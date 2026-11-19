# GAME BASIC Tutorial Manual: reference notes for the BASTERM replacement

Nov 18, 2026 · @Brett

These are notes from the whole Japanese *GAME BASIC for SEGASATURN Tutorial Manual* (チュートリアルマニュアル). The Reference Manual notes, including its keyword index, moved to `Reference_Manual_findings.md` on Nov 19. Everything is checked against `BASTERM/BASTERM_serial_protocol.md`, the VS Code extension (`vscode-game-basic`) and the Python sender (`tools/saturn_link`).

The manual is written for users, so it has no wire-level protocol detail. It does settle many behaviour questions, shows what the Saturn prints, and describes BASTERM itself in Chapter 3. Page numbers below are book pages unless marked "scan".

---

## 1. The scans

The scans are in `Documentation/Tutorial_Manual_JP/`, one TIFF per sheet. They were scanned at 600 dpi: the covers in 24-bit colour and the other pages in 8-bit grey. From scan 9 on, **book page = scan number − 6**. Scans 8, 18, 20, 150 and 152 are blank pages.

| Scans | Book pages | Content |
|---|---|---|
| 1–7 | cover, foreword, contents | Contents for the whole book. The foreword says a separate Reference Manual held the full command details |
| 9–17 | 3–11 | Package contents, pad and keyboard hookup, boot screen, controls, software keyboard, PC cable |
| 19–37 | 13–31 | Chapter 2 starts: first input, error messages, `PRINT`, variables, first program, `LIST`/`RUN`/Break, `SAVE`/`FILES`/`LOAD` |
| 38–66 | 32–60 | `IF`/`FOR`/`GOSUB`, arrays, `DATA`, `RENUM`, screen modes, graphics, kanji, sprites, scroll, zoom, rotate, mosaic |
| 67–85 | 61–79 | 3D polygons, samples P_PFONT, P_CLOCK, P_FLOWER and P_CAME2, the DXFCONV tool |
| 86–92 | 80–86 | Sound: music basics, FM and PCM, MML with `EFFECT "…"`, S_TUTOR.B |
| 93–109 | 87–103 | Making games: G_HATA.B, a line-by-line walkthrough of G_MOBIL.B, the light gun sample |
| 110–149 | 104–143 | Guide to every sample program and tool on the CD |
| 151–178 | 145–172 | **Chapter 3: BASTERM** (the PC communication software) |
| 179–184 | 173–176, back | Index, back matter, back cover |
| Ref. 1–22 | Ref. front matter, 1–18 | **Basic specification**: contents, characters, numbers, strings, operators and precedence, variables, line and label limits, memory, devices and file names, **reserved word list**, `@` constant table, editing keys, function keys, soft reset |
| Ref. 23–24 | Ref. 19–20 | **System settings screen**: baud rate, keyboard repeat, edit width, where the settings are stored |
| Ref. 420–425 | Ref. 416–421 | **Reference Manual index**: every keyword with its page |

Reference Manual scans are in `Documentation/Reference_Manual_JP/`; Reference scan N = book page N − 4. Notes on the Reference Manual are in `Reference_Manual_findings.md`.

---

## 2. Connecting the Saturn to the PC

**The cable (pp. 9–11).**
- The Windows comm cable plugs into the **expansion communication port on the back of the Saturn** (拡張通信端子), with the power off. The plug only fits one way.
- The PC end is a **DB-25 female** after an in-line box. It must **not** go straight into the PC ("this will cause damage"). The user adds a **straight-through RS-232C modem cable**: DB-25 male to DB-9 female for a DOS/V PC, or DB-25 male to DB-25 female for a PC-9801.
- So the cable presents itself as a modem-style (DCE) device, and the box is the RS-232 level converter. That fits the NEC µPD4711 in the Windows_Communication_Cable project, and means a USB-TTL adapter only has to do level shifting. The manual names no handshake lines.
- The requirement is just "a Windows 95 PC".

