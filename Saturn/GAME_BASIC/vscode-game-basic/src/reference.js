'use strict';
// Per-command reference for hover and completion help.
//
// Each COMMANDS entry is filled in from the GAME BASIC manuals as pages are
// scanned. Give the syntax exactly as the manual writes it ([] = optional),
// a one-line summary, and where it came from, e.g. "Ref. p. 18" for the
// Reference Manual or "Tut. p. 50" for the Tutorial Manual. Words with no
// entry still get a plain "statement" / "function" hover.

const COMMANDS = {
  CLEAR: {
    syntax: 'CLEAR <n>,<n>,<n>   (e.g. CLEAR 0,64,64)',
    summary: 'Reserves the user area (USERDATA, POKE, PEEK) and the file area (largest file a program can read or write). A soft reset does CLEAR 0,64,64. Argument order to be confirmed from the CLEAR page.',
    source: 'Ref. pp. 7-8, 19',
  },
  FILES: {
    syntax: 'FILES "<device>:[<name>]"',
    summary: 'Lists files on BRAM:, CRAM:, FD0:, FD1:, COM: or CD:, then "Free size n / m file blocks". Wildcards ? and * are allowed; give the extension here.',
    source: 'Tut. pp. 29-30; Ref. p. 8',
  },
  FKEY: {
    syntax: 'FKEY <key 1-12>,<string>',
    summary: 'Defines a function key. At start-up F5 is RUN, F7 CONT, F12 CHR$(16) (Ctrl+P, the panic key).',
    source: 'Ref. p. 18',
  },
  FRE: {
    syntax: 'FRE(<n>)',
    summary: 'Free memory: 0 = program area, 1 = user area, 2 and 3 = file area.',
    source: 'Ref. pp. 7-8',
  },
  KPRINT: {
    syntax: 'KPRINT [(x,y[,xpitch,ypitch,halfwidth])],[FIX][string][;][,colour][,SCALE][,bgcolour]',
    summary: 'Prints kanji text. Needs KLOAD ON first; kanji strings have to come from the PC.',
    source: 'Tut. pp. 49-50',
  },
  LOAD: {
    syntax: 'LOAD "<device>:<name>"[,R][,M]',
    summary: 'Loads a program. ,R runs it; ,M merges it without NEW. BASTERM types LOAD "COM:TBASTERM.B".',
    source: 'Tut. pp. 29, 89, 152, 171',
  },
  OPEN: {
    syntax: 'OPEN "<device>:<name>" FOR {INPUT|OUTPUT|APPEND} AS [#]<1|2>',
    summary: 'Opens a data file (.D). At most 2 files can be open, as #1 and #2.',
    source: 'Ref. p. 9; TRANSFOR.B',
  },
  PUTSPRITE: {
    syntax: 'PUTSPRITE <n>,(x,y),<pattern>',
    summary: 'Draws sprite n at (x,y).',
    source: 'Tut. p. 53',
  },
  RENUM: {
    syntax: 'RENUM',
    summary: 'Renumbers the program from 100 in steps of 10 and updates GOTO/GOSUB targets.',
    source: 'Tut. p. 34',
  },
  RGB: {
    syntax: 'RGB(r,g,b)',
    summary: 'Colour value, 0-31 per channel = r + g*32 + b*1024. Texture colours need OR &H8000.',
    source: 'Tut. pp. 44, 66',
  },
  SAVE: {
    syntax: 'SAVE "<device>:<name>"',
    summary: 'Saves the program. Fails if backup RAM is full.',
    source: 'Tut. p. 29',
  },
  SCREEN: {
    syntax: 'SCREEN [mode][,text BG][,text colours][,frame unit]',
    summary: 'Screen mode 0-6. Text screen 39x26, bitmap 320x224. SCREEN 0 (Ctrl+P / F12) brings back the edit screen.',
    source: 'Tut. pp. 41-44; Ref. p. 15',
  },
};

