"""Build a crafting profession's data: CraftLadder/Data/<Name>.lua and tools/<Name>Report.md.

    python -I tools/build_crafting.py alchemy|blacksmithing|enchanting|engineering|firstaid|leatherworking|poisons|
                                      tailoring [--refresh]

Sources:
  - wago.tools (the Forever client's tables, newest build): the recipes and their colours (SkillLineAbility),
    reagents (SpellReagents), what they make (SpellEffect), the tools they need (SpellTotems, TotemCategory), the plans
    or schematics and the recipe each teaches (ItemSparse, ItemXItemEffect, ItemEffect, SpellEffect), the skill,
    reputation and specialization one asks for, and vendor prices.
  - CMaNGOS classic-db (pinned as in build_fishing.py, GPL-3.0): the recipes and ranks trainers teach, at which skill
    and for how much, and who teaches the ranks. Its trainers list teaching spells; the Classic Era client's
    SpellEffect says which recipe each one teaches (Forever's client no longer has them).
  - QuestieDB (the installed addon's Forever data): who sells a plan, the quests and NPCs that give one, NPC names and
    places, and who sells a reagent or a tool.
  - What trainers showed in game (tools/seen_in_game.json, from Craft Ladder's saved variables): their skill and fee
    beat CMaNGOS's, and a guessed recipe a trainer didn't list isn't a trainer's. What a quartermaster was seen selling
    for Merchant's Favor is sold by it, whether QuestieDB lists it or not.
  - AllTheThings (att.py, pinned, MIT): a Merchant's Favor price not seen in game yet; who sells, rewards or drops a
    plan QuestieDB knows no source for, and the quests that teach a recipe outright (Camping 101); the recipes it holds
    as not out in Forever yet (only their plans at the auction house count, or what the game showed).
A recipe nothing is known to teach (most of them new in Forever) is taken as taught by trainers at yellow - 15 for a
fee like other recipes at that skill, marked as a guess: one visit to a trainer records the real skill and fee in game.
A recipe AllTheThings doesn't list at all (Season of Discovery's, still in the client) isn't guessed: it's left out.
"""
import argparse
import datetime
import statistics
import sys
from collections import Counter, defaultdict
from pathlib import Path

TOOLS = Path(__file__).resolve().parent
ROOT = TOOLS.parent
sys.path.insert(0, str(TOOLS))
import att  # noqa: E402
import seen_in_game  # noqa: E402
import wago  # noqa: E402
from build_data import lua, money  # noqa: E402
from build_fishing import classicdb  # noqa: E402
from questiedb import Places, QuestieDB, side  # noqa: E402