**Port and baud rate (Tutorial p. 166, Reference pp. 19–20).** 9600 or 19200 baud, default 9600 on both sides, default PC port COM1. The PC must match the Saturn's setting. 19200 is faster but less tolerant of CPU load and electrical noise, so drop to 9600 on errors. BASTERM's port settings can only change while disconnected. The manuals give no data format; 8N1 with no flow control comes from the `DCB` in `Basterm.exe` (see `BASTERM/BASTERM_serial_protocol.md`).

**Setting the baud rate on the Saturn (Reference pp. 19–20).** The rate is set on GAME BASIC's **system settings screen**:
- Open it from the edit screen (blinking `_` cursor) with **L+R+Z** on a pad in controller port 1, or **Q+E+D** held together on the Saturn keyboard.
- Move with the D-pad up/down, change a value with left/right, then move to **Exit** and press **C** to go back.
- **Baudrate**: `19200BPS` or `9600BPS`. "Select the same speed as the communication software. If communication errors occur, set 9600BPS."
- The other settings: **Keyboard** INITIAL (4–255 frames before key repeat, default 17), AFTER (1–255 frames between repeats, default 3), Ctrl key NORMAL or SWAP (swaps Ctrl and Caps Lock); **Edit width** LEFT/TOP/RIGHT/BOTTOM (default 1, 1, 38, 26) and background colour RED/GREEN/BLUE (0–15, default 0). A frame is 1/60 s at start-up, but `SCREEN` can change it.
- The settings are saved in the Saturn's backup RAM as **`GBASICSS_01`** (comment `Config`, 1 block), visible in the Saturn's own memory manager. Deleting that file puts every setting back to its default, including 9600 baud.

So if the link gets no answer, the first things to check are the rate on this screen and that `GBASICSS_01` hasn't been left at 19200 from an earlier session.

**Connection failure (p. 151).** BASTERM says 「セガサターンとの接続に失敗しました。接続を確認してください。」 ("Connection to the Saturn failed. Check the connection."). While the link comes up the progress dialog says 「通信ネゴシエーション中」 ("negotiating"). The advice is to check the port and connector, and keep electrical appliances away from the cable.

---

## 3. Saturn-side controls

**Pad shortcuts (p. 6).**

| Action | Pad |
|---|---|
| Software keyboard | L+R+Start |
| Page change / Shift / lower case | R / L / L+C |
| **Break** (stop the program) | **A+Start** |
| Insert/overwrite, cursor | A+X, A+D-pad |
| **BASIC system settings screen** (baud rate) | **L+R+Z** (keyboard: Q+E+D) |
| Software reset | A+B+C+Start |
| Delete, Space, Enter, Backspace, select | X, Y, Z, B, C |

**Software keyboard (pp. 7–8).** It has four pages, ALPH, カナ, CMD. and GRPH, each with F1–F12 along the top. CMD. has one-touch keywords (`CLS FOR NEXT STEP LOCATE PRINT IF THEN ELSE GOTO GOSUB RETURN COLOR PSET LINE CIRCLE PAINT`). GRPH has block graphics, card suits and the kanji 円年月日時分秒. The alphabet page shows `¥` where ASCII has `\`, as in Shift-JIS (JIS-Roman). The extension already treats `¥` as one byte.

**Saturn keyboard (pp. 9, 20).** It has F1–F12, Esc, Caps Lock, Ctrl, Alt, Shift and arrow keys. It is a Japanese (JIS) layout: `"` is Shift+2. That matters for a live key-send mode that maps PC keys to Saturn keys. It doesn't matter for sending text, which goes as character codes.

**Break (p. 28).** Ctrl+C on the keyboard or A+Start on the pad. The Saturn prints `Break at 130` (the line it stopped on), then `Ready.`. This explains BASTERM's STOP: it sends key byte **0x03, which is Ctrl+C**, with modifier 4 or 5.

