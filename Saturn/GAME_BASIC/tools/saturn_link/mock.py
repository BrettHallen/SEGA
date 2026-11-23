# Created with Claude Opus 5.5, Nov 2026
# Guided by Brett Hallen
"""A pretend Saturn running GAME BASIC, for testing without hardware.

It speaks the Saturn side of the protocol. Like the real interpreter it
starts in raw mode, switches to link mode after four 0x00 bytes in a row
without answering them (receive interrupt, 0x0600A144), and ignores
keystroke packets until then. It takes keystrokes, and runs LOAD "COM:..." / SAVE "COM:..." / RUN / LIST by issuing
file requests to the PC. Its status frames and retries follow the GAME BASIC
interpreter's own code (GAME_BASIC_CD/README.md):

- every typed command starts with STATUS_RUNNING (0x08) and ends with
  STATUS_IDLE (0x06), or STATUS_ERROR (0x09) if it stopped with an error;
  LOAD ...,R keeps running, so no end status follows until STOP;
- STOP at the prompt answers STATUS_IDLE, and STOP of a running program
  answers STATUS_BREAK (0x07);
- after a NAK it seeks (0x0E) to the position it expects and asks again.

The real Saturn never sends its screen text over the link. The mock keeps a
copy in `screen`, and only sends it as keystroke packets when echo=True, so
tests can still exercise the PC's text handling.

Its screen messages follow the GAME BASIC Tutorial Manual: "Ready." after a
command (p. 15), "Line 120" for the last line loaded (p. 152), "Syntax error"
(p. 17), "Break at 130" (p. 28), and LIST with 5-wide line numbers (p. 24).
File errors use the Reference Manual's wording (53 "File not found", 50
"File access error"); which one the real Saturn prints for each PC reply
was not traced.
"""

from __future__ import annotations

import re
import threading
import time
from typing import Dict, List, Optional

from . import protocol as P
from .reader import Reader
from .transport import Transport


