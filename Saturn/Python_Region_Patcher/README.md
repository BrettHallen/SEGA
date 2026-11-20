# SRP for Python: Saturn Region Patcher

`srp.py` is a cross-platform Python 3 port of **SRP (Saturn Region Patcher) v3.0 Gold Edition** by Madroms (2004-2009), the Windows-only VB.NET tool that changes the area (region) codes of Sega Saturn disc images.

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

Area letters: **J** Japan, **T** Taiwan and Philippines, **U** USA and Canada, **B** Brazil, **K** Korea, **A** Asia PAL, **E** Europe, **L** Latin America.

Image formats: any file containing the Saturn IP.BIN. A file whose size is a multiple of 2352 is treated as RAW (2352-byte sectors, e.g. `.bin` from a `.cue`, or `.img`). Anything else is treated as a 2048-byte image (`.iso`, track 1 `.bin` at 2048, and similar). This is the same rule SRP uses. For multi-track BIN/CUE sets, patch the data-track file.

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

## Verification

- `tests/test_srp.py` has 22 unit tests, including **40 golden outputs recorded from the original `SRP3.0GE.exe`**. They cover ISO and RAW, 1-8 slots, first and third party, SRP-filler slots, gap slots, stale ECC and the `--compat` cases. Run them with:
  ```sh
  python3 -m unittest discover -s tests
  ```
- `oracle/` holds the harness used to run the original. `harness.cs` loads `SRP3.0GE.exe` under Mono + Xvfb, sets the file name and checkboxes, and invokes `Regionpatchbutton_Click`. Mono's VB runtime (mono-basic) doesn't implement `FileSystem.FileOpen/FileGet/FilePut/Seek` and can't parse `&H` hex strings. `Rewrite.cs` (Mono.Cecil) therefore redirects just those 35 call sites, in a *copy* of the exe, to `VbShim.cs`, which follows the documented .NET semantics. All other logic, including EDC/ECC, is the original IL. `compare_with_original.py` runs both tools on every case and diffs the outputs. The result was **46/46 identical**, both on synthetic images and on images built from the real SGL 3.02J sample `IP.BIN`.
- `tests/make_test_images.py` builds the test images (ISO + RAW with valid sync, MSF headers, EDC and ECC). It uses a synthetic IP.BIN, or a real one if you pass its path.

## Files

```
srp.py                         the tool (single file, stdlib only)
tests/test_srp.py              unit + golden tests
tests/golden_original_srp.json SHA-256 of original SRP outputs
tests/make_test_images.py      deterministic test image generator
oracle/                        Mono harness and comparison script used to verify against SRP3.0GE.exe
```
