# Created with Claude Opus 5.5, Nov 2026
# Guided by Brett Hallen
"""Wire format of the BASTERM <-> GAME BASIC for SEGASATURN serial link.

Everything here is pure (no I/O) so it can be unit tested. The layouts come
from BASTERM_serial_protocol.md and were re-checked against the decompiled
Basterm.exe:

* command frame   (FUN_00404b70)  0x60|n, 0x40|n, 0x20|n, n
* keystroke       (FUN_00403a50)  [0x90|h,0xB0|l,0xD0|h,0xF0|l] 0x80|h,0xA0|l,0xC0|h,0xE0|l
* data block      (FUN_00401a70)  frame 0x04, len, sum8, crc_hi, crc_lo, 252 payload
* string packet   (FUN_00404660)  frame 0x19, crc_hi, crc_lo, 14 bytes text
"""

from __future__ import annotations

import re
from dataclasses import dataclass
from typing import List, Optional, Tuple

# --- command numbers -------------------------------------------------------

LINK = 0x01
ACK = 0x02
NAK = 0x03
DATA = 0x04
READ_BLOCK = 0x05
# Status frames, as the Saturn interpreter sends them (see
# Documentation/GAME_BASIC_CD_analysis.md). BASTERM calls them status 1-4.
STATUS_IDLE = 0x06  # status 1: a command ended normally, or idle after STOP
STATUS_BREAK = 0x07  # status 2: a command or program ended by break or STOP
STATUS_RUNNING = 0x08  # status 3: a direct command or RUN has started
STATUS_ERROR = 0x09  # status 4: stopped with an error (BASTERM beeps)
OPEN_READ = 0x0A
OPEN_WRITE = 0x0B
OPEN_RW = 0x0C
CLOSE = 0x0D
SEEK = 0x0E
DELETE = 0x0F
FILE_SIZE = 0x10
DIR_FIRST = 0x11
DIR_NEXT = 0x12
DIR_END = 0x13
HANDLE_0 = 0x14
HANDLE_1 = 0x15
HANDLE_2 = 0x16
ERR_NOT_FOUND = 0x17
ERR_ACCESS = 0x18
STRING = 0x19
DISK_FREE_A = 0x1A
DISK_FREE_B = 0x1B
ABORT = 0x1F  # BASTERM treats a decoded 0x1F as "abort current operation"

STATUS_FRAMES = (STATUS_IDLE, STATUS_BREAK, STATUS_RUNNING, STATUS_ERROR)

COMMAND_NAMES = {
    LINK: "LINK", ACK: "ACK", NAK: "NAK", DATA: "DATA", READ_BLOCK: "READ_BLOCK",
    STATUS_IDLE: "STATUS_IDLE", STATUS_BREAK: "STATUS_BREAK", STATUS_RUNNING: "STATUS_RUNNING",
    STATUS_ERROR: "STATUS_ERROR", OPEN_READ: "OPEN_READ", OPEN_WRITE: "OPEN_WRITE",
    OPEN_RW: "OPEN_RW", CLOSE: "CLOSE", SEEK: "SEEK", DELETE: "DELETE",
    FILE_SIZE: "FILE_SIZE", DIR_FIRST: "DIR_FIRST", DIR_NEXT: "DIR_NEXT",
    DIR_END: "DIR_END", HANDLE_0: "HANDLE_0", HANDLE_1: "HANDLE_1",
    HANDLE_2: "HANDLE_2", ERR_NOT_FOUND: "ERR_NOT_FOUND", ERR_ACCESS: "ERR_ACCESS",
    STRING: "STRING", DISK_FREE_A: "DISK_FREE_A", DISK_FREE_B: "DISK_FREE_B",
    ABORT: "ABORT",
}

BLOCK_PAYLOAD = 252
BLOCK_SIZE = 4 + BLOCK_PAYLOAD  # bytes after the DATA command frame
STRING_TEXT = 14
STRING_SIZE = 2 + STRING_TEXT  # bytes after the STRING command frame
STRING_MAX_CHARS = 12

# --- keystroke codes ---------------------------------------------------------

