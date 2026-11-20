# GAME BASIC for SEGA SATURN: analysis of the Saturn CD

The interpreter on the Saturn CD is one compressed file, `0`, that IP.BIN decrypts and unpacks to 0x0600A000. Unpacked, it contains everything a modern PC tool needs: the keyword token table, the tokenised program format and the Saturn's side of the BASTERM serial protocol. The protocol matches [`BASTERM_serial_protocol.md`](../BASTERM/BASTERM_serial_protocol.md), and the Saturn side settles every point that the PC side alone left unclear. Three findings are new: an undocumented `OPTION HD352` that switches the Saturn to its 28 MHz clock and unlocks **baud rates up to 115200**, a **raw serial mode** that lets `LOAD`, `SAVE`, `FREAD` and `FWRITE` use `COM:` with a plain terminal and no BASTERM, and the full encoding of numbers and line references in tokenised programs.

This is static analysis of the disc image only. Nothing was run on hardware or in an emulator. Addresses are SH-2 addresses in the unpacked image (load address 0x0600A000), so `file offset = address − 0x0600A000`.

## Disc layout

The disc is mixed mode: one Mode 1 data track and one short CD-DA track. `GAME_BASIC.iso` (23,035,904 bytes = 11,248 sectors) is the complete data track.

| Item | Value |
| --- | --- |
| Volume ID | `BASIC` |
| System ID | `SEGA SEGASATURN` |
| Publisher / preparer | `ASCII_CORP` / `BITS_LABORATORY` |
| Copyright, abstract, bibliography files | `CPYRIGHT.TXT`, `ABSTRACT.TXT`, `BIBLIOGR.TXT` (all Shift-JIS) |
| Volume size in the PVD | 12,155 sectors, which counts `WARNNING.PCM` |
| Root directory | 261 entries, no subdirectories |

`WARNNING.PCM` (sic) is not in the image. Its directory entry points at LBA 11405 with a size of 1,536,000 bytes, which is about 8.7 s of CD audio: the file is a pointer into track 2, the usual "don't play this disc in a CD player" warning. Every other file is inside the ISO, and the 260 extracted files match the `FILES.zip` that was copied off the disc on the Mac byte for byte.

`STAFF.TXT` holds the credits. The interpreter's main system was by 金山 素志 (Bits Laboratory), the sound system by 本間 直純 (Bits Laboratory) and BASTERM by Ikkou.Noku.

### What the files are

| Pattern | Count | What it is |
| --- | --- | --- |
| `0` | 1 | The interpreter, encrypted and LZSS-compressed (355,883 bytes; 738,784 unpacked). Loaded first by IP.BIN |
| `*.B` | 67 | Sample programs as **plain text**: line-numbered ASCII, CR+LF, Shift-JIS half-width kana in comments. `LAUNCH.B` is the menu the interpreter boots into |
| `*.D` | 98 | Data for programs: text `DATA`-style number lists (`ENEM01.D`, `TAISO.D`, `INID01.D`), `@name,bank,n` tone lists (`LST1_*.D`), raw binary (`MAZE01.D`, `BGCHR.D`, `PALWIN.D`), AIFF (`*_A.D`) and WAVE (`*_W.D`) samples for `TARG`, and the kanji fonts `FONT161.D`/`FONT162.D` for `KLOAD` |
| `*.WV` + `*.LST` | 29 + 22 | Sound banks (tone data for the SCSP) loaded by `PLAYINIT`/`TLIST`, each with a text listing of its tones. `TLIST.LST` is the index of banks |
| `FM_01.BIN`–`FM_47.BIN` | 47 | FM modulation waveforms, 30,720 bytes each |
| `SDDRVS.TSK` | 1 | Sega's 68000 sound driver, "Ver- 2.08 … Wed Sep 25 1996". Starts with a 68000 vector table (SSP 0xA000, PC 0x1000) |
| `DSP.EXB`, `DSPEXT.EXB` | 2 | SCSP DSP effect programs (`REV2.EXB`, `deley.EXB`, `dist.EXB`, `multi.EXB` inside) |
| `*.0`, `*.1` | 2, 2 | Pictures in `GSAVE` format (below) |
| `WIN_ALL.BIN` | 1 | Graphics for the on-screen software keyboard |

The User Guide (section 18) and RM pp. 407–410 already describe what each sample program does.

## IP.BIN

| Field (offset) | Value | Meaning |
| --- | --- | --- |
| Hardware ID (0x00) | `SEGA SEGASATURN` | |
| Maker (0x10) | `SEGA TP T-21` | Third-party licensee T-21 (ASCII) |
| Product (0x20), version (0x2A) | `T-2111G`, `V1.002` | |
| Release date (0x30) | `19980416` | |
| Device (0x38) | `CD-1/1` | |
| Area codes (0x40) | `J` | Japan only. Area symbol at 0xE00 is `For JAPAN.` |
| Peripherals (0x50) | `AEFGJKMSTZ` | Includes J (pad), K (keyboard), M (mouse), F (floppy drive) |
| Title (0x60) | `GAME BASIC for SEGASATURN` | |
| IP size (0xE0) | 0x1060 | Standard security code (0x100–0xE00), area symbol (0xE00), then a 0x240-byte AIP |
| Stacks (0xE8, 0xEC) | 0, 0 | BIOS defaults |
| 1st read address (0xF0) | **0x06080000** | Not the usual 0x06004000: `0` is loaded high and unpacked downwards |

`GAME_BASIC_EUR.iso` differs from the original in 8 bytes only: area code `J` → `E` and `For JAPAN. ` → `For EUROPE.`. That is the SRP region patch and nothing else.

## Boot chain

The application initial program (AIP, at 0x06002E20) is a small loader that does three things:

1. Copies a stub into the BIOS area and resets the CD block (0x25890008).
2. Clears 0x440 bytes at 0x060FF000 and unpacks `0` from 0x06080000 to **0x0600A000** (routine at 0x06002F40).
3. Jumps to 0x0600A000.

