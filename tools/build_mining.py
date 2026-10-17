"""Build CraftLadder/Data/Mining.lua and tools/MiningReport.md.

Mining levels from the nodes you mine (one chance at a skill point per node) and from smelting their ore. Sources:
  - GatherMate2_Data (the installed addon's Forever data): where each kind of node has been seen, by
    map. Counted per zone, these say which zones have the most nodes of each kind.
  - wago.tools (the Forever client's tables, newest build): the skill each node needs (Lock), the smelting recipes,
    their colours, reagents and bars (SkillLineAbility, SpellReagents, SpellEffect), zone names and sizes (UiMap,
    UiMapAssignment).
  - CMaNGOS classic-db (pinned like build_fishing.py, GPL-3.0): which lock and loot each node has, how often it can
    be mined, how often rare veins (silver, gold, truesilver) take the place of common ones, and trainer fees.
Node colours follow Classic's rule: yellow 25 above the skill a node needs, green 50, grey 100. Zone sides and levels
are build_fishing.py's (Classic facts), plus the three mining zones it lacks.

    python -I tools/build_mining.py [--refresh]
"""
import argparse
import datetime
import math
import re
import sys
from collections import defaultdict
from pathlib import Path

TOOLS = Path(__file__).resolve().parent
ROOT = TOOLS.parent
sys.path.insert(0, str(TOOLS))
import seen_in_game  # noqa: E402
import wago  # noqa: E402
from build_data import lua, money  # noqa: E402
from build_fishing import ZONES, classicdb  # noqa: E402

OUT_LUA = ROOT / "CraftLadder" / "Data" / "Mining.lua"
OUT_REPORT = TOOLS / "MiningReport.md"
ADDONS = Path(r"D:\Games\World of Warcraft\_classic_beta_\Interface\AddOns")
GM2_NODES = ADDONS / "GatherMate2_Data" / "Forever" / "MiningData.lua"
GM2_CONSTANTS = ADDONS / "GatherMate2" / "Constants.lua"

MINING = 186
LOCK_MINING = "3"  # Lock's index for a mining lock (its type 2 = a lock type)
EXTRA_ZONES = {3: ("C", 35, 45), 4: ("C", 45, 55), 51: ("C", 43, 50)}  # Badlands, Blasted Lands, Searing Gorge
MIN_PLACES = 10  # zones where fewer nodes were seen are left out (a capital's odd copper vein)
SPOT = 0.005  # GatherMate2 places this close (a share of the map's width) are one spawn spot
NEAR = 0.01  # a gather recorded in game counts on the nearest spot this close (the player stands by the node)
MIN_GATHERED = 50  # gathers on shared spots before the shares measured in game replace CMaNGOS's
PRIOR_PSEUDO = 5  # CMaNGOS's shares count as this many gathers on each spot mix
RANK_TEACH = {2581: 0, 2582: 1, 3568: 2, 10249: 3}  # CMaNGOS trainer spells that teach the ranks below
RANKS = [
    {"name": "Apprentice", "cap": 75, "learnAt": 0, "how": "trainer", "spell": 2575},
    {"name": "Journeyman", "cap": 150, "learnAt": 50, "how": "trainer", "spell": 2576, "charLevel": 10},
    {"name": "Expert", "cap": 225, "learnAt": 125, "how": "trainer", "spell": 3564, "charLevel": 20},
    {"name": "Artisan", "cap": 300, "learnAt": 200, "how": "trainer", "spell": 10248, "charLevel": 35},
]
# CMaNGOS trainer spell -> the smelting recipe it teaches
TEACH = {3313: 3304, 3314: 2659, 3315: 3308, 3316: 3307, 3317: 2658, 3596: 3569, 10099: 10097, 10100: 10098,
         16154: 16153}  # Smelt Steel (3569) gives no skill-ups, but Blacksmithing prices Steel Bars by it
START = {2657}  # Smelt Copper comes with Apprentice Mining
# The client lists these with yellow = grey (no skill-ups at all), which isn't how Classic played: Classic's colours
CLASSIC_COLORS = {10097: [175, 175, 202, 230], 10098: [230, 230, 235, 240], 16153: [250, 250, 270, 290]}
LEFT_OUT = {
    14891: "Smelt Dark Iron: only at the Black Forge in Blackrock Depths",
    22967: "Smelt Elementium: past 300",
    1213638: "Smelt Obsidian-Infused Thorium Bar: past 300",
    1306126: "Smelt Heavy Thorium: from 300 (Forever), ore source unknown",
    1249637: "Smelt Azerothium (Forever): nothing says how it's learned or where its ore is",
}


