"""Lua and money text for the data builders (build_crafting.py, build_mining.py, ...)."""


def lua(v, indent=""):
    if v is None:
        return "nil"
    if isinstance(v, bool):
        return "true" if v else "false"
    if isinstance(v, (int, float)):
        return repr(int(v)) if float(v).is_integer() else repr(v)
    if isinstance(v, str):
        return '"' + v.replace("\\", "\\\\").replace('"', '\\"').replace("\n", "\\n") + '"'
    if isinstance(v, list):
        return "{ " + ", ".join(lua(x, indent) for x in v) + " }"
    if isinstance(v, dict):
        parts = []
        for k, x in v.items():
            if isinstance(k, int) or (isinstance(k, str) and k.isdigit()):
                key = "[%s]" % int(k)
            elif isinstance(k, str) and k.isidentifier():
                key = k
            else:
                key = "[%s]" % lua(k)
            parts.append("%s = %s" % (key, lua(x, indent)))
        return "{ " + ", ".join(parts) + " }"
    raise TypeError(type(v))


def money(c):
    if not c:
        return "free"
    c = int(round(c))
    g, s, cp = c // 10000, (c // 100) % 100, c % 100
    return "".join(x for x in ("%dg" % g if g else "", "%ds" % s if s else "", "%dc" % cp if cp or c < 100 else ""))
