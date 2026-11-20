#!/usr/bin/env python3
"""Commented SH-2 disassembly of the GAME BASIC for SEGA SATURN interpreter.

    python3 gbcd_disasm.py GAME_BASIC.iso -o GAME_BASIC_main.s
    python3 gbcd_disasm.py main.bin -o GAME_BASIC_main.s

Takes the CD image (it unpacks the boot file "0" with gbcd_extract.py) or an
already unpacked main.bin, and writes an annotated listing:

  * code is found by following control flow from the entry point, the keyword
    token table, the symbol file and every call target, so literal pools,
    strings and tables between functions print as data, not as bogus code;
  * labels come from gbcd_symbols.txt first, then the token table
    (stmt_<KEYWORD> / fn_<KEYWORD>), then sub_/loc_/dat_/str_ by use;
  * every PC-relative literal shows its value, the name it points at and, for
    strings, the text; calls through registers show their target;
  * the keyword token table, the @ sub-keyword table and the error message
    table print as decoded tables.

Standard library only. The listing is derived from copyrighted (C)1998 ASCII
Corp./Bits Laboratory/ESP inc. code: write it outside any public repository.
"""
import argparse
import hashlib
import os
import re
import struct
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import gbcd_extract  # noqa: E402
import sh2  # noqa: E402

BASE = gbcd_extract.LOAD_ADDR


def load_image(path):
    data = open(path, 'rb').read()
    if len(data) > 17 * 2048 and data[16 * 2048 + 1:16 * 2048 + 6] == b'CD001':
        for name, lba, size in gbcd_extract.iso_root_files(data):
            if name == '0':
                return gbcd_extract.unpack_boot(data[lba * 2048:lba * 2048 + size])
        raise SystemExit('No boot file "0" in the ISO root')
    return data


def load_symbols(path):
    names, heads, notes, tables, sections = {}, {}, {}, [], {}
    for raw in open(path, encoding='utf-8'):
        line = raw.rstrip('\n')
        if not line.strip() or line.lstrip().startswith('#'):
            continue
        if line.startswith('.table'):
            _, a, kind, n = line.split()
            tables.append((int(a, 16), kind, int(n)))
            continue
        if line.startswith('.section'):
            _, a, text = line.split(None, 2)
            sections[int(a, 16)] = text
            continue
        body, _, comment = line.partition(';')
        a, name = body.split()[:2]
        a = int(a, 16)
        comment = comment.strip()
        if name == '-':
            notes.setdefault(a, []).append(comment)
        else:
            names[a] = name
            if comment:
                heads[a] = comment
    return names, heads, notes, tables, sections


class Image:
    def __init__(self, data):
        self.d = data
        self.end = BASE + len(data)

    def ok(self, a, n=1):
        return BASE <= a and a + n <= self.end

    def u16(self, a):
        return struct.unpack_from('>H', self.d, a - BASE)[0]

    def u32(self, a):
        return struct.unpack_from('>I', self.d, a - BASE)[0]

    def cstr(self, a, minlen=2, limit=512):
        """Text at a if it is a printable (ASCII or Shift-JIS) NUL-terminated string."""
        if not self.ok(a):
            return None
        o = a - BASE
        e = self.d.find(b'\0', o, o + limit)
        if e < 0 or e - o < minlen:
            return None
        raw = self.d[o:e]
        try:
            s = raw.decode('cp932')
        except UnicodeDecodeError:
            return None
        if sum(c < ' ' and c not in '\t\n\r\x1b' for c in s) * 5 > len(s) or '\x7f' in s:
            return None
        if sum((ch.isalnum() or ch == ' ') and not '\uff61' <= ch <= '\uff9f' for ch in s) * 2 < len(s):
            return None
        kana = any('\uff61' <= ch <= '\uff9f' for ch in s)
        if kana and any(c < ' ' for c in s):
            return None
        if kana and sum(ch.isascii() and ch.isalpha() for ch in s) < 4:
            return None
        return s


