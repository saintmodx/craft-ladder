"""Build CraftLadder/Data/Herbalism.lua and tools/HerbalismReport.md.

Herbalism uses Mining's ladder (herbs are nodes, without smelting). Sources, as tools/build_mining.py's:
  - GatherMate2_Data (installed; no license): where herbs are in Forever, by zone (its herb ids
    401-431);
  - the Forever client's tables (wago.tools): the skill a herb needs (Lock), zone names and sizes, vendor prices;
  - CMaNGOS classic-db (pinned as in build_fishing.py, GPL-3.0): what picking a herb gives, how often a kind is the
    one at a place it can spawn (pools), and the trainers' ranks.
Colours as Mining's: yellow 25, green 50, grey 100 above what a herb needs.

    python -I tools/build_herbalism.py
"""
import datetime
import sys
from collections import defaultdict
from pathlib import Path

TOOLS = Path(__file__).resolve().parent
ROOT = TOOLS.parent
sys.path.insert(0, str(TOOLS))
import wago  # noqa: E402
from build_data import lua, money  # noqa: E402
from build_fishing import ZONES, classicdb  # noqa: E402
from build_mining import (ADDONS, EXTRA_ZONES, MIN_PLACES, gm2_ids, gm2_places, gm2_spots, rarity,  # noqa: E402
                          spot_counts, zone_weights)

OUT_LUA = ROOT / "CraftLadder" / "Data" / "Herbalism.lua"
OUT_REPORT = TOOLS / "HerbalismReport.md"
GM2_HERBS = ADDONS / "GatherMate2_Data" / "Forever" / "HerbalismData.lua"
ERA_BUILD = "1.15.9.70003"  # the Classic Era client whose SpellEffect still has Classic's teaching spells
LOCK_HERBALISM = "2"  # Lock's index for a herbalism lock (its type 2 = a lock type)
RANKS = [
    {"name": "Apprentice", "cap": 75, "spell": 2366},
    {"name": "Journeyman", "cap": 150, "spell": 2368, "charLevel": 10},
    {"name": "Expert", "cap": 225, "spell": 3570, "charLevel": 20},
    {"name": "Artisan", "cap": 300, "spell": 11993, "charLevel": 35},
]