**F12 restores a readable screen (Tutorial pp. 60, 165; Reference p. 20).** F12, or Ctrl+P, resets the edit screen to the "Edit width" text area from the settings screen. That is why it cancels `MOSAIC ON` and why in key-send mode it turns polygon display off. `SCREEN` doesn't change the edit width. A key-send mode or a "Reset display" command should be able to send it (F12 is 07,07 in the key table; Ctrl+P would also do).

**Soft reset (Reference p. 19).** A+B+C+Start shows `HOT START` instead of the boot message. It reinitialises variables, file buffers and the user area as if by `CLEAR 0,64,64`, and resets sound memory to its power-on state. The program itself may not survive.

**Launcher (p. 105).** Shift+F1 on the keyboard (L+F1 on the software keyboard) starts LAUNCH.B, a file picker. A or Tab changes device, Start or Enter runs the file, and A–Z, 0–9 or F4 search.

**Music survives Break (p. 128).** T_KANADE.B relies on the last BGM staying in sound memory after a Break. So stopping a program from the PC won't silence its music.

---

## 4. What the Saturn prints

This is what the mock Saturn should imitate, and what the sender can read back after a send.

| Situation | Saturn output | Page |
|---|---|---|
| Boot | `GAME BASIC for SEGASATURN ver 1.00` / `(C)1998 ASCII Corp./Bits Laboratory` / `/ESP inc.` / `Ready.` | 5 |
| After any command | `Ready.` | 17–22 |
| Bad input (e.g. `A`) | `Syntax error`, the input again with the cursor on it, then `Ready.` (and a beep if a speaker is connected) | 17–18 |
| `PRINT "HELLO"` / `PRINT 1+2` | `HELLO` / ` 3` (numbers have a leading sign space) | 20–22 |
| Break | `Break at 130`, then `Ready.` | 28 |
| After BASTERM sends | `LOAD "COM:TBASTERM.B"`, then `Line 120` (the last line loaded), then `Ready.` | 152 |
| `LIST` | line numbers right-aligned in 5 characters: `   10 PRINT "HELLO!"` | 24–25 |
| `FILES "BRAM:"` | one 8.3 name per line, padded to 8 characters (`DATE    .B`), then `Free size 105 / 512 file blocks`, then `Ready.` | 29–30 |

The tutorial shows only `Syntax error` and says the full list of error messages is in the Reference Manual. Typos such as `1022 NAXT` only show up when the program runs (p. 155).

**Errors may only show on the Saturn (pp. 163–164).** If a transfer fails, or is aborted from the Saturn keyboard, BASTERM may show no error. The manual says to always check the Saturn's own message. So a replacement should read the Saturn's screen text after a send, not just trust the protocol result.

---

## 5. Devices and files

**Device names.** `BRAM:` is the Saturn's internal backup RAM. `CRAM:` is cartridge RAM (the separately sold Power Memory). `CD:` is the CD-ROM, `FD0:` and `FD1:` are floppy drives, and `COM:` is the PC through BASTERM (pp. 29–30, 132, and LAUNCH.B). A name without a device uses the current device (`LOAD "G_BOMB.B",R`, p. 106).

**Commands.**
- `SAVE "BRAM:DATE.B"` and `LOAD "BRAM:DATE.B"` use the same `DEVICE:NAME.B` form as BASTERM's `LOAD "COM:TBASTERM.B"`. SAVE fails when backup RAM is full of game saves.
- `LOAD "…",R` loads and runs (used for every sample, pp. 89–143). `LOAD "…",M` merges without `NEW` (p. 171). The sender's `--run` and `--merge` already type these.
- `NEW` clears the program in work RAM, and so does power-off. The manual recommends `NEW` before typing a new program, which matches BASTERM's plain `LOAD` doing a `NEW` first (pp. 24, 29).