def quote(s, n=60):
    s = s.replace('\\', '\\\\').replace('"', '\\"').replace('\n', '\\n').replace('\r', '\\r') \
         .replace('\t', '\\t').replace('\x1b', '\\e')
    s = re.sub(r'[\x00-\x1f]', lambda m: f'\\x{ord(m.group()):02X}', s)
    return '"' + (s if len(s) <= n else s[:n] + '...') + '"'


def switch_table(img, pc, bound, code_end):
    """Entries of a 'mova T,r0 / mov.w @(r0,rX),rX / add rX,r0 / jmp @r0' table at T."""
    t = ((pc + 4) & ~3) + (img.u16(pc) & 0xFF) * 4
    out, i = [], 0
    limit = bound if bound else 256
    while i < limit and img.ok(t + 2 * i, 2):
        v = img.u16(t + 2 * i)
        tgt = t + (v - 0x10000 if v & 0x8000 else v)
        if not (BASE <= tgt < code_end) or tgt & 1:
            break
        if not bound and tgt < t + 2 * (i + 1):
            break
        out.append(tgt)
        i += 1
    return t, out


def trace(img, seeds, code_end, jtables=None):
    """Follow control flow. Returns (code addresses, calls, branches, lits, movas)."""
    code, calls, branches, lits, movas = set(), set(), set(), {}, set()
    jtables = {} if jtables is None else jtables
    todo = list(seeds)
    in_range = lambda a: BASE <= a < code_end and not a & 1
    while todo:
        pc = todo.pop()
        regs, bound = {}, None
        while in_range(pc) and pc not in code and pc not in lits:
            mn, ops, info = sh2.decode(img.u16(pc), pc)
            if mn == '.word':
                break
            code.add(pc)
            if 'lit' in info:
                lits[info['lit']] = info['size']
                n = (img.u16(pc) >> 8) & 0xF
                if img.ok(info['lit'], info['size']):
                    regs[n] = img.u32(info['lit']) if info['size'] == 4 else None
            elif mn == 'mov' and ops.startswith('#'):
                regs[int(ops.split(',r')[1])] = int(ops[1:].split(',')[0])
            elif mn in ('cmp/hi', 'cmp/hs', 'cmp/gt', 'cmp/ge') and ops.startswith('r'):
                m = int(ops.split(',')[0][1:])
                if isinstance(regs.get(m), int) and 0 <= regs[m] < 512:
                    bound = regs[m] + (1 if mn in ('cmp/hi', 'cmp/gt') else 0)
            elif mn == 'cmp/eq':
                pass
            elif mn == 'mov' and ops.startswith('r'):
                m, n = (int(x[1:]) for x in ops.split(','))
                regs[n] = regs.get(m)
            else:
                dst = re.search(r',r(\d+)$', ops)
                if dst:
                    regs.pop(int(dst.group(1)), None)
            if 'mova' in info:
                movas.add(info['mova'])
                seq = [sh2.decode(img.u16(pc + 2 * k), pc + 2 * k)[:2] for k in range(1, 7)] \
                    if img.ok(pc, 14) else []
                if any(m == 'mov.w' and o.startswith('@(r0,') for m, o in seq) and \
                        any(m == 'add' and o.endswith(',r0') and o.startswith('r') for m, o in seq):
                    t, targets = switch_table(img, pc, bound, code_end)
                    if targets:
                        jtables[t] = targets
                        lits[t] = 2 * len(targets)
                        branches.update(targets)
                        todo.extend(targets)
            for k in ('branch', 'call'):
                if k in info and in_range(info[k]):
                    (calls if k == 'call' else branches).add(info[k])
                    todo.append(info[k])
            if 'jsr' in info:
                t = regs.get(info['jsr'])
                if t is not None and in_range(t):
                    (branches if info.get('end') else calls).add(t)
                    todo.append(t)
            if mn in ('jsr', 'bsr', 'bsrf'):
                for r in range(8):
                    regs.pop(r, None)
            if info.get('delay'):
                pc += 2
                if in_range(pc) and pc not in lits:
                    w = img.u16(pc)
                    dmn, dops, dinfo = sh2.decode(w, pc)
                    if dmn != '.word':
                        code.add(pc)
                        if 'lit' in dinfo:
                            lits[dinfo['lit']] = dinfo['size']
                        if 'mova' in dinfo:
                            movas.add(dinfo['mova'])
            if info.get('end'):
                break
            pc += 2
    return code, calls, branches, lits, movas


