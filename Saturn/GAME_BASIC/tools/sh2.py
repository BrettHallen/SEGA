#!/usr/bin/env python3
"""Minimal SH-2 (SuperH) instruction decoder, standard library only.

decode(word, pc) returns (mnemonic, operands, info) for one big-endian 16-bit
instruction at address pc. info is a dict that may hold:

  'lit'    address of a PC-relative literal (mov.l / mov.w @(disp,pc)), with
  'size'   its size (2 or 4)
  'mova'   address that mova loads into r0
  'branch' target of bra / bt / bf / bt/s / bf/s
  'call'   target of bsr
  'jsr'    register number for jsr @rn / jmp @rn (the caller resolves it)
  'end'    True for an unconditional control transfer (rts, rte, bra, braf, jmp)
  'delay'  True when the next instruction is a delay slot

Unknown encodings return ('.word', '0x%04x', {}).
"""


def _s8(v):
    return v - 0x100 if v & 0x80 else v


def _s12(v):
    return v - 0x1000 if v & 0x800 else v


def decode(w, pc):
    n = (w >> 8) & 0xF
    m = (w >> 4) & 0xF
    d4 = w & 0xF
    d8 = w & 0xFF
    rn, rm = f"r{n}", f"r{m}"
    top = w >> 12
    info = {}

    if top == 0x0:
        lo = w & 0xFF
        fixed = {0x0008: 'clrt', 0x0009: 'nop', 0x000B: 'rts', 0x0018: 'sett',
                 0x0019: 'div0u', 0x001B: 'sleep', 0x0028: 'clrmac', 0x002B: 'rte'}
        if w in fixed:
            mn = fixed[w]
            if mn in ('rts', 'rte'):
                info.update(end=True, delay=True)
            return mn, '', info
        if lo == 0x02: return 'stc', f'sr,{rn}', info
        if lo == 0x12: return 'stc', f'gbr,{rn}', info
        if lo == 0x22: return 'stc', f'vbr,{rn}', info
        if lo == 0x03: return 'bsrf', rn, dict(delay=True)
        if lo == 0x23: return 'braf', rn, dict(delay=True, end=True)
        if lo == 0x0A: return 'sts', f'mach,{rn}', info
        if lo == 0x1A: return 'sts', f'macl,{rn}', info
        if lo == 0x2A: return 'sts', f'pr,{rn}', info
        if lo == 0x29: return 'movt', rn, info
        if d4 == 0x4: return 'mov.b', f'{rm},@(r0,{rn})', info
        if d4 == 0x5: return 'mov.w', f'{rm},@(r0,{rn})', info
        if d4 == 0x6: return 'mov.l', f'{rm},@(r0,{rn})', info
        if d4 == 0x7: return 'mul.l', f'{rm},{rn}', info
        if d4 == 0xC: return 'mov.b', f'@(r0,{rm}),{rn}', info
        if d4 == 0xD: return 'mov.w', f'@(r0,{rm}),{rn}', info
        if d4 == 0xE: return 'mov.l', f'@(r0,{rm}),{rn}', info
        if d4 == 0xF: return 'mac.l', f'@{rm}+,@{rn}+', info
    elif top == 0x1:
        return 'mov.l', f'{rm},@({d4 * 4},{rn})', info
    elif top == 0x2:
        ops = {0: ('mov.b', f'{rm},@{rn}'), 1: ('mov.w', f'{rm},@{rn}'), 2: ('mov.l', f'{rm},@{rn}'),
               4: ('mov.b', f'{rm},@-{rn}'), 5: ('mov.w', f'{rm},@-{rn}'), 6: ('mov.l', f'{rm},@-{rn}'),
               7: ('div0s', f'{rm},{rn}'), 8: ('tst', f'{rm},{rn}'), 9: ('and', f'{rm},{rn}'),
               0xA: ('xor', f'{rm},{rn}'), 0xB: ('or', f'{rm},{rn}'), 0xC: ('cmp/str', f'{rm},{rn}'),
               0xD: ('xtrct', f'{rm},{rn}'), 0xE: ('mulu.w', f'{rm},{rn}'), 0xF: ('muls.w', f'{rm},{rn}')}
        if d4 in ops:
            return ops[d4][0], ops[d4][1], info
    elif top == 0x3:
        ops = {0: 'cmp/eq', 2: 'cmp/hs', 3: 'cmp/ge', 4: 'div1', 5: 'dmulu.l', 6: 'cmp/hi',
               7: 'cmp/gt', 8: 'sub', 0xA: 'subc', 0xB: 'subv', 0xC: 'add', 0xD: 'dmuls.l',
               0xE: 'addc', 0xF: 'addv'}
        if d4 in ops:
            return ops[d4], f'{rm},{rn}', info
    elif top == 0x4:
        lo = w & 0xFF
        ops = {0x00: ('shll', rn), 0x01: ('shlr', rn), 0x02: ('sts.l', f'mach,@-{rn}'),
               0x03: ('stc.l', f'sr,@-{rn}'), 0x04: ('rotl', rn), 0x05: ('rotr', rn),
               0x06: ('lds.l', f'@{rn}+,mach'), 0x07: ('ldc.l', f'@{rn}+,sr'), 0x08: ('shll2', rn),
               0x09: ('shlr2', rn), 0x0A: ('lds', f'{rn},mach'), 0x0E: ('ldc', f'{rn},sr'),
               0x10: ('dt', rn), 0x11: ('cmp/pz', rn), 0x12: ('sts.l', f'macl,@-{rn}'),
               0x13: ('stc.l', f'gbr,@-{rn}'), 0x15: ('cmp/pl', rn), 0x16: ('lds.l', f'@{rn}+,macl'),
               0x17: ('ldc.l', f'@{rn}+,gbr'), 0x18: ('shll8', rn), 0x19: ('shlr8', rn),
               0x1A: ('lds', f'{rn},macl'), 0x1B: ('tas.b', f'@{rn}'), 0x1E: ('ldc', f'{rn},gbr'),
               0x20: ('shal', rn), 0x21: ('shar', rn), 0x22: ('sts.l', f'pr,@-{rn}'),
               0x23: ('stc.l', f'vbr,@-{rn}'), 0x24: ('rotcl', rn), 0x25: ('rotcr', rn),
               0x26: ('lds.l', f'@{rn}+,pr'), 0x27: ('ldc.l', f'@{rn}+,vbr'), 0x28: ('shll16', rn),
               0x29: ('shlr16', rn), 0x2A: ('lds', f'{rn},pr'), 0x2E: ('ldc', f'{rn},vbr')}
        if lo == 0x0B:
            return 'jsr', f'@{rn}', dict(jsr=n, delay=True)
        if lo == 0x2B:
            return 'jmp', f'@{rn}', dict(jsr=n, delay=True, end=True)
        if lo in ops:
            return ops[lo][0], ops[lo][1], info
        if d4 == 0xF:
            return 'mac.w', f'@{rm}+,@{rn}+', info
    elif top == 0x5:
        return 'mov.l', f'@({d4 * 4},{rm}),{rn}', info
    elif top == 0x6:
        ops = {0: ('mov.b', f'@{rm},{rn}'), 1: ('mov.w', f'@{rm},{rn}'), 2: ('mov.l', f'@{rm},{rn}'),
               3: ('mov', f'{rm},{rn}'), 4: ('mov.b', f'@{rm}+,{rn}'), 5: ('mov.w', f'@{rm}+,{rn}'),
               6: ('mov.l', f'@{rm}+,{rn}'), 7: ('not', f'{rm},{rn}'), 8: ('swap.b', f'{rm},{rn}'),
               9: ('swap.w', f'{rm},{rn}'), 0xA: ('negc', f'{rm},{rn}'), 0xB: ('neg', f'{rm},{rn}'),
               0xC: ('extu.b', f'{rm},{rn}'), 0xD: ('extu.w', f'{rm},{rn}'), 0xE: ('exts.b', f'{rm},{rn}'),
               0xF: ('exts.w', f'{rm},{rn}')}
        return ops[d4][0], ops[d4][1], info
    elif top == 0x7:
        return 'add', f'#{_s8(d8)},{rn}', info
    elif top == 0x8:
        sub = n
        if sub == 0x0: return 'mov.b', f'r0,@({d4},{rm})', info
        if sub == 0x1: return 'mov.w', f'r0,@({d4 * 2},{rm})', info
        if sub == 0x4: return 'mov.b', f'@({d4},{rm}),r0', info
        if sub == 0x5: return 'mov.w', f'@({d4 * 2},{rm}),r0', info
        if sub == 0x8: return 'cmp/eq', f'#{_s8(d8)},r0', info
        if sub in (0x9, 0xB, 0xD, 0xF):
            t = pc + 4 + _s8(d8) * 2
            mn = {0x9: 'bt', 0xB: 'bf', 0xD: 'bt/s', 0xF: 'bf/s'}[sub]
            info = dict(branch=t)
            if sub in (0xD, 0xF):
                info['delay'] = True
            return mn, f'0x{t:08x}', info
    elif top == 0x9:
        a = pc + 4 + d8 * 2
        return 'mov.w', f'@(0x{a:08x}),{rn}', dict(lit=a, size=2)
    elif top == 0xA:
        t = pc + 4 + _s12(w & 0xFFF) * 2
        return 'bra', f'0x{t:08x}', dict(branch=t, end=True, delay=True)
    elif top == 0xB:
        t = pc + 4 + _s12(w & 0xFFF) * 2
        return 'bsr', f'0x{t:08x}', dict(call=t, delay=True)
    elif top == 0xC:
        sub = n
        if sub == 0x0: return 'mov.b', f'r0,@({d8},gbr)', info
        if sub == 0x1: return 'mov.w', f'r0,@({d8 * 2},gbr)', info
        if sub == 0x2: return 'mov.l', f'r0,@({d8 * 4},gbr)', info
        if sub == 0x3: return 'trapa', f'#{d8}', info
        if sub == 0x4: return 'mov.b', f'@({d8},gbr),r0', info
        if sub == 0x5: return 'mov.w', f'@({d8 * 2},gbr),r0', info
        if sub == 0x6: return 'mov.l', f'@({d8 * 4},gbr),r0', info
        if sub == 0x7:
            a = ((pc + 4) & ~3) + d8 * 4
            return 'mova', f'@(0x{a:08x}),r0', dict(mova=a)
        ops = {0x8: 'tst', 0x9: 'and', 0xA: 'xor', 0xB: 'or'}
        if sub in ops:
            return ops[sub], f'#{d8},r0', info
        ops = {0xC: 'tst.b', 0xD: 'and.b', 0xE: 'xor.b', 0xF: 'or.b'}
        return ops[sub], f'#{d8},@(r0,gbr)', info
    elif top == 0xD:
        a = ((pc + 4) & ~3) + d8 * 4
        return 'mov.l', f'@(0x{a:08x}),{rn}', dict(lit=a, size=4)
    elif top == 0xE:
        return 'mov', f'#{_s8(d8)},{rn}', info
    return '.word', f'0x{w:04x}', {}
