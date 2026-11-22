# GAME BASIC and the Sega Saturn SDK: cross-reference

GAME BASIC is built on Sega's own libraries. The interpreter on the CD contains **SGL 2.12** (Sega Graphics Library, 1996-12-04), **BUP 1.21** (the backup-RAM library) and loads **SDDRVS.TSK**, Sega's 68000 sound driver 2.08 (see `../GAME_BASIC_CD/README.md`). Many GAME BASIC commands are a thin layer over these, so Sega's developer documentation explains a good deal of what the GAME BASIC manuals only describe.

This file lists what the Sega documents confirm or explain. It is a companion to `Reference_Manual_findings.md` and `Tutorial_Manual_findings.md`.

## Sources

The PDFs are in `Saturn/Development/Sega_Saturn_Development_Documentation/`, and the headers are in `Saturn/Development/SEGA_Saturn_Development_Tools.zip`. Page numbers are **PDF page numbers** (what a PDF viewer shows), not the printed page numbers, which restart in every chapter. The Sega documents are marked confidential, so they are referred to here and not copied.

| Short name | Document |
|---|---|
| SGL Ref | *Sega Saturn SGL Developer's Manual Reference.pdf* |
| SGL Tut | *Sega Saturn SGL Developer's Manual Tutorial.pdf* |
| SndDrv | *Sega Saturn Sound Driver Implementation Manual.pdf* (ST-241-042795) |
| Release Form | *Sega Saturn Master CD-ROM Release Form.pdf* |
| Demo Loader | *Sega Saturn Demo File Loader Specifications Version 1.20.pdf* |
| `SL_DEF.H` | `SGL Version 3.02J/INC/SL_DEF.H` in the Tools zip |
| `SEGA_PER.H` | `SBL Version 6.01/SEGALIB/INCLUDE/SEGA_PER.H` in the Tools zip |
| `SEGA_BUP.H` | `SGL Version 3.02J/INC/SEGA_BUP.H` in the Tools zip |

The headers come from SGL 3.02, a later version than the 2.12 in GAME BASIC. The constants below have not changed between versions as far as the manuals show.

**Not in the set.** The documentation set doesn't include the hardware manuals (SMPC, VDP1, VDP2, SCSP, SCU, CD block). So nothing here covers the communication port, the SH-2 serial interface or the BASTERM protocol, and it doesn't fully describe the keyboard's data or the `.WV` tone-bank format. The Address Checker, dAsms, SCU DSP Assembler and Simulator, Parameter Editor, Sound Box and Target Box manuals cover development hardware and tools, and they aren't relevant to GAME BASIC.

---

## 1. SETATR is SGL's ATTRIBUTE macro

SGL describes each polygon face with an `ATTRIBUTE(plane, sort, texture, color, gouraud, mode, dir, option)` macro (SGL Ref pp. 194 and 229–230, SGL Tut p. 114). GAME BASIC's `SETATR (<TYPE>,<SURFACE>,<SORT>,<texture ID>,<COLOR>,<MODE>)` (Ref. pp. 218–221) uses the same fields, with the same numbers in most of them.

| SETATR field | GAME BASIC values (Ref. pp. 219–220) | SGL equivalent (`SL_DEF.H`) |
|---|---|---|
| SURFACE | 0 one-sided, 1 two-sided | `plane`: `Singl_Plane` = 0, `Dual_Plane` = 1 |
| SORT | 0 previous polygon, 1 nearest, 2 farthest, 3 average | `sort`: `SORT_BFR` = 0, `SORT_MIN` = 1, `SORT_MAX` = 2, `SORT_CEN` = 3 |
| TYPE 0–3 | texture with no flip, left-right, up-down, both | `dir`: `sprNoflip`, `sprHflip`, `sprVflip`, `sprHVflip` (flip bits 4–5 plus `FUNC_Texture`) |
| TYPE 4, 5, 6 | polygon, polyline, line | `dir`: `sprPolygon`, `sprPolyLine`, `sprLine`, built on `FUNC_Polygon` = 4, `FUNC_PolyLine` = 5, `FUNC_Line` = 6 (the VDP1 command numbers) |
| Texture ID | SETTEX texture | `texture` (`texno`) |
| COLOR | palette offset, or RGB() for plain polygons | `color`: colour bank or palette number, or `C_RGB(r,g,b)` |
| MODE bits 0–1 | 0 overwrite, 1 shadow, 2 half-bright, 3 half-transparent | `CL_Replace` = 0, `CL_Shadow` = 1, `CL_Half` = 2, `CL_Trans` = 3 (VDP1 colour calculation) |
| MODE bit 3 | lit by the light source | `option`: `UseLight` = 1 << 3 |
| MODE bit 5 | use the palette for polygon colour | `option`: `UsePalette` = 1 << 5 |
| MODE bits 6–7 | window: 0 ignore, 1 inside (default), 2 outside | `mode`: `No_Window` = 0, `Window_In` = 2 << 9, `Window_Out` = 3 << 9 |
| MODE bit 8 | mesh | `mode`: `MESHon` = 1 << 8 (the same bit) |

