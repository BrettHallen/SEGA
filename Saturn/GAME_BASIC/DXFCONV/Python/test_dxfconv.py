#!/usr/bin/env python3
# Created with Claude Opus 5.5, Nov 2026
# Guided by Brett Hallen
"""Tests for the Python DXFCONV tools.

    python3 test_dxfconv.py

Checks that the sample files in ../SAMPLE come out byte for byte, plus the
odd cases of the original C code. Uses only the standard library.
"""

import os
import shutil
import sys
import tempfile
import unittest

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)

import dxf2pol    # noqa: E402
import dxfconv    # noqa: E402
import pol2bas    # noqa: E402
import pol2bas2   # noqa: E402
from c_stdio import TextReader, atof, atoi, make_paths   # noqa: E402

SAMPLE = os.path.join(os.path.dirname(HERE), "SAMPLE")


def read(path):
    with open(path, "rb") as f:
        return f.read()


def write(path, text):
    """Write text with CR LF line ends, as a DOS program would."""
    with open(path, "wb") as f:
        f.write(text.replace("\n", "\r\n").encode("latin-1"))


def face(layer=None, colour=None, pts=((0, 0, 0), (1, 0, 0), (1, 1, 0),
                                       (0, 1, 0))):
    lines = ["0", "3DFACE"]
    if layer is not None:
        lines += ["8", layer]
    if colour is not None:
        lines += ["62", colour]
    for c, p in enumerate(pts):
        for a, v in enumerate(p):
            lines += [str(10 + c + 10 * a), str(v)]
    return lines


def dxf(*faces, eof=True):
    lines = ["0", "SECTION", "2", "ENTITIES"]
    for f in faces:
        lines += f
    lines += ["0", "ENDSEC"] + (["0", "EOF"] if eof else [])
    return "\n".join(lines) + "\n"


