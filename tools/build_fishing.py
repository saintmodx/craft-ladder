"""Build CraftLadder/Data/Fishing.lua and tools/FishingReport.md.

Fishing has no recipes: what matters is where to fish. Sources:
  - CMaNGOS classic-db (github.com/cmangos/classic-db, GPL-3.0, pinned): each zone's base
    fishing skill (skill_fishing_base_level) and what fish it gives (fishing_loot_template, reference_loot_template).
    That is Classic's world data: Forever may differ, so the window says where it's an assumption.
  - QuestieDB (the installed addon's Forever data): item, NPC and quest names, NPC places, map ids, who sells the
    Expert book, and Nat Pagle's quest for Artisan.
  - wago.tools' ItemSparse (the client's item table, newest Forever build): what vendors ask for lures, poles and
    the Expert book.
Zone sides and levels, lure and pole bonuses are Classic facts written below.

    python -I tools/build_fishing.py [--refresh]
"""
import argparse
import datetime
import gzip
import re
import sys
import urllib.request
from collections import defaultdict
from pathlib import Path

TOOLS = Path(__file__).resolve().parent
ROOT = TOOLS.parent
sys.path.insert(0, str(TOOLS))
import wago  # noqa: E402
from build_data import lua, money  # noqa: E402
from questiedb import QuestieDB, zones  # noqa: E402

OUT_LUA = ROOT / "CraftLadder" / "Data" / "Fishing.lua"
OUT_REPORT = TOOLS / "FishingReport.md"
CLASSICDB_COMMIT = "22b51464f1625f6ef6275771de1f5466c6f5d19e"
CLASSICDB_URL = "https://raw.githubusercontent.com/cmangos/classic-db/%s/Full_DB/ClassicDB_1_12_1_z2815.sql.gz"
CLASSICDB = TOOLS / "cache" / ("classicdb-%s.sql.gz" % CLASSICDB_COMMIT[:7])
SUBZONES = Path(r"D:\Games\World of Warcraft\_classic_beta_\Interface\AddOns\QuestieDB\support\Forever\Zones"
                r"\subZoneToParentZone.lua")
UA = "CraftLadder-databuilder (personal use)"

# Zones worth fishing (dungeons and the like left out): side (A, H, or C = contested) and the levels of its mobs
ZONES = {
    1: ("A", 1, 10), 12: ("A", 1, 10), 141: ("A", 1, 10), 14: ("H", 1, 10), 85: ("H", 1, 10), 215: ("H", 1, 10),
    1519: ("A", 1, 60), 1537: ("A", 1, 60), 1657: ("A", 1, 60), 1497: ("H", 1, 60), 1637: ("H", 1, 60),
    1638: ("H", 1, 60),
    38: ("A", 10, 20), 40: ("A", 10, 20), 148: ("A", 10, 20), 17: ("H", 10, 25), 130: ("H", 10, 20),
    44: ("A", 15, 25), 10: ("A", 18, 30), 11: ("A", 20, 30), 406: ("C", 15, 27), 331: ("C", 18, 30),
    267: ("C", 20, 30), 400: ("C", 25, 35), 36: ("C", 30, 40), 45: ("C", 30, 40), 405: ("C", 30, 40),
    33: ("C", 30, 45), 8: ("C", 35, 45), 15: ("C", 35, 45), 47: ("C", 40, 50), 357: ("C", 40, 50),
    440: ("C", 40, 50), 16: ("C", 45, 55), 361: ("C", 48, 55), 490: ("C", 48, 55), 493: ("C", 48, 55),
    46: ("C", 50, 58), 28: ("C", 51, 58), 139: ("C", 53, 60), 618: ("C", 53, 60), 41: ("C", 55, 60),
    1377: ("C", 55, 60),
}
POLES = {6256: 0, 12225: 3, 6365: 5, 6366: 15, 6367: 20, 19022: 25, 19970: 35}  # fishing skill they add
LURES = {6529: 25, 6530: 50, 6532: 75, 7307: 75, 6533: 100}  # for 10 minutes
LURE_MINUTES = 10
RANKS = [  # Journeyman's and Artisan's fees: CMaNGOS npc_trainer; Apprentice's as Cooking's
    {"name": "Apprentice", "cap": 75, "learnAt": 0, "how": "trainer", "spell": 7620, "cost": 100},
    {"name": "Journeyman", "cap": 150, "learnAt": 50, "how": "trainer", "spell": 7731, "cost": 500},
    {"name": "Expert", "cap": 225, "learnAt": 125, "how": "book", "item": 16083},
    {"name": "Artisan", "cap": 300, "learnAt": 225, "how": "quest", "quest": 6607, "cost": 10000,
     "note": "Catch the four fish below and bring them to Nat Pagle; he then teaches Artisan Fishing for 1g."},
]
MIN_SHARE = 0.005  # fish rarer than 0.5% of catches are left out
POOL_SKIP = {180184, 180248, 180369, 184956}  # odd one, Stranglethorn's fishing contest, Zul'Gurub, Outland
TRUNK_TIERS = {"Tightly Sealed Trunk": 1, "Watertight Trunk": 2, "Iron Bound Trunk": 3, "Mithril Bound Trunk": 4}
GM2_POOLS = {  # GatherMate2's fishing node ids (its Constants.lua) -> pool names
    101: "Floating Wreckage", 102: "Patch of Elemental Water", 103: "Floating Debris", 104: "Oil Spill",
    105: "Firefin Snapper School", 106: "Greater Sagefish School", 107: "Oily Blackmouth School",
    108: "Sagefish School", 109: "School of Deviate Fish", 110: "Stonescale Eel Swarm",
}


