# GAME BASIC Reference Manual: notes for the BASTERM replacement

> These notes cover the whole manual: pp. 1–20 (basic specification and system settings), Chapter 1 (pp. 23–227), Chapter 2 (pp. 229–388) and the Appendix (pp. 389–421).

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

**For the terminal.** `CHR$(&H0C)` clears the screen and `CHR$(&H0B)` homes the cursor, so a program's output can contain these control codes. The Saturn never sends its screen text over the link, so they matter only in data a program writes to `COM:` itself with `FWRITE`.

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
- **FILES over COM: (pp. 100–101).** It shows names in 12-character columns and, except on CD:, a last line "Free size <free> / <total> file blocks", where 1 block is 64 bytes. `FILES$` puts spaces in place of the size on COM:. `DSKF("COM:")` also returns free space in 64-byte blocks. On `COM:` the Saturn passes on whatever number the PC sends (commands 0x1A for free and 0x1B for total), so a PC-side file server should report free space in those units.
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

## 6a. Section 1.7, OBJ commands (Ref. pp. 179–223)

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

### The OBJ items (pp. 191–214)

Every item takes `OBJ(<object no>,<item>)=<value>` and reads back with `OBJ(<object no>,<item>)`; the object number is −1 to 255 unless noted. Items in a group of three (X, Y, Z) are described once for X, and the manual says to read the others the same way.

- **FLAG (1), values 0–7.**
  - Bit 0 copies the translation part of the perspective matrix into M30–M32. It is set automatically when GTEST is non-zero. M30–M32 are relative to the viewpoint, not to object 0, and by default include object 0's ZP of 200.
  - Bit 1 copies the whole 4×3 matrix into M00–M32.
  - Bit 2 writes the screen position into XD/YD (from the top-left corner), the Z distance into ZD and radius/Z into RD. Values for objects far off screen are not guaranteed, and it only works for types 4–7.
  - After setting a bit, wait at least 1 VSYNC (one frame) before reading. Reading FLAG returns the bits that are active (currently 0–3).
- **GROUP (2), 16 bits.** Each bit is a collision group, so an object can be in up to 16. A non-zero value makes the matrix be written to M00–M32 on every display. Objects not shown are not tested, and objects 0 and −1 never collide. Default 0.
- **XP, YP, ZP (4–6).** Position relative to the parent. `OBJ(1,4)=100,200,300` sets all three.
- **XR, YR, ZR (8–10).** Rotation relative to the parent. The example `OBJ(1,8)=0.125` tilts a character 45°, and OBJROT's `0.5` turns 180°, which confirms that the unit is turns. Default 0.
- **XS, YS, ZS (12–14).** Scale, default 1.0. On objects 1 and up the scale does not pass to children. It is faster to build a model at its final size and keep the scale at 1.0. Orthographic polygons (type 5) and sprites (type 7) need XS and YS of 0.99995 (`&H0.FFFC`) instead of 1 to show at true size.
- **ATR (16) and POLYGON (17).** Attribute ID (SETATR) and polygon ID (SETPOLYGON). An undefined ID gives Undefined attribute or Undefined polygon. The attribute must have at least as many faces as the polygon, or the object is not shown. Types 1–3 do not need a polygon. Both default to −1, and reading returns the last ID written.
- **ORDER (18), 0–11.** The order of translation (T) and the X, Y and Z rotations: 0 TXYZ, 1 TXZY, 2 TYXZ, 3 TYZX, 4 TZXY, 5 TZYX, 6 XYZT, 7 XZYT, 8 YXZT, 9 YZXT, 10 ZXYT, 11 ZYXT. Default 0.
- **TIME (19), 0–&HFFFF.** VSYNCs since the object was linked to object 0, counting from 0 when it is first shown. Fixed-point values outside the range do not raise Overflow; bits above 16 and the fraction are dropped.
- **PARENT (20), and the links CHILD (21), LEFT (22), RIGHT (23).**
  - `OBJ(n,20)=<parent>` links object 1–255 under a parent (−1 to 255). Its children move with it. Linking to the same parent again does nothing.
  - Parent −1 also copies object −1's contents into the object and all its descendants, which normally makes them unused again. Linking a used object to −1 breaks up the tree below it, and every descendant becomes a sibling.
  - Internally each object has parent and child pointers (vertical) and left/right pointers (siblings). The parent points at its eldest child, the one whose left is NULL. CHILD, LEFT and RIGHT are read-only functions returning the eldest child, the older sibling and the younger sibling, or −1 for none.
  - After `SCREEN`, object −1 holds objects 1 to max and object 0 has none. Setting TYPE 4 on an unused object links it to object 0.
  - The next free object is `OBJ(-1,21)`. All siblings can be walked with `N1=OBJ(N0,21)` and then `OBJ(N,23)` until −1.
  - A loop (an object that is its own parent or ancestor) just stops that branch being shown, and it stops moving and colliding, until it is linked back to object 0. More than 16 generations are not shown because of an internal stack limit.
  - Object 0 sets the world coordinates. Turning it turns everything "like a washing machine". The viewpoint is moved by changing object 0's XP, YP, ZP, XR, YR, ZR and ORDER, which is also what CAMERA does.
