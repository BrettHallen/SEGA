#!/usr/bin/env python3
"""srp.py - cross-platform Python port of SRP (Saturn Region Patcher) v3.0 Gold Edition.

The original SRP3.0GE.exe (Madroms, 2004-2009) is a Windows-only VB.NET tool.
This port was reverse engineered from its IL and reproduces its patching
output byte-for-byte:

* the area code field of the Saturn system header (IP.BIN offset 0x40, 8 bytes),
* the area code symbol blocks in sector 1 (IP.BIN offset 0xE00, 32 bytes each),
* optionally the first/third-party maker bytes (IP.BIN offset 0x15, 3 bytes),
* and, for RAW (2352-byte sector) images, the Mode 1 EDC/ECC of sectors 0 and 1.

Only the Python standard library is used.  Run ``python3 srp.py --help``.
"""

from __future__ import annotations

import argparse
import os
import sys
from dataclasses import dataclass, field

__version__ = "1.0.0"

# --------------------------------------------------------------------------
# Constants taken verbatim from SRP3.0GE.exe (Form1 constructor / handlers)
# --------------------------------------------------------------------------

#: Order in which SRP always writes area codes ("J-T-U-B-K-A-E-L").
AREA_ORDER = "JTUBKAEL"

#: 32-byte area code symbol blocks written into sector 1 (offset 0x600).
#: Each block is the SH-2 instruction prefix A0 0E 00 09 followed by text.
AREA_BLOCKS = {
    "J": bytes.fromhex("A00E0009466F72204A4150414E2E202020202020202020202020202020202020"),
    "T": bytes.fromhex("A00E0009466F722054414957414E20616E64205048494C4950494E45532E2020"),
    "U": bytes.fromhex("A00E0009466F722055534120616E642043414E4144412E202020202020202020"),
    "B": bytes.fromhex("A00E0009466F72204252415A494C2E2020202020202020202020202020202020"),
    "K": bytes.fromhex("A00E0009466F72204B4F5245412E202020202020202020202020202020202020"),
    "A": bytes.fromhex("A00E0009466F7220415349412050414C20617265612E20202020202020202020"),
    "E": bytes.fromhex("A00E0009466F72204555524F50452E2020202020202020202020202020202020"),
    "L": bytes.fromhex("A00E0009466F72204C4154494E20414D45524943412E20202020202020202020"),
}
#: Filler blocks SRP recognises as "free" area slots (written by SRP itself).
BLOCK_SRP_2004 = bytes.fromhex("A00E000950617463686564206279205352502032303034204D6164726F6D7320")  # "Patched by SRP 2004 Madroms "
BLOCK_SRP_NEW = bytes.fromhex("A00E00095061746368656420627920535250202D204D6164726F6D7320202020")   # "Patched by SRP - Madroms    "
BLOCK_SATHEADER = bytes.fromhex("A00E0009466F72205341544845414445522E2020202020202020202020202020")  # "For SATHEADER."

#: Recognised blocks in the order SRP indexes them (index -> pseudo letter).
KNOWN_BLOCKS = [AREA_BLOCKS[c] for c in AREA_ORDER] + [BLOCK_SRP_2004, BLOCK_SRP_NEW, BLOCK_SATHEADER]
KNOWN_BLOCK_LETTERS = AREA_ORDER + "ZYX"

SYSTEM_ID = b"SEGA SEGASATURN "
SECTOR1_SIGNATURE = bytes.fromhex("1EE1644C484C484C3A84C22484C1239E")  # first 16 bytes of sector 1 (security code)
PVD_SIGNATURE = bytes.fromhex("0143443030310100")                   # ISO9660 primary volume descriptor
MAKER_SEGA = b"ENT"   # "SEGA ENTERPRISES" (first party)
MAKER_TP = b"TP "     # "SEGA TP ..."      (third party)