def classicdb(refresh):
    if refresh or not CLASSICDB.exists():
        req = urllib.request.Request(CLASSICDB_URL % CLASSICDB_COMMIT, headers={"User-Agent": UA})
        with urllib.request.urlopen(req, timeout=600) as r:
            data = r.read()
        gzip.decompress(data)  # a broken download fails here, before it's kept
        CLASSICDB.parent.mkdir(parents=True, exist_ok=True)
        CLASSICDB.write_bytes(data)
    wanted = {name: [] for name in ("skill_fishing_base_level", "fishing_loot_template", "reference_loot_template",
                                    "gameobject_template", "gameobject_loot_template", "item_loot_template",
                                    "item_template", "pool_gameobject", "npc_trainer", "npc_trainer_template",
                                    "creature_template", "npc_vendor", "npc_vendor_template", "skinning_loot_template",
                                    "pickpocketing_loot_template", "quest_template")}
    columns, table = {}, None
    with gzip.open(CLASSICDB, "rt", encoding="utf-8", errors="replace") as f:
        for line in f:
            m = re.match(r"CREATE TABLE `(\w+)`", line)
            if m:
                table = m.group(1) if m.group(1) in wanted else None
                columns[table] = []
                continue
            if table and line.startswith("  `"):
                columns[table].append(line.split()[0].strip("`"))
            elif line.startswith(")"):
                table = None
            m = re.match(r"INSERT INTO `(\w+)`", line)
            if m and m.group(1) in wanted:
                wanted[m.group(1)].append(line)
    db = {"base": {int(a): int(s) for line in wanted["skill_fishing_base_level"]
                   for a, s in re.findall(r"\((-?\d+),(-?\d+)\)", line)}}
    loot_row = re.compile(r"\((\d+),(\d+),(-?[\d.]+),(\d+),(-?\d+),(\d+),(\d+),'")

    def rows(name):
        out = defaultdict(list)
        for line in wanted[name]:
            for e, item, chance, group, ref, maxcount, _ in loot_row.findall(line):
                out[int(e)].append((int(item), float(chance), int(group), int(ref), int(maxcount)))
        return out
    for name in ("fishing_loot_template", "reference_loot_template", "gameobject_loot_template", "item_loot_template",
                 "skinning_loot_template", "pickpocketing_loot_template"):
        db[name] = rows(name)

    def records(name):
        """Every row of a table as {column: value}, read by the column names of its own CREATE TABLE."""
        cols = columns[name]
        for line in wanted[name]:
            for values in sql_rows(line[line.index("VALUES") + 6:]):
                yield dict(zip(cols, values))
    db["objects"] = {int(r["entry"]): r for r in records("gameobject_template")}
    db["holes"] = {e: r for e, r in db["objects"].items() if r["type"] == "25"}
    db["items"] = {int(r["entry"]): r for r in records("item_template")}
    db["pool_gameobject"] = list(records("pool_gameobject"))
    db["npc_trainer"] = list(records("npc_trainer"))
    db["npc_trainer_template"] = list(records("npc_trainer_template"))
    db["creatures"] = {int(r["Entry"]): r for r in records("creature_template")}
    db["trainer_template_of"] = {e: int(r["TrainerTemplateId"]) for e, r in db["creatures"].items()
                                 if r["TrainerTemplateId"] not in ("0", "")}
    # item -> True when some vendor always has it, False when every vendor has only a few at a time (maxcount)
    db["vendor_stock"] = {}
    for name in ("npc_vendor", "npc_vendor_template"):
        for r in records(name):
            item = int(r["item"])
            db["vendor_stock"][item] = db["vendor_stock"].get(item, False) or r["maxcount"] == "0"
    # spell -> the quests that teach or cast it as a reward (a quest that teaches a recipe with no plan to it)
    db["quest_spells"] = defaultdict(list)
    for r in records("quest_template"):
        for k in ("RewSpell", "RewSpellCast"):
            if r[k] not in ("0", ""):
                db["quest_spells"][int(r[k])].append(int(r["entry"]))
    return db