- **OBJ PRINT and `OBJ?` (p. 198)** print the tree as text in the text window, for example `0->2`, `1->3->5`, `4->6`, `7`, one chain per line. With P it pauses at [HIT KEY] each window height − 3 lines, and Ctrl+C stops it.
- **XV, YV, ZV (24–26).** Speed, added to the position every VSYNC. Default 0. Objects keep moving until the program stops them.
- **XA, YA, ZA (28–30).** Acceleration, added to the speed every VSYNC. Set the speed limit first.
- **XL, YL, ZL (32–34).** Speed limit, applied only while the acceleration is non-zero: `XV=XV+XA`, then XV is clamped to ±XL.
- **XRV, YRV, ZRV (36–38).** Spin, added to the angle every VSYNC. Default 0.
- **XP0–YP3 (48–55).** Corners of a 4-point sprite (type 3), relative to XP/YP, clockwise from top left: (XP0,YP0) top left, (XP1,YP1) top right, (XP2,YP2) bottom right, (XP3,YP3) bottom left. Changing the order rotates, flips, scales or twists the sprite. `OBJ(1,48)=-10,-10,+10,-10,+10,+10,-10,+10` sets all eight. For type 3, XP/YP are screen positions from SPRWINDOW's CX,CY, ZP is the priority against polygons, and parent rotation and movement have no effect.
- **XD, YD, ZD, RD (56–59).** Read only, filled in when FLAG bit 2 is set (see FLAG). The example draws a circle on an object: `OBJ(1,1)=4: CIRCLE (OBJ(1,56),OBJ(1,57)),10`.
- **GTEST (60), 16 bits.** Groups to test against. A non-zero value starts collision tests between this object and every displayed object of type 4–7, other than itself and object 0, whose GROUP shares a bit with it. Only the first object hit is reported. The test is a sphere test; the manual prints it as `SQR(dx^2+dy^2+dz^2) <= SQR(r1+r2)`, which is presumably meant to be the sum of the radii. Default 0, no testing.
- **RADIUS (61).** Collision radius, default 10.0. The syntax box prints the item number as 60, a misprint for 61.
- **COLIDIST (62).** −1 for no contact, otherwise the distance to the object hit. After a hit, no more tests are made until GTEST is written again, which keeps BASIC in step.
- **COLIOBJ (63).** The object hit, valid when COLIDIST is 0 or more. Both examples on pp. 212–213 print "COLLSION", a typo in the manual.
- **M00–M32 (64–75).** The perspective matrix, read only (see FLAG). M30–M32 are the object's centre relative to the viewpoint and are what the collision test uses. The example `XATN(OBJ(2,73)-OBJ(1,73),OBJ(2,75)-OBJ(1,75))` finds the direction from object 1 to object 2 in the XZ plane.

### The alias commands (pp. 215–218)

Each is a shorthand for writing one OBJ item. Values in a group can be left out with commas, but at least one must be given.

| Command | Syntax | Same as |
|---|---|---|
| OBJATR | `OBJATR <object no>[,<polygon ID>][,<attribute ID>]` | ATR (16) |
| OBJLINK | `OBJLINK <object no>,<parent object no>` | PARENT (20) |
| OBJPOS | `OBJPOS <object no>,[<X>],[<Y>],[<Z>]` | XP (4) |
| OBJROT | `OBJROT <object no>[,<X angle>][,<Y angle>][,<Z angle>]` | XR (8) |
| OBJTURN | `OBJTURN <object no>,[<X spin>],[<Y spin>],[<Z spin>]` | XRV (36) |
| OBJTYPE | `OBJTYPE <object no>,<TYPE>` | TYPE (0) |
| OBJZOOM | `OBJZOOM <object no>,[<X scale>],[<Y scale>],[<Z scale>]` | XS (12) |

- OBJATR takes the polygon ID first and the attribute ID second, as its syntax line says. The interpreter's handler (0x060218A8) stores the first value with the same routine as `OBJ(n,17)` (polygon) and the second with the one for `OBJ(n,16)` (attribute). The parameter list, which names the attribute first, has the order wrong, and the alias column is best read as items 17 and 16 together.
- OBJPOS's example `OBJPOS 1,200` is described as setting X to 100, a misprint.
- OBJZOOM does not rescale normal vectors.
- OBJTYPE takes 0–7 and drops any fraction.

### SETATR, polygon face attributes (pp. 218–221)

- **Forms:** (1) `SETATR [<attribute ID>],<count>[,(<parameter 1>)][,(<parameter 2>)…]` starts a new ID; (2) `SETATR (<parameter 1>)[,(<parameter 2>)…]` continues after the last face written; (3) `SETATR <attribute ID>,<count>,READ` reads the groups from DATA.
- **Each group** is `(<TYPE>,<SURFACE>,<SORT>,<texture ID>,<COLOR>,<MODE>)` and applies to one face of the SETPOLYGON polygon, in order. The count must be at least the polygon's face count.
- **TYPE:** 0–3 texture with no flip, left-right flip, up-down flip or both; 4 polygon; 5 polyline; 6 a line through the first two points.
- **SURFACE:** 0 one-sided (back faces hidden using the normal), 1 two-sided.
- **SORT**, the point used for depth sorting: 0 the previous polygon's, 1 the nearest of the 4 points, 2 the farthest, 3 the average.
- **Texture ID:** a SETTEX texture, which must already exist; ignored for non-texture types. Adding a priority register value sets the face's priority (PRIORITY). A textured polygon is what is usually called a sprite.
- **COLOR:**
  - For 16- and 256-colour textures, the palette offset, in multiples of 16 (palette 1 = 16, … 31 = 496) or 256 (palette 1 = 256). The sprite palette has 512 entries, shared by 16- and 256-colour textures and palette polygons; the address is offset + dot colour code. They are changed with `PALETTE 10,…` (10 and up are sprite logical BGs).
  - For plain polygons (types 4–6), an RGB value as from RGB(): R + G×32 + B×32×32, each 0–31.
  - For 32768-colour textures, 0 (ignored).
- **MODE bits:** 0–1 draw mode (0 overwrite, 1 shadow, 2 half-bright, 3 half-transparent); 3 lit by the light source, using the normal (RGB textures and polygons only); 5 use the palette for polygon colour; 6–7 window (0 ignore, 1 inside, the default, 2 outside); 8 mesh. So half-transparent is 3 and mesh is 256 (&H100). Normally 0.
- **IDs:** Left out in form (1), the lowest free ID is used, which ATRID(−1) returns. Define IDs in order from 0: after 0 and 2, ID 1 can no longer be defined. No more IDs gives Attribute ID over, continuing with no current ID gives Undefined attribute, and too many faces gives Attribute data over. In form (3), too little DATA gives Out of DATA; a new ID is only registered if no error occurs, but redefining an existing one can leave the data up to the error.
- **Defaults:** In form (1) the first group is applied to every face of the new ID. With no group, every face starts as TYPE 4, SURFACE 1, SORT 2, texture 0, COLOR RGB(0,15,15), MODE 72 (inside the window, lit).
- **Redefining** works with the same ID and count; a different size gives Attribute size mismatch. SCREEN clears all attribute data.

### SETTEX, textures (pp. 222–223)

These details matter for the PNG converter, because a texture is uploaded as hex data.

