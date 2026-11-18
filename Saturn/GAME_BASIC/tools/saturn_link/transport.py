# Created with Claude Opus 5.5, Nov 2026
# Guided by Brett Hallen
"""Byte transports: a real serial port (pyserial) or an in-process pipe pair."""

from __future__ import annotations

import queue
import threading
import time
from typing import Optional, Tuple


class Transport:
    """Minimal interface the link code needs."""

    def write(self, data: bytes) -> None:  # pragma: no cover - interface
        raise NotImplementedError

    def read(self, n: int, timeout: float) -> bytes:  # pragma: no cover
        """Read up to n bytes, waiting at most timeout seconds for the first."""
        raise NotImplementedError

    def close(self) -> None:
        pass


class SerialTransport(Transport):
    """A pyserial port opened the way BASTERM opens COMx (0x4011C0)."""

    def __init__(self, port: str, baud: int = 9600):
        try:
            import serial  # type: ignore
        except ImportError as exc:  # pragma: no cover - depends on env
            raise SystemExit(
                "pyserial is not installed. Run: python3 -m pip install pyserial"
            ) from exc
        self._serial_mod = serial
        if "://" in port:
            # pyserial URL handlers (socket://, rfc2217://, loop://) for testing
            self.ser = serial.serial_for_url(port, baudrate=baud, timeout=0)
        else:
            self.ser = serial.Serial(
                port=port,
                baudrate=baud,
                bytesize=serial.EIGHTBITS,
                parity=serial.PARITY_NONE,
                stopbits=serial.STOPBITS_ONE,
                xonxoff=False,
                rtscts=False,
                dsrdtr=False,
                timeout=0,
                write_timeout=1.0,
            )
            try:
                self.ser.dtr = True
                self.ser.rts = True
            except (OSError, ValueError):
                pass
        try:
            self.ser.reset_input_buffer()
        except (OSError, AttributeError):
            pass

    def write(self, data: bytes) -> None:
        self.ser.write(data)
        try:
            self.ser.flush()
        except (OSError, AttributeError):
            pass

    def read(self, n: int, timeout: float) -> bytes:
        self.ser.timeout = max(timeout, 0)
        data = self.ser.read(1)
        if not data:
            return b""
        waiting = getattr(self.ser, "in_waiting", 0)
        if waiting and n > 1:
            self.ser.timeout = 0
            data += self.ser.read(min(n - 1, waiting))
        return data

    def close(self) -> None:
        try:
            self.ser.dtr = False
        except (OSError, ValueError, AttributeError):
            pass
        self.ser.close()


class PipeTransport(Transport):
    """One end of an in-process byte pipe. Works on every OS."""

    def __init__(self, rx: "queue.Queue[int]", tx: "queue.Queue[int]",
                 baud: Optional[int] = None, fault=None):
        self._rx = rx
        self._tx = tx
        self._byte_time = (10.0 / baud) if baud else 0.0
        self._fault = fault  # optional callable(bytes) -> bytes, for tests
        self._closed = False

    def write(self, data: bytes) -> None:
        if self._fault:
            data = self._fault(data)
        for b in data:
            self._tx.put(b)
        if self._byte_time:
            time.sleep(self._byte_time * len(data))

    def read(self, n: int, timeout: float) -> bytes:
        out = bytearray()
        try:
            out.append(self._rx.get(timeout=max(timeout, 0.0001)))
        except queue.Empty:
            return b""
        while len(out) < n:
            try:
                out.append(self._rx.get_nowait())
            except queue.Empty:
                break
        return bytes(out)

    def close(self) -> None:
        self._closed = True


def pipe_pair(baud: Optional[int] = None) -> Tuple[PipeTransport, PipeTransport]:
    a: "queue.Queue[int]" = queue.Queue()
    b: "queue.Queue[int]" = queue.Queue()
    return PipeTransport(a, b, baud), PipeTransport(b, a, baud)


class Tap(Transport):
    """Wraps a transport and logs every byte both ways (for --trace)."""

    def __init__(self, inner: Transport, log):
        self.inner = inner
        self.log = log
        self._lock = threading.Lock()

    def write(self, data: bytes) -> None:
        with self._lock:
            self.log("PC  -> " + data.hex(" "))
        self.inner.write(data)

    def read(self, n: int, timeout: float) -> bytes:
        data = self.inner.read(n, timeout)
        if data:
            with self._lock:
                self.log("SAT -> " + data.hex(" "))
        return data

    def close(self) -> None:
        self.inner.close()
