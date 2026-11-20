# Created with Claude Opus 5.5, Nov 2026
# Guided by Brett Hallen
"""PC side of the link: a cross-platform stand-in for BASTERM's comms code.

The PC is a file server. To send a program we type LOAD "COM:TBASTERM.B" at
the Saturn and then answer its open / read / close requests. TBASTERM.B is
held in memory, so nothing is written into your project folder. Other COM:
file names are served from (and written to) one folder, never outside it.
"""

from __future__ import annotations

import fnmatch
import io
import os
import re
import shutil
import time
from dataclasses import dataclass, field
from typing import Callable, Dict, List, Optional

from . import errors as E
from . import protocol as P
from .reader import Reader
from .transport import Transport

TRANSFER_NAME = "TBASTERM.B"

# Screen messages that mean a LOAD went wrong: the exact GAME BASIC error
# messages from the Reference Manual appendix (pp. 391-406), see errors.py.
# The tutorial says BASTERM itself may miss such errors and to read the
# Saturn's screen (p. 163), which is what this is for.
SATURN_ERROR_RE = E.ERROR_RE
# "Line 120": the last line number loaded (tutorial manual p. 152).
SATURN_LINE_RE = re.compile(r"^\s*Line\s+(\d+)\s*$", re.I)


# Reference Manual p. 147: a program drawing very many polygons can lock up
# the Saturn's keyboard input; a soft reset keeps the program in memory.
HUNG_HINT = ("If the Saturn has locked up, soft reset it with A+B+C+Start on the pad: "
             "GAME BASIC keeps the program in memory.")


class LinkError(Exception):
    pass


@dataclass
class OpenFile:
    name: str
    mode: str  # "r", "w", "rw"
    fh: io.BufferedIOBase
    virtual: bool = False
    bytes_moved: int = 0


@dataclass
class Stats:
    opened: List[str] = field(default_factory=list)
    closed: List[str] = field(default_factory=list)
    bytes_sent: int = 0
    bytes_received: int = 0
    blocks_sent: int = 0
    blocks_received: int = 0
    naks_received: int = 0
    naks_sent: int = 0
    saturn_text: List[str] = field(default_factory=list)  # lines it printed
    saturn_errors: List[str] = field(default_factory=list)  # ones that look like errors
    last_line: Optional[int] = None  # from "Line N"
    end_status: Optional[int] = None  # status frame that ended the LOAD, if any
    error_status: bool = False  # the Saturn sent STATUS_ERROR (0x09) for the LOAD