**`COM:` is a full device, not only for LOAD.**
- `FILES "COM:"` should make the Saturn use BASTERM's directory search: 0x11 (first), 0x12 (next) and 0x13 (end), then the two disk-space requests 0x1A and 0x1B. The `Free size … / … file blocks` line fits those last two as "free" and "total". This is still inferred, because the manual never shows `FILES "COM:"`. LAUNCH.B can list `COM:` but leaves it out by default because it is slow (`MAX_DEVICE=5 :'COM:を含める場合は6但し遅い`).
- The file dialogs in T_KAMI.B, T_OTO.B and T_HIBIKI.B offer all six devices, including `COM:` (p. 132).
- **TRANSFOR.B** (p. 128) copies a `.D` data file from the Saturn "to Basterm". It is 19 lines: `OPEN B$+":"+A$ FOR INPUT AS 1`, `OPEN "COM:"+A$ FOR OUTPUT AS 2`, then one `FREAD #1,DT$,1` / `FWRITE #2,DT$` per byte. `saturn_link` already handles the Saturn writing to the PC (`OPEN_WRITE`, then data blocks) when writes are allowed. One byte per block is the worst case, so this makes a good hardware test.

**BASTERM as a file server (pp. 162–165).** BASTERM's Connect must be on for programs that use `COM:` files. On disconnect, BASTERM closes any files the Saturn still has open, and later access gives an error, so programs should close files first. Send and Receive connect automatically and disconnect afterwards. Settings > Change current directory sets the PC folder that `COM:` maps to (the extension's `gameBasic.serveDirectory`).

**File names (p. 158).** BASTERM saves `.b` and lists `*.b;*.bas`. Names should be 8 half-width characters. Longer or full-width names can be saved on the PC, but the Saturn can then reach them only through BASTERM's own Send and Receive.

---

## 6. BASTERM (Chapter 3, pp. 145–172)

**Shortcuts.** Send Ctrl+P, Receive Ctrl+G, Run Ctrl+R, Stop Ctrl+B, Key send Ctrl+K.

**Send.** BASTERM types `LOAD "COM:TBASTERM.B"` on the Saturn and serves the file (photo on p. 152). The send order is: save, filter, number lines, check, diff, then `LOAD` or `LOAD,M`.

**Receive (p. 163).** It replaces the editor contents and keeps the file name. If `SAVE "COM:…"` writes the same format as `LIST`, received lines will start with spaces before the line number.

**Run and Stop (p. 164).** Run sends `RUN`, stopping the program first if it is running. Stop keeps sending the stop key until the program stops. BASTERM's display of whether a program is running is approximate.

**Key send (pp. 156, 165).** Ctrl+K starts it, and Alt+K or a click ends it. No other command works while it's on. F10 and Ctrl+Break can't be sent. During heavy polygon drawing, keys can be dropped or garbled. Pressing F12 turns polygon display off, and neither `CONT` nor direct commands bring the polygons back. It only works with GAME BASIC.

**Line numbering (pp. 170–171).** A numbered line resets the counter. `*label` lines are rounded up to the label interval. Blank lines become `'` when numbering and are dropped otherwise. `preprocess.py` already does this. `#include "FILE"`, written without a line number, is a BASTERM-only directive (p. 172).

**Checks before sending (p. 171).** Missing, duplicate or invalid line numbers, and too many characters per line. The manual gives no figure for the line limit.

**Diff send (pp. 169–171).**
- Only changed lines go, with `LOAD …,M`.
- A full `LOAD` is used after opening a file and after a cancelled send.
- If the diff would be too big it falls back to a full send. Shift+Send forces a full send.
- BASTERM can't see edits made on the Saturn, so diffs can drift. "Always issue LOAD,M" overrides the automatic choice.
- A fixed line number at the start of data sections keeps later numbering stable and diffs small.

