// Created with Claude Opus 5.5, Nov 2026
// Guided by Brett Hallen
'use strict';
// GAME BASIC for SEGA SATURN keyword list.
//
// Every word here is a GAME BASIC keyword: it is in the interpreter's token
// table on the CD (GAME_BASIC_CD/README.md, "Tokenised program format"), in
// the Reference Manual's reserved-word list (pp. 9-10) and keyword index
// (pp. 416-421), or both. The only extras are AS, OUTPUT and APPEND, which
// OPEN uses as plain words. REM is handled as a comment, not a keyword.
// Standard BASIC words that GAME BASIC lacks (WHILE/WEND, DEF FN, TRON,
// SOUND, TAB and so on) are left out, as are TIME, TIME$ and MSTR$, which the
// CD's programs use as ordinary variables. The checker never reports an
// unknown word as an error.
//
// CONFIRMED groups the words by where they were first found: in use in the
// CD's sample programs, in the Tutorial Manual, or in the Reference Manual.
//
// If you change these lists, also update syntaxes/game-basic.tmLanguage.json
// (run `npm run grammar` to regenerate it from this file).

// Words seen in use in the 67 sample programs on the GAME BASIC CD
// (GAME_BASIC_CD/*.B), plus RUN / SAVE / NEW, which BASTERM types itself.
const CONFIRMED = [
  // control
  'IF', 'THEN', 'ELSE', 'ENDIF', 'GOTO', 'GOSUB', 'RETURN', 'ON', 'FOR', 'TO',
  'STEP', 'NEXT', 'END', 'RESUME', 'ERROR',
  // general statements
  'DATA', 'DIM', 'READ', 'RESTORE', 'PRINT', 'USING', 'INPUT', 'CLS', 'LOCATE',
  'COLOR', 'WIDTH', 'CLEAR', 'SWAP', 'POKE', 'BEEP', 'OPEN', 'CLOSE', 'AS',
  'OUTPUT', 'APPEND', 'FREAD', 'FWRITE', 'FILES', 'LOAD', 'SAVE', 'RUN', 'NEW',
  'BLOAD', 'BSAVE', 'GLOAD', 'KLOAD', 'TIMER',
  // graphics, sprites, text
  'SCREEN', 'LINE', 'PSET', 'CIRCLE', 'PAINT', 'PALETTE', 'COLOROFS', 'KPRINT',
  'PUTCHR', 'SETCHR', 'SETPFONT', 'SETTEX', 'TPROP', 'GCOPY', 'CCOPY', 'SCROLL',
  'ZOOM', 'ROTATE', 'ROTCENTER', 'ROTOVER', 'ROTPOS', 'ROTZOOM', 'MOSAIC',
  'PRIORITY', 'DISPLAY', 'SETDISP', 'SPRWINDOW', 'EFFECT', 'VSYNC', 'INTERVAL',
  'LOCK', 'UNLOCK', 'ACTIVE', 'USERDATA',
  // 3D polygons
  'SETVERTEX', 'SETPOLYGON', 'SETATR', 'OBJ', 'CAMERA', 'SETLIGHT', 'SETPERS',
  // sound
  'BGM', 'PLAY', 'PLAYINIT', 'PLAYSTOP', 'PLAYFADE', 'PLAYTEMPO', 'SETSONG',
  'VOLUME', 'DSP', 'SKCLOSE', 'TARG', 'EG',
  // operators
  'AND', 'OR', 'XOR', 'MOD',
  // functions and system values
  'ABS', 'ASC', 'CHR$', 'COS', 'SIN', 'SQR', 'SGN', 'INT', 'FIX', 'RND', 'XSIN',
  'XCOS', 'LEFT$', 'RIGHT$', 'MID$', 'LEN', 'STR$', 'VAL', 'INSTR', 'SPACE$',
  'STRING$', 'STRW$', 'HEXBIN$', 'INKEY$', 'INPUT$', 'PEEK', 'PAD',
  'RGB', 'GETCHR', 'READCHR$', 'FILES$', 'LOF', 'LOC', 'ERR', 'FRE',
  'DATE$', 'PLAYSTAT',
  // from the tutorial manual (p. 53, p. 55); AND! is also used on the CD
  'PUTSPRITE', 'AND!',
  // tutorial manual pp. 65-72; all but HEX$ are also used on the CD
  'OBJTYPE', 'OBJATR', 'OBJPOS', 'OBJTURN', 'FRAC', 'HEX$',
  // reference manual index: words we had from standard BASIC
  'ATN', 'BIN$', 'CINT', 'CONT', 'DELETE', 'ERL', 'EXP', 'KILL', 'LET', 'LIST',
  'LOG', 'POS', 'RANDOMIZE', 'RENUM', 'STOP', 'TAN',
  // reference manual index: new statements
  'EDIT', 'FIND', 'FKEY', 'FORMAT', 'GSAVE', 'LFO', 'OBJLINK', 'OBJROT',
  'OBJZOOM', 'PLAYCONT', 'PLAYPAN', 'PLAYPAUSE', 'RGBADD', 'RGBTO', 'SEEK',
  'SETSPRITE', 'SHIFT', 'TLIST', 'WINDOW',
  // reference manual reserved-word list (pp. 9-10) and operators (p. 4)
  'COPY', 'OFF', 'OPTION', 'VERTEXID', 'NOT', 'NOT!', 'OR!', 'XOR!',
  // reference manual index: new functions
  'ATRID', 'BINHEX$', 'BITW$', 'DSKF', 'MMLSTAT', 'PEEK$', 'POINT',
  'POLYGONID', 'READHEX$', 'SFRE', 'SPRITE$', 'TEXID', 'TFRE', 'VERSION',
  'WADD$', 'WANDOR$', 'WMUL$', 'WXOR$', 'XATN', 'XDIST', 'XSQR', 'XTAN',
];

