#!/usr/bin/env python3
# Created with Claude Opus 5.5, Nov 2026
# Guided by Brett Hallen
"""POL2BAS2: turn a .POL file into GAME BASIC DATA lines, one object per layer.

    python3 pol2bas2.py                 # DAT.POL -> DAT.VTX + DAT.PNT
    python3 pol2bas2.py ASCII           # ASCII.POL -> ASCII.VTX + ASCII.PNT

A Python version of SOURCE/POL2BAS2.C (POL2bas2.exe Ver 1.00) that writes
the same bytes. Only the first file name on the command line is used.

It works like pol2bas.py, but makes one object for each layer name, in the
order the layers first appear. Each object has its own REM / count / DATA
block, and the line numbers carry on from one block to the next:

    10000 REM  ----------           20000 REM ----------
    10001 DATA  <vertices>          20001 DATA <polygons>
    10002 DATA x , y , z ...        20002 DATA , (a,b,c,d) ...
    10024 REM  ----------           20029 REM ----------
    ...                             ...

Vertex numbers start again from 0 in each object. The layer names and the
number of layers are shown first; the GAME BASIC program needs one object
per layer (for example FOR I=1 TO <layers> around SETVERTEX, SETPOLYGON and
SETATR).

The notes in pol2bas.py about shared vertices and the 3000 / 1000 limits
apply to each layer. The original also has room for 100 layers.
"""

import sys

from c_stdio import TextReader, TextWriter, make_paths
from pol2bas import BadPolFile, Mesh, _keep, write_mesh

MAX_LAYERS = 100


def list_layers(src):
    """checklayer(): the layer names in first-seen order, read line by line."""
    layers = []
    i = 0
    layer = ""
    while i != -1:
        if src.at_eof():
            raise BadPolFile("no end record (-1)")
        i = _keep(src.scan_int(), i)        # fscanf "%d\n" polygon number
        src.skip_space()
        src.fgets()                         # vertex count
        layer = _keep(src.fgets(), layer)   # layer name
        for _ in range(5):                  # colour and four corners
            src.fgets()
        if i != -1 and layer not in layers:
            layers.append(layer)
    return layers


def convert(infile, vtxfile, pntfile):
    """Convert a .POL file to .VTX and .PNT. Returns the layer names."""
    src = TextReader(infile)
    layers = list_layers(src)
    if len(layers) > MAX_LAYERS:
        print("warning: %d layers; the original program stops working past %d"
              % (len(layers), MAX_LAYERS), file=sys.stderr)

    meshes = []
    for name in layers:
        src.rewind()
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
            src.scan_int()                      # fscanf "%d\n" colour
            src.skip_space()
            if i != -1 and layer == name:
                mesh.read_polygon(src)
            else:
                for _ in range(4):
                    src.fgets()
        mesh.warn_if_too_big("layer " + name.rstrip("\n"))
        meshes.append(mesh)

    vtx = TextWriter(vtxfile)
    pnt = TextWriter(pntfile)
    try:
        ln1, ln2 = 10000, 20000
        for mesh in meshes:
            ln1, ln2 = write_mesh(mesh, vtx, pnt, ln1, ln2)
    finally:
        vtx.close()
        pnt.close()
    return layers


def main(argv=None):
    args = sys.argv[1:] if argv is None else argv
    infile, (vtxfile, pntfile) = make_paths(args[0] if args else None,
                                            "POL", ["VTX", "PNT"])
    print("POL2bas2.exe Ver 1.00\n")
    try:
        layers = convert(infile, vtxfile, pntfile)
    except FileNotFoundError:
        print("READ OPEN error")
        return 1
    except BadPolFile as e:
        print("error: %s" % e)
        return 1
    sys.stdout.flush()
    sys.stdout.buffer.write("".join(layers).encode("latin-1"))
    sys.stdout.buffer.flush()
    print(len(layers))
    return 0


if __name__ == "__main__":
    sys.exit(main())
