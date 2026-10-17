"""Build CraftLadder/Data/Skinning.lua and tools/SkinningReport.md.

Sources:
  - CMaNGOS classic-db (pinned as in build_fishing.py, GPL-3.0): which creatures can be skinned and what skinning one
    gives (creature_template.SkinningLootId, skinning_loot_template), and the trainers who teach the ranks.
  - QuestieDB (the installed addon's Forever data): where those creatures are (spawns by zone) and their levels.
  - wago.tools (the Forever client's tables): zone names and sizes (UiMap, UiMapAssignment), what a vendor pays.
Skinning uses Mining's ladder: a creature is a "node" (one skin, one chance at a point) and its spawns are the places.
The skill one needs is Classic's rule from its level: 1 up to level 10, (level - 10) x 10 to level 20, level x 5
above; colours as Mining's (yellow 25, green 50, grey 100 above). Creatures new in Forever aren't in CMaNGOS: they're
kept as candidates (where they are, their levels), and the game records the ones you skin (CraftLadderDB.skinLog).

    python -I tools/build_skinning.py
"""
import datetime
import sys
from collections import Counter, defaultdict
from pathlib import Path

TOOLS = Path(__file__).resolve().parent
ROOT = TOOLS.parent
sys.path.insert(0, str(TOOLS))
import wago  # noqa: E402
from build_data import lua, money  # noqa: E402
from build_fishing import ZONES, classicdb  # noqa: E402
from build_mining import EXTRA_ZONES  # noqa: E402
from questiedb import Places, QuestieDB, zones  # noqa: E402

OUT_LUA = ROOT / "CraftLadder" / "Data" / "Skinning.lua"
OUT_REPORT = TOOLS / "SkinningReport.md"
ERA_BUILD = "1.15.9.70003"  # the Classic Era client whose SpellEffect still has Classic's teaching spells
NODE_SECONDS = 30  # Gold: killing, looting and skinning one creature of your level, about
RANKS = [
    {"name": "Apprentice", "cap": 75, "spell": 8613},
    {"name": "Journeyman", "cap": 150, "spell": 8617, "charLevel": 10},
    {"name": "Expert", "cap": 225, "spell": 8618, "charLevel": 20},
    {"name": "Artisan", "cap": 300, "spell": 10768, "charLevel": 35},
]
RANK_NAMES = {0: "normal", 1: "elite", 2: "rare elite", 3: "boss", 4: "rare"}
FRIENDLY_TO_ALL = "35"  # a faction template no one can attack (a vendor's riding wolves)
NOT_ATTACKABLE = 0x2 | 0x100 | 0x2000000  # unit flags: non attackable, immune to players, not selectable


def skill_for(level):
    """The skinning skill a creature of `level` needs (Classic's rule)."""
    if level <= 10:
        return 1
    if level <= 20:
        return (level - 10) * 10
    return level * 5


def colors_for(skill):
    """Mining's colours: yellow 25, green 50, grey 100 above what it needs (a skill of 1 counts as 0)."""
    base = 0 if skill == 1 else skill
    return [skill, base + 25, base + 50, base + 100]