What this clarifies:

- **SORT 0 is `SORT_BFR`.** The GAME BASIC manual describes it as using "the previous polygon's" point. SGL Tut p. 114 explains what it is for: the face is drawn just in front of the polygon registered last. That makes it a way to keep a decal or marking on top of the face behind it. SGL notes that it is rarely needed.
- **MODE keeps SGL's own bit positions** for draw mode, lighting, palette and mesh. Only the window setting is moved, from VDP1's bits 9–10 down to bits 6–7, with its values renumbered. That explains why the default MODE is 72 (64 = inside the window + 8 = lit).
- **Not exposed:** SGL's `CL_Gouraud` (4) draw mode and its Gouraud table, `UseNearClip`, `ECdis`, `SPdis` and the colour-mode bits. GAME BASIC fills in the colour mode itself from the texture's colour depth.
- **SGL Ref p. 230 has an error:** it labels `SPdis` "display transparent pixels (default)". In `SL_DEF.H`, `SPenb` (0) is the default and means transparent pixels aren't drawn. `SPdis` makes colour 0 an ordinary colour.

## 2. SETTEX data is in VDP1's native format

- **Widths in steps of 8** (SETTEX XS 8–504) are a hardware rule: "the Saturn hardware requires that the horizontal size be a multiple of 8" (SGL Tut p. 466). The 504 and 255 limits fit VDP1's sprite size field: 6 bits for width ÷ 8 and 8 bits for height. That last point is from general VDP1 knowledge, not from this document set.
- **32768-colour dots** are `0x8000 | B << 10 | G << 5 | R` in SGL's `RGB()` macro (`SL_DEF.H`). That is the same `&b1BBBBB_GGGGG_RRRRR` layout as SETTEX (Ref. p. 222), including bit 15, which must be set for the dot to show. The User Guide's `OR &H8000` rule comes from the hardware.
- **Colour banks.** SGL's default 16-colour texture mode is `CL16Bnk`, a colour bank, which is why SETATR's COLOR for a 16-colour texture is a palette offset in steps of 16.

**For the tools:** DXFCONV output and the PNG-to-SETTEX converter (`tools/saturn_bitmap.py`) produce data the hardware uses as it is. A converter for SGL (`.TEX`-style) data would need only header changes, not pixel conversion.

## 3. Polygon limits and the SGL work area

- SGL's defaults are `MAX_POLYGON` 1800, `MAX_VERTICES` 2500, `MAX_TRANSFER` 20 and `MAX_NEST` 20 (SGL Ref p. 232). "When a model is specified by slPutPolygon, that model is not processed if the total number of polygons or vertices (including that model) will exceed the respective maximum". Every sprite also counts as one polygon.
- SGL Ref p. 233 has the WORK RAM-H map: SGL's sort lists, sprite buffers, vertex buffer and master-to-slave command buffer start at 0x060C0000 by default, with the user area from 0x06004000.
- **The 16-generation limit** on OBJ parent chains (Ref. p. 203) may come from SGL's matrix stack (`MAX_NEST`, 20 by default). GAME BASIC's own stack could also be the cause, so this isn't proven.
- **Open:** the Reference Manual warns that an OBJECT with over about 1000 polygons can hang the sprite system (p. 147). That is below SGL's default of 1800, so GAME BASIC probably configures SGL with smaller tables, or the hang comes from something else. The interpreter's `slInitSystem` call (0x06062D30) and the SGL work-area settings would settle it.

## 4. Sound: GAME BASIC's model is the sound driver's

| GAME BASIC (Ref. ch. 2) | Sound driver and SGL |
|---|---|
| 468 KB of sound memory for the user (p. 244) | The driver's system area is fixed at 44 KB (SndDrv p. 9), and sound data starts at 0x25A0B000 (SndDrv p. 14, SGL Tut p. 275). 512 − 44 = 468 KB |
| 8 sequences, sequence 0 for BGM, EFFECT gets 1–7 | "Up to eight sequences can be played back simultaneously. In the SGL, of these eight sequences, No. 0 is allocated for background music" (SGL Tut p. 275). The driver has 8 sound-control numbers (SndDrv p. 22) |
| 32 slots shared by all songs | The 32-channel sound source is shared by sequences by priority (SGL Tut p. 275) |
| PLAYTEMPO: −32768 to 32767, 4096 doubles the speed and −4096 halves it (p. 280) | The driver's tempo value: "the tempo is doubled for every positive 1000h (4,096) and is halved for every negative 1000h" (SndDrv p. 22). PLAYTEMPO passes the value straight through |
| PLAYFADE rate, 0 = at once (p. 273) | Sequence volume command, fade rate 0–255, 0 = no fade (SndDrv p. 22) |
| PLAYPAN: low 3 bits ignored, 16 steps each side (p. 279) | The SCSP has 32 pan levels, 0–15 to one side and 16–31 to the other (SndDrv p. 55, section 7.2). GAME BASIC's −127…127 is cut down to that |
| `PLAYINIT "DSP"` 40 KB and `"DSPEXT"` 72 KB work areas | DSP work RAM must start on a 2000h (8 KB) boundary (SndDrv p. 9). 40 KB and 72 KB are 5 and 9 units of 8 KB, which is consistent with that rule |
| `SDDRVS.TSK` starts with SSP 0xA000, PC 0x1000 (CD analysis) | The system information table gives the 68K program area at 1000h, the 68K work area at 7000h–A000h and the sound area map at A000h (SndDrv p. 30) |

