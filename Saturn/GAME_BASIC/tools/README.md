# saturn_send.py

A cross-platform stand-in for BASTERM's serial link to GAME BASIC for SEGASATURN, in Python 3 with pyserial. The VS Code extension in [`../vscode-game-basic`](../vscode-game-basic) uses it, and it also works on its own from a terminal.

```
python3 -m pip install pyserial
python3 saturn_send.py selftest                        # no hardware needed
python3 saturn_send.py ports
python3 saturn_send.py send GAME.B -p /dev/cu.usbserial-1410 --run
python3 saturn_send.py send GAME.B --mock --run        # pretend Saturn
```

| Command | What it does |
|---|---|
| `check FILE` | Runs BASTERM's pre-send checks without sending |
| `build FILE [-o OUT]` | Writes the exact text that would be sent (after `#include` and numbering) |
| `send FILE [--run] [--merge] [--serve]` | Types `LOAD "COM:TBASTERM.B"` (with `,R` / `,M`) and serves the program. `--serve` stays connected afterwards |
| `run` / `stop` | STOP, then `RUN`; or just STOP |
| `receive -o FILE` | Types `SAVE "COM:TBASTERM.B"` and saves what the Saturn sends |
| `type TEXT` | Types text at the Saturn, then Enter |
| `serve` | Stays connected, serves `COM:` files from `--serve-dir`, and prints the Saturn's screen echo |
| `ports` | Lists serial ports |
| `selftest` | Sends and receives a program with the mock Saturn, including a NAK and resend |

Common options: `-p/--port` (or `SATURN_PORT`), `-b/--baud 9600|19200` (or `SATURN_BAUD`), `--mock`, `--trace` (hex dump), `-v`, `--key-delay`, and for programs `-n/--auto-number`, `--start`, `--step`, `--label-interval`, `--max-line-bytes`. Exit codes: 0 ok, 1 link error, 2 program errors, 3 usage, 4 sent but the Saturn printed an error (such as `Syntax error`). After a send, `send` reports the Saturn's `Line N` message and any error lines it printed.

`serve` and `send --serve` list only names the Saturn can use (1-8 of A-Z, 0-9 and `_`, then `.B`, `.0`, `.1` or `.D`; Reference Manual pp. 96-97), so `FILES "COM:"` doesn't show files it couldn't load.