// Flow control
const CONTROL = [
  'IF', 'THEN', 'ELSE', 'ENDIF', 'GOTO', 'GOSUB', 'RETURN', 'ON', 'FOR', 'TO',
  'STEP', 'NEXT', 'END', 'STOP', 'RESUME', 'ERROR', 'CONT',
];

// Statements and commands
const STATEMENTS = [
  'DATA', 'DIM', 'READ', 'RESTORE', 'PRINT', 'USING', 'INPUT', 'CLS', 'LOCATE',
  'COLOR', 'WIDTH', 'CLEAR', 'SWAP', 'POKE', 'BEEP', 'OPEN', 'CLOSE', 'AS',
  'OUTPUT', 'APPEND', 'FREAD', 'FWRITE', 'FILES', 'LOAD', 'SAVE', 'RUN', 'NEW',
  'BLOAD', 'BSAVE', 'GLOAD', 'KLOAD', 'TIMER',
  'SCREEN', 'LINE', 'PSET', 'CIRCLE', 'PAINT', 'PALETTE', 'COLOROFS', 'KPRINT',
  'PUTCHR', 'SETCHR', 'SETPFONT', 'SETTEX', 'TPROP', 'GCOPY', 'CCOPY', 'SCROLL',
  'ZOOM', 'ROTATE', 'ROTCENTER', 'ROTOVER', 'ROTPOS', 'ROTZOOM', 'MOSAIC',
  'PRIORITY', 'DISPLAY', 'SETDISP', 'SPRWINDOW', 'EFFECT', 'VSYNC', 'INTERVAL',
  'LOCK', 'UNLOCK', 'ACTIVE', 'USERDATA', 'PUTSPRITE',
  'SETVERTEX', 'SETPOLYGON', 'SETATR', 'OBJ', 'CAMERA', 'SETLIGHT', 'SETPERS',
  'OBJTYPE', 'OBJATR', 'OBJPOS', 'OBJTURN',
  'BGM', 'PLAY', 'PLAYINIT', 'PLAYSTOP', 'PLAYFADE', 'PLAYTEMPO', 'SETSONG',
  'VOLUME', 'DSP', 'SKCLOSE', 'TARG', 'EG',
  // reference manual index
  'LET', 'RANDOMIZE', 'KILL', 'LIST', 'DELETE', 'RENUM',
  'EDIT', 'FIND', 'FKEY', 'FORMAT', 'GSAVE', 'LFO', 'OBJLINK', 'OBJROT',
  'OBJZOOM', 'PLAYCONT', 'PLAYPAN', 'PLAYPAUSE', 'SEEK',
  'SETSPRITE', 'TLIST', 'WINDOW', 'COPY', 'OPTION', 'OFF',
  // statement and function (see DUAL below)
  'MID$', 'SPRITE$',
];