ERA_BUILD = "1.15.9.70003"  # the Classic Era client whose SpellEffect still has Classic's teaching spells
MAX_SKILL = 300
GUESS_BELOW_YELLOW = 15  # a recipe nothing is known to teach: learnable this far below yellow (as First Aid's)
TRAINERS_LISTED = 3  # a recipe this few trainers teach names them (Annora alone teaches Artisan Enchanting's)
COOLDOWN_MIN = 3600  # seconds: a recipe that waits this long or more between crafts (Mooncloth) isn't for leveling
VENDOR_MIN = 3  # a reagent new in Forever sold by fewer vendors may be limited stock: priced at the auction house
# the profession quartermasters of Forever's supply camps (the Barrens, Redridge): they sell recipes for Merchant's Favor,
# how much the client doesn't say
FAVOR_VENDORS = set(range(248196, 248203)) | set(range(256729, 256736))
BOTS = {14337, 242498, 254695, 277849}  # Field Repair Bot 74A, Reagent Bot, Repair Bot, Portable Repair Bot: an
# engineer summons them, so they don't count as vendors
COAL = 3857  # Smelt Steel's other reagent: Steel Bars are priced from Iron Bars and Coal too
# a dish's Well Fed: what it raises, by its aura (EffectAura) and, for MOD_STAT, the stat (EffectMiscValue_0)
WELL_FED_STATS = {0: "str", 1: "agi", 2: "sta", 3: "int", 4: "spi"}  # aura 29 MOD_STAT
WELL_FED_AURAS = {13: "spell", 135: "heal", 99: "ap", 124: "rap"}  # spell damage, healing, attack power, ranged AP
STANDING = ["Hated", "Hostile", "Unfriendly", "Neutral", "Friendly", "Honored", "Revered", "Exalted"]
RANK_NAMES = [("Apprentice", 75, None), ("Journeyman", 150, 10), ("Expert", 225, 20), ("Artisan", 300, 35)]
GNOMISH, GOBLIN = 20219, 20222
PROFESSIONS = {
    "blacksmithing": {"name": "Blacksmithing", "table": "BLACKSMITHING", "skillLine": 164, "plan": "plan",
                      "ranks": [2018, 3100, 3538, 9785],
                      # Myolor Sunderfury and Krathok Moltenfist first, then the trainer's quest; a Weaponsmith masters
                      # one weapon with a dungeon quest from the trainers in Everlook (Kilram, Lilith, Seril)
                      "guides": [
                          {"spec": 9787, "steps": [
                              {"talk": [11145, 11176], "note": "Pick \"I wish to become a weaponsmith.\""},
                              {"quests": [5284, 5302]},
                              {"pick": [(17041, 5306), (17040, 5305), (17039, 5307)],
                               "note": "Then learn the mastery from the trainer who gave you the quest."}]},
                          {"spec": 9788,
                           "note": "Hank the Hammer's (Alliance) or Aturk the Anvil's (Horde) quests lead to Galvan the"
                                   " Ancient and Trenton Lighthammer, whose quests teach the Ornate Mithril recipes the"
                                   " last quest asks for. Buy those 7 items at the auction house and you can skip them.",
                           "steps": [
                               {"talk": [11145, 11176], "note": "Pick \"I wish to become an armorsmith.\""},
                               {"quests": [2758]}, {"quests": [2759]}, {"quests": [2756]}, {"quests": [2757]},
                               {"quests": [2760]}, {"quests": [2761]}, {"quests": [2762]}, {"quests": [2763]},
                               {"quests": [2764]}, {"quests": [2771]}, {"quests": [2772]}, {"quests": [2773]},
                               {"quests": [5283, 5301]}]}]},
    "tailoring": {"name": "Tailoring", "table": "TAILORING", "skillLine": 197, "plan": "pattern",
                  "ranks": [3908, 3909, 3910, 12180]},
    "leatherworking": {"name": "Leatherworking", "table": "LEATHERWORKING", "skillLine": 165, "plan": "pattern",
                       "ranks": [2108, 3104, 3811, 10662],
                       # Dragonscale (10656), Elemental (10658) and Tribal (10660) trainers: Peter Galen, Thorkaf
                       # Dragoneye; Sarah Tanner, Brumn Winterhoof; Caryssia Moonhunter, Se'Jib
                       "specTrainers": {7866: 10656, 7867: 10656, 7868: 10658, 7869: 10658, 7870: 10660, 7871: 10660},
                       # Tribal asks for the Wild Leather quests in Feralas first (Pratt McGrubben, Jangdor
                       # Swiftstrider), the last of them handed in at Telonis or Una
                       "guides": [
                           {"spec": 10656, "steps": [{"quests": [5141, 5145]}]},
                           {"spec": 10658, "steps": [{"quests": [5144, 5146]}]},
                           {"spec": 10660, "steps": [
                               {"quests": [2847, 2854]}, {"quests": [2848, 2855]}, {"quests": [2849, 2856]},
                               {"quests": [2850, 2857]}, {"quests": [2851, 2858]}, {"quests": [2852, 2859]},
                               {"quests": [2853, 2860], "note": "It gives you a letter to hand in."},
                               {"quests": [5143, 5148]}]}]},
    "alchemy": {"name": "Alchemy", "table": "ALCHEMY", "skillLine": 171, "plan": "recipe",
                "ranks": [2259, 3101, 3464, 11611]},
    "enchanting": {"name": "Enchanting", "table": "ENCHANTING", "skillLine": 333, "plan": "formula",
                   "ranks": [7411, 7412, 7413, 13920]},
    "engineering": {"name": "Engineering", "table": "ENGINEERING", "skillLine": 202, "plan": "schematic",
                    "ranks": [4036, 4037, 4038, 12656],
                    # CMaNGOS doesn't say which recipes need a specialization: these trainers teach only to theirs
                    "specTrainers": {7406: GNOMISH, 7944: GNOMISH, 8126: GOBLIN, 8738: GOBLIN},
                    # the first quest from any of its givers on your side, then the pledge (used from the bags)
                    "guides": [
                        {"spec": GNOMISH, "steps": [
                            {"quests": [3632, 3630, 3634, 3637, 3635]},
                            {"quests": [3640, 3642], "noItems": True,
                             "note": "Right-click the pledge it gives you: that completes it."},
                            {"quests": [3641, 3643]}]},
                        {"spec": GOBLIN, "steps": [
                            {"quests": [3629, 4181, 3633, 3526]},
                            {"quests": [3638], "noItems": True,
                             "note": "Right-click the pledge it gives you: that completes it."},
                            {"quests": [3639]}]}],
                    # a guessed recipe with one of these in its name is taken as needing that specialization
                    "specNames": {"Goblin": GOBLIN, "Gnomish": GNOMISH, "Dimensional Ripper": GOBLIN,
                                  "Ultrasafe Transporter": GNOMISH},
                    # build 1.60.1.70425 took the Tinkerbox and its schematics out of the client's items; the spells
                    # stayed, so without a plan they'd be guessed as a trainer's
                    "leaveOut": {s: n + ": the Tinkerbox and its schematics are gone from the client (1.60.1.70425)"
                                 for s, n in ((1226206, "Tinkerbox"), (1226207, "Tinkerbox: Teleport"),
                                              (1226208, "Tinkerbox: Nitro Boosts"),
                                              (1226209, "Tinkerbox: Magnetic Displacement"),
                                              (1226210, "Tinker: Teleport"), (1226211, "Tinker: Nitro Boosts"),
                                              (1226212, "Tinker: Magnetic Displacement"))}},
    # rogues only: no ranks (the cap is the level x 5), the skill from a class quest at 20, recipes from rogue trainers
    # at a level; one nobody is known to teach is left out (Season of Discovery's rune poisons, Forever's Occult
    # Poison II), as is Deadly Poison V (a book from Ruins of Ahn'Qiraj): the user's choice
    "poisons": {"name": "Poisons", "table": "POISONS", "skillLine": 40, "plan": "handbook", "ranks": [],
                "noGuess": True, "leaveOut": {25347: "Deadly Poison V: a book from Ruins of Ahn'Qiraj, not shown"},
                "learn": {"name": "Poisons", "how": "quest", "quest": {"A": 2359, "H": 2480}, "charLevel": 20,
                          "cap": 100, "learnAt": 0, "cost": 0},
                # the class quests that teach it (CMaNGOS's chains): Klaven's Tower, Hinott's Assistance
                "chains": {"A": [2360, 2359], "H": [2460, 2458, 2478, 2479, 2480]}},
    # a secondary profession whose ranks ask a character level (the Forever guide): Expert is a book, Artisan a quest
    # Dirge Quikcleave gives in Gadgetzan; Winter Veil's recipes are there only then (event)
    "cooking": {"name": "Cooking", "table": "COOKING", "skillLine": 185, "plan": "recipe",
                "ranks": [2550, 3102, {"how": "book", "item": 16072, "charLevel": 20},
                          {"how": "quest", "quest": {"A": 6610, "H": 6610}, "startQuests": {"A": 6612, "H": 6611},
                           "learnAt": 225, "charLevel": 35, "mats": {12207: 12, 7974: 10, 8932: 20},
                           "note": "Bring 12 Giant Egg, 10 Zesty Clam Meat and 20 Alterac Swiss to Dirge Quikcleave in"
                                   " Gadgetzan."}],
                "events": {21143: "Winter Veil", 21144: "Winter Veil"},
                "food": True,  # what eating a dish raises (its Well Fed), and the level it asks
                "leaveOut": {1255241: "Cleansing Stew: not learnable (skill 9999)",
                             818: "Basic Campfire (the old one): Forever teaches the Basic Campfire Kit instead"}},
    # a secondary profession: its trainer ranks ask no character level (CMaNGOS); Expert is a book, Artisan a quest
    "firstaid": {"name": "First Aid", "file": "FirstAid", "table": "FIRSTAID", "skillLine": 129, "plan": "book",
                 "secondary": True,
                 "ranks": [3273, 3274, {"how": "book", "item": 16084},
                           {"how": "quest", "quest": {"A": 6624, "H": 6622}, "learnAt": 225,
                            "note": "Save 15 wounded soldiers with the Triage Bandages the doctor gives you, before 6"
                                    " of them die."}],
                 "leaveOut": {30021: "Crystal Infused Bandage: a Burning Crusade recipe nothing in Forever teaches"}},
}


