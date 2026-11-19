# GAME BASIC BASTERM serial protocol

BASTERM turns the PC into a file server for GAME BASIC for SEGASATURN: it types `LOAD "COM:TBASTERM.B"` into the Saturn as keystrokes, and the Saturn then pulls the plain-text program over 8N1 serial in CRC-checked 252-byte blocks. Findings come from static analysis of the 1998 installers; nothing was run.

## What is on the CD

The CD holds two InstallShield 3 installers and a launcher; only BASTERM talks to the Saturn. Both installers unpack with standard tools (ZIP stubs, then a PKWARE-imploded `data.z`). All files are ©1998 ASCII Corp., Bits Laboratory and ESP inc.

| File | What it is | Contents |
| --- | --- | --- |
| `ToolLoad.exe` | CD autorun menu (`autorun.inf`: `ToolLoad.exe /1 instbt10.exe instdc10.exe`) | Lets you pick which installer to run |
| `Instbt10.exe` | Installer for **BASTERM 1.0** | `Basterm.exe` (Win32 MFC editor + serial terminal, 566 KB), `BASTERM.HLP`/`.cnt` (Japanese help), `readme.txt` |
| `Instdc10.exe` | Installer for **DXFCONV** 3D model converters | `DXFCONV.EXE` (Win95 GUI), `DXF2POL.EXE`, `POL2BAS.EXE`, `POL2BAS2.EXE` (DOS), their C sources, `HEADBAS.B` viewer stub, sample `GIRL`/`ASCII` models |

DXFCONV is offline only. It turns `3DFACE` entities in a DXF file into BASIC `DATA` lines (`.VTX` vertices from line 10000, `.PNT` polygons from line 20000) for `SETVERTEX` and `SETPOLYGON`. The C sources are on the CD, so it ports to any OS with a recompile.

## How a send works

The PC never pushes a program. It types a LOAD command at the Saturn's keyboard prompt, then answers the Saturn's file requests for `COM:` paths from its current directory.

1. BASTERM saves the editor text, optionally runs a user DOS filter (`IBASTERM.B` in, `OBASTERM.B` out), adds line numbers if asked, checks lines, and optionally diffs against the last send.
2. It writes the result to the temp file `TBASTERM.B` in the current directory.
3. It sends a STOP key (modifier 5, key 0x03) every 50 ms until the Saturn reports a status, giving up after 5 s.
4. It sends key 0x0A, waits 800 ms, then types `LOAD "COM:TBASTERM.B"` and CR, one keystroke packet per character. Variants: `,R` runs after loading, `,M` merges without `NEW` (used for diff sends), `,R,M` does both.
5. The Saturn opens the file: open-for-read command, then a string packet holding `TBASTERM.B`. BASTERM replies with a handle code, or an error.
6. The Saturn loops on read requests. Each one gets a data block of up to 252 bytes, and a zero-length block at end of file.
7. The Saturn closes the handle. BASTERM shows the byte count and waits for the Saturn's "done" status.

Receiving works the same way in reverse. BASTERM types `SAVE "COM:TBASTERM.B"`, the Saturn opens the file for write and sends data blocks, and BASTERM loads the file into the editor. **Run** sends STOP until acknowledged, then key 0x0A, `Run` and CR.

## Serial settings

The port is plain 8N1 with no flow control, which fits a TX/RX/GND-only 5 V TTL link. Values are read from the `DCB` and `COMMTIMEOUTS` that `Basterm.exe` builds at `0x4011C0`.

| Setting | Value | Note |
| --- | --- | --- |
| Baud | 9600 (default) or 19200 | Must match the Saturn's setting (system settings screen: L+R+Z on the pad or Q+E+D on the keyboard, Reference Manual pp. 19–20); drop to 9600 if 19200 gives errors |
| Framing | 8 data bits, no parity, 1 stop bit | `fBinary` on |
| Flow control | None | CTS, DSR, XON/XOFF all off |
| DTR / RTS | Both asserted while open | DTR raised on connect, dropped on disconnect; harmless on a 3-wire cable |
| Port buffers | 4096 bytes in and out | `SetupComm` |
| Write timeout | 1000 ms total | Read is non-blocking, driven by `WaitCommEvent` |
| Port and baud store | Registry `SOFTWARE\Bits Laboratory\BASTERM\1.0`, values `Port`, `Baudrate` | Default `COM1`, 9600 |

## Wire format

Every byte on the wire belongs to one of four frame types, and the top three bits tell them apart. Each type repeats its information so a receiver can vote out a corrupted byte.

**Command frame (4 bytes).** A 5-bit command number `n` (1 to 0x1B) is sent as `0x60|n, 0x40|n, 0x20|n, n`. So ACK (2) is `62 42 22 02` (`bB"` + 0x02) and "read block" (5) is `65 45 25 05`. BASTERM's decoder (`0x404BE0`) accepts a frame when enough of the four positions agree.

