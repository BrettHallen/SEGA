#!/usr/bin/env python3
# Created with Claude Opus 5.5, Nov 2026
# Guided by Brett Hallen
"""DXFCONV: convert a DXF file straight to a GAME BASIC .B file.

    python3 dxfconv.py GIRL.DXF                 # -> GIRL.B (VTX + PNT data)
    python3 dxfconv.py GIRL.DXF --head          # HEADBAS.B + data: runs as-is
    python3 dxfconv.py ASCII.DXF --group        # one object per layer
    python3 dxfconv.py GIRL.DXF OUT.B --head MYHEAD.B

A command-line version of the Windows 95 program DXFCONV.EXE, which has no
source. Its machine code shows that it is a front end for the three DOS
tools. It copies the DXF file to DAT.DXF in the temporary folder, runs
DXF2POL.EXE there, then POL2BAS.EXE ("Convert") or POL2BAS2.EXE ("Convert
(with group information)"). It joins DAT.VTX and DAT.PNT byte for byte into
DAT.BAS, and with "Add display program" ticked puts HEADBAS.B (from its own
folder) in front. The result is copied to the chosen file, by default the
DXF name with the extension .B, and the DAT.* files are deleted.

This script does the same with dxf2pol.py, pol2bas.py and pol2bas2.py, so
the output is the same bytes. The DXF and POL rules are in those scripts.

--head with no file name uses HEADBAS.B from this folder or the DXFCONV
folder above it. HEADBAS.B is the simple display program for one object
(SETVERTEX 1 / SETPOLYGON 1), so it suits the normal conversion. The
original README says the group conversion cannot add it, although the
program itself does not stop it; for --group, write a display program with
one object per layer (FOR I=1 TO <layers>) and pass it to --head.
"""

import argparse
import os
import sys
import tempfile

import dxf2pol
import pol2bas
import pol2bas2

HERE = os.path.dirname(os.path.abspath(__file__))
HEAD_NAME = "HEADBAS.B"


def find_head():
    for folder in (HERE, os.path.dirname(HERE)):
        path = os.path.join(folder, HEAD_NAME)
        if os.path.isfile(path):
            return path
    return None


def convert(dxf_path, b_path, head_path=None, group=False):
    """Convert dxf_path to b_path. Returns the layer names (group) or None."""
    with tempfile.TemporaryDirectory() as tmp:
        pol = os.path.join(tmp, "DAT.POL")
        vtx = os.path.join(tmp, "DAT.VTX")
        pnt = os.path.join(tmp, "DAT.PNT")
        dxf2pol.convert(dxf_path, pol)
        layers = None
        if group:
            layers = pol2bas2.convert(pol, vtx, pnt)
        else:
            pol2bas.convert(pol, vtx, pnt)
        data = b""
        if head_path:
            with open(head_path, "rb") as f:
                data = f.read()
        for path in (vtx, pnt):
            with open(path, "rb") as f:
                data += f.read()
    with open(b_path, "wb") as f:
        f.write(data)
    return layers


def main(argv=None):
    ap = argparse.ArgumentParser(
        description="Convert the 3DFACE data in a DXF file to a GAME BASIC "
                    "for SEGA SATURN program (.B).")
    ap.add_argument("dxf", help="DXF file to convert")
    ap.add_argument("output", nargs="?",
                    help="file to write (default: the DXF name with .B)")
    ap.add_argument("--head", nargs="?", const="", metavar="FILE",
                    help="put a display program in front; with no FILE, "
                         "HEADBAS.B")
    ap.add_argument("--group", action="store_true",
                    help="make one object per layer (POL2BAS2)")
    args = ap.parse_args(argv)

    output = args.output or os.path.splitext(args.dxf)[0] + ".B"
    head = None
    if args.head is not None:
        head = args.head or find_head()
        if not head or not os.path.isfile(head):
            print("cannot find %s" % (args.head or HEAD_NAME), file=sys.stderr)
            return 1
    if not os.path.isfile(args.dxf):
        print("cannot open %s" % args.dxf, file=sys.stderr)
        return 1

    try:
        layers = convert(args.dxf, output, head, args.group)
    except dxf2pol.ShortFile:
        print("error: %s ends before its EOF marker" % args.dxf,
              file=sys.stderr)
        return 1
    except pol2bas.BadPolFile as e:
        print("error: %s" % e, file=sys.stderr)
        return 1

    print("wrote %s" % output)
    if layers is not None:
        names = ", ".join(n.rstrip("\n").encode("latin-1").decode(
            "cp932", "replace") for n in layers)
        print("%d layers: %s" % (len(layers), names))
    return 0


if __name__ == "__main__":
    sys.exit(main())