def fee_guess(learn, fees):
    """What trainers ask for other recipes learned within 25 points of `learn` (the middle one)."""
    near = [fee for skill, fee in fees if abs(skill - learn) <= 25]
    return int(statistics.median(near)) if near else None


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("profession", choices=sorted(PROFESSIONS))
    ap.add_argument("--refresh", action="store_true", help="download the client tables again")
    args = ap.parse_args()
    P = dict(PROFESSIONS[args.profession], key=args.profession)
    line = P["skillLine"]

    build = wago.latest_build()
    t = lambda name, b=build: wago.table(name, b, args.refresh)  # noqa: E731
    spell_names = {int(r["ID"]): r["Name_lang"] for r in t("SpellName")}
    abilities = {int(r["Spell"]): r for r in t("SkillLineAbility") if int(r["SkillLine"]) == line}
    reagents = {int(r["SpellID"]): r for r in t("SpellReagents")}
    makes, teaches, makes_zero, enchants = {}, defaultdict(set), set(), set()
    spell_effects = defaultdict(list)
    for r in t("SpellEffect"):
        if P.get("food"):
            spell_effects[int(r["SpellID"])].append(r)
        if r["Effect"] == "53":  # an enchantment (Enchant Bracer - Minor Stamina): makes no item
            enchants.add(int(r["SpellID"]))
        if r["Effect"] == "24" and int(r["EffectItemType"] or 0):
            count = int(float(r["EffectBasePointsF"] or 1))
            if count < 1:  # Forever's new recipes (SAF-T, EZ-Thro) list 0; the server makes at least one
                count = 1
                makes_zero.add(int(r["SpellID"]))
            makes[int(r["SpellID"])] = (int(r["EffectItemType"]), count)
        elif r["Effect"] == "36" and int(r["EffectTriggerSpell"] or 0):
            teaches[int(r["SpellID"])].add(int(r["EffectTriggerSpell"]))
    needs = defaultdict(set)  # recipe -> the tool kinds (TotemCategory) it needs
    for r in t("SpellTotems"):
        for k in ("RequiredTotemCategoryID_0", "RequiredTotemCategoryID_1"):
            if int(r[k] or 0):
                needs[int(r["SpellID"])].add(int(r[k]))
    kinds = {int(r["ID"]): r for r in t("TotemCategory")}
    cooldown = {}  # recipe -> seconds between crafts
    for r in t("SpellCooldowns"):
        wait = max(int(r["RecoveryTime"] or 0), int(r["CategoryRecoveryTime"] or 0)) // 1000
        if wait >= COOLDOWN_MIN:
            cooldown[int(r["SpellID"])] = wait
    sparse = {int(r["ID"]): r for r in t("ItemSparse")}
    icons = {int(r["SpellID"]): int(r["SpellIconFileDataID"] or 0) for r in t("SpellMisc")}
    crafts = lambda s: s in makes or s in enchants  # noqa: E731 - a recipe: makes an item or enchants one
    factions = {int(r["ID"]): r["Name_lang"] for r in t("Faction")}
    prices = wago.item_prices(build, args.refresh)  # {item: (vendor buy per unit, vendor sell)}
    qdb = QuestieDB()
    places = Places(qdb)
    items = {}

    def item_name(i):
        if i not in items:
            items[i] = (sparse[i]["Display_lang"] if i in sparse else None) or qdb.item(i).get(1) or ("item %d" % i)
        return items[i]

    # plans: an item whose effect teaches (or is) a recipe of the profession. The item may ask for the profession's
    # child skill line instead (Forever's 2942 "First Aid" under 129: most First Aid books)
    lines = {line} | {int(r["ID"]) for r in t("SkillLine") if int(r["ParentSkillLineID"] or 0) == line}
    effects = {int(r["ID"]): int(r["SpellID"]) for r in t("ItemEffect")}
    plan_of = {}
    for r in t("ItemXItemEffect"):
        item = int(r["ItemID"])
        if item not in sparse or int(sparse[item]["RequiredSkill"] or 0) not in lines:
            continue
        spell = effects.get(int(r["ItemEffectID"]))
        for s in ({spell} | teaches.get(spell, set())) if spell else ():
            if s in abilities and crafts(s):
                plan_of.setdefault(s, item)
    eaten = defaultdict(list)  # a dish -> the spells eating it casts
    for r in t("ItemXItemEffect") if P.get("food") else ():
        if int(r["ItemEffectID"]) in effects:
            eaten[int(r["ItemID"])].append(effects[int(r["ItemEffectID"])])

    def well_fed(item):
        """What eating a dish raises: {"str": 20, ...}. Forever's Nutritious Food raises its Well Fed by its own value
        (aura 227: Smoked Desert Dumplings 20 x 1 Strength); a Classic dish triggers a buff of its own (aura 23)."""
        out = defaultdict(float)
        for spell in eaten.get(item, ()):
            for r in spell_effects[spell]:
                aura, buff = int(r["EffectAura"] or 0), int(r["EffectTriggerSpell"] or 0)
                if aura not in (23, 227) or not buff:
                    continue
                for b in spell_effects[buff]:
                    a, misc = int(b["EffectAura"] or 0), int(b["EffectMiscValue_0"] or 0)
                    stat = WELL_FED_STATS.get(misc) if a == 29 else WELL_FED_AURAS.get(a) if a != 13 or misc & 126                         else None
                    if b["Effect"] == "6" and stat:
                        out[stat] += float(b["EffectBasePointsF"] or 0) * (float(r["EffectBasePointsF"] or 0)
                                                                          if aura == 227 else 1)
        return {k: int(v) for k, v in out.items() if v > 0}

    # trainers (CMaNGOS): recipe or rank spell -> (fee, skill, specialization), and who teaches it. Forever moved some
    # professions' colours down from Classic's (most Blacksmithing recipes by 25 points); a trainer's skill moves with
    # its recipe's yellow (Rough Bronze Leggings: Classic 105, yellow 145 -> 120 in Forever, so 80, as the Forever
    # guide has it).
    era = {int(r["Spell"]): r for r in wago.table("SkillLineAbility", ERA_BUILD, args.refresh)
           if int(r["SkillLine"]) == line}
    era_yellow = {s: int(r["TrivialSkillLineRankLow"]) for s, r in era.items()}
    era_teaches = {}
    for r in wago.table("SpellEffect", ERA_BUILD, args.refresh):
        if r["Effect"] == "36" and int(r["EffectTriggerSpell"] or 0):
            era_teaches[int(r["SpellID"])] = int(r["EffectTriggerSpell"])
    db = classicdb(False)
    by_template = defaultdict(list)
    for npc, tmpl in db["trainer_template_of"].items():
        by_template[tmpl].append(npc)
    trained, trainers, moved = {}, defaultdict(set), {}
    for table, who in (("npc_trainer", lambda e: [e]), ("npc_trainer_template", lambda e: by_template[e])):
        for r in db[table]:
            spell = era_teaches.get(int(r["spell"]), int(r["spell"]))
            if spell not in abilities:
                continue
            skill = int(r["reqskillvalue"])
            shift = era_yellow[spell] - int(abilities[spell]["TrivialSkillLineRankLow"]) \
                if crafts(spell) and era_yellow.get(spell, 0) > 0 else 0
            if shift:
                skill -= shift
                moved[spell] = int(r["reqskillvalue"])
            spec = int(r["ReqAbility1"]) if r["ReqAbility1"].isdigit() else 0
            trained[spell] = (int(r["spellcost"]), max(1, skill), spec, int(r["reqlevel"] or 0))
            trainers[spell].update(who(int(r["entry"])))
    spec_trainers = P.get("specTrainers", {})
    for spell, (fee, skill, spec, level) in list(trained.items()):
        by = {spec_trainers.get(n) for n in trainers[spell]}
        if not spec and len(by) == 1 and None not in by:
            trained[spell] = (fee, skill, by.pop(), level)
    # what trainers showed in game beats CMaNGOS (and the moved skills); a guessed recipe a trainer didn't list (though
    # it listed recipes of that skill and higher) isn't a trainer's
    seen, not_taught = set(), set()
    favor_seen, seen_fees = seen_in_game.favor(), seen_in_game.rank_fees()  # quartermasters' and ranks' prices
    att_favor = att.favor_costs()  # quartermasters' prices AllTheThings knows (the game's beat them)
    att_recipes, att_ways = att.recipes(P["key"]), att.sources()  # the recipes it lists, who sells or rewards what
    for spell, note in seen_in_game.trainer().items():
        if spell not in abilities:
            continue
        if note.get("notAtTrainer"):
            not_taught.add(spell)
        else:
            _, _, spec, level = trained.get(spell, (0, 0, 0, 0))
            trained[spell] = (note["cost"], max(1, note["skill"]), spec, level)
            moved.pop(spell, None)
            seen.add(spell)
    fees = [(skill, fee) for s, (fee, skill, _, _) in trained.items() if crafts(s)]
    quest_teaches = defaultdict(set)  # recipe -> Classic quests that teach it straight away (no plan to it)
    for s, qs in db["quest_spells"].items():
        quest_teaches[era_teaches.get(s, s)].update(qs)

    def plan_sources(plan, rec):
        """How a plan is had: vendors (with what they ask), quests, NPC drops, from QuestieDB and the game; from
        AllTheThings when QuestieDB knows none (Vayn Moongaze's patterns, the Lunar Festival's rockets: event = the
        holiday that way is had in)."""
        d, get = qdb.item(plan), []
        a = {} if any(d.get(k) for k in (2, 3, 6, 14)) else att_ways["items"].get(plan, {})
        cost = prices.get(plan, (0, 0))[0] or None
        seen_favor = favor_seen.get(plan, {})
        sellers = list(d.get(14) or a.get("vendor", ()))
        if seen_favor.get("npc") and seen_favor["npc"] not in sellers:  # the game beats QuestieDB's lists
            sellers.append(seen_favor["npc"])
        favor = seen_favor.get("cost") or att_favor.get(plan)  # seen in game, else AllTheThings' price
        for n in sellers:
            v = places.npc(n)
            g = {"kind": "vendor", "npc": n, "npcName": v["name"], "faction": v["faction"], "cost": cost,
                 "event": a.get("vendor", {}).get(n)}
            # a quartermaster sells for favor what a visit (or AllTheThings) prices so, or what has no gold price; for
            # silver what does (Aza'bek's Smoked Sagefish)
            if (n in FAVOR_VENDORS or n == seen_favor.get("npc")) and (favor or not cost):
                g["cost"], g["favor"] = None, favor or True
                if seen_favor.get("level"):
                    g["favorLevel"] = seen_favor["level"]
            elif not cost:  # no gold price in the client (Mount Hyjal's plans at 300): sold for something else
                g["otherCost"] = True
            get.append(g)
        for q in d.get(6) or sorted(a.get("quest", ())):
            e = places.quest(q)
            get.append({"kind": "quest", "quest": q, "questName": e["name"], "faction": e["faction"],
                        "reqLevel": e.get("reqLevel"), "event": a.get("quest", {}).get(q)})
        drops = len(d.get(2) or []) + len(d.get(3) or []) or len(a.get("drop", ()))
        if drops:
            get.append({"kind": "drop", "npcs": drops})
        p = sparse[plan]
        if int(p["MinFactionID"] or 0):
            f = int(p["MinFactionID"])
            rec["rep"] = {"faction": f, "standing": int(p["MinReputation"])}
            factions_used[f] = factions.get(f, "faction %d" % f)
        if int(p["RequiredAbility"] or 0):
            rec["spec"] = int(p["RequiredAbility"])
        plan_side = side(int(p["AllowableRace_0"] or 0))
        if plan_side != "AH":
            rec["faction"] = plan_side
        return get

    def other_rank(rank):
        """A rank no trainer teaches: a book (its vendors and price; learned at the skill it asks) or a quest by side."""
        if rank["how"] == "book":
            book = rank["item"]
            item_name(book)
            rank["learnAt"] = int(sparse[book]["RequiredSkillRank"] or 0)
            rank["vendors"] = [g for g in plan_sources(book, {}) if g["kind"] == "vendor"]
            rank["cost"] = min((g["cost"] for g in rank["vendors"] if g.get("cost")), default=None)
        else:
            for i in rank.get("mats", {}):  # what the quest asks you to bring (Cooking's Artisan: Alterac Swiss)
                item_name(i)
            for q in rank.get("startQuests", {}).values():  # the quest that sends you to its giver, by side
                places.quest(q)
            for q in rank["quest"].values():
                e = places.quest(q)
                rank["learnAt"] = e.get("skill") or rank["learnAt"]
                if e.get("reqLevel"):
                    rank["charLevel"] = e["reqLevel"]
        return rank

    factions_used, specs = {}, {}
    recipes, left_out, unreleased = {}, [], []
    # a plan a quartermaster sells for favor that the client's item data doesn't have (so no recipe knows it): named
    # here, to be matched by hand
    for item, f in sorted(favor_seen.items()):
        if item not in sparse and f.get("name", "").lower().startswith(P["plan"] + ":"):
            left_out.append("%s: sold for %d favor (seen in game), not in the client's item data"
                            % (f["name"], f["cost"]))
    for spell, a in sorted(abilities.items()):
        if not crafts(spell) or spell not in reagents:
            continue
        name = spell_names.get(spell, "spell %d" % spell)
        if spell in P.get("leaveOut", {}):
            left_out.append(P["leaveOut"][spell])
            continue
        yellow, grey = int(a["TrivialSkillLineRankLow"]), int(a["TrivialSkillLineRankHigh"])
        rec, get, learn = {"name": name}, [], None
        if a["AcquireMethod"] == "1":
            learn, get = 1, [{"kind": "start"}]
        if spell in trained:
            fee, skill, spec, level = trained[spell]
            learn = skill if learn is None else min(learn, skill)
            get.append({"kind": "trainer", "cost": fee, "level": level if level > 1 else None})  # character level
            if spec:
                rec["spec"] = spec
            if 0 < len(trainers[spell]) <= TRAINERS_LISTED:  # none: seen in game only, no one known by name
                rec["trainers"] = sorted(trainers[spell])
                for n in rec["trainers"]:
                    places.npc(n)
        plan = plan_of.get(spell)
        if plan:
            rec["item"] = plan
            item_name(plan)
            skill = int(sparse[plan]["RequiredSkillRank"] or 0) or yellow
            learn = skill if learn is None else min(learn, skill)
            get += plan_sources(plan, rec)
        if learn is None:  # a Classic quest that teaches it (Ornate Mithril): the quest is Forever's (QuestieDB)
            for q in sorted(quest_teaches.get(spell, ())):
                if qdb.quest(q).get(1):
                    e = places.quest(q)
                    get.append({"kind": "quest", "quest": q, "questName": e["name"], "faction": e["faction"],
                                "reqLevel": e.get("reqLevel"), "classic": True})
                    learn = min(learn or MAX_SKILL, e.get("skill") or yellow)
        if learn is None:  # a quest AllTheThings says teaches it (Camping 101, one in each starting zone)
            for q in sorted(att_ways["spells"].get(spell, ())):
                e = places.quest(q)
                get.append({"kind": "quest", "quest": q, "questName": e["name"], "faction": e["faction"],
                            "reqLevel": e.get("reqLevel")})
                learn = min(learn or MAX_SKILL, e.get("skill") or yellow)
        for g in get:  # a plan teaches it sooner than a trainer does (Slippers: pattern 140, trainer 150)
            if g["kind"] == "trainer" and trained[spell][1] > learn:
                g["skill"] = trained[spell][1]
        # not out in Forever yet (AllTheThings): only what the game showed is had, else its plan at the auction house
        if att_recipes and spell in att_recipes["unreleased"] and spell not in seen:
            get = [g for g in get if g.get("npc") and g["npc"] == favor_seen.get(plan, {}).get("npc")]
            rec.pop("trainers", None)
            if not get and not plan:
                left_out.append("%s: not out in Forever yet (AllTheThings), no %s to buy" % (name, P["plan"]))
                continue
            learn = int(sparse[plan]["RequiredSkillRank"] or 0) or yellow
            unreleased.append(name)
        if spell in moved:
            rec["classicSkill"] = moved[spell]  # the trainer's skill is worked out from Classic's, not seen
        if learn is None and P.get("noGuess"):
            left_out.append("%s: nothing is known to teach it" % name)
            continue
        if learn is None and not grey:  # First Aid Kit (camping): nothing to guess from
            left_out.append("%s: no colours (gives no skill) and nothing is known to teach it" % name)
            continue
        if learn is None and spell in not_taught:  # no source left: the auction house can't sell it either (no item)
            left_out.append("%s: not at the trainer (seen in game), nothing else is known to teach it" % name)
            continue
        if learn is None and att_recipes and spell not in att_recipes["known"]:  # Season of Discovery's, ...
            left_out.append("%s: nothing is known to teach it, AllTheThings doesn't list it either" % name)
            continue
        if learn is None:
            learn = max(1, yellow - GUESS_BELOW_YELLOW)
            get = [{"kind": "trainer", "cost": fee_guess(learn, fees), "costGuess": True}]
            rec["guess"] = True  # the skill it's learned at, and that a trainer teaches it at all
            for word, spec in P.get("specNames", {}).items():
                if word in name:
                    rec["spec"], rec["specGuess"] = spec, True
        if learn > MAX_SKILL:
            left_out.append("%s: learned at %d, past %d" % (name, learn, MAX_SKILL))
            continue
        if rec.get("spec"):
            specs[rec["spec"]] = spell_names.get(rec["spec"], "spell %d" % rec["spec"])
        item, count = makes.get(spell, (None, 1))
        mats = {}
        for i in range(8):
            reagent = int(reagents[spell]["Reagent_%d" % i])
            if reagent:
                mats[reagent] = int(reagents[spell]["ReagentCount_%d" % i])
                item_name(reagent)
        rec.update(learn=learn, colors=[learn, yellow, (yellow + grey) // 2, grey])
        if item:
            item_name(item)
            rec["makes"] = item
            buff = well_fed(item) if P.get("food") else None
            if buff:
                rec["buff"], rec["eat"] = buff, int(sparse[item]["RequiredLevel"] or 0) if item in sparse else 0
        rec.update(mats=mats, get=get)
        if not item:
            rec["icon"] = icons.get(spell)  # an enchantment: the spell's icon stands for it
        if count != 1:
            rec["yield"] = count
        if needs.get(spell):
            rec["tools"] = sorted(needs[spell])
        if spell in cooldown:
            rec["cooldown"] = cooldown[spell]
        if spell in P.get("events", {}):
            rec["event"] = P["events"][spell]  # a holiday's: not for leveling the rest of the year
        if spell > 1000000:
            rec["forever"] = True  # new in Forever
        recipes[spell] = rec

    # a second version of a recipe (Season of Discovery's, in Forever's client too: same name, another item) that
    # nothing is known to teach, beside one that something does teach: the trainer teaches that one, not this
    sourced = {r["name"] for r in recipes.values() if not r.get("guess")}
    twins = []
    for r in recipes.values():
        if r.get("guess") and r["name"] in sourced:
            for k in ("guess", "spec", "specGuess"):
                r.pop(k, None)
            r["get"], r["twin"] = [], True
            twins.append(r["name"])

    # tools: every item of a kind the recipes need (or of a kind that covers it: a Gnomish Army Knife is a hammer and
    # a spanner too), the one vendors sell, else the recipe that makes one
    def covers(kind, need):
        a, b = kinds[kind], kinds[need]
        mask = int(b["TotemCategoryMask"])
        return a["TotemCategoryType"] == b["TotemCategoryType"] and int(a["TotemCategoryMask"]) & mask == mask

    tool_kinds = {}
    for need in sorted({k for r in recipes.values() for k in r.get("tools", ())}):
        tk = {"name": kinds[need]["Name_lang"],
              "items": sorted(i for i, r in sparse.items() if int(r["TotemCategoryID"] or 0) in kinds
                              and covers(int(r["TotemCategoryID"]), need))}
        sold = [i for i in tk["items"] if qdb.item(i).get(14) and prices.get(i, (0, 0))[0] > 0]
        if sold:
            tk["buy"] = min(sold, key=lambda i: prices[i][0])
        else:
            made = [s for s, r in recipes.items() if r.get("makes") in tk["items"]]
            if made:
                tk["make"] = min(made, key=lambda s: recipes[s]["learn"])
        for i in tk["items"]:
            item_name(i)
        tool_kinds[need] = tk

    # ranks: trainer fees and skills (CMaNGOS); the trainers who teach Expert and Artisan
    ranks = []
    for spell, (rank_name, cap, char_level) in zip(P["ranks"], RANK_NAMES):
        if isinstance(spell, dict):  # First Aid: Expert from a book, Artisan from a quest
            ranks.append(other_rank(dict(name=rank_name, cap=cap, **spell)))
            continue
        rank = {"name": rank_name, "cap": cap, "spell": spell, "how": "trainer"}
        if char_level and not P.get("secondary"):
            rank["charLevel"] = char_level
        fee, skill, _, _ = trained.get(spell, (None, 0, 0, 0))
        fee = seen_fees.get(spell, fee)  # what a trainer asked in game beats CMaNGOS's
        rank.update(cost=fee, learnAt=0 if rank_name == "Apprentice" else skill)
        who = sorted(trainers.get(spell, ()))
        if rank_name in ("Expert", "Artisan") and who:
            rank["trainers"] = who
            for n in who:
                places.npc(n)
        ranks.append(rank)
    if len(ranks) > 1:
        ranks[1]["learnAt"] = ranks[1]["learnAt"] or 50
    if P.get("learn"):  # learned from a quest (Poisons): its cap is the level's, set in game
        ranks.append(dict(P["learn"]))
    for qs in P.get("chains", {}).values():
        for q in qs:
            places.quest(q)

    # specializations: the steps to each (P["guides"]), with how many of each item their quests ask (CMaNGOS: QuestieDB
    # names the items, not how many) and who drops the ones no recipe makes
    made = {r["makes"] for r in recipes.values() if r.get("makes")}
    guide_npcs, areas = set(), {}

    def area_names():
        if not areas:
            areas.update({int(r["ID"]): r["AreaName_lang"] for r in t("AreaTable")})
        return areas

    def first_npc(v):
        """The first NPC of QuestieDB's [[npcs], [objects], ...] (a map when the lists ahead are empty)."""
        if isinstance(v, dict):
            v = [v.get(k) for k in (1, 2, 3)]
        return ((v or [None])[0] or [None])[0]

    def guide_step(qs, items=True):
        """A step of quests, any one of them (each side's own, or several givers); an ender = who it's handed in to."""
        step, asks = {"quests": qs}, None
        for q in qs:
            e = places.quest(q)
            ender = first_npc(qdb.quest(q).get(3))
            if ender and ender != e.get("giver"):
                e.update(ender=ender, enderName=places.npc(ender)["name"])
                guide_npcs.add(ender)
            got = db["quest_items"].get(q, []) if items else []
            if asks is not None and got != asks:
                raise ValueError("quest %d asks for other items than quest %d" % (q, qs[0]))
            asks = got
        if items and asks:
            step["items"] = []
            for item, count in asks:
                item_name(item)
                x, drops = {"item": item, "n": count}, [] if item in made else qdb.item(item).get(2) or []
                if len(drops) > 3:
                    x["dropsN"] = len(drops)
                elif drops:
                    x["drops"] = drops
                    for n in drops:
                        v = places.npc(n)
                        if v.get("x") == -1:  # in a dungeon: QuestieDB has no place on a map, the client names it
                            del v["x"], v["y"]
                            v["zone"] = area_names().get(qdb.npc(n).get(9))
                    guide_npcs.update(drops)
                step["items"].append(x)
        return step

    spec_guides = []
    for g in P.get("guides", ()):
        steps = []
        for s in g["steps"]:
            if "talk" in s:
                step = {"talk": s["talk"]}
                for n in s["talk"]:
                    places.npc(n)
                guide_npcs.update(s["talk"])
            elif "pick" in s:  # one of several masteries
                step = {"pick": [dict(guide_step([q]), spec=spec) for spec, q in s["pick"]]}
                for spec, _ in s["pick"]:
                    specs[spec] = spell_names.get(spec, "spell %d" % spec)
            else:
                step = guide_step(s["quests"], not s.get("noItems"))
            if s.get("note"):
                step["note"] = s["note"]
            steps.append(step)
        specs[g["spec"]] = spell_names.get(g["spec"], "spell %d" % g["spec"])
        grant = places.quest(db["quest_spells"][g["spec"]][0])  # the quest that teaches it: the level and skill
        guide = {"spec": g["spec"], "icon": icons.get(g["spec"]), "level": grant.get("reqLevel"),
                 "skill": grant.get("skill"), "note": g.get("note"), "steps": steps}
        spec_guides.append(guide)

    # reagents (and tools) vendors always have: their price, by the side the vendors are on. Always: some Classic
    # vendor (CMaNGOS) has it without a limit; for one Classic vendors don't sell, at least VENDOR_MIN vendors sell it
    vendor_prices, sell, limited = {}, {}, []
    used = {i for r in recipes.values() for i in r["mats"]} | {COAL} | {
        tk["buy"] for tk in tool_kinds.values() if tk.get("buy")} | {i for rk in ranks for i in rk.get("mats", {})}
    for i in sorted(used):
        sellers = [n for n in qdb.item(i).get(14) or [] if n not in BOTS]
        always = db["vendor_stock"].get(i)
        if always is None:
            always = len(sellers) >= VENDOR_MIN
        elif not always and sellers:
            limited.append(item_name(i))
        if sellers and always and prices.get(i, (0, 0))[0] > 0:
            sides = {places.npc(n)["faction"] for n in sellers}
            vendor_prices[i] = {f: prices[i][0] for f in "AH" if any(f in s for s in sides)}
    for i in used | {r["makes"] for r in recipes.values() if r.get("makes")}:
        if prices.get(i, (0, 0))[1] > 0:
            sell[i] = prices[i][1]
    item_name(COAL)

    named = {g["npc"] for r in recipes.values() for g in r["get"] if g.get("npc")}
    named |= {n for r in list(recipes.values()) + ranks for n in r.get("trainers", ())}
    named |= {g["npc"] for r in ranks for g in r.get("vendors", ())}
    named |= {q["giver"] for q in places.quests.values() if q.get("giver")} | guide_npcs
    npcs = {n: v for n, v in places.npcs.items() if n in named}  # reagent sellers only told the builder a side

    built = datetime.date.today().isoformat()
    data = {"P": P, "built": built, "build": build, "ranks": ranks, "recipes": recipes, "npcs": npcs,
            "quests": places.quests, "vendorPrices": vendor_prices, "sell": sell, "items": items,
            "factions": factions_used, "specs": specs, "moved": moved, "seen": seen, "toolKinds": tool_kinds,
            "makesZero": sorted(recipes[s]["name"] for s in makes_zero if s in recipes), "limited": limited,
            "twins": sorted(twins), "unreleased": sorted(unreleased), "specGuides": spec_guides}
    write_lua(data)
    write_report(data, left_out)
    how = Counter(source_kind(r) for r in recipes.values())
    print("%s.lua: %d recipes (%s), %d NPCs, %d quests, %d reagents at vendors, Forever build %s" % (
        P["name"], len(recipes), ", ".join("%d %s" % (n, k) for k, n in how.most_common()), len(npcs),
        len(places.quests), len(vendor_prices), build))


def source_kind(rec):
    """One word for how a recipe is learned, for the summary."""
    kinds = {g["kind"] for g in rec["get"]}
    if "start" in kinds:
        return "start"
    if rec.get("guess"):
        return "guessed trainer"
    if "trainer" in kinds:
        return "trainer"
    for k in ("vendor", "quest", "drop"):
        if k in kinds:
            return "plan: " + k
    return "plan: auction house only"


def write_lua(d):
    P = d["P"]
    lines = [
        "-- Craft Ladder: %s data for WoW Forever." % P["name"],
        "-- GENERATED by tools/build_crafting.py on %s - don't edit by hand; fix the builder and rebuild." % d["built"],
        "-- Recipes, colours, reagents, tools, %ss, reputation and specializations: the Forever client's tables" % P["plan"],
        "-- (build %s). Trainer fees and skills: CMaNGOS classic-db, or what a trainer showed in game." % d["build"],
        "-- Who sells a %s or a reagent, quests, drops, NPCs: QuestieDB. colors = skill where a recipe turns" % P["plan"],
        "-- { orange, yellow, green, grey }. get = how to learn it: start, trainer (cost), vendor (npc, cost; favor = its",
        "-- Merchant's Favor price, true = not known; otherCost = no gold price: sold for something else, not counted), quest,",
        "-- drop (npcs = how many drop it); a vendor's or quest's event = the holiday it's had in (not for leveling);",
        "-- a trainer's skill = it teaches it later than the plan does; a quest's",
        "-- classic = what it teaches is Classic's (CMaNGOS). classicSkill = the trainer's skill worked out from Classic's",
        "-- (moved as Forever moved the colours), not seen in game. guess = a trainer is assumed to teach",
        "-- it at yellow - 15 for a guessed fee (costGuess). item = its %s; rep = { faction, standing } it needs;" % P["plan"],
        "-- makes = the item it makes (none: an enchantment; icon = its spell's icon); spec = the specialization (spell) it",
        "-- needs (specGuess: taken from its name); trainers = the only trainers that teach it; tools = the tool kinds it needs;",
        "-- cooldown = seconds between crafts (not for leveling); twin = a second version nothing is known to teach;",
        "-- buff = what eating the dish raises (str, agi, sta, int, spi, spell damage, heal(ing), ap, rap: ranged attack",
        "-- power; Forever's Well Fed, read from the client, not seen in game); eat = the level the dish asks;",
        "-- (toolKinds: the items of each, the one vendors sell or the recipe that makes one); forever = new in Forever.",
        "-- sell = what a vendor pays. vendorPrices = reagents always sold by vendors (by side). Costs are copper.",
        "local _, ns = ...",
        "",
        "ns.%s = {" % P["table"],
        "  built = %s," % lua(d["built"]),
        "  ranks = {",
    ]
    for r in d["ranks"]:
        lines.append("    %s," % lua({k: v for k, v in r.items() if v is not None}))
    lines.append("  },")
    lines.append("  toolKinds = {")
    for k, v in sorted(d["toolKinds"].items()):
        lines.append("    [%d] = %s," % (k, lua(v)))
    lines.append("  },")
    lines.append("  recipes = {")
    for sid, r in sorted(d["recipes"].items(), key=lambda kv: (kv[1]["learn"], kv[1]["name"])):
        r = dict(r, get=[{k: v for k, v in g.items() if v is not None} for g in r["get"]])
        lines.append("    [%d] = %s," % (sid, lua(r)))
    lines.append("  },")
    for name in ("npcs", "quests", "vendorPrices", "sell", "factions", "specs", "items"):
        lines.append("  %s = {" % name)
        for k, v in sorted(d[name].items()):
            lines.append("    [%d] = %s," % (int(k), lua({x: y for x, y in v.items() if y is not None}
                                                          if isinstance(v, dict) else v)))
        lines.append("  },")
    if P.get("chains"):  # the class quests that teach it, by side
        lines.append("  chains = { %s }," % ", ".join("%s = %s" % (k, lua(v)) for k, v in sorted(P["chains"].items())))
    if d["specGuides"]:
        lines += ["  -- the steps to each specialization (spec, its icon, the level and skill its quest asks): talk = NPCs",
                  "  -- (one a side), quests = any one of them on your side (items = n of an item it asks; drops = the",
                  "  -- NPCs that drop it, dropsN = how many do), pick = one of several masteries (spec). A quest's",
                  "  -- ender = who it's handed in to, when that isn't its giver.",
                  "  specGuides = {"]
        for g in d["specGuides"]:
            lines.append("    { %s," % ", ".join("%s = %s" % (k, lua(v)) for k, v in g.items()
                                                 if k != "steps" and v is not None))
            lines.append("      steps = {")
            lines += ["        %s," % lua(s) for s in g["steps"]]
            lines.append("      } },")
        lines.append("  },")
    lines.append("}")
    (ROOT / "CraftLadder" / "Data" / ("%s.lua" % P.get("file", P["name"]))).write_text("\n".join(lines) + "\n", encoding="utf-8")


def write_report(d, left_out):
    P, recipes, items, tool_kinds = d["P"], d["recipes"], d["items"], d["toolKinds"]
    plan = P["plan"]

    def source(rec):
        parts = []
        for g in rec["get"]:
            k = g["kind"]
            if k == "start":
                parts.append("known from the start")
            elif k == "trainer":
                parts.append("trainer %s%s" % (money(g.get("cost")), " (guess)" if g.get("costGuess") else ""))
            elif k == "vendor":
                parts.append("%s (%s) %s" % (g["npcName"], g["faction"],
                                             "Merchant's Favor" if g.get("favor") else "not for gold"
                                             if g.get("otherCost") else money(g.get("cost"))))
            elif k == "quest":
                parts.append("quest %s (%s)%s" % (g["questName"], g["faction"],
                                                  ", its reward Classic's" if g.get("classic") else ""))
            if g.get("event"):
                parts[-1] += ", %s only" % g["event"]
            if g.get("skill"):
                parts[-1] += " from %d" % g["skill"]
            elif k == "drop":
                parts.append("drops (%d)" % g["npcs"])
        if rec.get("item") and not parts:
            parts.append("%s: auction house only" % plan)
        return "; ".join(parts)

    def notes(rec):
        out = []
        if rec.get("rep"):
            out.append("%s %s" % (d["factions"][rec["rep"]["faction"]], STANDING[rec["rep"]["standing"]]))
        if rec.get("spec"):
            out.append(d["specs"][rec["spec"]] + (" (guess)" if rec.get("specGuess") else ""))
        out += [tool_kinds[k]["name"] for k in rec.get("tools", ())]
        if rec.get("yield"):
            out.append("makes %d" % rec["yield"])
        if rec.get("cooldown"):
            out.append("once every %d h" % (rec["cooldown"] // 3600))
        if rec.get("twin"):
            out.append("second version, not taught")
        if rec.get("forever"):
            out.append("new")
        return ", ".join(out)

    how = Counter(source_kind(r) for r in recipes.values())
    out = ["# %s data report" % P["name"], "",
           "Built %s by `tools/build_crafting.py %s`. %d recipes up to %d (%d new in Forever), %d NPCs, %d quests;"
           " Forever build %s." % (d["built"], P["key"], len(recipes), MAX_SKILL,
                                   sum(1 for r in recipes.values() if r.get("forever")), len(d["npcs"]),
                                   len(d["quests"]), d["build"]), "",
           "How they're learned: " + ", ".join("%d %s" % (n, k) for k, n in how.most_common()) + ".",
           "%d need reputation, %d a specialization, %d no tool." % (
               sum(1 for r in recipes.values() if r.get("rep")), sum(1 for r in recipes.values() if r.get("spec")),
               sum(1 for r in recipes.values() if not r.get("tools"))), "", "## Ranks", ""]
    for r in d["ranks"]:
        who = ", ".join("%s (%s, %s)" % (d["npcs"][n]["name"], d["npcs"][n]["faction"], d["npcs"][n].get("zone", "?"))
                        for n in r.get("trainers", []))
        how = ("quests %s" % ", ".join("%s: %s" % (k, d["quests"][q]["name"]) for k, q in sorted(r["quest"].items()))
               if r["how"] == "quest" else "book %s, %s" % (items[r["item"]], money(r.get("cost")))
               if r["how"] == "book" else "trainer %s" % money(r.get("cost")))
        out.append("- %s (cap %d): at %d%s, %s%s" % (r["name"], r["cap"], r["learnAt"],
                   (", level %d" % r["charLevel"]) if r.get("charLevel") else "", how, (" - " + who) if who else ""))
    out += ["", "## Tools", ""]
    for k, tk in sorted(tool_kinds.items()):
        n = sum(1 for r in recipes.values() if k in r.get("tools", ()))
        got = ("bought: %s" % items[tk["buy"]]) if tk.get("buy") else (
            "made: %s (learned at %d)" % (recipes[tk["make"]]["name"], recipes[tk["make"]]["learn"])
            if tk.get("make") else "no source")
        out.append("- %s, needed by %d recipes; %s; counts: %s" % (tk["name"], n, got,
                                                                  ", ".join(items[i] for i in tk["items"])))
    out += ["", "## Reagents vendors always sell", ""]
    for i, p in sorted(d["vendorPrices"].items(), key=lambda kv: items[kv[0]]):
        out.append("- %s: %s (%s)" % (items[i], money(max(p.values())), "/".join(sorted(p))))
    out += ["", "## Recipes", "", "| Learn at | Recipe | Colours | Reagents | How to learn | Notes |",
            "|---|---|---|---|---|---|"]
    for sid, r in sorted(recipes.items(), key=lambda kv: (kv[1]["learn"], kv[1]["name"])):
        out.append("| %s | %s | %s | %s | %s | %s |" % (
            ("~%d (guess)" % r["learn"]) if r.get("guess") else ("%d (seen)" % r["learn"]) if sid in d["seen"] else (
                "%d (Classic %d)" % (r["learn"], d["moved"][sid]) if d["moved"].get(sid, r["learn"]) != r["learn"]
                else r["learn"]),
            r["name"], "/".join(map(str, r["colors"])),
            ", ".join("%d %s" % (n, items[i]) for i, n in r["mats"].items()), source(r), notes(r)))
    guessed = sorted((r["learn"], r["name"], g.get("cost"), d["specs"].get(r.get("spec")) if r.get("specGuess") else None)
                     for r in recipes.values() if r.get("guess") for g in r["get"] if g.get("costGuess"))
    out += ["", "## Guesses (to check against the real game; see ASSUMPTIONS.md)", "",
            "- %d recipes nothing is known to teach, taken as a trainer's at yellow - %d for a fee like others of that"
            " skill (a trainer visit in game corrects them, or drops the ones it doesn't list):" % (
                len(guessed), GUESS_BELOW_YELLOW)]
    out += ["  - %s: ~%d, %s%s" % (name, learn, money(cost), (", needs " + spec) if spec else "")
            for learn, name, cost, spec in guessed]
    if P.get("specNames"):
        out.append("- A guessed recipe with %s in its name is taken as needing that specialization (marked above)." %
                   ", ".join('"%s"' % w for w in P["specNames"]))
    if P.get("specTrainers"):
        out.append("- Recipes taught only by the specialization trainers (%s) need that specialization: CMaNGOS doesn't"
                   " say so itself." % ", ".join("%s: %s" % (d["npcs"][n]["name"] if n in d["npcs"] else n,
                                                             d["specs"].get(s, s))
                                                for n, s in sorted(P["specTrainers"].items())))
    if d["moved"]:
        out.append("- %d trainer skills moved down from Classic's (CMaNGOS) by how far Forever moved the recipe's"
                   " yellow; marked \"(Classic N)\" above." % len(d["moved"]))
    if d["seen"]:
        out.append("- %d trainer skills and fees are what a trainer showed in game (tools/seen_in_game.json); marked"
                   " \"(seen)\" above." % len(d["seen"]))
    if d["twins"]:
        out.append("- %d second versions of recipes (same name, another item; most from Season of Discovery) that nothing"
                   " is known to teach, beside a version something does teach, aren't guessed as a trainer's: %s." % (
                       len(d["twins"]), ", ".join(d["twins"])))
    if d["unreleased"]:
        out.append("- %d recipes AllTheThings holds as not out in Forever yet: their %ss only from the auction house,"
                   " whatever QuestieDB or CMaNGOS say sells, rewards or drops them: %s." % (
                       len(d["unreleased"]), plan, ", ".join(d["unreleased"])))
    cooled = sorted("%s (%d h)" % (r["name"], r["cooldown"] // 3600) for r in recipes.values() if r.get("cooldown"))
    if cooled:
        out.append("- Recipes with a cooldown, kept out of leveling (Gold lists them): " + ", ".join(cooled) + ".")
    if d["makesZero"]:
        out.append("- %d recipes the client says make 0 are taken as making 1 (the server makes at least one): %s." % (
            len(d["makesZero"]), ", ".join(d["makesZero"])))
    out.append("- %d %ss have no known seller, quest or drop: learned only from the auction house." % (
        sum(1 for r in recipes.values() if r.get("item") and not r["get"]), plan))
    if not P.get("secondary"):
        out.append("- Rank fees and the Expert and Artisan trainers are Classic's (CMaNGOS); the Forever guide says"
                   " Expert costs 50s.")
    out += ["- A reagent counts as always sold by vendors when a Classic vendor (CMaNGOS) has it without a limit, or,"
            " for one Classic vendors don't sell, when %d or more vendors sell it (QuestieDB doesn't say which stock is"
            " limited); engineers' bots don't count." % VENDOR_MIN]
    if d["limited"]:
        out.append("- Sold only a few at a time (CMaNGOS), so priced at the auction house: " + ", ".join(d["limited"]) + ".")
    if left_out:
        out += ["", "## Left out", ""] + ["- " + x for x in left_out]
    (TOOLS / ("%sReport.md" % P.get("file", P["name"]))).write_text("\n".join(out) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