RAW_SECTOR = 2352
MIN_IMAGE_SIZE = 7344        # SRP rejects anything smaller
SCAN_LIMIT = 0x100000        # SRP only reads the first 1 MiB of the image
AREA_SLOT_OFFSET = 0x600     # area blocks start 0x600 bytes into sector 1
AREA_SLOT_COUNT = 8
AREA_SLOT_SIZE = 32


class SRPError(Exception):
    """Raised for images SRP would refuse (or crash on)."""


# --------------------------------------------------------------------------
# CD-ROM Mode 1 EDC / ECC (identical to SRP's ECCEDCInit/EDCgenerate/ECCgenerate)
# --------------------------------------------------------------------------

def _build_tables():
    ecc_f = [0] * 256
    ecc_b = [0] * 256
    edc = [0] * 256
    for i in range(256):
        j = ((i << 1) ^ (0x11D if i & 0x80 else 0)) & 0xFFFFFFFF
        ecc_f[i] = j
        ecc_b[(i ^ j) & 0xFF] = i
        e = i
        for _ in range(8):
            e = (e >> 1) ^ (0xD8018001 if e & 1 else 0)
        edc[i] = e
    return ecc_f, ecc_b, edc


ECC_F_LUT, ECC_B_LUT, EDC_LUT = _build_tables()


def edc_compute(data: bytes | bytearray) -> int:
    edc = 0
    lut = EDC_LUT
    for b in data:
        edc = (edc >> 8) ^ lut[(edc ^ b) & 0xFF]
    return edc


def _ecc_pq(sector: bytearray, major_count: int, minor_count: int,
            major_mult: int, minor_inc: int) -> bytes:
    """Compute P (86x24) or Q (52x43) parity over sector[12:] like SRP does."""
    size = major_count * minor_count
    out = bytearray(major_count * 2)
    f_lut, b_lut = ECC_F_LUT, ECC_B_LUT
    for major in range(major_count):
        index = (major >> 1) * major_mult + (major & 1)
        ecc_a = 0
        ecc_b = 0
        for _ in range(minor_count):
            temp = sector[12 + index]
            index += minor_inc
            if index >= size:
                index -= size
            ecc_a ^= temp
            ecc_b ^= temp
            ecc_a = f_lut[ecc_a]
        ecc_a = b_lut[f_lut[ecc_a] ^ ecc_b]
        out[major] = ecc_a
        out[major + major_count] = ecc_a ^ ecc_b
    return bytes(out)


def regenerate_edc_ecc(sector: bytearray) -> None:
    """Recompute EDC (0x810), ECC-P (0x81C) and ECC-Q (0x8C8) of a Mode 1 sector in place.

    SRP always treats the sector as Mode 1 and does not clear the 8 reserved
    bytes at 0x814; neither does this function.
    """
    if len(sector) != RAW_SECTOR:
        raise ValueError("raw sector must be 2352 bytes")
    sector[0x810:0x814] = edc_compute(sector[0:0x810]).to_bytes(4, "little")
    sector[0x81C:0x81C + 172] = _ecc_pq(sector, 86, 24, 2, 86)
    sector[0x8C8:0x8C8 + 104] = _ecc_pq(sector, 52, 43, 86, 88)


# --------------------------------------------------------------------------
# Image analysis (SRP's TextBox1_TextChanged)
# --------------------------------------------------------------------------

def _ansi(b: bytes) -> str:
    return b.decode("cp1252", errors="replace")


@dataclass
class ImageInfo:
    path: str
    size: int
    raw: bool
    header_offset: int
    sector1_offset: int | None
    pvd_offset: int | None
    header: bytes
    area_slots: list = field(default_factory=list)   # pseudo-letter or None per slot
    max_areas: int = 0
    current_areas: str = ""                           # letters SRP pre-ticks
    maker: str | None = None                          # "sega", "tp" or None
    pvd: dict = field(default_factory=dict)

    # header fields as SRP displays them
    @property
    def fields(self) -> dict:
        h = self.header
        s = lambda a, n: _ansi(h[a:a + n]).rstrip(" ")
        return {
            "Hardware ID": s(0, 16),
            "Maker ID": s(16, 16),
            "Product number": s(32, 10),
            "Version": s(42, 6),
            "Release date": s(48, 8),
            "Device info": s(56, 8),
            "Area codes": s(64, 10),
            "Peripherals": s(80, 16),
            "Title": _ansi(h[96:208]),
        }


