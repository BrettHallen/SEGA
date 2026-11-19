# GAME BASIC Tutorial Manual: reference notes for the BASTERM replacement

These are notes from the whole Japanese *GAME BASIC for SEGASATURN Tutorial Manual* (チュートリアルマニュアル). They are read with a PC-side replacement for BASTERM in mind, alongside `BASTERM/BASTERM_serial_protocol.md`. Notes on the *Reference Manual* are in `Reference_Manual_findings.md`.

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

**Software keyboard (pp. 7–8).** It has four pages, ALPH, カナ, CMD. and GRPH, each with F1–F12 along the top. CMD. has one-touch keywords (`CLS FOR NEXT STEP LOCATE PRINT IF THEN ELSE GOTO GOSUB RETURN COLOR PSET LINE CIRCLE PAINT`). GRPH has block graphics, card suits and the kanji 円年月日時分秒. The alphabet page shows `¥` where ASCII has `\`, as in Shift-JIS (JIS-Roman).

**Saturn keyboard (pp. 9, 20).** It has F1–F12, Esc, Caps Lock, Ctrl, Alt, Shift and arrow keys. It is a Japanese (JIS) layout: `"` is Shift+2. That matters for a live key-send mode that maps PC keys to Saturn keys. It doesn't matter for sending text, which goes as character codes.

**Break (p. 28).** Ctrl+C on the keyboard or A+Start on the pad. The Saturn prints `Break at 130` (the line it stopped on), then `Ready.`. This explains BASTERM's STOP: it sends key byte **0x03, which is Ctrl+C**, with modifier 4 or 5.

**F12 restores a readable screen (Tutorial pp. 60, 165; Reference p. 20).** F12, or Ctrl+P, resets the edit screen to the "Edit width" text area from the settings screen. That is why it cancels `MOSAIC ON` and why in key-send mode it turns polygon display off. `SCREEN` doesn't change the edit width. A key-send mode or a "Reset display" command should be able to send it (F12 is 07,07 in the key table; Ctrl+P would also do).

**Soft reset (Reference p. 19).** A+B+C+Start shows `HOT START` instead of the boot message. It reinitialises variables, file buffers and the user area as if by `CLEAR 0,64,64`, and resets sound memory to its power-on state. The program itself may not survive.

**Launcher (p. 105).** Shift+F1 on the keyboard (L+F1 on the software keyboard) starts LAUNCH.B, a file picker. A or Tab changes device, Start or Enter runs the file, and A–Z, 0–9 or F4 search.

**Music survives Break (p. 128).** T_KANADE.B relies on the last BGM staying in sound memory after a Break. So stopping a program from the PC won't silence its music.

---

## 4. What the Saturn prints

This is what a PC terminal sees, and what a sending tool can read back after a send.

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
- `LOAD "…",R` loads and runs (used for every sample, pp. 89–143). `LOAD "…",M` merges without `NEW` (p. 171). A PC tool can type these after a send.
- `NEW` clears the program in work RAM, and so does power-off. The manual recommends `NEW` before typing a new program, which matches BASTERM's plain `LOAD` doing a `NEW` first (pp. 24, 29).

**`COM:` is a full device, not only for LOAD.**
- `FILES "COM:"` should make the Saturn use BASTERM's directory search: 0x11 (first), 0x12 (next) and 0x13 (end), then the two disk-space requests 0x1A and 0x1B. The `Free size … / … file blocks` line fits those last two as "free" and "total". This is still inferred, because the manual never shows `FILES "COM:"`. LAUNCH.B can list `COM:` but leaves it out by default because it is slow (`MAX_DEVICE=5 :'COM:を含める場合は6但し遅い`).
- The file dialogs in T_KAMI.B, T_OTO.B and T_HIBIKI.B offer all six devices, including `COM:` (p. 132).
- **TRANSFOR.B** (p. 128) copies a `.D` data file from the Saturn "to Basterm". It is 19 lines: `OPEN B$+":"+A$ FOR INPUT AS 1`, `OPEN "COM:"+A$ FOR OUTPUT AS 2`, then one `FREAD #1,DT$,1` / `FWRITE #2,DT$` per byte. On the link this is the Saturn opening a PC file for writing and then sending data blocks, one byte per block, which is the worst case for a file server.