def sql_rows(text):
    """The rows of an INSERT's VALUES part: lists of strings (quotes removed, escapes undone)."""
    rows, row, value, i, quoted = [], [], [], 0, False
    while i < len(text):
        c = text[i]
        if quoted:
            if c == "\\":
                value.append(text[i + 1])
                i += 1
            elif c == "'":
                quoted = False
            else:
                value.append(c)
        elif c == "'":
            quoted = True
        elif c == "(":
            row, value = [], []
        elif c == ",":
            if row is not None:
                row.append("".join(value).strip())
            value = []
        elif c == ")":
            row.append("".join(value).strip())
            rows.append(row)
            row, value = None, []
        elif row is not None:
            value.append(c)
        i += 1
    return rows


def shares(entry, table, refs, group=None, scale=1.0, out=None):
    """{item: fish of it per catch} for one loot entry. Items sharing a group give one of them per roll, a chance of
    0 being an equal share of what the others leave; ungrouped items roll on their own; a reference rolls the group
    of the referenced loot its own group names (0 = all of it). Quest-only items (negative chance) are skipped."""
    out = defaultdict(float) if out is None else out
    grouped = defaultdict(list)
    for item, chance, g, ref, maxcount in table.get(entry, []):
        if group is not None and group != 0 and g != group:
            continue
        if ref < 0:
            shares(-ref, refs, refs, g, scale * chance / 100 * maxcount, out)
        elif chance < 0:
            continue
        elif g == 0:
            out[item] += scale * chance / 100
        else:
            grouped[g].append((item, chance))
    for items in grouped.values():
        fixed = sum(c for _, c in items)
        zero = [i for i, c in items if c == 0]
        for item, chance in items:
            share = chance if chance else max(0.0, 100 - fixed) / len(zero)
            out[item] += scale * share / 100
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--refresh", action="store_true", help="download the CMaNGOS dump and the item table again")
    args = ap.parse_args()

    db = classicdb(args.refresh)
    base, fishing, refs = db["base"], db["fishing_loot_template"], db["reference_loot_template"]
    qdb = QuestieDB()
    areas = zones()
    subzones = {}
    for m in re.finditer(r"\[(\d+)\] = (\d+), -- (.+?) -> (.+)", SUBZONES.read_text(encoding="utf-8")):
        subzones[int(m.group(1))] = (int(m.group(2)), m.group(3).strip())
    items, npcs, quests = {}, {}, {}
    build = wago.latest_build()
    prices = wago.item_prices(build, args.refresh)  # {item: (vendor buy per unit, vendor sell)}

    def item_name(i):
        if i not in items:
            items[i] = qdb.item(i).get(1) or db["items"].get(i, {}).get("name") or ("item %d" % i)
        return items[i]

    def sell(i):
        """What a vendor pays for an item: the Forever client's item table, else Classic's."""
        if i in prices:
            return prices[i][1]
        return int(db["items"].get(i, {}).get("SellPrice") or 0)

    def add_npc(n):
        d = qdb.npc(n)
        e = {"name": d.get(1) or ("NPC %d" % n), "faction": d.get(13) or "AH"}
        for area, points in (d.get(7) or {}).items():
            if points and int(area) in areas:
                e["map"], e["zone"] = areas[int(area)]
                e["x"], e["y"] = round(points[0][0], 1), round(points[0][1], 1)
                break
        npcs[n] = e
        return e

    # zones: where fish don't get away from (base + 95), the mobs' levels, and what they give
    out_zones, report = {}, []
    for area, (side, low, high) in sorted(ZONES.items()):
        if area not in base or area not in areas:
            report.append("- area %d: no base skill or map, left out" % area)
            continue
        fish = {i: round(p, 4) for i, p in shares(area, fishing, refs).items() if p >= MIN_SHARE}
        if not fish:
            report.append("- %s: no fishing loot, left out" % areas[area][1])
            continue
        for i in fish:
            item_name(i)
        top = max(fish, key=fish.get)
        out_zones[area] = {"name": areas[area][1], "map": areas[area][0], "base": base[area], "faction": side,
                           "levels": [low, high], "top": top,
                           "fish": dict(sorted(fish.items(), key=lambda kv: -kv[1]))}

    # fishing pools (Floating Wreckage, schools of fish): what one catch from a pool gives, how many catches a pool
    # holds, and its tier: the trunk it can hold, which grows with the zone (Tightly Sealed .. Mithril Bound)
    pools, pool_tiers = {}, defaultdict(dict)
    for entry, r in sorted(db["holes"].items()):
        if entry in POOL_SKIP:
            continue
        loot = shares(int(r["data1"]), db["gameobject_loot_template"], refs)
        fish = {i: round(p, 4) for i, p in loot.items() if p >= MIN_SHARE}
        if not fish:
            continue
        tier = max([TRUNK_TIERS.get(item_name(i), 0) for i in fish] or [0])
        pools[entry] = {"name": r["name"], "tier": tier, "catches": [int(r["data2"]), int(r["data3"])],
                        "fish": dict(sorted(fish.items(), key=lambda kv: -kv[1]))}
        pool_tiers[r["name"]].setdefault(tier, entry)
    # where QuestieDB (Forever's data) has seen them; the rest come from GatherMate2 in game
    for entry in pools:
        for area, points in (qdb.get("Object", entry).get(4) or {}).items():
            parent = subzones.get(int(area), (int(area), None))[0]
            if parent in out_zones and points:
                known = out_zones[parent].setdefault("pools", {})
                known[entry] = known.get(entry, 0) + len(points)

    # containers caught (chests, crates, trunks): what's inside on average, coins included. Contents rarer than 1%
    # count at their vendor price as `rest`; the others are listed, to be priced at the auction house in game.
    containers = {}
    caught = {i for z in out_zones.values() for i in z["fish"]} | {i for p in pools.values() for i in p["fish"]}
    for item in sorted(caught):
        it = db["items"].get(item, {})
        money = (int(it.get("minMoneyLoot") or 0) + int(it.get("maxMoneyLoot") or 0)) / 2
        if item not in db["item_loot_template"] and not money:
            continue
        inside = shares(item, db["item_loot_template"], refs)
        kept = {i: round(p, 4) for i, p in sorted(inside.items(), key=lambda kv: -kv[1]) if p >= 0.01}
        rest = sum(p * sell(i) for i, p in inside.items() if p < 0.01)
        containers[item] = {"items": kept, "rest": round(rest), "money": round(money)}
        for i in kept:
            item_name(i)
    sells = {}
    for i in caught | {i for c in containers.values() for i in c["items"]}:
        item_name(i)
        if sell(i) > 0:
            sells[i] = sell(i)

    # Nat Pagle's quest: where each of its four fish bites
    quest = qdb.quest(6607)
    quest_fish = {}
    for item, _, _ in (quest.get(10) or {}).get(3, []):
        item_name(item)
        for area, rows in fishing.items():
            if any(r[0] == item for r in rows):
                parent, name = subzones.get(area, (area, None))
                if parent in out_zones:
                    quest_fish[item] = {"area": area, "where": name or out_zones[parent]["name"],
                                        "zone": parent, "base": base.get(area, base.get(parent))}
                    break
    giver = (quest.get(2) or [[None]])[0][0]
    g = add_npc(giver)
    quests[6607] = {"name": quest.get(1), "faction": "AH", "giver": giver, "giverName": g["name"],
                    "zone": g.get("zone"), "x": g.get("x"), "y": g.get("y"), "reqLevel": quest.get(4),
                    "skill": (quest.get(18) or [None, None])[1]}

    buy = {i: p[0] for i, p in prices.items() if p[0] > 0}
    vendor_prices = {}
    for i in list(POLES) + list(LURES):
        item_name(i)
        if qdb.item(i).get(14) and i in buy:  # sold by vendors
            vendor_prices[i] = {"A": buy[i], "H": buy[i]}

    ranks = []
    for rank in RANKS:
        rank = dict(rank)
        if rank["how"] == "book":
            item_name(rank["item"])
            rank["charLevel"] = qdb.item(rank["item"]).get(10)
            rank["cost"] = buy.get(rank["item"])
            rank["vendors"] = []
            for n in qdb.item(rank["item"]).get(14) or []:
                v = add_npc(n)
                rank["vendors"].append({"kind": "vendor", "npc": n, "npcName": v["name"], "faction": v["faction"],
                                        "cost": rank["cost"]})
        if rank["how"] == "quest":
            q = quests[rank["quest"]]
            rank["learnAt"], rank["charLevel"] = q["skill"] or rank["learnAt"], q["reqLevel"]
            rank["fish"] = sorted(quest_fish)
        ranks.append(rank)

    built = datetime.date.today().isoformat()
    data = {"built": built, "build": build, "ranks": ranks, "zones": out_zones, "questFish": quest_fish,
            "gear": {"poles": POLES, "lures": LURES, "lureMinutes": LURE_MINUTES}, "pools": pools,
            "poolTiers": dict(pool_tiers), "gm2": GM2_POOLS, "containers": containers, "sell": sells,
            "npcs": npcs, "quests": quests, "vendorPrices": vendor_prices, "items": items}
    write_lua(data)
    write_report(data, report)
    print("Fishing.lua: %d zones (%d with known pools), %d pools, %d containers, %d of Nat Pagle's fish placed,"
          " %d gear items priced, Forever build %s" % (len(out_zones), sum(1 for z in out_zones.values() if z.get("pools")),
                                                      len(pools), len(containers), len(quest_fish), len(vendor_prices), build))


