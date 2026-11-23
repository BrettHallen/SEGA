"""Tiny SH-2 interpreter (integer subset), enough to run BIOS helper routines.

Memory: BIOS ROM at 0x00000000 (mirrored at 0x20000000), low WRAM 0x00200000,
high WRAM 0x06000000. Everything else is a logging sink.
"""
import struct


def s8(v): return v - 0x100 if v & 0x80 else v
def s12(v): return v - 0x1000 if v & 0x800 else v
def s16(v): return v - 0x10000 if v & 0x8000 else v
M = 0xFFFFFFFF


class Mem:
    def __init__(self, rom):
        self.rom = bytearray(rom)
        self.lo = bytearray(0x100000)
        self.hi = bytearray(0x100000)
        self.io = {}
        self.log = []
        self.hook_read = None
        self.hook_write = None

    def region(self, a):
        p = a & 0x07FFFFFF if (a >> 28) in (0, 2) else None
        if p is None:
            return None, a
        if p < 0x80000:
            return self.rom, p
        if 0x00200000 <= p < 0x00300000:
            return self.lo, p - 0x00200000
        if 0x06000000 <= p < 0x06100000:
            return self.hi, p - 0x06000000
        return None, a

    def rd(self, a, n):
        a &= M
        buf, o = self.region(a)
        if buf is None:
            if self.hook_read:
                v = self.hook_read(a, n)
                if v is not None:
                    return v
            self.log.append(('R', a, n))
            return self.io.get(a, 0)
        return int.from_bytes(buf[o:o + n], 'big')

    def wr(self, a, n, v):
        a &= M
        v &= (1 << (8 * n)) - 1
        buf, o = self.region(a)
        if buf is None or buf is self.rom:
            if self.hook_write:
                self.hook_write(a, n, v)
            self.log.append(('W', a, n, v))
            self.io[a] = v
            return
        buf[o:o + n] = v.to_bytes(n, 'big')


