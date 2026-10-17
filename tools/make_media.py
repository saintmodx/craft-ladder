"""Draw Craft Ladder's few textures (white shapes, tinted in game) as 32-bit TGA files in CraftLadder/Media.

    python -I tools/make_media.py

round   64x64  rounded square (radius 14) for panels, buttons and bars: nine-sliced at 16 px
shadow  64x64  soft shadow around a rounded square: nine-sliced at 32 px
pointer 32x32  triangle pointing down: the "you are here" marker
close   32x32  an X
check   32x32  a tick
pin     32x32  a map pin
"""
import math
import struct
from pathlib import Path

OUT = Path(__file__).resolve().parent.parent / "CraftLadder" / "Media"
SS = 4  # supersampling per axis, for smooth edges


def write_tga(path, size, alpha):
    """White pixels with the given alpha (rows top to bottom)."""
    header = struct.pack("<BBBHHBHHHHBB", 0, 0, 2, 0, 0, 0, 0, 0, size, size, 32, 0x28)  # top-left origin, 8 alpha bits
    body = bytearray()
    for y in range(size):
        for x in range(size):
            a = max(0, min(255, int(round(alpha(x, y) * 255))))
            body += bytes((255, 255, 255, a))
    path.write_bytes(header + bytes(body))


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
