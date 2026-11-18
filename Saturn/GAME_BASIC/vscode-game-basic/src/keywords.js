'use strict';
// GAME BASIC for SEGASATURN keyword list.
//
// The GAME BASIC manual is not in this project, so the list was built from
// how the CD's own sample programs use each word (statement position, never
// assigned to, called like a function). Words marked "not seen on the CD"
// are standard BASIC that GAME BASIC may or may not have. Highlighting a
// word that GAME BASIC lacks does no harm, and the checker never reports an
// unknown word as an error.
//
// The GAME BASIC Tutorial Manual (scanned into ../Documentation) has since
// added PUTSPRITE, the fixed-point operator AND!, OBJTYPE, OBJATR, OBJPOS,
// OBJTURN and FRAC, and confirmed HEX$; they are listed in CONFIRMED with a
// "tutorial manual" note.
//
// The Reference Manual's index (pp. 416-421) lists every GAME BASIC command.
// Words from it are listed under "reference manual index" below. Standard
// BASIC words that are not in the index (WHILE/WEND, DEF FN, TRON, SOUND, TAB
// and so on) were removed, as were TIME and MSTR$, which the CD's programs
// use as ordinary variables, and TIME$.
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
  'OBJZOOM', 'PLAYCONT', 'PLAYPAN', 'PLAYPAUSE', 'RGBADD', 'RGBTO', 'SEEK',
  'SETSPRITE', 'SHIFT', 'TLIST', 'WINDOW', 'COPY', 'OPTION', 'OFF',
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
  'VERTEXID',
];

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
  JUMP_WORDS: uniq(JUMP_WORDS),
  ALL: uniq([...CONTROL, ...STATEMENTS, ...OPERATORS, ...FUNCTIONS]),
};
