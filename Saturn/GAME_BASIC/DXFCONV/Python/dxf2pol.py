#!/usr/bin/env python3
# Created with Claude Opus 5.5, Nov 2026
# Guided by Brett Hallen
"""DXF2POL: pull the 3DFACE entities out of a DXF file into a .POL file.

    python3 dxf2pol.py                  # DAT.DXF -> DAT.POL
    python3 dxf2pol.py GIRL             # GIRL.DXF -> GIRL.POL
    python3 dxf2pol.py models/GIRL.DXF  # models/GIRL.DXF -> models/GIRL.POL

A Python version of SOURCE/DXF2POL.C (DXF2pol.exe Ver 1.00) that writes the
same bytes. Only the first file name on the command line is used.

The DXF file is read as pairs of lines: a group code, then its value. Each
"3DFACE" starts a new polygon; group 8 gives its layer, 62 its colour, and
10-13 / 20-23 / 30-33 the x / y / z of its four corners. "EOF" ends the file.

Each polygon in the .POL file is eight lines (CR LF line ends):

    polygon number (from 1)
    3 or 4 (3 when corners 3 and 4 are the same point)
    layer name
    colour
    x1  y1  z1          six decimals, two spaces between
    x2  y2  z2
    x3  y3  z3
    x4  y4  z4

then an end record with -1 in every field.

Behaviour kept from the C source:

  * A face with no group 8 gets the layer "default" with no line end, so
    the layer and colour come out on one line ("default0"). POL2BAS then
    reads that line as the layer name and takes the colour from the next
    line, which shifts the corners. Give every face a layer to avoid it.
  * Any value line that reads exactly "3DFACE" or "EOF" counts, whatever
    its group code.
  * Lines must end in CR LF (DOS); a file with CR only reads as one line.
  * If the file ends before "EOF", "error" is shown and the faces read so
    far are written without the end record.
"""

import sys

from c_stdio import TextReader, TextWriter, atof, atoi, make_paths

START = "3DFACE\n"
END = "EOF\n"
DEFAULT_LAYER = "default"   # no "\n": see the module notes
DEFAULT_COLOUR = 0

# The group codes that set the four corners: code -> (corner, axis).
CORNER_CODES = {10 + 10 * axis + corner: (corner, axis)
                for corner in range(4) for axis in range(3)}


class ShortFile(Exception):
    """The DXF file ended before its EOF marker."""


def convert(infile, outfile):
    """Convert one DXF file to a .POL file. Returns the number of faces."""
    src = TextReader(infile)
    out = TextWriter(outfile)
    pln = 0
    started = False          # cvsflag: a face is waiting to be written
    in_face = False          # cvfl: the current entity is a 3DFACE
    pts = [[0.0, 0.0, 0.0] for _ in range(4)]
    layer = ""
    colour = 0

    def write_face():
        nonlocal pln
        npt = 3 if pts[2] == pts[3] else 4
        pln += 1
        out.write("%i\n%i\n" % (pln, npt))
        out.write(layer)
        out.write("%i\n" % colour)
        for x, y, z in pts:
            out.write("%f  %f  %f\n" % (x, y, z))

    try:
        while True:
            code_line = src.fgets()
            value = src.fgets() if code_line is not None else None
            if value is None:
                raise ShortFile()
            code = atoi(code_line)

            if code == 0:
                in_face = value == START
            if in_face:
                if code in CORNER_CODES:
                    corner, axis = CORNER_CODES[code]
                    pts[corner][axis] = atof(value)
                elif code == 62:
                    colour = atoi(value)
                elif code == 8:
                    layer = value

            if value == START:
                if started:
                    write_face()
                started = True
                pts = [[0.0, 0.0, 0.0] for _ in range(4)]
                colour = DEFAULT_COLOUR
                layer = DEFAULT_LAYER
            if value == END:
                break

        if started:
            write_face()
        out.write("-1\n-1\n-1\n-1\n-1 -1 -1\n-1 -1 -1\n-1 -1 -1\n-1 -1 -1 \n")
    finally:
        out.close()
    return pln


def main(argv=None):
    args = sys.argv[1:] if argv is None else argv
    infile, (outfile,) = make_paths(args[0] if args else None, "DXF", ["POL"])
    print("DXF2pol.exe Ver 1.00\n")
    try:
        convert(infile, outfile)
    except FileNotFoundError:
        print("READ OPEN error")
        return 1
    except ShortFile:
        print("error")
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
