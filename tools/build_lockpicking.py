"""Build CraftLadder/Data/Lockpicking.lua and tools/LockpickingReport.md.

Lockpicking (rogues only, the skill's cap is the character's level x 5) uses Mining's ladder: locked chests are nodes.
Sources:
  - GatherMate2_Data (installed; no license): where the chests are in Forever (its treasure ids
    508 and 514-519);
  - the Forever client's tables (wago.tools): the skill a lock needs (Lock), Thieves' Tools, lockbox prices and icons,
    zone names and sizes;
  - CMaNGOS classic-db (pinned as in build_fishing.py, GPL-3.0): which chest of a name needs which skill (three kinds
    of Battered Footlocker), the dungeon doors, the trainers' fee, who Pick Pockets which junkbox;
  - QuestieDB (Forever): the chests' places by kind, the class quests that teach using Pick Lock.
Colours as Mining's: yellow 25, green 50, grey 100 above what a lock needs (CMaNGOS skills Lockpicking as it does
gathering).

    python -I tools/build_lockpicking.py
"""
import datetime
import math
import re
import sys
from collections import defaultdict
from pathlib import Path

TOOLS = Path(__file__).resolve().parent
ROOT = TOOLS.parent
sys.path.insert(0, str(TOOLS))
import wago  # noqa: E402
from build_data import lua, money  # noqa: E402
from build_fishing import ZONES, classicdb  # noqa: E402
from build_mining import ADDONS, EXTRA_ZONES  # noqa: E402
from questiedb import Places, QuestieDB, zones  # noqa: E402

OUT_LUA = ROOT / "CraftLadder" / "Data" / "Lockpicking.lua"
OUT_REPORT = TOOLS / "LockpickingReport.md"
GM2_TREASURE = ADDONS / "GatherMate2_Data" / "Forever" / "TreasureData.lua"
LOCK_PICK = "1"  # Lock's index for a lock you pick (its type 2 = a lock type)
PICK_LOCK, PICK_LOCK_TEACH, THIEVES_TOOLS = 1804, 6480, 5060
# GatherMate2's treasure ids of the chests a rogue picks to level, and an item whose icon looks like each (a chest has
# no icon of its own)
GM2_CHESTS = {508: "Buccaneer's Strongbox", 514: "Practice Lockbox", 515: "Battered Footlocker",
              516: "Waterlogged Footlocker", 517: "Dented Footlocker", 518: "Mossy Footlocker", 519: "Scarlet Footlocker"}
ICON_ITEM = {"Buccaneer's Strongbox": 4633, "Practice Lockbox": 4632, "Battered Footlocker": 16882,
             "Waterlogged Footlocker": 6354, "Dented Footlocker": 16883, "Mossy Footlocker": 16884,
             "Scarlet Footlocker": 16885, "Blackrock Depths doors": 11000}
# items a rogue picks, and where they come from
BOXES = {4632: "drop", 4633: "drop", 4634: "drop", 4636: "drop", 4637: "drop", 4638: "drop", 5758: "drop",
         5759: "drop", 5760: "drop", 16882: "pickpocket", 16883: "pickpocket", 16884: "pickpocket",
         16885: "pickpocket", 6354: "fishing", 6355: "fishing", 13875: "fishing", 13918: "fishing", 6712: "engineering"}
# the dungeons of the doors a rogue can pick (CMaNGOS's door entries; the client has no map for them)
DOORS = {"Scarlet Monastery": [101850, 101851, 101854, 104591], "Gnomeregan": [90566, 90858],
         "Blackrock Depths": [161460, 170558, 170559, 170560, 170562, 170563, 170564, 170565, 170566, 170567, 170568,
                              170569, 170570],
         "Scholomance": [174626], "Stratholme": [175352, 175353, 175356, 175357, 175368, 175369]}
# Blackrock Depths' door round (zockify's Forever guide): 3 doors and the Shadowforge Lock a run, 5 runs an hour
BRD = {"key": -230, "levels": (52, 60), "doors": 4, "skill": 250}
# The class quests that teach using Pick Lock at 16, by race (Classic: each starts where that race's rogues train;
# QuestieDB opens them to the whole faction). A race not listed takes its faction's.
CHAINS = {"Human": [2281, 2282], "Dwarf": [2299, 2298, 2281, 2282], "Gnome": [2299, 2298, 2281, 2282],
          "NightElf": [2259, 2260, 2281, 2282], "Orc": [2380, 2379, 2382, 2381], "Troll": [2380, 2379, 2382, 2381],
          "Scourge": [2378, 2379, 2382, 2381], "A": [2281, 2282], "H": [2380, 2379, 2382, 2381]}