The unpacking is a stream cipher plus LZSS. `tools/gbcd_extract.py` reimplements it, and its output uses up exactly all 355,883 input bytes.

- **Header.** The first 4 bytes are the unpacked size, little-endian (0x000B45E0). The low byte of the size, sign-extended, is the key `k`.
- **Cipher.** The state starts at `k × 0xAD65`. For each input byte: `state = state × 0x792D3 + 0x6C1CF` (32-bit), output `(byte − (state >> 16) × k) & 0xFF`.
- **LZSS.** A 1 KB ring buffer starts at position 0x3BE. A flag byte supplies 8 bits, LSB first, and 1 means a literal. A match is two bytes: offset = `b1 + ((b2 & 0xC0) << 2)`, length = `(b2 & 0x3F) + 3`.

## The interpreter image

The unpacked image is 738,784 bytes of big-endian SH-2 code and data at 0x0600A000–0x060BE5E0. At 0x0600A040 the start-up code sets the stack to 0x060BE5D0, clears 0x060B9EF0–0x060BE5CC and calls the main initialisation at 0x0600E578.

It was built with a GNU-style C library (newlib `vfprintf` and math error strings) and these Sega libraries:

- `DGFS_SGL Version 2.12 1996-12-04`: Sega Graphics Library 2.12. Its `slInitSystem` is at 0x06062D30.
- `BUP Version 1.21 1996-08-06`: the backup-RAM library behind `BRAM:` and `CRAM:`.
- `SDDRVS.TSK`: Sega's sound driver 2.08, loaded into sound RAM. It sits under Bits Laboratory's own MML layer (`Bits Laboratory BASIC for SEGA SATURN : Sound Program`).

### Memory map

| Range | Use |
| --- | --- |
| 0x06000000–0x06002000 | BIOS work area. The SCI vectors are installed through `SYS_SETSINT` (0x06000310). 0x06000324 is the BIOS clock flag (0 = 26 MHz, 1 = 28 MHz) |
| 0x06002000–0x06003060 | IP.BIN, including the AIP loader |
| 0x0600A000–about 0x0604A000 | Interpreter code: serial driver and link protocol (0x0600A080–0x0600D7EF), error messages (0x0600D7F4), editor and LIST (0x0600F000–), statements and functions, keyword name strings (0x0602DBE4–0x0602E4CF), settings screen (0x06033500), file devices (0x06038000–), sound and MML (0x0603C000–0x06046000) |
| about 0x0604A000–0x06075000 | Library code: BUP (0x0604A7E0), C library (0x0604CFD0), SGL (0x0605C7BF) |
| 0x06075C10–0x06075C1F | Saved settings block (written to `GBASICSS_01`): screen mode flag 0x06075C19, baud index 0x06075C1A (26 MHz list) and 0x06075C1B (28 MHz list) |
| 0x060759E0–0x060761F0 | Serial driver and link state: link flag 0x06075A34, receive ring 0x06075CBC (512 bytes), transmit ring 0x06075EC8 (512 bytes), key queue 0x06075C38 (64 entries) |
| 0x06085070 | Pointer to the start of the BASIC program |
| 0x0609CBE0–0x0609DDDF | Token descriptor table (below) |
| 0x0609DEE0–0x0609E21F | `@` sub-keyword table (OBJ fields, PAD bits, sound parameters) |
| 0x060A4E65 | Boot command `LOAD"CD:LAUNCH",R`. Also `AUTORUN.B`, and `GBASICSS_` as the prefix for backup-RAM save names |
| 0x060BE230–0x060BE5CF | CRC-16 table (0x060BE240), link receive ring (0x060BE450, 300 bytes) |
| 0x060FF000, 0x060FFC00 | Unpacker ring buffer at boot, then the GBR base |
| 0x00200000–0x002FFFFF (Low Work RAM) | **BASIC program text starts at 0x00210000.** `NEW` resets the start and end pointers to that address. The rest of LWRAM holds other buffers, whose limits weren't traced |

On a soft reset the interpreter checksums the program area (0x06035858) and keeps the program if the checksum still matches. That is the `HOT START` message.

## Serial link: the Saturn's side

The link uses the SH-2's on-chip SCI, the serial port that the communication cable connects to. The init routine is at 0x0600A44C.

- **Format.** SMR = 0: asynchronous, 8 data bits, no parity, 1 stop bit, Pφ/1. Receive, receive-error and transmit interrupts are on vectors 0x60, 0x62 and 0x63 (handlers 0x0600A144, 0x0600A26C, 0x0600A298) at priority 15. Both directions go through 512-byte ring buffers.
- **Baud rate.** The BRR value comes from the settings screen's index (0x06075C1A or 0x06075C1B) and one of two tables chosen by the BIOS clock flag. The screen shows `table × 4800` as `%-7dBPS`.

| CPU clock (0x06000324) | Rates on the settings screen | BRR values |
| --- | --- | --- |
| 26.8 MHz (0) | 9600, 19200 | 0x15, 0x0A |
| 28.6 MHz (non-zero) | 9600, 14400, 28800, 38400, 57600, **115200** | 0x16, 0x0E, 0x07, 0x05, 0x03, 0x01 |

The manuals and BASTERM know only 9600 and 19200, which is the 26 MHz table. The BRR values check out against a peripheral clock of CPU/4 to within about 1%.

The 28 MHz clock comes from the screen mode. At start-up (0x0602F97C) the interpreter loads its settings from `GBASICSS_01` and calls SGL `slInitSystem` with TV mode 0 (320 × 224, 26.8 MHz) when the mode flag at 0x06075C19 is 0, or mode 4 (352 × 224, 28.6 MHz) when it is 1. SGL switches the CPU clock with the BIOS call `SYS_CHGSYSCK`, which sets the clock flag at 0x06000324, and the settings screen then shows the six-rate list.

