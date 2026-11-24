#!/usr/bin/env python3
# Created with Claude Opus 5.5, Nov 2026
# Guided by Brett Hallen
"""Convert between PNG and GAME BASIC for SEGA SATURN bitmap files (.0 / .1).

    python3 saturn_bitmap.py PICTURE.png              # -> PICTURE.1 (32768 colours)
    python3 saturn_bitmap.py PICTURE.png --256        # -> PICTURE.0 (256 colours)
    python3 saturn_bitmap.py TEKST.1                  # -> TEKST.png
    python3 saturn_bitmap.py SABA_BG.0 -o saba.png
    python3 saturn_bitmap.py FONT.png --setchr        # -> FONT_chr.B (SETCHR + DATA)
    python3 saturn_bitmap.py TILES.png --setchr 256 --first 64
    python3 saturn_bitmap.py SHIP.png --sprite         # -> SHIP_spr.B (SPRITE$ + DATA)

The Saturn reads these with GLOAD and writes them with GSAVE. Format, from the
Reference Manual pp. 105-106 (and checked against SABA_BG.0, HIBIKI_0.0,
TEKST.1 and TEKEND.1 on the GAME BASIC CD); every number is big-endian:

  .0  width (2), height (2), palette (256 x 2 bytes), 1 byte per dot.
      Dot value 0 is always transparent, whatever palette entry 0 holds.
  .1  width (2), height (2), 2 bytes per dot. Bit 15 is set on every
      visible dot (black is &H8000); the value 0 is transparent.

Colours are 5 bits each: red in bits 0-4, green 5-9, blue 10-14, as RGB().
Width is 1-512 and height 1-256.

--setchr turns a PNG into 8x8 character patterns as GAME BASIC lines:
SETCHR <BG>,<pattern>,1,READ (the count is a number of patterns) followed by one hex DATA line per dot row
(Reference Manual pp. 152-154), plus PALETTE lines for the colours. The
picture is cut into 8x8 cells, left to right, top to bottom. "16" makes
16-colour patterns for the text screen (4 bits per dot, 32 bytes each, up to
15 colours); "256" makes 256-colour patterns for a character screen (1 byte
per dot, 64 bytes each, up to 255 colours). Dot value 0 is transparent.

--sprite turns a PNG into 16x16 sprite patterns as GAME BASIC lines:
SPRITE$(<pattern>)=READHEX$(256) followed by 16 hex DATA lines, one per dot
row (Reference Manual pp. 161, 177). A sprite pattern is always 16x16 with
one byte per dot in row order, as G_BOMB.B on the CD builds them; dot value 0
is transparent. Up to 255 colours go into the sprite palette with
PALETTE 10 (entries 1-255 for SETSPRITE palette 0, 257-511 for palette 1).
The picture is cut into 16x16 cells, left to right, top to bottom.

Plain Python 3, no packages needed. PNG transparency (alpha below 128, or a
tRNS colour) becomes the Saturn's transparent value. A PNG with more than 255
colours is reduced with median cut when --256 is used.
"""
from __future__ import annotations

import argparse
import math
import os
import re
import struct
import sys
import zlib
from typing import Dict, List, Optional, Sequence, Tuple

MAX_W, MAX_H = 512, 256
Pixel = Optional[Tuple[int, int, int]]  # 8-bit RGB, or None for transparent

SATURN_NAME_RE = re.compile(r"[A-Z0-9_]{1,8}\.[B01D]", re.IGNORECASE)


class BitmapError(Exception):
    pass


# ------------------------------------------------------------------ colour

def to5(v: int) -> int:
    """8-bit channel to 5 bits, rounded."""
    return (v * 31 + 127) // 255


def to8(v: int) -> int:
    """5-bit channel to 8 bits (exact inverse of to5 for 0-31)."""
    return (v << 3) | (v >> 2)


def word_from_rgb(rgb: Tuple[int, int, int]) -> int:
    r, g, b = rgb
    return to5(r) | (to5(g) << 5) | (to5(b) << 10)


