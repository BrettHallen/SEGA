# Created with Claude Opus 5.5, Nov 2026
# Guided by Brett Hallen
"""BASTERM's pre-send processing: #include, auto line numbers and checks.

Mirrors the "Send settings" dialog described in BASTERM.HLP:
* #include "FILE.B" (no line number) pastes another file in place
* optional automatic line numbers from a start value in steps; a line that
  already has a number resets the counter; lines starting with '*' (labels)
  are rounded up to a multiple of an interval
* blank lines become ' comments when numbering, and are dropped otherwise
* checks: missing number, number above 99999, duplicate number, line too long
"""

from __future__ import annotations

import os
import re
from dataclasses import dataclass, field
from typing import List, Optional, Tuple

MAX_LINE_NUMBER = 99999
LINE_NUM_RE = re.compile(r"^\s*(\d+)(?=\s|$|[^\d.])")
INCLUDE_RE = re.compile(r'^\s*#include\s+"([^"]+)"\s*$', re.I)
# Unnumbered lines GAME BASIC runs at once instead of storing (e.g. the
# LOAD "COM:..." lines at the top of several CD programs). They are not
# program lines, so they are never numbered and are left out when sending.
DIRECT_RE = re.compile(r"^\s*(LOAD|SAVE|RUN|NEW|LIST|LLIST|CONT|FILES|MERGE|DELETE|RENUM|AUTO|KILL"
                       r"|BLOAD|BSAVE|GLOAD|KLOAD)(?![A-Za-z0-9_$])", re.I)
COMMENT_RE = re.compile(r"^\s*('|REM(?![A-Za-z0-9_$]))", re.I)


@dataclass
class Options:
    auto_number: bool = False
    start: int = 10
    step: int = 10
    label_interval: int = 0  # 0 = no rounding for '*' label lines
    max_line_bytes: int = 255
    encoding: str = "cp932"


@dataclass
class SourceLine:
    text: str
    file: str
    line: int  # 1-based


@dataclass
class Problem:
    file: str
    line: int
    severity: str  # "error" | "warning" | "info"
    message: str

    def __str__(self) -> str:
        return f"{self.file}:{self.line}: {self.severity}: {self.message}"


@dataclass
class Result:
    lines: List[Tuple[int, str, SourceLine]] = field(default_factory=list)
    problems: List[Problem] = field(default_factory=list)

    @property
    def errors(self) -> List[Problem]:
        return [p for p in self.problems if p.severity == "error"]

    def text(self) -> str:
        return "".join(f"{n} {body}\r\n" if body else f"{n}\r\n" for n, body, _ in self.lines)

    def encode(self, encoding: str = "cp932") -> bytes:
        return self.text().encode(encoding)


def read_source(path: str) -> str:
    """Read a .B file: UTF-8 if valid, otherwise Shift-JIS (cp932)."""
    with open(path, "rb") as fh:
        raw = fh.read()
    if raw.startswith(b"\xef\xbb\xbf"):
        raw = raw[3:]
    try:
        return raw.decode("utf-8")
    except UnicodeDecodeError:
        return raw.decode("cp932", errors="replace")


def expand(path: str, problems: List[Problem], _stack: Optional[List[str]] = None) -> List[SourceLine]:
    stack = _stack or []
    apath = os.path.abspath(path)
    if apath in stack:
        problems.append(Problem(path, 1, "error", "#include loop"))
        return []
    out: List[SourceLine] = []
    text = read_source(path)
    for i, line in enumerate(text.splitlines(), 1):
        m = INCLUDE_RE.match(line)
        if m:
            target = _find_include(os.path.dirname(apath), m.group(1))
            if target is None:
                problems.append(Problem(path, i, "error", f'#include file not found: "{m.group(1)}"'))
                continue
            out.extend(expand(target, problems, stack + [apath]))
            continue
        out.append(SourceLine(line.rstrip("\r\n"), path, i))
    return out


def _find_include(folder: str, name: str) -> Optional[str]:
    cand = os.path.join(folder, name)
    if os.path.isfile(cand):
        return cand
    try:  # case-insensitive match, for files that came from DOS/Windows
        for entry in os.listdir(folder):
            if entry.lower() == name.lower():
                return os.path.join(folder, entry)
    except OSError:
        pass
    return None


def process_lines(src: List[SourceLine], opts: Options, problems: List[Problem]) -> Result:
    res = Result(problems=problems)
    counter = opts.start
    seen = {}
    for sl in src:
        # trailing spaces and control codes (a DOS Ctrl-Z end-of-file mark)
        text = re.sub(r"[\s\x00-\x1f]+$", "", sl.text)
        m = LINE_NUM_RE.match(text)
        if m:
            num = int(m.group(1))
            body = text[m.end():]
            body = body[1:] if body.startswith(" ") else body
            counter = num + opts.step
        else:
            stripped = text.strip()
            dm = DIRECT_RE.match(text)
            if dm:
                problems.append(Problem(sl.file, sl.line, "info",
                                        f"left out direct command {dm.group(1).upper()} "
                                        "(no line number, so it is not a program line)"))
                continue
            if not opts.auto_number:
                if stripped == "":
                    continue  # BASTERM drops blank lines when not numbering
                if COMMENT_RE.match(text):
                    problems.append(Problem(sl.file, sl.line, "info",
                                            "left out comment with no line number"))
                    continue
                problems.append(Problem(sl.file, sl.line, "error",
                                        "line has no line number (turn on automatic line numbers, or add one)"))
                continue
            if stripped.startswith("*") and opts.label_interval > 0:
                iv = opts.label_interval
                counter = ((counter + iv - 1) // iv) * iv
            num = counter
            counter += opts.step
            body = stripped if stripped else "'"
        if num > MAX_LINE_NUMBER:
            problems.append(Problem(sl.file, sl.line, "error",
                                    f"line number {num} is above {MAX_LINE_NUMBER}"))
            continue
        if num in seen:
            prev = seen[num]
            problems.append(Problem(sl.file, sl.line, "error",
                                    f"duplicate line number {num} (also at {prev.file}:{prev.line})"))
            continue
        seen[num] = sl
        full = f"{num} {body}"
        try:
            nbytes = len(full.encode(opts.encoding))
        except UnicodeEncodeError as exc:
            bad = full[exc.start:exc.end]
            problems.append(Problem(sl.file, sl.line, "error",
                                    f"character {bad!r} (U+{ord(bad[0]):04X}) cannot be sent; "
                                    "the Saturn uses Shift-JIS"))
            continue
        if nbytes > opts.max_line_bytes:
            problems.append(Problem(sl.file, sl.line, "error",
                                    f"line is {nbytes} bytes, the limit is {opts.max_line_bytes}"))
            continue
        res.lines.append((num, body, sl))
    return res


def build(path: str, opts: Optional[Options] = None) -> Result:
    opts = opts or Options()
    problems: List[Problem] = []
    src = expand(path, problems)
    return process_lines(src, opts, problems)
