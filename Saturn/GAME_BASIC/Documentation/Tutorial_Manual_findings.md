# GAME BASIC Tutorial Manual: reference notes for the BASTERM replacement

Nov 18, 2026 · @Brett

These are notes from the whole Japanese *GAME BASIC for SEGASATURN Tutorial Manual* (チュートリアルマニュアル), plus the keyword index of the *Reference Manual*. Everything is checked against `BASTERM/BASTERM_serial_protocol.md`, the VS Code extension (`vscode-game-basic`) and the Python sender (`tools/saturn_link`).

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

Reference Manual scans are in `Documentation/Reference_Manual_JP/`; Reference scan N = book page N − 4. The Reference Manual is still the place to look for `COM:` details, the full error-message list and the `FKEY`/`EDIT`/`FIND` editor commands.

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

## 8. Keyword list vs the Reference Manual index

The index (Reference Manual pp. 416–421) lists every GAME BASIC command with its page, so it is the check for `src/keywords.js`. The extension now follows it. Every keyword (208 in all) comes from the CD's programs, the Tutorial Manual or the index.

- **Added (42).** Statements: `EDIT`, `FIND`, `FKEY`, `FORMAT`, `GSAVE`, `LFO`, `OBJLINK`, `OBJROT`, `OBJZOOM`, `PLAYCONT`, `PLAYPAN`, `PLAYPAUSE`, `RGBADD`, `RGBTO`, `SEEK`, `SETSPRITE`, `SHIFT`, `TLIST`, `VERTEX`, `WINDOW`. Functions: `ATRID`, `BINHEX$`, `BITW$`, `DSKF`, `MMLSTAT`, `PEEK$`, `POINT`, `POLYGONID`, `READHEX$`, `SFRE`, `SPRITE$`, `TEXID`, `TFRE`, `VERSION`, `WADD$`, `WANDOR$`, `WMUL$`, `WXOR$`, `XATN`, `XDIST`, `XSQR`, `XTAN`.
- **Confirmed (16)** words we only had from standard BASIC: `ATN`, `BIN$`, `CINT`, `CONT`, `DELETE`, `ERL`, `EXP`, `KILL`, `LET`, `LIST`, `LOG`, `POS`, `RANDOMIZE`, `RENUM`, `STOP`, `TAN`.
- **Removed (27).** `TIME` and `MSTR$` are user variables in the CD's games (`TIME = TIME + .05`; `DIM MSTR$(…)`). `TIME$` is in neither the index nor the CD. Standard BASIC words that aren't in GAME BASIC: `AUTO`, `CDBL`, `CSNG`, `CSRLIN`, `DEF`, `FN`, `EOF`, `EQV`, `IMP`, `ERASE`, `FIELD`, `GET`, `PUT`, `LLIST`, `MERGE`, `OCT$`, `PRESET`, `SOUND`, `SPC`, `TAB`, `TRON`, `TROFF`, `WHILE`, `WEND`. The index has no structured loops at all.
- **Kept although not indexed:** operators (`AND`, `OR`, `XOR`, `NOT`, `MOD`, `AND!`) and parts of other statements (`USING`, `AS`, `OUTPUT`, `APPEND`), which indexes don't list on their own.
- **Checked again against the full reserved-word list (Ref. pp. 9–10), Nov 18.** It has 203 words. Missing from the extension: `COPY`, `OFF` (as in `INTERVAL OFF`, used 79 times on the CD), `OPTION` and `VERTEXID` (used on the CD: `SYS_I=VERTEXID(-1)`). `VERTEX` was a misreading of the index: it isn't a keyword, and on the CD it only appears in comments. `REM` isn't in the keyword list but is already coloured as a comment. Operators missing: `NOT!`, `OR!`, `XOR!`. `AS`, `OUTPUT` and `APPEND` aren't reserved words, but `OPEN … FOR OUTPUT AS 2` uses them, so they stay. The number grammar also needs `&B` with a fraction (`&B101.01`), and doesn't need `&O` octal, which GAME BASIC doesn't have. *Done Nov 18 (not committed).*
- `OBJ` and `TPROP()` take numbered `@` fields (`@TYPE`, `@FLAG`, `@XP`…, `@ATR`, `@PARENT`, `@CHILD`, `@RADIUS`…; `@BEND`, `@LAYER`, `@TONE`, `@LOOP`, `@DPAN`…). The grammar colours any `@NAME` the same way, which covers these and the `@PAD_…` constants.

---

## 9. CD programs and tools worth knowing

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

