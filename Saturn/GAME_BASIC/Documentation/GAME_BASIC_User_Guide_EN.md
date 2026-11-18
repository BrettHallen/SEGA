# GAME BASIC for SEGASATURN: English User Guide

GAME BASIC for SEGASATURN (ASCII Corp., Bits Laboratory and ESP inc., 1998) is a BASIC interpreter that runs on the Sega Saturn. It was only sold in Japan, and its two manuals, the *Tutorial Manual* and the *Reference Manual*, are in Japanese.

This guide is written for English speakers who want to use GAME BASIC on a real Saturn. It is not a translation of the Tutorial Manual. It explains the important points in its own words, with short examples, and gives page numbers so you can look things up in the Japanese manual (book page numbers, "TM p. N"; Reference Manual pages are "RM p. N"). The scanned manuals are in `Documentation/Tutorial_Manual_JP/` and `Documentation/Reference_Manual_JP/`. For more detail on any topic, see `Documentation/Tutorial_Manual_findings.md`.

Where something here is worked out from the sample programs or the PC software rather than stated in the manuals, it says so.

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
22. [Quick reference](#22-quick-reference)

---

## 1. What you need

The package contains the GAME BASIC CD for the Saturn, a CD of Windows 95 tools, a serial cable for the PC (the "Windows communication cable") and the two manuals (TM p. 3).

To use it you need:

- **A Saturn and the GAME BASIC CD.**
- **A way to type.** Either a standard control pad in **controller port 1**, using the on-screen software keyboard, or the separately sold **Saturn keyboard** (TM pp. 3–4). The keyboard is much more comfortable for anything longer than a few lines.
- **Somewhere to save.** The Saturn's internal backup RAM works, but it is small (see section 8). A Power Memory cartridge gives more room.
- **Optionally, a PC link.** Writing long programs is much easier on a computer. The original cable connected to a Windows 95 PC running BASTERM. This project replaces both with a USB adapter and VS Code (sections 17–19).

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

**If you mistype**, GAME BASIC prints `Syntax error`, shows your line again with the cursor on it, and returns to `Ready.`. Fix the line and press Enter again. A mistake inside a numbered line (for example `40 NAXT I`) is only noticed when the program reaches that line.

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

Here is a short example of a spinning blue square (adapted from the structure on TM pp. 65–66, not tested on hardware):

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

This project replaces BASTERM with tools that run on macOS, Linux and Windows.

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

**Status.** The protocol was worked out from BASTERM's code and tested against a simulated Saturn. Testing on real hardware is still in progress; the open questions are listed in `tools/README.md`.

## 20. Messages and errors

### What GAME BASIC prints

| Message | Meaning |
|---|---|
| `Ready.` | Waiting for input |
| `Syntax error` | GAME BASIC could not understand the line. Typed directly, it shows the line again for you to fix. In a program, it is reported when that line runs |
| `Break at 130` | The program was stopped at line 130 (A+Start or Ctrl+C). `CONT` continues |
| `Line 120` | Shown after a program arrives from the PC: the last line loaded |
| `Overflow` | A number became too big for its type (for example when a floating-point result is turned back into fixed-point) |
| `HOT START` | GAME BASIC restarted after A+B+C+Start |

The Tutorial Manual only shows `Syntax error` and refers to the Reference Manual for the complete list of error messages. That part of the Reference Manual has not been scanned yet, so this table will grow as messages are seen on the Saturn. In the meantime, most messages are plain English and say what is wrong (for example a missing file or an undefined line).

To handle errors in your own program:

```basic
10 ON ERROR GOTO *OOPS
20 LOAD "BRAM:NOFILE.B"
30 END
40 *OOPS
50 PRINT "ERROR";ERR;"IN LINE";ERL
60 RESUME 30
```

### Common problems

| Problem | What to try |
|---|---|
| The screen is garbled or the listing is hidden after a program | Press **F12** (or Ctrl+P), or type `SCREEN 0` |
| `SAVE "BRAM:..."` fails | Backup RAM is full. Free space in the Saturn's memory manager, or save to `CRAM:` or `COM:` |
| The PC gets no answer from the Saturn | Check the cable and that the Saturn is at `Ready.`. Check the **Baudrate** on the settings screen (L+R+Z) matches the PC. If unsure, use 9600 on both |
| Transfers fail at 19200 | Use 9600 on both sides. Keep the cable away from mains equipment |
| BASTERM: "Connection to the Saturn failed. Check the connection." | As above: port, cable and baud rate |
| A program that uses `COM:` files gives errors | The PC software must be connected (BASTERM's Connect, or `saturn_send.py serve`). Close files in your program before disconnecting |
| The PC said the send worked, but the program is wrong | Look at the Saturn's screen; errors may only be shown there |
| Characters are missing when the PC types commands | Raise the key delay (`--key-delay` or `gameBasic.keyDelayMs`) |
| Japanese text looks garbled in the editor | The file is UTF-8 but opened as Shift-JIS, or the other way round. Reopen it with the right encoding |
| Typed-in listing from the book gives errors | The book wraps long lines. Join each wrapped part back onto its numbered line |

## 21. Sample programs on the CD

The CD is full of programs to run and study. List them with `FILES "CD:"` and run one with `LOAD "CD:NAME.B",R`, or use the launcher (Shift+F1). The Tutorial Manual describes each one on TM pp. 104–143.

| Prefix | What they are | Examples |
|---|---|---|
| `G_` | Games, with full source to read | `G_HATA` (flag-raising game), `G_MOBIL`, `G_BOMB`, `G_MAZE`, `G_JUMP`, `G_SABA`, `G_TEKE` |
| `P_` | Polygon and 3D demos | `P_PFONT`, `P_CLOCK`, `P_FLOWER`, `P_CAME2`, `P_TANK`, `P_HERI`, `P_DOLL` |
| `S_` | Sound and music | `S_TUTOR` (MML tutorial), music samples, `PLAYMIDI` |
| `T_` | Tools | `T_KAMI` (paint program), `T_OTO` (song editor), `T_HIBIKI` (instrument editor), `TRANSFOR` (copies a data file to the PC) |
| | Other | `LAUNCH` (file launcher) |

The Tutorial Manual walks through `G_MOBIL.B` line by line (TM pp. 87–103). Even without reading Japanese, its listing is a good model of how a GAME BASIC game is organised: set-up, a main loop driven by labels, `PAD` input and object updates.

## 22. Quick reference

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

*GAME BASIC for SEGASATURN, its manuals and the CD contents are ©1998 ASCII Corp./Bits Laboratory/ESP inc. This guide is an independent description written for preservation and hobby use; page references point to the original Japanese manuals.*
