"""Read QuestieDB's Forever data straight from its .toc file, outside the game.

QuestieDB (an installed addon) keeps its database in the metadata lines of QuestieDB_Forever.toc:
`## X-<Entity>-<id>-<field>: <base64 CBOR>`, field S holding the entity's small values as one map. A long value is
split: the field holds "~N~" and its parts follow as <field>-1 .. <field>-N. In game QuestieDB reads them with
C_EncodingUtil; this module does the same with a small CBOR decoder.

Field numbers (QuestieDB src/meta/*Meta.lua):
  Item:  1 name, 2 npcDrops, 3 objectDrops, 4 itemDrops, 6 questRewards, 9 itemLevel, 10 requiredLevel, 14 vendors
  Npc:   1 name, 7 spawns {areaId: [[x, y], ...]}, 9 zoneID, 13 friendlyToFaction ("A", "H", "AH"), 14 subName
  Quest: 1 name, 2 startedBy [[npcs], [objects], [items]], 3 finishedBy, 4 requiredLevel, 5 questLevel,
         18 requiredSkill [skill line, skill]
"""
import base64
import re
import struct

TOC = r"D:\Games\World of Warcraft\_classic_beta_\Interface\AddOns\QuestieDB\QuestieDB_Forever.toc"
ZONES = r"D:\Games\World of Warcraft\_classic_beta_\Interface\AddOns\QuestieDB\support\Forever\Zones\areaIdToUiMapId.lua"


def _cbor(b, i=0):
    ib = b[i]
    major, info = ib >> 5, ib & 31
    i += 1
    if major == 7:
        if info == 20:
            return False, i
        if info == 21:
            return True, i
        if info == 22:
            return None, i
        if info == 25:
            return struct.unpack(">e", b[i:i + 2])[0], i + 2
        if info == 26:
            return struct.unpack(">f", b[i:i + 4])[0], i + 4
        if info == 27:
            return struct.unpack(">d", b[i:i + 8])[0], i + 8
        raise ValueError("CBOR simple value %d" % info)
    if info < 24:
        n = info
    else:
        size = {24: 1, 25: 2, 26: 4, 27: 8}[info]
        n, i = int.from_bytes(b[i:i + size], "big"), i + size
    if major == 0:
        return n, i
    if major == 1:
        return -1 - n, i
    if major in (2, 3):  # QuestieDB writes its strings as byte strings
        return b[i:i + n].decode("utf-8", "replace"), i + n
    if major == 4:
        out = []
        for _ in range(n):
            x, i = _cbor(b, i)
            out.append(x)
        return out, i
    if major == 5:
        out = {}
        for _ in range(n):
            k, i = _cbor(b, i)
            out[k], i = _cbor(b, i)
        return out, i
    if major == 6:  # a tag: the value after it is what counts
        return _cbor(b, i)
    raise ValueError("CBOR major type %d" % major)


class QuestieDB:
    def __init__(self, toc=TOC):
        self.raw = {}
        line_re = re.compile(r"## X-(Item|Npc|Quest|Object)-(\d+)-([\w-]+): (.*)")
        with open(toc, encoding="utf-8") as f:
            for line in f:
                m = line_re.match(line)
                if m:
                    ent, eid, field, value = m.groups()
                    self.raw.setdefault((ent, int(eid)), {})[field] = value.strip()
        self._cache = {}

    def get(self, ent, eid):
        """The entity's fields as {field number: value}, {} when QuestieDB doesn't have it."""
        key = (ent, eid)
        if key in self._cache:
            return self._cache[key]
        fields = self.raw.get(key, {})
        out = {}
        for field, value in fields.items():
            if "-" in field:
                continue  # a part of a split value, joined below
            m = re.fullmatch(r"~(\d+)~", value)
            if m:
                value = "".join(fields[f"{field}-{n}"] for n in range(1, int(m.group(1)) + 1))
            decoded = _cbor(base64.b64decode(value))[0]
            if field == "S" and isinstance(decoded, list):  # some entities keep their small values as a list
                out.update({i: v for i, v in enumerate(decoded, 1) if v is not None})
            elif field == "S":
                out.update({int(k): v for k, v in decoded.items() if isinstance(k, int)})
            else:
                out[int(field)] = decoded
        self._cache[key] = out
        return out

    def item(self, eid):
        return self.get("Item", eid)

    def npc(self, eid):
        return self.get("Npc", eid)

    def quest(self, eid):
        return self.get("Quest", eid)


ALLIANCE_RACES, HORDE_RACES = 77, 178  # race masks: the low bits of QuestieDB's requiredRaces and of the client's


def side(mask):
    """"A", "H" or "AH" for a race mask (0: everyone)."""
    races = (mask or 0) & 0xFFFFFFFF
    a, h = bool(races & ALLIANCE_RACES), bool(races & HORDE_RACES)
    return "A" if a and not h else "H" if h and not a else "AH"


class Places:
    """The NPCs and quests a profession's data names, the way the Lua data keeps them: npcs = { [id] = { name,
    faction, map, zone, x, y } }, quests = { [id] = { name, faction, giver, giverName, zone, x, y, reqLevel, level,
    skill } }."""

    def __init__(self, qdb):
        self.qdb, self.areas, self.npcs, self.quests = qdb, zones(), {}, {}

    def npc(self, n):
        if n in self.npcs:
            return self.npcs[n]
        d = self.qdb.npc(n)
        e = {"name": d.get(1) or ("NPC %d" % n), "faction": d.get(13) or "AH"}
        spawns = d.get(7) or {}
        if isinstance(spawns, list):  # CBOR keeps a map keyed 1, 2, ... as a list
            spawns = dict(enumerate(spawns, 1))
        for area, points in spawns.items():
            if points:
                m = self.areas.get(int(area))
                if m:
                    e["map"], e["zone"] = m
                e["x"], e["y"] = round(points[0][0], 1), round(points[0][1], 1)
                break
        self.npcs[n] = e
        return e

    def quest(self, q):
        if q in self.quests:
            return self.quests[q]
        d = self.qdb.quest(q)
        e = {"name": d.get(1) or ("quest %d" % q), "faction": side(d.get(6))}
        started = d.get(2) or []
        if isinstance(started, dict):  # CBOR keeps a list with empty heads as a map from its 1-based places
            started = [started.get(k) for k in (1, 2, 3)]
        givers = (started[0] if started else None) or []
        if givers:
            g = self.npc(givers[0])
            e.update(giver=givers[0], giverName=g["name"], zone=g.get("zone"), x=g.get("x"), y=g.get("y"))
        if d.get(4):
            e["reqLevel"] = d[4]
        if d.get(5):
            e["level"] = d[5]
        if d.get(18):
            e["skill"] = d[18][1] if isinstance(d[18], list) and len(d[18]) > 1 else None
        self.quests[q] = e
        return e


def zones(path=ZONES):
    """{areaId: (uiMapId, zone name)} from QuestieDB's Forever zone table."""
    out = {}
    with open(path, encoding="utf-8") as f:
        text = f.read()
    body = text[text.index("ZoneDB.private.areaIdToUiMapId = "):]
    for m in re.finditer(r"\[(\d+)\] = (\d+),\s*--\s*(.+)", body):
        out[int(m.group(1))] = (int(m.group(2)), m.group(3).strip())
    return out