## 10. Reference Manual basic specification (Ref. pp. 1–18)

These pages are the language definition, so they settle several things the samples only hinted at.

**Characters (p. 1).** Program text may use only character codes 32–126; codes 128–255 are allowed only inside `"…"` strings. Lower-case letters are allowed when typing but are turned into capitals when the line is stored, except inside strings. Keywords and names are not case-sensitive.

**Numbers (pp. 1–3).**
- Two types. **Fixed-point** is the default: −131071.9999 to +131071.9999, with a fraction in 1/16384 steps and 4 decimal places shown. **Floating-point** (double) is marked with a `#` suffix on the number or variable, e.g. `1.5#`, `A#`. There is no integer type.
- Below 1, fixed-point drops the leading 0 (`.123`); floating-point keeps it (`0.123`).
- Exponents: `<mantissa>E{+|-}<exponent>`, for both types.
- **Binary** `&B…`: up to 17 integer digits and up to 14 fraction digits after a `.`, e.g. `&B101.01`. **Hex** `&H…`: up to 5 integer digits (the top one 0 or 1) and up to 4 fraction digits; range −&H1FFFF.FFFC to &H1FFFF.FFFC. There is no octal form.
- A fixed-point number typed beyond the range gets `#` added automatically.
- Mixed fixed/float arithmetic becomes float. `^` always works in float. `¥` and `MOD` need fixed-point. A float that doesn't fit when converted back gives an `Overflow` error.

**Strings (p. 3).** Up to 65535 characters; joined with `+`. The manual names special kinds used by functions: binary strings (one byte per value 0–255), word strings (two bytes per value 0–65535, high byte first), "binary-form" strings of `0`/`1` and hex-form strings of `0`–`9`/`A`–`F`.