def analyse_bytes(buf: bytes, file_size: int, path: str = "") -> ImageInfo:
    """Analyse the first (up to) 1 MiB of an image exactly as SRP does."""
    if file_size < MIN_IMAGE_SIZE:
        raise SRPError("This is not a valid Sega Saturn image (file too small).")
    raw = (file_size % RAW_SECTOR) == 0

    h = buf.find(SYSTEM_ID)
    if h < 0:
        raise SRPError("This is not a valid Sega Saturn image (no 'SEGA SEGASATURN' header found).")
    s1 = buf.find(SECTOR1_SIGNATURE, h)
    s1 = None if s1 < 0 else s1
    pvd = buf.find(PVD_SIGNATURE, s1) if s1 is not None else -1
    pvd = None if pvd < 0 else pvd

    header = bytes(buf[h:h + 209])
    info = ImageInfo(path=path, size=file_size, raw=raw, header_offset=h,
                     sector1_offset=s1, pvd_offset=pvd, header=header)

    mk = header[16:24]
    if mk == b"SEGA ENT":
        info.maker = "sega"
    elif mk == b"SEGA TP ":
        info.maker = "tp"

    if pvd is not None:
        def txt(a, n):
            return _ansi(bytes(buf[pvd + a:pvd + a + n]))
        c, m = txt(813, 16), txt(830, 16)
        info.pvd = {
            "Volume label": txt(40, 32).rstrip(" "),
            "Created": f"{c[0:4]}/{c[4:6]}/{c[6:8]} {c[8:10]}:{c[10:12]}:{c[12:14]}:{c[14:16]}",
            "Modified": f"{m[0:4]}/{m[4:6]}/{m[6:8]} {m[8:10]}:{m[10:12]}:{m[12:14]}:{m[14:16]}",
        }

    if s1 is not None:
        base = s1 + AREA_SLOT_OFFSET
        letters = ""
        for slot in range(AREA_SLOT_COUNT):
            blk = bytes(buf[base + slot * 32: base + slot * 32 + 32])
            hit = None
            for idx, known in enumerate(KNOWN_BLOCKS):
                if blk == known:
                    hit = KNOWN_BLOCK_LETTERS[idx]
                    letters += hit
            info.area_slots.append(hit)
        info.max_areas = len(letters)
        info.current_areas = "".join(c for c in letters if c in AREA_ORDER)
    return info


def analyse(path: str) -> ImageInfo:
    size = os.path.getsize(path)
    with open(path, "rb") as f:
        buf = f.read(min(size, SCAN_LIMIT))
    return analyse_bytes(buf, size, path)


# --------------------------------------------------------------------------
# Patching (SRP's Regionpatchbutton_Click)
# --------------------------------------------------------------------------

def normalise_areas(areas: str) -> str:
    areas = areas.upper().replace(",", "").replace(" ", "")
    bad = sorted(set(areas) - set(AREA_ORDER))
    if bad:
        raise SRPError(f"Unknown area code(s): {''.join(bad)} (valid: {AREA_ORDER})")
    return "".join(c for c in AREA_ORDER if c in areas)


@dataclass
class PatchPlan:
    """The exact writes SRP would perform: list of (file offset, bytes)."""
    writes: list
    areas: str
    maker_bytes: bytes
    warnings: list