def write_lua(d):
    lines = [
        "-- Craft Ladder: Fishing data for WoW Forever.",
        "-- GENERATED by tools/build_fishing.py on %s - don't edit by hand; fix the builder and rebuild." % d["built"],
        "-- Zones: base = fishing skill where fish start to bite (none get away from base + 95); fish = share of catches",
        "-- (CMaNGOS classic-db: Classic's world, which Forever may change). levels = its mobs; faction A, H or C",
        "-- (contested). pools = fishing pools QuestieDB places there (kind = count). Pools: fish = one catch from it,",
        "-- tier = the trunk it holds. containers: what's inside on average (rest, money: copper). sell = vendor price.",
        "-- gm2 = GatherMate2's fishing node ids. Names, NPCs and quests: QuestieDB. Vendor prices: the client's item",
        "-- table, build %s." % d["build"],
        "local _, ns = ...",
        "",
        "ns.FISHING = {",
        "  built = %s," % lua(d["built"]),
        "  ranks = {",
    ]
    for r in d["ranks"]:
        lines.append("    %s," % lua(r))
    lines.append("  },")
    lines.append("  gear = %s," % lua(d["gear"]))
    lines.append("  recipes = {},")
    lines.append("  gm2 = %s," % lua(d["gm2"]))
    lines.append("  poolTiers = {")
    for name, tiers in sorted(d["poolTiers"].items()):
        lines.append("    [%s] = %s," % (lua(name), lua(tiers)))
    lines.append("  },")
    for name in ("zones", "pools", "containers", "questFish", "npcs", "quests", "vendorPrices", "sell", "items"):
        lines.append("  %s = {" % name)
        for k, v in sorted(d[name].items()):
            if isinstance(v, dict):
                v = {x: y for x, y in v.items() if y is not None}
            lines.append("    [%d] = %s," % (k, lua(v)))
        lines.append("  },")
    lines.append("}")
    OUT_LUA.write_text("\n".join(lines) + "\n", encoding="utf-8")