def main():
    build = wago.latest_build()
    db = classicdb(False)
    qdb = QuestieDB()
    places = Places(qdb)
    areas = zones()  # {area: (ui map, zone name)}
    sides = {**ZONES, **EXTRA_ZONES}  # {area: (A/H/C, levels from, to)}
    items, report = {}, []

    def item_name(i):
        if i not in items:
            items[i] = db["items"].get(i, {}).get("name") or qdb.item(i).get(1) or ("item %d" % i)
        return items[i]

    def spawns_of(npc):
        """{ui map: spawn count} in zones whose side Craft Ladder knows, and the NPC's levels (QuestieDB)."""
        d = qdb.npc(npc)
        sp = d.get(7) or {}
        if isinstance(sp, list):  # CBOR keeps a map keyed 1, 2, ... as a list
            sp = dict(enumerate(sp, 1))
        out = defaultdict(int)
        for area, points in sp.items():
            area = int(area)
            if points and area in areas and area in sides:
                out[areas[area][0]] += len(points)
        return dict(out), d.get(4), d.get(5), d.get(1)

    # what skinning one gives, by loot template: items of a loot group are one of them per roll, a chance of 0 an equal
    # share of what the others leave (as Mining's nodes)
    def loot_of(template):
        rows = [x for x in db["skinning_loot_template"].get(template, []) if x[3] > 0]
        fixed, zero = defaultdict(float), defaultdict(int)
        for _, chance, group, _, _ in rows:
            fixed[group] += chance
            zero[group] += chance == 0
        got = defaultdict(float)
        for item, chance, group, mincount, maxcount in rows:
            share = chance if chance or group == 0 else max(0.0, 100 - fixed[group]) / zero[group]
            got[item] += share / 100 * (mincount + maxcount) / 2
        return {i: round(n, 3) for i, n in sorted(got.items(), key=lambda kv: -kv[1]) if n >= 0.005}

    # creatures you can skin: normal ones (not elites, rares or bosses: one of those is no way to level), where
    # QuestieDB has them in a zone Craft Ladder knows
    nodes, zone_nodes, left = {}, defaultdict(dict), Counter()
    for entry, c in sorted(db["creatures"].items()):
        template = int(c["SkinningLootId"] or 0)
        if not template:
            continue
        if c["Rank"] != "0":
            left[RANK_NAMES.get(int(c["Rank"]), c["Rank"])] += 1
            continue
        if c["Faction"] == FRIENDLY_TO_ALL or int(c["UnitFlags"] or 0) & NOT_ATTACKABLE:
            left["can't be attacked"] += 1
            continue
        where, lo, hi, name = spawns_of(entry)
        if not where or not lo:
            left["no spawns in a known zone"] += 1
            continue
        loot = loot_of(template)
        if not loot:
            left["no skinning loot"] += 1
            continue
        level = (lo + (hi or lo)) // 2
        skill = skill_for(level)
        for i in loot:
            item_name(i)
        nodes[entry] = {"name": name or c["Name"], "level": level, "levels": [lo, hi or lo], "skill": skill,
                        "colors": colors_for(skill), "loot": loot, "ore": {}, "item": next(iter(loot))}
        for ui_map, n in where.items():
            zone_nodes[ui_map][entry] = n

    # candidates: NPCs CMaNGOS doesn't have (most new in Forever), in a zone Craft Ladder knows; the game says which
    # can be skinned when you skin one
    known = set(db["creatures"])
    candidates = {}
    for (ent, eid) in qdb.raw:
        if ent != "Npc" or eid in known:
            continue
        where, lo, hi, name = spawns_of(eid)
        if where and lo and name:
            candidates[eid] = {"name": name, "levels": [lo, hi or lo], "zones": where}
            for ui_map in where:
                zone_nodes.setdefault(ui_map, {})

    # zones: the ones with creatures to skin, their side and levels (as Fishing and Mining know them), size in km²
    names = {int(r["ID"]): r["Name_lang"] for r in wago.table("UiMap", build)}
    sizes, area_of = {}, {}
    for r in wago.table("UiMapAssignment", build):
        if r["OrderIndex"] == "0" and int(r["UiMapID"]) not in sizes:
            dx = float(r["Region_3"]) - float(r["Region_0"])
            dy = float(r["Region_4"]) - float(r["Region_1"])
            sizes[int(r["UiMapID"])] = dx * dy * 0.9144 ** 2 / 1e6
            area_of[int(r["UiMapID"])] = int(r["AreaID"])
    area_by_map = {m: a for a, (m, _) in areas.items() if a in sides}
    zone_list = {}
    for ui_map, mobs in sorted(zone_nodes.items()):
        side = sides.get(area_by_map.get(ui_map))
        if not side or ui_map not in sizes:
            report.append("- map %d: no side or size known, left out" % ui_map)
            continue
        zone_list[ui_map] = {"name": names.get(ui_map, "map %d" % ui_map), "map": ui_map, "faction": side[0],
                             "levels": [side[1], side[2]], "size": round(sizes[ui_map], 2), "nodes": mobs}

    # ranks: trainer fees and skills (CMaNGOS, its teaching spells read through the Classic Era client)
    era_teaches = {int(r["SpellID"]): int(r["EffectTriggerSpell"]) for r in wago.table("SpellEffect", ERA_BUILD)
                   if r["Effect"] == "36" and int(r["EffectTriggerSpell"] or 0)}
    by_template = defaultdict(list)
    for npc, tmpl in db["trainer_template_of"].items():
        by_template[tmpl].append(npc)
    rank_spells = {r["spell"] for r in RANKS}
    trained, trainers = {}, defaultdict(set)
    for table, who in (("npc_trainer", lambda e: [e]), ("npc_trainer_template", lambda e: by_template[e])):
        for r in db[table]:
            spell = era_teaches.get(int(r["spell"]), int(r["spell"]))
            if spell in rank_spells:
                trained[spell] = (int(r["spellcost"]), int(r["reqskillvalue"]))
                trainers[spell].update(who(int(r["entry"])))
    ranks = []
    for rank in RANKS:
        fee, skill = trained.get(rank["spell"], (None, 0))
        r = dict(rank, how="trainer", cost=fee, learnAt=0 if rank["name"] == "Apprentice" else skill)
        if rank["name"] in ("Expert", "Artisan") and 0 < len(trainers[rank["spell"]]) <= 3:
            r["trainers"] = sorted(trainers[rank["spell"]])
            for n in r["trainers"]:
                places.npc(n)
        ranks.append({k: v for k, v in r.items() if v is not None})
    ranks[1]["learnAt"] = ranks[1].get("learnAt") or 50

    prices = wago.item_prices(build)
    sell = {i: prices[i][1] for i in items if i in prices and prices[i][1] > 0}

    data = {"built": datetime.date.today().isoformat(), "build": build, "ranks": ranks, "nodes": nodes,
            "zones": zone_list, "candidates": candidates, "sell": sell, "items": items, "npcs": places.npcs}
    write_lua(data)
    write_report(data, report, left)
    print("Skinning.lua: %d creatures in %d zones, %d candidates new in Forever, Forever build %s" % (
        len(nodes), len(zone_list), len(candidates), build))


