# GAME BASIC Reference Manual: notes for the BASTERM replacement

> **Work in progress.** This covers these pages so far: pp. 1–20 (basic specification and system settings), Chapter 1 sections 1.1–1.6 (pp. 23–178), the start of section 1.7 (pp. 179–190), Chapter 2 sections 2.1–2.4 (pp. 229–251) and the Appendix (pp. 389–421).

These are notes from the Japanese *GAME BASIC for SEGASATURN Reference Manual* (リファレンスマニュアル), with attention to what matters for a PC-side replacement for BASTERM. Notes from the *Tutorial Manual* are in `Tutorial_Manual_findings.md`.

Page numbers are the book's own page numbers.

---

## 1. Reference Manual basic specification (Ref. pp. 1–18)

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

**Reserved words (pp. 9–10).** The full list has 203 words; see section 9.

**`@` constants (pp. 11–14).** `@NAME` gives a fixed value. Object fields: `@TYPE`=0, `@FLAG`=1, `@GROUP`=2, `@XP` `@YP` `@ZP`=4–6, `@XR` `@YR` `@ZR`=8–10, `@XS` `@YS` `@ZS`=12–14, `@ATR`=16, `@POLYGON`=17, `@ORDER`=18, `@TIME`=19, `@PARENT` `@CHILD` `@LEFT` `@RIGHT`=20–23, velocities `@XV`…=24–26, accelerations `@XA`…=28–30, limits `@XL`…=32–34, spin `@XRV`…=36–38, sprite corners `@XP0`…`@YP3`=48–55, screen position `@XD` `@YD` `@ZD`=56–58, `@RD`=59, `@GTEST`=60, `@RADIUS`=61, `@COLIDIST`=62, `@COLIOBJ`=63, `@MATRIX`=64. Pad bits: `@PAD_A`=&H400, `@PAD_B`=&H100, `@PAD_C`=&H200, `@PAD_X`=&H40, `@PAD_Y`=&H20, `@PAD_Z`=&H10, `@PAD_R`=&H80, `@PAD_L`=&H8, `@PAD_RIGHT`=&H8000, `@PAD_LEFT`=&H4000, `@PAD_DOWN`=&H2000, `@PAD_UP`=&H1000, `@PAD_START`=&H800. Sound (`TPROP` and others): `@BEND`, `@LAYER`, `@TONE`, `@SN`, `@EN`, `@BN`, `@FT`, `@AR` `@DR` `@SR` `@RR` `@SL`, `@EGHOLD`, `@LSLINK`, `@KS`, `@SDIR`, `@SB`, `@SS`, `@LOOP`, `@PCM8B`, `@LSA`, `@LEA`, `@RE`, `@LFOF`, `@ALFOWS`, `@ALFOS`, `@PLFOWS`, `@PLFOS`, `@MDX`, `@MDY`, `@MDL`, `@ISEL`, `@IMIX`, `@DSEND`, `@DPAN`; effects `@REV` `@DEL` `@DST`; waves `@SAW` `@SQU` `@TRI` `@NOISE`.

**Editing keys (pp. 15–18).**
- `100 PRINT 10/2` + Enter stores a line; `PRINT 10/2` + Enter runs it at once.
- A line longer than the screen width wraps and is joined automatically.
- **Ctrl+C** on the edit screen cancels the line being typed and moves to the next line; during `INPUT` it stops input, and while a program runs it breaks the program. So BASTERM's Stop key (Ctrl+C) is safe to send when nothing is running.
- **Ctrl+P is the "panic" key: it runs `SCREEN 0` and brings back the text screen.** F12 is defined as `CHR$(16)`, which is Ctrl+P, so F12 and Ctrl+P do the same thing.
- Other control keys: Ctrl+H Backspace, Ctrl+V Insert, Ctrl+G Delete, Ctrl+B Home, Ctrl+N End, Ctrl+I Tab (jump to matching bracket), Ctrl+Q clear screen (Shift+Home), Ctrl+U restore the previous line (Shift+End), Ctrl+W/Ctrl+Z show the previous/next program line, Ctrl+D/S/E/X cursor right/left/up/down, Ctrl+F/Ctrl+A next/previous word, Ctrl+M Enter, Ctrl+J new line below, Ctrl+K delete to end, Ctrl+L paste what Ctrl+K deleted, Ctrl+T delete word.

**Function keys at start-up (p. 18), set with `FKEY`.** F1 `EDIT .`⏎, F2 `EDIT`⏎, F3 `LIST `, F4 `LIST`⏎, F5 `RUN`⏎, F6 `DELETE `, F7 `CONT`⏎, F8 `FILES"`, F9 `RENUM`, F10 `LOAD"` followed by cursor moves, F11 `FIND"`, F12 Ctrl+P. Most start with `CHR$(10)`.