Not explained:

- **Volume range.** The driver's sequence volume is 0–127 with 127 the loudest. GAME BASIC's 0–255 with a default of 127, where 128 and up is "louder than the original", must be scaled by Bits Laboratory's own MML layer.
- **Song count.** The driver allows 16 sequence banks per area map (SndDrv p. 22). GAME BASIC's 251 songs are managed by its own layer.
- **The `.WV` banks.** SndDrv describes area maps (p. 48: 8-byte entries, up to 32 per map, FFh end codes) and says tone data is one of the three kinds of sound data. It doesn't give the tone data layout, so the `.WV` format stays undecoded. That format is in Sega's sound tools documentation (the tone editor and the SCSP manual), which isn't in this set.

Other driver features GAME BASIC doesn't expose: PCM streaming (up to 8 streams), CD-DA level control, MIDI direct output, Q Sound and Yamaha 3D sound (SndDrv pp. 38–51).

## 5. Backup RAM (BRAM: and CRAM:)

- GAME BASIC's `BRAM:` and `CRAM:` sit on Sega's backup library, which is stored compressed in the Saturn boot ROM (SGL Tut pp. 264–269). Device 0 is the internal 32 KB memory, and device 1 is a cartridge.
- A directory entry (`BupDir` in `SEGA_BUP.H`) holds an 11-character file name, a 10-character comment, a language code (0 Japanese, 1 English, 2 French, 3 German, 4 Spanish, 5 Italian), a packed date, the size in bytes and the size in blocks. The status (`BupStat`) gives the total and free size in bytes and blocks, and the block size.
- `FILES "BRAM:"` shows `Free size … / 512 file blocks` (User Guide section 8). 512 × 64 bytes is the internal 32 KB, so its "file blocks" are the backup library's own blocks.
- **Sega's naming rule** (Release Form p. 15): all 11 characters are used, only digits, capital letters and `_`, the first character can't be a digit, and the name is padded with `_`. GAME BASIC's settings file `GBASICSS_01` follows it. How GAME BASIC turns an 8.1 name such as `MYGAME.B` into an 11-character backup name, and what it puts in the comment field, hasn't been checked. Looking at a saved file in the Saturn's memory manager, or tracing the interpreter's BUP calls, would show it.
- Sega required games to disable the Reset button while writing backup memory (Release Form p. 9), and SGL's sample does the same with `slResetDisable()` (SGL Tut p. 269).

## 6. Peripherals: pad, mouse and keyboard

- **Pad bits** (SGL Tut pp. 203–205): byte 1 is →, ←, ↓, ↑, Start, A, C, B (bits 7–0), and byte 2 is R, X, Y, Z, L. A bit is 0 while pressed. SGL turns this into a 16-bit word, which is presumably what `PAD()` builds on.
- **Device IDs** (`SEGA_PER.H`): the high nibble is the type (0x0 digital, 0x1 analogue, 0x2 pointing, 0x3 keyboard, 0xE Mega Drive) and the low nibble is the data size in bytes. The **keyboard is 0x34**: type 3, 4 bytes.
- **Keyboard data** (SGL Ref p. 210 `PerKeyBoard`, `SEGA_PER.H` `PerKbdData`): the first two bytes are pad-style buttons, the third is a status byte and the fourth is the key code. The status bits are Caps Lock (bit 6), Num Lock (bit 5), Scroll Lock (bit 4), Make (bit 3) and Break (bit 0). The key codes themselves are in the SMPC hardware manual, which isn't in this set. This is useful for the keyboard reproduction in `Saturn/Keyboard/`.
- SGL's list of input devices (SGL Tut p. 203) still gives the keyboard as "details to be determined, compatible with IBM keyboards". The Release Form (p. 19) has a check-list for Shuttle Mouse support.

## 7. CD boot

- The Demo Loader specification describes the boot ROM's "first read" hook table at 0x06002270 and the SYSTEM ID save area at 0x06000CCC (Demo Loader pp. 5–9). These are the same boot-ROM structures that IP.BIN and the AIP loader use, so they help when reading `gbcd_extract.py`'s IP.BIN analysis. They don't change any conclusion in the CD analysis.
