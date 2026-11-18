# Created with Claude Opus 5.5, Nov 2026
# Guided by Brett Hallen
"""Command line front end: python3 saturn_send.py <command> ...

Exit codes: 0 ok, 1 link or transfer error, 2 program check errors, 3 usage,
4 sent, but the Saturn printed an error message.
"""

from __future__ import annotations

import argparse
import json
import os
import re
import sys
import threading
import time

from . import __version__
from . import protocol as P
from . import errors as E
from .link import LinkError, SaturnLink
from .preprocess import Options, build
from .transport import SerialTransport, Tap, pipe_pair


def _err(msg: str) -> None:
    print(msg, file=sys.stderr, flush=True)


def _log_fn(verbose: bool):
    def log(msg: str) -> None:
        if verbose:
            print(msg, flush=True)
    return log


class Terminal:
    """Prints characters the Saturn sends back (its screen echo)."""

    def __init__(self, enabled: bool = True):
        self.enabled = enabled
        self.buf = bytearray()

    def __call__(self, mod: int, key: int) -> None:
        if not self.enabled:
            return
        if key == 0x0D:
            key = 0x0A
        self.buf.append(key)
        if key == 0x0A or len(self.buf) > 80:
            self.flush()

    def flush(self) -> None:
        if self.buf:
            text = self.buf.decode("cp932", errors="replace").rstrip("\n")
            print(f"[saturn] {text}", flush=True)
            self.buf.clear()


def _options(a) -> Options:
    return Options(
        auto_number=a.auto_number,
        start=a.start,
        step=a.step,
        label_interval=a.label_interval,
        max_line_bytes=a.max_line_bytes,
    )


def _open_link(a, log, term) -> SaturnLink:
    if a.mock:
        from .mock import MockSaturn
        pc_end, sat_end = pipe_pair(baud=None)
        mock = MockSaturn(sat_end, nak_first_block=a.mock_nak, log=log)
        mock.start()
        transport = pc_end
        print("Using the built-in mock Saturn (no hardware).", flush=True)
    else:
        if not a.port:
            _err("No serial port given. Use --port (see: saturn_send.py ports) or --mock.")
            sys.exit(3)
        transport = SerialTransport(a.port, a.baud)
    if a.trace:
        transport = Tap(transport, lambda s: print("  " + s, flush=True))
    link = SaturnLink(transport, serve_dir=a.serve_dir, log=log, on_char=term,
                      key_delay=a.key_delay)
    link.connect(timeout=a.connect_timeout)
    return link


def _check(a) -> int:
    res = build(a.file, _options(a))
    for p in res.problems:
        print(p, flush=True)
    return 2 if res.errors else 0


def cmd_check(a) -> int:
    rc = _check(a)
    if rc == 0 and not a.json:
        print("No errors found.")
    return rc


def cmd_build(a) -> int:
    res = build(a.file, _options(a))
    for p in res.problems:
        _err(str(p))
    if res.errors:
        return 2
    data = res.encode()
    if a.output and a.output != "-":
        with open(a.output, "wb") as fh:
            fh.write(data)
        print(f"Wrote {len(res.lines)} lines, {len(data)} bytes to {a.output}")
    else:
        sys.stdout.write(data.decode("cp932"))
    return 0


def _last_line_number(data: bytes):
    """Line number of the last numbered line in the program text, or None."""
    nums = re.findall(rb"^\s*(\d+)", data, re.M)
    return int(nums[-1]) if nums else None


def cmd_send(a) -> int:
    res = build(a.file, _options(a))
    for p in res.problems:
        print(p, flush=True)
    if res.errors:
        _err(f"Not sent: {len(res.errors)} error(s).")
        return 2
    data = res.encode()
    if a.serve_dir is None:
        a.serve_dir = os.path.dirname(os.path.abspath(a.file))
    log = _log_fn(a.verbose)
    term = Terminal(not a.quiet)
    link = None
    try:
        link = _open_link(a, log, term)
        t0 = time.monotonic()
        print(f"Sending {len(res.lines)} lines ({len(data)} bytes)...", flush=True)
        st = link.send_program(data, run=a.run, merge=a.merge, timeout=a.timeout)
        dt = time.monotonic() - t0
        term.flush()
        extra = f", {st.naks_received} block(s) resent" if st.naks_received else ""
        loaded = f"; the Saturn says Line {st.last_line}" if st.last_line is not None else ""
        print(f"Sent {st.bytes_sent} bytes in {st.blocks_sent} blocks, {dt:.1f} s{extra}"
              f"{loaded}.", flush=True)
        expect = _last_line_number(data)
        if st.last_line is not None and expect is not None and st.last_line != expect:
            print(f"Warning: the last line sent was {expect}, but the Saturn reports "
                  f"Line {st.last_line}. Check its screen.", flush=True)
        if st.saturn_errors:
            why = E.explain(st.saturn_errors[0])
            _err("Error: The Saturn reported: " + "; ".join(st.saturn_errors[:3])
                 + (f" ({why})" if why else ""))
            return 4
        if a.run:
            print("Program is running.", flush=True)
        if a.serve:
            print("Serving COM: files. Press Ctrl+C to stop.", flush=True)
            try:
                link.serve()
            except KeyboardInterrupt:
                pass
        return 0
    except LinkError as exc:
        term.flush()
        _err(f"Error: {exc}")
        return 1
    except KeyboardInterrupt:
        _err("Error: cancelled.")
        return 130
    finally:
        if link:
            link.close()