def rgb_from_word(w: int) -> Tuple[int, int, int]:
    return to8(w & 31), to8((w >> 5) & 31), to8((w >> 10) & 31)


# ------------------------------------------------------------------ PNG in

def _paeth(a: int, b: int, c: int) -> int:
    p = a + b - c
    pa, pb, pc = abs(p - a), abs(p - b), abs(p - c)
    if pa <= pb and pa <= pc:
        return a
    return b if pb <= pc else c


def read_png(data: bytes) -> Tuple[int, int, List[Pixel], Optional[List[int]]]:
    """Decode a PNG. Returns (width, height, pixels, palette_indices).

    palette_indices is set only for palette PNGs, so their colour order can be
    kept; pixels holds 8-bit RGB tuples, or None where the PNG is transparent.
    """
    if data[:8] != b"\x89PNG\r\n\x1a\n":
        raise BitmapError("not a PNG file")
    pos = 8
    ihdr = None
    plte: List[Tuple[int, int, int]] = []
    trns = b""
    idat = []
    while pos + 8 <= len(data):
        length, ctype = struct.unpack(">I4s", data[pos:pos + 8])
        body = data[pos + 8:pos + 8 + length]
        pos += 12 + length
        if ctype == b"IHDR":
            ihdr = struct.unpack(">IIBBBBB", body)
        elif ctype == b"PLTE":
            plte = [tuple(body[i:i + 3]) for i in range(0, len(body) - 2, 3)]  # type: ignore[misc]
        elif ctype == b"tRNS":
            trns = body
        elif ctype == b"IDAT":
            idat.append(body)
        elif ctype == b"IEND":
            break
    if ihdr is None:
        raise BitmapError("PNG has no IHDR chunk")
    w, h, depth, ctype_, _comp, _filt, interlace = ihdr
    if interlace:
        raise BitmapError("interlaced PNGs aren't supported; save it again without interlacing")
    channels = {0: 1, 2: 3, 3: 1, 4: 2, 6: 4}.get(ctype_)
    if channels is None or depth not in (1, 2, 4, 8, 16):
        raise BitmapError(f"unsupported PNG type (colour type {ctype_}, depth {depth})")
    raw = zlib.decompress(b"".join(idat))
    bits = channels * depth
    bpp = max(1, bits // 8)
    stride = (w * bits + 7) // 8
    rows = []
    prev = bytearray(stride)
    i = 0
    for _ in range(h):
        ftype = raw[i]
        line = bytearray(raw[i + 1:i + 1 + stride])
        i += 1 + stride
        for x in range(stride):
            a = line[x - bpp] if x >= bpp else 0
            b = prev[x]
            c = prev[x - bpp] if x >= bpp else 0
            if ftype == 1:
                line[x] = (line[x] + a) & 255
            elif ftype == 2:
                line[x] = (line[x] + b) & 255
            elif ftype == 3:
                line[x] = (line[x] + ((a + b) >> 1)) & 255
            elif ftype == 4:
                line[x] = (line[x] + _paeth(a, b, c)) & 255
            elif ftype != 0:
                raise BitmapError(f"bad PNG filter type {ftype}")
        rows.append(bytes(line))
        prev = line

    def samples(row: bytes) -> List[int]:
        if depth == 8:
            return list(row)
        if depth == 16:
            return [row[k] for k in range(0, len(row), 2)]  # keep the high byte
        out = []
        mask = (1 << depth) - 1
        for byte in row:
            for shift in range(8 - depth, -1, -depth):
                out.append((byte >> shift) & mask)
        return out

    scale = {1: 255, 2: 85, 4: 17, 8: 1, 16: 1}[depth]
    trns_key = None
    if ctype_ == 0 and len(trns) >= 2:
        trns_key = struct.unpack(">H", trns[:2])[0]
        if depth == 16:
            trns_key >>= 8
    elif ctype_ == 2 and len(trns) >= 6:
        k = struct.unpack(">HHH", trns[:6])
        trns_key = tuple(v >> 8 for v in k) if depth == 16 else k
    pal_alpha = list(trns) + [255] * (256 - len(trns)) if ctype_ == 3 else []

    pixels: List[Pixel] = []
    indices: Optional[List[int]] = [] if ctype_ == 3 else None
    for row in rows:
        s = samples(row)
        for x in range(w):
            if ctype_ == 3:
                idx = s[x]
                if idx >= len(plte):
                    raise BitmapError("PNG palette index out of range")
                indices.append(idx)  # type: ignore[union-attr]
                pixels.append(plte[idx] if pal_alpha[idx] >= 128 else None)
            elif ctype_ == 0:
                v = s[x]
                pixels.append(None if v == trns_key else (v * scale,) * 3)  # type: ignore[arg-type]
            elif ctype_ == 4:
                v, al = s[2 * x], s[2 * x + 1]
                pixels.append((v, v, v) if al >= 128 else None)
            elif ctype_ == 2:
                rgb = tuple(s[3 * x:3 * x + 3])
                pixels.append(None if rgb == trns_key else rgb)  # type: ignore[arg-type]
            else:
                r, g, b, al = s[4 * x:4 * x + 4]
                pixels.append((r, g, b) if al >= 128 else None)
    if ctype_ == 3:
        return w, h, pixels, indices
    return w, h, pixels, None


def read_png_palette(data: bytes) -> List[Tuple[int, int, int]]:
    """The PLTE entries of a PNG (empty if it has none)."""
    pos = 8
    while pos + 8 <= len(data):
        length, ctype = struct.unpack(">I4s", data[pos:pos + 8])
        if ctype == b"PLTE":
            body = data[pos + 8:pos + 8 + length]
            return [tuple(body[i:i + 3]) for i in range(0, len(body) - 2, 3)]  # type: ignore[misc]
        pos += 12 + length
    return []


# ----------------------------------------------------------------- PNG out

def _chunk(ctype: bytes, body: bytes) -> bytes:
    return (struct.pack(">I", len(body)) + ctype + body
            + struct.pack(">I", zlib.crc32(ctype + body) & 0xFFFFFFFF))


def write_png_rgba(w: int, h: int, pixels: Sequence[Pixel]) -> bytes:
    raw = bytearray()
    for y in range(h):
        raw.append(0)
        for p in pixels[y * w:(y + 1) * w]:
            raw += bytes((0, 0, 0, 0)) if p is None else bytes((p[0], p[1], p[2], 255))
    return (b"\x89PNG\r\n\x1a\n" + _chunk(b"IHDR", struct.pack(">IIBBBBB", w, h, 8, 6, 0, 0, 0))
            + _chunk(b"IDAT", zlib.compress(bytes(raw), 9)) + _chunk(b"IEND", b""))


def write_png_indexed(w: int, h: int, indices: Sequence[int],
                      palette: Sequence[Tuple[int, int, int]]) -> bytes:
    """Palette PNG; entry 0 is marked transparent, as on the Saturn."""
    raw = bytearray()
    for y in range(h):
        raw.append(0)
        raw += bytes(indices[y * w:(y + 1) * w])
    plte = b"".join(bytes(c) for c in palette)
    return (b"\x89PNG\r\n\x1a\n" + _chunk(b"IHDR", struct.pack(">IIBBBBB", w, h, 8, 3, 0, 0, 0))
            + _chunk(b"PLTE", plte) + _chunk(b"tRNS", b"\x00")
            + _chunk(b"IDAT", zlib.compress(bytes(raw), 9)) + _chunk(b"IEND", b""))


# ------------------------------------------------------------ Saturn files

def check_size(w: int, h: int) -> None:
    if not (1 <= w <= MAX_W and 1 <= h <= MAX_H):
        raise BitmapError(f"the picture is {w}x{h}; the Saturn takes up to {MAX_W}x{MAX_H}")


def encode_1(w: int, h: int, pixels: Sequence[Pixel]) -> bytes:
    check_size(w, h)
    out = bytearray(struct.pack(">HH", w, h))
    for p in pixels:
        out += struct.pack(">H", 0 if p is None else 0x8000 | word_from_rgb(p))
    return bytes(out)


def _median_cut(counts: Dict[int, int], n: int) -> Dict[int, int]:
    """Map each 15-bit colour to one of at most n representative colours."""
    boxes = [list(counts)]
    while len(boxes) < n:
        best = None
        for bi, box in enumerate(boxes):
            if len(box) < 2:
                continue
            spans = []
            for sh in (0, 5, 10):
                vals = [(c >> sh) & 31 for c in box]
                spans.append((max(vals) - min(vals), sh))
            span, sh = max(spans)
            score = span * sum(counts[c] for c in box)
            if span and (best is None or score > best[0]):
                best = (score, bi, sh)
        if best is None:
            break
        _, bi, sh = best
        box = sorted(boxes.pop(bi), key=lambda c: (c >> sh) & 31)
        total = sum(counts[c] for c in box)
        acc, cut = 0, 1
        for k, c in enumerate(box):
            acc += counts[c]
            if acc * 2 >= total:
                cut = min(max(k + 1, 1), len(box) - 1)
                break
        boxes += [box[:cut], box[cut:]]
    mapping: Dict[int, int] = {}
    for box in boxes:
        total = sum(counts[c] for c in box)
        avg = [round(sum(((c >> sh) & 31) * counts[c] for c in box) / total) for sh in (0, 5, 10)]
        rep = avg[0] | (avg[1] << 5) | (avg[2] << 10)
        for c in box:
            mapping[c] = rep
    return mapping


def encode_0(w: int, h: int, pixels: Sequence[Pixel], indices: Optional[List[int]] = None,
             png_palette: Optional[List[Tuple[int, int, int]]] = None) -> Tuple[bytes, bool]:
    """Returns (file bytes, reduced) where reduced says colours were merged."""
    check_size(w, h)
    # A palette PNG whose index 0 is the only see-through colour (or unused)
    # keeps its own colour order, so .0 -> PNG -> .0 gives back the same file.
    if (indices is not None and png_palette is not None and len(png_palette) <= 256
            and all((p is None) == (i == 0) for i, p in zip(indices, pixels))):
        pal = [word_from_rgb(c) for c in png_palette] + [0] * (256 - len(png_palette))
        return struct.pack(">HH", w, h) + struct.pack(">256H", *pal) + bytes(indices), False
    counts: Dict[int, int] = {}
    for p in pixels:
        if p is not None:
            k = word_from_rgb(p)
            counts[k] = counts.get(k, 0) + 1
    reduced = len(counts) > 255
    mapping = _median_cut(counts, 255) if reduced else {c: c for c in counts}
    reps = sorted(set(mapping.values()), key=lambda c: -sum(n for k, n in counts.items() if mapping[k] == c))
    index_of = {c: i + 1 for i, c in enumerate(reps)}
    pal = [0] + reps + [0] * (255 - len(reps))
    out = bytearray(struct.pack(">HH", w, h) + struct.pack(">256H", *pal))
    for p in pixels:
        out.append(0 if p is None else index_of[mapping[word_from_rgb(p)]])
    return bytes(out), reduced


def decode_saturn(data: bytes, ext: str):
    """Returns (w, h, kind, payload) for a .0 or .1 file."""
    if len(data) < 4:
        raise BitmapError("file too short")
    w, h = struct.unpack(">HH", data[:4])
    check_size(w, h)
    if ext == "0":
        need = 4 + 512 + w * h
        if len(data) < need:
            raise BitmapError(f"a {w}x{h} .0 file needs {need} bytes; this one has {len(data)}")
        pal = list(struct.unpack(">256H", data[4:516]))
        return w, h, "0", (pal, data[516:need])
    need = 4 + w * h * 2
    if len(data) < need:
        raise BitmapError(f"a {w}x{h} .1 file needs {need} bytes; this one has {len(data)}")
    words = struct.unpack(f">{w * h}H", data[4:need])
    return w, h, "1", words


def saturn_to_png(data: bytes, ext: str) -> bytes:
    w, h, kind, payload = decode_saturn(data, ext)
    if kind == "0":
        pal, dots = payload
        return write_png_indexed(w, h, dots, [rgb_from_word(c) for c in pal])
    return write_png_rgba(w, h, [None if v == 0 else rgb_from_word(v) for v in payload])


def clear_blocks(nbytes: int) -> int:
    """256-byte blocks of CLEAR file buffer GLOAD/GSAVE need (Ref. pp. 104, 107)."""
    return math.ceil(nbytes / 256)


# ------------------------------------------------------------ SETCHR DATA

def _palette_for(pixels: Sequence[Pixel], max_colours: int) -> Tuple[List[int], Dict[int, int], bool]:
    """Pick up to max_colours 15-bit colours. Returns (colours, word -> index, reduced).

    Index 0 is transparent, so the colours get indices 1..len(colours).
    """
    counts: Dict[int, int] = {}
    for p in pixels:
        if p is not None:
            k = word_from_rgb(p)
            counts[k] = counts.get(k, 0) + 1
    reduced = len(counts) > max_colours
    mapping = _median_cut(counts, max_colours) if reduced else {c: c for c in counts}
    weight: Dict[int, int] = {}
    for k, n in counts.items():
        weight[mapping[k]] = weight.get(mapping[k], 0) + n
    colours = sorted(weight, key=lambda c: -weight[c])
    index = {c: i + 1 for i, c in enumerate(colours)}
    return colours, {k: index[mapping[k]] for k in counts}, reduced


def setchr_lines(w: int, h: int, pixels: Sequence[Pixel], colours: int = 16, bg: int = 4,
                 first: int = 0, palette_code: Optional[int] = None,
                 with_palette: bool = True) -> Tuple[List[str], int, bool]:
    """GAME BASIC statements (no line numbers) that define the picture as characters.

    Returns (lines, number of characters, colours were reduced).
    """
    if colours not in (16, 256):
        raise BitmapError("--setchr takes 16 or 256")
    if w % 8 or h % 8:
        raise BitmapError(f"the picture is {w}x{h}; for characters both sides must be multiples of 8")
    cols, rows = w // 8, h // 8
    count = cols * rows
    limit = 1023 if colours == 16 else 511
    if not 0 <= first or first + count - 1 > limit:
        raise BitmapError(f"{count} characters from pattern {first} go past pattern {limit}")
    pal, index, reduced = _palette_for(pixels, 15 if colours == 16 else 255)
    if palette_code is None:
        palette_code = 1 if colours == 16 else 0
    out = [f"' {count} characters, {w // 8}x{h // 8} cells of 8x8, "
           f"{colours}-colour patterns {first}-{first + count - 1} on BG {bg}"
           f" (made by saturn_bitmap.py)"]
    if colours == 16:
        out.append(f"' Show one with PUTCHR {bg},(X,Y),<pattern>+&H{palette_code:X}000")
        base = palette_code * 16
    else:
        out.append(f"' Show one with PUTCHR {bg},(X,Y),<pattern>*2")
        base = palette_code * 256
    if with_palette and pal:
        values = [f"RGB({c & 31},{(c >> 5) & 31},{(c >> 10) & 31})" for c in pal]
        for i in range(0, len(values), 8):
            out.append(f"PALETTE {bg},{base + 1 + i}," + ",".join(values[i:i + 8]))
    for cy in range(rows):
        for cx in range(cols):
            pattern = first + cy * cols + cx
            out.append(f"SETCHR {bg},{pattern},1,READ")
            for y in range(8):
                row = pixels[(cy * 8 + y) * w + cx * 8:(cy * 8 + y) * w + cx * 8 + 8]
                vals = [0 if p is None else index[word_from_rgb(p)] for p in row]
                if colours == 16:
                    out.append("DATA " + "".join(f"{v:X}" for v in vals))
                else:
                    out.append("DATA " + "".join(f"{v:02X}" for v in vals))
    return out, count, reduced


def sprite_lines(w: int, h: int, pixels: Sequence[Pixel], first: int = 0, palette: int = 0,
                 with_palette: bool = True) -> Tuple[List[str], int, bool]:
    """GAME BASIC statements (no line numbers) that define the picture as SPRITE$ patterns.

    Returns (lines, number of patterns, colours were reduced).
    """
    if palette not in (0, 1):
        raise BitmapError("--sprite: the sprite palette is 0 or 1")
    if w % 16 or h % 16:
        raise BitmapError(f"the picture is {w}x{h}; for sprites both sides must be multiples of 16")
    cols, rows = w // 16, h // 16
    count = cols * rows
    if not 0 <= first or first + count - 1 > 255:
        raise BitmapError(f"{count} sprite patterns from pattern {first} go past pattern 255")
    pal, index, reduced = _palette_for(pixels, 255)
    noun = "pattern" if count == 1 else "patterns"
    out = [f"' {count} sprite {noun}, {cols}x{rows} cells of 16x16, "
           f"patterns {first}-{first + count - 1}, sprite palette {palette} (made by saturn_bitmap.py)",
           f"' Show one with SETSPRITE <sprite>,{palette} : PUTSPRITE <sprite>,(X,Y),<pattern>"]
    if with_palette and pal:
        values = [f"RGB({c & 31},{(c >> 5) & 31},{(c >> 10) & 31})" for c in pal]
        for i in range(0, len(values), 8):
            out.append(f"PALETTE 10,{palette * 256 + 1 + i}," + ",".join(values[i:i + 8]))
    for cy in range(rows):
        for cx in range(cols):
            out.append(f"SPRITE$({first + cy * cols + cx})=READHEX$(256)")
            for y in range(16):
                start = (cy * 16 + y) * w + cx * 16
                vals = [0 if p is None else index[word_from_rgb(p)] for p in pixels[start:start + 16]]
                out.append("DATA " + "".join(f"{v:02X}" for v in vals))
    return out, count, reduced


def number_lines(lines: List[str], start: Optional[int], step: int) -> List[str]:
    if start is None:
        return lines
    return [f"{start + i * step} {ln}" for i, ln in enumerate(lines)]


# --------------------------------------------------------------------- CLI

def convert(src: str, dst: Optional[str] = None, colours256: bool = False) -> str:
    ext = os.path.splitext(src)[1].lower()
    with open(src, "rb") as fh:
        data = fh.read()
    if ext == ".png":
        w, h, pixels, indices = read_png(data)
        if colours256:
            out, reduced = encode_0(w, h, pixels, indices, read_png_palette(data) if indices is not None else None)
            new_ext = ".0"
        else:
            out, reduced = encode_1(w, h, pixels), False
            new_ext = ".1"
        dst = dst or os.path.splitext(src)[0] + new_ext
        with open(dst, "wb") as fh:
            fh.write(out)
        name = os.path.basename(dst)
        msg = (f"Wrote {name}: {w}x{h}, {'256' if colours256 else '32768'} colours, {len(out)} bytes. "
               f"GLOAD needs a CLEAR file buffer of about {clear_blocks(len(out))} blocks.")
        if reduced:
            msg += " The picture had more than 255 colours, so they were reduced."
        if not SATURN_NAME_RE.fullmatch(name):
            msg += (f" Note: the Saturn can't use the name {name}; rename it to 1-8 letters,"
                    f" digits or _ plus {new_ext}.")
        return msg
    if ext in (".0", ".1"):
        out = saturn_to_png(data, ext[1])
        dst = dst or os.path.splitext(src)[0] + ".png"
        with open(dst, "wb") as fh:
            fh.write(out)
        w, h = struct.unpack(">HH", data[:4])
        return f"Wrote {os.path.basename(dst)}: {w}x{h}."
    raise BitmapError(f"don't know what to do with {ext or 'a file with no extension'}; give a .png, .0 or .1 file")


def convert_setchr(src: str, dst: Optional[str] = None, colours: int = 16, bg: int = 4,
                   first: int = 0, palette_code: Optional[int] = None, with_palette: bool = True,
                   start: Optional[int] = None, step: int = 10) -> str:
    if os.path.splitext(src)[1].lower() != ".png":
        raise BitmapError("--setchr needs a .png file")
    with open(src, "rb") as fh:
        w, h, pixels, _ = read_png(fh.read())
    lines, count, reduced = setchr_lines(w, h, pixels, colours, bg, first, palette_code, with_palette)
    lines = number_lines(lines, start, step)
    dst = dst or os.path.splitext(src)[0] + "_chr.B"
    with open(dst, "w", encoding="ascii", newline="\r\n") as fh:
        fh.write("\n".join(lines) + "\n")
    msg = f"Wrote {os.path.basename(dst)}: {count} characters, patterns {first}-{first + count - 1}."
    if start is None:
        msg += ' The lines have no numbers: #include it, or send with automatic line numbers.'
    if reduced:
        msg += f" The picture had more than {15 if colours == 16 else 255} colours, so they were reduced."
    return msg


def convert_sprite(src: str, dst: Optional[str] = None, first: int = 0, palette: int = 0,
                   with_palette: bool = True, start: Optional[int] = None, step: int = 10) -> str:
    if os.path.splitext(src)[1].lower() != ".png":
        raise BitmapError("--sprite needs a .png file")
    with open(src, "rb") as fh:
        w, h, pixels, _ = read_png(fh.read())
    lines, count, reduced = sprite_lines(w, h, pixels, first, palette, with_palette)
    lines = number_lines(lines, start, step)
    dst = dst or os.path.splitext(src)[0] + "_spr.B"
    with open(dst, "w", encoding="ascii", newline="\r\n") as fh:
        fh.write("\n".join(lines) + "\n")
    msg = (f"Wrote {os.path.basename(dst)}: {count} sprite pattern{'' if count == 1 else 's'}, "
           f"{first}-{first + count - 1}.")
    if start is None:
        msg += ' The lines have no numbers: #include it, or send with automatic line numbers.'
    if reduced:
        msg += " The picture had more than 255 colours, so they were reduced."
    return msg


def main(argv: Optional[List[str]] = None) -> int:
    ap = argparse.ArgumentParser(description="Convert PNG <-> GAME BASIC bitmap files (.0 / .1).")
    ap.add_argument("input", help="a .png, .0 or .1 file")
    ap.add_argument("-o", "--output", help="output file (default: same name, new extension)")
    ap.add_argument("--256", dest="colours256", action="store_true",
                    help="PNG -> .0 (256 colours) instead of .1 (32768 colours)")
    ap.add_argument("--setchr", nargs="?", const="16", choices=("16", "256"),
                    help="PNG -> SETCHR + DATA lines for 8x8 characters (16-colour text screen, or 256)")
    ap.add_argument("--sprite", action="store_true",
                    help="PNG -> SPRITE$ + DATA lines for 16x16 sprite patterns")
    ap.add_argument("--bg", type=int, default=4, help="--setchr: logical BG (default 4)")
    ap.add_argument("--first", type=int, default=0, help="--setchr/--sprite: first pattern number (default 0)")
    ap.add_argument("--palette", type=int, help="--setchr: palette code for the colours (default 1 for 16, 0 for 256); --sprite: sprite palette 0 or 1 (default 0)")
    ap.add_argument("--no-palette", action="store_true", help="--setchr/--sprite: leave out the PALETTE lines")
    ap.add_argument("--start", type=int, help="--setchr/--sprite: number the lines from here (default: no numbers)")
    ap.add_argument("--step", type=int, default=10, help="--setchr/--sprite: line number step (default 10)")
    a = ap.parse_args(argv)
    try:
        if a.sprite:
            print(convert_sprite(a.input, a.output, a.first, a.palette or 0, not a.no_palette,
                                 a.start, a.step))
            return 0
        if a.setchr:
            print(convert_setchr(a.input, a.output, int(a.setchr), a.bg, a.first, a.palette,
                                 not a.no_palette, a.start, a.step))
            return 0
        print(convert(a.input, a.output, a.colours256))
    except (BitmapError, OSError, zlib.error) as e:
        print(f"Error: {e}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
