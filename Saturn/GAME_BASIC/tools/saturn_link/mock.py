"""A pretend Saturn running GAME BASIC, for testing without hardware.

It speaks the Saturn side of the protocol as BASTERM expects it: answers the
NUL probe, takes keystrokes, and runs LOAD "COM:..." / SAVE "COM:..." / RUN /
LIST by issuing file requests to the PC. It is an emulation of the protocol as
read from Basterm.exe, not of the real Saturn firmware, so it proves the PC
side is self-consistent; it cannot prove the real Saturn behaves the same.
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
                 log=lambda s: None, echo: bool = True):
        super().__init__(daemon=True, name="MockSaturn")
        self.t = transport
        self.r = Reader(transport)
        self.log = log
        self.echo = echo
        self.linked = False
        self.line = bytearray()
        self.program: Dict[int, str] = {}
        self.running = False
        self.screen: List[str] = []  # lines the Saturn "printed"
        self.commands: List[str] = []  # command lines typed at it
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
        """Send text back to the PC's terminal, the way the Saturn echoes."""
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
        while not self._stop.is_set():
            ev = self.r.next_event(0.05)
            if ev is None:
                continue
            if ev == ("nul",):
                if not self.linked:
                    self.t.write(b"\x00")
                continue
            if ev[0] == "cmd":
                if ev[1] == P.LINK:
                    self.linked = True
                continue
            _, mod, key = ev
            self._on_key(mod, key)

    def _on_key(self, mod: int, key: int) -> None:
        if key == 0x03 and mod in (0x04, 0x05):
            self.t.write(P.keystroke(mod, 0x03))  # echo STOP
            self.line.clear()
            if self.running:
                self.running = False
                self._print("Break")
            self._cmd(P.STATUS_1)
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
                self._print("(running)")
                self._cmd(P.STATUS_RUNNING)
            else:
                self._cmd(P.STATUS_DONE)
            return
        if word == "LIST":
            for n in sorted(self.program):
                self._print(f"{n} {self.program[n]}")
            self._cmd(P.STATUS_DONE)
            return
        if word == "NEW":
            self.program.clear()
            self._cmd(P.STATUS_DONE)
            return
        if word:
            self._print("Syntax error")
        self._cmd(P.STATUS_DONE)

    def _open(self, verb: int, name: str) -> Optional[int]:
        self._cmd(verb)
        # Real Saturn file names are probably space padded 8.3; exercise that.
        stem, _, ext = name.partition(".")
        padded = f"{stem:<8}.{ext}" if len(stem) < 8 and ext else name
        if len(padded) > P.STRING_MAX_CHARS:
            padded = name
        if not self._send_string(padded):
            return None
        reply = self._expect((P.HANDLE_0, P.HANDLE_1, P.HANDLE_2, P.ERR_NOT_FOUND,
                              P.ERR_ACCESS, P.NAK))
        if reply in (P.HANDLE_0, P.HANDLE_1, P.HANDLE_2):
            return reply - P.HANDLE_0
        self._print({P.ERR_NOT_FOUND: "File not found",
                     P.ERR_ACCESS: "Access denied"}.get(reply, "Device I/O error"))
        return None

    def _load(self, name: str, run: bool, merge: bool) -> None:
        if self._open(P.OPEN_READ, name) is None:
            self._cmd(P.STATUS_DONE)
            return
        data = bytearray()
        retries = 0
        while True:
            self._cmd(P.READ_BLOCK)
            if self._expect((P.DATA,)) is None:
                self._print("Device timeout")
                self._cmd(P.STATUS_DONE)
                return
            raw = self.r.read_raw(P.BLOCK_SIZE, 2.0)
            blk = P.parse_block(raw) if raw else None
            if blk is None or not blk.ok or (self.nak_first_block and self.naks_sent == 0):
                self.naks_sent += 1
                retries += 1
                self._cmd(P.NAK)
                if retries > 5:
                    self._print("Device I/O error")
                    self._cmd(P.STATUS_DONE)
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
        for line in data.decode("cp932", errors="replace").splitlines():
            m = re.match(r"\s*(\d+)\s?(.*)$", line)
            if m:
                self.program[int(m.group(1))] = m.group(2)
        self._print("Ok")
        if run:
            self.running = True
            self._cmd(P.STATUS_RUNNING)
        else:
            self._cmd(P.STATUS_DONE)

    def _save(self, name: str) -> None:
        if self._open(P.OPEN_WRITE, name) is None:
            self._cmd(P.STATUS_DONE)
            return
        text = "".join(f"{n} {self.program[n]}\r\n" for n in sorted(self.program))
        data = text.encode("cp932", errors="replace")
        for i in range(0, len(data), P.BLOCK_PAYLOAD):
            chunk = data[i:i + P.BLOCK_PAYLOAD]
            for _ in range(3):
                self.t.write(P.data_block(chunk))
                if self._expect((P.ACK, P.NAK)) == P.ACK:
                    break
        self._cmd(P.CLOSE)
        self._expect((P.ACK, P.NAK))
        self._print("Ok")
        self._cmd(P.STATUS_DONE)
