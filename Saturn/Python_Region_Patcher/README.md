# SRP for Python: Saturn Region Patcher

`srp.py` is a cross-platform Python 3 port of [**SRP (Saturn Region Patcher) v3.0 Gold Edition** by Madroms (2004-2009)](https://madroms.satakore.com), the Windows-only VB.NET tool that changes the area (region) codes of Sega Saturn disc images.

It was reverse engineered from the IL of `SRP3.0GE.exe` (MD5 `c712e5a455555b73a341e5be7227bda7`). On every test case it writes **exactly the same bytes as the original**. That was checked by running the real executable under Mono next to the port (see [Verification](#verification)).

It needs only the Python standard library (3.8 or newer) and runs on macOS, Linux and Windows.

## Usage

```sh
python3 srp.py info  game.bin                 # show header, area slots, maximum areas
python3 srp.py patch game.bin -a JUE          # patch in place (like the original)
python3 srp.py patch game.iso -a U -o us.iso  # write a patched copy, leave the source untouched
python3 srp.py patch game.bin -a JTUE -m sega # also switch the maker ID to first party
python3 srp.py patch game.bin -a U -n         # dry run: list the writes only
```

| Option | Meaning |
|---|---|
| `-a/--areas` | Area letters, any of `J T U B K A E L`. They are always written in that order, so `UJ` becomes `JU`, as in the original. |
| `-m/--maker sega\|tp` | Like SRP's "Modify the header" radio buttons. It rewrites header bytes 0x15-0x17 to `ENT` (`SEGA ENTERPRISES`) or `TP ` (`SEGA TP ...`). The default keeps the detected type. |
| `-o/--output` | Patch a copy instead of the original file. |
| `--format iso\|raw` | Overrides RAW detection (see the edge cases below). |
| `--compat` | Reproduces the original's behaviour even where it damages the image. |
| `-n/--dry-run` | Shows the writes without changing anything. |

Area letters: 
- **J** Japan,
- **T** Taiwan and Philippines,
- **U** USA and Canada,
- **B** Brazil,
- **K** Korea,
- **A** Asia PAL,
- **E** Europe,
- **L** Latin America.

Image formats: any file containing the Saturn IP.BIN. A file whose size is a multiple of 2352 is treated as RAW (2352-byte sectors, e.g. `.bin` from a `.cue`, or `.img`). Anything else is treated as a 2048-byte image (`.iso`, track 1 `.bin` at 2048, and similar). This is the same rule SRP uses. For multi-track BIN/CUE sets, patch the data-track file.

## Area codes and console region

A disc boots only if its area letters include the console's region. The console's region is a 4-bit **area code** that the SMPC (315-5744) reads from four jumper pairs on the main board (pins 5-8, AC1-AC4). At boot the BIOS compares that code with the letters at IP.BIN 0x40. A region-patched disc and a jumper change are two ways to fix the same mismatch: patch the disc to add the console's letter, or change the console's code to match the disc.

Jumper names and locations below are for the PAL VA SD board (837-12135). See [../PAL_Jumpers/README.md](../PAL_Jumpers/README.md) for photos, pad locations and the step-by-step EUR to JAP change. Each pair is a +5V pad (bit = 1) and a GND pad (bit = 0): JP6/JP7 = AC1, JP8/JP9 = AC2, JP10/JP11 = AC3, JP12/JP13 = AC4. Open the old pad before bridging the other one.

| Code | Bits AC4-AC1 | Disc letter | Sector 1 text (Sega standard) | Region | Jumpers bridged |
|------|--------------|-------------|-------------------------------|--------|-----------------|
| 1    | 0001         | J           | For JAPAN.                    | Japan                      | JP6, JP9, JP11, JP13 |
| 2    | 0010         | T           | For TAIWAN and PHILIPINES.    | Asia NTSC                  | JP7, JP8, JP11, JP13 |
| 4    | 0100         | U           | For USA and CANADA.           | North America              | JP7, JP9, JP10, JP13 |
| 5    | 0101         | B           | For BRAZIL.                   | Central/South America NTSC | JP6, JP9, JP10, JP13 |
| 6    | 0110         | K           | For KOREA.                    | Korea                      | JP7, JP8, JP10, JP13 |
| A    | 1010         | A           | For ASIA PAL area.            | Asia PAL                   | JP7, JP8, JP11, JP12 |
| C    | 1100         | E           | For EUROPE.                   | Europe PAL                 | JP7, JP9, JP10, JP12 |
| D    | 1101         | L           | For LATIN AMERICA.            | Central/South America PAL  | JP6, JP9, JP10, JP12 |

Codes 0, 3, 7, 8, 9, B, E and F have no disc letter ("Sega reserved"), and the BIOS refuses to boot any disc with them (see below). The top bit (AC4, JP12) is set on every PAL code.

What the check does, in order (every failure returns -8, so the disc does not boot):

1. It reads the 4-bit area code (kept by the BIOS in a word at 0x06000248) and looks up the console's letter and its "For ..." block. **A reserved code (0, 3, 7, 8, 9, B, E, F) has no letter, so the check fails at once and no disc will boot**, whatever its header says.
2. It scans up to 10 bytes of the area field at IP.BIN 0x40 (loaded at 0x06002040). Spaces are skipped. Any byte other than `J T U B K A E L` fails the check. Each valid letter is counted, and the check fails if none of them is the console's letter.
3. For as many 32-byte blocks as letters counted, it compares the console's "For ..." block with the blocks at IP.BIN 0xE00 (0x06002E00). If one matches exactly, the check passes (returns 0 and stores 0x06002100 at 0x06000254). Otherwise it fails.

So a disc needs **both** the letter in the header and the matching "For ..." block in sector 1. That is why `srp.py` rewrites both. Each block starts with `A0 0E 00 09`, which is the SH-2 `bra` + `nop` pair that jumps over the text. That's presumably so the area blocks can sit inline in boot code that runs.

Sources: the BIOS disassembly above; the Sega Target Box manual (area codes 1, 4 and 12 for Japan, USA and Europe); the Sega VA0 service schematic (SMPC jumper inputs R50-R53 on pins 5-8, which gives the jumper bit order).

## What SRP actually does

All of this was read from the decompiled `TextBox1_TextChanged`, `Getcheckbox`, `Regionpatchbutton_Click` and `ECCEDCInit/EDCgenerate/ECCgenerate` methods.

**Analysis**
1. It rejects files under 7,344 bytes and reads only the first 1 MiB.
2. RAW means `file size % 2352 == 0`.
3. It finds the first `SEGA SEGASATURN ` (that offset is the header). From there it finds the 16-byte start of the security code `1E E1 64 4C 48 4C 48 4C 3A 84 C2 24 84 C1 23 9E` (sector 1). After that it finds the ISO9660 PVD `01 CD001 01 00`, which is only used to display dates and the volume label.
4. It reads the eight 32-byte **area code symbol blocks** at sector 1 + 0x600 (IP.BIN 0xE00). Each block that matches one of 11 known blocks counts as a slot. The known blocks are the 8 `A0 0E 00 09 "For JAPAN."`-style blocks, the two "Patched by SRP" fillers and `For SATHEADER.`. **Maximum areas = number of matching slots**. The pre-ticked areas come from these blocks, not from the header text.
5. The maker type is detected from header bytes 0x10-0x17 (`SEGA ENT` or `SEGA TP `).

**Patch** (you must pick between 1 and *maximum* areas):
- Header + 0x40, 8 bytes: the chosen letters in `JTUBKAEL` order, padded with spaces.
- Header + 0x15, 3 bytes: `ENT` or `TP `.
- Sector 1 + 0x600, 32 × *maximum* bytes: the chosen areas' blocks, then `Patched by SRP - Madroms` filler blocks.
- RAW only: it copies sectors 0 and 1, applies the changes above, and rebuilds the **Mode 1 EDC (0x810) and ECC P/Q (0x81C/0x8C8)** of both sectors. It then writes them back at file offsets 0 and 2352.

## Edge cases where the original misbehaves

The port matches the original on normal images. Where the original would damage the file or crash, the port stops with an explanation instead. `--compat` reproduces the original byte-for-byte anyway.

| Situation | Original SRP 3.0GE | `srp.py` |
|---|---|---|
| Maker ID is neither `SEGA ENT…` nor `SEGA TP …` | Writes `00 00 00` over header bytes 0x15-0x17 | Refuses unless you give `-m sega\|tp` (or `--compat`) |
| RAW image whose header is not at offset 16 (e.g. an extra leading sector) | Writes the patched sectors to offsets 0 and 2352 anyway, corrupting the image | Refuses unless `--compat` |
| 2048-byte image whose size happens to be a multiple of 2352 | Unhandled exception (crash) | Refuses; `--format iso` patches it correctly |
| More areas than slots, zero areas, no valid area block | Not possible in the GUI | Refuses with the GUI's message |

Not ported: the GUI-only features (reading a physical CD drive, TOC/track counts, the online database links and the TXT export). `info` shows the same header and PVD fields the GUI displays.

## Example
GAME BASIC:<br>
```
% python3 srp.py info GAME_BASIC.iso

File:            GAME_BASIC.iso
Size:            23,035,904 bytes
RAW (2352):      NO
Header offset:   0x0
Sector 1 offset: 0x800
Hardware ID:     SEGA SEGASATURN
Maker ID:        SEGA TP T-21
Product number:  T-2111G
Version:         V1.002
Release date:    19980416
Device info:     CD-1/1
Area codes:      J
Peripherals:     AEFGJKMSTZ
Title:           GAME BASIC for SEGASATURN                                                                                       
Volume label:    BASIC
Created:         1998/04/16 00:00:00:00
Modified:        1998/04/16 00:00:00:00
Area slots:      J, -, -, -, -, -, -, -
Maximum areas:   1
Current areas:   J
Maker type:      third party (SEGA TP)
```

```
% python3 srp.py patch GAME_BASIC.iso -a E -o GAME_BASIC_EUR.iso

File patched! Areas J -> E (ISO) -> GAME_BASIC_EUR.iso
```

```
% python3 srp.py info GAME_BASIC_EUR.iso

File:            GAME_BASIC_EUR.iso
Size:            23,035,904 bytes
RAW (2352):      NO
Header offset:   0x0
Sector 1 offset: 0x800
Hardware ID:     SEGA SEGASATURN
Maker ID:        SEGA TP T-21
Product number:  T-2111G
Version:         V1.002
Release date:    19980416
Device info:     CD-1/1
Area codes:      E
Peripherals:     AEFGJKMSTZ
Title:           GAME BASIC for SEGASATURN                                                                                       
Volume label:    BASIC
Created:         1998/04/16 00:00:00:00
Modified:        1998/04/16 00:00:00:00
Area slots:      E, -, -, -, -, -, -, -
Maximum areas:   1
Current areas:   E
Maker type:      third party (SEGA TP)