**Soft reset (p. 18).** If BASIC locks up, hold A+B+C and press Start on the lowest-numbered pad: BASIC restarts showing `HOT START`. Do it again to go to the Saturn's multiplayer screen. The program may not survive.

---

## 2. Reference Manual section 1.1, general commands (Ref. pp. 23–95)

Section 1.1 ends on p. 95 (XTAN); section 1.2, file commands, starts on p. 96. Page 22 is blank.

**Notation (p. 23).** `[]` optional; `<>` required, unless inside an outer `[]`; `{a|b}` choose one (in the sound chapters `{}` means "can repeat"). When a middle parameter is left out and a later one follows, keep its comma.

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
| DATE$ | `DATE$` | `"1997 02/27 THU 19:52:01"`: year, month/day, SUN–SAT, 24-hour time | 32–33 |
| DELETE | `DELETE {<start line>\|<label>},{<end line>\|<label>}` | Direct only; both lines must exist | 33 |
| DIM | `DIM <name>(<max>[,<max>...])[,...]` | Subscripts 0..max; up to 16 dimensions | 33–34 |
| EDIT | `EDIT [{<line>\|<label>}]` / `EDIT .` | Direct only; Page Up/Down move between lines | 34 |
| END | `END` | Closes files, clears stacks | 35 |
| ERL / ERR | `ERL` / `ERR` | Last error's line / code; reset by RESUME or a program change | 35–36 |
| ERROR | `ERROR [<error number>]` | 0–255. Bare `ERROR` right after a stop re-shows the failing line (use after F12) | 36 |
| EXP | `EXP(<numeric expression>)` | Float; argument up to about 709 | 36–37 |
| FIND | `FIND [<start>][{,\|-}[<end>]] [,]<search string>[,P]` | Direct only; Ctrl+S pause, Ctrl+C stop, Ctrl+E/X slower/faster | 37 |
| FIX | `FIX(<numeric expression>)` | Toward zero | 38 |
| FKEY | `FKEY <key>,<string>` / `FKEY PRINT` (`FKEY ?`) | Keys 1–12, up to 31 characters | 38 |
| FOR | `FOR <var>=<start> TO <end> [STEP <step>]` | Fixed-point limit ±131071.999; in direct mode the loop must fit on one line | 39–40 |
| FRAC | `FRAC(<numeric expression>)` | Fraction part | 40 |
| FRE | `FRE(<number>)` | 0 = free variable+program area; 1–3 = sizes of user area and file areas (not free space) | 40–41 |
| GOSUB / GOTO | `GOSUB {<line>\|<label>}` / `GOTO {<line>\|<label>}` | Lines 1–99999 or `*LABEL` | 41–42 |
| HEX$ | `HEX$(<numeric expression>[,<suppress>])` | Same suppress codes as BIN$ | 42 |
| HEXBIN$ | `HEXBIN$(<source string>)` | Hex text to bytes; commas allowed | 43 |
| IF | `IF <cond> THEN … [ELSE …]`, `IF <cond> GOTO … [ELSE …]`, block `IF … THEN` / `[ELSE]` / `ENDIF` | THEN followed by line end or `:` starts a block IF; ELSE IF chains allowed | 43–46 |
| INKEY$ | `INKEY$` | Key codes table (below) | 47–48 |
| INPUT | `INPUT [<prompt>,]{<string var>\|<numeric var>}[,<default>]` | Commas, colons and quotes are taken as typed | 48–49 |
| INPUT$ | `INPUT$(<number of characters>)` | 1–255 keys; all but Ctrl+C | 49 |
| INSTR | `INSTR(<target>,<search>[,<start>])` | 1-based, 0 if not found | 50 |
| INT | `INT(<numeric expression>)` | Floor | 51 |
| INTERVAL | `INTERVAL[<n>] ON [,<interval>]`, `INTERVAL[(<n>)] <interval>`, `INTERVAL[(<n>)] OFF` | Timers 0–23, 1/60 s units | 51–53 |
| LEFT$ / LEN | `LEFT$(<string>,<n>)` / `LEN(<string>)` | | 53–54 |
| LET | `[LET] <var>=<expression>` | Fixed-point range ±&H1FFFF.FFFC | 54 |
| LIST | `LIST [<start>][{,\|-}[<end>]]` / `LIST .` | Direct only; same Ctrl keys as FIND | 55 |
| LOCATE | `LOCATE [<X>][,<Y>]` | 0–127, from the WIDTH area's top left | 55–56 |
| LOCK / UNLOCK | `LOCK` / `UNLOCK` | Holds back ON INTERVAL / ON TIMER calls | 56 |
| LOG | `LOG(<numeric expression>)` | Float, argument > 0 | 56–57 |
| MID$ | `MID$(<string>,<pos>[,<len>])` and `MID$(<var>,<pos>[,<len>])=<string>` | Function and statement | 57–58 |
| NEW | `NEW` | Direct only; keeps user and file areas | 58 |
| NEXT | `NEXT [<var>[,<var>...]]` | | 59 |
| ON … | `ON ERROR GOTO {<line>\|<label>\|0}`, `ON <expr> GOSUB/GOTO/RESTORE …`, `ON INTERVAL[(<n>)] GOSUB …`, `ON TIMER[(<n>)] GOSUB …` | Interval timers 0–23, countdown timers 0–7 | 59–64 |
| PAD | `PAD(<function>[,<item>])` | Ports, device IDs, button bits (matches the `@PAD_` constants) | 64–67 |
| PEEK / PEEK$ / POKE | `PEEK(<block>,<address>)`, `PEEK$(<block>,<address>,<length>)`, `POKE <block>,<address>,{<n>\|<string>}[,...]` | User area from CLEAR | 67–68 |
| POS | `POS(<number>)` | 0 = X, 1 = Y | 69 |
| PRINT / ? | `PRINT [<expr>[[{,\|;}]<expr>...]][{,\|;}]` | `,` = next tab stop, `;` = continue; control characters act as with CHR$ | 69–70 |
| PRINT USING | `PRINT USING <format>;<expr>[{,\|;}<expr>...][{,\|;}]` | `#` `.` `+` `& &` `@` `!` `_` | 70–71 |
| READ | `READ <var>[,<var>...]` | | 72 |
| REM / ' | `{REM\|'} [<comment>]` | Not a statement separator: anything after it, `:` included, is comment | 72 |
| RANDOMIZE | `RANDOMIZE <seed>` | | 71 |
| RENUM | `RENUM [<new>][,<old>][,<step>]` | Direct only; defaults 100, all lines, 10 | 73 |
| RESTORE | `RESTORE [{<line>\|<label>}]` | | 73–74 |
| RESUME | `RESUME [{NEXT\|<line>\|<label>}]` | No line number in direct mode | 74 |
| RETURN | `RETURN` | | 74 |
| RIGHT$ / RND | `RIGHT$(<string>,<n>)` / `RND(<limit>)` | RND gives 0..limit−1 | 75–76 |
| RUN | `RUN [{<line>\|<label>}]` | Resets variables, files, timers, USERDATA, sound cache | 76 |
| SGN / SHIFT | `SGN(<n>)` / `SHIFT` | SHIFT bit table for the Saturn keyboard; BASTERM sends Shift = &H3, Ctrl = &HC | 77–78 |
| SIN / SKCLOSE / SPACE$ | `SIN(<angle>)`, `SKCLOSE`, `SPACE$(<length>)` | | 78–79 |
| SQR / STOP / STR$ | `SQR(<n>)`, `STOP`, `STR$(<n>[,<suppress>])` | STR$ suppress as BIN$/HEX$ | 80–81 |
| STRING$ / STRW$ | `STRING$(<count>,{<n>\|<string>})`, `STRW$(<count>,{<n>\|<string>})` | One character / a whole pattern | 81–82 |
| SWAP / TAN | `SWAP <var1>,<var2>`, `TAN(<angle>)` | | 83 |
| TIMER | `TIMER[(<n>)] ON [,<time>]`, `TIMER[(<n>)] <time>`, `TIMER[(<n>)] OFF` | Countdown timers 0–7, one-shot | 84–85 |
| USERDATA | four forms, plus `USERDATA(<0-3>)` | DATA kept in the user area, for BSAVE/BLOAD | 86–88 |
| VAL / VERSION | `VAL(<string>)`, `VERSION` | VAL takes `&H` and `&B` | 89 |
| WADD$ / WANDOR$ / WMUL$ / WXOR$ | `WADD$(<s>,<add>[,<start>])`, `WANDOR$(<s>,<and>,<or>[,<start>])`, `WMUL$(<s>,<mul>[,<start>])`, `WXOR$(<s>,<xor>[,<start>])` | Treat a string as 16-bit words | 90–92 |
| WIDTH | `WIDTH [<left>],[<top>][,<right>][,<bottom>]` | 0–127; SCREEN resets to 1,1,38,26; Ctrl+P resets to the system setting | 91 |
| XATN / XCOS / XSIN / XTAN | `XATN(<x>,<y>)`, `XCOS(<angle>)`, `XSIN(<angle>)`, `XTAN(<angle>)` | Fast fixed-point trig; angles in turns (1.000 = 360°) | 93–95 |
| XDIST / XSQR | `XDIST(<XP>,<YP>[,<ZP>])`, `XSQR(<n>)` | | 94–95 |

**Key codes the Saturn sees (INKEY$, pp. 47–48).** This matters for a live key-send mode. Backspace 8, Tab 9, Home 11, Insert 18, End 24, Esc 27, right 28, left 29, up 30, down 31, Delete 127, F1–F12 224–235 (&HE0–&HEB), Page Up 250, Page Down 251. The manual notes that **F10 can't be sent from BASTERM**. The F-key codes are shared with some graphic characters.

**Other points for the terminal.**
- `DELETE`, `EDIT`, `FIND`, `CONT` are direct-only, so they make sense as terminal commands but not in a sent program.
- After a program stops on an error, F12 then `ERROR` + Enter re-shows the failing line, so a terminal can offer it as one command.
- Ctrl+S / Pause, Ctrl+C, Ctrl+E and Ctrl+X control `FIND` and `LIST` output, so a terminal should pass these through.

**CLEAR (p. 30), for file transfers.** CLEAR wipes variables, undeclares arrays, closes open files and resets FOR/GOSUB stacks. File areas are counted in 256-byte blocks, 1–2048, and default to 256 (64 KB) when left out; they set the largest file `OPEN` can handle. They share memory with the user area and the program store. If both file areas are 1360 or more and unused, `PLAYINIT`/`TARG` use them as a sound cache.

**For the terminal.** `CHR$(&H0C)` clears the screen and `CHR$(&H0B)` homes the cursor, so a program's output can contain these control codes. If the Saturn echoes screen text over the link (still untested), the receive view should treat them as screen controls, not text.

---

## 3. Sections 1.2 and 1.3, file commands and functions (Ref. pp. 96–115)

Section 1.2 (file commands) runs pp. 96–112 and section 1.3 (file functions) pp. 113–115. Section 1.4 (BG, text and bitmap screens) comes next.

**General rules (pp. 96–97).**
- Devices: `COM:` (the PC), `BRAM:` (internal RAM), `CRAM:` (cartridge RAM), `FD0:`/`FD1:` (floppy partitions 1 and 2), `CD:`. Leaving the device out means the last one used.
- File names are `XXXXXXXX.Y`: a base of 1–8 characters from A–Z, 0–9 and `_`, with no spaces; lower case is made upper case. When a period is given the base is padded with spaces to 8 characters (a PC-side file server has to strip this padding).
- Extensions: `B` program, `0` 256-colour bitmap, `1` 32768-colour bitmap, `D` anything else. SAVE/LOAD add `B`, GSAVE/GLOAD add `0` or `1`, everything else adds `D`. `FILES`/`FILES$` accept `*` as the extension.
- Only 2 files can be open (numbers 1 and 2). Ending the program, or any error, closes and discards open files, and FWRITE data only reaches the file at CLOSE.
- **Busy Saturn:** "If LOAD, SAVE or other reads and writes to the PC are run while the Saturn is under heavy load, they may not work. Then press Ctrl+P or F12, or run SCREEN 0." This note appears four times in the section.

**For the PC link and file transfer.**
- **LOAD (p. 109).** `.B` is always added, even if another extension is typed. `M` merges over `COM:`: lines with the same number are replaced, new ones added, and lines without a line number are ignored. A text program made outside the Saturn needs CR+LF at the end of every line (CR is ignored and LF ends the line). Files sent to the Saturn therefore need `\r\n` line ends. An error during a plain LOAD loses the program in memory, because memory is cleared first.
- **SAVE is direct-only (p. 111).** It can't be used inside a program; Receive types it, so that is fine. `SAVE "…",A` (text as `.D`) works only on FD0:, FD1:, BRAM: and CRAM:, not on COM:.
- **FILES over COM: (pp. 100–101).** It shows names in 12-character columns and, except on CD:, a last line "Free size <free> / <total> file blocks", where 1 block is 64 bytes. `FILES$` puts spaces in place of the size on COM:. `DSKF("COM:")` also returns free space in 64-byte blocks, so a PC-side file server should report free space in those units.
- **Directory listing.** PC file names that break the Saturn rules (over 8 characters before the dot, a dash, a space, other extensions) can't be loaded, so a file server's listing is only useful when limited to valid `XXXXXXXX.Y` names.
- **Slow transfers.** `GSAVE` of a large area to `COM:` takes 1–2 minutes or more (p. 107). GLOAD/GSAVE need a free file buffer from `CLEAR` larger than the picture: 282 blocks (.0) or 560 blocks (.1) for 320 × 224.
- **Bitmap file format (pp. 105–106).** `.0`: width and height (2 bytes each, high byte first, up to 512 × 256), a 512-byte palette (256 RGB words), then 1 byte per dot with 0 transparent. `.1`: width, height, then 2 bytes per dot, high byte first, with bit 15 set (black is &H8000; 0 is transparent). Colour words are 5 bits each: red in bits 0–4, green 5–9, blue 10–14. A PC-side PNG ↔ `.0`/`.1` converter would be straightforward from this.
- Misprint: p. 113 says "Device no connected"; the error list (code 43) has "Device not connected".

---

## 4. Section 1.4, BG, text and video commands (Ref. pp. 116–156)

Section 1.4 runs from p. 116 (ACTIVE) to p. 156 (ZOOM).

- **Logical BG numbers** (pp. 117–118): 0 and 1 bitmap screens, 2 bitmap rotation screen, 4–7 character screens 0–3, 8 and 9 character rotation screens, 10 and up sprites/polygons. A SETTEX texture is texture ID + 10. `ACTIVE` sets the default; bitmap and character defaults are kept separately.
- **GCOPY strings (pp. 126–127)** are the same layout as the bitmap files: a `.1` file is exactly a 32768-colour GCOPY string, and a `.0` file is a 256-colour GCOPY string with the 512-byte palette inserted after the size. So a bitmap file can also feed GCOPY when loaded from a `.D` file.
- **Default display priorities** (p. 138): bitmaps 2, character screens 6/5/4/3, rotation 1, sprites 6; an 8th sprite priority register belongs to the virtual keyboard and is fixed at 7.
- **KLOAD** (pp. 127–128) takes 722 blocks (level 1) or 991 blocks (levels 1 and 2) from the program area and does `CLEAR 0,256,256`, so it belongs at the top of a program.
- **F12** restores the text screen after `DISPLAY OFF 4` or `MOSAIC ON 4` (pp. 124, 133), more support for the F12 key in a live mode.
- Misprint: the PRIORITY syntax box says `PRIORYTY`.
- **Screen modes** (pp. 148–150): 0 = bitmap 0 (32768 colours) + character screens 4, 5; 1 = bitmaps 0, 1 (256 colours) + 4, 5; 2 = 4, 5 + rotation 8 (Z axis, 256×256 characters); 3 = bitmap rotation 2 (Z axis) + 4, 5; 4 = character screens 4–7 (256 colours); 5 = 4, 5 + rotation 8 (3-axis); 6 = 4, 5 + rotation 8 and 9 (3-axis, sharing palette and patterns). The virtual keyboard uses the last 16 colours of BG 8 in mode 2.
- **What SCREEN resets** (pp. 147–148): VRAM, scroll, zoom, priorities, rotation, palettes, text font, WIDTH 1,1,38,26, WINDOW 0,0,319,223, ACTIVE, LINE start, OBJ, textures (image data kept), vertices, polygons, attributes, SPRWINDOW.
- **A hang worth knowing about** (p. 147): with a frame unit of 2 or more without waiting, an OBJECT with over about 1000 polygons can stop sprites and leave the keyboard dead even after Ctrl+P or SCREEN. Soft reset (A+B+C+Start) keeps the program in memory. The PC side would just see the Saturn stop answering.
- **SETCHR … READ** (p. 153) reads character patterns from hex `DATA` strings, so a PC tool can turn a picture into ready-to-send DATA lines.

---

## 5. Section 1.5, BG, text and video functions (Ref. pp. 157–164)

Pages 157–164: GETCHR, PALETTE(), POINT, READCHR$, READHEX$, RGB, RGBADD, RGBTO.

- **READHEX$ (p. 161)** confirms the hex DATA layouts: `DATA 12345678` is read as bytes 12,34,56,78, the same as `DATA 12,34,56,78`. Like `SETCHR …,READ` and `SETTEX …,READ`, it skips the rest of the last DATA line it reads from.
- **POINT** returns −1 for transparent and −2 off the screen, and isn't limited by WINDOW.
- **RGBADD / RGBTO** step colours for fades, clamped to 0–31 per part; RGB() keeps only the low 5 bits of each part.

---

## 6. Section 1.6, sprite and 3D commands (Ref. pp. 165–178, first part)

Pages 165–178: CAMERA, PUTSPRITE, SETDISP, SETLIGHT, SETPERS, SETPFONT, SETPOLYGON, SETSPRITE, SETVERTEX, SPRITE$, SPRWINDOW. Pages 165–166 also open the section with the general rules.

- **Numbers and angles.** 3D coordinates are fixed point, about ±&H7FFF.FFFC. Angles are in turns (0–1); the whole part is dropped.
- **Steps to show a polygon object:** SETVERTEX → SETPOLYGON → SETTEX (optional) → SETATR → give the OBJECT its polygon and attribute → position → parent (usually 0) → TYPE 4/5/6. With only TYPE set, BASIC links it to OBJECT 0 and shows a built-in cube. SETPFONT and PUTSPRITE do all of this for you.
- **Steps for a sprite:** SETTEX → SETATR → give the attribute → position → TYPE 1/2/3 → parent. A sprite whose Z is too close to the viewpoint disappears.
- **SPRITE$ (p. 177)** takes a 256-byte string, one byte per dot of a 16×16, 256-colour pattern. The bytes are in plain row order, unlike SETCHR's 8×8 cells: the manual doesn't say, but `G_BOMB.B` builds its patterns that way (16 rows of 16 bytes, colours from `PALETTE 10,1,…`).
- **SPRWINDOW** defaults to 0,0,319,223, ZLIMIT &H7FFF, centre (160,112). `SPRWINDOW ,,,,,0,0` moves the sprite origin to the top left.
- **IDs must be defined in order from 0** for SETVERTEX and SETPOLYGON; VERTEXID(-1) and POLYGONID(-1) give the next free one. SCREEN clears all of it.
- **Two likely misprints.** The SETPOLYGON syntax-box example `SETPOLYGON 1,16,READ` leaves out the vertex ID (p. 174 uses `1,6,0,READ`). PUTSPRITE (p. 168) says the pattern must be defined with SETSPRITE; it means SPRITE$. `G_BOMB.B` on the CD defines its patterns with SPRITE$ only and then calls PUTSPRITE with no SETSPRITE at all.

These pages don't affect the serial link.

---

## 6a. Section 1.7, OBJ commands (Ref. pp. 179–190, first part)

The per-item descriptions continue past p. 190; only TYPE is covered here.

- **OBJ is the table behind every sprite and polygon.** Each object number has numbered items. `OBJ(n,<item>)=` writes them and `OBJ(n,<item>)` reads them. OBJPOS, OBJROT and the other OBJ… commands are shorthands, so `OBJPOS 1,X,Y,Z` is the same as `OBJ(1,@XP)=X,Y,Z`. Extra values go into the following items, and an empty one is skipped.
- **Forms:** `OBJ COPY <from> TO <to>[,…]`, `OBJ CLEAR`, `OBJ NEW` and `OBJ PRINT n[,P]` (or `OBJ ?`). P pauses the listing.
- **Special object numbers:**
  - −1 is the "shredder": giving an object parent −1 deletes it.
  - 0 is the world/viewpoint: an object needs parent 0 to be shown.
- **Value ranges (p. 180):**
  - Positions, speeds and scales are fixed point up to about ±&H7FFF.FFFC. Bits above the 16-bit whole part are dropped **without** an Overflow error, so the sign can flip.
  - Angles are 0 to &H0.FFFC. The manual calls the unit "radians" but defines it as 1.000 = 360°, so it is really turns.
- **Defaults** are the values after a program starts, `SCREEN`, `OBJ CLEAR` or `OBJ NEW`. They are TYPE 0, position and angles 0, scale 1, RADIUS 10, COLIDIST −1, and everything else 0 (p. 185).
- **OBJ CLEAR vs OBJ NEW (p. 182).** CLEAR resets the object table. NEW also sets the texture, attribute, vertex and polygon ID counts back to 0. OBJ PRINT lists an object's children; with P it stops every screenful (window height − 3 lines) at [HIT KEY], Ctrl+C stops it, and it gives up on a loop such as an object that is its own parent.
- **The item table (pp. 182–185) agrees with the `@` constant table on pp. 11–14:**
  - 0–38 are read/write, except CHILD, LEFT and RIGHT (21–23), which are read only.
  - 48–55 are the 4-point sprite corners.
  - 56–63 (XD, YD, ZD, RD, GTEST, RADIUS, COLIDIST, COLIOBJ) are mostly read only.
  - 64–75 are the read-only perspective matrix M00–M32.
  - That makes 39 read/write items and 20 read-only ones.
  - The alias commands are OBJTYPE (0), OBJPOS (4–6), OBJROT (8–10), OBJZOOM (12–14), OBJATR (16–17), OBJLINK (20) and OBJTURN (36–38).
- **Starting links (p. 186).** Object −1 has every object as its children, chained as siblings (1 ↔ 2 ↔ 3 …). Object 0, the world, starts at ZP 200, which puts the viewpoint 200 in front of the world origin. `OBJ(0,@ZP)=0` makes them the same, and you then give each object a depth of about 200. The manual lists the last object's child as "1", which is presumably a misprint for −1.
- **TYPE 0–7 (pp. 187–190):**
  - 0: hidden (the default). Its children still show.
  - 1: sprite with one scale and Z rotation. A negative scale is worked out from Z and SETPERS.
  - 2: sprite with X/Y scale. A negative scale flips it.
  - 3: 4-point sprite. The corners go clockwise from top left, as offsets from XP/YP.
  - 4: 3D polygon with perspective.
  - 5: 3D polygon, orthographic, with no lighting or clipping.
  - 6: an invisible pivot, used to rotate children and for collision tests.
  - 7: orthographic sprite, used inside BASIC by SETSPRITE/PUTSPRITE. It allocates 4 vertices, 1 polygon and 1 attribute and shows a square.
  - Types 1–3 ignore parent rotation and movement and are placed around SPRWINDOW's CX,CY.
  - Setting a type on an unused object (parent −1) links it to object 0 automatically. Types 4 and 5 then show the built-in cube until a polygon is set.

## 6b. Chapter 2, sound reference, sections 2.1–2.4 (Ref. pp. 229–251)

Pages 228 and 230 are blank, and p. 229 is the Chapter 2 title page.

These pages explain how the sound system works. The command pages (2.5 onwards, including PLAY, EFFECT, PLAYINIT, TARG and TPROP) are not covered here.

- **Two systems.** BASIC runs on the SH-2. Music runs separately on the 68EC000 sound CPU with its own 512 KB of memory. That memory is checked with `SFRE()`/`TFRE()`, not `FRE`.
  - PLAY, EFFECT and SETSONG turn MML into "song data" in sound memory before playing.
  - `PLAY` waits until its line of MML has finished. `EFFECT` and `BGM` play in the background, independently of BASIC.
- **Limits:**
  - Up to 251 songs (plus song 0 for BEEP and one for PLAY), and up to 8 of them playing at once.
  - Sequence 0 is kept for BGM. PLAY and EFFECT get sequences 1–7: `EFFECT (I),"…"` returns the number in I for `PLAYFADE I,…`.
  - 16 tracks per song, with chords allowed within one track. 32 slots, so 8 notes at once for 4-operator FM. 26,000 notes.
- **Song 0 is the BEEP sound**, which also plays on errors and Break, so a program can change the error sound. Commands that take a song number default to 1.
- **Notes follow MIDI:** C4 (O4 C) = 60, A0 = 21, C8 = 108. MML note names cover C0–B8; other notes need the `N` command.
- **MML is mostly compatible with older PC MML.** On top of that it adds key signatures (`S`), velocity/gate/delta options, pitch bend, chord names, 52 user macros of up to 128 characters, transposition, score-style repeats, and the effect commands `ec` (choose effect), `el` (effect level) and `ep` (effect pan). Register-level commands from older MML don't carry over, and there is no PSG.
- **Sound memory (p. 244):** 468 KB for the user, in 1,872 blocks of 256 bytes.
  - Voice data is 340 KB by default, up to about 462 KB.
  - The song (MML) area is 128 KB by default.
  - The DSP areas are 40 KB for `PLAYINIT "DSP"` and 72 KB for `PLAYINIT "DSPEXT"`.
  - `PLAYINIT` resizes the areas in single blocks.
- **Effects (pp. 246–249):**
  - With no DSP, only the dry path is used: TPROP items 72 (send level) and 73 (pan), then the `VOLUME` master.
  - `PLAYINIT "DSP"` gives one effect at a time, picked by `ec`: 0 reverb 1, 1 reverb 2, 2 delay, 3 distortion.
  - `PLAYINIT "DSPEXT"` runs reverb, delay and distortion together, on inputs 0–2 (`@REV`, `@DEL`, `@DST`) and outputs 0–1, 2–3 and 4. Distortion is mono and loud, so turn it down with `el`.
  - A voice reaches an effect when TPROP item 70 (`@ISEL`, input select) points at it and item 71 (`@IMIX`, input mix level) is above 0.
- **Pan priority (p. 251):** `PLAYPAN` beats MML `P`, which beats TPROP 73. An `@` voice change resets `P`. Pan does nothing when the Saturn's settings screen is set to mono.
- **Own samples.** `TARG` can register AIFF or WAVE files (8- or 16-bit mono, detected automatically) as voice data, or raw wave data from `DATA` lines. 11 or 22 kHz samples play at the right pitch with TPROP.

**For the PC link.** These pages don't say where TARG reads AIFF/WAVE files from. If `COM:` works, a sample would travel as a `.D` file, converted on the PC to mono 8- or 16-bit. While `PLAY` is running BASIC doesn't take the next statement, so a stop request may wait until the end of that line of music.

---

## 7. Error messages (Ref. pp. 391–406)

Page 389 is the Appendix title and p. 390 is blank; the list runs from p. 391 to p. 406.

- Codes 1–95, with 33, 38, 40 and 49 not listed: 91 messages. Error 67 "Sound: MML command error" is followed by one of 35 detail lines, such as `Bad octave value(0 <=> 8)`.
- The Saturn prints the message text exactly as listed, in English. One typo is genuine: 41 is "Unusable charactor".
- **20 Communication error** is the one for the link. The manual's fix: check the cable, check that the PC's speed matches the Saturn's setting (L+R+Z), then press the link software's connect button to reconnect.
- **50 File access error**: the PC's link software couldn't read or write the host file (a `COM:` problem on the PC side).
- **42 Buffer full**: FWRITE to BRAM:, CRAM:, FD0:, FD1: or COM: overran the buffer set by `CLEAR`.
- **15 String too long** also covers a line typed on the edit screen that is too long, which matches the 255-character limit.
- **29 Data statement**: outside DATA and comments, a missing closing `"` is added automatically, so a missing quote only fails in DATA.
- **17 Can't continue**: changing the program after a stop blocks `CONT`.

