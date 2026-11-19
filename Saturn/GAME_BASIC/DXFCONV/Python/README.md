# DXFCONV in Python

Python versions of the DXFCONV tools from the GAME BASIC for SEGA SATURN CD. They turn the 3DFACE data in a DXF file into GAME BASIC `DATA` lines for `SETVERTEX` and `SETPOLYGON`. They need Python 3.7 or later and nothing else.

| Script | Original | What it does |
|---|---|---|
| `dxf2pol.py` | `SOURCE/DXF2POL.C` | DXF to `.POL` (the 3DFACE list) |
| `pol2bas.py` | `SOURCE/POL2BAS.C` | `.POL` to `.VTX` + `.PNT`, all polygons as one object |
| `pol2bas2.py` | `SOURCE/POL2BAS2.C` | `.POL` to `.VTX` + `.PNT`, one object per layer |
| `dxfconv.py` | `DXFCONV.EXE` (no source) | DXF straight to a `.B` program |
| `c_stdio.py` | | the C runtime behaviour the tools depend on |
| `test_dxfconv.py` | | tests |

Each script writes the same bytes as the original program, CR LF line ends included. On `SAMPLE/ASCII` and `SAMPLE/GIRL` the `.POL`, `.VTX` and `.PNT` files come out identical to the ones on the CD. The sample `.VTX` and `.PNT` files were made with POL2BAS2.

## Use

The two-step tools take the same command line as the DOS versions: one file name, with the extension optional.

```
python3 dxf2pol.py GIRL          # GIRL.DXF -> GIRL.POL
python3 pol2bas.py GIRL          # GIRL.POL -> GIRL.VTX, GIRL.PNT
python3 pol2bas2.py ASCII        # ASCII.POL -> ASCII.VTX, ASCII.PNT; lists the layers
```

With no file name they use `DAT.DXF` / `DAT.POL` and write `DAT.*`. The outputs go next to the input.

`dxfconv.py` does the whole job in one go, as the Windows program does:

```
python3 dxfconv.py GIRL.DXF                # -> GIRL.B (VTX + PNT data)
python3 dxfconv.py GIRL.DXF --head         # HEADBAS.B + data, ready to send and RUN
python3 dxfconv.py ASCII.DXF --group       # one object per layer
python3 dxfconv.py ASCII.DXF ASCII.B --group --head MYHEAD.B
```

`--head` with no file uses `HEADBAS.B` from this folder or the `DXFCONV` folder above it.

To test:

```
python3 test_dxfconv.py
```

## What DXFCONV.EXE does

DXFCONV.EXE is an MFC front end for the three DOS tools; its machine code shows the steps:

1. Copy the chosen DXF file to `DAT.DXF` in the Windows temporary folder and make that the current folder.
2. Run `DXF2POL.EXE` from the program's own folder, with its screen output going to `DAT.LOG`.
3. Run `POL2BAS.EXE` for "Convert" (変換実行), or `POL2BAS2.EXE` for "Convert (with group information)".
4. Join `DAT.VTX` and `DAT.PNT` byte for byte into `DAT.BAS`.
5. If "Add display program" is ticked, join `HEADBAS.B` (from the program's folder) and `DAT.BAS` into `DAT.TMP`.
6. Copy the result to the chosen file (the DXF name with `.B` if none was given), then delete the `DAT.*` files.

The README says the group conversion cannot add the display program; the code does not prevent it, but `HEADBAS.B` only sets up one object, so it suits the normal conversion. For `--group`, use a display program with one object per layer.

`SAMPLE/GIRL.B` is a display program followed by `GIRL.VTX` and `GIRL.PNT`, exactly as step 5 builds it. `SAMPLE/ASCII.B` is built the same way from the group conversion, except that line 20122 carries 24 trailing spaces that no tool writes.

## File formats

`.POL`, one record of eight lines per 3DFACE, then a record of `-1`s:

```
1                                 polygon number, from 1
4                                 3 when corners 3 and 4 are the same point
Surf16                            layer (group code 8)
1                                 colour (group code 62)
6.806497  0.130415  5.165959      corner 1 (codes 10, 20, 30)
6.806499  2.130415  5.165959      corner 2 (11, 21, 31)
6.806498  2.130416  -3.134030     corner 3 (12, 22, 32)
6.806496  0.130416  -3.134030     corner 4 (13, 23, 33)
```

`.VTX` and `.PNT`:

```
10000 REM  ----------             20000 REM ----------
10001 DATA  22                    20001 DATA 27
10002 DATA 6.806497 , 0.130415 , 5.165959
                                  20002 DATA , (0,1,2,3)
                                  20003 DATA , (3,2,4,5)
```

The vertex count line has two spaces after `DATA` in `.VTX` and one in `.PNT`, and the `REM` lines differ the same way. Vertex numbers count from 0 within each object. With POL2BAS2 the blocks follow one another and the line numbers carry on.

## Behaviour of the original code

These come straight from the C sources and are kept so the output matches:

- **Lines must end in CR LF.** The tools read in DOS text mode. A DXF file with CR-only line ends (classic Mac) reads as one long line; convert it first, as the README says. LF-only files work.
- **A face without a layer** (no group 8) gets `default` with no line end, so the `.POL` line reads `default0`. POL2BAS then takes the colour from the start of the next line, and every corner of that face moves along by one number. Give every face a layer.
- **Colour and vertex count are not used** by POL2BAS/POL2BAS2. A polygon is a triangle only when its third and fourth corners are the same vertex.
- **Vertices are shared** when x, y and z are exactly equal; the latest matching vertex wins. The first three corners of each object are always new vertices, even if they repeat.
- **A value line of exactly `3DFACE` or `EOF`** counts whatever its group code, so a layer called `EOF` ends the file.
- **Lines longer than 254 characters** are split in two, as `fgets` does, which throws the code/value pairs out of step.
- **Limits.** The originals have room for 3000 vertices and 1000 polygons per object and 100 layers, and go wrong past that. The Python versions carry on and show a warning.
- **File names.** A missing extension becomes `.DXF` or `.POL`. A name of one character or less is replaced by `DAT`, as in the original.

Where the original would hang or crash, the Python versions stop with a message instead: a DXF file with no `EOF` (the original shows `error` and leaves a `.POL` file without its end record; so does `dxf2pol.py`), and a `.POL` file with no `-1` record.