class SaturnLink:
    def __init__(
        self,
        transport: Transport,
        serve_dir: Optional[str] = None,
        log: Callable[[str], None] = lambda s: None,
        on_char: Optional[Callable[[int, int], None]] = None,
        key_delay: float = 0.03,
        allow_write: bool = True,
    ):
        self.t = transport
        self.r = Reader(transport)
        self.serve_dir = os.path.abspath(serve_dir) if serve_dir else None
        self.log = log
        self.on_char = on_char or (lambda mod, key: None)
        self.key_delay = key_delay
        self.allow_write = allow_write
        self.linked = False
        self.virtual: Dict[str, bytes] = {}
        self.received: Dict[str, bytes] = {}
        self.handles: List[Optional[OpenFile]] = [None, None, None]
        self.current = 0
        self.status: Optional[int] = None  # last STATUS_x frame number
        self.status_seq = 0
        self._close_seq = 0
        self.stop_echo = False
        self.stats = Stats()
        self._nul_run = 0
        self._dir_matches: List[str] = []
        self._last_rx = time.monotonic()
        self.screen_lines: List[str] = []  # complete lines the Saturn printed
        self._screen_buf = bytearray()

    # ------------------------------------------------------------------ I/O
    def _send(self, data: bytes) -> None:
        self.t.write(data)

    def _cmd(self, n: int) -> None:
        self._send(P.command_frame(n))

    # ------------------------------------------------------------- link up
    def connect(self, timeout: float = 5.0) -> None:
        """NUL handshake: send 0x00 every 50 ms until the Saturn answers 0x00."""
        deadline = time.monotonic() + timeout
        self.log("Probing for the Saturn (0x00 every 50 ms)...")
        while time.monotonic() < deadline:
            self._send(b"\x00")
            ev = self.r.next_event(0.05)
            while ev is not None:
                if ev == ("nul",):
                    self._drain_nuls(0.1)
                    self._cmd(P.LINK)
                    self.linked = True
                    self._nul_run = 0
                    self.log("Link up.")
                    return
                self._dispatch(ev)  # e.g. a stray status frame
                ev = self.r.next_event(0)
        raise LinkError(
            "No answer from the Saturn. Check the cable, the port, the baud rate "
            "(9600 or 19200, same as GAME BASIC; to see or change it on the Saturn, "
            "press L+R+Z on the pad or Q+E+D on the keyboard) and that GAME BASIC "
            "is at its prompt. " + HUNG_HINT
        )

    def _drain_nuls(self, quiet: float) -> None:
        while True:
            ev = self.r.next_event(quiet)
            if ev is None:
                return
            if ev != ("nul",):
                self._dispatch(ev)
                return

    def close(self) -> None:
        for i, h in enumerate(self.handles):
            if h is not None:
                self._close_handle(i)
        self.t.close()

    # --------------------------------------------------------- event pump
    def pump(self, timeout: float) -> bool:
        """Handle one incoming event. Returns False if nothing arrived."""
        ev = self.r.next_event(timeout)
        if ev is None:
            return False
        self._dispatch(ev)
        return True

    def pump_until(self, done: Callable[[], bool], timeout: float, what: str) -> None:
        deadline = time.monotonic() + timeout
        while not done():
            left = deadline - time.monotonic()
            if left <= 0:
                raise LinkError(f"Timed out waiting for {what}.")
            self.pump(min(left, 0.1))

    def pump_for(self, seconds: float) -> None:
        deadline = time.monotonic() + seconds
        while True:
            left = deadline - time.monotonic()
            if left <= 0:
                return
            self.pump(left)

    def _wait_reply(self, allowed, timeout: float = 1.0) -> Optional[int]:
        """Wait for one of the allowed command frames, handling keys meanwhile."""
        deadline = time.monotonic() + timeout
        while True:
            left = deadline - time.monotonic()
            if left <= 0:
                return None
            ev = self.r.next_event(left)
            if ev is None:
                return None
            if ev[0] == "cmd" and ev[1] in allowed:
                return ev[1]
            if ev[0] == "cmd" and ev[1] == P.ABORT:
                return None
            self._dispatch(ev)

    def _read_string(self) -> Optional[str]:
        """Read the string packet that follows a request, and ACK or NAK it."""
        got = self._wait_reply((P.STRING,), timeout=0.5)
        if got is None:
            self.log("  expected a string packet, got none")
            return None
        raw = self.r.read_raw(P.STRING_SIZE, 0.5)
        if raw is None:
            self.log("  string packet cut short")
            return None
        text = P.parse_string(raw)
        if text is None:
            self.stats.naks_sent += 1
            self._cmd(P.NAK)
            self.log("  string packet CRC error -> NAK")
            return None
        self._cmd(P.ACK)
        return text

    def _send_string(self, text: str) -> bool:
        self._send(P.string_packet(text))
        return self._wait_reply((P.ACK, P.NAK), 1.0) == P.ACK

    def _dispatch(self, ev) -> None:
        self._last_rx = time.monotonic()
        kind = ev[0]
        if kind == "nul":
            self._nul_run += 1
            if self.linked and self._nul_run >= 8:
                # BASTERM drops back to probing; serve()/connect() re-link.
                self.log("Saturn sent 8 NULs in a row: link reset.")
                self.linked = False
            return
        self._nul_run = 0
        if kind == "key":
            _, mod, key = ev
            if key == 0x03 and mod in (0x04, 0x05):
                self.stop_echo = True
                return
            if (mod, key) in ((0x12, 0x12), (0x59, 0x59), (0x14, 0x14), (0x18, 0x18)):
                return  # shift / ctrl state reports
            self._capture(key)
            self.on_char(mod, key)
            return
        n = ev[1]
        handler = self._handlers().get(n)
        if handler:
            handler()
        elif n in P.STATUS_FRAMES:
            self.status = n
            self.status_seq += 1
            self.log(f"  Saturn status {n - P.STATUS_IDLE + 1} ({P.command_name(n)})")
        else:
            self.log(f"  ignoring {P.command_name(n)}")

    def _capture(self, key: int) -> None:
        """Collect the Saturn's echoed text into lines (Shift-JIS)."""
        if key in (0x0D, 0x0A):
            if self._screen_buf:
                self.screen_lines.append(
                    self._screen_buf.decode("cp932", errors="replace").rstrip())
                self._screen_buf.clear()
            return
        self._screen_buf.append(key)
        if len(self._screen_buf) > 256:  # no line end coming; keep it bounded
            self._capture(0x0D)

    def _screen_report(self, start: int) -> None:
        """Copy what the Saturn printed since screen_lines[start] into stats."""
        self._capture(0x0D)  # flush a part line
        lines = [ln for ln in self.screen_lines[start:] if ln.strip()]
        self.stats.saturn_text = lines
        self.stats.saturn_errors = [ln for ln in lines if SATURN_ERROR_RE.search(ln)]
        for ln in lines:
            m = SATURN_LINE_RE.match(ln)
            if m:
                self.stats.last_line = int(m.group(1))

    def _handlers(self):
        return {
            P.LINK: lambda: None,
            P.ACK: lambda: None,
            P.NAK: lambda: None,
            P.READ_BLOCK: self._on_read_block,
            P.DATA: self._on_data,
            P.OPEN_READ: lambda: self._on_open("r"),
            P.OPEN_WRITE: lambda: self._on_open("w"),
            P.OPEN_RW: lambda: self._on_open("rw"),
            P.CLOSE: self._on_close,
            P.SEEK: self._on_seek,
            P.DELETE: self._on_delete,
            P.FILE_SIZE: self._on_size,
            P.DIR_FIRST: self._on_dir_first,
            P.DIR_NEXT: self._on_dir_next,
            P.DIR_END: lambda: self._cmd(P.ACK),
            P.HANDLE_0: lambda: self._on_select(0),
            P.HANDLE_1: lambda: self._on_select(1),
            P.HANDLE_2: lambda: self._on_select(2),
            P.DISK_FREE_A: self._on_disk,
            P.DISK_FREE_B: self._on_disk,
        }

    # ------------------------------------------------------------- files
    def _resolve(self, name: str) -> Optional[str]:
        """Map a Saturn file name to a path inside serve_dir (case-insensitive)."""
        if not self.serve_dir:
            return None
        if any(c in name for c in "/\\:") or name in ("", ".", ".."):
            return None
        try:
            for entry in os.listdir(self.serve_dir):
                if entry.upper() == name.upper():
                    return os.path.join(self.serve_dir, entry)
        except OSError:
            return None
        return os.path.join(self.serve_dir, name)

    def _on_open(self, mode: str) -> None:
        raw = self._read_string()
        if raw is None:
            return
        name = P.clean_filename(raw)
        self.log(f"  Saturn opens {name!r} for {dict(r='read', w='write', rw='read/write')[mode]}")
        slot = next((i for i, h in enumerate(self.handles) if h is None), None)
        if slot is None:
            self._cmd(P.NAK)
            self.log("  no free handle (3 files already open)")
            return
        key = name.upper()
        fh = None
        virtual = False
        if key in self.virtual and mode == "r":
            fh, virtual = io.BytesIO(self.virtual[key]), True
        elif key == TRANSFER_NAME and mode in ("w", "rw"):
            fh, virtual = io.BytesIO(), True
        else:
            path = self._resolve(name)
            if path is None:
                self._cmd(P.ERR_ACCESS if self.serve_dir else P.ERR_NOT_FOUND)
                return
            if mode != "r" and not self.allow_write:
                self._cmd(P.ERR_ACCESS)
                return
            try:
                fh = open(path, {"r": "rb", "w": "wb", "rw": "r+b"}[mode])
            except FileNotFoundError:
                self._cmd(P.ERR_NOT_FOUND)
                self.log("  not found")
                return
            except PermissionError:
                self._cmd(P.ERR_ACCESS)
                return
            except OSError:
                self._cmd(P.NAK)
                return
        self.handles[slot] = OpenFile(name, mode, fh, virtual)
        self.current = slot
        self.stats.opened.append(name)
        self._cmd(P.HANDLE_0 + slot)

    def _on_select(self, slot: int) -> None:
        self.current = slot
        self._cmd(P.HANDLE_0 + slot)

    def _cur(self) -> Optional[OpenFile]:
        return self.handles[self.current]

    def _on_read_block(self) -> None:
        h = self._cur()
        if h is None:
            payload = b""
        else:
            start = h.fh.tell()
            payload = h.fh.read(P.BLOCK_PAYLOAD)
        self._send(P.data_block(payload))
        reply = self._wait_reply((P.ACK, P.NAK), 1.0)
        if reply == P.ACK:
            self.stats.blocks_sent += 1
            self.stats.bytes_sent += len(payload)
            if h:
                h.bytes_moved += len(payload)
        else:
            # The Saturn asks again; rewind so it gets the same block.
            # (BASTERM does not rewind. Hardware-test item, see README.)
            self.stats.naks_received += 1
            if h:
                h.fh.seek(start)
            self.log("  block NAK or no reply, will resend on next request")

    def _on_data(self) -> None:
        raw = self.r.read_raw(P.BLOCK_SIZE, 1.0)
        if raw is None:
            self.log("  data block cut short")
            return
        blk = P.parse_block(raw)
        h = self._cur()
        if not blk.ok or h is None or h.mode == "r":
            self.stats.naks_sent += 1
            self._cmd(P.NAK)
            return
        h.fh.write(blk.payload)
        h.bytes_moved += blk.length
        self.stats.blocks_received += 1
        self.stats.bytes_received += blk.length
        self._cmd(P.ACK)

    def _close_handle(self, slot: int) -> Optional[OpenFile]:
        h = self.handles[slot]
        if h is None:
            return None
        if h.virtual and h.mode != "r":
            self.received[h.name.upper()] = h.fh.getvalue()  # type: ignore[attr-defined]
        h.fh.close()
        self.handles[slot] = None
        return h

    def _on_close(self) -> None:
        h = self._close_handle(self.current)
        if h is None:
            self._cmd(P.NAK)
            return
        self.stats.closed.append(h.name)
        self._close_seq = self.status_seq  # statuses after this follow the close
        self.log(f"  closed {h.name} ({h.bytes_moved} bytes)")
        self._cmd(P.ACK)

    def _on_seek(self) -> None:
        text = self._read_string()
        h = self._cur()
        if text is None:
            return
        try:
            pos = int(text, 16)
            h.fh.seek(pos)  # type: ignore[union-attr]
        except (ValueError, AttributeError, OSError):
            self._cmd(P.NAK)
            return
        self._cmd(P.ACK)

    def _on_delete(self) -> None:
        text = self._read_string()
        if text is None:
            return
        if not self.allow_write:
            self._cmd(P.ERR_ACCESS)
            return
        path = self._resolve(P.clean_filename(text))
        if path is None:
            self._cmd(P.ERR_ACCESS)
            return
        try:
            os.remove(path)
        except FileNotFoundError:
            self._cmd(P.ERR_NOT_FOUND)
            return
        except PermissionError:
            self._cmd(P.ERR_ACCESS)
            return
        except OSError:
            self._cmd(P.NAK)
            return
        self._cmd(P.ACK)

    def _on_size(self) -> None:
        h = self._cur()
        if h is None:
            size = 0
        else:
            pos = h.fh.tell()
            size = h.fh.seek(0, io.SEEK_END)
            h.fh.seek(pos)
        self._send_string(f"{size:x}")

    def _on_dir_first(self) -> None:
        pattern = self._read_string()
        if pattern is None:
            return
        self._dir_matches = self._dir_names(pattern)
        self._on_dir_next()

    def _dir_names(self, pattern: str) -> List[str]:
        """Names for FILES "COM:...": only ones the Saturn can load (Ref. pp. 96-97)."""
        names = sorted(self.virtual) if not self.serve_dir else []
        if self.serve_dir:
            try:
                names = sorted(e for e in os.listdir(self.serve_dir)
                               if os.path.isfile(os.path.join(self.serve_dir, e)))
            except OSError:
                names = []
        pat = pattern.upper() or "*"
        return [n.upper() for n in names
                if P.saturn_name_ok(n) and fnmatch.fnmatch(n.upper(), pat)]

    def _on_dir_next(self) -> None:
        if not self._dir_matches:
            self._cmd(P.ERR_NOT_FOUND)
            return
        self._send_string(self._dir_matches.pop(0))

    def _on_disk(self) -> None:
        try:
            free = shutil.disk_usage(self.serve_dir or os.getcwd()).free
            text = f"{min(free, 0x7FFFFFFF):x}"
        except OSError:
            text = "ffffffff"
        self._send_string(text)

    # ------------------------------------------------------------ keyboard
    def key(self, modifier: int, key: int) -> None:
        self._send(P.keystroke(modifier, key))
        if self.key_delay:
            self.pump_for(self.key_delay)

    def type_text(self, text: str) -> None:
        for mod, k in P.text_keystrokes(text):
            self.key(mod, k)

    def stop(self, timeout: float = 5.0) -> None:
        """Send STOP every 50 ms until the Saturn reports a status (5 s limit)."""
        seq = self.status_seq
        deadline = time.monotonic() + timeout
        while self.status_seq == seq:
            if time.monotonic() > deadline:
                raise LinkError("The Saturn did not answer STOP within 5 s. " + HUNG_HINT)
            self._send(P.keystroke(*P.KEY_STOP_BEFORE_LOAD))
            self.pump_for(0.05)

    def _type_command(self, command: str) -> None:
        """Key 0x0A, wait 800 ms, then type the command and Enter."""
        self.key(*P.KEY_LINE_RESET)
        self.pump_for(0.8)
        self.type_text(command)
        self.key(*P.KEY_ENTER)

    # ----------------------------------------------------------- commands
    def send_program(self, data: bytes, run: bool = False, merge: bool = False,
                     timeout: float = 120.0) -> Stats:
        """Type LOAD "COM:TBASTERM.B" and serve the file.

        The Saturn reports the result with a status frame: STATUS_IDLE (0x06)
        when the LOAD ended normally, STATUS_ERROR (0x09) when it stopped with
        an error. With ,R the program starts straight after loading, so no
        status comes until it ends. Afterwards stats.end_status holds that
        frame and stats.error_status is True after an error.

        The real Saturn never sends its screen text over the link, so
        stats.saturn_text, stats.saturn_errors and stats.last_line ("Line N")
        are only filled in by a mock that echoes text.
        """
        self.virtual[TRANSFER_NAME] = data
        self.stats = Stats()
        self.stop()
        opts = (",R" if run else "") + (",M" if merge else "")
        cmd = f'LOAD "COM:{TRANSFER_NAME}"{opts}'
        self.log(f"Typing: {cmd}")
        seq = self.status_seq
        screen_start = len(self.screen_lines)
        self._type_command(cmd)

        closed_at = None
        status_at_close = None
        deadline = time.monotonic() + timeout
        while True:
            names_closed = [n.upper() for n in self.stats.closed]
            if closed_at is None and TRANSFER_NAME in names_closed:
                closed_at = time.monotonic()
                status_at_close = self._close_seq
            if closed_at is not None:
                if self.status_seq > status_at_close:
                    self.stats.end_status = self.status
                    self.stats.error_status = self.status == P.STATUS_ERROR
                    break
                if time.monotonic() - closed_at > 3.0:
                    self.log("  no status after the transfer"
                             + ("; the program is running" if run else "; assuming it loaded"))
                    break
            elif (self.status == P.STATUS_ERROR and self.status_seq > seq
                  and TRANSFER_NAME not in [n.upper() for n in self.stats.opened]):
                self._screen_report(screen_start)
                said = "; ".join(self.stats.saturn_text[-3:])
                raise LinkError("The Saturn finished the command without asking for "
                                "the file. " + (f"It printed: {said}" if said else
                                                "Check its screen for an error message."))
            left = deadline - time.monotonic()
            if left <= 0:
                raise LinkError("Timed out during the transfer.")
            self.pump(min(left, 0.1))
        # Events arrive in order, so text the Saturn printed before its
        # status is already in screen_lines; don't pump on, or a running
        # program's own output would be mixed in.
        self._screen_report(screen_start)
        for ln in self.stats.saturn_text:
            self.log(f"  Saturn: {ln}")
        return self.stats

    def show_error_line(self) -> None:
        """Press F12, then type ERROR and Enter.

        Straight after a program stops on an error, a bare ERROR shows the
        failing line again (Ref. p. 36, not for errors inside DATA). F12 first
        gives a readable edit screen, as the manual suggests. No STOP is sent,
        so the Saturn keeps the error it stopped on.
        """
        f12 = P.SPECIAL_KEYS["F12"]
        self.key(f12, f12)
        self.pump_for(0.5)
        self._type_command("ERROR")

    def run_program(self) -> None:
        self.stop()
        self._type_command("RUN")

    def receive_program(self, timeout: float = 120.0) -> bytes:
        self.received.pop(TRANSFER_NAME, None)
        self.stats = Stats()
        self.stop()
        seq = self.status_seq
        cmd = f'SAVE "COM:{TRANSFER_NAME}"'
        self.log(f"Typing: {cmd}")
        self._type_command(cmd)
        self.pump_until(lambda: TRANSFER_NAME in self.received and self.status_seq > seq,
                        timeout, "the program from the Saturn")
        return self.received[TRANSFER_NAME]

    def serve(self, should_stop: Callable[[], bool] = lambda: False) -> None:
        """Stay connected, answer file requests and show Saturn output."""
        while not should_stop():
            if not self.linked:
                self._send(b"\x00")
                ev = self.r.next_event(0.05)
                if ev == ("nul",):
                    self._drain_nuls(0.1)
                    self._cmd(P.LINK)
                    self.linked = True
                    self._nul_run = 0
                    self.log("Link up.")
                elif ev is not None:
                    self._dispatch(ev)
                continue
            self.pump(0.2)
