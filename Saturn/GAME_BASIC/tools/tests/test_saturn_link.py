"""Tests for saturn_link. Run from the tools folder:  python3 -m unittest discover tests"""

import os
import select
import sys
import tempfile
import threading
import time
import unittest

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from saturn_link import protocol as P  # noqa: E402
from saturn_link.link import SaturnLink, LinkError  # noqa: E402
from saturn_link.mock import MockSaturn  # noqa: E402
from saturn_link.preprocess import Options, build  # noqa: E402
from saturn_link.reader import Reader  # noqa: E402
from saturn_link.transport import Transport, pipe_pair  # noqa: E402


class ProtocolTests(unittest.TestCase):
    def test_crc_matches_x25_check_value(self):
        self.assertEqual(P.crc16(b"123456789"), 0x906E)

    def test_command_frames_match_protocol_notes(self):
        self.assertEqual(P.command_frame(P.ACK), bytes.fromhex("62422202"))
        self.assertEqual(P.command_frame(P.READ_BLOCK), b"eE%\x05")
        self.assertEqual(P.command_frame(P.STRING), b"yY9\x19")

    def test_keystroke_encoding(self):
        self.assertEqual(P.keystroke(0, ord("A")), bytes((0x84, 0xA1, 0xC4, 0xE1)))
        self.assertEqual(P.keystroke(5, 3), bytes((0x90, 0xB5, 0xD0, 0xF5, 0x80, 0xA3, 0xC0, 0xE3)))

    def test_data_block_round_trip(self):
        raw = P.data_block(b"10 PRINT 1\r\n")
        self.assertEqual(len(raw), 4 + 256)
        self.assertEqual(raw[:4], b"dD$\x04")
        blk = P.parse_block(raw[4:])
        self.assertTrue(blk.ok)
        self.assertEqual(blk.payload, b"10 PRINT 1\r\n")
        bad = bytearray(raw[4:])
        bad[10] ^= 1
        self.assertFalse(P.parse_block(bytes(bad)).ok)

    def test_string_packet_round_trip_and_filler(self):
        raw = P.string_packet("TBASTERM.B")
        self.assertEqual(len(raw), 20)
        self.assertEqual(raw[4 + 2 + 10], 0)  # NUL terminator
        self.assertEqual(P.parse_string(raw[4:]), "TBASTERM.B")
        with self.assertRaises(ValueError):
            P.string_packet("THIRTEENCHARS")

    def test_clean_filename(self):
        self.assertEqual(P.clean_filename("TEST    .B  "), "TEST.B")
        self.assertEqual(P.clean_filename("README."), "README")

    def test_reader_votes_out_a_bad_byte(self):
        a, b = pipe_pair()
        frame = bytearray(P.command_frame(P.READ_BLOCK))
        frame[1] ^= 0x04  # corrupt one copy
        a.write(bytes(frame) + P.command_frame(P.ACK))
        r = Reader(b)
        self.assertEqual(r.next_event(0.5), ("cmd", P.READ_BLOCK))
        self.assertEqual(r.next_event(0.5), ("cmd", P.ACK))

    def test_reader_survives_a_dropped_byte(self):
        a, b = pipe_pair()
        frame = P.command_frame(P.ACK)
        a.write(frame[:2] + frame[3:] + P.command_frame(P.READ_BLOCK))
        r = Reader(b)
        self.assertEqual(r.next_event(0.5), ("cmd", P.ACK))
        self.assertEqual(r.next_event(0.5), ("cmd", P.READ_BLOCK))

    def test_reader_pairs_modifier_and_key(self):
        a, b = pipe_pair()
        a.write(P.keystroke(5, 3) + P.keystroke(0, 0x41))
        r = Reader(b)
        self.assertEqual(r.next_event(0.5), ("key", 5, 3))
        self.assertEqual(r.next_event(0.5), ("key", 0, 0x41))


