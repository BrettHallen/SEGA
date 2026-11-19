# Created with Claude Opus 5.5, Nov 2026
# Guided by Brett Hallen
"""The parts of the Windows C runtime that the DXFCONV tools rely on.

DXF2POL.C, POL2BAS.C and POL2BAS2.C read and write in text mode ("rt" and
"wt") with fgets, fscanf, atoi and atof. Their output depends on the exact
way those functions behave, including on odd input, so this module copies
that behaviour instead of using Python's own parsing:

  * Reading in text mode turns CR LF into LF, leaves a lone CR alone and
    stops at the first Ctrl-Z (0x1A).
  * Writing in text mode turns every LF into CR LF.
  * fgets(buf, 255, f) returns at most 254 characters, so a longer line is
    split across two calls.
  * fscanf and atof take the longest number they can at the current place
    and leave the rest; a failed conversion leaves the variable unchanged.
  * printf("%lf") prints six decimals, the same as Python's "%f".

Bytes are kept as Latin-1 text so that Shift-JIS layer names pass through
unchanged.
"""

import os
import re

# C isspace() in the "C" locale.
_SPACE = " \t\n\v\f\r"

# The longest prefix strtod/atof accepts: sign, digits with an optional
# point, then an optional exponent (only if it has digits).
_FLOAT_RE = re.compile(r"[+-]?(?:\d+\.?\d*|\.\d+)(?:[eE][+-]?\d+)?")
_INT_RE = re.compile(r"[+-]?\d+")


def _to_int32(value):
    """Wrap to a 32-bit signed int, as the C int would."""
    value &= 0xFFFFFFFF
    return value - 0x100000000 if value & 0x80000000 else value


def atoi(s):
    """C atoi: skip white space, then read an optional sign and digits."""
    m = _INT_RE.match(s.lstrip(_SPACE))
    return _to_int32(int(m.group())) if m else 0


def atof(s):
    """C atof: skip white space, then read the longest valid number."""
    m = _FLOAT_RE.match(s.lstrip(_SPACE))
    return float(m.group()) if m else 0.0


def read_text(path):
    """Read a whole file the way fopen(path, "rt") sees it."""
    with open(path, "rb") as f:
        data = f.read()
    cut = data.find(b"\x1a")
    if cut >= 0:
        data = data[:cut]
    return data.replace(b"\r\n", b"\n").decode("latin-1")


class TextReader:
    """A file opened with fopen(path, "rt"), read with fgets and fscanf."""

    def __init__(self, path):
        self.text = read_text(path)
        self.pos = 0

    def rewind(self):
        self.pos = 0

    def at_eof(self):
        return self.pos >= len(self.text)

    def fgets(self, size=255):
        """Return the next line (with its LF), or None at end of file."""
        if self.pos >= len(self.text):
            return None
        end = self.text.find("\n", self.pos, self.pos + size - 1)
        end = self.pos + size - 1 if end < 0 else end + 1
        line = self.text[self.pos:end]
        self.pos += len(line)
        return line

    def skip_space(self):
        """A white-space directive in a scanf format: skip any amount."""
        text, pos = self.text, self.pos
        while pos < len(text) and text[pos] in _SPACE:
            pos += 1
        self.pos = pos

    def _scan(self, regex, convert):
        self.skip_space()
        m = regex.match(self.text, self.pos)
        if not m:
            return None
        self.pos = m.end()
        return convert(m.group())

    def scan_int(self):
        """%d: returns the number, or None if nothing matched."""
        return self._scan(_INT_RE, lambda s: _to_int32(int(s)))

    def scan_float(self):
        """%lf: returns the number, or None if nothing matched."""
        return self._scan(_FLOAT_RE, float)


class TextWriter:
    """A file opened with fopen(path, "wt"): LF is written as CR LF."""

    def __init__(self, path):
        self.f = open(path, "wb")

    def write(self, s):
        self.f.write(s.replace("\n", "\r\n").encode("latin-1"))

    def close(self):
        self.f.close()


def make_paths(arg, default_ext, out_exts):
    """The file names DXF2POL/POL2BAS work out from the command line.

    With no argument the tools use DAT.<ext>. With one, a missing extension
    becomes default_ext, and the outputs go next to the input with the same
    name and each of out_exts. As in the original, a name of one character
    or less is replaced by DAT.
    """
    if arg is None:
        return ("DAT." + default_ext, ["DAT." + e for e in out_exts])
    folder, base = os.path.split(arg)
    name, ext = os.path.splitext(base)
    if len(ext) <= 1:
        ext = "." + default_ext
    if len(name) <= 1:
        name = "DAT"
    infile = os.path.join(folder, name + ext)
    return infile, [os.path.join(folder, name + "." + e) for e in out_exts]