- **Forms:** (1) `SETTEX [<texture ID>],<XS>,<YS>,<COLOR_DEPTH>[,<string>]` defines a new texture; (2) `SETTEX <string>` continues after the last data, with anything beyond the texture's size ignored; (3) `SETTEX <texture ID>,<XS>,<YS>,<COLOR_DEPTH>,READ` reads hex from DATA. Example: `SETTEX 1,8,8,256,HEXBIN$(STRW$(64,"FF"))`.
- **Sizes:** XS 8–504 in steps of 8 (anything else is an error), YS 1–255. Colour depth 16, 256 or 32768.
- **Data:** 16 colours is palette data, 1 byte per 2 dots; 256 colours is 1 byte per dot; 32768 colours is RGB, 2 bytes per dot. An 8×8 texture is 32, 64 or 128 bytes.
- **32768-colour format:** `&b1BBBBB_GGGGG_RRRRR`, high byte first. A dot is shown only when bit 15 is 1, and all zeros is transparent; anything from &H0001 to &H7FFF is not guaranteed.
- **DATA formats (as HEXBIN$):** comma-separated hex bytes (`DATA AA,BB,CC,…`) or a run of hex digits (`DATA AABBCC…`), 2 digits per byte, with a leading 0 added to an odd final digit. Form (3) reads exactly the amount needed; too little is an error and any extra is discarded.
- **IDs:** Left out in form (1), the lowest free ID is used, which TEXID(−1) returns. Texture data is laid out in sprite VRAM in ID order, so define IDs from 0. Starting at 10 means 0–9 can no longer be added (Table size error). No more IDs gives Texture ID over, and continuing with no current texture gives Undefined texture.
- **Redefining** works with the same ID, size and depth; anything else gives Texture size mismatch. Too much data gives Texture data over.
- **SCREEN** resets the texture allocation but leaves the pixel data as last defined. `CLS <texture ID + 10>` clears a texture, and bitmap commands can draw into one through logical BG texture ID + 10 (see ACTIVE).

## 6b. Section 1.8, sprite and 3D functions (Ref. pp. 224–227)

Pages 224–227 cover the four lookup functions. All parameters are fixed point with the fraction dropped, and all return integers. Page 228 is blank.

- **ATRID(<attribute ID>)** returns the next attribute ID after the highest defined, for a new SETATR. Only −1 is supported.
- **POLYGONID(<polygon ID>[,<element>[,<item>]])**: −1 returns the next free polygon ID. For a defined ID, no element gives its face count (0 = undefined); an element alone gives the vertex ID the polygon uses; items 0–3 give that face's vertices p1–p4 and items 4–6 its normal X, Y, Z. An element on an undefined ID gives Undefined polygon.
- **TEXID(<texture ID>[,<item>])**: −1 returns the next free texture ID. For a defined ID, item 0 is the width in dots, 1 the height and 2 the colour depth (16, 256 or 32768). The text says only "attribute ID" −1 is supported, copied from ATRID.
- **VERTEXID(<vertex ID>[,<element>[,<item>]])**: −1 returns the next free vertex ID. For a defined ID, no element gives its vertex count (0 = undefined), and an element with item 0, 1 or 2 gives that vertex's X, Y or Z. An element on an undefined ID gives Undefined vertex. The heading box says VERTEX, and the text says SETVERTEX defines "textures"; both are slips for VERTEXID and vertices.

## 6c. Chapter 2, sound reference, sections 2.1–2.4 (Ref. pp. 229–251)

Pages 228 and 230 are blank, and p. 229 is the Chapter 2 title page.

These pages explain how the sound system works. The sound commands start in section 2.5 (section 6d).

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

## 6d. Section 2.5, sound commands (Ref. pp. 252–317)

The MML itself (section 2.6) is in section 6e.

**How playback is organised.** There are 8 sequences. Sequence 0 belongs to BGM, and EFFECT shares out 1–7, so up to 7 effects play at once without cutting off the music. Songs are numbered from 0 (the BEEP sound) up to the count set by PLAYINIT. PLAYSTAT, PLAYCONT, PLAYFADE, PLAYPAN, PLAYPAUSE, PLAYSTOP and PLAYTEMPO take a sequence number: 0 for BGM, 1–7 as returned by EFFECT, −1 for everything and −2 for every effect except BGM. Volumes are 0–255 with 127 the default; 128 and up is louder than the original waveform, so the manual advises 127 or less.

| Command | Syntax | Pages |
|---|---|---|
| BEEP | `BEEP [0\|1]` | 252 |
| BGM | `BGM [<song no>[,<volume>[,<fade-in rate>]]]` | 253 |
| DSP | `DSP ON {<tone>,<layer\|ALL>,<effector>,<level>}…`, `DSP OFF {<tone>,<layer\|ALL>}…`, `DSP ALL ON <effector>,<level>`, `DSP ALL OFF` | 254–256 |
| EFFECT | `EFFECT [(<numeric var>),][<song no>[,<volume>],]{[#<track>,]"<MML>"}…` or `EFFECT [(<numeric var>),][<song no>[,<volume>]]` | 256–259 |
| EG | `EG <tone>,<layer\|ALL>,[<AR>][,<DR>][,<SR>][,<RR>][,<SL>][,<EGHOLD>][,<LSLINK>][,<KS>]` | 259–263 |
| LFO | `LFO <tone>,<layer\|ALL>,[<reset>][,<freq>][,<ALFO wave>][,<ALFO depth>][,<PLFO wave>][,<PLFO depth>]` | 263–266 |
| MMLSTAT() | `MMLSTAT(<track>,<item>)` | 267–270 |
| ON MMLSTAT GOSUB | `ON MMLSTAT GOSUB {<line>\|<label>}` (program only) | 269–270 |
| PLAY | `PLAY [<volume>,]<[#<track>,]"<MML>">[,…]` (up to 16 tracks) | 270–271 |
| PLAYSTAT() | `PLAYSTAT(<sequence no>)` | 272 |
| PLAYCONT | `PLAYCONT <sequence no>` | 272–273 |
| PLAYFADE | `PLAYFADE <sequence no>,<volume>,<fade rate>` | 273 |
| PLAYINIT | `PLAYINIT ["DSP"\|"DSPEXT",]["<tone file>",][<song count>][,<extra tone blocks>][,<song no>[~<song no>],<blocks>]…`, `PLAYINIT ["<tone file>"],0`, `PLAYINIT` | 274–279 |
| PLAYPAN | `PLAYPAN <sequence no>,<pan>` | 279 |
| PLAYPAUSE | `PLAYPAUSE <sequence no>` | 280 |
| PLAYSTOP | `PLAYSTOP <sequence no>` | 280 |
| PLAYTEMPO | `PLAYTEMPO <sequence no>,<tempo>` | 280–281 |
| SETSONG | `SETSONG [<song no>]` (program only) | 281–283 |
| SFRE() | `SFRE(<song no>)` | 283–284 |
| TARG | `TARG <"tone file",tone no>[,<tone no>…]…`, `TARG READ [<extra layer blocks>][,<BEEP switch>]` | 285–306 |
| TFRE() | `TFRE(0)` | 307 |
| TLIST | `TLIST ["<tone file>"]`, `TLIST "MENU"` | 308–309 |
| TPROP() | `A=TPROP(<tone>,<layer>,<item>)`, `TPROP(<tone>,<layer>\|ALL,<item>)=A[,A…]` | 309–316 |
| VOLUME | `VOLUME [<volume>]` | 317 |