class CPU:
    def __init__(self, mem):
        self.m = mem
        self.r = [0] * 16
        self.pc = 0
        self.pr = 0
        self.sr = 0xF0
        self.gbr = self.vbr = self.mach = self.macl = 0
        self.steps = 0
        self.trace = None

    @property
    def T(self): return self.sr & 1

    def setT(self, b): self.sr = (self.sr & ~1) | (1 if b else 0)

    def call(self, addr, args=(), sp=0x06002000, limit=50_000_000):
        RET = 0x0DEAD000
        for i, a in enumerate(args):
            self.r[4 + i] = a & M
        self.r[15] = sp
        self.pr = RET
        self.pc = addr
        while self.pc != RET:
            self.step()
            if self.steps > limit:
                raise RuntimeError('step limit at %08x' % self.pc)
        return self.r[0]

    def step(self, delay=False):
        m, r = self.m, self.r
        pc = self.pc
        w = m.rd(pc, 2)
        self.steps += 1
        if self.trace:
            self.trace(self, pc, w)
        n = (w >> 8) & 15
        mm = (w >> 4) & 15
        i8 = w & 0xFF
        top = w >> 12
        npc = pc + 2
        branch = None   # (target, delayed)

        def rdl(a): return m.rd(a, 4)

        if top == 0:
            lo4 = w & 15
            if w == 0x0009: pass
            elif w == 0x000B: branch = (self.pr, True)
            elif w == 0x0008: self.setT(0)
            elif w == 0x0018: self.setT(1)
            elif w == 0x0019: self.sr &= ~0x301
            elif w == 0x0028: self.mach = self.macl = 0
            elif w == 0x002B:
                npc_ = rdl(r[15]); r[15] = (r[15] + 4) & M
                self.sr = rdl(r[15]) & 0x3F3; r[15] = (r[15] + 4) & M
                branch = (npc_, True)
            elif w == 0x001B: raise RuntimeError('sleep at %08x' % pc)
            elif lo4 == 2:
                r[n] = {0: self.sr, 1: self.gbr, 2: self.vbr}.get(mm, 0)
            elif lo4 == 3:
                if mm == 0: self.pr = npc + 2; branch = ((pc + 4 + r[n]) & M, True)
                elif mm == 2: branch = ((pc + 4 + r[n]) & M, True)
                else: self.bad(w)
            elif lo4 == 4: m.wr(r[0] + r[n], 1, r[mm])
            elif lo4 == 5: m.wr(r[0] + r[n], 2, r[mm])
            elif lo4 == 6: m.wr(r[0] + r[n], 4, r[mm])
            elif lo4 == 7: self.macl = (r[n] * r[mm]) & M
            elif lo4 == 0xA:
                r[n] = {0: self.mach, 1: self.macl, 2: self.pr}.get(mm, 0)
            elif lo4 == 0xC: r[n] = s8(m.rd(r[0] + r[mm], 1)) & M
            elif lo4 == 0xD: r[n] = s16(m.rd(r[0] + r[mm], 2)) & M
            elif lo4 == 0xE: r[n] = rdl(r[0] + r[mm])
            elif w & 0xFF == 0x29: r[n] = self.T
            else: self.bad(w)
        elif top == 1:
            m.wr(r[n] + (w & 15) * 4, 4, r[mm])
        elif top == 2:
            k = w & 15
            if k == 0: m.wr(r[n], 1, r[mm])
            elif k == 1: m.wr(r[n], 2, r[mm])
            elif k == 2: m.wr(r[n], 4, r[mm])
            elif k == 4: r[n] = (r[n] - 1) & M; m.wr(r[n], 1, r[mm])
            elif k == 5: r[n] = (r[n] - 2) & M; m.wr(r[n], 2, r[mm])
            elif k == 6: r[n] = (r[n] - 4) & M; m.wr(r[n], 4, r[mm])
            elif k == 7:
                q = r[n] >> 31; mq = r[mm] >> 31
                self.sr = (self.sr & ~0x301) | (q << 8) | (mq << 9) | (q ^ mq)
            elif k == 8: self.setT((r[n] & r[mm]) == 0)
            elif k == 9: r[n] &= r[mm]
            elif k == 0xA: r[n] ^= r[mm]
            elif k == 0xB: r[n] |= r[mm]
            elif k == 0xC:
                x = r[n] ^ r[mm]
                self.setT(any(((x >> s) & 0xFF) == 0 for s in (0, 8, 16, 24)))
            elif k == 0xD: r[n] = ((r[mm] << 16) | (r[n] >> 16)) & M
            elif k == 0xE: self.macl = (s16(r[n] & 0xFFFF) * s16(r[mm] & 0xFFFF)) & M
            elif k == 0xF: self.macl = (s16(r[n] & 0xFFFF) * s16(r[mm] & 0xFFFF)) & M
            else: self.bad(w)
            if k == 0xE: self.macl = ((r[n] & 0xFFFF) * (r[mm] & 0xFFFF)) & M
        elif top == 3:
            k = w & 15
            a, b = r[n], r[mm]
            sa = a - (1 << 32) if a >> 31 else a
            sb = b - (1 << 32) if b >> 31 else b
            if k == 0: self.setT(a == b)
            elif k == 2: self.setT(a >= b)
            elif k == 3: self.setT(sa >= sb)
            elif k == 6: self.setT(a > b)
            elif k == 7: self.setT(sa > sb)
            elif k == 8: r[n] = (a - b) & M
            elif k == 0xC: r[n] = (a + b) & M
            elif k == 0xE:
                s = a + b + self.T; r[n] = s & M; self.setT(s >> 32)
            elif k == 0xA:
                s = a - b - self.T; r[n] = s & M; self.setT(s < 0)
            elif k == 4:   # div1
                q = (self.sr >> 8) & 1; mq = (self.sr >> 9) & 1
                oldq = q
                q = a >> 31
                a = ((a << 1) | self.T) & M
                if oldq == mq:
                    t = a - b; a = t & M; borrow = t < 0
                    q = q ^ borrow if mq == 0 else q ^ (not borrow) ^ 1
                    if mq == 0: q = (r[n] >> 31) ^ borrow
                else:
                    t = a + b; a = t & M; carry = t >> 32
                    q = (r[n] >> 31) ^ carry ^ 1 if mq == 0 else (r[n] >> 31) ^ carry
                # Use reference algorithm instead (below)
                r[n] = self._div1(r[n], b)
            elif k == 5:
                p = a * b; self.mach = p >> 32; self.macl = p & M
            elif k == 0xD:
                p = (sa * sb) & 0xFFFFFFFFFFFFFFFF; self.mach = p >> 32; self.macl = p & M
            elif k == 0xF:
                s = sa + sb; r[n] = s & M; self.setT(s > 0x7FFFFFFF or s < -0x80000000)
            elif k == 0xB:
                s = sa - sb; r[n] = s & M; self.setT(s > 0x7FFFFFFF or s < -0x80000000)
            else: self.bad(w)
        elif top == 4:
            lo = w & 0xFF
            a = r[n]
            if lo == 0x00: self.setT(a >> 31); r[n] = (a << 1) & M
            elif lo == 0x01: self.setT(a & 1); r[n] = a >> 1
            elif lo == 0x20: self.setT(a >> 31); r[n] = (a << 1) & M
            elif lo == 0x21: self.setT(a & 1); r[n] = (a >> 1) | (a & 0x80000000)
            elif lo == 0x04: self.setT(a >> 31); r[n] = ((a << 1) | (a >> 31)) & M
            elif lo == 0x05: self.setT(a & 1); r[n] = (a >> 1) | ((a & 1) << 31)
            elif lo == 0x24: t = self.T; self.setT(a >> 31); r[n] = ((a << 1) | t) & M
            elif lo == 0x25: t = self.T; self.setT(a & 1); r[n] = (a >> 1) | (t << 31)
            elif lo == 0x08: r[n] = (a << 2) & M
            elif lo == 0x09: r[n] = a >> 2
            elif lo == 0x18: r[n] = (a << 8) & M
            elif lo == 0x19: r[n] = a >> 8
            elif lo == 0x28: r[n] = (a << 16) & M
            elif lo == 0x29: r[n] = a >> 16
            elif lo == 0x10: r[n] = (a - 1) & M; self.setT(r[n] == 0)
            elif lo == 0x11: self.setT(not a >> 31)
            elif lo == 0x15: self.setT(not a >> 31 and a != 0)
            elif lo == 0x0B: self.pr = npc + 2; branch = (a, True)
            elif lo == 0x2B: branch = (a, True)
            elif lo == 0x1B:
                v = m.rd(a, 1); self.setT(v == 0); m.wr(a, 1, v | 0x80)
            elif lo in (0x0E, 0x1E, 0x2E):
                v = a & (0x3F3 if lo == 0x0E else M)
                if lo == 0x0E: self.sr = v
                elif lo == 0x1E: self.gbr = a
                else: self.vbr = a
            elif lo in (0x07, 0x17, 0x27):
                v = rdl(a); r[n] = (a + 4) & M
                if lo == 0x07: self.sr = v & 0x3F3
                elif lo == 0x17: self.gbr = v
                else: self.vbr = v
            elif lo in (0x03, 0x13, 0x23):
                r[n] = (a - 4) & M
                m.wr(r[n], 4, {0x03: self.sr, 0x13: self.gbr, 0x23: self.vbr}[lo])
            elif lo in (0x0A, 0x1A, 0x2A):
                if lo == 0x0A: self.mach = a
                elif lo == 0x1A: self.macl = a
                else: self.pr = a
            elif lo in (0x06, 0x16, 0x26):
                v = rdl(a); r[n] = (a + 4) & M
                if lo == 0x06: self.mach = v
                elif lo == 0x16: self.macl = v
                else: self.pr = v
            elif lo in (0x02, 0x12, 0x22):
                r[n] = (a - 4) & M
                m.wr(r[n], 4, {0x02: self.mach, 0x12: self.macl, 0x22: self.pr}[lo])
            else: self.bad(w)
        elif top == 5:
            r[n] = rdl(r[mm] + (w & 15) * 4)
        elif top == 6:
            k = w & 15
            b = r[mm]
            if k == 0: r[n] = s8(m.rd(b, 1)) & M
            elif k == 1: r[n] = s16(m.rd(b, 2)) & M
            elif k == 2: r[n] = rdl(b)
            elif k == 3: r[n] = b
            elif k == 4: v = s8(m.rd(b, 1)) & M; r[mm] = (b + 1) & M if n != mm else r[mm]; r[n] = v
            elif k == 5: v = s16(m.rd(b, 2)) & M; r[mm] = (b + 2) & M if n != mm else r[mm]; r[n] = v
            elif k == 6: v = rdl(b); r[mm] = (b + 4) & M if n != mm else r[mm]; r[n] = v
            elif k == 7: r[n] = (~b) & M
            elif k == 8: r[n] = (b & 0xFFFF0000) | ((b & 0xFF) << 8) | ((b >> 8) & 0xFF)
            elif k == 9: r[n] = ((b << 16) | (b >> 16)) & M
            elif k == 0xA: s = -b - self.T; r[n] = s & M; self.setT(s < 0)
            elif k == 0xB: r[n] = (-b) & M
            elif k == 0xC: r[n] = b & 0xFF
            elif k == 0xD: r[n] = b & 0xFFFF
            elif k == 0xE: r[n] = s8(b & 0xFF) & M
            elif k == 0xF: r[n] = s16(b & 0xFFFF) & M
        elif top == 7:
            r[n] = (r[n] + s8(i8)) & M
        elif top == 8:
            sub = n
            if sub == 0: m.wr(r[mm] + (w & 15), 1, r[0])
            elif sub == 1: m.wr(r[mm] + (w & 15) * 2, 2, r[0])
            elif sub == 4: r[0] = s8(m.rd(r[mm] + (w & 15), 1)) & M
            elif sub == 5: r[0] = s16(m.rd(r[mm] + (w & 15) * 2, 2)) & M
            elif sub == 8: self.setT(r[0] == (s8(i8) & M))
            elif sub in (9, 0xB, 0xD, 0xF):
                tgt = (pc + 4 + s8(i8) * 2) & M
                take = self.T if sub in (9, 0xD) else not self.T
                if take:
                    branch = (tgt, sub in (0xD, 0xF))
            else: self.bad(w)
        elif top == 9:
            r[n] = s16(m.rd(pc + 4 + i8 * 2, 2)) & M
        elif top == 0xA:
            branch = ((pc + 4 + s12(w & 0xFFF) * 2) & M, True)
        elif top == 0xB:
            self.pr = npc + 2
            branch = ((pc + 4 + s12(w & 0xFFF) * 2) & M, True)
        elif top == 0xC:
            sub = n
            g = self.gbr
            if sub == 0: m.wr(g + i8, 1, r[0])
            elif sub == 1: m.wr(g + i8 * 2, 2, r[0])
            elif sub == 2: m.wr(g + i8 * 4, 4, r[0])
            elif sub == 4: r[0] = s8(m.rd(g + i8, 1)) & M
            elif sub == 5: r[0] = s16(m.rd(g + i8 * 2, 2)) & M
            elif sub == 6: r[0] = rdl(g + i8 * 4)
            elif sub == 7: r[0] = ((pc + 4) & ~3) + i8 * 4
            elif sub == 8: self.setT((r[0] & i8) == 0)
            elif sub == 9: r[0] &= i8
            elif sub == 0xA: r[0] ^= i8
            elif sub == 0xB: r[0] |= i8
            elif sub == 0xC: self.setT((m.rd(g + r[0], 1) & i8) == 0)
            elif sub == 0xD: m.wr(g + r[0], 1, m.rd(g + r[0], 1) & i8)
            elif sub == 0xE: m.wr(g + r[0], 1, m.rd(g + r[0], 1) ^ i8)
            elif sub == 0xF: m.wr(g + r[0], 1, m.rd(g + r[0], 1) | i8)
            else: self.bad(w)
        elif top == 0xD:
            r[n] = rdl(((pc + 4) & ~3) + i8 * 4)
        elif top == 0xE:
            r[n] = s8(i8) & M
        else:
            self.bad(w)

        if branch:
            tgt, delayed = branch
            if delayed:
                self.pc = npc
                self.step(delay=True)
            self.pc = tgt
        elif not delay:
            self.pc = npc

    def _div1(self, rn, rm):
        sr = self.sr
        Q = (sr >> 8) & 1; Mb = (sr >> 9) & 1; T = sr & 1
        old_q = Q
        Q = (rn >> 31) & 1
        rn = ((rn << 1) | T) & M
        if old_q == 0:
            if Mb == 0:
                tmp = rn; rn = (rn - rm) & M; tmp1 = rn > tmp
                Q = tmp1 if Q == 0 else (tmp1 == 0)
            else:
                tmp = rn; rn = (rn + rm) & M; tmp1 = rn < tmp
                Q = (tmp1 == 0) if Q == 0 else tmp1
        else:
            if Mb == 0:
                tmp = rn; rn = (rn + rm) & M; tmp1 = rn < tmp
                Q = tmp1 if Q == 0 else (tmp1 == 0)
            else:
                tmp = rn; rn = (rn - rm) & M; tmp1 = rn > tmp
                Q = (tmp1 == 0) if Q == 0 else tmp1
        Q = int(bool(Q))
        T = int(Q == Mb)
        self.sr = (sr & ~0x101) | (Q << 8) | T
        return rn

    def bad(self, w):
        raise RuntimeError('unimplemented %04x at %08x' % (w, self.pc))