`TBASTERM.B` is kept in memory, so nothing is written to your folder on a send. Other `COM:` names the program opens are served from one folder only (`--serve-dir`, by default the program's folder), matched without regard to case, and paths that try to leave that folder are refused.

## saturn_bitmap.py

Converts between PNG and the Saturn's bitmap files for `GLOAD`/`GSAVE` (Reference Manual pp. 105-106). Plain Python 3, no packages needed.

```
python3 saturn_bitmap.py PICTURE.png            # -> PICTURE.1 (32768 colours)
python3 saturn_bitmap.py PICTURE.png --256      # -> PICTURE.0 (256 colours; more are reduced)
python3 saturn_bitmap.py TEKST.1                # -> TEKST.png
python3 saturn_bitmap.py FONT.png --setchr       # -> FONT_chr.B: SETCHR + DATA for 8x8 characters
python3 saturn_bitmap.py TILES.png --setchr 256 --first 64 --start 9000
```

PNG transparency becomes the Saturn's transparent value (dot 0 in `.0`, word 0 in `.1`). Pictures can be up to 512x256. It prints the `CLEAR` file-buffer size `GLOAD` needs, and warns if the output name isn't one the Saturn can use. `--setchr` cuts a PNG (sides multiples of 8) into 8x8 characters and writes `SETCHR <BG>,<pattern>,<bytes>,READ` with one hex `DATA` line per dot row (Reference Manual pp. 152-154), plus `PALETTE` lines for its colours. `16` (the default) is for the 16-colour text screen (up to 15 colours, palette code 1 unless `--palette` says otherwise); `256` is for a 256-colour character screen. Options: `--bg` (default 4), `--first` pattern, `--no-palette`, and `--start`/`--step` for line numbers (without them, `#include` the file or send with automatic numbering). The CD's `SABA_BG.0`, `HIBIKI_0.0`, `TEKST.1` and `TEKEND.1` convert to PNG and back byte for byte.

## Layout

| File | Contents |
|---|---|
| `saturn_link/protocol.py` | Frame, keystroke, data block and string packet encoders and decoders, CRC-16/X-25 |
| `saturn_link/reader.py` | Turns the byte stream into events, with BASTERM-style 3-of-4 voting |
| `saturn_link/link.py` | PC side: NUL handshake, file server, STOP, LOAD / SAVE / RUN |
| `saturn_link/mock.py` | A pretend Saturn that speaks the other side of the protocol |
| `saturn_link/preprocess.py` | `#include`, automatic line numbers, BASTERM's checks, Shift-JIS encoding |
| `saturn_bitmap.py` | PNG <-> `.0`/`.1` bitmap converter (separate from the link) |
| `saturn_link/transport.py` | pyserial port, in-process pipe, and a byte-logging tap |
| `tests/` | `python3 -m unittest discover tests`. Includes a run of the real pyserial code over a pseudo-terminal (macOS/Linux) |

## What the mock does and doesn't prove

The mock is written from the same reading of `Basterm.exe` as the sender, so passing tests show the PC side is self-consistent and that the pyserial path works. They can't show the real Saturn behaves the same way. These need checking on hardware, ideally with a logic analyser on TX and RX:

1. **Handshake.** Does the Saturn answer the PC's `0x00` probe with `0x00`, and is it happy with frame `0x01` after it?
2. **Status after STOP.** The sender waits up to 5 s for any status frame (`0x06` to `0x09`) after STOP, as BASTERM does.
3. **Typing speed.** The LOAD command is typed one keystroke packet every 30 ms. If characters go missing, raise `--key-delay`.
4. **File name in the open request.** The sender trims it the way BASTERM does (`"TBASTERM.B"`, `"TEST    .B"` and `"TEST."` all work). Check what the Saturn really sends with `--trace`.
5. **NAK on a data block.** The sender rewinds so the next read request gets the same block again. BASTERM itself doesn't rewind (its `ReadFile` has already moved on), so if the Saturn seeks before re-reading, both work; if it doesn't, only this one does.
6. **Status after the transfer.** The sender waits for a status frame after the close, and gives up waiting after 3 s and reports success, because it isn't known yet which status the Saturn sends there.
7. **Receive.** `SAVE "COM:..."` is handled as open-for-write, data blocks, close. That path is untested on hardware.
8. **Line length.** BASTERM refuses over-long lines, but the limit isn't known; 255 bytes is a guess.
9. **Japanese text.** Programs go as Shift-JIS. Typing Japanese with `type` sends each Shift-JIS byte as a key, which may not be what the Saturn expects.
10. **Wiring.** The adapter must be 5 V TTL. TX to Saturn RX, RX to Saturn TX, GND to GND.

## Details checked in the decompiled code

These go a little beyond `BASTERM/BASTERM_serial_protocol.md`, and the sender follows them:

- String packet filler after the NUL is `'0' + i % 9`, CRC over all 14 bytes (`FUN_00404660`).
- An incoming string packet is ACKed or NAKed first, and only then answered (handle frame, error, and so on).
- Sizes and offsets in string packets are lowercase hex (`%lx` at `0x466418`).
- A successful open makes the new handle the current one. Errors: not found `0x17`, access denied `0x18`, other `0x03`, and `0x03` when all three handles are in use.
- The data block's padding is whatever was in BASTERM's stack buffer; the sum and CRC cover all 252 bytes, so the padding value doesn't matter. The sender pads with zeros.
- BASTERM's own pre-send messages give the limits: no line number, above 99999, line too long, duplicate number.