def plan_patch(info: ImageInfo, areas: str, maker: str | None = None,
               compat: bool = False, buf: bytes | None = None) -> PatchPlan:
    """Work out what SRP writes.  ``buf`` must be the first 1 MiB for RAW images."""
    areas = normalise_areas(areas)
    warnings = []
    if info.sector1_offset is None:
        raise SRPError("This image cannot be patched. You don't have a valid sector 1.")
    if info.max_areas == 0:
        raise SRPError("This image can not be patched (no valid area code found!)")
    if not areas:
        raise SRPError("Select at least one area code.")
    if len(areas) > info.max_areas:
        raise SRPError(f"Too many area codes: this image has room for {info.max_areas} "
                       f"(sector 1 area slots), you asked for {len(areas)} ({areas}).")

    maker = maker or info.maker
    if maker == "sega":
        maker_bytes = MAKER_SEGA
    elif maker == "tp":
        maker_bytes = MAKER_TP
    elif compat:
        # Original behaviour: no radio button selected -> three NUL bytes are written.
        maker_bytes = b"\x00\x00\x00"
        warnings.append("Maker ID is neither 'SEGA ENT...' nor 'SEGA TP ...'; like the original, "
                        "writing 00 00 00 over header bytes 0x15-0x17.")
    else:
        raise SRPError("Maker ID is neither 'SEGA ENTERPRISES' nor 'SEGA TP ...'. The original SRP would "
                       "overwrite header bytes 0x15-0x17 with zeros here. Pass --maker sega|tp, "
                       "or --compat to reproduce the original behaviour.")

    header_area = (areas + " " * 8)[:8].encode("ascii")
    slots = b"".join(AREA_BLOCKS[c] for c in areas) + BLOCK_SRP_NEW * 8
    slots = slots[:AREA_SLOT_SIZE * info.max_areas]

    h, s1 = info.header_offset, info.sector1_offset
    if not info.raw:
        writes = [(h + 0x15, maker_bytes), (h + 0x40, header_area), (s1 + AREA_SLOT_OFFSET, slots)]
        return PatchPlan(writes, areas, maker_bytes, warnings)

    # RAW image: SRP patches copies of sectors 0 and 1, rebuilds EDC/ECC, and
    # writes them back at file offsets 0 and 2352 (regardless of where it found them).
    if buf is None:
        raise ValueError("buf required for RAW images")
    if h < 16 or s1 < 16:
        raise SRPError("Image size is a multiple of 2352 (so SRP treats it as RAW) but the header is not "
                       "preceded by a raw sector header. The original SRP crashes on this file. "
                       "Use --format iso to patch it as a 2048-byte image.")
    if h != 16 or s1 != 16 + RAW_SECTOR:
        msg = (f"RAW image header found at 0x{h:X} / sector 1 at 0x{s1:X}; the original SRP still writes "
               f"the patched sectors to offsets 0x0 and 0x930")
        if not compat:
            raise SRPError(msg + ", which would corrupt this image. Use --compat to do it anyway.")
        warnings.append(msg + ".")
    sec0 = bytearray(buf[h - 16:h - 16 + RAW_SECTOR])
    sec1 = bytearray(buf[s1 - 16:s1 - 16 + RAW_SECTOR])
    if len(sec0) != RAW_SECTOR or len(sec1) != RAW_SECTOR:
        raise SRPError("Image is truncated inside sector 0/1.")
    for name, sec in (("0", sec0), ("1", sec1)):
        if sec[15] != 1:
            warnings.append(f"Sector {name} mode byte is {sec[15]}, not 1; EDC/ECC are rebuilt as Mode 1 anyway.")
    sec0[16 + 0x40:16 + 0x48] = header_area
    sec1[16 + AREA_SLOT_OFFSET:16 + AREA_SLOT_OFFSET + len(slots)] = slots
    sec0[16 + 0x15:16 + 0x18] = maker_bytes
    regenerate_edc_ecc(sec0)
    regenerate_edc_ecc(sec1)
    writes = [(0, bytes(sec0)), (RAW_SECTOR, bytes(sec1))]
    return PatchPlan(writes, areas, maker_bytes, warnings)