MOD_NONE = 0x00
KEY_STOP = (0x04, 0x03)  # Stop menu
KEY_STOP_BEFORE_LOAD = (0x05, 0x03)  # sent before LOAD / SAVE
KEY_LINE_RESET = (0x00, 0x0A)
KEY_ENTER = (0x00, 0x0D)

# special keys use the same code as modifier and key
SPECIAL_KEYS = {
    "BACKSPACE": 0x66, "ESC": 0x76, "CAPSLOCK": 0x58, "SCROLLLOCK": 0x7E,
    "F1": 0x05, "F2": 0x06, "F3": 0x04, "F4": 0x0C, "F5": 0x03, "F6": 0x0B,
    "F7": 0x83, "F8": 0x0A, "F9": 0x01, "F10": 0x09, "F11": 0x78, "F12": 0x07,
    "INSERT": 0x81, "HOME": 0x87, "END": 0x88, "PGUP": 0x8B, "PGDN": 0x8C,
    "DELETE": 0x85, "LEFT": 0x86, "UP": 0x89, "RIGHT": 0x8D, "DOWN": 0x8A,
    "PRINTSCREEN": 0x84, "PAUSE": 0x82,
}


# --- CRC / checksums ---------------------------------------------------------

def _make_table() -> List[int]:
    table = []
    for i in range(256):
        crc = i
        for _ in range(8):
            crc = (crc >> 1) ^ 0x8408 if crc & 1 else crc >> 1
        table.append(crc)
    return table


_CRC_TABLE = _make_table()


def crc16(data: bytes) -> int:
    """CRC-16/X-25 (reflected 0x8408, init 0xFFFF, xorout 0xFFFF)."""
    crc = 0xFFFF
    for b in data:
        crc = _CRC_TABLE[(crc ^ b) & 0xFF] ^ (crc >> 8)
    return crc ^ 0xFFFF


def sum8(data: bytes) -> int:
    return sum(data) & 0xFF


# --- encoders ----------------------------------------------------------------

def command_frame(n: int) -> bytes:
    if not 1 <= n <= 0x1F:
        raise ValueError(f"command number out of range: {n:#x}")
    return bytes((0x60 | n, 0x40 | n, 0x20 | n, n))


def keystroke(modifier: int, key: int) -> bytes:
    """Encode one (modifier, key) pair. The modifier packet is omitted when 0."""
    out = bytearray()
    if modifier:
        h, l = modifier >> 4, modifier & 0x0F
        out += bytes((0x90 | h, 0xB0 | l, 0xD0 | h, 0xF0 | l))
    h, l = key >> 4, key & 0x0F
    out += bytes((0x80 | h, 0xA0 | l, 0xC0 | h, 0xE0 | l))
    return bytes(out)


def text_keystrokes(text: str, encoding: str = "cp932") -> List[Tuple[int, int]]:
    """Turn text into a list of (modifier, key) pairs, one per byte.

    Newlines become Enter (0x0D). Shift-JIS double-byte characters are sent as
    two key bytes, which is what BASTERM's key-send dialog does with the bytes
    of the text; whether the Saturn accepts that is a hardware-test item.
    """
    keys = []
    raw = text.replace("\r\n", "\n").replace("\n", "\r").encode(encoding)
    for b in raw:
        keys.append((MOD_NONE, b))
    return keys


def data_block(payload: bytes) -> bytes:
    """DATA frame plus the 256-byte block. Payload is padded with zeros."""
    if len(payload) > BLOCK_PAYLOAD:
        raise ValueError("payload longer than 252 bytes")
    padded = payload + bytes(BLOCK_PAYLOAD - len(payload))
    crc = crc16(padded)
    return (command_frame(DATA)
            + bytes((len(payload), sum8(padded), crc >> 8, crc & 0xFF))
            + padded)


def string_packet(text: str) -> bytes:
    """STRING frame plus 16 bytes. Filler after the NUL copies BASTERM ('0'+i%9)."""
    raw = text.encode("ascii")
    if len(raw) > STRING_MAX_CHARS:
        raise ValueError(f"string packet text longer than {STRING_MAX_CHARS}: {text!r}")
    body = bytearray()
    for i in range(STRING_TEXT):
        if i < len(raw):
            body.append(raw[i])
        elif i == len(raw):
            body.append(0)
        else:
            body.append(0x30 + i % 9)
    crc = crc16(bytes(body))
    return command_frame(STRING) + bytes((crc >> 8, crc & 0xFF)) + bytes(body)