The flag is set only by an undocumented form of `OPTION` (statement handler 0x06016A5C). `OPTION` reads the next word and compares it, through the same cipher as the boot loader, with hidden names:

| Statement | Effect |
| --- | --- |
| `OPTION HD352` | Sets the flag to 1, saves the settings and restarts the interpreter in 352-wide mode at 28.6 MHz. The baud list on the settings screen becomes 9600–115200 |
| `OPTION HD320` | Sets the flag to 0, saves and restarts in the normal 320-wide mode at 26.8 MHz |
| `OPTION COM` | Re-initialises the serial port and drops the BASTERM link (0x0602F910), returning the port to raw mode |
| `OPTION VERSION` | Prints a hidden "PROGRAM DESIGN" credit list (BASTERM Ikkou.Noku, polygon font Satoru.Miyazaki, sound system Naozumi.Honma, other programs Motoyuki.Kanayama) |

Any other word gives *Syntax error*. Because the mode is saved, the 28 MHz setting survives a power cycle until `OPTION HD320` is run. The screen is 32 pixels wider in this mode, so programs written for 320 pixels may sit off-centre.

### Two receive modes

The receive interrupt behaves differently depending on whether BASTERM's link is up.

- **Raw mode (no link).** Received bytes go into the 512-byte receive ring as plain characters. 0x03 (Ctrl+C) sets the break flag. 0x13 (Ctrl+S) toggles a pause flag. When the ring holds more than 255 bytes the Saturn sends XOFF (0x13), and when it falls to 63 or fewer it sends XON (0x11). **Four 0x00 bytes in a row switch the port into link mode.**
- **Link mode.** Each byte goes to the frame parser (0x0600D2B8), which uses a 300-byte ring like BASTERM's.

### Raw mode from BASIC

Raw mode is usable on its own. The keyboard routine (0x0602FED8) takes characters from the serial receive ring before the keyboard queue, so a plain terminal at the Saturn's baud rate, 8N1, can type at the `Ready.` prompt with no BASTERM at all. Every `COM:` statement checks the link flag (0x06075A34) and picks a path:

| Statement | With the BASTERM link | Without the link (raw) |
| --- | --- | --- |
| `SAVE "COM:name"` | File-server write (0x06037CD0) | Sends plain text: CR LF, `LOAD "COM:name"`, CR LF, the program as `LIST` prints it, then `'LOAD END` CR LF (0x06037FBC) |
| `LOAD "COM:name"` | File-server read (0x06037B44) | Reads text lines from the port, ending each at CR or LF and turning tabs into spaces, and tokenises them (0x06037DBC) |
| `FWRITE` to a `COM:` file | Data blocks | The bytes go out unchanged (0x06036EB4) |
| `FREAD` from a `COM:` file | Data blocks | Bytes are taken from the receive ring (0x06030028) |
| `KILL`, `BSAVE`, `GSAVE` on `COM:` | File-server commands | Error 61 *Bad file mode* |

The raw `SAVE` output is itself a valid input for a raw `LOAD`, so two Saturns linked by a crossed cable can pass a program across, and a terminal program can capture or replay one. XON/XOFF from the Saturn protects its receive ring, so a sender should honour XOFF. Text that BASIC prints to the screen is never sent on the port in either mode.

### Handshake

When the Saturn needs the PC, for example on the first `COM:` access, it runs 0x0600C840. That routine sends **four 0x00 bytes**, then one 0x00 every 50 ms, skips any 0x00s that come back, and waits up to **3 s** for command frame 0x01 (`61 41 21 01`). If nothing arrives, the link is marked down and the operation fails with *Communication error*. BASTERM's side as already documented fits this: it probes with 0x00 every 50 ms and answers a 0x00 with frame 0x01.

### Frames

Encoder and decoder agree with the BASTERM analysis:

- **Command frame.** `0x60|n, 0x40|n, 0x20|n, n`, built at 0x0600BEB0.
- **CRC.** The table at 0x060BE240 is built from reflected polynomial 0x8408 with initial value 0xFFFF, and the result is inverted (0x0600C3D0).
- **String packet** (0x0600B810). The Saturn refuses strings longer than 12 characters. It sends `79 59 39 19`, then the CRC (high byte first) over the 14-byte text field, then the text field. **The filler after the NUL is `'0' + (i mod 9)`** for byte positions i = len+1 … 13, so it is predictable but not zero. A PC replacement can ignore it but must include it in the CRC.
- **Timeouts.** 1 s for an ACK or NAK after a string or data block. Timing uses the VBlank counter (0x060760D4).

Command codes the Saturn sends, found by tracing every call to the encoder:

| Code | Sent by | Use |
| --- | --- | --- |
| 0x02, 0x03 | receive path | ACK, NAK for blocks and strings |
| 0x05 | 0x0600C708 | Read next block |
| 0x0A, 0x0B, 0x0C | 0x0600ADC0 | Open for read, write, read/write |
| 0x0D | 0x0600A7C0 | Close |
| 0x0E | 0x0600B468, 0x0600C708 | Seek (hex offset in a string packet) |
| 0x0F | 0x0600A8A0 | Delete |
| 0x10 | 0x0600B714 | File size |
| 0x11, 0x12, 0x13 | 0x0600ABB0, 0x0600AC4C, 0x0600AC98 | Directory search: first, next, end. The Saturn sends 0x13 and does not wait for a reply |
| 0x14 + n | 0x0600ACE4 | Make handle n current |
| 0x1A, 0x1B | 0x0600AA24, 0x0600AAC8 | Free and total space. The reply is a string packet holding a hex number, read with `%lx` |
| 0x06–0x09 | interpreter, not the driver | Status (below) |

### Space reports

`FILES "COM:"` lists the directory with 0x11/0x12/0x13, then sends 0x1A and 0x1B and prints `Free size <0x1A> / <0x1B> blocks`. `DSKF("COM:")` sends only 0x1A and returns the value unchanged, as an unsigned 32-bit number. The Saturn applies no unit, so the PC chooses one. For backup RAM `DSKF` returns the free size divided by 64, so a server that answers in 64-byte blocks matches what programs expect from `BRAM:`.

