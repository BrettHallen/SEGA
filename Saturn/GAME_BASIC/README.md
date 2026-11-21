# GAME BASIC for SEGA SATURN
GAME BASIC for SEGA SATURN was a BASIC interpreter for the Saturn, released in Japan in 1998 by ASCII Corp., Bits Laboratory and ESP inc. It came with a Windows 95 CD of PC tools that send programs to the Saturn over a serial communication cable.<br>

The aim here is a modern Mac/Linux/Windows workflow: edit BASIC on a PC and send it to the Saturn through a USB-TTL serial adapter.<br>

## Folders
| Folder | What it contains |
|---|---|
| [GAME_BASIC_CD](GAME_BASIC_CD) | The GAME BASIC CD for the Saturn, and the analysis of the interpreter on it |
| [WIN95_TOOLS_CD](WIN95_TOOLS_CD) | The original Windows 95 tools CD, as shipped. Japanese InstallShield 3 installers. |
| [BASTERM](BASTERM) | BASTERM 1.0, the editor and serial terminal, unpacked from `Instbt10.exe`, plus my analysis of it. |
| [DXFCONV](DXFCONV) | The DXF to BASIC 3D model converters, unpacked from `Instdc10.exe`, with their C source and samples. |
| [vscode-game-basic](vscode-game-basic) | VS Code extension: highlighting, live checks and Send/Run/Stop/Receive for GAME BASIC, on macOS, Linux and Windows. |
| [Documentation](Documentation) | The two Japanese manuals as PDFs, their English translations, an English User Guide, and notes on both manuals. |
| [tools](tools) | `saturn_send.py`, the Python (pyserial) replacement for BASTERM's serial link that the extension uses, with a mock Saturn for testing without hardware; `saturn_bitmap.py`, a PNG converter for Saturn bitmaps, characters and sprites; and `gbcd_extract.py` and `gbcd_disasm.py`, which extract and disassemble the GAME BASIC CD. |

### [GAME_BASIC_CD](/Saturn/GAME_BASIC/GAME_BASIC_CD)
Files, ISO and analysis of GAME BASIC itself.<br>

The analysis explains how the interpreter on this CD works: the boot loader, the memory map, the Saturn's side of the serial link, the tokenised program format and the file formats. [`tools/gbcd_extract.py`](tools/gbcd_extract.py) extracts the CD and unpacks the interpreter for anyone who wants to check it, and [`tools/gbcd_disasm.py`](tools/gbcd_disasm.py) turns it into a commented disassembly (`GAME_BASIC_CD/GAME_BASIC_main.s`). The ISO, the copy of its files and the disassembly are copyrighted, so they are kept out of the repository; the README also holds an English translation of the CD's staff credits.

### [WIN95_TOOLS_CD](/Saturn/GAME_BASIC/WIN95_TOOLS_CD)
| File | Description |
|---|---|
| `autorun.inf` | Runs `ToolLoad.exe /1 instbt10.exe instdc10.exe` when the CD is inserted |
| `ToolLoad.exe` | Autorun menu for choosing which installer to run |
| `Instbt10.exe` | Installer for BASTERM |
| `Instdc10.exe` | Installer for DXFCONV |

The installers don't need Windows to unpack. Each is a ZIP-based self-extractor holding an InstallShield 3 `data.z` archive, compressed with PKWARE DCL implode.

### [BASTERM](/Saturn/GAME_BASIC/BASTERM)
BASTERM is the only tool on the original CD that talks to the Saturn. It is an editor with Send, Receive, Run, Stop and live key-send commands.

| File | Description |
|---|---|
| `BASTERM_serial_protocol.md` | **Start here.** How BASTERM talks to the Saturn: serial settings, wire format, command table, keystroke codes and BASIC file format |
| `Basterm.exe` | The original Win32 program (kept out of the public repository, like the other original programs) |
| `Basterm_decompiled.c` | Ghidra decompilation of `Basterm.exe` (2,352 functions), used for the protocol analysis. Kept out of the public repository |
| `BASTERM.HLP`, `basterm.cnt` | The original Japanese WinHelp file and its contents list |
| `BASTERM_help_text_JP.txt` | The help text pulled out of `BASTERM.HLP` as plain Japanese text |
| `BASTERM_help_text_EN.txt` | The same help text, line by line, with an English translation under each line |
| `readme_JP.txt`, `readme_EN.txt` | Original release note (Japanese, Shift-JIS) and its English translation |

In short, the PC acts as a file server. BASTERM types `LOAD "COM:TBASTERM.B"` at the Saturn as encoded keystrokes, and the Saturn then reads the program as plain text. The link is 9600 or 19200 baud (up to 115200 after the undocumented `OPTION HD352`, untested on hardware), 8N1, no flow control, and data moves in 252-byte blocks with a CRC-16 check. Tokenising happens on the Saturn, not the PC. The protocol has been read from both ends, BASTERM and the Saturn interpreter, and they agree.

