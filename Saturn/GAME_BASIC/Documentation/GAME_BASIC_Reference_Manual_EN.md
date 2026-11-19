# GAME BASIC for SEGASATURN: Reference Manual (English translation)

This is an English translation of the *GAME BASIC for SEGASATURN Reference Manual* (リファレンスマニュアル; ASCII Corp., Bits Laboratory and ESP inc., 1998). It follows the Japanese book page by page. Page markers such as *[p. 24]* give the book page number, so any entry can be checked against the original.

Command names, syntax, example programs and screen output are kept exactly as printed. Japanese placeholder names in the syntax are translated (for example `<数値式>` becomes `<numeric expression>`). Where the original has a clear misprint it is kept and marked "(sic)", with a short note where the meaning is not obvious. Notes in square brackets in italics, such as *[p. 22 is blank]*, describe the layout of the book.

Terms used throughout:

- **Direct-mode command** (直接実行命令): can be typed and run directly at the `Ready.` prompt.
- **Program-mode command** (間接実行命令): can be used in a program line.
- **Fixed-point / floating-point** (固定小数点型 / 浮動小数点型): the two numeric types; see the basic specification.

> **Work in progress.** Translated so far: the front matter, the basic specification (pp. 1–20), Chapter 1 (pp. 21–227), Chapter 2 pp. 228–273 and 355–388, and the Appendix (pp. 389–421). Pages 274–354 are marked *pending*.

---

## Contents

- [Preface](#preface)
- [GAME BASIC for SEGASATURN: basic specification](#game-basic-for-segasaturn-basic-specification)
- [Chapter 1: Function reference](#chapter-1-function-reference)
    - [1.1 General commands](#11-general-commands)
    - [1.2 File commands](#12-file-commands)
    - [1.3 File functions](#13-file-functions)
    - [1.4 BG/text/video commands](#14-bgtextvideo-commands)
    - [1.5 BG/text/video functions](#15-bgtextvideo-functions)
    - [1.6 Sprite/3D commands](#16-sprite3d-commands)
    - [1.7 OBJ commands/functions](#17-obj-commandsfunctions)
    - [1.8 Sprite/3D functions](#18-sprite3d-functions)
- [Chapter 2: Sound reference](#chapter-2-sound-reference)
    - [2.1 Sound system specification](#21-sound-system-specification)
    - [2.2 Explanation of terms](#22-explanation-of-terms)
    - [2.3 Sound memory map](#23-sound-memory-map)
    - [2.4 Sound system block structure](#24-sound-system-block-structure)
    - [2.5 Sound commands](#25-sound-commands)
    - [2.7 Repeat structure details](#27-repeat-structure-details)
    - [2.8 Voice data details](#28-voice-data-details)
- [Appendix](#appendix)
    - [Error message and code table](#error-message-and-code-table)
    - [List of BASIC files (sample programs)](#list-of-basic-files-sample-programs)
    - [Character code table](#character-code-table)
    - [3D coordinate conversion diagrams and illustrations](#3d-coordinate-conversion-diagrams-and-illustrations)
    - [Index](#index)

---

## Preface

*[Front matter, unnumbered page]*

Thank you for purchasing "GAME BASIC for SEGASATURN", software for the Sega Saturn. Before use, please read this manual carefully and use the software correctly. This manual will not be reissued, so please keep it in a safe place.

# GAME BASIC for SEGASATURN: basic specification

*[p. 1]*

## Characters used

The characters that can be written in GAME BASIC for SEGASATURN are only the letters, digits and symbols with character codes 32 to 126. Inside a string enclosed in double quotes (`"`), characters 128 to 255 can also be used. No font is defined for character codes 0 to 31 and 127.

Lower-case letters can be typed into a program, but when the line is stored in the list, lower-case letters outside strings are automatically converted to upper case. Also, except inside strings, upper-case and lower-case letters are not distinguished.

## Numbers

There are two kinds of numeric value, "fixed-point" and "floating-point", and both can be written in exponent notation. Fixed-point numbers can also be written in binary and hexadecimal. (An integer type is not supported.)

### Fixed-point and floating-point

**■ Fixed-point**

The values that can be represented are −131071.9999 to +131071.9999. The fraction is held to a precision of 1/16384, but the display is limited to 4 decimal places. Because of this, two values can look the same on screen but not actually be the same. Also, because of the limits of the internal precision, errors can arise in the fraction. Take care, for example, when a fixed-point value is assigned to a floating-point variable: because of this error the value may not be exact.

**■ Floating-point**

The values that can be represented are −1.7976931348623156E+308 to +1.7976931348623156E+308. The exponent range is E+308 to E−324. To handle a value as floating-point you must explicitly put the type symbol sharp (`#`) at the end of the number. Without the symbol, every number is handled as fixed-point.

*[p. 2]*

> **Note.** Values below 1: for fixed-point, the integer part is left out.
> - Example: `.123`
>
> For floating-point, the integer part has a 0.
> - Example: `0.123`

### Exponent notation

To write a number in exponent form, use this format.

Format: `<mantissa> E {+|-} <exponent>`

The sign of the number itself goes in `<mantissa>`. Exponent notation is valid for both fixed-point and floating-point.

### Binary notation

For fixed-point numbers only, a number can also be written in binary in this format.

Format: `[<sign>] &B <binary value>`

Each digit of `<binary value>` is written as 0 or 1. Up to 17 digits are valid. A fraction can also be written after a period (`.`). The fraction can have up to 14 digits. For the fraction, write after the "." the numerator of a fraction whose denominator is 16384. The range of values that can be represented is −&B11111111111111111.11111111111111 to &B11111111111111111.11111111111111.

### Hexadecimal notation

For fixed-point numbers only, a number can also be written in hexadecimal in this format.

Format: `[<sign>] &H <hex value>`

Each digit of `<hex value>` is written as 0 to 9 and A to F. A to F may also be lower case. The integer part is 17 bits, and up to 5 digits are valid (the top digit can only be 0 or 1). A fraction can also be written after a period (`.`). The fraction is 14 bits, and up to 4 digits are valid (the lowest digit can only be 0, 4, 8 or C). For the fraction, write after the "." the numerator of a fraction whose denominator is 16384. The range of values that can be represented is −&H1FFFF.FFFC to &H1FFFF.FFFC. Fraction digits beyond the valid number of digits are cut off.

### Type conversion of numbers

When an operation is done between a fixed-point value and a floating-point value, it is automatically converted to a floating-point value. Also, even in an operation between two fixed-point values, if the value goes beyond the representable range during the calculation, it is converted to floating-point. Note that even in an operation between fixed-point values whose result is fixed-point, for exponentiation (`^`) only, both sides are converted to floating-point before the calculation. In commands and functions whose parameters are integer values, the fraction is INT-processed. INT processing means converting to the largest integer that does not exceed the original value.

*[p. 3]*

When a program is written, if a number beyond the fixed-point range is written, the floating-point type symbol sharp (`#`) is automatically added at the end of the number.

## Strings

Data made of a sequence of characters, each of which has one of 256 character codes, is called the string type. When writing a string, enclose it in double quotes (`"`) before and after. Depending on what a string is used for, there are the following kinds of string besides normal strings. Strings can be joined with the `+` operator.

### Empty string

A string of length 0 with no characters. To write this as a constant, write `""`.

### Binary string

A string in which each character represents a value from 0 to 255 by its character code.

### Word string

A string in which every two characters represent a value from 0 to 65535 by their character codes. The first character represents the upper part of the value and the second character the lower part.

### Binary-form string

A string made of the characters 0 and 1.

In this manual there are two ways of describing binary, so take care.

- **"○ bits"** means a width of ○ bits.
  Example: `00` is 2 bits (2 bits wide), `0000` is 4 bits (4 bits wide).
- **"bit ○"** means the ○th bit, counted from 0.
  Example: in `00100000` the bit that is set to 1 is bit 5 (the 5th bit); in `00000001` the bit that is set to 1 is bit 0 (the 0th bit).

### Hexadecimal-form string

A string made of the characters 0 to 9 and A to F. A to F may also be lower case.

*[p. 4]*

## Operators

### Logical operators

Logical operators take fixed-point values on both sides.

| Operator | Meaning |
|---|---|
| `AND` | Symbol used to get the logical product of the left and right sides |
| `NOT` | Symbol used to get the logical negation of the right side |
| `OR` | Symbol used to get the logical sum of the left and right sides |
| `XOR` | Symbol used to get the exclusive logical sum of the left and right sides |
| `AND!` | AND operation including the fraction part |
| `NOT!` | NOT operation including the fraction part |
| `OR!` | OR operation including the fraction part |
| `XOR!` | XOR operation including the fraction part |

### Arithmetic operators

| Operator | Meaning |
|---|---|
| `MOD` | Symbol used to divide the left side by the right side and get the remainder (the result of MOD includes the fraction part) |
| `¥` | Symbol used to divide the left side by the right side and get the quotient |
| `^` | Symbol used to raise the left side to the power of the right side |
| `*` | Symbol used to multiply the left and right sides |
| `/` | Symbol used to divide the left side by the right side |
| `+` | Symbol used to add the left and right sides |
| `-` | Symbol used to subtract the right side from the left side |

The operator `^` treats both sides as floating-point. The operators `¥` and `MOD` are valid only when both sides are fixed-point.

The four arithmetic operators `*`, `/`, `+` and `-` have no restriction on the type of the value.

> Translator's note: `¥` is character code &H5C, which shows as a backslash (`\`) on an ASCII PC.

### Rules for automatic type conversion

When a fixed-point value is given to the following functions and operators, it is automatically converted to floating-point.

- Operators that handle both floating-point and fixed-point
- Operators that handle floating-point only
- Functions that take both floating-point and fixed-point as parameters
- Functions that take floating-point only as parameters

When a floating-point value is given to the following functions and operators, it is automatically converted to fixed-point. However, if the value is beyond the range that fixed-point can represent, an Overflow error occurs.

- Operators that handle fixed-point only
- Functions that take fixed-point only as parameters

*[p. 5]*

### Relational operators

- Operators whose result is a truth value (−1 or 0) depending on the relation between the two sides.
- −1 is returned as the result if the relation holds, 0 if it does not.

This operation is valid when the left and right sides are both numbers or both strings.

| Operator | Meaning |
|---|---|
| `>` | The left side is greater than the right side |
| `<` | The left side is less than the right side |
| `=` | The left side and the right side are equal |
| `>=` | The left side is greater than or equal to the right side |
| `<=` | The left side is less than or equal to the right side |
| `<>` | The left side and the right side are not equal |

If both sides are numbers and their types differ, the comparison is done on the values converted to floating-point. For this reason, when values with fractions are compared, the result can contradict what the values look like, because of rounding errors.

### Other symbols

| Symbol | Meaning |
|---|---|
| `()` | An expression in brackets is calculated first |
| `+ -` | Sign of a number |

### Operator precedence

The precedence is as follows (the higher the number on the right, the earlier it is processed). Operators of the same precedence are processed from the left.

| Operator | Precedence |
|---|---|
| `()` | Highest |
| `^` | 8 |
| `+ -` (sign) | 7 |
| `NOT` | 7 |
| `NOT!` | 7 |
| `*` | 6 |
| `/` | 6 |
| `MOD` | 5 |
| `¥` | 5 |
| `+` | 4 |
| `-` | 4 |
| `<` `<=` `<>` `=` `>` `>=` | 3 |

*[p. 6]*

| Operator | Precedence |
|---|---|
| `AND` | 2 |
| `AND!` | 2 |
| `XOR` | 2 |
| `XOR!` | 2 |
| `OR` | Lowest |
| `OR!` | Lowest |

## Variables

The characters that can be used in a variable name are limited to letters and digits beginning with a letter, and the underscore (`_`). A variable name can be up to 31 characters. Using variables consumes the program area.

### Variable types

There are the following three types of variable, and each can handle only data of its own type.

**■ Fixed-point variables**

A variable name on its own is treated as fixed-point. A floating-point value can be assigned only if it does not exceed the fixed-point range. In that case the digits beyond 4 decimal places are cut off. A string cannot be assigned.

**■ Floating-point variables**

A variable name ending with the type symbol sharp (`#`) is treated as floating-point. A fixed-point value that is assigned is converted to floating-point. A string cannot be assigned.

**■ String variables**

A variable name ending with the type symbol dollar (`$`) is treated as a string. A number cannot be assigned. A string variable can hold a string of up to 65535 characters.

### Simple variables and array variables

A variable made of a variable name and a type symbol is called a simple variable and can hold any one item of data. By declaring it with the DIM command, you can also use an array variable, which holds several items of data under the same variable name.

An array variable holds one item of data for each element, managed by subscripts given in `()` right after the variable name and type symbol. An array variable with one subscript is called a one-dimensional array; likewise one with two subscripts is called two-dimensional and one with three three-dimensional. The maximum number of dimensions is 16. The largest subscript that can be used in one dimension is the upper limit of fixed-point values (131071) (but this depends on the space left in the program area).

*[p. 7]*

## Programs

### Multi-statements

By separating commands and expressions (including functions) with the statement separator colon (`:`), several can be written and run on one line. A multi-statement can be up to 255 characters, including the line number.

### Program list

The order in which statements are run is shown by numbers, called line numbers. What is written in the following syntax is called the program list.

```
<line number> <statement>[:[<statement>]...]
```

The `<statement>` above is a command or an expression.

The program that can be stored on one line is at most 255 characters for `<line number>` + `<statement>`.

### Line number limits

The values valid as line numbers are the integers from 1 to 99999.

### Labels

A label starts with an asterisk (`*`). The characters that can be used in a label name are letters and digits beginning with a letter, and the underscore (`_`); a label name can be up to 31 characters. A label is defined right after the line number. In this way, in every command that deals with line numbers, a label can be used instead of a line number unless stated otherwise. The same label name cannot be defined more than once in one program list.

## Memory

All information such as programs and variables is recorded in memory. The main areas of memory are as follows. These areas are expressed in units of blocks (256 bytes).

### Program area

The area where the program list you have created and stored, the variables used, the declared array variables and so on are kept. The remaining space in this area can be obtained with `FRE(0)`.

### User area

Part of the program area's memory, reserved as user-area memory. The reserved memory is protected by the system. The area is reserved with the CLEAR command. Data in this area is read and written with the USERDATA command, the POKE command and the PEEK function. The data in the area can be written out and read in with the BSAVE and BLOAD commands. The remaining space in this area can be obtained with `FRE(1)`.

*[p. 8]*

### File area

Part of the program area's memory, reserved for exchanging data with files. The reserved memory is protected by the system. The area is reserved with the CLEAR command. The size of this area is the size of file that can be exchanged. The remaining space in this area can be obtained with `FRE(2)` and `FRE(3)`.

## Files

### Device names

Each device can be used by using the following names.

| Device | Meaning |
|---|---|
| `BRAM:` | Saturn (console) RAM |
| `CRAM:` | Cartridge RAM |
| `FD0:` | FD partition 1 |
| `FD1:` | FD partition 2 |
| `COM:` | The host PC's current drive |
| `CD:` | Built-in CD drive |

However, to use the host PC's drive, the dedicated communication software "BASTERM.EXE" is needed.

### File names

The characters that can be used in a file name are limited to letters, digits and the underscore (`_`). A file name can be up to 8 characters. A file extension showing its contents is added to the file name. In a file name the 9th character is a period (`.`) and the 10th character is the file extension. Any extension can be given in the FILES command and the `FILES$()` function, but in other commands it is added to the file name automatically, so you don't need to give it.

### Kinds of file extension

| Extension | Contents |
|---|---|
| `*.D` | Files created with the OPEN command and the BSAVE command |
| `*.B` | BASIC programs |
| `*.0` | Bitmap data in 256-palette mode |
| `*.1` | Bitmap data in 32768-colour mode |

### Wildcards

Use a question mark (`?`) to match any one character, and an asterisk (`*`) to match any 8 characters plus the extension.

> **Note.** `"*"` is `"????????.?"`

In a search file name containing wildcards, up to the first 8 characters are valid.

*[p. 9]*

**Examples**

```
"SEGA*"   → processed as "SEGA????.?"
"?_*.B"   → processed as "?_??????.B"
"*TEST"   → processed as "????????.?"
"X??.?"   → processed as "X??     .?"
```

### File numbers and file buffers

The maximum number of files that can be handled by the OPEN command and the like is 2. Only the two file numbers #1 and #2 can be used (the `#` before the number can be left out). The size of file that the file input/output commands can handle depends on the size of the file area reserved with the CLEAR command. Files larger than the file area cannot be exchanged.

## Reserved words

**BASIC reserved word list** (pp. 9–10)

`ABS` `ACTIVE` `ASC` `ATN` `ATRID` `BEEP` `BGM` `BIN$` `BINHEX$` `BITW$` `BLOAD` `BSAVE` `CAMERA` `CCOPY` `CHR$` `CINT` `CIRCLE` `CLEAR` `CLOSE` `CLS` `COLOR` `COLOROFS` `CONT` `COPY` `COS` `DATA` `DATE$` `DELETE` `DIM` `DISPLAY` `DSKF` `DSP` `EDIT` `EFFECT` `EG` `ELSE` `END` `ENDIF` `ERL` `ERR` `ERROR` `EXP` `FILES` `FILES$` `FIND` `FIX` `FKEY` `FOR` `FORMAT` `FRAC` `FRE` `FREAD` `FWRITE` `GCOPY` `GETCHR` `GLOAD` `GOSUB` `GOTO` `GSAVE` `HEX$` `HEXBIN$` `IF` `INKEY$` `INPUT` `INPUT$` `INSTR` `INT` `INTERVAL` `KILL` `KLOAD` `KPRINT` `LEFT$` `LEN` `LET` `LFO` `LINE` `LIST` `LOAD` `LOC` `LOCATE`

*[p. 10]*

`LOCK` `LOF` `LOG` `MID$` `MMLSTAT` `MOSAIC` `NEW` `NEXT` `OBJ` `OBJATR` `OBJLINK` `OBJPOS` `OBJROT` `OBJTURN` `OBJTYPE` `OBJZOOM` `OFF` `ON` `OPEN` `OPTION` `PAD` `PAINT` `PALETTE` `PEEK` `PEEK$` `PLAY` `PLAYCONT` `PLAYFADE` `PLAYINIT` `PLAYPAN` `PLAYPAUSE` `PLAYSTAT` `PLAYSTOP` `PLAYTEMPO` `POINT` `POKE` `POLYGONID` `POS` `PRINT` `PRIORITY` `PSET` `PUTCHR` `PUTSPRITE` `RANDOMIZE` `READ` `READCHR$` `READHEX$` `REM` `RENUM` `RESTORE` `RESUME` `RETURN` `RGB` `RGBADD` `RGBTO` `RIGHT$` `RND` `ROTATE` `ROTCENTER` `ROTOVER` `ROTPOS` `ROTZOOM` `RUN` `SAVE` `SCREEN` `SCROLL` `SEEK` `SETATR` `SETCHR` `SETDISP` `SETLIGHT` `SETPERS` `SETPFONT` `SETPOLYGON` `SETSONG` `SETSPRITE` `SETTEX` `SETVERTEX` `SFRE` `SGN` `SHIFT` `SIN` `SKCLOSE` `SPACE$` `SPRITE$` `SPRWINDOW` `SQR` `STEP` `STOP` `STR$` `STRING$` `STRW$` `SWAP` `TAN` `TARG` `TEXID` `TFRE` `THEN` `TIMER` `TLIST` `TO` `TPROP` `UNLOCK` `USERDATA` `USING` `VAL` `VERSION` `VERTEXID` `VOLUME` `VSYNC` `WADD$` `WANDOR$` `WIDTH` `WINDOW` `WMUL$` `WXOR$` `XATN` `XCOS` `XDIST` `XSIN` `XSQR` `XTAN` `ZOOM`

*[p. 11]*

## Operators

**BASIC operator list**

`AND` `NOT` `OR` `XOR` `AND!` `NOT!` `OR!` `XOR!` `MOD` `¥` `^` `*` `+` `-` `/` `<` `<=` `<>` `=` `>` `>=` `(` `)`

## BASIC constant table

`@` + `<constant name>` gives the following values.

| Constant name | Value | Contents |
|---|---|---|
| `TYPE` | 0 | OBJECT type |
| `FLAG` | 1 | Auxiliary flag |
| `GROUP` | 2 | OBJECT group |
| `XP` | 4 | X position |
| `YP` | 5 | Y position |
| `ZP` | 6 | Z position |
| `XR` | 8 | X rotation angle |
| `YR` | 9 | Y rotation angle |
| `ZR` | 10 | Z rotation angle |
| `XS` | 12 | X scale |
| `YS` | 13 | Y scale |
| `ZS` | 14 | Z scale |
| `ATR` | 16 | Attribute ID number |
| `POLYGON` | 17 | Polygon ID number |
| `ORDER` | 18 | Order of move/rotate transformation |
| `TIME` | 19 | Display time |

*[p. 12]*

| Constant name | Value | Contents |
|---|---|---|
| `PARENT` | 20 | Link structure: parent OBJ number |
| `CHILD` | 21 | Link structure: child OBJ number |
| `LEFT` | 22 | Link structure: elder sibling OBJ number |
| `RIGHT` | 23 | Link structure: younger sibling OBJ number |
| `XV` | 24 | X velocity |
| `YV` | 25 | Y velocity |
| `ZV` | 26 | Z velocity |
| `XA` | 28 | X acceleration |
| `YA` | 29 | Y acceleration |
| `ZA` | 30 | Z acceleration |
| `XL` | 32 | X velocity limiter |
| `YL` | 33 | Y velocity limiter |
| `ZL` | 34 | Z velocity limiter |
| `XRV` | 36 | X rotation speed |
| `YRV` | 37 | Y rotation speed |
| `ZRV` | 38 | Z rotation speed |
| `XP0` | 48 | 4-point sprite vertex X0 |
| `YP0` | 49 | 4-point sprite vertex Y0 |
| `XP1` | 50 | 4-point sprite vertex X1 |
| `YP1` | 51 | 4-point sprite vertex Y1 |
| `XP2` | 52 | 4-point sprite vertex X2 |
| `YP2` | 53 | 4-point sprite vertex Y2 |
| `XP3` | 54 | 4-point sprite vertex X3 |
| `YP3` | 55 | 4-point sprite vertex Y3 |
| `XD` | 56 | X position on the screen |
| `YD` | 57 | Y position on the screen |
| `ZD` | 58 | Z position from the screen |
| `RD` | 59 | RADIUS/ZD |
| `GTEST` | 60 | Collision-detection group setting |
| `RADIUS` | 61 | Radius for contact detection |

*[p. 13]*

| Constant name | Value | Contents |
|---|---|---|
| `COLIDIST` | 62 | Contact flag and its distance |
| `COLIOBJ` | 63 | Number of the OBJECT contacted |
| `MATRIX` | 64 | Matrix used for the perspective transformation |
| `PAD_A` | &H400 | Control pad A button |
| `PAD_B` | &H100 | Control pad B button |
| `PAD_C` | &H200 | Control pad C button |
| `PAD_X` | &H40 | Control pad X button |
| `PAD_Y` | &H20 | Control pad Y button |
| `PAD_Z` | &H10 | Control pad Z button |
| `PAD_R` | &H80 | Control pad R button |
| `PAD_L` | &H8 | Control pad L button |
| `PAD_RIGHT` | &H8000 | Control pad direction button, right |
| `PAD_LEFT` | &H4000 | Control pad direction button, left |
| `PAD_DOWN` | &H2000 | Control pad direction button, down |
| `PAD_UP` | &H1000 | Control pad direction button, up |
| `PAD_START` | &H800 | Control pad Start button |
| `BEND` | 0 | Bend range |
| `LAYER` | 1 | Number of layers − 1 |
| `TONE` | 2 | Number of voices − 1 |
| `SN` | 10 | Start note |
| `EN` | 11 | End note |
| `BN` | 12 | Base note |
| `FT` | 13 | Fine tune |
| `AR` | 20 | Attack rate |
| `DR` | 21 | Decay rate |
| `SR` | 22 | Sustain rate |
| `RR` | 23 | Release rate |
| `SL` | 24 | Sustain level |
| `EGHOLD` | 25 | EG hold mode |
| `LSLINK` | 26 | Loop start link |

*[p. 14]*

| Constant name | Value | Contents |
|---|---|---|
| `KS` | 27 | Key rate scaling |
| `SDIR` | 30 | Sound direct |
| `SB` | 31 | Source bit control |
| `SS` | 32 | Sound source control |
| `LOOP` | 33 | Loop control |
| `PCM8B` | 34 | Waveform data word length |
| `LSA` | 35 | Loop start address |
| `LEA` | 36 | Loop end address |
| `RE` | 50 | LFO reset |
| `LFOF` | 51 | LFO frequency |
| `ALFOWS` | 52 | ALFO (amplitude modulation) waveform select |
| `ALFOS` | 53 | ALFO (amplitude modulation) depth |
| `PLFOWS` | 54 | PLFO (frequency modulation) waveform select |
| `PLFOS` | 55 | PLFO (frequency modulation) depth |
| `MDX` | 60 | Modulation input X select (layer number) |
| `MDY` | 61 | Modulation input Y select (layer number) |
| `MDL` | 62 | Modulation level |
| `ISEL` | 70 | Input select |
| `IMIX` | 71 | Input mix level |
| `DSEND` | 72 | Direct data send level |
| `DPAN` | 73 | Direct data pan |
| `REV` | 0 | STEREO REVERB |
| `DEL` | 1 | STEREO DELAY |
| `DST` | 2 | DISTORTION |
| `SAW` | 0 | Sawtooth wave |
| `SQU` | 1 | Square wave |
| `TRI` | 2 | Triangle wave |
| `NOISE` | 3 | Noise |

*[p. 15]*

## Editing

A program list is entered (stored as a program) by writing a number that is the line number at the start of the line, followed by commands and so on. Press the [Enter] key to store the program list you have typed. To run a command directly, write the command from the start of the line and press the [Enter] key.

```
100 PRINT 10/2 [Enter]   → stores the line in the program
PRINT 10/2 [Enter]       → runs it directly
```

When editing on the screen, up to 255 characters can be typed, including the line number and not counting leading and trailing spaces.

### Input during screen editing

If the line being typed does not fit on one line of the screen, the system automatically joins it with the next line, and you can keep typing. To join an upper and a lower line on purpose, move the cursor to the right-hand end of the upper line in overwrite mode and type a suitable character. If typing in insert mode reaches the next line, a new line is inserted right after it and the following lines scroll down. However, if the line being typed is at the bottom two lines of the screen, the whole screen scrolls up and a new line is inserted. Switch between insert mode and overwrite mode with the [Insert] key (or [Ctrl]+[V]).

In the following table [Ctrl] means pressed together with the Control key and [Shift] together with the Shift key. Keys separated by brackets `()` have the same function.

| Key | Function and action |
|---|---|
| [Ctrl]+[C] | Cancels the line being typed and moves the cursor to the next line. On the bottom line the screen scrolls up |
| [Ctrl]+[K] | Erases from the cursor position to the end of the joined line. If the erased area covered several lines, the joins between those lines are released |
| [Ctrl]+[L] | Shows the string deleted with [Ctrl]+[K] at the cursor position |
| [Ctrl]+[P] | Panic recovery key. Runs `SCREEN 0` and gives the text screen for editing |
| [Ctrl]+[T] | Deletes the word at the cursor position. All the joined characters after it move forward by the number of characters deleted. If the cursor is in the middle of a word, the part from the cursor on is deleted |

*[p. 16]*

| Key | Function and action |
|---|---|
| [BackSpace] ([Ctrl]+[H]) | Deletes the character just before the cursor, and all the joined characters after it move forward by one character. If pressed at the start of a line, the character at the cursor position is deleted |
| [Insert] ([Ctrl]+[V]) | Switches between insert mode and overwrite mode |
| [Delete] ([Ctrl]+[G]) | Deletes the character at the cursor position. All the joined characters after it move forward by one character |
| [Home] ([Ctrl]+[B]) | Moves the cursor to the start of the line |
| [End] ([Ctrl]+[N]) | Moves the cursor to the position after the end of the line. If the end of the line is at the right-hand edge, it moves to the end of the line |
| [Tab] ([Ctrl]+[I]) | Moves to the bracket that matches the `()`, `{}` or `[]` at the cursor position |
| [Shift]+[Home] ([Ctrl]+[Q]) | Clears the text screen |
| [Shift]+[End] ([Ctrl]+[U]) | Restores the contents of the line typed before at the cursor position |
| [PageUp] ([Ctrl]+[W]) | Program editing: shows the program line before the line last edited |
| [PageDown] ([Ctrl]+[Z]) | Program editing: shows the program line after the line last edited |
| [→] ([Ctrl]+[D]) | Moves the cursor one character right. Lines are not joined even if it crosses a line boundary |
| [←] ([Ctrl]+[S]) | Moves the cursor one character left. Lines are not joined even if it crosses a line boundary |
| [↑] ([Ctrl]+[E]) | Moves the cursor up one line |
| [↓] ([Ctrl]+[X]) | Moves the cursor down one line |
| [Ctrl]+[→] ([Ctrl]+[F]) | Moves the cursor to the next word boundary |
| [Ctrl]+[←] ([Ctrl]+[A]) | Moves the cursor to the previous word boundary |
| [Enter] ([Ctrl]+[M]) | Stores the line typed, or runs the command |
| [Shift]+[Enter] ([Ctrl]+[J]) | Makes an empty line after the cursor line and moves the cursor to it. The empty line and the line after it are not joined |

> **Note.** When moving with [Ctrl]+[→], [Ctrl]+[←] and so on, the cursor stops at word boundaries: the boundary of a variable name, the boundary between different runs of symbols, and the boundary of lines that are not joined.

*[p. 17]*

### Input during line editing

When input is taken with the INPUT command and the like, some operations act differently from screen editing. Lines being typed are not joined; input is on that line only.

In the following table [Ctrl] means pressed together with the Control key and [Shift] together with the Shift key.

| Key | Function and action |
|---|---|
| [Ctrl]+[C] | Stops the input. While a program is running, stops the program |
| [Ctrl]+[K] | Erases from the cursor position to the end of the line |
| [Ctrl]+[P] | No effect |
| [Ctrl]+[T] | Deletes the word at the cursor position. All the characters after it move forward by the number of characters deleted |
| [BackSpace] ([Ctrl]+[H]) | Deletes the character just before the cursor, and all the joined characters after it move forward by one character. If pressed at the start of a line, the character at the cursor position is deleted |
| [Insert] ([Ctrl]+[V]) | Switches between insert mode and overwrite mode |
| [Delete] ([Ctrl]+[G]) | Deletes the character at the cursor position. All the characters after it move forward by one character |
| [Home] ([Ctrl]+[B]) | Moves the cursor to the start of the input line (just after the prompt) |
| [End] ([Ctrl]+[N]) | Moves the cursor to the position after the end of the line |
| [Tab] ([Ctrl]+[I]) | Moves to the bracket that matches the `()` at the cursor position |
| [Shift]+[Home] ([Ctrl]+[Q]) | Clears the input line only |
| [Shift]+[End] | No effect |
| [PageUp] ([Ctrl]+[W]) | No effect |
| [PageDown] ([Ctrl]+[Z]) | No effect |
| [→] ([Ctrl]+[D]) | Moves the cursor one character right. No effect at the end of the line |
| [←] ([Ctrl]+[S]) | Moves the cursor one character left. No effect at the input start position |
| [↑] ([Ctrl]+[E]) | No effect |

*[p. 18]*

| Key | Function and action |
|---|---|
| [↓] ([Ctrl]+[X]) | No effect |
| [Ctrl]+[→] ([Ctrl]+[F]) | Moves the cursor to the next word boundary, within the input line |
| [Ctrl]+[←] ([Ctrl]+[A]) | Moves the cursor to the previous word boundary, but not to the left of the input start position |
| [Enter] ([Ctrl]+[M]) | Ends the input. Trailing spaces are not included in the input |
| [Shift]+[Enter] ([Ctrl]+[J]) | No effect |

## Function keys

A string is defined for each of the keys [F1] to [F12]. Function keys are defined and checked with the FKEY command.

The function key definitions when BASIC starts:

```
FKEY 1,CHR$(10)+"EDIT ."+CHR$(13)
FKEY 2,CHR$(10)+"EDIT"+CHR$(13)
FKEY 3,CHR$(10)+"LIST "
FKEY 4,CHR$(10)+"LIST"+CHR$(13)
FKEY 5,CHR$(10)+"RUN"+CHR$(13)
FKEY 6,CHR$(2)+"DELETE "
FKEY 7,CHR$(10)+"CONT"+CHR$(13)
FKEY 8,CHR$(10)+"FILES"+CHR$(34)
FKEY 9,CHR$(2)+"RENUM"
FKEY 10,"LOAD"+CHR$(34)+STRING$(8,4)+CHR$(11)+CHR$(14)+CHR$(34)
FKEY 11,CHR$(10)+"FIND"+CHR$(34)
FKEY 12,CHR$(16)
```

## Resetting the BASIC system

If BASIC should become impossible to operate, hold down the A, B and C buttons of the controller connected to control port 1 (if several are connected, the controller in the lowest-numbered port) and press the Start button. BASIC moves to its opening screen and shows "HOT START" (soft reset). If you soft reset again in this state, it moves to the Sega Saturn's multiplayer screen.

When you soft reset, the contents of the BASIC program are not always guaranteed. If the BASIC program has been damaged, clear the program and

*[p. 19]*

restart BASIC; the message shown when the BASIC system starts appears instead of "HOT START". A soft reset initialises variables, the file buffers and the user area as if by `CLEAR 0,64,64`. Sound memory is initialised to its power-on state.

## Setting BASIC's initial values

### Before you start

You can adjust some of BASIC's settings to suit your setup. On the edit screen (with the cursor "_" blinking), if the input device connected to control port 1 is:

- a control pad: hold the L and R buttons and press the Z button;
- a Sega Saturn keyboard: hold the [Q] and [E] keys and press the [D] key,

the system settings screen appears.

On this screen, move the blinking cursor up and down with the direction buttons to choose a setting, and change its value with left and right. When you have finished, move the cursor to the Exit item and press the C button to go back to the edit screen.

The settings are as follows.

**■ Baudrate: 19200BPS or 9600BPS**

Sets the communication speed for connecting to a PC. You must choose the same speed as the communication software. If communication errors occur, set it to 9600BPS.

**■ Keyboard: Sega Saturn keyboard settings**

| Item | Values |
|---|---|
| INITIAL | 4–255: the time, in frames, from first pressing a key until repeat starts |
| AFTER | 1–255: the keyboard repeat interval, in frames |
| Ctrl key | NORMAL or SWAP: choosing SWAP swaps the actions of the Sega Saturn keyboard's [Ctrl] key and [Caps Lock] key |

> **Note.** A "frame" is the unit in which BASIC updates the display. When BASIC starts, 1 frame = 1/60 second, but this can be changed with the SCREEN command.

**■ Edit width: the screen state set when the [F12] key or [Ctrl]+[P] is pressed**

| Item | Meaning |
|---|---|
| Width LEFT | Position of the left edge |
| Width TOP | Position of the top edge |
| Width RIGHT | Position of the right edge |
| Width BOTTOM | Position of the bottom edge |
| Color RED | 0–15: red component of the background colour |
| Color GREEN | 0–15: green component of the background colour |
| Color BLUE | 0–15: blue component of the background colour |

*[p. 20]*

> **Note.** The Edit width setting does not affect the SCREEN command.

This sets the text display size that is set when [Ctrl]+[P] (or, by default, the [F12] key) is pressed on the edit screen. You can adjust it to suit the display you are using.

If the right edge is set near the maximum (127), on some televisions the character in the first column may appear when the cursor moves near the right edge. This is a characteristic of the hardware: columns 0 and 127 of the scroll screen appear to be joined, so they are not actually joined as a string. In that case, reduce the value of the right edge.

> **Note.** The settings are saved in the console's memory, in the Sega Saturn multiplayer screen's data management, as
>
> | Name | Comment |
> |---|---|
> | GBASICSS_01 | Config |
>
> Deleting this file returns all the settings to their initial state. This data uses 1 block.
>
> **Default settings**
>
> | Setting | Item | Default |
> |---|---|---|
> | Baudrate | | 9600BPS |
> | Keyboard | INITIAL | 17 |
> | | AFTER | 3 |
> | | CTRL | NORMAL |
> | Edit Width | LEFT | 1 |
> | | TOP | 1 |
> | | RIGHT | 38 |
> | | BOTTOM | 26 |
> | Color | RED | 0 |
> | | GREEN | 0 |
> | | BLUE | 0 |

# Chapter 1: Function reference

*[p. 21: chapter title page. p. 22 is blank.]*

## 1.1 General commands

*[p. 23]*

Each BASIC command is described in the following format.

| Item | Description |
|---|---|
| (dark bar) | The command name is shown on this bar |
| (light bar) | The kind of command is shown on this bar |
| **Function** | What the command does |
| **Syntax** | The syntax of the command |
| **Example** | A sample of how the command is actually written and used |
| **[Parameters]** | The values given to the command and what they mean |
| **[Return value]** | For a function, what the command returns |
| **[Details]** | A more detailed description of the command |

The symbols used in the syntax mean the following.

- A part enclosed in `[ ]` can be left out.
- A part enclosed in `< >` cannot be left out. However, if there is a `[ ]` outside it, it can be left out within that `[ ]`.
- `{n|m}` means choose either the n form or the m form.
- In "2.5 Sound commands" and "2.6 MML details" (the sound chapters), a part enclosed in `{ }` can be repeated in the same form.

If a parameter is left out and more parameters follow it, put a comma in the place of the parameter to separate them.

> In this translation each command is headed with its name, followed by its kind in italics.

*[p. 24]*

### ABS

*Fixed-point, floating-point function*

**Function:** Returns the absolute value.

**Syntax:** `ABS(<numeric expression>)`

**Example:**
```
PRINT ABS(-5)
```

**[Parameters]**
- `<numeric expression>`: a numeric expression. Both fixed-point and floating-point values are valid.

**[Return value]** Returns the absolute value of the number given by `<numeric expression>`.

**[Details]** The type of the value of the numeric expression (fixed-point or floating-point) does not change. The absolute value is the number that expresses the absolute distance from the origin (0) on the number line; whether the number given is positive or negative, the result is always positive.

### ASC

*Fixed-point function*

**Function:** Returns a character code.

**Syntax:** `ASC(<string expression>)`

**Example:**
```
A = ASC("A")
PRINT ASC(A$)
```

**[Parameters]**
- `<string expression>`: a string expression.

**[Return value]** Returns the character code of the first character of the string given by `<string expression>`. The type of the return value is fixed-point.

**[Details]** Returns the character code of the first character of the string given by `<string expression>`.

*[p. 25]*

### ATN

*Floating-point function*

**Function:** Returns the arc tangent.

**Syntax:** `ATN(<ratio>)`

**Example:**
```
A# = ATN(1)
PRINT ATN(X#/Y#)
```

**[Parameters]**
- `<ratio>`: a floating-point numeric expression. If the result of the expression is fixed-point, it is converted to floating-point before being given.

**[Return value]** The type of the return value is floating-point. The unit is radians (2π = 360°).

**[Details]** Returns the angle that corresponds to the `<ratio>` given by the numeric expression. The numeric expression given as the argument is the ratio between the side opposite the angle sought and the side between the angle sought and the right angle. If the argument is negative, the sign is reflected in the return value.

**[Example]**
```
PRINT ATN(SQR(3))*3   → shows " 3.14159265358979"
```

### BIN$

*String function*

**Function:** Converts a number to a binary-form string.

**Syntax:** `BIN$(<numeric expression>[,<suppress>])`

**Example:**
```
A$ = BIN$(10)
PRINT BIN$(A,2)
```

**[Parameters]**
- `<numeric expression>`: a fixed-point numeric expression.
- `<suppress>`: a fixed-point numeric expression. The valid range is 0 to 3 (any fraction is cut off).

**[Return value]** The return value is a binary-form string.

**[Details]** Converts the number given by `<numeric expression>` to a binary-form string and returns it. If `<numeric expression>` is negative, a minus sign (`-`) is put at the start of the string.

*[p. 26]*

If `<numeric expression>` is not negative, a space is put at the start of the string.

`<suppress>` says whether missing digits after conversion are filled with "0", and is handled as follows depending on its value.

| Value | Meaning |
|---|---|
| 0 | Missing digits are not filled with "0" (default) |
| 1 | Only the integer part is filled with "0"; the fraction is not |
| 2 | Only the fraction is filled with "0"; the integer part is not |
| 3 | Both the integer part and the fraction are filled with "0" |

A "." is added between the integer part and the fraction of the return value.

**[Example]**
```
PRINT BIN$(123.25)     → shows " 1111011.01"
PRINT BIN$(123.25,1)   → shows " 00000000001111011.01"
PRINT BIN$(123.25,2)   → shows " 1111011.01000000000000"
PRINT BIN$(123.25,3)   → shows "000000000001111011.01000000000000"
PRINT BIN$(-123.25)    → shows "-1111011.01"
```

### BINHEX$

*String function*

**Function:** Converts a binary string to a hexadecimal-form string.

**Syntax:** `BINHEX$(<source string>[,<separator>])`

**Example:**
```
A$ = BINHEX$("ABC")
PRINT BINHEX$(D$,",")
```

**[Parameters]**
- `<source string>`: a string expression.
- `<separator>`: a string expression.

**[Return value]** The return value is a hexadecimal-form string. If `<separator>` is given, the string returned has the separator added every 2 digits.

**[Details]** Treats the string given by `<source string>` as binary data, turns it into numbers and converts it to a hexadecimal-form string of 2 digits per character. It is turned into numbers by taking the character code of each character from the start, and the hexadecimal string is output in units of 2 digits per character.

If a `<separator>` string is given, its first character is used as the separator, and the result is returned with the separator added every 2 digits. If `<separator>` is an empty string or is left out, it is treated as having no separator.

*[p. 27]*

**[Example]**
```
PRINT BINHEX$("ABC")          → shows "414243"
PRINT BINHEX$("ABC","")       → shows "414243"
PRINT BINHEX$("ABC",";")      → shows "41;42;43"
PRINT BINHEX$("ABC",",/;¥")   → shows "41,42,43"
```

### BITW$

*String function*

**Function:** Converts the bit width of the data in a string.

**Syntax:** `BITW$(<source string>,<input bit width>,<output bit width>[,<add value>])`

**Example:**
```
PRINT BINHEX$(BITW$(HEXBIN$("12"),16, 16))
1200
```

**[Parameters]**
- `<conversion bit width>`: fixed-point; one of 4, 8 or 16.
- `<output bit width>`: fixed-point; one of 4, 8 or 16.
- `<add value>`: fixed-point.
- `<source string>`: the input string to convert.

In each case the fraction is cut off.

**[Return value]** Returns the string made by taking `<source string>` in order from the first character in pieces of `<input bit width>` and converting them to `<output bit width>`. It is used for things like converting the number of colours of dot data.

**[Details]**

**(1) When `<input bit width>` <= `<output bit width>`**

Takes `<input bit width>` from `<source string>`, adds `<add value>` to make a string of `<output bit width>`, and repeats this for the length of the string.

Example:
```
PRINT BINHEX$(BITW$(HEXBIN$("1234"), 4, 8) ,",")
01,02,03,04
PRINT BINHEX$(BITW$(HEXBIN$("1234"), 4,16,&hFFF0) ,",")
FF,F1,FF,F2,FF,F3,FF,F4
```

**(2) When `<input bit width>` > `<output bit width>`**

Takes `<input bit width>` from `<source string>`, adds `<add value>`, and makes a string cut down to `<output bit width>`; this is repeated for the length of the string.

*[p. 28]*

Example:
```
PRINT BINHEX$(BITW$(HEXBIN$("12345678"), 8, 4) ,",")
24,68
PRINT BINHEX$(BITW$(HEXBIN$("12345678"),16, 4) ,",")
48
```

**[Supplement]** If the source string is shorter than `<input bit width>`, the data is made by assuming the last data is 0 (this can only happen with a 16-bit width).

### CHR$

*String function*

**Function:** Returns the character for the given character code.

**Syntax:** `CHR$(<character code>)`

**Example:**
```
A$ = CHR$(65)
PRINT CHR$(A AND 255)
```

**[Parameters]**
- `<character code>`: a fixed-point numeric expression. The valid range is 0 to 255 (any fraction is cut off).

**[Return value]** Returns one character, the character for `<character code>`.

**[Details]** Codes 0 to 31 return control-code characters (with no font).

| Code | Meaning |
|---|---|
| `CHR$(&H00)` | Null character (not the same as the empty string) |
| `CHR$(&H05)` | Erases from the cursor position to the right-hand end of the same line |
| `CHR$(&H09)` | Tab. Moves the cursor to the next column position in units of 8 columns from the left edge of the screen |
| `CHR$(&H0A)` | Line feed (LF). Moves the cursor down one line |
| `CHR$(&H0B)` | Home position. Moves the cursor to LOCATE position (0,0) |
| `CHR$(&H0C)` | Clear screen. Erases the text inside WIDTH and moves the cursor to position (0,0) |
| `CHR$(&H0D)` | Carriage return (CR). Moves the cursor to the left edge |
| `CHR$(&H13)` | SCROLL DOWN from the cursor line downwards. The cursor position does not change |
| `CHR$(&H1C)` | Cursor movement (right) |
| `CHR$(&H1D)` | Cursor movement (left) |
| `CHR$(&H1E)` | Cursor movement (up) |
| `CHR$(&H1F)` | Cursor movement (down) |

*[p. 29]*

### CINT

*Fixed-point function, floating-point function*

**Function:** Returns the value made into an integer by rounding the fraction.

**Syntax:** `CINT(<numeric expression>)`

**Example:**
```
A = CINT(12.5)
PRINT CINT(X/10)
```

**[Parameters]**
- `<numeric expression>`: a fixed-point or floating-point numeric expression.

**[Return value]** Returns the value given by `<numeric expression>` with its fraction rounded. The type of the return value is the same numeric type as the `<numeric expression>` given as the argument.

**[Details]** Returns the value given by `<numeric expression>` with its fraction rounded.

**[Example]**
```
PRINT CINT(0.49)    → shows " 0"
PRINT CINT(0.5)     → shows " 1"
PRINT CINT(-0.49)   → shows " 0"
PRINT CINT(-0.5)    → shows "-1"
```

### CLEAR

*Direct-mode command, program-mode command*

> In this translation, "direct-mode command" (直接実行命令) means a command that can be typed and run directly at the edit screen, and "program-mode command" (間接実行命令) means one that can be used in a program.

**Function:** Initialises variables and stacks, and reserves the user area and file areas.

**Syntax:** `CLEAR [<blocks>[,[<file area 1>][,<file area 2>]]]`

**Example:**
```
CLEAR
CLEAR 10
CLEAR 100,256,256
CLEAR ,,1024
```

**[Parameters]**
- `<blocks>`: a fixed-point numeric expression (any fraction is cut off).
- `<file area 1>`, `<file area 2>`: fixed-point numeric expressions. The valid range is 1 to 2048 (in units of 256 bytes; any fraction is cut off).

*[p. 30]*

**[Details]**

**Initialisation**

Initialises the contents of all variables. String variables are initialised to the empty string of length 0, numeric variables to 0. All declared array variables go back to the undeclared state. Any open files are all closed. The stacks of the FOR and GOSUB commands are initialised.

**Reserving the user area**

If `<blocks>` is given, it sets the size of the user area that can be read and written with the POKE command, the PEEK function and the USERDATA command.

If it is left out, no user area is reserved.

**Reserving the file areas**

If `<file area 1>` and `<file area 2>` are given, buffers for file input and output are reserved at the given sizes. `<file area 1>` corresponds to file number 1 and `<file area 2>` to file number 2. At least 1 block (256 bytes) is reserved for each file area. The size of the area given here is the size of file that the OPEN command and the like can handle.

If they are left out, areas of 256 blocks (65536 bytes) are reserved.

If values of 1360 blocks or more are given for `<file area 1>` and `<file area 2>` and the areas are not in use, the PLAYINIT and TARG commands use them as a sound-source cache. The sound-source cache is discarded when a command that uses the file areas, such as OPEN, is run. If `CLEAR, 1360, 1360` is given, up to 3 kinds of voice data can be switched without accessing the CD.

**[Caution]** The user area and the file areas use the same memory space, so the size reserved for one changes the size available to the other. Also, these areas are shared with the BASIC program storage area, so reserving large areas reduces the size of program that can be written.

*[p. 31]*

### CONT

*Direct-mode command*

**Function:** Resumes a stopped program.

**Syntax:** `CONT`

**Example:**
```
CONT
```

**[Details]** Resumes a program that was stopped by the STOP command or by input such as [Ctrl]+[C], from the command right after where it stopped. However, if any change has been made to the program after it stopped, it cannot be resumed.

### COS

*Floating-point function*

**Function:** Returns the cosine of `<angle>`.

**Syntax:** `COS(<angle>)`

**Example:**
```
A# = COS(0)
PRINT COS(I#)
```

**[Parameters]**
- `<angle>`: a floating-point numeric expression. If the value of the expression is fixed-point, it is converted to floating-point before being given.

**[Return value]** The type of the return value is floating-point.

**[Details]** `<angle>` is given in radians (2π = 360°). According to the `<angle>` given, the ratio (−1 to 1) of the horizontal-axis direction to the hypotenuse is returned.

**[Example]**
```
PRINT COS(0)           → shows " 1"
PRINT COS(ATN(1)*4)    → shows "-1"
```

### DATA

*Program-mode command. \*It is not a command but a passive statement.*

**Function:** Defines constants as data.

**Syntax:** `DATA [<data item>][,[<data item>...]]`

**Example:**
```
DATA 1,2,3,4
DATA "ABC",10,"XYZ",20
```

*[p. 32]*

**[Parameters]**
- `<data item>`: only numeric (including exponent notation) or string constants can be given. Anything that cannot be recognised as a number is all treated as a string. Spaces placed between the separator comma (`,`) and a constant are ignored.

**[Details]** Defines data that is read by the READ command and by commands with a READ option. Each `<data item>` can be left out.

If left out, it is treated as 0 for a number and as the empty string for a string. `<data item>`s are separated with commas. To include this symbol in a data string, you must enclose the whole string in double quotes (`"`). Likewise, to include the statement separator colon (`:`) or space characters in a data string, you must enclose the whole data string in double quotes. A double quote itself cannot be included in a data string. The order in which data items are evaluated (precedence) is as follows.

1. End of line
2. Matching double quotes
3. The separator comma, and the colon

DATA statements are read in order from the first line of the program towards the last (including the "false" part of an IF statement). How the data read is interpreted depends on the command that reads it.

**[See also]** READ, RESTORE, ON RESTORE

### DATE$

*String function*

**Function:** Gets the date and time from the built-in clock.

**Syntax:** `DATE$`

**Example:**
```
A$ = DATE$
```

**[Return value]** Returns a fixed-format string giving the date and time.

**[Details]** Gets the date and time from the clock built into the Sega Saturn, as a string. The returned string has this fixed format:

Year + month + day + day of week + hour (24-hour) + minute + second

*[p. 33]*

Each part is separated by a space (the hour and minute are separated by a colon (`:`)). The day of the week, Sunday to Saturday, is shown as SUN, MON, TUE, WED, THU, FRI, SAT. Getting the date and time with the DATE$ function takes a little time, so there may be a slight difference from the date and time actually set.

**[Example]** For Thursday 27 February 1997, 7:52:01 pm, it is:
```
"1997 02/27 THU 19:52:01"
```

### DELETE

*Direct-mode command*

**Function:** Deletes the program list in the given range of lines.

**Syntax:** `DELETE {<start line>|<label>},{<end line>|<label>}`

**Example:**
```
DELETE 100,200
```

**[Parameters]**
- `<start line>`, `<end line>`: only fixed-point numeric constants (not exponent notation) are valid. A number with a fraction is not valid. The valid range is 1 to 99999.
- `<label>`: the name of a label that exists in the program. The names allowed follow the label naming rules.

**[Details]** Deletes the list from the line given by `<start line>` to the line given by `<end line>`. Lines that exist must be given. Also, `<end line>` cannot be smaller than `<start line>`.

### DIM

*Direct-mode command, program-mode command*

**Function:** Declares array variables.

**Syntax:** `DIM <variable name>(<maximum subscript>[,<maximum subscript>...])[,<variable name>(<maximum subscript>[,<maximum subscript>...])...]`

**Example:**
```
DIM A(10,5,30)
DIM A(X,Y,Z),B(X,Y),C(X,Z)
DIM A$(10)
```

*[p. 34]*

**[Parameters]**
- `<variable name>`: the name of the variable. The names allowed follow the variable naming rules. To declare a floating-point array, put a sharp (`#`) at the end. To declare a string array, put a dollar (`$`) at the end.
- `<maximum subscript>`: a fixed-point numeric expression. The valid range is 0 and above (any fraction is cut off). In practice up to 16 dimensions can be given.

**[Details]** Declares an array variable of the given size and makes it usable in the rest of the program. The lowest subscript of an array made usable by this declaration is 0, and the highest is the `<maximum subscript>` given in the declaration.

**[Example]**
```
DIM A(10)   → A(0) to A(10) can be used
```

The number of elements of an array that can be declared is up to the size possible at that point. The size that can be reserved is checked with the FRE() function and managed by the user. To use an array variable, it must first be declared with the DIM command.

### EDIT

*Direct-mode command*

**Function:** Edits the program list again.

**Syntax:**
```
(1) EDIT [{<line number>|<label>}]
(2) EDIT .
```

**Example:**
```
EDIT 100
```

**[Parameters]**
- `<line number>`: the valid range is the integers 1 to 99999.
- `<label>`: the name of a label that exists in the program. The names allowed follow the label naming rules.

**[Details]** Edits the program from the line given by `<line number>`. If `<line number>` is left out, the program list is edited from the start. If a period (`.`) is given, it is edited from the line last referred to. If you change the contents by editing, you must store it with the [Enter] key. If editing deletes everything except the line number, the line is deleted when [Enter] is pressed.

The next [Page Up] or [Page Down] key shows the program line above or below this line. The keys work the same as in normal screen editing.

*[p. 35]*

### END

*Direct-mode command, program-mode command*

**Function:** Ends the program.

**Syntax:** `END`

**Example:**
```
END
```

**[Details]** Ends the running of the program. Any open files are all closed. The stacks of FOR–NEXT, GOSUB and so on are also all initialised. It also ends normally while error handling defined with an ON ERROR GOTO statement is running.

### ERL

*Fixed-point function*

**Function:** Returns the line number of the last error that occurred.

**Syntax:** `ERL`

**Example:**
```
ERROR_LINE_NUMBER = ERL
```

**[Return value]** Returns the error number as fixed-point. *(sic: the line number is meant.)*

**[Details]** When an error occurs, it holds the number of the error that occurred *(sic)*. It always works, whether or not there is an ON ERROR GOTO declaration. For an error that occurred in direct mode it holds 0. It is reset to 0 by running the RESUME command, or by a change to the program and so on (the same conditions under which a stopped program can no longer be resumed with CONT).

**[See also]** ERR, ON ERROR GOTO, ERROR, RESUME

### ERR

*Fixed-point function*

**Function:** Returns the number of the last error that occurred.

**Syntax:** `ERR`

**Example:**
```
A = ERR
```

**[Return value]** Returns the error number as a fixed-point number.

*[p. 36]*

**[Details]** When an error occurs, it holds the number of the error that occurred. It always works, whether or not there is an ON ERROR GOTO declaration. It also holds a value for errors that occur in direct mode. It is reset to 0 by running the RESUME command, or by a change to the program and so on (the same conditions under which a stopped program can no longer be resumed with CONT).

**[See also]** ERL, ON ERROR GOTO, ERROR, RESUME

### ERROR

*Direct-mode command, program-mode command*

**Function:** Simulates an error occurring.

**Syntax:** `ERROR [<error number>]`

**Example:**
```
ERROR 10
```

**[Parameters]**
- `<error number>`: a fixed-point numeric expression; an integer from 0 to 255.

**[Details]** Giving `<error number>` shows the error with that error number. If an undefined error number is given, it is treated as "Unprintable error". In this case the contents of the error line are not shown. If, right after a program has stopped because of an error, the ERROR command is run directly without `<error number>`, the place in the program where the error occurred is shown again. However, an error place inside a DATA statement is not shown. This function is provided so that, when an error occurs while the screen is in a state that is hard to read, you can use it like this:

| Key | Action |
|---|---|
| [F12] | Gives the editing screen |
| ERROR + [Enter] | Shows the error place again |

**[See also]** ERR, ERL, ON ERROR GOTO, RESUME

### EXP

*Floating-point function*

**Function:** Calculates the exponential function (e raised to the power of the expression).

**Syntax:** `EXP(<numeric expression>)`

**Example:**
```
E# = EXP(1)
```

*[p. 37]*

**[Parameters]**
- `<numeric expression>`: a floating-point numeric expression. The valid range is values up to about 709 (up to where the result can be represented in floating-point).

**[Return value]** The type of the return value is floating-point. If the result would be beyond the floating-point range, a correct result is not obtained.

**[Details]** Returns e raised to the power `<numeric expression>`, as a floating-point value. The value of e is about 2.7182818284588.

### FIND

*Direct-mode command*

**Function:** Searches the program for a string.

**Syntax:** `FIND [<start line>][{,|-}[<end line>]] [,]<search string expression>[,P]`

**Example:**
```
FIND "GOSUB",P
```

**[Parameters]**
- `<start line>`, `<end line>`: only fixed-point numeric constants (not exponent notation) are valid. A number with a fraction is not valid. The valid range is 1 to 99999.
- `<search string expression>`: the string to search for.
- `P`: stops after each page.

**[Details]** Searches the program for the string of `<string expression>` and shows it. The matched characters are shown in a different colour. If the option "P" is given, it stops after each page. Upper-case and lower-case letters in `<search string expression>` and in the program text searched are always treated as the same. If "P" is not given, the following keys work during the search.

| Key | Action |
|---|---|
| [Ctrl]+[S] or [Pause] | Pauses the display (the same key resumes) |
| [Ctrl]+[C] or [Ctrl]+[Pause] | Stops the display |
| [Ctrl]+[E] or [↑] | Slows the display down |
| [Ctrl]+[X] or [↓] | Speeds the display up |

*[p. 38]*

### FIX

*Fixed-point function, floating-point function*

**Function:** Returns the value made into an integer by cutting off the fraction.

**Syntax:** `FIX(<numeric expression>)`

**Example:**
```
A = FIX(12.5)
PRINT FIX(X/10)
```

**[Parameters]**
- `<numeric expression>`: a fixed-point or floating-point numeric expression.

**[Return value]** Returns the value given by `<numeric expression>` with the fraction removed. The type of the return value is the same numeric type as the `<numeric expression>` given as the argument.

**[Details]** Returns the value given by `<numeric expression>` with the fraction removed.

**[Example]**
```
PRINT FIX(0.99)    → shows " 0"
PRINT FIX(1.01)    → shows " 1"
PRINT FIX(-0.99)   → shows " 0"
PRINT FIX(-1.01)   → shows "-1"
```

### FKEY

*Direct-mode command, program-mode command*

**Function:** Defines the function keys on the keyboard.

**Syntax:**
```
(1) FKEY <function key number>,<string expression>
(2) FKEY PRINT  or  FKEY ?
```

**Example:**
```
FKEY 1,"RUN"+CHR$(13)+CHR$(10)
```

**[Parameters]**
- `<function key number>`: a fixed-point numeric expression; 1 to 12.
- `<string expression>`: up to 31 characters. If the string contains `CHR$(0)`, the characters after it are ignored.

**[Details]** Form 2 shows the current function key definitions. Control codes in the strings are shown as "×". For the strings defined on the function keys as standard, see "Input during screen editing" in "GAME BASIC for SEGASATURN basic specification" earlier. *(The list is under "Function keys", p. 18.)*

*[p. 39]*

### FOR TO STEP

*Direct-mode command, program-mode command*

**Function:** Start of loop processing.

**Syntax:** `FOR <numeric variable>=<initial value> TO <end value> [STEP <increment>]`

**Example:**
```
FOR I = 0 TO 10
FOR I = A TO A*2 STEP 0.5
```

**[Parameters]**
- `<numeric variable>`: the name of a fixed-point numeric variable. The names allowed follow the variable naming rules.
- `<initial value>`, `<end value>`: fixed-point numeric expressions.
- `STEP <increment>`: a fixed-point numeric expression. To give `<increment>`, "STEP" is needed just before it.

**[Details]** Declares the start of loop processing with the variable given in `<numeric variable>` as the loop counter. The end of the loop is given by the NEXT command. At the start of the loop, the value given as `<initial value>` is assigned to the loop counter. When the matching NEXT command is reached, `<increment>` is added to the loop counter. If the result is beyond the `<end value>` given, the loop ends and execution moves to the next command. If not, it goes back to the command right after the FOR statement and repeats until the condition is met. The end condition of the loop is decided as follows by the value set in `<end value>` and `<increment>`.

**When `<increment>` is positive**

The loop ends when running the NEXT command makes the loop counter go above `<end value>`, or when the loop counter would go above the fixed-point upper limit (131071.999).

**When `<increment>` is negative**

The loop ends when running the NEXT command makes the loop counter go below `<end value>`, or when the loop counter would go below the fixed-point lower limit (−131071.999). Giving STEP `<increment>` lets you set any step for the loop counter updated by the NEXT command. If STEP `<increment>` is left out, it is +1. Note that if `<increment>` is 0, the loop repeats forever unless the contents of the loop counter are changed deliberately.

*[p. 40]*

**[Caution]** If the STEP `<increment>` includes a fraction, take care: the precision of fixed-point numbers causes accumulated errors. If an exact number of loops is needed, count with integers, or, if a fraction is written, write it in hexadecimal (example: `&H0.1`). When running in direct mode, the loop must be complete within the input line.

**[See also]** NEXT

### FRAC

*Fixed-point function*

**Function:** Takes out the fraction of a number and returns it.

**Syntax:** `FRAC(<numeric expression>)`

**Example:**
```
A = FRAC(X/Y)
```

**[Parameters]**
- `<numeric expression>`: a fixed-point numeric expression.

**[Return value]** Returns the fraction of the value given by `<numeric expression>`. The type of the return value is fixed-point.

**[Details]** Returns the fraction of the value given by `<numeric expression>`.

### FRE

*Fixed-point function*

**Function:** Returns the space left in the variable area, or the size of the user area or file areas.

**Syntax:** `FRE(<number>)`

**Example:**
```
A = FRE(0)
```

**[Parameters]**
- `<number>`: a fixed-point numeric expression. The valid range is 0 to 3 (any fraction is cut off).

**[Return value]** Returns the size of the area given by `<number>`. The type of the return value is fixed-point.

**[Details]** Returns the following information depending on the value given as `<number>`.

| Value | Returns |
|---|---|
| 0 | The free space of the variable area and program area, in blocks |
| 1 | The size of the user area, in blocks (not the free space) |
| 2 | The size of file area 1, in blocks (not the free space) |
| 3 | The size of file area 2, in blocks (not the free space) |

*[p. 41]*

If there is a remainder, it is rounded up.

**[See also]** SFRE, TFRE

### GOSUB

*Program-mode command*

**Function:** Calls a subroutine.

**Syntax:** `GOSUB {<line number>|<label>}`

**Example:**
```
GOSUB 1000
GOSUB *CHECKSUB
```

**[Parameters]**
- `<line number>`: the valid range is the integers 1 to 99999.
- `<label>`: the name of a label that exists in the program. The names allowed follow the label naming rules.

**[Details]** Calls the line given by `<line number>` or `<label>` as a subroutine. When the RETURN command is run in the subroutine, execution returns to the command right after the calling GOSUB command.

### GOTO

*Program-mode command*

**Function:** Moves to the start of the given line.

**Syntax:** `GOTO {<line number>|<label>}`

**Example:**
```
GOTO 1000
GOTO *GAMEOVER
```

**[Parameters]**
- `<line number>`: the valid range is the integers 1 to 99999.
- `<label>`: the name of a label that exists in the program. The names allowed follow the label naming rules.

*[p. 42]*

**[Details]** Unconditionally passes control to the start of the line given by `<line number>` or `<label>`. So statements placed after this command are never run. However, it is valid if DATA statements and the like are placed there.

### HEX$

*String function*

**Function:** Converts a number to a hexadecimal-form string.

**Syntax:** `HEX$(<numeric expression>[,<suppress>])`

**Example:**
```
A$ = HEX$(10)
PRINT HEX$(A,2)
```

**[Parameters]**
- `<numeric expression>`: a fixed-point numeric expression.
- `<suppress>`: a fixed-point numeric expression. The valid range is 0 to 3 (any fraction is cut off).

**[Return value]** The return value is a hexadecimal-form string.

**[Details]** Converts the number given by `<numeric expression>` to a hexadecimal-form string and returns it. If `<numeric expression>` is negative, a minus sign (`-`) is put at the start of the string. If `<numeric expression>` is not negative, a space is put at the start of the string.

`<suppress>` says whether missing digits after conversion are filled with "0". It is handled as follows depending on its value.

| Value | Meaning |
|---|---|
| 0 | Missing digits are not filled with "0" (default) |
| 1 | Only the integer part is filled with "0"; the fraction is not |
| 2 | Only the fraction is filled with "0"; the integer part is not |
| 3 | Both the integer part and the fraction are filled with "0" |

A "." is added between the integer part and the fraction of the return value.

**[Example]**
```
PRINT HEX$(123.25)     → shows "7B.4"
PRINT HEX$(123.25,1)   → shows "0007B.4"
PRINT HEX$(123.25,2)   → shows "7B.4000"
PRINT HEX$(123.25,3)   → shows "0007B.4000"
PRINT HEX$(-123.25)    → shows "-7B.4"
```

*[p. 43]*

### HEXBIN$

*String function*

**Function:** Converts a hexadecimal-form string to a binary string.

**Syntax:** `HEXBIN$(<source string>)`

**Example:**
```
A$ = HEXBIN$("FF80C3")
PRINT HEXBIN$(D$)
```

**[Parameters]**
- `<source string>`: a string expression.

**[Return value]** The return value is a binary string.

**[Details]** Turns the hexadecimal-form string given by `<source string>` into numbers and converts it, byte by byte, to a binary string. It is turned into numbers 2 digits at a time from the start. If there is an odd digit at the end, the upper digit is taken as 0. If the string given contains comma separators, the separators take priority when turning it into numbers. If an item has more than 3 digits, it is turned into numbers following the rule above. The binary string is made by converting each byte to the character whose character code is that value.

**[Example]**
```
PRINT HEXBIN$("414243")     → shows "ABC"
PRINT HEXBIN$("41,42,43")   → shows "ABC"
A$ = HEXBIN$("41443")       → the variable A$ holds "AD"+CHR$(3)
A$ = HEXBIN$("41,4,43")     → the variable A$ holds "A"+CHR$(4)+"C"
```

### IF GOTO

*Direct-mode command, program-mode command*

**Function:** Tests the given condition and branches depending on whether it is true or false.

**Syntax:** `IF <condition> GOTO {<line number>|<label>}[ELSE [{<line number>|<label>|<statement>...}]]`

**Example:**
```
IF A$ = "Y" GOTO 100
IF A > 10 GOTO *GOAL
```

**[Parameters]**
- `<condition>`: a fixed-point numeric expression. Any fraction is cut off.
- `<line number>`: the valid range is the integers 1 to 99999.
- `<label>`: the name of a label that exists in the program. The names allowed follow the label naming rules.
- `<statement>`: an executable statement.

*[p. 44]*

**[Details]** If the result of the expression given by `<condition>` is a value other than 0, control passes to the line given by `<line number>` or `<label>`. If the result of `<condition>` is 0, control passes to the next line. `<condition>` is evaluated and calculated like any normal expression (any fraction is cut off).

- **ELSE clause:** write the statements run when the result of `<condition>` is false (0). If `<line number>` or `<label>` is given, control passes to the start of that line. The ELSE clause can be left out, including "ELSE".

### IF THEN ELSE ENDIF

*Direct-mode command, program-mode command*

**Function:** Tests the given condition and branches depending on whether it is true or false.

**Syntax:**
```
(1) IF <condition> THEN [{<line number>|<label>|<statement>...}][ELSE [{<line number>|<label>|<statement>...}]]
(2) IF <condition> THEN [:<statement>...]
      [<statement>...]
    [ELSE]
      [<statement>...]
    ENDIF
```

**Example:**
```
IF A$ = "Y" THEN PRINT "Yes"
IF A > 10 THEN 100 ELSE A=A+1:GOTO 100
IF FLAG THEN       → flag test
  PRINT "True"
ELSE
  PRINT "False"
ENDIF
```

**[Parameters]**
- `<condition>`: a fixed-point numeric expression. Any fraction of the result is cut off.
- `<line number>`: the valid range is the integers 1 to 99999.
- `<label>`: the name of a label that exists in the program. The names allowed follow the label naming rules.
- `<statement>`: an executable statement.

*[p. 45]*

**[Details]**

**Form (1)**

When the result of the expression given by `<condition>` is 0 it is "false", and when it is any other value it is "true"; if true, the part after THEN is run, and if false, the part after ELSE. `<condition>` is evaluated and calculated like any normal expression (any fraction is cut off). The part after THEN is called the "THEN clause" and the part after ELSE the "ELSE clause".

- **THEN clause:** write the statements run when the result of `<condition>` is true (not 0). If `<line number>` or `<label>` is given, control passes to the start of that line. If statements are written, when execution reaches the ELSE clause that belongs to that IF statement, control passes to the next line.
- **ELSE clause:** write the statements run when the result of `<condition>` is false (0). If `<line number>` or `<label>` is given, control passes to the start of that line. The ELSE clause can be left out, including "ELSE".
- **Nesting IF statements:** further IF statements can be used in the THEN clause or the ELSE clause.

If an ELSE has no matching IF, an "ELSE/ENDIF without IF" error occurs.

**Form (2)**

If THEN is followed by the end of the line or the separator ":", it is interpreted as form (2). It is processed in the same way as form (1), but the IF statement does not end at the end of the line: everything up to the ENDIF that matches the IF is run as one IF statement spanning several lines.

- If an ELSE or ENDIF has no matching IF, an "ELSE/ENDIF without IF" error occurs.
- If an IF has no matching ELSE or ENDIF, an "IF/ELSE without ENDIF" error occurs.

The following three examples all do the same thing (the digits 1 and 2 are the nesting level).

Process 1
```
IF <ex1> THEN IF <ex2> THEN <st1> ELSE <st2>
1111111111111 22222222222222222222222222222222
```

Process 2
```
IF <ex1> THEN :IF <ex2> THEN :<st1> ELSE <st2> ENDIF ENDIF
11111111111111 2222222222222222222222222222222222222222 11111
```

> **Note.** Note that THEN is followed directly by a separator, with no `<statement>` in between. This is written on one line to explain it, but it is normally split over several lines with indentation (indenting by nesting depth), as in Process 3.

*(In these examples `<ex1>`, `<ex2>` … stand for expressions and `<st1>`, `<st2>` … for statements.)*

*[p. 46]*

Process 3
```
IF <ex1> THEN       → 1
  IF <ex2> THEN     →   2
    <st1>           →   2
  ELSE              →   2
    <st2>           →   2
  ENDIF             →   2
ENDIF               → 1
```

In other words, in form (1) an ENDIF for the one-line IF is taken to be added at the end of the line.

**ELSE IF in form (2)**

If "ELSE IF" is used in a form (2) IF construct as below, then if `<ex1>` is true `<st1>` is run and execution moves on to the matching ENDIF; if `<ex2>` is true `<st2>` is run and execution moves on to the matching ENDIF; if `<exn>` is true `<stn>` is run and execution moves on to the matching ENDIF…; and if none of the expressions is true, `<st4>` is run. In this case there is no limit on the number of `<exn>`.

Process 4
```
IF  <ex1> THEN          → 1
  <st1>                 → 1
ELSE IF <ex2> THEN      → 1
  <st2>                 → 1
ELSE IF <exn> THEN      → 1
  <stn>                 → 1
ELSE                    → 1
  <st4>                 → 1
ENDIF                   → 1
```

Both forms can be mixed. If there is an ENDIF at the end of a form (1) IF statement, the nesting of form (1) IFs up to just before that ENDIF ends, as it would at the end of the line (the digits 1, 2, 3 are the nesting level).

```
IF <ex1> THEN: IF <ex2> THEN IF <ex3> THEN <st>: ENDIF
11111111111111 2222222222222 333333333333333333  11111
```

If execution enters the middle of nested IF statements with a GOTO statement, the line entered is taken to be "true", and from then on it is processed by the simple IF rule that an ELSE clause following "true" is "false".

*[p. 47]*

### INKEY$

*String function*

**Function:** Reads one character of key input from the keyboard.

**Syntax:** `INKEY$`

**Example:**
```
I$ = INKEY$
```

**[Return value]** Returns the character typed on the keyboard.

**[Details]** Takes one character of information from the key input buffer and returns it. If no character has been typed, it returns the empty string. Take care: some of the character codes of special keys returned by key input differ from the character codes used for display.

**[Character codes returned by special keys]**

| Key | Code (decimal) | Code (hex) |
|---|---|---|
| [Back space] | 8 | &H08 |
| [Tab] | 9 | &H09 |
| [Home] | 11 | &H0B |
| [Insert] | 18 | &H12 |
| [Esc] | 27 | &H1B |
| [→] | 28 | &H1C |
| [←] | 29 | &H1D |
| [↑] | 30 | &H1E |
| [↓] | 31 | &H1F |
| [End] | 24 | &H18 |
| [Delete] | 127 | &H7F |
| [F1] | 224 | &HE0 |
| [F2] | 225 | &HE1 |
| [F3] | 226 | &HE2 |
| [F4] | 227 | &HE3 |
| [F5] | 228 | &HE4 |

*[p. 48]*

| Key | Code (decimal) | Code (hex) |
|---|---|---|
| [F6] | 229 | &HE5 |
| [F7] | 230 | &HE6 |
| [F8] | 231 | &HE7 |
| [F9] | 232 | &HE8 |
| [F10] | 233 | &HE9 (not possible from BASTERM) |
| [F11] | 234 | &HEA |
| [F12] | 235 | &HEB |
| [Page Up] | 250 | &HFA |
| [Page Down] | 251 | &HFB |

The input codes of the function keys ([F1] to [F12]) are shared with some of the graphic characters.

### INPUT

*Direct-mode command, program-mode command*

**Function:** Accepts any string typed on the keyboard.

**Syntax:** `INPUT [<prompt>,]{<string variable>|<numeric variable>}[,<default>]`

**Example:**
```
INPUT A$
INPUT "ENTRY NAME ?",N$,"SEGA"
```

**[Parameters]**
- `<prompt>`: the message shown when input is taken, given as a string (constant).
- `<string variable>`: the name of a string-type variable. The names allowed follow the variable naming rules.
- `<numeric variable>`: the name of a variable: the name of a fixed-point or floating-point variable. The names allowed follow the variable naming rules.
- `<default>`: a string expression.

**[Details]** Shows the string given in `<prompt>` and waits for input from the keyboard. Before this command runs, the key input buffer is initialised.

*[p. 49]*

The string shown by `<prompt>` is not affected at all by editing from the keyboard. Input starts right after the `<prompt>` shown. If `<prompt>` is left out, "?" is shown in the prompt position. If it is given, only the string given is shown, even if it is the empty string.

The string typed is stored in the variable given in `<string variable>`. All characters that can be typed on the keyboard and have a font can be entered. Characters used as separators, such as the colon (`:`), comma (`,`) and double quote (`"`), are all treated as part of the input. An empty input is also treated as input and stored in the given `<string variable>`. However, trailing spaces in the input string are ignored. If a `<default>` string is given, that string is shown in the input line before input is accepted. A string shown in this way is affected by editing from the keyboard. If `<default>` is left out, it waits for input without showing anything.

Because of the limits of line editing, the number of characters that can be typed is the number of characters across one line of the screen minus the number of characters in the prompt. The position of the input line shown by the INPUT command is affected by the LOCATE command and so on. The colour of the message shown is also affected by the COLOR command. If `<numeric variable>` is given and no valid number is typed, input is repeated at the position where the INPUT command was run until a number is typed.

### INPUT$

*String function*

**Function:** Waits until the given number of characters have been typed.

**Syntax:** `INPUT$(<number of characters>)`

**Example:**
```
A$ = INPUT$(1)
```

**[Parameters]**
- `<number of characters>`: a fixed-point numeric expression. The valid range is 1 to 255 (any fraction is cut off).

**[Return value]** Returns the string typed on the keyboard.

**[Details]** Accepts input from the keyboard until the number of characters given in `<number of characters>` has been typed, and returns the string typed. Every character with a character code except [Ctrl]+[C] is accepted. For the character codes returned by special keys, see the INKEY$ function.

*[p. 50]*

### INSTR

*Fixed-point function*

**Function:** Searches a string and returns position information.

**Syntax:** `INSTR(<target string>,<search string>[,<search start position>])`

**Example:**
```
A = INSTR(A$,"ABC")
PRINT INSTR(A$,B$,X)
```

**[Parameters]**
- `<target string>`, `<search string>`: string expressions.
- `<search start position>`: a fixed-point numeric expression. The valid range is 1 and above (any fraction is cut off).

**[Return value]** Returns the character position where `<search string>` was found. The type of the return value is fixed-point.

**[Details]** Checks whether the string given by `<search string>` is contained in the string given by `<target string>`, and if it is, returns the matching character position. `<search start position>` gives the character of `<target string>` from which to start the search. If it is left out, the search start position is taken as 1.

If `<target string>` is the empty string, 0 is returned whatever is given as `<search string>`. 0 is also returned if `<search string>` is longer than `<target string>`. 0 is also returned if the value of `<search start position>` is greater than the length of `<target string>`.

Otherwise, if `<search string>` is the empty string, the first search position is always returned.

**[Example]**
```
PRINT INSTR("123","2")          → shows "2"
PRINT INSTR("123123","2")       → shows "2"
PRINT INSTR("123123","2",4)     → shows "5"
PRINT INSTR("123","1234")       → shows "0"
PRINT INSTR("123","2",5)        → shows "0"
PRINT INSTR("123","")           → shows "1"
```

*[p. 51]*

### INT

*Fixed-point function, floating-point function*

**Function:** Returns the largest integer not greater than the given value.

**Syntax:** `INT(<numeric expression>)`

**Example:**
```
A = INT(12.5)
PRINT INT(X/10)
```

**[Parameters]**
- `<numeric expression>`: a fixed-point or floating-point numeric expression.

**[Return value]** Returns the largest integer not greater than the value given by `<numeric expression>`. The type of the return value is the same numeric type as the `<numeric expression>` given as the argument.

**[Details]** Returns the largest integer not greater than the value given by `<numeric expression>`.

**[Example]**
```
PRINT INT(0.99)    → shows " 0"
PRINT INT(0.01)    → shows " 0"
PRINT INT(-0.01)   → shows "-1"
PRINT INT(-0.99)   → shows "-1"
```

### INTERVAL

*Program-mode command*

**Function:** Sets an interval timer.

**Syntax:**
```
(1) INTERVAL[interval timer number] ON [,<interval>]
(2) INTERVAL[(<interval timer number>)] <interval>
(3) INTERVAL[(<interval timer number>)] OFF
```

**Example:**
```
INTERVAL ON
INTERVAL(0) ON,60
INTERVAL(2) 0
INTERVAL OFF
```

- Form (1) starts timing of the given interval timer.
- Form (2) changes the interval at which the given interval timer's interrupt occurs.
- Form (3) stops the given interval timer's interrupt from occurring.

*[p. 52]*

**[Parameters]**
- `<interval timer number>`: a fixed-point numeric expression. The valid range is 0 to 23 (any fraction is cut off).
- `<interval>`: a fixed-point numeric expression. The valid range is 0 and above (any fraction is cut off).
- `ON`: starts timing of the interval timer.
- `OFF`: stops the interval timer's interrupt.

**[Details]** Sets the state of the interval timer given by `<interval timer number>`. If `<interval timer number>` is left out, it is treated as 0.

Form (1) enables interrupts from the given interval timer. At the same time it starts (resumes) timing of the interval timer. If `<interval>` is given, the interval timer's count so far is reset and a new interval at which interrupts occur is set. If `<interval>` is left out, it only enables interrupts; the count so far and the previous interrupt interval are kept unchanged.

Form (2) changes only the interrupt interval of the given interval timer. The count so far and whether interrupts are enabled or disabled are kept unchanged.

If changing `<interval>` means the condition for an interrupt is met, the interrupt occurs at the next count. However, this is only when interrupts are enabled.

Form (3) disables the interrupt of the given interval timer. The count so far and the interrupt interval setting are kept unchanged. If the condition for an interrupt is met while interrupts are disabled, no interrupt occurs and only the count goes on (it is not held over either).

If 0 is given as `<interval>` in form (1) or form (2), timing of the interval timer stops. At that time, the count so far is reset to the interrupt interval set before.

- **Unit of `<interval>`:** the interval timer counts every 1/60 second. The interrupt interval can also be set in steps of 1/60 second.
- **Interrupts from interval timers:** when the count reaches the `<interval>` set, an interrupt occurs. At the same time the count is reset to 0 and counting continues. If several interrupts are set, other interrupts may occur even while an interrupt is being handled.
- **Order in which interrupts occur:** they are handled in order from the lowest interval timer number, then countdown

*[p. 53]*

timer interrupts, then interrupts from MML control commands (the ON MMLSTAT GOSUB command). Only one interrupt occurs at each chance for an interrupt. Before running this command, the routine called when the interrupt occurs must be set with the ON INTERVAL GOSUB command.

**[See also]** LOCK, UNLOCK, ON INTERVAL GOSUB

### LEFT$

*String function*

**Function:** Takes a string of the given length from the left of a string and returns it.

**Syntax:** `LEFT$(<target string>, <numeric expression>)`

**Example:**
```
A$ = LEFT$("ABC",2)
PRINT LEFT$(I$,X)
```

**[Parameters]**
- `<target string>`: a string expression.
- `<numeric expression>`: a fixed-point numeric expression. The valid range is 0 and above (any fraction is cut off).

**[Return value]** Returns the number of characters given by `<numeric expression>` from the left of the string given by `<target string>`.

**[Details]** If `<target string>` is the empty string, the return value is also the empty string.

If `<numeric expression>` is greater than the length of `<target string>`, `<target string>` is returned. If `<numeric expression>` is 0, the return value is the empty string.

`<target string>` is not changed.

### LEN

*Fixed-point function*

**Function:** Returns the length of the given string.

**Syntax:** `LEN(<string expression>)`

**Example:**
```
A = LEN("123")
PRINT LEN(D$)
```

**[Parameters]**
- `<string expression>`: a string expression.

*[p. 54]*

**[Return value]** Returns the length (number of characters) of the string given by `<string expression>`. The type of the return value is fixed-point.

**[Details]** If `<string expression>` is a null string, 0 is returned.

### LET

*Direct-mode command, program-mode command*

**Function:** Assigns the value of the expression on the right side to the variable on the left side.

**Syntax:**
```
(1) [LET] <numeric variable>=<numeric expression>
(2) [LET ]<string variable>=<string expression>
```

**Example:**
```
LET A = 10
A$ = CHR$(A)
```

**[Parameters]**
- `<numeric variable>`: the name of a variable: the name of a fixed-point or floating-point variable. The names allowed follow the variable naming rules.
- `<string variable>`: the name of a variable: the name of a string-type variable. The names allowed follow the variable naming rules.
- `<numeric expression>`: both fixed-point and floating-point values are valid.
- `<string expression>`: a string expression.

**[Details]** Form (1) assigns the result of the numeric expression on the right side to the numeric variable on the left side.

Form (2) assigns the result of the string expression on the right side to the string variable on the left side.

This command can be written with "LET" left out, as follows.

```
Form (1): <numeric variable>=<numeric expression>
Form (2): <string variable>=<string expression>
```

If the value assigned to a fixed-point variable goes beyond the range the variable can represent (−&h1FFFF.FFFC to +&h1FFFF.FFFC), an Overflow occurs. Trying to assign a number to a string variable, or a string to a numeric variable, causes a Type mismatch.

*[p. 55]*

### LIST

*Direct-mode command*

**Function:** Shows the program list.

**Syntax:**
```
(1) LIST [<start line>][{,|-}[<end line>]]
(2) LIST .
```

**Example:**
```
LIST
LIST 100-200
LIST .
```

**[Parameters]**
- `<start line>`, `<end line>`: the valid range is the integers 1 to 99999.

**[Details]** Shows the list from the line given by `<start line>` to the line given by `<end line>`. If `<end line>` is smaller than `<start line>`, nothing is shown.

If `<start line>` is left out, the program list is shown from the start.

If `<end line>` is left out, the program list is shown to the end. However, if the separator comma (`,`) or hyphen (`-`) is also left out, only the line given by `<start line>` is shown. Form (2) shows only the line last referred to.

While the program list is being shown, the following keys work.

| Key | Action |
|---|---|
| [Ctrl]+[S] or [Pause] | Pauses the display (the same key resumes) |
| [Ctrl]+[C] or [Ctrl]+[Pause] | Stops the display |
| [Ctrl]+[E] or [↑] | Slows the display down |
| [Ctrl]+[X] or [↓] | Speeds the display up |

### LOCATE

*Direct-mode command, program-mode command*

**Function:** Sets the cursor position on the text screen.

**Syntax:** `LOCATE [<X character position>][,<Y character position>]`

**Example:**
```
LOCATE 10,0
LOCATE X,Y
```

**[Parameters]**
- `<X character position>`, `<Y character position>`: fixed-point numeric expressions. The valid range is 0 to 127 (any fraction is cut off).

*[p. 56]*

**[Details]** Moves the cursor (the position where text is shown by PRINT statements and the like) to the position `<X character position>` to the right and `<Y character position>` down, taking the top-left position of the text screen area defined by the WIDTH command as the origin (0,0). "Top left" assumes the text screen is not rotated or flipped. The position set by the LOCATE command affects the position of messages shown by the PRINT, PRINT USING and INPUT commands.

### LOCK

*Direct-mode command, program-mode command*

**Function:** Disables interrupt handling.

**Syntax:** `LOCK`

**Example:**
```
10 LOCK
20 LOCATE 10,10:PRINT "HELLO"
30 UNLOCK
```

**[Details]** Between the LOCK command and the UNLOCK command, calls to the interrupt subroutines registered with the ON INTERVAL and ON TIMER commands are temporarily disabled.

For ON TIMER, if the count runs out during LOCK, the request is held until UNLOCK.

For ON INTERVAL, if the count runs out during LOCK, the request is held until UNLOCK, but the counting itself carries on regardless. If the same timer's count runs out several times during LOCK, only the last request is passed on at UNLOCK.

It is also used to stop the same resource being rewritten partway through when several parts of a BASIC program handle it, for example through timer interrupts. For example, the LOCK command in the example stops the cursor position being rewritten by interrupt handling until the characters have been shown at the cursor position set by the LOCATE command.

If interrupts are disabled for a long time, the calls to the subroutines of the ON INTERVAL, ON TIMER and ON MMLSTAT commands are held up, so keep the commands between LOCK and UNLOCK as few as possible.

### LOG

*Floating-point function*

**Function:** Returns the natural logarithm of the given number.

**Syntax:** `LOG(<numeric expression>)`

**Example:**
```
A# = LOG(2)
PRINT LOG(X#)/LOG(10)
```

*[p. 57]*

**[Parameters]**
- `<numeric expression>`: a floating-point numeric expression. If the result of the expression is fixed-point, it is converted to floating-point before being given. The valid range is values greater than 0.

**[Return value]** The type of the return value is floating-point.

**[Details]** Returns the natural logarithm of the number given by `<numeric expression>`.

### MID$ (statement)

*Direct-mode command, program-mode command*

**Function:** Replaces the contents of a string variable, from the given character position, with any string.

**Syntax:** `MID$(<string variable>,<character position>[,<length>]) = <replacement string>`

**Example:**
```
MID$(A$,2) = "123"
MID$(D$,I,2) = B$
```

**[Parameters]**
- `<string variable>`: the name of the string variable that holds the target string.
- `<character position>`: a fixed-point numeric expression. Valid values are 1 and above (any fraction is cut off).
- `<length>`: a fixed-point numeric expression. Valid values are 0 and above (any fraction is cut off).
- `<replacement string>`: a string expression.

**[Details]** Replaces the part, given by `<character position>` and `<length>`, of the string held in the variable given by `<string variable>` with the whole of `<replacement string>`.

`<character position>` gives the position, counted from the start, at which to start replacing.

If a value greater than the number of characters in `<string variable>` is given, the replacement is made by adding to the end of `<string variable>`.

`<length>` gives the number of characters of the part replaced. If `<length>` is greater than the number of characters of `<string variable>` from `<character position>` on, everything from `<character position>` on is replaced.

If `<length>` is left out or is 0, it is treated as the same as the length of `<replacement string>`.

*[p. 58]*

### MID$ (function)

*String function*

**Function:** Takes part of a string, of any length, from the given character position.

**Syntax:** `MID$(<target string>,<character position>[,<length>])`

**Example:**
```
A$ = MID$("123",2)
PRINT MID$(D$,I,2)
```

**[Parameters]**
- `<target string>`: a string expression.
- `<character position>`: a fixed-point numeric expression. The valid range is 1 and above (any fraction is cut off).
- `<length>`: a fixed-point numeric expression. The valid range is 0 and above (any fraction is cut off).

**[Return value]** Returns `<length>` characters of the string given by `<target string>`, from the `<character position>`th character counted from the start.

**[Details]** If `<character position>` is greater than the length of `<target string>`, the return value is the empty string.

If `<length>` is left out, or if the number of characters from `<character position>` on is less than `<length>`, the part of `<target string>` from `<character position>` on is the return value.

`<target string>` is not changed.

### NEW

*Direct-mode command*

**Function:** Clears the program list from memory.

**Syntax:** `NEW`

**Example:**
```
NEW
```

**[Details]** Clears the program list from memory. At the same time the variable area, stack area and so on are initialised. Any open files are all closed. However, the user area and file areas are not affected at all.

*[p. 59]*

### NEXT

*Direct-mode command, program-mode command*

**Function:** End of loop processing.

**Syntax:** `NEXT [<numeric variable>[,<numeric variable>...]]`

**Example:**
```
NEXT
NEXT I,J
```

**[Parameters]**
- `<numeric variable>`: the name of the variable given as the loop counter in the FOR–TO–STEP command.

**[Details]** Declares the end of the loop processing whose loop counter is the given `<numeric variable>`.

If `<numeric variable>` is left out, it automatically matches the FOR–TO–STEP command run most recently. If an outer loop counter is given, an error occurs.

When the NEXT command runs, the contents of the given loop counter are updated by the `<increment>` given in the FOR–TO–STEP command. The test for the end of the loop is also made when this NEXT command runs. When running in direct mode, the loop must be complete within the input line.

### ON ERROR GOTO

*Program-mode command*

**Function:** Sets the error-handling routine.

**Syntax:** `ON ERROR GOTO {{<line number>|<label>}|0}`

**Example:**
```
ON ERROR GOTO *TRAP_ROUTINE
```

**[Parameters]**
- `<line number>`: the valid range is the integers 1 to 99999.
- `<label>`: the name of a label that exists in the program. The names allowed follow the label naming rules.

**[Details]** Sets things up so that when an error occurs, instead of raising a BASIC error, execution jumps to the error-handling routine set by the user.

Error handling is cancelled by giving "0" in place of the line number.

While the error-handling routine is running, the error-handling function is suspended, so if an error occurs inside the error-handling routine the program stops. Running a RESUME statement to leave the error-handling routine enables the error-handling function again. If the error-

*[p. 60]*

handling routine does not end with a RESUME or END statement and runs to the end of the program, a "No RESUME" error occurs.

**[See also]** ERL, ERR, ERROR, RESUME

### ON GOSUB

*Program-mode command*

**Function:** Calls a subroutine depending on the value of an expression.

**Syntax:** `ON <expression> GOSUB [{<line number>|<label>}][,[{<line number>|<label>}]...]`

**Example:**
```
ON INDEX GOSUB *SUBROUTINE1,*SUBROUTINE2,*SUBROUTINE3
ON NUMBER GOSUB ,,,*SUBROUTINE4
```

**[Parameters]**
- `<expression>`: any numeric expression whose result fits in the fixed-point range. The fraction is ignored (any fraction is cut off). A value from 0 to 131071.
- `<line number>`: the valid range is the integers 1 to 99999.
- `<label>`: the name of a label that exists in the program. The names allowed follow the label naming rules.

**[Details]** If the integer part of the value of `<expression>` is n, the subroutine at the nth `<line number>` or `<label>` given is called. When the RETURN command is run in the subroutine, execution returns to the command after ON GOSUB.

For example, writing

```
ON 1 GOSUB 100, 200, 300
```

moves to line 100, and writing

```
ON 3 GOSUB 100, 200, 300
```

moves to line 300.

If the target line number is left out, execution moves to the next command.

Likewise, if n is 0 or is greater than the number of line numbers given, execution moves to the next command. If a negative value is given for `<expression>`, an "Illegal function call" occurs.

**[See also]** GOSUB, ON GOTO

*[p. 61]*

### ON GOTO

*Program-mode command*

**Function:** Moves to the start of a line depending on the value of an expression.

**Syntax:** `ON <expression> GOTO [{<line number>|<label>}][,[{<line number>|<label>}]...]`

**Example:**
```
ON INDEX GOTO *LABEL1,*LABEL2,*LABEL3
ON NUMBER GOTO ,,,*LABEL4
ON 100 GOTO :PRINT 3    → 3 is always shown
```

**[Parameters]**
- `<expression>`: any numeric expression whose result fits in the fixed-point range. The fraction is ignored (any fraction is cut off). A value from 0 to 131071.
- `<line number>`: the valid range is the integers 1 to 99999.
- `<label>`: the name of a label that exists in the program. The names allowed follow the label naming rules.

**[Details]** If the integer part of the value of `<expression>` is n, the program's point of execution moves to the nth `<line number>` or `<label>` given.

For example, writing

```
ON 3 GOTO 100, 200, 300
```

moves to line 300.

If the target line number is left out, execution moves to the next command.

Likewise, if n is 0 or is greater than the number of line numbers given, execution moves to the next command. If a negative value is given for `<expression>`, an "Illegal function call" occurs.

**[See also]** GOTO, ON GOSUB

*[p. 62]*

### ON INTERVAL

*Program-mode command*

**Function:** Sets the routine called by an interval timer interrupt.

**Syntax:** `ON INTERVAL[(<interval timer number>)] GOSUB {<line number>|<label>}`

**Example:**
```
ON INTERVAL GOSUB 1000
ON INTERVAL(1) GOSUB *MOVE
```

**[Parameters]**
- `<interval timer number>`: a fixed-point numeric expression. The valid range is 0 to 23 (any fraction is cut off).
- `<line number>`: the valid range is the integers 1 to 99999.
- `<label>`: the name of a label that exists in the program. The names allowed follow the label naming rules.

**[Details]** Sets the interrupt routine called when an interval timer interrupt occurs. The interrupt target can be set for each `<interval timer number>`.

If `<interval timer number>` is left out, it is treated as 0. When this command runs, the interval timer is set as follows.

- Interrupts are disabled.
- The interrupt interval is initialised to 60.
- The interval timer's count is initialised to 0.

**[Caution]** Interrupts from other interval timers are accepted even during interrupt handling, so when the same resource is handled, you must either disable interrupts temporarily with the LOCK command or do the mutual exclusion yourself.

Take care: if interrupt handling takes too long, the GOSUB stack overflows. Also take care with heavy processing such as scrolling, clearing the screen, PAINT and INPUT: the interrupt cannot be handled in time and the program pauses. For how interval timer interrupts work, see the INTERVAL command.

**[See also]** INTERVAL, LOCK, UNLOCK

*[p. 63]*

### ON RESTORE

*Program-mode command*

**Function:** Sets the position of the data to be read, depending on the value of the given numeric expression.

**Syntax:** `ON <numeric expression> RESTORE [<line number>|<label>][,[<line number>|<label>]...]`

**Example:**
```
ON A RESTORE 100,200,300
ON A RESTORE ,,,*START
```

**[Parameters]**
- `<numeric expression>`: a fixed-point numeric expression. The valid range is 0 and above (any fraction is cut off).
- `<line number>`: the valid range is the integers 1 to 99999.
- `<label>`: the name of a label that exists in the program. The names allowed follow the label naming rules.

**[Details]** Depending on the value of the given `<numeric expression>`, sets the data to be read next to the data from the `<line number>` or `<label>` written after RESTORE. The value of `<numeric expression>` corresponds to each `<line number>` or `<label>` in order from the first: 1, 2, 3 and so on. If the value of `<numeric expression>` is 0, or greater than the number of `<line number>`s and `<label>`s written, no data position is set and execution moves to the next command.

**[Example]**
```
100 ON A RESTORE 200,300,400:READ A:PRINT A
200 DATA 1
300 DATA 2
400 DATA 3
```

When A=1 the data on line 200 is read and "1" is shown; when A=2 the data on line 300 is read and "2" is shown. When A=3 the data on line 400 is read and "3" is shown.

`<line number>` and `<label>` can also be left out. In that case, when the value of `<numeric expression>` corresponds to a left-out `<line number>` or `<label>`, no data position is set and execution moves to the next command.

**[See also]** READ, DATA, RESTORE

*[p. 64]*

### ON TIMER

*Program-mode command*

**Function:** Sets the routine called by a countdown timer interrupt.

**Syntax:** `ON TIMER[(<countdown timer number>)] GOSUB {<line number>|<label>}`

**Example:**
```
ON TIMER GOSUB 1000
ON TIMER(0) GOSUB *MOVE
```

**[Parameters]**
- `<countdown timer number>`: a fixed-point numeric expression. The valid range is 0 to 7 (any fraction is cut off).
- `<line number>`: the valid range is the integers 1 to 99999.
- `<label>`: the name of a label that exists in the program. The names allowed follow the label naming rules.

**[Details]** Sets the interrupt routine called when a countdown timer interrupt occurs. The interrupt target can be set for each `<countdown timer number>`.

If `<countdown timer number>` is left out, it is treated as 0. When this command runs, the countdown timer is set as follows.

- Interrupts are disabled.
- The countdown timer's count is initialised to 0.

For how countdown timer interrupts work, see the TIMER command.

**[See also]** TIMER

### PAD

*Fixed-point function*

**Function:** Returns the state of the Sega Saturn's control ports.

**Syntax:** `PAD(<function>[,<item number>])`

**Example:**
```
A = PAD(-1)
S = PAD(0,1)
```

**[Parameters]**
- `<function>`: a fixed-point numeric expression (any fraction is cut off). The valid range is −2 to 29.

*[p. 65]*

- `<item number>`: a fixed-point numeric expression (any fraction is cut off). The valid range is 0 to 5 (depending on the kind of device connected).

**[Return value]** Information about the input device connected to the control port is returned as a fixed-point number. The return value is explained in detail in [Details] below.

**[Details]** The following information is obtained depending on the value of `<function>`.

| `<function>` | Meaning |
|---|---|
| −1 | Returns the number of devices connected to control port 1. 0 if nothing is connected |
| −2 | Returns the number of devices connected to control port 2. 0 if nothing is connected |
| 0–14 | Examines a device connected to control port 1 |
| 15–29 | Examines a device connected to control port 2 |

If `<function>` is −1 or −2, `<item number>` has no effect.

If 0 to 29 is given as `<function>`, information about the individual devices connected to each control port is obtained.

If 0 is given as `<item number>`, the device ID value below is obtained. 0 gets the ID of the connected device (also when `<item number>` is left out). The return value is as follows.

| Return value | Meaning |
|---|---|
| &H00– | Digital devices |
| &H10– | Analogue devices |
| &H20– | Pointing devices |
| &H30– | Keyboard devices |
| &HFF | Not connected |

When 1 or more is given as `<item number>`, the return value depends on the device ID obtained with `<item number>` 0, as follows.

**Device ID = &H00–: digital devices (the Sega Saturn control pad and so on)**

| `<item number>` | Meaning |
|---|---|
| 1 | On/off state of the buttons (On=1/Off=0) |
| 2 | Buttons that went from off to on (Off→On=1/other=0) |

Each bit of the return value corresponds to a button of the control pad, as follows.

| Bit | Button |
|---|---|
| Bit 15 | Direction button right |
| Bit 14 | Direction button left |
| Bit 13 | Direction button down |
| Bit 12 | Direction button up |
| Bit 11 | Start button |
| Bit 10 | A button |

*[p. 66]*

| Bit | Button |
|---|---|
| Bit 09 | C button |
| Bit 08 | B button |
| Bit 07 | R button |
| Bit 06 | X button |
| Bit 05 | Y button |
| Bit 04 | Z button |
| Bit 03 | L button |
| Bits 02–00 | Always 0 |

For example, if the A button is pressed, the value is 1024 (or &H0400, &B0000 0100 0000 0000).

**Device ID = &H10–: analogue devices**

| `<item number>` | Meaning |
|---|---|
| 1 | On/off state of the buttons (On=1/Off=0) |
| 2 | Buttons that went from off to on (Off→On=1/other=0) |
| 3 | Analogue 1 value (8 bits), e.g. X of the Sega Multi Controller |
| 4 | Analogue 2 value (8 bits), e.g. Y of the Sega Multi Controller |
| 5 | Analogue 3 value (8 bits), e.g. R of the Sega Multi Controller |
| 6 | Analogue 4 value (8 bits), e.g. L of the Sega Multi Controller |

For `<item number>` 1 and 2, the details of the return value are as for digital devices.

**Device ID = &H20–: pointing devices**

| `<item number>` | Meaning |
|---|---|
| 1 | On/off state of the buttons (On=1/Off=0) |
| 2 | Buttons that went from off to on (Off→On=1/other=0) |
| 3 | Analogue X value (16 bits) |
| 4 | Analogue Y value (16 bits) |

For `<item number>` 1 and 2, the details of the return value are as for digital devices.

**Device ID = &H30–: keyboard devices**

| `<item number>` | Meaning |
|---|---|
| 1 | On/off state of the buttons (On=1/Off=0) |
| 2 | Buttons that went from off to on (Off→On=1/other=0) |
| 3 | make/break (bits below) |

| Bit (item 3) | Meaning |
|---|---|
| Bit 7 | Always 0 |
| Bit 6 | CAPS LOCK |
| Bit 5 | NUM LOCK |
| Bit 4 | SCROLL LOCK |
| Bit 3 | MAKE |
| Bit 2 | Always 1 |

*[p. 67]*

| Bit (item 3) | Meaning |
|---|---|
| Bit 1 | Always 1 |
| Bit 0 | BREAK |

| `<item number>` | Meaning |
|---|---|
| 4 | Key code typed |

For `<item number>` 1 and 2, the details of the return value are as for digital devices.

**[Caution]** PAD data is updated once per VSYNC, and the trigger information is ORed in each time a button is pressed. It is cleared to 0 when read, so when checking several bits, first copy it to a variable and use that. To cancel the trigger information so far, read it once and discard the result.

**[See also]** "BASIC constant table" in "GAME BASIC for SEGASATURN basic specification"

### PEEK

*Fixed-point function*

**Function:** Reads one byte of data from the user area.

**Syntax:** `PEEK(<block>,<address>)`

**Example:**
```
A = PEEK(0,&H1000)
A = PEEK(B,AD)
```

**[Parameters]**
- `<block>`: a fixed-point numeric expression.
- `<address>`: a fixed-point numeric expression. The valid range is 0 and above (any fraction is cut off).

**[Return value]** Reads one byte of data from the address in the user area given by `<block>` and `<address>` and returns it. So the return value is 0 to 255.

**[Details]** The user area must already have been reserved with the CLEAR command, and the range that can be given for `<block>` and `<address>` depends on the size of the user area reserved.

*[p. 68]*

### PEEK$

*String function*

**Function:** Reads data from the user area as a string.

**Syntax:** `PEEK$(<block>,<address>,<length>)`

**Example:**
```
A$ = PEEK$(0,&H1000,&h1000)
```

**[Parameters]**
- `<block>`: a fixed-point numeric expression.
- `<address>`: a fixed-point numeric expression. The valid range is 0 and above (any fraction is cut off).
- `<length>`: a fixed-point numeric expression. The valid range is 0 and above (any fraction is cut off).

**[Return value]** Reads `<length>` bytes of data from the address in the user area given by `<block>` and `<address>` and returns it as a string.

**[Details]** The user area must already have been reserved with the CLEAR command, and the range that can be given for `<block>` and `<address>` depends on the size of the user area reserved. `<length>` must not go beyond the user area.

### POKE

*Direct-mode command, program-mode command*

**Function:** Writes data to the given address in the user area.

**Syntax:** `POKE <block>,<address>,{<numeric expression>|<string expression>}[,{<numeric expression>|<string expression>}...]`

**Example:**
```
POKE 0,0,128,64,32,16
POKE 0,&H3800,BN$
```

**[Parameters]**
- `<block>`: a fixed-point numeric expression.
- `<address>`: a fixed-point numeric expression. The valid range is 0 and above.
- `<numeric expression>`: a fixed-point numeric expression. The valid range is 0 to 255.
- `<string expression>`: the resulting string is treated as a binary string.

**[Details]** Writes the data given by `<numeric expression>` or `<string expression>` to the address in the user area given by `<block>` and `<address>`. When a parameter is a `<numeric expression>`,

*[p. 69]*

one parameter corresponds to one byte of data. For a `<string expression>`, the character code of each character corresponds to one byte of data. The user area must already have been reserved with the CLEAR command, and the range that can be given for `<block>` and `<address>` depends on the size of the user area reserved.

### POS

*Fixed-point function*

**Function:** Returns the cursor position on the text screen.

**Syntax:** `POS(<number>)`

**Example:**
```
X = POS(0)
```

**[Parameters]**
- `<number>`: a fixed-point numeric expression. The valid range is 0 to 1 (any fraction is cut off).

**[Return value]** The type of the return value is fixed-point.

**[Details]** If `<number>` is 0, returns the horizontal position of the cursor (X character position). If `<number>` is 1, returns the vertical position of the cursor (Y character position).

### PRINT

*Direct-mode command, program-mode command*

**Function:** Shows characters on the text screen.

**Syntax:** `PRINT [<expression>[[{,|;}]<expression>[[{,|;}]<expression>]...]][{,|;}]`

**Example:**
```
PRINT 1000*A#;
PRINT "ABC"
PRINT "Lv.=";LV,"H.P=";HP
```

**[Parameters]**
- `<expression>`: any expression whose result is a number or a string can be given.

**[Details]** Shows the result of the numeric or string expression given by `<expression>` on the text screen. To give several `<expression>`s, a comma (`,`) or semicolon (`;`) is needed to separate them. If the separator is left out, it is treated as if there were a semicolon. If a comma is used, the `<expression>` right after the comma is shown at the next tab position from the current cursor position.

*[p. 70]*

If a semicolon is used, it is shown continuing from the current cursor position. If a comma or semicolon is given at the end of the parameters, the command ends after the cursor movement above. If nothing is given, the cursor moves to the left edge of the next line.

If the result of `<expression>` is a string and the string contains any of the following characters that have no font, the function of that control code takes effect. The control codes are as for the CHR$ function.

The PRINT command can also be written as "?", and used like this:

```
?"ABC"
```

**[See also]** CHR$

### PRINT USING

*Direct-mode command, program-mode command*

**Function:** Shows characters on the text screen in the given format.

**Syntax:** `PRINT USING <format string>;<expression>[{,|;}<expression>[{,|;}<expression>]...][{,|;}]`

**Example:**
```
PRINT USING "#####.###";1000*A#;
PRINT USING "Name : @";N$
PRINT USING "Lv_.=### H_.P=###";LV;HP
```

**[Parameters]**
- `<format string>`: a string constant containing display format characters.
- `<expression>`: any expression whose result is a number or a string can be given.

**[Details]** Shows the result of the numeric or string expression given by `<expression>` on the text screen, following the format given by `<format string>`. The following display format characters are valid in `<format string>`.

| Character | Meaning |
|---|---|
| `#` | Sets the digit positions and number of digits of the number shown. With `###`, numbers of up to 3 digits are shown right-aligned. If the number has more digits than given, a `%` sign is added before the number shown. If there are too many digits after the decimal point, it is rounded |
| `.` | Sets the position of the decimal point. It must always be used with `#` |
| `+` | Put before the symbols that set the digits of a number (`#` or `.`), shows a sign on the left of the number |
| `&&` | Sets the length and position of the string shown. Spaces between the two `&` set the length: the length shown equals the length of the format including the `&`s. If it is shorter than the string, that many characters from the start of the string are shown |
| `@` | Shows a string of any length from the position of the `@` |
| `!` | Shows the first character of the string |
| `_` | (Underline) shows the next format character as an ordinary character |

*[p. 71]*

When several `<expression>`s are given, they must be separated by a comma or semicolon. Unlike PRINT, neither affects the cursor position. If there are more expressions than the format string covers, the format string is applied again from its start.

If a comma or semicolon is given at the end of the parameters, the command ends without moving the cursor. If nothing is given, the cursor moves to the left edge of the next line.

Characters that are control codes work as in the PRINT command.

### RANDOMIZE

*Direct-mode command, program-mode command*

**Function:** Sets the random number sequence.

**Syntax:** `RANDOMIZE <seed>`

**Example:**
```
RANDOMIZE 1234
FOR I=1 TO 10:PRINT RND(100):NEXT
```

**[Parameters]**
- `<seed>`: a fixed-point number.

**[Details]** Sets the random number sequence produced by the RND function from `<seed>`. BASIC renews the random sequence at startup, at RUN and at LOAD. If a constant is given as `<seed>`, the RND function always returns the same sequence.

**[See also]** RND

*[p. 72]*

### READ

*Program-mode command*

**Function:** Reads data into variables.

**Syntax:** `READ <variable>[,<variable>...]`

**Example:**
```
READ A
READ A,A$,B$
```

**[Parameters]**
- `<variable>`: the variable(s) to read the data into.

**[Details]** Reads the items of a DATA statement into the variables in order, and advances the read position. If an item is empty, a numeric variable gets 0 and a string variable gets a string of length 0.

```
10 READ A,B
20 PRINT A,B
30 DATA  ,
```
→ there is no data item, so it is treated as 0.

If there is no data left to read, an "Out of DATA" error occurs. If the type of the variable and the type of the data differ, a "Type mismatch" error occurs.

**[See also]** DATA, RESTORE, ON RESTORE, USERDATA

### REM or '

*Direct-mode command, program-mode command*

**Function:** Writes a comment.

**Syntax:** `{REM|'} [<comment>]`

**Example:**
```
REM Game Main
'=== Enemy Move subroutine ===
```

**[Parameters]**
- `<comment>`: any text. It can be left out.

**[Details]** Anything written after REM or ' is not run. REM and ' do not act as statement separators.

*[p. 73]*

### RENUM

*Direct-mode command*

**Function:** Renumbers the program's lines.

**Syntax:** `RENUM [<new number>][,<old number>][,<interval>]`

**Example:**
```
RENUM
RENUM 1000,320
RENUM ,,100
```

**[Parameters]**
- `<new number>`, `<old number>`, `<interval>`: 1 to 99999.

**[Details]** Renumbers the lines from `<old number>` onward so that they start at `<new number>` and go up by `<interval>`. If line `<old number>` does not exist, the lines after it are used. If left out, `<new number>` is 100, `<old number>` is all lines and `<interval>` is 10.

A `<new number>` that would duplicate existing line numbers cannot be given, nor values whose result would exceed the maximum line number.

### RESTORE

*Program-mode command*

**Function:** Sets the DATA to be read next.

**Syntax:** `RESTORE [{<line number>|<label>}]`

**Example:**
```
RESTORE
RESTORE 1000
RESTORE *DATA1
```

**[Parameters]**
- `<line number>`, `<label>`: the position to read from.

**[Details]** Sets the DATA statements from the given line onward as the data for the next READ command or READ option. Data is read from the nearest DATA statement at or after that position, so the command is valid even if the given line has no DATA statement. If the parameter is left out, the first DATA statement in the program is used.

*[p. 74]*

**[See also]** READ, DATA, ON RESTORE, USERDATA

### RESUME

*Direct-mode command, program-mode command*

**Function:** Returns from error handling.

**Syntax:** `RESUME [{NEXT|<line number>|<label>}]`

**Example:**
```
RESUME NEXT
```

**[Parameters]**
- `NEXT`: runs again from the command after the one that caused the error.
- `<line number>`, `<label>`: runs again from the given position.

**[Details]** Ends error handling and continues the program. If the parameter is left out, the command that caused the error is run again. ERR and ERL are reset to 0.

**[See also]** ON ERROR GOTO, ERR, ERL, ERROR

**[Caution]** In direct mode, `<line number>` cannot be given ("Illegal direct" error).

### RETURN

*Program-mode command*

**Function:** Returns from a subroutine.

**Syntax:** `RETURN`

**[Details]** Returns to the command after the GOSUB that called the subroutine.

**[See also]** GOSUB, ON GOSUB

*[p. 75]*

### RIGHT$

*String function*

**Function:** Takes a string of the given length from the right of a string and returns it.

**Syntax:** `RIGHT$(<target string>, <numeric expression>)`

**Example:**
```
A$ = RIGHT$("ABC",2)
PRINT RIGHT$(I$,X)
```

**[Parameters]**
- `<target string>`: a string expression.
- `<numeric expression>`: a fixed-point numeric expression. The valid range is 0 and above (any fraction is cut off).

**[Return value]** Returns the number of characters given by `<numeric expression>` from the right of the string given by `<target string>`.

**[Details]** If `<target string>` is the empty string, the return value is also the empty string. If `<numeric expression>` is greater than the length of `<target string>`, `<target string>` is returned. If `<numeric expression>` is 0, the return value is the empty string.

`<target string>` is not changed.

### RND

*Fixed-point function*

**Function:** Returns a random number.

**Syntax:** `RND(<upper limit>)`

**Example:**
```
R = RND(100)
```

**[Parameters]**
- `<upper limit>`: a fixed-point numeric expression, the upper limit of the random numbers produced. The valid range is integers of 0 and above (any fraction is cut off).

**[Return value]** Returns any integer less than the value given by `<upper limit>`. For example, if 10 is given the result is 0 to 9; if 1 is given, 0 is always returned.

**[Details]** Returns a random number less than `<upper limit>`. This BASIC's random numbers are set to a new random sequence at system startup, by the RUN command and by the LOAD command. To always use the same random sequence, run the RANDOMIZE command at the start of the BASIC program.

*[p. 76]*

**[See also]** RANDOMIZE

### RUN

*Direct-mode command, program-mode command*

**Function:** Runs a program.

**Syntax:** `RUN [<line number>|<label>]`

**Example:**
```
RUN
RUN 100
```

**[Parameters]**
- `<line number>`: the valid range is integers from 1 to 99999.
- `<label>`: the name of a label in the program. Names follow the label naming rules.

**[Details]** Starts running the program from the line given by `<line number>` or `<label>`. If `<line number>` or `<label>` is left out, the program runs from its start.

The RUN command also does the following:

- Sets all numeric variables to 0.
- Sets all string variables to the empty string.
- Cancels all DIM declarations.
- Sets the line number of the last error (ERL function) to 0.
- Sets the error number of the last error (ERR function) to 0.
- Sets the READ read position to the start of the program.
- Resets FOR-NEXT and IF nesting to the initial state.
- Closes all open files unconditionally.
- Disables the INTERVAL and TIMER commands.
- Sets the PAD command's trigger input to 0.
- Disables USERDATA.
- Disables the voice data cache.

*[p. 77]*

### SGN

*Fixed-point function*

**Function:** Returns the sign of the given number.

**Syntax:** `SGN(<numeric expression>)`

**Example:**
```
A = SGN(A)
S = SGN(X1-X2)
```

**[Parameters]**
- `<numeric expression>`: a fixed-point numeric expression.

**[Return value]** Returns the sign of the number given by `<numeric expression>`.

**[Details]** Returns -1 if `<numeric expression>` is negative, 1 if it is positive and 0 if it is 0. The type of the return value is the same numeric type as the `<numeric expression>` given as the argument.

### SHIFT

*Fixed-point function*

**Function:** Checks the state of the Sega Saturn keyboard's shift keys.

**Syntax:** `SHIFT`

**Example:**
```
IF SHIFT AND 3 THEN PRINT "Shift ON"
```

**[Return value]** Returns the keyboard's shift key information.

**[Details]** A function that returns the state of the Sega Saturn keyboard's [Shift], [Alt], [Ctrl], [Caps Lock] and [Katakana/Hiragana] keys. It is used, for example, to extend key functions by combining the input code returned by INKEY$ or similar with the state of the shift keys. The relation between the value returned and the state of the keyboard is as follows.

*[p. 78]*

| Keyboard | Bit | Binary | Hex | Bit is 1 when |
|---|---|---|---|---|
| [Shift] key (left) | 0 | `&B00000001` | `&H1` | held down |
| [Shift] key (right) | 1 | `&B00000010` | `&H2` | 〃 |
| [Ctrl] key (left) | 2 | `&B00000100` | `&H4` | 〃 |
| [Ctrl] key (right) | 3 | `&B00001000` | `&H8` | 〃 |
| [Alt] key (left) | 4 | `&B00010000` | `&H10` | 〃 |
| [Alt] key (right) | 5 | `&B00100000` | `&H20` | 〃 |
| [Caps Lock] key | 6 | `&B01000000` | `&H40` | in Caps Lock |
| [Katakana/Hiragana] key | 7 | `&B10000000` | `&H80` | in katakana |

Because of the input limits of the Sega Saturn keyboard, if three or more keys are pressed at the same time the bits may not be reflected correctly. The shift state of the BASTERM virtual keyboard can also be read, but there is no distinction between left and right keys. Also, when the CPU is under load, for example from showing many polygons or scrolling the screen, the bits may not be reflected correctly.

| Virtual keyboard | Bit | Binary | Hex | Bit is 1 when |
|---|---|---|---|---|
| [Shift] key | 0,1 | `&B000000011` | `&H3` | held down |
| [Ctrl] key | 2,3 | `&B000001100` | `&HC` | 〃 |

### SIN

*Floating-point function*

**Function:** Returns the sine.

**Syntax:** `SIN(<angle>)`

**Example:**
```
A# = SIN(0)
PRINT SIN(I#)
```

**[Parameters]**
- `<angle>`: a floating-point numeric expression. A fixed-point numeric expression is converted to floating point before it is given (the unit is radians).

**[Return value]** The type of the return value is floating point.

*[p. 79]*

**[Details]** The unit of `<angle>` is radians (2π = 360°). Returns the sine (the ratio of the vertical side to the hypotenuse, -1 to 1) for the given `<angle>`.

**[Example]**
```
PRINT SIN(0)             → shows " 0"
PRINT SIN(ATN(1)*2)      → shows " 1"
```

### SKCLOSE

*Direct-mode command, program-mode command*

**Function:** Closes the software keyboard.

**Syntax:** `SKCLOSE`

**Example:**
```
SKCLOSE
```

**[Details]** If run while the software keyboard is shown on the screen, closes it.

**[Caution]** This command does not disable the software keyboard, so it can be opened again with the pad.

### SPACE$

*String function*

**Function:** Returns a string of spaces of the given length.

**Syntax:** `SPACE$(<length>)`

**Example:**
```
A$ = SPACE$(10)
```

**[Parameters]**
- `<length>`: a fixed-point numeric expression. The valid range is 0 and above (any fraction is cut off).

**[Return value]** Returns a string of spaces with the number of characters given by `<length>`.

**[Details]** If `<length>` is 0, the null string is returned.

*[p. 80]*

### SQR

*Floating-point function*

**Function:** Returns the square root.

**Syntax:** `SQR(<numeric expression>)`

**Example:**
```
A# = SQR(X)
```

**[Parameters]**
- `<numeric expression>`: a floating-point numeric expression. If the result of the expression is fixed point, it is converted to floating point before it is given. The valid range is 0 and above.

**[Return value]** Returns the square root of the number given by `<numeric expression>`.

**[Details]** Giving a negative value as `<numeric expression>` causes an "Illegal function call" error.

### STOP

*Program-mode command*

**Function:** Interrupts the running program.

**Syntax:** `STOP`

**Example:**
```
1000 STOP
```

**[Details]** Interrupts the running program. An interrupted program can be run again with the CONT command.

### STR$

*String function*

**Function:** Converts a number to a string in decimal form.

**Syntax:** `STR$(<numeric expression>[,<suppress>])`

**Example:**
```
A$ = STR$(10)
PRINT STR$(A,2)
```

**[Parameters]**
- `<numeric expression>`: a fixed-point numeric expression.
- `<suppress>`: a fixed-point numeric expression. The valid range is 0 to 3 (any fraction is cut off).

*[p. 81]*

**[Return value]** The return value is a string in decimal form.

**[Details]** Converts the number given by `<numeric expression>` to a string in decimal form and returns it. If `<numeric expression>` is negative, a minus sign (-) is added to the start of the string. If it is not negative, a space is added to the start of the string.

`<suppress>` sets whether missing digits after conversion are filled with "0". It is handled as follows depending on its value:

| Value | Meaning |
|---|---|
| 0 | Missing digits are not filled with "0" (default) |
| 1 | Only the integer part is filled with "0"; the fraction is not |
| 2 | Only the fraction is filled with "0"; the integer part is not |
| 3 | Both the integer part and the fraction are filled with "0" |

A "." is added between the integer part and the fraction of the return value.

**[Example]**
```
PRINT STR$(123.25)      → shows " 123.25"
PRINT STR$(123.25,1)    → shows " 000123.25"
PRINT STR$(123.25,2)    → shows " 123.2500"
PRINT STR$(123.25,3)    → shows " 000123.2500"
PRINT STR$(-123.25)     → shows "-123.25"
```

### STRING$

*String function*

**Function:** Returns a string that repeats the given character.

**Syntax:** `STRING$(<repeat count>,{<numeric expression>|<string expression>})`

**Example:**
```
A$ = STRING$(8,"A")
A$ = STRING$(I,D AND &HFF)
```

**[Parameters]**
- `<repeat count>`: a fixed-point numeric expression. An integer of 0 or more (any fraction is cut off).
- `<numeric expression>`: a fixed-point numeric expression. Whatever its sign, only 8 bits of the integer part are used (any fraction is cut off).
- `<string expression>`: a string expression. Only the first character is repeated.

**[Return value]** Returns a string that repeats the character given by `<numeric expression>` or `<string expression>` `<repeat count>` times.

*[p. 82]*

**[Details]** If `<numeric expression>` is given, its value is treated as the character code of the character. Whatever its sign, only the low 8 bits of the integer part of `<numeric expression>` are used. Only the first character of `<string expression>` is used.

**[Example]**
```
PRINT STRING$(5,&H41)   → shows "AAAAA"
PRINT STRING$(4,"1")    → shows "1111"
```

To repeat a string of two or more characters, use the STRW$() function.

### STRW$

*String function*

**Function:** Returns a string that repeats the given data.

**Syntax:** `STRW$(<repeat count>,{<numeric expression>|<string expression>})`

**Example:**
```
A$ = STRW$(8,"ABC")
A$ = STRW$(I,D AND &HF0FF)
```

**[Parameters]**
- `<repeat count>`: a fixed-point numeric expression. The valid range is integers of 0 and above (any fraction is cut off).
- `<numeric expression>`: a numeric expression whose result is fixed point. The valid range is integers from 0 to 65535 (any fraction is cut off).
- `<string expression>`: a string expression giving the string to repeat.

**[Return value]** Returns a string that repeats the data given by `<numeric expression>` or `<string expression>` `<repeat count>` times.

**[Details]** If `<numeric expression>` is given, it is treated as a word string. Only the low 16 bits of the integer part are used. These 16 bits are used repeatedly, with the high 8 bits as the first character code and the low 8 bits as the next character code.

**[Example]**
```
PRINT STRW$(5,&H4142)                   → shows "ABABABABAB"
PRINT STRW$(4,"123")                    → shows "123123123123"
PALETTE ,STRW$(32,RGB(3,0,0)+&H8000)    → makes 32 RGB data items for the bitmap screen
```

If the result of `<string expression>` is one character, use the STRING$() function.

*[p. 83]*

### SWAP

*Direct-mode command, program-mode command*

**Function:** Swaps the contents of variables.

**Syntax:** `SWAP <variable 1>,<variable 2>`

**Example:**
```
SWAP A,B
SWAP A$,D$(I)
```

**[Parameters]**
- `<variable 1>`, `<variable 2>`: the names of the variables whose contents are swapped. Names follow the variable naming rules.

**[Details]** Swaps the contents of the variables given by `<variable 1>` and `<variable 2>`. There is no limit on the type of variable, but the two variables must be of the same type. If a given variable is an array variable, only the one element with the given subscript is affected.

### TAN

*Floating-point function*

**Function:** Returns the tangent.

**Syntax:** `TAN(<angle>)`

**Example:**
```
A# = TAN(D#)
```

**[Parameters]**
- `<angle>`: the unit of `<angle>` is radians (2π = 360°). A floating-point numeric expression. A fixed-point numeric expression is converted to floating point before it is given.

**[Return value]** The type of the return value is floating point.

**[Details]** Returns the tangent (the ratio of the vertical side to the horizontal side) for the given `<angle>`.

*[p. 84]*

### TIMER

*Program-mode command*

**Function:** Sets a countdown timer.

**Syntax:**
```
(1) TIMER[(<countdown timer number>)] ON [,<time>]
(2) TIMER[(<countdown timer number>)] <time>
(3) TIMER[(<countdown timer number>)] OFF
```

**Example:**
```
TIMER ON
TIMER(0) ON,60
TIMER(2) 0
TIMER OFF
```

**[Parameters]**
- `<countdown timer number>`: a fixed-point numeric expression. The valid range is 0 to 7 (any fraction is cut off).
- `<time>`: a fixed-point numeric expression. The valid range is 0 and above (any fraction is cut off).
- `ON`: starts timing of the countdown timer.
- `OFF`: disables the countdown timer's interrupt.

**[Details]** Form (1) starts timing of the given countdown timer. Form (2) sets the time until the given countdown timer's interrupt occurs. Form (3) stops the given countdown timer's interrupt from occurring.

Sets the state of the countdown timer given by `<countdown timer number>`. If `<countdown timer number>` is left out, it is treated as 0.

Form (1) enables interrupts from the given countdown timer. At the same time it starts (resumes) timing of the countdown timer. If `<time>` is given, the countdown timer's count so far is reset and a new time until an interrupt occurs is set. If `<time>` is left out, it only enables interrupts; the count so far and the previous time until an interrupt are kept unchanged.

Form (2) sets only the time until the given countdown timer's interrupt occurs. The count so far and whether interrupts are enabled or disabled are kept unchanged. If changing `<time>` means the condition for an interrupt is met, the interrupt occurs at the next count. However, this is only when interrupts are enabled.

Form (3) disables the interrupt of the given countdown timer. The count so far and the time until the interrupt are kept unchanged. If the condition for an interrupt is met while interrupts are

*[p. 85]*

disabled, no interrupt occurs and counting ends (the interrupt is not held over).

If 0 is given as `<time>` in form (1) or form (2), timing of the countdown timer stops. At that time, the count so far is reset to the interrupt interval set before.

- **Unit of `<time>`:** the countdown timer counts every 1/60 second. The time until an interrupt can also be set in steps of 1/60 second.
- **Interrupts from countdown timers:** when the count reaches the `<time>` set, an interrupt occurs. This works almost the same as an interval timer interrupt, but once an interrupt occurs the countdown timer stops counting, so interrupts do not occur repeatedly. If several interrupts are set, other interrupts may occur even while an interrupt is being handled.
- **Order in which interrupts occur:** among all countdown timers and interval timers, the timer that finished counting is handled first. If several timers finish counting at the same moment, they are handled round-robin (the timer after the last one handled has top priority).
- **Interrupts happen between BASIC commands:** only one interrupt is handled at a time. Most BASIC commands take less than 1/60 second to run, so in practice several interrupts are handled within 1/60 second. Before running this command, the routine called when the interrupt occurs must be set with the ON TIMER GOSUB command.

**[See also]** LOCK, UNLOCK

### UNLOCK

*Direct-mode command, program-mode command*

**Function:** Enables interrupt handling.

**Syntax:** `UNLOCK`

**Example:**
```
10 *TIMER_ROUTINE:LOCK
20  ACTIVE 1:LINE (XS,YS)-(XE,YE)
30  UNLOCK:RETURN
```

**[Details]** Enables again the calls to interrupt subroutines registered with the ON INTERVAL and ON TIMER commands that were disabled with the LOCK command. For details, see the LOCK command.

*[p. 86]*

### USERDATA

*Program-mode command*

**Function:** Uses the user area for DATA-statement-style access.

**Syntax:**
```
(1) USERDATA [<block, offset,>] <"string">,<switch>
(2) USERDATA <block, offset>
(3) USERDATA END
```

**Example:**
```
(1) USERDATA 0,0,"ABC",1
(2) USERDATA 0,0
(3) USERDATA END
```

**[Parameters]**
- `<block>`: the first block of the user area where the data is stored. An integer from 0 to 4095; any fraction is ignored. The actual address is the start address of the user area + block × 256 + offset.
- `<offset>`: the offset from the first block. 0 to &H1FFFF; any fraction is ignored.
- `<"string">`: the data actually stored in the user area. Numbers, strings and so on can be given in the form written in a DATA statement. Numbers are also given enclosed in " ", but in that case the next item, the switch, is set to 0 so they are registered without quotes.
- `<switch>`: chooses how quotes are handled. 1 registers the data including the quotes (default); 0 leaves the quotes out.

**[Details]** Form (1) converts the contents of "string" to the same structure as a DATA statement and stores it in the user area. To register more data after it, leave out the block and offset. After this command runs, unless a new block and offset are given, this is the start address of the data read by the next READ command or command with the READ option (it acts as "RESTORE" for the user area).

Form (2) (with no string or switch) is the way to access data that was made into a DATA statement structure with this command, saved with "BSAVE" and later loaded with "BLOAD". Give the block and offset the same values as given to "BLOAD" (for the parameters to give to "BSAVE", see the USERDATA function).

Form (3) ends "USERDATA" mode and switches back to reading from ordinary DATA statements. The USERDATA command keeps the read pointer from before switching to "USERDATA" mode and restores it, so running the RESTORE command in "USERDATA" mode is ignored.

*[p. 87]*

**[Caution]** Running any of the following, which rewrite the user area, forces a return from "USERDATA" mode to "normal READ" mode:

- "BLOAD" to the user area with a different offset.
- Running the CLEAR statement.
- Running the POKE command.

If an error occurs during a read in "USERDATA" mode, its location cannot be identified.

**[Example 1]**
```
100 CLEAR 100:RESTORE *NORMAL_DATA
110 USERDATA 0,0,"@44L8CDEFGAB>C"
120 USERDATA     "NEXT"
130 USERDATA     "C<BAGFEDC"
140 USERDATA     "ENDSONG"
150 BSAVE"BRAM:MML_TST",USERDATA(0),USERDATA(1),USERDATA(2),USERDATA(3)
160 SETSONG
170 USERDATA END
     :
300 *NORMAL_DATA
310 DATA …
```

- 100 → reserves 100 blocks of user area.
- 110 → registers "USERDATA" from the first block of the user area.
- 120 on → to register more data after it, the block and offset are not given.
- 150 → saves the registered "USERDATA" to "BRAM" under the file name <MML_TST>. The "BSAVE" parameters are just the return values of the "USERDATA" function.
- 160 → reads the MML strings from the "DATA" registered in the user area and registers the song data.
- 170 → ends "USERDATA" mode and returns to the read pointer set by the RESTORE command on line 100 (if there is no "RESTORE", the first DATA statement).

*[p. 88]*

**[Example 2]**
```
100 CLEAR 100:RESTORE *NORMAL_DATA
110 BLOAD "BRAM:MML_TST",10,0
120 USERDATA 10,0
130 SETSONG
140 USERDATA END
     :
300 *NORMAL_DATA
310 DATA …
```

- 100 → reserves 100 blocks of user area.
- 110 → loads the "USERDATA" saved in example (1) into the user area (the block is 10 here, but any value can be used).
- 120 → sets the read pointer to point at the place loaded with "BLOAD" (the same as the RESTORE command for the user area).
- 130 → registers the song data using the loaded MML string data.
- 140 → to read data from ordinary "DATA" statements afterwards, end "USERDATA" mode.

### USERDATA()

*Program-mode command, fixed-point function*

**Function:** Returns the status of the USERDATA command.

**Syntax:** `A = USERDATA(<item number>)`

**Example:**
```
A=USERDATA(0)
BSAVE"BRAM:TEST",USERDATA(0),USERDATA(1),USERDATA(2),USERDATA(3)
```

**[Parameters]**
- `<item number>`: 0 to 3.

**[Return value]** These follow the parameters of the BSAVE command:

| Item number | Value |
|---|---|
| 0 | First block |
| 1 | First offset |
| 2 | End block |
| 3 | End offset |

**[Details]** Reads the state as of the last time data was registered with the USERDATA command. The first block and first offset are returned as the values given the first time a block/offset was given. The end block and end offset are updated each time data is registered with the USERDATA command. The values read by giving item numbers 0 to 3 can be used directly as the parameters of the BSAVE command.

*[p. 89]*

### VAL

*Fixed-point function*

**Function:** Converts a string to a number.

**Syntax:** `VAL(<string expression>)`

**Example:**
```
A = VAL(A$)
D = VAL("&H"+D$)
```

**[Parameters]**
- `<string expression>`: a string expression whose result represents a number.

**[Return value]** Returns the string given by `<string expression>` converted to a number.

**[Details]** The strings that can be converted are strings in binary, decimal or hexadecimal form. A binary string needs the number prefix "&B" at its start. A hexadecimal string needs the number prefix "&H" at its start. If the string contains a sign, put the prefix directly after the sign.

Spaces in the string are ignored, but if there is any other character that cannot be converted, conversion ends there. If a string that cannot be converted, or a string of length 0, is given, 0 is returned.

### VERSION

*Fixed-point function*

**Function:** Returns the BASIC version number.

**Syntax:** `VERSION`

**Example:**
```
A = VERSION
```

**[Return value]** The version number is returned as a fixed-point number.

**[Details]** The version number is returned as a fixed-point number.

*[p. 90]*

### WADD$

*String function*

**Function:** Returns a string after addition or subtraction on a string.

**Syntax:** `WADD$(<string expression>,<add value>[,<start position>])`

**Example:**
```
A$ = WADD$(A$,&H8080,2)
PRINT WADD$("ABCD",-&H0101)
```

**[Parameters]**
- `<string expression>`: a string expression. The resulting string is treated as a binary word string.
- `<add value>`: a fixed-point numeric expression. Only 16 bits of the integer part are used.
- `<start position>`: a fixed-point numeric expression. The valid range is 1 and above (any fraction is cut off).

**[Return value]** Takes every two characters of the given `<string expression>` as a number from 0 to 65535, high byte then low byte, adds the value given in `<add value>`, and returns the low 16 bits of the result turned back into a string.

**[Details]** If `<conversion string>` (sic) has an odd number of characters, the last character is cut off.

**[Example]**
```
PRINT WADD$("AAAAAAAA",&H0102)   → shows "BCBCBCBC"
PRINT WADD$("12345678",-&H0101)  → shows "01234567"
```

### WANDOR$

*String function*

**Function:** Returns a string after AND and OR operations on a string.

**Syntax:** `WANDOR$(<conversion string>,<AND value>,<OR value>[,<start position>])`

**Example:**
```
A$ = WANDOR$(A$,&HF0FF,&H7800)
PRINT WANDOR$("ABCD",&H5F5F,&H2020)
```

**[Parameters]**
- `<conversion string>`: a string expression. The resulting string is treated as a binary word string.
- `<AND value>`, `<OR value>`: fixed-point numeric expressions. Whatever their sign, only 16 bits of the integer part are used (any fraction is cut off).
- `<start position>`: a fixed-point numeric expression. The valid range is 1 and above (any fraction is cut off).

*[p. 91]*

**[Return value]** Takes every two characters of the given `<string expression>` as a number from 0 to 65535, high byte then low byte, first ANDs it with the value given in `<AND value>`, then ORs it with the value given in `<OR value>`, and returns the low 16 bits of the integer part of the result turned back into a string.

**[Details]** If `<conversion string>` has an odd number of characters, the last character is cut off.

**[Example]**
```
PRINT WANDOR$("AAAAAAAA",&HFFFF,&H0002)   → shows "ACACACAC"
PRINT WANDOR$("AbCdEfGh",&H5F5F,&H2020)   → shows "abcdefgh"
PRINT WANDOR$("AbCdEfGh",&H5F5F,&H0000)   → shows "ABCDEFGH"
```

### WIDTH

*Direct-mode command, program-mode command*

**Function:** Sets the display area of the text screen.

**Syntax:** `WIDTH [<left>],[<top>][,<right>][,<bottom>]`

**Example:**
```
WIDTH 0,20,63,24
```

**[Parameters]**
- `<left>`, `<top>`, `<right>`, `<bottom>`: fixed-point numeric expressions. The valid range is integers from 0 to 127.

**[Details]** Sets the area of the text screen where characters and so on are shown. If the display width is large, parts may not fit on the TV monitor. In that case they can be shown with the SCROLL command or similar. Changing the display area with WIDTH does not change how lines are joined when editing. The SCREEN command sets the WIDTH area to 1,1,38,26. Also, [Ctrl]+[P] while editing changes it to the area set on the system settings screen.

### WMUL$

*String function*

**Function:** Returns a string after multiplication on a string.

**Syntax:** `WMUL$(<conversion string>,<multiplier>[,<start position>])`

**Example:**
```
A$ = WMUL$(A$,2,2)
```

**[Parameters]**
- `<conversion string>`: a string expression. The resulting string is treated as a binary word string.
- `<multiplier>`: a fixed-point numeric expression.

*[p. 92]*

- `<start position>`: only fixed-point values are valid (any fraction is cut off). The valid range is 1 and above.

**[Return value]** Takes every two characters of the given `<string expression>` as a number from 0 to 65535, high byte then low byte, multiplies each value by `<multiplier>`, and returns the low 16 bits turned back into a string.

**[Details]** If `<conversion string>` has an odd number of characters, the last character is cut off.

**[Example]**
```
PRINT WMUL$("12",2)     → shows "bd"
PRINT WMUL$("bd",1/2)   → shows "12"
```

### WXOR$

*String function*

**Function:** Returns a string after an XOR operation on a string.

**Syntax:** `WXOR$(<conversion string>,<XOR value>[,<start position>])`

**Example:**
```
A$ = WXOR$(A$,&H0800)
PRINT WANDOR$("ABCD",&HFFFF)
```
(The second example is printed with WANDOR$ (sic); WXOR$ is meant.)

**[Parameters]**
- `<conversion string>`: a string expression. The resulting string is treated as a binary word string.
- `<XOR value>`: a fixed-point numeric expression. Whatever its sign, only 16 bits of the integer part are used.
- `<start position>`: a fixed-point numeric expression. The valid range is 1 and above (any fraction is cut off).

**[Return value]** Takes every two characters of the given `<string expression>` as a number from 0 to 65535, high byte then low byte, XORs it with `<XOR value>`, and returns the low 16 bits of the result turned back into a string.

**[Details]** If `<conversion string>` has an odd number of characters, the last character is cut off.

**[Example]**
```
PRINT WXOR$("AAAAAAAA",&H0304)   → shows "BEBEBEBE"
PRINT WXOR$("NANANANA",&H0F00)   → shows "AAAAAAAA"
```

*[p. 93]*

### XATN

*Fixed-point function*

**Function:** Returns the arctangent.

**Syntax:** `XATN(<horizontal ratio>,<vertical ratio>)`

**Example:**
```
A = XATN(X,Y)
```

**[Parameters]**
- `<horizontal ratio>`, `<vertical ratio>`: fixed-point numeric expressions.

**[Return value]** The return value is fixed point, a fraction from 0 to less than 1. The unit is "radians" in this manual's sense (1.000 = 360°).

**[Details]** Returns the arctangent derived from `<horizontal ratio>` and `<vertical ratio>`. However, if `<horizontal ratio>` = 0 and `<vertical ratio>` = 0, 0 is returned.

**[Example]**
```
PRINT XATN(1,0)    → shows "0"
PRINT XATN(0,1)    → shows ".25"
PRINT XATN(-1,0)   → shows ".5"
PRINT XATN(0,-1)   → shows ".75"
```

### XCOS

*Fixed-point function*

**Function:** Returns the cosine.

**Syntax:** `XCOS(<angle>)`

**Example:**
```
A = XCOS(0)
PRINT XCOS(I)
```

**[Parameters]**
- `<angle>`: a fixed-point numeric expression. The integer part is ignored.

**[Return value]** The return value is fixed point, a fraction from 0 to less than 1.

**[Details]** The unit of `<angle>` is "radians" (1.000 = 360°). Returns the ratio of the horizontal side to the hypotenuse (-1 to 1) for the given `<angle>`.

*[p. 94]*

### XDIST

*Fixed-point function*

**Function:** Calculates and returns the distance from the origin.

**Syntax:** `XDIST(<XP>, <YP> [, <ZP>])`

**Example:**
```
PRINT XDIST(10,10,10)
```

**[Parameters]**
- `<XP>`, `<YP>`, `<ZP>`: fixed-point numeric expressions.

**[Return value]** Returns the distance from the 2D origin (0,0) to (`<XP>`,`<YP>`), or from the 3D origin (0,0,0) to (`<XP>`,`<YP>`,`<ZP>`).

**[Details]** The distance is obtained by calculating:

- if `<XP>`, `<YP>` are given: `SQR(<XP>^2 + <YP>^2)`
- if `<XP>`, `<YP>`, `<ZP>` are given: `SQR(<XP>^2 + <YP>^2 + <ZP>^2)`

If the result exceeds &h1FFFF, an OVER FLOW ERROR occurs.

**[Example]**
```
PRINT XDIST(10000,10000,10000)
17320.508
```

### XSIN

*Fixed-point function*

**Function:** Returns the sine.

**Syntax:** `XSIN(<angle>)`

**Example:**
```
A = XSIN(0)
PRINT XSIN(I)
```

**[Parameters]**
- `<angle>`: a fixed-point numeric expression. The integer part is ignored.

**[Return value]** The return value is fixed point, a fraction from 0 to less than 1.

**[Details]** The unit of `<angle>` is "radians" (1.000 = 360°). Returns the ratio of the vertical side to the hypotenuse (-1 to 1) for the given `<angle>`.

*[p. 95]*

### XSQR

*Floating-point function*

**Function:** Returns the square root.

**Syntax:** `XSQR(<numeric expression>)`

**Example:**
```
A = XSQR(X)
```

**[Parameters]**
- `<numeric expression>`: a floating-point numeric expression. The valid range is 0 and above.

**[Return value]** Returns the square root of the number given by `<numeric expression>`.

**[Details]** Giving a negative value as `<numeric expression>` causes an "Illegal fanction call" (sic) error.

### XTAN

*Fixed-point function*

**Function:** Returns the tangent.

**Syntax:** `XTAN(<angle>)`

**Example:**
```
A = XTAN(D)
```

**[Parameters]**
- `<angle>`: a fixed-point numeric expression. The integer part is ignored.

**[Return value]** The return value is fixed point, a fraction from 0 to less than 1.

**[Details]** The unit of `<angle>` is "radians" (1.000 = 360°). Returns the ratio of the vertical side to the horizontal side for the given `<angle>`.

## 1.2 File commands

*[p. 96]*

### About the file commands

> **Caution.** If, after copying data on the saved data management screen or similar, two or more items with the same comment name exist in the same RAM (for a floppy disk, the same partition), BASIC confuses the files, so delete the one you do not need. When a program ends, all open files are discarded. To write data written with FWRITE, the file must be closed before the program ends. If an error occurs, all open files are discarded.

**■ Device names**

| Device | Meaning |
|---|---|
| `COM:` | Host computer (PC) |
| `BRAM:` | Internal RAM |
| `CRAM:` | Cartridge RAM |
| `FD0:` | Floppy disk: partition 1 |
| `FD1:` | Floppy disk: partition 2 |
| `CD:` | Built-in CD drive |

If `<device name>` is left out, the last device selected is used.

**■ File name strings**

A file name has the form "XXXXXXXX.Y" and is divided into the base name "XXXXXXXX" and the extension "Y". The extension "Y" shows the kind of file. The following are defined:

| Extension | Kind of file |
|---|---|
| "B" | BASIC program |
| "0" | 256-colour bitmap data |
| "1" | 32768-colour bitmap data |
| "D" | Other BASIC file |

- The base name is 1 to 8 characters from [A–Z, 0–9, _].
- Lower-case letters given in the base name or extension are converted to upper case.
- The base name cannot contain spaces.

*[p. 97]*

- A period is used to separate the base name and the extension.
- If a period is given and the base name is shorter than 8 characters, spaces are filled in up to the 8th character.
- A file name can end with a period, but nothing other than one of the defined extensions can follow the period.
- For SAVE and LOAD, if the extension is left out or blank, "B" is added.
- For GSAVE and GLOAD, if the extension is left out or blank, "0" or "1" is added.
- Otherwise the extension is "D".

As an exception, FILES and FILES$ allow "\*" as the extension, but files are not shown unless they match the pattern.

> **Caution.** In fact, the comment of the backup data name is used as the file name.

**■ File numbers**

A file number is the number used to work with a file. Unlike partition numbers, it starts at 1.

> **Caution.** If a write or read command such as LOAD or SAVE to or from the PC is run while the Sega Saturn is under load, reading or writing may not work properly. In that case, press [CTRL]+[P] or [F12], or run SCREEN 0.

*[p. 98]*

**File command list**

### BLOAD

*Direct-mode command, program-mode command*

**Function:** Reads a file into the user area reserved with the CLEAR command.

**Syntax:** `BLOAD "[<device name>]<file name>",<first block>,<first offset>`

**Example:**
```
BLOAD FILENAME$,0,0
```

**[Parameters]**
- `<device name>`: a string expression. Only the defined names can be given.
- `<file name>`: a string expression. Only characters valid in a file name can be given.
- `<first block>`: fixed point. The first block of the user area to read into.
- `<first offset>`: fixed point. The offset from the first block of the user area to read into.

**[Details]** If `<device name>` is left out, the device used last is used.

If the extension of `<file name>` is left out, "D" is added. If an extension is given explicitly and it is anything other than "D", a "Bad file name" error occurs.

The data is read in at the user area address `<first block>`\*256+`<first offset>`.

`<first block>` can be any value of 0 and above; any fraction is ignored. The range of `<first offset>` is 0 to &h1FFFF; any fraction is ignored.

**[Caution]** Trying to BLOAD with the same file name as a file already open on the same device causes a "File still open" error. Trying to read beyond the user area causes a "Not enough space" error.

*[p. 99]*

### BSAVE

*Direct-mode command, program-mode command*

**Function:** Writes the contents of the user area reserved with the CLEAR command to a file.

**Syntax:** `BSAVE "[<device name>]<file name>",<first block>,<first offset>,<end block>,<end offset>`

**Example:**
```
BSAVE FILENAME$,0,0,10,10
```

**[Parameters]**
- `<device name>`: a string expression. Only the defined names can be given.
- `<file name>`: a string expression. Only characters valid in a file name can be given.
- `<first block>`: fixed point. The first block of the user area to write out.
- `<first offset>`: fixed point. The offset from the first block of the user area to write out.
- `<end block>`: fixed point. The end block of the user area to write out.
- `<end offset>`: fixed point. The end offset of the user area to write out.

**[Details]** If `<device name>` is left out, the device used last is used. If the extension of `<file name>` is left out, "D" is added. If an extension is given explicitly and it is anything other than "D", a "Bad file name" error occurs.

The range of the user area written is `<first block>`×256+`<first offset>` to `<end block>`×256+`<end offset>`.

`<first block>` can be any value of 0 and above; any fraction is ignored. The range of `<first offset>` is 0 to &h1FFFF; any fraction is ignored.

**[Caution]** Trying to BSAVE with the same file name as a file already open on the same device causes a "File still open" error. If the target device does not have enough space, or if you try to make 99 or more files on a backup device, a "Not enough space" error occurs.

*[p. 100]*

### CLOSE

*Direct-mode command, program-mode command*

**Function:** Ends file access.

**Syntax:** `CLOSE [[#]<file number>]`

**Example:**
```
CLOSE
CLOSE #1
```

**[Parameters]**
- `<file number>`: a fixed-point numeric expression. The valid range is 1 to 2 (any fraction is cut off).

**[Details]** Closes a file opened with the OPEN command and ends access to it. If data is left in the file area when this command runs, the data is written to the file before it ends. If `<file number>` is left out, all files opened with the OPEN command are closed (on a backup device, the file is only written when it is closed).

### FILES

*Direct-mode command, program-mode command*

**Function:** Searches for files and shows the names of those that exist.

**Syntax:** `FILES "[<device name>][<search file name>]"[,P]`

**Example:**
```
FILES
FILES "COM:SAMPLE??"
FILES F$
```

**[Parameters]**
- `<device name>`: only the defined names can be given.
- `<search file name>`: a string expression. Only characters valid in a file name (including `<wildcards>`) can be given.
- `P`: pauses the listing.

**[Details]** Searches the device given by `<device name>` for the files given by `<search file name>`, and lists the information of the matching files on the screen.

The kinds and number of characters that can be used in `<device name>` and `<search file name>` follow the file name rules. Wildcards can be used in the file name.

If `<device name>` is left out, the device used last is used.

*[p. 101]*

If `<search file name>` is left out, all files on that device are included.

If `<file extension>` is left out, all file extensions are included.

If the option "P" is given, the listing pauses and waits for input when the file names found do not all fit on the screen. Pressing any key shows the rest. Each entry is shown as 10 characters of file name + 2 characters of separator; if a file name does not fit in the rest of the line, a new line is started.

If a device other than CD: is chosen for FILES, the capacity of the device is shown on the last line as:

```
Free size <remaining file blocks> / <total file blocks> file blocks
```

(1 file block = 64 bytes.) It is not shown for CD:.

### FORMAT

*Direct-mode command, program-mode command*

**Function:** Initialises the device `<device name>`.

**Syntax:** `FORMAT "<device name>"`

**Example:**
```
FORMAT "FD1:"
```

**[Parameters]**
- `<device name>`: a device name. See "About the file commands" above.

**[Details]** Erases (initialises) the whole device `<device name>`, only if it has not been formatted. The only devices that can be formatted are BRAM:, CRAM:, FD0: and FD1:. On a floppy disk, only the inside of the selected partition is formatted.

**[Example]**
```
FORMAT "FD1:"    ...
```
Initialises partition number 1 of the floppy disk. If the device name is not valid, a "Bad device name" error occurs.

**[Caution]** If the device is already formatted, an "Already formatted" error occurs.

*[p. 102]*

### FREAD

*Direct-mode command, program-mode command*

**Function:** Reads data from the file area into a string variable.

**Syntax:** `FREAD [#]<file number>,<string variable>,<number of bytes>`

**Example:**
```
FREAD #1,A$,10
```

**[Parameters]**
- `<file number>`: a fixed-point numeric expression. The valid range is 1 to 2 (any fraction is cut off).
- `<string variable>`: the name of a string variable. Names follow the variable naming rules.
- `<number of bytes>`: a fixed-point numeric expression. The valid range is 1 and above (any fraction is cut off).

**[Details]** Reads `<number of bytes>` of data from a file opened with the OPEN command into the variable given by `<string variable>`. The file must have been opened by the OPEN command either with INPUT or with no mode given. In fact, the data is read from the file area that corresponds to the given `<file number>`. Reading data moves the SEEK position on by the number of characters read. For the SEEK position, see the SEEK command.

**[Caution]** Trying to read beyond the size of the file causes an "Access past EOF" error.

**[See also]** SEEK

### FWRITE

*Direct-mode command, program-mode command*

**Function:** Writes data to the file area.

**Syntax:** `FWRITE [#]<file number>,<data>`

**Example:**
```
FWRITE #1,"ABC"
FWRITE 1,A$
```

**[Parameters]**
- `<file number>`: a fixed-point numeric expression. The valid range is 1 to 2 (any fraction is cut off).
- `<data>`: a string expression.

*[p. 103]*

**[Details]** Writes the data given by `<data>` to a file opened with the OPEN command. The file must have been opened by the OPEN command with OUTPUT, APPEND or no mode given. To finish writing, the file number must always be closed. In fact, the data is written to the file area that corresponds to the given `<file number>`, and it is written out to the file when writing is finished and the CLOSE command is run. Writing data moves the SEEK position on by the number of characters written. For the SEEK position, see the SEEK command.

**[See also]** SEEK

### GLOAD

*Direct-mode command, program-mode command*

**Function:** Reads the bitmap data of `<file name>` into `<logical BG>`.

**Syntax:** `GLOAD "[<device name>]<file name>"[,<logical BG>][,(<destination X>,<destination Y>)][,P]`

**Example:**
```
GLOAD "COM:TEST.1"
```

**[Parameters]**
- `<device name>`: a string expression. Only the defined names can be given.
- `<file name>`: a string expression. Only characters valid in a file name can be given.
- `<logical BG>`: a fixed-point numeric expression. The valid range depends on the screen mode set by the SCREEN command.
- `<destination X>`, `<destination Y>`: the coordinates of one point of the destination rectangle (corresponding to the start point of the source). Fixed-point numeric expressions.
- `P`: the palette colour data in 256-colour bitmap data is not read.

*[p. 104]*

**[Details]** Reads graphics data into the bitmap screen from the position (`<destination X>`,`<destination Y>`). If the graphics data goes past the edge of the bitmap screen, it is handled in the same way as

```
GCOPY <string expression> TO 《destination coordinates》
```

If `<destination X>`, `<destination Y>` are left out, it runs as

```
<destination X>=0
<destination Y>=0
```

If `<device name>` is left out, the device used last is used. The extension of `<file name>` is one of the following:

| Extension | Kind of data |
|---|---|
| .0 | 256-colour bitmap data |
| .1 | 32768-colour bitmap data |

If the extension is left out, the extension that matches the current screen mode is added automatically. If the current screen mode cannot handle bitmap data, an "Illegal function call" error occurs.

If an extension is given explicitly and it does not match the screen mode, an "Illegal function call" error occurs.

If the option "P" is given, the palette colour data in 256-colour bitmap data is not read. This option is ignored in 32768-colour mode.

If `<logical BG>` is left out, the data is read into the bitmap screen given last with the ACTIVE command.

GLOAD uses a file buffer to read the graphics data temporarily, so the size needed must be reserved first with the CLEAR command. The file buffer used is the largest unused buffer (not assigned by the OPEN command), and it is used only temporarily while this command runs. The size of file buffer needed by GLOAD must be larger than the size of the graphics data read. For example, graphics data saved with GSAVE at a size of 320×224 dots must be read with GLOAD after reserving the following area with the CLEAR command:

| Data | Minimum |
|---|---|
| 256-colour bitmap data | 282 blocks (1 block = 256 bytes) |
| 32768-colour bitmap data | 560 blocks (〃) |

*[p. 105]*

**[Example]**
```
SCREEN 1
CLEAR,600
GLOAD "GDATA.0",1
```

**[Bitmap data format]** The format is as follows. It is basically the same format as the string used by the GCOPY command, but unlike a string the data size is not limited to &HFFFF. OFFSET is the position from the start of the data and SIZE is the number of bytes.

**256-colour bitmap data**

| OFFSET | SIZE | Contents |
|---|---|---|
| +0 | 2 | [Width] The width of the image data in dots (1–512). High byte, then low byte |
| +2 | 2 | [Height] The height of the image data in dots (1–256). High byte, then low byte |
| +4 | 512 | Palette colour data. 256 colours, high byte then low byte, 512 bytes |
| +516 | Variable | Dot data. [Width]\*[Height] bytes are needed, as given above |

The value 0 to 255 held in 1 dot = 8 bits is shown in the colour of the corresponding palette colour data. However, a value of 0 is shown as a transparent dot whatever the palette colour data holds.

The structure of the palette colour data is the same as the format handled by the RGB function:

```
&B0000000000011111   red component
&B0000001111100000   green component
&B1111110000000000   blue component
```

**32768-colour (RGB colour) bitmap data**

| OFFSET | SIZE | Contents |
|---|---|---|
| +0 | 2 | [Width] The width of the image data in dots (1–512). High byte, then low byte |
| +2 | 2 | [Height] The height of the image data in dots (1–256). High byte, then low byte |
| +4 | Variable | Dot data. [Width]×[Height]×2 bytes are needed, as given above |

*[p. 106]*

Each dot is represented by 16 bits of RGB data, arranged high byte then low byte for each dot.

The structure of the RGB data is the same as the format handled by the RGB function:

```
&B0000000000011111   red component
&B0000001111100000   green component
&B1111110000000000   blue component
```

However, the top bit of the display colour (bit 15) must be 1. So a black dot is given as

```
 RGB(0,0,0)+&H8000  (=&H8000)
```

To show a dot as transparent, give the whole RGB data as 0. The display of any other value (&H0001 to &H7FFF) is not guaranteed.

(The blue mask is printed with six 1 bits, so it also covers bit 15, the display bit described above.)

**[See also]** GSAVE, GCOPY, ACTIVE

### GSAVE

*Direct-mode command, program-mode command*

**Function:** Writes the bitmap data of `<logical BG>` to a file as the data of `<file name>`.

**Syntax:** `GSAVE "[<device name>]<file name>"[,<logical BG>][,(<start X>,<start Y>)-(<end X>,<end Y>)]`

**Example:**
```
GSAVE "COM:PICT",0
```

**[Parameters]**
- `<device name>`: a string expression. Only the defined names can be given.
- `<file name>`: a string expression. Only characters valid in a file name can be given.
- `<logical BG>`: a fixed-point numeric expression. The valid range depends on the screen mode set by the SCREEN command.
- `<start X>`, `<start Y>`, `<end X>`, `<end Y>`: the coordinates of two opposite corners of the source rectangle. Fixed-point numeric expressions.

*[p. 107]*

**[Details]** If `<start X>`, `<start Y>`, `<end X>`, `<end Y>` are left out, it runs as:

- `<start X>` = 0
- `<start Y>` = 0
- `<end X>` = 319
- `<end Y>` = 223

If `<device name>` is left out, the device used last is used. The extension of `<file name>` is one of the following:

| Extension | Kind of data |
|---|---|
| .0 | 256-colour bitmap data |
| .1 | 32768-colour bitmap data |

If the extension is left out, the extension that matches the current screen mode is added automatically. If the current screen mode cannot handle bitmap data, an "Illegal function call" error occurs. If an extension is given explicitly and it does not match the screen mode, an "Illegal function call" error occurs.

If `<logical BG>` is left out, the file is made from the bitmap screen given last with the ACTIVE command. GSAVE uses the largest unused file buffer to write the graphics data temporarily, so the size needed must be reserved first with the CLEAR command.

For example, to write the 320×224-dot data of `<logical BG>` 0 in SCREEN 0, do the following:

```
CLEAR ,600       → reserves 600 blocks for file buffer #1.
GSAVE "TEMP",0
```

With

- `<width>` = `<end X>` − `<start X>` + 1
- `<height>` = `<end Y>` − `<start Y>` + 1

the size of file buffer needed by GSAVE is:

- for 256-colour bitmap data, 4+512+(`<width>`×`<height>`) bytes
- for 32768-colour bitmap data, 4+(`<width>`×`<height>`×2) bytes

For the bitmap data format, see GLOAD. If the area saved with GSAVE is large, writing to the COM: device takes 1 to 2 minutes or more.

*[p. 108]*

### KILL

*Direct-mode command, program-mode command*

**Function:** Deletes the given file.

**Syntax:** `KILL [<device name>]<file name>`

**Example:**
```
KILL "BRAM:TEST.B"
KILL F$
```

**[Parameters]**
- `<device name>`: a string expression. Only the defined names can be given.
- `<file name>`: a string expression. Only characters valid in a file name can be given.

**[Details]** Deletes the file given by `<file name>` on the device given by `<device name>`. `<file name>` must be the complete name, including the extension. The kinds and number of characters that can be used in `<device name>` and `<file name>` follow the file name rules. If `<device name>` is left out, the device used last is used.

**[Caution]** The extension of `<file name string>` must always be given explicitly. If the extension is left out, it is treated as a space, so a "File not found" error occurs.

### LOAD

*Direct-mode command, program-mode command*

**Function:** Reads in a program list.

**Syntax:** `LOAD [<device name>]<file name>[,[{R|M}]...]`

**Example:**
```
LOAD "SAMPLE"
LOAD "BRAM:MAIN",R
LOAD F$,R
```

**[Parameters]**
- `<device name>`: a string expression. Only the defined names can be given.
- `<file name>`: a string expression. Only characters valid in a file name can be given.
- `{R|M}`: run immediately, or merge load.

*[p. 109]*

**[Details]** Reads the file given by `<file name>` from the device given by `<device name>`. The kinds and number of characters that can be used in `<device name>` and `<file name>` follow the file name rules.

If `<device name>` is left out, the device used last is used. "B" is always added as the extension, even if no extension is given explicitly.

If the "R" switch is given at the end, the program read in is run immediately.

If there is a program in memory, memory is initialised when the program is read in, so note that if an error occurs during reading, the original program that was in memory has already been discarded.

Whether a file is a runnable BASIC program is decided by its file extension.

Only when `<device name>` is FD0:, FD1:, BRAM: or CRAM: can ".D" be given as the extension of `<file name>`. Such a file must be in BASIC's text format (ASCII code). This is useful especially for merging programs without a PC connected, or for taking data made by a program such as a character editor in as part of a BASIC program.

If the device is COM:, or if the device is CRAM:, BRAM:, FD0: or FD1: and the file's extension is ".D", the M option can be given. This option merges the new program into the program that was there before loading. Lines with the same line numbers as the original are deleted, and lines of the new program are added. Lines that do not start with a line number are ignored.

When making a text-format program other than with the `SAVE"...",A` command, add CHR$(13)+CHR$(10) at the end of each program line (CHR$(13) is ignored, and CHR$(10) is taken as the end of a line).

**[Supplement]** The LOAD command can be written in a program (program mode), but note that the original program and the values of variables are lost. However, the contents of the user area reserved with CLEAR, and of textures, vertices, polygons, attributes, sound source data and so on, are kept.

> **Caution.** If a write or read command such as LOAD or SAVE to or from the PC is run while the Sega Saturn is under load, reading or writing may not work properly. In that case, press [CTRL]+[P] or [F12], or run SCREEN 0.

*[p. 110]*

### OPEN

*Direct-mode command, program-mode command*

**Function:** Prepares a file for reading and writing data.

**Syntax:** `OPEN [<device name>]<file name> [FOR {INPUT|OUTPUT|APPEND}]AS [#]<file number>`

**Example:**
```
OPEN "SAMPLE.D" AS 1
OPEN "SAVE.D" FOR INPUT AS 1
OPEN FILENAME$ FOR APPEND AS FNUM
```

**[Parameters]**
- `<device name>`, `<file name>`: string expressions.
- `<file number>`: a fixed-point numeric expression. The valid range is 1 to 2 (any fraction is cut off).

**[Details]** Assigns the file given by `<device name>` and `<file name>` to `<file number>` so that its contents can be read and written. If `<device name>` is left out, the device used last is used. The keyword given after FOR gives the file the following attribute:

- **INPUT:** opens the given file for reading only. INPUT cannot be given for a file that does not exist. Also, only files with the extension ".D" can be read.
- **OUTPUT:** opens the given file for writing a new file only. If OUTPUT is given for a file that does not exist, the file is created at that point. If OUTPUT is used on an existing file, the contents of that file are not read in, and the SEEK position is the start of the file.
- **APPEND:** opens the given file for appending only. APPEND cannot be given for a file that does not exist. The contents of the given file are read into the file area, and the SEEK position is moved to its end.

If the part from FOR on is left out, the file is assigned to that file number as a file that can be both read and written. Files created by the OPEN command are given the extension ".D".

*[p. 111]*

**[Caution]** If [FOR ...] is left out, the file is opened for writing or reading. Trying to open a file with the same file name as a file already open on the same device causes a "File already open" error. Trying to make 99 or more files on a backup device causes a "Not enough space" error.

### SAVE

*Direct-mode command*

**Function:** Saves a program list.

**Syntax:** `SAVE [<device name>]<file name>[,A]`

**Example:**
```
SAVE "SAMPLE"
SAVE "BRAM:MAIN"
SAVE F$
```

**[Parameters]**
- `<device name>`: a string expression. Only the defined names can be given.
- `<file name>`: a string expression. Only characters valid in a file name can be given.
- `A`: writes the program out as data, in a text-format file with the extension ".D".

**[Details]** Saves the program list on the device given by `<device name>` under the file name given by `<file name>`. The kinds and number of characters that can be used in `<device name>` and `<file name>` follow the file name rules.

If `<device name>` is left out, the device used last is used. The file extension ".B" is automatically added to the file name of a saved BASIC program.

Only when `<device name>` is FD0:, FD1:, BRAM: or CRAM:, giving the option "A" writes the program out as data in a text-format file with the extension ".D". This file can be read and written with the OPEN command.

Also, if the extension ".D" is given explicitly to the LOAD command, it can be read in as a program or merged.

Like the GSAVE command, the `SAVE"..",A` command uses a file buffer to hold the text file temporarily, so the size needed must be reserved first with the CLEAR command (in other words, very large files cannot be written out). If the size of the BASIC text file to be written is larger than the file buffer, an "Out of memory" error occurs. The file buffer used temporarily is the largest unused (not open)

*[p. 112]*

buffer. `SAVE"..",A` completes its work within this command, so the buffer is released after the command runs.

A buffer as large as the data to be written must be given with the second or third parameter of the CLEAR command.

**[See also]** CLEAR

> **Caution.** If a write or read command such as LOAD or SAVE to or from the PC is run while the Sega Saturn is under load, reading or writing may not work properly. In that case, press [CTRL]+[P] or [F12], or run SCREEN 0.

### SEEK

*Direct-mode command, program-mode command*

**Function:** Sets the read/write position in a file.

**Syntax:** `SEEK [#]<file number>,<position>`

**Example:**
```
SEEK #1,128
```

**[Parameters]**
- `<file number>`: a fixed-point numeric expression. The valid range is 1 to 2 (any fraction is cut off).
- `<position>`: a floating-point numeric expression. The range is 0 to 2147483647 (&H7FFFFFFF). Any fraction is cut off.

**[Details]** Sets the position for reading and writing in a file opened with the OPEN command. If the file was opened for reading only (`OPEN <file name> FOR INPUT AS ...`), giving a position beyond the original size of the file causes an "Access past EOF" error. If the file was opened in a mode that allows writing, the SEEK command can give a position beyond the original size of the file, but the contents there are undefined.

If a file is opened with `OPEN <file name> AS ...` or `OPEN <file name> FOR OUTPUT AS ...`, the size of the file is the largest size to which data was written, whatever the SEEK position.

If a file is opened with `OPEN <file name> FOR APPEND AS ...`, the size of the file is the largest size to which data was written, and at least the original file size, whatever the SEEK position. The current SEEK position can be obtained with the LOC function, and the end position of the file with the LOF function.

## 1.3 File functions

*[p. 113]*

### DSKF

*Fixed-point function, floating-point function*

**Function:** Returns the free space of the given device.

**Syntax:** `DSKF([<device name>])`

**Example:**
```
A = DSKF("BRAM:")
PRINT DSKF("")
```

**[Parameters]**
- `<device name>`: a string expression. Only the defined names can be given. If `<device name>` is left out or the empty string is given, the device used last is used.

**[Return value]** Returns the free space of the device given by `<device name>`.

**[Details]** The unit of the value returned is file blocks (1 file block = 64 bytes). The type of the return value in blocks is fixed point. If the free space of the given device is larger than the upper limit of fixed point, the maximum fixed-point value is returned.

**[Caution]** Using DSKF on CD: causes a "Bad device name" error. For a device that is not connected, a "Device no connected" (sic) error occurs.

*[p. 114]*

### FILES$

*String function*

**Function:** Searches for files and returns a string of the matching file names.

**Syntax:** `FILES$([<device name>][<search file name>][.<extension>])`

**Example:**
```
A$ = FILES$()
PRINT FILES$("COM:TEST*.b")
```

**[Parameters]**
- `<device name>`: a string expression. Only the defined names can be given.
- `<search file name>`: a string expression. Only characters valid in a file name (including wildcards) can be given.
- `<extension>`: a string expression. Only characters valid in a file extension (including wildcards) can be given.

**[Return value]** Returns a string joining the file names found.

**[Details]** Searches the device given by `<device name>` for the files given by `<search file name>`, and returns all matching file names joined in a string. Each entry in the string returned is made up of:

- the file name, 10 characters including the extension and period
- the number of file blocks, as a 5-character decimal number
- CHR$(13)
- CHR$(10)

The number of file blocks is added only for backup devices; for "CD:" and "COM:" that many spaces are put in instead (1 file block = 64 bytes).

**[Example]**
```
PRINT FILES$("CD:*.*")
```

The kinds and number of characters that can be used in `<device name>` and `<search file name>` follow the file name rules. Wildcards can be used in the file name. If `<device name>` is left out, the device used last is used. If `<search file name>` is left out, all files on that device are included.

If `<extension>` is left out, all file extensions are included. If no file matches, the empty string is returned.

*[p. 115]*

### LOC

*Floating-point function*

**Function:** Gets the read/write position of an open file.

**Syntax:** `LOC([#]<file number>)`

**Example:**
```
A# = LOC(#1)
SEEK 1,LOC(#1)+5
```

**[Parameters]**
- `<file number>`: a fixed-point numeric expression (any fraction is cut off). The valid range is 1 to 2.

**[Return value]** Returns the read/write position of a file opened with the OPEN command.

**[Details]** Returns the read/write position of a file opened with the OPEN command.

### LOF

*Floating-point function*

**Function:** Returns the end of the read/write positions of an open file.

**Syntax:** `LOF([#]<file number>)`

**Example:**
```
A# = LOF(#1)
SEEK 1,LOF(1)
```

**[Parameters]**
- `<file number>`: a fixed-point numeric expression (any fraction is cut off). The valid range is 1 to 2.

**[Return value]** Returns the end position of the read/write positions of a file opened with the OPEN command.

**[Details]** Returns the end position of the read/write positions of a file opened with the OPEN command.

## 1.4 BG/text/video commands

*[p. 116]*

### About the terms

| Term | Meaning |
|---|---|
| BG | A display plane that is not the sprite screen. Includes the bitmap and character screens |
| Character screen | A BG screen referenced by character codes. Includes the text display |
| Text screen | A BG screen used, among the character screens, specifically to show BASIC's characters. It can be set with the SCREEN command |
| Bitmap screen | A BG screen made of dots. There are 256-colour and 32768-colour screens. 256 colours is a screen given by colour index through the palette; 32768 colours is a screen that gives 15-bit RGB colour directly |
| 1-axis rotation screen | A rotating BG screen: a bitmap or character screen that rotates about the Z axis |
| 3-axis rotation screen | A rotating BG screen: a character screen that rotates about the X, Y and Z axes |

In this BASIC, the text screen is one of the character screens, used specifically to show text. Because of this, most commands that can be used on character screens can also be used on the text screen. Which character screen text is assigned to is given by a parameter of the SCREEN command. For example, the text font can be replaced with the PUTCHR command, and the RGB colours of the text can be changed with the PALETTE command. However, the SCREEN command returns these settings to the system's standard settings.

*[p. 117]*

**BG/text/video command list (including palette and screen synchronisation)**

### ACTIVE

*Direct-mode command, program-mode command*

**Function:** Sets the default number used when the logical BG is left out.

**Syntax:** `ACTIVE <logical BG>`

**Example:**
```
ACTIVE 0
ACTIVE (A AND 3)+4
```

**[Parameters]**
- `<logical BG>`: a fixed-point numeric expression. The valid range depends on the screen mode set by the SCREEN command (any fraction is cut off).

**[Details]** The behaviour depends on the value of `<logical BG>` given, as follows.

**When `<logical BG>` is 0 to 2:** when the logical BG is left out in the following commands and functions that read and write a bitmap screen, the bitmap `<logical BG>` set by this command is used:

- CIRCLE, LINE, GCOPY, PSET, PAINT and KPRINT commands, POINT function

**When `<logical BG>` is 4 to 8:** when the logical BG is left out in the following commands and functions that read and write a character screen, the character `<logical BG>` set by this command is used:

- CCOPY, PUTCHR and SETCHR commands, READCHR$ function

**When `<logical BG>` is 10 or more:** if `<logical BG>` is 10 or more, a texture registered with the SETTEX command is what is operated on. The correspondence between `<logical BG>` and texture ID is

```
<texture ID>+10=<logical BG>
```

Immediately after a texture is selected, the drawing area is the same as the texture size. If the texture is not defined, or the texture concerned has been lost through the SCREEN command or similar, an "Undefined texture" error occurs. When the following commands and functions that read and write a bitmap screen are used, the texture set by this command is operated on, so the texture must already have been defined with SETTEX. The number of colours of the texture must be 256 or 32768.

*[p. 118]*

- CIRCLE, LINE, GCOPY, PSET, PAINT, KPRINT and CLS commands, POINT function

The selections of bitmap screens (including textures) and character screens are kept separately, so one selection does not affect the other. However, in the following commands common to character screens and bitmap screens, the `<logical BG>` given last is used:

- CLS ACTIVE, MOSAIC ACTIVE and DISPLAY ACTIVE commands

In the rotating BG commands ROTCENTER, ROTOVER, ROTPOS, ROTATE and ROTZOOM, logical BG 8 or logical BG 9 given with the ACTIVE command is the target of the command.

| `<logical BG>` number | Kind of screen |
|---|---|
| 0 | Bitmap screen 0 |
| 1 | Bitmap screen 1 |
| 2 | Bitmap rotation screen 0 |
| 4 | Character screen 0 |
| 5 | Character screen 1 |
| 6 | Character screen 2 |
| 7 | Character screen 3 |
| 8 | Character rotation screen 0 |
| 9 | Character rotation screen 1 |
| 10 and above | Sprite/polygon plane |

### CCOPY

*Direct-mode command, program-mode command*

**Function:** Transfers image data of a rectangular area of a character screen.

**Syntax:**
```
(1) CCOPY 《source area》 TO 《destination coordinates》
(2) CCOPY <string expression> TO 《destination coordinates》
(3) CCOPY 《source area》 TO <string variable>
```

Format of 《source area》:
```
[<logical BG>,](<start X>,<start Y>)-(<end X>,<end Y>)
```

Format of 《destination coordinates》:
```
[<logical BG>,](<destination X>,<destination Y>)
```

**Example:**
```
CCOPY (0,0)-(99,99) TO (100,0)
CCOPY A$ TO 1,(0,100)
CCOPY 0,(0,0)-(20,7) TO V$
```

*[p. 119]*

**[Parameters]**
- `<logical BG>`: a fixed-point numeric expression (any fraction is cut off). The valid range depends on the screen mode set by the SCREEN command.
- `<start X>`, `<start Y>`, `<end X>`, `<end Y>`: the coordinates of two opposite corners of the source rectangle. Fixed-point numeric expressions.
- `<destination X>`, `<destination Y>`: the coordinates of one point of the destination rectangle (corresponding to the start point of the source). Fixed-point numeric expressions.
- `<string expression>`: the shape of the string is described below.
- `<string variable>`: the name of a string variable. Names follow the variable naming rules.

**[Details]** Form (1) copies image data of the given character screen to another area.

Form (2) transfers image data in string form to a character screen.

Form (3) turns image data of the given rectangle into a string and takes it into a variable.

If `<logical BG>` is left out, the logical BG of the character screen given last with the ACTIVE command is used.

Form (1) works as follows. The image of the rectangle given by 《source area》 is copied/transferred to the area given by 《destination coordinates》. The coordinates of the two are related so that the start point of the source rectangle corresponds to the coordinates given for the destination. However, whatever the positions of the given start coordinates, the image data is always transferred one horizontal line at a time from the top-left point of the source area.

In form (2), the source is string data (binary data holding an image), and the coordinates given for the destination are always the top-left position of the area. Transfer direction and so on follow form (1).

In form (3), the destination is a string variable, and the source image data is stored in the variable as binary string data. Transfer direction and so on follow form (1).

- **Coordinate limits:** the given coordinates are adjusted to fit within the size of the target `<logical BG>` (the unit is characters). The adjustment is done by taking the remainder by the maximum character width of `<logical BG>` (this is to cope with scrolling of the character screen).
- **Structure of the binary string holding an image:** the `<string expression>` given as the source and the `<string variable>` given as the destination hold data in the following format.

*[p. 120]*

| Bytes | Contents |
|---|---|
| 1st byte | Its character code is the width of the image data in characters (1–128) |
| 2nd byte | Its character code is the height of the image data in characters (1–128) |
| 3rd byte on | Pattern name data. 2 bytes are needed per character, high byte then low byte, so the shortest length is 4 bytes |

For details of pattern name data, see the PUTCHR command and the GETCHR function.

### CIRCLE

*Direct-mode command, program-mode command*

**Function:** Draws a circle on a bitmap screen.

**Syntax:**
```
(1) CIRCLE(<X>,<Y>),<radius>[,[<colour>][,F]]
(2) CIRCLE(<X>,<Y>),(<X radius>,<Y radius>)[,[<colour>][,F]]
```

**Example:**
```
CIRCLE(100,100),10,15
CIRCLE(X,Y),(RX,RY),C,F
```

Draws a circle inside the area of the bitmap screen clipped by the WINDOW command. Form (1) draws a true circle; form (2) draws an ellipse.

**[Parameters]**
- `<X>`, `<Y>`: fixed-point numeric expressions.
- `<radius>`, `<X radius>`, `<Y radius>`: fixed-point numeric expressions.
- `<colour>`: a fixed-point numeric expression. The valid range depends on the number of colours available on the bitmap screen drawn on.
- `F` switch: fills the inside of the circle drawn with the given `<colour>`.

**[Details]** `<X>` and `<Y>` give the coordinates of the centre of the circle (in dots). Initially, the coordinates are measured from (0,0) at the top-left corner of the screen.

`<radius>` gives the distance (in dots) from the centre to the points drawn. For an ellipse, it is given separately for the horizontal (X direction) and vertical (Y direction).

If `<colour>` is left out, the colour set by the COLOR command is used.

Also, if "F" is given at the end of the command, the inside of the circle drawn is filled with the given `<colour>`.

In a screen mode with several bitmap screens, drawing is done on the bitmap screen set as the default with the ACTIVE command.

*[p. 121]*

### CLS

*Direct-mode command, program-mode command*

**Function:** Clears the screen.

**Syntax:**
```
(1) CLS [<logical BG>][,<logical BG>...]
(2) CLS -1
(3) CLS ACTIVE
```

**Example:**
```
CLS
CLS 0,4,5
```

In form (1), the screens given by `<logical BG>` are cleared. If everything is left out, the screen given as the text screen is cleared.

In form (2), all screens except textures are cleared.

In form (3), the logical BG set with the ACTIVE command is cleared.

**[Parameters]**
- `<logical BG>`: a fixed-point numeric expression. The valid range depends on the screen mode set by the SCREEN command (any fraction is cut off).

**[Details]** The behaviour differs with the kind of screen given by `<logical BG>`, as follows.

**When `<logical BG>` is 0 to 2 (bitmap screen):** fills the area clipped by the WINDOW command with the background colour set by the COLOR command.

**When `<logical BG>` is 4 to 8 (character screen):** fills the whole screen with the code word 0 (&H0000). The text screen (the screen among the character screens assigned to text display) is filled with the space character (&H20) inside the area given by the WIDTH command.

**When `<logical BG>` is 10 or more:** fills the whole texture area with the background colour set by the COLOR command. If `<logical BG>` is 10 or more, a texture registered with the SETTEX command is what is operated on. The correspondence between `<logical BG>` and texture ID is

```
<texture ID>+10=<logical BG>
```

If ACTIVE is given, the screen given by the ACTIVE command run last is used.

*[p. 122]*

### COLOR

*Direct-mode command, program-mode command*

**Function:** Sets the display colours, the colour around the screen and so on.

**Syntax:** `COLOR [<text colour>][,[<drawing colour>][,[<background colour>][,<border colour>]]]`

**Example:**
```
COLOR 5
COLOR A,,15-A
```

**[Parameters]**
- `<text colour>`: a fixed-point numeric expression. The valid range is 0 to 15.
- `<drawing colour>`, `<background colour>`: fixed-point numeric expressions. The valid range depends on the number of colours available on the given bitmap screen.
- `<border colour>`: a fixed-point numeric expression. The valid range is 0 to 32767. To give the border colour as line colours, give a string expression.

**[Details]** `<text colour>` gives the colour of characters shown on the text screen. The correspondence between the value given and the actual colour depends on the text palette settings.

`<drawing colour>` and `<background colour>` give the colour used when drawing on a bitmap screen and the background colour. The valid range of values depends on the bitmap screen mode, as follows.

**In 32768-colour mode:** values derived from the following formula are valid. -1 is treated as transparent.

```
colour value = <red>+<green>×32+<blue>×1024
     (or) RGB(<red>,<green>,<blue>)
```

The correspondence between the value given and the actual colour is fixed.

**In 256-colour palette mode:** give a palette number from 0 to 255. The correspondence between the value given and the actual colour depends on the palette settings. `<border colour>` gives the colour around the screen. If a value is given for the border colour, a single colour is shown; if a string expression is given, 224 line colours (a colour for each horizontal line from the top of the screen) can be given. The format of this string is a word string of 224 entries, the same format as used by the PALETTE command. If it has fewer than 224 colours, it is written up to the given length; if it has more than 224, up to 224 colours are written. If the length is odd, the last byte is ignored.

In both 32768-colour mode and 256-colour palette mode, any setting left out keeps its previous value, so at least one parameter must be given.

*[p. 123]*

### COLOROFS

*Direct-mode command, program-mode command*

**Function:** Applies a colour tint to BG screens and the sprite screen.

**Syntax:**
```
(1) COLOROFS {ON[,]<logical BG>[,<logical BG>...]}|{OFF[,]<logical BG>[,<logical BG>...]}
(2) COLOROFS (<R>, <G>, <B>)
```

**Example:** see **[Example]**.

**[Parameters]**
- `<logical BG>`: the logical BG to tint.
- `<R>`, `<G>`, `<B>`: fixed-point numeric expressions. The range is integers from -255 to +255; outside it, an "Illegal function call" error occurs.
- `ON`: enables tinting of the logical BG.
- `OFF`: disables tinting of the logical BG.

**[Details]** Here `<logical BG>` also includes the sprites (10).

Form (1) enables/disables tinting of the target `<logical BG>`. Several numbers can be given together, and ON and OFF can be mixed. If the same number is given more than once, the last one given takes priority. If the parameters end with ON or OFF, tinting is set for all `<logical BG>`s of the current screen mode.

Form (2) applies the tint to the screens given in form (1).

**[Caution]** Tinting the sprites also affects the virtual keyboard, which in some cases can no longer be seen.

**[Example]** Fades out the whole screen.

```
COLOROFS (0,0,0)      → sets the offset to its initial value, to be safe
COLOROFS ON           → allows tinting of all screens
FOR OFS =0 TO 255
 COLOROFS (-OFS,-OFS,-OFS)
VSYNC
NEXT OFS
```

The SCREEN command disables tinting of all `<logical BG>`s, and the colour offset becomes (0,0,0).

*[p. 124]*

### DISPLAY

*Direct-mode command, program-mode command*

**Function:** Turns display of BG screens on and off.

**Syntax:** `DISPLAY {ON[,]<logical BG>[,<logical BG>...]}|{OFF[,]<logical BG>[,<logical BG>...]}`

**Example:**
```
DISPLAY OFF 4
```

Normally this makes the text screen disappear. To show it again, press [F12].

**[Parameters]**
- `<logical BG>`: the BG whose display is turned on or off.
- `ON`: enables tinting of the logical BG (sic).
- `OFF`: disables tinting of the logical BG (sic).

(The ON and OFF descriptions are printed as for COLOROFS; here they turn display of the logical BG on and off.)

**[Details]** Turns display of the target `<logical BG>` on/off. Several numbers can be given together, and ON and OFF can be mixed. If the same number is given more than once, the last one given takes priority. If ACTIVE is given in place of `<logical BG>`, display of the `<logical BG>` given with ACTIVE is turned on/off (for compatibility with CLS). If the parameters end with ON or OFF, all `<logical BG>`s of the current screen mode are turned on or off.

**[Supplement]** Temporarily using DISPLAY OFF on rotation screens in particular makes drawing faster.

**[Example]**
```
DISPLAY OFF     → disables display of all BGs
```

The SCREEN command turns display on for all `<logical BG>`s (the same as DISPLAY ON).

**[Caution]** The following cannot be written. Split it into separate commands.

```
DISPLAY OFF,ON 3
```

**[See also]** ACTIVE

*[p. 125]*

### GCOPY

*Direct-mode command, program-mode command*

**Function:** Transfers image data of a rectangular area of a bitmap screen.

**Syntax:**
```
(1) GCOPY 《source area》 TO 《destination coordinates》
(2) GCOPY <string expression> TO 《destination coordinates》
(3) GCOPY 《source area》 TO <string variable>
```

Format of 《source area》:
```
[<logical BG>,](<start X>,<start Y>)-(<end X>,<end Y>)
```

Format of 《destination coordinates》:
```
[<logical BG>,](<destination X>,<destination Y>)
```

**Example:**
```
GCOPY 0,(0,0)-(99,99) TO 1,(100,0)
GCOPY A$ TO 1,(0,100)
GCOPY (0,0)-(20,7) TO V$
```

**[Parameters]**
- `<logical BG>`: a fixed-point numeric expression. The valid range depends on the screen mode set by the SCREEN command.
- `<start X>`, `<start Y>`, `<end X>`, `<end Y>`: the coordinates of two opposite corners of the source rectangle. Fixed-point numeric expressions.
- `<destination X>`, `<destination Y>`: the coordinates of one point of the destination rectangle (corresponding to the start point of the source). Fixed-point numeric expressions.
- `<string expression>`: the shape of the string is described below.
- `<string variable>`: the name of a string variable. Names follow the variable naming rules.

**[Details]** Form (1) copies image data of the given bitmap screen to another area.

Form (2) transfers image data in string form to a bitmap screen.

Form (3) turns image data of the given rectangle into a string and takes it into a variable.

If `<logical BG>` is left out, the bitmap logical BG number given last with the ACTIVE command is used.

**When `<logical BG>` is 0 to 2:** form (1) works as follows. The image of the rectangle given by 《source area》 is copied/transferred to the area given by 《destination coordinates》. The coordinates

*[p. 126]*

of the two are related so that the start point of the source rectangle corresponds in position to the coordinates given for the destination. However, whatever the positions of the given start coordinates, the image data is always transferred one horizontal line at a time from the top-left point of the source area.

In form (2), the source is string data (binary data holding an image), and the coordinates given for the destination are always the top-left position of the area. Transfer direction and so on follow form (1).

In form (3), the destination is a string variable, and the source image data is stored in the variable as binary string data. Transfer direction and so on follow form (1).

- **Coordinate limits:** the given coordinates are adjusted to the range 0 to 511 for X and 0 to 255 for Y (the unit is dots). The adjustment is done by taking the remainder by 512 and 256 respectively (this is to cope with scrolling of the bitmap screen).

**When `<logical BG>` is 10 or more:** if `<logical BG>` is 10 or more, a texture registered with the SETTEX command is what is operated on. The correspondence between `<logical BG>` and texture ID is

```
<texture ID> + 10 = <logical BG>
```

Form (1) cannot be used with textures, so copying must go through a string. Forms (2) and (3) are as for `<logical BG>` 0 to 2.

- **Coordinate limits:** when transferring from a string to a texture, there is no limit on the range of coordinates, including negative values. If the string is larger than the texture, only the part where the texture exists is copied. For example, if the rectangle of string A$ is 100×100 dots and the texture is 64×64 dots,

  ```
  GCOPY A$ TO 10,(-10,-20)
  ```

  copies the data to the texture from the 10th dot from the left and the 20th dot from the top of the string's rectangle. When transferring from a texture to a string, the given coordinates are limited to within the texture size given with the SETTEX command. For example, if the texture is 64×64 dots, coordinates can be given from (0,0) to (63,63).

**[Structure of the binary string holding an image]**

**When the target `<logical BG>` is 256 colours (palette colour):** the `<string expression>` given as the source and the `<string variable>` given as the destination hold data in the following format:

| Bytes (characters) | Contents |
|---|---|
| 1st–2nd | Their character codes are the width of the image data in dots (1–512) |
| 3rd–4th | Their character codes are the height of the image data in dots (1–256) |

*[p. 127]*

| Bytes (characters) | Contents |
|---|---|
| 5th on | Colour data (palette number data). One character per dot. The shortest length is 5 bytes (characters) |

**When the target `<logical BG>` is 32768 colours (RGB colour):** the `<string expression>` given as the source and the `<string variable>` given as the destination hold data in the following format:

| Bytes (characters) | Contents |
|---|---|
| 1st–2nd | Their character codes are the width of the image data in dots (1–512). High byte (1st character), then low byte (2nd character) |
| 3rd–4th | Their character codes are the height of the image data in dots (1–256). High byte (1st character), then low byte (2nd character) |
| 5th on | Colour data (RGB data). 2 bytes (characters) are needed per dot, arranged high byte (1st character) then low byte (2nd character). The shortest length is 6 bytes (characters) |

The structure of the RGB data is the same as the format handled by the RGB function:

```
&B0000000000011111   red component
&B0000001111100000   green component
&B1111110000000000   blue component
```

However, the top bit of the display colour (bit 15) must be 1. So a black dot is given as

```
RGB(0,0,0)+&H8000    (=&h8000)
```

To show a dot as transparent, give the whole RGB data as 0.

### KLOAD

*Direct-mode command, program-mode command*

**Function:** Makes it possible to show kanji.

**Syntax:**
```
KLOAD [ON[,{1|2}]]
KLOAD OFF
```

**Example:**
```
KLOAD          → makes level 1 and level 2 kanji available for display
KLOAD ON       → 〃
KLOAD ON,2     → 〃
KLOAD ON,1     → makes level 1 available for display
KLOAD OFF      → makes kanji unusable and increases the free area
```

**[Parameters]**
- `ON`: makes kanji usable.
- `OFF`: stops kanji being used. If the parameter is left out, it works the same as ON.

*[p. 128]*

- `1`: makes level 1 kanji available for display.
- `2`: makes level 1 and level 2 kanji available for display.

**[Details]** If the parameter is left out or ON is given, the kanji font is read from the CD and kanji can be shown. If a kanji font of the same size has already been read, it is not read again. The kanji font uses the following memory from the BASIC program area (1 block is 256 bytes):

| Reading | Memory |
|---|---|
| Level 1 only | 722 blocks |
| Level 1 and level 2 | 991 blocks |

If the kanji font cannot be read, for example because the program code is very large, an "Out of memory" error occurs.

If OFF is given as the parameter, the memory used by the kanji font is released and can be used as user area or program area.

Running the KLOAD command, with either ON or OFF, does the same as

```
CLEAR 0,256,256
```

For the following reasons, it is normally recommended to run it before the CLEAR command, for example at the start of the program:

- The contents of all variables are initialised.
- String variables are initialised to the empty string of length 0, and numeric variables to 0.
- All declared array variables return to the undeclared state.
- Any open files are all closed.
- Stacks such as those of FOR–NEXT and GOSUB are all initialised.
- The user area becomes 0 blocks.
- `<file area 1>` and `<file area 2>` both become 256 blocks.

### KPRINT

*Direct-mode command, program-mode command*

**Function:** Shows kanji on a bitmap screen.

**Syntax:**
```
(1) KPRINT [<position>,][FIX][<string expression>][;][,<text colour>][,<SCALE>][,<background colour>]
(2) KPRINT [<position>]
(3) KPRINT PALETTE [<logical BG>],<start PALETTE number>,<base colour>
```

The `<position>` part has the following form:

```
(<start X>,<start Y>[,<X spacing>,<Y spacing>,<half-width position>])
```

*[p. 129]*

**Example:**
```
KPRINT (10,10)                         → sets the next kanji display position to (10,10) from the
                                          top left of the screen (if the screen is not rotated or flipped)
SCREEN 0:KLOAD ON                      → sets 32768-colour mode
KPRINT "全角ﾊﾝｶｸ";,RGB(31,0,0)         → shows kanji in red characters without a new line
SCREEN 1:KLOAD ON                      → sets 256-colour palette mode
KPRINT PALETTE 0,100,RGB(31,0,0)       → makes a red palette for kanji display at palette number 100
KPRINT "全角ﾊﾝｶｸ",100,12               → shows 12×12-dot characters using this palette
```

**[Parameters]**
- `<start X>`, `<start Y>`: fixed-point numeric expressions.
- `<X spacing>`, `<Y spacing>`: fixed-point numeric expressions. Integers from -128 to +127.
- `<half-width position>`: a fixed-point numeric expression. An integer from -128 to +127.
- `<text colour>`, `<background colour>`: fixed-point numeric expressions. The valid range depends on the number of colours available on the bitmap screen drawn on.
- `<SCALE>`: a fixed-point numeric expression. An integer from 8 to 16.
- `<logical BG>`: a fixed-point numeric expression. A bitmap screen (0, 1, 2) or the sprites (10).
- `<start PALETTE number>`: a fixed-point numeric expression. The valid range is 0 to 253.
- `<base colour>`: a fixed-point numeric expression. The valid range is 0 to 32767.
- `FIX`: shows characters using the 8×8 font used on the text screen.
- `;`: if the start coordinates are left out in the next KPRINT command, characters are shown without a new line.
- `<string expression>`: SHIFT JIS character codes, or 1-byte character codes, shown on the bitmap screen given with ACTIVE.

**[Details]** In the description below:

| Term | Meaning |
|---|---|
| 8×8 font | The font used for text display |
| 8×16 font | The half-width characters included in the kanji font |
| 16×16 font | Full-width kanji, digits and other characters |

*[p. 130]*

To show kanji with KPRINT, the font data must first be read from the CD with the KLOAD command. While the kanji data has not been read, only the 8×8 font with the "FIX" option described below can be shown. Trying to show any other full-width or half-width characters while the kanji font data has not been read causes an "Illegal function call" error.

Form (1) shows the SHIFT JIS character codes or 1-byte character codes of `<string expression>`, going right from the coordinates given by `<start X>` and `<start Y>`, on the bitmap screen given with ACTIVE.

If `<text colour>` is given, drawing is based on that colour.

If `<text colour>` is left out, the bitmap drawing colour set by the second parameter of the COLOR command is used.

`<background colour>` can give the background colour of the characters. If it is left out, the bitmap background colour set by the third parameter of the COLOR command is used. Transparent (-1) can be used as the background colour. However, transparent (-1) cannot be used as `<text colour>`; trying to do so causes an "Illegal function call" error.

If "FIX" is given, 1-byte characters (half-width characters) are shown with the 8×8 font used on the text screen (the shadow pattern is not shown).

If "FIX" is left out, characters are shown with the 8×16 font. `<SCALE>` gives the size of the characters shown. Half-width characters are affected only in their vertical size, and the 8×8 font is not affected. If it is left out, the size given last is used.

`<X spacing>` gives the horizontal spacing between characters. If it is left out, the value given last is used. `<Y spacing>` gives the spacing between characters above and below after a new line. If it is left out, the value given last is used.

`<half-width position>` gives the display position of 1-byte characters relative to 2-byte characters. If it is left out, the value given last is used.

- **About KPRINT's half-width position:** this is used to align half-width characters when the FIX option (8×8 dot font) is used. A concrete example follows.

*[Figure: (1) "Default value": a full-width character with a half-width character beside it, aligned at the bottom. (2) "When `<half-width position>` = -8": the half-width character is aligned at the top.]*

*[p. 131]*

If ";" is given at the end of the string expression, characters are shown without a new line when the start coordinates are left out in the next KPRINT command. If the string expression is left out, it is treated as the empty string. If ";" is left out, the start position used when the start coordinates are left out in the next KPRINT command is:

| | |
|---|---|
| `<X when left out>` | The `<start X>` given in the last KPRINT command |
| `<Y when left out>` | The `<start Y>` given in the last KPRINT command + `<SCALE>` + `<Y spacing>` |

If the string contains `CHR$(13)`, the X start position of the next character becomes the `<start X>` given in the last KPRINT command. If the string contains `CHR$(10)`, the Y start position of the next character becomes the `<start Y>` given in the last KPRINT command + `<SCALE>` + `<Y spacing>`.

Form (2) sets the `<start X>` and `<start Y>` used when the display position is left out in the next KPRINT command. If `<position>` is left out, it moves to a new line like the PRINT statement (the same as form (1)).

Form (3) makes colours in the palette for showing kanji on a bitmap screen or texture in 256-colour mode. If `<logical BG>` is left out, the palette of the bitmap screen given by ACTIVE is used. If `<logical BG>` is 10, or a texture is selected with ACTIVE, the palette for sprites is used. Intermediate colours made from `<base colour>` are written into 3 palette entries from `<start PALETTE number>`. By giving `<start PALETTE number>` as the second parameter of the COLOR command or as `<text colour>` in form (1), the kanji colour can be set in 256-colour mode. The intermediate colours are used when the kanji `<SCALE>` is less than 16.

**[Example]**
```
KLOAD                              → makes kanji usable
SCREEN 0                           → makes logical BG 0 a 32768-colour bitmap screen
COLOR ,RGB(0,31,0)                 → sets the bitmap screen's drawing colour (= the text colour) to green
KPRINT (10,20)                     → sets the display position to (10,20)
KPRINT "1行目"                     → shows green kanji at 12×12
KPRINT "2行目",RGB(31,31,31)       → shows white kanji at 12×12 on the next line

KLOAD                              → makes kanji usable
SCREEN 1                           → makes logical BG 0 a 256-colour bitmap screen
KPRINT PALETTE  0,100,RGB(0,31,31) → makes intermediate colours based on light blue at palette
                                      numbers 100–102 of logical BG 0
KPRINT (10,30)                     → sets the display position to (10,30)
KPRINT "テステス",100,12           → shows kanji at 12×12 using palette numbers 100–102
```

("1行目" and "2行目" mean "line 1" and "line 2".)

*[p. 132]*

The SCREEN command initialises:

```
<start X>=0
<start Y>=0
<X spacing>=0
<Y spacing>=1
<half-width position>=0
<SCALE>=16
```

**[See also]** KLOAD

### LINE

*Direct-mode command, program-mode command*

**Function:** Draws a straight line or a rectangle on a bitmap screen.

**Syntax:**
```
(1) LINE[(<start X>,<start Y>)]-(<end X>,<end Y>)[,<colour>]
(2) LINE[(<start X>,<start Y>)]-(<end X>,<end Y>)[,[<colour>][,B|BF]]
```

**Example:**
```
LINE(0,0)-(100,100)
LINE-(200,0),,B
LINE(X,Y)-(XX,YY),C,BF
```

Draws a straight line inside the area of the bitmap screen clipped by the WINDOW command.

**[Parameters]**
- `<start X>`, `<start Y>`, `<end X>`, `<end Y>`: fixed-point numeric expressions (any fraction is cut off).
- `<colour>`: a fixed-point numeric expression. The valid range depends on the number of colours available on the bitmap screen drawn on (any fraction is cut off).
- `B`, `BF`: draw a rectangle, fill a rectangle.

**[Details]** Form (1) draws a straight line joining the two given points.

Form (2) draws a rectangle with the two given points as opposite corners.

Form (1) draws a straight line from the coordinates given by `<start X>` and `<start Y>` to the coordinates given by `<end X>` and `<end Y>`. If the start coordinates are left out, the line is drawn from the coordinates last drawn by a LINE or PSET command run before.

*[p. 133]*

Form (2) draws a rectangle with the start and end coordinates as opposite corners. If the start coordinates are left out, the coordinates given as the end point in the LINE command run before are used as one corner. If "B" is given at the end, only the outline of the rectangle is drawn; if "BF" is given, the inside of the rectangle is filled with the same colour.

Initially, the coordinates are measured from (0,0) at the top-left corner of the screen. In either form, if `<colour>` is given, drawing is done in that colour. If it is left out, the colour set by the COLOR command is used. In a screen mode with several bitmap screens, drawing is done on the bitmap screen set as the default with the ACTIVE command.

**[See also]** PSET, COLOR, ACTIVE

### MOSAIC

*Direct-mode command, program-mode command*

**Function:** Applies a mosaic to BG screens.

**Syntax:**
```
(1) MOSAIC {ON[,]<logical BG>[,<logical BG>...]}|{OFF[,]<logical BG>[,<logical BG>...]}
(2) MOSAIC (<horizontal dots>,<vertical dots>)
```

**Example:**
```
MOSAIC ON 4
MOSAIC (4,4)
```

Normally this applies the mosaic to the text screen. To show it normally again, press [F12].

**[Parameters]**
- `<horizontal dots>`, `<vertical dots>`: fixed-point numeric expressions. The range is integers from 1 to 16.
- `<logical BG>`: the logical BG to apply the mosaic to.
- `ON`: applies the mosaic.
- `OFF`: removes the mosaic.

**[Details]** Form (1) enables/disables the mosaic effect on the target `<logical BG>`. Several numbers can be given together, and ON and OFF can be mixed. If the same number is given more than once, the last one given takes priority. If the parameters end with ON or OFF, the mosaic effect is set for all `<logical BG>`s of the current screen mode.

Form (2) applies the mosaic effect to the screens given in form (1). The vertical mosaic is not applied to rotation screens.

The `<logical BG>`s that the mosaic effect can be applied to are as follows. For rotation screens, the horizontal

*[p. 134]*

mosaic only is applied, and the vertical one is ignored. A mosaic cannot be applied to polygons or sprites.

| `<logical BG>` number | Kind of screen | Mosaic direction |
|---|---|---|
| 0 | Bitmap screen 0 | Horizontal, vertical |
| 1 | Bitmap screen 1 | Horizontal, vertical |
| 2 | Bitmap rotation screen 0 | Horizontal |
| 4 | Character screen 0 | Horizontal, vertical |
| 5 | Character screen 1 | Horizontal, vertical |
| 6 | Character screen 2 | Horizontal, vertical |
| 7 | Character screen 3 | Horizontal, vertical |
| 8 | Character rotation screen 0 | Horizontal |
| 9 | Character rotation screen 1 | Horizontal |
| 10 and above | Sprite/polygon plane | No mosaic. An "Illegal function call" error occurs |

**[Example]** Applies a mosaic to all BG screens and makes it gradually finer.

```
NEW
100 MOSAIC ON                  → applies the mosaic effect to all BG screens
110 FOR DOT=16 TO 1 STEP -1
120   MOSAIC (DOT,DOT)
130   VSYNC 3
140 NEXT DOT
RUN
```

The SCREEN command disables the mosaic for all `<logical BG>`s, and the horizontal and vertical dots become (1,1).

**[See also]** SCREEN

### PAINT

*Direct-mode command, program-mode command*

**Function:** Fills an area of a bitmap screen with the given colour.

**Syntax:**
```
(1) PAINT(<X>,<Y>)[,<fill colour>[,<border colour>[,<border colour>...]]]
(2) PAINT(<X>,<Y>) ON [<fill colour>]
```

**Example:**
```
PAINT(100,100),C
PAINT(PX,PY),PC,BC
PAINT(X,Y) ON,-1
```

*[p. 135]*

**[Parameters]**
- `<X>`, `<Y>`: fixed-point numeric expressions (any fraction is cut off).
- `<fill colour>`, `<border colour>`: fixed-point numeric expressions (any fraction is cut off). The valid range depends on the number of colours available on the bitmap screen drawn on.
- `ON`: fills the part of the same colour connected to the given coordinates with `<fill colour>`.

**[Details]** Form (1) fills, from the given coordinates, the part with colours other than the given ones with `<fill colour>`.

Form (2) fills, from the given coordinates, the part of the same colour connected to those coordinates with `<fill colour>`.

`<X>` and `<Y>` give the coordinates where filling starts (in dots). Initially, the coordinates are measured from (0,0) at the top-left corner of the screen.

In form (1), the area is filled with the colour given by `<fill colour>` from the given coordinates up to the border of the colour given by `<border colour>`.

If all `<border colour>`s are left out, `<fill colour>` and `<border colour>` are treated as the same.

In form (2), the part of the same colour connected to the colour at the given coordinates is filled with `<fill colour>` from the given coordinates.

In both forms, if `<fill colour>` is left out, the colour set as the drawing colour by the COLOR command is used as `<fill colour>`. If the colour at the starting coordinates is the same as `<fill colour>`, the command ends without doing anything. In a screen mode with several bitmap screens, filling is done on the bitmap screen set as the default with the ACTIVE command.

**[Caution]** The drawing range is inside the area clipped by the WINDOW command on the bitmap screen selected with ACTIVE.

If `<fill colour>` is -1, the area is filled with the transparent colour. If the target `<logical BG>` is 256 colours (palette), -1 is in fact treated as colour number 0.

**[See also]** ACTIVE, WINDOW

*[p. 136]*

### PALETTE

*Direct-mode command, program-mode command*

**Function:** Changes palette values.

**Syntax:**
```
(1) PALETTE [<logical BG>],<palette number>[,{<numeric expression>|<string expression>}[,{<numeric expression>|<string expression>}...]]
(2) PALETTE [<logical BG>],-1
```

**Example:**
```
PALETTE ,C,RGB(R,G,B)
PALETTE ,15,A$
PALETTE 0,-1
```

**[Parameters]**
- `<logical BG>`: a numeric expression whose result is fixed point. The valid range depends on the screen mode set by the SCREEN command.
- `<palette number>`: a numeric expression whose result is fixed point. The valid range depends on the screen mode set by the SCREEN command.
- `<numeric expression>`: a numeric expression whose result is fixed point. The valid range is 0 to 32767.
- `<string expression>`: a word string. The shape of the string is described below.

**[Details]** Form (1) sets colour data in the palette.

Form (2) returns the palette values to the standard colours of that screen (the initial state).

Sets the palette value at the palette number given by `<palette number>`. Values 1 to 255 are valid for `<palette number>` (because 0 is fixed as the transparent colour). The value given by `<numeric expression>` is a palette value derived from the following formula; one `<numeric expression>` corresponds to one palette entry.

```
colour value = <red>+<green>×32+<blue>×1024,
     (or) RGB(<red>,<green>,<blue>)
```

When giving a `<string expression>`, see the hexadecimal-form string whose values are the numbers above. Every 2 characters from the start of `<string expression>` correspond to one palette entry; if there is an odd remainder, that part is invalid (cut off). The hexadecimal-form string must be arranged high then low. In this manual's terms, this is the same as a word string. In either case, only the low 15 bits of the data are valid.

For the text screen, when the text colour is 16 colours and this command is run on the text screen, the palette number used by the COLOR command and so on, multiplied by 16, plus 15 gives the colour of the font's face, and plus 1 gives the colour of the font's outline.

*[p. 137]*

| | |
|---|---|
| Face colour | palette code × 16 + &H0F |
| Outline colour | palette code × 16 + &H01 |

For the text screen, when the text colour is 256 colours, that is, when text is set to 256 colours with the SCREEN command, the palette number is always treated as 0; palette number 15 is the colour of the font's face, and palette number 1 the colour of the font's outline.

| | |
|---|---|
| Face colour | &H0F |
| Outline colour | &H01 |

With this command, 10 can also be given as `<logical BG>` to set the palette values of polygons (sprites). In that case the valid range is 0 to 511. Also, when setting the palette values of the 3-axis rotation screen of screen mode 6, the palette is shared by the two screens logical BG 8 and 9, so setting either palette changes both. The valid range is then 0 to 511.

### PRIORITY

*Direct-mode command, program-mode command*

**Function:** Sets the priority with which screens are shown.

**Syntax:** `PRIORYTY <logical BG>,<priority>` (sic: PRIORITY)

**Example:**
```
PRIORITY 0,5
```

**[Parameters]**
- `<logical BG>`: a fixed-point numeric expression (any fraction is cut off). The valid range depends on the screen mode set by the SCREEN command.
- `<priority>`: a fixed-point numeric expression (any fraction is cut off). The valid range is 0 to 7.

**[Details]** Sets the priority of the screen given by `<logical BG>`. The larger the value given as `<priority>`, the further forward the screen is shown. If there are screens with the same `<priority>`, the one with the smaller logical BG takes priority. Also, giving 0 as `<priority>` stops that screen being shown (except sprites). If `<logical BG>` is 10 to 16, the priority of sprites relative to the BGs is set. Sprites can be divided into 7 kinds, each with its own independent priority.

Specifically, a total of 7 priorities are set with

```
PRIORITY 10+0,<priority> ～ PRIORITY 10+6,<priority>
```

The value added to `<logical BG>` 10 is the number of the sprite `<priority register>`. To apply the given priority to polygons or sprites, add `<priority register>`×&h1000 to the `<texture ID>` item of the `<parameters>` of the SETATR command.

*[p. 138]*

> **Caution.** There is in fact an 8th priority register, but it is used by the virtual keyboard. This register can be given with the SETATR command, but its priority is always 7.

**Priority settings**

| Logical BG | Priority | Default priority (screen) |
|---|---|---|
| 0 | 2 | Bitmap screen 0 |
| 1 | 2 | Bitmap screen 1 |
| 2 | 2 | Bitmap rotation screen 0 |
| 3 | 2 | Undefined |
| 4 | 6 | Character screen 0 |
| 5 | 5 | Character screen 1 |
| 6 | 4 | Character screen 2 |
| 7 | 3 | Character screen 3 |
| 8 | 1 | Character rotation screen 0 |
| 9 | 1 | Character rotation screen 1 |
| 10 | 6 | Sprite priority register 0 (normal) |
| 11 | 6 | Sprite priority register 1 |
| 12 | 6 | Sprite priority register 2 |
| 13 | 6 | Sprite priority register 3 |
| 14 | 6 | Sprite priority register 4 |
| 15 | 6 | Sprite priority register 5 |
| 16 | 6 | Sprite priority register 6 |

- The larger the priority number, the further forward.

(The third column is headed "default priority" in the original, but lists the screen for each logical BG.)

**[See also]** SETATR

*[p. 139]*

### PSET

*Direct-mode command, program-mode command*

**Function:** Shows a point at the given coordinates of a bitmap screen.

**Syntax:** `PSET (<X>,<Y>)[,<colour>]`

**Example:**
```
PSET (100,100),&H7FFF → puts a white point at (100,100)
```

**[Parameters]**
- `<X>`, `<Y>`: fixed-point numeric expressions (any fraction is cut off).
- `<colour>`: a fixed-point numeric expression. The valid range depends on the number of colours available on the bitmap screen drawn on (any fraction is cut off).

**[Details]** Draws a point inside the area of the bitmap screen selected with ACTIVE and clipped by the WINDOW command. Initially, the coordinates are measured from (0,0) at the top-left corner of the screen.

If `<colour>` is left out, the colour set by the COLOR command is used.

In a screen mode with several bitmap screens, drawing is done on the bitmap screen set as the default with the ACTIVE command. The coordinates drawn by this command are also used as the start point of the LINE command when that is left out.

**[See also]** ACTIVE, WINDOW, COLOR, LINE

### PUTCHR

*Direct-mode command, program-mode command*

**Function:** Writes pattern name data to a character screen.

**Syntax:**
```
(1) PUTCHR [<logical BG>][,] (<X character position>,<Y character position>),{<WORD string>|<value>}[,{<WORD string>|<value>}...]
(2) PUTCHR [<logical BG>],<start VRAM address>,{<WORD string>|<value>}[,{<WORD string>|<value>}...]
```

**Example:**
```
SCREEN 0,4,16                           → assigns 16-colour text to logical BG 4
PUTCHR 4,(10,10),ASC("3")+&H5000        → shows a light-blue "3" on the text screen
PUTCHR 4,(10,12),STRW$(10,&H5034)       → shows 10 light-blue "4"s two lines below it
```

*[p. 140]*

**[Parameters]**
- `<logical BG>`: a fixed-point numeric expression. The valid range depends on the screen mode set by the SCREEN command.
- `<X character position>`, `<Y character position>`: fixed-point numeric expressions. The valid range depends on the screen mode set by the SCREEN command.
- `<start VRAM address>`: a fixed-point numeric expression. The valid range is 0 to 65535.
- `<WORD string>`: a string expression, used to write consecutive data. For the shape of the string, see "Pattern name data structure" below.
- `<value>`: a word value. For its form, see "Structure of pattern name data" below.

**[Details]** If `<X character position>`, `<Y character position>` are given as the start position in form (1), the write start position can be given in character coordinates with the top left of the target screen's map as (0,0). The range of character positions is 0 to the maximum character width of the target screen − 1. The range of `<X character position>`, `<Y character position>` is 0 to the maximum character width of the target screen − 1. If a character position is negative or exceeds the maximum, it is treated as the remainder by the maximum. For example, if the character width of the target BG screen is horizontal width = &H80 characters and vertical width = &H80 characters,

```
PUTCHR 4,(&H102,&H110),
```

is the same as

```
PUTCHR 4,(&H102 AND &H7F,  &H110 AND &H7F),
```

If `<start VRAM address>` is given in form (2), data is written in address order from the start address. Data is written in units of word data (2 bytes), so an odd address is ANDed with &H1FFFF to make it even. If the data transferred exceeds the character size of the target screen, an error occurs. The range of `<start VRAM address>` is 0 to the maximum number of characters of the target screen − 1; if it exceeds this value, it is treated as the remainder by the maximum number of characters. For example, if the character size of the target BG screen is &H4000 bytes (= &H2000 characters),

```
PUTCHR 4,&H5000,
```

is treated as

```
PUTCHR 4,(&H5000 AND &H3FFE),
```

(The odd-address mask is printed as &H1FFFF; it does not by itself make the address even.)

*[p. 141]*

Writes the data given by `<numeric expression>` or `<string expression>` from the position given by `<X>` and `<Y>`. `<X>` and `<Y>` are given in character coordinates. In no case can data be written beyond the size of the screen. Also, if the values of `<X>` and `<Y>` exceed the left–right or top–bottom width of the screen, the upper bits are ignored (the coordinates are ANDed). If `<logical BG>` is left out, the logical BG of the character screen given last with the ACTIVE command is used.

**Structure of pattern name data**

Pattern name data is one word of data with the following bit layout:

| Bits | Contents |
|---|---|
| 15–12 | Palette number |
| 11 | Vertical flip flag (0 = as is, 1 = flip vertically) |
| 10 | Horizontal flip flag (0 = as is, 1 = flip horizontally) |
| 09–00 | Character number |

For a character screen, the palette number is as follows:

- If the character screen has 256 colours, 0.
- If the character screen has 512 colours, 0 or 1.

If any other value is set, the palette of another screen is referenced. For the text screen (16-colour mode), give the same value as given to the COLOR command. The character number holds the character code for the text screen, and the pattern number × 2 for a character screen.

**[Example]**
```
SCREEN 0,4,256
```
Sets text to 256 colours in SCREEN MODE 0 and assigns it to logical BG 4.

```
PUTCHR 4,(10,10),ASC("X")*2+&H1000
```
Shows "X" with palette 1 at position (10,10) of the character screen (text screen) of logical BG 4.

```
PALETTE 4,256*1+15,RGB(31,0,0)
```
Makes the 15th colour of palette 1 of logical BG 4 red. In 256-colour mode, palette 0 uses colours 0 to 255 and palette 1 uses colours 255 (sic) to 511 (the text font colour uses the 15th colour code in the palette).

**[See also]** GCOPY, ACTIVE

*[p. 142]*

### ROTATE

*Direct-mode command, program-mode command*

**Function:** Sets the display angle of a rotation screen.

**Syntax:** `ROTATE [<X rotation angle>][,[<Y rotation angle>][,<Z rotation angle>]]`

**Example:**
```
ROTATE X,Y,Z
ROTATE ,,0.5
```

**[Parameters]**
- `<X rotation angle>`, `<Y rotation angle>`, `<Z rotation angle>`: fixed-point numeric expressions (the integer part is ignored).

**[Details]** A command only for screen modes in which rotation screens can be used. In screen mode 6, it applies to the rotation screen set last with the ACTIVE command.

`<X rotation angle>` and `<Y rotation angle>` are valid only when the screen mode is 5 or 6 (3-axis rotation screen), and are ignored in screen modes 2 and 3. The value given for each parameter is an angle as a fraction from 0 to 1, in units of "radians" (1.000 = 360°). An angle of 0 is upright, the same as the initial state, and 0.5 is upside down. For example, for the Z rotation angle, 0 shows normally, and 0.25 rotates 90° clockwise, 0.5 rotates 180° and 0.75 rotates 270°.

**[Caution]** `<X rotation angle>`, `<Y rotation angle>`, `<Z rotation angle>` are initialised to 0,0,0 by the SCREEN command.

**[See also]** ACTIVE, SCREEN

### ROTCENTER

*Direct-mode command, program-mode command*

**Function:** Sets the centre position of a rotation screen.

**Syntax:** `ROTCENTER <X>,<Y>,<Z>`

**Example:**
```
ROTCENTER 160,112,0
ROTCENTER XX,YY,ZZ
```

**[Parameters]**
- `<X>`, `<Y>`, `<Z>`: fixed-point numeric expressions (any fraction is cut off).

**[Details]** Sets the coordinates of the centre of rotation when the screen is rotated. For the Z-axis rotation screen of screen mode 2 or 3, `<Z>` has no effect. A command only for screen modes in which rotation screens

*[p. 143]*

can be used.

In screen mode 6, it applies to the rotation screen set with the ACTIVE command.

For a 1-axis rotation screen, `<X>`, `<Y>`, `<Z>` are initialised by the SCREEN command to 320/2, 224/2, 0 (top left of the screen).

For a 3-axis rotation screen, `<X>`, `<Y>`, `<Z>` are initialised by the SCREEN command to 0, 0, 0 (centre of the screen).

(For the 1-axis case, 320/2, 224/2 is described as "top left of the screen" as printed.)

**[Explanation]**

**How the 3-axis rotation screen is calculated:** in the screen mode with two parameter sets (SCREEN 6), the A and B parameters are calculated independently.

1. Make a unit vector in the line-of-sight direction.
2. Translate by the value of ROTPOS.
3. Scale by the reciprocal of the value of ROTZOOM.
4. Rotate about the axes in the order Z, Y, X by the values of ROTATE.
5. Translate by the value of ROTCENTER.

This works almost the same as the 1-axis rotation screen, but ROTCENTER behaves differently on 1-axis and 3-axis rotation screens. On a 1-axis rotation screen, ROTCENTER is used to set the centre of rotation within the screen, with the top left of the screen as (0,0); on a 3-axis rotation screen, it translates relative to the centre of the screen, so the direction is the reverse of the 1-axis case and the reference position is also different.

**[See also]** ACTIVE

### ROTOVER

*Direct-mode command, program-mode command*

**Function:** Sets how the part outside the area of a rotation screen is shown.

**Syntax:** `ROTOVER <outside mode>[,<repeat character>]`

**Example:**
```
ROTOVER 1,2
```

**[Parameters]**
- `<outside mode>`: a fixed-point numeric expression. The valid range is 0 to 2 (any fraction is cut off).
- `<repeat character>`: a fixed-point numeric expression. The valid range is 0 to 65535.

**[Details]** A command only for screen modes in which rotation screens can be used. In screen mode 6, it applies to the rotation screen set with the ACTIVE command. When, because the screen is rotated or similar, the part outside the area of the rotation screen

*[p. 144]*

is shown, `<outside mode>` sets how that part is shown. The value given for `<outside mode>` is one of the following:

| Value | Meaning |
|---|---|
| 0 | Outside the area, the image inside the rotation screen is shown repeated |
| 1 | Outside the area is filled with `<repeat character>` |
| 2 | Outside the area is transparent (initial state) |

`<repeat character>` is valid when `<outside mode>` is 1. The data given as `<repeat character>` is treated as being in the same format as pattern name data. The SCREEN command sets `<display mode>` (sic: `<outside mode>`) to 2 and `<repeat character>` to 0.

In screen mode 6, when `<outside mode>` = 2 is used, the system reserves the last character code as a transparent character:

| Mode | Character code |
|---|---|
| 16-colour mode | &H3FF |
| 256-colour mode | &H1FF |

**[Example]** When the text screen is assigned to a rotation screen in 16-colour mode, to fill the part outside the display with white "X" characters:

```
ROTOVER 1,ASC("X")+&H7000
```

(&H7000 is the palette code.)

**[Supplement]** `<repeat character>` has the same format as used by CCOPY, PUTCHR and so on.

**[See also]** COPY (sic: CCOPY), PUTCHR, SCREEN

### ROTPOS

*Direct-mode command, program-mode command*

**Function:** Sets the distance from the viewpoint to the centre of a rotation screen.

**Syntax:** `ROTPOS [<X distance>][,[<Y distance>][,<Z distance>]]`

**Example:**
```
ROTPOS 100
ROTPOS ,,ZP
```

**[Parameters]**
- `<X distance>`, `<Y distance>`, `<Z distance>`: the distance from the viewpoint to the centre of the rotation screen. Fixed-point numeric expressions (any fraction is cut off).

*[p. 145]*

**[Details]** A command only for screen modes in which rotation screens can be used. In screen mode 6, it applies to the rotation screen set with the ACTIVE command. Sets the distance in each direction from the viewpoint to the centre of the rotation screen. However, a negative value cannot be given for `<Z distance>`. For the Z-axis rotation screen of screen mode 2 or 3, `<Z distance>` has no effect.

**[Supplement]** `<XP>`, `<YP>`, `<ZP>` are initialised to 0,0,100 by the SCREEN command.

**[See also]** SCREEN

### ROTZOOM

*Direct-mode command, program-mode command*

**Function:** Sets the magnification of a rotation plane in each direction. Zooms (scales) a rotating BG screen.

**Syntax:** `ROTZOOM [<X scale>][,[<Y scale>][,<Z scale>]]`

**Example:**
```
ROTZOOM 2,2
ROTZOOM ,,Z
SCREEN 2,8 → assigns text to a rotation screen
ROTZOOM -1 → flips the X axis
```

**[Parameters]**
- `<X scale>`, `<Y scale>`, `<Z scale>`: the magnification along each axis of the rotation plane from the viewpoint. Fixed-point numeric expressions.

**[Details]** A command only for screen modes in which rotation screens can be used. For normal BGs, use the ZOOM command. In screen mode 6, it applies to the rotation screen set with the ACTIVE command. Sets the scale along each axis of the rotation plane. If a negative scale is given, that axis is flipped. For the Z-axis rotation screen of screen mode 2 or 3, `<Z scale>` has no effect.

**[Supplement]** `<XS>`, `<YS>`, `<ZS>` are initialised to 1,1,1 by the SCREEN command. 3-axis rotating BG screens are also affected by SETPERS.

**[See also]** ZOOM, SCREEN, SETPERS

*[p. 146]*

### SCREEN

*Direct-mode command, program-mode command*

**Function:** Initialises the screen and sets the screen mode.

**Syntax:** `SCREEN [<screen mode>][,<text logical BG>][,<text colours>][,<drawing frame unit>]`

**Example:**
```
SCREEN 0
SCREEN ,4,256
```

**[Parameters]**
- `<screen mode>`: a fixed-point numeric expression. The valid range is 0 to 6.
- `<text logical BG>`: a fixed-point numeric expression. The valid range depends on the screen mode set by the SCREEN command.
- `<text colours>`: a fixed-point numeric expression. Valid values are 16 or 256.
- `<drawing frame unit>`: a fixed-point numeric expression. Valid values are integers from -8 to -1 and 1 to 8. Any fraction is cut off.

**[Details]** Sets the screen mode to use. At the same time, the logical BG that shows text and the number of colours used to show text can be set.

If `<screen mode>` is left out, the screen-related settings are initialised while keeping the current screen mode.

`<text logical BG>` is chosen from the character screens available in the given `<screen mode>`. If it is left out, the lowest-numbered character screen is used. A rotation screen can also be given as `<text logical BG>`. The logical BG that text is assigned to is essentially no different from a normal character screen, so commands for character screens can also be used on the text screen.

**`<text colours>`:** to handle the BG that the text font is assigned to with the same number of colours as a normal character screen, give 256 colours. If 256 colours is given, the text colour given with the COLOR command is ignored and the first palette (COLOR 0) is always selected (in 256-colour mode, COLOR 0 is set to the same colour data as COLOR 7 in 16-colour mode, so initially the text colour is white).

If `<text colours>` is left out, it is handled as 16 colours.

**`<drawing frame unit>`:** sets how sprites and polygons are drawn. On the Sega Saturn, polygons are shown using two frame buffers (VRAM areas like a bitmap screen) in turn: one is shown, and for the frame buffer not being shown the following is

*[p. 147]*

repeated:

1. Clear the buffer.
2. Draw the polygons calculated and projected onto the screen, overwriting as many times as needed.
3. Show the finished buffer, and make the buffer that was being shown the one for writing.

`<drawing frame unit>` sets in how many 1/60ths of a second the frame buffers are swapped. The larger the value, the more polygon area can be shown, but the drawing interval gets longer and input from controllers and the keyboard also gets slower, so movement becomes jerky. If a positive value is given, it waits until all polygons have been shown. If a negative value is given, polygon display is cut off at the given time. If it is left out, +1 is used.

If the SCREEN command sets the sprite drawing unit to 2 frames or more without waiting for drawing, trying to show many polygons (over 1000 or so) in a single OBJECT can make sprite display stop, after which keyboard input may become impossible even with [Ctrl]+[P], which initialises the screen, or the SCREEN command.

It may be possible to avoid this by stopping with the BASIC text kept, using a soft reset (A+B+C+Start button), and adjusting the part that sets the SCREEN command using a combination of the following:

- Use the mode that finishes drawing completely, with `SCREEN ,,,+<frames>`.
- Wait until drawing has completely finished, with `SCREEN ,,,<large number of frames>`.
- Reduce the number of polygons shown.
- Spread the registration over several OBJECTs.

**What is initialised:**

- The whole of VRAM is initialised to 0.
- Scroll positions return to the reference position (initial position).
- Zoom is cancelled.
- Screen priorities return to their initial values.
- Settings for rotation screens are initialised.
- All palettes are set to their initial values.
- The text font is registered again.
- The text colours are transferred.
- The WIDTH values are set to 1,1,38,26.
- The WINDOW values are set to 0,0,319,223.
- The ACTIVE command settings are set to the lowest logical BG for bitmap and for character screens respectively.
- The reference coordinates used when the LINE command's start coordinates are left out are initialised to (0,0).
- The object structures (OBJ) are initialised.

*[p. 148]*

- The texture management table is initialised (defined image data is not erased, so if a texture of the same size is reserved, the previous pattern can be used).
- Vertex data is initialised.
- Polygon data is initialised.
- Attribute data is initialised.
- The SPRWINDOW values return to their standard values:

```
left      0;
top       0;
right     320 - 1;
bottom    224 - 1;
zlimit    &H7FFF;
cx        320 / 2;
cy        224 / 2;
```

*[Figure: the display planes. Character planes (four), a bitmap rotation plane, bitmap planes (two) and character rotation planes (two) are drawn in a row; dotted lines show that the text plane (drawn dashed) is assigned to one of the character or character rotation planes. The sprite plane (polygon plane) is drawn separately.]*

**Screen mode 0**

| Logical BG | Kind of screen | Colour mode | Colours | Notes |
|---|---|---|---|---|
| 0 | Bitmap screen | RGB | 32768 | Scroll and zoom possible |
| 1–3 | Not available | — | — | |
| 4 | Character screen | Palette | 512 | Scroll and zoom possible |
| 5 | Character screen | Palette | 512 | Scroll possible |
| 6–9 | Not available | — | — | |

*[p. 149]*

**Screen mode 1**

| Logical BG | Kind of screen | Colour mode | Colours | Notes |
|---|---|---|---|---|
| 0 | Bitmap screen | Palette | 256 | Scroll and zoom possible |
| 1 | Bitmap screen | Palette | 256 | Scroll and zoom possible |
| 2–3 | Not available | — | — | |
| 4 | Character screen | Palette | 512 | Scroll possible |
| 5 | Character screen | Palette | 512 | Scroll possible |
| 6–9 | Not available | — | — | |

**Screen mode 2**

| Logical BG | Kind of screen | Colour mode | Colours | Notes |
|---|---|---|---|---|
| 0–3 | Not available | — | — | |
| 4 | Character screen | Palette | 512 | Scroll and zoom possible |
| 5 | Character screen | Palette | 512 | Scroll and zoom possible |
| 6–7 | Not available | — | — | |
| 8 | Character rotation screen | Palette | 512 | Rotation about the Z axis possible |
| 9 | Not available | — | — | |

The Z-axis rotation screen of logical BG 8 is 256×256 characters in size. The last 16 colours of logical BG 8 are used by the virtual keyboard.

**Screen mode 3**

| Logical BG | Kind of screen | Colour mode | Colours | Notes |
|---|---|---|---|---|
| 0–1 | Not available | — | — | |
| 2 | Bitmap rotation screen | Palette | 256 | Rotation about the Z axis possible |
| 3 | Not available | — | — | |
| 4 | Character screen | Palette | 512 | Scroll and zoom possible |
| 5 | Character screen | Palette | 512 | Scroll and zoom possible |
| 6–9 | Not available | — | — | |

*[p. 150]*

**Screen mode 4**

| Logical BG | Kind of screen | Colour mode | Colours | Notes |
|---|---|---|---|---|
| 0–3 | Not available | — | — | |
| 4 | Character screen | Palette | 256 | Scroll and zoom possible |
| 5 | Character screen | Palette | 256 | Scroll and zoom possible |
| 6 | Character screen | Palette | 256 | Scroll possible |
| 7 | Character screen | Palette | 256 | Scroll possible |
| 8–9 | Not available | — | — | |

**Screen mode 5**

| Logical BG | Kind of screen | Colour mode | Colours | Notes |
|---|---|---|---|---|
| 0–3 | Not available | — | — | |
| 4 | Character screen | Palette | 512 | Scroll and zoom possible |
| 5 | Character screen | Palette | 512 | Scroll and zoom possible |
| 6–7 | Not available | — | — | |
| 8 | Character rotation screen | Palette | 512 | 3-axis rotation possible |
| 9 | Not available | — | — | |

The 3-axis rotation screen of logical BG 8 is 256×256 characters in size.

**Screen mode 6**

| Logical BG | Kind of screen | Colour mode | Colours | Notes |
|---|---|---|---|---|
| 0–3 | Not available | — | — | |
| 4 | Character screen | Palette | 512 | Scroll and zoom possible |
| 5 | Character screen | Palette | 512 | Scroll and zoom possible |
| 6–7 | Not available | — | — | |
| 8 | Character rotation screen | Palette | 512 | 3-axis rotation possible |
| 9 | Character rotation screen | Palette | 512 | 3-axis rotation possible |

The 3-axis rotation screen of logical BG 8 is 128×128 characters in size. Also, the screens of logical BG 8 and 9 share the palette, with 512 colours, and share the pattern generator, with characters 0 to 511. The COLOR and character patterns of `<logical BG>` 8 and 9 are shared.

*[p. 151]*

### SCROLL

*Direct-mode command, program-mode command*

**Function:** Scrolls a normal screen.

**Syntax:** `SCROLL [<logical BG>],[STEP ][<X position>][,<Y position>]`

**Example:**
```
SCROLL 0,SX,SY
SCROLL 4,STEP 0,1
```

**[Parameters]**
- `<logical BG>`: a fixed-point numeric expression (any fraction is cut off). Of the `<logical BG>`s valid in the current screen mode, only the following numbers can be given. Rotating bitmap screens and rotating character screens cannot be given.

  | Number | Screen |
  |---|---|
  | 0 | Bitmap screen 0 |
  | 1 | Bitmap screen 1 |
  | 4 | Character screen 0 |
  | 5 | Character screen 1 |
  | 6 | Character screen 2 |
  | 7 | Character screen 3 |

- `<X position>`, `<Y position>`: fixed-point numeric expressions (any fraction is cut off).
- `STEP`: makes the values relative to the current position.

**[Details]** Sets the display start position of the screen.

**[Example]**
```
SCROLL ,50,50
```

Given like this, the point at coordinates (50,50) becomes the top-left position of the screen. If `<X position>` or `<Y position>` is left out, the position given last is used. If STEP is given, the values are relative to the current position; if `<X position>` or `<Y position>` is left out, the relative value is treated as 0.

For both absolute and relative positions the unit is dots, and only the low 10 bits are valid (they are ANDed). If `<logical BG>` is left out, the ACTIVE command's setting is used. The SCROLL position is initialised to `<X position>`=0, `<Y position>`=0 by the SCREEN command.

*[p. 152]*

### SETCHR

*Direct-mode command, program-mode command*

**Function:** Writes pattern data used by a character screen.

**Syntax:**
```
(1) SETCHR [<logical BG>],[<pattern number>][,<string expression>]
(2) SETCHR [<logical BG>],[<pattern number>],<number of characters>,READ
```

**Example:**
```
SCREEN 0
SETCHR 4,ASC("A"),STRING$(32,&HFF)→ makes character "A" a white square ([Ctrl]+[P] restores it)
```

**[Parameters]**
- `<logical BG>`: a fixed-point numeric expression. The valid range depends on the screen mode set by the SCREEN command.
- `<pattern number>`: a fixed-point numeric expression. The valid range is 0 to 511 (or 0 to 1023).
- `<number of characters>`: a fixed-point numeric expression. The valid range is 1 and above.
- `<string expression>`: a string.
- `READ`: reads the data from DATA statements.

**[Details]** Form (1) writes the given string to the pattern generator.

Form (2) writes the given number of characters from DATA statements to the pattern generator.

Writes pattern generator data used by character screens. Character screens include the text screen. Except in SCREEN 6, pattern generator data is independent for each `<logical BG>`.

If `<logical BG>` is left out, the logical BG of the character screen given last with the ACTIVE command is used.

If `<pattern number>` is left out, the number straight after the pattern number referenced by the READCHR$ function or SETCHR command run before is used. However, it must always be given if the logical BG is changed.

Pattern generator data is a sequence of colour data for each dot, going across from the top left of an 8×8-dot pattern, so for a character screen with 256 colours one item of pattern generator data is 64 bytes (64 characters), and for the text screen with 16 colours one item is 32 bytes (32 characters).

*[p. 153]*

**Data needed for form (2):** the DATA statement data usable with form (2) must be strings in hexadecimal form. Every 2 characters from the left of the string are used as 1 byte of data. If more data is read than the given `<number of characters>` (a long hexadecimal string), the rest of the data read is discarded. If the number of characters in the data is odd, the upper digit is treated as 0.

For example, to define the following pattern:

```
□□■■■□□□
□■■□■■□□
■■□□□■■□
■■□□□■■□
■■■■■■■□
■■□□□■■□
■■□□□■■□
□□□□□□□□
```

□ = palette code 0, ■ = palette code 15 (&H0F)

the pattern data for a character screen that can use 256 colours is

```
DATA 00000F0F0F000000
DATA 000F0F000F0F0000
DATA 0F0F0000000F0F00
DATA 0F0F0000000F0F00
DATA 0F0F0F0F0F0F0F00
DATA 0F0F0000000F0F00
DATA 0F0F0000000F0F00
DATA 0000000000000000
```

or

```
DATA 00,00,0F,0F,0F,00,00,00
DATA 00,0F,0F,00,0F,0F,00,00
DATA 0F,0F,00,00,00,0F,0F,00
DATA 0F,0F,00,00,00,0F,0F,00
DATA 0F,0F,0F,0F,0F,0F,0F,00
DATA 0F,0F,00,00,00,0F,0F,00
DATA 0F,0F,00,00,00,0F,0F,00
DATA 00,00,00,00,00,00,00,00
```

*[p. 154]*

and the pattern data for a text screen that can use 16 colours is

```
DATA 00FFF000
DATA 0FF0FF00
DATA FF000FF0
DATA FF000FF0
DATA FFFFFFF0
DATA FF000FF0
DATA FF000FF0
DATA 00000000
```

or

```
DATA 00,FF,F0,00
DATA 0F,F0,FF,00
DATA FF,00,0F,F0
DATA FF,00,0F,F0
DATA FF,FF,FF,F0
DATA FF,00,0F,F0
DATA FF,00,0F,F0
DATA 00,00,00,00
```

On the 3-axis rotation screen of screen mode 6, logical BG 8 and 9 share the pattern generator table, so take care.

### VSYNC

*Direct-mode command / Program-mode command*

**Function:** Waits until the specified time has passed.

**Syntax:** `VSYNC [<wait time>]`

**Example:**

```
VSYNC
VSYNC 2
```

**[Parameters]**

- `<wait time>`: fixed-point value of 0 or more; the fractional part is discarded.

**[Details]**

Waits for the specified time. The unit is about 1/60 second. If the wait time is omitted it is treated as 1; if 0 is given, the command ends immediately.

**[Caution]**

Interrupts such as the interval timer still occur while VSYNC is executing. Do not use VSYNC in an overlapping way, for example inside a timer interrupt routine.

*[p. 155]*

### WINDOW

*Direct-mode command / Program-mode command*

**Function:** Sets the drawing range of the bitmap drawing commands.

**Syntax:** `WINDOW [<left>],[<top>][,<right>][,<bottom>]`

**Example:** `WINDOW 0,0,200,223`

**[Parameters]**

- `<left>`, `<top>`, `<right>`, `<bottom>`: fixed-point, positive values. An error occurs unless right >= left and bottom >= top.

**[Details]**

Immediately after SCREEN, or when bitmap logical BG 0, 1 or 2 has been selected with ACTIVE, WINDOW sets the drawing area of the bitmap. The width (right − left + 1) and height (bottom − top + 1) must fit within the bitmap size set with SCREEN. At the maximum size, some parts can only be seen by scrolling. In screen modes that have several bitmap screens the WINDOW area is shared, so there is only one.

When a texture has been selected with ACTIVE, WINDOW sets the drawing area of the texture. This must lie within the size of the texture. For example, after `SETTEX 0,32,4,256` (texture ID 0, width 32, height 4, 256 colours) the range is 0–31 horizontally and 0–3 vertically.

Immediately after a texture is selected with ACTIVE, WINDOW is set to the size of the texture, so set WINDOW each time straight after ACTIVE.

The values are reset by SCREEN or by [Ctrl]+[P] during editing. After SCREEN the bitmap screen is selected and WINDOW is 0,0,319,223.

*[p. 156]*

### ZOOM

*Direct-mode command / Program-mode command*

**Function:** Zooms (scales) a normal screen.

**Syntax:** `ZOOM [<logical BG>],[<horizontal scale>][,<vertical scale>]`

**Example:** `ZOOM 0,2,2`

**[Parameters]**

- `<logical BG>`: fixed-point value; the fractional part is discarded. Only 0, 1, 4, 5, 6 and 7 can be given (bitmap 0/1, character 0–3). Rotation screens cannot be given; use ROTZOOM for those.
- `<horizontal scale>`, `<vertical scale>`: fixed-point values of 1.0 or more.

**[Details]**

Displays the screen at the specified scales. 1 is normal size, and larger values enlarge the screen. An omitted scale keeps its previous value; an omitted logical BG uses the one selected with ACTIVE. SCREEN initialises both scales to 1.0.

**[See also]** ROTZOOM

## 1.5 BG/text/video functions

*[p. 157]*

### GETCHR

*Fixed-point function*

**Function:** Reads pattern name data from a character screen.

**Syntax:**
```
(1) GETCHR([<logical BG>,](<X character position>,<Y character position>))
(2) GETCHR([<logical BG>],<start VRAM address>)
```

**Example:**
```
A = GETCHR(4,(X,Y))     → reads the data at X,Y on logical BG 4
A = GETCHR(4,&H800)     → reads the data at VRAM address &H800 on logical BG 4
```

**[Parameters]**
- `<logical BG>`: a fixed-point numeric expression (any fraction is cut off). The valid range depends on the screen mode set with the SCREEN command.
- `<X character position>`, `<Y character position>`: fixed-point numeric expressions. The valid range depends on the screen mode set with the SCREEN command.
- `<start VRAM address>`: a fixed-point numeric expression. The valid range is 0 to 65535.

**[Return value]** Reads and returns the pattern name data at the position given by `<X character position>` and `<Y character position>`, or at `<start VRAM address>`. The return value is a fixed-point value from 0 to 65535.

When `<start VRAM address>` is given, the data at the start address is read.

**[Details]** With form (1), giving `<X character position>`,`<Y character position>` as the start position specifies the read position in character coordinates, with the top left of the target screen's map as (0,0). The range of a character position is 0 to (the maximum character width of the target screen − 1). The range of `<X character position>`,`<Y character position>` is 0 to (the maximum character width of the target screen − 1). *[p. 158]* If a character position is negative or exceeds the maximum, it is treated as the remainder modulo the maximum.

With form (2), giving `<start VRAM address>` reads the data at the start address. Data is read in word (2-byte) units, so an odd address is ANDed with &h1FFFF and treated as an even address. The range of `<start VRAM address>` is 0 to (the maximum number of characters of the target screen − 1); a value beyond this is treated as the remainder modulo the maximum number of characters.

With either form, if `<logical BG>` is omitted, the character logical BG last specified with the ACTIVE command is used.

**Structure of the pattern name data**

The pattern name data is one word of data with the following bit layout:

| Bits | Meaning |
|---|---|
| 15–12 | Palette number |
| 11 | Vertical flip flag (0 = as is, 1 = flip vertically) |
| 10 | Horizontal flip flag (0 = as is, 1 = flip horizontally) |
| 09–00 | Character number |

For a character screen, the palette number is:

- 0 when the character screen has 256 colours.
- 0 or 1 when the character screen has 512 colours.

If any other value is set, the palette of another screen ends up being referenced. For the text screen (16-colour mode), give the same value as you would give to the COLOR command. The character number holds the character code for the text screen, and the pattern number × 2 for a character screen.

### PALETTE

*Fixed-point function*

**Function:** Gets a palette value.

**Syntax:** `PALETTE([<logical BG>],<palette number>)`

**Example:** `A = PALETTE(0,255)`

**[Parameters]**
- `<logical BG>`: a fixed-point numeric expression (any fraction is cut off). The valid range depends on the screen mode set with the SCREEN command.
- `<palette number>`: a fixed-point numeric expression (any fraction is cut off). The valid range depends on the screen mode set with the SCREEN command.

*[p. 159]*

**[Return value]** Reads and returns the palette value set in the palette given by `<palette number>`. The value returned is a 15-bit RGB value. The relationship between the bit positions of the returned value and the colours is:

`<red component> + <green component> × 32 + <blue component> × 1024` (each a 5-bit value)

**[Details]** The ranges of `<logical BG>` and `<palette number>` are the same as for the PALETTE command. The palette number runs from 0 to the maximum allowed for that `<logical BG>`. With this function you can also give 10 as `<logical BG>` to examine the palette values of polygons (sprites).

### POINT

*Fixed-point function*

**Function:** Detects the colour at the given coordinates of a bitmap screen.

**Syntax:** `POINT(<X coordinate>,<Y coordinate>)`

**Example:** `A = POINT(X,Y)`

**[Parameters]**
- `<X coordinate>`, `<Y coordinate>`: fixed-point numeric expressions (any fraction is cut off).

**[Return value]** Examines and returns the colour at the position given by `<X coordinate>` and `<Y coordinate>` on the bitmap screen or texture currently selected with the ACTIVE command. The return value is fixed-point and, depending on the colour mode, is as follows.

**[Details]**

*In 32768-colour mode*

A value from 0 to 32767. In addition, −1 is returned for the transparent colour and −2 for a point outside the screen. In this case colour 0 represents black, RGB(0,0,0).

*In 256-colour palette mode*

A value from 1 to 255. In addition, −1 is returned for the transparent colour and −2 for a point outside the screen. In this case colour 0 is returned as −1 (transparent). The size of the screen is determined, for a bitmap, by the size of the bitmap screen set with the SCREEN command, and for a texture, by the size of the texture defined with the SETTEX command. POINT is not affected by the area set with the WINDOW command.

*[p. 160]*

### READCHR$

*String function*

**Function:** Reads pattern generator data from a character screen.

**Syntax:** `READCHR$([<logical BG>],[<pattern number>],<number of characters>)`

**Example:** `A$ = READCHR$(,10,10)`

**[Parameters]**
- `<logical BG>`: a fixed-point numeric expression. The valid range depends on the screen mode set with the SCREEN command.
- `<pattern number>`: a fixed-point numeric expression. The valid range is 0 to 511 (or 0 to 1023).
- `<number of characters>`: a fixed-point numeric expression. The valid range is 1 or more.

**[Return value]** The pattern generator data is returned as a binary-format string.

**[Details]** Reads pattern generator data from a character screen (text screen). The pattern generator data read is laid out as the colour data of each dot, in horizontal order starting from the top left of the 8×8-dot pattern. So for a character screen that handles 256 colours, one pattern's generator data is 64 bytes (64 characters), and for a text screen that handles 16 colours it is 32 bytes (32 characters). Note also that on the 3-axis rotation screen of screen mode 6, the two screens logical BG 8 and 9 share the pattern generator table, so take care.

If `<logical BG>` is omitted, the ACTIVE command setting applies. If `<pattern number>` is omitted, the pattern number immediately after the one referenced by the previously executed READCHR$ function or SETCHR command is used. However, it must always be given when the logical BG has been changed.

*[p. 161]*

### READHEX$

*String function*

**Function:** Reads hexadecimal strings from DATA statements and converts them to a binary-format string.

**Syntax:** `READHEX$(<number of bytes to convert>)`

**Example:** `PTN$=READHEX$(16)`

**[Parameters]**
- `<number of bytes to convert>`: the number of bytes of data to read from DATA statements. A fixed-point numeric expression. The valid range is 0 or more (any fraction is cut off).

**[Return value]** Returns a binary string of the number of bytes given by `<number of bytes to convert>`.

**[Details]** Reads `<number of bytes to convert>` bytes of data from DATA statements of hexadecimal strings and returns them as a string. If one DATA statement does not have enough data, data is taken from the next DATA statement. A DATA statement is always read up to its last item, so the next READ command reads from the DATA statement after that. If there is not enough data to read, Out of DATA occurs. The DATA statement formats allowed by READHEX$ are as follows (the same as for HEXBIN$):

1. Comma-separated hexadecimal strings.
   ```
   DATA AA,BB,CC,DD,EE,...FF
   ```
2. A continuous hexadecimal string. Every 2 characters are converted to 1 byte. A leftover final digit is converted with a 0 added in front.
   ```
   DATA 12345678  -> same as DATA "12,34,56,78"
   DATA 123,45,6  -> same as DATA "01,23,45,06"
   ```

**[Example]**
```
100 A$=READHEX$(3)       → reads 3 bytes of data from the DATA statements in lines 140 and 150
110 PRINT BINHEX$(A$,",")
120 A$=READHEX$(1)       → reads 1 byte of data from the DATA statement in line 160
130 PRINT BINHEX$(A$,",")
140 DATA 1122
150 DATA 3,4,5
160 DATA 6,7,8
RUN
11,22,03                 → the 4 and 5 in line 150 are skipped
06                       → the 7 and 8 in line 160 are skipped
```

The READHEX$ function differs from the READ command in that it discards the rest of the data in the last DATA statement it read. This is the same behaviour as the SETTEX ...,READ command.

*[p. 162]*

**[Caution]** A binary string is a string used not as characters but as 1-byte data CHR$(0) to CHR$(255), for bitmap patterns, colour data, sound wave data and so on. A hexadecimal string (HEX string) is a string in which each byte is represented as character data of one or two characters, "0" to "FF".

**[See also]** BINHEX$, HEXBIN$

### RGB

*Fixed-point function*

**Function:** Calculates and returns, from its colour components, the colour data used for palette values or in 32768-colour mode.

**Syntax:** `RGB(<red component>,<green component>,<blue component>)`

**Example:** `A = RGB(R,G,B)`

**[Parameters]**
- `<red component>`, `<green component>`, `<blue component>`: fixed-point numeric expressions. The valid range is 0 or more (only the lower 5 bits of the value are used, and any fraction is cut off).

**[Return value]** The type of the return value is fixed-point.

**[Details]** Returns the value calculated by the following formula:

```
(<red component> AND 31)+(<green component> AND 31)×32+(<blue component> AND 31)×1024
```

*[p. 163]*

### RGBADD

*Fixed-point function*

**Function:** Calculates and returns colour data, used for palette values or in 32768-colour mode, with an increment or decrement added to each colour component.

**Syntax:** `RGBADD(<RGB value>,<red change>,<green change>,<blue change>)`

**Example:** `A = RGBADD(PLT,10,-4,2)`

**[Parameters]**
- `<RGB value>`: a fixed-point numeric expression (any fraction is cut off).
- `<red change>`, `<green change>`, `<blue change>`: fixed-point numeric expressions. Only the integer part of the value is used.

**[Return value]** The type of the return value is fixed-point. For each colour component of the value given by `<RGB value>`, the given change for that component is added, and an `<RGB value>` with the results as its colour components is returned.

**[Details]** In the calculation for each colour component, a result below 0 is adjusted to 0 and a result above 31 is adjusted to 31. The part of the value given by `<RGB value>` from bit 16 upward is not affected and is reflected in the return value as is. The value returned is the 15-bit `<RGB value>` with `<each change>` added. The value is calculated as follows:

```
OTHER = <RGB> AND (NOT! &H7FFF)
<RGB> = INT(<RGB>)
<R> = INT(<R>)
<G> = INT(<G> / 32)
<B> = INT(<B> / 1024)
戻り値 = ((<RGB> + <R>) AND 31) + ((<RGB> / 32 + <G>) AND 31) * 32
+ ((<RGB> / 1024) AND 31) * 1024 + OTHER
```

(戻り値 = return value.) If a colour goes outside the range 0 to 31, it is limited to 0 or 31. Bits other than the target bits (0 to 14) are not affected.

**[See also]** RGB, RGBTO

*[p. 164]*

### RGBTO

*Fixed-point function*

**Function:** Calculates and returns colour data, used for palette values or in 32768-colour mode, moved closer to a target value.

**Syntax:** `RGBTO(<RGB value>,<target RGB value>)`

**Example:** `CURRENT_COLOR = RGBTO(CURRENT_COLOR, TARGET_COLOR)`

**[Parameters]**
- `<RGB value>`, `<target RGB value>`: fixed-point numeric expressions (any fraction is cut off).

**[Return value]** The type of the return value is fixed-point. For each colour component of the value given by `<RGB value>`, a value moved closer to the colour of `<target RGB value>` is calculated and returned.

**[Details]** Moves the colour of the 15-bit `<RGB value>` towards `<target RGB value>`. Where an R, G or B element of `<RGB value>` differs from the same element of `<target RGB value>`, a value moved 1 step closer is returned. Data outside the target bits is the same as in `<target RGB value>`. The order of the colours is the same as for the RGB() function.

**[See also]** RGB(), RGBADD()

## 1.6 Sprite/3D commands

*[p. 165]*

The coordinate system of the sprite commands takes fixed-point values, but the range actually used is −&h7FFF.FFFC to +&h7FFF.FFFC; the rest of the value is cut off. In general, angles are given as fixed-point values in which one full turn is expressed as a value from 0 to 1. The integer part is cut off.

**■ Procedure for displaying a polygon**

0. Put the OBJECT into a state where it is not displayed. There are various ways, such as making it its own parent; it is not displayed unless it is connected to OBJECT 0. Setting OBJECT TYPE = 0 is another way.
1. Create the vertices with SETVERTEX.
2. Create a face with SETPOLYGON by gathering vertices created with SETVERTEX.
3. Create the surface material (texture) of the face with SETTEX (not needed for a plain face).
4. Create the attributes of the face with SETATR. If needed, specify the SETTEX texture.
5. Give the OBJECT the face and its attributes created with SETPOLYGON and SETATR.
6. Give the OBJECT the coordinates at which to display it.
7. Decide the parent of the OBJECT (normally OBJECT 0).
8. Decide the type of the OBJECT (TYPE = 4,5,6).

> **Caution:** If you skip the steps above and only give an OBJECT a type, BASIC performs step 7 for you and, as a stopgap, displays a cuboid registered inside BASIC (this object has no attribute ID, vertex ID or polygon ID; it is something like a marker to warn you).
>
> If you display the internal polygon characters with the SETPFONT command, BASIC performs steps 1–8 for you. Likewise, if you display a 16×16 sprite (a flat polygon) with the PUTSPRITE command, BASIC performs steps 1–8 for you.

**■ Procedure for displaying a sprite**

0. Put the OBJECT into a state where it is not displayed, for example by executing the SCREEN command.
1. Create the surface material (texture) of the face with SETTEX (not needed for a plain face).
2. Create the attributes of the face with SETATR. If needed, specify the SETTEX texture.
3. Give the OBJECT the attributes created with SETATR.
4. Give the OBJECT the coordinates at which to display it directly (SETVERTEX is not used).

*[p. 166]*

5. Decide the type of the OBJECT (TYPE = 1,2,3).
6. Decide the parent of the OBJECT (normally OBJECT 0).

> **Caution:** If you skip the steps above and only give an OBJECT a type, BASIC performs step 6 for you and gives the OBJECT a depth of 500. Take care, because if the Z position of the sprite is close to the viewpoint, the sprite is not displayed.

### CAMERA

*Direct-mode command / Program-mode command*

**Function:** Sets the camera angle used when displaying OBJECTs.

**Syntax:**
```
(1) CAMERA (<XO>,<YO>,<ZO>)[,<BANK>] to <OBJECT NUMBER>[,BG]
(2) CAMERA (<XO>,<YO>,<ZO>)[,<BANK>] to (<XT>,<YT>,<ZT>)[,BG]
```

**Example:**
```
CAMERA(0,-200,200) to 1,BG
CAMERA(0,HIGHT,500),0.01 to (TARGET_XP,TARGET_YP,TARGET_ZP,),BG
```

**[Parameters]**
- `<XO>`, `<YO>`, `<ZO>`: fixed-point; the coordinates of the viewpoint.
- `<XT>`, `<YT>`, `<ZT>`: fixed-point; the coordinates of the target.
- `<BANK>`: fixed-point.
- `<OBJECT NUMBER>`: the number of the target object.
- `BG`: sets the parameters of the 3-axis rotation `<logical BG>` in step with the contents of OBJECT 0.

**[Details]** The camera does not work independently; it changes the viewpoint by changing the settings of OBJECT 0. Form (1) sets values in OBJECT 0 so that the line of sight points from the position (XO,YO,ZO) towards `<OBJECT NUMBER>`. Give a value of 1 or more for `<OBJECT NUMBER>`.

Form (2) sets values in OBJECT 0 so that the line of sight points from the position (XO,YO,ZO) towards (XT,YT,ZT). `<BANK>` specifies the tilt as an angle about the Z direction, as a fraction from 0 to 1; the integer part is cut off. The items changed in OBJECT 0 are:

| Item | Setting |
|---|---|
| Matrix conversion order | If the value is less than 6 it becomes 7 (order X,Z,Y,T). If it is greater than 6, the current conversion order is used |
| (X,Y,Z) rotation angles | Set so that OBJECT 0 faces the target |
| (X,Y,Z) position | Set to (−XO,−YO,−ZO) |

If the option "BG" is given, the parameters of logical BG 8 (the 3-axis rotation BG) are set in step with the contents of OBJECT 0. In screen modes other than 5 or 6, Illegal function call occurs. The parameters given to logical BG 8 are calculated by the following formulas; *[p. 167]* use them for reference if you calculate them by hand. The Y and Z axes are swapped in order to tip the X-Y plane of the rotation BG over by 90 degrees so that it matches the X-Z plane of the OBJECT.

```
画面モード5(256×256キャラクタ回転BG)の場合 <BGの中心位置>=128*8(dot)
画面モード6(128×128キャラクタ回転BG)の場合 <BGの中心位置>=64*8(dot)
<BG X位置>=(-OBJ(0,XP)/<ROTZOOMのX倍率>)+<BGの中心位置>
<BG Y位置>=(OBJ(0,ZP)/<ROTZOOMのY倍率>)+<BGの中心位置>
<BG Z位置>=OBJ(0,YP)
<BG X角度>=OBJ(0,XR)-0.25
<BG Y角度>=-OBJ(0,ZR)
<BG Z角度>=-OBJ(0,YR)
ROTPOS <BG X位置>,<BG Y位置>,<BG Z位置>
ROTATE <BG X角度>,<BG Y角度>,<BG Z角度>
```

(In the formulas: 画面モード5(256×256キャラクタ回転BG)の場合 = for screen mode 5 (256×256-character rotation BG); 画面モード6(128×128キャラクタ回転BG)の場合 = for screen mode 6 (128×128-character rotation BG); BGの中心位置 = centre position of the BG; X位置/Y位置/Z位置 = X/Y/Z position; X角度/Y角度/Z角度 = X/Y/Z angle; ROTZOOMのX倍率/Y倍率 = X/Y scale of ROTZOOM.)

**[Supplement]** This command is valid only for OBJECTs that have world coordinates (children of OBJECT 0). For other OBJECTs it does not point in the correct direction (no error occurs). Also, OBJECT 0 has ZP set to 200 as its initial value (that is, the line of sight is at −200 from the origin), so

```
CAMERA(0,0,-200) to (0,0,0)
OBJ(0,<マトリクス変換順序>)=0
```

(マトリクス変換順序 = matrix conversion order) returns things to the state immediately after the SCREEN command.

### PUTSPRITE

*Direct-mode command / Program-mode command*

**Function:** Displays a sprite.

**Syntax:** `PUTSPRITE <sprite number>,[(<X coordinate>,<Y coordinate>)][,<sprite pattern number>]]` (sic)

**Example:** `PUTSPRITE 1,(100,150),0`

**[Parameters]**
- `<sprite number>`: a fixed-point numeric expression from 1 to 255. Anything after the decimal point is cut off.
- `<sprite pattern number>`: a fixed-point numeric expression from 0 to 255. Anything after the decimal point is cut off.
- `<X coordinate>`, `<Y coordinate>`: the display coordinates.

*[p. 168]*

**[Details]** Displays the sprite `<sprite number>` at `<X coordinate>`,`<Y coordinate>`, using the pattern `<sprite pattern number>`.

As with other polygons and sprites, the values given are written into an OBJECT internally. Like the sprites of object types 0–3, the sprite is displayed relative to the `<CX>`,`<CY>` given with the SPRWINDOW command, but the coordinates set in the OBJECT are as follows:

```
OBJ(<対象OBJ番号>, @XP) = <X座標> - <CX> - 8
OBJ(<対象OBJ番号>, @YP) = <Y座標> - <CY> - 8
OBJ(<対象OBJ番号>, @ZP) = 200
```

(対象OBJ番号 = target OBJ number; X座標/Y座標 = X/Y coordinate.)

`<sprite pattern number>` must be defined beforehand with the SETSPRITE command (sic: the command that defines sprite patterns is SPRITE$). If it is not defined, Undefined texture occurs. If the sprite pattern number is omitted, the last number given is used. If it is omitted without ever having been given, 0 is used.

**[Caution]** The information set with PUTSPRITE is initialised by the SCREEN command.

**[Note]** This command is provided for compatibility with MSX BASIC. After executing the SCREEN command, as long as you display sprites using only SETSPRITE and PUTSPRITE, you can work in much the same way, but if you define objects with other commands, `<sprite number>` and `<object number>` are no longer the same number.

`<sprite number>` corresponds one-to-one with an object number, so a defined sprite can be freely rewritten with the OBJ command. An object defined with the SPRITE$ command is treated as TYPE 7 (an orthographically projected polygon with matrix calculation), so parent-child relationships, rotation and so on can be handled in the same way.

The internal registration order is almost the same as for a TYPE 7 object. If the object for `<sprite number>` is not TYPE 7, the following is done:

1. 4 vertices are reserved with SETVERTEX,
2. a polygon ID is reserved for these vertex IDs with SETPOLYGON,
3. the scale XS,YS,ZS of this object is set to 0.99995 (&HFFFC),
4. if the SETSPRITE command has not yet been executed, an attribute ID is reserved with the SETATR command and set in the object for `<sprite number>`,
5. finally, the texture ID referenced by `<sprite pattern number>` is bound to this attribute.

The ID number reserved here is, for each command, the number after the ID last used. This cannot happen as long as you use only the SPRITE$ command, but if any resource runs out, an error such as Overflow occurs.

*[p. 169]*

### SETDISP

*Direct-mode command / Program-mode command*

**Function:** Specifies how far in front of the projection plane of perspective-transformed polygons is actually projected onto the projection plane.

**Syntax:** `SETDISP <display level>`

**Example:** `SETDISP 7`

**[Parameters]**
- `<display level>`: one of 1 to 7. A fixed-point value.

**[Details]** Specifies how far in front of the projection plane of perspective-transformed polygons is actually projected onto the projection plane. The larger the value, the nearer the area displayed.

When `<display level>` is 1, the display level is set at 1/2 of the distance between the projection plane and the viewpoint (exactly halfway). After that, it is set at a distance of (1/2) to the power of `<display level>`. So when `<display level>` is 7, it is (1/2)<sup>7</sup> = 1/128.

For details, see "Display level set by SETDISP" in "3D coordinate conversion diagrams and illustrations" at the end of the book.

### SETLIGHT

*Direct-mode command / Program-mode command*

**Function:** Sets the light source.

**Syntax:** `SETLIGHT <X direction>,<Y direction>,<Z direction>[,<light colour>][,<ambient light>]`

**Example:** `SETLIGHT 1,0,0`

**[Parameters]**
- `<X direction>`, `<Y direction>`, `<Z direction>`: values giving the direction in which the light source points. Fixed-point.
- `<light colour>`: the colour of the light source as a 15-bit RGB colour. Fixed-point.
- `<ambient light>`: the minimum level of dark parts as a 15-bit RGB colour. Fixed-point.

**[Details]** Sets the light source. There is one kind of light source, parallel light. The light source affects RGB-colour polygons, or textures, whose attributes are set to be affected by the light source.

*[p. 170]*

**[Supplement]** These values are initialised by the SCREEN command:

| Item | Initial value |
|---|---|
| `<X,Y,Z direction>` | 1,1,0.5 |
| `<light colour>` | RGB(28,28,28) |
| `<ambient light>` | RGB(0,0,0) |

**[Caution]** If a value exceeds &h1FFFF while the X, Y, Z directions are being calculated, Overflow occurs.

**[Example]**
```
SETLIGHT &H1FFFF,&H1FFFF,&H1FFFF
```

### SETPERS

*Direct-mode command / Program-mode command*

**Function:** Sets the angle of view of the field of vision.

**Syntax:** `SETPERS <angle of view>`

**Example:** `SETPERS 90`

**[Parameters]**
- `<angle of view>`: the field of view, given in degrees. A fixed-point value (expression). The range is 10 to 160.

**[Details]** This command affects perspective-transformed objects and sprites, and the 3-axis rotation screen. The initial value is 90 degrees.

**[Supplement]** `<angle of view>` is initialised to 90 degrees by the SCREEN command.

### SETPFONT

*Direct-mode command / Program-mode command*

**Function:** Defines polygon character data.

**Syntax:** `SETPFONT [<OBJECT ID>],<font number>[,(<scale X>, <scale Y>, <scale Z>[,<position X>, <position Y>,<position Z>)][,<colour>][,<attribute ID>]`

**Example:** `SETPFONT 1,ASC("A")`

*[p. 171]*

**[Parameters]**
- `<OBJECT ID>`: the OBJECT number to define. When `<OBJECT ID>` is given, the `<polygon ID>` and `<attribute ID>` reserved by this command are set for `<OBJECT ID>`. If the parent of `<OBJECT ID>` is −1 (an empty OBJECT), it is connected as a child of the WORLD OBJECT (OBJECT 0), and its OBJECT TYPE is set to 4 (3D polygon, perspective transformation). If the parent of `<OBJECT ID>` is anything other than −1, this setting is not made. If `<OBJECT ID>` is omitted, only the `<vertex ID>` and `<polygon ID>` are defined, and nothing is assigned to an object.
- `<font number>`: the numbers that can be given are:

  | Number | Shape |
  |---|---|
  | 1–14 | Simple figures |
  | 48–57 | Digits 0–9 |
  | 65–90 | Capital letters A–Z |

- `<scale X>`, `<scale Y>`, `<scale Z>`: any fixed-point value is valid. If given, they specify the scale used when reading the vertices of the DATA statements. If omitted, 1.0 is given for all the scales.
- `<position X>`, `<position Y>`, `<position Z>`: any fixed-point value is valid. If given, the position is added when reading the vertices of the DATA statements. If omitted, 0 is given for all the positions. The position is added after the scaling.
- `<colour>`: fixed-point. Specifies the character colour, as a 15-bit RGB colour, set in the attribute. If omitted, RGB(15,15,15) is given. `<colour>` is valid only when new attribute data is reserved; it is ignored when an existing attribute is used.
- `<attribute ID>`: given when already registered attribute data is to be used for the polygon font. The number of data items of the `<attribute ID>` assigned must be at least the number of polygon faces of `<font number>`. If there are not enough data items, an Attribute size error occurs. If `<attribute ID>` is omitted, new attribute data is reserved, and vertex data of the size used by `<font number>` is assigned as an unused attribute ID number (the number after the attribute ID last defined). If no more IDs can be assigned, Attribute ID over occurs; if no more vertex data can be reserved, Attribute data over occurs.

**[Details]** Defines polygon character data for an OBJECT using the vertex data built into BASIC. In addition, the SETPFONT command automatically reserves vertex IDs and polygon IDs according to the amount of font data used.

*[p. 172]*

*Vertex ID*

SETPFONT assigns vertex data of the size used by `<font number>` as an unused vertex ID number (the number after the vertex ID last defined). If no more IDs can be assigned, Vertex ID over occurs; if no more vertex data can be reserved, Vertex data over occurs. The vertex ID can be read with the VERTEXID(-1) function immediately before executing SETPFONT.

*Polygon ID*

SETPFONT assigns polygon face data of the size used by `<font number>` as an unused polygon ID number (the number after the polygon ID last defined). If no more IDs can be assigned, Polygon ID over occurs; if no more polygon face data can be reserved, Polygon data over occurs. The vertex ID reserved just before by this command is assigned to the reserved polygon ID, and the normal vectors are made automatically. The polygon ID can be read with the POLYGONID(-1) function immediately before executing SETPFONT.

**[Example]** Reserves the built-in font character "B" at vertex ID 0, polygon ID 0 and attribute ID 0, assigns it to OBJECT 1 and displays it.

```
OBJ CLEAR
SETPFONT 1,ASC("B")
```

### SETPOLYGON

*Direct-mode command / Program-mode command*

**Function:** Defines a polygon face group (polygon face list).

**Syntax:**
```
(1) SETPOLYGON [<polygon ID>],<number of polygons>,<vertex ID>[,{[(<normal vector>)]|[+]|[-]},(<vertex list>)]
(2) SETPOLYGON {[(<normal vector>)]|[+]|[-]},(<vertex list>)
(3) SETPOLYGON <polygon ID>,<number of polygons>,<vertex ID>,READ
    ...  DATA [(<normal vector>)],(<vertex list>)[,[(<normal vector>)],(<vertex list>)...]
```

**Example:**
```
(1)SETPOLYGON 0,1,0,,(0,1,2,3)
(2)SETPOLYGON (1,0,0),(0,1,2,3)
(3)SETPOLYGON 1,16,READ
```

(Example (3) is printed without the `<vertex ID>` that form (3) requires.)

**[Parameters]** SETPOLYGON registers a table based on registered vertex data, so the vertex ID must always be defined beforehand with SETVERTEX.

- `<polygon ID>`: the group number of the polygons to define, from 0.
- `<number of polygons>`: the number of polygons defined in this group.

*[p. 173]*

- `<vertex ID>`: the ID of the vertex group used to build the polygons. It must already be defined; if it is undefined, Undefined vertex occurs. As long as the number of vertices is the same as or larger than the number of polygon faces, it can be changed to another vertex ID. However, the normal vectors are not recalculated.
- `<normal vector>`: specifies the direction of the face as a unit vector in the form (x,y,z). If `<normal vector>` is omitted, a suitable normal vector is made from the vertex list. The method is to find, among the first 4 vertices, 3 vertices with different coordinates going clockwise, and to make it from the cross product of these 3 vertices. If minus (−) is given when `<normal vector>` is omitted, the normal made from the 3 vertices can be reversed. If plus (+) or nothing is given, it is not reversed.
- `<vertex list>`: given in the form (P1,P2,P3,P4). P1, P2, P3, P4 are vertex numbers within the vertex group of `<vertex ID>`, given so that they go clockwise when the front of the polygon is viewed. When the polygon is a triangle, omitting p4 copies the same number as p3. `<vertex list>` is a list of `<vertex ID>` numbers, so they must be within the range 0 to (`<number of vertices>` − 1) defined with the SETVERTEX command. If a value outside this range is given, Vertex number occurs.

**[Details]** Form (1) creates a new polygon group. If `<polygon ID>` is omitted, the smallest group number that can be defined is assigned. This number can be read with the POLYGONID(-1) function. If no more `<polygon ID>`s can be registered, Polygon ID over occurs.

Form (2) writes on from the data of the polygon ID last defined.

Form (3) defines polygon data defined in DATA statements instead of in a string. The data must be defined in DATA statements in exactly the amount needed for the definition. If there is not enough data, an Out of DATA error occurs. A pair of normal vector and vertex list must always be defined in the same DATA statement.

As a rule, `<polygon ID>`s are defined in order from 0. For example, if ID 2 is defined after ID 0, ID 1 cannot be defined later. If the `<number of polygons>` of a `<polygon ID>` is the same, it can be redefined later. If it differs from the original number of polygons, Polygon size mismatch occurs. The `<vertex ID>` given in this case must have the same number of vertices as, or more than, the `<vertex ID>` last defined. If it has fewer vertices than before, Vertex size mismatch occurs. The contents of the polygon data are initialised by the SCREEN command.

*[p. 174]*

**[Example]**
```
(1) SETPOLYGON 0,10,0
(2) SETPOLYGON -,(0,1,2,3)
(3) SETPOLYGON 1,6,0,READ
```

(1) declares that 10 polygons will now be defined in polygon ID 0 using the vertices of vertex ID 0. Or it declares that polygons will be newly redefined in the previously defined polygon ID 0 using the vertices of vertex ID 0.

(2), assuming it is executed straight after (1), assigns the vertices with vertex numbers 0, 1, 2 and 3 of vertex ID 0 to the first polygon (polygon number 0) of polygon ID 0 declared in (1). The normal vector is omitted and a minus sign is given, so the normal vector is defined so that the normal of the plane joining the first 3 distinct points of vertex numbers 0, 1, 2 and 3 points to the far side.

*[Figure: a square of vertices 0 → 1 → 2 → 3 going clockwise (0 top left, 1 top right, 2 bottom right, 3 bottom left), labelled "the normal vector is made pointing away from the screen".]*

Polygon ID 0 was reserved for 10 faces by (1), so it needs to be defined 9 more times.

(3) declares that 6 polygons will now be defined in polygon ID 1 using the vertices of vertex ID 0. Or it declares that polygons will be newly redefined in the previously defined polygon ID 1 using the vertices of vertex ID 0. The data to define is read from DATA statements in the same way as the READ command.

- Example DATA statements for (3):

```
100 DATA ( 0, 0,-1), (0, 1, 2, 3)
110 DATA ( 1, 0, 0), (1, 4, 7, 2)
120 DATA ( 0, 0, 1), (4, 5, 6, 7)
130 DATA (-1, 0, 0), (5, 0, 3, 6)
140 DATA ( 0,-1, 0), (4, 1, 0, 5)
150 DATA ( 0, 1, 0), (2, 7, 6, 3)
```

### SETSPRITE

*Direct-mode command / Program-mode command*

**Function:** Displays a sprite.

**Syntax:** `SETSPRITE<sprite number>[,<colour (palette number)>[,<flip>]]`

**Example:** `SETSPRITE 1,1,&B10`

*[p. 175]*

**[Parameters]**
- `<sprite number>`: takes a value from 1 to 255.
- `<palette number>`: takes the value 0 or 1. The colours of the palette selected by `<palette number>` can be specified with

  ```
  PALETTE 10,0～255,<color>     →palette 0
  PALETTE 10,256～511,<color>   →palette 1
  ```

  (10 is the logical BG number of sprites). Parameters other than the sprite number can be omitted; if omitted, the previous state is kept.
- `<flip>`:

  | Value | Meaning |
  |---|---|
  | 0 | No flip |
  | 1 | Flip in the X direction |
  | 2 | Flip in the Y direction |
  | 3 | Flip in the X and Y directions |

**[Details]** When sprite display is on, displays the sprite with the given sprite number on the screen. Parameters other than the sprite number can be omitted; if omitted, the previous state is kept. The sprite number uses the value given when it was defined with the SPRITE$ command. The information set with SETSPRITE is initialised by the SCREEN command.

### SETVERTEX

*Direct-mode command / Program-mode command*

**Function:** Defines a vertex group used by polygons.

**Syntax:**
```
(1) SETVERTEX [<vertex ID>],<number of vertices>[,[@<vertex number>,](<XP>,<YP>,<ZP>)...]
(2) SETVERTEX [@<vertex number>,](<XP>,<YP>,<ZP>)
(3) SETVERTEX [<vertex ID>],<number of vertices>,READ[,(<scale X>, <scale Y>, <scale Z>[,<position X>, <position Y>, <position Z>])]
    ...
    DATA <XP>,<YP>,<ZP>[,<XP2>,<YP2>,<ZP2>...]
    DATA <XP3>,<YP3>,<ZP3>
```

**Example:**
```
(1)SETVERTEX 0,4,@0(-10,-10,0,),(10,-10,0),(10,10,0),(-10,10,0)
(2)SETVERTEX @0,(-10,-10,0)
(3)SETVERTEX 1,4,(-10,-10,0,),(10,-10,0),(10,10,0),(-10,10,0)
```

*[p. 176]*

**[Parameters]**
- `<vertex ID>`: the group number of the vertices to define, from 0.
- `<number of vertices>`: the number of vertices defined in this group.
- `<vertex number>`: the number of the vertex at which to start defining vertex coordinates.
- `(<XP>,<YP>,<ZP>)`: the coordinates of a vertex.
- `(<scale X>, <scale Y>, <scale Z>)`: the scale value for each direction.
- `(<position X>, <position Y>, <position Z>)`: the position is added when the vertices of the DATA statements are read.

**[Details]** Form (1) creates new vertices. If `<vertex ID>` is omitted, the smallest group number that can be defined is assigned. This number can be read with the VERTEXID(-1) function. If no more `<vertex ID>`s can be registered, Vertex ID over occurs.

Form (2) writes on from the vertex last defined. If you try to define vertices beyond the number of vertices given for `<vertex ID>`, Vertex out of area occurs.

Form (3) defines vertex data defined in DATA statements instead of in a string. The data must be defined in DATA statements in exactly the amount needed for the definition. If there is not enough data, an Out of DATA error occurs.

If `<scale X>`,`<scale Y>`,`<scale Z>` are given, they specify the scale used when reading the vertices of the DATA statements. If omitted, 1.0 is given for all the scales.

If `<position X>`,`<position Y>`,`<position Z>` are given, the position is added when the vertices of the DATA statements are read. If omitted, 0 is given for all the positions. The position is added after the scaling. The DATA statements can be split into several, but X, Y and Z must always be registered in the same statement.

Defines a vertex group used by polygons. As a rule, `<vertex ID>`s are defined in order from 0. For example, if ID 2 is defined after ID 0, ID 1 cannot be defined later.

A `<vertex ID>` can be redefined later if its `<number of vertices>` is the same.

`<vertex number>` is given when, for example, you want to rewrite some of the vertices later. The range of `<vertex number>` is 0 to `<number of vertices>` − 1 (of the vertex group being defined). If the coordinates of defined vertices are changed later, all polygons using this vertex ID are deformed, but the normal vectors of the polygons are not recalculated, so take care with one-sided polygons and polygons affected by light. To make correct normal vectors, SETPOLYGON must be executed again using the same vertex ID. The vertex data is initialised by the SCREEN command.

*[p. 177]*

### SPRITE$

*Direct-mode command / Program-mode command*

**Function:** Defines a sprite pattern.

**Syntax:** `SPRITE$(<sprite pattern number>) = <string expression>`

**Example:** `SPRITE$(1)=STRING$(16*16, CHR$(&HAA))`

**[Parameters]**
- `<sprite pattern number>`: 0 to 255.
- `<string expression>`: the length cannot exceed 256 bytes (16×16). If it does, TABLE SIZE ERROR occurs.

**[Details]** A sprite is always 16×16 in 256 colours. Patterns defined with SPRITE$ are initialised by the SCREEN command.

**[Supplement]** SPRITE$ sets patterns in the same area as the SETTEX command, but they do not need to be defined in order from 0 and can be handled in any order. When a new pattern is defined with SPRITE$, a 16×16 256-colour pattern is reserved at the position following those defined with the SETTEX command, and this can be referenced by `<sprite pattern number>`. For example, if you have defined

```
SETTEX 0,<XS>,<YS>,<COLOR_DEPTH>,<文字列>
SETTEX 1,<XS>,<YS>,<COLOR_DEPTH>,<文字列>
```

(文字列 = string) and you then define

```
SPRITE$(99)=<文字列>
```

this texture number can be rewritten with

```
SETTEX 2,...
```

*[p. 178]*

### SPRWINDOW

*Direct-mode command / Program-mode command*

**Function:** Sets the range that limits the display of sprites and polygons.

**Syntax:** `SPRWINDOW [<left>][,<top>][,<right>][,<bottom>] [,<ZLIMIT>] [,<CX>][,<CY>]`

**Example:**
```
SPRWINDOW ,,,,,0,0         → makes the top left of the screen the sprite reference point
SPRWINDOW 0,0,159,223      → displays particular polygons only on the left side of the screen
```

**[Parameters]**
- `<left>`, `<top>`, `<right>`, `<bottom>`: fixed-point integers. The value `<right>` − `<left>` + 1 (screen width) must be in the range 1 to 320. The value `<bottom>` − `<top>` + 1 (screen height) must be in the range 1 to 224.
- `<ZLIMIT>`: a fixed-point integer, 0 to &H7FFF.
- `<CX>`: a fixed-point integer, 0 to 319.
- `<CY>`: a fixed-point integer, 0 to 223.

**[Details]** `<left>`,`<top>`,`<right>`,`<bottom>` specify the display range of polygons and sprites on the screen. These parameters are valid when bits 6 and 7 of the `<MODE>` item of the SETATR command for the displayed sprite or polygon face are set to "display inside the window" or "display outside the window". In attributes created with the SETPFONT command, "display inside the window" is enabled.

`<ZLIMIT>` specifies the display limit position of polygons in the Z direction from the viewpoint. Polygons beyond this value are not displayed. Sprites whose Z coordinate is larger than this are also not displayed (the Z coordinate of a sprite is used to decide the display priority of polygons and sprites).

`<CX>`,`<CY>` set the reference position for displaying polygons and sprites. For polygons it is the position of the vanishing point, and for sprites it is the coordinate origin; by default it is the centre of the screen.

The following values are defined as initial values after the SCREEN command is executed:

| Item | Initial value |
|---|---|
| `<LEFT>` | 0 |
| `<TOP>` | 0 |
| `<RIGHT>` | 319 |
| `<BOTTOM>` | 223 |
| `<ZLIMIT>` | &H7FFF |
| `<CX>` | 320 / 2 |
| `<CY>` | 224 / 2 |

## 1.7 OBJ commands/functions

*[p. 179]*

### About the OBJ commands/functions

In GAME BASIC for SEGASATURN, polygons and sprites are called OBJECTs and are managed through the OBJ commands and functions.

Each OBJ-related command is almost equivalent to an OBJ item number `OBJ(n,<item>)=`. The 3D-related commands work using numbers. Frequently used items have alias definitions. For details, see the OBJPOS command, the OBJROT command and so on.

For example, the command that writes the coordinates of a polygon or sprite is

```
OBJPOS <オブジェクト番号>, X,Y,Z
```

but in GAME BASIC for SEGASATURN it can also be expressed as

```
OBJ(<オブジェクト番号>,@XP)=X,Y,Z
```

(オブジェクト番号 = object number). When OBJ is on the right-hand side of =, it is a function; when OBJ is in an expression (sic) or on the left-hand side of =, it is a command (a command like MID$(...)=). Internally, for each object number, the coordinates, rotation angles, attribute ID (the colour and surface of the material), polygon ID (the shape of the material) and so on needed for display are kept in a structure (a kind of array), and polygons and sprites are displayed frame by frame (the 4th parameter of the SCREEN command) using the values of these items. Put simply, the OBJ command is a command that rewrites the contents of these items.

*[p. 180]*

**`<OBJECT number>`**

A fixed-point integer. The fractional part is cut off. The valid range differs between commands and functions.

**Coordinates, speed, acceleration, distance, matrix values**

- *When writing:* As long as the value is a fixed-point value from −32767.9999 (= −&h7FFF.FFFC) to +32767.9999 (= &h7FFF.FFFC), no Overflow error occurs even beyond this range. Bits beyond the 16-bit integer part are ignored (take care, because upper bits are cut off and the sign can change). A floating-point value is converted to fixed-point according to the BASIC conversion rules before it is applied.
- *When reading:* A fixed-point value from −32767.9999 (= −&h7FFF.FFFC) to +32767.9999 (= &h7FFF.FFFC).

**Scale**

- *When writing:* As long as the value is a fixed-point value from −32767.9999 (= −&h7FFF.FFFC) to +32767.9999 (= &h7FFF.FFFC), no Overflow error occurs even beyond this range. Bits beyond the 16-bit integer part are ignored (take care, because upper bits are cut off and the sign can change). A floating-point value is converted to fixed-point according to the BASIC conversion rules before it is applied.
- *When reading:* A fixed-point value from −32767.9999 (= −&h7FFF.FFFC) to +32767.9999 (= &h7FFF.FFFC).

**Angle / angular velocity**

- *When writing:* A fixed-point value from 0 (&H0.0000) to less than 1 (&H0.FFFC). The unit is radians (1.000 = 360°) (sic). Bits of the integer part beyond this range are ignored. A floating-point value is converted to fixed-point according to the BASIC conversion rules before it is applied.
- *When reading:* A fixed-point value from 0 (&H0.0000) to less than 1 (&H0.FFFC). The unit is radians (1.000 = 360°) (sic).

**Initial value**

The standard-state value set immediately after a BASIC program starts, after the SCREEN command is executed, or after the OBJ CLEAR or OBJ NEW command is executed.

*[p. 181]*

### List of OBJ commands/functions

### OBJ

*Direct-mode command / Program-mode command / Fixed-point function*

**Function:** The structure used to display 2D and 3D sprites.

**Syntax:**
```
(1) OBJ(<OBJECT number>,<item number>)=<numeric expression>
(2) OBJ(<OBJECT number>,<item number>)
(3) OBJ COPY <source OBJECT number> TO <destination OBJECT number>[<destination OBJECT number>...]
(4) OBJ CLEAR
(5) OBJ NEW
(6) OBJ PRINT <OBJECT number>[,P]  or
    OBJ ?[ <object number>][,P]
```

**Example:** `OBJ(1,4)=100,100,50` → as well as item number 4, which specifies the X position, this also specifies the Y position and Z position.

**[Parameters]**
- `<OBJECT number>`:

  | Number | Meaning |
  |---|---|
  | −1 | Shredder (to delete an OBJECT, make OBJECT −1 its parent) |
  | 0 | World coordinates that determine the viewpoint (to display an OBJECT, make OBJECT 0 its parent) |
  | 1 | Individual OBJECTs |

- `<item number>`: the number of the operation item concerned.
- `<numeric expression>`: the value to set in each item.
- `P`: specifies a pause.

**[Details]** Displays the OBJECT given by `<OBJECT number>`.

Form (1) sets `<numeric expression>` for the function corresponding to `<item number>` of the object given by `<object number>`. Several `<numeric expression>`s can be given in a row, separated by commas (,). Each comma advances the item number by 1, and items in between can be skipped by consecutive commas. However, at least one value is needed.

Form (2) is the usage for reading a value set in an OBJECT, as a function.

Form (3) copies the contents of `<source OBJECT number>` to `<destination OBJECT number>`. The objects concerned are OBJECT 1 and above. All the contents of `<source OBJECT>` are copied to `<destination OBJECT>`, but for the parent and sibling relationships the same rules apply as when the following commands are executed.

*[p. 182]*

```
OBJ(<コピー先OBJECT>,PARENT)=OBJ(<コピー元OBJECT>,PARENT)
```

(コピー先 = destination, コピー元 = source.)

Form (4) initialises the currently defined object structures.

Form (5) initialises the currently defined object structures and resets the registered counts of the texture, attribute, vertex and polygon IDs to 0.

Form (6) displays the relationships of the objects connected as children to `<OBJECT number>`. If the "P" option is given, [HIT KEY] is shown and the display stops every (height of the text WINDOW − 3) lines. Pressing [CTRL]+[C] interrupts the display. If an object references itself (for example, if its parent is itself), the display is cut off at the point where it returns to the first object and displays it.

The OBJ command/function takes the form of a structure. Depending on `<item number>`, the second parameter in the () following OBJ, it acts as 39 commands/functions (one item number acts as both a command and a function; these are the ones marked READ/WRITE under object type in the tables in the [Parameters] parts below) and as 20 functions (the ones marked only READ). In other words, in the normal BASIC sense of commands and functions, there are 39 commands, 39 functions with the same names, and 20 more functions that work only as functions. Here, the function, syntax, example, parameters and details are described for each item number of the OBJ command/function as if it were an independent command/function.

**List of item numbers** *[pp. 182–185: items 0–12 on p. 182, 13–40 on p. 183, 41–68 on p. 184 and 69–75 on p. 185; from item 41 the printed table has no alias column]*

| Item number | Function | Symbol used in the descriptions | OBJECT type | Alias command |
|---|---|---|---|---|
| 0 | OBJECT type | @TYPE | (READ/WRITE) | OBJTYPE |
| 1 | Auxiliary flag | @FLAG | (READ/WRITE) | |
| 2 | OBJECT group | @GROUP | (READ/WRITE) | |
| 3 | | | | |
| 4 | X position | @XP | (READ/WRITE) | OBJPOS |
| 5 | Y position | @YP | (READ/WRITE) | OBJPOS |
| 6 | Z position | @ZP | (READ/WRITE) | OBJPOS |
| 7 | | | | |
| 8 | X rotation angle | @XR | (READ/WRITE) | OBJROT |
| 9 | Y rotation angle | @YR | (READ/WRITE) | OBJROT |
| 10 | Z rotation angle | @ZR | (READ/WRITE) | OBJROT |
| 11 | | | | |
| 12 | X scale | @XS | (READ/WRITE) | OBJZOOM |
| 13 | Y scale | @YS | (READ/WRITE) | OBJZOOM |
| 14 | Z scale | @ZS | (READ/WRITE) | OBJZOOM |
| 15 | | | | |
| 16 | Attribute ID number | @ATR | (READ/WRITE) | OBJATR |
| 17 | Polygon ID number | @POLYGON | (READ/WRITE) | OBJATR |
| 18 | Move/rotate conversion order | @ORDER | (READ/WRITE) | |
| 19 | Display time | @TIME | (READ/WRITE) | |
| 20 | Link structure: parent OBJECT | @PARENT | (READ/WRITE) | OBJLINK |
| 21 | Link structure: child OBJECT | @CHILD | (READ) | |
| 22 | Link structure: elder sibling OBJECT | @LEFT | (READ) | |
| 23 | Link structure: younger sibling OBJECT | @RIGHT | (READ) | |
| 24 | X speed | @XV | (READ/WRITE) | |
| 25 | Y speed | @YV | (READ/WRITE) | |
| 26 | Z speed | @ZV | (READ/WRITE) | |
| 27 | | | | |
| 28 | X acceleration | @XA | (READ/WRITE) | |
| 29 | Y acceleration | @YA | (READ/WRITE) | |
| 30 | Z acceleration | @ZA | (READ/WRITE) | |
| 31 | | | | |
| 32 | X speed limiter | @XL | (READ/WRITE) | |
| 33 | Y speed limiter | @YL | (READ/WRITE) | |
| 34 | Z speed limiter | @ZL | (READ/WRITE) | |
| 35 | | | | |
| 36 | X rotation speed | @XRV | (READ/WRITE) | OBJTURN |
| 37 | Y rotation speed | @YRV | (READ/WRITE) | OBJTURN |
| 38 | Z rotation speed | @ZRV | (READ/WRITE) | OBJTURN |
| 39 | | | | |
| 40 | | | | |
| 41 |  |  |  | |
| 42 |  |  |  | |
| 43 |  |  |  | |
| 44 |  |  |  | |
| 45 |  |  |  | |
| 46 |  |  |  | |
| 47 |  |  |  | |
| 48 | 4-point sprite vertex X0 | @XP0 | (READ/WRITE) | |
| 49 | 4-point sprite vertex Y0 | @YP0 | (READ/WRITE) | |
| 50 | 4-point sprite vertex X1 | @XP1 | (READ/WRITE) | |
| 51 | 4-point sprite vertex Y1 | @YP1 | (READ/WRITE) | |
| 52 | 4-point sprite vertex X2 | @XP2 | (READ/WRITE) | |
| 53 | 4-point sprite vertex Y2 | @YP2 | (READ/WRITE) | |
| 54 | 4-point sprite vertex X3 | @XP3 | (READ/WRITE) | |
| 55 | 4-point sprite vertex Y3 | @YP3 | (READ/WRITE) | |
| 56 | X position on screen | @XD | (READ) | |
| 57 | Y position on screen | @YD | (READ) | |
| 58 | Z position from screen | @ZD | (READ) | |
| 59 | RADIUS/ZD | @RD | (READ) | |
| 60 | Collision-test group setting | @GTEST | (READ/WRITE) | |
| 61 | Radius for contact test | @RADIUS | (READ/WRITE) | |
| 62 | Contact flag and its distance | @COLIDIST | (READ) | |
| 63 | Number of the OBJECT contacted | @COLIOBJ | (READ) | |
| 64 | Matrix at perspective transformation | M00 | (READ) | |
| 65 | Matrix at perspective transformation | M01 | (READ) | |
| 66 | Matrix at perspective transformation | M02 | (READ) | |
| 67 | Matrix at perspective transformation | M10 | (READ) | |
| 68 | Matrix at perspective transformation | M11 | (READ) | |
| 69 | Matrix at perspective transformation | M12 | (READ) | |
| 70 | Matrix at perspective transformation | M20 | (READ) | |
| 71 | Matrix at perspective transformation | M21 | (READ) | |
| 72 | Matrix at perspective transformation | M22 | (READ) | |
| 73 | Matrix at perspective transformation | M30 | (READ) | |
| 74 | Matrix at perspective transformation | M31 | (READ) | |
| 75 | Matrix at perspective transformation | M32 | (READ) | |

*[p. 185]*

**[Supplement]** Rewrites the contents of the OBJECT given by `<OBJECT number>`. The contents of each OBJECT are calculated at every VSYNC and displayed on the screen. If the polygon of `<OBJECT number>` is undefined (if it is connected to OBJECT −1), `<OBJECT number>` is connected as a child of OBJECT 0 and the cube defined inside BASIC is displayed.

The initial values of an object are as follows:

| Item | Symbol | Initial value |
|---|---|---|
| Object type | TYPE | 0 |
| Auxiliary flag | FLAG | 0 |
| For collision tests | GROUP | 0 |
| Position | (XP,YP,ZP) | (0,0,0) |
| Scale | (XS,YS,ZS) | (1,1,1) |
| Angle | (XR,YR,ZR) | (0,0,0) |
| Contact radius | RADIUS | 10 |
| Contact flag and distance | COLIDIST | −1 |
| OBJECT contacted | COLIOBJ | 0 |
| OBJECT lifetime | TIME | 0 |
| Matrix conversion order | ORDER | 0 |
| | POLYGON | 0 |
| | ATR | 0 |

Next, the initial values for OBJECTs of each type are described.

*[p. 186]*

**OBJ −1 (OBJECT for deletion)**

| Connection | Item | Value |
|---|---|---|
| Connection to parent OBJECT | PARENT | −1 (OBJECT −1) |
| Connection to child OBJECT | CHILD | 1 (the first OBJECT for display) |
| Connection to elder sibling OBJECT | LEFT | −1 |
| Connection to younger sibling OBJECT | RIGHT | −1 |

Everything else is the same as a normal OBJECT.

**OBJ 0 (WORLD OBJECT)**

| Connection | Item | Value |
|---|---|---|
| Connection to parent OBJECT | PARENT | 0 |
| Connection to child OBJECT | CHILD | −1 |
| Connection to elder sibling OBJECT | LEFT | −1 |
| Connection to younger sibling OBJECT | RIGHT | −1 |
| Position | (XP,YP,ZP) | (0,0,200) |

Everything else is the same as a normal OBJECT.

The WORLD OBJECT is given a depth of 200 (that is, the viewpoint is 200 in front, at −200). In this respect it differs from general graphics textbooks. To make the origin of the WORLD coordinates the same as the viewpoint, set

```
OBJ(0, ZP) = 0
```

and give a depth such as 200 when displaying each OBJECT.

**OBJECT 1 onward (OBJECTs for display)**

| | OBJECT 1 | OBJECT 2 | Last OBJECT |
|---|---|---|---|
| Connection to parent OBJECT | −1 (OBJECT −1) | −1 (OBJECT −1) | −1 (OBJECT −1) |
| Connection to child OBJECT | −1 | −1 | −1 |
| Connection to elder sibling OBJECT | −1 | 1 | The previous OBJECT number |
| Connection to younger sibling OBJECT | 2 | 3 | −1 |

*[p. 187]*

### Explanation by item number

**■ TYPE (OBJECT type) [OBJTYPE]**

*[Figure annotation: an arrow labelled "item number" points to the 0 at the start of the entry heading below.]*

### 0 (OBJECT type: @TYPE)

*Direct-mode command / Program-mode command / Fixed-point function*

**Function:** Specifies how an OBJECT is displayed.

**Syntax:** `OBJ(<OBJECT number>,0)=<TYPE>`

**Example:** `OBJ(1,0)=4` → makes the OBJECT type a polygon and displays the system cuboid.

**[Parameters]**
- `<OBJECT number>`: the OBJECT number concerned. An integer from 1 to 255.
- `<TYPE>`: a numeric expression giving one of the values that specify the display method. Valid values are integers from 0 to 7. Anything after the decimal point is cut off.

**[Return value]** An integer from 0 to 7 representing the type of the OBJECT. However, this does not apply when `<OBJECT number>` is 0.

**[Details]**

*`<TYPE>`=0*

Display stopped (initial state). Used to disable display temporarily. Neither rotation nor translation is performed. If children are connected to `<OBJECT number>`, the children are displayed.

*`<TYPE>`=1*

2D sprite display, with scale and Z rotation.

- Function: Displays a sprite with the given position, scale and rotation angle. It is also sorted by Z value. If a negative value is given for the scale, a scale is calculated from the Z position, multiplied by the complement of the scale, and used as the display scale. For example, if −2.0 is given as the scale and the sprite is at a position (Z position) where it would be displayed at 0.5×, it is displayed at 1.0×. If the OBJECT of `<OBJECT number>` is undefined (connected to OBJECT −1, for example when it has never been used since the SCREEN command), `<OBJECT number>` is connected as a child of OBJECT 0 (the world coordinates) (this is not done if the OBJECT is connected to anything other than OBJECT −1). Specifically, `OBJ(<OBJECT number>,PARENT)=0` is executed automatically.

*[p. 188]*

  A worked example follows. The other types can be examined in the same way, so use it for reference.

  ```
  SCREEN 0
  ?OBJ(1,0),OBJ(1,20)
  >0   -1               → the default type is 0; the parent is OBJECT -1
  OBJ ?                 → look at the connections
  >0                    → only the world OBJECT exists
  OBJ(1,0)=1            → set TYPE 1 for OBJECT 1
  OBJ ?                 → look at the new connections
  > 0-> 1               → OBJECT 1 has been connected with OBJECT 0 as its parent
                          (it is not displayed because no sprite shape has been defined)
  ?OBJ(1,0),OBJ(1,20)
  >1   0                → the type has become 1 and the parent has become OBJECT 0
  ```

  The items used in the OBJ() structure are:

  | Item | Meaning |
  |---|---|
  | XP | Position (position on the screen, centred on the CX,CY parameters of SPRWINDOW) |
  | YP | Position (position on the screen, centred on the CX,CY parameters of SPRWINDOW) |
  | ZP | Priority relative to polygons, by Z position |
  | ZR | Rotation angle |
  | XS | The XS scale is used for both scale X and scale Y |
  | ATR | Attribute ID created with the SETATR command |

  Not affected by rotation or translation. If a negative value is given for the scale, it is affected by SETPERS.

*`<TYPE>`=2*

2D sprite display, with X,Y scale and Z rotation.

- Function: Displays a deformed sprite with the given vertical and horizontal display scales. Unlike the function (sic), if a negative scale is given the character is displayed flipped. If the OBJECT of `<OBJECT number>` is undefined (connected to OBJECT −1, for example when it has never been used since the SCREEN command), `<OBJECT number>` is connected as a child of OBJECT 0 (the world coordinates) (this is not done if the OBJECT is connected to anything other than OBJECT −1). The items used in the OBJ() structure are:

  | Item | Meaning |
  |---|---|
  | XP | Position (position on the screen, centred on the CX,CY parameters of SPRWINDOW) |
  | YP | Position (position on the screen, centred on the CX,CY parameters of SPRWINDOW) |
  | ZP | Priority relative to polygons, by Z position |
  | ZR | Rotation angle |
  | XS | Scale X |
  | YS | Scale Y |
  | ATR | Attribute ID created with the SETATR command |

  *[p. 189]* Not affected by rotation or translation.

*`<TYPE>`=3*

2D sprite display, 4-point specification.

- Function: Displays a deformed sprite by specifying 4 points on the screen. The 4 points are given as offset positions from the centre of the window, and a Z position representing the whole sprite is given separately. The 4 points are given in the order top left, top right, bottom right, bottom left (clockwise). If the OBJECT of `<OBJECT number>` is undefined (connected to OBJECT −1, for example when it has never been used since the SCREEN command), `<OBJECT number>` is connected as a child of OBJECT 0 (the world coordinates) (this is not done if the OBJECT is connected to anything other than OBJECT −1). The items used in the OBJ() structure are:

  | Item | Meaning |
  |---|---|
  | XP | Position (position on the screen, centred on the CX,CY parameters of SPRWINDOW) |
  | YP | Position (position on the screen, centred on the CX,CY parameters of SPRWINDOW) |
  | ZP | Priority relative to polygons, by Z position |
  | ATR | Attribute ID created with the SETATR command |
  | XP0,YP0 / XP1,YP1 / XP2,YP2 / XP3,YP3 | Positions of the 4 points of the sprite, relative to XP,YP |

  Not affected by rotation or translation.

*`<TYPE>`=4*

3D polygon display, rotation, translation, perspective transformation.

- Function: Rotates and translates the given polygon model relative to the position of the parent OBJECT, applies the perspective transformation, and displays it as polygons and deformed sprites. It is affected by almost all items except the 4-point sprite vertices.

  If the OBJECT of `<OBJECT number>` is undefined (if the PARENT of `<OBJECT number>` is −1), `<OBJECT number>` is connected with OBJECT 0 (the world coordinates) as its parent, and the cube defined inside BASIC is displayed (this is not done if the OBJECT is connected to anything other than OBJECT −1).

  ```
  OBJ(<OBJECT番号>, 20)=0    → connects with OBJECT 0 as the parent (displayed relative to the position of <OBJECT 0)
  ```

  (OBJECT番号 = OBJECT number.)

*[p. 190]*

*`<TYPE>`=5*

3D polygon display, rotation, translation, orthographic projection.

- Function: Rotates and translates the given polygon model relative to the position of the parent OBJECT, and displays polygons and deformed sprites with orthographic projection as is. However, options such as light-source calculation and clipping cannot be used.

  If the OBJECT of `<OBJECT number>` is undefined (if the PARENT of `<OBJECT number>` is −1), `<OBJECT number>` is connected with OBJECT 0 (the world coordinates) as its parent, and the cube defined inside BASIC is displayed (this is not done if the OBJECT is connected to anything other than OBJECT −1).

*`<TYPE>`=6*

Transparent object, matrix rotation and translation.

- Function: Rotates and translates relative to the position of the parent OBJECT to make a new position. It is the same as the 3D polygon display of `<TYPE>`=4 except that no sprite is displayed. It is used to rotate children connected with this OBJECT as their parent, or for hit detection.

  If the OBJECT of `<OBJECT number>` is undefined (if the PARENT of `<OBJECT number>` is −1), `<OBJECT number>` is connected with OBJECT 0 (the world coordinates) as its parent.

*`<TYPE>`=7*

Sprite display, rotation, translation, orthographic projection.

- Function: Rotates and translates relative to the position of the parent OBJECT, and displays polygons and deformed sprites with orthographic projection as is. However, options such as light-source calculation and clipping cannot be used.

  This function is used inside BASIC mainly to simulate the SETSPRITE and PUTSPRITE commands.

  If the OBJECT of `<OBJECT number>` is undefined (if the PARENT of `<OBJECT number>` is −1), `<OBJECT number>` is connected with OBJECT 0 (the world coordinates) as its parent, and the following operations are performed:

  - 4 vertices are reserved at an unused vertex ID using the SETVERTEX command.
  - 1 polygon is reserved at an unused polygon ID using the SETPOLYGON command.
  - 1 attribute is reserved at an unused attribute ID using the SETATR command.
  - These IDs are set in `<OBJECT number>` and a square is displayed.

*[p. 191]*

**■ FLAG (auxiliary flag)**

### 1 (Auxiliary flag: @FLAG)

*Direct-mode command / Program-mode command / Fixed-point function*

**Function:** Specifies how an OBJECT behaves when it is displayed.

**Syntax:** `OBJ(<OBJECT number>,1)=<numeric expression>`

**Example:** `OBJ(1,1)=&B10` → makes the matrix readable.

**[Parameters]**
- `<OBJECT number>`: the OBJECT number concerned. An integer from −1 to 255.
- `<numeric expression>`: a value from 0 to 7.

**[Return value]** The bits for which matrix reading is enabled are "1" (specifically, at present a value from 0 to 3).

**[Details]**

When bit 0 is "1", the translation components of the matrix used at perspective transformation are written to M30 to M32. To read the values of M30 to M32, you must wait at least 1 VSYNC after setting the value. This flag automatically becomes "1" when the collision-test setting (GTEST) is set to a value other than 0.

Note that the coordinates used for an OBJECT's hit detection (M30, M31, M32) are strictly coordinates from the viewpoint, and differ from coordinates relative to OBJECT 0 (in the sense that a matrix operation between the unit vector of the line of sight and OBJECT 0 comes in between). In the standard state, the ZP value of OBJECT 0, 200, is added in the Z direction.

When bit 1 is "1", the whole matrix used at perspective transformation (4×3) is saved in M00 to M32. To read these values, you must wait at least 1 VSYNC after setting the value.

```
M00  M01  M02
M10  M11  M12
M20  M21  M22
M30  M31  M32
```

**[Caution]** These bits are flags for taking out the matrix used for display, because following the hierarchy of 3D objects and calculating the matrices with ordinary BASIC expressions, for collision detection and the like, needs a great deal of calculation.

When bit 2 is "1", the position on screen when the OBJECT has been perspective-transformed onto the screen is written to XD and YD, taking the top left (0,0) as the reference; the Z distance of the OBJECT is written to ZD, and the OBJECT's radius/Z distance to RD. The position of an OBJECT that would be projected off the screen is also returned, but the values are not guaranteed if it is far off the screen. To read these values,

*[p. 192]*

you must wait at least one drawing frame after setting the value. The values are valid for OBJECTs of TYPE 4, 5, 6 and 7.

**■ GROUP (OBJECT group)**

### 2 (OBJECT group: @GROUP)

*Direct-mode command / Program-mode command / Fixed-point function*

**Function:** Specifies the group of an OBJECT for collision detection.

**Syntax:** `OBJ(<OBJECT number>,2)=<numeric expression>`

**Example:** `OBJ(1,2)=&B101` → sets OBJECT 1 to belong to the groups of bit 0 and bit 2.

**[Parameters]**
- `<OBJECT number>`: the OBJECT number concerned. An integer from −1 to 255.
- `<numeric expression>`: a 16-bit integer.

**[Return value]** Returns the current group value, as a 16-bit integer in fixed-point form.

**[Details]** Holds a 16-bit value and is used to specify the group of a 3D OBJECT for collision detection. Each bit means one group, so OBJECTs can be sorted into up to 16 groups. An OBJECT can also belong to more than one group. When a value other than 0 is written here, the values of the OBJECT's matrix are written to M00 to M32 at each display, as the basis for contact testing. The coordinates are not calculated for an OBJECT that is not displayed. The initial value is 0, meaning that the OBJECT is not subject to contact testing. Values can be written to and read from OBJECT 0 and OBJECT −1, but these OBJECTs are not displayed, so they are not subject to testing.

*[p. 193]*

**■ XP, YP, ZP (position) [OBJPOS]**

### 4 (X position: @XP)

*Direct-mode command / Program-mode command / Fixed-point function*

### 5 (Y position: @YP)

*Direct-mode command / Program-mode command / Fixed-point function*

### 6 (Z position: @ZP)

*Direct-mode command / Program-mode command / Fixed-point function*

The following describes item number 4. Read it accordingly for 5 and 6.

**Function:** Specifies XP (the relative position (X coordinate)) from the parent OBJECT.

**Syntax:** `OBJ(<OBJECT number>,4)=<numeric expression>`

**Example:**
```
OBJ(1,4)=200              → sets XP to 100
OBJ(1,4)=100,200,300      → sets XP to 100, YP to 200 and ZP to 300
```
(The first example sets 200, although the comment says 100 (sic).)

**[Parameters]**
- `<OBJECT number>`: the OBJECT number concerned. An integer from −1 to 255.
- `<numeric expression>`: the relative position coordinate.

**[Return value]** Coordinate: the X-coordinate distance from the parent OBJECT (the value written).

**[Details]** Specifies the X-coordinate distance from the parent OBJECT with a numeric expression.

**■ XR, YR, ZR (rotation angle) [OBJROT]**

### 8 (X rotation angle: @XR)

*Direct-mode command / Program-mode command / Fixed-point function*

### 9 (Y rotation angle: @YR)

*Direct-mode command / Program-mode command / Fixed-point function*

### 10 (Z rotation angle: @ZR)

*Direct-mode command / Program-mode command / Fixed-point function*

*[p. 194]*

The following describes item number 8. Read it accordingly for 9 and 10.

**Function:** Specifies the XR (rotation angle about the X axis) of an OBJECT.

**Syntax:** `OBJ(<OBJECT number>,8)=<numeric expression>`

**Example:** `OBJ(1,8)=0.07`

**[Parameters]**
- `<OBJECT number>`: the OBJECT number concerned. An integer from −1 to 255.
- `<numeric expression>`: the angle.

**[Return value]** Angle: the rotation angle about the X axis relative to the parent OBJECT.

**[Details]** Specifies the rotation angle about the X axis relative to the parent OBJECT with a numeric expression. The initial value is 0.

**[Example]** Tilts the character "B" 45 degrees towards the viewer.

```
SCREEN 0
SETPFONT 1,66         → 66 is the ASCII code of the character B; 1 means display it as OBJECT 1
OBJ(1,8)=0.125        → tilts it towards the viewer
```

**■ XS, YS, ZS (scale) [OBJZOOM]**

### 12 (X scale: @XS)

*Direct-mode command / Program-mode command / Fixed-point function*

### 13 (Y scale: @YS)

*Direct-mode command / Program-mode command / Fixed-point function*

### 14 (Z scale: @ZS)

*Direct-mode command / Program-mode command / Fixed-point function*

The following describes item number 12. Read it accordingly for 13 and 14.

**Function:** Specifies the XS (scale factor in the X-axis direction) of an OBJECT.

**Syntax:** `OBJ(<OBJECT number>,12)=<numeric expression>`

**Example:**
```
OBJ(1,14)=0           → makes the thickness in the Z direction 0
OBJ(1,12)=2,2,2       → doubles the size of the whole OBJECT
```

**[Parameters]**
- `<OBJECT number>`: the OBJECT number concerned. An integer from −1 to 255.
- `<numeric expression>`: the scale factor.

*[p. 195]*

**[Return value]** Returns the current scale factor in the X-axis direction.

**[Details]** Specifies the scale factor of the OBJECT in the X-axis direction with a numeric expression. The scale of OBJECT 1 and later does not affect their children. The initial value is 1.0. If the size of an OBJECT to be displayed is decided in advance, processing time is shorter if the scale is fixed when it is defined and XS, YS and ZS are left at 1.0. To display the correct scale with an orthographic polygon (OBJECT TYPE = 5) or a sprite (OBJECT TYPE = 7), XS and YS must be set to 0.99995 (&h0.FFFC) rather than 1.

**■ ATR (attribute ID number) [OBJATR]**

### 16 (Attribute ID number: @ATR)

*Direct-mode command / Program-mode command / Fixed-point function*

**Function:** Specifies ATR (the ID number of the face information for sprites or polygons made with the SETATR command).

**Syntax:** `OBJ(<OBJECT number>,16)=<numeric expression>`

**Example:**
```
OBJ NEW                          → initialises the 3D tables (0 entries registered)
SETATR 5,10,(4,1,3,0,7399,8)     → defines 10 faces in attribute ID 5
OBJ(1,16)=5                      → defines attribute ID 5 for OBJECT 1
```

**[Parameters]**
- `<OBJECT number>`: the OBJECT number concerned. An integer from −1 to 255.
- `<numeric expression>`: an integer in the range from 0 to the maximum number of definable attribute IDs − 1.

**[Return value]** Returns the attribute ID last defined (written). Returns −1 if undefined.

**[Details]** Specifies the ID number of the face information for sprites or polygons made with the SETATR command. If an undefined number is given, an Undefined attribute error occurs. The number of attribute faces of the attribute ID number given here must be equal to or greater than the number of polygons of the polygon ID defined for the same OBJECT.

```
アトリビュート面数 >= ポリゴン数
```
(Number of attribute faces >= number of polygons.)

If there are fewer attribute faces, the OBJECT is not displayed. The initial value is −1.

*[p. 196]*

**■ POLYGON (polygon ID number) [OBJATR]**

### 17 (Polygon ID number: @POLYGON)

*Direct-mode command / Program-mode command / Fixed-point function*

**Function:** Specifies POLYGON (the ID number of the position information for polygons made with the SETPOLYGON command).

**Syntax:** `OBJ(<OBJECT number>,17)=<numeric expression>`

**Example:** `OBJ(1,17)=0`

**[Parameters]**
- `<OBJECT number>`: the OBJECT number concerned. An integer from −1 to 255.
- `<numeric expression>`: an integer in the range from 0 to the maximum number of definable polygon IDs − 1.

**[Return value]** Returns the polygon ID last defined. Returns −1 if undefined.

**[Details]** Specifies the ID number of polygons made with the SETPOLYGON command. If an undefined number is given, an Undefined polygon error occurs. The number of attribute faces of the attribute ID number given here must be equal to or greater than the number of polygons of the polygon ID defined for the same OBJECT.

```
アトリビュート面数 >= ポリゴン数
```
(Number of attribute faces >= number of polygons.)

If there are fewer attribute faces, the OBJECT is not displayed. This need not be specified for the 2D sprites of OBJECT types 1, 2 and 3, or when the OBJECT is not displayed. The initial value is −1.

**■ ORDER (move/rotate conversion order)**

### 18 (Move/rotate conversion order: @ORDER)

*Direct-mode command / Program-mode command / Fixed-point function*

**Function:** Specifies ORDER (the conversion order of a 3D OBJECT).

**Syntax:** `OBJ(<OBJECT number>,18)=<numeric expression>`

**Example:** `OBJ(0,18)=7`

**[Parameters]**
- `<OBJECT number>`: the OBJECT number concerned. An integer from −1 to 255.
- `<numeric expression>`: a numeric expression giving one of the values that specify the display method. Valid values are integers from 00 to 11.

**[Return value]** Returns the conversion order currently set, a value from 0 to 11.

*[p. 197]*

**[Details]** A shape defined for an OBJECT is displayed based on the position obtained by translating by the OBJECT's (XP,YP,ZP) from the position of the parent OBJECT and rotating by the OBJECT's (XR,YR,ZR). The displayed position then differs depending on the order of conversion, and the shape may be displayed at an unintended position. This parameter is given to change the order of conversion in such cases. The meanings of the parameter values are as follows.

| Value | Order |
|---|---|
| 00 | T,X,Y,Z |
| 01 | T,X,Z,Y |
| 02 | T,Y,X,Z |
| 03 | T,Y,Z,X |
| 04 | T,Z,X,Y |
| 05 | T,Z,Y,X |
| 06 | X,Y,Z,T |
| 07 | X,Z,Y,T |
| 08 | Y,X,Z,T |
| 09 | Y,Z,X,T |
| 10 | Z,X,Y,T |
| 11 | Z,Y,X,T |

※ T = translation, X = rotation about the X axis, Y = rotation about the Y axis, Z = rotation about the Z axis. The initial value is 0.

**■ TIME (display time)**

### 19 (Display time: @TIME)

*Direct-mode command / Program-mode command / Fixed-point function*

**Function:** Sets the display time (TIME) of an OBJECT.

**Syntax:** `OBJ(<OBJECT number>,19)=<numeric expression>`

**Example:** `OBJ(1,19)=0`

**[Parameters]**
- `<OBJECT number>`: the OBJECT number concerned. An integer from −1 to 255.
- `<numeric expression>`: an integer from 0 to &hFFFF. In fixed-point form, going outside this range does not cause an Overflow error. The part beyond 16 bits of the integer part, and the bits of the fractional part, are ignored.

**[Return value]** Returns the current count value, an integer from 0 to &HFFFF.

**[Details]** Rewrites the display time of an OBJECT. The display time expresses, in VSYNC units, the time elapsed while the OBJECT of `<OBJECT number>` has been connected to OBJECT 0. Counting starts from 0 when the OBJECT is first displayed.

*[p. 198]*

**■ PARENT (parent OBJECT) [OBJLINK]**

### 20 (Link structure: parent OBJECT: @PARENT)

*Direct-mode command / Program-mode command / Fixed-point function*

**Function:** Specifies the association (PARENT) of an OBJECT.

**Syntax:**
```
(1) OBJ(<OBJECT number>,20)=<parent OBJECT number>
(2) OBJ(<OBJECT number>,20)
(3) OBJ PRINT <OBJECT number>[,P]  or
    OBJ ?[ <OBJECT number>][,P]
```

**Example:** `OBJ(1,20)=2` → displays OBJECT 1 based on OBJECT 2.

**[Parameters]**
- `<OBJECT number>`: the OBJECT number concerned. An integer from 1 to 255.
- `<parent OBJECT number>`: the number of the OBJECT with which the OBJECT of `<OBJECT number>` is associated. An integer from −1 to 255.
- `P`: displays one screen and pauses.

**[Return value]** Returns the `<OBJECT number>` of the `<parent OBJECT>` if there is one, or −1 if there is none.

**[Details]**

Syntax (1) associates the OBJECT of `<OBJECT number>` so that it is displayed based on the position of `<parent OBJECT number>`.

Syntax (2) is the syntax as a function.

Syntax (3), in the syntax as a function (sic), displays the relationships of the objects connected as children to `<OBJECT number>`. When the P option is given, it displays [HIT KEY] and stops at the height of the display text WINDOW − 3 lines. Pressing [Ctrl]+[C] interrupts the display.

Normally OBJECT 0 is given as `<parent OBJECT number>` (the world coordinates become the reference). If the previous parent number of `<OBJECT number>` is the same as the new number nothing is done, but when a new `<parent OBJECT number>` is given, the CHILD of `<parent OBJECT number>` is set to `<OBJECT number>`. When the CHILD of `<parent OBJECT number>` is other than −1 (when it has children), for example when you want to display a moon going round an earth going round a sun, specify the following.

```
OBJ(<太陽 OBJECT番号>, 20)=0                    →太陽の親は OBJ 0(ワールド座標)
OBJ(<地球 OBJECT番号>, 20)=<太陽 OBJECT番号>    →地球の親は太陽(太陽を基準に動く)
OBJ(<月   OBJECT番号>, 20)=<地球 OBJECT番号>    →月の親は地球(地球を基準に動く)
```
(太陽 = sun, 地球 = earth, 月 = moon, OBJECT番号 = OBJECT number. The comments read: the sun's parent is OBJ 0 (the world coordinates); the earth's parent is the sun (it moves based on the sun); the moon's parent is the earth (it moves based on the earth).)

*[p. 199]*

Only when −1 is given as `<parent OBJECT number>`, the following is done in addition to the above. First, the contents of OBJECT −1 are copied to all items of `<OBJECT number>` except the connection information (normally this returns it to the initial state). If the CHILD of `<OBJECT number>` is other than −1 (if children are connected), the same is done for the OBJECT numbers from CHILD downwards.

**[About the parent-child relationships of OBJECTs]** The parent-child relationships of OBJECTs represent the display hierarchy used when displaying 3D bodies. Display is done in order from the top downwards. Before any OBJECT is displayed, the matrix set for the line-of-sight direction is, in the example in the figure below, translated by the (XP,YP,ZP) of OBJECT 0 and rotated by (XR,YR,ZR), then translated by the (XP,YP,ZP) of OBJECT 1, the child of OBJECT 0, and rotated by its (XR,YR,ZR), and then rotation and translation are repeated with the parameters of OBJECT 3, the child of OBJECT 1. When a shape is specified for an OBJECT (when its TYPE is 4, 5 or 7), the shape is displayed based on the matrix after the movement.

**[Example of parent-child relationships]**

*[Figure: a tree headed "Top" and ending "Bottom". Under "OBJECTs in use": OBJECT 0 has children OBJECT 1 and OBJECT 2; OBJECT 1 has child OBJECT 3; OBJECT 3 has children OBJECT 4, OBJECT 5 and OBJECT 7; OBJECT 4 has child OBJECT 6. Under "Free OBJECTs": OBJECT −1, under which OBJECT 10 − OBJECT 11 − OBJECT 12 … are chained.]*

| OBJECT \<ID\> | OBJECT number |
|---|---|
| OBJECT 0 | World coordinates |
| OBJECT 0 | Parent of OBJECT 1 and OBJECT 2 |
| OBJECT 1 | Parent of OBJECT 3 |
| OBJECT 3 | Parent of OBJECT 4, OBJECT 5 and OBJECT 7 |
| OBJECT 4 | Parent of OBJECT 6 |
| OBJECT 4, OBJECT 5, OBJECT 7 | Siblings |

*[p. 200]*

To actually produce this state, execute the following commands.

```
FOR I=1 TO 7: OBJ(I,0)=4 : NEXT   → giving TYPE 4 to an unused OBJECT connects it to OBJECT 0
OBJ(3, 20)=1                       → 20 is PARENT (the parent OBJECT number)
OBJ(7, 20)=3
OBJ(4, 20)=3
OBJ(5, 20)=3
OBJ(6, 20)=4

OBJ?
```

Executing this displays the following (the actual display may differ in the order of siblings).

```
      0-> 2
Top   1-> 3-> 5     Bottom
            4-> 6
            7
```

**[Sibling relationships of OBJECTs]**

*[Figure: headed "Top" and ending "Bottom". OBJECT 0 has a line down to OBJECT 1, which is joined horizontally to OBJECT 2 and then to OBJECT 3.]*

| | |
|---|---|
| OBJECT 0 | Parent |
| OBJECT 1 | Eldest son of OBJECT 0 |
| OBJECT 2 | Second son of OBJECT 0 |
| OBJECT 3 | Youngest child of OBJECT 0 |
| ID of the \<child\> of OBJECT 0 | 1 (OBJECT 1 = eldest son) |
| ID of the \<elder sibling\> of OBJECT 1 | −1 (the eldest son has no elder sibling) |
| ID of the \<younger sibling\> of OBJECT 1 | 2 (OBJECT 2) |
| ID of the \<elder sibling\> of OBJECT 2 | 1 (OBJECT 1) |
| ID of the \<younger sibling\> of OBJECT 2 | 3 (OBJECT 3) |
| ID of the \<elder sibling\> of OBJECT 3 | 2 (OBJECT 2) |
| ID of the \<younger sibling\> of OBJECT 3 | −1 (the youngest child has no younger sibling) |
| ID of the \<parent\> of OBJECT 1, OBJECT 2 and OBJECT 3 | OBJECT 0 |

*[p. 201]*

**[State of the OBJECTs immediately after initialisation by the SCREEN command]**

*[Figure: OBJECT −1 has children OBJECT 1 … OBJECT max. Next to it, OBJECT 0 with "none" beneath it.]*

Internally:

- left means the elder sibling and right the younger sibling.
- \<parent\> and child are bidirectional list pointers representing the vertical relationship.
- left and right are bidirectional list pointers representing the horizontal relationship.
- \<parent\> holds the pointer child to the eldest sibling (whose left is NULL).
- The next younger sibling is pointed to by the elder sibling's right, and the youngest sibling's pointer is NULL.
- The \<parent\> of all siblings points to the same parent.

**[About OBJECT 0]** OBJECT 0 is a special OBJECT used to define the world coordinates. All displayed OBJECTs are children of OBJECT 0. For example, if the Y axis of OBJECT 0 is rotated in the default state, the OBJECTs displayed on the screen rotate just like a washing machine. To move the viewpoint or use a camera viewpoint, change XP, YP, ZP, XR, YR, ZR, ORDER and so on of OBJECT 0. The CAMERA command also rewrites the items of OBJECT 0.

```
OBJ(<OBJECT番号>,20) = <親OBJECT番号>
```
(OBJECT番号 = OBJECT number, 親OBJECT番号 = parent OBJECT number.)

Makes the parent of the OBJECT of `<OBJECT number>` the `<parent OBJECT number>`. All the OBJECTs below the OBJECT of `<OBJECT number>` (children and grandchildren) move with it as child OBJECTs of `<parent OBJECT number>`.

*[Figure: OBJECT 0 has children OBJECT 1 and OBJECT 6; OBJECT 1 has child OBJECT 2; OBJECT 2 has children OBJECT 3, OBJECT 4 and OBJECT 5.]*

*[p. 202]*

For example, if OBJECT 6 is the right arm, OBJECT 1 the left arm, OBJECT 2 the hand, and OBJECT 3, OBJECT 4 and OBJECT 5 the fingers, to create the state in the figure above:

```
OBJ(6,20)=0     ワールド座標にOBJECT 6を結び付ける
OBJ(1,20)=0     ワールド座標にOBJECT 1を結び付ける
OBJ(2,20)=1     OBJECT 2の親はOBJECT 1
OBJ(3,20)=2     OBJECT 3の親はOBJECT 2
OBJ(4,20)=2     OBJECT 4の親はOBJECT 2
OBJ(5,20)=2     OBJECT 5の親はOBJECT 2
```
(The comments read: attach OBJECT 6 to the world coordinates; attach OBJECT 1 to the world coordinates; the parent of OBJECT 2 is OBJECT 1; the parent of OBJECT 3, 4 and 5 is OBJECT 2.)

Executing `OBJ(2,20)=6` in this state gives the following.

*[Figure: OBJECT 0 has children OBJECT 1 and OBJECT 6; OBJECT 6 has child OBJECT 2; OBJECT 2 has children OBJECT 3, OBJECT 4 and OBJECT 5.]*

You can also make an OBJECT its own parent, or register its own child or grandchild as its parent, but when the connections loop like this, the OBJECT can no longer be reached from OBJECT 0, so its display simply stops. To display it again, just give OBJECT 0 as its parent. While it is not displayed, movement, rotation, contact testing and so on are not performed, as for an unused OBJECT.

*[Figure: OBJECT 0 above OBJECT 1, with an arrow from OBJECT 1 looping back to itself.]*

**[Example]**

```
SETPFONT 1,65     → displays "A" using OBJECT 1
OBJ(1,20)=1       → the OBJECTs connected to OBJECT 1 are no longer displayed
OBJ(1,20)=0       → they are displayed again
```

*[p. 203]*

**[About OBJECT −1]**

```
OBJ(<OBJECT番号>,20) = -1
```
(OBJECT番号 = OBJECT number.)

OBJECT ID −1 is a special OBJECT used to hold unused OBJECTs. In the initial state, all OBJECTs other than OBJECT 0 are connected as children of OBJECT −1. To return a displayed OBJECT to its initial values, give OBJECT −1 as its parent. For example, if OBJECT −1 is registered as the parent of OBJECT 2 in the arm model above, the OBJECTs OBJECT 2, OBJECT 3, OBJECT 4 and OBJECT 5 are returned to their initial values. When a used OBJECT is connected to OBJECT −1, the structure of grandchildren and below connected to its children is destroyed, and they all become siblings.

```
OBJ(2,20)=-1
```

To remove only OBJECT 2 and keep its children, connect OBJECT 3, OBJECT 4 and OBJECT 5 to OBJECT 6 and then remove OBJECT 2.

```
OBJ(3,20)=6       OBJECT 2の子供をOBJECT 2の親とつなげてから
OBJ(4,20)=6
OBJ(5,20)=6
OBJ(2,20)=-1      OBJECT 2を消去する
```
(The comments read: after connecting the children of OBJECT 2 to the parent of OBJECT 2 … delete OBJECT 2.)

**[How to examine the connections]**

```
N = OBJ(<OBJECT番号>,20)
```

Returns the ID of the parent of `<OBJECT number>`.

```
N = OBJ(<OBJECT番号>,21)
```

To get a free OBJECT number, look up the number of the first child of OBJECT −1. Returns the first child of `<ID>`. If there are no children, returns −1. If you know the OBJECT number you most want to use, you can use any OBJECT number.

```
N = OBJ(<OBJECT番号>,22)
```

Returns the ID of the elder sibling of `<OBJECT number>`. For example, one way to examine all the siblings of the OBJECT of a given `<OBJECT number>` is:

```
N0 = OBJ(<OBJECT番号>,20) →N0は 親IDを表す。
N1 = OBJ(N0,21)           →親N0の最初の子供を調べる。
N2 = OBJ(N1,23)           →N1の次の弟を調べる。-1なら弟はいない。
N3 = OBJ(N2,23)           →N2の次の弟を調べる。-1なら弟はいない。
...
```
(OBJECT番号 = OBJECT number. The comments read: N0 is the parent ID; look up the first child of parent N0; look up the next younger sibling of N1, and if −1 there is no younger sibling; the same for N2.)

and so on. There is also a way of examining them using the fact that the value of the eldest son's \<elder sibling\> is −1.

**[Caution]** Objects whose parent-child generations exceed 16 are not displayed, because of an internal stack limit.

*[p. 204]*

**■ CHILD (child OBJECT)**

### 21 (Link structure: child OBJECT: @CHILD)

*Fixed-point function*

**Function:** Returns the association (CHILD) of an OBJECT.

**Syntax:** `OBJ(<OBJECT number>,21)`

**Example:** `IF OBJ(1,21) <> -1 THEN BEEP` → sounds BEEP if a child is connected to OBJECT 1.

**[Parameters]**
- `<OBJECT number>`: the number of the OBJECT whose child is examined. An integer from −1 to 255.

**[Return value]** Returns the first `<OBJECT number>` if there is a `<child OBJECT>`, or −1 if there is none. For details, see [About the parent-child relationships of OBJECTs] under `<item number>`=20.

**[Details]** Examines whether a `<child OBJECT>` is connected to the OBJECT of `<OBJECT number>`, and returns its `<OBJECT number>`. A child is an OBJECT in the level below `<OBJECT number>`. A child OBJECT is displayed based on the position of the parent `<OBJECT number>`. If several children are connected to `<OBJECT number>`, the OBJECT number of the first child (the eldest) is returned.

**■ LEFT (elder sibling OBJECT)**

### 22 (Link structure: elder sibling OBJECT: @LEFT)

*Fixed-point function*

**Function:** Returns the association (LEFT) of an OBJECT.

**Syntax:** `OBJ(<OBJECT number>,22)`

**Example:** `? OBJ(1,22)`

**[Parameters]**
- `<OBJECT number>`: the number of the OBJECT whose elder sibling OBJECT is examined. An integer from −1 to 255.

**[Return value]** Returns the `<OBJECT number>` if an elder sibling OBJECT is connected, or −1 if there is none.

**[Details]** Examines whether an elder sibling OBJECT is connected to the OBJECT of `<OBJECT number>`, and returns its `<OBJECT number>`. An elder sibling is an OBJECT at the same level connected to the same parent. Sibling OBJECTs are displayed based on the position and angle of the parent OBJECT, and the positions

*[p. 205]*

and angles of siblings operate independently of each other. Also, when several OBJECTs are connected to the same parent, they are automatically connected as sibling OBJECTs. In normal operation, all displayed OBJECTs are connected as children of OBJECT 0, as siblings at the same level.

**■ RIGHT (younger sibling OBJECT)**

### 23 (Link structure: younger sibling OBJECT: @RIGHT)

*Fixed-point function*

**Function:** Returns the association (RIGHT) of an OBJECT.

**Syntax:** `OBJ(<OBJECT number>,23)`

**Example:** `? OBJ(1,23)`

**[Parameters]**
- `<OBJECT number>`: the number of the OBJECT whose younger sibling OBJECT is examined. An integer from −1 to 255.

**[Return value]** Returns its `<OBJECT number>` if a younger sibling OBJECT is connected, or −1 if there is none. For details, see [About the parent-child relationships of OBJECTs] under `<item number>`=20.

**[Details]** Examines whether a younger sibling OBJECT is connected to the OBJECT of `<OBJECT number>`, and returns its `<OBJECT number>`. A younger sibling is an OBJECT at the same level connected to the same parent. Sibling OBJECTs are displayed based on the position and angle of the parent OBJECT, and the positions and angles of siblings operate independently of each other.

**■ XV, YV, ZV (speed)**

### 24 (X speed: @XV)

*Direct-mode command / Program-mode command / Fixed-point function*

### 25 (Y speed: @YV)

*Direct-mode command / Program-mode command / Fixed-point function*

### 26 (Z speed: @ZV)

*Direct-mode command / Program-mode command / Fixed-point function*

The following describes item number 24. Read it accordingly for 25 and 26.

**Function:** Gives the value (XV) added to the X coordinate of an OBJECT.

**Syntax:** `OBJ(<OBJECT number>,24)=<numeric expression>`

**Example:**
```
OBJ(1,24)=0.2
OBJ(1,24)=0.2, 1, 0
```

*[p. 206]*

**[Parameters]**
- `<OBJECT number>`: the OBJECT number concerned. An integer from −1 to 255.
- `<numeric expression>`: the speed. Gives, as a numeric expression, the value added to the X coordinate at each VSYNC.

**[Return value]** Returns the current speed, the value added to XP at each VSYNC.

**[Details]** Gives the value added to XP at each VSYNC. The initial value is 0. Once a value is given here, the OBJECT keeps moving, so the program must take responsibility for stopping it.

**■ XA, YA, ZA (acceleration)**

### 28 (X acceleration: @XA)

*Direct-mode command / Program-mode command / Fixed-point function*

### 29 (Y acceleration: @YA)

*Direct-mode command / Program-mode command / Fixed-point function*

### 30 (Z acceleration: @ZA)

*Direct-mode command / Program-mode command / Fixed-point function*

The following describes item number 28. Read it accordingly for 29 and 30.

**Function:** Gives the acceleration (XA) added to the X speed (XV) of an OBJECT.

**Syntax:** `OBJ(<OBJECT number>,28)=<numeric expression>`

**Example:**
```
OBJ(1,32)=4                    → sets the maximum speed to 4 dots per VSYNC
OBJ(1,28)=0.01                 → gives an acceleration in the positive direction of the X axis
OBJ(1,28)=0.01,0.01,0.01       → gives an acceleration of 0.01 in each of the positive X, Y and Z directions
```

**[Parameters]**
- `<OBJECT number>`: the OBJECT number concerned. An integer from −1 to 255.
- `<numeric expression>`: the acceleration. Gives, as a numeric expression, the value added to the X speed at each VSYNC.

**[Return value]** Returns the current acceleration, the value added to the X speed (XV) at each (VSYNC).

*[p. 207]*

**[Details]** Gives the value added to XV at each VSYNC. The initial value is 0. When XA is specified, the maximum speed must be given in XL beforehand. Once a value is given here, the OBJECT keeps moving, so the program must take responsibility for stopping it.

```
XV = XV + XA
IF (XV < 0) AND (XV < -XL) THEN XV = -XL
IF (XV > 0) AND (XV > +XL) THEN XV = +XL
```

**■ XL, YL, ZL (speed limiter)**

### 32 (X speed limiter: @XL)

*Direct-mode command / Program-mode command / Fixed-point function*

### 33 (Y speed limiter: @YL)

*Direct-mode command / Program-mode command / Fixed-point function*

### 34 (Z speed limiter: @ZL)

*Direct-mode command / Program-mode command / Fixed-point function*

The following describes item number 32. Read it accordingly for 33 and 34.

**Function:** Specifies that the absolute value of the X speed (XV) of an OBJECT must not exceed this value.

**Syntax:** `OBJ(<OBJECT number>,32)=<numeric expression>`

**Example:**
```
OBJ(1,32)=3
OBJ(1,32)=3,3,3   → sets the speed limiter of each of X, Y and Z to 3
```

**[Parameters]**
- `<OBJECT number>`: the OBJECT number concerned. An integer from −1 to 255.
- `<numeric expression>`: the speed.

**[Return value]** The speed limit value. The limit value of the X speed (XV) of the OBJECT.

**[Details]** When XA is other than 0 and the value of XA (acceleration) is added to XV (speed) at each VSYNC, limits the absolute value of XV so that it does not exceed XL. When XA is 0, XL has no effect on XV. The initial value of XA is 0.

```
XV = XV + XA
IF (XV < 0) AND (XV < -XL) THEN XV = -XL
IF (XV > 0) AND (XV > +XL) THEN XV = +XL
```

*[p. 208]*

**■ XRV, YRV, ZRV (rotation speed) [OBJTURN]**

### 36 (X rotation speed: @XRV)

*Direct-mode command / Program-mode command / Fixed-point function*

### 37 (Y rotation speed: @YRV)

*Direct-mode command / Program-mode command / Fixed-point function*

### 38 (Z rotation speed: @ZRV)

*Direct-mode command / Program-mode command / Fixed-point function*

The following describes item number 36. Read it accordingly for 37 and 38.

**Function:** Gives the value added to the XR (rotation angle about the X axis) of an OBJ.

**Syntax:** `OBJ(<OBJECT number>,36)=<numeric expression>`

**Example:** `OBJ(1,36)=0.01`

**[Parameters]**
- `<OBJECT number>`: the OBJECT number concerned. An integer from −1 to 255.
- `<numeric expression>`: the angular speed.

**[Return value]** Angular speed. The X rotation speed of the OBJECT.

**[Details]** Gives the value added to XR at each VSYNC. The initial value is 0. Once a value is given here, the OBJECT keeps rotating, so the program must take responsibility for stopping it.

**■ XP0, YP0, XP1, YP1, XP2, YP2, XP3, YP3 (4-point sprite vertices)**

### 48 (4-point sprite vertex X0: @XP0)

*Direct-mode command / Program-mode command / Fixed-point function*

### 49 (4-point sprite vertex Y0: @YP0)

*Direct-mode command / Program-mode command / Fixed-point function*

### 50 (4-point sprite vertex X1: @XP1)

*Direct-mode command / Program-mode command / Fixed-point function*

### 51 (4-point sprite vertex Y1: @YP1)

*Direct-mode command / Program-mode command / Fixed-point function*

*[p. 209]*

### 52 (4-point sprite vertex X2: @XP2)

*Direct-mode command / Program-mode command / Fixed-point function*

### 53 (4-point sprite vertex Y2: @YP2)

*Direct-mode command / Program-mode command / Fixed-point function*

### 54 (4-point sprite vertex X3: @XP3)

*Direct-mode command / Program-mode command / Fixed-point function*

### 55 (4-point sprite vertex Y3: @YP3)

*Direct-mode command / Program-mode command / Fixed-point function*

**Function:** Specifies the positions for displaying a 2D sprite of TYPE=3 (4-point specification).

**Syntax:**
```
OBJ(<OBJECT number>,48)=<numeric expression>
OBJ(<OBJECT number>,49)=<numeric expression>
OBJ(<OBJECT number>,50)=<numeric expression>
OBJ(<OBJECT number>,51)=<numeric expression>
OBJ(<OBJECT number>,52)=<numeric expression>
OBJ(<OBJECT number>,53)=<numeric expression>
OBJ(<OBJECT number>,54)=<numeric expression>
OBJ(<OBJECT number>,55)=<numeric expression>
```

**Example:** `OBJ(1,48)= -10,-10, +10,-10, +10,+10, -10,+10` → specifies the 4 vertices at once.

**[Parameters]**
- `<OBJECT number>`: the OBJECT number concerned. An integer from −1 to 255.
- `<numeric expression>`: a coordinate.

**[Return value]** The coordinate is the position of each vertex written.

**[Details]** When the OBJECT type is the 2D sprite display of TYPE=3, specifies the positions of the 4 points of the sprite. The 4 points are given as positions relative to the X position (XP) and Y position (YP), in the order top left (XP0,YP0), top right (XP1,YP1), bottom right (XP2,YP2), bottom left (XP3,YP3) (clockwise). By changing the order in which they are given, effects such as rotation, flipping, enlargement, reduction and twisting can be applied to the sprite. The items used in the OBJ() structure are as follows.

*[p. 210]*

| Item | Meaning |
|---|---|
| XP | Position on screen, relative to the CX parameter of SPRWINDOW |
| YP | Position on screen, relative to the CY parameter of SPRWINDOW |
| ZP | Priority against polygons by Z position |
| ATR | Attribute ID made with the SETATR command |
| XP0,YP0 | Position of the 4 points of the sprite relative to XP,YP |
| XP1,YP1 | 〃 |
| XP2,YP2 | 〃 |
| XP3,YP3 | 〃 |

It is not affected by rotation or translation.

**■ XD, YD, ZD, RD (position on screen)**

### 56 (X position projected on screen: @XD)

*Fixed-point function*

### 57 (Y position projected on screen: @YD)

*Fixed-point function*

### 58 (Z position from screen: @ZD)

*Fixed-point function*

### 59 (RADIUS/ZD: @RD)

*Fixed-point function*

The following describes item number 56. Read it accordingly for 57 to 59.

**Function:** Reads the coordinates at which an OBJECT is projected onto the screen.

**Syntax:** `OBJ(<OBJECT number>,56)`

**Example:**
```
FLAG = 1
OBJ(1, FLAG)=4                       → sets the flag so the values can be read
CIRCLE (OBJ(1,56),OBJ(1,57)),10      → draws a circle centred on the OBJECT's display position
```

**[Parameters]**
- `<OBJECT number>`: the OBJECT number concerned. An integer from −1 to 255.

**[Return value]** A fixed-point number.

*[p. 211]*

**[Details]** When bit 2 of FLAG is "1", the position on screen when the OBJECT has been perspective-transformed onto the screen is written to XD and YD, taking the top left (0,0) as the reference; the Z distance of the OBJECT is written to ZD, and the OBJECT's radius/Z distance to RD. The position of an OBJECT that would be projected off the screen is also returned, but the values are not guaranteed if it is far off the screen. To read these values, you must wait at least 1 VSYNC after setting the value. The values are valid for OBJECTs of TYPE 4, 5, 6 and 7.

**■ GTEST (collision-test group setting)**

### 60 (Collision-test group setting: @GTEST)

*Direct-mode command / Program-mode command / Fixed-point function*

**Function:** Specifies the collision-test group.

**Syntax:** `OBJ(<OBJECT number>,60)=<numeric expression>`

**Example:** `OBJ(1,60)=1` → starts testing for collision with the group belonging to bit 0.

**[Parameters]**
- `<OBJECT number>`: the OBJECT number concerned. An integer from −1 to 255.
- `<numeric expression>`: the collision-test group bits.

**[Return value]** Fixed-point. The 16-bit value written.

**[Details]**

Holds a 16-bit value and is used to specify the groups for collision testing. When a value other than 0 is written here, contact testing between this OBJECT and other OBJECTs starts.

Each bit represents one group, and collision is tested with other displayed OBJECTs that have the same bit set to 1. Several groups can be examined together, but only the first OBJECT collided with can be detected. The results of the test are stored in "contact flag and its distance" (COLIDIST) and "number of the OBJECT contacted" (COLIOBJ).

The test algorithm is as follows.

- For all displayed OBJECTs (TYPE=4, TYPE=5, TYPE=6, TYPE=7),
- other than itself and the WORLD OBJECT (0),
- for OBJECTs where the AND of this OBJECT's GTEST and the examined OBJECT's GROUP is other than 0,
- when the distance between the 2 OBJECTs is equal to or less than the sum of their radii.

```
SQR((OBJ1_X-OBJ2_X)^2 + (OBJ1_Y-OBJ2_Y)^2 + (OBJ1_Z-OBJ2_Z)^2) <=
SQR(OBJ1_RADIUS+OBJ2_RADIUS)
```

The initial value is 0, meaning no contact testing.

*[p. 212]*

**■ RADIUS (radius for contact test)**

### 61 (Radius for contact test: @RADIUS)

*Direct-mode command / Program-mode command / Fixed-point function*

**Function:** Specifies the collision radius used by GTEST.

**Syntax:** `OBJ(<OBJECT number>,60)=<numeric expression>` (sic: the item number is 61)

**Example:** `OBJ(1,61)=20`

**[Parameters]**
- `<OBJECT number>`: the OBJECT number concerned. An integer from −1 to 255.
- `<numeric expression>`: the radius.

**[Return value]** Distance. Returns the current radius.

**[Details]** Distance. Specifies the radius of the OBJECT for collision testing. The initial value is 10.0.

**■ COLIDIST (contact flag and its distance)**

### 62 (Contact flag and its distance: @COLIDIST)

*Fixed-point function*

**Function:** Examines the result of an OBJECT's collision test.

**Syntax:** `OBJ(<OBJECT number>,62)`

**Example:** `IF OBJ(1,62) <> -1 THEN ?"COLLISION DISTANCE=";OBJ(1,62)`

**[Parameters]**
- `<OBJECT number>`: the OBJECT number concerned. An integer from −1 to 255.

**[Return value]** Fixed-point. The result of the GTEST contact test is stored here.

**[Details]** −1 is stored when there is no contact, and the distance to the OBJECT contacted when it is 0 or more. Once contact has occurred, no collision test is done until a value is written to GTEST again (this is also to keep in step with BASIC).

*[p. 213]*

**■ COLIOBJ (number of the OBJECT contacted)**

### 63 (Number of the OBJECT contacted: @COLIOBJ)

*Fixed-point function*

**Function:** Gets the OBJECT number of the other party collided with in an OBJECT's collision test.

**Syntax:** `OBJ(<OBJECT number>,63)`

**Example:** `IF OBJ(1,63) <> -1 THEN ?"COLLSION OBJECT=";OBJ(1,63)`

**[Parameters]**
- `<OBJECT number>`: the OBJECT number concerned. An integer from −1 to 255.

**[Return value]** Fixed-point. Gets the OBJECT number of the other party collided with.

**[Details]** When the contact test flag (COLIDIST) is 0 or more, the number of the OBJECT contacted is written here.

**■ M00 to M32 (matrix at perspective transformation)**

### 64 (Matrix at perspective transformation M00)

*Fixed-point function*

### 65 (Matrix at perspective transformation M01)

*Fixed-point function*

### 66 (Matrix at perspective transformation M02)

*Fixed-point function*

### 67 (Matrix at perspective transformation M10)

*Fixed-point function*

### 68 (Matrix at perspective transformation M11)

*Fixed-point function*

### 69 (Matrix at perspective transformation M12)

*Fixed-point function*

### 70 (Matrix at perspective transformation M20)

*Fixed-point function*

### 71 (Matrix at perspective transformation M21)

*Fixed-point function*

*[p. 214]*

### 72 (Matrix at perspective transformation M22)

*Fixed-point function*

### 73 (Matrix at perspective transformation M30)

*Fixed-point function*

### 74 (Matrix at perspective transformation M31)

*Fixed-point function*

### 75 (Matrix at perspective transformation M32)

*Fixed-point function*

The following describes item number 64. Read it accordingly for 65 to 75.

**Function:** Reads the matrix values of an OBJECT at perspective transformation.

**Syntax:** `OBJ(<OBJECT number>,64)`

**Example:** `?XATN(OBJ(2,73)-OBJ(1,73), OBJ(2,75)-OBJ(1,75))` → finds the direction in the XZ plane of OBJECT 2 as seen from OBJECT 1.

**[Parameters]**
- `<OBJECT number>`: the OBJECT number concerned. An integer from −1 to 255.

**[Return value]** The matrix value at perspective transformation.

**[Details]**

When bit 0 of FLAG is "1", the translation components of the matrix at perspective transformation are written to M30 to M32. To read the values of M30 to M32, you must wait at least 1 VSYNC after setting the value. This flag automatically becomes "1" when the collision-test setting (GTEST) is set to a value other than 0.

Note that the coordinates used for an OBJECT's hit detection (M30, M31, M32) are strictly coordinates from the viewpoint, and differ from coordinates relative to OBJECT 0 (in the sense that a matrix operation between the unit vector of the line of sight and OBJECT 0 comes in between). In the standard state, the ZP value of OBJECT 0, 200, is added in the Z direction. When bit 1 is "1", the whole matrix at perspective transformation (4×3) is saved in M00 to M32. To read these values, you must wait at least 1 VSYNC after setting the value.

```
M00  M01  M02
M10  M11  M12
M20  M21  M22
M30  M31  M32   → translation components
```

M30 to M32 are the centre position of the OBJECT relative to the viewpoint, and are also used for collision testing.

*[p. 215]*

### OBJATR

*Direct-mode command / Program-mode command*

**Function:** Specifies the attribute ID and polygon ID of an OBJECT.

**Syntax:** `OBJATR <OBJECT number>[,<polygon ID number>][,<attribute ID>]`

**Example:** `OBJATR 1,1,4`

**[Parameters]**
- `<OBJECT number>`: the OBJECT number concerned. An integer from 1 to 255.
- `<attribute ID>`: an integer in the range from 0 to the maximum number of definable attribute IDs − 1.
- `<polygon ID>`: an integer in the range from 0 to the maximum number of definable polygon IDs − 1.

**[Details]**

Specifies the attribute ID and polygon ID for an OBJECT. The attribute ID holds the information on each face of a polygon made with the SETATR command, and the polygon ID holds the shape information of a polygon made with the SETPOLYGON command.

`<attribute ID>` and `<polygon ID number>` can be omitted by separating them with ",", but at least one must be given. This command is an alias of `OBJ(<OBJECT number>,16)=<numeric expression>...` and behaves the same way.

**[See also]** The ATR (16) and POLYGON (17) items of the OBJ command.

### OBJLINK

*Direct-mode command / Program-mode command*

**Function:** Specifies the "parent-child relationship" of an OBJECT.

**Syntax:** `OBJLINK <OBJECT number>,<parent OBJECT number>`

**Example:** `OBJLINK 1,2` → makes the parent of OBJECT 1 OBJECT 2.

**[Parameters]**
- `<OBJECT number>`: the OBJECT number concerned. An integer from 1 to 255.
- `<parent OBJECT number>`: the number of the OBJECT with which the OBJECT of `<OBJECT number>` is associated. An integer from −1 to 255.

**[Details]** Makes the parent OBJECT of the OBJECT of `<OBJECT number>` the `<parent OBJECT number>`. If child OBJECTs are connected to `<OBJECT number>`, all the child OBJECTs are also connected to the OBJECT of `<parent OBJECT number>`. If `<parent OBJECT number>` is −1, the parent-child structure of all the OBJECTs from the children of `<OBJECT number>`

*[p. 216]*

downwards is discarded and the values of OBJECT −1 are copied (normally they return to the unused state). This command is an alias of `OBJ(<OBJECT number>,20)=<numeric expression>...` and behaves the same way.

**[See also]** The PARENT (20) item of the OBJ command.

### OBJPOS

*Direct-mode command / Program-mode command*

**Function:** Specifies the "relative position" from the parent OBJECT.

**Syntax:** `OBJPOS <OBJECT number>,[<X position>],[<Y position>],[<Z position>]`

**Example:**
```
OBJPOS 1,200      → sets the X position of OBJECT 1 to 100
OBJPOS 1,,,300    → sets the ZP of OBJECT 1 to 300
```
(The first example sets 200, although the comment says 100 (sic).)

**[Parameters]**
- `<OBJECT number>`: the OBJECT number concerned. An integer from −1 to 255.
- `<X position>`, `<Y position>`, `<Z position>`: coordinates.

**[Details]** Specifies the X-, Y- and Z-coordinate distances from the parent OBJECT with numeric expressions. `<X position>`, `<Y position>` and `<Z position>` can be omitted by separating them with ",", but at least one must be given. This command is an alias of `OBJ(<OBJECT number>,4)=<numeric expression>...` and behaves the same way.

**[See also]** The XP (4), YP (5) and ZP (6) items of the OBJ command.

### OBJROT

*Direct-mode command / Program-mode command*

**Function:** Specifies the "rotation angle" relative to the angle of the parent OBJECT.

**Syntax:** `OBJROT <OBJECT number> [,<X-axis angle>][,<Y-axis angle>][,<Z-axis angle>]`

**Example:** `OBJROT 1,,0.5` → rotates OBJECT 1 by 180 degrees about the Y axis of the parent OBJECT.

**[Parameters]**
- `<OBJECT number>`: the OBJECT number concerned. An integer from −1 to 255.
- `<X-axis angle>`, `<Y-axis angle>`, `<Z-axis angle>`: angles.

**[Details]** Specifies the rotation angles about the X, Y and Z axes relative to the parent OBJECT with numeric expressions. `<X-axis angle>`, `<Y-axis angle>` and `<Z-axis angle>` can be omitted by separating them with ",", but at least one must be

*[p. 217]*

given. This command is an alias of `OBJ(<OBJECT number>,8)=<numeric expression>...` and behaves the same way.

**[See also]** The XR (8), YR (9) and ZR (10) items of the OBJ command.

### OBJTURN

*Direct-mode command / Program-mode command*

**Function:** Specifies the "rotation angle" relative to the angle of the parent OBJECT.

**Syntax:** `OBJTURN <OBJECT number>,[<X-axis angular speed>],[<Y-axis angular speed>],[<Z-axis angular speed>]`

**Example:** `OBJTURN 1,,,&H0.01` → rotates OBJECT 1 in the Z-axis direction.

**[Parameters]**
- `<OBJECT number>`: the OBJECT number concerned. An integer from −1 to 255.
- `<X-axis angular speed>`, `<Y-axis angular speed>`, `<Z-axis angular speed>`: angular speeds.

**[Details]** Specifies the values added to the X-axis, Y-axis and Z-axis angles at each VSYNC. When a value other than 0 is given, an OBJECT connected to OBJECT 0 keeps rotating. `<X-axis angular speed>`, `<Y-axis angular speed>` and `<Z-axis angular speed>` can be omitted by separating them with ",", but at least one must be given. This command is an alias of `OBJ(<OBJECT number>,36)=<numeric expression>...` and behaves the same way.

**[See also]** The XRV (36), YRV (37) and ZRV (38) items of the OBJ command.

### OBJTYPE

*Direct-mode command / Program-mode command*

**Function:** Specifies the OBJECT type.

**Syntax:** `OBJTYPE <OBJECT number>,<TYPE>`

**Example:** `OBJTYPE 1,4` → displays OBJECT 1 as a polygon.

**[Parameters]**
- `<OBJECT number>`: the OBJECT number concerned. An integer from 1 to 255.
- `<TYPE>`: a numeric expression giving one of the values that specify the display method. Valid values are integers from 0 to 7. Anything after the decimal point is cut off.

**[Details]** This command is an alias of `OBJ(<OBJECT number>,0)=<numeric expression>...` and behaves the same way.

*[p. 218]*

**[See also]** The TYPE (0) item of the OBJ command.

### OBJZOOM

*Direct-mode command / Program-mode command*

**Function:** Specifies the "display scale" of an OBJECT.

**Syntax:** `OBJZOOM <OBJECT number>,[<X-axis scale>],[<Y-axis scale>],[<Z-axis scale>]`

**Example:** `OBJZOOM 1,2,2,2` → doubles the display size of OBJECT 1.

**[Parameters]**
- `<OBJECT number>`: the OBJECT number concerned. An integer from −1 to 255.
- `<X-axis scale>`, `<Y-axis scale>`, `<Z-axis scale>`: scale factors.

**[Details]** Specifies the scale factors of the OBJECT in the X-, Y- and Z-axis directions with numeric expressions. The scale of OBJECT 1 and later does not affect child OBJECTs. Changing the scale does not change the normal vectors. To display the correct scale with an orthographic polygon (OBJECT TYPE=5) or a sprite (OBJECT TYPE=7), XS and YS must be set to 0.99995 (&h0.FFFC) rather than 1. `<X-axis scale>`, `<Y-axis scale>` and `<Z-axis scale>` can be omitted by separating them with ",", but at least one must be given. This command is an alias of `OBJ(<OBJECT number>,12)=<numeric expression>...` and behaves the same way.

**[See also]** The XS (12), YS (13) and ZS (14) items of the OBJ command.

### SETATR

*Direct-mode command / Program-mode command*

**Function:** Defines the attributes given to each face of a polygon.

**Syntax:**
```
(1) SETATR [<attribute ID>],<number of attributes>[,(<parameter 1>)][,(<parameter 2>)...]
(2) SETATR (<parameter 1>)[,(<parameter 2>)...]
(3) SETATR <attribute ID>,<number of attributes>,READ
    ...
    DATA (<parameter>)[,(<parameter>)...]
    ...
```

**Example:**
```
(1)SETATR 1,1,(0,1,3,1,0,0)
(2)SETATR (0,1,3,1,0,0)
(3)SETATR 1,1,READ
```

*[p. 219]*

**[Parameters]** Each `<parameter>` corresponds one-to-one with a face of the polygon defined by SETPOLYGON, and specifies how that face is displayed.
- `<attribute ID>`: the group number of the attributes to define, from 0 upwards.
- `<number of attributes>`: the number of attributes defined in this group. It must be equal to or greater than the number of faces of the target polygon defined by SETPOLYGON.
- `<parameter>`: the attribute parameters (`<TYPE>`, `<SURFACE>`, `<SORT>`, `<texture ID>`, `<COLOR>`, `<MODE>`). See [Details].
- `<READ>`: reads the parameters from DATA statements.

**[Details]**

In syntax (1), new attributes are created. If `<attribute ID>` is omitted, the smallest definable group number is assigned. This number can be read with the ATRID(−1) function. If no more `<attribute ID>`s can be registered, an Attribute ID over error occurs.

When syntax (2) is used, writing continues from where the last defined attribute ended. When the rest of the data is written to the attribute table address being written, an Undefined attribute error occurs if the address is undefined. Trying to define more than the given number of attributes causes an Attribute data over error.

In syntax (3), attribute data defined in DATA statements is defined instead of a string. The data must be defined in DATA statements in the amount needed for the definition. If there is not enough data, an Out of DATA error occurs. When registering new data, the `<attribute ID>` is registered only if no error occurred during the definition. When registering existing data, the data up to the point where the error occurred may be registered.

`<TYPE>`: shows the state of the polygon.

| Value | Meaning |
|---|---|
| 0 | Texture display, no flip |
| 1 | Texture display, flipped left-right |
| 2 | Texture display, flipped top-bottom |
| 3 | Texture display, flipped top-bottom and left-right |
| 4 | Polygon |
| 5 | Polyline display |
| 6 | Straight line through the first 2 points |

*[p. 220]*

`<SURFACE>`: specifies how (POLYGON, TEXTURE) is displayed.

| Value | Meaning |
|---|---|
| 0 | One-sided (polygons facing away, judged by the normal vector, are not displayed) |
| 1 | Two-sided |

`<SORT>`: specifies the reference point used to sort polygon faces.

| Value | Meaning |
|---|---|
| 0 | Use the position of the Polygon displayed just before |
| 1 | Use the nearest of the 4 points |
| 2 | Use the farthest of the 4 points |
| 3 | Use the average position of the 4 points |

`<texture ID>`: specifies the texture ID, defined by SETTEX, to paste onto the polygon face. The texture ID must already be defined. A polygon with a texture is the same as what is generally called a sprite. Ignored if `<TYPE>` is not a texture. The priority of the face can also be specified by adding the value of a priority register to `<texture ID>` (see the PRIORITY command).

`<COLOR>`: when `<TYPE>` is a texture (0, 1, 2, 3) and its number of colours (the number of colours of the texture of `<texture ID>`) is 16 or 256, specifies the palette number. The palette number is given as follows. Multiples of 16 or 256 are used so that the same area can be shared by attributes with different numbers of colours.

If the texture has 16 colours, give a multiple of 16:

```
Palette 0  = 0
Palette 1  = 16
Palette 2  = 32
...
Palette 31 = 496
```

If the texture has 256 colours, a multiple of 256:

```
Palette 0 = 0
Palette 1 = 256
```

Addresses 0 to 511 of the sprite palette are obtained with the following formula.

```
<パレット番号>+<テクスチャのドットのカラーコード>
```
(\<palette number\> + \<colour code of the texture dot\>.)

A total of 512 colours are allocated to the sprite palette, shared by 16-colour textures, 256-colour textures and polygons that use a palette.

To change the colour data of the sprite palette, use `PALETTE 10, ....` (numbers 10 and up are the logical BG numbers for sprites). When `<TYPE>` is a plain polygon (4, 5, 6), give an RGB colour. The colour format is the same as the RGB function. RGB data is the value `<R>+<G>×32+<B>×32×32`, each colour taking a value from 0 to 31. When `<TYPE>` (sic) is a 32768-colour texture, the full colour can be decided on the texture side, so

*[p. 221]*

set `<COLOR>` to 0 (it is ignored).

`<MODE>`: sets the various drawing modes of the polygon. Normally set to 0.

| Bits | Meaning |
|---|---|
| Bits 0 and 1 | Drawing mode: 0 = overwrite mode; 1 = shadow mode; 2 = half-luminance mode; 3 = semi-transparent mode |
| Bit 3 | Polygon affected by the light source (uses the normal vector). Limited to RGB-specified textures or polygons. |
| Bit 5 | Uses a palette for the polygon colour |
| Bits 6 and 7 | Window mode: 0 = not restricted by the window; 1 = displayed inside the window (default); 2 = displayed outside the window |
| Bit 8 | Mesh display |

For example, semi-transparent mode is 3 (or &H03, &B00000011), and mesh display is 256 (or &H100, &B100000000).

As a rule, `<attribute ID>`s are defined in order from 0. For example, if ID 2 is defined after ID 0, ID 1 cannot be defined afterwards. When registration of attributes is started with syntax (1), `<parameter 1>` is applied to all the attribute data of the `<attribute ID>` reserved by SETATR. When a new `<attribute ID>` is reserved with syntax (1) with the parameters omitted, all the data of the `<attribute ID>` is first initialised with the following data.

| Parameter | Initial value |
|---|---|
| `<TYPE>` | =4 (polygon) |
| `<SURFACE>` | =1 (two-sided) |
| `<SORT>` | =2 (use the farthest of the 4 points) |
| `<texture ID>` | =0 (not relevant) |
| `<COLOR>` | =RGB(0,15,15) |
| `<MODE>` | =72 (displayed inside the window, affected by the light source) |

If `<attribute ID>` and `<number of attributes>` are the same, it can be redefined later. When redefining existing attributes, if the attributes are already defined and their size differs, an Attribute size mismatch error occurs. Attribute data is initialised (erased) by the SCREEN command.

**[See also]** The ATR (16) item of the OBJ command.

*[p. 222]*

### SETTEX

*Direct-mode command / Program-mode command*

**Function:** Defines a texture.

**Syntax:**
```
(1) SETTEX [<texture ID>],<XS>,<YS>,<COLOR_DEPTH>[,<string>]
(2) SETTEX <string>
(3) SETTEX <texture ID>,<XS>,<YS>,<COLOR_DEPTH>,READ
```

**Example:**
```
(1)SETTEX 1,8,8,256,HEXBIN$(STRW$(64,"FF")
(2)SETTEX A$
(3)SETTEX 1,8,8,256,READ
```

**[Parameters]**
- `<texture ID>`: the group number of the texture to define, from 0 upwards.
- `<XS>`, `<YS>`: the dot size of the texture defined in this group. The range of `<XS>` is 8 to 504, but it causes an error if it is not in units of 8 dots. The range of `<YS>` is 1 to 255.
- `<COLOR_DEPTH>`: the number of colours per dot. One of 16, 256 and 32768.
- `<string>`: the texture data to define. The string format is described below.
- `READ`: reads the texture data from DATA statements.

**[Details]**

Syntax (1) defines a new texture. If `<texture ID>` is omitted, the smallest undefined texture ID is assigned. This number can be read with the TEXID(−1) function. If no more `<texture ID>`s can be registered, a Texture ID over error occurs.

Syntax (2) writes from where the last defined address ended. If the definition goes beyond the size of the texture, the excess part is ignored. If the texture address being written is undefined, an Undefined texture error occurs.

Syntax (3) defines texture data defined in DATA statements instead of a string. Because the hexadecimal strings are read and converted in one go, the data must be defined in DATA statements in the amount needed for the definition. If there is not enough data an error occurs, and if the amount needed for the definition is reached partway through a DATA statement, the remaining data is discarded. When the SCREEN command is executed, the area reserved by the SETTEX command is initialised, but the texture data itself is kept in its last defined state.

The DATA statement formats allowed by SETTEX are as follows (following HEXBIN$).

1. Comma-separated hexadecimal strings. `DATA AA,BB,CC,DD,EE,...FF`
2. A continuous hexadecimal string. Every 2 characters are converted as 1 byte. A final odd character is converted with a 0 added in the upper position.

*[p. 223]*

   Example: `DATA AABBCCDDEE...FF`

Defines `<string>` as texture data. A texture is bitmap data pasted onto a polygon face. `<COLOR_DEPTH>` gives the number of colours per dot.

- For 16, palette format, with 1 byte holding the data for 2 dots.
- For 256, palette format, with 1 byte holding the data for 1 dot.
- For 32768, RGB format, with 2 bytes holding the data for 1 dot.

As an example, the amount of data to register is calculated as follows.

```
1. <XS> = 8, <YS> = 8, <COLOR_DEPTH> = 16     → 8 × 8 × 0.5 = 32 bytes
2. <XS> = 8, <YS> = 8, <COLOR_DEPTH> = 256    → 8 × 8 × 1   = 64 bytes
3. <XS> = 8, <YS> = 8, <COLOR_DEPTH> = 32768  → 8 × 8 × 2   = 128 bytes
```

Because texture data is defined in order in SPRITE VRAM, as a rule `<texture ID>`s are defined in order from 0. It is possible to start defining at number 10, but then the data for numbers 0 to 9 can no longer be registered afterwards (a Table size error occurs).

If the `<XS>`, `<YS>` and `<COLOR_DEPTH>` of a `<texture ID>` are the same, it can be redefined later. When redefining an existing texture, if the texture is already defined in a different format, a Texture size mismatch error occurs.

If texture data being defined goes beyond the defined area, a Texture data over error occurs. To initialise texture data, execute `CLS <texture number + 10>`.

A defined texture can also be rewritten with the bitmap drawing commands.

**[String format]** For 32768 colours (RGB format), each dot is colour data with 5 bits each for R, G and B, &b0BBBBB_GGGGG_RRRRR, upper byte first, then lower byte. A dot to be displayed has the most significant bit (&H8000 = &b1_00000_00000_00000) set to "1", and a transparent dot has all bits "0". Display of any other data (values &H0001 to &H7FFF) is not guaranteed.

**[See also]** The ACTIVE command.

*[p. 224]*

## 1.8 Sprite/3D functions

### ATRID

*Fixed-point function*

**Function:** Returns an unused attribute ID.

**Syntax:** `ATRID(<attribute ID>)`

**Example:** `NEXT_ATTR = ATRID(-1)`

**[Parameters]**
- `<attribute ID>`: fixed-point (everything after the decimal point is cut off).

**[Return value]** Returns an unused attribute ID, as a fixed-point integer.

**[Details]**

Returns the number following the largest attribute ID defined so far. Used when defining new attributes with SETATR, when getting an undefined attribute ID, and so on.

The only parameter currently supported is `<attribute ID>` = −1.

### POLYGONID

*Fixed-point function*

**Function:** Reads the contents of a polygon ID.

**Syntax:** `POLYGONID(<polygon ID>[,<element number>[,<item number>]])`

**Example:**
```
POLYGONID(-1)   → returns the next unused polygon ID
POLYGONID(0)    → finds the number of faces of polygon ID 0
```

**[Parameters]**
- `<polygon ID>`: fixed-point (everything after the decimal point is cut off).
- `<element number>`: fixed-point (everything after the decimal point is cut off).

*[p. 225]*

- `<item number>`: fixed-point (everything after the decimal point is cut off).

**[Return value]** Returns a fixed-point integer.

**[Details]**

When `<polygon ID>` = −1, returns the number following the largest polygon ID defined so far. Used when defining a new polygon with SETPOLYGON, and so on.

When `<polygon ID>` >= 0, giving `<element number>` and `<item number>` gets the following contents from the polygon defined in `<polygon ID>`.

| \<element number\> | \<item number\> | Remarks |
|---|---|---|
| None | None | The number of elements of the polygon with this ID. 0 means undefined (the number of elements is the number of faces of the polygon). |
| 0 to \<number of elements − 1\> | None | The vertex ID used by this polygon |
| 0 to \<number of elements − 1\> | 0,1,2,3 | The list of vertices (p1,p2,p3,p4) making up the polygon face of \<element number\> |
| | 4,5,6 | The normal vector (X,Y,Z) of the polygon face of \<element number\> |

When `<element number>` is given, an Undefined polygon error occurs unless an existing polygon ID is given.

If the element number and item number are omitted, the number of elements of `<POLYGON ID>` is returned.

Example:

```
POLYGONID(0)   → returns the number of elements of POLYGON ID = 0
```

If only the item number is omitted, the vertex ID used by `<POLYGON ID>` is returned.

### TEXID

*Fixed-point function*

**Function:** Reads the contents of a texture ID.

**Syntax:** `TEXID(<texture ID>[,<item number>])`

**Example:** `TEXID(-1)`

**[Parameters]**
- `<texture ID>`: fixed-point (everything after the decimal point is cut off).
- `<item number>`: fixed-point (everything after the decimal point is cut off).

*[p. 226]*

**[Return value]** Returns a fixed-point integer.

**[Details]**

When `<texture ID>` = −1, returns the number following the largest texture ID defined so far. Used when defining a new texture with SETTEX, when getting an undefined texture ID, and so on.

The only parameter currently supported is `<attribute ID>` (sic) = −1.

When `<texture ID>` >= 0, giving `<item number>` as well gets the following information.

| \<item number\> | Information |
|---|---|
| 0 | Dot size X of the texture of \<texture ID\> |
| 1 | Dot size Y of the texture of \<texture ID\> |
| 2 | Number of colours of the texture of \<texture ID\>: one of 16, 256 and 32768 |

### VERTEX

*Fixed-point function*

**Function:** Reads the contents of a vertex ID.

**Syntax:** `VERTEXID(<vertex ID>[,<element number>[,<item number>]])`

(The heading reads VERTEX, while the syntax and example use VERTEXID.)

**Example:** `PRINT VERTEXID(-1)`

**[Parameters]**
- `<vertex ID>`: fixed-point (everything after the decimal point is cut off).
- `<element number>`: fixed-point (everything after the decimal point is cut off).
- `<item number>`: fixed-point (everything after the decimal point is cut off).

**[Return value]** Returns a fixed-point integer.

**[Details]**

When `<vertex ID>` = −1, returns the number following the largest vertex ID defined so far. Used when defining a texture (sic) with SETVERTEX, when examining an undefined vertex ID, and so on.

When `<vertex ID>` = 0, the following information can also be taken out by giving `<element number>` and `<item number>` as parameters.

*[p. 227]*

| \<element number\> | \<item number\> | Remarks |
|---|---|---|
| None | None | The number of vertices of \<vertex ID\>. 0 shows that it is undefined. |
| 0 to \<number of elements − 1\> | 0,1,2 | The vertex coordinates of each \<element number\> of \<vertex ID\>. \<item number\> 0, 1 and 2 correspond to (X,Y,Z) respectively. |

When `<element number>` is given, an Undefined vertex error occurs unless an existing vertex ID is given.

# Chapter 2: Sound reference

*[p. 229: chapter title page. pp. 228 and 230 are blank.]*

## 2.1 Sound system specification

*[p. 231]*

**■ 32 slots (shared by FM and PCM) / 16 tracks**
- With 1 voice and 1 layer, up to 32 notes can sound at once.

**■ Up to 251 songs**
- 253 songs including the one for "BEEP" and the one for the PLAY command.

**■ Up to 26,000 notes**
- When no special effects such as pitch bend are specified.

**■ Voice data area: standard 340 KB, maximum about 462 KB**
- The amount that can be handled in memory at the same time without swapping.

**■ Up to 128 voices (each voice up to 128 layers) can be used at the same time**
- In general synthesizer terms, this corresponds to a patch/performance.

**■ Maximum bend range ±2 octaves**
- Can be changed with the TPROP command.

**■ DSP control for effects**
- Reverb, delay and distortion can be controlled from MML.

**■ Over 200 PCM sounds and 512 FM sounds as standard (including sound effects)**
- Can be freely selected and rearranged from 16 voice data files.

**■ FM sound editing commands**
- 32 operators can be connected freely, and as well as the 47 standard modulation waveforms, original PCM sampling data can be used as a modulation waveform.

### Specification details

**■ Sound synthesis method**
- PCM sound synthesis and FM sound synthesis. Noise source (can be mixed).

**■ Sound source section**
- Resampling frequency (fixed playback rate) fixed at 44.1 kHz (CD quality with a sampling frequency of 44.1 kHz and 16 bits).

*[p. 232]*

**■ Waveform data format**
- 16-bit linear and 8-bit linear.
- Sampling frequency 0 (DC) to 44.1 kHz.
- Supports sign-bit inversion of waveform data.

**■ 32 sound processing slots**
- 1 slot corresponds to 1 PCM note or 1 FM operator.
- Up to 32 notes at once (8 notes when all are FM sounds with 4-operator algorithms).
- The number of slots used for 1 FM note can be set freely from 1 to 32 (FM and PCM sounds can be mixed).
- Managed together as layer data.

**■ Waveform loop function**

For each layer, select from

- Normal
- Reverse
- Alternative loop

(for both PCM and FM).

**■ EG (envelope generator)**
- 4-segment Amplitude-EG (for both PCM and FM).

**■ LFO (low-frequency oscillator)**
- Amplitude/frequency modulation (tremolo/vibrato).
- LFO output waveforms: sawtooth, square, triangle, white noise.
- ALFO/PLFO can be set independently (for both PCM and FM).

**■ Voice data (standard voice files)**
- The memory capacity is a trade-off with the song data area and the DSP program area (see "2.3 Sound memory map").
- Can be freely rearranged from among the voice files (340 KB × 12 = about 4 MB, plus a GM-ordered FM voice file).
- Original PCM sampling data can be registered and played back at different pitches (it can also be combined with data from the standard voice files).
- Files in "AIFF" and "WAVE" format can be linked as voice data (detected automatically).
- Wave data without header information can also be registered with the "DATA" statement.
- ALFO/PLFO/4-segment EG can be controlled per layer (per slot).

*[p. 233]*

**■ DSP/mixer control (input mixer/output mixer)**
- In "DSP" mode (single-effector mode): one DSP effector program from

  ```
  STEREO REVERB (reverb), 2 kinds
  STEREO DELAY (delay)
  DISTORTION (distortion)
  ```

  can be selected in real time with the MML "ec: effect change" command.
- In "DSPEXT" mode (multi-effector mode): the DSP effector programs

  ```
  STEREO REVERB (reverb)
  STEREO DELAY (delay)
  DISTORTION (distortion)
  ```

  are assigned to separate DSP input mixers, so effectors can be selected per layer and used at the same time. Effect level and pan pot can be set for each output channel.

**■ Modulation waveforms for the FM sound source**

As well as general waveforms such as sine, sawtooth, square and triangle waves, a total of 47 modulation waveforms are provided for the FM sound source, which widens the range of voices that can be expressed. For the shapes of the modulation waveforms, see the description of the TARG command (FM modulation waveform diagrams) in "2.5 Sound commands".

### Features of the MML

**■ Almost upwardly compatible with conventional MML**
- Register meanings differ, so MML commands that operate registers directly are not compatible.
- Up to 16 tracks can be specified.

**■ Key signatures can be specified**
- Has the concepts of bars and accidentals (compatible with conventional MML unless the "S" command is given).

**■ Sub-options for the note-on command (note name)**
- Velocity / Gate / Delta ratio.
- Pitch bend (also used for auto volume / auto pan).
- Chord names.
- The sub-options are compatible with conventional MML unless they are specified.

*[p. 234]*

**■ Damper switch per track**

**■ Chords within one track (possible even between different voices)**
- Tuplets, ties and pitch-bend operations on chords are possible.

**■ DSP effector/mixer control commands**
- When the input mixer to the DSP block has been set per layer, the level and position of that effect component can be controlled from MML.
- In "DSP" mode the effector can be selected with the effect change command "ec" (fixed at "ec0" in "DSPEXT" mode).

**■ Redefinable macros**
- Velocity macros (p, mp, mf, f and so on).
- 52 freely defined macros of 128 characters each (useful for percussion definitions).

**■ Key transpose**
- The pitch of all notes can be raised or lowered in semitone steps.

**■ Loop structure based on musical scores**
- A loop structure based on the abbreviations used in printed scores, rather than simple loops or subroutines.

**■ Embedded control commands for synchronising with the main system**
- The playing state of 16 tracks can be monitored in real time.
- Track "0" can be monitored by interrupt.

### About the sound system for GAME BASIC for SEGASATURN

In GAME BASIC for SEGASATURN, the program that parses BASIC and the program that actually plays the music are controlled by separate systems, so the specification differs somewhat from the MML used on conventional personal computers.

Conventional MML provided register-setting commands for controlling PSG and FM sound sources directly, but in this MML the command specification differs because of differences in hardware structure (there is no PSG in the hardware). Compared with the personal computers of the days when conventional MML was carried, the SEGA Saturn has a vast amount of memory, so the sound system including MML has been greatly extended, taking in as many functions of commercial sequencers and synthesizers as possible, with a design that puts more weight on musicality. This works by adding options to the basic commands, so if no options are given it behaves the same as conventional MML.

Some of the files in the voice data file set contain sound-effect data that can be used as is, so you can also make scales from sound effects, or conversely make sound effects from instrument voices.

The SEGA Saturn's sound hardware is designed so that a voice can be specified individually for each of 32 slots and played. This system *[p. 235]* allows up to 16 tracks to be written in MML, but it does not assign 1 track to 1 slot; it makes effective use of the 32 slots by assigning them dynamically (as with MIDI).

Sound data written in MML is converted to song data in advance and transferred to sound memory before playing, by the PLAY, EFFECT and SETSONG commands. This keeps the time lag caused by changing tunes or requesting sound effects to a minimum.

Music playback and BASIC parsing run in parallel on separate systems, so music does not drag or lose its timing while parsing is going on. However, the PLAY command alone plays one line of MML string at a time and does not execute the next command until that playing has finished, so there may be pauses for the time taken by parsing in between. Timing between tracks does not slip, but when writing a program whose main purpose is a game or musical performance, prepare the song data in sound memory in advance with the SETSONG command (up to 251 tunes), and then call up and play any song data with the EFFECT or BGM command. When playing with the EFFECT or BGM command, the music plays completely independently of the BASIC main system, so playing while moving polygon characters does not affect either side.

To use the DSP effector, an "input mixer" setting is needed on the voice data side (some voices have it set by default).

> **Caution:** Read "2.4 Sound system block structure" carefully before use.

There are "embedded control commands" for synchronising with the main system. As well as getting the "note", "volume" and "position" being played in real time, the sound system can send trigger-style commands to the BASIC interpreter. Only control commands written in track "0" can be monitored by interrupt from the interpreter side. With this feature you can make karaoke programs, or move polygons in sync with music.

*[p. 236]*

## 2.2 Explanation of terms

### MML

MML stands for Music Macro Language, a simple language dedicated to music for expressing a score using strings such as "C4D8E8…". Most of the basic commands follow the conventional personal-computer MML specification as closely as possible. Because of differences in internal function and added functions, a wide range of dedicated options is provided on top of the conventional MML commands. If you do not give the options peculiar to this MML, it is almost compatible, so old MML program listings can be entered as they are (or with small parameter changes) and played. Note numbers follow the MIDI standard. Below are a table of note numbers against note names, and the correspondence between note names on a score and note numbers.

*[p. 237]*

**Table of note numbers and note names (MIDI notation)**

| Note: name | | | | | |
|---|---|---|---|---|---|
| 0: C- | 24: C1 | 48: C3 | 72: C5 | 96: C7 | 120: C- |
| 1: C#- | 25: C#1 | 49: C#3 | 73: C#5 | 97: C#7 | 121: C#- |
| 2: D- | 26: D1 | 50: D3 | 74: D5 | 98: D7 | 122: D- |
| 3: D#- | 27: D#1 | 51: D#3 | 75: D#5 | 99: D#7 | 123: D#- |
| 4: E- | 28: E1 | 52: E3 | 76: E5 | 100: E7 | 124: E- |
| 5: F- | 29: F1 | 53: F3 | 77: F5 | 101: F7 | 125: F- |
| 6: F#- | 30: F#1 | 54: F#3 | 78: F#5 | 102: F#7 | 126: F#- |
| 7: G- | 31: G1 | 55: G3 | 79: G5 | 103: G7 | 127: G- |
| 8: G#- | 32: G#1 | 56: G#3 | 80: G#5 | 104: G#7 |  |
| 9: A- | 33: A1 | 57: A3 | 81: A5 | 105: A7 |  |
| 10: A#- | 34: A#1 | 58: A#3 | 82: A#5 | 106: A#7 |  |
| 11: B- | 35: B1 | 59: B3 | 83: B5 | 107: B7 |  |
| 12: C0 | 36: C2 | 60: C4 | 84: C6 | 108: C8\* |  |
| 13: C#0 | 37: C#2 | 61: C#4 | 85: C#6 | 109: C#8 |  |
| 14: D0 | 38: D2 | 62: D4 | 86: D6 | 110: D8 |  |
| 15: D#0 | 39: D#2 | 63: D#4 | 87: D#6 | 111: D#8 |  |
| 16: E0 | 40: E2 | 64: E4 | 88: E6 | 112: E8 |  |
| 17: F0 | 41: F2 | 65: F4 | 89: F6 | 113: F8 |  |
| 18: F#0 | 42: F#2 | 66: F#4 | 90: F#6 | 114: F#8 |  |
| 19: G0 | 43: G2 | 67: G4 | 91: G6 | 115: G8 |  |
| 20: G#0 | 44: G#2 | 68: G#4 | 92: G#6 | 116: G#8 |  |
| 21: A0\* | 45: A2 | 69: A4 | 93: A6 | 117: A8 |  |
| 22: A#0 | 46: A#2 | 70: A#4 | 94: A#6 | 118: A#8 |  |
| 23: B0 | 47: B2 | 71: B4 | 95: B6 | 119: B8 |  |

\*A0: the lowest note on a piano (88 keys)  
\*C8: the highest note on a piano (88 keys)

> **Caution:** Note names in MML can specify C0 to B8. Play notes outside this range with the "N" command.

*[p. 238]*

**Note names and note numbers on the staff**

*[Figure: a grand staff with a key signature of two sharps (F♯ and C♯) on both the treble and bass staves. The notes on the lines and spaces are labelled with their names and note numbers, rising from F (41) below the bass staff through G 43, A 45, B 47, C 48, D 50, E 52, F 53, G 55, A 57, B 59, middle C 60, D 62, E 64, F 65, G 67, A 69, B 71, C 72, D 74, E 76, F 77, C 79 (sic), A 81 and B 83. A bracket on the right marks the octaves O2 (41–47), O3 (48–59), O4 (60–71) and O5 (72–83).]*

※ The position of the "♯ (sharp sign)" is a sample for explaining MML. See → the MML "S" command (key signature).

### Sound memory

This is the 512 KB of memory dedicated to sound processing, managed by the SEGA Saturn's dedicated music CPU (MC68EC000). When BASIC starts, the STANDARD voice data and the default song data for the BEEP command are set, and the MML expansion area is initialised. Voice data is loaded directly from the CD-ROM. Song data is entered in the form of MML strings and transferred to sound memory by executing the PLAY/EFFECT/SETSONG commands. Unlike conventional MML, it does not occupy the BASIC variable area, so the free-area check functions "SFRE()" and "TFRE()" dedicated to sound memory are provided.

### Voice data files

A collection of data in which instruments and sound effects have been sampled by the PCM method. "GM_FM1" to "GM_FM4" are voice files built with the FM sound-source method (General MIDI order). Voice data files are loaded from the CD-ROM with the PLAYINIT command before use. One file holds dozens of kinds of voice data. The TLIST command displays a short description of each item of voice data (TLIST "MENU" displays a list of the voice files that can be specified). The TARG command can rearrange voices between voice files and register original PCM sampling data.

*[p. 239]*

Original PCM sampling data in AIFF or WAVE format files is detected automatically, taken in and can be used as voice data. Waveform data itself, without a header, can also be given in DATA statements. The standard voice data files provided are 12 PCM sets + 4 FM sets. For details, see "2.8 Voice data details".

### Wave data (waveform data: PCM sampling data)

The voice data registered in the voice data files is the sound waveform sampled by the PCM method. Wave data registered with the TARG command is 8-bit/16-bit (mono) in "AIFF" or "WAVE" format. The standard sampling frequency of voice data is 44.1 kHz, but the pitch can be changed freely with the TPROP command, so data with sampling frequencies different from the SEGA Saturn standard, such as 11 kHz or 22 kHz, can also be handled. When wave data is sounded, various kinds of voice processing such as LFO and EG can be applied.

### Song data (score data)

MML strings are converted all at once into "song data" that the CPU managing sound memory can recognise when the PLAY/EFFECT or SETSONG command is executed. In one item of song data, MML strings for up to 16 tracks are expanded and stored in sound memory. The number of items of song data that sound memory can hold at once (the number of songs) and the size of each are decided by the PLAYINIT command. Up to 251 tunes (+ one for "BEEP" + one for the PLAY command) can be registered, and as long as sound memory is not initialised by the PLAYINIT command, they can be called up and played any number of times with the EFFECT/BGM commands.

### Song number

The serial number of song data as registered in sound memory. Number 0 is reserved for the BEEP command, but normal MML can also be registered there and played. The song data for the BEEP command is also called on BASIC errors and on Break, so the error sound (tune) can be changed freely. The default of each command that takes a song number as a parameter is "1", so if the song number is omitted, song data number 1 is the one operated on.

*[p. 240]*

### Sequence number

A management number needed when playing song data at the same time. This sound system can choose any of up to 251 tunes and play up to 8 tunes at the same time (including sound effects). When playing is started by the PLAY/EFFECT/BGM commands, it is assigned to one of 8 sequences, and from then on, when sequence control commands (PLAYFADE, PLAYSTOP and so on) are executed, all of them can be executed in real time by giving the sequence number. There are 8, so sequence numbers are "0 to 7". Sequence number "0" is special and is used exclusively by the BGM command. Sequence numbers "1 to 7" are assigned dynamically to free places by the PLAY/EFFECT commands. With the EFFECT command you can give a "numeric variable" to return which sequence number the system assigned to the given song data.

For example, if you want to fade after playing starts, first start playing with the following form:

```
EFFECT (I),"MML文字列"
```

(MML文字列 = MML string.) The assigned sequence number is stored in the numeric variable "I", so the parameter passed to the fade command "PLAYFADE" is given using the "numeric variable", like this:

```
PLAYFADE I,127,50
```

In this way the sequence number is passed by way of a numeric variable, so the user does not need to be aware of it at all.

### Track number

The number used to distinguish the tracks that make up one item of song data. In this MML, up to 16 tracks can be written. In conventional MML, tracks had to be separated to sound chords, but this MML allows chords within the same track.

When several tracks are used, the lowest track number is specially called the base track.

### Layer number

In the sound system, a layer is a still finer unit of sound data that makes up one voice of the voice data. The SEGA Saturn has 32 sound slots, and each slot is controlled by one item of layer data. Some voices sound several items of wave data at the same time; in this case the layers are divided internally per item of wave data. So a voice that sounds 2 items of wave data at the same time has 2 items of layer data, and 2 slots are used at the same time *[p. 241]* when it sounds, so the number of notes that can sound at once becomes fewer than 32.

Voices such as those of the "PIANO" set, which assign wave data from different sampling regions to one voice, and voices such as drum sets, whose kind changes with the note number, have correspondingly more layers, but in these cases they are not sounded at the same time, so slots are not occupied for the number of layers. However, layer data whose internal parameters "Start Note" and "End Note" are the same are sounded at the same time, so slots are occupied.

When the FM sound source is used, each carrier/modulator is assigned to 1 slot, so a voice made with a 4-operator algorithm has 4 items of layer data. Depending on how the slot algorithm is specified, several slots are used for 1 note, so the number of notes that can sound at once becomes fewer than 32. For example, if all 32 slots are connected in series, only 1 note can sound at a time. For FM, if even 1 of the slots used by the connected algorithm is not available, the note is cancelled; to give an extreme example, while 1 PCM note is sounding, an FM voice with 32 connected slots cannot be sounded.

Detailed editing per layer can be done with the TARG and TPROP commands.

### Direct data

Sound that does not go through the DSP, or that goes through it but has no effect applied, is called direct data (or dry data).

### Effect data

When some effect is applied through the DSP to the sound generated in the sound source section, the resulting sound is called effect data (or wet data).

### Pan pot (PAN-POT)

The function that sets localisation (the direction and position the sound is heard from). This sound system has 2 kinds: direct pan (localisation of direct data) and effect pan (localisation of effect data).

Direct pan information comes in 3 kinds, with a fixed order of priority: that set in advance in the voice data, that set by the MML "P" command, and that set by the PLAYPAN command. For details, see "Direct pan priority" below.

*[p. 242]*

### PCM sound generator (Pulse Code Modulation sound generator)

A sound source that turns sound into PCM data, stores it in memory, and reads it from memory and outputs the sound when playing. PCM means dividing a sound (waveform) along the time axis and replacing each wave height with digital data. The data obtained by this process is called PCM data.

### FM (Frequency Modulation)

Means frequency modulation. In the sense of a sound source, it means the FM sound source.

### LFO (Low Frequency Oscillator)

A function generator that produces waveforms at frequencies lower than the range the human ear can hear. The waveform output of the LFO is used for modulating amplitude, frequency and so on, to express tremolo and vibrato.

### DSP (Digital Signal Processor)

A dedicated high-speed calculation circuit that mainly performs calculations (multiplication and addition) at high speed. The DSP built into the SCSP (Saturn Custom Sound Processor) is specialised for audio and is used as a means of producing the effects called acoustic effects, such as echo and reverb.

### Number of samples

The number of items of data in waveform data. With 8-bit sampling, 1 sample is 8 bits; with 16-bit sampling, 1 sample is 16 bits.

### dB (decibel)

A unit that uses logarithms to compare magnitudes such as volume. Specifically, when the volume being compared is twice the reference volume (amplitude of the waveform), the volume ratio is 6 [dB]. Also, 1× is 0 [dB], 3× is 10 [dB] and so on. Conversely, when the volume being compared is smaller than the reference volume, this value [dB] takes a negative value. For example, at 1/2 of the reference it is −6 [dB]. In this sound system, the units of the MML "@V" command, "[" command and "]" command, the modulation depth and the total level are of this kind.

### Modulator

When several slots are connected in the FM sound source, the slot on the side that applies modulation.

*[p. 243]*

### Carrier

When several slots are connected in the FM sound source, the slot on the side to which modulation is applied.

### Gate time

The time for which a key is actually on.

### Delta time

This represents the interval between commands throughout all tracks, but in this manual it is used as the word for the length in time of one note. The unit is the direct length of the MML command "L".

### Gate/Delta ratio

The ratio of gate time to delta time. For example, 1/2 means the key is on for only half the length of the note (delta time), so it is played staccato.

### AIFF

The standard waveform data format of the Macintosh. With 16-bit sampling, the upper 8 bits come first, then the lower 8 bits.

### WAVE

The standard waveform data format of Windows. With 16-bit sampling, the lower 8 bits come first, then the upper 8 bits.

### MIDI (Musical Instrument Digital Interface)

A standard for exchanging signals between electronic instruments such as synthesizers and keyboards, and computers. This sound system follows this standard for note numbers and the way notes are sounded.

### Note

Means a musical note. The C of octave 4 is assigned 60, and the pitch is expressed by numbers from 0 to 127.

*[p. 244]*

## 2.3 Sound memory map

The total sound memory capacity available to the user is 468 KB (1872 blocks).

*[Figure: memory map of sound memory, 1 block = 256 bytes. From the top:*

- *● Voice data area: 340 KB (1360 blocks) ★ default; maximum about 462 KB (1847 blocks).*
- *A bracket labelled "can be extended in 1-block units by the PLAYINIT command" spans the areas below and is marked "maximum about 122 KB, extendable (487 blocks)".*
- *● Song data area (MML expansion area): 128 KB ★ default (512 blocks).*
- *Under the heading <PLAYINIT "DSPEXT">: ● DSP Area 72 KB (288 blocks).*
- *Under the heading <PLAYINIT "DSP">: ● DSP Area 40 KB (160 blocks).*
- *Beside these: "DSP" Mode 88 KB (352 blocks); "DSPEXT" Mode 56 KB (224 blocks).]*

*[p. 245]*

## 2.4 Sound system block structure

The actual flow of sound data when sound commands and functions are executed is more complex than in conventional systems. Here, the parts that are hard to understand from the individual command descriptions alone (especially DSP/mixer control) are shown in diagrams and explained.

*[Figure, pp. 245–246: block diagram of the sound system.*

*Top half (p. 245). Four blocks:*

- *● BASIC Main block [SH-2], BASIC interpreter.*
- *● Sound control block [MC68EC000], SCSP Controler (sic).*
- *● Sound memory.*
- *● CD block.*

*The flows between them:*

- *PLAYINIT/TARG → \<memory initialisation request> \<FM sound source settings> → sound memory: loading voices from the CD (from the CD block), initialising the DSP program and work area.*
- *TPROP (part 1), EG/LFO ↔ \<voice parameters> Read/Write ↔ sound memory.*
- *PLAY/EFFECT/BGM/SETSONG → \<MML registration/play request> → song data in sound memory; sequence playback in the sound control block.*
- *PLAYSTAT/MMLSTAT and ON MMLSTAT GOSUB ← \<status monitoring> ← sound control block.*
- *PLAY\*\*\*\* → sequence control in the sound control block ← SCSP.*
- *TPROP (part 2) / DSP mixer control \<input select> \<Direct Level/Pan>, and the mixer control commands in MML \<Effect Level/Pan>, → \<setting of each mixer parameter> → ● DSP/mixer block.*
- *Sound memory → \<waveform data> → ● SCSP: 32-channel sound slots, PCM/FM switching → \<direct component output> (/32).*
- *Note in the DSP/mixer block: "Waveforms set in the layer data are assigned to free slots when sounded."*

*Bottom half (p. 246). The DSP/mixer block in detail:*

- *The 32 slot outputs, numbered 0–31, each carry a direct component and a DSP path. The DSP path of each slot is adjusted with the TPROP command parameters "71: input mix level" and "70: input select". This sound system manages them by layer, without the user needing to be aware of slot numbers.*
- *These feed the 16 inputs (0–15) of the DSP input mixer, then the ● DSP effect module, whose internal structure changes with the "DSP"/"DSPEXT" mode (※ see "DSP effect module details").*
- *The 16 outputs (0–15) of the DSP output mixer go through the MML "el" command (effect send level) ×16 and the MML "ep" command (effect pan) ×16, giving L/R pairs for outputs 0–15, which are summed to L and R.*
- *The direct component of the 32 slots (/32) goes through the TPROP command parameters "72: direct data send level" and "73: direct data localisation" to L and R.*
- *All of these meet in the accumulator (MIX of all audio signals), for all 32 channels, then pass through the master volume (VOLUME command) to the final L and R outputs.]*

*[p. 247]*

Sound data roughly follows the paths shown in the diagram and is finally mixed down to 2 stereo channels.

In the default state, without the DSP effector, only the "direct component" in the diagram is used, so sound comes out just by changing the parameters "72: direct data send level", "73: direct data localisation" and "master volume". The master volume has a default value set by the VOLUME command, and the other direct-component parameters also have default values set in advance on the voice data side, so if you do not use the DSP effector you do not need to be aware of the mixer at all.

### DSP effect module details

**Internal structure in "DSP" mode**

Executing PLAYINIT "DSP" initialises the DSP in single-effector mode. The input mixer uses only channel "0".

A layer registered with a voice that you want to pass through the effector is connected when its "70: input select" is set to channel "0" with the TPROP/DSP command, but this is "0" by default, so the effector can be used just by changing "71: input mix level" (some voices have a mix level set in advance). Conversely, for voices you do not want to pass through the effector, set "71: input mix level" to "0". For details, see the TPROP/DSP command. The output mixer uses only channels "0–1" (distortion is a mono effector, so only channel "0").

By default the output mixer pans channel "0" to Left and channel "1" to Right, with the effect level set to maximum. These settings can be changed later with the MML "ep: effect pan" command and "el: effect level" command.

> **Caution:** Distortion is an effector that distorts the sound on purpose, so its output level is high. Adjust it with the "el" command.

*[p. 248]*

*[Figure: the "DSP" mode effect module. Input mixer channels 0–15 at the top: channel 0 is connected when "70: input select" of each layer is set to "0" (channels 1–15 are disabled). Channel 0 feeds one effector, "0: reverb 1 or 1: reverb 2 or 2: delay or 3: distortion", changed with the MML "ec" command (effect change); the numbers are effector numbers. ★ The other channels are unused. The effector feeds output mixer channels 0 (L) and 1 (R) (channels 2–15 are disabled): stereo output (distortion only: mono output → channel "0").]*

**Internal structure in "DSPEXT" mode**

Executing PLAYINIT "DSPEXT" initialises the DSP in multi-effector mode. For the input mixer, channels "0–2" can be chosen according to the kind of effector (0–2 correspond to the constant symbols @REV, @DEL and @DST).

A layer registered with a voice that you want to pass through an effector is connected when its "70: input select" is set to channels "0–2" with the TPROP/DSP command, but this is "0" by default, so if you do not choose anything in particular it goes to the reverb.

The output mixer can also be taken out separately for each kind of effector. The reverb output is "0–1", the delay output is "2–3", and distortion, being a mono effector, is assigned to channel "4" only. By default each output mixer is panned Left and Right with the effect level set to maximum. Operation after setting up is the same as in "DSP" mode.

*[p. 249]*

*[Figure: the "DSPEXT" mode effect module. Input mixer channels 0, 1 and 2 are connected when "70: input select" of each layer is set to "0–2" (channels 3–15 are disabled). Channel 0 feeds the reverb, channel 1 the delay and channel 2 the distortion. ★ The other channels are unused. Output mixer: channels 0 (L) and 1 (R) are the reverb stereo output, 2 (L) and 3 (R) the delay stereo output, and 4 (M) the distortion mono output (channels 5–15 are disabled).]*

### About the mixer

The mixer parameters of the direct component are set in advance in the voice data. When the "DSP" option is given with the PLAYINIT command, the mixer parameters for the effect component are initialised.

The mixer parameters of the effect component are not per voice, so set them with the MML "el" command.

When using this sound system, if you do not use DSP effects you do not really need to be aware of the mixer. The SEGA Saturn's digital mixer is the block that adjusts the level/balance of each sound signal, and it consists of 4 parts: the direct sound adjustment section, the DSP input stage adjustment section, the DSP output stage adjustment section and the final output stage adjustment section.

**Direct sound adjustment section**

The mixer block that manages the path by which the output of each slot connects directly to the digital-to-analogue converter. The output level and output balance can be controlled for each slot.

> **Caution:** Adjusted with the TPROP command.

*[p. 250]*

**DSP input stage adjustment section**

Performs the mixing for feeding the output of each slot into the DSP. In practice, the sound signal is selected with "input select" in the layer data of each voice, and the input level is adjusted with "input mix level". When several sounds are mixed with "input select", the balance of each sound needs to be set. The DSP can take several slot outputs mixed together as input, so the same effect processing can be applied to several sounds, as with reverb on BGM.

> **Caution:** Set with the TPROP or DSP command.

**DSP output stage adjustment section**

Finally brings the sounds that have had effects applied by the DSP together into stereo through mixing. The output level and output balance can be adjusted. The data brought together here is also mixed with the direct sound component.

> **Caution:** Adjusted with the MML "el" and "ep" commands.

**Final output stage adjustment section**

Brings together the direct component and the effect component of the sound and adjusts the output level.

> **Caution:** Adjusted with the VOLUME command.

### Relationship between sound slots and layer data

**For those who want to operate the values of the SCSP (Saturn Custom Sound Processor) registers directly**

The SEGA Saturn has 32 sound slots, allowing up to 32 notes to sound at the same time. The diagrams were explained in terms of slots, but you do not need to be aware of slot numbers when using this sound system. This is because one layer is assigned dynamically to one slot internally. So, unlike when operating conventional sound-source parameters, you do not need to look up the addresses of the sound-source registers corresponding to sound slot numbers and read or write them; everything is set in advance in the layer data, and the layer may be assigned to any slot when it sounds (as with MIDI).

When setting FM sound-source parameters too, you create the layer data in advance (TARG command "FM" command), and when changing parameters later in real time you read and write by giving the layer number with the TPROP command (settings are made to the SCSP registers not directly but by indirect operation through layers). Register values set in this way are transferred to the actual SCSP registers at the moment the layer sounds (note-on) (the user does not need to be aware of which sound slot it was assigned to). For details of the register items, see the TPROP command.

*[p. 251]*

### Direct pan priority

"73: direct data localisation", which can be set with the TPROP command, is disabled when the MML "P (direct pan)" command is executed. To enable it, change the voice (program change) with the MML "@" command. Put the other way round, note that the setting of the MML "P" command (including the note-on command's "~P: auto pan") is initialised by a voice change. Also, when the PLAYPAN command is executed, both the direct pan from the "P" command and the layer pan of the voice data are disabled. The pan commands are listed below in order of priority, highest first:

1. Sequence pan (PLAYPAN command)
2. MML pan (MML "P" command)
3. Layer pan (TPROP item number "73: direct data localisation")

In every case, the value is set in the direct data localisation mixer of the diagram shown first (the settings are not held in separate places).

> **Caution:** It has no effect when mono is selected on the user settings screen.

*[p. 252]*

## 2.5 Sound commands

### BEEP

*Direct-mode command / Program-mode command*

**Function:** Sounds the warning beep. Returns the error sound registered as song number "0" to the default warning sound.

**Syntax:** `BEEP [0|1]`

**Example:**
```
BEEP
BEEP 1
```

**[Parameters]**
- `0|1`: switch.

**[Details]** If no switch is given, it sounds briefly, as on an error. It does not go on to the next processing until it has finished sounding. If the switch is "1", the warning sound is left sounding and processing continues without waiting. If the switch is "0", the warning sound is stopped.

**[Caution]** If the BEEP sound (error sound) has been changed by registering song "0" with the EFFECT/SETSONG command, executing this BEEP command returns it to the default.

*[p. 253]*

### BGM

*Direct-mode command / Program-mode command*

**Function:** Plays MML already registered in sound memory by the SETSONG command. The difference from the PLAY/EFFECT commands is that it plays on the sequence number reserved for BGM (number 0), so playback is not interrupted even when all 7 sequences are occupied by the EFFECT command. This command does not take an MML string.

**Syntax:** `BGM [song number[,volume[,fade-in rate]]]`

**Example:**
```
BGM 5,127,70    → plays the tune registered as song number 5, fading in towards volume 127
BGM ,,70
```

**[Parameters]**
- Song number: specifies the song number to play. From "0" (for BEEP) up to the number of tunes given by "number of songs to register" in the PLAYINIT command. Default = 1.
- Volume: specifies the volume during playback. "0 to 255"; the larger the value, the louder. Default = 127. A value of 128 or more makes it louder than the original volume of the waveform data. Normally give 127 or less.
- Fade-in rate: specifies the speed of the fade-in. The final volume of the fade-in is the value given by "volume". "0 to 255"; the smaller the value, the faster the fade-in. If 0 is given, playback starts at the "volume" value from the beginning, without fade-in processing. Default = 0.

**[Details]**

The BGM command is used mainly to play music. Because it uses sequence number "0", give sequence number "0" when using sequence control commands such as PLAYFADE on a song sounded by BGM. Each time it is executed, the BGM command stops the song on sequence number "0" and then starts.

"Song number" specifies the song number to play. The maximum value that can be given is the number of tunes given by "number of songs to register" in the PLAYINIT command.

"Fade-in rate" specifies the interval at which the volume is brought closer to the value given by "volume". "0" means no fade-in processing.

*[p. 254]*

### DSP

*Direct-mode command / Program-mode command*

**Function:** Performs DSP control.

**Syntax:**
```
(1) DSP ON {<voice number>,<layer number|ALL>,<effector number>,<level>}
(2) DSP OFF {<voice number>,<layer number|ALL>}
(3) DSP ALL ON <effector number,level>
(4) DSP ALL OFF
```

**Example:**
```
DSP ALL OFF           → makes all voices of the currently loaded voice data not use the DSP,
DSP ON 38,0,@REV,7      and sets only the voice of layer 0 of number 38 to have reverb at the maximum.
DSP ALL ON @DEL,5     → makes all voices of the currently loaded voice data able to use the DSP,
DSP OFF 5,ALL,24,2      and initialises the effector to delay at level 5.
                        Then turns OFF all layers of voice number 5 and layer 2 of number 24.
```

**[Parameters]**
- `<voice number>`: specifies the voice number for which the DSP effector is to be turned ON or OFF. The number given by the MML "@" command. Cannot be omitted.
- `<layer number|ALL>`: specifies the layer number for which the DSP effector is to be turned ON or OFF. "ALL" can be given instead of a layer number; in this case all layers of the selected voice number are affected. Cannot be omitted.
- `<effector number>`: specifies the type of DSP effector. The same as "70: input select" of the TPROP command. Affected if the TPROP command is executed.

  Specifies which channel of the DSP mixer the slot output data is input to. The range is "0 to 15", but in GAME BASIC for SEGASATURN values other than the following are invalid.

  | Value | Effector | |
  |---|---|---|
  | 0 | STEREO REVERB [reverb] | @REV |
  | 1 | STEREO DELAY [delay] | @DEL |
  | 2 | DISTORTION [distortion] | @DST |

  In DSP mode (single effector), always give "0".
- `<level>`: specifies the level sent to the DSP input mixer. The same as "71: input mix level" of the TPROP command. Affected if the TPROP command is executed.

*[p. 255]*

  Specifies the input level when the slot output data is input to the DSP mixer.

  The input mixer has no protection against overflow, so set it so that the total for all slots does not exceed "0 dB" (exceeding it causes distortion).

  The number of notes that can properly be input when the "input mix level" value is changed is as follows.

  | Input mix level | Level [dB] | Factor | Notes that can be input |
  |---|---|---|---|
  | 0 | −MAX | ×0.000000 | -- notes |
  | 1 | −36 | ×0.015625 | 64 notes |
  | 2 | −30 | ×0.031250 | 32 notes |
  | 3 | −24 | ×0.062500 | 16 notes |
  | 4 | −18 | ×0.125000 | 8 notes |
  | 5 | −12 | ×0.250000 | 4 notes |
  | 6 | −6 | ×0.500000 | 2 notes |
  | 7 | −0 | ×1.000000 | 1 note |

**[Details]**

Syntax (1) turns the DSP effector "ON", layer by layer, for the voice data currently in sound memory. Constant symbols can be used for the effector number.

Syntax (2) turns the DSP effector "OFF", layer by layer, for the voice data currently in sound memory.

In both syntax (1) and (2), the parameters enclosed in "{…}" can be written repeatedly.

When single-effector mode has been set with `PLAYINIT "DSP",…`, only one type of effector can be used at a time, so give "0" as the effector number. In this case, the effector is switched with the MML command "ec".

Syntax (3) is used to apply the DSP effector to all voices.

Syntax (4) is used when the DSP effector is not to be applied to any voice.

Some voice data files have a "level" set by default. If unintended effects appear, first execute "DSP ALL OFF" and then operate on each voice.

*[p. 256]*

The settings can also be changed in real time during playback. In this case, the rewritten values take effect at note-on timing. Settings can also be made for voice data rearranged by the TARG command and for original PCM sampling data.

**[Caution]**

An error occurs if DSP mode has not been set with `PLAYINIT "DSP"` or `PLAYINIT "DSPEXT"`. Data that has been reset cannot be saved.

If the voice data in sound memory is replaced by the PLAYINIT/TARG commands, values set before that return to the original voice parameters, so to change settings, do so after registering the voice data you want to change in sound memory with the PLAYINIT and TARG commands.

**[Warning]** Depending on how the parameters are given, this command may make the sound stop or become distorted. In that case, execute the PLAYINIT command. If there is still no sound, or communication between the main system and the sound system goes wrong, do a hot start, save the program, reset, and run it again.

**[See also]** "DSP effect module details" in "2.4 Sound system block structure".

### EFFECT

*Direct-mode command / Program-mode command*

**Function:** Plays music (a sound effect) given by an MML string. By setting the volume to "0", it can be registered only, without being sounded at that point.

Unlike the PLAY command, it moves on to the next command without waiting for the sound to finish.

Up to 7 pieces of music (sound effects) can be played at the same time by giving song numbers. If both a song number and an MML string are given, the MML is registered under the given song number, and from the second time on it can be played again by giving the song number only.

**Syntax:**
```
(1) EFFECT[(<numeric variable name>),][song number[,volume,]]{[[#<track number>][,"MML string"]]} (repeated for up to 16 tracks)
(2) EFFECT[(<numeric variable name>),][song number[,volume]]
```

**Example:**
```
EFFECT 2,0,"CDE"  → only registers do-re-mi as song number 2, without playing it
EFFECT 2          → plays the song data registered as song number 2
EFFECT -2         → plays the song data registered as song number 2 without waiting
                    (when using it in a real-time game, play it this way)
```

*[p. 257]*

**[Parameters]**
- `(<numeric variable name>)`: specifies the name of a numeric variable to hold the sequence number assigned. The EFFECT command returns a value in the numeric variable given here. "1 to 7" is returned in the numeric variable. The variable type is limited to fixed-point or a fixed-point array.
- Song number: specifies the song number to play or newly register. Can be from "0" (for BEEP) up to the number of tunes given by "number of songs to register" in the PLAYINIT command.

  If omitted, as with the PLAY statement, the MML is not registered in sound memory and is discarded each time it is executed. If the MML string is also omitted, an error occurs. Only the MML string given in one statement is valid; an EFFECT command spread over 2 or more statements is not recognised as continuing the previous one.

  Registering short song data such as sound effects is convenient as it takes only one statement, but to register a long tune, register it all at once with the SETSONG command and then call it with the EFFECT or BGM command.

  Only the EFFECT command allows a minus (−) sign on the song number. With a minus sign, it does not wait for the sound to start when the sound effect is requested. For details, see [Caution].
- Volume: specifies the volume during playback. "0 to 255"; the larger the value, the louder. Setting "0" registers only, without sounding at that point. Default = 127. A value of 128 or more makes it louder than the original volume of the waveform data. Normally give 127 or less.
- `#<track number>`: specifies which track (performance part) the MML string that follows is expanded into. Within the range "0 to 15" the numbers need not be consecutive, so the order can be changed. Unlike the PLAY command, the previous state is not kept, and default values are always set at the start.

  If the track number of the first MML is omitted, it is track "0". If the track of an MML partway through is omitted, it is the previously assigned track + 1. An error occurs if this goes beyond 15.
- `"MML string"`: defines score data as a string. For details, see "2.6 MML details". MML strings can be given for up to 16 tracks, separated by ",". A track given nothing is a "rest".

*[p. 258]*

**[Details]**

The EFFECT command can play up to 7 kinds of song data at the same time, managing sequence numbers "1 to 7" (sequence number "0" is reserved for the BGM command). When executed, it looks for free sequence numbers and assigns them in order, and returns in "(\<numeric variable name\>)" which sequence number the song data sounded by that EFFECT command was assigned to. Store this return value in a variable and use it as a parameter of other sequence control commands such as PLAYFADE.

"Song number" specifies the song number to register or play. The maximum value that can be given is the number of tunes given by "number of songs to register" in the PLAYINIT command.

"Volume" specifies the volume during playback. Separately from the MML volume commands, it works as the total volume of all tracks (above it there is also a master volume that adjusts the volume of all sequences together; for details, see the VOLUME command). If "song number" and "volume" are omitted and the MML string is written from the start, playback starts with the default values.

An MML string expanded into sound memory stays in memory unless it is initialised with the PLAYINIT command or re-registered under the same song number, so from the second time on it can be played again just by giving the song number.

When using it in an ordinary game program, register the MML in the song area in advance with "volume" set to "0", and give only the "song number" when actually sounding it. To register several sound effects at once, use the SETSONG command.

By executing it in combination with the PLAYPAN command, sound effects coming from different directions can be sounded while sharing song data.

**[Caution]**

Note the following when writing an "expression" with "()" as the song number.

"EFFECT (I),(5-4),…" starts playing with "5−4=1" as the song number and returns the assigned sequence number in the numeric variable "I", but if "(I)" is omitted, an error occurs because it tries to read the bracketed "(5-4)" as a numeric variable name. When writing "(expression)" as the song number, do not omit the numeric variable name.

In this sound system the main CPU and the sound CPU are independent, so a wait is included so that the "PLAYSTAT" function, which returns whether a sound is playing or not, works correctly. Because of this, processing on the main side may stop for a moment just after a request. For the EFFECT command only, this wait can be skipped by putting a minus sign on the "song number", but as a side effect the return value of the "PLAYSTAT" function just after the request may be incorrect.

*[p. 259]*

If a different MML string is written over a song number that is currently playing, it does not play correctly.

```
EFFECT 1,"CDEFG"     → while this data is playing, the EFFECT below rewrites it,
EFFECT 1,"ABCDE"       so it does not play correctly.
```

### EG

*Direct-mode command / Program-mode command*

**Function:** Sets the EG (envelope generator) parameters.

**Syntax:** `EG <voice number,<layer number|ALL>,[AR]>[,DR] [,SR] [,RR] [,SL] [,EGHOLD] [,LSLINK] [,KS]`

**Example:** `EG 44,ALL,31,18,8,16` → sets AR=31, DR=18, SR=8, RR=16 for voice number 44.

Meaning of the symbols:

| Symbol | Meaning |
|---|---|
| AR | Attack rate |
| DR | Decay rate |
| SR | Sustain rate |
| RR | Release rate |
| SL | Sustain level |
| EGHOLD | EG hold mode |
| LSLINK | Loop start link |
| KS | Key rate scaling |

**[Parameters]**
- `<voice number>`: specifies the voice number to read and rewrite. The number given by the MML "@" command. Cannot be omitted.
- `<layer number|ALL>`: specifies the layer number to rewrite. "ALL" can be given instead of a layer number; in this case all layers of the selected voice number are affected. Cannot be omitted.
- `AR`: specifies the amount of change over time from the start of the sound until it reaches its maximum. "0 to 31": 0 = smallest change (level increase), 31 = largest change (level increase).
- `DR`: specifies the amount of change over time while decaying from maximum volume to the sustain level. "0 to 31": 0 = smallest change (level decay), 31 = largest change (level decay).

*[p. 260]*

- `SR`: specifies the amount of change over time while decaying from the sustain level to silence. "0 to 31": 0 = smallest change (level decay), 31 = largest change (level decay). Setting "0" gives a sustained sound with no decay.
- `RR`: specifies the amount of change over time while decaying from key-off to silence. "0 to 31": 0 = smallest change (level decay), 31 = largest change (level decay).
- `SL`: specifies the actual level, in the sustain state, of a sound that has gone through DR from maximum volume. "0 to 31": 0 = minimum level, 31 = maximum level.
- `EGHOLD`: specifies whether the value at the attack is held or changed.
  - 0: changes according to the value given for the attack rate.
  - 1: reaches maximum volume as soon as the sound starts. The time for which maximum volume is held is decided by the attack rate value.
- `LSLINK`: synchronises "the start of the loop" with "the transition of the EG from the attack state to the decay state" (for loops, see the waveform data control of the TPROP command).
  - 0: the EG state transition and the position of the loop start point are unrelated.
  - 1: synchronised.

  If, in the attack state, the EG reaches maximum volume earlier in time than the loop start point, the EG reaches MAX level first. However, it cannot move to the decay state until the waveform read address reaches the loop start point, so the EG keeps holding MAX level. When the loop start point is reached, the EG moves to the decay state.

  If, in the attack state, the EG reaches maximum volume later in time than the loop start point, there are two further patterns. If the loop start point is reached and the EG level at that moment is greater than the sustain level, after reaching the loop start point the EG

*[p. 261]*

  moves to the decay state. Then, when the EG value reaches the sustain level, it moves to the sustain state.

  If the loop start point is reached and the EG level at that moment is less than the sustain level, after reaching the loop start point the EG moves to the decay state. After that, the EG value never reaches the sustain level, so it does not move to the sustain state and keeps holding the silent state.
- `KS`: key rate scaling has the effect of changing each rate of the envelope according to pitch (note number) (it specifies the rate at which the envelope transition speed becomes faster the higher the note). "0 to 14" and "−1": −1 = scaling OFF, 0 = minimum scaling, 14 = maximum scaling.

**[Details]**

The sound of an instrument changes in volume and tone over time. This change over time is called the envelope, and the function that creates this curve mechanically is called the EG (envelope generator).

Rewrites the EG settings, layer by layer, for the voice data currently in sound memory. They can also be changed in real time during playback. In this case, the rewritten values take effect at note-on timing.

If only "," is given, the item is skipped, and the value of a skipped item does not change.

The EG represents the change over time of the amount of decay of the sound with 4 states.

The EG does not go through all 4 states in every case of sounding; it draws various envelope curves depending on the timing of key-off. If key-off is done during the attack state, the sound decays from the level at that moment according to the release rate setting. So the envelope curve in this case has a shape as if the decay state and sustain state were missing. On entering the decay state, the sound decays towards the sustain level according to the decay rate setting. If key-off is executed partway through, after that it decays from the level at the moment of key-off according to the release rate setting.

The contents of the parameters are the same as item numbers 20 to 27 of the TPROP command. So it is affected if those items are rewritten with the TPROP command.

*[p. 262]*

*[Figure: comparison with conventional envelope generators. A key on/off line at the top goes ON and later OFF. The upper graph, "EG specification of conventional FM sound chips such as the YM2203/YM2608", plots EG against Time: a rise during AR 0–31, a fall during DR 0–31 to the level set by SL 0–15, a slow fall during SR 0–31, and after key-off a fall to zero during RR 0–15. The lower graph, "EG specification of the SEGA Saturn", has the same shape with AR 0–31 (attack state), DR 0–31 (decay state), SR 0–31 (sustain state) and RR 0–31 (release state), and the sustain level SL 0–31.]*

*[p. 263]*

**[Caution]** Data that has been reset cannot be saved. If the voice data in sound memory is replaced by the PLAYINIT/TARG commands, values set before that return to the original voice parameters, so to change settings, do so after registering the voice data you want to change in sound memory with the PLAYINIT and TARG commands.

**[Warning]** Depending on how the parameters are given, this command may make the sound stop or become distorted. In that case, execute the PLAYINIT command. If there is still no sound, or communication between the main system and the sound system goes wrong, do a hot start, save the program, reset, and run it again.

### LFO

*Direct-mode command / Program-mode command*

**Function:** Sets the LFO parameters.

**Syntax:** `LFO <voice number,<layer number|ALL>,[LFO reset]> [,LFO frequency] [,ALFO waveform] [,ALFO depth] [,PLFO waveform] [,PLFO depth]`

**Example:** `LFO 44,ALL,1,16,2,7,1,7` → sets, for voice number 44, LFO reset = ON, LFO frequency = 2.87 Hz, ALFO waveform = triangle wave, ALFO depth = maximum, PLFO waveform = square wave, PLFO depth = maximum.

**[Parameters]**
- `<voice number>`: specifies the voice number to read and rewrite. The number given by the MML "@" command. Cannot be omitted.
- `<layer number|ALL>`: specifies the layer number to read and rewrite. "ALL" can be given instead of a layer number; in this case all layers of the selected voice number are affected. Cannot be omitted.
- LFO reset: specifies whether the LFO is reset at key-on. 0 = not synchronised; 1 = the LFO is reset at key-on.
- LFO frequency: specifies the oscillation frequency common to ALFO and PLFO.

*[p. 264]*

  | Value set for LFO frequency | Oscillation frequency (Hz) | Value set for LFO frequency | Oscillation frequency (Hz) |
  |---|---|---|---|
  | 0 | 0.17 | 16 | 2.87 |
  | 1 | 0.19 | 17 | 3.31 |
  | 2 | 0.23 | 18 | 3.92 |
  | 3 | 0.27 | 19 | 4.79 |
  | 4 | 0.34 | 20 | 6.15 |
  | 5 | 0.39 | 21 | 7.18 |
  | 6 | 0.45 | 22 | 8.6 |
  | 7 | 0.55 | 23 | 10.8 |
  | 8 | 0.68 | 24 | 14.4 |
  | 9 | 0.78 | 25 | 17.2 |
  | 10 | 0.92 | 26 | 21.5 |
  | 11 | 1.10 | 27 | 28.7 |
  | 12 | 1.39 | 28 | 43.1 |
  | 13 | 1.60 | 29 | 57.4 |
  | 14 | 1.87 | 30 | 86.1 |
  | 15 | 2.27 | 31 | 172.3 |
- ALFO waveform: specifies the amplitude modulation waveform.

  | Value | Waveform | |
  |---|---|---|
  | 0 | Sawtooth wave | @SAW |
  | 1 | Square wave | @SQU |
  | 2 | Triangle wave | @TRI |
  | 3 | White noise | @NOISE |
- ALFO depth: specifies how strongly amplitude modulation by the LFO is applied. This amplitude modulation can produce a tremolo effect (periodic variation of the volume).

*[p. 265]*

  | ALFO depth | Mixing into the EG |
  |---|---|
  | 0 | No effect |
  | 1 | 0.4 dB variation |
  | 2 | 0.8 dB variation |
  | 3 | 1.5 dB variation |
  | 4 | 3 dB variation |
  | 5 | 6 dB variation |
  | 6 | 12 dB variation |
  | 7 | 24 dB variation |
- PLFO waveform: specifies the frequency modulation waveform.

  | Value | Waveform | |
  |---|---|---|
  | 0 | Sawtooth wave | @SAW |
  | 1 | Square wave | @SQU |
  | 2 | Triangle wave | @TRI |
  | 3 | White noise | @NOISE |
- PLFO depth: specifies how strongly frequency modulation by the LFO is applied. This frequency modulation can produce a vibrato effect (periodic variation of the oscillation frequency of the sound).

  | PLFO depth | Effect on pitch |
  |---|---|
  | 0 | No effect |
  | 1 | ±7 cents variation |
  | 2 | ±13.5 cents variation |
  | 3 | ±27 cents variation |
  | 4 | ±55 cents variation |
  | 5 | ±112 cents variation |
  | 6 | ±230 cents variation |
  | 7 | ±494 cents variation |

*[p. 266]*

**[Details]**

Rewrites the LFO settings, layer by layer, for the voice data currently in sound memory. They can also be changed in real time during playback. In this case, the rewritten values take effect at note-on timing.

If only "," is given, the item is skipped, and the value of a skipped item does not change.

The LFO is a low-frequency oscillator, used to modulate the audio signal. Each slot has one LFO, and each has an output for amplitude modulation and an output for frequency modulation of its slot. The LFO output waveform has 4 types, sawtooth wave, square wave, triangle wave and white noise, and any of these can be chosen.

Except for noise, the sawtooth, square and triangle waves can be reset and have their frequency changed.

The LFO waveform and modulation depth can be set independently for the amplitude modulation side and the frequency modulation side.

The contents of the parameters are the same as item numbers 50 to 55 of the TPROP command. So the values are rewritten if the TPROP command is executed.

**[Caution]** Data that has been reset cannot be saved. If the voice data in sound memory is replaced by the PLAYINIT/TARG commands, values set before that return to the original voice parameters, so to change settings, do so after registering the voice data you want to change in sound memory with the PLAYINIT and TARG commands.

**[Warning]** Depending on how the parameters are given, this command may make the sound stop or become distorted. In that case, execute the PLAYINIT command. If there is still no sound, or communication between the main system and the sound system goes wrong, do a hot start, save the program, reset, and run it again.

*[p. 267]*

### MMLSTAT()

*Fixed-point function*

**Function:** Gets the status during playback.

**Syntax:** `A=MMLSTAT(<track number>,<item number>)`

**Example:**
```
X=MMLSTAT(8,1)
IF MMLSTAT(0,1)THEN
```

**[Parameters]**
- `<track number>`: specifies the MML track number to get. "0 to 15", corresponding to the track numbers given for the MML strings.
- `<item number>`: selects the item to get.

  | Value | Item |
  |---|---|
  | 0 | Value given by a control command (the MML "!" command) |
  | 1 | Note number being sounded |
  | 2 | Direct data level |
  | 3 | Direct pan value |
  | 4 | Total level |

**[Return value]** Differs by item, as follows.
- Item number = 0: the value given by a control command (the MML "!" command) is returned (trigger form). "0 to 127". It becomes "0" after the value has been read.
- Item number = 1: the note number currently being sounded is returned. "0 to 127". "0" is returned when nothing is sounding.
- Item number = 2: the direct data send level. "0 to 7". The value given by "72: direct data send level" of the TPROP command is returned. "0" is returned when nothing is sounding.
- Item number = 3: the direct pan value. "0 to 31". The value set by the MML "P" command or by the auto-pan option of the note-on command is returned. When no pan command has been executed, the value of "73: direct data localisation" of the TPROP command is returned. "0" is returned when nothing is sounding.

*[p. 268]*

- Item number = 4: the total level. "0 to 255". The final volume setting after the MML "(@)V (volume)" command and "v (velocity)" processing is returned. It is not the value after the envelope generator, so it cannot be used for a precise level meter, but it shows roughly how loud the note was sounded. It is an "amount of attenuation", so note that the smaller the value, the louder the sound. "255" is returned when nothing is sounding. For the correspondence between the values and actual levels, see TL in the FM command of the TARG command.

**[Details]**

Gets the sounding state during MML playback, track by track. Because the note number, volume, localisation and so on currently being sounded can be read, you can make a meter with a simple BASIC program, or move a character in time with the notes. Except for item number "0", the current status can be read in real time.

Item number "0" returns the value embedded by the MML "!\<control command\>". If a value from "0 to 127" following "!" is embedded at any position in the MML string, the value is returned when playback reaches that position. It "holds the value" until a new control command appears in the same track or it is read by this command. Once it has been read, "0" is returned.

Using this function, the program can branch in time with the tune at any chosen moment. Also, item number "0" of track "0" can be watched by interrupt with the "ON MMLSTAT GOSUB" statement. For details, see "ON MMLSTAT GOSUB".

**[Caution]** It can be read track by track, but when several sequences are sounding at the same time, you cannot tell which sequence the status belongs to.

**[Example 1]**

```
100 EFFECT (I),"CDE"                    → starts playback.
110 *LOOP
120 IF PLAYSTAT(I)=0 THEN END           → ends when it has finished sounding.
130 MN=MMLSTAT(0,1)                     → reads the new status.
140 IF MN=MO THEN *LOOP ELSE MO=MN      → if the same as the status read last time, go back.
150 IF MN=60 THEN PRINT "C ";             If different, display the parameter according to
160 IF MN=62 THEN PRINT "D ";             the new status value.
170 IF MN=64 THEN PRINT "E ";
180 GOTO *LOOP
```

*[p. 269]*

**[Example 2]**

```
100 EFFECT (I),"CDEFGAB>CD !1 EFGAB>CDEFGAB" → embeds the "!" command.
110 *LOOP
120 IF MMLSTAT(0,0)=1 THEN PLAYFADE I,60     → when playback reaches the "!1" position,
130 GOTO *LOOP                                 starts fade processing.
```

### ON MMLSTAT GOSUB

*Program-mode command*

**Function:** Watches the MML control command ("!") by interrupt, and sets the subroutine to execute when a value comes back.

**Syntax:** `ON MMLSTAT GOSUB <line number|label>`

**Example:**
```
ON MMLSTAT GOSUB 2000
ON MMLSTAT GOSUB *CHANGE_BGM
```

**[Parameters]**
- `<line number>`: the valid range is an integer from 1 to 99999.
- `<label>`: write the name of a label that exists in the program. The names that can be given follow the label naming rules.

**[Details]**

Specifies the interrupt processing called when an MML "!\<control command\>" is in track "0" and returns a value other than "0". When this command is executed, the MML status starts to be watched at V-Sync timing. When the control command of track "0" becomes other than "0", the interrupt processing subroutine given by this command is called.

The control command sent can be read with "MMLSTAT(0,0)" "inside the interrupt processing" (the "1 to 127" that was set is returned), so finer processing can be done according to the value (for example, changing the BGM at a convenient bar boundary).

**[Caution]**

Interrupts from other interval timers are accepted even during interrupt processing, so when handling the same resources you must disable interrupts temporarily with the LOCK command or do exclusive processing on your own responsibility.

If interrupt processing takes too long, the GOSUB stack overflows, so take care. Also, with heavy processing such as scrolling, screen clearing, PAINT and INPUT, the interrupt processing cannot be done in time and the program pauses, so take care. For the operation of interval timer interrupts, see the INTERVAL command.

*[p. 270]*

Reading of the next control command starts from the moment "MMLSTAT(0,0)" is executed, so if control commands are close together, interrupts occur one after another and the main processing is not done.

**[Note]**

When changing the BGM, it is convenient to use the song number as the control command. Because MML control commands are issued at note-on timing, by the time one has been issued and the interrupt occurs, "the next note may already have started sounding". The technique for switching at exactly the right moment is as follows.

- To make an interrupt occur at the moment these 2 bars finish playing:

```
DATA #0,"|L4 R1       |R R R R8 R16 R32 !1 R32"
DATA #1,"|L4 C D E F  |C D E F"
  :
```

It varies somewhat with the playback tempo, but the interrupt processing starts after roughly the time of a 32nd note has passed since the control command was issued. So the control command is embedded a 32nd note early, as above.

If track "0" cannot be used only for control, or a finer timing is needed, adjust the note lengths using the direct length "l\<n\>".

### PLAY

*Direct-mode command / Program-mode command*

**Function:** Plays music (a sound effect) given by an MML string. Executes one command at a time, waiting for playback to finish.

**[Caution]** This command is provided to keep compatibility with conventional MML. It cannot make full use of the functions of this sound system.

**Syntax:** `PLAY [volume,]<[#<track number>,]"MML string">{[,<[#<track number>,]"MML string">]}` (repeated for up to 16 tracks)

**Example:** `PLAY 60,"CDE"` → plays do-re-mi at volume "60".

**[Parameters]**
- Volume: specifies the volume during playback. "0 to 255"; the larger the value, the louder. Default = 127. A value of 128 or more makes it louder than the original volume of the waveform data. Normally give 127 or less.

*[p. 271]*

- `#<track number>`: specifies which track (performance part) the MML string that follows is expanded into. Within the range "0 to 15" the numbers need not be consecutive, and the order can be changed. However, the state of the previously executed PLAY command is kept for each track, so if the track numbers are rearranged partway through, it plays with the voice and note length that were given in the previous PLAY command. If the track number of the first MML is omitted, it is track "0". If the track of an MML partway through is omitted, it is the previously assigned track + 1. An error occurs if this goes beyond 15.
- `<"MML string">`: defines score data as a string. For details, see "2.6 MML details". MML strings can be given for up to 16 tracks, separated by ",". A track given nothing is a "rest". Also, even if the total playing times of the tracks do not match, they can be forcibly matched by the next PLAY command (the time left over is treated as a rest).

**[Details]**

The PLAY command is provided to carry over the conventional MML specification, so it cannot make full use of the functions of this sound system. It analyses one command at a time, starts playback each time, and waits for it to finish before moving on to the next command. When PLAY commands are written over several lines in a program, the values of the previous PLAY command are carried over as they are (note length, octave and so on). When executed in direct mode, it is initialised to the default values each time before executing.

The format of the MML string is the same as for the other commands that take MML strings, but only 4 blocks of song data are reserved, so if complicated parameter sub-options (such as pitch bend) are given on one line, it stops with a "Sound:Song bank full" error. The number of notes that can be given in 4 blocks is about 150 when quarter notes are sounded as they are. PLAY executes one command at a time, so if this error is displayed, split it over several lines.

**[Caution]** The number of blocks of the song data area reserved for the PLAY command is fixed by the system and cannot be changed. Playback uses a temporary area not assigned to any song number, so song data played by the PLAY command does not remain in sound memory. To call it again by giving a song number, use the EFFECT command or the SETSONG command.

*[p. 272]*

### PLAYSTAT()

*Fixed-point function*

**Function:** Examines whether the given sequence number is playing.

**Syntax:** `A=PLAYSTAT(<sequence number>)`

**Example:**
```
BGM 1:VSYNC 2
*LBL:IF PLAYSTAT(0)=1 THEN *LBL    → loops at *LBL while the BGM is sounding
```

**[Parameters]**
- `<sequence number>`: specifies the sequence number to examine. Give the return value of the EFFECT command. "0 to 7". For a sequence sounded by BGM, give "0".

**[Return value]** "1" while playing, "0" while stopped.

**[Details]** Examines whether the given sequence number is currently playing. Because it is a function for examining whether a new song can be played, a song paused by the PLAYPAUSE command is also treated as "playing".

**[Caution]** When a minus sign is put on the song number in the EFFECT command, or playback is started with the BGM command, the status just after may not be "1" (because the sound system and the main system run in parallel). In this case, leave at least 2 syncs after the start of playback before reading it (see the VSYNC command).

### PLAYCONT

*Direct-mode command / Program-mode command*

**Function:** Resumes playback paused by PLAYPAUSE.

**Syntax:** `PLAYCONT <sequence number>`

**Example:**
```
EFFECT(I),"dc CDEFGABdc"   → starts playback with the EFFECT command, pauses it 10 seconds later,
VSYNC 60*10:PLAYPAUSE I      and resumes 2 seconds after that
VSYNC 60*2:PLAYCONT I
```

**[Parameters]**
- `<sequence number>`: specifies the sequence number whose playback is to be resumed. Give the return value of the EFFECT command. "0 to 7", and "−1" and "−2".

*[p. 273]*

**[Details]** For a sequence sounded by BGM, give "0". If "−1" is given, all BGM and sound effects are resumed. If "−2" is given, all sound effects except the BGM are resumed.

### PLAYFADE

*Direct-mode command / Program-mode command*

**Function:** Gradually changes the volume of the sound being played on the given sequence number.

**Syntax:** `PLAYFADE <sequence number>,<volume>,<fade rate>`

**Example:**
```
PLAYFADE 0,0,50
PLAYFADE I,64,80
```

**[Parameters]**
- `<sequence number>`: specifies the sequence number to fade. Give the return value of the EFFECT command. "0 to 7", and "−1" and "−2".
- `<volume>`: specifies the volume during playback. "0 to 255"; the larger the value, the louder. Default = 127. A value of 128 or more makes it louder than the original volume of the waveform data. Normally give 127 or less. Setting the value to "0" stops playback.
- `<fade rate>`: specifies the fade speed. The final volume of the fade is the value given by "volume". "0 to 255"; the smaller the value, the faster the fade. If "0" is given, it goes straight to the "volume" value without fade processing.

**[Details]** For a sequence sounded by BGM, give "0". If "−1" is given, fade processing is done on all BGM and sound effects. If "−2" is given, fade processing is done on all sound effects except the BGM.

*[pp. 274–354]*

> **Pending.** The rest of section 2.5 (from p. 274) and section 2.6, "MML details", are not yet translated.

*[p. 355]*

## 2.7 Repeat structure details

### Details of segno, dal segno, coda, repeat marks and so on

**[Example 1]**
```
A B |: C D :|
```
Playing order: AB CD CD

**[Example 2]**
```
A B :| C D
```
Playing order: AB AB CD

**[Example 3]**
```
A B C D :|
```
Playing order: ABCD ABCD

**[Example 4]**
```
A B :|: C D :|
```
Playing order: AB AB CD CD

**[Example 5]**
```
A B :|: C D |1 E :|2 F
```
Playing order: AB AB CDE CDF

**[Example 6]**
```
A B dc C D dc
```
Playing order: AB CD CD CD ……

**[Caution]** In standard musical notation you go back to the start of the piece and are affected by D.S. and coda, but in this MML the part enclosed by the two "dc" marks loops endlessly, for game BGM.

*[p. 356]*

**[Example 7]**
```
A $ B * C ds D
```
Playing order: ABC BD

**[Example 8]**
```
A B $ C D * E |: F G |1 H I :|2 J K ds L M
```
Playing order: ABCDEFGHI FGJK CDLM

**[Example 9]**
```
A $1;3 B *1;3 C $2 D *2 E ds1 F ds2 G |:H |1I :|2J ds3 |: K |1 L :|2 M
```
Playing order: ABCDE BF DGHI HJ BKL KM

This is a complicated way of specifying it, so let us follow it in more detail.

- **A**: A is played (the intro part). Segno 1 "`$1`" is registered. Segno 3 "`$3`" is registered.
- **B** (segno 1, 3): B is played. The first coda mark 1 "*1" is skipped. The first coda mark 3 "*3" is skipped.
- **C**: C is played. Segno 2 "`$2`" is registered.
- **D** (segno 2): D is played. The first coda mark 2 "*2" is skipped.
- **E**: E is played. Dal segno 1 "ds1" returns to the segno 1 "`$1`" point.
- **B**: B is played (2nd time). The second coda mark 1 "*1" skips to just after "ds1".
- **F** (coda 1): F is played. Dal segno 2 "ds2" returns to the segno 2 "`$2`" point.
- **D**: D is played (2nd time). The second coda mark 2 "*2" skips to just after "ds2".
- **G** (coda 2): G is played. The repeat start point "|:" is registered.
- **H** (repeat position): H is played. The mark "|1" for the part played the 1st time.
- **I**: I is played. Returns to the repeat start point "|:" once only.
- **H**: H is played (2nd time). Skips the part played the 1st time and jumps to the position for the 2nd time.

*[p. 357]*

- **J** (part for the 2nd time): J is played. Dal segno 3 "ds3" returns to the segno 3 "`$3`" point.
- **B**: B is played (3rd time). The second coda mark 3 "*3" skips to just after "ds3".
- **Coda 3**: the repeat start point "|1" (sic) is registered.
- **K** (repeat position): K is played. The mark "|1" for the part played the 1st time.
- **L**: L is played. Jumps to the repeat start point "|:" once only.
- **K**: K is played (2nd time). Skips the part played the 1st time and jumps to the position for the 2nd time.
- **M** (part for the 2nd time): M is played. End.

As you can see by looking closely at the examples shown here, repeats and skips follow these fixed rules.

- **Repeat:** a repeat using segno and dal segno is valid only once.
- **Skip:** only a part that has been played once can be skipped. For example, in the example above, you cannot jump to the part starting with coda mark 2 "*2" or coda mark 3 "*3" before the part starting with coda mark 1 "*1" has been played.

*[p. 358]*

## 2.8 Voice data details

### Classification of voice data

Voice data files fall broadly into the following 4 groups. Each has 4 sets, so 16 sets in all are provided as standard.

**[Caution]** Note the following about the notation below.
- "…" is the file name given to the PLAYINIT and TLIST commands.
- The start of each set of voice data contains the common voice data for the BEEP command (error sound) (except "GM_FM1" to "GM_FM2" (sic)).
- The sound sources that follow are the sound sources of different instruments depending on the set.

**[1]**

| Set | File name | |
|---|---|---|
| Standard Set | "STANDARD" | Standard set |
| Orchestra Set | "ORCHEST" | Orchestra set |
| Rock Set | "ROCK" | Rock music set |
| Dance Set | "DANCE" | Dance music set |

As a game sound set, voice data files containing sound-effect data are provided so they can be used easily without any special registration work (the sound-effect data is duplicated at the start of the 4 files). These voice data files contain many sound sources in one file so that they can handle all-round music.

**[2]**

| Set | File name | |
|---|---|---|
| Piano Solo Set | "PIANO" | Piano solo set (piano only) |
| Heavy Metal Set | "METAL" | Heavy metal set |
| Ethnic Set | "ETHNIC" | Ethnic instrument set |
| MUSIC BOX & Pipe Organ Set | "MBOXPO" | Music box & pipe organ set |

*[p. 359]*

These are high-quality sets specialised for particular music genres. The sound-effect data is left out, and the data is sampled giving priority to quality within the limited voice data area.

For example, the piano sound is also in "ORCHEST", but to fit in the sounds of other instruments, only the basic range could be included, and the rest is sounded by changing the frequency on the program side, so the sound quality falls the further you go from the range that was included.

The piano solo set, on the other hand, leaves out all other instrument sounds and uses the full size of a file to sample only the piano sound. Different ranges are sampled separately, to bring it as close as possible to the real sound. The range is divided finely, and the sampling data used is switched according to the scale, reducing frequency changes by the program.

**[3]**

| Set | File name | |
|---|---|---|
| Extra Set 1 | "EXTRA1" | Extra set 1 |
| Extra Set 2 | "EXTRA2" | Extra set 2 |
| Extra Set 3 | "EXTRA3" | Extra set 3 |
| Extra Set 4 | "EXTRA4" | Extra set 4 |

Voice sets intended to be rearranged with the TARG command. They can be used as they are, like the sets of [1] and [2], but high-quality BGM can be created by selecting the voice data you need and rearranging it with the TARG command.

**[Caution]** Program number 0 (voice number 0) of the voice files of [1] to [3] contains the voice data used by the BEEP command.

**[4]**

| Set | File name | |
|---|---|---|
| GM FM Set 1 | "GM_FM1" | GM-arranged FM sound source set 1 |
| GM FM Set 2 | "GM_FM2" | GM-arranged FM sound source set 2 |
| GM FM Set 3 | "GM_FM3" | GM-arranged FM sound source set 3 |
| GM FM Set 4 | "GM_FM4" | GM-arranged FM sound source set 4 |

These are GM (General MIDI) arranged sets using the FM sound source (voice numbers "0 to 127"). They can also be used in combination with the voice data in the PCM sound source files. The FM sound source does not use much waveform memory, so memory overflow is unlikely when rearranging with the TARG command, and it has the advantage over PCM sampled in particular ranges that the sound quality is constant over the whole range. When playing with the GM arrangement, high-quality playback can be achieved by making up with PCM for drums and for sounds with long releases such as cymbals, which FM is poor at.

**[Caution]** Only these sets have a different BEEP voice.

*[p. 360]*

### Explanation of the common voices (sound effects)

This explains the relatively common voices (sound effects). Use it when using sound effects and so on in a game.

**Voice explanations**

| No. | Voice Name | Layer Name | Recommended range | Voice | |
|---|---|---|---|---|---|
| 00 | BEEP | BEEP | 000-127 | | |
| 01 | HEY!男声 | HEY | 000-127 | Male voice | For fighting games |
| 02 | HUA男声 | HUA | 000-127 | Male voice | For fighting games |
| 03 | POH男声 | POH | 000-127 | Male voice | For fighting games |
| 04 | KYA女声 | KYA | 000-127 | Female voice | For fighting games |
| 05 | TAH女声 | TAH | 000-127 | Female voice | For fighting games |
| 06 | TOH女声 | TOH | 000-127 | Female voice | For fighting games |
| 07 | WAH女声 | WAH | 000-127 | Female voice | For fighting games |
| 08 | YAH女声 | YAH | 000-127 | Female voice | For fighting games |
| 09 | HAH男声 | HAH | 000-127 | Male voice | For fighting games |
| 10 | TOH2男声 | TOH2 | 000-127 | Male voice | For fighting games |
| 11 | CHUKIN | CHUKIN | 000-127 | "Chukin" (cocking) | |
| 12 | NOISE | NOISE | 000-127 | White noise (explosion) | |
| 13 | BA | BA | 000-127 | "Ba" (door) | |
| 14 | BASHA | BASHA | 000-127 | "Basha" (scratch sound) | |
| 15 | DOKA | DOKA | 000-127 | "Doka" (hit sound) | |
| 16 | KACHA | KACHA | 000-127 | "Kacha" (opening/closing sound) | |
| 17 | SHU | SHU | 000-127 | "Shu" (firing sound) | |
| 18 | SAW WAVE | SAW WAVE | 000-127 | Sawtooth wave (system sounds etc.) | |
| 19 | SINE WAVE | SINE WAVE | 000-127 | Sine wave (system sounds etc.) | |
| 20 | SQUARE WAVE | SQUARE WAVE | 000-127 | Square wave (system sounds etc.) | |
| 21 | SAW SE1 | SAW SE1 | 000-127 | Sawtooth wave application (energy) | |
| 22 | SINE SE1 | SINE SE1 | 000-127 | Sine wave application (inside a spaceship) | |
| 23 | SQUARE SE1 | SQUARE SE1 | 000-127 | Square wave application (futuristic machine sound) | |
| 24 | SAW SE2 | SAW SE2 | 000-127 | Sawtooth wave application (comical) | |
| 25 | SINE SE2 | SINE SE2 | 000-127 | Sine wave application (UFO flying) | |

*[p. 361]*

| No. | Voice Name | Layer Name | Recommended range | Voice |
|---|---|---|---|---|
| 26 | SQUARE SE2 | SQUARE SE2 | 000-127 | Square wave application (UFO flying) |
| 27 | SINE SE3 | SINE SE3 | 000-127 | Sine wave application (sound of outer space) |
| 28 | Crystal Bell | Crystal Bell | 000-127 | Crystal bell |
| 29 | GLOCKEN | GLOCKEN | 000-127 | Metallic percussion sound |
| 30 | RUM | RUM | 000-127 | Beam firing sound |

(男声 = male voice, 女声 = female voice.)

### How to read the lists

| Item name | Item number given in TPROP | Explanation |
|---|---|---|
| No | | Voice number (voice program number) |
| Voice Name (Layer Name) | | Instrument name |
| Bd | 0 | Bend range |
| Ly | 1 | Layer number |
| sn | 10 | Start note |
| en | 11 | End note |
| bn | 12 | Base note |
| ft | 13 | Fine tune |
| AR | 20 | Attack rate |
| DR | 21 | Decay rate |
| SR | 22 | Sustain rate |
| RR | 23 | Release rate |
| SL | 24 | Sustain level |
| KS | 27 | Key rate scaling |
| RE | 50 | LFO reset |
| LF | 51 | LFO frequency |
| AW | 52 | LFO amplitude modulation waveform |
| AS | 53 | LFO amplitude modulation depth |
| PW | 54 | LFO frequency modulation waveform |
| PS | 55 | LFO frequency modulation depth |
| MX | 71 | Input mix level |
| DS | 72 | Direct data send level |
| DP | 73 | Direct data localisation |

The number under each item is the item number given in the TPROP command. Where a number is given under the instrument name in the tables below, it is the recommended range. It means that when sounded at note numbers in that range, the characteristics of the given instrument appear, or it can be used for other purposes.

*[p. 362]*

If the voice data you need no longer fits in memory, you can deal with it by using layer edit mode and copying only the waveforms of the range you need.

For example, to use only the high range of the "STANDARD" strings:

```
DATA "BUILDLAYER"
DATA "STANDARD"   ,44, 1,-1,-1, -1
DATA "ENDLAYER"
```

If the range N56 to N75 of the "PIANO" set is enough:

```
DATA "BUILDLAYER"
DATA "PIANO"    , 1, 4,-1,-1, -1
DATA            , 1, 5,-1,-1, -1
DATA            , 1, 6,-1,-1, -1
DATA "ENDLAYER"
```

### \<STANDARD\> Standard set

In the voice tables, the column headings carry the TPROP item numbers: Bd 0, Ly 1, sn 10, en 11, bn 12, ft 13, AR 20, DR 21, SR 22, RR 23, SL 24, KS 27, RE 50, LF 51, AW 52, AS 53, PW 54, PS 55, MX 71, DS 72, DP 73. The tables are reproduced as printed.

```
No Voice Name           Bd Ly  sn- en : bn/ ft AR-DR-SR-RR:SL KS RE LF AW AS PW PS MX DS DP
   ( Layer Name )
 0 BEEP                 12  0   0-127 : 72/ 44 15-14- 0-15: 0  0  0  0  0  0  1  0  0  7  0
 1 HEY!男声             12  0   0-127 : 72/  0 31- 0- 0- 6: 0  0  0  0  0  0  0  0  0  7  0
 2 HUA男声              12  0   0-127 : 72/  0 31- 0- 0-15: 0  0  0  0  0  0  0  0  0  7  0
 3 POH男声              12  0   0-127 : 72/  0 31- 0- 0-14: 0  0  0  0  0  0  0  0  0  7  0
 4 KYA女声              12  0   0-127 : 72/  0 31- 0- 0-18: 0  0  0  0  0  0  0  0  0  7  0
 5 TAH女声              12  0   0-127 : 72/  0 31- 0- 0-21: 0  0  0  0  0  0  0  0  0  7  0
 6 TOH女声              12  0   0-127 : 72/  0 31- 0- 0-20: 0  0  0  0  0  0  0  0  0  7  0
 7 WAH女声              12  0   0-127 : 72/  0 31- 0- 0-19: 0  0  0  0  0  0  0  0  0  7  0
 8 YAH女声              12  0   0-127 : 72/  0 31- 0- 0-20: 0  0  0  0  0  0  0  0  0  7  0
 9 HAH男声              12  0   0-127 : 72/  0 31- 0- 0-20: 0  0  0  0  0  0  0  0  0  7  0
10 TOH2男声             12  0   0-127 : 72/  0 31- 0- 0-15: 0  0  0  0  0  0  0  0  0  7  0
11 CHUKIN               12  0   0-127 : 72/  0 31-11-24-12:13  0  0  0  0  0  0  0  0  7  0
12 NOISE                12  0   0-127 : 72/  0 31- 0- 0-14: 0  0  0  0  3  0  3  0  0  7  0
13 BA                   12  0   0-127 : 72/  0 31- 0- 0-14: 0  0  0  0  0  0  0  0  0  7  0
14 BASHA                12  0   0-127 : 72/  0 31- 0- 0-20: 0  0  0  0  0  0  0  0  0  7  0
15 DOKA                 12  0   0-127 : 72/  0 31- 0- 0-11: 0  0  0  0  0  0  0  0  0  7  0
16 KACHA                12  0   0-127 : 72/  0 31- 0- 0-20: 0  0  0  0  0  0  0  0  0  7  0
17 SHU                  12  0   0-127 : 72/  0 31- 0- 0-11: 0  0  0  0  0  0  0  0  0  7  0
```

In the voice names, 男声 means "male voice" and 女声 means "female voice". The same common voices appear at the start of every set that follows.

*[p. 363]*

\<STANDARD\>

```
No Voice Name           Bd Ly  sn- en : bn/ ft AR-DR-SR-RR:SL KS RE LF AW AS PW PS MX DS DP
   ( Layer Name )
18 SAW WAVE             12  0   0- 38 : 48/  0 31-23- 0-20: 2  0  0  0  0  0  0  0  0  6  0
                            1  39- 44 : 54/ -6 31- 0- 0-22: 0  0  0  0  0  0  0  0  0  6  0
                            2  45- 50 : 60/ 16 31- 0- 0-23: 0  0  0  0  0  0  0  0  0  6  0
                            3  51- 56 : 66/ 32 31- 0- 0-22: 0  0  0  0  0  0  0  0  0  6  0
                            4  57- 62 : 72/ 40 31- 0- 0-22: 0  0  0  0  0  0  0  0  0  6  0
                            5  63- 68 : 78/ 32 31- 0- 0-22: 0  0  0  0  0  0  0  0  0  6  0
                            6  69- 74 : 84/-14 31- 0- 0-22: 0  0  0  0  0  0  0  0  0  6  0
                            7  75- 80 : 90/ 34 31- 0- 0-22: 0  0  0  0  0  0  0  0  0  6  0
                            8  81- 86 : 96/-12 31- 0- 0-22: 0  0  0  0  0  0  0  0  0  6  0
                            9  87-127 :102/ 32 31- 0- 0-24: 0  0  0  0  0  0  0  0  0  6  0
19 SINE WAVE            12  0   0-127 : 95/-62 22- 0- 0-18: 0  0  0  0  0  0  0  0  0  6  0
20 SQUARE WAVE          12  0   0- 38 : 48/-30 25- 0- 0-20: 0  0  0  0  0  0  0  0  0  6  0
                            1  39- 44 : 54/-62 25- 0- 0-23: 0  0  0  0  0  0  0  0  0  6  0
                            2  45- 50 : 60/ 16 25- 0- 0-23: 0  0  0  0  0  0  0  0  0  6  0
                            3  51- 56 : 66/ -6 25- 0- 0-23: 0  0  0  0  0  0  0  0  0  6  0
                            4  57- 62 : 72/-12 25- 0- 0-23: 0  0  0 18  2  0  2  0  0  6  0
                            5  63- 68 : 77/-78 25- 0- 0-23: 0  0  0  0  0  0  0  0  0  6  0
                            6  69- 74 : 84/ 90 25- 0- 0-23: 0  0  0  0  0  0  0  0  0  6  0
                            7  75- 80 : 90/ 32 25- 0- 0-23: 0  0  0  0  0  0  0  0  0  6  0
                            8  81- 86 : 96/-12 25- 0- 0-23: 0  0  0  0  0  0  0  0  0  6  0
                            9  87-127 :102/ 32 25- 0- 0-23: 0  0  0  0  0  0  0  0  0  6  0
21 SAW SE1              12  0   0-127 : 72/ 40 31- 0- 0-22: 0  0  0  0  0  0  0  0  0  7  0
22 SINE SE1             12  0   0-127 : 95/-62 31- 0- 0-31: 0  0  1  2  0  0  0  2  0  6  0
23 SQUARE SE1           12  0   0-127 : 72/-12 31- 0- 0-27: 0  0  0 18  2  0  2  0  0  6  0
24 SAW SE2              12  0   0-127 : 72/ 40 31-15-21-14: 9  0  0 21  0  0  1  6  0  7  0
25 SINE SE2             12  0   0-127 : 95/-62 31- 0- 0-31: 0  0  0  0  0  0  0  0  0  6  0
26 SQUARE SE2           12  0   0-127 : 72/-12 31- 0- 0-27: 0  0  1 12  1  0  2  7  0  6  0
27 SINE SE3             12  0   0-127 : 95/-62 31- 8-12-11:23  0  0 21  1  0  0  3  0  6  0
28 Crystal Bell         12  0   0-127 : 72/  0 31- 7-15-13: 9  0  0  0  3  0  3  0  0  7  0
29 GLOCKEN              12  0   0-127 : 74/  0 31- 0- 8-18: 5  0  0  0  0  0  0  0  6  7  0
```

*[p. 364]*

\<STANDARD\>

```
No Voice Name           Bd Ly  sn- en : bn/ ft AR-DR-SR-RR:SL KS RE LF AW AS PW PS MX DS DP
   ( Layer Name )
30 RUM                  12  0   0-127 : 74/  0 31-11- 0-31:31  0  0  0  0  0  0  0  6  7  0
31 Drum Set             12
     kick                   0   0- 36 : 48/-88 31- 0- 0-14: 0  0  0  0  0  0  0  0  0  7  0
     Snare                  1  38- 38 : 41/  0 29- 0- 0-13: 0 -1  0  0  0  0  0  0  7  7  0
     Electric Snare         2  40- 40 : 15/  0 29-10- 3-18: 5 -1  0  0  0  0  0  0  7  7  0
     close H H              3  42- 44 : 51/  0 31- 3- 0-20: 0  0  0  0  0  0  0  0  2  5  2
     open H H               4  46- 46 : 56/  0 31-16-15-14:22  0  0  0  0  0  0  0  2  5  2
     Low Tom                5  41- 41 : 54/  0 28- 9-12-13: 5 -1  0  0  0  0  0  0  4  6 25
     Mid Tom                6  45- 45 : 49/  0 29- 9-10-14: 5 -1  0  0  0  0  0  0  4  6 19
     High Tom               7  48- 48 : 46/  0 28- 9-12-14: 5 -1  0  0  0  0  0  0  4  6  5
     clash Cymbal 1         8  49- 49 : 56/  0 31- 9- 0-11: 0  0  0  0  0  0  0  0  4  7 28
     Ride Cymbal            9  51- 51 : 55/  0 31-17-26-12:27  0  0  0  0  0  0  0  3  5 12
     clash Cymbal 2        10  52- 72 : 64/  0 31-13- 0-12: 0  0  0  0  0  0  0  0  4  6 15
32 Percussion Set       12
     Cabasa                 0  65- 71 : 67/  0 31- 0- 0-14: 0  0  0  0  0  0  0  0  1  7 29
     Tambourine             1  40- 54 : 58/  0 31-11- 0-16: 7 -1  0  0  0  0  0  0  6  7 13
     Conga Low              2  64- 64 : 71/  0 31- 0- 0-14: 0  0  0  0  0  0  0  0  4  7 23
     Conga Hi               3  63- 63 : 70/  0 31- 0- 0-14: 0  0  0  0  0  0  0  0  4  7 23
     Conga Mute             4  55- 62 : 70/  0 31- 0- 0-14: 0  0  0  0  0  0  0  0  4  7 31
     808Tom Low             5  72- 72 : 93/  0 31- 0- 0-23: 0 -1  0  0  0  0  0  0  4  7 31
     808Tom Mid             6  84- 84 : 96/  0 31- 0- 0-31: 0  0  0  0  0  0  0  0  4  7  0
     808Tom Hi              7  96-127 :100/  0 31- 0- 0-31: 0  0  0  0  0  0  0  0  4  7 15
     Hand Clap              8   0- 39 : 56/  0 31- 8-11-18: 4 -1  0  0  0  0  0  0  4  7  0
                            9   0- 39 : 59/  0 28- 7-19-17: 5 -1  0  0  0  0  0  0  4  7  0
33 Pick Bass            12  0   0-127 : 62/-50 31- 0- 9-17: 0  0  0  0  0  0  0  0  0  7  0
     36 - 127
34 A.Bass               12  0   0-127 : 67/ 36 31-10- 7-16:10 -1  0  0  0  0  0  0  0  7  0
     36 - 96
35 Synth Bass           12  0   0-127 : 43/ 70 29-14- 0-23: 3 -1  0  0  0  0  0  0  1  7  0
     0 - 127
```

*[p. 365]*

\<STANDARD\>

```
No Voice Name           Bd Ly  sn- en : bn/ ft AR-DR-SR-RR:SL KS RE LF AW AS PW PS MX DS DP
   ( Layer Name )
36 A.Piano              12  0   0-127 : 96/ 84 27-11- 6-24: 9 -1  0  0  0  0  0  0  4  7  0
     36 - 88
37 Rhodes E.Piano       12  0   0-127 : 79/ 70 25-11- 6-20: 9 -1  0  0  0  0  0  0  5  7  0
     24 - 104
38 Organ                12  0   0- 62 : 55/ 70 28-12- 1-31: 2 -1  0  0  0  0  0  0  6  7  0
     28 - 62                1  63-127 : 79/ 70 28-12- 1-31: 2 -1  0  0  0  0  0  0  6  7  0
39 A.Guitar             12  0   0-127 : 84/  0 31-11-11-22: 5 -1  0  0  0  0  0  0  6  7 16
     28 - 108
40 Clean Guitar         12  0   0- 72 : 67/ 66 29-12-10-22: 7 -1  0  0  0  0  0  0  5  7  0
     24 - 72                1  73-127 : 91/ 70 29-12-10-22: 7 -1  0  0  0  0  0  0  5  7  0
41 Over Drive Guitar    12  0  58-127 : 93/100 31- 0- 0-22: 0 -1  0  0  0  0  0  0  6  7  0
     36 - 88                1   0- 57 : 73/110 31- 0- 0-31: 0  0  0  0  0  0  0  0  6  7  0
42 Glocken              12  0   0-127 : 90/ 10 30-11-12-15: 4 -1  0  0  0  0  0  0  6  7  0
     60 - 95
43 Marimba              12  0   0-127 : 89/ 60 31-12-10-22: 9 -1  0  0  0  0  0  0  2  7  0
     48 - 108
44 Strings              12  0   0- 67 : 66/104 20- 0- 0-15: 0  0  0  0  0  0  0  0  6  6 16
     28 - 100               1  68-127 : 90/112 26- 0- 0-15: 0  0  0  0  0  0  0  0  6  6 16
45 Brass Sec.           12  0   0-127 : 97/126 27- 9- 5-19: 0 -1  0 10  0  0  0  2  6  7  0
     40 - 96
46 Horn                 12  0   0-127 : 71/ 50 26- 6- 0-15: 1 -1  0  0  0  0  0  0  5  7  0
     53 - 79
47 A.Sax                12  0   0-127 : 78/-86 17- 6- 0-23: 4 -1  0 19  0  0  2  3  6  7  0
     48 - 88
48 Flute & Piccolo      12  0   0- 44 : 58/ 74 16-13- 3-19: 3 -1  0 19  2  1  2  1  6  7  0
     60 - 96                1  45-127 :78/-112 16-13- 0-19: 0 -1  0  0  2  0  2  0  6  7  0
49 Oboe                 12  0   0-127 : 71/  0 25- 7- 0-22: 3 -1  0  0  0  0  0  0  6  7 16
     48 - 89
50 Clarinet             12  0   0-127 : 77/ 90 17- 0- 0-22: 0 -1  0 18  2  1  2  3  6  7 16
     36 - 89
```

*[p. 366]*

\<STANDARD\>

```
No Voice Name           Bd Ly  sn- en : bn/ ft AR-DR-SR-RR:SL KS RE LF AW AS PW PS MX DS DP
   ( Layer Name )
51 Synth Pad 1          12  0   0-127 : 84/ 10 23- 9- 0-17: 4 -1  0  0  0  0  0  0  6  7  0
     (Synth Brass)          1   0-127 : 84/ 40 23- 9- 0-17: 4 -1  0  0  0  0  0  0  6  7  0
     24 - 91
52 Synth Pad 2          12  0   0-127 : 79/ 86 18- 4- 7-15: 6 -1  0  0  0  0  0  0  5  6 31
     (Hielm Pad)            1   0-127 : 79/ 74 18- 4- 7-15: 6 -1  0  0  0  0  0  0  5  6 15
     43 - 96
53 Brightness           12  0   0-127 :89/-100 29-10- 3-14: 4 -1  0  0  0  0  0  0  6  6  0
     (Bell Strings)         1   0-127 : 67/ 60 23- 6- 8-14: 5 -1  0  0  0  0  0  0  6  5 16
     60 - 96                2   0-127 : 79/ 60 31- 6- 8-14: 5 -1  0  0  0  0  0  0  6  5 16
54 Solo Synth Lead 1    12  0   0-127 :79/-102 18- 7- 0-19: 6  0  0 22  0  1  2  3  6  7  0
     35 - 98
55 Solo Synth Lead 2    12  0   0-127 : 79/ 56 27- 7- 0-19: 6  0  0 18  0  0  2  2  6  7  0
     24 - 103
```

### \<ORCHEST\> Orchestra set

```
No Voice Name           Bd Ly  sn- en : bn/ ft AR-DR-SR-RR:SL KS RE LF AW AS PW PS MX DS DP
   ( Layer Name )
 0 BEEP                 12  0   0-127 : 72/ 44 15-14- 0-15: 0  0  0  0  0  0  1  0  0  7  0
 1 HEY!男声             12  0   0-127 : 72/  0 31- 0- 0- 6: 0  0  0  0  0  0  0  0  0  7  0
 2 HUA男声              12  0   0-127 : 72/  0 31- 0- 0-15: 0  0  0  0  0  0  0  0  0  7  0
 3 POH男声              12  0   0-127 : 72/  0 31- 0- 0-14: 0  0  0  0  0  0  0  0  0  7  0
 4 KYA女声              12  0   0-127 : 72/  0 31- 0- 0-18: 0  0  0  0  0  0  0  0  0  7  0
 5 TAH女声              12  0   0-127 : 72/  0 31- 0- 0-21: 0  0  0  0  0  0  0  0  0  7  0
 6 TOH女声              12  0   0-127 : 72/  0 31- 0- 0-20: 0  0  0  0  0  0  0  0  0  7  0
 7 WAH女声              12  0   0-127 : 72/  0 31- 0- 0-19: 0  0  0  0  0  0  0  0  0  7  0
 8 YAH女声              12  0   0-127 : 72/  0 31- 0- 0-20: 0  0  0  0  0  0  0  0  0  7  0
 9 HAH男声              12  0   0-127 : 72/  0 31- 0- 0-20: 0  0  0  0  0  0  0  0  0  7  0
10 TOH2男声             12  0   0-127 : 72/  0 31- 0- 0-15: 0  0  0  0  0  0  0  0  0  7  0
11 CHUKIN               12  0   0-127 : 72/  0 31-11-24-12:13  0  0  0  0  0  0  0  0  7  0
```

*[p. 367]*

\<ORCHEST\>

```
No Voice Name           Bd Ly  sn- en : bn/ ft AR-DR-SR-RR:SL KS RE LF AW AS PW PS MX DS DP
   ( Layer Name )
12 NOISE                12  0   0-127 : 72/  0 31- 0- 0-14: 0  0  0  0  3  0  3  0  0  7  0
13 BA                   12  0   0-127 : 72/  0 31- 0- 0-14: 0  0  0  0  0  0  0  0  0  7  0
14 BASHA                12  0   0-127 : 72/  0 31- 0- 0-20: 0  0  0  0  0  0  0  0  0  7  0
15 DOKA                 12  0   0-127 : 72/  0 31- 0- 0-11: 0  0  0  0  0  0  0  0  0  7  0
16 KACHA                12  0   0-127 : 72/  0 31- 0- 0-20: 0  0  0  0  0  0  0  0  0  7  0
17 SHU                  12  0   0-127 : 72/  0 31- 0- 0-11: 0  0  0  0  0  0  0  0  0  7  0
18 SAW WAVE             12  0   0- 38 : 48/  0 31-23- 0-20: 2  0  0  0  0  0  0  0  0  6  0
                            1  39- 44 : 54/ -6 31- 0- 0-22: 0  0  0  0  0  0  0  0  0  6  0
                            2  45- 50 : 60/ 16 31- 0- 0-23: 0  0  0  0  0  0  0  0  0  6  0
                            3  51- 56 : 66/ 32 31- 0- 0-22: 0  0  0  0  0  0  0  0  0  6  0
                            4  57- 62 : 72/ 40 31- 0- 0-22: 0  0  0  0  0  0  0  0  0  6  0
                            5  63- 68 : 78/ 32 31- 0- 0-22: 0  0  0  0  0  0  0  0  0  6  0
                            6  69- 74 : 84/-14 31- 0- 0-22: 0  0  0  0  0  0  0  0  0  6  0
                            7  75- 80 : 90/ 34 31- 0- 0-22: 0  0  0  0  0  0  0  0  0  6  0
                            8  81- 86 : 96/-12 31- 0- 0-22: 0  0  0  0  0  0  0  0  0  6  0
                            9  87-127 :102/ 32 31- 0- 0-24: 0  0  0  0  0  0  0  0  0  6  0
19 SINE WAVE            12  0   0-127 : 95/-62 22- 0- 0-18: 0  0  0  0  0  0  0  0  0  6  0
20 SQUARE WAVE          12  0   0- 38 : 48/-30 25- 0- 0-20: 0  0  0  0  0  0  0  0  0  6  0
                            1  39- 44 : 54/-62 25- 0- 0-23: 0  0  0  0  0  0  0  0  0  6  0
                            2  45- 50 : 60/ 16 25- 0- 0-23: 0  0  0  0  0  0  0  0  0  6  0
                            3  51- 56 : 66/ -6 25- 0- 0-23: 0  0  0  0  0  0  0  0  0  6  0
                            4  57- 62 : 72/-12 25- 0- 0-23: 0  0  0 18  2  0  2  0  0  6  0
                            5  63- 68 : 77/-78 25- 0- 0-23: 0  0  0  0  0  0  0  0  0  6  0
                            6  69- 74 : 84/ 90 25- 0- 0-23: 0  0  0  0  0  0  0  0  0  6  0
                            7  75- 80 : 90/ 32 25- 0- 0-23: 0  0  0  0  0  0  0  0  0  6  0
                            8  81- 86 : 96/-12 25- 0- 0-23: 0  0  0  0  0  0  0  0  0  6  0
                            9  87-127 :102/ 32 25- 0- 0-23: 0  0  0  0  0  0  0  0  0  6  0
21 SAW SE1              12  0   0-127 : 72/ 40 31- 0- 0-22: 0  0  0  0  0  0  0  0  0  7  0
22 SINE SE1             12  0   0-127 : 95/-62 31- 0- 0-31: 0  0  1  2  0  0  0  2  0  6  0
23 SQUARE SE1           12  0   0-127 : 72/-12 31- 0- 0-27: 0  0  0 18  2  0  2  0  0  6  0
```

*[p. 368]*

\<ORCHEST\>

```
No Voice Name           Bd Ly  sn- en : bn/ ft AR-DR-SR-RR:SL KS RE LF AW AS PW PS MX DS DP
   ( Layer Name )
24 SAW SE2              12  0   0-127 : 72/ 40 31-15-21-14: 9  0  0 21  0  0  1  6  0  7  0
25 SINE SE2             12  0   0-127 : 95/-62 31- 0- 0-31: 0  0  0  0  0  0  0  0  0  6  0
26 SQUARE SE2           12  0   0-127 : 72/-12 31- 0- 0-27: 0  0  1 12  1  0  2  7  0  6  0
27 SINE SE3             12  0   0-127 : 95/-62 31- 8-12-11:23  0  0 21  1  0  0  3  0  6  0
28 NOISE2               12  0   0-127 : 72/  0 31- 7-15-13: 9  0  0  0  3  0  3  0  0  7  0
29 GLOCKEN              12  0   0-127 : 74/  0 31- 0- 8-18: 5  0  0  0  0  0  0  0  6  7  0
30 RUM                  12  0   0-127 : 74/  0 31-11- 0-31:31  0  0  0  0  0  0  0  6  7  0
31 ORCHEST.PERCUSSION   12
     大太鼓                 0  36- 36 : 64/  0 31-31- 0-13: 0  0  0  0  0  0  0  0  6  7  0
     小太鼓                 1  38- 40 : 65/  0 31- 0- 0-14: 0  0  0  0  0  0  0  0  6  7  2
     ｵｰｹｽﾄﾗｼﾝﾊﾞﾙ 1          2  57- 57 : 80/  0 31- 0- 0- 9: 0  0  0  0  0  0  0  0  6  7  1
     ｵｰｹｽﾄﾗｼﾝﾊﾞﾙ 2          3  59- 59 : 80/  0 31- 0- 0-11: 0  0  0  0  0  0  0  0  6  7 17
     Cabasa                 4  69- 69 : 81/  0 31- 0- 0- 0: 0  0  0  0  0  0  0  0  0  7 21
     Claves                 5  75- 75 :100/  0 31- 0- 0-31: 0  0  0  0  0  0  0  0  6  7 31
     Mute Triangl           6  80- 80 : 92/  0 31- 0- 0-31: 0  0  0  0  0  0  0  0  0  7 31
     Open Triangl           7  81- 81 : 70/  0 31- 8-14-12:13  2  0  0  0  0  0  0  6  7 31
     Castanets              8  85- 85 :111/  0 31- 0- 0-31: 0  0  0  0  0  0  0  0  6  7 31
     Tambourine             9  54- 54 : 60/  0 31- 0- 0-31: 0  0  0  0  0  0  0  0  0  7 31
32 A.Piano    : G1      12  0   0- 31 : 60/  0 31- 3- 8-13: 0  0  0 12  2  2  2  1  6  7  0
                A#2         1  32- 63 : 76/106 31- 0- 9-14: 0  0  0  0  0  0  0  0  6  7  0
                D#3         2  64- 69 : 81/ 86 31-10-19-21: 7  0  0  0  0  0  0  0  6  7  0
                C#4         3  70- 89 : 91/100 31-10-10-11: 3  0  0  0  0  0  0  0  6  7  0
                G6          4  90-127 :121/ 52 31- 8- 4-12: 4  0  0  0  0  0  0  0  6  7  0
33 Pipe Organ           12  0   0-127 : 78/ 90 31- 0- 0-31: 0  0  0  0  0  0  0  0  6  7  0
34 Glocken              12  0   0-127 :106/ 18 31-10-18-12:25  1  0  0  0  0  0  0  6  7  0
35 Strings Arco  : Lo   12  0   0- 67 : 66/104 24- 0- 0-12: 0  0  0  0  0  0  0  0  5  7  0
                   Hi       1  68-127 : 90/112 24- 0- 0-13: 0  0  0  0  0  0  0  0  5  7  0
36 Strings Pizz  : C3   12  0   0- 65 : 84/-86 31- 0-11- 1: 0  0  0  0  0  0  0  0  6  7  0
                   C4       1  66-127 : 97/110 31- 0-11-31: 0  0  0  0  0  0  0  0  6  7  0
37 Harp                 12  0   0-127 : 65/ -8 31- 0-12-13: 0  0  0  0  0  0  0  0  6  6  0
```

In voice 31, ORCHEST.PERCUSSION, the layer names 大太鼓, 小太鼓 and ｵｰｹｽﾄﾗｼﾝﾊﾞﾙ mean "bass drum", "snare drum" and "orchestra cymbal".

*[p. 369]*

\<ORCHEST\>

```
No Voice Name           Bd Ly  sn- en : bn/ ft AR-DR-SR-RR:SL KS RE LF AW AS PW PS MX DS DP
   ( Layer Name )
38 Trombone             12  0   0-127 : 67/ 48 31- 0- 0-18: 0  0  0  0  0  0  0  0  6  7  0
39 Trumpet              12  0   0-127 : 82/ 92 31- 0- 0-16: 0  0  0  0  0  0  0  0  6  7  0
40 Horn                 12  0   0-127 : 88/-96 31- 0- 0-15: 0  0  0  0  0  0  0  0  6  7  0
41 BRASS     : Trombone 12  0   0-127 : 82/ 92 31- 0- 0-18: 0  0  0  0  0  0  0  0  6  6  0
               "Trumpet"     1   0-127 : 67/ 48 31- 0- 0-17: 0  0  0  0  0  0  0  0  6  4  0
               "Horn"       2   0-127 : 66/ 84 19- 0- 0-18: 0  0  0  0  0  0  0  0  6  5  0
42 Oboe                 12  0   0-127 : 80/ 90 20- 0- 0-17: 0  0  0  0  0  0  0  0  5  7 17
43 Clarinet             12  0   0-127 : 80/ 18 16- 0- 0-19: 0  0  0  0  0  0  0  0  6  7  0
44 Flute                12  0   0-127 : 68/-44 31- 0- 0-21:13  0  0 18  0  0  2  1  5  7  0
45 Ocarina              12  0   0-127 : 88/-64 31- 1- 0-16: 0  0  0  0  0  0  0  0  6  7  0
46 Timpani              12  0   0-127 : 64/  0 31-10- 6- 9:29  0  0  0  0  0  0  0  7  7  0
47 Orche.Cymbal         12  0   0-127 : 80/  0 31- 0- 0- 9: 0  0  0  0  0  0  0  0  6  7  0
48 Marimba              12  0   0-127 : 89/ 60 31-12-10-22: 9 -1  0  0  0  0  0  0  7  7  0
```

### \<ROCK\> Rock music set

```
No Voice Name           Bd Ly  sn- en : bn/ ft AR-DR-SR-RR:SL KS RE LF AW AS PW PS MX DS DP
   ( Layer Name )
 0 BEEP                 12  0   0-127 : 72/ 44 15-14- 0-15: 0  0  0  0  0  0  1  0  0  7  0
 1 HEY!男声             12  0   0-127 : 72/  0 31- 0- 0- 6: 0  0  0  0  0  0  0  0  0  7  0
 2 HUA男声              12  0   0-127 : 72/  0 31- 0- 0-15: 0  0  0  0  0  0  0  0  0  7  0
 3 POH男声              12  0   0-127 : 72/  0 31- 0- 0-14: 0  0  0  0  0  0  0  0  0  7  0
 4 KYA女声              12  0   0-127 : 72/  0 31- 0- 0-18: 0  0  0  0  0  0  0  0  0  7  0
 5 TAH女声              12  0   0-127 : 72/  0 31- 0- 0-21: 0  0  0  0  0  0  0  0  0  7  0
 6 TOH女声              12  0   0-127 : 72/  0 31- 0- 0-20: 0  0  0  0  0  0  0  0  0  7  0
 7 WAH女声              12  0   0-127 : 72/  0 31- 0- 0-19: 0  0  0  0  0  0  0  0  0  7  0
 8 YAH女声              12  0   0-127 : 72/  0 31- 0- 0-20: 0  0  0  0  0  0  0  0  0  7  0
 9 HAH男声              12  0   0-127 : 72/  0 31- 0- 0-20: 0  0  0  0  0  0  0  0  0  7  0
10 TOH2男声             12  0   0-127 : 72/  0 31- 0- 0-15: 0  0  0  0  0  0  0  0  0  7  0
11 CHUKIN               12  0   0-127 : 72/  0 31-11-24-12:13  0  0  0  0  0  0  0  0  7  0
```

*[p. 370]*

\<ROCK\>

```
No Voice Name           Bd Ly  sn- en : bn/ ft AR-DR-SR-RR:SL KS RE LF AW AS PW PS MX DS DP
   ( Layer Name )
12 NOISE                12  0   0-127 : 72/  0 31- 0- 0-14: 0  0  0  0  3  0  3  0  0  7  0
13 BA                   12  0   0-127 : 72/  0 31- 0- 0-14: 0  0  0  0  0  0  0  0  0  7  0
14 BASHA                12  0   0-127 : 72/  0 31- 0- 0-20: 0  0  0  0  0  0  0  0  0  7  0
15 DOKA                 12  0   0-127 : 72/  0 31- 0- 0-11: 0  0  0  0  0  0  0  0  0  7  0
16 KACHA                12  0   0-127 : 72/  0 31- 0- 0-20: 0  0  0  0  0  0  0  0  0  7  0
17 SHU                  12  0   0-127 : 72/  0 31- 0- 0-11: 0  0  0  0  0  0  0  0  0  7  0
18 SAW WAVE             12  0   0- 38 : 48/  0 31-23- 0-20: 2  0  0  0  0  0  0  0  0  6  0
                            1  39- 44 : 54/ -6 31- 0- 0-22: 0  0  0  0  0  0  0  0  0  6  0
                            2  45- 50 : 60/ 16 31- 0- 0-23: 0  0  0  0  0  0  0  0  0  6  0
                            3  51- 56 : 66/ 32 31- 0- 0-22: 0  0  0  0  0  0  0  0  0  6  0
                            4  57- 62 : 72/ 40 31- 0- 0-22: 0  0  0  0  0  0  0  0  0  6  0
                            5  63- 68 : 78/ 32 31- 0- 0-22: 0  0  0  0  0  0  0  0  0  6  0
                            6  69- 74 : 84/-14 31- 0- 0-22: 0  0  0  0  0  0  0  0  0  6  0
                            7  75- 80 : 90/ 34 31- 0- 0-22: 0  0  0  0  0  0  0  0  0  6  0
                            8  81- 86 : 96/-12 31- 0- 0-22: 0  0  0  0  0  0  0  0  0  6  0
                            9  87-127 :102/ 32 31- 0- 0-24: 0  0  0  0  0  0  0  0  0  6  0
19 SINE WAVE            12  0   0-127 : 95/-62 22- 0- 0-18: 0  0  0  0  0  0  0  0  0  6  0
20 SQUARE WAVE          12  0   0- 38 : 48/-30 25- 0- 0-20: 0  0  0  0  0  0  0  0  0  6  0
                            1  39- 44 : 54/-62 25- 0- 0-23: 0  0  0  0  0  0  0  0  0  6  0
                            2  45- 50 : 60/ 16 25- 0- 0-23: 0  0  0  0  0  0  0  0  0  6  0
                            3  51- 56 : 66/ -6 25- 0- 0-23: 0  0  0  0  0  0  0  0  0  6  0
                            4  57- 62 : 72/-12 25- 0- 0-23: 0  0  0 18  2  0  2  0  0  6  0
                            5  63- 68 : 77/-78 25- 0- 0-23: 0  0  0  0  0  0  0  0  0  6  0
                            6  69- 74 : 84/ 90 25- 0- 0-23: 0  0  0  0  0  0  0  0  0  6  0
                            7  75- 80 : 90/ 32 25- 0- 0-23: 0  0  0  0  0  0  0  0  0  6  0
                            8  81- 86 : 96/-12 25- 0- 0-23: 0  0  0  0  0  0  0  0  0  6  0
                            9  87-127 :102/ 32 25- 0- 0-23: 0  0  0  0  0  0  0  0  0  6  0
21 SAW SE1              12  0   0-127 : 72/ 40 31- 0- 0-22: 0  0  0  0  0  0  0  0  0  7  0
22 SINE SE1             12  0   0-127 : 95/-62 31- 0- 0-31: 0  0  1  2  0  0  0  2  0  6  0
23 SQUARE SE1           12  0   0-127 : 72/-12 31- 0- 0-27: 0  0  0 18  2  0  2  0  0  6  0
```

*[p. 371]*

\<ROCK\>

```
No Voice Name           Bd Ly  sn- en : bn/ ft AR-DR-SR-RR:SL KS RE LF AW AS PW PS MX DS DP
   ( Layer Name )
24 SAW SE2              12  0   0-127 : 72/ 40 31-15-21-14: 9  0  0 21  0  0  1  6  0  7  0
25 SINE SE2             12  0   0-127 : 95/-62 31- 0- 0-31: 0  0  0  0  0  0  0  0  0  6  0
26 SQUARE SE2           12  0   0-127 : 72/-12 31- 0- 0-27: 0  0  1 12  1  0  2  7  0  6  0
27 SINE SE3             12  0   0-127 : 95/-62 31- 8-12-11:23  0  0 21  1  0  0  3  0  6  0
28 NOISE2               12  0   0-127 : 72/  0 31- 7-15-13: 9  0  0  0  3  0  3  0  0  7  0
29 GLOCKEN              12  0   0-127 : 74/  0 31- 0- 8-18: 5  0  0  0  0  0  0  0  6  7  0
30 RUM                  12  0   0-127 : 74/  0 31-11- 0-31:31  0  0  0  0  0  0  0  6  7  0
31 Drums Set            12
     Kick                   0  36- 36 : 60/  0 31-15-23-16:14  0  0  0  0  0  0  0  2  7  0
     Snare                  1  37- 38 : 48/  0 31-13-13-13: 0  0  0  0  0  0  0  0  5  7  0
     Lo Tom                 2  41- 41 : 65/  0 31-15-23-15:14  0  0  0  0  0  0  0  5  7 18
     Hi Hat                 3  42- 42 : 52/  0 31-17-17-17: 0  0  0  0  0  0  0  0  5  7  2
     Mid Tom                4  45- 45 : 66/  0 31-16-16-15: 0  0  0  0  0  0  0  0  5  7  4
     Hi Hat Open            5  46- 46 : 56/  0 31-13-11-16: 0  0  0  0  0  0  0  0  5  7  3
     Hi Tom                 6  48- 48 : 64/  0 31-16-16-16: 0  0  0  0  0  0  0  0  5  7  8
     Crash Cym 1            7  49- 49 : 55/-80 31-11-11-11: 0  0  0  0  0  0  0  0  6  7 13
     Crash Cym 2            8  57- 57 : 62/ 80 31-11-11-12: 0  0  0  0  0  0  0  0  6  7 29
     Ride Cym 1             9  51- 51 : 55/  0 31-12-12-13: 0  0  0  0  0  0  0  0  7  7 19
     Ride Cym 2            10  59- 59 : 61/  0 31-12-12-13: 0  0  0  0  0  0  0  0  7  7 20
     Rim Shot              11  39- 39 : 54/  0 31- 0- 0-10: 0  0  0  0  0  0  0  0  5  7  0
32 Fingered Bass        12  0   0- 45 : 54/ 82 31- 0- 8-18: 0  0  0  0  0  0  0  0  3  7  0
     36 - 55                1  46- 60 : 66/ 84 31- 0- 9-19: 0  0  0  0  0  0  0  0  3  7  0
                            2  61-127 : 78/100 31- 0- 9-20: 0  0  0  0  0  0  0  0  3  7  0
33 Picked Bass          12  0   0-127 : 66/ 60 31- 0- 9-17: 0  0  0  0  0  0  0  0  3  7  0
     40 - 64
34 Power Guitar         12  0   0-127 : 68/ 78 31- 0- 0-17: 0  0  0  0  0  0  0  0  5  7  0
     40 - 84                1   0-127 : 89/ -8 31- 0- 0-17: 0  0  0  0  0  0  0  0  5  7  0
35 Solo Guitar          12  0   0-127 : 96/ -8 31- 0- 0-17: 0  0  0  0  0  0  0  0  7  7  0
     57 - 81
```

*[p. 372]*

\<ROCK\>

```
No Voice Name           Bd Ly  sn- en : bn/ ft AR-DR-SR-RR:SL KS RE LF AW AS PW PS MX DS DP
   ( Layer Name )
36 Clean Guitar         12  0   0-127 : 82/-10 31-11- 9-16: 0  0  0  0  0  0  0  0  7  7  0
     50 - 86
37 Organ                12  0   0-127 : 90/112 31- 0- 0-28: 0  0  0  0  0  0  0  0  6  7  0
     38 - 91
38 Synth Brass          12  0   0-127 : 68/ 36 18- 0- 0-14: 0  0  0  0  0  0  0  0  5  7  0
     36 - 84
39 Choir Pad            12  0   0-127 : 79/ 74 25- 7- 7-16: 3  0  0  0  0  0  0  0  6  4  0
     47 - 91                1   0-127 : 84/ 80 31- 0- 8-15: 0  0  0  0  0  0  0  0  6  7  0
```

### \<DANCE\> Dance music set

```
No Voice Name           Bd Ly  sn- en : bn/ ft AR-DR-SR-RR:SL KS RE LF AW AS PW PS MX DS DP
   ( Layer Name )
 0 BEEP                 12  0   0-127 : 72/ 44 15-14- 0-15: 0  0  0  0  0  0  1  0  0  7  0
 1 HEY!男声             12  0   0-127 : 72/  0 31- 0- 0- 6: 0  0  0  0  0  0  0  0  0  7  0
 2 HUA男声              12  0   0-127 : 72/  0 31- 0- 0-15: 0  0  0  0  0  0  0  0  0  7  0
 3 POH男声              12  0   0-127 : 72/  0 31- 0- 0-14: 0  0  0  0  0  0  0  0  0  7  0
 4 KYA女声              12  0   0-127 : 72/  0 31- 0- 0-18: 0  0  0  0  0  0  0  0  0  7  0
 5 TAH女声              12  0   0-127 : 72/  0 31- 0- 0-21: 0  0  0  0  0  0  0  0  0  7  0
 6 TOH女声              12  0   0-127 : 72/  0 31- 0- 0-20: 0  0  0  0  0  0  0  0  0  7  0
 7 WAH女声              12  0   0-127 : 72/  0 31- 0- 0-19: 0  0  0  0  0  0  0  0  0  7  0
 8 YAH女声              12  0   0-127 : 72/  0 31- 0- 0-20: 0  0  0  0  0  0  0  0  0  7  0
 9 HAH男声              12  0   0-127 : 72/  0 31- 0- 0-20: 0  0  0  0  0  0  0  0  0  7  0
10 TOH2男声             12  0   0-127 : 72/  0 31- 0- 0-15: 0  0  0  0  0  0  0  0  0  7  0
11 CHUKIN               12  0   0-127 : 72/  0 31-11-24-12:13  0  0  0  0  0  0  0  0  7  0
12 NOISE                12  0   0-127 : 72/  0 31- 0- 0-14: 0  0  0  0  3  0  3  0  0  7  0
13 BA                   12  0   0-127 : 72/  0 31- 0- 0-14: 0  0  0  0  0  0  0  0  0  7  0
14 BASHA                12  0   0-127 : 72/  0 31- 0- 0-20: 0  0  0  0  0  0  0  0  0  7  0
15 DOKA                 12  0   0-127 : 72/  0 31- 0- 0-11: 0  0  0  0  0  0  0  0  0  7  0
16 KACHA                12  0   0-127 : 72/  0 31- 0- 0-20: 0  0  0  0  0  0  0  0  0  7  0
```

*[p. 373]*

\<DANCE\>

```
No Voice Name           Bd Ly  sn- en : bn/ ft AR-DR-SR-RR:SL KS RE LF AW AS PW PS MX DS DP
   ( Layer Name )
17 SHU                  12  0   0-127 : 72/  0 31- 0- 0-11: 0  0  0  0  0  0  0  0  0  7  0
18 SAW WAVE             12  0   0- 38 : 48/  0 31-23- 0-20: 2  0  0  0  0  0  0  0  0  6  0
                            1  39- 44 : 54/ -6 31- 0- 0-22: 0  0  0  0  0  0  0  0  0  6  0
                            2  45- 50 : 60/ 16 31- 0- 0-23: 0  0  0  0  0  0  0  0  0  6  0
                            3  51- 56 : 66/ 32 31- 0- 0-22: 0  0  0  0  0  0  0  0  0  6  0
                            4  57- 62 : 72/ 40 31- 0- 0-22: 0  0  0  0  0  0  0  0  0  6  0
                            5  63- 68 : 78/ 32 31- 0- 0-22: 0  0  0  0  0  0  0  0  0  6  0
                            6  69- 74 : 84/-14 31- 0- 0-22: 0  0  0  0  0  0  0  0  0  6  0
                            7  75- 80 : 90/ 34 31- 0- 0-22: 0  0  0  0  0  0  0  0  0  6  0
                            8  81- 86 : 96/-12 31- 0- 0-22: 0  0  0  0  0  0  0  0  0  6  0
                            9  87-127 :102/ 32 31- 0- 0-24: 0  0  0  0  0  0  0  0  0  6  0
19 SINE WAVE            12  0   0-127 : 95/-62 22- 0- 0-18: 0  0  0  0  0  0  0  0  0  6  0
20 SQUARE WAVE          12  0   0- 38 : 48/-30 25- 0- 0-20: 0  0  0  0  0  0  0  0  0  6  0
                            1  39- 44 : 54/-62 25- 0- 0-23: 0  0  0  0  0  0  0  0  0  6  0
                            2  45- 50 : 60/ 16 25- 0- 0-23: 0  0  0  0  0  0  0  0  0  6  0
                            3  51- 56 : 66/ -6 25- 0- 0-23: 0  0  0  0  0  0  0  0  0  6  0
                            4  57- 62 : 72/-12 25- 0- 0-23: 0  0  0 18  2  0  2  0  0  6  0
                            5  63- 68 : 77/-78 25- 0- 0-23: 0  0  0  0  0  0  0  0  0  6  0
                            6  69- 74 : 84/ 90 25- 0- 0-23: 0  0  0  0  0  0  0  0  0  6  0
                            7  75- 80 : 90/ 32 25- 0- 0-23: 0  0  0  0  0  0  0  0  0  6  0
                            8  81- 86 : 96/-12 25- 0- 0-23: 0  0  0  0  0  0  0  0  0  6  0
                            9  87-127 :102/ 32 25- 0- 0-23: 0  0  0  0  0  0  0  0  0  6  0
21 SAW SE1              12  0   0-127 : 72/ 40 31- 0- 0-22: 0  0  0  0  0  0  0  0  0  7  0
22 SINE SE1             12  0   0-127 : 95/-62 31- 0- 0-31: 0  0  1  2  0  0  0  2  0  6  0
23 SQUARE SE1           12  0   0-127 : 72/-12 31- 0- 0-27: 0  0  0 18  2  0  2  0  0  6  0
24 SAW SE2              12  0   0-127 : 72/ 40 31-15-21-14: 9  0  0 21  0  0  1  6  0  7  0
25 SINE SE2             12  0   0-127 : 95/-62 31- 0- 0-31: 0  0  0  0  0  0  0  0  0  6  0
26 SQUARE SE2           12  0   0-127 : 72/-12 31- 0- 0-27: 0  0  1 12  1  0  2  7  0  6  0
27 SINE SE3             12  0   0-127 : 95/-62 31- 8-12-11:23  0  0 21  1  0  0  3  0  6  0
28 NOISE2               12  0   0-127 : 72/  0 31- 7-15-13: 9  0  0  0  3  0  3  0  0  7  0
```

*[p. 374]*

\<DANCE\>

```
No Voice Name           Bd Ly  sn- en : bn/ ft AR-DR-SR-RR:SL KS RE LF AW AS PW PS MX DS DP
   ( Layer Name )
29 GLOCKEN              12  0   0-127 : 74/  0 31- 0- 8-18: 5  0  0  0  0  0  0  0  6  7  0
30 RUM                  12  0   0-127 : 74/  0 31-11- 0-31:31  0  0  0  0  0  0  0  6  7  0
31 Drums                  
     Kick               12  0  35- 36 : 64/  0 31- 0- 0- 5: 0  0  0  0  0  0  0  0  7  7  0
     Snare                  1  38- 40 : 59/  0 31- 0- 0- 5: 0  0  0  0  0  0  0  0  7  7  1
     Tom-H                  2  48- 48 : 75/  0 31- 0- 0- 5: 0  0  0  0  0  0  0  0  7  7  3
     Tom-M                  3  45- 45 : 72/  0 31- 0- 0- 5: 0  0  0  0  0  0  0  0  7  7 18
     Tom-L                  4  41- 41 : 68/  0 31- 0- 0- 5: 0  0  0  0  0  0  0  0  7  7 21
     Cym 1                  5  49- 49 : 70/  0 31- 0- 0- 5: 0  0  0  0  0  0  0  0  7  7 20
     Cym 2                  6  57- 57 : 75/  0 31- 0- 0- 5: 0  0  0  0  0  0  0  0  7  7  3
     HH-Close               7  42- 42 : 63/  0 31- 0- 0- 5: 0  0  0  0  0  0  0  0  7  7  4
     HH-Open                8  46- 46 : 67/  0 31- 0- 0- 5: 0  0  0  0  0  0  0  0  7  7  4
     Clap                   9  37- 37 : 64/  0 31- 0- 0- 5: 0  0  0  0  0  0  0  0  7  7 18
     Tambourine            10  54- 54 : 70/  0 31- 0- 0- 5: 0  0  0  0  0  0  0  0  7  7 19
     Shaker                11  58- 58 : 73/  0 31- 0- 0- 5: 0  0  0  0  0  0  0  0  7  7  3
     Stab                  12  50- 53 : 83/ 64 31- 0- 0- 5: 0  0  0  0  0  0  0  0  7  7  0
32 Synth Bass           12  0   0-127 :35/-114 31- 0- 0-31: 0  0  0  0  0  0  0  0  7  6  0
     0 - 56
33 Piano                12  0   0- 41 : 51/ 40 31-18- 8-16: 0  0  0 20  2  2  1  2  7  6  0
                            1  42- 48 : 57/ 14 31-18- 8-16: 0  0  0 20  2  2  1  2  7  6  0
                            2  49- 55 : 64/-22 31-18- 8-16: 0  0  0 20  2  2  1  2  7  6  0
                            3  56- 74 : 71/-12 31-18- 8-16: 0  0  0 20  2  2  1  2  7  6  0
                            4  75- 80 : 78/-44 31-18- 8-16: 0  0  0 20  2  2  1  2  7  6  0
                            5  81- 89 : 84/-14 31-18- 8-16: 0  0  0 20  2  2  1  2  7  6  0
                            6  90- 99 : 96/-12 31-18- 8-16: 0  0  0 20  2  2  1  2  7  6  0
                            7 100-127 :104/-90 31-18- 8-16: 0  0  0 20  2  2  1  2  7  6  0
```

*[p. 375]*

\<DANCE\>

```
No Voice Name           Bd Ly  sn- en : bn/ ft AR-DR-SR-RR:SL KS RE LF AW AS PW PS MX DS DP
   ( Layer Name )
34 Warm Bell            12  0   0- 38 : 48/  2 31- 0- 9-11: 0  0  0  0  0  0  0  0  7  6  0
     36 - 84                1  39- 44 : 54/ -4 31- 0- 8-11: 0  0  0  0  0  0  0  0  7  6  0
                            2  45- 50 : 60/-10 31- 0- 9-11: 0  0  0  0  0  0  0  0  7  6  0
                            3  51- 56 : 66/ -4 31- 0- 8-11: 0  0  0  0  0  0  0  0  7  6  0
                            4  57- 62 : 72/-12 31- 0- 8-11: 0  0  0  0  0  0  0  0  7  6  0
                            5  63- 68 : 78/ 32 31- 0- 8-11: 0  0  0  0  0  0  0  0  7  6  0
                            6  69- 74 : 84/-12 31- 0- 8-11: 0  0  0  0  0  0  0  0  7  6  0
                            7  75- 80 : 90/ 32 31- 0- 8-11: 0  0  0  0  0  0  0  0  7  6  0
                            8  81- 86 : 96/-12 31- 0- 8-11: 0  0  0  0  0  0  0  0  7  6  0
                            9  87-127 :102/ 34 31- 0- 8-11: 0  0  0  0  0  0  0  0  7  6  0
35 Vocoder Vox          12  0   0-127 : 77/120 16- 0- 8-10: 0  0  0 19  0  0  2  3  0  6  0
     36 - 84
36 Synth Brass          12  0   0-127 : 84/  0 22- 6- 5-13: 6  0  0  0  0  0  0  0  6  7  0
     36 - 84
37 Square Wave          12  0   0- 38 : 48/-30 31- 0- 0-27: 0  0  0  0  0  0  0  0  7  6  0
                            1  39- 44 : 54/-62 31- 0- 0-27: 0  0  0  0  0  0  0  0  7  6  0
                            2  45- 50 : 60/ 16 31- 0- 0-27: 0  0  0  0  0  0  0  0  7  6  0
                            3  51- 56 : 66/ -6 31- 0- 0-31: 0  0  0  0  0  0  0  0  7  6  0
                            4  57- 62 : 72/-12 31- 0- 0-27: 0  0  0 18  2  0  2  0  7  6  0
                            5  63- 68 : 77/-78 31- 0- 0-27: 0  0  0  0  0  0  0  0  7  6  0
                            6  69- 74 : 84/ 90 31- 0- 0-27: 0  0  0  0  0  0  0  0  7  6  0
                            7  75- 80 : 90/ 32 31- 0- 0-27: 0  0  0  0  0  0  0  0  7  6  0
                            8  81- 86 : 96/-12 31- 0- 0-27: 0  0  0  0  0  0  0  0  7  6  0
                            9  87-127 :102/ 32 31- 0- 0-27: 0  0  0 17  0  0  0  5  7  6  0
38 Organ                12  0   0-127 : 83/ 48 31- 0- 0-31: 0  0  0  0  0  0  0  0  7  7  0
39 Voice Ahh            12  0   0- 47 : 57/ -8 15- 7- 9-13: 7  0  0  0  0  0  2  0  6  6  0
     36 - 84                1  48- 53 : 62/-30 15- 7- 9-13: 7  0  0  0  0  0  2  0  6  6  0
                            2  54- 59 : 69/-10 15- 7- 9-13: 7  0  0  0  0  0  2  0  6  6  0
                            3  60-127 : 74/ -4 15- 7- 9-13: 7  0  0  0  0  0  2  0  6  6  0
```

*[p. 376]*

\<DANCE\>

```
No Voice Name           Bd Ly  sn- en : bn/ ft AR-DR-SR-RR:SL KS RE LF AW AS PW PS MX DS DP
   ( Layer Name )
40 Pulse Wave           12  0   0- 37 : 47/-74 31- 0- 0-20: 0  0  0  0  0  0  0  0  7  6  0
                            1  38- 43 : 53/-62 31- 0- 0-18: 0  0  0  0  0  0  0  0  7  6  0
                            2  44- 49 : 59/-88 31- 0- 0-18: 0  0  0  0  0  0  0  0  7  6  0
                            3  50- 55 : 65/-80 31- 0- 0-20: 0  0  0  0  0  0  0  0  7  6  0
                            4  56- 61 : 71/-62 31- 0- 0-22: 0  0  0  0  0  0  0  0  7  6  0
                            5  62- 67 : 77/-80 31- 0- 0-21: 0  0  0  0  0  0  0  0  7  6  0
                            6  68- 73 : 83/-64 31- 0- 0-20: 0  0  0  0  0  0  0  0  7  6  0
                            7  74- 79 : 89/-80 31- 0- 0-20: 0  0  0  0  0  0  0  0  7  6  0
                            8  80-127 : 95/-64 31- 0- 0-20: 0  0  0  0  0  0  0  0  7  6  0
41 Filter 1             12  0   0-127 :35/-114 31- 0- 0-31: 0  0  0  0  0  0  0  0  7  6  0
42 Filter 2             12  0   0-127 : 84/  0 31-13-31-20:31  0  0  0  0  0  0  0  7  7  0
43 Space Pad            12  0   0- 61 : 72/ 94 11- 7-15-13:10  0  0 17  0  0  2  2  7  6  0
     36 - 84                1  62- 65 : 76/ 76 11- 7-15-13:10  0  0 17  0  0  2  2  7  6  0
                            2  66- 68 : 80/ 80 11- 7-15-13:10  0  0 17  0  0  2  3  7  6  0
                            3  69- 70 : 82/ 66 11- 7-15-13:10  0  0 18  0  0  2  3  7  6  0
                            4  71- 72 : 84/-14 11- 7-15-13:10  0  0 18  0  0  2  3  7  6  0
                            5  73- 75 : 86/ 54 11- 7-15-13:10  0  0 18  0  0  2  3  7  6  0
                            6  76- 78 : 89/ 62 11- 7-15-13:10  0  0 18  0  0  2  2  7  6  0
                            7  79- 82 : 93/ -8 11- 7-15-13:10  0  0 18  0  0  2  3  7  6  0
                            8  83- 87 : 97/ 26 11- 7-15-13:10  0  0 18  0  0  2  2  7  6  0
                            9  88-127 :103/-18 11- 7-15-13:10  0  0 18  0  0  2  3  7  6  0
44 Synth Pad            12  0   0- 61 : 61/  0 11- 7-15-13:10  0  0 18  0  0  2  2  6  6  0
     36 - 84                1  62- 63 : 63/ 42 11- 7-15-13:10  0  0 18  0  0  2  2  6  6  0
                            2  64- 70 : 66/ 36 11- 7-15-13:10  0  0 18  0  0  2  2  6  6  0
                            3  67- 73 : 73/ 30 11- 7-15-13:10  0  0 18  0  0  2  2  6  6  0
                            4  71- 75 : 75/ 12 11- 7-15-13:10  0  0 18  0  0  2  2  6  6  0
                            5  76- 78 : 78/ 32 11- 7-15-13:10  0  0 18  0  0  2  2  6  6  0
                            6  79- 80 : 80/ -6 11- 7-15-13:10  0  0 18  0  0  2  2  6  6  0
                            7  81- 87 : 85/ 30 11- 7-15-13:10  0  0 18  0  0  2  2  6  6  0
                            8  88-127 : 90/ 34 11- 7-15-13:10  0  0 18  0  0  2  0  6  6  0
```

*[p. 377]*

\<DANCE\>

```
No Voice Name           Bd Ly  sn- en : bn/ ft AR-DR-SR-RR:SL KS RE LF AW AS PW PS MX DS DP
   ( Layer Name )
45 Metal Pad            12  0   0- 61 : 72/ 94 11- 7-15-13:10  0  0 17  0  0  2  2  7  6  0
     36 - 84                1  62- 65 : 76/ 76 11- 7-15-13:10  0  0 17  0  0  2  2  7  6  0
                            2  66- 68 : 80/ 80 11- 7-15-13:10  0  0 17  0  0  2  3  7  6  0
                            3  69- 70 : 82/ 66 11- 7-15-13:10  0  0 18  0  0  2  3  7  6  0
                            4  71- 72 : 84/-14 11- 7-15-13:10  0  0 18  0  0  2  3  7  6  0
                            5  73- 75 : 86/ 54 11- 7-15-13:10  0  0 18  0  0  2  3  7  6  0
                            6  76- 78 : 89/ 62 11- 7-15-13:10  0  0 18  0  0  2  2  7  6  0
                            7  79- 82 : 93/ -8 11- 7-15-13:10  0  0 18  0  0  2  3  7  6  0
                            8  83- 87 : 97/ 26 11- 7-15-13:10  0  0 18  0  0  2  2  7  6  0
                            9  88-127 :103/-18 11- 7-15-13:10  0  0 18  0  0  2  3  7  6  0
                           10   0- 38 : 48/  2 11- 7-15-13:10  0  0  0  0  0  0  0  7  6  0
                           11  39- 44 : 54/ -4 11- 7-15-13:10  0  0  0  0  0  0  0  7  6  0
                           12  45- 50 : 60/-10 11- 7-15-13:10  0  0  0  0  0  0  0  7  6  0
                           13  51- 56 : 66/ -4 11- 7-15-13:10  0  0  0  0  0  0  0  7  6  0
                           14  57- 62 : 72/-12 11- 7-15-13:10  0  0  0  0  0  0  0  7  6  0
                           15  63- 68 : 78/ 32 11- 7-15-13:10  0  0  0  0  0  0  0  7  6  0
                           16  69- 74 : 84/-12 11- 7-15-13:10  0  0  0  0  0  0  0  7  6  0
                           17  75- 80 : 90/ 32 11- 7-15-13:10  0  0  0  0  0  0  0  7  6  0
                           18  81- 86 : 96/-12 11- 7-15-13:10  0  0  0  0  0  0  0  7  6  0
                           19  87-127 :102/ 34 11- 7-15-13:10  0  0  0  0  0  0  0  7  6  0
46 Voice Pad            12  0   0- 47 : 57/ -8 15- 0- 0-14: 0  0  0 18  0  0  2  2  7  5  0
     36 - 84                1  48- 53 : 62/-30 13- 0- 0-16: 0  0  0 18  0  0  2  2  7  5  0
                            2  54- 59 : 69/-10 15- 0- 0-15: 0  0  0 18  0  0  2  3  7  5  0
                            3  60-127 : 74/ -4 15- 0- 0-15: 0  0  0 18  0  0  2  3  7  5  0
                            4   0-127 : 77/120 16- 0- 0-13: 0  0  0 19  0  0  2  3  7  5  0
```

*[p. 378]*

### \<PIANO\> Piano set

```
No Voice Name           Bd Ly  sn- en : bn/ ft AR-DR-SR-RR:SL KS RE LF AW AS PW PS MX DS DP
   ( Layer Name )
 0 BEEP                 12  0   0-127 : 72/ 44 15-14- 0-15: 0  0  0  0  0  0  1  0  0  7  0
 1 PIANO                 2  0   0- 33 : 52/-86 31- 0- 8-13: 0  0  0  0  0  0  0  0  4  7 16
                            1  34- 40 : 59/-82 31- 0- 8-13: 0  0  0  0  0  0  0  0  4  7 16
                            2  41- 48 :65/-106 31- 0- 8-13: 0  0  0  0  0  0  0  0  4  7 16
                            3  49- 55 : 73/ 98 31- 0- 8-13: 0  0  0  0  0  0  0  0  4  7  0
                            4  56- 62 : 80/114 31- 0- 8-13: 0  0  0  0  0  0  0  0  4  7  0
                            5  63- 69 : 87/112 31- 0- 8-13: 0  0  0  0  0  0  0  0  4  7  0
                            6  70- 75 : 93/120 31- 0- 8-13: 0  0  0  0  0  0  0  0  4  7 16
                            7  76- 81 : 99/102 31- 0- 8-13: 0  0  0  0  0  0  0  0  4  7  0
                            8  82- 89 :105/112 31- 0- 8-13: 0  0  0  0  0  0  0  0  4  7 16
                            9  90-120 :113/120 31- 0- 8-13: 0  0  0  0  0  0  0  0  4  7  0
```

### \<METAL\> Heavy metal set

```
No Voice Name           Bd Ly  sn- en : bn/ ft AR-DR-SR-RR:SL KS RE LF AW AS PW PS MX DS DP
   ( Layer Name )
 0 BEEP                 12  0   0-127 : 72/ 44 15-14- 0-15: 0  0  0  0  0  0  1  0  0  7  0
 1 HEAVY MUTE           12  0   0-127 : 55/100 31-10-17-20: 1  0  0  0  0  0  0  0  0  7  0
     45 - 64
 2 POWER CHORD          12  0   0-127 : 58/100 31- 0- 0-21: 0  0  0  0  0  0  0  0  0  7  0
     45 - 64
 3 ROCK BASS            12  0   0-127 : 76/-20 31- 0- 0-20: 0  0  0  0  0  0  0  0  0  7  0
     45 - 64
 4 PICK SCRATCH         12  0   0-127 : 60/  0 31- 0- 5-25: 0  0  0  0  0  0  0  0  0  7  0
     48 - 55
```

*[p. 379]*

\<METAL\>

```
No Voice Name           Bd Ly  sn- en : bn/ ft AR-DR-SR-RR:SL KS RE LF AW AS PW PS MX DS DP
   ( Layer Name )
 5 DRUMS                12
     KICK                   0  36- 36 : 53/  0 31-14-22-16:13  0  0  0  0  0  0  0  0  7  0
     SNARE                  1  37- 38 : 50/  0 31-13-13-13: 0  0  0  0  0  0  0  0  0  7  0
     LO TOM                 2  41- 41 : 65/  0 31-15-23-15:14  0  0  0  0  0  0  0  0  7 21
     HI HAT                 3  42- 42 : 52/  0 31-17-17-17: 0  0  0  0  0  0  0  0  0  6  2
     MID TOM                4  45- 45 : 66/  0 31-16-16-15: 0  0  0  0  0  0  0  0  0  7  4
     HI HAT OPEN            5  46- 46 : 56/  0 31-13-11-16: 0  0  0  0  0  0  0  0  0  6  3
     HI TOM                 6  48- 48 : 64/  0 31-16-16-16: 0  0  0  0  0  0  0  0  0  7  8
     CRASH1                 7  49- 49 : 57/-80 31-11-11-11: 0  0  0  0  0  0  0  0  0  7 13
     CRASH2                 8  57- 57 : 64/ 80 31-11-11-12: 0  0  0  0  0  0  0  0  0  7 29
     RIDE1                  9  51- 51 : 55/  0 31-12-12-13: 0  0  0  0  0  0  0  0  0  7 19
     RIDE2                 10  59- 59 : 61/  0 31-12-12-13: 0  0  0  0  0  0  0  0  0  6 18
     CHINA CYM             11  52- 53 : 66/  0 31- 9- 9-10: 0  0  0  0  0  0  0  0  0  7 23
     COW BELL              12  55- 55 : 68/  0 31-14-14-15: 0  0  0  0  0  0  0  0  0  7  1
     GONG                  13  60- 60 : 71/-40 31- 0- 6-11: 0  0  0  0  0  0  0  0  0  7  0
 6 SOLO GUITAR          12  0   0-127 : 96/  0 31- 0- 0-17: 0  0  0  0  0  0  0  0  0  7  0
     57 - 81
 7 HARMONICS            12  0   0-127 : 62/-90 31- 0- 0-18: 0  0  0 18  0  1  0  3  0  7  0
     52 - 69
```

*[p. 380]*

### \<ETHNIC\> Ethnic set

```
No Voice Name           Bd Ly  sn- en : bn/ ft AR-DR-SR-RR:SL KS RE LF AW AS PW PS MX DS DP
   ( Layer Name )
 0 BEEP                 12  0   0-127 : 72/ 44 15-14- 0-15: 0  0  0  0  0  0  1  0  0  7  0
 1 BAGPIPE               2  0   0- 55 : 65/-16 15- 0- 0-22: 0  1  0 11  0  0  2  0  7  6  0
     36 - 96                1  56- 59 : 70/-34 15- 0- 0-22: 0  1  0 11  0  0  2  0  7  6  0
                            2  60- 64 : 74/-30 15- 0- 0-22: 0  1  0 11  0  0  2  0  7  6  0
                            3  65- 96 : 79/-72 15- 0- 0-22: 0  1  0 11  0  0  2  0  7  6  0
 2 BANJO                 2  0   0- 57 :72/-128 31-31- 8-17: 0  0  0  0  0  0  0  0  7  7 16
     24 - 65                1  58- 67 : 78/112 31-31- 9-17: 0 -1  0  0  0  0  0  0  7  7  0
                            2  68- 74 : 87/124 31- 0- 9-18: 0 -1  0  0  0  0  0  0  7  7  0
                            3  75-127 : 94/ 68 31-31- 9-17: 0  0  0  0  0  0  0  0  7  7  0
 3 KOTO                  2  0   0-127 : 57/  0 31- 0-12-12: 0  0  0  0  0  0  0  0  6  7  0
     24 - 65
 4 SHAKUHATI             2  0  55- 72 : 81/100 31- 0- 0-31: 0  0  0  0  0  0  0  0  7  7  0
     24 - 60                1  73-127 : 71/ 82 31- 0- 0-31: 0  0  0  0  0  0  0  0  7  7  0
                            2   0- 54 : 67/-80 31- 0- 0-31: 0  0  0  0  0  0  0  0  7  7  0
 5 SHAMISEN              2  0   0- 65 :70/-118 31- 0-10-14: 0  0  0  0  0  0  2  0  7  7  0
     24 - 60                1   0-127 : 84/-16 31- 0-15-11: 0  0  0  0  0  0  2  0  7  7  0
                            2  76-127 : 88/-48 31- 0-12-14: 0  0  0  0  0  0  0  0  7  7  0
                            3  66- 75 :74/-116 31- 0-13-14: 0  0  0  0  0  0  0  0  7  7  0
 6 KALIMBA               2  0   0- 57 : 55/ 22 31- 0- 8-18: 0  0  0  0  0  0  0  0  7  7  0
     36 - 96                1  71- 77 : 74/-64 31- 0- 8-18: 0  0  0  0  0  0  0  0  7  7  0
                            2  58- 63 :60/-118 31- 0- 8-18: 0  0  0  0  0  0  0  0  7  7  0
                            3  64- 70 : 65/ 64 31- 0- 8-18: 0  0  0  0  0  0  0  0  7  7  0
                            4  78-127 : 78/-40 31- 0- 8-18: 0  0  0  0  0  0  0  0  7  7  0
 7 STEEL DRUM            2  0   0-127 : 80/ 94 31- 0- 0-10: 0  0  0  0  0  0  0  0  7  7  0
     36 - 96
 8 SITAR                 2  0  72-127 : 91/ 82 31- 0-11-13: 0  0  0  0  0  0  0  0  0  7  0
     24 - 65                1   0- 71 : 84/106 31- 0-11-13: 0  0  0  0  0  0  0  0  0  7  0
```

*[p. 381]*

\<ETHNIC\>

```
No Voice Name           Bd Ly  sn- en : bn/ ft AR-DR-SR-RR:SL KS RE LF AW AS PW PS MX DS DP
   ( Layer Name )
 9 ACCORDION             2  0   0- 58 : 53/ 10 31- 0- 0-20: 0  0  0  0  0  0  0  0  5  6  0
                            1  59- 67 : 64/-60 31- 0- 0-20: 0  0  0  0  0  0  0  0  5  6  0
                            2  68- 77 : 70/-26 31- 0- 0-20: 0  0  0  0  0  0  0  0  5  6  0
                            3  78-127 : 78/ 32 31- 0- 0-20: 0  0  0  0  0  0  0  0  5  6  0
10 PERCUSSION            2
     WADAIKO                0  36- 36 : 57/  0 31- 0- 0-10: 0  0  0  0  0  0  0  0  7  7  0
     WADAIKO RIM            1  37- 37 : 58/  0 31- 0- 0-10: 0  0  0  0  0  0  0  0  7  7  0
     SHIME TAIKO            2  38- 38 : 59/  0 31- 0- 0-10: 0  0  0  0  0  0  0  0  7  7 18
     ATARIGANE              3  39- 39 : 60/  0 31- 0- 0-10: 0  0  0  0  0  0  0  0  7  7  1
     HYOUSHIGI              4  40- 40 : 61/  0 31- 0- 0-10: 0  0  0  0  0  0  0  0  7  7  2
     OHKAWA                 5  41- 41 : 62/  0 31- 0- 0-10: 0  0  0  0  0  0  0  0  7  7  1
     TSUZUMI                6  43- 43 : 64/  0 31- 0- 0-10: 0  0  0  0  0  0  0  0  7  7  1
     BEND GONG              7  47- 47 : 68/  0 31- 0- 0-10: 0  0  0  0  0  0  0  0  7  7  0
     UDO SHORT              8  51- 51 : 72/  0 31- 0- 0-10: 0  0  0  0  0  0  0  0  7  7  2
     UDO LONG               9  52- 52 : 73/  0 31- 0- 0-10: 0  0  0  0  0  0  0  0  7  7  2
     TABLA NA              10  58- 58 : 79/  0 31- 0- 0-10: 0  0  0  0  0  0  0  0  7  7 19
     TABLA TUN             11  59- 59 : 80/  0 31- 0- 0-10: 0  0  0  0  0  0  0  0  7  7 18
     TABLA GE              12  60- 60 : 81/  0 31- 0- 0-10: 0  0  0  0  0  0  0  0  7  7 17
     TIMBALES LOW          13  67- 67 : 88/  0 31- 0- 0-10: 0  0  0  0  0  0  0  0  7  7  0
     TIMBALES HI           14  69- 69 : 90/  0 31- 0- 0-10: 0  0  0  0  0  0  0  0  7  7  1
     BONGO HI              15  71- 71 : 92/  0 31- 0- 0-10: 0  0  0  0  0  0  0  0  7  7  2
     BONGO LOW             16  72- 72 : 93/  0 31- 0- 0-10: 0  0  0  0  0  0  0  0  7  7  2
     SURDO OPEN            17  81- 81 :102/  0 31- 0- 0-10: 0  0  0  0  0  0  0  0  7  7 18
     SURDO MUTE            18  82- 82 :103/  0 31- 0- 0-10: 0  0  0  0  0  0  0  0  7  7 18
     AGOGO HI              19  84- 84 :105/  0 31- 0- 0-10: 0  0  0  0  0  0  0  0  7  7 18
     AGOGO LOW             20  85- 85 :106/  0 31- 0- 0-10: 0  0  0  0  0  0  0  0  7  7 18
     WHISTLE HI            21  87- 87 :108/  0 31- 0- 0-31: 0  0  0  0  0  0  0  0  7  7  2
     WHISTLE LOW           22  88- 88 :109/  0 31- 0- 0-31: 0  0  0  0  0  0  0  0  7  7  2
     CUICA MUTE            23  89- 89 :110/  0 31- 0- 0-10: 0  0  0  0  0  0  0  0  7  7 17
     CUICA OPEN            24  90- 90 :111/  0 31- 0- 0-10: 0  0  0  0  0  0  0  0  7  7 17
```

*[p. 382]*

\<ETHNIC\>

```
No Voice Name           Bd Ly  sn- en : bn/ ft AR-DR-SR-RR:SL KS RE LF AW AS PW PS MX DS DP
   ( Layer Name )
     GUIRO SHORT           25  93- 93 :114/  0 31- 0- 0-10: 0  0  0  0  0  0  0  0  7  7  2
     GUIRO LONG            26  94- 94 :115/  0 31- 0- 0-10: 0  0  0  0  0  0  0  0  7  7  2
     WOOD BLOCK HI         27  98- 98 :119/  0 31- 0- 0-10: 0  0  0  0  0  0  0  0  7  7  1
     WOOD BLOCK LOW        28  99- 99 :120/  0 31- 0- 0-10: 0  0  0  0  0  0  0  0  7  7  2
     CONGA HI MUTE         29  75- 75 : 87/  0 31- 0- 0-10: 0  0  0  0  0  0  0  0  7  7 19
     CONGA HI OPEN         30  74- 74 : 86/  0 31- 0- 0-10: 0  0  0  0  0  0  0  0  7  7 19
     CONGA LOW             31  76- 76 : 88/  0 31- 0- 0-10: 0  0  0  0  0  0  0  0  7  7 19
```

### \<MBOXPO\> Music box/pipe organ set

```
No Voice Name           Bd Ly  sn- en : bn/ ft AR-DR-SR-RR:SL KS RE LF AW AS PW PS MX DS DP
   ( Layer Name )
 0 BEEP                 12  0   0-127 : 72/ 44 15-14- 0-15: 0  0  0  0  0  0  1  0  0  7  0
 1 Music Box             2  0   0- 96 : 81/-10 31- 0- 8-12: 0  0  0 11  0  0  2  0  7  7  0
 2 Pipe Organ           12  0   0- 54 : 72/  0 31- 0- 0-20: 0  0  0  0  0  0  0  0  7  7  0
                            1  55- 65 : 72/  0 31- 0- 0-20: 0  0  0  0  0  0  0  0  7  7  0
                            2  66-127 : 72/  0 31- 0- 0-20: 0  0  0  0  0  0  0  0  7  7  0
```

### \<EXTRA1\> Extra set 1

```
No Voice Name           Bd Ly  sn- en : bn/ ft AR-DR-SR-RR:SL KS RE LF AW AS PW PS MX DS DP
   ( Layer Name )
 0 BEEP                 12  0   0-127 : 72/ 44 15-14- 0-15: 0  0  0  0  0  0  1  0  0  7  0
 1 Orche.Hit 1           2  0   0-127 : 84/  0 31-12-18-28:10  0  0  0  0  0  0  0  7  7  0
 2 Orche.Hit 2           2  0   0-127 : 84/  0 31- 0- 0-24: 0  0  0  0  0  0  0  0  7  7  0
 3 Orche.Hit 3           2  0   0-127 : 84/  0 31- 0- 0-24: 0  0  0  0  0  0  0  0  7  7  0
 4 Orche.Hit 4           2  0   0-127 : 84/  0 31- 0- 0-22: 0  0  0  0  0  0  0  0  7  7  0
 5 Orche.Hit 5           2  0   0-127 : 84/  0 31- 0- 0-20: 0  0  0  0  0  0  0  0  7  7  0
 6 Orche.Hit 6           2  0   0-127 : 84/  0 31- 0- 0-23: 0  0  0  0  0  0  0  0  7  7  0
 7 Orche.Hit 7           2  0   0-127 : 84/  0 31- 0- 0-22: 0  0  0  0  0  0  0  0  7  7  0
```

*[p. 383]*

\<EXTRA1\>

```
No Voice Name           Bd Ly  sn- en : bn/ ft AR-DR-SR-RR:SL KS RE LF AW AS PW PS MX DS DP
   ( Layer Name )
 8 Cembalo               2  0   0- 40 : 57/  0 31- 8- 9-16:10  0  0  0  0  0  0  0  7  7  0
                            1  41- 53 : 58/  0 31- 9- 7-20: 5  0  0  0  0  0  0  0  7  7  0
                            2  54- 65 : 71/  0 31- 9-11-20:13  0  0  0  0  0  0  0  7  7  0
                            3  66- 81 : 86/  0 31-11-13-21:17  0  0  0  0  0  0  0  7  7  0
                            4  82-127 : 95/  0 31-10- 9-20:19  0  0  0  0  0  0  0  7  7  0
 9 Harmonica             2  0   0-127 : 84/  0 31- 0- 0-27: 0  0  0  0  0  0  0  0  7  7  0
10 Oboe                  2  0   0- 52 : 71/  0 31- 0- 0-21: 0  0  0  0  0  0  0  0  7  7  0
                            1  53- 64 : 83/  0 31- 0- 0-20: 0  0  0  0  0  0  0  0  7  7  0
                            2  65-127 : 95/  0 31- 0- 0-20: 0  0  0  0  0  0  0  0  7  7  0
11 Cow Bell              2  0   0-127 : 60/  0 31- 0- 0-21: 0  0  0  0  0  0  0  0  7  7  0
12 Gun                   2  0   0-127 : 84/  0 31- 0- 0-19: 0  0  0  0  0  0  0  0  7  7  0
```

### \<EXTRA2\> Extra set 2

```
No Voice Name           Bd Ly  sn- en : bn/ ft AR-DR-SR-RR:SL KS RE LF AW AS PW PS MX DS DP
   ( Layer Name )
 0 BEEP                 12  0   0-127 : 72/ 44 15-14- 0-15: 0  0  0  0  0  0  1  0  0  7  0
 1 Trombone             12  0   0- 45 : 64/  0 27- 0- 0-20: 0  0  0 17  0  0  2  1  7  7  0
                            1  46- 57 : 76/  0 31- 0- 0-25: 0  0  0 17  0  0  2  1  7  7  0
                            2  58-127 : 88/  0 31- 0- 0-31: 0  0  0 17  0  0  2  1  7  7  0
 2 Trumpet              12  0   0- 60 : 79/  0 31- 0- 0-19: 0  0  0 18  0  0  2  2  7  7  0
                            1  61- 72 : 91/  0 31- 0- 0-20: 0  0  0  0  0  0  0  0  7  7  0
                            2  73-127 :103/  0 31- 0- 0-20: 0  0  0  0  0  0  0  0  7  7  0
 3 Big Brass            12  0   0- 43 : 72/  0 31- 0- 0-18: 0  0  0  0  0  0  0  0  7  7  0
                            1  44- 55 : 90/  0 31- 0- 0-20: 0  0  0  0  0  0  0  0  7  7  0
                            2  56-127 :102/  0 31- 0- 0-20: 0  0  0  0  0  0  0  0  7  7  0
 4 Over Drive Guitar    12  0   0- 45 : 64/  0 31- 0- 9-20:12  0  0  0  0  0  0  0  7  7  0
                            1  46- 57 : 76/  0 31- 0- 9-20:12  0  0  0  0  0  0  0  7  7  0
                            2  58-127 : 88/  0 31- 0- 9-20:12  0  0  0  0  0  0  0  7  7  0
```

*[p. 384]*

### \<EXTRA3\> Extra set 3

```
No Voice Name           Bd Ly  sn- en : bn/ ft AR-DR-SR-RR:SL KS RE LF AW AS PW PS MX DS DP
   ( Layer Name )
 0 BEEP                 12  0   0-127 : 72/ 44 15-14- 0-15: 0  0  0  0  0  0  1  0  0  7  0
 1 LOOP150A              2  0   0-127 : 72/  0 31- 0- 0-31: 0  0  0  0  0  0  0  0  7  7  0
 2 LOOP150B              2  0   0-127 : 72/  0 31- 0- 0-31: 0  0  0  0  0  0  0  0  7  7  0
 3 LOOP150C              2  0   0-127 : 72/  0 31- 0- 0-31: 0  0  0  0  0  0  0  0  7  7  0
 4 LOOP163               2  0   0-127 : 72/  0 31- 0- 0-31: 0  0  0  0  0  0  0  0  7  7  0
 5 LOOP169               2  0   0-127 : 72/  0 31- 0- 0-31: 0  0  0  0  0  0  0  0  7  7  0
```

**About LOOP**

A LOOP voice keeps sounding while it is in the Note On state, so to stop it, cut it with Note Off. For example, when the MML "%\<damper switch\>" is set to "1", no Note Off is issued, so as long as that state continues the voice keeps sounding.

The tempo of every LOOP is set to match at Note No. 60. To make the tempo faster or slower than that, change the Note No. Raising it by one octave doubles the tempo, and lowering it by one octave halves it.

### \<EXTRA4\> Extra set 4

```
No Voice Name           Bd Ly  sn- en : bn/ ft AR-DR-SR-RR:SL KS RE LF AW AS PW PS MX DS DP
   ( Layer Name )
 0 BEEP                 12  0   0-127 : 72/ 44 15-14- 0-15: 0  0  0  0  0  0  1  0  0  7  0
 1 TECHNO SE 1           2  0   0-127 : 72/  0 31- 0- 0-31: 0  0  0  0  0  0  0  0  7  7  0
 2 TECHNO SE 2           2  0   0-127 : 72/  0 31- 0- 0-31: 0  0  0  0  0  0  0  0  7  7  0
 3 TECHNO SE 3           2  0   0-127 : 72/  0 31- 0- 0-31: 0  0  0  0  0  0  0  0  7  7  0
 4 TECHNO SE 4           2  0   0-127 : 72/  0 31- 0- 0-31: 0  0  0  0  0  0  0  0  7  7  0
 5 TECHNO SE 5           2  0   0-127 : 72/  0 31- 0- 0-31: 0  0  0  0  0  0  0  0  7  7  0
 6 TECHNO SE 6           2  0   0-127 : 72/  0 31- 0- 0-31: 0  0  0  0  0  0  0  0  7  7  0
 7 TECHNO SE 7           2  0   0-127 : 72/  0 31- 0- 0-31: 0  0  0  0  0  0  0  0  7  7  0
 8 TECHNO SE 8           2  0   0-127 : 72/  0 31- 0- 0-31: 0  0  0  0  0  0  0  0  7  7  0
 9 LOOP149A              2  0   0-127 : 72/  0 31- 0- 0-31: 0  0  0  0  0  0  0  0  7  7  0
10 LOOP149B              2  0   0-127 : 72/  0 31- 0- 0-31: 0  0  0  0  0  0  0  0  7  7  0
11 LOOP201               2  0   0-127 : 72/  0 31- 0- 0-31: 0  0  0  0  0  0  0  0  7  7  0
```

*[p. 385]*

### \<GM_FM1\> GM FM set 1 to \<GM_FM4\> GM FM set 4

There are four FM sound source files in GM order, numbered 1 to 4. The voice names are the same in every set; the parameters (the sounds) differ.

| No. | Voice name |
|---|---|
| 000 | Acoustic Grand Piano |
| 001 | Bright Acoustic Piano |
| 002 | Electric grand Piano |
| 003 | Honky Tonk Piano |
| 004 | Eiectric Piano 1 (sic) |
| 005 | Electric Piano 2 |
| 006 | Harpsichord |
| 007 | Clavinet |
| 008 | Celesta |
| 009 | Glockenspiel |
| 010 | Music Box |
| 011 | Vibraphone |
| 012 | Marimba |
| 013 | Xylophone |
| 014 | Tubular bells |
| 015 | Dulcimer |
| 016 | Drawbar Organ |
| 017 | Percussive Organ |
| 018 | Rock Organ |
| 019 | Church Organ |
| 020 | Reed Organ |
| 021 | Accordion |
| 022 | Harmonica |
| 023 | Tango Accordion |
| 024 | Nylon Accustic Guitar (sic) |
| 025 | Steel Acoustic Guitar |
| 026 | Jazz Electric Guitar |
| 027 | Ciean Electric Guitar (sic) |
| 028 | Muted Electric Guitar |
| 029 | Overdrive Guitar |
| 030 | Distorted Guitar |
| 031 | Guitar Harmonics |
| 032 | Acoustic Bass |
| 033 | Electric Fingered Bass |
| 034 | Electric Picked Bass |

*[p. 386]*

| No. | Voice name |
|---|---|
| 035 | Fretless Bass |
| 036 | Slap Bass 1 |
| 037 | Slap Bass 2 |
| 038 | Syn Bass 1 |
| 039 | Syn Bass 2 |
| 040 | Violin |
| 041 | Viola |
| 042 | Cello |
| 043 | Contrabass |
| 044 | Tremolo Strings |
| 045 | Pizzicato Strings |
| 046 | Orchestral Harp |
| 047 | Timpani |
| 048 | String Ensemble 1 |
| 049 | String Ensemble 2 (Slow) |
| 050 | Syn Strings 1 |
| 051 | Syn Strings 2 |
| 052 | Choir Aahs |
| 053 | Voice Oohs |
| 054 | Syn Choir |
| 055 | Orchestral Hit |
| 056 | Trumpet |
| 057 | Trombone |
| 058 | Tuba |
| 059 | Muted Trumpet |
| 060 | French Horn |
| 061 | Brass Section |
| 062 | Syn Brass 1 |
| 062 (sic) | Syn Brass 2 |
| 064 | Soprano Sax |
| 065 | Alto Sax |
| 066 | Tenor Sax |
| 067 | Baritone Sax |
| 068 | Oboe |
| 069 | English Horn |
| 070 | Bassoon |
| 071 | Clarinet |
| 072 | Piccolo |
| 073 | Flute |

*[p. 387]*

| No. | Voice name |
|---|---|
| 074 | Recorder |
| 075 | Pan Flute |
| 076 | Bottle Blow |
| 077 | Shakuhachi |
| 078 | Whistle |
| 079 | Ocarina |
| 080 | Syn Square Wave |
| 081 | Syn Sawtooth Wave |
| 082 | Syn Calliope |
| 083 | Syn Chiff |
| 084 | Syn Charang |
| 085 | Syn Voice |
| 086 | Syn Fifths Sawtooth Wave |
| 087 | Syn Bass & Lead |
| 088 | New Age Syn Pad |
| 089 | Warm Syn Pad |
| 090 | Polysynth Syn Pad |
| 091 | Choir Syn Pad |
| 092 | Bowed Syn Pad |
| 093 | Metal Syn Pad |
| 094 | Halo Syn Pad |
| 095 | Sweep Syn Pad |
| 096 | SFX Rain |
| 097 | SFX Soundtrack |
| 098 | SFX Crystal |
| 099 | SFX Atmosphere |
| 100 | SFX Brightness |
| 101 | SFX Goblins |
| 102 | SFX Echoes |
| 103 | SFX Sci-fi |
| 104 | Sitar |
| 105 | Banjo |
| 106 | Shamisen |
| 107 | Koto |
| 108 | Kalimba |
| 109 | Bag Pipe |
| 110 | Fiddle |
| 111 | Shanai |
| 112 | Tinkle Bell |

*[p. 388]*

| No. | Voice name |
|---|---|
| 113 | Agogo |
| 114 | Steel Drums |
| 115 | Woodblock |
| 116 | Taiko Drum |
| 117 | Melodic Tom |
| 118 | Syn Drum |
| 119 | Reverse Cymbal |
| 120 | Guitar Fret Noise |
| 121 | Breath Noise |
| 122 | Seashore |
| 123 | Bird Tweet |
| 124 | Telephone Ring |
| 125 | Helicopter |
| 126 | Applause |
| 127 | Gun Shot |

# Appendix

*[p. 389: Appendix title page. p. 390 is blank.]*

*[p. 391]*

## Error message and code table

Each entry gives the error code, the error message (exactly as displayed) and its cause. Some entries also give a remedy.

#### 1 · `NEXT without FOR`
**Cause:** Occurs when no FOR command corresponding to a NEXT command can be found.

#### 2 · `Syntax error`
**Cause:** Occurs when the grammar is wrong, for example the syntax of a command, the number of (), the position of commas or the separation of commands.

#### 3 · `RETURN without GOSUB`
**Cause:** Occurs when RETURN is used without having been called from a GOSUB command.

#### 4 · `Out of DATA`
**Cause:** Occurs when there is no data to read in a command that reads DATA statements, such as READ, SETCHR or SETPOLYGON.

#### 5 · `Illegal function call`
**Cause:** Occurs when a command or function is called in the wrong way.

#### 6 · `Overflow`
**Cause:** Occurs when, during numeric calculation or polygon registration, converting a value to fixed-point goes beyond the range that fixed-point can represent.

*[p. 392]*

#### 7 · `Out of memory`
**Cause:** Occurs when memory cannot be reserved, for example when the CLEAR command cannot reserve the area needed, when the DIM command cannot reserve the number of elements needed, when a program larger than the program area is read during program entry on the edit screen or with the LOAD command, or when PEEK or POKE tries to read or write beyond the user area.

**Remedy:** Change the memory allocation with the CLEAR command.

#### 8 · `Undefined line number`
**Cause:** Occurs when a line number or label given in GOTO, GOSUB and so on does not exist.

#### 9 · `Subscript out of range`
**Cause:** Occurs when the value given as an array subscript is beyond the range given when the array was declared.

#### 10 · `Variable already defined`
**Cause:** Occurs when the DIM command tries to register a variable that is already defined.

#### 11 · `Division by 0`
**Cause:** Occurs when dividing by 0 during numeric calculation.

#### 12 · `Illegal direct`
**Cause:** Occurs when trying to execute a command that cannot be executed in direct mode.

#### 13 · `Type mismatch`
**Cause:** Occurs when types do not match, for example when a numeric value is assigned to a string variable.

*[p. 393]*

#### 14 · `Sound: MML String too short`
**Cause:** Occurs when the length in time of an MML string is too short.

#### 15 · `String too long`
**Cause:** Occurs in the following cases:
- When trying to handle a string of more than 65535 characters.
- When a string entered on the edit screen is too long.

#### 16 · `Formula too complex`
**Cause:** Occurs in the following cases:
- When an expression is too complex.
- When functions are nested too deeply.

#### 17 · `Can't continue`
**Cause:** Occurs when execution cannot be resumed.

#### 18 · `Undefined array`
**Cause:** Occurs when trying to handle an array variable that has not been declared with DIM.

#### 19 · `Dimension size error`
**Cause:** Occurs when trying to handle an array variable with a number of dimensions different from that given when it was declared with DIM.

#### 20 · `Communication error`
**Cause:** Means that a communication error has occurred.

**Remedy:** Check the connection of the communication cable. First, check that the speed setting of the communication software matches the communication speed on the settings screen shown with the L+R+Z buttons of the control pad, then press the connect button of the communication software to reconnect.

*[p. 394]*

#### 21 · `No RESUME`
**Cause:** Occurs when there has been no return with the RESUME command, for example when the program reaches its end during error handling with the ON ERROR command. It does not occur if the program ends with an END statement.

#### 22 · `RESUME without error`
**Cause:** Occurs when RESUME is attempted although no error has occurred.

#### 23 · `Illegal line number`
**Cause:** Occurs in the following cases:
- When a line number is invalid.
- When a line number of 0 or above 99999 is given.

#### 24 · `Stack overflow`
**Cause:** Occurs in the following cases:
- When the FOR-NEXT or GOSUB stack overflows.
- When the figure to be filled by the PAINT command is too complex.

#### 25 · `IF stack overflow`
**Cause:** Occurs when IF commands are nested too deeply.

#### 26 · `ELSE/ENDIF without IF`
**Cause:** Occurs when there is no IF corresponding to ELSE or ENDIF.

#### 27 · `FOR without NEXT`
**Cause:** Occurs when no NEXT command corresponding to a FOR command can be found.

#### 28 · `Direct statement only`
**Cause:** Occurs when trying to execute a command that cannot be executed in program mode.

*[p. 395]*

#### 29 · `Data statement`
**Cause:** Occurs when the contents of a DATA statement are read with a READ command or similar and there is no closing double quote (") by the end.

In commands other than DATA statements and comment statements, a missing second double quote is added automatically.

#### 30 · `String format error`
**Cause:** Occurs when the structure of the string given to the GCOPY or CCOPY command is wrong.

#### 31 · `Parameter mismatch`
**Cause:** Occurs when parameters do not match, for example in PRINT USING.

#### 32 · `IF/ELSE without ENDIF`
**Cause:** Occurs when there is no ENDIF corresponding to IF or ELSE.

#### 34 · `Undefined vertex`
**Cause:** Occurs in the following cases:
- When the SETVERTEX command tries to register vertices in an undefined vertex ID.
- When the SETPOLYGON command tries to use an undefined vertex ID.
- When the VERTEXID function tries to examine the contents of an undefined vertex ID.

#### 35 · `Undefined polygon`
**Cause:** Occurs in the following cases:
- When the SETPOLYGON command tries to register data in an undefined polygon ID.
- When trying to register an undefined polygon ID in an object.
- When the POLYGONID function tries to examine the contents of an undefined polygon ID.

*[p. 396]*

#### 36 · `Undefined attribute`
**Cause:** Occurs in the following cases:
- When the SETATR command tries to register data in an undefined attribute ID.
- When trying to register an undefined attribute ID in an object.

#### 37 · `Undefined texture`
**Cause:** Occurs in the following cases:
- When the SETTEX command tries to register data for an undefined texture ID.
- When the SETATR command tries to register an undefined texture ID in an attribute.
- When the PUTSPRITE command tries to use an undefined texture ID (the sprite pattern = texture must be defined beforehand with the SPRITE$ command).
- When the TEXID function tries to examine the contents of an undefined texture ID.

#### 39 · `Version mismatch`
**Cause:** Occurs when the version of a BASIC program is different.

#### 41 · `Unusable charactor`
**Cause:** Occurs when an invalid character is registered when registering BASIC.

#### 42 · `Buffer full`
**Cause:** Occurs when, while executing the FWRITE command on the BRAM:, CRAM:, FD0:, FD1: or COM: device, more data is written than the size of the buffer reserved with the CLEAR command.

#### 43 · `Device not connected`
**Cause:** Occurs when, while using the CRAM:, FD0: or FD1: device, the device concerned is not connected, or for example when the SEGA Saturn was started without a floppy disk inserted.

*[p. 397]*

**Remedy:** Read the manual of each device.

#### 44 · `Device not formatted`
**Cause:** Occurs when a floppy disk that has not been formatted (fully erased) is used with the FD0: or FD1: device.

**Remedy:** Check the contents of the floppy disk carefully, and if it is all right to erase them, set the "protect notch" to "write enabled" and execute the FORMAT command. For details, read the manual of the SEGA Saturn floppy disk drive.

#### 45 · `Device write protected`
**Cause:** Occurs when the "protect notch" of the floppy disk is set to write-protected, for the FD0: or FD1: device.

#### 46 · `Device verify error`
**Cause:** Occurs when a file is damaged.

#### 47 · `Not enough space`
**Cause:** Occurs when there is not enough space to write while using the BRAM:, CRAM:, FD0: or FD1: device.

#### 48 · `Backup RAM error`
**Cause:** Other errors while using the BRAM:, CRAM:, FD0: or FD1: device.

#### 50 · `File access error`
**Cause:** Occurs when the host's file could not be read or written while using the communication software.

#### 51 · `Internal error`
**Cause:** An internal error.

*[p. 398]*

#### 52 · `Sound: Out of layer memory`
**Cause:** Occurs when there is not enough layer area.

#### 53 · `File not found`
**Cause:** Occurs when a file cannot be found.

#### 54 · `File already open`
**Cause:** Occurs when OPEN, KILL or similar is attempted on a file that is already open.

#### 55 · `Access past EOF`
**Cause:** Occurs when trying to access beyond the end of a file.

#### 56 · `Bad file name`
**Cause:** Occurs when trying to use an invalid file name.

#### 57 · `Invalid BASIC file`
**Cause:** Occurs when trying to LOAD a file that is not a BASIC file.

#### 58 · `Duplicated label`
**Cause:** Occurs when a label is defined more than once.

#### 59 · `File not OPEN`
**Cause:** Occurs when a file number is used without being opened.

#### 60 · `Already formatted`
**Cause:** Occurs when it is already formatted.

*[p. 399]*

#### 61 · `Bad file mode`
**Cause:** Occurs when the file mode is invalid.

#### 62 · `Bad device name`
**Cause:** Occurs when the device name is invalid.

#### 63 · `Sound: Not layer mode`
**Cause:** Occurs when not in layer edit mode.

#### 64 · `File still open`
**Cause:** Occurs when trying to use a file that is open.

#### 65 · `Sound: Command buffer full`
**Cause:** Occurs when the command buffer on the sound driver side is full.

#### 66 · `Sound: Out of sound memory`
**Cause:** Occurs when sound memory cannot be reserved.

#### 67 · `Sound: MML command error`
An MML command error. The following are the error details displayed at the same time.

| Detail message | Cause |
|---|---|
| `MML Syntax error` | Occurs when there is a grammatical error. |
| `Bad note length` | Occurs when a note length is not given correctly. |
| `Velocity value(0 <=> 127)` | Occurs when a velocity value is not correct. |
| `Not gate time ratio` *[p. 400]* | Occurs when the format of the key-on specification relative to the note length is not correct. |
| `Bad gate time ratio` | Occurs when the range of the key-on specification relative to the note length is not correct. |
| `Bad pitch bend value` | Occurs when the value of a pitch-bend option is not correct. |
| `Not chord '(...)'` | Occurs when a chord is not specified correctly. |
| `Can't nest - plets` | Occurs when tuplets are nested. |
| `Bad note number(0 <=> 127)` | Occurs when a note number is not correct. |
| `Bad tone number` | Occurs when a voice specification is not correct. |
| `Bad signature(-7 <=> 7)` | Occurs when a key signature is not correct. |
| `Bad transpose value(-127 <=> 127)` | Occurs when a key transpose value is not correct. |
| `Bad tempo value(40 <=> 300)` *[p. 401]* | Occurs when a tempo value is not correct. |
| `Tempo change over` | Occurs when there are too many tempo changes. |
| `Bad volume value(0 <=> 15 @:127)` | Occurs when a volume value is not given correctly. |
| `Bad direct pan value(0 <=> 127)` | Occurs when a pan value is not correct. |
| `Bad octave value(0 <=> 8)` | Occurs when an octave is not given correctly. |
| `Not MML command` | Occurs when it is not an MML command. |
| `Bad damper value(0 or 1)` | Occurs when the damper is not given correctly. |
| `Macro error` | A macro registration error. |
| `Software layer error` | Occurs when a Software layer parameter is not correct. |
| `Pitch bend cmd.buffer overflow` | Occurs when too many pitch bends are given. |
| `Not base track` *[p. 402]* | Occurs when a command that can be placed only in the base track is written elsewhere. |
| `Bad label(0 <=> 7)` | Occurs when the range of a label is not correct. |
| `D.S. without '$'` | Occurs when no segno sign corresponding to a dal segno can be found. |
| `Bad '$'or'*'or'ds'position` | Occurs when the positions of the segno, coda and dal segno signs relative to each other are not correct. |
| `Repeat command error` | Occurs when a repeat-processing command is not correct. |
| `Bad effect pan value(0 <=> 127)` | Occurs when an effect pan value is not correct. |
| `Bad effect level(0 <=> 7)` | Occurs when an effect level value is not correct. |
| `Bad effect number(0 <=> 15)` | Occurs when an effect number is not correct. |
| `Not DSP mode` | Occurs when not in DSP mode. |
| `Bad DSP mixer number(0 <=> 15)` *[p. 403]* | Occurs when a DSP output mixer number is not correct. |
| `Bad status value(0 <=> 127)` | Occurs when a status value is not correct. |
| `Not code name` | Occurs when a chord name is not correct. |
| `Chord note over(2<=>32)` | Occurs when there are too many notes making up a chord. |

#### 68 · `Sound:Out of MML data`
**Cause:** Occurs when the MML string is not long enough.

#### 69 · `File read error`
**Cause:** Occurs when a file cannot be read.

#### 70 · `File write error`
**Cause:** Occurs when a file cannot be written.

#### 71 · `Sound: Song bank full`
**Cause:** Occurs when the reserved blocks are exceeded.

#### 72 · `Sound: Layer overflow`
**Cause:** Occurs when no more layers can be registered.

#### 73 · `Sound: Tone overflow`
**Cause:** Occurs when no more voices can be registered.

*[p. 404]*

#### 74 · `Sound: VL overflow`
**Cause:** Occurs when no more VL (velocity level) conversion data can be registered.

Occurs when there is not enough layer area.

#### 75 · `Sound: PEG overflow`
**Cause:** Occurs when no more PEG (pitch envelope) data can be registered.

Occurs when there is not enough layer area.

#### 76 · `Sound: PLFO overflow`
**Cause:** Occurs when no more PLFO (pitch LFO) data can be registered.

Occurs when there is not enough layer area.

#### 77 · `Sound: No layer`
**Cause:** Occurs when not a single layer is registered.

#### 78 · `Invalid USERDATA`
**Cause:** Invalid USERDATA.

#### 79 · `Vertex size mismatch`
**Cause:** Occurs when, on re-registering the same ID with the SETVERTEX command, a size different from the previously registered size is given.

#### 80 · `Vertex number`
**Cause:** Occurs when the vertex list of SETPOLYGON is larger than the number of vertices defined in the corresponding vertex group (that is, when an undefined vertex number is used).

**Explanation:** The SETPOLYGON command registers a face by joining 3 or 4 vertex numbers defined with the SETVERTEX command. So the numbers in the vertex list of SETPOLYGON must be values within 0 to (number of vertices − 1) of the vertex ID they are to correspond to.

*[p. 405]*

#### 81 · `Vertex ID over`
**Cause:** Occurs when no more vertex ID numbers can be registered with the SETVERTEX command.

#### 82 · `Vertex data over`
**Cause:** Occurs when no more data can be registered with the SETVERTEX command (when many vertices are reserved with one ID).

#### 83 · `Vertex out of area`
**Cause:** Occurs when trying to define data beyond the number of vertices reserved with `<number of vertices>` of the SETVERTEX command.

#### 84 · `Texture size mismatch`
**Cause:** Occurs when, on re-registering a texture with the SETTEX command, a size different from the previously registered size is given.

#### 85 · `Texture ID over`
**Cause:** Occurs when no more ID numbers can be registered with the SETTEX command.

#### 86 · `Texture data over`
**Cause:** Occurs when data larger than the area size given with the SETTEX command is registered.

#### 87 · `Sound: Invalid WAVE file`
**Cause:** Occurs when it is not wave data.

#### 88 · `Sound: Bad WAVE file format`
**Cause:** Occurs when the format of the wave data is different.

*[p. 406]*

#### 89 · `Polygon size mismatch`
**Cause:** Occurs when, on re-registering with the SETPOLYGON command, a size different from the previously registered size is given.

#### 90 · `Polygon ID over`
**Cause:** Occurs when no more ID numbers can be registered with the SETPOLYGON command.

#### 91 · `Polygon data over`
**Cause:** Occurs when no more data can be registered with the SETPOLYGON command (when many vertices are reserved with one ID).

#### 92 · `Attribute size mismatch`
**Cause:** Occurs when, on re-registering an existing attribute ID with the SETATR or SETPFONT command, a size different from the previously registered size is given.

#### 93 · `Attribute ID over`
**Cause:** Occurs when no more attribute ID numbers can be registered with the SETATR command.

#### 94 · `Attribute data over`
**Cause:** Occurs when no more data can be registered with the SETATR command (when many vertices are reserved with one ID).

#### 95 · `Attribute out of area`
**Cause:** Occurs when more data than the size given with the SETATR command is registered.

*[p. 407]*

## List of BASIC files (sample programs)

Data files used by a program are listed indented beneath it (shown here with "·").

| File name | Contents |
|---|---|
| CLOCK.B | Clock sample program |
| DEMO.B | GAME BASIC for SEGASATURN demo program |
| · FONT161.D | Kanji font data (loaded into memory with KLOAD) |
| · FONT162.D | Kanji font data (loaded into memory with KLOAD) |
| G_BOMB.B | Sample game "Bomb" for the Multi-Terminal 6 |
| G_BOU.B | "Bou" (stick) start-up program |
| · BOU_SCD.B | "Bou" title display program |
| · BOU_TCD.B | "Bou" texture setup program |
| · BOU_MCD.B | "Bou" main program |
| G_HATA.B | "Hata" (flag) game program |
| G_JUMP.B | Sample game "Jump" |
| G_JUMP_A.B | Sample game "Jump", Multi Controller version |
| G_JUMP_M.B | Sample game "Jump", Mission Stick version |
| G_MAZE.B | Sample game "Maze" |
| G_MOBIL.B | Sample game "Mobile" |
| G_MOBILS.B | Sample game "Mobile", Racing Controller version |
| G_SABA.B | "Saba" (mackerel) game program |
| · SABA_BG.0 | "Saba" background image data (256 colours) |
| G_TEKE.B | "Teketeke" main program |
| · TEKEND.1 | "Teketeke" ending graphic data (32768 colours) |
| · TEKST.1 | "Teketeke" start graphic data (32768 colours) |
| G_THESEU.B *[p. 408]* | Theseus main program |
| · PALWIN.D | Palette data |
| · BGCHR.D | BG character data |
| · WLCHR.D | Wall pattern data |
| · MYCHR.D | Player character data |
| · ENECHR.D | Enemy character data |
| · YAKCHR.D | Character data for items and so on |
| · HEROCHR.D | End character |
| · MAZE01.D | Maze data for stages 1–3 |
| · MAZE04.D | Maze data for stages 4–5 |
| · MAZE06.D | Maze data for stages 6–7 |
| · MAZE08.D | Maze data for stage 8 |
| · MAZE09.D | Maze data for stage 9 |
| · MAZE10.D | Maze data up to stage 10 |
| · ITEM01.D … · ITEM10.D | Item data (stages 1–10) |
| · ENEM01.D … · ENEM10.D | Enemy data (stages 1–10) |
| · INID01.D … · INID10.D | Initial setting data (stages 1–10) |
| LAUNCH.B | File launcher (simple filer) program |
| P_CAME2.B | Camera command test program |
| P_CLOCK.B | Polygon clock sample program |
| P_DLPLAY.B | Polygon doll animation demo program |
| · TAISOPT.D | Sample data for P_DLPLAY.B |
| P_DOLL.B | Polygon doll animation program |
| · TAISO.D | Sample data for P_DOLL.B |
| P_FLOWER.B | Texture test program |
| P_HERI.B | Polygon test program |
| P_NEKO.B | Sprite test program |
| P_PFONT.B | Polygon font display test program |
| P_SHOWER.B *[p. 409]* | Polygon test program |
| P_TANK.B | Polygon test program |
| P_TEXMAP.B | Polygon test program |
| PLAYMIDI.B | Program that converts MIDI files to MML |
| S_AIFF.B | PCM sound source test program |
| · BEAT_A.D | AIFF file |
| · SAMPLE_A.D | AIFF file |
| · WAVE1_A.D | AIFF file |
| S_FM_TA.B | FM sound source test program |
| S_GM_FM1.B | GMIDI-order FM sound source building program ① |
| S_GM_FM2.B | GMIDI-order FM sound source building program ② |
| S_GM_FM3.B | GMIDI-order FM sound source building program ③ |
| S_GM_FM4.B | GMIDI-order FM sound source building program ④ |
| S_TUTOR.B | Sound function sample program (tutorial) |
| S_CLASSI.B | Menu for the classical sample music (selects the following 6 pieces) |
| · S_ARIA_P.B | "Air on the G String (pipe organ)" music program |
| · S_ARIA.B | "Air on the G String (strings)" music program |
| · S_POLONA.B | "Heroic Polonaise" music program |
| · S_MARIA.B | "Gounod's Ave Maria" music program |
| · S_FUGA.B | "Little Fugue in G minor" music program |
| · S_KANON.B | "Pachelbel's Canon" music program |
| S_G_ARTS.B | Menu for the game sample music (selects the following 8 pieces) |
| · S_SILPH.B | "Silpheed" music program |
| · S_ZELIAR.B | "Zeliard" music program |
| · S_VEIGUS.B | "Veigues" music program |
| · S_F_HAWK.B | "Fire Hawk" music program |
| · S_ALISIA.B | "Alisia Dragoon" music program |
| · S_LUNARA.B | "Lunar" arrangement A music program |
| · S_LUNARB.B | "Lunar" arrangement B music program |
| · S_TUBASA.B | "Tubasa (LUNAR theme)" music program |
| S_T_NAME.B | Name file for the sound source data |
| S_WAVE.B *[p. 410]* | PCM sound source test program |
| · BEAT_W.D | WAVE file |
| · SAMPLE_W.D | WAVE file |
| · WAVE1_W.D | WAVE file |
| T_HIBIKI.B | "Hibiki" title display program |
| · H_MAIN.B | "Hibiki" main program |
| · H_SET.B | "Hibiki" texture setup program |
| · HIBIKI_0.0 | "Hibiki" background image data (256 colours) |
| · LST1_00.D … · LST1_15.D | "Oto"/"Hibiki" voice name data |
| T_KANADE.B | "Kanade" program |
| T_KAMI.B | "Kami" title display program |
| · K_MAIN.B | "Kami" main program |
| T_OTO.B | "Oto" title display program |
| · O_MAIN.B | "Oto" main program |
| · O_SET.B | "Oto" texture setup program |
| · OTO_DATA.D | "Oto" data file |
| TRANSFOR.B | Program that transfers "*.D" files to "COM:" |
| UD_DATA1.B | "USERDATA command" test program |
| UD_DATA2.B | "USERDATA command" test program |

*[p. 411]*

## Character code table

The table gives each character by its code: the column is the upper 4 bits and the row is the lower 4 bits. Columns 0 and 1 are empty. The text characters (columns 2–7 and A–D) are:

| Lower 4 bits ↓ / upper 4 bits → | 2 | 3 | 4 | 5 | 6 | 7 | A | B | C | D |
|---|---|---|---|---|---|---|---|---|---|---|
| 0 |   | 0 | @ | P | &#96; | p |  | ー | タ | ミ |
| 1 | ! | 1 | A | Q | a | q | 。 | ア | チ | ム |
| 2 | " | 2 | B | R | b | r | 「 | イ | ツ | メ |
| 3 | # | 3 | C | S | c | s | 」 | ウ | テ | モ |
| 4 | $ | 4 | D | T | d | t | 、 | エ | ト | ヤ |
| 5 | % | 5 | E | U | e | u | ・ | オ | ナ | ユ |
| 6 | & | 6 | F | V | f | v | ヲ | カ | ニ | ヨ |
| 7 | ' | 7 | G | W | g | w | ァ | キ | ヌ | ラ |
| 8 | ( | 8 | H | X | h | x | ィ | ク | ネ | リ |
| 9 | ) | 9 | I | Y | i | y | ゥ | ケ | ノ | ル |
| A | \* | : | J | Z | j | z | ェ | コ | ハ | レ |
| B | + | ; | K | [ | k | { | ォ | サ | ヒ | ロ |
| C | , | &lt; | L | ¥ | l | ¦ | ャ | シ | フ | ワ |
| D | - | = | M | ] | m | } | ュ | ス | ヘ | ン |
| E | . | &gt; | N | ^ | n | ~ | ョ | セ | ホ | ゛ |
| F | / | ? | O | \_ | o |  | ッ | ソ | マ | ゜ |

(Code 20 is the space. Code 5C is printed as ¥ and 7C as a broken bar ¦. Code 7F is empty, as is A0.)

The remaining columns hold graphic characters:

- *Column 8:* 80–8E are solid block shapes in graded steps (horizontal bars for 80–87, vertical bars for 88–8E). 8F is a cross (┼).
- *Column 9:* box-drawing lines. 90–93 are the T-pieces ┴ ┬ ┤ ├, 94–95 are horizontal lines and 96–97 vertical lines, 98–9B are the corners ┌ ┐ └ ┘, and 9C–9F are rounded corners (curved line pieces).
- *Column E:* E0–E3 are horizontal line patterns, E4–E7 diagonal half-filled triangles, E8–EB the card suits ♠ ♥ ♦ ♣, EC a filled circle ●, ED an open circle ○, and EE–EF diagonal line pieces.
- *Column F:* F0 is a box with a diagonal cross, F1–F7 are the kanji 円 年 月 日 時 分 秒 (yen, year, month, day, hour, minute, second), F8–FB are the arrows → ← ↑ ↓, FC is a diagonal line ＼, FD is empty and FE is a tick ✓. FF is empty.

*[p. 412]*

## 3D coordinate conversion diagrams and illustrations

**Illustration of a polygon (sprite) face**

*[Figure: a perspective view of the viewing pyramid. Lines spread out from the viewpoint (視点) on the left. Close to the viewpoint, a dashed rectangle marks the display level (can be changed with the SETDISP command). Further out is the projection plane, 320 wide and 224 high, with a flat polygon face in front of it. Beyond it a cube sits inside the pyramid, which ends at the rear limit (後方限界).]*

*[p. 413]*

**Projection conversion by angle of view**

*[Figure: a side view with the x axis pointing down and the z axis pointing right from the viewpoint. The two edges of the field of view open out from the viewpoint at the angle of view (default 90 degrees). Along the z axis are marked, in order: the display level (can be changed with the SETDISP command), at 1/2 of the distance to the projection plane; the projection plane; and the rear limit plane. The display area runs from the display level to the rear limit plane. Dashed lines project a box-shaped object onto the projection plane. On the right, "how it looks after projection conversion" shows the result in the x–y plane: an outer square and a smaller dashed inner square, centred on the y (horizontal) and x (vertical, downward) axes.]*

*[p. 414]*

**Display level set by SETDISP**

*[Figure: the viewpoint on the left and the projection plane on the right, with an object beyond it. Dashed vertical lines mark level 1 at 1/2, level 2 at 1/4 and level 3 at 1/8 of the distance from the viewpoint to the projection plane. Bands labelled "level 1 display distance", "level 2 display distance" and "level 3 display distance" run from each level to the projection plane. Key: an empty box = the distance that is displayed.]*

*[p. 415 is blank.]*

*[p. 416]*

## Index

Entries are given as in the book, with page numbers.

**Symbols:** `'` 72 · `¥` 321 · `@` 322 · `@V` 326 · `[` 326 · `]` 327 · `(…)` 340 · `<` 343 · `>` 344 · `{…}` 341 · `&` 344 · `%` 346 · `_` 346 · `!` 347 · `/` 347 · `$` 349 · `*` 350 · `:|` 352 · `:|:` 352 · `:|2` 353 · `|` 351 · `|1` 353 · `|:` 352 · `^` 354

**A:** A～G 335 · ABS 24 · ACTIVE 117 · ASC 24 · ATN 25 · ATRID 224

**B:** BEEP 252 · BGM 253 · BIN$ 25 · BINHEX$ 26 · BITW$ 27 · BLOAD 98 · BSAVE 99

**C:** CAMERA 166 · CCOPY 118 · CHR$ 28 · CINT 29 · CIRCLE 120 · CLEAR 29 · CLOSE 100 · CLS 121 · COLOR 122 · COLOROFS 123 · *[p. 417]* CONT 31 · COS 31

**D:** DATA 31 · DATE$ 32 · dc 348 · DELETE 33 · DIM 33 · DISPLAY 124 · ds 350 · DSKF 113 · DSP 254

**E:** ec 330 · EDIT 34 · EFFECT 256 · EG 259 · el 329 · END 35 · ep 328 · ERL 35 · ERR 35 · ERROR 36 · EXP 36

**F:** f 333 · ff 333 · fff 333 · FILES 100 · FILES$ 114 · FIND 37 · FIX 38 · FKEY 38 · FORMAT 101 · FOR TO STEP 39 · FRAC 40 · FRE 40 · FREAD 102 · FWRITE 102

**G:** GCOPY 125 · GETCHR 157 · GLOAD 103 · GOSUB 41 · GOTO 41 · GSAVE 106

**H:** HEX$ 42 · HEXBIN$ 43

**I:** IF GOTO 43 · IF THEN ELSE ENDIF 44 · INKEY$ 47 · INPUT 48 · INPUT$ 49 · INSTR 50 · INT 51 · INTERVAL 51

**K:** K 324 · KILL 108 · KLOAD 127 · KPRINT 128

*[p. 418]*

**L:** L 331 · LEFT$ 53 · LEN 53 · LET 54 · LFO 263 · LINE 132 · LIST 55 · LOAD 108 · LOC 115 · LOCATE 55 · LOCK 56 · LOF 115 · LOG 56

**M:** mf 333 · MID$ 57, 58 · MMLSTAT() 267 · MOSAIC 133 · mp 333

**N:** N 342 · NEW 58 · NEXT 59

**O:** O 330 · OBJ 181

- OBJ item numbers: 0 (@TYPE) 187 · 1 (@FLAG) 191 · 2 (@GROUP) 192 · 4 (@XP) 193 · 5 (@YP) 193 · 6 (@ZP) 193 · 8 (@XR) 193 · 9 (@YR) 193 · 10 (@ZR) 193 · 12 (@XS) 194 · 13 (@YS) 194 · 14 (@ZS) 194 · 16 (@ATR) 195 · 17 (@POLYGON) 196 · 18 (@ORDER) 196 · 19 (@TIME) 197 · 20 (@PARENT) 198 · 21 (@CHILD) 204 · 22 (@LEFT) 204 · 23 (@RIGHT) 205 · 24 (@XV) 205 · 25 (@YV) 205 · 26 (@ZV) 205 · 28 (@XA) 206 · 29 (@YA) 206 · 30 (@ZA) 206 · 32 (@XL) 207 · 33 (@YL) 207 · 34 (@ZL) 207 · 36 (@XRV) 208 · 37 (@YRV) 208 · 38 (@ZRV) 208 · 48 (@XP0) 208 · 49 (@YP0) 208 · 50 (@XP1) 208 · 51 (@YP1) 208 · 52 (@XP2) 209 · 53 (@YP2) 209 · 54 (@XP3) 209 · *[p. 419]* 55 (@YP3) 209 · 56 (@XD) 210 · 57 (@YD) 210 · 58 (@ZD) 210 · 59 (@RD) 210 · 60 (@GTEST) 211 · 61 (@RADIUS) 212 · 62 (@COLIDIST) 212 · 63 (@COLIOBJ) 213 · 64 (M00) 213 · 65 (M01) 213 · 66 (M02) 213 · 67 (M10) 213 · 68 (M11) 213 · 69 (M12) 213 · 70 (M20) 213 · 71 (M21) 213 · 72 (M22) 214 · 73 (M30) 214 · 74 (M31) 214 · 75 (M32) 214

OBJATR 215 · OBJLINK 215 · OBJPOS 216 · OBJROT 216 · OBJTURN 217 · OBJTYPE 217 · OBJZOOM 218 · ON ERROR GOTO 59 · ON GOSUB 60 · ON GOTO 61 · ON INTERVAL 62 · ON RESTORE 63 · ON TIMER 64 · OPEN 110

**P:** p 333 · P 327 · PAD 64 · PAINT 134 · PALETTE 136, 158 · PEEK 67 · PEEK$ 68 · PLAY 270 · PLAYCONT 272 · PLAYFADE 273 · PLAYINIT 274 · PLAYPAN 279 · PLAYPAUSE 280 · PLAYSTAT() 272 · PLAYSTOP 280 · PLAYTEMPO 280 · POINT 159 · POKE 68 · POLYGONID 224 · POS 69 · pp 333 · ppp 333 · PRINT 69 · PRINT USING 70 · PRIORITY 137 · PSET 139 · PUTCHR 139 · PUTSPRITE 167

**Q:** q 334

*[p. 420]*

**R:** R 342 · RANDOMIZE 71 · READ 72 · READCHR$ 160 · READHEX$ 161 · REM 72 · RENUM 73 · RESTORE 73 · RESUME 74 · RETURN 74 · RGB 162 · RGBADD 163 · RGBTO 164 · RIGHT$ 75 · RND 75 · ROTATE 142 · ROTCENTER 142 · ROTOVER 143 · ROTPOS 144 · ROTZOOM 145 · RUN 76

**S:** S 323 · SAVE 111 · SCREEN 146 · SCROLL 151 · SEEK 112 · SETATR 218 · SETCHR 152 · SETDISP 169 · SETLIGHT 169 · SETPERS 170 · SETPFONT 170 · SETPOLYGON 172 · SETSONG 281 · SETSPRITE 174 · SETTEX 222 · SETVERTEX 175 · SFRE() 283 · SGN 77 · SHIFT 77 · SIN 78 · SKCLOSE 79 · SPACE$ 79 · SPRITE$ 177 · SPRWINDOW 178 · SQR 80 · STOP 80 · STR$ 80 · STRING$ 81 · STRW$ 82 · SWAP 83

**T:** T 324 · TAN 83 · TARG 285 · TEXID 225 · TFRE() 307 · TIMER 84 · TLIST 308 · TPROP() 309

- TPROP item numbers: 0 (@BEND) 311 · 1 (@LAYER) 311 · 2 (@TONE) 311 · 10 (@SN) 311 · 11 (@EN) 311 · *[p. 421]* 12 (@BN) 312 · 13 (@FT) 312 · 20 (@AR) 312 · 21 (@DR) 312 · 22 (@SR) 312 · 23 (@RR) 312 · 24 (@SL) 312 · 25 (@EGHOLD) 312 · 26 (@LSLINK) 312 · 27 (@KS) 312 · 30 (@SDIR) 313 · 31 (@SB) 313 · 32 (@SS) 313 · 33 (@LOOP) 313 · 34 (@PCM8B) 314 · 35 (@LSA) 314 · 36 (@LEA) 314 · 50 (@RE) 314 · 51 (@LFOF) 314 · 52 (@ALFOWS) 314 · 53 (@ALFOS) 314 · 54 (@PLFOWS) 314 · 55 (@PLFOS) 314 · 60 (@MDX) 315 · 61 (@MDY) 315 · 62 (@MDL) 315 · 70 (@ISEL) 315 · 71 (@IMIX) 315 · 72 (@DSEND) 315 · 73 (@DPAN) 316

**U:** UNLOCK 85 · USERDATA 86 · USERDATA() 88

**V:** v 333 · V 325 · VAL 89 · VERSION 89 · VERTEX 226 · VOLUME 317 · VSYNC 154

**W:** WADD$ 90 · WANDOR$ 90 · WIDTH 91 · WINDOW 155 · WMUL$ 91 · WXOR$ 92

**X:** XATN 93 · XCOS 93 · XDIST 94 · XSIN 94 · XSQR 95 · XTAN 95

**Z:** ZOOM 156

*[Two blank pages follow, then the back cover.]*