def looks_like_function(img, a, code_end, lits, code):
    """Straight-line decode from a reaches rts/bra/jmp with no bad opcode or pool."""
    pc, n = a, 0
    while pc < code_end and n < 400:
        if pc in lits or (pc in code and n):
            return n >= 3
        mn, ops, info = sh2.decode(img.u16(pc), pc)
        if mn in ('.word', 'sleep', 'rte', 'trapa') or ops.startswith('#') and mn == 'mov.l':
            return False
        if 'lit' in info and not (BASE <= info['lit'] < code_end and info['lit'] > pc):
            return False
        if info.get('end'):
            return n >= 1
        pc += 2
        n += 1
    return False


def disassemble(img, symfile, source_name):
    names, heads, notes, tables, sections = load_symbols(symfile)

    # Table entries and the code they point at.
    table_at = {a: (kind, n) for a, kind, n in tables}
    seeds = {BASE} | {a for a in names if img.ok(a, 2) and not a & 1}
    kw = {}
    tok = next((t for t in tables if t[1] == 'tokens'), None)
    if tok:
        default_stmt = None
        rows = [struct.unpack_from('>4I', img.d, tok[0] - BASE + 16 * i) for i in range(tok[2])]
        stmt_count = {}
        for s, f, nm, fl in rows:
            stmt_count[s] = stmt_count.get(s, 0) + 1
        default_stmt = max(stmt_count, key=stmt_count.get)
        names.setdefault(default_stmt, 'stmt_not_a_statement')
        for i, (s, f, nm, fl) in enumerate(rows):
            word = img.cstr(nm, 1) or f'tok{i:03X}'
            ident = re.sub(r'\W', lambda m: {'$': 'S', '#': 'N'}.get(m.group(), '_'), word) or f'tok{i:03X}'
            kw[i] = word
            if nm:
                names.setdefault(nm, f'kw_{ident}')
            if s and s != default_stmt:
                names.setdefault(s, f'stmt_{ident}')
                seeds.add(s)
            if f:
                names.setdefault(f, f'fn_{ident}')
                seeds.add(f)
    for a, kind, n in tables:
        if kind == 'subkw':
            for i in range(n):
                p = img.u32(a + 8 * i)
                s = img.cstr(p, 1)
                if s:
                    names.setdefault(p, 'at_' + re.sub(r'\W', '_', s))
        if kind == 'errptrs':
            for i in range(n):
                p = img.u32(a + 4 * i)
                if p not in names:
                    names[p] = f'msg_err_{i:02d}'

    code_end = min([a for a in sections if a > BASE and 'variables' in sections[a].lower()] or [img.end])
    jtables = {}
    code, calls, branches, lits, movas = trace(img, seeds, code_end, jtables)

    def in_lit(x):
        return any(x - k in lits and lits[x - k] > k for k in range(0, 64, 2))
    # Second pass: unreached function prologues (called through tables we do not decode).
    for _ in range(8):
        extra = set()
        a = BASE
        while a < code_end:
            prev = a - 2
            if a not in code and not in_lit(a) and img.u16(a) not in (0x0000, 0x0009) and \
                    (prev in code or in_lit(prev) or img.u16(prev) in (0x0009, 0x0000)) and \
                    not img.cstr(a, 4) and looks_like_function(img, a, code_end, lits, code):
                extra.add(a)
            a += 2
        if not extra:
            break
        c2, k2, b2, l2, m2 = trace(img, extra, code_end, jtables)
        code |= c2; calls |= k2 | extra; branches |= b2; lits.update(l2); movas |= m2

    # Literal values that point into the image get labels too.
    refs = set(movas)
    for a, size in lits.items():
        if size == 4 and img.ok(a, 4):
            v = img.u32(a)
            if img.ok(v):
                refs.add(v)
    for a in calls:
        names.setdefault(a, f'sub_{a:08X}')
    for a in branches:
        names.setdefault(a, f'loc_{a:08X}')
    for a in refs:
        if a in code:
            names.setdefault(a, f'sub_{a:08X}')
        elif img.cstr(a):
            names.setdefault(a, f'str_{a:08X}')
        else:
            names.setdefault(a, f'dat_{a:08X}')

    def nm(v):
        return names.get(v)

    def lit_comment(a, size):
        if not img.ok(a, size):
            return ''
        if size == 2:
            v = img.u16(a)
            sv = v - 0x10000 if v & 0x8000 else v
            return f'={sv} (0x{v:04X})'
        v = img.u32(a)
        c = f'=0x{v:08X}'
        if nm(v):
            c += ' ' + nm(v)
        s = img.cstr(v)
        if s and v not in code:
            c += ' ' + quote(s, 48)
        return c

    out = []
    w = out.append
    w('; GAME BASIC for SEGA SATURN, interpreter image main.bin (SH-2, big-endian)')
    w(f'; Load address 0x{BASE:08X}, {len(img.d)} bytes, SHA-1 {hashlib.sha1(img.d).hexdigest()}')
    w(f'; Generated from {source_name} by gbcd_disasm.py with gbcd_symbols.txt.')
    w('; Copyrighted (C)1998 ASCII Corp./Bits Laboratory/ESP inc. material: keep out of public repositories.')
    w(f'; {len(code)} instructions found by control flow; everything else prints as data.')
    w(';')
    w('; Columns: address, raw bytes, instruction, comment. "=X" is a PC-relative literal value.')
    w('')

    sec_keys = sorted(sections)
    a = BASE
    while a < img.end:
        for s in [s for s in sec_keys if s == a]:
            w('')
            w(';' + '=' * 78)
            w(f'; {sections[s]}')
            w(';' + '=' * 78)
        if a in names:
            if a in heads or a in calls:
                w('')
                if a in heads:
                    w(f'; {heads[a]}')
            w(f'{names[a]}:')
        for t in notes.get(a, []):
            w(f'        ; {t}')

        if a in table_at:
            kind, n = table_at[a]
            if kind == 'tokens':
                for i in range(n):
                    e = a + 16 * i
                    s, f, p, fl = struct.unpack_from('>4I', img.d, e - BASE)
                    code_s = f'{i:02X}' if i < 0x100 else f'E8 {i - 0x100:02X}'
                    fld = ', '.join(nm(x) or f'0x{x:08X}' for x in (s, f, p))
                    w(f'{e:08X}  .long   {fld}, 0x{fl:08X}  ; token {code_s} {kw.get(i, "")}')
                a += 16 * n
            elif kind == 'subkw':
                for i in range(n):
                    e = a + 8 * i
                    p, v = struct.unpack_from('>2I', img.d, e - BASE)
                    w(f'{e:08X}  .long   {nm(p) or hex(p)}, 0x{v:08X}  ; @{img.cstr(p, 1) or "?"} = {v >> 16}')
                a += 8 * n
            elif kind == 'errptrs':
                for i in range(n):
                    e = a + 4 * i
                    p = img.u32(e)
                    w(f'{e:08X}  .long   {nm(p) or hex(p)}  ; error {i}: {quote(img.cstr(p, 1) or "")}')
                a += 4 * n
            continue

        if a in code:
            ww = img.u16(a)
            mn, ops, info = sh2.decode(ww, a)
            cm = []
            if 'lit' in info:
                lname = nm(info['lit']) or '0x%08X' % info['lit']
                ops = re.sub(r'@\(0x[0-9a-f]+\)', '@(' + lname + ')', ops)
                cm.append(lit_comment(info['lit'], info['size']))
            for k in ('branch', 'call', 'mova'):
                if k in info and nm(info[k]):
                    ops = re.sub(r'0x[0-9a-f]{8}', nm(info[k]), ops)
            if info.get('delay') is None and a - 2 in code:
                pmn, _, pinfo = sh2.decode(img.u16(a - 2), a - 2)
                if pinfo.get('delay'):
                    cm.append('(delay slot)')
            line = f'{a:08X}  {ww:04X}    {mn:8}{ops}'
            if any(cm):
                line = f'{line:44} ; ' + ' '.join(c for c in cm if c)
            w(line)
            a += 2
            continue

        # Data: run until the next code, label, table or section.
        stop = a + 1
        while stop < img.end and stop not in code and stop not in names and stop not in table_at \
                and stop not in sections:
            stop += 1
        a = emit_data(img, a, stop, lits, names, nm, w, jtables)
    w('')
    return '\n'.join(out) + '\n'