- **BEEP** with no parameter gives the error beep and waits for it to end. `BEEP 1` keeps sounding while the program carries on, and `BEEP 0` stops it. If song 0 was replaced, BEEP restores the default.
- **BGM** plays a song registered with SETSONG and takes no MML. The fade-in rate is 0–255, where smaller is faster and 0 means no fade.
- **EFFECT** does not wait. With a song number, the MML is registered under that number and can be replayed later with just the number; volume 0 only registers it. Without a song number, the MML is discarded after playing, like PLAY. The MML belongs to one statement, so two EFFECT statements are not joined; long songs go through SETSONG.
  - The optional variable must be a fixed-point variable or array element and receives the sequence number (1–7).
  - A negative song number skips a short wait the system inserts so that PLAYSTAT is right straight away. PLAYSTAT may then read 0 for up to 2 VSYNCs.
  - An expression song number must be in brackets after the variable: `EFFECT (I),(5-4)`. Without `(I)`, `(5-4)` is read as the variable.
  - Tracks are `#0`–`#15` in any order. An omitted first track is 0 and later ones count up; going past 15 is an error. Each EFFECT starts every track from its defaults, unlike PLAY.
  - Overwriting the MML of a song that is playing makes it play wrongly.
- **DSP, EG and LFO** change one tone's parameters in sound memory, layer by layer, and take effect at the next note-on. The tone is the MML `@` number and `ALL` means every layer. A lone comma leaves an item unchanged. Changes are not saved, and PLAYINIT or TARG puts the original values back. All three warn that bad values can silence or distort the sound; the cure is PLAYINIT, or failing that a hot start, saving the program and resetting.
  - **DSP** needs PLAYINIT "DSP" or "DSPEXT" and is an error otherwise. The effector (TPROP 70) is `@REV` 0 stereo reverb, `@DEL` 1 stereo delay or `@DST` 2 distortion; in single-effector mode ("DSP") it must be 0 and switching is done with the MML `ec` command. The level (TPROP 71) is 0 (off) or 1–7 for −36 dB to 0 dB in 6 dB steps. The input mixer has no overflow protection, so the total should stay at 0 dB or below. Some tone files already set a level, so `DSP ALL OFF` first gives a clean start.
  - **EG** sets TPROP 20–27. AR, DR, SR, RR and SL are 0–31, with SR 0 meaning the note is held. EGHOLD 1 jumps to full level and holds it for the AR time. LSLINK 1 ties the start of decay to the waveform's loop start. KS (key scaling) is 0–14, or −1 for off. The manual compares this with the YM2203/YM2608 envelope, whose SL and RR only go to 15.
  - **LFO** sets TPROP 50–55. The frequency is 0–31 (0.17 Hz to 172.3 Hz, with 16 = 2.87 Hz) and is shared by both outputs. The waveforms are `@SAW` 0, `@SQU` 1, `@TRI` 2 and `@NOISE` 3; noise can't be reset or have its speed changed. ALFO depth 0–7 is tremolo from 0.4 dB to 24 dB, and PLFO depth 0–7 is vibrato from ±7 to ±494 cents.
- **MMLSTAT(track, item)** reads a playing track, 0–15:
  - 0: the value (0–127) of the last `!` control command in the MML. It is held until read, then reads 0.
  - 1: the note number playing (0 when silent).
  - 2: the direct send level, 0–7 (TPROP 72).
  - 3: the pan, 0–31, from the MML `P` command or auto-pan; otherwise TPROP 73.
  - 4: the total level, 0–255, after volume and velocity but before the envelope. It is an attenuation, so smaller is louder and 255 is silent.
  - It cannot tell which sequence a value came from when several are playing.
- **ON MMLSTAT GOSUB** checks track 0 every VSYNC and calls the routine when a `!` value arrives; the routine reads it with `MMLSTAT(0,0)`. Other interval interrupts still run, so shared data needs LOCK. A slow routine can overflow the GOSUB stack, and heavy work such as scrolling, CLS, PAINT or INPUT can pause the program. The interrupt comes about a 32nd note after the note-on, so to switch BGM exactly on a bar line the `!` goes a 32nd early: `DATA #0,"|L4 R1 |R R R R8 R16 R32 !1 R32"`.
- **PLAY** waits for each statement to finish and is kept for compatibility with older MML. Length, octave and other settings carry over from the previous PLAY (in direct mode they reset each time). Tracks that end at different times are lined up at the next PLAY. It has only 4 song blocks, about 150 quarter notes, and a long or complex line (pitch bend, for example) gives `Sound:Song bank full`; split it over several lines. PLAY's data is not kept in sound memory.
- **PLAYSTAT** returns 1 while a sequence plays and 0 when stopped; a paused song counts as playing.
- **PLAYFADE** with volume 0 stops the sequence, and rate 0 changes the volume at once.
- **PLAYINIT** sets up sound memory. Without it the state is `PLAYINIT "STANDARD",8,0`, and plain `PLAYINIT` returns to that power-on state.
  - `"DSP"` is single-effector mode: channels 0 and 1 output at level 7, panned left and right. `"DSPEXT"` is multi-effector mode: channels 0/1 reverb, 2/3 delay and 4 distortion.
  - The tone file (default STANDARD) is a set of PCM waveforms; the MML `@` command picks a tone inside it, and one MML can't mix tones from two files. Changing the file reads the CD and erases every registered song. `PLAYINIT "METAL",0` swaps the file only and keeps the songs.
  - The song count is 1–251 (default 8). Song 0 is always the BEEP sound.
  - Extra tone blocks are 0–487 of 256 bytes, added to the standard 1360 blocks (340 KB) of tone area, for TARG or extra tones. The tone area can then reach 1847 blocks.
  - The song area is 512 blocks (128 KB), less any extra tone blocks and the DSP work area. A header of 4 bytes for each of 253 songs (251, BEEP and PLAY) takes 4 blocks, whatever the song count. PLAY has 4 blocks, every other song gets 2, and song 1 gets the rest: 512 − 4 − 16 − 4 = 488 blocks with the defaults. A `<song no>,<blocks>` pair (or a range `2~3,100`) changes that; it is an error if song 1 can't then be allocated.
  - Sound cache: if the second or third CLEAR parameter (file areas 1 and 2) is at least 1360 blocks, the last tone files are kept there, so up to 3 files can be switched without reading the CD (`CLEAR ,1360,1360` gives both).
  - An error during PLAYINIT re-initialises the sound system, so the error can take a while to appear.