# --- decoders ----------------------------------------------------------------

@dataclass
class Block:
    length: int
    payload: bytes  # already trimmed to length
    ok: bool


def parse_block(raw: bytes) -> Block:
    if len(raw) != BLOCK_SIZE:
        raise ValueError("data block must be 256 bytes")
    length, s, hi, lo = raw[0], raw[1], raw[2], raw[3]
    body = raw[4:]
    crc = crc16(body)
    ok = (s == sum8(body) and hi == crc >> 8 and lo == crc & 0xFF and length <= BLOCK_PAYLOAD)
    return Block(length, body[:min(length, BLOCK_PAYLOAD)], ok)


def parse_string(raw: bytes) -> Optional[str]:
    """Return the text of a 16-byte string packet body, or None on bad CRC."""
    if len(raw) != STRING_SIZE:
        raise ValueError("string packet must be 16 bytes")
    body = raw[2:]
    crc = crc16(body)
    if raw[0] != crc >> 8 or raw[1] != crc & 0xFF:
        return None
    text = body.split(b"\0", 1)[0]
    return text.decode("ascii", errors="replace")


# Reference Manual pp. 96-97: a base of 1-8 characters from A-Z, 0-9 and "_",
# then one of the extensions B (program), 0/1 (256/32768-colour bitmap) or
# D (other data). The Saturn upper-cases what is typed.
SATURN_NAME_RE = re.compile(r"[A-Z0-9_]{1,8}\.[B01D]", re.IGNORECASE)


def saturn_name_ok(name: str) -> bool:
    """True if the Saturn can use this name (e.g. GAME.B, PIC_01.1)."""
    return SATURN_NAME_RE.fullmatch(name) is not None


def clean_filename(name: str) -> str:
    """Trim a Saturn file name the way BASTERM does (FUN_0040b360).

    Trailing spaces and a trailing dot are removed, and spaces in front of the
    extension dot are squeezed out, so "TEST    .B  " becomes "TEST.B".
    """
    name = name.rstrip(" ")
    if name.endswith("."):
        name = name[:-1]
    if "." in name:
        stem, ext = name.rsplit(".", 1)
        name = stem.rstrip(" ") + "." + ext
    return name


# --- 4-byte group voting ----------------------------------------------------

def _tag(byte: int) -> int:
    """Return the position tag (0..3) of a frame byte, by its 0x60 bits."""
    return 3 - ((byte >> 5) & 0x03)


def decode_command(window: bytes) -> Optional[int]:
    """Decode a 4-byte command frame with BASTERM-style voting.

    At least three of the four bytes must sit in the right position (bits 6-5
    give 3,2,1,0) and agree on the low 5 bits. Returns the command or None.
    """
    if len(window) < 4:
        return None
    votes = {}
    good = 0
    for pos, b in enumerate(window[:4]):
        if b & 0x80 or b == 0:
            continue
        if _tag(b) != pos:
            continue
        good += 1
        votes[b & 0x1F] = votes.get(b & 0x1F, 0) + 1
    if good < 3:
        return None
    value, count = max(votes.items(), key=lambda kv: kv[1])
    if count < 2:
        return None
    return value


def decode_key_packet(window: bytes) -> Optional[Tuple[bool, int]]:
    """Decode a 4-byte keystroke packet. Returns (is_modifier, byte) or None."""
    if len(window) < 4:
        return None
    w = window[:4]
    if not all(b & 0x80 for b in w):
        return None
    if [(b >> 5) & 0x03 for b in w] != [0, 1, 2, 3]:
        return None
    mod_bits = sum(1 for b in w if b & 0x10)
    is_mod = mod_bits > 2
    hi = w[0] & 0x0F if (w[0] & 0x0F) == (w[2] & 0x0F) else w[2] & 0x0F
    lo = w[1] & 0x0F if (w[1] & 0x0F) == (w[3] & 0x0F) else w[3] & 0x0F
    return is_mod, (hi << 4) | lo


def command_name(n: int) -> str:
    return COMMAND_NAMES.get(n, f"CMD_{n:02X}")