### [DXFCONV](/Saturn/GAME_BASIC/DXFCONV)
DXFCONV turns `3DFACE` entities in a DXF model into BASIC `DATA` lines for `SETVERTEX` and `SETPOLYGON`. It works offline and never touches the serial port.

| File | Description |
|---|---|
| `DXFCONV.EXE` | Windows 95 GUI converter: DXF straight to a `.B` program |
| `DXF2POL.EXE` | DOS pass 1: DXF to `.POL` polygon text |
| `POL2BAS.EXE` | DOS pass 2: `.POL` to `.VTX` vertex and `.PNT` polygon `DATA` lines, as one object |
| `POL2BAS2.EXE` | As `POL2BAS.EXE`, but one object per DXF layer |
| `SOURCE/` | C source for the three DOS tools, so they can be rebuilt for any OS |
| `HEADBAS.B` | Small BASIC viewer program that the converters can put in front of the model data |
| `SAMPLE/` | `ASCII` and `GIRL` example models at every stage (`.DXF`, `.POL`, `.VTX`, `.PNT`, `.B`) |
| `README_JP.TXT`, `README_EN.TXT` | Original Japanese documentation (Shift-JIS), and the same text with an English translation under each line |
| `Python/` | Python versions of all four DXFCONV programs, byte-exact with the originals on the samples |

### [Documentation](/Saturn/GAME_BASIC/Documentation)
GAME BASIC came with two Japanese manuals: the *Tutorial Manual* (チュートリアルマニュアル), and the *Reference Manual* (リファレンスマニュアル) with the full command details.

| File | Description |
|---|---|
| `GAME_BASIC_for_SEGA_SATURN_Tutorial_Manual_JP.pdf` | The original Japanese Tutorial Manual (184 pages), including Chapter 3 on BASTERM. Scanned original, kept out of the public repository |
| `GAME_BASIC_for_SEGA_SATURN_Reference_Manual_Part1_JP.pdf` | The original Japanese Reference Manual, part 1: the front matter and Chapter 1, up to p228. Scanned original, kept out of the public repository |
| `GAME_BASIC_for_SEGA_SATURN_Reference_Manual_Part2_JP.pdf` | The original Japanese Reference Manual, part 2: the back matter and Chapter 2, from p229. Scanned original, kept out of the public repository |
| [`GAME_BASIC_for_SEGA_SATURN_Tutorial_Manual_EN.md`](Documentation/GAME_BASIC_for_SEGA_SATURN_Tutorial_Manual_EN.md) ([PDF](Documentation/GAME_BASIC_for_SEGA_SATURN_Tutorial_Manual_EN.pdf)) | English translation of the Tutorial Manual, page by page |
| [`GAME_BASIC_for_SEGA_SATURN_Reference_Manual_EN.md`](Documentation/GAME_BASIC_for_SEGA_SATURN_Reference_Manual_EN.md) ([PDF](Documentation/GAME_BASIC_for_SEGA_SATURN_Reference_Manual_EN.pdf)) | English translation of the Reference Manual, page by page, complete through p. 421 |
| [`GAME_BASIC_for_SEGA_SATURN_User_Guide_EN.md`](Documentation/GAME_BASIC_for_SEGA_SATURN_User_Guide_EN.md) ([PDF](Documentation/GAME_BASIC_for_SEGA_SATURN_User_Guide_EN.pdf)) | **Start here** for using GAME BASIC in English: a guide in its own words, with page references to both manuals |
| [`Tutorial_Manual_findings.md`](Documentation/Tutorial_Manual_findings.md) | Notes from the Tutorial Manual for the BASTERM replacement: connecting, controls, what the Saturn prints, and BASTERM's own behaviour |
| [`Reference_Manual_findings.md`](Documentation/Reference_Manual_findings.md) | Notes from the Reference Manual, chapter by chapter: syntax, limits, error messages and what matters for sending files |
| [`GAME_BASIC_CD/README.md`](GAME_BASIC_CD/README.md) | How the interpreter on the Saturn CD works: boot loader, memory map, serial link, hidden `OPTION` forms and baud rates, raw `COM:` mode, token format and file formats |

## Hardware
The protocol is fully described by the code on both sides. What only real hardware can show is electrical: which speeds a given USB-TTL adapter handles reliably (the 28 MHz rates above 19200 are untested), and the timing on the wire. [`USB_Serial_Connection.md`](USB_Serial_Connection.md) covers the wiring.

## Copyright
The CD contents, the scanned manuals, the original Windows programs, `Basterm.exe`'s decompiled code and the disassembly are ©1998 ASCII Corp./Bits Laboratory/ESP inc. They are kept locally for research and preservation, and the repository's `.gitignore` keeps them out of the public repository.
