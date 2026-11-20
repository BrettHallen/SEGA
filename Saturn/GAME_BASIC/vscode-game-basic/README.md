# GAME BASIC for VS Code

Edit, check and send GAME BASIC for SEGASATURN programs from VS Code on macOS, Linux or Windows, over a 5 V USB-TTL serial adapter. It replaces the editing and Send/Run/Receive side of BASTERM.

The extension does the editing side itself. Anything that touches the serial port is done by the Python sender in [`../tools`](../tools), which the extension runs for you.

## What it does

| Feature | Notes |
|---|---|
| Highlighting | Line numbers, keywords, built-in functions, strings, `'` and `REM` comments, `*labels`, `@ATR`-style object fields, `&H` hex and `&B` binary numbers (with fixed-point fractions), BASTERM's `#include` |
| Live checks | Unnumbered direct commands such as `LOAD"COM:DDD"` and unnumbered comments are shown as notes and left out when sending. Otherwise, the same checks BASTERM makes before sending (missing, duplicate or too-big line numbers, over-long lines), plus characters Shift-JIS can't carry, missing `#include` files, unbalanced brackets, unclosed strings, `GOTO`/`GOSUB`/`RESTORE` to a line or `*label` that doesn't exist, `IF` without `THEN`, direct-only commands such as `NEW`, `LIST` or `SAVE` inside a program line (they stop with error 28 *Direct statement only*), and a `PLAY` with more than about 150 notes, which the Saturn stops with `Sound:Song bank full` (Reference Manual p. 271) |
| Automatic line numbers | Optional, BASTERM style: unnumbered lines get numbers when sent, a numbered line resets the counter, and inlay hints show the number each line will get |
| Hover and completion help | Hover a keyword for its syntax and manual page where known (`src/reference.js`), or an `@NAME` constant such as `@PAD_START` for its value. Inside the MML string of a `PLAY`, `EFFECT` or `DATA` statement, hover a command such as `T150` or `:|2` for its meaning. Hover a `*LABEL`, where it's defined or after a `GOTO`, `GOSUB`, `RESTORE` and so on, to see the line it's on, its first lines, and every line that jumps to it |
| Go to definition and references | **F12** on a `GOTO 100` target or a `*LABEL` goes to it; **Shift+F12** on a `*LABEL` lists every use. Labels also show in the Outline view |
| Send to Saturn | **F6**, or the upload button in the editor title. Saves, checks, then types `LOAD "COM:TBASTERM.B"` at the Saturn and serves the file |
| Send and Run | **Shift+F6**. Same, with `,R` |
| Stop | **Ctrl+F6** |
| Show Error Line | **Alt+F6**, or the warning button in the editor title. After a program stops on an error, presses F12 (readable edit screen) and types `ERROR`, so the Saturn shows the failing line again (Reference Manual p. 36) |
| Convert to Saturn Bitmap / Convert Saturn Bitmap to PNG | Right-click a `.png`, `.0` or `.1` file in the Explorer. A PNG becomes `.1` (32768 colours) or `.0` (256 colours, reduced if needed) for `GLOAD`; a Saturn bitmap becomes a PNG. Uses `tools/saturn_bitmap.py` |
| Convert to Characters (SETCHR DATA) | Right-click a `.png` whose sides are multiples of 8. Asks for 16 colours (text screen) or 256 (character screen) and the first pattern number, then writes `NAME_chr.B` with `SETCHR ... READ`, the hex `DATA` lines and `PALETTE` lines, ready to `#include` |
| Convert to Sprites (SPRITE$ DATA) | Right-click a `.png` whose sides are multiples of 16. Asks for the first sprite pattern (0-255) and the sprite palette (0 or 1), then writes `NAME_spr.B` with `SPRITE$(n)=READHEX$(256)`, 16 hex `DATA` lines per pattern and `PALETTE 10` lines, ready to `#include`. Show a pattern with `PUTSPRITE <sprite>,(X,Y),<pattern>` |
| Other commands | Run, Receive (pulls the Saturn's program back with `SAVE "COM:..."`), Type Text, Show Program as It Will Be Sent, Select Serial Port, Run Self-Test, and a COM: file server console |

All commands are under **GAME BASIC:** in the Command Palette.

## Getting started

### 1. Install the extension (one time)

1. In VS Code, open the Command Palette with **Cmd+Shift+P** (Ctrl+Shift+P on Windows and Linux).
2. Type `Install Extension from Location` and choose **Developer: Install Extension from Location...**
3. Pick this folder (`GAME_BASIC/vscode-game-basic`) and click **Select**.
4. If VS Code asks to reload, say yes. **GAME BASIC** now shows in the Extensions view (**Cmd+Shift+X**).

The extension is used straight from this folder, so edits here take effect after **Developer: Reload Window**. It finds the Python sender in `../tools` by itself.

If your VS Code doesn't have that command, link the folder in by hand, then quit and reopen VS Code:

```
ln -s ~/Documents/GitHub/SEGA/Saturn/GAME_BASIC/vscode-game-basic ~/.vscode/extensions/local.game-basic-0.1.0
```

Other ways in:
- **Packaged:** run `npm install` and then `npm run package` in this folder, then install the `.vsix` it makes with **Extensions: Install from VSIX...**. The package carries its own copy of the Python sender.
- **Development window:** run `code --extensionDevelopmentPath="$PWD" examples` in this folder, or open the folder and press **F5**.

### 2. Check the language mode

Open any `.B` file (upper or lower case), for example `examples/HELLO.B`. The bottom-right corner of the status bar should say **GAME BASIC**, and the keywords should be coloured. If it says *Plain Text*, click that word and choose **GAME BASIC**.

Files ending in `.b` (any case) and `.gbas` open as GAME BASIC. For `.bas` files, add `"files.associations": { "*.bas": "game-basic" }` to your settings.

### 3. Try it without a Saturn

1. In the Command Palette, run **GAME BASIC: Select Serial Port** and choose **Use the mock Saturn (no hardware)**.
2. `HELLO.B` has no line numbers, so turn on automatic numbering: open Settings (**Cmd+,**), search for `gameBasic.autoLineNumbers` and tick it. Grey numbers appear at the start of each line, showing the number each line will be sent with.
3. Press **F6** to send, or **Shift+F6** to send and run. On a Mac keyboard you may need **fn+F6**. You can also use the upload and play buttons at the top right of the editor.
4. Progress shows in a notification. The full log is in **View > Output**, under **GAME BASIC** in the drop-down.

### 4. Use the real Saturn

1. Install Python 3 and pyserial once: `python3 -m pip install pyserial`. On a Mac with Homebrew Python you may need a virtual environment (`python3 -m venv ~/.venvs/saturn && ~/.venvs/saturn/bin/pip install pyserial`), then set **gameBasic.pythonPath** to `~/.venvs/saturn/bin/python` (written out in full).
2. Plug in the USB-TTL adapter, run **GAME BASIC: Select Serial Port** again, and pick it (on a Mac, something like `/dev/cu.usbserial-...`).
3. Set **gameBasic.baudRate** to the rate set in GAME BASIC (9600 or 19200). To see or change the Saturn's rate, open GAME BASIC's system settings screen with **L+R+Z** on the pad (or **Q+E+D** on the Saturn keyboard), change **Baudrate**, then go to **Exit** and press **C**. A fresh install uses 9600.
4. With GAME BASIC at its prompt, press **F6**.

The status bar shows the port and baud rate in use. Click it to change the port.

### 5. Other things to know

- **Problems** are underlined as you type and listed in the Problems panel (**Cmd+Shift+M**). Errors stop a send. Warnings and notes don't.
- **Go to a jump target:** Cmd+click a line number after `GOTO`, `GOSUB` or `RESTORE`, or a `*LABEL`. Labels also show in the Outline view.
- **Completion:** start typing a keyword for suggestions.
- **Stop** a running program with **Ctrl+F6**.
- **More commands:** type `GAME BASIC` in the Command Palette for Run, Stop, Receive, Type Text, Show Program as It Will Be Sent, the COM: file server console, and the self-test.
- Point at a keyword, an `@NAME` constant or a `*LABEL` for help on it. Press **F12** on a label to jump to it, and **Shift+F12** to list the lines that use it.

## Settings

| Setting | Default | What it does |
|---|---|---|
| `gameBasic.port` | | e.g. `/dev/cu.usbserial-1410` (Mac), `/dev/ttyUSB0` (Linux), `COM3` (Windows) |
| `gameBasic.baudRate` | 9600 | 9600 or 19200, the same as GAME BASIC |
| `gameBasic.useMockSaturn` | false | Use the built-in pretend Saturn instead of the port |
| `gameBasic.autoLineNumbers` | false | Number unnumbered lines when sending |
| `gameBasic.lineNumberStart` / `lineNumberStep` | 10 / 10 | Automatic numbering |
| `gameBasic.labelLineInterval` | 0 | Round `*label` lines up to a multiple of this (BASTERM option; 0 is off) |
| `gameBasic.maxLineBytes` | 255 | Longest line, in Shift-JIS bytes. The real GAME BASIC limit isn't known yet |
| `gameBasic.keyDelayMs` | 30 | Pause between typed keystrokes |
| `gameBasic.serveDirectory` | the file's folder | Where the Saturn's own `COM:` file accesses go |
| `gameBasic.pythonPath` | auto | Python 3 that has pyserial |
| `gameBasic.senderScript` | auto | Path to `saturn_send.py` if you keep it elsewhere |
| `gameBasic.trace` | false | Hex dump of every byte in the **GAME BASIC** output panel |

The extension also sets Shift-JIS as the file encoding (with encoding guessing off) and CRLF line ends for GAME BASIC files, to match the files on the original CD. It turns off VS Code's "non-basic ASCII" Unicode warning for them, because Japanese text and half-width katakana are normal in these programs. A UTF-8 file with Japanese text will look garbled under Shift-JIS: reopen it with **Reopen with Encoding**, or save it as Shift-JIS. The sender reads UTF-8 or Shift-JIS either way.

## Where the keyword list comes from

[`src/keywords.js`](src/keywords.js) was first built from how the 67 sample programs in `../GAME_BASIC_CD` use each word (in statement position and never assigned to, or called like a function), then checked against the Reference Manual's reserved-word list (pp. 9–10) and keyword index (pp. 416–421). Every word now comes from the CD, the Tutorial Manual or the Reference Manual, 214 in all, including the operators `AND! OR! XOR! NOT!`. Standard BASIC words that GAME BASIC doesn't have (`WHILE`/`WEND`, `DEF FN`, `TRON` and so on) were removed, and so were `TIME` and `MSTR$`, which the sample games use as ordinary variables. See `../Documentation/Reference_Manual_findings.md` (section 9) for the details. The checker never flags an unknown word. After editing `src/keywords.js`, run `npm run grammar` to rebuild the grammar.

[`src/reference.js`](src/reference.js) holds the hover help: each command's syntax as the manual writes it, a one-line summary and the page it came from, plus the values of the `@` constants (Reference Manual pp. 11–14) and the MML commands (section 2.6, pp. 318–354). Every command and function in the manual has an entry; a word without one (such as an operator) still gets a plain hover.

The CD samples also serve as a test: `npm test` runs the checker over all of them when they have been extracted into `../GAME_BASIC_CD` or `../GAME_BASIC_CD/extracted` (`tools/gbcd_extract.py`). They come up with no errors. The only warnings are two strings with no closing quote. There are also notes for out-of-order line numbers, and for the unnumbered `LOAD "COM:..."` lines and comments that the original developers left in some files.

## Development

`npm install`, then `npm test` runs the checker tests (plus the CD samples, as above), the grammar tests (with the same TextMate engine VS Code uses), and a smoke test that loads the extension against a stub VS Code API and sends a program to the mock Saturn through the real Python sender.