- **PLAYPAN** pans sequence 0–7, or −1 for all effects, from −127 (left) through 0 to 127 (right). The low 3 bits are ignored, giving 16 steps each side, and only the direct sound moves. Afterwards the MML `P` command and TPROP pan no longer apply.
- **PLAYPAUSE** and **PLAYSTOP** take 0–7, −1 (all) or −2 (all effects but BGM).
- **PLAYTEMPO** changes the tempo relative to the original: −32768 to 32767, where 4096 doubles the speed and −4096 halves it. An MML `T` command takes priority, and a `dc` repeat resets the tempo when it jumps back.
- **SETSONG** turns MML in DATA lines into a song in sound memory, for BGM or EFFECT. The DATA layout is:
  - `SONG<n>` starts a song and overrides the SETSONG number, so several songs can follow each other; RESTORE also picks the start.
  - `TEMPO<n>` sets how many tempo changes the song may hold, 1–256 (default 16; more uses memory).
  - `[#<track>,]"<MML>"`: without a track number each string goes to the next track. Quotes are needed only when the MML contains `:` (for example `"|:"` or `":|2"`).
  - `NEXT`, `-` or `+` goes back to track 0 and continues the score from there.
  - `ENDSONG` must end the data. Text straight after NEXT, ENDSONG and so on is a comment.
  - The song number must be within the PLAYINIT count and the song must fit its blocks, otherwise it is an error. Overwriting a song while it plays makes it play wrongly.
- **SFRE(song)** returns a song's free blocks with a fraction; −1 gives the whole area. MML lives in sound memory, so FRE doesn't count it. With the defaults SFRE(0) = 1.7852 and SFRE(1) = 487.9961 (about 122 KB); `PLAYINIT 1` gives song 1 about 125 KB.
- **TARG** rebuilds the tone set.
  - Form 1 copies whole tones (every layer) from one or more tone files; the new tones are numbered from 1, with 0 the BEEP tone. Waveforms are shared by source file, so repeating a tone to make versions with different TPROP, EG, LFO or DSP settings costs no wave memory.
  - `TARG READ` reads DATA up to `ENDARRANGE`. Lines can list tones (`"ROCK",34`), build a tone layer by layer (`BUILDLAYER` … `ENDLAYER`, each layer `"<file>",<tone>,<layer>,<sn>,<en>,<bn>`), add raw PCM (`STARTPCM,8|16,<source bit control>,<sn>,<en>,<bn>`, hex strings, `ENDPCM`), load a wave file (`FILE,"<file>",<start block>,<offset>,<sn>,<en>,<bn>`) or define FM operators (`FM,…` and `FMEXT,…`).
  - Wave files may be AIFF (not AIFF-C) or WAVE, mono, 8- or 16-bit, any sample rate; bn −1 takes the pitch from the file's sample rate. Up to 64 KB − 2 per tone. Stereo needs two layers panned left and right.
  - FM: 32 operators, numbered 1–32, wired freely through inputs X and Y. W is waveform 1–47, or −n to use layer n's PCM (one cycle 1024 words, stored 3 times with loop 1024–2048). M 0–4 means no modulation and 5–15 is ±π/16 to ±64π (YM2203/YM2608 M = M − 4). S is the direct send level 0–7, normally 7 only on the output operator. TL is 0–255, ml1 −62 to 65 and ml2 0–4 set the multiple (ml1 36, ml2 1, dt 0 plays at the written pitch), and dt −128 to 127 is detune. The manual gives tables of ml1/dt for the classic multiples and the 4-operator algorithms as DATA lines.
  - The second READ parameter is 0–108 extra layer blocks, for `Sound:Out of layer memory` or `Sound:Layer overflow`. Up to 128 tones; about 120 layers fit by default. Memory is tones × 4 + layers × 32 bytes.
  - BEEP switch 0 makes `@0` the first new tone, so error and break sounds change.
  - TARG needs the 1360-block file area reserved first with the second or third CLEAR parameter, and a wave file also borrows the user area (first CLEAR parameter). It does not include PLAYINIT. Rebuilt tones can't be saved. An error re-initialises the sound system.
- **TFRE(0)** returns the free tone area for TARG in blocks: 1360 by default, 1847 after `PLAYINIT ,487`. It only drops once TARG has been used; after `CLEAR ,1360:TARG "PIANO",1` it is 628, showing that piano tone 1 takes 1219 blocks.
- **TLIST** prints the tone numbers and instrument names of the current tone file, or of a named file (read from the CD without changing the tones). `TLIST "MENU"` lists the tone files. Some names are in half-width katakana. After TARG the list no longer matches sound memory.
- **TPROP** reads (function form) or writes (statement form) one item of a tone layer, also for TARG and original PCM tones. Changes act at the next note-on. Writing takes several comma-separated values for consecutive items, and `ALL` writes every layer: `TPROP(1,ALL,@AR)=20,5,7,10,3,0,1,5` is the same as `EG 1,ALL,20,5,7,10,3,0,1,5`. The item numbers have `@` constants:

