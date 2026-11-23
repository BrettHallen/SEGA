# FDD Operator (HSS-0128)<br>FDDオペレーター

## セガサターンFDDオペレーター使用について
本CD-ROMはセガサターン専用フロッピーディスクドライブを使い本体からフロッピーディスクへのファイルのコピーやカートリッジからフロッピーディスクへのファイルのコピー、またはファイルの削除、フロッピーディスクのフォーマットを簡単に行えるようにしたものです。<br>
本CD-ROM付属のセガサターンFDDオペレーター取扱説明書をよく読み使用してください。

## About Using the Sega Saturn FDD Operator
This CD-ROM uses the dedicated Sega Saturn floppy disk drive to make it easy to copy files from the console to a floppy disk, copy files from a cartridge to a floppy disk, delete files, and format floppy disks.<br>
Please read the Sega Saturn FDD Operator instruction manual supplied with this CD-ROM carefully before use.<br>

## Redumper Log
```
% sudo ./redumper --drive=disk4 --image-name=FDD_BACKUP --overwrite --drive-sector-order=DATA_SUB
redumper (build: b773)

arguments: --drive=disk4 --image-name=FDD_BACKUP --overwrite --drive-sector-order=DATA_SUB
warning: drive not found in the database
warning: using generic drive
warning: drive doesn't support C2 error pointers

drive information
  path: disk4
  inquiry: PIONEER - BD-RW BDR-UD02D (revision level: 1.01, vendor specific: 13/09/26 PIONEER)
  configuration: GENERIC (read offset: +667, C2 shift: 0, pre-gap start: +0, read method: BE, sector order: DATA_SUB)
  profile: CD-ROM
  read speed: <optimal>

image path: .
image name: FDD_BACKUP

*** DUMP (time check: 0s)

disc TOC:
  track 1 {  data }
    index 01 { LBA:      0, MSF: 00:02:00 }
  track 2 { audio }
    index 01 { LBA:    616, MSF: 00:10:16 }
  track A { audio }
    index 01 { LBA:   2116, MSF: 00:30:16 }

- [  0%] LBA:      0/2116, errors: { SCSIs: 0, C2s: 0, Q: 0 }warning: unscrambled sector read
                                                             
media errors: 
  SCSI: 0 samples
  C2: 0 samples
  Q: 3

*** DUMP::EXTRA (time check: 8s)


*** PROTECTION (time check: 0s)

protection: none

*** REFINE (time check: 0s)


*** DVDKEY (time check: 0s)


*** SPLIT (time check: 0s)


correcting P... done
correcting Q... done

final TOC:
  track 1 {  data }
    index 00 { LBA: [  -150 ..     -1], length:    150, MSF: 00:00:00-00:01:74 }
    index 01 { LBA: [     0 ..    462], length:    463, MSF: 00:02:00-00:08:12 }
  track 2 { audio }
    index 00 { LBA: [   463 ..    615], length:    153, MSF: 00:08:13-00:10:15 }
    index 01 { LBA: [   616 ..   2115], length:   1500, MSF: 00:10:16-00:30:15 }
  track A { audio }
    index 01 { LBA:   2116, MSF: 00:30:16 }

warning: TOC / QTOC mismatch, track length (track: 2, LBA: 2116 <=> 2115)
warning: TOC / QTOC mismatch, track index 00 (track: A, LBA: 2116 <=> 2115)
warning: TOC / QTOC mismatch, track index 01 (track: A, LBA: 2116 <=> 2115)

final QTOC:
  track 1 {  data }
    index 00 { LBA: [  -150 ..     -1], length:    150, MSF: 00:00:00-00:01:74 }
    index 01 { LBA: [     0 ..    462], length:    463, MSF: 00:02:00-00:08:12 }
  track 2 { audio }
    index 00 { LBA: [   463 ..    615], length:    153, MSF: 00:08:13-00:10:15 }
    index 01 { LBA: [   616 ..   2114], length:   1499, MSF: 00:10:16-00:30:14 }
  track A { audio }
    index 01 { LBA: [  2115 ..   2115], length:      1, MSF: 00:30:15-00:30:15 }

analyzing... done (time: 2s)

data disc detected, offset configuration: 
  LBA:     -1 ->      0, MSF: 00:02:00, count:    466, offset: -667
  LBA:    465 ->    463, MSF: 00:08:13, count:      3, offset: +1260

non-zero  TOC sample range: [   -88200 ..  +1244208]
non-zero data sample range: [     -667 ..  +1187782]
Universal Hash (SHA-1): 5aad1788d7db2c6894dc95b5f5081bec88807e0c

warning: offset shift detected, to apply correction please use an option
disc write offset: -667

warning: incomplete pre-gap (session: 1, unavailable: 150/150)
warning: lead-in starts with unavailable sector (session: 1)
warning: lead-out ends with unavailable sector (session: 1)
checking tracks
done

writing tracks
done

CUE [FDD_BACKUP.cue]:
CATALOG 0000000000000
FILE "FDD_BACKUP (Track 1).bin" BINARY
  TRACK 01 MODE1/2352
    INDEX 01 00:00:00
FILE "FDD_BACKUP (Track 2).bin" BINARY
  TRACK 02 AUDIO
    INDEX 00 00:00:00
    INDEX 01 00:02:03


*** HASH (time check: 3s)

dat:
<rom name="FDD_BACKUP (Track 1).bin" size="1088976" crc="708aac1b" md5="f6afaca2cfd03b31736d4b471ab408bb" sha1="c4973e6f4d4d292472aaad585111b8c80b4033c8" />
<rom name="FDD_BACKUP (Track 2).bin" size="3887856" crc="66397448" md5="9698da7e47764d37d6744dce5b9db43c" sha1="ff94684a0465aac247cdaa91d613cb7823c0cab6" />

*** INFO (time check: 0s)

CD-ROM [FDD_BACKUP (Track 1).bin]:
  sectors count: 463
  mode1 sectors: 463

  REDUMP.INFO errors: 0

ISO9660 [FDD_BACKUP (Track 1).bin]:
  volume identifier: FDD_BACKUP
  PVD:
0320 : 20 20 20 20 20 20 20 20  20 20 20 20 20 31 39 39                199
0330 : 36 30 36 32 30 30 30 30  30 30 30 30 30 24 31 39   6062000000000$19
0340 : 39 36 30 36 32 30 30 30  30 30 30 30 30 30 24 30   96062000000000$0
0350 : 30 30 30 30 30 30 30 30  30 30 30 30 30 30 30 00   000000000000000.
0360 : 30 30 30 30 30 30 30 30  30 30 30 30 30 30 30 30   0000000000000000
0370 : 00 01 00 00 00 00 00 00  00 00 00 00 00 00 00 00   ................

SS [FDD_BACKUP (Track 1).bin]:
  build date: 1996-06-20
  version: 1.003
  serial: 610-6276
  region: Japan
  header:
0000 : 53 45 47 41 20 53 45 47  41 53 41 54 55 52 4E 20   SEGA SEGASATURN 
0010 : 53 45 47 41 20 45 4E 54  45 52 50 52 49 53 45 53   SEGA ENTERPRISES
0020 : 36 31 30 2D 36 32 37 36  20 20 56 31 2E 30 30 33   610-6276  V1.003
0030 : 31 39 39 36 30 36 32 30  43 44 2D 31 2F 31 20 20   19960620CD-1/1  
0040 : 4A 20 20 20 20 20 20 20  20 20 20 20 20 20 20 20   J               
0050 : 4A 20 20 20 20 20 20 20  20 20 20 20 20 20 20 20   J               
0060 : 53 45 47 41 20 53 41 54  55 52 4E 20 20 20 20 20   SEGA SATURN     
0070 : 46 44 44 20 4F 50 45 52  41 54 4F 52 20 20 20 20   FDD OPERATOR    
0080 : 20 20 20 20 20 20 20 20  20 20 20 20 20 20 20 20                   
0090 : 20 20 20 20 20 20 20 20  20 20 20 20 20 20 20 20                   
00A0 : 20 20 20 20 20 20 20 20  20 20 20 20 20 20 20 20                   
00B0 : 20 20 20 20 20 20 20 20  20 20 20 20 20 20 20 20                   
00C0 : 20 20 20 20 20 20 20 20  20 20 20 20 20 20 20 20                   
00D0 : 00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00   ................
00E0 : 00 00 10 00 00 00 00 00  00 00 00 00 00 00 00 00   ................
00F0 : 06 01 00 00 00 00 00 00  00 00 00 00 00 00 00 00   ................

*** END (time check: 0s)
```