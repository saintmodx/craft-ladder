"""Build CraftLadder/Data/Camp.lua: WoW Forever's camps, from the client's own tables (wago.tools, newest build).

A campfire holds a number of camp features; sitting or crafting near it gives each feature's buff. Each feature is an
item a profession makes (Mining, Herbalism, Fishing and Skinning too). Everything here is the client's:
  - ItemSparse: the items (279940-279990) and their names; ItemEffect, ItemXItemEffect: the spell an item casts.
  - Spell: that spell's description, which says what the feature gives, by the player's level ($?$PL<24[6]...),
    what it doesn't stack with, and which feature an upgrade stands for ("provides all of the benefits of a ...").
  - SpellEffect: the numbers the descriptions point at ($1230172s1), and the campfires' slots ($s1).
  - SpellEffect (create item), SkillLineAbility, SkillLine, SpellReagents: the recipe that makes each item, its
    profession and what it takes.
Nothing comes from other addons.

    python -I tools/build_camp.py [--refresh]
"""
import argparse
import datetime
import re
import sys
from pathlib import Path

TOOLS = Path(__file__).resolve().parent
ROOT = TOOLS.parent
sys.path.insert(0, str(TOOLS))
import wago  # noqa: E402
from build_data import lua  # noqa: E402

OUT_LUA = ROOT / "CraftLadder" / "Data" / "Camp.lua"
FIRST, LAST = 279940, 279990  # the camp items' ids
MAX_LEVEL = 60
FIRES = (279981, 279961, 279974)  # Basic, Journeyman, Expert Campfire Kit
# what a feature's buff is, from words in what it gives (the order matters: "Attack Power" before "Strength"...)
KINDS = (("Attack Power", "ap"), ("Strength", "str"), ("Mana every", "mp5"), ("Intellect", "int"),
         ("% stats", "stats"), ("Stamina", "sta"), ("Spirit", "spi"), ("Armor", "armor"), ("Rested", "rested"),
         ("critical strike", "crit"), ("reagents", "vendor"))
PROFESSIONS = {"First Aid": "firstaid"}  # a skill line's name -> our profession key (else its name in lower case)


def effects(rows):
    out = {}
    for e in rows:
        out.setdefault(int(e["SpellID"]), {})[int(e["EffectIndex"])] = e
    return out


def resolve(text, spell, level, eff, dur):
    """The description as the game shows it to a player of `level`: $?$PL<N[a]?$PL>M[b][c] picked, $123s1 and $s1
    replaced by the effect's number."""
    def points(s, i):
        e = eff.get(s, {}).get(i - 1)
        return str(int(float(e["EffectBasePointsF"]))) if e else "?"

    out, i = [], 0
    while i < len(text):
        if text.startswith("$?", i):
            i += 2
            chosen = None
            while True:
                m = re.match(r"\$PL([<>])(\d+)\[([^\]]*)\]", text[i:])
                if not m:
                    break
                n = int(m.group(2))
                if chosen is None and (level < n if m.group(1) == "<" else level > n):
                    chosen = m.group(3)
                i += m.end()
                if text.startswith("?", i):
                    i += 1
                    continue
                if text.startswith("[", i):  # the "else"
                    j = text.index("]", i)
                    if chosen is None:
                        chosen = text[i + 1:j]
                    i = j + 1
                break
            out.append(resolve(chosen or "", spell, level, eff, dur))
            continue
        m = re.match(r"\$(\d*)s(\d)", text[i:])
        if m:
            out.append(points(int(m.group(1)) if m.group(1) else spell, int(m.group(2))))
            i += m.end()
            continue
        m = re.match(r"\$(\d+)d", text[i:])
        if m:
            out.append(duration(dur.get(int(m.group(1)), 0)))
            i += m.end()
            continue
        out.append(text[i])
        i += 1
    return "".join(out)