**Keystroke packet (4 bytes).** A byte `k` is split into nibbles `h` and `l`. A key or character goes as `0x80|h, 0xA0|l, 0xC0|h, 0xE0|l`. A modifier or scancode byte goes first, if nonzero, as `0x90|h, 0xB0|l, 0xD0|h, 0xF0|l` (bit 4 set). Keystrokes need no ACK. The Saturn uses the same encoding for characters it sends back, which BASTERM shows in its terminal pane.

**Data block (4 + 256 bytes).** Command frame 0x04, then:

| Offset | Size | Field |
| --- | --- | --- |
| 0 | 1 | Payload length, 0 to 252 (0 means end of file) |
| 1 | 1 | 8-bit sum of the 252 payload bytes |
| 2 | 2 | CRC-16, high byte first, over the 252 payload bytes |
| 4 | 252 | Payload, padded to 252 bytes |

The receiver answers ACK (0x02) or NAK (0x03) within 1 s. BASTERM does not resend on NAK itself; the Saturn re-requests.

**String packet (4 + 16 bytes).** Command frame 0x19 (`yY9` + 0x19), then CRC-16 (high byte first), then 14 bytes of NUL-terminated text. Strings are at most 12 characters, enough for an 8.3 file name or a hex number. Padding bytes after the NUL are filler. It is answered with ACK or NAK.

**CRC-16.** Reflected polynomial 0x8408 (CCITT), initial value 0xFFFF, result inverted. That is CRC-16/X-25, but stored big-endian:

```python
def crc16(data):
    crc = 0xFFFF
    for b in data:
        crc ^= b
        for _ in range(8):
            crc = (crc >> 1) ^ 0x8408 if crc & 1 else crc >> 1
    return crc ^ 0xFFFF   # send (crc >> 8), then (crc & 0xFF)
```

## Command table

The Saturn drives a small file-server protocol, and BASTERM's dispatcher (jump table at `0x404094`) answers it. Up to three files can be open at once; one is "current" at a time. Meanings marked *inferred* come from how BASTERM uses the value, not from a handler.

| Code | Frame | From | Meaning | BASTERM's reply |
| --- | --- | --- | --- | --- |
| 0x01 | `aA!` 01 | Both | Link up (see next section) | None |
| 0x02 | `bB"` 02 | Both | ACK | None |
| 0x03 | `cC#` 03 | Both | NAK or general error | None |
| 0x04 | `dD$` 04 | Both | Data block follows (256 bytes) | Writes payload to the current file, then ACK or NAK |
| 0x05 | `eE%` 05 | Saturn | Read next block of the current file | Data block (length 0 at EOF), waits for ACK |
| 0x06 to 0x09 | `fF&` 06 … `iI)` 09 | Saturn | Status 1 to 4. 3 = program running, 4 = command finished (BASTERM beeps), 1 and 2 = stopped states (*inferred*) | None |
| 0x0A | `jJ*` 0A | Saturn | Open for read; file name in the string packet that follows | Handle frame 0x14 + n, or 0x17 not found, 0x18 access denied, 0x03 other |
| 0x0B | `kK+` 0B | Saturn | Open for write (create or truncate) | Same as 0x0A |
| 0x0C | `lL,` 0C | Saturn | Open existing for read and write | Same as 0x0A |
| 0x0D | `mM-` 0D | Saturn | Close the current file | ACK, or NAK |
| 0x0E | `nN.` 0E | Saturn | Seek; string packet holds an absolute offset in hex | ACK, or NAK |
| 0x0F | `oO/` 0F | Saturn | Delete file named in a string packet | ACK, or 0x17 / 0x18 / 0x03 |
| 0x10 | `pP0` 10 | Saturn | Size of the current file | String packet, size in hex |
| 0x11 | `qQ1` 11 | Saturn | Directory search, first match; pattern in a string packet | String packet with a file name |
| 0x12 | `rR2` 12 | Saturn | Directory search, next match | String packet with a file name |
| 0x13 | `sS3` 13 | Saturn | End directory search | Reply not traced |
| 0x14 to 0x16 | `tT4` 14 … `vV6` 16 | Both | Handle 0, 1 or 2. From the Saturn: make it current. From the PC: reply to an open | Echoes the handle frame |
| 0x17 | `wW7` 17 | PC | Error: file not found | — |
| 0x18 | `xX8` 18 | PC | Error: access denied | — |
| 0x19 | `yY9` 19 | Both | String packet follows (16 bytes) | ACK or NAK |
| 0x1A, 0x1B | `zZ:` 1A, `{[;` 1B | Saturn | Disk space of the current directory (two variants, likely free and total) | String packet, bytes in hex |

File names are trimmed of trailing spaces and a trailing dot before use. Paths resolve against BASTERM's "current directory" setting, so a modern server should confine them to one folder.

## Link setup and timeouts

The link comes up on a NUL-byte handshake and drops back to it on silence or a run of NULs. This is read from BASTERM's receive state machine (`0x4094A0`, `0x4091C0`); the exact Saturn side is not visible in these files.