**For the PC link.** Because the messages are fixed, a PC tool can recognise a Saturn error by matching these exact strings, rather than any output that merely contains "error" or "not found".

---

## 8. Rest of the Appendix (Ref. pp. 407–415)

Page 414 is a diagram and p. 415 is blank. The index follows on pp. 416–421, then two blank pages and the back cover.

- **pp. 407–410, sample program list.** One row per file on the CD, with its data files indented beneath it. Points for the PC link: `TRANSFOR.B` is described as "a program that transfers `*.D` files to `COM:`", as the Tutorial Manual also says; `DEMO.B` loads the kanji fonts `FONT161.D`/`FONT162.D` with `KLOAD`; `UD_DATA1.B`/`UD_DATA2.B` test `USERDATA`; `P_CAME2.B` tests the camera commands; `PLAYMIDI.B` converts MIDI files to MML.
- **p. 411, character code table.** The Saturn's character set is **single-byte only**:
  - 0x20–0x7E is ASCII, except 0x5C is shown as **¥** and 0x7C as a broken bar.
  - 0xA1–0xDF is half-width katakana and punctuation, as in Shift-JIS.
  - 0x80–0x9F and 0xE0–0xFF are **graphic characters**: block shades, box lines, card suits, arrows, a circle and dot, a tick, and 円 年 月 日 時 分 秒 at 0xF1–0xF7.
  - In Shift-JIS those same bytes (0x81–0x9F, 0xE0–0xFC) start two-byte kanji. So a program file that uses the graphic characters reads as kanji or garbage in VS Code, and a kanji typed in VS Code reaches the Saturn as two graphic characters. Only `KPRINT` (after `KLOAD ON`) shows real kanji.
