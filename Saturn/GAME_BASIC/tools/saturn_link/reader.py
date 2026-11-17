"""Turns the incoming byte stream into events. Used by both the PC side and the mock Saturn."""

from __future__ import annotations

import time
from typing import Optional, Tuple

from .protocol import _tag, decode_command, decode_key_packet
from .transport import Transport

# Event shapes:
#   ("nul",)
#   ("cmd", n)
#   ("key", modifier, key)
Event = Tuple


class Reader:
    def __init__(self, transport: Transport):
        self.t = transport
        self.buf = bytearray()
        self._modifier = 0
        self.dropped = 0  # bytes skipped while resynchronising

    # -- low level ----------------------------------------------------------
    def _fill(self, timeout: float) -> bool:
        data = self.t.read(1024, timeout)
        if data:
            self.buf += data
            return True
        return False

    def read_raw(self, n: int, timeout: float) -> Optional[bytes]:
        """Read exactly n raw bytes (block or string bodies)."""
        deadline = time.monotonic() + timeout
        while len(self.buf) < n:
            left = deadline - time.monotonic()
            if left <= 0 or not self._fill(left):
                if len(self.buf) >= n:
                    break
                return None
        out = bytes(self.buf[:n])
        del self.buf[:n]
        return out

    # -- framing ------------------------------------------------------------
    def _try_parse(self) -> Tuple[Optional[Event], bool]:
        """Parse one event from buf. Returns (event, need_more)."""
        while self.buf:
            b = self.buf[0]
            if b == 0:
                del self.buf[0]
                return ("nul",), False
            if b & 0x80:
                if len(self.buf) < 4:
                    return None, True
                res = decode_key_packet(bytes(self.buf[:4]))
                if res is None:
                    del self.buf[0]
                    self.dropped += 1
                    continue
                del self.buf[:4]
                is_mod, value = res
                if is_mod:
                    self._modifier = value
                    continue
                mod, self._modifier = self._modifier, 0
                return ("key", mod, value), False
            # command frame byte
            if len(self.buf) < 4:
                # A short frame may still be a 3-of-4 frame; wait for more first.
                return None, True
            cmd = decode_command(bytes(self.buf[:4]))
            if cmd is not None:
                del self.buf[:4]
                return ("cmd", cmd), False
            three = self._three_of_four()
            if three is not None:
                del self.buf[:3]
                self.dropped += 1
                return ("cmd", three), False
            del self.buf[0]
            self.dropped += 1
        return None, True

    def _three_of_four(self) -> Optional[int]:
        """Accept a frame that lost one byte in transit (3 bytes, rising tags)."""
        w = self.buf[:3]
        if any(x & 0x80 or x == 0 for x in w):
            return None
        tags = [_tag(x) for x in w]
        if not (tags[0] < tags[1] < tags[2]):
            return None
        vals = {x & 0x1F for x in w}
        if len(vals) != 1:
            return None
        return vals.pop()

    def next_event(self, timeout: float) -> Optional[Event]:
        deadline = time.monotonic() + timeout
        while True:
            ev, need_more = self._try_parse()
            if ev is not None:
                return ev
            left = deadline - time.monotonic()
            if left <= 0:
                # flush a stuck partial frame after the wait (BASTERM: 2 s rule)
                return None
            if not self._fill(left):
                return None