- **Probing.** While not linked, BASTERM sends one `0x00` byte every 50 ms.
- **Link up.** When the Saturn answers with `0x00`, BASTERM skips any further NULs, sends frame 0x01 (`61 41 21 01`) and treats the link as up.
- **Link lost.** Eight `0x00` bytes in a row while linked, or 2 s of silence with a part-frame in the buffer, reset the link to probing.
- **Per-step timeouts.** 1 s for an ACK, data block or string packet; 500 ms between command polls; 5 s for STOP to be acknowledged.
- **Receive buffer.** A 300-byte ring; overflow forces a link reset.

## Keystroke codes

A keystroke is a pair (modifier, key), sent as the two packets from the wire-format section. Printable text uses modifier 0 and the character code. Special keys put the same code in both bytes, and most codes match PS/2 scan-code set 2, which may tie in with the Saturn keyboard work in this project. Table from BASTERM's key-send dialog (`0x40C550`).

| PC key | Modifier, key (hex) |
| --- | --- |
| Printable character, Tab, Enter, Space | 00, ASCII (09, 0D, 20) |
| Ctrl+A to Ctrl+Z | 00, 01 to 1A |
| STOP (Stop menu) | 04, 03 |
| STOP (before LOAD and SAVE) | 05, 03 |
| Line-reset key sent before typed commands | 00, 0A |
| Shift pressed / released | 59, 59 / 12, 12 |
| Ctrl pressed / released | 18, 18 / 14, 14 |
| Backspace, Esc, Caps Lock, Scroll Lock | 66, 76, 58, 7E (each in both bytes) |
| F1 to F12 | 05, 06, 04, 0C, 03, 0B, 83, 0A, 01, 09, 78, 07 (each in both bytes) |
| Insert, Home, End, PgUp, PgDn, Delete | 81, 87, 88, 8B, 8C, 85 (each in both bytes) |
| Left, Up, Right, Down | 86, 89, 8D, 8A (each in both bytes) |
| Print Screen, Pause | 84, 82 (each in both bytes) |

The Saturn echoes STOP as (03, 04) or (03, 05) and reports Shift state as (12, 12) or (59, 59). Any other pair it sends is a character for BASTERM's terminal pane. BASTERM clears its outgoing key queue when STOP is pressed, so STOP always goes out next.

## BASIC file format and tokenisation

No tokenisation happens on the PC: programs travel as plain text and the Saturn tokenises them as it LOADs. The `.B` samples on the CD are line-numbered ASCII with CRLF line ends, and Japanese text would be Shift-JIS. `Basterm.exe` holds no keyword table.

BASTERM's pre-send processing, all optional, is what a modern tool would reproduce:

- **Line numbers.** Numbers unnumbered lines from a start value in steps, and rounds lines starting with `*` (labels) up to a multiple of a set interval. A line that already has a number resets the counter. Blank lines become `'` comments when numbering, or are dropped otherwise.
- **Checks.** Refuses lines with no number, numbers above 99999, duplicate numbers, or lines that are too long.
- **`#include "FILE.B"`.** A BASTERM-only directive, written without a line number, that pastes another file in place (for example model data from DXFCONV).
- **Diff send.** Sends only changed lines with `LOAD …,M` (merge). Shift+Send forces a full send.
- **Filter.** Runs a DOS program on the text first, for example a structured-BASIC preprocessor.

File names on the Saturn side must be 8.3 names ending in `.B`. The default transfer file is `TBASTERM.B` and the error log is `ERRORLOG.TXT`.

## What a modern replacement needs

A cross-platform replacement is small: a serial port, the frame codec, a file-server loop over one folder, and a keystroke sender. Python with pyserial would do it in a few hundred lines.

1. Open the USB-TTL port at 9600 or 19200, 8N1, no flow control.
2. Run the link handshake: send `0x00` every 50 ms, answer a `0x00` with frame 0x01.
3. Run a receive loop that decodes command frames and serves 0x05, 0x0A to 0x16, 0x19 and 0x1A/0x1B from a project folder, with up to three open handles.
4. To send a program, write it as CRLF text to `TBASTERM.B`, send STOP (05, 03) until a status frame arrives, then type `LOAD "COM:TBASTERM.B",R` and CR as keystroke packets.
5. Optionally add line numbering, `#include`, diff sends and a live keyboard pass-through.

Open questions to check on hardware with a logic analyser:

- [ ] The decompiled code shows the PC probes first and expects `0x00` back. Confirm the Saturn really answers that way.
- [ ] The meaning of status codes 1 and 2 (frames 0x06 and 0x07). BASTERM only ever tests for 3 and 4, so it treats 1 and 2 as plain "not running".
- [ ] Whether STOP modifiers 4 and 5 differ on the Saturn side.
- [ ] How the Saturn reacts to a NAK on a data block (resend or re-request).
- [ ] The `COM:` device syntax beyond `LOAD`/`SAVE`/`OPEN`/`FILES`.

Addresses such as `0x4011C0` are virtual addresses in `Basterm.exe` (image base `0x400000`), for anyone re-checking the disassembly.

The unpacked CD files and Ghidra's decompiled C for `Basterm.exe` are in `BASTERM/` and `DXFCONV/` next to this file.
