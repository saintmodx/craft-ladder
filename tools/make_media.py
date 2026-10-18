"""Draw Craft Ladder's few textures (white shapes, tinted in game) as 32-bit TGA files in CraftLadder/Media.

    python -I tools/make_media.py

logo    64x64  the logo, shrunk from the user's picture outside the repo (LOGO), skipped when it isn't there
round   64x64  rounded square (radius 14) for panels, buttons and bars: nine-sliced at 16 px
shadow  64x64  soft shadow around a rounded square: nine-sliced at 32 px
pointer 32x32  triangle pointing down: the "you are here" marker
close   32x32  an X
check   32x32  a tick
pin     32x32  a map pin
"""
import math
import struct
import zlib
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / "CraftLadder" / "Media"
LOGO = ROOT.parent / "craft-ladder-logo.png"  # D:\Dev: 1254x1254, the CurseForge project's logo too
SS = 4  # supersampling per axis, for smooth edges


def tga_header(size):
    return struct.pack("<BBBHHBHHHHBB", 0, 0, 2, 0, 0, 0, 0, 0, size, size, 32, 0x28)  # top-left origin, 8 alpha bits


def write_tga(path, size, alpha):
    """White pixels with the given alpha (rows top to bottom)."""
    body = bytearray()
    for y in range(size):
        for x in range(size):
            a = max(0, min(255, int(round(alpha(x, y) * 255))))
            body += bytes((255, 255, 255, a))
    path.write_bytes(tga_header(size) + bytes(body))


def read_png(path):
    """The width, height and rows (bytes r, g, b per pixel) of an 8-bit RGB PNG that isn't interlaced, as the logo is."""
    data = path.read_bytes()
    w, h, depth, colour, _, _, interlace = struct.unpack(">IIBBBBB", data[16:29])
    assert (depth, colour, interlace) == (8, 2, 0), f"{path.name}: not an 8-bit RGB PNG without interlace"
    idat, i = bytearray(), 8
    while i < len(data):
        n, kind = struct.unpack(">I4s", data[i:i + 8])
        if kind == b"IDAT":
            idat += data[i + 8:i + 8 + n]
        i += 12 + n
    raw, stride = zlib.decompress(bytes(idat)), w * 3
    rows, prev = [], bytearray(stride)
    for y in range(h):
        start = y * (stride + 1)
        kind, line = raw[start], bytearray(raw[start + 1:start + 1 + stride])
        for x in range(stride):  # undo the row's filter (PNG spec, 9.2): 0 none, 1 sub, 2 up, 3 average, 4 Paeth
            left = line[x - 3] if x >= 3 else 0
            up, upleft = prev[x], prev[x - 3] if x >= 3 else 0
            if kind == 1:
                line[x] = (line[x] + left) & 255
            elif kind == 2:
                line[x] = (line[x] + up) & 255
            elif kind == 3:
                line[x] = (line[x] + (left + up) // 2) & 255
            elif kind == 4:
                p = left + up - upleft
                pa, pb, pc = abs(p - left), abs(p - up), abs(p - upleft)
                line[x] = (line[x] + (left if pa <= pb and pa <= pc else up if pb <= pc else upleft)) & 255
        rows.append(line)
        prev = line
    return w, h, rows


def write_logo(path, size):
    """The logo shrunk to size x size, each pixel the average of the picture's pixels it covers; opaque."""
    w, h, rows = read_png(LOGO)
    body = bytearray()
    for ty in range(size):
        y0, y1 = ty * h // size, (ty + 1) * h // size
        for tx in range(size):
            x0, x1 = tx * w // size, (tx + 1) * w // size
            r = g = b = 0
            for y in range(y0, y1):
                line = rows[y]
                for x in range(x0 * 3, x1 * 3, 3):
                    r, g, b = r + line[x], g + line[x + 1], b + line[x + 2]
            n = (y1 - y0) * (x1 - x0)
            body += bytes((round(b / n), round(g / n), round(r / n), 255))  # TGA keeps blue first
    path.write_bytes(tga_header(size) + bytes(body))


def supersample(size, inside):
    """Coverage of each pixel by the shape inside(x, y) (pixel units, y down)."""
    def alpha(px, py):
        hits = 0
        for sy in range(SS):
            for sx in range(SS):
                if inside(px + (sx + 0.5) / SS, py + (sy + 0.5) / SS):
                    hits += 1
        return hits / (SS * SS)
    return alpha


def rounded_box_distance(x, y, x0, y0, x1, y1, r):
    """Signed distance to a rounded box (negative inside)."""
    cx, cy = (x0 + x1) / 2, (y0 + y1) / 2
    hx, hy = (x1 - x0) / 2 - r, (y1 - y0) / 2 - r
    qx, qy = abs(x - cx) - hx, abs(y - cy) - hy
    outside = math.hypot(max(qx, 0), max(qy, 0))
    return outside + min(max(qx, qy), 0) - r


def point_in_polygon(x, y, pts):
    inside = False
    j = len(pts) - 1
    for i in range(len(pts)):
        xi, yi = pts[i]
        xj, yj = pts[j]
        if (yi > y) != (yj > y) and x < (xj - xi) * (y - yi) / (yj - yi) + xi:
            inside = not inside
        j = i
    return inside


def segment_distance(x, y, ax, ay, bx, by):
    dx, dy = bx - ax, by - ay
    t = max(0, min(1, ((x - ax) * dx + (y - ay) * dy) / (dx * dx + dy * dy)))
    return math.hypot(x - (ax + t * dx), y - (ay + t * dy))


def main():
    OUT.mkdir(parents=True, exist_ok=True)

    if LOGO.exists():
        write_logo(OUT / "logo.tga", 64)
    else:
        print("no", LOGO, "so logo.tga is kept as it is")

    write_tga(OUT / "round.tga", 64, supersample(64, lambda x, y: rounded_box_distance(x, y, 0, 0, 64, 64, 14) <= 0))

    def shadow(px, py):
        d = rounded_box_distance(px + 0.5, py + 0.5, 22, 22, 42, 42, 8)
        if d <= 0:
            return 0.55
        return 0.55 * max(0.0, 1 - d / 20) ** 2
    write_tga(OUT / "shadow.tga", 64, shadow)

    write_tga(OUT / "pointer.tga", 32, supersample(32, lambda x, y: point_in_polygon(x, y, [(4, 6), (28, 6), (16, 26)])))

    write_tga(OUT / "close.tga", 32, supersample(32, lambda x, y: min(
        segment_distance(x, y, 9, 9, 23, 23), segment_distance(x, y, 23, 9, 9, 23)) <= 2.2))

    write_tga(OUT / "check.tga", 32, supersample(32, lambda x, y: min(
        segment_distance(x, y, 6, 17, 13, 24), segment_distance(x, y, 13, 24, 26, 8)) <= 2.6))

    def pin(x, y):
        head = math.hypot(x - 16, y - 12) <= 9
        tail = point_in_polygon(x, y, [(8.5, 15), (23.5, 15), (16, 29)])
        hole = math.hypot(x - 16, y - 12) <= 3.5
        return (head or tail) and not hole
    write_tga(OUT / "pin.tga", 32, supersample(32, pin))
    print("wrote", ", ".join(sorted(p.name for p in OUT.glob("*.tga"))), "to", OUT)


if __name__ == "__main__":
    main()