def cmd_run(a) -> int:
    return _simple(a, lambda link: link.run_program(), "RUN sent.")


def cmd_show_error(a) -> int:
    def go(link):
        link.show_error_line()
        link.pump_for(0.5)
    return _simple(a, go, "Sent F12, then ERROR.")


def cmd_stop(a) -> int:
    return _simple(a, lambda link: link.stop(), "Stopped.")


def cmd_type(a) -> int:
    def go(link):
        link.type_text(a.text)
        if a.enter:
            link.key(*P.KEY_ENTER)
        link.pump_for(0.5)
    return _simple(a, go, "Typed.")


def _simple(a, fn, ok: str) -> int:
    term = Terminal(not a.quiet)
    link = None
    try:
        link = _open_link(a, _log_fn(a.verbose), term)
        fn(link)
        link.pump_for(0.3)
        term.flush()
        print(ok, flush=True)
        if getattr(a, "serve", False):
            print("Serving COM: files. Press Ctrl+C to stop.", flush=True)
            link.serve()
        return 0
    except LinkError as exc:
        term.flush()
        _err(f"Error: {exc}")
        return 1
    except KeyboardInterrupt:
        return 0
    finally:
        if link:
            link.close()


def cmd_receive(a) -> int:
    term = Terminal(not a.quiet)
    link = None
    try:
        link = _open_link(a, _log_fn(a.verbose), term)
        if a.mock:
            # give the mock something to hand back
            link.send_program(b'10 PRINT "HELLO FROM THE MOCK SATURN"\r\n20 GOTO 10\r\n')
        data = link.receive_program(timeout=a.timeout)
        term.flush()
        text = data.decode("cp932", errors="replace").replace("\r\n", "\n")
        if a.output == "-":
            sys.stdout.write(text)
        else:
            with open(a.output, "w", encoding=a.encoding, newline="\n") as fh:
                fh.write(text)
            print(f"Received {len(data)} bytes into {a.output}", flush=True)
        return 0
    except LinkError as exc:
        term.flush()
        _err(f"Error: {exc}")
        return 1
    finally:
        if link:
            link.close()


def cmd_serve(a) -> int:
    term = Terminal(not a.quiet)
    link = None
    try:
        link = _open_link(a, _log_fn(True), term)
        print(f"Serving COM: files from {a.serve_dir or '(nowhere)'}. Ctrl+C to stop.",
              flush=True)
        link.serve()
        return 0
    except LinkError as exc:
        _err(f"Error: {exc}")
        return 1
    except KeyboardInterrupt:
        return 0
    finally:
        if link:
            link.close()


def cmd_ports(a) -> int:
    try:
        from serial.tools import list_ports  # type: ignore
    except ImportError:
        _err("pyserial is not installed. Run: python3 -m pip install pyserial")
        return 1
    ports = []
    for p in sorted(list_ports.comports(), key=lambda p: p.device):
        ports.append({"device": p.device, "description": p.description or "",
                      "hwid": p.hwid or ""})
    if a.json:
        print(json.dumps(ports))
    else:
        if not ports:
            print("No serial ports found.")
        for p in ports:
            print(f"{p['device']}\t{p['description']}")
    return 0


def cmd_selftest(a) -> int:
    """End-to-end check against the mock Saturn: send, run, receive, NAK path."""
    from .mock import MockSaturn
    ok = True
    prog = "".join(f"{10 * i} PRINT \"LINE {i}\"\r\n" for i in range(1, 60)).encode()
    for nak in (False, True):
        pc, sat = pipe_pair(baud=a.baud if a.real_speed else None)
        mock = MockSaturn(sat, nak_first_block=nak)
        mock.start()
        link = SaturnLink(pc, key_delay=0.0 if not a.real_speed else 0.03)
        link.connect()
        st = link.send_program(prog, run=True)
        got = "".join(f"{n} {mock.program[n]}\r\n" for n in sorted(mock.program)).encode()
        good = got == prog and mock.running
        print(f"send{' with NAK' if nak else ''}: {len(prog)} bytes, "
              f"{st.blocks_sent} blocks, resent {st.naks_received}: {'OK' if good else 'FAIL'}")
        ok &= good
        back = link.receive_program()
        good = back == prog
        print(f"receive: {len(back)} bytes: {'OK' if good else 'FAIL'}")
        ok &= good
        link.close()
        mock.stop_thread()
    print("Self-test passed." if ok else "Self-test FAILED.")
    return 0 if ok else 1


