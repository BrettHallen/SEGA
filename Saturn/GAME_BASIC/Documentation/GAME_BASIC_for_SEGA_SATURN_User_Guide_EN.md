# GAME BASIC for SEGA SATURN: English User Guide

GAME BASIC for SEGA SATURN (ASCII Corp., Bits Laboratory and ESP inc., 1998) is a BASIC interpreter that runs on the Sega Saturn. It was only sold in Japan, and its two manuals, the *Tutorial Manual* and the *Reference Manual*, are in Japanese.

This guide is written for English speakers who want to use GAME BASIC on a real Saturn. It is not a translation of the Tutorial Manual. It explains the important points in its own words, with short examples, and gives page numbers so you can look things up in the Japanese manual (book page numbers, "TM p. N"; Reference Manual pages are "RM p. N"). For more detail on any topic, see `Documentation/Tutorial_Manual_findings.md` and `Documentation/Reference_Manual_findings.md`.

Where something here is worked out from the sample programs or the PC software rather than stated in the manuals, it says so.

> **Work in progress.** The serial protocol used by the modern PC tools (section 19) was worked out from BASTERM's code and has not yet been confirmed on real hardware; the open questions are listed in `tools/README.md`. The polygon example in section 14 has also not yet been run on a Saturn.

---

## Contents