**BASTERM as a file server (pp. 162–165).** BASTERM's Connect must be on for programs that use `COM:` files. On disconnect, BASTERM closes any files the Saturn still has open, and later access gives an error, so programs should close files first. Send and Receive connect automatically and disconnect afterwards. Settings > Change current directory sets the PC folder that `COM:` maps to.

**File names (p. 158).** BASTERM saves `.b` and lists `*.b;*.bas`. Names should be 8 half-width characters. Longer or full-width names can be saved on the PC, but the Saturn can then reach them only through BASTERM's own Send and Receive.

---

## 6. BASTERM (Chapter 3, pp. 145–172)

**Shortcuts.** Send Ctrl+P, Receive Ctrl+G, Run Ctrl+R, Stop Ctrl+B, Key send Ctrl+K.

**Send.** BASTERM types `LOAD "COM:TBASTERM.B"` on the Saturn and serves the file (photo on p. 152). The send order is: save, filter, number lines, check, diff, then `LOAD` or `LOAD,M`.

**Receive (p. 163).** It replaces the editor contents and keeps the file name. If `SAVE "COM:…"` writes the same format as `LIST`, received lines will start with spaces before the line number.

**Run and Stop (p. 164).** Run sends `RUN`, stopping the program first if it is running. Stop keeps sending the stop key until the program stops. BASTERM's display of whether a program is running is approximate.

**Key send (pp. 156, 165).** Ctrl+K starts it, and Alt+K or a click ends it. No other command works while it's on. F10 and Ctrl+Break can't be sent. During heavy polygon drawing, keys can be dropped or garbled. Pressing F12 turns polygon display off, and neither `CONT` nor direct commands bring the polygons back. It only works with GAME BASIC.

**Line numbering (pp. 170–171).** A numbered line resets the counter. `*label` lines are rounded up to the label interval. Blank lines become `'` when numbering and are dropped otherwise. `#include "FILE"`, written without a line number, is a BASTERM-only directive (p. 172).

**Checks before sending (p. 171).** Missing, duplicate or invalid line numbers, and too many characters per line. The manual gives no figure for the line limit.

**Diff send (pp. 169–171).**
- Only changed lines go, with `LOAD …,M`.
- A full `LOAD` is used after opening a file and after a cancelled send.
- If the diff would be too big it falls back to a full send. Shift+Send forces a full send.
- BASTERM can't see edits made on the Saturn, so diffs can drift. "Always issue LOAD,M" overrides the automatic choice.
- A fixed line number at the start of data sections keeps later numbering stable and diffs small.

**Send settings (p. 169).** Run after send; key send after Run; diff send; add line numbers (start, step and `*` label interval); show errors after send (on); stop on errors (on); keep `ERRORLOG.TXT`; keep `TBASTERM.B`; always `LOAD,M`. The temp-file name must be an 8.3 name ending `.B`, because it becomes the `LOAD`/`SAVE` argument.

**Filter (pp. 166–168).** MS-DOS console programs only (`.com`, `.exe`, `.bat`). Defaults: input `IBASTERM.B`, output `OBASTERM.B`, folder `C:\WINDOWS\TEMP\`. Options: add stderr (on) or stdout (off) to the error log, delete temp files (on), show the console (on). The example is a structured-BASIC to line-numbered-BASIC converter.

**Kanji needs the PC (pp. 49–50).** The Saturn keyboard can't type kanji, so kanji strings for `KPRINT` have to arrive in a program sent from the PC. Shift-JIS string literals are a core use of BASTERM. Sequence: `KLOAD ON` loads the kanji font from the CD (using work RAM), then `KPRINT "せがた三四郎"`.

---

## 7. Language and syntax

**Rules (pp. 19–27).**
- Variable names can be up to **31 characters**. `LET` is optional, string variables end in `$`, and `A$+B$` joins strings.
- Keywords use letters, digits and some symbols. Kana and kanji belong only in strings and comments; half-width katakana in `'` comments is normal in listings.
- `:` separates statements. `*LOOP` labels with `GOTO *LOOP` are recommended over line numbers, because renumbering changes the numbers.
- `RENUM` with no arguments renumbers from **100 in steps of 10** and updates `GOTO` targets (p. 34).
- `LIST 10` lists one line for editing, and `DELETE 10` removes it.

