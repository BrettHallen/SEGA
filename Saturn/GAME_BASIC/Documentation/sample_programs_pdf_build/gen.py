import os, sys, re
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import render, progs, manual_listings as ML
from common import load, CD

DXF = os.environ.get('DXFDIR', '/mnt/user-data/uploads/Saturn/GAME_BASIC/DXFCONV')
def path_of(p):
    if p['src'] == 'dxf':
        return os.path.join(DXF, 'SAMPLE', p['f']) if p['f'] != 'HEADBAS.B' else os.path.join(DXF, 'HEADBAS.B')
    return os.path.join(CD, p['f'])

def slug(s):
    s = s.lower()
    s = re.sub(r'[^\w\- ]', '', s)
    return re.sub(r' ', '-', s.strip())

CH_NUM = {'games': 3, 'graphics': 4, 'sound': 5, 'tools': 6, 'manuals': 7, 'dxfconv': 8}
CH_TITLE = {k: t for k, t, _ in progs.CHAPTERS}
CH_TITLE['manuals'] = 'Listings from the manuals'
CH_INTRO = {k: i for k, _, i in progs.CHAPTERS}

out = []
w = out.append
total_shown = 0

w('# GAME BASIC for SEGA SATURN: Sample Programs\n')
w('This book collects every sample program that comes with GAME BASIC for SEGA SATURN (ASCII Corp., Bits Laboratory and ESP inc., 1998) in one place, in English. It is meant for learning how to write your own games: each program has a short description of what it does and which techniques it shows, followed by its listing.\n')
w('It covers the 67 programs on the GAME BASIC CD, the three sample programs that come with the DXFCONV converter on the Windows 95 tools CD, and the program listings printed in the Tutorial Manual and the Reference Manual.\n')
w('> **About the translation.** The programs\' comments and on-screen text were written in Japanese, mostly in half-width katakana. Here they are translated into English inside the listings, so a listing is no longer byte-for-byte the file on the CD: English text is a different length, so some screens will not line up as they did, and the Japanese font codes some programs print are gone. The line numbers and all of the code are exactly as on the CD. To run a program, load the original from the CD.\n')
w('---\n')
w('## Contents\n')
toc = [('1. How to read this book', '1-how-to-read-this-book'), ('2. A path for learning to write a game', '2-a-path-for-learning-to-write-a-game')]
for k in ['games', 'graphics', 'sound', 'tools', 'manuals', 'dxfconv']:
    t = f'{CH_NUM[k]}. {CH_TITLE[k]}'
    toc.append((t, slug(t)))
for i, (t, s) in enumerate(toc, 1):
    w(f'{i}. [{t.split(". ",1)[1]}](#{s})')
w('\n---\n')

