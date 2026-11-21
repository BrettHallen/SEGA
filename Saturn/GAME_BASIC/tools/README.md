# saturn_send.py

A cross-platform stand-in for BASTERM's serial link to GAME BASIC for SEGA SATURN, in Python 3 with pyserial. The VS Code extension in [`../vscode-game-basic`](../vscode-game-basic) uses it, and it also works on its own from a terminal.

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
| `serve` | Stays connected and serves `COM:` files from `--serve-dir` |
| `ports` | Lists serial ports |
| `selftest` | Sends and receives a program with the mock Saturn, including a NAK and the Saturn's seek-and-retry |

Common options: `-p/--port` (or `SATURN_PORT`), `-b/--baud 9600|19200` (or `SATURN_BAUD`), `--mock`, `--trace` (hex dump), `-v`, `--key-delay`, and for programs `-n/--auto-number`, `--start`, `--step`, `--label-interval`, `--max-line-bytes`. Exit codes: 0 ok, 1 link error, 2 program errors, 3 usage, 4 sent but the Saturn stopped the LOAD with an error.

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
python3 saturn_bitmap.py SHIP.png --sprite       # -> SHIP_spr.B: SPRITE$ + DATA for 16x16 sprites
```

PNG transparency becomes the Saturn's transparent value (dot 0 in `.0`, word 0 in `.1`). Pictures can be up to 512x256. It prints the `CLEAR` file-buffer size `GLOAD` needs, and warns if the output name isn't one the Saturn can use. `--setchr` cuts a PNG (sides multiples of 8) into 8x8 characters and writes `SETCHR <BG>,<pattern>,<bytes>,READ` with one hex `DATA` line per dot row (Reference Manual pp. 152-154), plus `PALETTE` lines for its colours. `16` (the default) is for the 16-colour text screen (up to 15 colours, palette code 1 unless `--palette` says otherwise); `256` is for a 256-colour character screen. Options: `--bg` (default 4), `--first` pattern, `--no-palette`, and `--start`/`--step` for line numbers (without them, `#include` the file or send with automatic numbering). `--sprite` cuts a PNG (sides multiples of 16) into 16x16 sprite patterns and writes `SPRITE$(<pattern>)=READHEX$(256)` with one hex `DATA` line per dot row (one byte per dot in row order, as `G_BOMB.B` builds its sprites; Reference Manual pp. 161, 177), plus `PALETTE 10` lines for up to 255 colours. `--first` sets the first pattern (0-255), `--palette 1` uses sprite palette 1 (entries 257-511, for `SETSPRITE n,1`); `--no-palette` and `--start`/`--step` work as for `--setchr`. The CD's `SABA_BG.0`, `HIBIKI_0.0`, `TEKST.1` and `TEKEND.1` convert to PNG and back byte for byte.

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

## The GAME BASIC CD: extractor and disassembler

Two standard-library scripts read the GAME BASIC CD. Their output is copyrighted (C)1998 ASCII Corp./Bits Laboratory/ESP inc. material, so it goes into `GAME_BASIC_CD`, and the repository's `.gitignore` keeps it out.

```
python3 gbcd_extract.py ../GAME_BASIC_CD/GAME_BASIC.iso --out ../GAME_BASIC_CD/extracted
python3 gbcd_disasm.py  ../GAME_BASIC_CD/GAME_BASIC.iso -o ../GAME_BASIC_CD/GAME_BASIC_main.s
```

| File | Contents |
|---|---|
| `gbcd_extract.py` | Prints the IP.BIN header, extracts the files, unpacks the interpreter (`0`) to `main.bin` and writes `tokens.tsv` |
| `gbcd_disasm.py` | Writes a commented SH-2 listing of the interpreter. Takes the ISO or `main.bin`. The same input always gives the same listing |
| `gbcd_symbols.txt` | Our names and comments for routines, variables and tables. Edit it and re-run `gbcd_disasm.py` to add your own |
| `sh2.py` | The SH-2 instruction decoder `gbcd_disasm.py` uses |