| Items | Group | Constants and values |
|---|---|---|
| 0–2 | Voice (layer number must be 0) | `@BEND` 0–12 or 24 notes, `@LAYER` layers − 1 (can be lowered, not raised), `@TONE` tones − 1 (read only) |
| 10–13 | Note-on | `@SN`/`@EN` note range 0–127, `@BN` base note 0–127, `@FT` fine tune −127 to 128 (BN and FT adjusted by TARG for FM) |
| 20–27 | EG (as EG) | `@AR` `@DR` `@SR` `@RR` `@SL` `@EGHOLD` `@LSLINK` `@KS` |
| 30–36 | Wave data | `@SDIR` 0 through the EG, 1 direct; `@SB` bit inversion 0–3; `@SS` source 0 wave data, 1 noise, 2 zero; `@LOOP` 0 off, 1 normal, 2 reverse, 3 alternating; `@PCM8B` 0 16-bit, 1 8-bit (read only); `@LSA`/`@LEA` loop start and end, &H0000–&HFFFE samples |
| 50–55 | LFO (as LFO) | `@RE` `@LFOF` `@ALFOWS` `@ALFOS` `@PLFOWS` `@PLFOS` |
| 60–62 | FM wiring | `@MDX`/`@MDY` input layer 0–127 (+128 = previous generation), `@MDL` modulation level (0 switches the layer to PCM) |
| 70–73 | Mixer/DSP | `@ISEL`, `@IMIX` (as DSP), `@DSEND` direct send 0–7 (−36 dB to 0 dB), `@DPAN` direct pan 0–31: 0 and 16 centre, 1–15 turn the right side down 3 dB a step (15 = left only), 17–31 the left side (31 = right only); MML `P` and PLAYPAN change it |

- **VOLUME** sets the master volume for PLAY, EFFECT, BGM and BEEP, 0–127 (default 127). It returns to the default after an error or break.

