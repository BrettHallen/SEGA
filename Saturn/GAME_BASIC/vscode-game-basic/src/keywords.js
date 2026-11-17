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
  'STRING$', 'STRW$', 'MSTR$', 'HEXBIN$', 'INKEY$', 'INPUT$', 'PEEK', 'PAD',
  'RGB', 'GETCHR', 'READCHR$', 'FILES$', 'LOF', 'LOC', 'ERR', 'FRE', 'TIME',
  'TIME$', 'DATE$', 'PLAYSTAT',
];

// Flow control
const CONTROL = [
  'IF', 'THEN', 'ELSE', 'ENDIF', 'GOTO', 'GOSUB', 'RETURN', 'ON', 'FOR', 'TO',
  'STEP', 'NEXT', 'END', 'STOP', 'RESUME', 'ERROR',
  'WHILE', 'WEND', 'CONT', // standard BASIC, not seen on the CD
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
  'LOCK', 'UNLOCK', 'ACTIVE', 'USERDATA',
  'SETVERTEX', 'SETPOLYGON', 'SETATR', 'OBJ', 'CAMERA', 'SETLIGHT', 'SETPERS',
  'BGM', 'PLAY', 'PLAYINIT', 'PLAYSTOP', 'PLAYFADE', 'PLAYTEMPO', 'SETSONG',
  'VOLUME', 'DSP', 'SKCLOSE', 'TARG', 'EG',
  // standard BASIC, not seen on the CD
  'LET', 'DEF', 'FN', 'RANDOMIZE', 'ERASE', 'KILL', 'LIST', 'LLIST',
  'MERGE', 'DELETE', 'RENUM', 'AUTO', 'TRON', 'TROFF', 'PRESET', 'SOUND',
  'GET', 'PUT', 'FIELD',
];

const OPERATORS = ['AND', 'OR', 'XOR', 'MOD', 'NOT', 'EQV', 'IMP'];

// Built-in functions and system values. Names ending in $ return strings.
const FUNCTIONS = [
  'ABS', 'ASC', 'CHR$', 'COS', 'SIN', 'SQR', 'SGN', 'INT', 'FIX', 'RND', 'XSIN',
  'XCOS', 'LEFT$', 'RIGHT$', 'MID$', 'LEN', 'STR$', 'VAL', 'INSTR', 'SPACE$',
  'STRING$', 'STRW$', 'MSTR$', 'HEXBIN$', 'INKEY$', 'INPUT$', 'PEEK', 'PAD',
  'RGB', 'GETCHR', 'READCHR$', 'FILES$', 'LOF', 'LOC', 'ERR', 'FRE', 'TIME',
  'TIME$', 'DATE$', 'PLAYSTAT',
  // standard BASIC, not seen on the CD
  'ATN', 'TAN', 'EXP', 'LOG', 'HEX$', 'OCT$', 'BIN$', 'TAB', 'SPC', 'CSRLIN',
  'POS', 'EOF', 'ERL', 'CINT', 'CSNG', 'CDBL',
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
