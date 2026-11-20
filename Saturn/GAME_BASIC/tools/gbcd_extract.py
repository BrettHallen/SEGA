#!/usr/bin/env python3
"""Extract and unpack a GAME BASIC for SEGA SATURN CD image.

Reads a 2048-byte/sector ISO of the CD's data track (for example one made with
`dd if=/dev/rdiskN of=GAME_BASIC.iso bs=2048`) and:

  * prints the Saturn IP.BIN header (system ID, product, version, area codes,
    1st read address),
  * extracts every file in the ISO9660 root directory,
  * unpacks the boot file "0" into the interpreter image as it sits in RAM at
    0x0600A000 ("main.bin"), using the same decrypt + LZSS scheme as the
    loader in IP.BIN (AIP at 0x06002F40),
  * optionally writes the interpreter's keyword token table as TSV.

Standard library only. The output is copyrighted (C)1998 ASCII Corp./Bits
Laboratory/ESP inc. material: write it outside any public repository.

    python3 gbcd_extract.py GAME_BASIC.iso --out ~/GAME_BASIC_CD_extracted
"""
import argparse
import os
import struct
import sys

SECTOR = 2048
LOAD_ADDR = 0x0600A000


def ip_header(iso):
    h = iso[:0x100]
    txt = lambda a, n: h[a:a + n].decode('ascii', 'replace').rstrip()
    return {
        'hardware_id': txt(0x00, 16),
        'maker_id': txt(0x10, 16),
        'product': txt(0x20, 10),
        'version': txt(0x2A, 6),
        'release_date': txt(0x30, 8),
        'device_info': txt(0x38, 8),
        'area_codes': txt(0x40, 16),
        'peripherals': txt(0x50, 16),
        'title': txt(0x60, 0x70),
        'ip_size': hex(struct.unpack('>I', h[0xE0:0xE4])[0]),
        'master_stack': hex(struct.unpack('>I', h[0xE8:0xEC])[0]),
        'slave_stack': hex(struct.unpack('>I', h[0xEC:0xF0])[0]),
        'first_read_addr': hex(struct.unpack('>I', h[0xF0:0xF4])[0]),
        'first_read_size': hex(struct.unpack('>I', h[0xF4:0xF8])[0]),
    }


def iso_root_files(iso):
    pvd = iso[16 * SECTOR:17 * SECTOR]
    if pvd[1:6] != b'CD001':
        raise SystemExit('No ISO9660 primary volume descriptor at sector 16')
    root = pvd[156:156 + 34]
    lba, size = struct.unpack('<I', root[2:6])[0], struct.unpack('<I', root[10:14])[0]
    d = iso[lba * SECTOR:lba * SECTOR + size]
    i, out = 0, []
    while i < len(d):
        n = d[i]
        if n == 0:                       # records never cross a sector
            i = (i // SECTOR + 1) * SECTOR
            continue
        rec = d[i:i + n]
        flen = rec[32]
        name = rec[33:33 + flen]
        if name not in (b'\x00', b'\x01') and not rec[25] & 2:
            out.append((name.decode('ascii').split(';')[0],
                        struct.unpack('<I', rec[2:6])[0],
                        struct.unpack('<I', rec[10:14])[0]))
        i += n
    return out


def unpack_boot(src):
    """Decrypt + LZSS, as the IP.BIN AIP does from 0x06080000 to 0x0600A000."""
    M = 0xFFFFFFFF
    size = struct.unpack('<I', src[:4])[0]
    seed = (src[0] - 256 if src[0] & 0x80 else src[0]) & M   # exts.b of the size
    state = [(seed * 0xAD65) & M, 4]

    def byte():
        b = src[state[1]]
        state[1] += 1
        state[0] = (state[0] * 0x792D3 + 0x6C1CF) & M
        return (b - ((state[0] >> 16) * seed)) & 0xFF

    ring, pos, flags, out = bytearray(0x400), 0x3BE, 0, bytearray()
    while len(out) < size:
        flags >>= 1
        if not flags & 0x100:
            flags = byte() | 0xFF00
        if flags & 1:                      # literal
            c = byte()
            ring[pos & 0x3FF] = c
            pos += 1
            out.append(c)
        else:                              # 10-bit offset, 6-bit length (+3)
            a, b = byte(), byte()
            a += (b & 0xC0) << 2
            end = a + (b & 0x3F) + 2
            while len(out) < size:
                c = ring[a & 0x3FF]
                ring[pos & 0x3FF] = c
                a += 1
                pos += 1
                out.append(c)
                if a > end:
                    break
    return bytes(out)


def token_table(main):
    """Keyword descriptors: 16 bytes each at 0x0609CBE0 (stmt, func, name, flags)."""
    def at(addr, n):
        o = addr - LOAD_ADDR
        return main[o:o + n]

    def cstr(addr):
        o = addr - LOAD_ADDR
        return main[o:main.index(b'\0', o)].decode('ascii')
    rows = []
    for i in range(0x120):
        stmt, func, name, flags = struct.unpack('>4I', at(0x0609CBE0 + 16 * i, 16))
        code = f'{i:02X}' if i < 0x100 else f'E8 {i - 0x100:02X}'
        rows.append((code, cstr(name), f'{flags >> 16:04X}', f'{stmt:08X}', f'{func:08X}'))
    return rows


def main():
    ap = argparse.ArgumentParser(description=__doc__.split('\n')[0])
    ap.add_argument('iso')
    ap.add_argument('--out', help='folder for the extracted files (omit to only list)')
    a = ap.parse_args()
    iso = open(a.iso, 'rb').read()
    for k, v in ip_header(iso).items():
        print(f'{k:16} {v}')
    files = iso_root_files(iso)
    print(f'\n{len(files)} files in the root directory')
    total = len(iso) // SECTOR
    for name, lba, size in sorted(files, key=lambda f: f[1]):
        note = '  (outside the data track: points at the CD-DA track)' if lba >= total else ''
        print(f'{lba:6d} {size:9d}  {name}{note}')
    if not a.out:
        return
    os.makedirs(a.out, exist_ok=True)
    for name, lba, size in files:
        if lba < total:
            with open(os.path.join(a.out, name), 'wb') as f:
                f.write(iso[lba * SECTOR:lba * SECTOR + size])
    with open(os.path.join(a.out, 'IP.BIN'), 'wb') as f:
        f.write(iso[:16 * SECTOR])
    boot = open(os.path.join(a.out, '0'), 'rb').read()
    img = unpack_boot(boot)
    with open(os.path.join(a.out, 'main.bin'), 'wb') as f:
        f.write(img)
    print(f'\nmain.bin: {len(img)} bytes, load at 0x{LOAD_ADDR:08X} (SH-2 big-endian)')
    with open(os.path.join(a.out, 'tokens.tsv'), 'w') as f:
        f.write('token\tkeyword\tflags\tstatement\tfunction\n')
        for r in token_table(img):
            f.write('\t'.join(r) + '\n')
    print('tokens.tsv: keyword token table')


if __name__ == '__main__':
    sys.exit(main())
