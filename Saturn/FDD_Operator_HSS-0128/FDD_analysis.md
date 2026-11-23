# Saturn floppy drive (HSS-0128): how it works

Analysis of the **FDD Operator** CD (610-6276 V1.003, 1996-06-20) and the Saturn BIOS backup library that it, and GAME BASIC's `FD0:`/`FD1:`, use to drive the floppy.

## Short version

- **The FDD Operator CD holds no floppy driver.** `BK1.BIN` is a front end (menus, copy, delete, format) that calls SEGA's standard backup library (BUP) with device 2, the "serial device". BUP lives **compressed inside the Saturn BIOS ROM**, so the floppy protocol is in the BIOS, not on the CD.
- **The Saturn never sees tracks or sectors.** It sends file-level commands (status, select partition, format, directory, read, write, delete) over the master SH-2's serial port in clocked synchronous mode. The drive's own controller turns those into disk I/O and owns the on-disk filesystem.
- So **the disk format can't be learned from Saturn code at all**. It has to come from imaging floppies (see [Imaging the floppies](#imaging-the-floppies)).
- Packets are framed by a start byte (`0x80` command, `0x40` argument block, `0x10` data block, `0x20` drive reply) and end in a 32-bit CRC field whose low 16 bits are **CRC-16/CCITT-FALSE** (poly 0x1021, init 0xFFFF) over everything before them. Checked by running the BIOS's own routines in an emulator.
- A disk has **2 partitions** (GAME BASIC's `FD0:` and `FD1:`). Files are backup-RAM style records: 11-byte name, 10-byte comment, language byte, date, size. A GAME BASIC save on floppy should therefore be the same kind of record it writes to `BRAM:`.

## What's on the CD

The data track is ISO9660 with four files:

| File | Size | Contents |
|---|---|---|
| `BK1.BIN` | 587,008 | The program: raw SH-2 code loaded at 0x06010000 (IP.BIN 1st read address), not compressed. Code is about the first 0x14000 bytes, then zeros, then graphics from about 0x80000 |
| `BKUP_ABS.TXT` | 398 | Abstract (Shift-JIS): "Using the Sega Saturn FDD Operator. With the Sega Saturn floppy disk drive, this CD-ROM makes it easy to copy files from the console or a cartridge to a floppy disk, delete files and format floppy disks." |
| `BKUP_BIB.TXT` | 20 | `SEGA SATURN BOOTROM` |
| `BKUP_CPY.TXT` | 52 | `(C) SEGA ENTERPRISES,LTD 1996 SYSTEM R&D DEVELOPMENT` |

Track 2 is audio (the usual "this is a Saturn disc" warning track).

Extraction used `iso_root_files()` from `GAME_BASIC/tools/gbcd_extract.py` after stripping the 2352-byte raw sectors to 2048, and the listing used `gbcd_disasm.py` with its base address set to 0x06010000 (about 23,000 instructions found).

### The BUP calls in `BK1.BIN`

At 0x06017670–0x060179A0 is SBL's standard BUP stub. Each wrapper:

1. saves the interrupt level and raises it to 15,
2. on the first nested call sends SMPC command `0x1A` (RESDISA, reset button off) and swaps the BIOS's `SYS_SETSCUIM`/`SYS_CHGSCUIM` vectors (0x06000340/0x06000344) for an `rts`,
3. calls through the BUP vector table at `*0x06000354` (+4 `BUP_SelPart` … +40 `BUP_SetDate`, exactly as in `SEGA_BUP.H` from SBL 6.01),
4. undoes 2 with SMPC `0x19` (RESENA) and restores the interrupt level.

The program calls `BUP_Init(lib=0x060F0000, work=0x06024A78, cfg=0x06026A78)` at 0x06014A40, then works with devices 0 (console), 1 (cartridge) and 2 (floppy).

## Where the driver is: the BIOS backup library

`BUP_Init` is `*0x06000358`, which the BIOS reset code fills from a table in ROM (ROM 0x958 → 0x0007D600). That stub calls the BIOS decompressor (`*0x000005F8`, 0x1F04 in the 1994-11-15 BIOS) on the module at `*0x0600035C` (ROM 0x7D660) into the caller's 16 KB library area, then jumps to it.

I couldn't find the compressed format documented, so `tools/sh2emu.py` (a small SH-2 interpreter) runs the BIOS's own decompressor. `tools/bup_unpack.py` does the whole job:

```
python3 tools/bup_unpack.py ../Development/Sega_Saturn_BIOS_1994_11_15.bin bup.bin
# module at ROM 0x7D660: 14394 bytes
```

The result is position-independent code, so it is the same at any load address. The US 1.00 (1994-11-15) library is 14,394 bytes; the JP 1.003 (1994-10-12) one is 14,386 and differs slightly. The notes below are from the US one. The unpacked libraries and their annotated listings are kept in [`BIOS_BUP/`](BIOS_BUP/) for analysis and preservation: `BUP_BIOS_1994-11-15_US.s`/`.bin`, `BUP_BIOS_1994-10-12_JP.s`/`.bin`, and `bup_symbols.txt` with the routine names used here (the US listing carries them).

Library map (offsets from the load address):

| Offset | Routine |
|---|---|
| 0x0000 | Entry: fills the vector table in the work area, detects devices |
| 0x02C4 / 0x03AA / 0x0672 / 0x0A78 | `BUP_SelPart` / `BUP_Format` / `BUP_Stat` / `BUP_Write` |
| 0x135A / 0x16DC / 0x18B4 / 0x1ACC | `BUP_Read` / `BUP_Delete` / `BUP_Dir` / `BUP_Verify` |
| 0x1E70 / 0x1F64 | `BUP_GetDate` / `BUP_SetDate` |
| 0x2010–0x20A3 | Cartridge flash ID (`AA`/`55`/`90` at 0x2400AAAB/0x24005555) and delays |
| 0x20C4 | **Floppy probe** at init |
| 0x2140 | Serial error recovery |
| 0x21D8 | **Send packet** |
| 0x22AA | **Receive packet** |
| 0x2484 / 0x2568 / 0x25B2 | Send command and get the immediate reply / wait for the final reply / command 0x00 |
| 0x25C8 / 0x266E / 0x2732 / 0x279C | Floppy stat (0x10) / select partition (0x11) / format (0x20) / delete (0x30) |
| 0x2860 / 0x2C08 | Directory stream parser / directory (0x40) |
| 0x2D82 / 0x2FD0 | Data receive / read (0x41) |
| 0x30DE / 0x32A6 | Data send / write (0x50) |
| 0x3478 | CRC |

## The link

### Port and clocking

The floppy uses the master SH-2's SCI (0xFFFFFE00 SMR … 0xFFFFFE05 RDR) on comm port pins 5 (TXD), 6 (RXD), 7 (SCK) and 8 (GND), as in [`Communication_Port_DA15/README.md`](../Communication_Port_DA15/README.md).

- **Mode.** `SMR = 0x80`: clocked synchronous, 8-bit, clock divider 1.
- **Saturn sending.** `SCR = (SCR & 0x0C) | 0x20`: TE on with CKE1 = 0, so the **Saturn drives SCK**. The rate comes from `BRR`, which is 0x10 at the probe and is then set to **byte 6 of the drive's reply to command 0x11** (0x10 if that byte is 0). The drive chooses the Saturn's speed. Each byte is polled out (wait for TDRE, write TDR, clear TDRE); after the last one the code waits for TEND and turns TE off.
- **Saturn receiving.** `SCR = (SCR & 0x0C) | 0x12`: RE on with CKE1 = 1, so the **drive drives SCK**. That's the half-duplex, swap-the-master scheme Freedman describes (Saturn about 100 kHz, drive about 500 kHz).
- **Interrupts.** For each receive, the SCU interrupt mask is saved to work+108 and everything is masked through `SYS_SETSCUIM(-1)`. All I/O is polled.
- **Timeouts and errors.** Errors come back as internal codes:

| Code | Meaning |
|---|---|
| 0x101 | Receive timeout |
| 0x102 | CRC mismatch |
| 0x103 | Parity error |
| 0x104 | Framing error |
| 0x105 | Overrun |
| 0x106 | Transmit timeout |
| 0x107 | Bad reply |
| 0x108 | Directory table too small |

  0x101 and 0x106 surface to the program as `BUP_NON` (no device).

### CRC

Every packet ends in a 4-byte field, `00 00 hi lo`. `hi lo` is CRC-16/CCITT-FALSE over all bytes before it, including the two zero bytes. The BIOS computes it four bits at a time with a multiply by 0x01102100 (= 0x1021 << 12 plus a byte-clear term). Feeding the BIOS's send routines random data in the emulator gives, for example:

```
command: 80 11 00 00 | 00 00 74 3B          CRC(80 11 00 00 00 00) = 0x743B
data:    10 FF 00 14 <20 bytes> | 00 00 08 57
```

That fits Freedman's "CRC16 CCITT (0xFFFF), sent as 32 bits with the upper 16 bits zero, which are part of the calculation".

### Packet types

| Start byte | Direction | Layout (before the 4-byte CRC field) |
|---|---|---|
| `0x80` command | Saturn → drive | `80 cmd a1 a2`. For select partition and format, a2 is the partition. For 0x10 the library puts a 32-bit value in bytes 2–5, which covers the CRC's zero bytes (see the open questions) |
| `0x40` argument block | Saturn → drive | `40 00 00 00` + 32 bytes of fields (below) |
| `0x10` data block | both | `10 flag lenHi lenLo` + data. flag `0x00` = more blocks follow, `0xFF` = last block. At most 4096 bytes per block |
| `0x20` reply | drive → Saturn | `20 x s e`: s = 0xFF on the **final** reply of a command (anything else is the immediate acknowledgement), e = error code |

Every command starts with a command packet answered at once by a `0x20` reply (s must not be 0xFF, e must be 0). It may have an argument block (also acknowledged) and data blocks, and ends with a final `0x20` reply (s = 0xFF) that the Saturn waits for for up to about 0x1400000 polls.

### Drive error codes and their BUP results

| e | Meaning | BUP result |
|---|---|---|
| 0x00 | OK | 0 |
| 0x21 | No disk | 1 `BUP_NON` |
| 0x23 | Write protected | 3 `BUP_WRITE_PROTECT` |
| 0x24 | Partition not formatted | 2 `BUP_UNFORMAT` |
| 0x30 | File not found (Freedman) | not checked in the code |
| 0x31 | Disk full | 4 `BUP_NOT_ENOUGH_MEMORY` |
| 0x42 | Drive saw a bad CRC | |

### Commands

| Cmd | BUP call | Exchange |
|---|---|---|
| `0x00` | (internal) | Plain status poll |
| `0x10` | `BUP_Stat` | Command with a 32-bit value → 18-byte data reply: free bytes, free blocks, and the number of items of the requested size that fit (copied from data+4, +8, +12) → final reply |
| `0x11` | `BUP_SelPart`, probe | a2 = partition → 26-byte data reply (below) → final reply |
| `0x20` | `BUP_Format` | a2 = partition → final reply (can take a long time). Formats **only that partition**, which matches GAME BASIC's `FORMAT "FD1:"` |
| `0x30` | `BUP_Delete` | Argument block with the name at bytes 4–14 → final reply |
| `0x40` | `BUP_Dir` | Argument block with the name filter (11) and table size → stream of 32-byte entries: name 11, comment 10, language 1, blocks 2, date 4, bytes 4. The library unpacks each into a 36-byte `BupDir` |
| `0x41` | `BUP_Read`/`BUP_Verify` | Argument block with the name → data blocks → final reply |
| `0x50` | `BUP_Write` | Argument block (name 4–14, comment 16–25, language 26, date 28–31, size 32–35) → reply (e ≠ 0 aborts) → data blocks in chunks of the drive's block size, each answered by a final reply |

**Reply to `0x11`** (bytes after the `20 …` header):

| Byte | Meaning |
|---|---|
| 4 | Unit ID (becomes `BupConfig[2].unit_id`) |
| 5 | Partition count (becomes `BupConfig[2].partition`; 2 on a real drive) |
| 6 | **SCI BRR value** for the Saturn to use |
| 7 | Unknown |
| 8–11 | Total size |
| 12–15 | Total blocks |
| 16–17 | Block size |
| 18–19 | Transfer chunk size (stored at work+104; 0x1000 per Freedman) |
| 20–23 | Unknown |

At init the library selects partition 0 with 0x11 (retrying once). If that works, device 2 exists, and the floppy's unit ID and partition count go into the caller's config table. With no drive (timeout), device 2 reads as not connected.

## How GAME BASIC saves land on disk

GAME BASIC's `FD0:` and `FD1:` are BUP device 2, partitions 0 and 1. It goes through the same library and calls as for `BRAM:`/`CRAM:`. So a program saved to floppy is a BUP file record exactly like one in backup RAM: an 11-character BUP name, a 10-character comment, language, date and size, with the data starting with the `SSBASIC50 ` header ([`GAME_BASIC_CD/README.md`](../GAME_BASIC/GAME_BASIC_CD/README.md)). The Reference Manual's warning about two files "with the same comment name" in a partition suggests the BASIC file name is kept in the comment field, with a generated BUP name (the interpreter uses a `GBASICSS_` prefix for its own saves). This needs confirming, and the floppy images will do it.

Where those bytes then go on the platter is up to the drive's firmware. Freedman notes that the drive uses "standard PC floppy disks … but a normal computer is unable to read data written to the disks", so expect standard MFM media with a non-FAT layout, or a non-standard sector layout.

## Imaging the floppies

**Please use a flux-level reader (Greaseweazle or KryoFlux), not a USB floppy drive.** A USB drive only reads standard PC formats (720K/1.44M with 512-byte sectors), and it fails without telling you why if the drive's controller writes anything else. A flux dump keeps everything, and if the disk turns out to be ordinary MFM we can convert it to a plain sector image afterwards.

Greaseweazle (v1.x software):

```
gw read --tracks=c=0-81:h=0-1 --revs=3 disk01.scp      # raw flux, the master copy
gw read --format=ibm.scan disk01.img                     # optional: tries any IBM MFM layout
```

For KryoFlux, a stream dump (`dtc -fdisk01/track -i0`) of tracks 0–81, both sides.

Test set, each with a short note of what it holds (name, comment, size, which partition):

1. **Blank:** fresh disk formatted by FDD Operator (both partitions).
2. **One GAME BASIC program in `FD0:`** with known contents. A tiny `10 PRINT "HELLO"` is ideal, plus its `BRAM:` copy if you can, to compare.
3. **The same disk after saving a second, larger program to `FD1:`.**
4. **The same disk after deleting the first file.**
5. One of your existing disks with known contents.

Also please note whether the disks are HD (a second square hole) or DD, and the label on the drive's mechanism if visible. Imaging the same disk before and after each change shows directly where the directory, allocation data and file data live.

## Open questions

- **Clock rates.** The SH7604's synchronous rate is Pφ/(4(N+1)). The exact Pφ on the Saturn and the BRR the drive sends back (Freedman's capture suggests 0x05) should be checked with a logic analyser.
- **Command 0x10.** The library puts a 32-bit value (the caller's data size) into bytes 2–5, where the CRC field's upper zero bytes would sit. Freedman describes 0x10 as taking no argument. It needs a capture.
- **Disk layout.** Physical format, filesystem and how the two partitions split the disk: this needs the images.
- **Drive hardware.** The drive's MCU and firmware. A ROM dump would answer the format question outright.

## Sources and files

- `tools/sh2emu.py`: small SH-2 interpreter (integer instructions, ROM/WRAM map).
- `tools/bup_unpack.py`: unpacks BUP from a BIOS ROM.
- Listings were made with `GAME_BASIC/tools/gbcd_disasm.py` at bases 0x06010000 (`BK1.BIN`) and 0x060F0000 (BUP, in `BIOS_BUP/`), which follows `bsrf`/`braf` targets and takes `--base`/`--title` for raw images (see `GAME_BASIC/tools/README.md` for the exact BUP command). `bup_symbols.txt` names the US library's routines; `bup_symbols_JP.txt` only the JP entry point so far.
- SBL 6.01 `SEGALIB/INCLUDE/SEGA_BUP.H` and `SEGASMP/MAN/MANBUP.DOC` ("Z button: Select Serial device").
- Sanford T. Freedman, *Sega Saturn Floppy Disk Drive Communication Protocol* v1.4 (2016). It agrees with the code on start bytes, command IDs, block format, 4096-byte blocks, CRC and error codes.
