"""What the game itself showed Craft Ladder, kept as facts for the builders: tools/seen_in_game.json.

    python -I tools/seen_in_game.py [path to SavedVariables/CraftLadder.lua]

Reads from the saved variables (by default the newest of the Forever client's accounts):
  - CraftLadderDB.trainer: by recipe spell, the skill and fee a trainer asked, or that a trainer listing recipes of
    that skill and higher didn't list it (notAtTrainer). build_crafting.py puts these over CMaNGOS's and its guesses.
  - CraftLadderDB.gatherLog: every node or herb gathered, "profession entry map x y time". build_mining.py and
    build_herbalism.py measure from them how often each kind takes a spawn spot it shares.
  - CraftLadderDB.favorPrices: by item, what a quartermaster asks in Merchant's Favor, the level it asks, its name and
    who sells it. build_crafting.py puts the price and level on the recipe's plan.
  - CraftLadderDB.rankFees: by rank spell (Journeyman, Expert, Artisan), what a trainer asks for it.
  - CraftLadderDB.disenchantLog: every disenchant, "item time material:count ...". build_disenchant.py compares them
    with Classic's table in its report.
"""
import json
import re
import sys
from pathlib import Path

TOOLS = Path(__file__).resolve().parent
OUT = TOOLS / "seen_in_game.json"
ACCOUNTS = Path(r"D:\Games\World of Warcraft\_classic_beta_\WTF\Account")


def _load():
    return json.loads(OUT.read_text(encoding="utf-8")) if OUT.exists() else {}


def trainer():
    """{spell: {"skill", "cost"} or {"notAtTrainer": True}}; empty when nothing was seen."""
    return {int(k): v for k, v in _load().get("trainer", {}).items()}


def gather():
    """The gathers recorded in game: ["profession entry map x y time", ...]."""
    return _load().get("gather", [])


def disenchants():
    """The disenchants recorded in game: ["item time material:count ...", ...]."""
    return _load().get("disenchant", [])


def favor():
    """{item: {"cost", "level", "npc", "name"} (the last three when seen)}: what quartermasters sell for favor."""
    return {int(k): v for k, v in _load().get("favor", {}).items()}


def rank_fees():
    """{rank spell: fee in copper}."""
    return {int(k): v for k, v in _load().get("rankFees", {}).items()}


def read_gather(path, key="gatherLog"):
    """CraftLadderDB.gatherLog (or another log of lines: disenchantLog) from a SavedVariables file: its lines."""
    m = re.search(r'\["%s"\] = \{(.*?)\n\}' % key, path.read_text(encoding="utf-8"), re.S)
    return re.findall(r'"([^"]+)"', m.group(1)) if m else []


def read_table(text, key):
    """A table of CraftLadderDB keyed by number: {number: {field: its text}} (the game writes an entry a few lines
    long; a string's quotes are kept)."""
    start = text.find('["%s"] = {' % key)
    if start < 0:
        return {}
    block = text[start:]
    end = re.search(r'\n\},\n\["', block)  # its entries are followed by [number], the table itself by ["key"]
    block = block[:end.start() if end else len(block)]
    return {int(n): dict(re.findall(r'\["(\w+)"\] = ([^\n]+?),\n', body + "\n"))
            for n, body in re.findall(r"\[(\d+)\] = \{(.*?)\n\}", block, re.S)}


def read_saved(path):
    """CraftLadderDB.trainer from a SavedVariables file."""
    out = {}
    for spell, fields in read_table(path.read_text(encoding="utf-8"), "trainer").items():
        if fields.get("notAtTrainer") == "true":
            out[spell] = {"notAtTrainer": True}
        elif "skill" in fields and "cost" in fields:
            out[spell] = {"skill": int(fields["skill"]), "cost": int(fields["cost"])}
    return out


def read_favor(path):
    """CraftLadderDB.favorPrices from a SavedVariables file: {item: {"cost", and "level", "npc", "name" if seen}}."""
    out = {}
    for item, fields in read_table(path.read_text(encoding="utf-8"), "favorPrices").items():
        e = {k: int(fields[k]) for k in ("cost", "level", "npc") if k in fields}
        if "name" in fields:
            e["name"] = fields["name"].strip('"')
        if "cost" in e:
            out[item] = e
    return out


def read_rank_fees(path):
    """CraftLadderDB.rankFees from a SavedVariables file: {rank spell: fee}."""
    return {spell: int(f["cost"]) for spell, f in read_table(path.read_text(encoding="utf-8"), "rankFees").items()
            if "cost" in f}


def main():
    if len(sys.argv) > 1:
        path = Path(sys.argv[1])
    else:
        path = max(ACCOUNTS.glob("*/SavedVariables/CraftLadder.lua"), key=lambda p: p.stat().st_mtime)
    seen, favors, fees = read_saved(path), read_favor(path), read_rank_fees(path)
    des = read_gather(path, "disenchantLog")
    assert seen or favors or fees or read_gather(path) or des, "nothing recorded in %s" % path
    old = trainer()
    old.update(seen)  # a later visit wins; what only an older file had stays
    gathers = sorted(set(gather()) | set(read_gather(path)))  # each line has its time: the same gather once
    des = sorted(set(disenchants()) | set(des))
    all_favor = favor()
    all_favor.update(favors)
    all_fees = rank_fees()
    all_fees.update(fees)
    OUT.write_text(json.dumps({"trainer": {str(k): v for k, v in sorted(old.items())}, "gather": gathers,
                               "favor": {str(k): v for k, v in sorted(all_favor.items())},
                               "rankFees": {str(k): v for k, v in sorted(all_fees.items())}, "disenchant": des},
                              indent=1) + "\n", encoding="utf-8")
    print("%s: %d trainer notes (%d not at the trainer), %d gathers, %d sold for favor, %d rank fees, %d disenchants"
          % (OUT.name, len(old), sum(1 for v in old.values() if v.get("notAtTrainer")), len(gathers), len(all_favor),
             len(all_fees), len(des)))


if __name__ == "__main__":
    main()