**Send settings (p. 169).** Run after send; key send after Run; diff send; add line numbers (start, step and `*` label interval); show errors after send (on); stop on errors (on); keep `ERRORLOG.TXT`; keep `TBASTERM.B`; always `LOAD,M`. The temp-file name must be an 8.3 name ending `.B`, because it becomes the `LOAD`/`SAVE` argument.

**Filter (pp. 166–168).** MS-DOS console programs only (`.com`, `.exe`, `.bat`). Defaults: input `IBASTERM.B`, output `OBASTERM.B`, folder `C:\WINDOWS\TEMP\`. Options: add stderr (on) or stdout (off) to the error log, delete temp files (on), show the console (on). The example is a structured-BASIC to line-numbered-BASIC converter.

**Kanji needs the PC (pp. 49–50).** The Saturn keyboard can't type kanji, so kanji strings for `KPRINT` have to arrive in a program sent from the PC. Shift-JIS string literals are a core use of BASTERM, and the extension already handles them. Sequence: `KLOAD ON` loads the kanji font from the CD (using work RAM), then `KPRINT "せがた三四郎"`.

---

## 7. Language and syntax

**Rules (pp. 19–27).**
- Variable names can be up to **31 characters**. `LET` is optional, string variables end in `$`, and `A$+B$` joins strings.
- Keywords use letters, digits and some symbols. Kana and kanji belong only in strings and comments; half-width katakana in `'` comments is normal in listings.
- `:` separates statements. `*LOOP` labels with `GOTO *LOOP` are recommended over line numbers, because renumbering changes the numbers.
- `RENUM` with no arguments renumbers from **100 in steps of 10** and updates `GOTO` targets (p. 34). The extension's auto-numbering defaults to 10/10.
- `LIST 10` lists one line for editing, and `DELETE 10` removes it.

**Forms that the editor has to accept.** All of these are in the manual or on the CD, and the checker accepts all of them:
- Fixed-point hex: `&H0.0E`, `&HFFFF.FFFC` (pp. 55, 155).
- `AND!`, a fixed-point AND: `N=(N+&H0.001) AND! &HFFFF.FFFC` (p. 55).
- Multi-value assignment: `OBJ(3,@XP0) = x0,y0, x1,y1, …` and `OBJ(I,XP)=0,0,0` (Chapter 2 samples, p. 155).
- `@` names, both as `OBJ` fields (`OBJ(P,@ORDER) = 0`) and as pad constants (`IF PDL AND @PAD_START THEN …`, `@PAD_LEFT`, `@PAD_A`), pp. 94–98. The older form uses plain variables as field numbers (`TYPE=0: OBJ(n,TYPE)`), and fields can also be numbered directly (`OBJ(1,37)=.03`).
- Block `IF … THEN` on its own line, closed by `ENDIF` on a later line (p. 103).
- Leading commas (`SCREEN,,,2`, `COLOR,,,RGB(…)`), negative arguments (`EFFECT -4`), `*LOOP: LOCATE 0,0`, and code indented after the line number.
- `TIME` is an ordinary variable: the manual calls it "the variable TIME" (変数TIME, p. 98).

**Printed listings wrap long lines** (for example `1260 … THEN LINE` / `-(XP,YP),…` on p. 103). When typing a listing in from the book, join these back into one line. The checker's "no line number" error catches any that are missed.

**Graphics notes.**
- `SCREEN [mode][,text BG][,text colours][,frame unit]`, modes 0–6. The character screen is 39×26 cells and the bitmap is 320×224 (pp. 41–44). Mode 5 is the 3-axis rotation BG with a 256×256-character field (p. 91).
- `RGB(r,g,b)` uses 0–31 per channel, giving r + g×32 + b×1024. Texture colours need bit 15 set: `RGB(31,0,0) OR &H8000` = `&H801F` (p. 66).
- Polygon vertices go clockwise for a front face (p. 66). `ROTATE` angles are in turns (0.25 = 90°), not radians as the text says.
- `KPRINT [(x,y[,xpitch,ypitch,halfwidth])],[FIX][string][;][,colour][,SCALE][,bgcolour]` (p. 50).
- `CAMERA … TO TARGET,BG` has a trailing `BG` that may be an option word. There's only one example, so it waits for the Reference Manual.