CLUSTER = 6.0  # a chest's spot: the place with the most others within this many map % of it


def colors_for(skill):
    base = 0 if skill == 1 else skill  # a skill of 1 counts as 0: yellow 25, green 50, grey 100
    return [skill, base + 25, base + 50, base + 100]


def gm2_treasure():
    """{ui map: {chest name: [(x, y) in map %]}} from GatherMate2_Data (its coordinate: x then y, 4 digits each)."""
    out, current = defaultdict(lambda: defaultdict(list)), None
    for line in GM2_TREASURE.read_text(encoding="utf-8").splitlines():
        m = re.match(r"\s*\[(\d+)\] = \{", line)
        if m:
            current = int(m.group(1))
            continue
        m = re.match(r"\s*\[(\d+)\] = (\d+),", line)
        if m and current and int(m.group(2)) in GM2_CHESTS:
            coord = int(m.group(1))
            out[current][GM2_CHESTS[int(m.group(2))]].append((coord // 1000000 / 100, coord // 100 % 10000 / 100))
    return out


def spot(points):
    """Where most of a zone's chests of a kind are: the place with the most others near it, and their middle."""
    best = max(points, key=lambda p: sum(math.dist(p, q) <= CLUSTER for q in points))
    near = [q for q in points if math.dist(best, q) <= CLUSTER]
    return [round(sum(q[0] for q in near) / len(near), 1), round(sum(q[1] for q in near) / len(near), 1)]


def main():
    build = wago.latest_build()
    db = classicdb(False)
    qdb = QuestieDB()
    places = Places(qdb)
    areas = zones()  # {area: (ui map, name)}
    report = []
    picks = {}
    for r in wago.table("Lock", build):
        for i in range(8):
            if r["Type_%d" % i] == "2" and r["_Index_%d" % i] == LOCK_PICK:
                picks[r["ID"]] = int(r["Skill_%d" % i])
    sparse = {int(r["ID"]): r for r in wago.table("ItemSparse", build)}
    icons = {int(r["ID"]): int(r["IconFileDataID"]) for r in wago.table("Item", build)}

    # chests: one kind per name and skill (CMaNGOS has three Battered Footlockers: 70, 110 and 150); QuestieDB's places
    # of each by ui map, GatherMate2's places of each name (it doesn't tell the kinds apart)
    nodes, kind_of, questie = {}, {}, defaultdict(lambda: defaultdict(list))
    for entry, o in sorted(db["objects"].items()):
        if o["type"] != "3" or o["name"] not in ICON_ITEM or o["data0"] not in picks:
            continue
        skill = picks[o["data0"]]
        key = (o["name"], skill)
        if key not in kind_of:
            kind_of[key] = entry
            nodes[entry] = {"name": o["name"], "skill": skill, "colors": colors_for(skill), "loot": {}, "ore": {},
                            "item": ICON_ITEM[o["name"]], "lock": True, "share": 1}
        spawns = qdb.get("Object", entry).get(4) or {}
        if isinstance(spawns, list):
            spawns = dict(enumerate(spawns, 1))
        for area, points in spawns.items():
            m = areas.get(int(area))
            if m and points:
                questie[m[0]][kind_of[key]] += [(p[0], p[1]) for p in points]
    seen = gm2_treasure()

    # zones: each kind's places, GatherMate2's places of a name shared out between its kinds as QuestieDB has them
    # there (the more of the two counts); size in km², side and levels as Mining's
    names = {int(r["ID"]): r["Name_lang"] for r in wago.table("UiMap", build)}
    sizes, area_of = {}, {}
    for r in wago.table("UiMapAssignment", build):
        if r["OrderIndex"] == "0" and int(r["UiMapID"]) not in sizes:
            dx = float(r["Region_3"]) - float(r["Region_0"])
            dy = float(r["Region_4"]) - float(r["Region_1"])
            sizes[int(r["UiMapID"])] = dx * dy * 0.9144 ** 2 / 1e6
            area_of[int(r["UiMapID"])] = int(r["AreaID"])
    sides = {**ZONES, **EXTRA_ZONES}
    zone_list = {}
    for ui_map in sorted(set(seen) | set(questie)):
        name = names.get(ui_map, "map %d" % ui_map)
        side = sides.get(area_of.get(ui_map))
        if not side:
            report.append("- %s: no side or levels known, left out" % name)
            continue
        counts, spots = {}, {}
        for chest in {n["name"] for n in nodes.values()}:
            kinds = [k for k, n in nodes.items() if n["name"] == chest]
            q_total = sum(len(questie[ui_map][k]) for k in kinds)
            gm2 = seen[ui_map].get(chest, [])
            for k in kinds:
                q = len(questie[ui_map][k])
                n = max(q, len(gm2) * q / q_total) if q_total else 0
                if n:
                    counts[k] = round(n, 1)
                    spots[k] = spot(gm2 or questie[ui_map][k])
            if gm2 and not q_total:
                report.append("- %s: GatherMate2 has %d %s places, QuestieDB none: which lock they need is unknown, "
                              "left out" % (name, len(gm2), chest))
        if counts:
            zone_list[ui_map] = {"name": name, "map": ui_map, "faction": side[0], "levels": [side[1], side[2]],
                                 "size": round(sizes[ui_map], 2), "nodes": counts, "spots": spots}

    # Blackrock Depths' doors: one kind, a run's doors in a small place (no map, no places: the card says the round)
    door = min(DOORS["Blackrock Depths"])
    nodes[door] = {"name": "Blackrock Depths doors", "skill": BRD["skill"], "colors": colors_for(BRD["skill"]),
                   "loot": {}, "ore": {}, "item": ICON_ITEM["Blackrock Depths doors"], "lock": True, "share": 1}
    zone_list[BRD["key"]] = {"name": "Blackrock Depths", "map": BRD["key"], "faction": "C",
                             "levels": list(BRD["levels"]), "size": 0.3, "nodes": {door: BRD["doors"]},
                             "dungeon": True}
    doors = []
    for dungeon, entries in DOORS.items():
        skills = sorted({picks[db["objects"][e]["data1"]] for e in entries if db["objects"].get(e, {}).get("data1") in picks})
        if skills:
            doors.append({"dungeon": dungeon, "skill": skills[0], "doors": len(entries)})

    # what a rogue picks from its bags: a lockbox is a "recipe" (key: minus the item) whose reagent is the box; who
    # Pick Pockets a junkbox (CMaNGOS, levels of the creatures that carry one: the middle 80%)
    carriers = defaultdict(list)
    for entry, c in db["creatures"].items():
        template = int(c["PickpocketLootId"] or 0)
        rows = list(db["pickpocketing_loot_template"].get(template, []))
        for item, _, _, ref, _ in list(rows):
            if ref < 0:
                rows += db["reference_loot_template"].get(-ref, [])
        for item, *_ in rows:
            if item in BOXES:
                carriers[item].append(int(c["MinLevel"]))
    recipes, items = {}, {}
    for item, source in BOXES.items():
        r = sparse[item]
        lock = r.get("LockID")
        if lock not in picks:
            report.append("- %s (%d): no pick lock in the client's tables, left out" % (r["Display_lang"], item))
            continue
        skill = picks[lock]
        rec = {"name": r["Display_lang"], "learn": skill, "colors": colors_for(skill), "mats": {item: 1},
               "get": [{"kind": "start"}], "icon": icons.get(item), "source": source}
        levels = sorted(carriers.get(item, []))
        if source == "pickpocket" and levels:
            rec["levels"] = [levels[len(levels) // 10], levels[len(levels) * 9 // 10]]
        recipes[-item] = rec
        items[item] = r["Display_lang"]
    for n in nodes.values():
        items[n["item"]] = sparse[n["item"]]["Display_lang"]
    items[THIEVES_TOOLS] = sparse[THIEVES_TOOLS]["Display_lang"]

    # Pick Lock: any rogue trainer at 16 (CMaNGOS's fee); its cap and the ones after it come from your level in game
    fee = next((int(r["spellcost"]) for t in ("npc_trainer", "npc_trainer_template") for r in db[t]
                if int(r["spell"]) == PICK_LOCK_TEACH), None)
    ranks = [{"name": "Pick Lock", "how": "trainer", "cost": fee, "learnAt": 0, "charLevel": 16, "spell": PICK_LOCK,
              "mats": {THIEVES_TOOLS: 1}}]
    chains = {race: list(qs) for race, qs in CHAINS.items()}
    for qs in chains.values():
        for q in qs:
            places.quest(q)
    vendor = int(sparse[THIEVES_TOOLS]["BuyPrice"])

    data = {"built": datetime.date.today().isoformat(), "build": build, "ranks": ranks, "nodes": nodes,
            "zones": zone_list, "recipes": recipes, "items": items, "doors": doors, "chains": chains,
            "npcs": places.npcs, "quests": places.quests, "vendorPrices": {THIEVES_TOOLS: {"A": vendor, "H": vendor}}}
    write_lua(data)
    write_report(data, report)
    print("Lockpicking.lua: %d kinds of chest, %d zones, %d boxes, Forever build %s" % (len(nodes), len(zone_list),
                                                                                         len(recipes), build))


def write_lua(d):
    lines = [
        "-- Craft Ladder: Lockpicking data for WoW Forever.",
        "-- GENERATED by tools/build_lockpicking.py on %s - don't edit by hand; fix the builder and rebuild." % d["built"],
        "-- Mining's ladder picks locked chests as it mines nodes. nodes (CMaNGOS's chest entries, one per name and",
        "-- skill): skill = what its lock needs (the client's Lock table), colors = Mining's rule from it, item = an item",
        "-- whose icon looks like it. zones (ui maps): nodes = places (GatherMate2_Data and QuestieDB), spots = where most",
        "-- of a kind are (map %); Blackrock Depths (no map) is its door round. recipes: boxes picked from the bags",
        "-- (key: minus the item). chains: the class quests by race (build %s)." % d["build"],
        "local _, ns = ...",
        "",
        "ns.LOCKPICKING = {",
        "  built = %s," % lua(d["built"]),
        "  ranks = {",
    ]
    for r in d["ranks"]:
        lines.append("    %s," % lua(r))
    lines.append("  },")
    for name in ("nodes", "zones", "recipes", "items", "npcs", "quests", "vendorPrices"):
        lines.append("  %s = {" % name)
        for k, v in sorted(d[name].items()):
            lines.append("    [%d] = %s," % (k, lua(v)))
        lines.append("  },")
    lines.append("  doors = %s," % lua(d["doors"]))
    lines.append("  chains = {")
    for race, qs in sorted(d["chains"].items()):
        lines.append("    %s = %s," % (race, lua(qs)))
    lines.append("  },")
    lines.append("}")
    OUT_LUA.write_text("\n".join(lines) + "\n", encoding="utf-8")


def write_report(d, notes):
    nodes = d["nodes"]
    out = ["# Lockpicking data report", "",
           "Built %s by `tools/build_lockpicking.py`. %d kinds of chest, %d zones, %d boxes; Forever build %s." % (
               d["built"], len(nodes), len(d["zones"]), len(d["recipes"]), d["build"]), "",
           "Pick Lock: any rogue trainer at level 16, %s; needs Thieves' Tools. The cap is the level x 5." % money(
               d["ranks"][0]["cost"]), "", "## Chests", "", "| Chest | Skill | Colours |", "|---|---|---|"]
    for n in sorted(nodes.values(), key=lambda n: (n["skill"], n["name"])):
        out.append("| %s | %d | %s |" % (n["name"], n["skill"], "/".join(map(str, n["colors"]))))
    out += ["", "## Zones", "", "| Zone | Side | Levels | km² | Chests (places) |", "|---|---|---|---|---|"]
    for z in sorted(d["zones"].values(), key=lambda z: z["name"]):
        out.append("| %s | %s | %d-%d | %.1f | %s |" % (z["name"], z["faction"], z["levels"][0], z["levels"][1],
                   z["size"], ", ".join("%s %d %g" % (nodes[k]["name"], nodes[k]["skill"], c)
                                        for k, c in z["nodes"].items())))
    out += ["", "## Boxes from the bags", "", "| Box | Skill | From |", "|---|---|---|"]
    for r in sorted(d["recipes"].values(), key=lambda r: r["learn"]):
        out.append("| %s | %d | %s%s |" % (r["name"], r["learn"], r["source"],
                   (" (creatures level %d-%d)" % tuple(r["levels"])) if r.get("levels") else ""))
    out += ["", "## Dungeon doors", ""] + ["- %s: %d doors, from %d" % (x["dungeon"], x["doors"], x["skill"])
                                           for x in d["doors"]]
    out += ["", "## Class quests by race", ""] + ["- %s: %s" % (race, " -> ".join(
        d["quests"][q]["name"] for q in qs)) for race, qs in sorted(d["chains"].items())]
    out += ["", "## Guesses (to check against the real game; see ASSUMPTIONS.md)", "",
            "- Skill-ups: Classic's rule for gathering (yellow 25, green 50, grey 100 above what a lock needs).",
            "- Which race starts which class quest; Blackrock Depths' round (4 doors a run, 5 runs an hour).",
            "- A chest's kind where GatherMate2 has its places: shared out as QuestieDB has the kinds there."]
    if notes:
        out += ["", "## Left out", ""] + notes
    OUT_REPORT.write_text("\n".join(out) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
