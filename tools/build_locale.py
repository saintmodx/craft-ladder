"""A new language's file for Craft Ladder, from a list of translations.

    python -I tools/build_locale.py deDE German translations.txt

`translations.txt` is one translation per line, in the order the keys come out of `--keys`:

    python -I tools/build_locale.py --keys keys.txt

The keys, their order and the section comments all come from `CraftLadder/Locale/ruRU.lua`, the fullest file;
English needs no file of its own, since the key is the English string as it stands in the code.

Nothing is written unless every key has a line and every line's %s and %d come in the same order as the English
one's: Lua 5.1 has no positional specifiers, so the game fills them in the order they appear.

A language already in Locale/ is edited by hand from then on; this is only for starting one.
"""
import argparse
import pathlib
import re
import sys

sys.stdout.reconfigure(encoding="utf-8")
NL = chr(10)
ROOT = pathlib.Path(__file__).resolve().parent.parent / "CraftLadder"
LIT = re.compile(r'"((?:[^"\\\n]|\\.)*)"')
SPEC = re.compile(r"%[-+ #0-9.]*[a-zA-Z%]")
WIDTH = 118  # the longest line the addon's files run to

# the languages the Forever client has no strings of its own for: their item and recipe names stay English
NO_CLIENT_NAMES = {"itIT", "ukUA"}


def unescape(s):
    return s.replace(chr(92) + '"', '"').replace(chr(92) * 2, chr(92))


def lua(s):
    return chr(34) + s.replace(chr(92), chr(92) * 2).replace(chr(34), chr(92) + chr(34)) + chr(34)


def plan():
    """ruRU.lua as a list of ("comment", text) and ("key", english), in the order it writes them."""
    out, pending = [], []
    body = (ROOT / "Locale/ruRU.lua").read_text(encoding="utf-8").split("ns.Locales.ruRU = {", 1)[1]
    for line in body.split(NL):
        stripped = line.strip()
        if stripped.startswith("--"):
            out.append(("comment", stripped[2:].strip()))
            pending = []
        elif line.startswith("    ["):
            pending = [line]
            if "] =" in line:
                out.append(("key", unescape("".join(LIT.findall(line.split("] =")[0])))))
                pending = []
        elif pending:
            pending.append(line)
            if "] =" in line:
                out.append(("key", unescape("".join(LIT.findall(NL.join(pending).split("] =")[0])))))
                pending = []
    return out


def keys():
    """The keys in order, each once."""
    out, seen = [], set()
    for kind, payload in plan():
        if kind == "key" and payload not in seen:
            seen.add(payload)
            out.append(payload)
    return out


def chunks(s, first, rest_room):
    """Split s at spaces so the first piece fits `first` characters and the others `rest_room`."""
    out, rest, room = [], s, first
    while len(rest) > room:
        cut = rest.rfind(" ", 1, room + 1)
        if cut <= 0:
            cut = room
        out.append(rest[:cut])
        rest = rest[cut:]
        room = rest_room
    out.append(rest)
    return out


def entry(english, translated):
    """One line of the table, wrapped at WIDTH columns the way the rest of the addon is."""
    pad, margin = 8, 4  # a continued line's indent; room for the quotes an escaped character takes
    lines = []
    key = chunks(english, WIDTH - len("    [") - 2 - 3 - margin, WIDTH - pad - 2 - 3 - margin)
    for i, k in enumerate(key[:-1]):
        lines.append(("    [" if i == 0 else " " * pad) + lua(k) + " ..")
    head = ("    [" if len(key) == 1 else " " * pad) + lua(key[-1]) + "] = "
    room = WIDTH - len(head) - 2 - 3 - margin
    if room < 24:  # no room worth using: the value starts on the next line
        lines.append(head.rstrip())
        head, room = " " * pad, WIDTH - pad - 2 - 3 - margin
    value = chunks(translated, room, WIDTH - pad - 2 - 3 - margin)
    for i, v in enumerate(value):
        lines.append((head if i == 0 else " " * pad) + lua(v) + (" .." if i < len(value) - 1 else ","))
    return lines


def write(code, language, words):
    ordered = keys()
    missing = [k for k in ordered if k not in words]
    bad = [k for k in ordered if k in words and SPEC.findall(k) != SPEC.findall(words[k])]
    for k in missing[:10]:
        print("   missing:", k[:90])
    for k in bad[:10]:
        print("   %%s/%%d out of order: %r -> %r" % (k[:60], words[k][:60]))
    if missing or bad:
        sys.exit("%s: %d missing, %d with the wrong %%s/%%d" % (code, len(missing), len(bad)))

    names = ("Item, recipe and zone names come from the game itself, so they are not here."
             if code not in NO_CLIENT_NAMES else
             "Item, recipe and zone names stay English: the Forever client has none in this language.")
    out = [
        "-- Craft Ladder in %s. The key is the English string as it stands in the code; what's missing here is"
        " shown in" % language,
        "-- English. %s" % names,
        "-- The %s and %d of a line must stay in the same order as in the English one: the game fills them in"
        " that order.",
        "local _, ns = ...",
        "",
        "ns.Locales = ns.Locales or {}",
        "ns.Locales.%s = {" % code,
    ]
    written = set()
    for kind, payload in plan():
        if kind == "key" and payload in written:
            continue  # the same string was wrapped twice in the code: one line is enough
        written.add(payload)
        if kind == "comment":
            if not out[-1].endswith("{"):
                out.append("")
            out.append("    -- " + payload)
        else:
            out.extend(entry(payload, words[payload]))
    out.append("}")
    path = ROOT / "Locale" / ("%s.lua" % code)
    path.write_bytes((NL.join(out) + NL).replace(NL, chr(13) + NL).encode("utf-8"))
    print("%s.lua: %d lines, %d KB" % (code, len(ordered), path.stat().st_size / 1024))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--keys", metavar="FILE", help="write the English keys, in order, and stop")
    ap.add_argument("code", nargs="?", help="the game's code for it: deDE, frFR, zhCN, ...")
    ap.add_argument("language", nargs="?", help="its English name, for the file's first line")
    ap.add_argument("translations", nargs="?", help="one translation per line, in the keys' order")
    args = ap.parse_args()

    if args.keys:
        pathlib.Path(args.keys).write_text(NL.join(keys()), encoding="utf-8")
        print("%d keys written to %s" % (len(keys()), args.keys))
        return
    if not (args.code and args.language and args.translations):
        ap.error("give a code, a language and a file of translations, or --keys")

    ordered = keys()
    values = pathlib.Path(args.translations).read_text(encoding="utf-8").split(NL)
    while values and values[-1] == "":
        values.pop()
    if len(values) != len(ordered):
        sys.exit("%s: %d translations for %d keys" % (args.code, len(values), len(ordered)))
    blank = [i + 1 for i, v in enumerate(values) if not v]
    if blank:
        sys.exit("%s: lines %s are empty" % (args.code, blank[:10]))
    write(args.code, args.language, dict(zip(ordered, values)))


main()