def main(argv=None) -> int:
    ap = argparse.ArgumentParser(
        prog="saturn_send.py",
        description="Send GAME BASIC for SEGASATURN programs over a serial cable "
                    "(a cross-platform BASTERM replacement).")
    ap.add_argument("--version", action="version", version=__version__)
    sub = ap.add_subparsers(dest="command", required=True)

    def link_args(p):
        p.add_argument("-p", "--port", default=os.environ.get("SATURN_PORT"),
                       help="serial port, e.g. /dev/cu.usbserial-1410 or COM3 "
                            "(env SATURN_PORT). pyserial URLs like socket://host:port work too")
        p.add_argument("-b", "--baud", type=int, default=int(os.environ.get("SATURN_BAUD", 9600)),
                       choices=(9600, 19200), help="must match GAME BASIC (default 9600)")
        p.add_argument("--mock", action="store_true", help="talk to a built-in pretend Saturn")
        p.add_argument("--mock-nak", action="store_true", help=argparse.SUPPRESS)
        p.add_argument("--trace", action="store_true", help="hex dump every byte")
        p.add_argument("-v", "--verbose", action="store_true", help="log protocol steps")
        p.add_argument("-q", "--quiet", action="store_true", help="hide the Saturn's screen echo")
        p.add_argument("--key-delay", type=float, default=0.03,
                       help="seconds between typed keystrokes (default 0.03)")
        p.add_argument("--connect-timeout", type=float, default=5.0)
        p.add_argument("--serve-dir", default=None,
                       help='folder for other COM: files the program opens '
                            '(send: defaults to the program\'s folder)')

    def prog_args(p):
        p.add_argument("file", help="BASIC source (.B / .bas)")
        p.add_argument("-n", "--auto-number", action="store_true",
                       help="number lines that have no line number")
        p.add_argument("--start", type=int, default=10)
        p.add_argument("--step", type=int, default=10)
        p.add_argument("--label-interval", type=int, default=0,
                       help="round '*label' lines up to a multiple of this (0 = off)")
        p.add_argument("--max-line-bytes", type=int, default=255)
        p.add_argument("--json", action="store_true", help=argparse.SUPPRESS)

    p = sub.add_parser("check", help="check a program without sending it")
    prog_args(p)
    p.set_defaults(fn=cmd_check)

    p = sub.add_parser("build", help="write the exact text that would be sent")
    prog_args(p)
    p.add_argument("-o", "--output", default="-")
    p.set_defaults(fn=cmd_build)

    p = sub.add_parser("send", help="send a program (LOAD \"COM:TBASTERM.B\")")
    prog_args(p)
    link_args(p)
    p.add_argument("-r", "--run", action="store_true", help="run after loading (,R)")
    p.add_argument("-m", "--merge", action="store_true", help="merge without NEW (,M)")
    p.add_argument("--serve", action="store_true",
                   help="stay connected afterwards to serve COM: files and show output")
    p.add_argument("--timeout", type=float, default=300.0)
    p.set_defaults(fn=cmd_send)

    p = sub.add_parser("run", help="stop, then type RUN")
    link_args(p)
    p.add_argument("--serve", action="store_true")
    p.set_defaults(fn=cmd_run)

    p = sub.add_parser("stop", help="send STOP")
    link_args(p)
    p.set_defaults(fn=cmd_stop)

    p = sub.add_parser("show-error", help="press F12, then type ERROR: show the line a program stopped on")
    link_args(p)
    p.set_defaults(fn=cmd_show_error)

    p = sub.add_parser("type", help="type text at the Saturn")
    link_args(p)
    p.add_argument("text")
    p.add_argument("--no-enter", dest="enter", action="store_false")
    p.set_defaults(fn=cmd_type)

    p = sub.add_parser("receive", help="fetch the Saturn's program (SAVE \"COM:TBASTERM.B\")")
    link_args(p)
    p.add_argument("-o", "--output", required=True, help="file to write, or - for stdout")
    p.add_argument("--encoding", default="utf-8", help="encoding of the saved file")
    p.add_argument("--timeout", type=float, default=300.0)
    p.set_defaults(fn=cmd_receive)

    p = sub.add_parser("serve", help="stay connected: serve COM: files and show output")
    link_args(p)
    p.set_defaults(fn=cmd_serve)

    p = sub.add_parser("ports", help="list serial ports")
    p.add_argument("--json", action="store_true")
    p.set_defaults(fn=cmd_ports)

    p = sub.add_parser("selftest", help="run send/receive against the mock Saturn")
    p.add_argument("--baud", type=int, default=9600)
    p.add_argument("--real-speed", action="store_true", help="simulate the baud rate's timing")
    p.set_defaults(fn=cmd_selftest)

    a = ap.parse_args(argv)
    return a.fn(a)