def gm2_ids(section="Mining", first=201, last=220):
    """{node name: GatherMate2 id} for Classic's nodes of a kind (mining: ids 201-220)."""
    out, inside = {}, False
    for line in GM2_CONSTANTS.read_text(encoding="utf-8").splitlines():
        if re.match(r'\s*\["%s"\] = \{' % section, line):
            inside = True
        elif inside:
            m = re.match(r'\s*\["([^"]+)"\]\s*=\s*(\d+),', line)
            if m and first <= int(m.group(2)) <= last:
                out[m.group(1)] = int(m.group(2))
            if line.strip().startswith("}"):
                break
    return out


def gm2_places(path=GM2_NODES):
    """{ui map: {node id: places seen}} from GatherMate2_Data."""
    out, current = defaultdict(lambda: defaultdict(int)), None
    for line in path.read_text(encoding="utf-8").splitlines():
        m = re.match(r"\s*\[(\d+)\] = \{", line)
        if m:
            current = int(m.group(1))
            continue
        m = re.match(r"\s*\[\d+\] = (\d+),", line)
        if m and current:
            out[current][int(m.group(1))] += 1
    return out


def rarity(pool_rows, names):
    """How often each kind of node is the one there, where it can spawn, by zone: {(zone, node name): share} and
    the same over all zones {node name: share}. CMaNGOS pools the kinds that share a place (a chance of 0 is an equal
    share of what the others leave) and names the zone in the pool's description ("Gold Vein - Badlands - ..."); a
    pool of one kind picks places, not kinds, and says nothing here. Also returns the zones with any mining pool."""
    pools, zones = defaultdict(list), set()
    for r in pool_rows:
        parts = [p.strip() for p in r["description"].split(" - ")]
        if parts[0] in names and len(parts) > 1:
            zone = re.sub(r"\s*\(.*\)", "", parts[1]).replace("Stranglehorn", "Stranglethorn")  # CMaNGOS's typo
            pools[r["pool_entry"]].append((parts[0], zone, float(r["chance"])))
            zones.add(zone)
    total, seen = defaultdict(float), defaultdict(int)
    for members in pools.values():
        if len({n for n, _, _ in members}) < 2:
            continue
        fixed = sum(c for _, _, c in members)
        zero = sum(1 for _, _, c in members if c == 0)
        shares = defaultdict(float)
        for name, zone, chance in members:
            shares[(zone, name)] += (chance if chance else max(0.0, 100 - fixed) / zero) / 100
        for key, s in shares.items():
            for k in (key, key[1]):
                total[k] += s
                seen[k] += 1
    return {k: total[k] / seen[k] for k in total}, zones