// AND!, OR!, XOR! and NOT! work on the fraction bits too (reference manual
// p. 4; AND! also tutorial manual p. 55 and the CD):
// N=(N+&H0.001) AND! &HFFFF.FFFC
const OPERATORS = ['AND', 'AND!', 'OR', 'OR!', 'XOR', 'XOR!', 'MOD', 'NOT', 'NOT!'];

// Built-in functions and system values. Names ending in $ return strings.
const FUNCTIONS = [
  'ABS', 'ASC', 'CHR$', 'COS', 'SIN', 'SQR', 'SGN', 'INT', 'FIX', 'RND', 'XSIN',
  'XCOS', 'LEFT$', 'RIGHT$', 'MID$', 'LEN', 'STR$', 'VAL', 'INSTR', 'SPACE$',
  'STRING$', 'STRW$', 'HEXBIN$', 'INKEY$', 'INPUT$', 'PEEK', 'PAD',
  'RGB', 'GETCHR', 'READCHR$', 'FILES$', 'LOF', 'LOC', 'ERR', 'FRE',
  'DATE$', 'PLAYSTAT', 'FRAC', 'HEX$',
  // reference manual index
  'ATN', 'TAN', 'EXP', 'LOG', 'BIN$', 'POS', 'ERL', 'CINT',
  'ATRID', 'BINHEX$', 'BITW$', 'DSKF', 'MMLSTAT', 'PEEK$', 'POINT',
  'POLYGONID', 'READHEX$', 'SFRE', 'SPRITE$', 'TEXID', 'TFRE', 'VERSION',
  'WADD$', 'WANDOR$', 'WMUL$', 'WXOR$', 'XATN', 'XDIST', 'XSQR', 'XTAN',
  'VERTEXID', 'RGBADD', 'RGBTO',
  // a system value with no arguments, like ERR and VERSION (interpreter
  // token flags 0x0042)
  'SHIFT',
  // statement and function (see DUAL below)
  'OBJ', 'PALETTE', 'TPROP', 'USERDATA',
];

// Words the interpreter's token table marks as both statement and function
// (flags 0x025A, 0x0238, 0x0252, 0x0218), such as OBJ(1,4)=10 and
// A=OBJ(1,4). They are in both STATEMENTS and FUNCTIONS. Highlighting shows
// the string ones (MID$, SPRITE$) as functions and the others as statements,
// their more common use.
const DUAL = ['OBJ', 'PALETTE', 'TPROP', 'USERDATA', 'MID$', 'SPRITE$'];

// Words after which a line number or *label is a jump target.
const JUMP_WORDS = ['GOTO', 'GOSUB', 'THEN', 'ELSE', 'RESTORE', 'RUN', 'RESUME', 'LIST', 'DELETE'];

function uniq(list) {
  return [...new Set(list)].sort();
}

module.exports = {
  CONFIRMED: uniq(CONFIRMED),
  CONTROL: uniq(CONTROL),
  STATEMENTS: uniq(STATEMENTS.filter((w) => !CONTROL.includes(w))),
  OPERATORS: uniq(OPERATORS),
  FUNCTIONS: uniq(FUNCTIONS),
  DUAL: uniq(DUAL),
  JUMP_WORDS: uniq(JUMP_WORDS),
  ALL: uniq([...CONTROL, ...STATEMENTS, ...OPERATORS, ...FUNCTIONS]),
};
