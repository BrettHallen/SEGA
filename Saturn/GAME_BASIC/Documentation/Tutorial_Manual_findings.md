# GAME BASIC Tutorial Manual: notes for the BASTERM replacement

Nov 18, 2026 · @Brett

Notes from the Japanese *GAME BASIC for SEGASATURN Tutorial Manual* scans in `Documentation/`, checked against `BASTERM/BASTERM_serial_protocol.md`, the VS Code extension and `tools/saturn_link`. The manual is written for users, so it has no wire-level protocol detail, but it settles several behaviour questions and gives the Saturn-side messages.

## Pages covered

Scans are named by sheet number. Book page = scan number − 6 from scan 151 on.

| Scans | Book pages | Content |
|---|---|---|
| 1–7 | Cover, foreword, contents | Contents list for the whole book |
| 9–11 | 3–5 | Package contents, pad and keyboard hookup, boot screen |
| 151–178 | 145, 147–172 | **Chapter 3: BASTERM**, complete |
| 179–182 | 173–176 | Index |
| 183–184 | — | Back matter, back cover |

Scans 8, 18, 150 and 152 are very small files, most likely blank placeholder pages; I did not open them. **Still to scan for this work:** book pp. 6–11 (input devices, "パソコンとの接続" PC connection on p. 9, extension cable p. 10, comm port p. 11), pp. 17 and 23–30 (error messages, `LOAD`/`SAVE`/`FILES`, `CD:`/`BRAM:`/`CRAM:` devices on p. 29–30), and p. 49 (`KLOAD`).

The foreword (scan 3) says the box also held a separate **Reference Manual** (リファレンスマニュアル) with the full command details. That is the book most likely to document `COM:`, file I/O commands and the error-message list.

## New information

**Saturn screen output (p. 5, 152).** Useful for the mock Saturn and for reading the terminal echo.
- Boot banner: `GAME BASIC for SEGASATURN ver 1.00` / `(C)1998 ASCII Corp./Bits Laboratory` / `/ESP inc.` / `Ready.`
- After a successful send the Saturn shows `LOAD "COM:TBASTERM.B"`, then `Line 120` (the last line number loaded), then `Ready.`. The mock currently prints `Ok`.
- A typo such as `1022 NAXT` gives `Syntax Error` when run (p. 155).

**Fixed-point hex literals (p. 155).** The sample `P_SHOWER.B` uses `&H0.0E` and `&H0.01`. The CD samples use the same form (`&H0.001`, `&H0.0024` and others). The grammar's hex rule `&H[0-9A-F]+` stops at the dot, so these highlight in two pieces.

**Multi-value assignment (p. 155).** `OBJ(I,XP)=0,0,0` and `OBJ(I,XR)=RND(1024)/1024,…` set several consecutive object fields in one statement.

**Connect, and files left open (p. 162–163).** BASTERM's Connect command must be on for programs that use the PC as a file server (`fopen`, `fread`, `fwrite`, `fclose` on `COM:`). On disconnect BASTERM closes any files the Saturn still has open, and later access from the Saturn gives an error, so programs should close files first. Send and Receive connect automatically if needed and disconnect afterwards. The note says this monitoring costs PC CPU time.

**Errors may only show on the Saturn (p. 163–164).** If a transfer fails, or is aborted from the Saturn keyboard, BASTERM may show no error; the manual says always check the Saturn's own message. A replacement should read the Saturn's echoed text after a send rather than trust the protocol result alone.

**Run and Stop (p. 164).** Run sends `RUN`, stopping the program first if it is running. Stop keeps sending the stop key until the program stops. Both commands show the running state, which the manual calls approximate ("indeterminate when unknown").

**Key send mode (p. 156, 165).** Ctrl+K starts it, Alt+K or a click ends it, and no other command works while it is on. F10 and Ctrl+Break cannot be sent. During heavy polygon drawing keys can be dropped or garbled; pressing **F12** turns polygon display off, after which `CONT` or direct commands do not bring the polygons back. It works only with GAME BASIC, not as a keyboard for other Saturn software.

