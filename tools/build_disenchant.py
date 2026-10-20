"""Build CraftLadder/Data/Disenchant.lua and tools/DisenchantReport.md: what disenchanting an item gives.

  - Forever's client (wago.tools, newest build): ItemDisenchantLoot, the buckets an item falls in (weapon or armor,
    quality, item level range); ItemSparse and Item, each crafted item's level, quality and class, and the "can't be
    disenchanted" flag (Flags_0 0x8000) of every item.
  - CMaNGOS classic-db (GPL-3.0): disenchant_loot_template, what a bucket gives. That's the server's, not in the client:
    Classic's numbers, each bucket taking the entry most Classic items of it use. Shields and off-hand items count as
    weapons, as CMaNGOS has them.
  - The buckets Forever added (blue items of levels 5-20) aren't Classic's: they take the green bucket of their class
    and levels, one more of everything (the user checked it on 2026-10-20: Novice Arcanist's Sash, a blue of level 15,
    gives 2-3 Strange Dust or Lesser Magic Essence, where a green gives 1-2).
  - The crafted items: every item the professions' data makes (CraftLadder/Data/*.lua, `makes = `).
  - seen_in_game.json's disenchants (what the game gave, recorded by the addon): a bucket with 5 or more of them takes
    what they gave instead (the addon does the same in game with the player's own); the report shows them all.

    python -I tools/build_disenchant.py [--refresh]
"""
import argparse
import datetime
import re
import sys
from collections import Counter, defaultdict
from pathlib import Path

TOOLS = Path(__file__).resolve().parent
ROOT = TOOLS.parent
sys.path.insert(0, str(TOOLS))
import seen_in_game  # noqa: E402
import wago  # noqa: E402
from build_data import lua  # noqa: E402
from build_fishing import classicdb  # noqa: E402

OUT_LUA = ROOT / "CraftLadder" / "Data" / "Disenchant.lua"
OUT_REPORT = TOOLS / "DisenchantReport.md"
DATA = ROOT / "CraftLadder" / "Data"
WEAPON, ARMOR = 2, 4
NO_DISENCHANT = 0x8000  # ItemSparse.Flags_0
# 3 lesser essences make a greater one and a greater splits into 3 lesser (Classic's, a right-click in the bags)
GREATER = {10938: 10939, 10998: 11082, 11134: 11135, 11174: 11175, 16202: 16203}
QUALITY = {2: "green", 3: "blue", 4: "epic"}
SEEN = 5  # recorded disenchants of a bucket from which they replace its table (the user's number; Disenchant.SEEN)


def effective_class(cls, subclass, inventory_type):
    """Weapon or armor as disenchanting counts it: a shield or an off-hand item counts as a weapon (CMaNGOS's)."""
    if cls == ARMOR and (subclass == 6 or inventory_type == 23):
        return WEAPON
    return cls