def main():
    build = wago.latest_build()
    db = classicdb(False)
    loot = db["gameobject_loot_template"]
    locks = {r["ID"]: r for r in wago.table("Lock", build)}
    ids = gm2_ids("Herb Gathering", 401, 431)
    items, report = {}, []

    def item_name(i):
        if i not in items:
            items[i] = db["items"].get(i, {}).get("name") or ("item %d" % i)
        return items[i]

    # herbs: the skill they need (the Forever client's Lock), what picking one gives (CMaNGOS: averaged over the
    # kind's templates; items of a loot group are one of them per roll, a chance of 0 an equal share of what's left)
    def expect(rows, depth=0):
        """{item: how many one roll of these loot rows gives on average}; a row that points to a reference template
        (mincountOrRef < 0) rolls that one maxcount times at its chance (the herb itself, for the rarer herbs)."""
        got = defaultdict(float)
        rows = [x for x in rows if x[1] > 0 or x[3] < 0 or x[2] > 0]  # quest items (chance < 0) left out
        fixed, zero = defaultdict(float), defaultdict(int)
        for _, chance, group, _, _ in rows:
            fixed[group] += max(chance, 0)
            zero[group] += chance == 0
        for item, chance, group, mincount, maxcount in rows:
            share = chance if chance or group == 0 else max(0.0, 100 - fixed[group]) / zero[group]
            if mincount < 0:
                if depth < 3:
                    for i, n in expect(db["reference_loot_template"].get(-mincount, []), depth + 1).items():
                        got[i] += share / 100 * maxcount * n
            else:
                got[item] += share / 100 * (mincount + maxcount) / 2
        return got

    nodes, loot_sums, templates = {}, defaultdict(lambda: defaultdict(float)), defaultdict(int)
    node_of = {}  # a herb's object entry -> its kind (what the game's gatherLog records)
    for entry, r in db["objects"].items():
        node = ids.get(r["name"])
        if not node or r["type"] != "3":
            continue
        node_of[entry] = node
        lock = locks.get(r["data0"])
        skill = None
        for i in range(8):
            if lock and lock["Type_%d" % i] == "2" and lock["_Index_%d" % i] == LOCK_HERBALISM:
                skill = int(lock["Skill_%d" % i])
        if skill is None:
            report.append("- %s (%d): no herbalism lock in the client's tables, left out" % (r["name"], entry))
            continue
        opens = (int(r["data4"]) + int(r["data5"])) / 2 if int(r["data5"]) else 1
        for item, n in expect(loot.get(int(r["data1"]), [])).items():
            loot_sums[node][item] += n * opens
        templates[node] += 1
        base = 0 if skill == 1 else skill  # a skill of 1 counts as 0: yellow 25, green 50, grey 100
        nodes[node] = {"name": r["name"], "skill": skill, "colors": [skill, base + 25, base + 50, base + 100], "ore": {}}
    for node, got in loot_sums.items():
        per = {i: round(n / templates[node], 3) for i, n in got.items() if n / templates[node] >= 0.005}
        nodes[node]["loot"] = dict(sorted(per.items(), key=lambda kv: -kv[1]))
        own = [i for i in per if item_name(i) == nodes[node]["name"]]  # its own herb, else what it gives most
        nodes[node]["item"] = own[0] if own else next(iter(nodes[node]["loot"]))
        for i in per:
            item_name(i)
    nodes = {n: v for n, v in nodes.items() if v.get("loot")}
    share, _ = rarity(db["pool_gameobject"], set(ids))
    for node in nodes.values():
        node["share"] = round(share.get(node["name"], 1.0), 3)

    # zones: GatherMate2's places joined into spawn spots, each shared by the herbs seen there (CMaNGOS's shares, or
    # the game's once measured); the zone's size in km²
    names = {int(r["ID"]): r["Name_lang"] for r in wago.table("UiMap", build)}
    sizes, area_of = {}, {}
    for r in wago.table("UiMapAssignment", build):
        if r["OrderIndex"] == "0" and int(r["UiMapID"]) not in sizes:
            dx = float(r["Region_3"]) - float(r["Region_0"])
            dy = float(r["Region_4"]) - float(r["Region_1"])
            sizes[int(r["UiMapID"])] = dx * dy * 0.9144 ** 2 / 1e6
            area_of[int(r["UiMapID"])] = int(r["AreaID"])
    sides = {**ZONES, **EXTRA_ZONES}
    zones, spots = {}, gm2_spots(GM2_HERBS)
    weight = zone_weights("herbalism", spots, node_of, {v: k for k, v in ids.items()}, share, report)
    for ui_map, seen in sorted(gm2_places(GM2_HERBS).items()):
        name = names.get(ui_map, "map %d" % ui_map)
        if sum(seen.values()) < MIN_PLACES:
            report.append("- %s: only %d herb places seen, left out" % (name, sum(seen.values())))
            continue
        side = sides.get(area_of.get(ui_map))
        if not side:
            report.append("- %s: no side or levels known, left out" % name)
            continue
        counts = spot_counts(spots[ui_map], lambda k, zone=name: weight(zone, k))
        zones[ui_map] = {"name": name, "map": ui_map, "faction": side[0], "levels": [side[1], side[2]],
                         "size": round(sizes[ui_map], 2), "nodes": {k: v for k, v in counts.items() if k in nodes},
                         "seen": dict(sorted(seen.items())), "spots": len(spots[ui_map])}

    # ranks: trainer fees and skills (CMaNGOS, its teaching spells read through the Classic Era client)
    era_teaches = {int(r["SpellID"]): int(r["EffectTriggerSpell"]) for r in wago.table("SpellEffect", ERA_BUILD)
                   if r["Effect"] == "36" and int(r["EffectTriggerSpell"] or 0)}
    rank_spells = {r["spell"] for r in RANKS}
    trained = {}
    for table in ("npc_trainer", "npc_trainer_template"):
        for r in db[table]:
            spell = era_teaches.get(int(r["spell"]), int(r["spell"]))
            if spell in rank_spells:
                trained[spell] = (int(r["spellcost"]), int(r["reqskillvalue"]))
    ranks = []
    for rank in RANKS:
        fee, skill = trained.get(rank["spell"], (None, 0))
        r = dict(rank, how="trainer", cost=fee, learnAt=0 if rank["name"] == "Apprentice" else skill)
        ranks.append({k: v for k, v in r.items() if v is not None})
    ranks[1]["learnAt"] = ranks[1].get("learnAt") or 50

    prices = wago.item_prices(build)
    sell = {}
    for i in items:
        v = prices[i][1] if i in prices else int(db["items"].get(i, {}).get("SellPrice") or 0)
        if v > 0:
            sell[i] = v

    data = {"built": datetime.date.today().isoformat(), "build": build, "ranks": ranks, "nodes": nodes,
            "zones": zones, "sell": sell, "items": items}
    write_lua(data)
    write_report(data, report)
    print("Herbalism.lua: %d herbs, %d zones, Forever build %s" % (len(nodes), len(zones), build))