def duration(ms):
    """A spell's duration as its tooltip says it: "1 hour", "30 min"."""
    s = ms // 1000
    if s >= 3600 and s % 3600 == 0:
        return "%d hour%s" % (s // 3600, "" if s == 3600 else "s")
    if s >= 60:
        return "%d min" % (s // 60)
    return "%d sec" % s


def benefit(desc):
    """What a feature gives, short ("+11 Strength"), and what it doesn't stack with, from its resolved description."""
    first = desc.split("\n\n")[0]
    m = re.search(r"nearby (?:to )?(.*?)(?:, mutually exclusive with (.*?))?\.(?:\s|$)", first)
    if not m:
        return None, None
    s = re.sub(r"\s+", " ", m.group(1)).strip()
    s = re.sub(r"^gain ", "", s)
    s = re.sub(r"^regenerate (\d+)", r"+\1", s)
    s = re.sub(r"(\d+%?) increased ", r"+\1 ", s)
    s = re.sub(r"(\d+) increase to all ", r"+\1 all ", s)
    s = re.sub(r"(?<![+\d])(\d+) Armor", r"+\1 Armor", s)
    s = re.sub(r"^increase Rested experience to", "Rested experience up to", s)
    return s[0].upper() + s[1:], m.group(2)


def extra(desc, name):
    """What an upgrade (or a feature with no buff) adds, from its first sentence: "contains healing potions"."""
    s = re.sub(r"\s+", " ", desc.split("\n\n")[0]).strip()
    s = re.split(r"(?<=\.) ", s)[0].rstrip(".")
    s = re.sub(r",? and provides all (?:of )?the benefits of an? [^.,]+", "", s)
    s = re.sub(r"^\w+(?: out)? (?:an? )?" + re.escape(name) + r"(?: that)?,? ?", "", s, flags=re.I)
    return (s[0].upper() + s[1:]) if s else ""


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--refresh", action="store_true", help="download the client's tables again")
    args = ap.parse_args()
    build = wago.latest_build()

    def table(name):
        return wago.table(name, build, args.refresh)

    names = {int(r["ID"]): r["Display_lang"] for r in table("ItemSparse")}
    item_effect = {r["ID"]: r for r in table("ItemEffect")}
    casts = {}
    for r in table("ItemXItemEffect"):
        item = int(r["ItemID"])
        if FIRST <= item <= LAST:
            casts[item] = int(item_effect[r["ItemEffectID"]]["SpellID"])
    desc = {int(r["ID"]): r["Description_lang"] for r in table("Spell")}
    lengths = {r["ID"]: int(r["Duration"] or 0) for r in table("SpellDuration")}
    dur = {int(r["SpellID"]): lengths.get(r["DurationIndex"], 0) for r in table("SpellMisc")}
    spell_names = {int(r["ID"]): r["Name_lang"] for r in table("SpellName")}
    eff = effects(table("SpellEffect"))
    makers = {}
    for s, es in eff.items():
        for e in es.values():
            if e["Effect"] == "24" and e["EffectItemType"] and FIRST <= int(e["EffectItemType"]) <= LAST:
                makers[int(e["EffectItemType"])] = s
    skill_of = {int(r["Spell"]): r["SkillLine"] for r in table("SkillLineAbility")}
    skill_names = {r["ID"]: r["DisplayName_lang"] for r in table("SkillLine")}
    reagents = {}
    for r in table("SpellReagents"):
        mats = {}
        for k in range(8):
            item, n = int(r.get("Reagent_%d" % k) or 0), int(r.get("ReagentCount_%d" % k) or 0)
            if item and n:
                mats[item] = n
        reagents[int(r["SpellID"])] = mats

    used = set()

    def entry(item):
        maker = makers.get(item)
        prof = skill_names.get(skill_of.get(maker))
        e = {"item": item, "spell": casts[item], "name": names[item]}
        if maker:
            e["maker"] = maker
            e["prof"] = PROFESSIONS.get(prof, (prof or "").lower())
            e["mats"] = reagents.get(maker, {})
            used.update(e["mats"])
        used.add(item)
        return e

    fires, features, upgrades, others = [], [], [], []
    for item in FIRES:
        e = entry(item)
        e["name"] = e["name"].replace(" Kit", "")  # Basic Campfire Kit: Basic Campfire
        e["slots"] = int(float(eff[e["spell"]][0]["EffectBasePointsF"]))
        fires.append(e)
    for item in sorted(casts):
        if item in FIRES or not desc.get(casts[item]):
            continue
        d = desc[casts[item]]
        e = entry(item)
        base = re.search(r"benefits of an? ([^.,]+)|placed over an? (.+?) to replace", d)
        if base:
            e["base"] = (base.group(1) or base.group(2)).strip()
            e["adds"] = extra(resolve(d, e["spell"], MAX_LEVEL, eff, dur), e["name"])
            upgrades.append(e)
            continue
        brackets, exclusive = [], None
        for level in range(1, MAX_LEVEL + 1):
            text, exclusive = benefit(resolve(d, e["spell"], level, eff, dur))
            if text is None:
                break
            if brackets and brackets[-1][1] == text:
                brackets[-1][0] = level
            else:
                brackets.append([level, text])
        if not brackets:
            e["adds"] = extra(resolve(d, e["spell"], MAX_LEVEL, eff, dur), e["name"])
            others.append(e)
            continue
        e["kind"] = next(k for word, k in KINDS if word in brackets[-1][1])
        e["gives"] = brackets  # { up to this level, what it gives }
        if exclusive:
            e["exclusive"] = exclusive
        side = re.search(r"members of the (Horde|Alliance)", d)
        if side:
            e["faction"] = side.group(1)[0]
        features.append(e)
    by_name = {f["name"]: f for f in features}
    for u in upgrades:
        base = by_name.get(u["base"])
        assert base, "no feature named %s for %s" % (u["base"], u["name"])
        for f in features:
            if f["name"] == base["name"]:
                f.setdefault("upgrades", []).append({k: v for k, v in u.items() if k != "base"})

    today = datetime.date.today().isoformat()
    lines = [
        "-- Craft Ladder: WoW Forever's camps.",
        "-- GENERATED by tools/build_camp.py on %s - don't edit by hand; fix the builder and rebuild." % today,
        "-- From the client's tables, build %s: fires = the campfires (slots: how many features each holds);" % build,
        "-- features: a buff near a campfire, gives = { up to this level, what it gives } as its tooltip says,",
        "-- kind = the buff, exclusive = the class buff it doesn't stack with, upgrades = what stands for it and adds",
        "-- something; others = features with no buff. maker = the recipe (spell) that makes the item, prof = its",
        "-- profession, mats = what that takes. items = the names of every item named here.",
        "local _, ns = ...",
        "",
        "ns.CAMP = {",
        "  built = %s," % lua(today),
        "  fires = {",
    ]
    lines += ["    %s," % lua(f) for f in fires]
    lines += ["  },", "  features = {"]
    lines += ["    %s," % lua(f) for f in features]
    lines += ["  },", "  others = {"]
    lines += ["    %s," % lua(f) for f in others]
    lines += ["  },", "  items = {"]
    lines += ["    [%d] = %s," % (i, lua(names[i])) for i in sorted(used) if i in names]
    lines += ["  },", "}"]
    OUT_LUA.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print("wrote %s: %d campfires, %d features, %d upgrades, %d others" % (
        OUT_LUA.relative_to(ROOT), len(fires), len(features), len(upgrades), len(others)))


if __name__ == "__main__":
    main()