def emit_data(img, a, stop, lits, names, nm, w, jtables):
    while a < stop:
        if a in jtables:
            for i, t in enumerate(jtables[a]):
                w(f'{a + 2 * i:08X}  .word   0x{img.u16(a + 2 * i):04X}  ; case {i} -> {nm(t) or hex(t)}')
            a += 2 * len(jtables[a])
            continue
        if a in lits and a + lits[a] <= stop:
            size = lits[a]
            if size == 4:
                v = img.u32(a)
                c = nm(v) or ''
                s = img.cstr(v)
                if s and not c.startswith(('sub_', 'loc_')):
                    c = (c + ' ' + quote(s, 48)).strip()
                w(f'{a:08X}  .long   0x{v:08X}' + (f'  ; {c}' if c else ''))
            else:
                v = img.u16(a)
                w(f'{a:08X}  .word   0x{v:04X}  ; {v - 0x10000 if v & 0x8000 else v}')
            a += size
            continue
        s = img.cstr(a, 2 if a in names else 4)
        if s is not None and (a in names or a == 0 or img.d[a - BASE - 1] == 0 or a & 3 == 0):
            n = len(s.encode('cp932')) + 1
            if a + n <= stop:
                w(f'{a:08X}  .asciz  {quote(s, 200)}')
                a += n
                continue
        # Hex row up to 16 bytes, stopping before a literal or a string start.
        row_end = a + 1
        while row_end < stop and row_end - a < 16 and row_end not in lits and not (
                img.d[row_end - BASE - 1] == 0 and img.d[row_end - BASE] and img.cstr(row_end, 4)):
            row_end += 1
        chunk = img.d[a - BASE:row_end - BASE]
        if not any(chunk) and row_end - a > 1:
            # Collapse long zero runs.
            z = a
            while z < stop and img.d[z - BASE] == 0 and z not in lits:
                z += 1
            if z - a >= 32:
                w(f'{a:08X}  .space  {z - a}')
                a = z
                continue
        asc = ''.join(chr(b) if 32 <= b < 127 else '.' for b in chunk)
        w(f'{a:08X}  .byte   ' + ' '.join(f'{b:02X}' for b in chunk).ljust(48) + f'; {asc}')
        a = row_end
    return a


def main():
    ap = argparse.ArgumentParser(description=__doc__.split('\n')[0])
    ap.add_argument('source', help='GAME_BASIC.iso, or an unpacked main.bin')
    ap.add_argument('-o', '--out', required=True, help='listing to write (keep it out of public repos)')
    ap.add_argument('--symbols', default=os.path.join(os.path.dirname(os.path.abspath(__file__)),
                                                      'gbcd_symbols.txt'))
    a = ap.parse_args()
    img = Image(load_image(a.source))
    text = disassemble(img, a.symbols, os.path.basename(a.source))
    with open(a.out, 'w', encoding='utf-8') as f:
        f.write(text)
    print(f'{a.out}: {text.count(chr(10))} lines')


if __name__ == '__main__':
    sys.exit(main())