**For the PC tools.** Sending a program with PLAY lines that are too long gives `Sound:Song bank full` on the Saturn, so a sender or linter could warn about long PLAY strings. MMLSTAT, PLAYSTAT, SFRE and TFRE are functions, TPROP is both, and the rest are statements. TARG READ and FILE can load AIFF or WAVE samples from a file (the manual's example reads `BRAM:WAVE_DT`), so sending such a file to the Saturn is another use for file transfer. TLIST prints half-width katakana, which a terminal needs to show as such.

## 6e. Section 2.6, MML (Ref. pp. 318–354)

MML is the music language used by PLAY, EFFECT and the DATA lines that SETSONG reads.

**General rules (pp. 318–319).**
- MML goes in double quotes. In DATA lines the quotes can be left out unless the MML contains `:`.
- Upper and lower case are different commands (`V` volume, `v` velocity; `P` pan, `p` piano).
- A long score can be split over several strings, but only between commands. A tie, tuplet or chord must not be split: `"@44 CDE @V"` + `"127"` is an error, where `"@44 CDE"` + `"@V127"` is fine.
- Tracks of different lengths are padded with rests to the longest one at the next separator, so an unused track needs no rests.
- A song shorter than a 128th note (direct length 15) gives `Sound: MML String too short`. `PLAY "Cl14"` is an error; `"C128"`, `"Cl15"` and `"Cl14 Cl1"` are not.
- The **base track** is the lowest-numbered track in use. Commands marked BASE (tempo and all the repeat marks) are an error on any other track.

**Commands.** Scope is BASE (base track only), All (shared by every track, last setting wins) or Track (per track).

| Command | Scope | Meaning | Pages |
|---|---|---|---|
| `¥<name>[=¥…¥]` | All | Macro, one letter A–Z or a–z, up to 128 characters | 321–322 |
| `@<tone>` | Track | Tone number in the current tone file; 0 is the BEEP tone (default) | 322–323 |
| `S<key>` | Track | Key signature −7 to 7 (sharps +, flats −) | 323 |
| `K<semitones>` | Track | Transpose −127 to 127 (K12 = an octave up) | 324 |
| `T<tempo>` | BASE | Tempo 40–300 (default 120) | 324–325 |
| `V<volume>` | Track | Volume 0–15 (default 15) | 325 |
| `@V<volume>` | Track | Fine volume 0–127 (default 125) | 326 |
| `[<n>` / `]<n>` | Track | Raise / lower @V by 2 × n, n 0–63 (default 1) | 326–327 |
| `P<pan>` | Track | Pan 0–127, 64 centre | 327–328 |
| `ep<ch>;<pan>` | All | DSP effect pan of output channel 0–15 | 328 |
| `el<ch>;<level>` | All | DSP effect level 0–7 of output channel 0–15 | 329 |
| `ec<n>` | All | Effector in single-effector mode: 0 reverb 1, 1 reverb 2, 2 delay, 3 distortion | 330 |
| `O<octave>` | Track | Octave 0–8 (default 4) | 330–331 |
| `L<length>[.][.][.]` | Track | Default length 1–128 (default 4), or `Ll<direct length>` | 331–332 |
| `v<velocity>` | Track | Default velocity 0–127 (default 127) | 333 |
| `ppp` … `fff[=<n>]` | All | Velocity presets ppp 16, pp 32, p 48, mp 64, mf 80, f 96, ff 112, fff 127 | 333–334 |
| `q[<num>/]<den>` | Track | Key-on time as a fraction of the length (default 1/1) | 334 |
| `A`–`G` | Track | Note, with options (below) | 335–339 |
| `(…)` | Track | Chord, up to 32 notes | 340 |
| `{…}[<length>]` | Track | Tuplet | 341 |
| `N<note>['<length>]` | Track | Note by number 0–127 (N60 = O4 C) | 342 |
| `R[<length>]` | Track | Rest | 342–343 |
| `<` / `>` | Track | Octave down / up (wraps between 0 and 8) | 343–344 |
| `&` | Track | Tie | 344–345 |
| `_` | Track | Slur | 346 |
| `%<0\|1>` | Track | Damper (sustain pedal) off / on | 346–347 |
| `!<n>` | Track | Sends 1–127 to MMLSTAT(n,0); on track 0 it triggers ON MMLSTAT GOSUB | 347 |
| `/[<tone>;<semitones>…]` | Track | Software layer: extra tones on each note | 347–348 |
| `dc` | BASE | Da capo: the part between two `dc` marks loops for ever | 348–349 |
| `$[<label>…]` | BASE | Segno, label 0–7 | 349 |
| `ds[<label>]` | BASE | Dal segno: back to `$` once | 350 |
| `*[<label>…]` | BASE | To coda: on the repeat, skip to after `ds` | 350–351 |
| `\|` | Track | Bar line | 351 |
| `\|:` `:\|` `:\|:` | BASE | Repeat start, end, end-and-start | 352–353 |
| `\|1` `:\|2` | BASE | First and second endings | 353 |
| `^…^` | Track | Not played (for testing) | 354 |

**Notes and their options (pp. 335–339).** The full form is `A–G[+|#|-|n][<length>[.][.][.]|l<direct length>][;<velocity>[;<gate>]][~[V|P][<start>[;<target>[;<bend length>]]]][?<chord>[;<inversion>]]`.
- Without `S`, `+` or `#` sharpens and `-` flattens that note only, and `n` is ignored, as in older PC MML. After `S`, the note letters follow the key signature, and `+`, `#`, `-` and `n` act as real accidentals until the next bar line `|` (within one octave). A tie carries an accidental over the bar line.
- Lengths are 1–128 (1, 2, 3, 4, 6, 8, 12, 16, 24, 32, 48, 64, 96 or 128; others are an error) with up to three dots. Direct lengths count 480 to a quarter note: whole 1920, half 960, quarter 480, eighth 240, 16th 120, 32nd 60, 64th 30, 128th 15; triplet lengths 3 = 640, 6 = 320, 12 = 160, 24 = 80, 48 = 40, 96 = 20. A dotted 128th is rounded.
- `;velocity` and `;gate` apply to that note only; they are this MML's own extension.
- `~` bends the pitch, `~V` the volume and `~P` the pan, from a start value to a target (0–127, 64 = normal) over the bend length (default the note's length). Pitch range comes from the tone's bend range. If the start is left out, the bend carries on from the previous target, so tied notes can shape a curve: `C1~64;70; & C2~;127; & C1~;80; & C2~;30;`. Up to 64 bends can be tied. After `~` the `;` separators can't be left out. A bend stays on the track for the following notes, so set the start back to 64 when done. The bend speed is fixed at 1 per time unit, so a wide bend over a short time jumps to the target at the end.
- Pitch bends take many times the usual memory, so a PLAY line with wide bends easily gives `Sound:Song bank full`.
- `?` plays a named chord: `?` major, `?m` (`?-`) minor, `?aug` (`?+`), `?dim` (`?°`), `?7`, `?m7`, `?m7-5` (`?m7b5`), `?M7` (`?maj7`), `?mM7`, `?dim7`, `?6`, `?m6`, `?sus4`, `?7sus4`, with `;1`–`;3` for the inversion: `G?7`, `C?7;3`, `C~64;127;?M7`.
- `S` and `K` change notes, so drums and other fixed-range tones are best played with `N`.
- Examples: `D-4;127;2` is a D flat quarter note at full velocity keyed on for an eighth; `O4 C1~64;127;960` bends a whole-note C up an octave over a half note.

**Other details.**
- **Macros** are stored as text and only become song data where they are used. The example defines a kick and a snare: `¥K=¥N36'4;127¥ ¥S=¥N37'4;100¥` and then plays `¥K(¥K¥S)¥K(¥K¥S)`.
- **Chords** share the Saturn's 32 voices with every song playing, and later notes take priority; 33 notes in one chord is an error. Each note keeps its own length, velocity and tone, and the last note's length sets when the next note starts. Volume and pan are per track, so the last one given wins. Give a pitch bend on one note only, or it is applied once per note. An octave change inside the brackets ends with the chord. Velocities can differ per note: `(C;80 E;90 G;100)`.
- **Tuplets** share the length among the notes inside, which can include chords and tone changes: `{@32 (FD) (GE) (FD) @40 (GE) (FD) (AF)}4`. `C4&{CCC}4` ties into the first note; `{C&CC}&C` is not supported.
- **Ties**: the pitch comes from the first note and other options from the last; q and gate apply to the total length. Tie across a bar line with `C& | C`; `|&` is an error. Chords are tied inside the brackets, `(C1&C1&C1&C1 E1&E1&E1&E1 G1&G1&G1&G1)`, not as `(C1E1G1)&(C1E1G1)`. Tied notes split over two DATA lines lose their timing.
- **Rests** can carry bend options. `R` with direct length 0 sets them without resting: `EFFECT 1,"@44 R10~P0;127;2000 & R10~P127;0;2000 CDEFGAB"` sweeps the pan while the scale plays.
- **Damper** `%1` stops key-offs. The LOOP rhythm tones in the EXTRA3 and EXTRA4 sets keep sounding between notes and need long notes or `%1`. Some tones never stop without a key-off, and PLAYINIT may not stop them either.
- **Software layer** `/41;0;36;12;38;-12` adds tones 41, 36 an octave up and 38 an octave down to every note until a bare `/` turns it off. Up to 16 pairs per track; each one uses a voice. TARG BUILDLAYER gives fuller control.
- **Repeats**: `dc` simply loops for ever in this MML (no da capo to the start). `$`, `ds` and `*` take labels 0–7 so a score can jump back more than once: `CD$1;2;3FFds1GAds2BGds3`. The repeat order is set out in section 2.7 (section 6f).
- **Bar lines** do nothing without `S`. They needn't be on every bar, tracks may differ, and a `|` on its own at the end of a string is not allowed.

**For the PC tools.**
- The macro mark `¥` is byte &H5C, which shows as a backslash `\` on a PC, and the bend mark `~` is byte &H7E (an overline in some Japanese fonts). The sender should send both unchanged and turn a typed Unicode `¥` into &H5C. The chord name `?dim` can also be written `?°`, which is not ASCII; `?dim` is safer in a file sent from a PC.
- `N61'4` uses `'`, which starts a comment in BASIC outside quotes, and repeat marks use `:`, which separates statements, so MML in DATA lines should stay in quotes.
- The VS Code extension shows these commands as hovers inside PLAY, EFFECT and DATA strings. A checker could also catch the simple errors listed here: lengths other than the allowed values, BASE commands on a non-base track, a `|` alone at the end of a string, or a tie or chord split across strings.

## 6f. Sections 2.7 and 2.8, repeats and tone data (Ref. pp. 355–388)

### 2.7 Repeat structure (pp. 355–357)

MML uses score-style repeat marks. The manual's examples, with the order they play in:

| MML | Plays |
|---|---|
| `AB \|: CD :\|` | AB CD CD |
| `AB :\| CD` | AB AB CD |
| `ABCD :\|` | ABCD ABCD |
| `AB :\|: CD :\|` | AB AB CD CD |
| `AB :\|: CD \|1 E :\|2 F` | AB AB CDE CDF |
| `AB dc CD dc` | AB CD CD CD … (endless) |
| `A $ B * C ds D` | A B C B D |
| `A B $ C D * E \|: F G \|1 H I :\|2 J K ds L M` | ABCDEFGHIFGJKCDLM |

- `$` is a segno, `ds` a dal segno back to it, `*` a coda mark and `|1`/`|2` first and second endings. Numbers pair them up (`$1`, `ds1`, `*1`), and `$1;3` sets two at once.
- Unlike a printed score, `dc` does not go back to the start: the part between two `dc` marks loops for ever, for game BGM.
- A segno or dal segno repeat works only once, and a skip can only jump over a part that has already played.

### 2.8 Tone data (pp. 358–388)

There are 16 tone files in 4 groups. The names are what PLAYINIT and TLIST take.

| Group | Files | Use |
|---|---|---|
| 1, game sets | `STANDARD`, `ORCHEST`, `ROCK`, `DANCE` | Ready to use; each starts with the same sound effects |
| 2, high quality | `PIANO`, `METAL`, `ETHNIC`, `MBOXPO` | One genre, no effects; PIANO samples each range separately |
| 3, extra | `EXTRA1`–`EXTRA4` | Meant to be recombined with TARG |
| 4, GM FM | `GM_FM1`–`GM_FM4` | General MIDI order, tones 0–127, FM so little wave memory |

- Tone 0 in groups 1–3 is the BEEP sound; the GM FM sets have a different beep.
- **Common sound effects (pp. 360–361)**, tones 0–30 of the game sets: 0 BEEP; 1–10 fighting-game shouts (HEY, HUA, POH, HAH, TOH2 male; KYA, TAH, TOH, WAH, YAH female); 11 CHUKIN (docking); 12 NOISE (explosion); 13 BA (bad door); 14 BASHA (scratch); 15 DOKA (hit); 16 KACHA (open/close); 17 SHU (launch); 18–20 saw, sine and square waves (system sounds); 21–27 effects built on them (energy, inside a spaceship, future machine, comical, UFO, space); 28 Crystal Bell; 29 GLOCKEN (metal hit); 30 RUM (beam).
- **Reading the tables (p. 361).** Each column is a TPROP item: Bd 0 bend range, Ly 1 layer, sn 10 / en 11 start and end note, bn 12 base note, ft 13 fine tune, AR–SL 20–24, KS 27, RE 50 LFO reset, LF 51 frequency, AW/AS 52/53 AM wave and depth, PW/PS 54/55 PM wave and depth, MX 71 input mix level, DS 72 direct send level, DP 73 direct pan. A range under an instrument name is its recommended note range.
- **Saving memory (p. 362).** When tone data does not fit, a layer list copies only the ranges needed, for example `DATA "BUILDLAYER"`, `DATA "STANDARD",44,1,-1,-1,-1`, `DATA "ENDLAYER"` for just the high strings.
- **Per-set tables** list every tone and layer: STANDARD pp. 362–366 (drum set 31 and percussion set 32 map one sound per note), ORCHEST pp. 366–369, ROCK pp. 369–372, DANCE pp. 372–377, PIANO and METAL pp. 378–379, ETHNIC pp. 380–382, MBOXPO and EXTRA1 p. 382, EXTRA2 p. 383, EXTRA3 and EXTRA4 p. 384.
- **EXTRA3 loops (p. 384).** The LOOP tones keep playing until Note Off. They are in tempo at note 60; an octave up doubles the tempo and an octave down halves it.
- **GM FM sets (pp. 385–388)** use the standard General MIDI program names 000–127. The four sets share the names but differ in parameters. The list numbers both Syn Brass 1 and 2 as 062; the second is 063.

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

- **Easy to miss:** `COPY`, `OFF` (as in `INTERVAL OFF`, used 79 times on the CD), `OPTION` (undocumented; its hidden forms `OPTION HD352`, `OPTION HD320`, `OPTION COM` and `OPTION VERSION` are described in `GAME_BASIC_CD/README.md`), `VERTEXID` (`SYS_I=VERTEXID(-1)` on the CD), and the operators `NOT!`, `OR!`, `XOR!` and `AND!`. `REM` is reserved and starts a comment.
- **Not keywords:** `VERTEX` (it only appears in comments on the CD). `TIME` and `MSTR$` are ordinary user variables in the CD's games (`TIME = TIME + .05`; `DIM MSTR$(…)`), and `TIME$` exists nowhere.
- **Standard BASIC words that GAME BASIC doesn't have:** `AUTO`, `CDBL`, `CSNG`, `CSRLIN`, `DEF`, `FN`, `EOF`, `EQV`, `IMP`, `ERASE`, `FIELD`, `GET`, `PUT`, `LLIST`, `MERGE`, `OCT$`, `PRESET`, `SOUND`, `SPC`, `TAB`, `TRON`, `TROFF`, `WHILE`, `WEND`. There are no structured loops, and no `&O` octal numbers.
- **Not reserved but part of statements:** `AS`, `OUTPUT` and `APPEND` (`OPEN … FOR OUTPUT AS 2`), and `USING` in `PRINT USING`.
- **Numbers:** `&B` binary can have a fraction (`&B101.01`).
- `OBJ` and `TPROP()` take numbered `@` fields (`@TYPE`, `@FLAG`, `@XP`…, `@ATR`, `@PARENT`, `@CHILD`, `@RADIUS`…; `@BEND`, `@LAYER`, `@TONE`, `@LOOP`, `@DPAN`…), and the `@PAD_…` constants work the same way.