**Operators (pp. 4–5, 11).** The full list is `AND NOT OR XOR AND! NOT! OR! XOR! MOD ¥ ^ * / + - = < > <= >= <> ( )`. The `!` forms work on the fraction bits as well. `¥` (byte 0x5C, shown as `\` in ASCII) is integer division. `MOD` returns a fraction too. Comparisons give −1 (true) or 0 (false) and work on two numbers or two strings. Precedence, highest first: `()`; `^`; unary `+ -`, `NOT`, `NOT!`; `* /`; `MOD ¥`; `+ -`; comparisons; `AND AND! XOR XOR!`; `OR OR!` lowest. Equal precedence goes left to right.

**Variables (p. 6).** A name starts with a letter, then letters, digits and `_`, up to **31** characters. Type suffix: none = fixed-point, `#` = float, `$` = string. Arrays need `DIM`, have up to 16 dimensions, and each subscript can go up to 131071 (memory permitting).

**Programs (p. 7).**
- `<line number> <statement>[:<statement>]…`. A whole line, line number included, can be at most **255 characters** (leading and trailing spaces not counted, p. 15).
- Line numbers are whole numbers **1–99999**.
- Labels start with `*`, then a letter, letters, digits and `_`, up to 31 characters. A label goes right after the line number. Any command that takes a line number also takes a label. A label may be defined only once.

**Memory (pp. 7–8).** Memory is counted in 256-byte blocks. `FRE(0)` = free program area. The user area is reserved with `CLEAR`, read and written with `USERDATA`, `POKE` and `PEEK`, and saved and loaded with `BSAVE`/`BLOAD`; `FRE(1)` gives what's left. The file area, also reserved with `CLEAR`, limits the size of any file a program can read or write; `FRE(2)` and `FRE(3)` report it.

**Devices and files (pp. 8–9).**

| Device | Meaning |
|---|---|
| `BRAM:` | Saturn internal backup RAM |
| `CRAM:` | Cartridge RAM |
| `FD0:` / `FD1:` | Floppy disk, partitions 1 and 2 |
| `COM:` | **The host PC's current drive. Needs the dedicated communication software `BASTERM.EXE`** |
| `CD:` | The built-in CD drive |

- File names: letters, digits and `_`, up to **8 characters**; the 9th character is `.` and the 10th is the type letter. Types: `.D` data (written by `OPEN` or `BSAVE`), `.B` BASIC program, `.0` 256-colour bitmap, `.1` 32768-colour bitmap. Only `FILES` and `FILES$()` take an explicit extension; every other command adds it automatically.
- Wildcards: `?` = one character, `*` = the rest of the 8 characters plus extension (`"*"` = `"????????.?"`). Only the first 8 characters of a search name count.
- At most **2 files open** at once, as `#1` and `#2` (the `#` is optional). Files can't be larger than the file area set by `CLEAR`.

**Reserved words (pp. 9–10).** The full list has 203 words; section 8 compares it with the extension.

**`@` constants (pp. 11–14).** `@NAME` gives a fixed value. Object fields: `@TYPE`=0, `@FLAG`=1, `@GROUP`=2, `@XP` `@YP` `@ZP`=4–6, `@XR` `@YR` `@ZR`=8–10, `@XS` `@YS` `@ZS`=12–14, `@ATR`=16, `@POLYGON`=17, `@ORDER`=18, `@TIME`=19, `@PARENT` `@CHILD` `@LEFT` `@RIGHT`=20–23, velocities `@XV`…=24–26, accelerations `@XA`…=28–30, limits `@XL`…=32–34, spin `@XRV`…=36–38, sprite corners `@XP0`…`@YP3`=48–55, screen position `@XD` `@YD` `@ZD`=56–58, `@RD`=59, `@GTEST`=60, `@RADIUS`=61, `@COLIDIST`=62, `@COLIOBJ`=63, `@MATRIX`=64. Pad bits: `@PAD_A`=&H400, `@PAD_B`=&H100, `@PAD_C`=&H200, `@PAD_X`=&H40, `@PAD_Y`=&H20, `@PAD_Z`=&H10, `@PAD_R`=&H80, `@PAD_L`=&H8, `@PAD_RIGHT`=&H8000, `@PAD_LEFT`=&H4000, `@PAD_DOWN`=&H2000, `@PAD_UP`=&H1000, `@PAD_START`=&H800. Sound (`TPROP` and others): `@BEND`, `@LAYER`, `@TONE`, `@SN`, `@EN`, `@BN`, `@FT`, `@AR` `@DR` `@SR` `@RR` `@SL`, `@EGHOLD`, `@LSLINK`, `@KS`, `@SDIR`, `@SB`, `@SS`, `@LOOP`, `@PCM8B`, `@LSA`, `@LEA`, `@RE`, `@LFOF`, `@ALFOWS`, `@ALFOS`, `@PLFOWS`, `@PLFOS`, `@MDX`, `@MDY`, `@MDL`, `@ISEL`, `@IMIX`, `@DSEND`, `@DPAN`; effects `@REV` `@DEL` `@DST`; waves `@SAW` `@SQU` `@TRI` `@NOISE`. A table like this would make good hover text.

**Editing keys (pp. 15–18).**
- `100 PRINT 10/2` + Enter stores a line; `PRINT 10/2` + Enter runs it at once.
- A line longer than the screen width wraps and is joined automatically.
- **Ctrl+C** on the edit screen cancels the line being typed and moves to the next line; during `INPUT` it stops input, and while a program runs it breaks the program. So BASTERM's Stop key (Ctrl+C) is safe to send when nothing is running.
- **Ctrl+P is the "panic" key: it runs `SCREEN 0` and brings back the text screen.** F12 is defined as `CHR$(16)`, which is Ctrl+P, so F12 and Ctrl+P do the same thing.
- Other control keys: Ctrl+H Backspace, Ctrl+V Insert, Ctrl+G Delete, Ctrl+B Home, Ctrl+N End, Ctrl+I Tab (jump to matching bracket), Ctrl+Q clear screen (Shift+Home), Ctrl+U restore the previous line (Shift+End), Ctrl+W/Ctrl+Z show the previous/next program line, Ctrl+D/S/E/X cursor right/left/up/down, Ctrl+F/Ctrl+A next/previous word, Ctrl+M Enter, Ctrl+J new line below, Ctrl+K delete to end, Ctrl+L paste what Ctrl+K deleted, Ctrl+T delete word.

**Function keys at start-up (p. 18), set with `FKEY`.** F1 `EDIT .`⏎, F2 `EDIT`⏎, F3 `LIST `, F4 `LIST`⏎, F5 `RUN`⏎, F6 `DELETE `, F7 `CONT`⏎, F8 `FILES"`, F9 `RENUM`, F10 `LOAD"` followed by cursor moves, F11 `FIND"`, F12 Ctrl+P. Most start with `CHR$(10)`.

**Soft reset (p. 18).** If BASIC locks up, hold A+B+C and press Start on the lowest-numbered pad: BASIC restarts showing `HOT START`. Do it again to go to the Saturn's multiplayer screen. The program may not survive.

---

## 10a. Reference Manual command pages (Ref. pp. 23–32)

Scans 25–34 (Ref. p. = scan − 4). Scan 26 is blank.

**Notation (p. 23).** `[]` optional; `<>` required, unless inside an outer `[]`; `{a|b}` choose one (in the sound chapters `{}` means "can repeat"). When a middle parameter is left out and a later one follows, keep its comma. These rules are what `src/reference.js` follows.

**Each page gives** the type (statement, string function, fixed-point or float function), what it does (機能), syntax (書式), examples, parameters, return value and details.

| Word | Syntax | Notes | Page |
|---|---|---|---|
| ABS | `ABS(<numeric expression>)` | Keeps fixed/float type | 24 |
| ASC | `ASC(<string expression>)` | Code of the first character | 24 |
| ATN | `ATN(<ratio>)` | Radians, float result | 25 |
| BIN$ | `BIN$(<numeric expression>[,<suppress>])` | Leading space if not negative, `-` if negative; `.` between integer and fraction. Suppress: 0 no padding (default), 1 pad integer part, 2 pad fraction, 3 both | 25–26 |
| BINHEX$ | `BINHEX$(<source string>[,<separator>])` | 2 hex digits per character; first character of the separator between pairs | 26–27 |
| BITW$ | `BITW$(<source string>,<input bit width>,<output bit width>[,<add value>])` | Widths 4, 8 or 16; for converting the colour depth of dot data | 27–28 |
| CHR$ | `CHR$(<character code>)` | 0–255. Control codes: &H05 erase to end of line, &H09 tab, &H0A LF, &H0B home, &H0C clear screen, &H0D CR, &H13 scroll down, &H1C–&H1F cursor right/left/up/down | 28 |
| CINT | `CINT(<numeric expression>)` | Rounds halves away from zero (−0.5 → −1); keeps type | 29 |
| CLEAR | `CLEAR [<blocks>[,[<file area 1>][,<file area 2>]]]` | Direct or program statement. File areas 1–2048 blocks. Examples `CLEAR 10`, `CLEAR 100,256,256`, `CLEAR ,,1024` | 29–30 |
| CONT | `CONT` | Direct command only. Won't resume if the program was changed after it stopped (error 17), so a send ends any chance of CONT | 31 |
| COS | `COS(<angle>)` | Radians, float result | 31 |
| DATA | `DATA [<data item>][,[<data item>]...]` | Program only. Quote strings holding `,` `:` or spaces; a `"` can't be included; left-out items are 0 or "" | 31–32 |
| DATE$ | `DATE$` | Year, month, day, weekday, hour (24 h), minute, second; the exact layout continues on p. 33 | 32 |

**CLEAR (p. 30), useful for the sender.** CLEAR wipes variables, undeclares arrays, closes open files and resets FOR/GOSUB stacks. File areas are counted in 256-byte blocks, 1–2048, and default to 256 (64 KB) when left out; they set the largest file `OPEN` can handle. They share memory with the user area and the program store. If both file areas are 1360 or more and unused, `PLAYINIT`/`TARG` use them as a sound cache.

**For the terminal.** `CHR$(&H0C)` clears the screen and `CHR$(&H0B)` homes the cursor, so a program's output can contain these control codes. If the Saturn echoes screen text over the link (still untested), the receive view should treat them as screen controls, not text.

---

## 10b. Error messages (Ref. pp. 391–406)

Scans 393–410 (Ref. p. = scan − 4, as everywhere in this manual). Scan 393 is the Appendix title (p. 389) and scan 394 is blank; the list runs from scan 395 (p. 391) to scan 410 (p. 406).

- Codes 1–95, with 33, 38, 40 and 49 not listed: 91 messages. Error 67 "Sound: MML command error" is followed by one of 35 detail lines, such as `Bad octave value(0 <=> 8)`.
- The Saturn prints the message text exactly as listed, in English. One typo is genuine: 41 is "Unusable charactor".
- **20 Communication error** is the one for the link. The manual's fix: check the cable, check that the PC's speed matches the Saturn's setting (L+R+Z), then press the link software's connect button to reconnect.
- **50 File access error**: the PC's link software couldn't read or write the host file (a `COM:` problem on the PC side).
- **42 Buffer full**: FWRITE to BRAM:, CRAM:, FD0:, FD1: or COM: overran the buffer set by `CLEAR`.
- **15 String too long** also covers a line typed on the edit screen that is too long, which matches the 255-character limit.
- **29 Data statement**: outside DATA and comments, a missing closing `"` is added automatically, so a missing quote only fails in DATA.
- **17 Can't continue**: changing the program after a stop blocks `CONT`.
- The full table, with the cause of each error, is in `vscode-game-basic/src/reference.js` (`ERRORS`).

**For the sender.** `tools/saturn_link` now spots Saturn errors by these exact messages (`errors.py`), so program output that merely contains "error" or "not found" no longer counts as a failed send.

---

## 11. Changes made from these notes (Nov 18, not committed)

1. `PUTSPRITE` added, and `AND!` highlighted as one operator.
2. Fixed-point hex (`&H0.0E`, `&HFFFF.FFFC`) highlights as one number.
3. The mock Saturn prints `Line N`, `Ready.`, `Syntax error`, `Break at N` and 5-wide `LIST` numbers, as in the manual. It doesn't print the boot banner, which the PC never sees.
4. After a send, the sender collects what the Saturn printed. It reports `Line N` in the "Sent" message and warns if that isn't the last line sent. If anything looks like an error (`Syntax error`, `… not found` and so on), it exits with code 4, and VS Code shows "Sent, but the Saturn reported: …".
5. `OBJTYPE`, `OBJATR`, `OBJPOS`, `OBJTURN` and `FRAC` added, and `HEX$` confirmed.
6. Keyword list brought in line with the Reference Manual index (section 8), with a grammar test for the new words and for `TIME`/`MSTR$` staying uncoloured.
7. Baud-rate docs updated from Reference pp. 19–20: `USB_Serial_Connection.md` (new "Serial settings" section), `BASTERM_serial_protocol.md` (open item closed), the extension README's setup step, and the sender's "No answer from the Saturn" message, which now says where to find the setting (L+R+Z or Q+E+D).
8. Reference Manual pp. 1–18 applied: `COPY`, `OFF`, `OPTION`, `VERTEXID` and the operators `NOT!`, `OR!`, `XOR!` added; `VERTEX` removed (214 keywords); `&B` binary numbers with fractions highlighted and `&O` octal dropped.
9. Hover help: a new `src/reference.js` holds per-command syntax (manual wording, summary, page) and the `@` constant values. Hovering a keyword shows its syntax where known; hovering `@PAD_START` and the like shows the value. It is seeded with the commands whose syntax is already confirmed (`KPRINT`, `SCREEN`, `LOAD`, `FILES`, `OPEN`, `FKEY`, `FRE`, `RGB`, `PUTSPRITE`, `RENUM`, `SAVE`, `CLEAR`), and will grow as Reference Manual pages are scanned.
10. Hover syntax added from Reference pp. 23–30: `ABS`, `ASC`, `ATN`, `BIN$`, `BINHEX$`, `BITW$`, `CHR$`, `CINT`, and `CLEAR` rewritten with its argument order and defaults. A hover test for `BIN$` was added.
11. Reference pp. 31–32 and the error list applied to the extension: hover syntax for `CONT`, `COS`, `DATA` and `DATE$`; the full error table (`ERRORS`, `MML_DETAILS`, `explainError`) in `src/reference.js`; when the Saturn reports an error after a send, VS Code now adds the code and cause, e.g. "Sent, but the Saturn reported: Syntax error (error 2: the statement is written wrongly …)". Tests added for both.
12. The Python sender matches the manual's exact error messages: a new `tools/saturn_link/errors.py` (same table as the extension) replaces the old loose pattern in `link.py`, and `cli.py` adds the code and cause to "The Saturn reported: …". Two tests added (27 Python tests pass).

---

## 12. Still open

**To build.**
- Diff send, following the rules in section 6.
- A live key-send mode, with F12 as a "reset display" key.
- Optionally: a check for variable names over 31 characters; an option to auto-number from 100/10 like `RENUM`; hover notes (texture colour bit 15, `RGB` ranges); MML highlighting inside strings.

**To test on hardware.**
- Whether the Saturn echoes its screen text over the link at all. If it doesn't, change 4 above simply finds nothing.
- `FILES "COM:"`, to confirm the 0x11–0x13 directory calls and what units 0x1A/0x1B use.
- TRANSFOR.B against `saturn_link serve`, for Saturn→PC writes one byte at a time.
- Whether Receive copes with `LIST`-style leading spaces before line numbers.

**Not in the tutorial.** It has no wire-level protocol (byte formats, handshake, block sizes) and no full error-message list. It also doesn't explain status codes 1 and 2 or the difference between the two STOP modifiers. The Reference Manual may cover some of this.