def classic_skill(max_level):
    """The Enchanting skill Classic asks to disenchant the items of a bucket up to this level (a guess for Forever)."""
    return 1 if max_level <= 20 else min(225, ((max_level - 21) // 5 + 1) * 25)


def gives_of(rows):
    """A disenchant_loot_template entry as exclusive outcomes: [(item, chance 0-1, min, max)]. Entries of a group
    with no chance share what the others leave."""
    explicit = sum(c for _, c, _, _, _ in rows if c > 0)
    unset = [r for r in rows if r[1] == 0]
    out = []
    for item, chance, _, mincount, maxcount in rows:
        share = chance if chance > 0 else (100 - explicit) / len(unset)
        out.append((item, share / 100, mincount, maxcount))
    return out


def seen_gives(records):
    """A bucket's outcomes as the game gave them ([{material: count}] a disenchant): each material's share of the
    disenchants it came in, the fewest and the most of it (as Disenchant.Table does in game)."""
    counts = defaultdict(list)
    for got in records:
        for mat, n in got.items():
            counts[mat].append(n)
    return [{"item": m, "chance": round(len(ns) / len(records), 6), "min": min(ns), "max": max(ns)}
            for m, ns in sorted(counts.items(), key=lambda x: (-len(x[1]), x[0]))]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--refresh", action="store_true", help="download the client tables again")
    args = ap.parse_args()
    build = wago.latest_build()
    sparse = {int(r["ID"]): r for r in wago.table("ItemSparse", build, args.refresh)}
    items = {int(r["ID"]): r for r in wago.table("Item", build, args.refresh)}
    buckets = {int(r["ID"]): r for r in wago.table("ItemDisenchantLoot", build, args.refresh)}

    def bucket_of(cls, quality, level):
        for bid, b in buckets.items():
            if int(b["Class"]) == cls and int(b["Quality"]) == quality \
                    and int(b["MinLevel"]) <= level <= int(b["MaxLevel"]):
                return bid

    # what each bucket gives: the CMaNGOS entry most Classic items of the bucket use
    db = classicdb(False)
    entries = db["disenchant_loot_template"]  # entry -> [(item, chance, group, min, max)]
    votes = defaultdict(Counter)
    for r in db["items"].values():
        if r["DisenchantID"] not in ("0", ""):
            cls = effective_class(int(r["class"]), int(r["subclass"]), int(r["InventoryType"]))
            bid = bucket_of(cls, int(r["Quality"]), int(r["ItemLevel"]))
            if bid:
                votes[bid][int(r["DisenchantID"])] += 1
    era = {int(r["ID"]) for r in wago.table("ItemDisenchantLoot", "1.15.9.70003", args.refresh)}
    out_buckets, guessed = {}, []
    for bid, b in sorted(buckets.items()):
        cls, quality, low, high = int(b["Class"]), int(b["Quality"]), int(b["MinLevel"]), int(b["MaxLevel"])
        twin, extra = bid, 0
        if bid not in era:  # a bucket Forever added: its class and levels' green one, one more of everything
            twin = next(x for x, g in buckets.items() if int(g["Class"]) == cls and int(g["Quality"]) == 2
                        and int(g["MinLevel"]) == low and int(g["MaxLevel"]) == high)
            extra = 1
        entry = votes[twin].most_common(1)[0][0] if votes[twin] else None
        if entry is None:  # no Classic item of it: the same class and quality's next bucket up
            up = min((x for x in buckets if int(buckets[x]["Class"]) == cls and int(buckets[x]["Quality"]) == quality
                      and int(buckets[x]["MinLevel"]) > low and votes[x]), key=lambda x: int(buckets[x]["MinLevel"]))
            entry = votes[up].most_common(1)[0][0]
        gives = gives_of(entries[entry])
        assert abs(sum(g[1] for g in gives) - 1) < 1e-6, "entry %d's chances don't make 100%%" % entry
        out = {"class": "weapon" if cls == WEAPON else "armor", "quality": quality,
               "levels": [low, high], "skill": classic_skill(high),
               "gives": [{"item": i, "chance": round(c, 6), "min": lo + extra, "max": hi + extra}
                         for i, c, lo, hi in gives]}
        if extra:
            out["guess"] = True
            guessed.append(bid)
        out_buckets[bid] = out

    def item_bucket(item):
        """The bucket an item falls in, whether it's a shield or an off-hand item, or (None, ...)."""
        s, i = sparse.get(item), items.get(item)
        if not (s and i) or int(i["ClassID"]) not in (WEAPON, ARMOR) or int(s["OverallQualityID"]) not in QUALITY:
            return None, False
        cls = effective_class(int(i["ClassID"]), int(i["SubclassID"]), int(i["InventoryType"]))
        return bucket_of(cls, int(s["OverallQualityID"]), int(s["ItemLevel"])), cls != int(i["ClassID"])

    # the crafted items that can be disenchanted
    made = set()
    for path in DATA.glob("*.lua"):
        made |= {int(x) for x in re.findall(r"makes = (\d+)", path.read_text(encoding="utf-8"))}
    out_items, shields, no_de = {}, [], []
    for item in sorted(made):
        bid, shield = item_bucket(item)
        if bid and int(sparse[item]["Flags_0"]) & NO_DISENCHANT:
            no_de.append(item)
        elif bid:
            out_items[item] = bid
            if shield:
                shields.append(item)
    # every weapon and armor the game won't disenchant: what the bags have is looked up in game
    no_de_all = sorted(k for k, s in sparse.items() if int(s["Flags_0"]) & NO_DISENCHANT and item_bucket(k)[0])

    # what the game gave (any item disenchanted): a bucket with SEEN or more takes it
    seen = defaultdict(list)
    for entry in seen_in_game.disenchants():
        parts = entry.split()
        bid = item_bucket(int(parts[0]))[0]
        if bid:
            seen[bid].append({int(m): int(n) for m, n in (x.split(":") for x in parts[2:])})
    for bid, records in seen.items():
        if len(records) >= SEEN:
            out_buckets[bid]["gives"], out_buckets[bid]["seen"] = seen_gives(records), len(records)
            out_buckets[bid].pop("guess", None)

    mats = sorted({g["item"] for b in out_buckets.values() for g in b["gives"]} | set(GREATER) | set(GREATER.values()))
    prices = wago.item_prices(build, args.refresh)
    name = lambda x: sparse[x]["Display_lang"] if x in sparse else str(x)  # noqa: E731
    today = datetime.date.today().isoformat()
    lines = [
        "-- Craft Ladder: what disenchanting a crafted item gives.",
        "-- GENERATED by tools/build_disenchant.py on %s - don't edit by hand; fix the builder and rebuild." % today,
        "-- buckets: Forever's (client build %s: weapon or armor, quality, item levels); gives = what one" % build,
        "-- disenchant gives, one of them: chance 0-1, min-max of it (CMaNGOS's, Classic's numbers); skill = the",
        "-- Enchanting it asks (Classic's rule, a guess); guess = a bucket Forever added: its green twin's, one more",
        "-- of each (checked for one item); seen = how many recorded disenchants it's taken from then.",
        "-- items = the crafted items that can be disenchanted, their bucket (a shield or an off-hand item as a",
        "-- weapon); noDisenchant = every weapon and armor the game won't disenchant (the client's flag).",
        "-- greater = the essence 3 of a lesser make; sell = what a vendor pays for each material; names = theirs.",
        "local _, ns = ...",
        "",
        "ns.DISENCHANT = {",
        "  built = %s," % lua(today),
        "  buckets = {",
    ]
    for bid, b in out_buckets.items():
        lines.append("    [%d] = %s," % (bid, lua(b)))
    def rows(entries):
        """Table entries, ten to a line."""
        return ["    " + " ".join(entries[i:i + 10]) for i in range(0, len(entries), 10)]
    lines += ["  },", "  items = {"]
    lines += rows(["[%d] = %d," % (item, bid) for item, bid in out_items.items()])
    lines += ["  },", "  noDisenchant = {"]
    lines += rows(["[%d] = true," % item for item in no_de_all])
    lines += ["  },",
              "  greater = %s," % lua(GREATER),
              "  sell = %s," % lua({m: prices[m][1] for m in mats if m in prices}),
              "  names = %s," % lua({m: name(m) for m in mats}),
              "}"]
    OUT_LUA.write_text("\n".join(lines) + "\n", encoding="utf-8")

    # the report: the buckets, the guesses, and what the game gave
    per_bucket = Counter(out_items.values())
    rep = ["# Disenchanting", "", "Built %s from client build %s and CMaNGOS classic-db." % (today, build), "",
           "## Buckets", "",
           "| Bucket | Class | Quality | Levels | Skill | Gives | Crafted items | Seen in game |",
           "|---|---|---|---|---|---|---|---|"]
    for bid, b in out_buckets.items():
        gives = "; ".join("%g%% %s %s" % (round(g["chance"] * 100, 1), g["min"] if g["min"] == g["max"]
                                          else "%d-%d" % (g["min"], g["max"]), name(g["item"])) for g in b["gives"])
        records, got = seen.get(bid, []), Counter()
        for r in records:
            got.update(r)
        got = ", ".join("%.2f %s" % (n / len(records), name(m)) for m, n in got.most_common())
        rep.append("| %d%s | %s | %s | %d-%d | %d | %s | %d | %s |" % (
            bid, " (new)" if bid in guessed else "", b["class"], QUALITY[b["quality"]], b["levels"][0], b["levels"][1],
            b["skill"], gives, per_bucket[bid], records and "%d%s: %s a disenchant" % (
                len(records), " (used)" if b.get("seen") else "", got) or ""))
    rep += ["", "## Guesses", "",
            "- What every bucket gives is Classic's (CMaNGOS): the server's, not in the client. A bucket with %d or"
            " more disenchants recorded in game takes what they gave instead." % SEEN,
            "- The skill each bucket asks is Classic's rule: 1 up to item level 20, then 25 more every 5 levels, 225"
            " from 61.",
            "- Buckets Forever added (%s): their class and levels' green bucket, one more of everything (checked for"
            " Novice Arcanist's Sash: 2-3 Strange Dust or Lesser Magic Essence)." % ", ".join(map(str, guessed)),
            "- Shields and off-hand items count as weapons (CMaNGOS's): %d crafted ones (%s)." % (
                len(shields), ", ".join(name(x) for x in shields[:12]) + (", ..." if len(shields) > 12 else "")),
            "", "%d crafted items can be disenchanted; %d can't (the client's flag)." % (len(out_items), len(no_de))]
    OUT_REPORT.write_text("\n".join(rep) + "\n", encoding="utf-8")
    print("%s: %d buckets (%d new in Forever), %d crafted items, %d shields and off-hands, %d disenchants seen" % (
        OUT_LUA.name, len(out_buckets), len(guessed), len(out_items), len(shields), sum(len(r) for r in seen.values())))


if __name__ == "__main__":
    main()
