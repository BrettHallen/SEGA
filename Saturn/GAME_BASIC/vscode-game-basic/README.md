# GAME BASIC for VS Code

Edit, check and send GAME BASIC for SEGASATURN programs from VS Code on macOS, Linux or Windows, over a 5 V USB-TTL serial adapter. It replaces the editing and Send/Run/Receive side of BASTERM.

The extension does the editing side itself. Anything that touches the serial port is done by the Python sender in [`../tools`](../tools), which the extension runs for you.

## What it does

| Feature | Notes |
|---|---|
| Highlighting | Line numbers, keywords, built-in functions, strings, `'` and `REM` comments, `*labels`, `@ATR`-style object fields, `&H` hex and `&B` binary numbers (with fixed-point fractions), BASTERM's `#include` |
| Live checks | Unnumbered direct commands such as `LOAD"COM:DDD"` and unnumbered comments are shown as notes and left out when sending. Otherwise, the same checks BASTERM makes before sending (missing, duplicate or too-big line numbers, over-long lines), plus characters Shift-JIS can't carry, missing `#include` files, unbalanced brackets, unclosed strings, `GOTO`/`GOSUB`/`RESTORE` to a line or `*label` that doesn't exist, and `IF` without `THEN` |
| Automatic line numbers | Optional, BASTERM style: unnumbered lines get numbers when sent, a numbered line resets the counter, and inlay hints show the number each line will get |
| Hover and completion help | Hover a keyword for its syntax and manual page where known (`src/reference.js`), or an `@NAME` constant such as `@PAD_START` for its value |
| Go to definition | On a `GOTO 100` target or a `*LABEL`. Labels also show in the Outline view |
| Send to Saturn | **F6**, or the upload button in the editor title. Saves, checks, then types `LOAD "COM:TBASTERM.B"` at the Saturn and serves the file |
| Send and Run | **Shift+F6**. Same, with `,R` |
| Stop | **Ctrl+F6** |
| Other commands | Run, Receive (pulls the Saturn's program back with `SAVE "COM:..."`), Type Text, Show Program as It Will Be Sent, Select Serial Port, Run Self-Test, and a COM: file server console |

All commands are under **GAME BASIC:** in the Command Palette.

## Setup

1. Install Python 3 and pyserial: `python3 -m pip install pyserial`. On a Mac with Homebrew Python you may need a virtual environment (`python3 -m venv ~/.venvs/saturn && ~/.venvs/saturn/bin/pip install pyserial`), then set **gameBasic.pythonPath** to `~/.venvs/saturn/bin/python` (written out in full).
2. Install the extension, using either way:
   - **Try it from source:** run `code --extensionDevelopmentPath="$PWD" examples` in this folder (or open the folder in VS Code and press **F5**, choosing *VS Code Extension Development*). A second VS Code window opens on `examples/`. Run **GAME BASIC: Select Serial Port** there and pick *Use the mock Saturn* to try everything without hardware, and turn on **gameBasic.autoLineNumbers** for `HELLO.B`.
   - **Install it:** run `npm install` and then `npm run package` in this folder, and install the `.vsix` it makes with **Extensions: Install from VSIX...**. The package carries its own copy of the Python sender.
3. Plug in the adapter, run **GAME BASIC: Select Serial Port**, and set **gameBasic.baudRate** to the rate set in GAME BASIC (9600 or 19200). To see or change the Saturn's rate, open GAME BASIC's system settings screen with **L+R+Z** on the pad (or **Q+E+D** on the Saturn keyboard), change **Baudrate**, then go to **Exit** and press **C**. A fresh install uses 9600.
4. Open a `.B` file and press **F6**.

Files ending in `.b` (any case) and `.gbas` open as GAME BASIC. For `.bas` files, add `"files.associations": { "*.bas": "game-basic" }` to your settings.

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

[`src/keywords.js`](src/keywords.js) was first built from how the 67 sample programs in `../GAME_BASIC_CD` use each word (in statement position and never assigned to, or called like a function), then checked against the Reference Manual's reserved-word list (pp. 9–10) and keyword index (pp. 416–421). Every word now comes from the CD, the Tutorial Manual or the Reference Manual, 214 in all, including the operators `AND! OR! XOR! NOT!`. Standard BASIC words that GAME BASIC doesn't have (`WHILE`/`WEND`, `DEF FN`, `TRON` and so on) were removed, and so were `TIME` and `MSTR$`, which the sample games use as ordinary variables. See `../Documentation/Tutorial_Manual_findings.md` for the details. The checker never flags an unknown word. After editing `src/keywords.js`, run `npm run grammar` to rebuild the grammar.

[`src/reference.js`](src/reference.js) holds the hover help: each command's syntax as the manual writes it, a one-line summary and the page it came from, plus the values of the `@` constants (Reference Manual pp. 11–14). It is meant to grow as more Reference Manual pages are scanned; a command without an entry still gets a plain hover.

The CD samples also serve as a test: `npm test` runs the checker over all of them when `../GAME_BASIC_CD` exists. They come up with no errors. The only warnings are two strings with no closing quote. There are also notes for out-of-order line numbers, and for the unnumbered `LOAD "COM:..."` lines and comments that the original developers left in some files.

## Development

`npm install`, then `npm test` runs the checker tests (plus the CD samples, as above), the grammar tests (with the same TextMate engine VS Code uses), and a smoke test that loads the extension against a stub VS Code API and sends a program to the mock Saturn through the real Python sender.