class MockSaturn(threading.Thread):
    def __init__(self, transport: Transport, nak_first_block: bool = False,
                 log=lambda s: None, echo: bool = False):
        super().__init__(daemon=True, name="MockSaturn")
        self.t = transport
        self.r = Reader(transport)
        self.log = log
        self.echo = echo
        self.linked = False  # raw mode until four NULs arrive
        self.raw_bytes = 0
        self.line = bytearray()
        self.program: Dict[int, str] = {}
        self.running = False
        self.screen: List[str] = []  # lines the Saturn "printed"
        self.commands: List[str] = []  # command lines typed at it
        self.keys: List[tuple] = []  # every (modifier, key) pair received
        self.nak_first_block = nak_first_block
        self.naks_sent = 0
        self._stop = threading.Event()
        self._modifier = 0

    # ------------------------------------------------------------ plumbing
    def stop_thread(self) -> None:
        self._stop.set()

    def _cmd(self, n: int) -> None:
        self.t.write(P.command_frame(n))

    def _print(self, text: str) -> None:
        """Record a screen line; send it to the PC only when echo is on."""
        self.screen.append(text)
        if not self.echo:
            return
        for mod, k in P.text_keystrokes(text + "\n"):
            self.t.write(P.keystroke(mod, k))

    def _expect(self, allowed, timeout: float = 2.0) -> Optional[int]:
        deadline = time.monotonic() + timeout
        while time.monotonic() < deadline:
            ev = self.r.next_event(deadline - time.monotonic())
            if ev and ev[0] == "cmd" and ev[1] in allowed:
                return ev[1]
        return None

    def _send_string(self, text: str) -> bool:
        self.t.write(P.string_packet(text))
        return self._expect((P.ACK, P.NAK)) == P.ACK

    def _recv_string(self) -> Optional[str]:
        if self._expect((P.STRING,)) is None:
            return None
        raw = self.r.read_raw(P.STRING_SIZE, 1.0)
        if raw is None:
            return None
        text = P.parse_string(raw)
        self._cmd(P.ACK if text is not None else P.NAK)
        return text

    # ----------------------------------------------------------- main loop
    def run(self) -> None:
        nuls = 0
        while not self._stop.is_set():
            ev = self.r.next_event(0.05)
            if ev is None:
                continue
            if ev == ("nul",):
                nuls += 1
                if nuls >= 4 and not self.linked:
                    self.linked = True  # raw -> link mode; nothing is sent back
                continue
            nuls = 0
            if not self.linked:
                self.raw_bytes += 1  # raw mode: would be typed as junk characters
                continue
            if ev[0] == "cmd":
                continue
            _, mod, key = ev
            self._on_key(mod, key)

    def _on_key(self, mod: int, key: int) -> None:
        self.keys.append((mod, key))
        if key == 0x03 and mod in (0x04, 0x05):
            self.line.clear()
            if self.running:
                self.running = False
                # The mock doesn't execute the program, so it reports the
                # last line as the one it stopped on.
                self._print(f"Break at {max(self.program)}" if self.program else "Break")
                self._print("Ready.")
                self._cmd(P.STATUS_BREAK)
            else:
                self._cmd(P.STATUS_IDLE)
            return
        if (mod, key) == P.KEY_LINE_RESET:
            self.line.clear()
            return
        if (mod, key) == P.KEY_ENTER:
            text = self.line.decode("cp932", errors="replace")
            self.line.clear()
            self._execute(text)
            return
        if mod == key == P.SPECIAL_KEYS["BACKSPACE"]:
            if self.line:
                self.line.pop()
            return
        if mod == 0:
            self.line.append(key)

    # ----------------------------------------------------------- commands
    def _execute(self, text: str) -> None:
        self.commands.append(text)
        if self.linked:
            self._cmd(P.STATUS_RUNNING)
        m = re.match(r'\s*(LOAD|SAVE)\s*"COM:([^"]+)"\s*((?:,\s*[RM]\s*)*)$', text, re.I)
        if m:
            verb, name, opts = m.group(1).upper(), m.group(2), m.group(3).upper()
            if verb == "LOAD":
                self._load(name, run="R" in opts, merge="M" in opts)
            else:
                self._save(name)
            return
        word = text.strip().upper()
        if word == "RUN":
            if self.program:
                self.running = True
            else:
                self._print("Ready.")
                self._cmd(P.STATUS_IDLE)
            return
        if word == "LIST":
            for n in sorted(self.program):
                self._print(f"{n:5d} {self.program[n]}")
            self._print("Ready.")
            self._cmd(P.STATUS_IDLE)
            return
        if word == "ERROR":
            # Ref. p. 36: re-shows the line the last error stopped on. The
            # mock never stops on an error, so it shows the last line.
            if self.program:
                n = max(self.program)
                self._print(f"{n:5d} {self.program[n]}")
            self._print("Ready.")
            self._cmd(P.STATUS_IDLE)
            return
        if word == "NEW":
            self.program.clear()
            self._print("Ready.")
            self._cmd(P.STATUS_IDLE)
            return
        if word:
            self._print("Syntax error")
            self._cmd(P.STATUS_ERROR)
            self._print("Ready.")
            return
        self._print("Ready.")
        self._cmd(P.STATUS_IDLE)

    def _open(self, verb: int, name: str) -> Optional[int]:
        self._cmd(verb)
        # Real Saturn file names are probably space padded 8.3; exercise that.
        stem, _, ext = name.partition(".")
        padded = f"{stem:<8}.{ext}" if len(stem) < 8 and ext else name
        if len(padded) > P.STRING_MAX_CHARS:
            padded = name
        if not self._send_string(padded):
            self._fail("Communication error")
            return None
        reply = self._expect((P.HANDLE_0, P.HANDLE_1, P.HANDLE_2, P.ERR_NOT_FOUND,
                              P.ERR_ACCESS, P.NAK))
        if reply in (P.HANDLE_0, P.HANDLE_1, P.HANDLE_2):
            return reply - P.HANDLE_0
        self._fail({P.ERR_NOT_FOUND: "File not found",
                    P.ERR_ACCESS: "File access error"}.get(reply, "Communication error"))
        return None

    def _fail(self, message: str) -> None:
        self._print(message)
        self._cmd(P.STATUS_ERROR)
        self._print("Ready.")

    def _seek(self, pos: int) -> bool:
        """Seek the current file the way the Saturn retries: 0x0E + hex offset."""
        self._cmd(P.SEEK)
        return self._send_string(f"{pos:x}")

    def _load(self, name: str, run: bool, merge: bool) -> None:
        if self._open(P.OPEN_READ, name) is None:
            return
        data = bytearray()
        retries = 0
        while True:
            self._cmd(P.READ_BLOCK)
            if self._expect((P.DATA,)) is None:
                self._fail("Communication error")
                return
            raw = self.r.read_raw(P.BLOCK_SIZE, 2.0)
            blk = P.parse_block(raw) if raw else None
            if blk is None or not blk.ok or (self.nak_first_block and self.naks_sent == 0):
                self.naks_sent += 1
                retries += 1
                self._cmd(P.NAK)
                if retries > 5 or not self._seek(len(data)):
                    self._fail("Communication error")
                    return
                continue
            self._cmd(P.ACK)
            if blk.length == 0:
                break
            data += blk.payload
        self._cmd(P.CLOSE)
        self._expect((P.ACK, P.NAK))
        if not merge:
            self.program.clear()
        last = None
        bad = False
        for line in data.decode("cp932", errors="replace").splitlines():
            m = re.match(r"\s*(\d+)\s?(.*)$", line)
            if m:
                last = int(m.group(1))
                self.program[last] = m.group(2)
            elif line.strip():
                bad = True
        if last is not None:
            self._print(f"Line {last}")
        if bad:
            self._fail("Syntax error")
        elif run:
            self.running = True
        else:
            self._print("Ready.")
            self._cmd(P.STATUS_IDLE)

    def _save(self, name: str) -> None:
        if self._open(P.OPEN_WRITE, name) is None:
            return
        text = "".join(f"{n} {self.program[n]}\r\n" for n in sorted(self.program))
        data = text.encode("cp932", errors="replace")
        for i in range(0, len(data), P.BLOCK_PAYLOAD):
            chunk = data[i:i + P.BLOCK_PAYLOAD]
            for attempt in range(4):
                if attempt and not self._seek(i):
                    continue
                self.t.write(P.data_block(chunk))
                if self._expect((P.ACK, P.NAK)) == P.ACK:
                    break
            else:
                self._fail("Communication error")
                return
        self._cmd(P.CLOSE)
        self._expect((P.ACK, P.NAK))
        self._print("Ready.")
        self._cmd(P.STATUS_IDLE)
