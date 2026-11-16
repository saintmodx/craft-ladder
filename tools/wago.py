"""Forever client tables (DB2) from wago.tools, downloaded once into tools/cache/wago.

    from wago import latest_build, table
    rows = table("ItemSparse", latest_build())   # [{column: text}, ...]
"""
import csv
import io
import json
import urllib.request
from pathlib import Path

CACHE = Path(__file__).resolve().parent / "cache" / "wago"
UA = "CraftLadder-databuilder (personal use)"
BUILDS = "https://wago.tools/api/builds"
DB2 = "https://wago.tools/db2/%s/csv?build=%s"


def _get(url):
    req = urllib.request.Request(url, headers={"User-Agent": UA})
    with urllib.request.urlopen(req, timeout=300) as r:
        return r.read()


def _key(version):
    return tuple(int(x) for x in version.split("."))


def latest_build():
    """The newest WoW Forever build wago.tools lists (the 1.6x ones; live Forever is the "wowf" branch, the beta
    builds were under wow_classic_beta)."""
    builds = json.loads(_get(BUILDS))
    return max((b["version"] for branch in ("wowf", "wow_classic_beta") for b in builds.get(branch, [])
                if b["version"].startswith("1.6")), key=_key)


def table(name, build, refresh=False, locale=None):
    """One DB2 table at one build, as a list of rows. locale ("ruRU"): its *_lang columns in that language."""
    path = CACHE / ("%s-%s%s.csv" % (name, build, "-" + locale if locale else ""))
    if refresh or not path.exists():
        data = _get((DB2 % (name, build)) + ("&locale=" + locale if locale else ""))
        if not data.strip() or data.lstrip().startswith(b"<"):
            raise ValueError("wago.tools sent no table for %s %s" % (name, build))
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_bytes(data)
    return list(csv.DictReader(io.StringIO(path.read_text(encoding="utf-8-sig"))))


def item_prices(build, refresh=False):
    """{item: (copper per unit a vendor asks, copper a vendor pays)} for every item, from ItemSparse."""
    out = {}
    for row in table("ItemSparse", build, refresh):
        buy = int(row["BuyPrice"] or 0) / max(1, int(row["VendorStackCount"] or 1))
        out[int(row["ID"])] = (buy, int(row["SellPrice"] or 0))
    return out