1. [What you need](#1-what-you-need)
2. [Starting GAME BASIC](#2-starting-game-basic)
3. [Typing with a control pad (software keyboard)](#3-typing-with-a-control-pad-software-keyboard)
4. [Typing with the Saturn keyboard](#4-typing-with-the-saturn-keyboard)
5. [The edit screen](#5-the-edit-screen)
6. [The system settings screen (L+R+Z)](#6-the-system-settings-screen-lrz)
7. [Your first program](#7-your-first-program)
8. [Saving and loading: devices and files](#8-saving-and-loading-devices-and-files)
9. [Language basics](#9-language-basics)
10. [Reading the control pad](#10-reading-the-control-pad)
11. [Graphics: screens, drawing and colour](#11-graphics-screens-drawing-and-colour)
12. [Sprites](#12-sprites)
13. [Screen effects: scroll, zoom, rotate, mosaic](#13-screen-effects-scroll-zoom-rotate-mosaic)
14. [3D polygons](#14-3d-polygons)
15. [Japanese text (kanji)](#15-japanese-text-kanji)
16. [Sound and music (MML)](#16-sound-and-music-mml)
17. [Connecting to a PC](#17-connecting-to-a-pc)
18. [BASTERM, the original Windows 95 tool](#18-basterm-the-original-windows-95-tool)
19. [The modern tools: VS Code and saturn_send.py](#19-the-modern-tools-vs-code-and-saturn_sendpy)
20. [Messages and errors](#20-messages-and-errors)
21. [Sample programs on the CD](#21-sample-programs-on-the-cd)
22. [Character codes](#22-character-codes)
23. [Quick reference](#23-quick-reference)

---

## 1. What you need

The package contains the GAME BASIC CD for the Saturn, a CD of Windows 95 tools, a serial cable for the PC (the "Windows communication cable") and the two manuals (TM p. 3).

To use it you need:

- **A Saturn and the GAME BASIC CD.**
- **A way to type.** Either a standard control pad in **controller port 1**, using the on-screen software keyboard, or the separately sold **Saturn keyboard** (TM pp. 3–4). The keyboard is much more comfortable for anything longer than a few lines.
- **Somewhere to save.** The Saturn's internal backup RAM works, but it is small (see section 8). A Power Memory cartridge gives more room.
- **Optionally, a PC link.** Writing long programs is much easier on a computer. The original cable connected to a Windows 95 PC running BASTERM. A USB serial adapter and the VS Code tools in this repository can replace both (sections 17–19).

## 2. Starting GAME BASIC

Put the CD in the Saturn and switch on. After the Saturn logo you see a title message like this (TM p. 5):

```
GAME BASIC for SEGASATURN ver 1.00
(C)1998 ASCII Corp./Bits Laboratory
/ESP inc.
Ready.
```

`Ready.` means GAME BASIC is waiting for you to type. The blinking `_` is the cursor. Everything happens from here: typing commands, writing programs and running them.

**If BASIC locks up**, hold **A+B+C** and press **Start** on the pad (the normal Saturn soft reset). GAME BASIC restarts and shows `HOT START` instead of the title. Variables, open files and sound are reset, and the program in memory may be lost. Doing it a second time goes back to the Saturn's own menu (RM p. 18–19).

## 3. Typing with a control pad (software keyboard)

Press **L+R+Start** to bring up the software keyboard (TM pp. 6–8). Move around it with the D-pad and press **C** to type the highlighted key.

| Pad | What it does |
|---|---|
| L+R+Start | Show or hide the software keyboard |
| R | Next keyboard page |
| L | Shift |
| L+C | Type a lower-case letter |
| C | Type the selected key |
| X | Delete |
| Y | Space |
| Z | Enter |
| B | Backspace |
| A+D-pad | Move the edit cursor |
| A+X | Switch between insert and overwrite |
| **A+Start** | **Break** (stop a running program) |
| **L+R+Z** | **System settings screen** (section 6) |
| A+B+C+Start | Soft reset (section 2) |

The software keyboard has four pages, which you step through with R:

- **ALPH**: letters, numbers and symbols. The backslash key shows as `¥`, as on Japanese computers. It is the same character.
- **Kana**: Japanese katakana.
- **CMD.**: whole keywords in one press: `CLS FOR NEXT STEP LOCATE PRINT IF THEN ELSE GOTO GOSUB RETURN COLOR PSET LINE CIRCLE PAINT`. This saves a lot of typing on a pad.
- **GRPH**: block-graphic characters, card suits and a few kanji (for dates and money).

Each page also has F1–F12 along the top (see section 5 for what they do).

## 4. Typing with the Saturn keyboard

The Saturn keyboard (HSS-0129) plugs into a controller port and works like a PC keyboard, with F1–F12, Esc, Caps Lock, Ctrl, Alt, Shift and arrow keys (TM p. 9). Keep a pad in port 1 too, because some programs only read the pad.

It has a **Japanese (JIS) layout**, so some symbols are not where a UK or US keyboard has them. The ones you will notice most:

- `"` is **Shift+2** (you need it for every string).
- `¥` (backslash) is a key of its own, near the top right.
- `@`, `[`, `]`, `:`, `*` and `+` have their own keys to the right of the letters.

On the keyboard, the settings screen is **Q+E+D** held together, and Break is **Ctrl+C**.

## 5. The edit screen

GAME BASIC has a full-screen editor, much like 1980s home computers (RM pp. 15–18). You can move the cursor anywhere on screen, change a line and press **Enter** to store the change.

- A line that **starts with a number** is stored as part of the program: `100 PRINT 10/2`.
- A line **without a number** runs straight away: `PRINT 10/2` prints ` 5`.
- A line longer than the screen wraps onto the next row and is still treated as one line.

**Useful keys** (keyboard; on the pad use the software keyboard):

| Key | What it does |
|---|---|
| Ctrl+C | While typing: abandon the line. While a program runs: Break. During `INPUT`: stop |
| **F12** or **Ctrl+P** | "Panic" key: puts the normal text screen back (runs `SCREEN 0` and resets the text window). Use it whenever the screen is unreadable after a graphics program |
| Ctrl+Q (Shift+Home) | Clear the screen |
| Ctrl+B / Ctrl+N | Home / End |
| Ctrl+V | Insert mode on or off |
| Ctrl+K | Delete to the end of the line |
| Ctrl+L | Paste what Ctrl+K deleted |
| Ctrl+U (Shift+End) | Bring back the line as it was before you edited it |
| Ctrl+W / Ctrl+Z | Show the previous / next program line for editing |
| Ctrl+F / Ctrl+A | Next / previous word |
| Ctrl+T | Delete a word |
| Ctrl+I (Tab) | Jump to the matching bracket |

**Function keys** at start-up (RM p. 18). You can change them with `FKEY`.

| Key | Types | Key | Types |
|---|---|---|---|
| F1 | `EDIT .` and Enter (edit the current line) | F7 | `CONT` and Enter |
| F2 | `EDIT` and Enter | F8 | `FILES"` |
| F3 | `LIST ` | F9 | `RENUM` |
| F4 | `LIST` and Enter | F10 | `LOAD"` |
| F5 | `RUN` and Enter | F11 | `FIND"` |
| F6 | `DELETE ` | F12 | Ctrl+P (restore the screen) |

**Launcher.** **Shift+F1** on the keyboard (L+F1 on the software keyboard) starts `LAUNCH.B`, a menu that lists the files on a device so you can run one without typing its name. In the launcher, A or Tab changes the device, Start or Enter runs the file, and you can type letters or numbers to jump to a name (TM p. 105).

## 6. The system settings screen (L+R+Z)

From the edit screen, press **L+R+Z** on the pad in port 1, or hold **Q+E+D** on the Saturn keyboard (RM pp. 19–20). Move between settings with the D-pad up and down, change a value with left and right, and finish by moving to **Exit** and pressing **C**.

| Setting | Values | Default | Notes |
|---|---|---|---|
| **Baudrate** | 9600BPS or 19200BPS | 9600 | Speed of the PC link. Must match the PC. Use 9600 if you get errors |
| Keyboard INITIAL | 4–255 frames | 17 | Delay before a held key repeats |
| Keyboard AFTER | 1–255 frames | 3 | Time between repeats |
| Ctrl key | NORMAL or SWAP | NORMAL | SWAP exchanges Ctrl and Caps Lock |
| Edit width LEFT / TOP / RIGHT / BOTTOM | character cells | 1, 1, 38, 26 | Size of the text area. Shrink it if your TV cuts off the edges |
| Background RED / GREEN / BLUE | 0–15 each | 0, 0, 0 | Edit screen background colour |

A frame is 1/60 of a second.

These settings are stored in the Saturn's backup RAM in a file called **`GBASICSS_01`** (1 block). If you delete that file in the Saturn's memory manager, every setting goes back to its default.

## 7. Your first program

Type each line and press Enter after it (TM pp. 17–28):

```basic
NEW
10 CLS
20 FOR I=1 TO 5
30 PRINT "HELLO SATURN";I
40 NEXT I
```

`NEW` clears any program already in memory. Do it before starting a new program.

Now try these commands:

| Command | What it does |
|---|---|
| `LIST` | Show the whole program. `LIST 30` shows one line, which you can then edit |
| `RUN` | Run the program |
| `RENUM` | Renumber the program from 100 in steps of 10, fixing `GOTO` and `GOSUB` targets (TM p. 34) |
| `DELETE 30` | Remove line 30 |
| `NEW` | Clear the program |

**Stopping a program.** Press **A+Start** on the pad or **Ctrl+C** on the keyboard. GAME BASIC prints something like `Break at 130` (the line it stopped on) and then `Ready.` (TM p. 28). Type `CONT` to carry on from there. If the program left the screen in a strange state, press **F12** or type `SCREEN 0`.

**If you mistype**, GAME BASIC prints `Syntax error`, shows your line again with the cursor on it, and returns to `Ready.`. Fix the line and press Enter again. A mistake inside a numbered line (for example `40 NAXT I`) is only noticed when the program reaches that line. Section 20 lists every error message and what it means.

## 8. Saving and loading: devices and files

A program only lives in the Saturn's work RAM until you save it. Switching off or typing `NEW` loses it, so save often (TM pp. 29–31).

### Devices

Every file name can start with a device name and a colon (RM pp. 8–9):

| Device | Where it is | Notes |
|---|---|---|
| `BRAM:` | The Saturn's internal backup RAM | Shared with game saves, so it may be full |
| `CRAM:` | A RAM cartridge (Power Memory) | Much more space |
| `CD:` | The GAME BASIC CD | Read only. Holds all the sample programs |
| `FD0:` / `FD1:` | Saturn floppy drive, partitions 1 and 2 | Rare hardware |
| `COM:` | A folder on the PC, through the serial link | Needs BASTERM or the modern tools running on the PC (section 17) |

If you leave the device out, GAME BASIC uses the current device.

### File names

- Up to **8 characters**: letters, digits and `_`.
- Then a dot and **one type letter**: `.B` BASIC program, `.D` data file, `.0` 256-colour picture, `.1` 32768-colour picture.
- `LOAD`, `SAVE` and the other commands add the type letter for you, so `SAVE "BRAM:GAME"` saves `GAME.B`. Only `FILES` and `FILES$()` need the type written out.
- `FILES` accepts wildcards: `?` matches one character and `*` matches the rest of the name.

### Commands

```basic
SAVE "BRAM:MYGAME.B"      ' save the program in memory
FILES "BRAM:"             ' list what is in backup RAM
LOAD "BRAM:MYGAME.B"      ' load it back (replaces the program in memory)
LOAD "CD:G_HATA.B",R      ' load and run straight away
LOAD "BRAM:EXTRA.B",M     ' merge into the program in memory instead of replacing it
```

`FILES` prints one name per line and then the free space, for example `Free size 105 / 512 file blocks`.

If `SAVE` to `BRAM:` fails, backup RAM is probably full of game saves. Delete some in the Saturn's memory manager, or save to `CRAM:` or `COM:` instead.

### Data files

Programs can read and write their own files with `OPEN`, `CLOSE`, `INPUT #`, `PRINT #`, `FREAD` and `FWRITE`. Up to **two files** can be open at once, numbered 1 and 2:

```basic
10 OPEN "BRAM:SCORE" FOR OUTPUT AS 1
20 PRINT #1, 12345
30 CLOSE 1
```

The largest file a program can handle is set by the file area reserved with `CLEAR` (RM pp. 7–9).

## 9. Language basics

GAME BASIC looks like the line-numbered BASICs of 1980s home computers, with many Saturn-specific commands added. The Reference Manual (RM pp. 1–14) is the formal definition. The main points are below.

### Lines, statements and labels

- Each program line is `<line number> <statement>[:<statement>]...`.
- Line numbers go from **1 to 99999**. A line can be at most **255 characters**.
- `:` separates several statements on one line.
- `'` (or `REM`) starts a comment.
- **Labels** start with `*` and come straight after the line number. Any command that takes a line number also takes a label, and labels survive `RENUM`, so they are the better choice:

```basic
100 *MAINLOOP
110 GOSUB *DRAW
120 GOTO *MAINLOOP
...
500 *DRAW
510 ' drawing code here
520 RETURN
```

- Keywords and variable names can be typed in lower case. GAME BASIC turns them into capitals when the line is stored. Text inside `"..."` is left alone.
- Only plain ASCII characters are allowed in program text. Japanese characters are allowed only inside strings and comments.

### Variables

- Names start with a letter and can contain letters, digits and `_`, **up to 31 characters**: `PLAYER_X`, `SCORE2`.
- The ending sets the type:

| Ending | Type | Range |
|---|---|---|
| none | Fixed-point number (default) | −131071.9999 to 131071.9999, 4 decimal places |
| `#` | Floating-point (double) | Large range, slower |
| `$` | String | Up to 65535 characters |

- There is **no integer type**. Plain variables are fixed-point, which is fast and is what the Saturn's graphics hardware uses. Use `#` only when you need very large or very precise numbers.
- `LET` is optional: `LET A=1` and `A=1` are the same.
- Arrays need `DIM`: `DIM MAP(31,23)`. Up to 16 dimensions.

### Numbers

- Decimal: `12`, `-3.5`, `.25` (fixed-point values below 1 print without a leading 0).
- Hexadecimal: `&H1F`, and also with a fraction, `&H0.8` (= 0.5).
- Binary: `&B1010`, `&B101.01`.
- Exponent form: `1.5E+3`.
- Printed numbers have a space in front for the sign: `PRINT 1+2` shows ` 3`.

### Operators

From highest to lowest priority (RM p. 5):

| Operators | Meaning |
|---|---|
| `( )` | Brackets |
| `^` | Power |
| `-` `+` `NOT` `NOT!` | Unary minus and plus, logical NOT |
| `*` `/` | Multiply, divide |
| `MOD` `¥` | Remainder, whole-number divide (`¥` is the backslash key) |
| `+` `-` | Add, subtract (`+` also joins strings) |
| `=` `<>` `<` `>` `<=` `>=` | Comparisons. True is −1, false is 0 |
| `AND` `AND!` `XOR` `XOR!` | Logical AND and XOR |
| `OR` `OR!` | Logical OR |

The `!` versions (`AND!`, `OR!`, `XOR!`, `NOT!`) also work on the fraction bits of a fixed-point number. The samples use them to make a counter wrap round smoothly, for example `N=(N+&H0.001) AND! &HFFFF.FFFC`.

### Control flow

```basic
10 INPUT "HOW OLD ARE YOU";AGE
20 IF AGE>=18 THEN PRINT "ADULT" ELSE PRINT "NOT YET"
30 FOR I=10 TO 0 STEP -2: PRINT I;: NEXT I
40 GOSUB *BEEPTWICE
50 END
60 *BEEPTWICE
70 BEEP: BEEP: RETURN
```

- `IF ... THEN ... ELSE ...` on one line. A block `IF` is also allowed: put `IF condition THEN` at the end of a line, the statements on the following lines, and `ENDIF` on its own line to close it (TM p. 103).
- `FOR ... TO ... STEP ... NEXT`, `GOTO`, `GOSUB ... RETURN`, `ON n GOTO`, `END`, `STOP`.
- There is **no `WHILE`/`WEND`** and no `DEF FN`. Use `GOTO` loops and `GOSUB` routines.
- `ON ERROR GOTO *HANDLER` catches errors. In the handler, `ERR` is the error number and `ERL` the line, and `RESUME` carries on.

### DATA

`READ` takes values from `DATA` lines in order. `RESTORE 500` or `RESTORE *LEVEL1` goes back to a given line. Several commands (`SETVERTEX`, `SETTEX`) can read their data straight from `DATA` lines with the word `READ` in place of a value.

### Common functions

| Group | Functions |
|---|---|
| Maths | `ABS INT FIX SGN SQR RND SIN COS TAN ATN EXP LOG FRAC` |
| Fast fixed-point maths | `XSIN XCOS XTAN XATN XSQR XDIST`, used throughout the samples for movement and animation |
| Strings | `LEFT$ RIGHT$ MID$ LEN INSTR STR$ VAL CHR$ ASC STRING$ SPACE$ HEX$ BIN$` |
| Input | `INKEY$` (the key being pressed, or `""`), `INPUT`, `PAD()` (section 10) |
| System | `DATE$`, `FRE(0)` (free program memory), `TIMER` |

The Reference Manual's index (RM pp. 416–421) lists every keyword with its page.

## 10. Reading the control pad

`PAD(port,1)` returns a number in which each button is one bit. Test a button by ANDing it with one of the `@PAD_` constants (RM pp. 11–14):

| Constant | Button | Constant | Button |
|---|---|---|---|
| `@PAD_UP` | Up | `@PAD_A` | A |
| `@PAD_DOWN` | Down | `@PAD_B` | B |
| `@PAD_LEFT` | Left | `@PAD_C` | C |
| `@PAD_RIGHT` | Right | `@PAD_X` / `@PAD_Y` / `@PAD_Z` | X / Y / Z |
| `@PAD_START` | Start | `@PAD_L` / `@PAD_R` | L / R |

```basic
10 CLS: X=19: Y=12
20 *LOOP
30 P=PAD(0,1)
40 IF P AND @PAD_LEFT THEN X=X-1
50 IF P AND @PAD_RIGHT THEN X=X+1
60 LOCATE X,Y: PRINT "*";
70 IF (P AND @PAD_START)=0 THEN GOTO *LOOP
```

Port 0 is the first controller port in the sample programs. The `PAD(0,1)` form is the one the CD's games use; the other second arguments (`PAD(0,2)` and so on) return other readings, such as analogue values or the light gun position, and are described in the Reference Manual. The Virtua Gun light gun goes in **port 2** (TM pp. 102–103).

For the keyboard, use `INKEY$`.

## 11. Graphics: screens, drawing and colour

### How the display is built

The Saturn draws several layers on top of each other (TM pp. 41–45):

- **Bitmap screen**: a 320×224 picture you draw on with `PSET`, `LINE`, `CIRCLE` and `PAINT`. Kanji text is drawn here too.
- **Character (text) screens**: grids of 8×8 tiles. The program listing and `PRINT` output use one of these, 39 columns × 26 rows.
- **Sprite/polygon layer**: moving objects, both flat sprites and 3D polygons.

Each layer is independent, so drawing on one does not disturb another.

### SCREEN

`SCREEN mode[,text layer][,text colours][,frame time]` chooses how the layers are set up. `SCREEN 0` is the normal start-up screen and is the right choice for most programs. The main differences between modes (TM pp. 41–44):

| Mode | What you get |
|---|---|
| 0 | 32768-colour bitmap that can scroll and zoom, plus character layers (default) |
| 1 | Two 256-colour (palette) bitmaps, plus character layers |
| 2 | Character layers plus a character layer that rotates around the Z axis |
| 3 | A 256-colour bitmap that rotates around the Z axis, plus character layers |
| 4 | Four 256-colour character layers |
| 5 | Character layers plus a 256×256-tile layer that rotates in 3D |
| 6 | Character layers plus two 3D-rotating layers |

The last value, frame time, sets how often the screen is redrawn, in 1/60 s units. The full details of each mode and layer number are in the Reference Manual.

After experimenting, `SCREEN 0` or **F12** puts things back.

### Coordinates

On the bitmap, x runs 0–319 from left to right and y runs 0–223 from top to bottom. Text positions for `LOCATE x,y` are in character cells, 0–38 across and 0–25 down.

### Drawing

```basic
10 SCREEN 0: CLS
20 PSET (160,112), RGB(31,31,31)               ' a white dot in the middle
30 LINE (0,0)-(319,223), RGB(31,0,0)           ' a red diagonal line
40 LINE (20,20)-(100,60), RGB(0,31,0), B       ' a green box outline
50 LINE (20,80)-(100,120), RGB(0,0,31), BF     ' a filled blue box
60 CIRCLE (240,150), 40, RGB(31,31,0)          ' a yellow circle
70 PAINT (240,150), RGB(31,0,31), RGB(31,31,0) ' fill it, stopping at yellow
```

- `PSET (x,y)[,colour]` draws a dot.
- `LINE (x1,y1)-(x2,y2)[,colour][,B or BF]` draws a line, or a box with `B`, or a filled box with `BF`.
- `CIRCLE (x,y),radius[,colour][,F]` draws a circle, filled with `F`. It can draw ellipses too (see the Reference Manual).
- `PAINT (x,y)[,fill colour][,border colour...]` fills an area. You can list several border colours.

### Colour

`RGB(r,g,b)` makes a colour from red, green and blue, each **0 to 31**. That gives 32768 colours. The number it returns is r + g×32 + b×1024, so `RGB(31,31,31)` is the brightest white.

In 256-colour modes you use **palettes** instead. `PALETTE layer,number,colour` stores a colour in a numbered slot, and drawing commands then use the slot number. `ACTIVE` chooses which bitmap you draw on:

```basic
10 SCREEN 1
20 ACTIVE 1
30 PALETTE ,5,RGB(31,16,0)    ' slot 5 = orange
40 CIRCLE (160,112),50,5,F
```

Palette slots also colour sprites (section 12). Layer 10 is the sprite layer.

## 12. Sprites

GAME BASIC has two kinds of sprite (TM pp. 51–56).

### Simple sprites

These are 16×16 dot pictures, each dot using a palette slot of the sprite layer (layer 10). Slot 0 is transparent. Define the shape by assigning 256 characters to `SPRITE$`, one character per dot, then show it with `PUTSPRITE`:

```basic
10 SCREEN 1
20 PALETTE 10,1,RGB(31,31,0)          ' sprite colour 1 = yellow
30 SPRITE$=STRING$(256,CHR$(1))       ' a solid 16x16 square
40 FOR X=0 TO 300 STEP .5
50 PUTSPRITE 1,(X,100),0              ' move it across the screen
60 NEXT X
```

For a real shape, build the 256-character string from `DATA` lines, using `CHR$(0)` for see-through dots and other values for colours.

### Object sprites

The more powerful kind uses the same object system as the 3D polygons (section 14), so it can be scaled, rotated and distorted. An object is a numbered slot whose settings you change with `OBJ(n,@field)`:

- **Type 1**: can be scaled evenly and turned around the Z axis.
- **Type 2**: like type 1, but width and height scale separately.
- **Type 3**: you place each of the four corners yourself, so you can stretch the picture into any four-sided shape.

The steps are: make a texture with `SETTEX`, give it an attribute with `SETATR`, then set the object's type, attribute and position. After that, changing a field such as `OBJ(1,@ZR)` (Z rotation) or `OBJ(1,@XS)` (X scale) updates the display at once, so a loop that changes the fields animates the sprite. Several fields can be set in one go: `OBJ(1,@XP)=-100,-50,300` sets X, Y and Z.

The tutorial's example of all three types is on TM pp. 54–56. The `@` field names (`@TYPE`, `@ATR`, `@XP`, `@ZR`, `@XS`, `@YS`, `@XP0`...`@YP3` and many more) are listed on RM pp. 11–14.

## 13. Screen effects: scroll, zoom, rotate, mosaic

These change how a whole layer is shown, without redrawing it (TM pp. 56–60).

**Scroll.** `SCROLL [layer],[STEP][x][,y]` moves a layer. With `STEP`, the values are added to the current position:

```basic
10 SCREEN 0: CIRCLE (160,112),30,RGB(0,31,31),F
20 SCROLL 0,STEP 0,1: GOTO 20      ' the circle drifts up and wraps round
```

**Zoom.** `ZOOM [layer],[x scale][,y scale]` enlarges a layer. `ZOOM 4,3,3` makes the text layer three times bigger. `SCREEN 0` puts it back.

**Rotate.** Rotation needs a rotating mode (`SCREEN 2`, `3`, `5` or `6`) and three commands:

- `ROTCENTER x,y,z` sets the point to turn around.
- `ROTPOS x,y,z` sets the distance from the viewpoint to that point.
- `ROTATE [x angle][,y angle][,z angle]` turns the layer. Angles are in **turns**: 0.25 is a quarter turn clockwise, 0.5 is half a turn. (The Japanese text calls these "radians", but its own numbers are turns.)

```basic
10 SCREEN 3
20 PALETTE 2,100,RGB(31,0,0): CIRCLE (60,60),30,100,F
30 ROTCENTER 160,112,0: ROTPOS 0,0,0
40 A=0
50 *SPIN: ROTATE ,,A: A=A+.002: IF A>=1 THEN A=0
60 GOTO *SPIN
```

**Mosaic.** `MOSAIC ON` then `MOSAIC (w,h)` turns a layer into big blocks, for fades and transitions. Press **F12** to clear it if it hides the listing.

## 14. 3D polygons

The Saturn's main strength is real-time 3D, and GAME BASIC gives you direct access to it (TM pp. 61–79).

### Ideas

- **World coordinates**: x grows to the right, y grows **downwards**, and z grows **away** from you. The point (0,0,0) is the centre of the screen.
- **Polygon**: a flat four-cornered face. Models are built from many polygons.
- **Object**: anything placed in the 3D world. Objects can have a **parent**, so moving a parent (an arm) also moves its children (the hand).
- **Texture**: a picture painted onto a polygon.
- **Light** and **camera**: set with `SETLIGHT` and `CAMERA`.

### Building one polygon

The steps are always the same:

1. `SETTEX id,width,height,colours,data$` makes a texture.
2. `SETVERTEX id,count,READ` reads corner positions from `DATA`.
3. `SETPOLYGON id,...,(0,1,2,3)` joins the corners into a face. List them **clockwise**, so the face points towards you.
4. `SETATR id,...` sets the face's attributes, such as which texture it uses.
5. `OBJTYPE`, `OBJATR` and `OBJPOS` create an object, give it the polygon and attribute, and place it.
6. `OBJTURN` sets it spinning.

Here is a short example of a spinning blue square (adapted from the structure on TM pp. 65–66):

```basic
10 SCREEN 0
20 C=RGB(0,0,31) OR &H8000                 ' texture colours need bit 15 set
30 C$=HEXBIN$(RIGHT$(HEX$(C),4))           ' one 16-bit dot as a 2-byte string
40 SETTEX 0,32,32,32768,STRW$(32*32*2,C$)  ' 32x32 texture of that colour
50 SETVERTEX 0,4,READ
60 SETPOLYGON 0,1,0,,(0,1,2,3)
70 SETATR 0,1,(0,1,3,0,0,0)
80 OBJTYPE 1,4: OBJATR 1,0,0: OBJPOS 1,0,0,0
90 OBJTURN 1,.003,-.001
100 DATA -40,-40,0, 40,-40,0, 40,40,0, -40,40,0
```

Two points the manual stresses: texture colours must have **bit 15 set** (`OR &H8000`), or they show in the wrong colour, and corners must go **clockwise** for the front face.

### How the 3D view works

The Reference Manual's appendix has diagrams of the 3D view (RM pp. 412–415). In short:

- The viewpoint (camera) looks along the z axis. The **projection plane**, the 320×224 picture you see, sits in front of it. The default field of view is **90 degrees**.
- Objects are only drawn between a **near limit** and a **far limit** (the "back limit plane"). Anything outside is not shown.
- `SETDISP` sets the **display level**, which moves the near limit. At level 1, objects are drawn from half the distance to the projection plane; level 2 draws from a quarter, and level 3 from an eighth, so higher levels let objects come closer to the camera before they disappear. (`P_PFONT.B` uses `SETDISP 3`.)

### Bigger models: DXFCONV

Typing in hundreds of vertices is not practical. The Windows tools CD includes **DXFCONV**, which turns a 3D model saved as a DXF file (using `3DFACE` entities) into BASIC `DATA` lines for `SETVERTEX` and `SETPOLYGON`, optionally with a small viewer program (`HEADBAS.B`) in front (TM pp. 73–78). The C source of its command-line versions is in `GAME_BASIC/DXFCONV/SOURCE/`, so it can be rebuilt on a modern computer. An English version of its readme is in `GAME_BASIC/DXFCONV/README_EN.TXT`.

The polygon samples on the CD (P_PFONT, P_CLOCK, P_FLOWER, P_CAME2, P_TANK and others) are the best way to learn the rest: lights, cameras, parent objects and `PFONT` polygon text.

## 15. Japanese text (kanji)

Kanji are drawn on the bitmap layer (TM pp. 49–50):

```basic
10 SCREEN 0
20 KLOAD ON                 ' load the kanji font from the CD (uses work RAM)
30 KPRINT "こんにちは"
```

The Saturn keyboard cannot type kanji, so programs that print Japanese have to be written on a PC and sent over the link. The modern tools send programs as Shift-JIS, which is what GAME BASIC expects.

## 16. Sound and music (MML)

GAME BASIC plays music written in **MML** (Music Macro Language), a compact text notation for notes (TM pp. 79–86). It uses both FM synthesis and PCM (sampled) sounds, and follows MIDI conventions for note numbers.

### Playing notes

`EFFECT "..."` plays an MML string straight away:

```basic
EFFECT "CDEFGAB"              ' a scale in the default beep sound
EFFECT "@44 CEG (CEG)"        ' strings: three notes, then a chord
```

### MML in brief

| MML | Meaning | Example |
|---|---|---|
| `C D E F G A B` | Notes | `CDE` |
| `#` or `+` / `-` / `n` | Sharp / flat / natural (after the note) | `C# D- En` |
| `R` | Rest | `C R C` |
| `O` number | Set the octave | `O4 C O5 C` |
| `>` / `<` | Up / down one octave | `C>C<C` |
| Number after a note | Length: 1 = whole note, 4 = quarter, 8 = eighth... Allowed: 1, 2, 3, 4, 6, 8, 12, 16, 24, 32, 48, 64, 96, 128 | `C4 D8 E8` |
| `.` after the length | Dotted (up to three dots) | `C4. D8` |
| `( )` | Play notes together (chord) | `(CEG)` |
| `@` number | Choose an instrument | `@35` |
| `V` number | Volume 0–15 (relative) | `V10` |
| `@V` number | Volume 0–127 (in decibel steps) | `@V90` |

Instrument numbers depend on the instrument set that is loaded. With the STANDARD set, `@0` is the beep, `@35` Synth Bass, `@36` piano and `@44` strings (TM pp. 84–85). Tempo (`T`), default length (`L`), loops and dynamics are in the Reference Manual (RM pp. 323–342).

### Background music and sound effects

`EFFECT n,0,"mml"` stores a tune in slot n, and `BGM n` plays it in the background while your program carries on. `VOLUME` sets the overall level. GAME BASIC shares 16 music tracks among the Saturn's 32 sound channels. Background music keeps playing after a Break.

### Learning more

Load `S_TUTOR.B` from the CD (`LOAD "CD:S_TUTOR.B",R`). It is an interactive tutorial for MML and the sound commands, with demonstrations of each feature (TM pp. 83–84). The CD also has a song editor (`T_OTO.B`) that exports MML, and an instrument editor (`T_HIBIKI.B`).

## 17. Connecting to a PC

Writing programs on a PC is much easier: you get a real editor, unlimited storage, and you can use Japanese text.

### The original setup

The **Windows communication cable** plugs into the **communication port on the back of the Saturn** (switch the Saturn off first; the plug only fits one way). Its other end is a 25-pin connector that must go to the PC through a **straight-through RS-232C modem cable**, never directly into the PC (TM pp. 9–11). The PC runs **BASTERM** from the Windows tools CD.

### The modern setup

The original cable is only an RS-232 level converter. A **5 V USB-to-TTL serial adapter** wired to the Saturn's port does the same job on any Mac, Linux or Windows computer. Wiring, parts and safety notes are in [`GAME_BASIC/USB_Serial_Connection.md`](../USB_Serial_Connection.md).

### Serial settings

| Setting | Value |
|---|---|
| Speed | 9600 (default) or 19200 baud. Must match the Saturn's **Baudrate** setting (section 6) |
| Format | 8 data bits, no parity, 1 stop bit |
| Flow control | None |

19200 is faster but more sensitive to interference. If transfers fail, use 9600 on both sides.

### How the link works

The PC acts as a file server for the `COM:` device. To send a program, the PC "types" a command such as `LOAD "COM:TBASTERM.B"` at the Saturn, and the Saturn then reads the program from the PC as a file. So anything that works with `COM:` on the Saturn (`LOAD`, `SAVE`, `FILES`, `OPEN`) needs the PC software running and connected.

## 18. BASTERM, the original Windows 95 tool

BASTERM is the editor and link program on the Windows tools CD (TM Chapter 3, pp. 145–172). It needs a Windows 95-era PC with a real serial port. A full English translation of its help file is in `GAME_BASIC/BASTERM/BASTERM_help_text_EN.txt`.

| Command | Shortcut | What it does |
|---|---|---|
| Send | Ctrl+P | Sends the program in the editor to the Saturn (it types `LOAD "COM:TBASTERM.B"` for you) |
| Receive | Ctrl+G | Fetches the Saturn's program into the editor |
| Run | Ctrl+R | Runs the program on the Saturn (stopping it first if needed) |
| Stop | Ctrl+B | Breaks the running program |
| Key send | Ctrl+K | Your PC keyboard types on the Saturn until you press Alt+K |
| Connect | | Stays connected so Saturn programs can use `COM:` files |

Useful BASTERM features:

- **Automatic line numbers.** You can write programs without numbers. BASTERM numbers them when sending (start and step are settings; a line that has its own number resets the count).
- **Checks before sending**: missing, duplicate or too-large line numbers and lines that are too long.
- **Difference send**: only changed lines are sent, merged with `LOAD ...,M`. Hold Shift while sending to force a full send.
- **`#include "FILE.B"`** pulls another file into the program when it is sent.
- **Filter**: runs a DOS program over your source before sending, for example to convert a structured BASIC dialect.

**Always check the Saturn's screen after a transfer.** If something goes wrong, BASTERM may not show an error, but the Saturn will (TM pp. 163–164). A successful send shows `Line` and the last line number, then `Ready.`.

## 19. The modern tools: VS Code and saturn_send.py

The tools in this repository replace BASTERM and run on macOS, Linux and Windows.

### VS Code extension (`GAME_BASIC/vscode-game-basic`)

It gives syntax highlighting, live error checking (the same checks as BASTERM, plus more), automatic line numbers, go-to-definition for `GOTO` targets and labels, and these commands:

| Key | Command |
|---|---|
| **F6** | Send to Saturn |
| **Shift+F6** | Send and run |
| **Ctrl+F6** | Stop |
| Command Palette, **GAME BASIC:** | Run, Receive, Type Text, Select Serial Port, Show Program as It Will Be Sent, COM: file server, Run Self-Test |

Setup, in short (the extension's README has the details):

1. Install Python 3 and pyserial (`python3 -m pip install pyserial`).
2. Install the extension, from source or as a `.vsix`.
3. Plug in the USB adapter, run **GAME BASIC: Select Serial Port**, and set **gameBasic.baudRate** to match the Saturn (section 6).
4. On the Saturn, wait at `Ready.`. Open a `.B` file in VS Code and press **F6**.

You can try everything without a Saturn by choosing **Use the mock Saturn** as the port.

Files are saved as Shift-JIS with CRLF line ends, like the files on the original CD. Turn on **gameBasic.autoLineNumbers** to write programs without line numbers, as in BASTERM.

### Command line (`GAME_BASIC/tools/saturn_send.py`)

The same link from a terminal:

```
python3 saturn_send.py ports                               # list serial ports
python3 saturn_send.py send GAME.B -p /dev/ttyUSB0 --run   # send and run
python3 saturn_send.py stop -p /dev/ttyUSB0                # break
python3 saturn_send.py receive -o BACKUP.B -p /dev/ttyUSB0 # fetch the Saturn's program
python3 saturn_send.py serve -p /dev/ttyUSB0               # act as the COM: drive
python3 saturn_send.py selftest                            # test with the mock Saturn
```

`serve` lets programs on the Saturn use `COM:` for their own files, and lets you type `FILES "COM:"`, `SAVE "COM:NAME"` and `LOAD "COM:NAME"` at the Saturn. See `tools/README.md` for all options.

## 20. Messages and errors

### What GAME BASIC prints

| Message | Meaning |
|---|---|
| `Ready.` | Waiting for input |
| `Break at 130` | The program was stopped at line 130 (A+Start or Ctrl+C). `CONT` continues |
| `Line 120` | Shown after a program arrives from the PC: the last line loaded |
| `HOT START` | GAME BASIC restarted after A+B+C+Start |

Anything else is an error message. When you type a bad line directly, GAME BASIC shows the line again with the cursor on it so you can fix it. In a program, the error is reported when the line runs.

### Error codes

Every error has a code number as well as a message. The full list is in the Reference Manual's appendix (RM pp. 391–406). It is summarised below in our own words. Codes 33, 38, 40 and 49 are not listed in the manual.

**Program and language errors**

| Code | Message | Cause |
|---|---|---|
| 1 | `NEXT without FOR` | A `NEXT` has no matching `FOR` |
| 2 | `Syntax error` | The line breaks the grammar: wrong command format, unbalanced brackets, a misplaced comma, a missing `:` and so on |
| 3 | `RETURN without GOSUB` | `RETURN` was reached without a `GOSUB` |
| 4 | `Out of DATA` | `READ` (or a command reading `DATA`, such as `SETCHR` or `SETPOLYGON`) ran out of data |
| 5 | `Illegal function call` | A command or function was called the wrong way, or with a value it can't accept |
| 6 | `Overflow` | A number became too big for fixed-point while calculating or when setting up polygons |
| 7 | `Out of memory` | Not enough memory: `CLEAR` or `DIM` asked for too much, a program is too big for the program area (when typing or with `LOAD`), or `PEEK`/`POKE` went outside the user area. **Fix:** change how memory is shared out with `CLEAR` |
| 8 | `Undefined line number` | A `GOTO`, `GOSUB` or similar points at a line number or label that doesn't exist |
| 9 | `Subscript out of range` | An array index is bigger than the size given in `DIM` |
| 10 | `Variable already defined` | `DIM` on an array that already exists |
| 11 | `Division by 0` | Dividing by zero |
| 12 | `Illegal direct` | This command can't be typed directly; it only works inside a program |
| 13 | `Type mismatch` | Wrong kind of value, for example a number put into a string variable |
| 15 | `String too long` | A string over 65535 characters, or a line typed on the edit screen that is too long |
| 16 | `Formula too complex` | An expression is too complicated, or functions are nested too deeply. Split it into steps |
| 17 | `Can't continue` | `CONT` can't resume the program from where it stopped |
| 18 | `Undefined array` | An array was used without `DIM` |
| 19 | `Dimension size error` | An array was used with a different number of dimensions from its `DIM` |
| 21 | `No RESUME` | The program ran off the end while handling an error from `ON ERROR`, without a `RESUME`. Ending with `END` is fine |
| 22 | `RESUME without error` | `RESUME` was used when there was no error to resume from |
| 23 | `Illegal line number` | An invalid line number, such as 0 or one above 99999 |
| 24 | `Stack overflow` | `FOR`/`NEXT` loops or `GOSUB` calls are nested too deeply, or a `PAINT` shape is too complicated |
| 25 | `IF stack overflow` | Block `IF`s are nested too deeply |
| 26 | `ELSE/ENDIF without IF` | An `ELSE` or `ENDIF` has no matching `IF` |
| 27 | `FOR without NEXT` | A `FOR` has no matching `NEXT` |
| 28 | `Direct statement only` | This command can only be typed directly, not used inside a program |
| 29 | `Data statement` | A string in a `DATA` line has no closing `"`. (Other commands add a missing closing quote for you, but `DATA` lines and comments don't) |
| 30 | `String format error` | The string given to `GCOPY` or `CCOPY` is not in the right format |
| 31 | `Parameter mismatch` | The values don't fit the format, for example in `PRINT USING` |
| 32 | `IF/ELSE without ENDIF` | A block `IF` or `ELSE` has no closing `ENDIF` |
| 39 | `Version mismatch` | The BASIC program was made by a different version of GAME BASIC |
| 41 | `Unusable charactor` | The line contains a character that can't be stored (the spelling is the Saturn's own) |
| 51 | `Internal error` | An error inside GAME BASIC itself |
| 58 | `Duplicated label` | The same `*label` is defined twice |
| 78 | `Invalid USERDATA` | Bad `USERDATA` |

**Graphics and polygon errors**

| Code | Message | Cause |
|---|---|---|
| 34 | `Undefined vertex` | A vertex ID that hasn't been set up was used by `SETVERTEX`, `SETPOLYGON` or `VERTEXID` |
| 35 | `Undefined polygon` | A polygon ID that hasn't been set up was used by `SETPOLYGON`, given to an object, or read with `POLYGONID` |
| 36 | `Undefined attribute` | An attribute ID that hasn't been set up was used by `SETATR` or given to an object |
| 37 | `Undefined texture` | A texture ID that hasn't been set up was used by `SETTEX`, `SETATR`, `PUTSPRITE` or `TEXID`. For `PUTSPRITE`, define the pattern with `SPRITE$` first |
| 79 | `Vertex size mismatch` | `SETVERTEX` redefined an ID with a different number of vertices |
| 80 | `Vertex number` | `SETPOLYGON` used a corner number that is not in the vertex group. Corner numbers must be 0 to (number of vertices − 1), and a polygon joins 3 or 4 of them |
| 81 | `Vertex ID over` | No more vertex IDs are available |
| 82 | `Vertex data over` | No room for more vertex data (too many vertices in one ID) |
| 83 | `Vertex out of area` | More vertices were given than `SETVERTEX` reserved |
| 84 | `Texture size mismatch` | `SETTEX` redefined a texture with a different size |
| 85 | `Texture ID over` | No more texture IDs are available |
| 86 | `Texture data over` | More texture data was given than the size in `SETTEX` |
| 89 | `Polygon size mismatch` | `SETPOLYGON` redefined an ID with a different size |
| 90 | `Polygon ID over` | No more polygon IDs are available |
| 91 | `Polygon data over` | No room for more polygon data |
| 92 | `Attribute size mismatch` | `SETATR` or `SETPFONT` redefined an attribute with a different size |
| 93 | `Attribute ID over` | No more attribute IDs are available |
| 94 | `Attribute data over` | No room for more attribute data |
| 95 | `Attribute out of area` | More data was given than the size in `SETATR` |

**File and device errors**

| Code | Message | Cause |
|---|---|---|
| 20 | `Communication error` | The PC link failed. **Fix:** check the cable, check that the PC's speed matches **Baudrate** on the settings screen (L+R+Z), then reconnect from the PC software |
| 42 | `Buffer full` | `FWRITE` wrote more than the file buffer reserved by `CLEAR` |
| 43 | `Device not connected` | `CRAM:` or the floppy drive isn't connected, or the Saturn was started without a floppy disk in the drive |
| 44 | `Device not formatted` | The floppy disk isn't formatted. **Fix:** if its contents can be erased, set the write-protect tab to writable and use `FORMAT` |
| 45 | `Device write protected` | The floppy disk's write-protect tab is set |
| 46 | `Device verify error` | The file is damaged |
| 47 | `Not enough space` | Not enough free space on `BRAM:`, `CRAM:` or the floppy disk |
| 48 | `Backup RAM error` | Any other error on `BRAM:`, `CRAM:` or the floppy disk |
| 50 | `File access error` | The PC couldn't read or write the file over `COM:` |
| 53 | `File not found` | No file with that name |
| 54 | `File already open` | `OPEN`, `KILL` or similar on a file that is already open |
| 55 | `Access past EOF` | Reading past the end of a file |
| 56 | `Bad file name` | The file name is not valid (section 8) |
| 57 | `Invalid BASIC file` | `LOAD` was used on a file that isn't a BASIC program |
| 59 | `File not OPEN` | A file number was used before `OPEN` |
| 60 | `Already formatted` | The disk is already formatted |
| 61 | `Bad file mode` | The file mode is not valid |
| 62 | `Bad device name` | The device name is not valid |
| 64 | `File still open` | A file was used while it was still open, where that isn't allowed |
| 69 | `File read error` | The file couldn't be read |
| 70 | `File write error` | The file couldn't be written |

**Sound errors**

| Code | Message | Cause |
|---|---|---|
| 14 | `Sound: MML String too short` | The MML string plays for too short a time |
| 52 | `Sound: Out of layer memory` | Not enough room for sound layers |
| 63 | `Sound: Not layer mode` | The command needs layer editing mode |
| 65 | `Sound: Command buffer full` | The sound driver's command buffer is full |
| 66 | `Sound: Out of sound memory` | Sound memory couldn't be reserved |
| 67 | `Sound: MML command error` | A mistake in an MML string. A second line gives the details (see below) |
| 68 | `Sound:Out of MML data` | The MML string ended too soon |
| 71 | `Sound: Song bank full` | The song data is bigger than the space reserved for it |
| 72 | `Sound: Layer overflow` | No more layers can be registered |
| 73 | `Sound: Tone overflow` | No more instruments can be registered |
| 74 | `Sound: VL overflow` | No more velocity-level data can be registered (layer area full) |
| 75 | `Sound: PEG overflow` | No more pitch-envelope data can be registered (layer area full) |
| 76 | `Sound: PLFO overflow` | No more pitch-LFO data can be registered (layer area full) |
| 77 | `Sound: No layer` | No layers have been registered |
| 87 | `Sound: Invalid WAVE file` | The file is not wave data |
| 88 | `Sound: Bad WAVE file format` | The wave data is in a format GAME BASIC doesn't accept |

**MML details shown with error 67.** The second line says what is wrong in the MML string. Ranges are shown in brackets.

| Detail | Meaning |
|---|---|
| `MML Syntax error` | General mistake in the MML |
| `Bad note length` | Invalid note length |
| `Velocity value(0 <=> 127)` | Velocity out of range |
| `Not gate time ratio` / `Bad gate time ratio` | The gate time (how long a note sounds within its length) is badly written / out of range |
| `Bad pitch bend value` | Invalid pitch bend |
| `Not chord '(...)'` | Badly written chord |
| `Can't nest -plets` | Triplets and other tuplets can't be nested |
| `Bad note number(0 <=> 127)` | Note out of range |
| `Bad tone number` | Invalid instrument number |
| `Bad signature(-7 <=> 7)` | Invalid key signature |
| `Bad transpose value(-127 <=> 127)` | Transpose out of range |
| `Bad tempo value(40 <=> 300)` | Tempo out of range |
| `Tempo change over` | Too many tempo changes |
| `Bad volume value(0 <=> 15 @:127)` | Volume out of range (`V` 0–15, `@V` 0–127) |
| `Bad direct pan value(0 <=> 127)` | Pan out of range |
| `Bad octave value(0 <=> 8)` | Octave out of range |
| `Not MML command` | Not an MML command |
| `Bad damper value(0 or 1)` | Damper must be 0 or 1 |
| `Macro error` | Error defining a macro |
| `Software layer error` | Invalid software-layer settings |
| `Pitch bend cmd.buffer overflow` | Too many pitch bends |
| `Not base track` | This command can only go on the base track |
| `Bad label(0 <=> 7)` | Label number out of range |
| `D.S. without '$'` | A dal segno has no matching segno (`$`) |
| `Bad '$'or'*'or'ds'position` | Segno, coda and dal segno are in the wrong order |
| `Repeat command error` | Badly written repeat |
| `Bad effect pan value(0 <=> 127)` | Effect pan out of range |
| `Bad effect level(0 <=> 7)` | Effect level out of range |
| `Bad effect number(0 <=> 15)` | Effect number out of range |
| `Not DSP mode` | The command needs DSP mode |
| `Bad DSP mixer number(0 <=> 15)` | DSP output mixer number out of range |
| `Bad status value(0 <=> 127)` | Status value out of range |
| `Not code name` | Invalid chord name |
| `Chord note over(2<=>32)` | Too many notes in a chord |

### Handling errors in your program

`ON ERROR GOTO` sends errors to your own handler. There, `ERR` holds the code from the tables above and `ERL` the line number. Finish the handler with `RESUME`, or error 21 (`No RESUME`) follows.

```basic
10 ON ERROR GOTO *OOPS
20 LOAD "BRAM:NOFILE.B"
30 END
40 *OOPS
50 IF ERR=53 THEN PRINT "NO SUCH FILE" ELSE PRINT "ERROR";ERR;"IN LINE";ERL
60 RESUME 30
```

### Common problems

| Problem | What to try |
|---|---|
| The screen is garbled or the listing is hidden after a program | Press **F12** (or Ctrl+P), or type `SCREEN 0` |
| `SAVE "BRAM:..."` fails with `Not enough space` | Backup RAM is full. Free space in the Saturn's memory manager, or save to `CRAM:` or `COM:` |
| The PC gets no answer from the Saturn | Check the cable and that the Saturn is at `Ready.`. Check the **Baudrate** on the settings screen (L+R+Z) matches the PC. If unsure, use 9600 on both |
| Transfers fail at 19200 | Use 9600 on both sides. Keep the cable away from mains equipment |
| BASTERM: "Connection to the Saturn failed. Check the connection.", or `Communication error` on the Saturn | As above: port, cable and baud rate, then reconnect |
| A program that uses `COM:` files gives errors | The PC software must be connected (BASTERM's Connect, or `saturn_send.py serve`). Close files in your program before disconnecting |
| The PC said the send worked, but the program is wrong | Look at the Saturn's screen; errors may only be shown there |
| Characters are missing when the PC types commands | Raise the key delay (`--key-delay` or `gameBasic.keyDelayMs`) |
| Japanese text looks garbled in the editor | The file is UTF-8 but opened as Shift-JIS, or the other way round. Reopen it with the right encoding |
| Typed-in listing from the book gives errors | The book wraps long lines. Join each wrapped part back onto its numbered line |

## 21. Sample programs on the CD

The CD is full of programs to run and study. List them with `FILES "CD:"` and run one with `LOAD "CD:NAME.B",R`, or use the launcher (Shift+F1). The Reference Manual's appendix lists every program with a one-line description (RM pp. 407–410), and the Tutorial Manual describes how to use each one (TM pp. 104–143). The tables below give that list in English. Indented names are the data files and helper programs that the program above them loads for you; you don't run those directly.

Japanese titles are given in romaji, with their meaning in brackets.

### Games

| File | What it is |
|---|---|
| `G_BOMB.B` | Sample game "Bomb". Supports the Multi-Terminal 6 multitap for several players |
| `G_BOU.B` | Starts the game "Bou" (stick) |
| &nbsp;&nbsp;`BOU_SCD.B` / `BOU_TCD.B` / `BOU_MCD.B` | Its title screen, texture set-up and main program |
| `G_HATA.B` | "Hata" (flags): raise the red and white flags as instructed. The Tutorial Manual's first worked game (TM p. 87) |
| `G_JUMP.B` | Sample game "Jump" |
| `G_JUMP_A.B` | "Jump" for the analogue Multi Controller (3D pad) |
| `G_JUMP_M.B` | "Jump" for the Mission Stick |
| `G_MAZE.B` | Sample game "Maze" |
| `G_MOBIL.B` | Sample game "Mobil". The Tutorial Manual's game-making chapter explains its listing line by line (TM pp. 87–103) |
| `G_MOBILS.B` | "Mobil" for the Racing Controller |
| `G_SABA.B` | "Saba" (mackerel) |
| &nbsp;&nbsp;`SABA_BG.0` | Its background picture (256 colours) |
| `G_TEKE.B` | "Teke-teke", main program |
| &nbsp;&nbsp;`TEKST.1` / `TEKEND.1` | Its opening and ending pictures (32768 colours) |
| `G_THESEU.B` | "Theseus", main program (a maze game) |
| &nbsp;&nbsp;`PALWIN.D`, `BGCHR.D`, `WLCHR.D`, `MYCHR.D`, `ENECHR.D`, `YAKCHR.D`, `HEROCHR.D` | Palette, background, wall, player, enemy, item and ending character data |
| &nbsp;&nbsp;`MAZE01.D`–`MAZE10.D` | Maze layouts for stages 1–10 (some files cover several stages) |
| &nbsp;&nbsp;`ITEM01.D`–`ITEM10.D`, `ENEM01.D`–`ENEM10.D`, `INID01.D`–`INID10.D` | Items, enemies and start-up settings for each stage |

### Polygon and graphics demos

| File | What it is |
|---|---|
| `CLOCK.B` | Clock sample |
| `DEMO.B` | GAME BASIC demonstration program |
| &nbsp;&nbsp;`FONT161.D` / `FONT162.D` | Kanji font data, loaded into memory by `KLOAD` |
| `P_CAME2.B` | Tests the `CAMERA` command |
| `P_CLOCK.B` | Clock built from polygons |
| `P_DLPLAY.B` | Polygon doll animation demo |
| &nbsp;&nbsp;`TAISOPT.D` | Its sample motion data |
| `P_DOLL.B` | Polygon doll animation program |
| &nbsp;&nbsp;`TAISO.D` | Its sample motion data |
| `P_FLOWER.B` | Texture test |
| `P_HERI.B`, `P_SHOWER.B`, `P_TANK.B`, `P_TEXMAP.B` | Polygon tests. Going by their names: a helicopter, a shower, a tank and texture mapping |
| `P_NEKO.B` | Sprite test |
| `P_PFONT.B` | Polygon font (`PFONT`) test |

### Sound and music

| File | What it is |
|---|---|
| `S_TUTOR.B` | Interactive tutorial for the sound commands and MML (TM pp. 83–84). The best place to start |
| `PLAYMIDI.B` | Converts a MIDI file to MML |
| `S_AIFF.B` | Tests PCM (sampled) sound using AIFF files |
| &nbsp;&nbsp;`BEAT_A.D`, `SAMPLE_A.D`, `WAVE1_A.D` | Its AIFF sound files |
| `S_WAVE.B` | Tests PCM sound using WAVE files |
| &nbsp;&nbsp;`BEAT_W.D`, `SAMPLE_W.D`, `WAVE1_W.D` | Its WAVE sound files |
| `S_FM_TA.B` | Tests the FM synthesiser |
| `S_GM_FM1.B`–`S_GM_FM4.B` | Four programs that build an FM instrument set laid out in General MIDI order |
| `S_CLASSI.B` | Menu of six classical pieces: Bach's *Air on the G String* (pipe organ, `S_ARIA_P.B`, and strings, `S_ARIA.B`), Chopin's *Heroic Polonaise* (`S_POLONA.B`), Gounod's *Ave Maria* (`S_MARIA.B`), Bach's *Little Fugue in G minor* (`S_FUGA.B`) and Pachelbel's *Canon* (`S_KANON.B`) |
| `S_G_ARTS.B` | Menu of eight game tunes: *Silpheed* (`S_SILPH.B`), *Zeliard* (`S_ZELIAR.B`), *Veigues* (`S_VEIGUS.B`), *Fire Hawk* (`S_F_HAWK.B`), *Alisia Dragoon* (`S_ALISIA.B`), two *Lunar* arrangements (`S_LUNARA.B`, `S_LUNARB.B`) and *Tubasa*, the *Lunar* theme (`S_TUBASA.B`) |
| `S_T_NAME.B` | Names of the instruments in the sound data, to add to your own program (TM p. 141) |

### Tools

| File | What it is |
|---|---|
| `LAUNCH.B` | File launcher: pick and run a file from any device (also started with Shift+F1) |
| `T_KAMI.B` | "Kami" (paper): a paint program. Starts with a title screen, then runs `K_MAIN.B` |
| `T_OTO.B` | "Oto" (sound): a song editor that saves MML. Runs `O_MAIN.B` and `O_SET.B`, with data in `OTO_DATA.D` |
| `T_HIBIKI.B` | "Hibiki" (resonance): an instrument editor. Runs `H_MAIN.B` and `H_SET.B`, with a background picture `HIBIKI_0.0` and instrument names in `LST1_00.D`–`LST1_15.D` (shared with `T_OTO.B`) |
| `T_KANADE.B` | "Kanade" (playing music) program (TM p. 128) |
| `TRANSFOR.B` | Copies a `.D` data file to the PC over `COM:` |
| `UD_DATA1.B`, `UD_DATA2.B` | Tests of the `USERDATA` command |

Even without reading Japanese, the game listings are good models of how a GAME BASIC program is organised: set-up, a main loop driven by labels, `PAD` input and object updates.

## 22. Character codes

`CHR$(n)` and `ASC()` use GAME BASIC's own character set (RM p. 411). It is mostly ASCII with Japanese additions, much like the character sets of 1980s Japanese home computers. Codes below 32 are control codes.

| Codes (hex) | Characters |
|---|---|
| `&H20`–`&H7E` | Standard ASCII, except that `&H5C` shows as `¥` (it still works as `\`, the whole-number divide) and `&H7C` shows as a broken bar |
| `&H80`–`&H8F` | Solid blocks of increasing height, for bar graphs |
| `&H90`–`&H9F` | Line-drawing pieces: crosses, tees, corners and lines, for drawing boxes |
| `&HA0`–`&HDF` | Half-width katakana and Japanese punctuation (the same as the standard JIS X 0201 set) |
| `&HE0`–`&HE7` | Thin horizontal lines and triangles |
| `&HE8`–`&HEB` | Card suits: ♠ ♥ ♦ ♣ |
| `&HEC` / `&HED` | ● / ○ |
| `&HEE`, `&HEF`, `&HF0` | Diagonal line pieces and a crossed box |
| `&HF1`–`&HF7` | Kanji for money and dates: 円 年 月 日 時 分 秒 (yen, year, month, day, hour, minute, second) |
| `&HF8`–`&HFB` | Arrows: → ← ↑ ↓ |
| `&HFC` | \ (a real backslash) |
| `&HFE` | ✓ |

These are the same symbols as on the software keyboard's GRPH page (section 3). For example, `PRINT CHR$(&HE9)` prints a heart.

## 23. Quick reference

| Task | How |
|---|---|
| Software keyboard | L+R+Start |
| Stop a program | A+Start, or Ctrl+C |
| Restore the screen | F12, Ctrl+P, or `SCREEN 0` |
| Settings (baud rate) | L+R+Z, or Q+E+D, then Exit and C |
| Soft reset | A+B+C+Start |
| File launcher | Shift+F1 |
| Start a new program | `NEW` |
| List / run / renumber | `LIST`, `RUN`, `RENUM` |
| Save / load | `SAVE "BRAM:NAME"`, `LOAD "BRAM:NAME"` |
| Load and run | `LOAD "CD:NAME.B",R` |
| What is on a device | `FILES "CD:"`, `FILES "BRAM:"`, `FILES "CRAM:"`, `FILES "COM:"` |
| Colour | `RGB(r,g,b)`, each 0–31 |
| Play notes | `EFFECT "@44 CDEFG"` |
| Read the pad | `IF PAD(0,1) AND @PAD_A THEN ...` |
| Send from VS Code | F6 (Shift+F6 to run as well, Ctrl+F6 to stop) |

---

*GAME BASIC for SEGA SATURN, its manuals and the CD contents are ©1998 ASCII Corp./Bits Laboratory/ESP inc. This guide is an independent description written for preservation and hobby use; page references point to the original Japanese manuals.*