def gm2_spots(path=GM2_NODES):
    """{ui map: [[x, y, {node ids seen there}]]}: GatherMate2's places joined into spawn spots. Kinds that share a
    spot (a Silver Vein where an Iron Deposit stands at other times) are seen on the same place, and one node is
    sometimes kept twice a step apart; places within SPOT of each other (a share of the map) are one spot."""
    raw, current = defaultdict(list), None
    for line in path.read_text(encoding="utf-8").splitlines():
        m = re.match(r"\s*\[(\d+)\] = \{", line)
        if m:
            current = int(m.group(1))
            continue
        m = re.match(r"\s*\[(\d+)\] = (\d+),", line)
        if m and current:
            c = int(m.group(1))  # GatherMate2's coordinate: x and y times 10000, then 2 digits of its own
            raw[current].append((c // 1000000 / 10000, (c % 1000000) // 100 / 10000, int(m.group(2))))
    out = {}
    for ui_map, pts in raw.items():
        grid = defaultdict(list)  # cells as wide as SPOT: a place's neighbours are in the 9 cells around it
        for i, (x, y, _) in enumerate(pts):
            grid[(int(x / SPOT), int(y / SPOT))].append(i)
        parent = list(range(len(pts)))

        def root(i):
            while parent[i] != i:
                parent[i] = parent[parent[i]]
                i = parent[i]
            return i
        for (cx, cy), members in grid.items():
            for i in members:
                for dx in (-1, 0, 1):
                    for dy in (-1, 0, 1):
                        for j in grid.get((cx + dx, cy + dy), ()):
                            if j > i and math.dist(pts[i][:2], pts[j][:2]) <= SPOT:
                                parent[root(i)] = root(j)
        spots = defaultdict(list)
        for i, p in enumerate(pts):
            spots[root(i)].append(p)
        out[ui_map] = [[sum(p[0] for p in s) / len(s), sum(p[1] for p in s) / len(s), {p[2] for p in s}]
                       for s in spots.values()]
    return out


def spot_counts(spots, weight):
    """{node id: nodes standing in the zone at a time, per spot up}: each spot is one node, shared by the kinds seen
    there by their weights (weight(node id))."""
    counts = defaultdict(float)
    for _, _, kinds in spots:
        w = {k: weight(k) for k in kinds}
        total = sum(w.values())
        for k, x in w.items():
            counts[k] += x / total
    return {k: round(v, 1) for k, v in sorted(counts.items())}


def measured_weights(observed, prior):
    """Weights of the node kinds from what was gathered on shared spots: observed = [(kinds at the spot, the kind
    gathered)], prior = {kind: weight} (CMaNGOS). The chance of a kind at a spot is its weight over the weights of the
    kinds there (Luce's choice model), fitted by minorize-maximize; each spot mix also gets PRIOR_PSEUDO observations
    shared by the prior, so a few gathers move the weights only a little. Returns ({kind: weight}, {kind: gathered})."""
    n = defaultdict(float)  # (spot mix, kind) -> observations, real and pseudo
    real = defaultdict(int)
    for kinds, k in observed:
        n[(frozenset(kinds), k)] += 1
        real[k] += 1
    for mix in {m for m, _ in n}:
        total = sum(prior[k] for k in mix)
        for k in mix:
            n[(mix, k)] += PRIOR_PSEUDO * prior[k] / total
    mixes = defaultdict(float)
    for (mix, _), c in n.items():
        mixes[mix] += c
    kinds = {k for m in mixes for k in m}
    w = {k: prior[k] for k in kinds}
    for _ in range(200):
        for k in kinds:
            got = sum(c for (m, j), c in n.items() if j == k)
            w[k] = got / sum(c / sum(w[j] for j in m) for m, c in mixes.items() if k in m)
    scale = sum(prior[k] for k in kinds) / sum(w.values())  # the prior's scale, so unmeasured kinds stay comparable
    return {k: v * scale for k, v in w.items()}, dict(real)


def measured_check():
    """Self-check: gathers drawn with Silver 20% beside Tin, 50% beside Gold give those shares back."""
    obs = [({"tin", "silver"}, "silver")] * 200 + [({"tin", "silver"}, "tin")] * 800 + \
          [({"silver", "gold"}, "silver")] * 100 + [({"silver", "gold"}, "gold")] * 100
    w, _ = measured_weights(obs, {"tin": 1.0, "silver": 1.0, "gold": 1.0})
    assert abs(w["silver"] / (w["silver"] + w["tin"]) - 0.2) < 0.02, w
    assert abs(w["silver"] / (w["silver"] + w["gold"]) - 0.5) < 0.04, w


def gathered(prof, spots, node_of):
    """What was gathered on shared spots (tools/seen_in_game.json: the game's gatherLog): [(kinds at the spot, the
    kind gathered)]. A gather is on the nearest spot of its map within NEAR; the kind it found there counts as seen."""
    out = []
    for line in seen_in_game.gather():
        key, entry, ui_map, x, y = line.split()[:5]
        k = node_of.get(int(entry))
        if key != prof or k is None or int(ui_map) not in spots:
            continue
        best = min(spots[int(ui_map)], key=lambda s: math.dist(s[:2], (float(x), float(y))))
        if math.dist(best[:2], (float(x), float(y))) <= NEAR:
            kinds = best[2] | {k}
            if len(kinds) > 1:
                out.append((kinds, k))
    return out


def zone_weights(prof, spots, node_of, name_of, share, report):
    """weight(zone name, node id) for spot_counts: what the gathers measured once there are MIN_GATHERED of them on
    shared spots, else CMaNGOS's share in that zone (or over all zones). name_of = {node id: name} of every kind."""
    measured_check()
    prior = {k: share.get(n, 1.0) for k, n in name_of.items()}
    observed = gathered(prof, spots, node_of)
    if len(observed) >= MIN_GATHERED:
        w, real = measured_weights(observed, prior)
        report.append("- Shares measured in game from %d gathers on shared spots (weight, gathers): %s." % (
            len(observed), ", ".join("%s %.2f (%d)" % (name_of[k], v, real.get(k, 0)) for k, v in sorted(w.items()))))
        return lambda zone, k: w.get(k, prior[k])
    report.append("- Shares: CMaNGOS's (%d gathers on shared spots recorded in game; measured from %d)." % (
        len(observed), MIN_GATHERED))
    return lambda zone, k: share.get((zone, name_of[k]), prior[k])


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--refresh", action="store_true", help="download the client tables again")
    args = ap.parse_args()

    build = wago.latest_build()
    db = classicdb(False)
    loot = db["gameobject_loot_template"]
    locks = {r["ID"]: r for r in wago.table("Lock", build, args.refresh)}
    ids = gm2_ids()
    items, report = {}, []

    def item_name(i):
        if i not in items:
            items[i] = db["items"].get(i, {}).get("name") or ("item %d" % i)
        return items[i]

    # nodes: the skill they need (the Forever client's Lock), what one gives: ore, stone, gems (CMaNGOS: loot of each
    # time it's mined times how many times it can be, averaged over the node's templates; items of a loot group are
    # one of them per roll, a chance of 0 an equal share of what the others leave)
    nodes, loot_sums, templates = {}, defaultdict(lambda: defaultdict(float)), defaultdict(int)
    node_of = {}  # a node's object entry -> its kind (what the game's gatherLog records)
    for entry, r in db["objects"].items():
        node = ids.get(r["name"])
        if not node or r["type"] != "3":
            continue
        node_of[entry] = node
        lock = locks.get(r["data0"])
        skill = None
        for i in range(8):
            if lock and lock["Type_%d" % i] == "2" and lock["_Index_%d" % i] == LOCK_MINING:
                skill = int(lock["Skill_%d" % i])
        if skill is None:
            report.append("- %s (%d): no mining lock in the client's tables, left out" % (r["name"], entry))
            continue
        opens = (int(r["data4"]) + int(r["data5"])) / 2 if int(r["data5"]) else 1
        rows = [x for x in loot.get(int(r["data1"]), []) if x[1] > 0 and x[3] > 0]  # no quest items, references
        fixed = defaultdict(float)
        for _, chance, group, _, _ in rows:
            fixed[group] += chance
        zero = defaultdict(int)
        for _, chance, group, _, _ in rows:
            zero[group] += chance == 0
        for item, chance, group, mincount, maxcount in rows:
            share = chance if chance or group == 0 else max(0.0, 100 - fixed[group]) / zero[group]
            loot_sums[node][item] += share / 100 * (mincount + maxcount) / 2 * opens
        templates[node] += 1
        base = 0 if skill == 1 else skill  # Copper's 1 counts as 0: yellow 25, green 50, grey 100
        nodes[node] = {"name": r["name"], "skill": skill, "colors": [skill, base + 25, base + 50, base + 100]}
    for node, got in loot_sums.items():
        per = {i: round(n / templates[node], 3) for i, n in got.items() if n / templates[node] >= 0.005}
        nodes[node]["loot"] = dict(sorted(per.items(), key=lambda kv: -kv[1]))
        nodes[node]["ore"] = {i: n for i, n in per.items() if item_name(i).endswith(" Ore")}
        nodes[node]["item"] = max(nodes[node]["ore"], key=nodes[node]["ore"].get)
    share, _ = rarity(db["pool_gameobject"], set(ids))
    for node in nodes.values():
        node["share"] = round(share.get(node["name"], 1.0), 3)

    # zones: GatherMate2's places joined into spawn spots, each shared by the kinds seen there (CMaNGOS's shares, or
    # the game's once measured); the zone's size in km²
    names = {int(r["ID"]): r["Name_lang"] for r in wago.table("UiMap", build, args.refresh)}
    sizes, area_of = {}, {}
    for r in wago.table("UiMapAssignment", build, args.refresh):
        if r["OrderIndex"] == "0" and int(r["UiMapID"]) not in sizes:
            dx = float(r["Region_3"]) - float(r["Region_0"])
            dy = float(r["Region_4"]) - float(r["Region_1"])
            sizes[int(r["UiMapID"])] = dx * dy * 0.9144 ** 2 / 1e6
            area_of[int(r["UiMapID"])] = int(r["AreaID"])
    sides = {**ZONES, **EXTRA_ZONES}
    zones, spots = {}, gm2_spots()
    weight = zone_weights("mining", spots, node_of, {v: k for k, v in ids.items()}, share, report)
    for ui_map, seen in sorted(gm2_places().items()):
        name = names.get(ui_map, "map %d" % ui_map)
        if sum(seen.values()) < MIN_PLACES:
            report.append("- %s: only %d node places seen, left out" % (name, sum(seen.values())))
            continue
        side = sides.get(area_of.get(ui_map))
        if not side:
            report.append("- %s: no side or levels known, left out" % name)
            continue
        counts = spot_counts(spots[ui_map], lambda k, zone=name: weight(zone, k))
        zones[ui_map] = {"name": name, "map": ui_map, "faction": side[0], "levels": [side[1], side[2]],
                         "size": round(sizes[ui_map], 2), "nodes": {k: v for k, v in counts.items() if k in nodes},
                         "seen": dict(sorted(seen.items())), "spots": len(spots[ui_map])}

    # smelting: the Forever client's recipes; fees and skills from CMaNGOS's trainers
    spell_names = {int(r["ID"]): r["Name_lang"] for r in wago.table("SpellName", build, args.refresh)}
    reagents = {int(r["SpellID"]): r for r in wago.table("SpellReagents", build, args.refresh)}
    makes = {}
    for r in wago.table("SpellEffect", build, args.refresh):
        if r["Effect"] == "24" and int(r["EffectItemType"] or 0):
            makes[int(r["SpellID"])] = (int(r["EffectItemType"]), int(float(r["EffectBasePointsF"] or 1)))
    fees, rank_fees = {}, {}
    for r in db["npc_trainer"]:
        teach = int(r["spell"])
        if teach in TEACH:
            fees[TEACH[teach]] = (int(r["spellcost"]), int(r["reqskillvalue"]))
        if teach in RANK_TEACH:
            rank_fees[RANK_TEACH[teach]] = int(r["spellcost"])
    recipes = {}
    for r in wago.table("SkillLineAbility", build, args.refresh):
        spell = int(r["Spell"])
        if int(r["SkillLine"]) != MINING or spell not in makes or spell not in reagents:
            continue
        name = spell_names.get(spell, "spell %d" % spell)
        if spell in LEFT_OUT:
            report.append("- %s" % LEFT_OUT[spell])
            continue
        if spell not in START and spell not in fees:
            report.append("- %s: no trainer teaches it, left out" % name)
            continue
        cost, learn = fees.get(spell, (0, 1))
        yellow, grey = int(r["TrivialSkillLineRankLow"]), int(r["TrivialSkillLineRankHigh"])
        colors = CLASSIC_COLORS.get(spell) or [learn, yellow, (yellow + grey) // 2, grey]
        mats = {}
        for i in range(8):
            if int(reagents[spell]["Reagent_%d" % i]):
                mats[int(reagents[spell]["Reagent_%d" % i])] = int(reagents[spell]["ReagentCount_%d" % i])
        item, count = makes[spell]
        for i in list(mats) + [item]:
            item_name(i)
        rec = {"name": name, "learn": learn, "colors": colors, "mats": mats, "makes": item, "count": count,
               "get": [{"kind": "start"}] if spell in START else [{"kind": "trainer", "cost": cost}]}
        if spell in CLASSIC_COLORS:
            rec["data"] = "classic"
        recipes[spell] = rec

    ranks = []
    for i, rank in enumerate(RANKS):
        ranks.append(dict(rank, cost=rank_fees.get(i)))
    # what a vendor pays for what nodes give and for bars (the client's item table, else Classic's)
    prices = wago.item_prices(build, args.refresh)
    sell = {}
    for i in {i for n in nodes.values() for i in n["loot"]} | {r["makes"] for r in recipes.values()}:
        item_name(i)
        v = prices[i][1] if i in prices else int(db["items"].get(i, {}).get("SellPrice") or 0)
        if v > 0:
            sell[i] = v

    data = {"built": datetime.date.today().isoformat(), "build": build, "ranks": ranks, "nodes": nodes,
            "zones": zones, "recipes": recipes, "sell": sell, "items": items}
    write_lua(data)
    write_report(data, report)
    print("Mining.lua: %d nodes, %d zones, %d smelting recipes, Forever build %s" % (len(nodes), len(zones),
                                                                                  len(recipes), build))


def write_lua(d):
    lines = [
        "-- Craft Ladder: Mining data for WoW Forever.",
        "-- GENERATED by tools/build_mining.py on %s - don't edit by hand; fix the builder and rebuild." % d["built"],
        "-- nodes (GatherMate2's ids): skill = what the node needs (the client's Lock table), colors = Classic's rule from",
        "-- it, loot = what one node gives on average (ore = its ore), share = how often this kind is the one at a place it can spawn",
        "-- (CMaNGOS classic-db). zones (ui maps): nodes = GatherMate2_Data's places joined into spawn spots, each shared by the",
        "-- kinds seen there (spots = how many); seen = places seen;",
        "-- size in km²; faction A, H or C (contested), levels = its mobs. recipes: smelting, from the client's tables",
        "-- (build %s); trainer fees from CMaNGOS; data = \"classic\" for colours from Classic. sell = vendor price." % d["build"],
        "local _, ns = ...",
        "",
        "ns.MINING = {",
        "  built = %s," % lua(d["built"]),
        "  ranks = {",
    ]
    for r in d["ranks"]:
        lines.append("    %s," % lua(r))
    lines.append("  },")
    for name in ("nodes", "zones", "recipes", "sell", "items"):
        lines.append("  %s = {" % name)
        for k, v in sorted(d[name].items()):
            lines.append("    [%d] = %s," % (k, lua(v)))
        lines.append("  },")
    lines.append("  npcs = {}, quests = {}, vendorPrices = {},")
    lines.append("}")
    OUT_LUA.write_text("\n".join(lines) + "\n", encoding="utf-8")


def write_report(d, notes):
    out = ["# Mining data report", "",
           "Built %s by `tools/build_mining.py`. %d zones, %d kinds of node, %d smelting recipes; Forever build %s." % (
               d["built"], len(d["zones"]), len(d["nodes"]), len(d["recipes"]), d["build"]), "", "## Ranks", ""]
    for r in d["ranks"]:
        out.append("- %s (cap %d): at %d%s, trainer, %s" % (r["name"], r["cap"], r["learnAt"],
                   (", level %d" % r["charLevel"]) if r.get("charLevel") else "", money(r.get("cost"))))
    out += ["", "## Nodes", "", "| Node | Skill | Yellow / green / grey | Ore per node | Share where it spawns |",
            "|---|---|---|---|---|"]
    for n in sorted(d["nodes"].values(), key=lambda n: (n["skill"], n["name"])):
        ore = ", ".join("%s %.1f" % (d["items"][i], c) for i, c in n.get("ore", {}).items())
        out.append("| %s | %d | %d / %d / %d | %s | %d%% |" % (n["name"], n["skill"], n["colors"][1], n["colors"][2],
                                                             n["colors"][3], ore, round(n["share"] * 100)))
    out += ["", "## Zones", "", "| Zone | Side | Levels | km² | Nodes (spots shared by the kinds seen there) |", "|---|---|---|---|---|"]
    for z in sorted(d["zones"].values(), key=lambda z: (z["levels"][0], z["name"])):
        nodes = ", ".join("%s %g" % (d["nodes"][n]["name"], c) for n, c in sorted(z["nodes"].items()))
        out.append("| %s | %s | %d-%d | %.1f | %s |" % (z["name"], z["faction"], z["levels"][0], z["levels"][1],
                                                        z["size"], nodes))
    out += ["", "## Smelting", ""]
    for spell, r in sorted(d["recipes"].items(), key=lambda kv: kv[1]["learn"]):
        mats = ", ".join("%d %s" % (n, d["items"][i]) for i, n in r["mats"].items())
        how = "with Apprentice" if r["get"][0]["kind"] == "start" else "trainer " + money(r["get"][0]["cost"])
        out.append("- %s (%d): %s -> %d %s; colours %s%s; %s" % (r["name"], spell, mats, r["count"],
                   d["items"][r["makes"]], "/".join(map(str, r["colors"])),
                   " (Classic's)" if r.get("data") == "classic" else "", how))
    if notes:
        out += ["", "## Left out", ""] + notes
    OUT_REPORT.write_text("\n".join(out) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
