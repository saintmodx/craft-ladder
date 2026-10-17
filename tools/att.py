"""AllTheThings' WoW Forever database (MIT), read when the data is built, never shipped as is: what the supply camps'
quartermasters sell for Merchant's Favor and for how much; who sells, rewards or drops a recipe; which recipes it knows
at all and which it holds back as not out in Forever yet. Its source files are downloaded once into tools/cache/att.

    import att
    att.favor_costs()           # {recipe item: Merchant's Favor}
    att.recipes("firstaid")     # {"known": {spell}, "unreleased": {spell}}; None: it has no file for the profession
    att.sources()               # {"items": {item: {"vendor": {npc: holiday}, "quest": {quest: holiday},
                                #  "drop": {npc}}}, "spells": {spell: {quest}}}; holiday None: all year
"""
import json
import re
import urllib.parse
import urllib.request
from collections import defaultdict
from pathlib import Path

COMMIT = "10164719738bdc1e7baa23dd854bef4c7184a6ac"  # ATTWoWAddon/AllTheThings, 2026-10-16
DB = ".contrib/.db/forever/"
RAW = "https://raw.githubusercontent.com/ATTWoWAddon/AllTheThings/%s/%s"
TREE = "https://api.github.com/repos/ATTWoWAddon/AllTheThings/git/trees/%s?recursive=1"
PROFESSIONS = ("alchemy", "blacksmithing", "enchanting", "engineering", "leatherworking", "tailoring")
NAMES = {"firstaid": "first aid", "poisons": "poison"}  # its profession files' names, where they differ from ours
# the folders that place things in the world (zones, instances, holidays, ...), not the crafted items' lists
SOURCES = ("zones/", "world drops/", "dungeons & raids/", "holidays/", "world events/", "expansion features/", "pvp/",
           "character/", "professions/")
CACHE = Path(__file__).resolve().parent / "cache" / "att" / COMMIT[:7]
UA = "CraftLadder-databuilder (personal use)"
# i(250388, {	-- Recipe: Elixir of Lesser Intellect (RECIPE!)
# 	cost = {{ "c", MERCHANTS_FAVOR, 45 }},
FAVOR = re.compile(r'i\((\d+),\s*\{[^\n]*\n\s*cost\s*=\s*\{\{\s*"c",\s*MERCHANTS_FAVOR,\s*(\d+)')
# a profession file's recipe: i(item or 0, spell...) or r(spell)
SPELL = re.compile(r"^(?:i\(\d+,\s*(\d+)|r\((\d+)\))")
# what the source files are read as: strings and comments (skipped), a call that opens a table (n(VENDORS, {,
# q(8876, {, bubbleDownClassicRep(FACTION_..., {), a call with an id (i(276961), recipe(1230643)), braces
TOKENS = re.compile(r'"(?:[^"\\\n]|\\.)*"|--\[\[.*?\]\]|--[^\n]*|(\w+)\(\s*([\w.]*)\s*,\s*(?:[\w.]+\s*,\s*)?\{'
                    r'|(\w+)\(\s*(\d+)|(\{)|(\})', re.S)


def _get(url):
    req = urllib.request.Request(url, headers={"User-Agent": UA})
    with urllib.request.urlopen(req, timeout=60) as r:  # anything but 200 raises: nothing is cached then
        return r.read()


def _source(rel):
    """A file of the Forever database (rel: its path under .contrib/.db/forever), downloaded once."""
    path = CACHE / rel
    if not path.exists():
        data = _get(RAW % (COMMIT, urllib.parse.quote(DB + rel)))
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_bytes(data)
    return path.read_text(encoding="utf-8")


def _files(folders):
    """The Forever database's .lua files under these folders, from the pinned commit's file list (downloaded once)."""
    path = CACHE / "tree.json"
    if not path.exists():
        data = _get(TREE % COMMIT)
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_bytes(data)
    tree = json.loads(path.read_text(encoding="utf-8"))
    if tree.get("truncated"):
        raise ValueError("GitHub cut AllTheThings' file list short")
    return [e["path"][len(DB):] for e in tree["tree"] if e["type"] == "blob" and e["path"].startswith(DB)
            and e["path"][len(DB):].startswith(folders) and e["path"].endswith(".lua")]


def favor_costs():
    """{recipe item: its price in Merchant's Favor} over every profession's quartermasters, both sides."""
    out = {int(item): int(cost) for name in PROFESSIONS
           for item, cost in FAVOR.findall(_source(".config/structures/%s.lua" % name))}
    if not out:
        raise ValueError("no Merchant's Favor prices in AllTheThings' files: has their format changed?")
    return out


def recipes(profession):
    """What AllTheThings' file of a profession (our key: "firstaid") lists: known = every recipe, whatever its heading
    (TRAINER, ITEM, UNKNOWN, ...); unreleased = the ones under an UNRELEASED CONTENT heading, commented out as not
    out in Forever yet. None when it has no file for the profession (Cooking) or an empty one (Poisons)."""
    rel = "profession db/%s.lua" % NAMES.get(profession, profession)
    if rel not in _files(("profession db/",)):
        return None
    known, unreleased, block, held = set(), set(), False, False
    for line in _source(rel).splitlines():
        s = line.strip()
        if s.startswith("--[["):
            block = True
        elif s.startswith("--]]") or s == "]]":
            block = held = False
        elif s.startswith("--- "):  # a heading; under UNRELEASED CONTENT a block has headings of its own (--- MC ---)
            held = s.startswith("--- UNRELEASED") or held and block
        m = SPELL.match(s)
        if m:
            spell = int(m.group(1) or m.group(2))
            known.add(spell)
            if held:
                unreleased.add(spell)
    return {"known": known, "unreleased": unreleased} if known else None


def sources():
    """Who sells, rewards or drops each item and which quests teach a spell outright (Camping 101), from the files
    that place things in the world. A way found in a holiday's file is that holiday's (its name, else None)."""
    items = defaultdict(lambda: {"vendor": {}, "quest": {}, "drop": set()})
    spells = defaultdict(set)
    for rel in _files(SOURCES):
        holiday = None
        if rel.startswith("holidays/"):
            holiday = " ".join(w if w in ("of", "the") else w.capitalize() for w in rel[9:-4].split())
        stack = []
        for m in TOKENS.finditer(_source(rel)):
            call, arg, leaf, eid, opened, closed = m.groups()
            if opened:
                stack.append(None)
            elif closed:
                if stack:
                    stack.pop()
            elif call or leaf:
                kind, eid = call or leaf, arg if call else eid
                if kind in ("i", "recipe") and eid.isdigit():
                    ctx = [c for c in stack if c]
                    quests = [int(a) for k, a in ctx if k == "q" and a.isdigit()]
                    npcs = [int(a) for k, a in ctx if k == "n" and a.isdigit()]
                    if kind == "recipe":
                        if quests:
                            spells[int(eid)].add(quests[-1])
                    elif quests:
                        items[int(eid)]["quest"][quests[-1]] = holiday
                    elif any(k == "n" and a == "VENDORS" for k, a in ctx):
                        if npcs:
                            items[int(eid)]["vendor"][npcs[-1]] = holiday
                    else:  # a creature's, a zone's or the world's drop, a treasure
                        items[int(eid)]["drop"].add(npcs[-1] if npcs else rel)
                if call:
                    stack.append((call, arg))
    if not items:
        raise ValueError("nothing placed in AllTheThings' files: has their format changed?")
    return {"items": dict(items), "spells": dict(spells)}