### Retries and timeouts

The Saturn drives every retry; the PC only answers.

- **Receiving a block or string.** 0x0600C418 checks the 8-bit sum and the CRC and answers ACK (0x02) or NAK (0x03).
- **Reading a file** (0x0600C708). After a NAK or a bad block the Saturn re-sends seek 0x0E with the handle's current position, waits for ACK, and sends 0x05 again, up to 6 attempts. If nothing arrives within 1 s it re-runs the handshake, sets error bit 0x10 in the link status word (0x06075A68) and fails with *Communication error*.
- **Writing a file** (0x0600B468). Each block is sent by 0x0600C588, which returns success only on ACK. On NAK or timeout the Saturn re-links if needed, seeks to the block's offset (0x0E plus a string packet, then ACK) and sends the block again, up to 4 attempts.

A PC server therefore never resends on its own. It must honour a seek at any time and serve the next 0x05 from the new position.

File handles live at 0x060BDF00 + n × 0x110 for n = 0, 1, 2, with the current position at +0x104.

### Status frames

The status frames are sent only while the link is up. Where each one is sent shows what it means:

| Frame | BASTERM's name | Sent when |
| --- | --- | --- |
| 0x06 | status 1 | The screen editor gets the STOP key (internal codes 0xF4 or 0xF5) at the prompt, so it means "idle at the prompt". It also ends a command that completed normally (0x0600E3F2) |
| 0x07 | status 2 | A direct command or program ended through break or STOP (0x0600E3FA, and the break handler at 0x06013B5E) |
| 0x08 | status 3 | Just before a direct command or `RUN` starts executing (0x0600E3D6): "running" |
| 0x09 | status 4 | From the error printer (0x0600E0C4), before `Line n: message` is shown: **an error** |

So BASTERM's beep on status 4 is an error beep. For a modern tool, a finished `LOAD` shows up as 0x08 followed by 0x06 (OK) or 0x09 (error). Waiting for "any status after 0x08" is more robust than waiting for status 4.

### STOP modifiers and keystrokes

Keystroke packets from the PC go to the key handler 0x0600BC54, then into the 64-entry key queue as (modifier << 8 | key), as if typed on the Saturn keyboard (0x0600A520).

- **STOP.** Key 0x03 with modifier 4 or 5 sets the STOP flag (0x06075A10) and queues internal code 0xF4 or 0xF5. The receive interrupt sees the flag and raises a break, so both stop a running program in the same way.
- **The difference.** At the prompt (0x06034F4E), code 0xF5 also calls 0x0601E520, the reset of the graphics and sprite work area that `LOAD`, `SAVE`, `BLOAD`, `BSAVE`, `GLOAD` and `GSAVE` all do before a transfer. Both then send status 0x06. So modifier 4 is a plain STOP and modifier 5 is "STOP and get ready for a file transfer", which is why BASTERM sends 5 before `LOAD` and `SAVE`.
- **Shift and Ctrl.** The pairs (59, 59) and (12, 12) set and clear Shift, and (18, 18) and (14, 14) set and clear Ctrl, in the modifier state at 0x06075A11.
- **Pause.** Key 0x13 toggles the pause flag, except when it arrives as part of the Left (0x86) or Pause (0x82) codes.

The Saturn never sends keystroke packets: no routine in the image builds the `0x80|h …` form. BASTERM's code for showing received characters in its terminal pane is never used by this interpreter.

## Tokenised program format

Programs travel as text, and LOAD tokenises them on the Saturn. In memory, starting at 0x00210000, each line is:

| Bytes | Field |
| --- | --- |
| 2 | Offset to the next line, little-endian. 0 marks the end of the program |
| 3 | Line number, little-endian (1–99999) |
| n | Tokens |
| 1 | 0x00 end of line |

Token bytes, from the LIST routine (0x0600FD7C):