def write_lua(d):
    lines = [
        "-- Craft Ladder: Skinning data for WoW Forever.",
        "-- GENERATED by tools/build_skinning.py on %s - don't edit by hand; fix the builder and rebuild." % d["built"],
        "-- Mining's ladder skins creatures as it mines nodes. nodes (creatures you can skin, CMaNGOS classic-db): level",
        "-- (QuestieDB), skill = what it needs (Classic's rule from its level), colors = Mining's rule from that, loot =",
        "-- what one skin gives on average. zones (ui maps): nodes = { [creature] = spawns } (QuestieDB), side and levels,",
        "-- size in km². candidates: creatures CMaNGOS doesn't have (most new in Forever): skinned in game, they join",
        "-- (CraftLadderDB.skinLog). nodeSeconds = a creature's kill, loot and skin (Gold). sell = vendor price (build %s)." % d["build"],
        "local _, ns = ...",
        "",
        "ns.SKINNING = {",
        "  built = %s," % lua(d["built"]),
        "  nodeSeconds = %d," % NODE_SECONDS,
        "  ranks = {",
    ]
    for r in d["ranks"]:
        lines.append("    %s," % lua(r))
    lines.append("  },")
    for name in ("nodes", "zones", "candidates", "sell", "items", "npcs"):
        lines.append("  %s = {" % name)
        for k, v in sorted(d[name].items()):
            lines.append("    [%d] = %s," % (k, lua(v)))
        lines.append("  },")
    lines.append("  recipes = {}, quests = {}, vendorPrices = {},")
    lines.append("}")
    OUT_LUA.write_text("\n".join(lines) + "\n", encoding="utf-8")


def write_report(d, notes, left):
    nodes, zones_, items = d["nodes"], d["zones"], d["items"]
    out = ["# Skinning data report", "",
           "Built %s by `tools/build_skinning.py`. %d creatures to skin in %d zones; %d candidates new in Forever;"
           " Forever build %s." % (d["built"], len(nodes), len(zones_), len(d["candidates"]), d["build"]), "",
           "Left out: " + ", ".join("%d %s" % (n, k) for k, n in left.most_common()) + ".", "", "## Ranks", ""]
    for r in d["ranks"]:
        out.append("- %s (cap %d): at %d%s, trainer %s" % (r["name"], r["cap"], r["learnAt"],
                   (", level %d" % r["charLevel"]) if r.get("charLevel") else "", money(r.get("cost"))))
    out += ["", "## Zones", "", "| Zone | Side | Levels | km² | Creatures | Spawns | Skill they need |", "|---|---|---|---|---|---|---|"]
    for m, z in sorted(zones_.items(), key=lambda kv: kv[1]["name"]):
        mobs = [nodes[n] for n in z["nodes"]]
        out.append("| %s | %s | %d-%d | %.1f | %d | %d | %s |" % (
            z["name"], z["faction"], z["levels"][0], z["levels"][1], z["size"], len(mobs), sum(z["nodes"].values()),
            ("%d-%d" % (min(x["skill"] for x in mobs), max(x["skill"] for x in mobs))) if mobs else "-"))
    out += ["", "## Creatures", "", "| Creature | Level | Skill | One skin gives |", "|---|---|---|---|"]
    for n, c in sorted(nodes.items(), key=lambda kv: (kv[1]["skill"], kv[1]["name"])):
        out.append("| %s | %d-%d | %d | %s |" % (c["name"], c["levels"][0], c["levels"][1], c["skill"],
                   ", ".join("%.2f %s" % (q, items[i]) for i, q in c["loot"].items())))
    out += ["", "## Guesses (to check against the real game; see ASSUMPTIONS.md)", "",
            "- The skill a creature needs: Classic's rule from its level (1 to level 10, (level - 10) x 10 to 20, level"
            " x 5 above), taken at the middle of its levels.",
            "- Skill-up colours: Mining's (yellow 25, green 50, grey 100 above what a creature needs).",
            "- Which creatures can be skinned and what one gives: Classic's (CMaNGOS). Elites, rares and bosses are"
            " left out (no way to level).",
            "- %d creatures CMaNGOS doesn't know (most new in Forever) are candidates: they count once the game records"
            " skinning one." % len(d["candidates"]),
            "- Gold: a creature takes %d s to kill, loot and skin." % NODE_SECONDS]
    if notes:
        out += ["", "## Left out", ""] + notes
    OUT_REPORT.write_text("\n".join(out) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