class PreprocessTests(unittest.TestCase):
    def _write(self, folder, name, text):
        path = os.path.join(folder, name)
        with open(path, "w", encoding="utf-8") as fh:
            fh.write(text)
        return path

    def test_help_file_numbering_example(self):
        # From BASTERM.HLP: start 100, step 1
        with tempfile.TemporaryDirectory() as d:
            p = self._write(d, "a.b", "print i\n\n1234 print j\nprint z\n")
            res = build(p, Options(auto_number=True, start=100, step=1))
            self.assertEqual(res.text(), "100 print i\r\n101 '\r\n1234 print j\r\n1235 print z\r\n")

    def test_label_rounding(self):
        with tempfile.TemporaryDirectory() as d:
            p = self._write(d, "a.b", "a=1\nb=2\n*LOOP\nGOTO *LOOP\n")
            res = build(p, Options(auto_number=True, start=100, step=1, label_interval=100))
            self.assertEqual([n for n, _, _ in res.lines], [100, 101, 200, 201])

    def test_checks(self):
        with tempfile.TemporaryDirectory() as d:
            p = self._write(d, "a.b", "10 A=1\nB=2\n10 C=3\n100000 D=4\n20 X$=\"\U0001F600\"\n")
            msgs = [str(x) for x in build(p).problems]
            self.assertEqual(len(msgs), 4, msgs)
            self.assertIn("no line number", msgs[0])
            self.assertIn("duplicate", msgs[1])
            self.assertIn("above 99999", msgs[2])
            self.assertIn("Shift-JIS", msgs[3])

    def test_include(self):
        with tempfile.TemporaryDirectory() as d:
            self._write(d, "DATA.B", "10000 DATA 1,2,3\n")
            p = self._write(d, "main.b", '10 READ A\n#include "data.b"\n')
            res = build(p)
            self.assertEqual(res.text(), "10 READ A\r\n10000 DATA 1,2,3\r\n")
            p2 = self._write(d, "bad.b", '#include "NOPE.B"\n')
            self.assertIn("not found", str(build(p2).problems[0]))

    def test_direct_commands_and_comments_are_left_out(self):
        # DEMO.B on the CD starts with LOAD"COM:DDD" and has no-number comments.
        with tempfile.TemporaryDirectory() as d:
            p = self._write(d, "demo.b", 'LOAD"COM:DDD"\n1000 \' TITLE\n\'LOAD END\n1100 END\n')
            res = build(p)
            self.assertEqual(res.errors, [])
            self.assertEqual([x.severity for x in res.problems], ["info", "info"])
            self.assertEqual(res.text(), "1000 ' TITLE\r\n1100 END\r\n")
            res = build(p, Options(auto_number=True))
            self.assertEqual(res.text(), "1000 ' TITLE\r\n1010 'LOAD END\r\n1100 END\r\n")
            p2 = self._write(d, "bad.b", "PRINT 1\n")
            self.assertEqual(len(build(p2).errors), 1)

    def test_japanese_text_is_shift_jis(self):
        with tempfile.TemporaryDirectory() as d:
            p = self._write(d, "j.b", '10 PRINT "セガ"\n')
            self.assertEqual(build(p).encode(), b'10 PRINT "\x83Z\x83K"\r\n')


def _session(nak=False, baud=None):
    pc, sat = pipe_pair(baud)
    mock = MockSaturn(sat, nak_first_block=nak)
    mock.start()
    link = SaturnLink(pc, key_delay=0)
    link.connect()
    return link, mock