**Sound (pp. 79–86, 91).**
- MML goes inside a string and plays with `EFFECT "…"`, e.g. `EFFECT "@35 CDEF @36 GAB"`. Notes `A`–`G`; `#` or `+` sharp, `-` flat, `n` natural; `R` rest; `O` octave and `<` `>` octave down/up; lengths `1`–`128` with up to three dots; `( )` chords; `@n` instrument; `v` (0–15) and `@v` (0–127) volume. The Reference Manual covers the rest on pp. 323–342 (`L`, `T`, `Q`, `K`, `P`, `S`, dynamics `p`…`f`, loops `:|`).
- `EFFECT n,0,"@10 %1 C"` stores a sound in slot n, and `BGM n` plays it.
- BASIC spreads 16 tracks over the Saturn's 32 sound channels. Pan commands do nothing when the Saturn's audio is set to mono.
- Since MML is always inside strings, it doesn't affect the keyword list. Highlighting it would be a nice extra.

**Light gun (pp. 102–103).** The Virtua Gun is device ID "37" and goes in controller port 2. It is read with `PAD(port,1)`, `PAD(port,3)` and `PAD(port,4)`.

---

## 8. CD programs and tools worth knowing

| Program | What it is | Why it matters here |
|---|---|---|
| TRANSFOR.B | Copies a `.D` file from the Saturn to BASTERM (p. 128) | Real-world test of Saturn→PC writes over `COM:` |
| LAUNCH.B | File picker for all devices (p. 105) | Shows the device list and that `FILES` over `COM:` is slow |
| DXFCONV | PC tool: DXF `3DFACE` → `.VTX`/`.PNT` → `.B`, optionally with `HEADBAS.B` (pp. 73–78) | The installer is `Instdc10.exe` on the CD (the manual misprints `Instbc10.exe`). Doesn't touch the serial link |
| T_OTO.B | Song editor, exports MML (pp. 133–137) | A possible source of files coming back over `COM:` |
| T_HIBIKI.B | Instrument-set editor, exports BASIC (pp. 139–141) | Same |
| T_KAMI.B | Paint tool with the six-device file dialog (pp. 128–132) | Uses `COM:` like any other device |
| S_T_NAME.B | Instrument names to append to a program, in `TLIST` order (p. 141) | — |
| S_TUTOR.B | Sound tutorial menu (pp. 83–84) | — |

The rest (G_HATA, G_MOBIL/G_MOBILS, G_BOMB, G_BOU, G_JUMP/_A/_M, G_MAZE, G_SABA, G_TEKE, G_THESEU, P_DOLL, P_DLPLAY, P_HERI, P_TANK, P_NEKO, P_SHOWER, P_TEXMAP, the S_ music samples and PLAYMIDI) are games and demos. Their pages explain how to play them.

---

## 9. Changes made from these notes (not committed)

Changes that came from the Reference Manual (6–13, 15–18, 21, 22, 25, 26 and later) are listed in `Reference_Manual_findings.md`, section 10, under the same numbers.

1. `PUTSPRITE` added, and `AND!` highlighted as one operator.

2. Fixed-point hex (`&H0.0E`, `&HFFFF.FFFC`) highlights as one number.

3. The mock Saturn prints `Line N`, `Ready.`, `Syntax error`, `Break at N` and 5-wide `LIST` numbers, as in the manual. It doesn't print the boot banner, which the PC never sees.

4. After a send, the sender collects what the Saturn printed. It reports `Line N` in the "Sent" message and warns if that isn't the last line sent. If anything looks like an error (`Syntax error`, `… not found` and so on), it exits with code 4, and VS Code shows "Sent, but the Saturn reported: …".