// @NAME constants (Ref. pp. 11-14).
const OBJ = 'OBJ field';
const PAD = 'pad button bit';
const SND = 'sound parameter';
const CONSTANTS = {
  TYPE: [0, OBJ, 'object type'], FLAG: [1, OBJ, 'helper flags'], GROUP: [2, OBJ, 'object group'],
  XP: [4, OBJ, 'X position'], YP: [5, OBJ, 'Y position'], ZP: [6, OBJ, 'Z position'],
  XR: [8, OBJ, 'X rotation'], YR: [9, OBJ, 'Y rotation'], ZR: [10, OBJ, 'Z rotation'],
  XS: [12, OBJ, 'X scale'], YS: [13, OBJ, 'Y scale'], ZS: [14, OBJ, 'Z scale'],
  ATR: [16, OBJ, 'attribute ID'], POLYGON: [17, OBJ, 'polygon ID'], ORDER: [18, OBJ, 'move/rotate order'],
  TIME: [19, OBJ, 'display time'], PARENT: [20, OBJ, 'link: parent OBJ'], CHILD: [21, OBJ, 'link: child OBJ'],
  LEFT: [22, OBJ, 'link: older sibling'], RIGHT: [23, OBJ, 'link: younger sibling'],
  XV: [24, OBJ, 'X speed'], YV: [25, OBJ, 'Y speed'], ZV: [26, OBJ, 'Z speed'],
  XA: [28, OBJ, 'X acceleration'], YA: [29, OBJ, 'Y acceleration'], ZA: [30, OBJ, 'Z acceleration'],
  XL: [32, OBJ, 'X speed limit'], YL: [33, OBJ, 'Y speed limit'], ZL: [34, OBJ, 'Z speed limit'],
  XRV: [36, OBJ, 'X spin speed'], YRV: [37, OBJ, 'Y spin speed'], ZRV: [38, OBJ, 'Z spin speed'],
  XP0: [48, OBJ, '4-point sprite X0'], YP0: [49, OBJ, '4-point sprite Y0'],
  XP1: [50, OBJ, '4-point sprite X1'], YP1: [51, OBJ, '4-point sprite Y1'],
  XP2: [52, OBJ, '4-point sprite X2'], YP2: [53, OBJ, '4-point sprite Y2'],
  XP3: [54, OBJ, '4-point sprite X3'], YP3: [55, OBJ, '4-point sprite Y3'],
  XD: [56, OBJ, 'X on screen'], YD: [57, OBJ, 'Y on screen'], ZD: [58, OBJ, 'Z from screen'],
  RD: [59, OBJ, 'RADIUS/ZD'], GTEST: [60, OBJ, 'collision group'], RADIUS: [61, OBJ, 'collision radius'],
  COLIDIST: [62, OBJ, 'contact flag and distance'], COLIOBJ: [63, OBJ, 'OBJ touched'],
  MATRIX: [64, OBJ, 'perspective matrix'],
  PAD_A: ['&H400', PAD, 'A'], PAD_B: ['&H100', PAD, 'B'], PAD_C: ['&H200', PAD, 'C'],
  PAD_X: ['&H40', PAD, 'X'], PAD_Y: ['&H20', PAD, 'Y'], PAD_Z: ['&H10', PAD, 'Z'],
  PAD_R: ['&H80', PAD, 'R'], PAD_L: ['&H8', PAD, 'L'],
  PAD_RIGHT: ['&H8000', PAD, 'right'], PAD_LEFT: ['&H4000', PAD, 'left'],
  PAD_DOWN: ['&H2000', PAD, 'down'], PAD_UP: ['&H1000', PAD, 'up'], PAD_START: ['&H800', PAD, 'Start'],
  BEND: [0, SND, 'bend range'], LAYER: [1, SND, 'layers - 1'], TONE: [2, SND, 'tones - 1'],
  SN: [10, SND, 'start note'], EN: [11, SND, 'end note'], BN: [12, SND, 'base note'], FT: [13, SND, 'fine tune'],
  AR: [20, SND, 'attack rate'], DR: [21, SND, 'decay rate'], SR: [22, SND, 'sustain rate'],
  RR: [23, SND, 'release rate'], SL: [24, SND, 'sustain level'], EGHOLD: [25, SND, 'EG hold mode'],
  LSLINK: [26, SND, 'loop start link'], KS: [27, SND, 'key rate scaling'], SDIR: [30, SND, 'sound direct'],
  SB: [31, SND, 'source bit control'], SS: [32, SND, 'sound source control'], LOOP: [33, SND, 'loop control'],
  PCM8B: [34, SND, 'wave data word length'], LSA: [35, SND, 'loop start address'], LEA: [36, SND, 'loop end address'],
  RE: [50, SND, 'LFO reset'], LFOF: [51, SND, 'LFO frequency'], ALFOWS: [52, SND, 'amplitude LFO wave'],
  ALFOS: [53, SND, 'amplitude LFO depth'], PLFOWS: [54, SND, 'pitch LFO wave'], PLFOS: [55, SND, 'pitch LFO depth'],
  MDX: [60, SND, 'modulation input X (layer)'], MDY: [61, SND, 'modulation input Y (layer)'], MDL: [62, SND, 'modulation level'],
  ISEL: [70, SND, 'input select'], IMIX: [71, SND, 'input mix level'], DSEND: [72, SND, 'direct send level'],
  DPAN: [73, SND, 'direct pan'],
  REV: [0, 'effect', 'stereo reverb'], DEL: [1, 'effect', 'stereo delay'], DST: [2, 'effect', 'distortion'],
  SAW: [0, 'waveform', 'sawtooth'], SQU: [1, 'waveform', 'square'], TRI: [2, 'waveform', 'triangle'],
  NOISE: [3, 'waveform', 'noise'],
};

module.exports = { COMMANDS, CONSTANTS };