**Forms that the editor has to accept.** All of these are in the manual or on the CD:
- Fixed-point hex: `&H0.0E`, `&HFFFF.FFFC` (pp. 55, 155).
- `AND!`, a fixed-point AND: `N=(N+&H0.001) AND! &HFFFF.FFFC` (p. 55).
- Multi-value assignment: `OBJ(3,@XP0) = x0,y0, x1,y1, …` and `OBJ(I,XP)=0,0,0` (Chapter 2 samples, p. 155).
- `@` names, both as `OBJ` fields (`OBJ(P,@ORDER) = 0`) and as pad constants (`IF PDL AND @PAD_START THEN …`, `@PAD_LEFT`, `@PAD_A`), pp. 94–98. The older form uses plain variables as field numbers (`TYPE=0: OBJ(n,TYPE)`), and fields can also be numbered directly (`OBJ(1,37)=.03`).
- Block `IF … THEN` on its own line, closed by `ENDIF` on a later line (p. 103).
- Leading commas (`SCREEN,,,2`, `COLOR,,,RGB(…)`), negative arguments (`EFFECT -4`), `*LOOP: LOCATE 0,0`, and code indented after the line number.
- `TIME` is an ordinary variable: the manual calls it "the variable TIME" (変数TIME, p. 98).

**Printed listings wrap long lines** (for example `1260 … THEN LINE` / `-(XP,YP),…` on p. 103). When typing a listing in from the book, join these back into one line.

**Graphics notes.**
- `SCREEN [mode][,text BG][,text colours][,frame unit]`, modes 0–6. The character screen is 39×26 cells and the bitmap is 320×224 (pp. 41–44). Mode 5 is the 3-axis rotation BG with a 256×256-character field (p. 91).
- `RGB(r,g,b)` uses 0–31 per channel, giving r + g×32 + b×1024. Texture colours need bit 15 set: `RGB(31,0,0) OR &H8000` = `&H801F` (p. 66).
- Polygon vertices go clockwise for a front face (p. 66). `ROTATE` angles are in turns (0.25 = 90°), not radians as the text says.
- `KPRINT [(x,y[,xpitch,ypitch,halfwidth])],[FIX][string][;][,colour][,SCALE][,bgcolour]` (p. 50).
- `CAMERA … TO TARGET,BG` has a trailing `BG` that may be an option word. There's only one example here; the Reference Manual (p. 165) defines it as an option that also sets the 3-axis rotation screen.

**Sound (pp. 79–86, 91).**
- MML goes inside a string and plays with `EFFECT "…"`, e.g. `EFFECT "@35 CDEF @36 GAB"`. Notes `A`–`G`; `#` or `+` sharp, `-` flat, `n` natural; `R` rest; `O` octave and `<` `>` octave down/up; lengths `1`–`128` with up to three dots; `( )` chords; `@n` instrument; `v` (0–15) and `@v` (0–127) volume. The Reference Manual covers the rest on pp. 323–342 (`L`, `T`, `Q`, `K`, `P`, `S`, dynamics `p`…`f`, loops `:|`).
- `EFFECT n,0,"@10 %1 C"` stores a sound in slot n, and `BGM n` plays it.
- BASIC spreads 16 tracks over the Saturn's 32 sound channels. Pan commands do nothing when the Saturn's audio is set to mono.
- Since MML is always inside strings, it doesn't affect the keyword list.

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

## 9. Open questions

**Not settled by the manual; to check on hardware.**
- Whether the Saturn echoes its screen text over the link at all.
- `FILES "COM:"`, to confirm the 0x11–0x13 directory calls and what units 0x1A/0x1B use.
- What `FILES "COM:"` and `DSKF("COM:")` show for free space, which the Reference Manual counts in 64-byte blocks.
- TRANSFOR.B against a PC file server, for Saturn→PC writes one byte at a time.
- Whether Receive copes with `LIST`-style leading spaces before line numbers.

**Not in the tutorial.** It has no wire-level protocol and no full error-message list. The Reference Manual covers the error messages (see `Reference_Manual_findings.md`, section 7). The wire protocol is derived from Basterm.exe in `BASTERM/BASTERM_serial_protocol.md`: byte formats, keystroke packets, 252-byte data blocks with checksum and CRC-16, the handshake, the command table and the timeouts.

**Status codes.** From the same analysis, status 3 means a program is running (it drives the check mark on the Run menu item) and status 4 means a command has finished (BASTERM beeps, and Send and Receive wait for it). BASTERM treats 1 and 2 only as "not running" and never tells them apart, and it sends both STOP modifiers (4 and 5) in exactly the same way. What 1 and 2 mean, and whether the Saturn handles the two STOP modifiers differently, can only be settled on hardware.
