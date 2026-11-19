# Created with Claude Opus 5.5, Nov 2026
# Guided by Brett Hallen
"""Tests for saturn_bitmap.py (PNG <-> .0 / .1, Reference Manual pp. 105-106)."""
import os
import struct
import sys
import tempfile
import unittest

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

import saturn_bitmap as B  # noqa: E402

CD = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))),
                  "GAME_BASIC_CD")


class BitmapTests(unittest.TestCase):
    def test_colour_words(self):
        self.assertTrue(all(B.to5(B.to8(v)) == v for v in range(32)))
        # RGB(): red in bits 0-4, green 5-9, blue 10-14.
        self.assertEqual(B.word_from_rgb((255, 0, 0)), 0x001F)
        self.assertEqual(B.word_from_rgb((0, 255, 0)), 0x03E0)
        self.assertEqual(B.word_from_rgb((0, 0, 255)), 0x7C00)

    def test_png_to_1(self):
        px = [(0, 0, 0), None, (255, 255, 255), (255, 0, 0)]
        png = B.write_png_rgba(2, 2, px)
        w, h, back, idx = B.read_png(png)
        self.assertEqual((w, h, back, idx), (2, 2, px, None))
        data = B.encode_1(w, h, back)
        # Black is &H8000, transparent is 0, every visible dot has bit 15.
        self.assertEqual(struct.unpack(">6H", data), (2, 2, 0x8000, 0, 0xFFFF, 0x801F))
        self.assertEqual(B.read_png(B.saturn_to_png(data, "1"))[2], px)

    def test_png_to_0(self):
        px = [None, (255, 0, 0), (255, 0, 0), (0, 0, 255)]
        data, reduced = B.encode_0(2, 2, px)
        self.assertFalse(reduced)
        self.assertEqual(len(data), 4 + 512 + 4)
        dots = data[516:]
        self.assertEqual(dots[0], 0)  # transparent is always index 0
        self.assertEqual(dots[1], dots[2])
        pal = struct.unpack(">256H", data[4:516])
        self.assertEqual(pal[dots[1]], 0x001F)
        self.assertEqual(pal[dots[3]], 0x7C00)

    def test_many_colours_are_reduced(self):
        px = [(r * 8, g * 8, 0) for r in range(32) for g in range(32)]
        data, reduced = B.encode_0(32, 32, px)
        self.assertTrue(reduced)
        self.assertNotIn(0, data[516:])  # nothing became transparent

    def test_size_limits(self):
        with self.assertRaises(B.BitmapError):
            B.encode_1(513, 1, [(0, 0, 0)] * 513)
        with self.assertRaises(B.BitmapError):
            B.encode_1(1, 257, [(0, 0, 0)] * 257)

    def test_cli_names(self):
        with tempfile.TemporaryDirectory() as d:
            src = os.path.join(d, "my picture.png")
            with open(src, "wb") as fh:
                fh.write(B.write_png_rgba(1, 1, [(1, 2, 3)]))
            msg = B.convert(src)
            self.assertTrue(os.path.exists(os.path.join(d, "my picture.1")))
            self.assertIn("can't use the name", msg)
            msg = B.convert(src, os.path.join(d, "PIC.0"), colours256=True)
            self.assertNotIn("can't use", msg)
            other = os.path.join(d, "x.bmp")
            open(other, "wb").close()
            with self.assertRaises(B.BitmapError):
                B.convert(other)

    def test_setchr_16(self):
        # Ref. p. 154: 16-colour text patterns are 4 bits per dot, one DATA per row.
        px = [(255, 0, 0) if x < 4 else None for y in range(8) for x in range(8)]
        lines, count, reduced = B.setchr_lines(8, 8, px)
        self.assertEqual((count, reduced), (1, False))
        self.assertIn("PALETTE 4,17,RGB(31,0,0)", lines)
        i = lines.index("SETCHR 4,0,32,READ")
        self.assertEqual(lines[i + 1:i + 9], ["DATA 11110000"] * 8)

    def test_setchr_256_and_numbers(self):
        px = [None] * 63 + [(0, 0, 255)]
        lines, count, _ = B.setchr_lines(8, 8, px, colours=256, bg=5, first=64)
        self.assertIn("SETCHR 5,64,64,READ", lines)
        self.assertEqual(lines[-1], "DATA 0000000000000001")
        self.assertEqual(B.number_lines(["A", "B"], 100, 10), ["100 A", "110 B"])
        with self.assertRaises(B.BitmapError):
            B.setchr_lines(9, 8, [None] * 72)
        with self.assertRaises(B.BitmapError):
            B.setchr_lines(16, 8, [None] * 128, first=1023)

    def test_setchr_reduces_to_15_colours(self):
        px = [(x * 32, y * 32, 0) for y in range(8) for x in range(8)]
        lines, _, reduced = B.setchr_lines(8, 8, px)
        self.assertTrue(reduced)
        digits = "".join(l[5:] for l in lines if l.startswith("DATA "))
        self.assertLessEqual(len(set(digits) - {"0"}), 15)

    def test_sprite(self):
        # Ref. p. 177: SPRITE$ is 16x16, one byte per dot in row order (as G_BOMB.B builds it).
        px = [(0, 255, 0) if x == 15 else None for y in range(16) for x in range(32)]
        lines, count, reduced = B.sprite_lines(32, 16, px, first=10, palette=1)
        self.assertEqual((count, reduced), (2, False))
        self.assertIn("PALETTE 10,257,RGB(0,31,0)", lines)
        i = lines.index("SPRITE$(10)=READHEX$(256)")
        self.assertEqual(lines[i + 1:i + 17], ["DATA " + "00" * 15 + "01"] * 16)
        j = lines.index("SPRITE$(11)=READHEX$(256)")
        self.assertEqual(lines[j + 1:j + 17], ["DATA " + "00" * 16] * 16)
        with self.assertRaises(B.BitmapError):
            B.sprite_lines(8, 16, [None] * 128)
        with self.assertRaises(B.BitmapError):
            B.sprite_lines(32, 16, [None] * 512, first=255)

    def test_sprite_cli(self):
        with tempfile.TemporaryDirectory() as d:
            src = os.path.join(d, "SHIP.png")
            with open(src, "wb") as fh:
                fh.write(B.write_png_rgba(16, 16, [(255, 255, 255)] * 256))
            self.assertEqual(B.main([src, "--sprite", "--start", "100"]), 0)
            with open(os.path.join(d, "SHIP_spr.B"), "rb") as fh:
                text = fh.read().decode("ascii")
            self.assertIn("\r\n120 PALETTE 10,1,RGB(31,31,31)\r\n", text)
            self.assertIn("SPRITE$(0)=READHEX$(256)", text)
            self.assertEqual(text.count("DATA " + "01" * 16), 16)

    @unittest.skipUnless(os.path.isdir(CD), "GAME_BASIC_CD folder not present")
    def test_cd_files_round_trip(self):
        for name in ("SABA_BG.0", "HIBIKI_0.0", "TEKST.1", "TEKEND.1"):
            path = os.path.join(CD, name)
            if not os.path.exists(path):
                continue
            with open(path, "rb") as fh:
                data = fh.read()
            ext = name[-1]
            png = B.saturn_to_png(data, ext)
            w, h, px, idx = B.read_png(png)
            if ext == "0":
                again, _ = B.encode_0(w, h, px, idx, B.read_png_palette(png))
            else:
                again = B.encode_1(w, h, px)
            self.assertEqual(again, data, name)


if __name__ == "__main__":
    unittest.main()