def write_lua(d):
    lines = [
        "-- Craft Ladder: Herbalism data for WoW Forever.",
        "-- GENERATED by tools/build_herbalism.py on %s - don't edit by hand; fix the builder and rebuild." % d["built"],
        "-- Mining's ladder picks herbs as it mines nodes (no smelting). nodes (GatherMate2's ids): skill = what the herb",
        "-- needs (the client's Lock table), colors = Classic's rule from it, loot = what picking one gives on average,",
        "-- share = how often this kind is the one at a place it can spawn (CMaNGOS classic-db). zones (ui maps): nodes =",
        "-- GatherMate2_Data's places joined into spawn spots, each shared by the herbs seen there (spots = how many); size in km²; faction A, H or C; levels = its creatures (build %s)." % d["build"],
        "local _, ns = ...",
        "",
        "ns.HERBALISM = {",
        "  built = %s," % lua(d["built"]),
        "  ranks = {",
    ]
    for r in d["ranks"]:
        lines.append("    %s," % lua(r))
    lines.append("  },")
    for name in ("nodes", "zones", "sell", "items"):
        lines.append("  %s = {" % name)
        for k, v in sorted(d[name].items()):
            lines.append("    [%d] = %s," % (k, lua(v)))
        lines.append("  },")
    lines.append("  recipes = {}, npcs = {}, quests = {}, vendorPrices = {},")
    lines.append("}")
    OUT_LUA.write_text("\n".join(lines) + "\n", encoding="utf-8")


def write_report(d, notes):
    nodes, items = d["nodes"], d["items"]
    out = ["# Herbalism data report", "",
           "Built %s by `tools/build_herbalism.py`. %d herbs, %d zones; Forever build %s." % (
               d["built"], len(nodes), len(d["zones"]), d["build"]), "", "## Ranks", ""]
    for r in d["ranks"]:
        out.append("- %s (cap %d): at %d%s, trainer %s" % (r["name"], r["cap"], r["learnAt"],
                   (", level %d" % r["charLevel"]) if r.get("charLevel") else "", money(r.get("cost"))))
    out += ["", "## Herbs", "", "| Herb | Skill | Colours | One gives | Share |", "|---|---|---|---|---|"]
    for n, h in sorted(nodes.items(), key=lambda kv: kv[1]["skill"]):
        out.append("| %s | %d | %s | %s | %.2f |" % (h["name"], h["skill"], "/".join(map(str, h["colors"])),
                   ", ".join("%.2f %s" % (q, items[i]) for i, q in h["loot"].items()), h["share"]))
    out += ["", "## Zones", "", "| Zone | Side | Levels | km² | Herbs (places) |", "|---|---|---|---|---|"]
    for m, z in sorted(d["zones"].items(), key=lambda kv: kv[1]["name"]):
        out.append("| %s | %s | %d-%d | %.1f | %s |" % (z["name"], z["faction"], z["levels"][0], z["levels"][1],
                   z["size"], ", ".join("%s %g" % (nodes[n]["name"], c) for n, c in z["nodes"].items())))
    out += ["", "## Guesses (to check against the real game; see ASSUMPTIONS.md)", "",
            "- Skill-up colours: Mining's (yellow 25, green 50, grey 100 above what a herb needs).",
            "- What picking a herb gives and how often a kind is the one at its place: Classic's (CMaNGOS)."]
    if notes:
        out += ["", "## Left out", ""] + notes
    OUT_REPORT.write_text("\n".join(out) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
