# GAME BASIC for SEGASATURN
GAME BASIC for SEGASATURN was a BASIC interpreter for the Saturn, released in Japan in 1998 by ASCII Corp., Bits Laboratory and ESP inc. It came with a Windows 95 CD of PC tools that send programs to the Saturn over a serial communication cable.<br>

The aim here is a modern Mac/Linux/Windows workflow: edit BASIC on a PC and send it to the Saturn through a USB-TTL serial adapter.<br>

## Folders
| Folder | What it contains |
|---|---|
| [WIN_TOOLS_CD](WIN95_TOOLS_CD) | The original Windows 95 tools CD, as shipped. Japanese InstallShield 3 installers. |
| [BASTERM](BASTERM) | BASTERM 1.0, the editor and serial terminal, unpacked from `Instbt10.exe`, plus my analysis of it. |
| [DXFCONV](DXFCONV) | The DXF to BASIC 3D model converters, unpacked from `Instdc10.exe`, with their C source and samples. |
| [vscode-game-basic](vscode-game-basic) | VS Code extension: highlighting, live checks and Send/Run/Stop/Receive for GAME BASIC, on macOS, Linux and Windows. |
| [tools](tools) | `saturn_send.py`, the Python (pyserial) replacement for BASTERM's serial link that the extension uses. Has a mock Saturn for testing without hardware. |

### WIN_TOOLS_CD
| File | Description |
|---|---|
| `autorun.inf` | Runs `ToolLoad.exe /1 instbt10.exe instdc10.exe` when the CD is inserted |
| `ToolLoad.exe` | Autorun menu for choosing which installer to run |
| `Instbt10.exe` | Installer for BASTERM |
| `Instdc10.exe` | Installer for DXFCONV |

The installers don't need Windows to unpack. Each is a ZIP-based self-extractor holding an InstallShield 3 `data.z` archive, compressed with PKWARE DCL implode.

### BASTERM
BASTERM is the only tool that talks to the Saturn. It is an editor with Send, Receive, Run, Stop and live key-send commands.

| File | Description |
|---|---|
| `BASTERM_serial_protocol.md` | **Start here.** How BASTERM talks to the Saturn: serial settings, wire format, command table, keystroke codes and BASIC file format |
| `Basterm.exe` | The original Win32 program |
| `Basterm_decompiled.c` | Ghidra decompilation of `Basterm.exe` (2,352 functions), used for the protocol analysis |
| `BASTERM.HLP`, `basterm.cnt` | The original Japanese WinHelp file and its contents list |
| `BASTERM_help_text_JP.txt` | The help text pulled out of `BASTERM.HLP` as plain Japanese text |
| `readme.txt` | Original release note (Japanese, Shift-JIS) |

In short, the PC acts as a file server. BASTERM types `LOAD "COM:TBASTERM.B"` at the Saturn as encoded keystrokes, and the Saturn then reads the program as plain text. The link is 9600 or 19200 baud, 8N1, no flow control, and data moves in 252-byte blocks with a CRC-16 check. Tokenising happens on the Saturn, not the PC.

### DXFCONV
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
| `README.TXT` | Original Japanese documentation (Shift-JIS) |

## Next steps
- Confirm the protocol on real hardware with a logic analyser; the open questions are listed at the end of `BASTERM/BASTERM_serial_protocol.md`.
- Try `tools/saturn_send.py` and the VS Code extension on real hardware; the checks still to do are listed in [tools/README.md](tools/README.md).

## Copyright
The CD contents, `Basterm.exe` and the decompiled code are ©1998 ASCII Corp./Bits Laboratory/ESP inc. They are kept here for research and preservation.