# ------------------------------------------------------------ 1
w('## 1. How to read this book\n')
w('### Running a sample\n')
w('On the Saturn, start the launcher (it starts by itself when GAME BASIC boots, or press Shift+F1), pick a file and press A. Or type the name yourself:\n')
w('```\nLOAD "CD:G_MOBIL.B",R\n```\n')
w('`FILES "CD:"` lists the files on the CD. A few programs need a particular controller (the Virtua Gun, Shuttle Mouse, Racing Controller, Mission Stick or Multi-Terminal 6); the descriptions say so.\n')
w('To read a program on a PC, the CD\'s files are in `GAME_BASIC/GAME_BASIC_CD/GAME_BASIC_files.zip` in this project. `.B` files are plain text in the Shift-JIS character set, with CR+LF line ends, so any editor that understands Shift-JIS opens them. The VS Code extension in `vscode-game-basic` highlights them.\n')
w('### How the listings are shown\n')
w('- **Line numbers** are the program\'s own. Many samples number from 1000 up; jumps in the numbers are as on the CD.')
w('- **Comments and strings** that were in Japanese are translated in place. Comments begin with `\'` or `REM`. Strings are the text between `"` marks. English kept from the original is unchanged.')
w('- **Long runs of `DATA`** are left out. Most of the bytes on the CD are data: polygon models, textures, music, FM tones. When six or more `DATA` lines come together, the listing shows the first three and the last one, and puts a line like this in place of the rest:\n')
w("  ```\n        ' ... 2,920 DATA lines not shown (lines 5000-7930) ...\n  ```\n")
w('  These marker lines are not part of the program. Labels (`*NAME`) inside a data block are always kept, so you can see where each `RESTORE` points. The heading of each program gives the full size and how many lines are shown.')
w('- **Variants.** Where a program is a small change to another one (for example `G_JUMP_A.B`, which is `G_JUMP.B` for the analogue pad), the listing shows only the differences, as a "diff": lines starting `-` are in the original, lines starting `+` replace them, and the `@@` lines mark where each change is. Line numbers are left off in a diff, because the variants are renumbered.')
w('- **The first line.** Several samples start with an unnumbered line such as `LOAD"COM:D"`. It was left over from sending the program from a PC, and `LOAD` ignores a line with no number.\n')
w('### Patterns you will see again and again\n')
w('The samples were written by several teams, but they share a few habits that are worth knowing before you read them:\n')
w('- **"Object Item Number" constants.** Most 3D programs begin by naming the items of the `OBJ` array: `TYPE = 0: FLAG = 1`, `XP = 4` (position), `XR = 8` (rotation), `XS = 12` (scale), `ATR = 16`, `POLYGON = 17`, `PARENT = 20`, `XV = 24` (speed), `XRV = 36` (rotation speed) and so on. Then `OBJ(1,XP) = x,y,z` sets three items at once. GAME BASIC also has the built-in names `@XP`, `@TYPE` and so on, which later programs use instead.')
w('- **Labels instead of line numbers.** `GOSUB *SETUP` and `GOTO *LOOP` jump to labels, so the programs can be renumbered freely.')
w('- **A main loop of subroutine calls.** `*MAIN: GOSUB *MOVE: GOSUB *CHECK: ... GOTO *MAIN`. Each subroutine does one job.')
w('- **Timer interrupts.** `ON INTERVAL (0) GOSUB *CLOCK` and `INTERVAL (0) ON,1` run a subroutine every frame (1/60 s), used for clocks, fades and reading pads while the main program does something else.')
w('- **Pad bits.** `P = PAD(0,1)` reads pad 1 as a bit mask; `IF P AND @PAD_A THEN ...` tests one button.')
w('- **Fades.** `COLOROFS (FADE,FADE,FADE)` with a value stepping between -255 and 0 fades the screen out and in.')
w('- **Housekeeping at the start.** `SKCLOSE` closes the software keyboard, `KLOAD ON` loads the kanji font, `CLEAR ,1360` reserves the file buffer that `TARG` needs, `PLAYINIT` sets up sound.')
w('- **Passing values between programs.** The music menus `POKE` a few bytes of user memory before running another program with `LOAD ... ,R` and `PEEK` them when control comes back.\n')

# ------------------------------------------------------------ 2
w('## 2. A path for learning to write a game\n')
w('You do not need to read the book in order. If your aim is to write a game, this order builds up one idea at a time:\n')
w('| Step | Read | Why |')
w('|---|---|---|')
chmap = {'chapter 7': 7, 'chapter 4': 4, 'chapter 2': 3, 'chapter 3': 4}
for i, (what, ch, why) in enumerate(progs.LEARNING_PATH, 1):
    c = {'Tutorial Manual examples': 7}.get(what)
    if c is None:
        c = {'chapter 3': 4, 'chapter 2': 3, 'chapter 4': 5}[ch]
    w(f'| {i} | {what} (chapter {c}) | {why} |')
w('')
w('After that, the graphics demos in chapter 4 are a toolbox: each shows one feature in a few dozen lines. The tool programs in chapter 6 show how to build bigger interfaces (windows, menus, mouse input), and chapter 5 has music you can reuse, notably the Lunar version A tunes, which were laid out to be used as game BGM.\n')
w('The English User Guide (`GAME_BASIC_for_SEGA_SATURN_User_Guide_EN`) explains the commands these programs use, and the translated Tutorial and Reference Manuals give the full detail.\n')