class LinkTests(unittest.TestCase):
    PROG = b"".join(b"%d PRINT \"HELLO %d\"\r\n" % (i * 10, i) for i in range(1, 80))

    def test_send_and_receive(self):
        link, mock = _session()
        st = link.send_program(self.PROG)
        self.assertEqual(st.bytes_sent, len(self.PROG))
        self.assertEqual(len(mock.program), 79)
        self.assertIn('LOAD "COM:TBASTERM.B"', mock.commands)
        self.assertEqual(link.receive_program(), self.PROG)
        mock.stop_thread()

    def test_send_run_and_merge_flags(self):
        link, mock = _session()
        link.send_program(b"10 A=1\r\n20 B=2\r\n")
        link.send_program(b"20 B=3\r\n", run=True, merge=True)
        self.assertEqual(mock.commands[-1], 'LOAD "COM:TBASTERM.B",R,M')
        self.assertEqual(mock.program, {10: "A=1", 20: "B=3"})
        self.assertTrue(mock.running)
        link.stop()
        self.assertFalse(mock.running)
        mock.stop_thread()

    def test_nak_resends_same_block(self):
        link, mock = _session(nak=True)
        st = link.send_program(self.PROG)
        self.assertEqual(st.naks_received, 1)
        self.assertEqual(len(mock.program), 79)
        mock.stop_thread()

    def test_saturn_echo_reaches_terminal(self):
        out = bytearray()
        link, mock = _session()
        link.on_char = lambda m, k: out.append(k)
        link.send_program(b"10 A=1\r\n")
        link.pump_for(0.2)
        self.assertIn(b"Ready.", bytes(out))
        mock.stop_thread()

    def test_reads_back_line_and_errors(self):
        # Tutorial manual p. 152: after a load the Saturn shows "Line 120".
        link, mock = _session()
        st = link.send_program(b"100 SCREEN\r\n110 PRINT 1\r\n120 GOTO 110\r\n")
        self.assertEqual(st.last_line, 120)
        self.assertEqual(st.saturn_errors, [])
        self.assertIn("Line 120", st.saturn_text)
        # The mock says "Syntax error" for a line it can't take.
        st = link.send_program(b"10 A=1\r\nNAXT\r\n")
        self.assertEqual(st.saturn_errors, ["Syntax error"])
        mock.stop_thread()

    def test_break_reports_line(self):
        # Tutorial manual p. 28: Ctrl+C (BASTERM's STOP) prints "Break at N".
        link, mock = _session()
        link.send_program(b"120 *LOOP\r\n130 GOTO *LOOP\r\n", run=True)
        st = link.send_program(b"10 A=1\r\n")  # sends STOP first
        self.assertIn("Break at 130", link.screen_lines)
        self.assertEqual(st.last_line, 10)
        mock.stop_thread()

    def test_serves_other_files_from_folder_only(self):
        with tempfile.TemporaryDirectory() as d:
            with open(os.path.join(d, "Data.b"), "wb") as fh:
                fh.write(b"10 REM FROM DISK\r\n")
            pc, sat = pipe_pair()
            mock = MockSaturn(sat)
            mock.start()
            link = SaturnLink(pc, serve_dir=d, key_delay=0)
            link.connect()
            # The mock types LOAD for us when we type it; load a real file.
            link.stop()
            link._type_command('LOAD "COM:DATA.B"')
            link.pump_until(lambda: "DATA.B" in [n.upper() for n in link.stats.closed], 5, "load")
            link.pump_for(0.2)
            self.assertEqual(mock.program, {10: "REM FROM DISK"})
            self.assertIsNone(link._resolve("../etc"))
            mock.stop_thread()

    def test_no_saturn_times_out(self):
        pc, _sat = pipe_pair()
        link = SaturnLink(pc)
        with self.assertRaises(LinkError):
            link.connect(timeout=0.3)

    def test_real_speed_19200(self):
        link, mock = _session(baud=19200)
        t0 = time.monotonic()
        part = b"".join(self.PROG.split(b"\r\n")[i] + b"\r\n" for i in range(30))
        link.send_program(part)
        self.assertEqual(len(mock.program), 30)
        self.assertLess(time.monotonic() - t0, 10)
        mock.stop_thread()


class FdTransport(Transport):
    def __init__(self, fd):
        self.fd = fd

    def write(self, data):
        os.write(self.fd, data)

    def read(self, n, timeout):
        r, _, _ = select.select([self.fd], [], [], max(timeout, 0))
        if not r:
            return b""
        try:
            return os.read(self.fd, n)
        except OSError:
            return b""


@unittest.skipIf(os.name == "nt", "pty test needs macOS or Linux")
class PySerialPtyTest(unittest.TestCase):
    """Runs the real pyserial code path against the mock on a pseudo-terminal."""

    def test_send_over_pty(self):
        try:
            import serial  # noqa: F401
        except ImportError:
            self.skipTest("pyserial not installed")
        import pty
        import tty
        from saturn_link.transport import SerialTransport
        master, slave = pty.openpty()
        tty.setraw(slave)
        name = os.ttyname(slave)
        mock = MockSaturn(FdTransport(master))
        mock.start()
        link = SaturnLink(SerialTransport(name, 9600), key_delay=0.001)
        link.connect()
        link.send_program(LinkTests.PROG, run=True)
        self.assertEqual(len(mock.program), 79)
        self.assertTrue(mock.running)
        link.close()
        mock.stop_thread()
        os.close(slave)


if __name__ == "__main__":
    unittest.main()