5. `OBJTYPE`, `OBJATR`, `OBJPOS`, `OBJTURN` and `FRAC` added, and `HEX$` confirmed.

14. Show Error Line (Brett's request): **Alt+F6** or the warning button in the editor title runs `saturn_send.py show-error`, which presses F12 (keystroke 07,07) and then types `ERROR` + Enter, with no STOP first so the Saturn keeps its error state. The mock answers `ERROR` by listing a line. One Python test added (28 pass); README updated. Still to test on hardware: whether F12 sent over the link acts like the keyboard's F12.

19. Sender: `FILES "COM:"` now lists only names the Saturn can use (1–8 of A–Z, 0–9, `_`, then `.B`, `.0`, `.1` or `.D`), via `protocol.saturn_name_ok` and `SaturnLink._dir_names`. One test added. Brett asked for this.

20. New `tools/saturn_bitmap.py` (Brett asked for it): PNG ↔ `.0`/`.1` converter with no extra packages. PNG → `.1` keeps every colour, `--256` makes a `.0` (median-cut reduction past 255 colours; dot 0 stays transparent); PNG transparency maps to the Saturn's transparent value. It prints the CLEAR buffer GLOAD needs and warns about names the Saturn can't use. The four CD bitmaps round-trip byte for byte. VS Code: right-click a `.png` → "Convert to Saturn Bitmap (.0/.1)" (asks which type), or a `.0`/`.1` → "Convert Saturn Bitmap to PNG". The extension bundles the script. 7 Python tests and 1 extension test added (36 Python, 18 extension tests pass); both READMEs updated.

23. Sender (Brett asked): "No answer from the Saturn" and "The Saturn did not answer STOP" now end with the soft-reset hint from p. 147: "If the Saturn has locked up, soft reset it with A+B+C+Start on the pad: GAME BASIC keeps the program in memory." (`HUNG_HINT` in `link.py`.)

24. `saturn_bitmap.py --setchr [16|256]` (Brett asked): cuts a PNG into 8×8 characters and writes `NAME_chr.B` with `SETCHR <BG>,<pattern>,<bytes>,READ`, one hex `DATA` line per dot row, and `PALETTE` lines (16-colour text patterns use palette code 1 by default so the normal text colours are untouched; colours past 15 or 255 are reduced). Options `--bg`, `--first`, `--palette`, `--no-palette`, `--start`/`--step`. A generated file passes `saturn_send.py check` and sends to the mock Saturn. VS Code: right-click a `.png` → "Convert to Characters (SETCHR DATA)". 3 Python tests and one extension check added (39 Python, 18 extension tests pass); READMEs updated.

---

## 10. Still open

**To build.**
- Diff send, following the rules in section 6.
- A live key-send mode, with F12 as a "reset display" key.
- A "Saturn charset" mode for files using the graphic characters 0x80–0x9F/0xE0–0xFF (Reference findings, section 8), and a warning when a non-`KPRINT` string contains kanji.
- Optionally: a check for variable names over 31 characters; an option to auto-number from 100/10 like `RENUM`; hover notes (texture colour bit 15, `RGB` ranges); MML highlighting inside strings.

**To test on hardware.**
- Whether the Saturn echoes its screen text over the link at all. If it doesn't, change 4 above simply finds nothing.
- `FILES "COM:"`, to confirm the 0x11–0x13 directory calls and what units 0x1A/0x1B use.
- What `FILES "COM:"` and `DSKF("COM:")` show for free space with the sender's current answer (Reference findings, section 3).
- TRANSFOR.B against `saturn_link serve`, for Saturn→PC writes one byte at a time.
- Whether Receive copes with `LIST`-style leading spaces before line numbers.

**Not in the tutorial.** It has no wire-level protocol (byte formats, handshake, block sizes) and no full error-message list. It also doesn't explain status codes 1 and 2 or the difference between the two STOP modifiers. The Reference Manual may cover some of this.