**Baud rate (p. 166).** Must match the Saturn setting. 19200 is faster but less tolerant of CPU load and noise; drop to 9600 on errors. Default 9600, default port COM1. Port settings can only change while disconnected.

**Connection failure (p. 151).** Message: "セガサターンとの接続に失敗しました。接続を確認してください。" (Connection to the Saturn failed. Check the connection.) The progress dialog says "通信ネゴシエーション中" (negotiating) while the link comes up. Advice: check the port, the connector, and keep electrical appliances away from the cable.

**Diff send rules (p. 169–171).**
- Only changed lines go, with `LOAD …,M`.
- A full `LOAD` is used after opening a file and after a cancelled send.
- If the diff would be too large it falls back to a full send.
- Shift+Send forces a full send.
- BASTERM can't see edits made on the Saturn, so diffs can go out of step.
- "Always issue LOAD,M" overrides the automatic choice.
- Putting a fixed line number at the start of data sections keeps later numbering stable and diffs small.

**Send settings dialog (p. 169).** Run after send; turn on key send after Run; diff send; add line numbers (start, step, and the `*` label interval); show errors after send (on); stop on errors (on); keep `ERRORLOG.TXT`; keep `TBASTERM.B`; always `LOAD,M`. There is also a temp-file name setting: it must be an 8.3 name ending `.B`, because it becomes the `LOAD`/`SAVE` argument.

**Filter (p. 166–168).** MS-DOS console programs only (`.com`, `.exe`, `.bat`). Defaults: input `IBASTERM.B`, output `OBASTERM.B`, working folder `C:\WINDOWS\TEMP\`. Options to add stderr (on) or stdout (off) to the error log, delete the temp files (on), and show the console (on). The example use is a structured GAME BASIC to line-numbered BASIC converter. Send order: save, filter, number lines, check, diff, `LOAD` or `LOAD,M`.

**File names (p. 158).** BASTERM saves `.b` and lists `*.b;*.bas`. Names should be 8 half-width characters: longer or full-width names can be saved on the PC, but the Saturn can then reach them only through BASTERM's own send and receive.

**Current directory (p. 165).** Settings > Change current directory sets where Saturn file access goes, for example `C:\`. That matches the extension's `gameBasic.serveDirectory`.

## Confirms earlier analysis

- `LOAD "COM:TBASTERM.B"` is what BASTERM types (photo on p. 152).
- Receive replaces the editor contents and keeps the file name (p. 163).
- Line numbering: a numbered line resets the counter, `*` lines are rounded up to the label interval, and blank lines become `'` when numbering or are dropped otherwise (p. 170–171). `preprocess.py` already does this.
- Checks before sending: missing, duplicate or invalid line number, and characters per line (p. 171). The manual gives no figure for the line limit.
- `#include "FILE"`, written without a line number, is a BASTERM-only directive (p. 172).
- `LOAD …,M` merges without `NEW` (p. 171).
- 9600 or 19200 baud, default 9600 (p. 166).
- BASTERM shortcuts: Send Ctrl+P, Receive Ctrl+G, Run Ctrl+R, Stop Ctrl+B, Key send Ctrl+K.

## Not in these pages

- No wire-level protocol: no byte formats, handshake or block sizes.
- No `COM:` syntax beyond `LOAD "COM:…"`, and no list of error messages yet (index points to p. 17).
- Status codes 1 and 2, and the difference between the two STOP modifiers, are still open.

## Suggested follow-ups (not done)

1. Make the mock print `Line N` and `Ready.` after a load, and the boot banner.
2. Let the hex rule take a fraction: `&H[0-9A-F]+(\.[0-9A-F]+)?`.
3. After a send, read the Saturn's echoed text and report errors seen there.
4. Later, if wanted: diff send with the rules above, and a live key-send mode with F12 as the polygon-off key.
