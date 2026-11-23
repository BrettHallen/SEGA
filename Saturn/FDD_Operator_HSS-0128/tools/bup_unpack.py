#!/usr/bin/env python3
"""Unpack the backup library (BUP) from a Saturn BIOS ROM.

The BIOS keeps BUP compressed. BUP_Init (*0x06000358) calls the BIOS
decompressor (*0x000005F8) on the module at *0x0600035C into the caller's
16 KB library area, then jumps to it. This script sets up those RAM vectors
the way the BIOS reset code does and runs the decompressor in sh2emu.

    python3 bup_unpack.py Sega_Saturn_BIOS_1994_11_15.bin bup.bin

The output is position independent SH-2 code (disassemble at any base, for
example 0x060F0000, where FDD Operator loads it). Ready-made copies and
listings are in ../BIOS_BUP/.
"""
import os
import sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from sh2emu import Mem, CPU  # noqa: E402

LIB = 0x060F0000


def unpack(rom):
    m = Mem(rom)

    def cp(cnt, dst, src):          # same copies as the reset code at 0x2000024C
        for i in range(cnt):
            m.wr(dst + 4 * i, 4, m.rd(src + 4 * i, 4))
    cp(4, 0x06000210, 0x20000810)
    cp(0x84, 0x06000000, 0x20000600)
    cp(0x238, 0x06000220, 0x20000820)
    src = m.rd(0x0600035C, 4)
    m.wr(0x06001F00, 4, LIB)
    CPU(m).call(m.rd(0x5F8, 4), (src, 0x06001F00, 0x4000))
    end = m.rd(0x06001F00, 4)
    return bytes(m.hi[LIB - 0x06000000:end - 0x06000000]), src


if __name__ == '__main__':
    data, src = unpack(open(sys.argv[1], 'rb').read())
    open(sys.argv[2], 'wb').write(data)
    print(f'module at ROM 0x{src:X}: {len(data)} bytes -> {sys.argv[2]}')