class Temp(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.mkdtemp()

    def tearDown(self):
        shutil.rmtree(self.tmp)

    def path(self, name):
        return os.path.join(self.tmp, name)


@unittest.skipUnless(os.path.isdir(SAMPLE), "no SAMPLE folder")
class Samples(Temp):
    """The sample outputs were made with DXF2POL and POL2BAS2."""

    def check(self, name):
        sample = os.path.join(SAMPLE, name)
        dxf2pol.convert(sample + ".DXF", self.path("OUT.POL"))
        self.assertEqual(read(self.path("OUT.POL")), read(sample + ".POL"))
        pol2bas2.convert(sample + ".POL", self.path("OUT.VTX"),
                         self.path("OUT.PNT"))
        self.assertEqual(read(self.path("OUT.VTX")), read(sample + ".VTX"))
        self.assertEqual(read(self.path("OUT.PNT")), read(sample + ".PNT"))

    def test_ascii(self):
        self.check("ASCII")

    def test_girl(self):
        self.check("GIRL")

    def test_girl_one_object(self):
        # GIRL has a single layer, so POL2BAS gives the same files.
        sample = os.path.join(SAMPLE, "GIRL")
        pol2bas.convert(sample + ".POL", self.path("OUT.VTX"),
                        self.path("OUT.PNT"))
        self.assertEqual(read(self.path("OUT.VTX")), read(sample + ".VTX"))
        self.assertEqual(read(self.path("OUT.PNT")), read(sample + ".PNT"))

    def test_ascii_layers(self):
        layers = pol2bas2.convert(os.path.join(SAMPLE, "ASCII.POL"),
                                  self.path("A.VTX"), self.path("A.PNT"))
        self.assertEqual(layers, ["Surf16\n", "Surf12\n", "Surf8\n",
                                  "Surf6\n", "Surf4\n"])

    def test_girl_b(self):
        # GIRL.B is a display program followed by GIRL.VTX and GIRL.PNT.
        sample = read(os.path.join(SAMPLE, "GIRL.B"))
        data = read(os.path.join(SAMPLE, "GIRL.VTX")) + \
            read(os.path.join(SAMPLE, "GIRL.PNT"))
        head = self.path("HEAD.B")
        with open(head, "wb") as f:
            f.write(sample[:len(sample) - len(data)])
        dxfconv.convert(os.path.join(SAMPLE, "GIRL.DXF"), self.path("GIRL.B"),
                        head_path=head)
        self.assertEqual(read(self.path("GIRL.B")), sample)

    def test_dxfconv_group(self):
        out = self.path("ASCII.B")
        dxfconv.convert(os.path.join(SAMPLE, "ASCII.DXF"), out, group=True)
        self.assertEqual(read(out), read(os.path.join(SAMPLE, "ASCII.VTX")) +
                         read(os.path.join(SAMPLE, "ASCII.PNT")))


class CRuntime(unittest.TestCase):
    def test_atoi(self):
        self.assertEqual(atoi("  62\n"), 62)
        self.assertEqual(atoi("1.000000\n"), 1)
        self.assertEqual(atoi("-7x"), -7)
        self.assertEqual(atoi("x"), 0)

    def test_atof(self):
        self.assertEqual(atof(" -3.5\n"), -3.5)
        self.assertEqual(atof("1e2"), 100.0)
        self.assertEqual(atof("1e"), 1.0)
        self.assertEqual(atof(".5"), 0.5)
        self.assertEqual(atof("abc"), 0.0)

    def test_fgets_splits_long_lines(self):
        with tempfile.TemporaryDirectory() as tmp:
            p = os.path.join(tmp, "x")
            write(p, "a" * 300 + "\nb\n")
            r = TextReader(p)
            self.assertEqual(r.fgets(), "a" * 254)
            self.assertEqual(r.fgets(), "a" * 46 + "\n")
            self.assertEqual(r.fgets(), "b\n")
            self.assertIsNone(r.fgets())

    def test_text_mode(self):
        with tempfile.TemporaryDirectory() as tmp:
            p = os.path.join(tmp, "x")
            with open(p, "wb") as f:
                f.write(b"a\r\nb\rc\n\x1ad\n")
            self.assertEqual(TextReader(p).text, "a\nb\rc\n")

    def test_paths(self):
        self.assertEqual(make_paths(None, "DXF", ["POL"]),
                         ("DAT.DXF", ["DAT.POL"]))
        self.assertEqual(make_paths("GIRL", "DXF", ["POL"]),
                         ("GIRL.DXF", ["GIRL.POL"]))
        self.assertEqual(make_paths("m/GIRL.dxf", "DXF", ["POL"]),
                         (os.path.join("m", "GIRL.dxf"),
                          [os.path.join("m", "GIRL.POL")]))


class Dxf2Pol(Temp):
    def convert(self, text):
        write(self.path("IN.DXF"), text)
        dxf2pol.convert(self.path("IN.DXF"), self.path("IN.POL"))
        return read(self.path("IN.POL")).decode("latin-1").replace("\r\n", "\n")

    END = "-1\n-1\n-1\n-1\n-1 -1 -1\n-1 -1 -1\n-1 -1 -1\n-1 -1 -1 \n"

    def test_quad_and_triangle(self):
        tri = ((0, 0, 0), (1, 0, 0), (1, 1, 0), (1, 1, 0))
        out = self.convert(dxf(face("A", "3"), face("B", "1.0", tri)))
        self.assertEqual(out, (
            "1\n4\nA\n3\n"
            "0.000000  0.000000  0.000000\n1.000000  0.000000  0.000000\n"
            "1.000000  1.000000  0.000000\n0.000000  1.000000  0.000000\n"
            "2\n3\nB\n1\n"
            "0.000000  0.000000  0.000000\n1.000000  0.000000  0.000000\n"
            "1.000000  1.000000  0.000000\n1.000000  1.000000  0.000000\n"
            + self.END))

    def test_default_layer_has_no_line_end(self):
        out = self.convert(dxf(face()))
        self.assertTrue(out.startswith("1\n4\ndefault0\n0.000000"))

    def test_other_entities_ignored(self):
        line = ["0", "LINE", "8", "X", "10", "9"]
        out = self.convert(dxf(face("A", "1"), line))
        self.assertEqual(out.count("\n"), 8 + 8)
        self.assertNotIn("9.0", out)

    def test_no_eof(self):
        with self.assertRaises(dxf2pol.ShortFile):
            self.convert(dxf(face("A", "1"), eof=False))

    def test_empty(self):
        self.assertEqual(self.convert(dxf()), self.END)


class Pol2Bas(Temp):
    def run_tool(self, tool, text):
        write(self.path("IN.DXF"), text)
        dxf2pol.convert(self.path("IN.DXF"), self.path("IN.POL"))
        tool.convert(self.path("IN.POL"), self.path("IN.VTX"),
                     self.path("IN.PNT"))
        return (read(self.path("IN.VTX")).decode().replace("\r\n", "\n"),
                read(self.path("IN.PNT")).decode().replace("\r\n", "\n"))

    def test_shared_vertices(self):
        a = ((0, 0, 0), (1, 0, 0), (1, 1, 0), (0, 1, 0))
        b = ((1, 0, 0), (2, 0, 0), (2, 1, 0), (1, 1, 0))
        vtx, pnt = self.run_tool(pol2bas, dxf(face("A", "1", a),
                                              face("A", "1", b)))
        self.assertIn("10001 DATA  6\n", vtx)
        self.assertEqual(pnt, "20000 REM ----------\n20001 DATA 2\n"
                              "20002 DATA , (0,1,2,3)\n"
                              "20003 DATA , (1,4,5,2)\n")

    def test_first_three_always_new(self):
        a = ((0, 0, 0), (0, 0, 0), (1, 1, 0), (1, 1, 0))
        vtx, pnt = self.run_tool(pol2bas, dxf(face("A", "1", a)))
        self.assertIn("10001 DATA  3\n", vtx)
        self.assertIn("20002 DATA , (0,1,2)\n", pnt)

    def test_last_match_wins(self):
        a = ((0, 0, 0), (0, 0, 0), (0, 0, 0), (0, 0, 0))
        vtx, pnt = self.run_tool(pol2bas, dxf(face("A", "1", a)))
        self.assertIn("20002 DATA , (0,1,2)\n", pnt)

    def test_layers(self):
        a = ((0, 0, 0), (1, 0, 0), (1, 1, 0), (0, 1, 0))
        b = ((5, 0, 0), (6, 0, 0), (6, 1, 0), (6, 1, 0))
        vtx, pnt = self.run_tool(pol2bas2, dxf(face("A", "1", a),
                                               face("B", "1", b),
                                               face("A", "1", a)))
        self.assertTrue(vtx.startswith("10000 REM  ----------\n"
                                       "10001 DATA  4\n"))
        self.assertIn("10006 REM  ----------\n10007 DATA  3\n", vtx)
        self.assertEqual(pnt, "20000 REM ----------\n20001 DATA 2\n"
                              "20002 DATA , (0,1,2,3)\n"
                              "20003 DATA , (0,1,2,3)\n"
                              "20004 REM ----------\n20005 DATA 1\n"
                              "20006 DATA , (0,1,2)\n")

    def test_no_end_record(self):
        write(self.path("IN.POL"), "1\n4\nA\n1\n0 0 0\n1 0 0\n1 1 0\n0 1 0\n")
        for tool in (pol2bas, pol2bas2):
            with self.assertRaises(pol2bas.BadPolFile):
                tool.convert(self.path("IN.POL"), self.path("IN.VTX"),
                             self.path("IN.PNT"))


if __name__ == "__main__":
    unittest.main()