- **pp. 412–414, 3D diagrams.** The screen is 320 × 224, the default view angle is 90°, and `SETDISP` display levels 1, 2 and 3 start at 1/2, 1/4 and 1/8 of the distance to the projection plane.

**For PC-side editing.** Reading files as Shift-JIS (`cp932`) is right for katakana and for strings meant for `KPRINT`, but not for the graphic bytes. Mapping each byte 0x80–0x9F and 0xE0–0xFF to a single look-alike Unicode character (and back) would let such programs be edited and sent byte for byte.

---

## 9. Reserved words and the index

The index (pp. 416–421) lists every GAME BASIC command with its page, and the reserved-word list (pp. 9–10) has 203 words. Together with the CD's programs and the Tutorial Manual they give 208 keywords.

- **Easy to miss:** `COPY`, `OFF` (as in `INTERVAL OFF`, used 79 times on the CD), `OPTION`, `VERTEXID` (`SYS_I=VERTEXID(-1)` on the CD), and the operators `NOT!`, `OR!`, `XOR!` and `AND!`. `REM` is reserved and starts a comment.
- **Not keywords:** `VERTEX` (it only appears in comments on the CD). `TIME` and `MSTR$` are ordinary user variables in the CD's games (`TIME = TIME + .05`; `DIM MSTR$(…)`), and `TIME$` exists nowhere.
- **Standard BASIC words that GAME BASIC doesn't have:** `AUTO`, `CDBL`, `CSNG`, `CSRLIN`, `DEF`, `FN`, `EOF`, `EQV`, `IMP`, `ERASE`, `FIELD`, `GET`, `PUT`, `LLIST`, `MERGE`, `OCT$`, `PRESET`, `SOUND`, `SPC`, `TAB`, `TRON`, `TROFF`, `WHILE`, `WEND`. There are no structured loops, and no `&O` octal numbers.
- **Not reserved but part of statements:** `AS`, `OUTPUT` and `APPEND` (`OPEN … FOR OUTPUT AS 2`), and `USING` in `PRINT USING`.
- **Numbers:** `&B` binary can have a fraction (`&B101.01`).
- `OBJ` and `TPROP()` take numbered `@` fields (`@TYPE`, `@FLAG`, `@XP`…, `@ATR`, `@PARENT`, `@CHILD`, `@RADIUS`…; `@BEND`, `@LAYER`, `@TONE`, `@LOOP`, `@DPAN`…), and the `@PAD_…` constants work the same way.
