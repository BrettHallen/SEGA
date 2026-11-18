'use strict';
// Per-command reference for hover and completion help.
//
// Each COMMANDS entry is filled in from the GAME BASIC manuals as pages are
// scanned. Give the syntax exactly as the manual writes it ([] = optional),
// a one-line summary, and where it came from, e.g. "Ref. p. 18" for the
// Reference Manual or "Tut. p. 50" for the Tutorial Manual. Words with no
// entry still get a plain "statement" / "function" hover.

const COMMANDS = {
  ABS: {
    syntax: 'ABS(<numeric expression>)',
    summary: 'Absolute value. The result keeps the type of the argument (fixed or float).',
    source: 'Ref. p. 24',
  },
  ASC: {
    syntax: 'ASC(<string expression>)',
    summary: 'Character code of the first character of the string (fixed point).',
    source: 'Ref. p. 24',
  },
  ATN: {
    syntax: 'ATN(<ratio>)',
    summary: 'Arctangent in radians, returned as float. A fixed-point argument is converted to float first.',
    source: 'Ref. p. 25',
  },
  'BIN$': {
    syntax: 'BIN$(<numeric expression>[,<suppress>])',
    summary: 'Number to binary string, with "." between the integer and fraction parts. A value that is not negative gets a leading space, a negative one a "-". Suppress pads with 0s: 0 = none (default), 1 = integer part, 2 = fraction part, 3 = both. BIN$(123.25) gives " 1111011.01".',
    source: 'Ref. pp. 25-26',
  },
  'BINHEX$': {
    syntax: 'BINHEX$(<source string>[,<separator>])',
    summary: 'Treats the string as binary data and returns 2 hex digits per character. Only the first character of the separator is used, placed between each pair. BINHEX$("ABC",",") gives "41,42,43".',
    source: 'Ref. pp. 26-27',
  },
  'BITW$': {
    syntax: 'BITW$(<source string>,<input bit width>,<output bit width>[,<add value>])',
    summary: 'Re-packs string data from one bit width to another (4, 8 or 16), adding the add value to each item. Used to convert the colour depth of dot data. Fractions are truncated.',
    source: 'Ref. pp. 27-28',
  },
  'CHR$': {
    syntax: 'CHR$(<character code>)',
    summary: 'The character for a code 0-255 (fraction truncated). Codes 0-31 are control codes: &H05 erase to end of line, &H09 tab (8 columns), &H0A line feed, &H0B home, &H0C clear screen, &H0D carriage return, &H13 scroll down, &H1C-&H1F cursor right/left/up/down.',
    source: 'Ref. p. 28',
  },
  CINT: {
    syntax: 'CINT(<numeric expression>)',
    summary: 'Rounds the fraction to the nearest whole number, halves away from zero (CINT(0.5) = 1, CINT(-0.5) = -1). The result keeps the type of the argument.',
    source: 'Ref. p. 29',
  },
  CLEAR: {
    syntax: 'CLEAR [<blocks>[,[<file area 1>][,<file area 2>]]]   (e.g. CLEAR 100,256,256 or CLEAR ,,1024)',
    summary: 'Direct or program statement. Clears all variables, undeclares arrays, closes open files and resets the FOR/GOSUB stacks. <blocks> sets the user area for POKE, PEEK and USERDATA (none if left out). The file areas are buffers for file numbers 1 and 2, in 256-byte blocks, 1-2048 (256 if left out), and set the largest file OPEN can handle. If both file areas are 1360 or more and unused, PLAYINIT and TARG use them as a sound cache: CLEAR ,1360,1360 lets you switch 3 sets of tone data without the CD. These areas share memory with each other and with the program. A soft reset does CLEAR 0,64,64.',
    source: 'Ref. pp. 7-8, 19, 29-30',
  },
  CONT: {
    syntax: 'CONT',
    summary: 'Direct command. Resumes a program stopped by STOP or Ctrl+C, from the statement after the stop. It can\'t resume if the program was changed after it stopped (error 17, Can\'t continue), so sending lines to the Saturn rules out CONT.',
    source: 'Ref. p. 31',
  },
  COS: {
    syntax: 'COS(<angle>)',
    summary: 'Cosine, returned as float. The angle is in radians (2\u03c0 = 360\u00b0); a fixed-point angle is converted to float first.',
    source: 'Ref. p. 31',
  },
  DATA: {
    syntax: 'DATA [<data item>][,[<data item>]...]',
    summary: 'Program-only statement holding constants for READ and other DATA readers (SETCHR, SETPOLYGON...). Items are number or string constants; a left-out item is 0 or "". Put a string in double quotes if it holds a comma, colon or space; a double quote itself can\'t be included. DATA is read from the first line to the last, even in the false part of an IF.',
    source: 'Ref. pp. 31-32',
  },
  'DATE$': {
    syntax: "DATE$",
    summary: "Date and time from the Saturn's clock, as \"YYYY MM/DD DDD hh:mm:ss\" with a 24-hour clock and the weekday as SUN to SAT, e.g. \"1997 02/27 THU 19:52:01\". Reading the clock takes a moment, so it can be slightly off.",
    source: "Ref. pp. 32-33",
  },
  DELETE: {
    syntax: "DELETE {<start line>|<label>},{<end line>|<label>}",
    summary: "Direct command. Deletes the lines from start to end. Both must be lines that exist, given as plain line numbers 1-99999 or labels, and end can't come before start. E.g. DELETE 100,200.",
    source: "Ref. p. 33",
  },
  DIM: {
    syntax: "DIM <name>(<max subscript>[,<max subscript>...])[,<name>(<max subscript>[,<max subscript>...])...]",
    summary: "Declares arrays. Subscripts run from 0 to the maximum given, so DIM A(10) gives A(0) to A(10); up to 16 dimensions in practice. Add # for a float array and $ for a string array. Arrays must be declared before use; FRE() shows how much room is left.",
    source: "Ref. pp. 33-34",
  },
  EDIT: {
    syntax: "EDIT [{<line>|<label>}]\nEDIT .",
    summary: "Direct command. Re-edits the program from the given line, from the top if none, or from the last line used with a period. Press Enter to store a changed line; Page Up and Page Down move to the lines above and below.",
    source: "Ref. p. 34",
  },
  END: {
    syntax: "END",
    summary: "Ends the program. Closes open files and clears the FOR/NEXT and GOSUB stacks; ends normally even inside an ON ERROR GOTO handler.",
    source: "Ref. p. 35",
  },
  ERL: {
    syntax: "ERL",
    summary: "Line number of the last error (fixed point). Works with or without ON ERROR GOTO; 0 for an error in direct mode. Reset to 0 by RESUME or by changing the program.",
    source: "Ref. p. 35",
  },
  ERR: {
    syntax: "ERR",
    summary: "Code of the last error (fixed point), with or without ON ERROR GOTO, including errors in direct mode. Reset to 0 by RESUME or by changing the program. The codes are in the error list (Ref. pp. 391-406).",
    source: "Ref. pp. 35-36",
  },
  ERROR: {
    syntax: "ERROR [<error number>]",
    summary: "Raises error 0-255 as if it had happened; an undefined number gives \"Unprintable error\". Typed on its own straight after a program stops on an error, it shows the line in error again (not for errors in DATA), handy after pressing F12 to get a readable edit screen.",
    source: "Ref. p. 36",
  },
  EXP: {
    syntax: "EXP(<numeric expression>)",
    summary: "e to the given power, returned as float (e = 2.7182818284588). The argument can be up to about 709.",
    source: "Ref. pp. 36-37",
  },
  FIND: {
    syntax: "FIND [<start line>][{,|-}[<end line>]] [,]<search string>[,P]",
    summary: "Direct command. Lists the program lines containing the string, with the match in colour; case is ignored. P pauses after each page. Otherwise Ctrl+S or Pause pauses, Ctrl+C stops, Ctrl+E or Up slows down, Ctrl+X or Down speeds up. E.g. FIND \"GOSUB\",P.",
    source: "Ref. p. 37",
  },
  FIX: {
    syntax: "FIX(<numeric expression>)",
    summary: "Drops the fraction, rounding toward zero: FIX(-1.01) = -1, FIX(-0.99) = 0. The result keeps the type of the argument.",
    source: "Ref. p. 38",
  },
  FOR: {
    syntax: "FOR <numeric variable>=<start> TO <end> [STEP <step>]",
    summary: "Starts a loop closed by NEXT. STEP defaults to +1; a step of 0 loops forever. The loop also ends if the counter passes the fixed-point limit of +/-131071.999. Fractional steps build up rounding errors, so count in whole numbers or use hex fractions such as &H0.1. In direct mode the whole loop must be on the one line.",
    source: "Ref. pp. 39-40",
  },
  FRAC: {
    syntax: "FRAC(<numeric expression>)",
    summary: "The fraction part of a number, as fixed point.",
    source: "Ref. p. 40",
  },
  GOSUB: {
    syntax: "GOSUB {<line>|<label>}",
    summary: "Calls a subroutine at a line (1-99999) or a label, e.g. GOSUB *CHECKSUB. RETURN goes back to the statement after the GOSUB.",
    source: "Ref. p. 41",
  },
  GOTO: {
    syntax: "GOTO {<line>|<label>}",
    summary: "Jumps to a line (1-99999) or a label, e.g. GOTO *GAMEOVER. Statements after it on the line never run, though DATA there still counts.",
    source: "Ref. pp. 41-42",
  },
  'HEX$': {
    syntax: "HEX$(<numeric expression>[,<suppress>])",
    summary: "Number to hex string, with \".\" before the fraction. A value that is not negative gets a leading space, a negative one a \"-\". Suppress pads with 0s: 0 = none (default), 1 = integer part, 2 = fraction, 3 = both. HEX$(123.25) gives \" 7B.4\"; with 3, \" 0007B.4000\".",
    source: "Ref. p. 42",
  },
  'HEXBIN$': {
    syntax: "HEXBIN$(<source string>)",
    summary: "Hex string to binary data, one character per pair of digits: HEXBIN$(\"414243\") = \"ABC\". Commas can separate items, so HEXBIN$(\"41,4,43\") = \"A\"+CHR$(4)+\"C\"; an odd last digit counts as the low digit.",
    source: "Ref. p. 43",
  },
  IF: {
    syntax: "IF <condition> THEN [{<line>|<label>|<statement>...}][ELSE [{<line>|<label>|<statement>...}]]\nIF <condition> GOTO {<line>|<label>}[ELSE [{<line>|<label>|<statement>...}]]\nIF <condition> THEN [:<statement>...]\n  [<statement>...]\n[ELSE]\n  [<statement>...]\nENDIF",
    summary: "Non-zero is true (fractions dropped). A one-line IF ends at the end of the line. If THEN is followed by the line end or \":\", the IF runs over several lines until ENDIF, and ELSE IF chains are allowed. The two forms can be mixed. Errors: ELSE/ENDIF without IF, IF/ELSE without ENDIF.",
    source: "Ref. pp. 43-46",
  },
  'INKEY$': {
    syntax: "INKEY$",
    summary: "One character from the key buffer, or \"\" if none. Special keys: Backspace 8, Tab 9, Home 11, Insert 18, End 24, Esc 27, right 28, left 29, up 30, down 31, Delete 127, F1-F12 224-235 (&HE0-&HEB; F10 can't be sent from BASTERM), Page Up 250, Page Down 251.",
    source: "Ref. pp. 47-48",
  },
  INPUT: {
    syntax: "INPUT [<prompt>,]{<string variable>|<numeric variable>}[,<default>]",
    summary: "Shows the prompt (\"?\" if left out) and reads a line from the keyboard; the key buffer is cleared first. Commas, colons and quotes are taken as typed and trailing spaces dropped. The default text is shown ready to edit. A numeric variable repeats the input until a number is typed. E.g. INPUT \"ENTRY NAME ?\",N$,\"SEGA\".",
    source: "Ref. pp. 48-49",
  },
  'INPUT$': {
    syntax: "INPUT$(<number of characters>)",
    summary: "Waits for 1-255 key presses and returns them as a string. Every key with a character code counts except Ctrl+C; see INKEY$ for special keys.",
    source: "Ref. p. 49",
  },
  INSTR: {
    syntax: "INSTR(<target string>,<search string>[,<start position>])",
    summary: "Position of the search string in the target, counting from 1, or 0 if not found, if the target is \"\", or if the start is past its end. An empty search string returns the start position.",
    source: "Ref. p. 50",
  },
  INT: {
    syntax: "INT(<numeric expression>)",
    summary: "Largest whole number not above the value, so INT(-0.01) = -1. The result keeps the type of the argument.",
    source: "Ref. p. 51",
  },
  INTERVAL: {
    syntax: "INTERVAL[<timer number>] ON [,<interval>]\nINTERVAL[(<timer number>)] <interval>\nINTERVAL[(<timer number>)] OFF",
    summary: "Interval timers 0-23 (0 if left out), counting in 1/60 s. ON allows the interrupt and starts the count, and a new interval resets it; a bare interval changes only the interval; OFF blocks the interrupt (it isn't queued). An interval of 0 stops the count. Set the handler with ON INTERVAL GOSUB first. Lower timer numbers go first, then countdown timers, then ON MMLSTAT GOSUB.",
    source: "Ref. pp. 51-53",
  },
  'LEFT$': {
    syntax: "LEFT$(<target string>,<numeric expression>)",
    summary: "The first n characters of the string; the whole string if n is longer, \"\" if n is 0.",
    source: "Ref. p. 53",
  },
  LEN: {
    syntax: "LEN(<string expression>)",
    summary: "Number of characters in the string (fixed point), 0 for \"\".",
    source: "Ref. pp. 53-54",
  },
  LET: {
    syntax: "[LET] <numeric variable>=<numeric expression>\n[LET] <string variable>=<string expression>",
    summary: "Assignment; LET can be left out. A fixed-point variable holds -&H1FFFF.FFFC to +&H1FFFF.FFFC, beyond which you get Overflow; mixing strings and numbers gives Type mismatch.",
    source: "Ref. p. 54",
  },
  FILES: {
    syntax: 'FILES "<device>:[<name>]"',
    summary: 'Lists files on BRAM:, CRAM:, FD0:, FD1:, COM: or CD:, then "Free size n / m file blocks". Wildcards ? and * are allowed; give the extension here.',
    source: 'Tut. pp. 29-30; Ref. p. 8',
  },
  FKEY: {
    syntax: "FKEY <function key number>,<string expression>\nFKEY PRINT   (or FKEY ?)",
    summary: "Defines function key 1-12 with a string of up to 31 characters (anything after a CHR$(0) is ignored), e.g. FKEY 1,\"RUN\"+CHR$(13)+CHR$(10). FKEY PRINT lists the keys, with control codes shown as X. At start-up F5 is RUN, F7 CONT, F12 CHR$(16) (Ctrl+P, the panic key).",
    source: "Ref. pp. 18, 38",
  },
  FRE: {
    syntax: "FRE(<number>)",
    summary: "Memory in 256-byte blocks, rounded up: 0 = free space in the variable and program area; 1 = size of the user area; 2 and 3 = size of file areas 1 and 2 (sizes, not free space). See also SFRE, TFRE.",
    source: "Ref. pp. 7-8, 40-41",
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


// Words that belong to a larger statement show that statement's entry.
for (const w of ['THEN', 'ELSE', 'ENDIF']) COMMANDS[w] = COMMANDS.IF;
for (const w of ['TO', 'STEP']) COMMANDS[w] = COMMANDS.FOR;

// Error messages, Reference Manual appendix pp. 391-406: code -> [message as
// the Saturn prints it, cause]. Codes 33, 38, 40 and 49 are not listed.
const ERRORS = {
  1: ["NEXT without FOR", "a NEXT has no matching FOR"],
  2: ["Syntax error", "the statement is written wrongly: its form, the number of brackets, a comma or a separator"],
  3: ["RETURN without GOSUB", "RETURN was reached without a GOSUB"],
  4: ["Out of DATA", "READ, SETCHR, SETPOLYGON or another DATA reader ran out of DATA"],
  5: ["Illegal function call", "a statement or function was called the wrong way"],
  6: ["Overflow", "a number, in a calculation or a polygon, went outside the fixed-point range"],
  7: ["Out of memory", "CLEAR, DIM, a program being typed or loaded, or PEEK/POKE past the user area ran out of memory; change the split with CLEAR"],
  8: ["Undefined line number", "a GOTO, GOSUB or similar names a line number or label that doesn't exist"],
  9: ["Subscript out of range", "an array index is outside the size given in DIM"],
  10: ["Variable already defined", "DIM names a variable that is already defined"],
  11: ["Division by 0", "a calculation divided by 0"],
  12: ["Illegal direct", "this statement can't be typed as a direct command"],
  13: ["Type mismatch", "a value of the wrong type, such as a number put in a string variable"],
  14: ["Sound: MML String too short", "the MML string is too short in time"],
  15: ["String too long", "a string over 65535 characters, or a line typed on the edit screen that is too long"],
  16: ["Formula too complex", "an expression is too complex or functions are nested too deeply"],
  17: ["Can't continue", "the program can't be resumed, for example because it was changed after it stopped"],
  18: ["Undefined array", "an array is used without DIM"],
  19: ["Dimension size error", "an array is used with a different number of dimensions from its DIM"],
  20: ["Communication error", "the link failed. Check the cable, and that the PC's speed matches the Saturn's setting (L+R+Z on the pad), then reconnect"],
  21: ["No RESUME", "the program ended inside an ON ERROR handler without RESUME"],
  22: ["RESUME without error", "RESUME was used when no error had happened"],
  23: ["Illegal line number", "a bad line number, or 0, or over 99999"],
  24: ["Stack overflow", "the FOR-NEXT or GOSUB stack overflowed, or a PAINT shape is too complex"],
  25: ["IF stack overflow", "IF statements are nested too deeply"],
  26: ["ELSE/ENDIF without IF", "an ELSE or ENDIF has no matching IF"],
  27: ["FOR without NEXT", "a FOR has no matching NEXT"],
  28: ["Direct statement only", "this statement can't be used in a program"],
  29: ["Data statement", "a DATA item read by READ has no closing double quote"],
  30: ["String format error", "GCOPY or CCOPY was given a string with the wrong structure"],
  31: ["Parameter mismatch", "the parameters don't match, as in PRINT USING"],
  32: ["IF/ELSE without ENDIF", "an IF or ELSE has no matching ENDIF"],
  34: ["Undefined vertex", "SETVERTEX, SETPOLYGON or VERTEXID used a vertex ID that isn't defined"],
  35: ["Undefined polygon", "SETPOLYGON, an object or POLYGONID used a polygon ID that isn't defined"],
  36: ["Undefined attribute", "SETATR or an object used an attribute ID that isn't defined"],
  37: ["Undefined texture", "SETTEX, SETATR, PUTSPRITE or TEXID used a texture ID that isn't defined (define sprites with SPRITE$ first)"],
  39: ["Version mismatch", "the BASIC program is from a different version"],
  41: ["Unusable charactor", "the line holds a character BASIC can't store"],
  42: ["Buffer full", "FWRITE went past the file buffer set by CLEAR"],
  43: ["Device not connected", "CRAM:, FD0: or FD1: isn't connected, or the Saturn started with no floppy in"],
  44: ["Device not formatted", "the floppy isn't formatted; FORMAT it if its contents can be erased"],
  45: ["Device write protected", "the floppy's write-protect notch is set"],
  46: ["Device verify error", "the file is damaged"],
  47: ["Not enough space", "BRAM:, CRAM:, FD0: or FD1: is too full to write"],
  48: ["Backup RAM error", "another BRAM:, CRAM:, FD0: or FD1: error"],
  50: ["File access error", "the PC's link software couldn't read or write the host file"],
  51: ["Internal error", "internal error"],
  52: ["Sound: Out of layer memory", "not enough layer area"],
  53: ["File not found", "the file doesn't exist"],
  54: ["File already open", "OPEN, KILL or similar on a file that is already open"],
  55: ["Access past EOF", "read past the end of the file"],
  56: ["Bad file name", "the file name isn't valid"],
  57: ["Invalid BASIC file", "LOAD of a file that isn't a BASIC program"],
  58: ["Duplicated label", "the same label is defined twice"],
  59: ["File not OPEN", "a file number was used without OPEN"],
  60: ["Already formatted", "the device is already formatted"],
  61: ["Bad file mode", "the file mode isn't valid"],
  62: ["Bad device name", "the device name isn't valid"],
  63: ["Sound: Not layer mode", "not in layer edit mode"],
  64: ["File still open", "a file that is open was used"],
  65: ["Sound: Command buffer full", "the sound driver's command buffer is full"],
  66: ["Sound: Out of sound memory", "sound memory can't be reserved"],
  67: ["Sound: MML command error", "an MML command error; the next line gives the detail"],
  68: ["Sound:Out of MML data", "the MML string ran out"],
  69: ["File read error", "the file can't be read"],
  70: ["File write error", "the file can't be written"],
  71: ["Sound: Song bank full", "the reserved blocks are used up"],
  72: ["Sound: Layer overflow", "no more layers can be registered"],
  73: ["Sound: Tone overflow", "no more tones can be registered"],
  74: ["Sound: VL overflow", "no more velocity-level data can be registered, or not enough layer area"],
  75: ["Sound: PEG overflow", "no more pitch-envelope data can be registered, or not enough layer area"],
  76: ["Sound: PLFO overflow", "no more pitch-LFO data can be registered, or not enough layer area"],
  77: ["Sound: No layer", "no layer has been registered"],
  78: ["Invalid USERDATA", "the USERDATA isn't valid"],
  79: ["Vertex size mismatch", "SETVERTEX re-registered an ID with a different size"],
  80: ["Vertex number", "a SETPOLYGON vertex number is outside 0 to (vertices - 1) of its vertex group"],
  81: ["Vertex ID over", "SETVERTEX can't register more vertex IDs"],
  82: ["Vertex data over", "SETVERTEX can't register more data"],
  83: ["Vertex out of area", "SETVERTEX defined more vertices than it reserved"],
  84: ["Texture size mismatch", "SETTEX re-registered a texture with a different size"],
  85: ["Texture ID over", "SETTEX can't register more IDs"],
  86: ["Texture data over", "SETTEX was given more data than its area size"],
  87: ["Sound: Invalid WAVE file", "not wave data"],
  88: ["Sound: Bad WAVE file format", "the wave data's format is wrong"],
  89: ["Polygon size mismatch", "SETPOLYGON re-registered an ID with a different size"],
  90: ["Polygon ID over", "SETPOLYGON can't register more IDs"],
  91: ["Polygon data over", "SETPOLYGON can't register more data"],
  92: ["Attribute size mismatch", "SETATR or SETPFONT re-registered an ID with a different size"],
  93: ["Attribute ID over", "SETATR can't register more attribute IDs"],
  94: ["Attribute data over", "SETATR can't register more data"],
  95: ["Attribute out of area", "SETATR was given more data than its size"],
};

// Detail lines shown under error 67 (pp. 399-403), e.g. "Bad octave value(0 <=> 8)".
const MML_DETAILS = [
  "MML Syntax error", "Bad note length", "Velocity value", "Not gate time ratio",
  "Bad gate time ratio", "Bad pitch bend value", "Not chord", "Can't nest - plets",
  "Bad note number", "Bad tone number", "Bad signature", "Bad transpose value",
  "Bad tempo value", "Tempo change over", "Bad volume value", "Bad direct pan value",
  "Bad octave value", "Not MML command", "Bad damper value", "Macro error",
  "Software layer error", "Pitch bend cmd.buffer overflow", "Not base track", "Bad label",
  "D.S. without", "Bad '$'or'*'or'ds'position", "Repeat command error", "Bad effect pan value",
  "Bad effect level", "Bad effect number", "Not DSP mode", "Bad DSP mixer number",
  "Bad status value", "Not code name", "Chord note over",
];

// 'Syntax error in 100' -> 'error 2: the statement is written wrongly ...'.
// Returns null when the text holds no known message. Longest match wins, so
// "Sound: MML command error" is not taken for "MML Syntax error".
function explainError(text) {
  const t = String(text).toLowerCase();
  let best = null;
  for (const [code, [msg, cause]] of Object.entries(ERRORS)) {
    if (t.includes(msg.toLowerCase()) && (!best || msg.length > best.len)) {
      best = { len: msg.length, text: `error ${code}: ${cause}` };
    }
  }
  for (const msg of MML_DETAILS) {
    if (t.includes(msg.toLowerCase()) && (!best || msg.length > best.len)) {
      best = { len: msg.length, text: 'MML detail for error 67 (Sound: MML command error)' };
    }
  }
  return best ? best.text : null;
}

module.exports = { COMMANDS, CONSTANTS, ERRORS, MML_DETAILS, explainError };