def write_report(d, notes):
    out = ["# Fishing data report", "",
           "Built %s by `tools/build_fishing.py`. %d zones; prices from Forever build %s." % (
               d["built"], len(d["zones"]), d["build"]), "", "## Ranks", ""]
    for r in d["ranks"]:
        extra = ""
        if r["how"] == "book":
            extra = "book from " + ", ".join(v["npcName"] for v in r["vendors"])
        elif r["how"] == "quest":
            extra = "quest %s" % d["quests"][r["quest"]]["name"]
        out.append("- %s (cap %d): at %d%s, %s%s, %s" % (r["name"], r["cap"], r["learnAt"],
                   (", level %d" % r["charLevel"]) if r.get("charLevel") else "", r["how"],
                   (" - " + extra) if extra else "", money(r.get("cost"))))
    out += ["", "## Nat Pagle's fish", ""]
    for item, q in sorted(d["questFish"].items()):
        out.append("- %s: %s (%s), fish bite from %d" % (d["items"][item], q["where"], d["zones"][q["zone"]]["name"],
                                                         q["base"]))
    out += ["", "## Zones", "", "| Zone | Side | Levels | Fish bite from | No getaways from | Main fish |",
            "|---|---|---|---|---|---|"]
    for area, z in sorted(d["zones"].items(), key=lambda kv: (kv[1]["base"], kv[1]["name"])):
        main = ", ".join("%s %d%%" % (d["items"][i], round(p * 100)) for i, p in list(z["fish"].items())[:3])
        out.append("| %s | %s | %d-%d | %d | %d | %s |" % (z["name"], z["faction"], z["levels"][0], z["levels"][1],
                                                          max(1, z["base"] - 5), z["base"] + 95, main))
    out += ["", "## Fishing pools", "", "Known places (QuestieDB): " + (", ".join(
        "%s: %s" % (z["name"], ", ".join("%s (%d)" % (d["pools"][e]["name"], n) for e, n in z["pools"].items()))
        for z in d["zones"].values() if z.get("pools")) or "none") + ". Others come from GatherMate2 in game.", ""]
    for e, p in sorted(d["pools"].items(), key=lambda kv: (kv[1]["tier"], kv[1]["name"])):
        loot = ", ".join("%s %d%%" % (d["items"][i], round(s * 100)) for i, s in list(p["fish"].items())[:4])
        out.append("- %s (%d, tier %d, %d-%d catches): %s" % (p["name"], e, p["tier"], p["catches"][0],
                                                             p["catches"][1], loot))
    out += ["", "## Containers", ""]
    for i, c in sorted(d["containers"].items()):
        inside = ", ".join("%s %d%%" % (d["items"][x], round(s * 100)) for x, s in list(c["items"].items())[:4])
        out.append("- %s: coins %s, %s; the rest worth %s at a vendor" % (d["items"][i], money(c["money"]),
                                                                         inside or "-", money(c["rest"])))
    out += ["", "## Gear", ""]
    for kind in ("poles", "lures"):
        for i, bonus in sorted(d["gear"][kind].items(), key=lambda kv: kv[1]):
            p = d["vendorPrices"].get(i)
            out.append("- %s +%d: %s" % (d["items"][i], bonus, ("vendor " + money(p["A"])) if p else "no vendor"))
    if notes:
        out += ["", "## Left out", ""] + notes
    OUT_REPORT.write_text("\n".join(out) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