# ------------------------------------------------------------ program chapters
def entry(p):
    global total_shown
    f = p['f']; src = path_of(p)
    raw = open(src, 'rb').read()
    L = load(src)
    title = f"{f}: {p['title']}"
    w(f'### {title}\n')
    srcdesc = 'GAME BASIC CD' if p['src'] == 'cd' else 'Windows 95 tools CD, `DXFCONV' + ('/SAMPLE' if f != 'HEADBAS.B' else '') + '` folder'
    meta = f"**File:** `{f}` on the {srcdesc}, {len(raw):,} bytes, {len(L):,} lines."
    if p['variant_of']:
        meta += f" Shown as the differences from `{p['variant_of']}`."
    elif p['same_code_as']:
        pass
    else:
        lst = render.listing(src)
        shown = sum(1 for x in lst if not x.lstrip().startswith("' ... "))
        if shown < len(L):
            meta += f" {shown:,} lines shown."
    if p['src'] == 'cd' and not f.startswith('S_T_NAME') and f not in ('BOU_SCD.B', 'BOU_TCD.B', 'BOU_MCD.B', 'K_MAIN.B', 'O_MAIN.B', 'O_SET.B', 'H_MAIN.B', 'H_SET.B'):
        meta += f" Run it with `LOAD \"CD:{f}\",R`."
    w(meta + '\n')
    w(p['what'] + '\n')
    if p['tech']:
        w('**Techniques:**\n')
        for t in p['tech']:
            w(f'- {t}')
        w('')
    if p['related']:
        w(f"**Files it uses:** {p['related']}\n")
    if p['note']:
        w(f"> {p['note']}\n")
    if p['variant_of']:
        base = os.path.join(CD, p['variant_of'])
        d = render.vdiff(base, src)
        w('```diff')
        for x in d: w(x.rstrip())
        w('```\n')
        total_shown += len(d)
    elif p['same_code_as']:
        d = render.vdiff(os.path.join(CD, p['same_code_as']), src)
        changed = [x for x in d if x[:1] in '+-' and not x.startswith(('+++', '---'))]
        if not changed:
            w(f"The code is line for line the same as `{p['same_code_as']}`; only the FM parameters in the `DATA` differ, so the listing is not repeated.\n")
        else:
            w('```diff'); [w(x) for x in d]; w('```\n')
    else:
        lst = render.listing(src)
        w('```')
        for x in lst: w(x)
        w('```\n')
        total_shown += len(lst)

for k in ['games', 'graphics', 'sound', 'tools']:
    n = CH_NUM[k]
    w(f'## {n}. {CH_TITLE[k]}\n')
    w(CH_INTRO[k] + '\n')
    ps = [p for p in progs.P if p['ch'] == k]
    w('| Program | What it is |')
    w('|---|---|')
    for p in ps:
        w(f"| [`{p['f']}`](#{slug(p['f'] + ': ' + p['title'])}) | {p['title']} |")
    w('')
    for p in ps:
        entry(p)

# ------------------------------------------------------------ manuals
w(f"## {CH_NUM['manuals']}. Listings from the manuals\n")
w('The Tutorial Manual teaches with short programs typed in by hand, and the Reference Manual gives examples for many commands. These are the complete programs from the two books (the English translations in `Documentation`). Excerpts of CD programs that the Tutorial Manual prints (from `P_PFONT.B`, `P_CLOCK.B`, `P_CAME2.B`, `G_MOBIL.B` and `P_SHOWER.B`) are not repeated here: see those programs in chapters 3 and 4. Lines that are only `:` stand for parts the manual leaves out.\n')
w('### From the Tutorial Manual\n')
for title, where, what, code in ML.TM:
    w(f'#### {title}\n')
    w(f'*{where}.* {what}\n')
    w('```'); w(code); w('```\n')
w('### From the Reference Manual\n')
for title, where, what, code in ML.RM:
    w(f'#### {title}\n')
    w(f'*{where}.* {what}\n')
    w('```'); w(code); w('```\n')

# ------------------------------------------------------------ dxf
k = 'dxfconv'
w(f'## {CH_NUM[k]}. {CH_TITLE[k]}\n')
w(CH_INTRO[k] + '\n')
for p in [p for p in progs.P if p['ch'] == k]:
    entry(p)

md = '\n'.join(out) + '\n'
open(sys.argv[1], 'w', encoding='utf-8').write(md)
print('lines shown', total_shown, 'missing translations', len(render.missing))
for m in list(render.missing)[:20]: print('MISSING', repr(m))
nonascii = set(ch for ch in md if ord(ch) > 127)
print('non-ascii chars:', ''.join(sorted(nonascii)))