def patch_file(path: str, areas: str, maker: str | None = None, output: str | None = None,
               compat: bool = False, fmt: str | None = None) -> tuple:
    """Patch ``path`` in place (like SRP) or write a patched copy to ``output``."""
    size = os.path.getsize(path)
    with open(path, "rb") as f:
        buf = f.read(min(size, SCAN_LIMIT))
    info = analyse_bytes(buf, size, path)
    if fmt == "iso":
        info.raw = False
    elif fmt == "raw":
        info.raw = True
    plan = plan_patch(info, areas, maker, compat, buf)
    target = path
    if output:
        if os.path.abspath(output) != os.path.abspath(path):
            import shutil
            shutil.copyfile(path, output)
        target = output
    with open(target, "r+b") as f:
        for off, data in plan.writes:
            f.seek(off)
            f.write(data)
    return info, plan


# --------------------------------------------------------------------------
# Command line
# --------------------------------------------------------------------------

def _print_info(info: ImageInfo) -> None:
    print(f"File:            {info.path}")
    print(f"Size:            {info.size:,} bytes")
    print(f"RAW (2352):      {'YES' if info.raw else 'NO'}")
    print(f"Header offset:   0x{info.header_offset:X}")
    print(f"Sector 1 offset: " + ("not found" if info.sector1_offset is None else f"0x{info.sector1_offset:X}"))
    for k, v in info.fields.items():
        print(f"{k + ':':17}{v}")
    for k, v in info.pvd.items():
        print(f"{k + ':':17}{v}")
    slots = ", ".join(s or "-" for s in info.area_slots)
    print(f"Area slots:      {slots}")
    print(f"Maximum areas:   {info.max_areas}")
    print(f"Current areas:   {info.current_areas or '(none)'}")
    print(f"Maker type:      {({'sega': 'first party (SEGA ENTERPRISES)', 'tp': 'third party (SEGA TP)'}).get(info.maker, 'unknown')}")


def main(argv=None) -> int:
    p = argparse.ArgumentParser(prog="srp.py", description="Saturn Region Patcher (Python port of SRP v3.0GE)")
    p.add_argument("--version", action="version", version=f"%(prog)s {__version__}")
    sub = p.add_subparsers(dest="cmd", required=True)
    pi = sub.add_parser("info", help="show header and area information")
    pi.add_argument("image")
    pp = sub.add_parser("patch", help="patch area codes (in place unless -o is given)")
    pp.add_argument("image")
    pp.add_argument("-a", "--areas", required=True, help=f"area letters, any of {AREA_ORDER} (e.g. JUE)")
    pp.add_argument("-m", "--maker", choices=["sega", "tp"], help="also set maker ID to first party (sega) or third party (tp); default keeps the detected one")
    pp.add_argument("-o", "--output", help="write a patched copy here instead of patching in place")
    pp.add_argument("--format", choices=["iso", "raw"], help="override RAW detection (default: size multiple of 2352 = RAW)")
    pp.add_argument("--compat", action="store_true", help="reproduce the original's behaviour even where it damages the image")
    pp.add_argument("-n", "--dry-run", action="store_true", help="show what would be written without changing anything")
    args = p.parse_args(argv)
    try:
        if args.cmd == "info":
            _print_info(analyse(args.image))
            return 0
        if args.dry_run:
            size = os.path.getsize(args.image)
            with open(args.image, "rb") as f:
                buf = f.read(min(size, SCAN_LIMIT))
            info = analyse_bytes(buf, size, args.image)
            if args.format:
                info.raw = args.format == "raw"
            plan = plan_patch(info, args.areas, args.maker, args.compat, buf)
            for w in plan.warnings:
                print("warning:", w, file=sys.stderr)
            for off, data in plan.writes:
                print(f"would write {len(data):4d} bytes at 0x{off:X}")
            return 0
        info, plan = patch_file(args.image, args.areas, args.maker, args.output, args.compat, args.format)
        for w in plan.warnings:
            print("warning:", w, file=sys.stderr)
        print(f"File patched! Areas {info.current_areas or '(none)'} -> {plan.areas} "
              f"({'RAW, EDC/ECC rebuilt' if info.raw else 'ISO'}) -> {args.output or args.image}")
        return 0
    except (SRPError, OSError) as e:
        print("error:", e, file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