| Byte | Meaning |
| --- | --- |
| 0x01–0xD8 | Keyword with this index in the descriptor table. `IF` (0x1F) and `ELSE` (0x14) are followed by 3 bytes, a skip offset to the matching branch |
| 0x09 n | n spaces (indentation is kept) |
| `,` `:` `;` `#` `@` `~` 0x0A | Stored as themselves. The table has holes at those values |
| 0xD9 len text | `DATA` with its text kept raw |
| 0xDA k len text | Comment: k = 1 is `REM`, anything else is `'` |
| 0xDB f addr len name | Variable, 7 + len bytes. Flag bits in f: 4 = `$`, 2 = `#`, 8 = array `(`. `addr` is a 4-byte little-endian slot that the interpreter fills in when the variable is first used, so `LIST` ignores it |
| 0xDC len text | String literal |
| 0xDD f n n n [name] | Line reference after `GOTO`, `GOSUB`, `RESTORE` and similar. f = 0: n is a 3-byte line number. f = 0x40: n is a 3-byte relative link to the target line, filled in at run time (`LIST` prints that line's number). f = 0x80 + len: a label, printed as `*` and the len-byte name that follows |
| 0xDE, 0xDF, 0xE0 + 4 bytes | Number as a 32-bit little-endian fixed-point value, printed as binary `&B`, hex `&H` or decimal |
| 0xE1, 0xE2, 0xE3 + 1 byte | Small integer 0–255 in the same three styles |
| 0xE4 + 8 bytes | Double-precision constant, printed with a `#` suffix |
| 0xE5 n | `@` sub-keyword n from the table at 0x0609DEE0, as in `TPROP(0,0,@TONE)` or `@AR` |
| 0xE8 n | Extended keyword 0x100 + n (`OBJPOS` … `OBJZOOM`) |
| 0xE9–0xFF | Operators: `AND NOT OR XOR AND! NOT! OR! XOR! MOD \ ^ * + - / < <= <> = > >= ( )` |

Numbers are fixed point with 14 fraction bits (18.14): the value is the 32-bit word divided by 16384, and the print routine (0x0602CCD0) shows up to four decimal places. The one-byte forms store n and stand for n × 16384.

Each descriptor is 16 bytes: statement handler, function handler, name pointer and a flags word. The flags group the keywords:

| Flags | Kind |
| --- | --- |
| 0x0018 | Ordinary statement |
| 0x0010 | Flow statement (`GOTO`, `GOSUB`, `READ`, `RESTORE`, `RETURN`, `STOP`, `INTERVAL`, `TIMER`, `SETSONG`, `DATA`) |
| 0x0008 | Direct mode only (`EDIT`, `LIST`, `RENUM`, `DELETE`, `NEW`, `SAVE`, `CONT`, `FIND`, `FORMAT`), which matches error 28 *Direct statement only* |
| 0x02xx | Function. 0x0241 is numeric with one argument, 0x0242 numeric, 0x0220 string |
| 0x0020 | String system value with no arguments (`DATE$`, `INKEY$`) |
| 0x025A, 0x0238, 0x0252, 0x0218 | Usable as both statement and function (`OBJ`, `PALETTE`, `TPROP`, `MID$`, `USERDATA`, `SPRITE$`) |
| 0x0042 | System value with no arguments (`ERL`, `ERR`, `VERSION`, `SHIFT`) |
| 0x0080 / 0x0100 | Logical / arithmetic and comparison operators |

The 226 named tokens. Bytes 0xE9–0xFF are the operators; `E8 nn` is the two-byte form for the extended keywords.

| Token | Keyword | Kind |
|---|---|---|
| `01` | `ABS` | Numeric function, one argument |
| `02` | `ACTIVE` | Statement |
| `03` | `ASC` | Numeric function |
| `04` | `ATN` | Numeric function, one argument |
| `05` | `BINHEX$` | String function |
| `06` | `BIN$` | String function |
| `07` | `COPY` | Statement |
| `08` | `CAMERA` | Statement |
| `0B` | `CINT` | Numeric function |
| `0C` | `CIRCLE` | Statement |
| `0D` | `CLEAR` | Statement |
| `0E` | `COLOR` | Statement |
| `0F` | `COS` | Numeric function, one argument |
| `10` | `DATE$` | String system value |
| `11` | `BITW$` | String function |
| `12` | `DIM` | Statement |
| `13` | `DISPLAY` | Statement |
| `14` | `ELSE` | Statement |
| `15` | `ERROR` | Statement |
| `16` | `EXP` | Numeric function, one argument |
| `17` | `FIX` | Numeric function |
| `18` | `FOR` | Statement |
| `19` | `FRAC` | Numeric function |
| `1A` | `GCOPY` | Statement |
| `1B` | `GOSUB` | Statement (flow) |
| `1C` | `GOTO` | Statement (flow) |
| `1D` | `HEXBIN$` | String function |
| `1E` | `HEX$` | String function |
| `1F` | `IF` | Statement |
| `20` | `INKEY$` | String system value |
| `21` | `INPUT` | Statement |
| `22` | `INPUT$` | String function |
| `24` | `INT` | Numeric function |
| `25` | `INTERVAL` | Statement (flow) |
| `26` | `LEFT$` | String function |
| `27` | `LEN` | Numeric function |
| `28` | `LINE` | Statement |
| `29` | `LOCATE` | Statement |
| `2A` | `LOG` | Numeric function, one argument |
| `2B` | `MID$` | Statement and string function |
| `2D` | `OBJ` | Statement and function |
| `2F` | `ON` | Statement |
| `30` | `OPEN` | Statement |
| `31` | `PAD` | Numeric function |
| `32` | `PAINT` | Statement |
| `33` | `PALETTE` | Statement and function |
| `34` | `PEEK$` | String function |
| `35` | `POINT` | Numeric function |
| `36` | `POKE` | Statement |
| `37` | `POS` | Numeric function |
| `38` | `PRINT` | Statement |
| `39` | `PRIORITY` | Statement |
| `3C` | `PUTCHR` | Statement |
| `3D` | `READ` | Statement (flow) |
| `3E` | `READCHR$` | String function |
| `3F` | `RESTORE` | Statement (flow) |
| `41` | `RGB` | Numeric function |
| `42` | `RIGHT$` | String function |
| `43` | `RND` | Numeric function |
| `44` | `SCROLL` | Statement |
| `45` | `SETATR` | Statement |
| `46` | `SETCHR` | Statement |
| `47` | `SETDISP` | Statement |
| `48` | `SETLIGHT` | Statement |
| `49` | `SETPERS` | Statement |
| `4A` | `SETPOLYGON` | Statement |
| `4B` | `SETTEX` | Statement |
| `4C` | `SETVERTEX` | Statement |
| `4D` | `SGN` | Numeric function |
| `4E` | `SIN` | Numeric function, one argument |
| `4F` | `SPACE$` | String function |
| `50` | `SQR` | Numeric function, one argument |
| `51` | `STEP` | Statement |
| `52` | `STRING$` | String function |
| `53` | `STRW$` | String function |
| `54` | `STR$` | String function |
| `55` | `SWAP` | Statement |
| `56` | `TAN` | Numeric function, one argument |
| `57` | `THEN` | Statement |
| `58` | `TIMER` | Statement (flow) |
| `59` | `TO` | Statement |
| `5A` | `USING` | Statement |
| `5B` | `VAL` | Numeric function, one argument |
| `5C` | `VSYNC` | Statement |
| `5D` | `WADD$` | String function |
| `5E` | `WANDOR$` | String function |
| `5F` | `WIDTH` | Statement |
| `60` | `WINDOW` | Statement |
| `61` | `WMUL$` | String function |
| `62` | `KPRINT` | Statement |
| `63` | `WXOR$` | String function |
| `64` | `XATN` | Numeric function |
| `65` | `XCOS` | Numeric function |
| `66` | `XSIN` | Numeric function |
| `67` | `XSQR` | Numeric function |
| `68` | `XTAN` | Numeric function |
| `69` | `ZOOM` | Statement |
| `6A` | `ROTPOS` | Statement |
| `6B` | `ROTATE` | Statement |
| `6C` | `ROTZOOM` | Statement |
| `6D` | `FILES$` | String function |
| `6E` | `ENDIF` | Statement |
| `6F` | `BEEP` | Statement |
| `71` | `EDIT` | Direct command only |
| `72` | `CLOSE` | Statement |
| `73` | `CLS` | Statement |
| `74` | `CONT` | Direct command only |
| `75` | `DELETE` | Direct command only |
| `76` | `DSKF` | Numeric function |
| `77` | `END` | Statement |
| `78` | `CCOPY` | Statement |
| `79` | `ERL` | System value |
| `7A` | `ERR` | System value |
| `7B` | `GLOAD` | Statement |
| `7C` | `FILES` | Statement |
| `7D` | `FRE` | Numeric function |
| `7F` | `FWRITE` | Statement |
| `80` | `FKEY` | Statement |
| `81` | `KILL` | Statement |
| `82` | `LET` | Statement |
| `83` | `LIST` | Direct command only |
| `84` | `LOAD` | Statement |
| `85` | `LOC` | Numeric function |
| `86` | `LOF` | Numeric function |
| `87` | `GSAVE` | Statement |
| `88` | `NEW` | Direct command only |
| `89` | `PEEK` | Numeric function |
| `8A` | `VERSION` | System value |
| `8B` | `RENUM` | Direct command only |
| `8C` | `RESUME` | Statement |
| `8D` | `RUN` | Statement |
| `8E` | `SAVE` | Direct command only |
| `8F` | `SCREEN` | Statement |
| `90` | `SEEK` | Statement |
| `91` | `FIND` | Direct command only |
| `92` | `STOP` | Statement (flow) |
| `93` | `BLOAD` | Statement |
| `94` | `BSAVE` | Statement |
| `95` | `XDIST` | Numeric function |
| `96` | `GETCHR` | Numeric function |
| `97` | `ROTCENTER` | Statement |
| `98` | `COLOROFS` | Statement |
| `99` | `FORMAT` | Direct command only |
| `9A` | `SPRITE$` | Statement and string function |
| `9B` | `ROTOVER` | Statement |
| `9C` | `RGBADD` | Numeric function |
| `9D` | `RGBTO` | Numeric function |
| `9E` | `PUTSPRITE` | Statement |
| `9F` | `SETSPRITE` | Statement |
| `A0` | `SPRWINDOW` | Statement |
| `A1` | `OPTION` | Statement |
| `A2` | `SETPFONT` | Statement |
| `A3` | `POLYGONID` | Numeric function |
| `A4` | `VERTEXID` | Numeric function |
| `A5` | `ATRID` | Numeric function |
| `A6` | `TEXID` | Numeric function |
| `A7` | `KLOAD` | Statement |
| `A9` | `MOSAIC` | Statement |
| `AA` | `CHR$` | String function |
| `AB` | `PSET` | Statement |
| `AC` | `NEXT` | Statement |
| `AD` | `RETURN` | Statement (flow) |
| `AE` | `INSTR` | Numeric function |
| `AF` | `FREAD` | Statement |
| `B0` | `LOCK` | Statement |
| `B1` | `UNLOCK` | Statement |
| `B2` | `OFF` | Statement |
| `B3` | `RANDOMIZE` | Statement |
| `B4` | `SHIFT` | System value |
| `B5` | `READHEX$` | String function |
| `C0` | `PLAY` | Statement |
| `C1` | `EFFECT` | Statement |
| `C2` | `BGM` | Statement |
| `C3` | `VOLUME` | Statement |
| `C4` | `PLAYINIT` | Statement |
| `C5` | `PLAYPAUSE` | Statement |
| `C6` | `PLAYCONT` | Statement |
| `C7` | `PLAYFADE` | Statement |
| `C8` | `PLAYSTOP` | Statement |
| `C9` | `PLAYTEMPO` | Statement |
| `CA` | `PLAYPAN` | Statement |
| `CB` | `SETSONG` | Statement (flow) |
| `CC` | `SFRE` | Numeric function |
| `CD` | `TLIST` | Statement |
| `CE` | `PLAYSTAT` | Numeric function |
| `CF` | `SKCLOSE` | Statement |
| `D0` | `TARG` | Statement |
| `D1` | `TPROP` | Statement and function |
| `D2` | `USERDATA` | Statement and function |
| `D3` | `TFRE` | Numeric function |
| `D4` | `MMLSTAT` | Numeric function |
| `D5` | `LFO` | Statement |
| `D6` | `EG` | Statement |
| `D7` | `DSP` | Statement |
| `D9` | `DATA` | Statement (flow) |
| `DA` | `REM` | Statement |
| `E9` | `AND` | Logical operator |
| `EA` | `NOT` | Logical operator |
| `EB` | `OR` | Logical operator |
| `EC` | `XOR` | Logical operator |
| `ED` | `AND!` | Logical operator |
| `EE` | `NOT!` | Logical operator |
| `EF` | `OR!` | Logical operator |
| `F0` | `XOR!` | Logical operator |
| `F1` | `MOD` | Arithmetic operator |
| `F2` | `\` | Arithmetic operator |
| `F3` | `^` | Arithmetic operator |
| `F4` | `*` | Arithmetic operator |
| `F5` | `+` | Arithmetic operator |
| `F6` | `-` | Arithmetic operator |
| `F7` | `/` | Arithmetic operator |
| `F8` | `<` | Comparison operator |
| `F9` | `<=` | Comparison operator |
| `FA` | `<>` | Comparison operator |
| `FB` | `=` | Comparison operator |
| `FC` | `>` | Comparison operator |
| `FD` | `>=` | Comparison operator |
| `FE` | `(` | Bracket |
| `FF` | `)` | Bracket |
| `E8 00` | `OBJPOS` | Statement |
| `E8 01` | `OBJROT` | Statement |
| `E8 02` | `OBJATR` | Statement |
| `E8 03` | `OBJTURN` | Statement |
| `E8 04` | `OBJLINK` | Statement |
| `E8 05` | `OBJTYPE` | Statement |
| `E8 06` | `OBJZOOM` | Statement |

The 104 `@` sub-keywords (table at 0x0609DEE0), with the value each stands for. For `OBJ` fields the value is the field's index in the object record, as in `OBJ(n,@XP)`.

| Name | Value | Used with |
|---|---|---|
| `@TYPE` | 0 | `OBJ` field index |
| `@FLAG` | 1 | `OBJ` field index |
| `@GROUP` | 2 | `OBJ` field index |
| `@XP` | 4 | `OBJ` field index |
| `@YP` | 5 | `OBJ` field index |
| `@ZP` | 6 | `OBJ` field index |
| `@XR` | 8 | `OBJ` field index |
| `@YR` | 9 | `OBJ` field index |
| `@ZR` | 10 | `OBJ` field index |
| `@XS` | 12 | `OBJ` field index |
| `@YS` | 13 | `OBJ` field index |
| `@ZS` | 14 | `OBJ` field index |
| `@ATR` | 16 | `OBJ` field index |
| `@POLYGON` | 17 | `OBJ` field index |
| `@ORDER` | 18 | `OBJ` field index |
| `@TIME` | 19 | `OBJ` field index |
| `@PARENT` | 20 | `OBJ` field index |
| `@CHILD` | 21 | `OBJ` field index |
| `@LEFT` | 22 | `OBJ` field index |
| `@RIGHT` | 23 | `OBJ` field index |
| `@XV` | 24 | `OBJ` field index |
| `@YV` | 25 | `OBJ` field index |
| `@ZV` | 26 | `OBJ` field index |
| `@XA` | 28 | `OBJ` field index |
| `@YA` | 29 | `OBJ` field index |
| `@ZA` | 30 | `OBJ` field index |
| `@XL` | 32 | `OBJ` field index |
| `@YL` | 33 | `OBJ` field index |
| `@ZL` | 34 | `OBJ` field index |
| `@XRV` | 36 | `OBJ` field index |
| `@YRV` | 37 | `OBJ` field index |
| `@ZRV` | 38 | `OBJ` field index |
| `@XP0` | 48 | `OBJ` field index |
| `@YP0` | 49 | `OBJ` field index |
| `@XP1` | 50 | `OBJ` field index |
| `@YP1` | 51 | `OBJ` field index |
| `@XP2` | 52 | `OBJ` field index |
| `@YP2` | 53 | `OBJ` field index |
| `@XP3` | 54 | `OBJ` field index |
| `@YP3` | 55 | `OBJ` field index |
| `@XD` | 56 | `OBJ` field index |
| `@YD` | 57 | `OBJ` field index |
| `@ZD` | 58 | `OBJ` field index |
| `@RD` | 59 | `OBJ` field index |
| `@GTEST` | 60 | `OBJ` field index |
| `@RADIUS` | 61 | `OBJ` field index |
| `@COLIDIST` | 62 | `OBJ` field index |
| `@COLIOBJ` | 63 | `OBJ` field index |
| `@MATRIX` | 64 | `OBJ` field index |
| `@PAD_A` | &H0400 | `PAD()` bit mask |
| `@PAD_B` | &H0100 | `PAD()` bit mask |
| `@PAD_C` | &H0200 | `PAD()` bit mask |
| `@PAD_X` | &H0040 | `PAD()` bit mask |
| `@PAD_Y` | &H0020 | `PAD()` bit mask |
| `@PAD_Z` | &H0010 | `PAD()` bit mask |
| `@PAD_R` | &H0080 | `PAD()` bit mask |
| `@PAD_L` | &H0008 | `PAD()` bit mask |
| `@PAD_RIGHT` | &H8000 | `PAD()` bit mask |
| `@PAD_LEFT` | &H4000 | `PAD()` bit mask |
| `@PAD_DOWN` | &H2000 | `PAD()` bit mask |
| `@PAD_UP` | &H1000 | `PAD()` bit mask |
| `@PAD_START` | &H0800 | `PAD()` bit mask |
| `@BEND` | 0 | Sound parameter (`TPROP`, `LFO`, `EG`, `DSP`) |
| `@LAYER` | 1 | Sound parameter (`TPROP`, `LFO`, `EG`, `DSP`) |
| `@TONE` | 2 | Sound parameter (`TPROP`, `LFO`, `EG`, `DSP`) |
| `@SN` | 10 | Sound parameter (`TPROP`, `LFO`, `EG`, `DSP`) |
| `@EN` | 11 | Sound parameter (`TPROP`, `LFO`, `EG`, `DSP`) |
| `@BN` | 12 | Sound parameter (`TPROP`, `LFO`, `EG`, `DSP`) |
| `@FT` | 13 | Sound parameter (`TPROP`, `LFO`, `EG`, `DSP`) |
| `@AR` | 20 | Sound parameter (`TPROP`, `LFO`, `EG`, `DSP`) |
| `@DR` | 21 | Sound parameter (`TPROP`, `LFO`, `EG`, `DSP`) |
| `@SR` | 22 | Sound parameter (`TPROP`, `LFO`, `EG`, `DSP`) |
| `@RR` | 23 | Sound parameter (`TPROP`, `LFO`, `EG`, `DSP`) |
| `@SL` | 24 | Sound parameter (`TPROP`, `LFO`, `EG`, `DSP`) |
| `@EGHOLD` | 25 | Sound parameter (`TPROP`, `LFO`, `EG`, `DSP`) |
| `@LSLINK` | 26 | Sound parameter (`TPROP`, `LFO`, `EG`, `DSP`) |
| `@KS` | 27 | Sound parameter (`TPROP`, `LFO`, `EG`, `DSP`) |
| `@SDIR` | 30 | Sound parameter (`TPROP`, `LFO`, `EG`, `DSP`) |
| `@SB` | 31 | Sound parameter (`TPROP`, `LFO`, `EG`, `DSP`) |
| `@SS` | 32 | Sound parameter (`TPROP`, `LFO`, `EG`, `DSP`) |
| `@LOOP` | 33 | Sound parameter (`TPROP`, `LFO`, `EG`, `DSP`) |
| `@PCM8B` | 34 | Sound parameter (`TPROP`, `LFO`, `EG`, `DSP`) |
| `@LSA` | 35 | Sound parameter (`TPROP`, `LFO`, `EG`, `DSP`) |
| `@LEA` | 36 | Sound parameter (`TPROP`, `LFO`, `EG`, `DSP`) |
| `@RE` | 50 | Sound parameter (`TPROP`, `LFO`, `EG`, `DSP`) |
| `@LFOF` | 51 | Sound parameter (`TPROP`, `LFO`, `EG`, `DSP`) |
| `@ALFOWS` | 52 | Sound parameter (`TPROP`, `LFO`, `EG`, `DSP`) |
| `@ALFOS` | 53 | Sound parameter (`TPROP`, `LFO`, `EG`, `DSP`) |
| `@PLFOWS` | 54 | Sound parameter (`TPROP`, `LFO`, `EG`, `DSP`) |
| `@PLFOS` | 55 | Sound parameter (`TPROP`, `LFO`, `EG`, `DSP`) |
| `@MDX` | 60 | Sound parameter (`TPROP`, `LFO`, `EG`, `DSP`) |
| `@MDY` | 61 | Sound parameter (`TPROP`, `LFO`, `EG`, `DSP`) |
| `@MDL` | 62 | Sound parameter (`TPROP`, `LFO`, `EG`, `DSP`) |
| `@ISEL` | 70 | Sound parameter (`TPROP`, `LFO`, `EG`, `DSP`) |
| `@IMIX` | 71 | Sound parameter (`TPROP`, `LFO`, `EG`, `DSP`) |
| `@DSEND` | 72 | Sound parameter (`TPROP`, `LFO`, `EG`, `DSP`) |
| `@DPAN` | 73 | Sound parameter (`TPROP`, `LFO`, `EG`, `DSP`) |
| `@REV` | 0 | `DSP` effect type |
| `@DEL` | 1 | `DSP` effect type |
| `@DST` | 2 | `DSP` effect type |
| `@SAW` | 0 | `LFO` waveform |
| `@SQU` | 1 | `LFO` waveform |
| `@TRI` | 2 | `LFO` waveform |
| `@NOISE` | 3 | `LFO` waveform |

The VS Code extension's keyword list can be checked against this table. `tokens.tsv` from the extractor has it in machine-readable form.

## File formats seen on the CD

| Format | Layout |
| --- | --- |
| `.B` program (CD, `COM:`) | Plain text, one numbered line per CR+LF. Several samples start with an unnumbered `LOAD"COM:D"` or `load"com:dummy"` line, left over from being sent from a PC. An unnumbered line is ignored by `LOAD` |
| `GSAVE` `.1` picture | u16 width, u16 height (big-endian, for example 0x0140 × 0x00E0), then width × height RGB555 pixels, big-endian. 143,364 bytes for 320 × 224 |
| `GSAVE` `.0` picture | Same header, a 256-entry RGB555 palette (512 bytes), then 8-bit pixels. 72,196 bytes for 320 × 224, which is 282 blocks of 256 bytes and matches the CLEAR figure in RM p. 107 |
| `.D` data | Free format: whatever the program writes with `FWRITE` or reads with `FREAD`/`INPUT#`. Can hold AIFF or RIFF WAVE for `TARG` |
| `.WV` sound bank | SCSP tone data, typically 348,160 bytes per bank. `555_BEEP.WV` (4,352 bytes) starts with a table of 16-bit offsets. Not decoded further |
| Saved settings | Backup-RAM file `GBASICSS_01`, comment `Config`. Programs saved to `BRAM:`/`CRAM:` carry a `SSBASIC50 ` header (0x0603610F) |

## Error numbers

The message table is at 0x06075A84, one pointer per error number from 1. Numbers 33, 38, 40 and 49 have no message and print *Undefined error*, as do 255 and anything above 96. The interpreter's own uses that matter for `COM:` are 20 *Communication error*, 28 *Direct statement only*, 61 *Bad file mode* and 62 *Bad device name*.

## How to reproduce

`GAME_BASIC/tools/gbcd_extract.py` uses only the Python standard library. It prints the IP.BIN header and file list, extracts the files, unpacks `0` to `main.bin` and writes `tokens.tsv`:

```sh
python3 GAME_BASIC/tools/gbcd_extract.py GAME_BASIC/GAME_BASIC_CD/GAME_BASIC.iso \
        --out GAME_BASIC/GAME_BASIC_CD/extracted
```

`main.bin` loads into Ghidra as SuperH SH-2, big-endian, base 0x0600A000. Good starting points are the serial driver at 0x0600A080, the link protocol at 0x0600B810–0x0600D7EF, LIST at 0x0600FD7C and the token table at 0x0609CBE0.

**Copyright.** The ISO, the extracted files, `main.bin` and `tokens.tsv` are ©1998 ASCII Corp./Bits Laboratory/ESP inc. Keep them out of any public repository. `gbcd_extract.py` and this report contain no CD data apart from the keyword names and addresses quoted here.

## Limits of this analysis

Everything above comes from reading the code. These points depend on the hardware and can only be measured on a real Saturn:

- Whether a given USB-TTL adapter keeps up at 57600 and 115200 baud once `OPTION HD352` is set. The BRR values are within about 1% of nominal.
- The real timing margins on the wire, for example how close the Saturn's 50 ms NUL spacing and 1 s timeouts run on hardware.
