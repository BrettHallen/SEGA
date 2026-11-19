#!/usr/bin/env python3
# Created with Claude Opus 5.5, Nov 2026
# Guided by Brett Hallen
"""POL2BAS: turn a .POL file into GAME BASIC DATA lines for one object.

    python3 pol2bas.py                  # DAT.POL -> DAT.VTX + DAT.PNT
    python3 pol2bas.py GIRL             # GIRL.POL -> GIRL.VTX + GIRL.PNT

A Python version of SOURCE/POL2BAS.C (POL2bas.exe Ver 1.00) that writes the
same bytes. Only the first file name on the command line is used. All the
polygons become one object; pol2bas2.py splits them by layer instead.

.VTX holds the vertex list, from line 10000:

    10000 REM  ----------
    10001 DATA  <number of vertices>
    10002 DATA x , y , z            one line per vertex, six decimals

.PNT holds the polygon list, from line 20000:

    20000 REM ----------
    20001 DATA <number of polygons>
    20002 DATA , (a,b,c,d)          vertex numbers, counted from 0
    20003 DATA , (a,b,c)            when corners 3 and 4 are the same vertex

These go after a display program such as HEADBAS.B, which reads them with
SETVERTEX and SETPOLYGON (see dxfconv.py).

Behaviour kept from the C source:

  * A corner that has exactly the same x, y and z as an earlier vertex
    reuses it (the latest match wins). The first three corners in the file
    are always new vertices, even if they repeat.
  * The colour and the vertex count in the .POL file are not used: a
    polygon is a triangle only when corners 3 and 4 match.
  * The original has room for 3000 vertices and 1000 polygons and goes
    wrong past that. This version carries on and shows a warning.
"""

import sys

from c_stdio import TextReader, TextWriter, make_paths

MAX_VERTICES = 3000
MAX_POLYGONS = 1000


class BadPolFile(Exception):
    """The .POL file ran out, or a number could not be read."""


class Mesh:
    """The vertex and polygon lists one object builds up (lx/ly/lz, p1-p4)."""

    def __init__(self):
        self.vertices = []
        self.polygons = []

    def read_polygon(self, src):
        """checkpoint(0..3): read four corners and add the polygon."""
        corners = []
        for _ in range(4):
            point = []
            for _ in range(3):
                value = src.scan_float()
                if value is None:
                    raise BadPolFile("could not read a corner")
                point.append(value)
            src.skip_space()
            corners.append(self.add_vertex(tuple(point)))
        self.polygons.append(corners)

    def add_vertex(self, point):
        if len(self.vertices) >= 3:
            match = -1
            for i, known in enumerate(self.vertices):
                if known == point:
                    match = i
            if match >= 0:
                return match
        self.vertices.append(point)
        return len(self.vertices) - 1

    def warn_if_too_big(self, name="the object"):
        if len(self.vertices) > MAX_VERTICES or len(self.polygons) > MAX_POLYGONS:
            print("warning: %s has %d vertices and %d polygons; the original "
                  "program stops working past %d and %d"
                  % (name, len(self.vertices), len(self.polygons),
                     MAX_VERTICES, MAX_POLYGONS), file=sys.stderr)


def write_mesh(mesh, vtx, pnt, ln1, ln2):
    """Write one object's lines and return the next line numbers."""
    vtx.write("%d REM  ----------\n" % ln1)
    pnt.write("%d REM ----------\n" % ln2)
    vtx.write("%d DATA  %d\n" % (ln1 + 1, len(mesh.vertices)))
    pnt.write("%d DATA %d\n" % (ln2 + 1, len(mesh.polygons)))
    ln1 += 2
    ln2 += 2
    for x, y, z in mesh.vertices:
        vtx.write("%d DATA %f , %f , %f\n" % (ln1, x, y, z))
        ln1 += 1
    for a, b, c, d in mesh.polygons:
        if c == d:
            pnt.write("%d DATA , (%d,%d,%d)\n" % (ln2, a, b, c))
        else:
            pnt.write("%d DATA , (%d,%d,%d,%d)\n" % (ln2, a, b, c, d))
        ln2 += 1
    return ln1, ln2


def convert(infile, vtxfile, pntfile):
    """Convert a .POL file to .VTX and .PNT. Returns the Mesh."""
    src = TextReader(infile)
    mesh = Mesh()
    i = 0
    layer = ""
    while i != -1:
        if src.at_eof():
            raise BadPolFile("no end record (-1)")
        i = _keep(src.scan_int(), i)        # fscanf "%d"   polygon number
        src.scan_int()                      # fscanf "%d\n" vertex count
        src.skip_space()
        layer = _keep(src.fgets(), layer)   # fgets         layer name
        src.scan_int()                      # fscanf "%d"   colour
        if i != -1:
            src.skip_space()
            mesh.read_polygon(src)
    mesh.warn_if_too_big()

    vtx = TextWriter(vtxfile)
    pnt = TextWriter(pntfile)
    try:
        write_mesh(mesh, vtx, pnt, 10000, 20000)
    finally:
        vtx.close()
        pnt.close()
    return mesh


def _keep(new, old):
    """A failed fscanf/fgets leaves the variable as it was."""
    return old if new is None else new


def main(argv=None):
    args = sys.argv[1:] if argv is None else argv
    infile, (vtxfile, pntfile) = make_paths(args[0] if args else None,
                                            "POL", ["VTX", "PNT"])
    print("POL2bas.exe Ver 1.00\n")
    try:
        convert(infile, vtxfile, pntfile)
    except FileNotFoundError:
        print("READ OPEN error")
        return 1
    except BadPolFile as e:
        print("error: %s" % e)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