The listing finds code by following control flow from the entry point, the keyword token table, every call and `switch` jump table, so literal pools, strings and tables print as data. Labels come from `gbcd_symbols.txt`, then from the token table (`stmt_PRINT`, `fn_ABS`), then `sub_`/`loc_`/`str_`/`dat_` by use. Each PC-relative load shows the value it loads and what that points at. The token table, the `@` sub-keyword table and the error message table print decoded.

## What the Saturn's own code shows

The sender and the mock follow both sides of the protocol: `Basterm.exe` for the PC side and the interpreter on the GAME BASIC CD ([`GAME_BASIC_CD/README.md`](../GAME_BASIC_CD/README.md)) for the Saturn side. The Saturn's code settles how the real Saturn behaves:

1. **Handshake.** The Saturn sends four `0x00` bytes, then one every 50 ms, and waits 3 s for frame `0x01`. The sender's probe-and-answer matches this.
2. **Status after STOP.** STOP makes the Saturn send `0x06` (idle at the prompt), so waiting for any status frame is correct.
3. **Status after the transfer.** Every typed command starts with `0x08` (`STATUS_RUNNING`) and ends with `0x06` (`STATUS_IDLE`), or `0x09` (`STATUS_ERROR`) when it stops with an error. The sender reports a `0x09` after a LOAD as a failed send (exit code 4). With `,R` the program starts straight away and no end status follows, so after 3 s the sender reports the program as running.
4. **Screen text.** The Saturn never sends its screen text over the link, so on real hardware the `Line N` count and the screen echo printed by `serve` stay empty; the status frames are its only report. The mock behaves the same way by default; tests that check the PC's text handling turn its echo on.
5. **NAK on a data block.** The Saturn recovers by itself: it sends a seek (`0x0E`) to the position it expects and then asks for the block again, up to 6 times for reads and 4 for writes. The sender's rewind and a seek-following server both work.
6. **Receive.** `SAVE "COM:..."` is open-for-write, data blocks, close, as handled. The text is in `LIST` format, so line numbers have leading spaces.
7. **Line length.** The Saturn's editor and its error 15 *String too long* set the limit at 255 characters per line, which is what the sender checks.
8. **Japanese text.** The Saturn's character set is single-byte (Reference Manual p. 411), so typing Shift-JIS with `type` arrives as two graphic characters per kanji. Put Japanese text in the program file for `KPRINT` instead.
9. **Faster speeds.** After the undocumented `OPTION HD352` (28 MHz mode) the Saturn also offers 14400, 28800, 38400, 57600 and 115200 baud. These are untested on hardware, and `-b` accepts only 9600 and 19200.

Two things depend on the hardware rather than the code: how fast a given USB-TTL adapter runs reliably, and whether one keystroke packet every 30 ms is slow enough on a busy Saturn (raise `--key-delay` if characters go missing). The adapter must be 5 V TTL, with TX to Saturn RX, RX to Saturn TX and GND to GND.

## Details checked in the decompiled code

These come from `Basterm.exe`, and the sender follows them:

- String packet filler after the NUL is `'0' + i % 9`, CRC over all 14 bytes (`FUN_00404660`). The Saturn uses the same filler.
- An incoming string packet is ACKed or NAKed first, and only then answered (handle frame, error, and so on).
- Sizes and offsets in string packets are lowercase hex (`%lx` at `0x466418`).
- A successful open makes the new handle the current one. Errors: not found `0x17`, access denied `0x18`, other `0x03`, and `0x03` when all three handles are in use.
- The data block's padding is whatever was in BASTERM's stack buffer; the sum and CRC cover all 252 bytes, so the padding value doesn't matter. The sender pads with zeros.
- BASTERM's own pre-send messages give the limits: no line number, above 99999, line too long, duplicate number.
