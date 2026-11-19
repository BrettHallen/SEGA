// Created with Claude Opus 5.5, Nov 2026
// Guided by Brett Hallen
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
  LIST: {
    syntax: "LIST [<start line>][{,|-}[<end line>]]\nLIST .",
    summary: "Direct command. Lists lines 1-99999 in the range; with no comma or hyphen only the start line; LIST . shows the last line used. Nothing is shown if end comes before start. Ctrl+S or Pause pauses, Ctrl+C stops, Ctrl+E or Up slows down, Ctrl+X or Down speeds up.",
    source: "Ref. p. 55",
  },
  LOCATE: {
    syntax: "LOCATE [<X character position>][,<Y character position>]",
    summary: "Moves the text cursor, 0-127 each, measured from the top left (0,0) of the area set by WIDTH. Affects where PRINT, PRINT USING and INPUT write.",
    source: "Ref. pp. 55-56",
  },
  LOCK: {
    syntax: "LOCK",
    summary: "Holds back ON INTERVAL and ON TIMER subroutine calls until UNLOCK. A timer that fires meanwhile is kept and delivered at UNLOCK (only the last one for an interval timer); interval timers keep counting. Keep LOCK...UNLOCK short.",
    source: "Ref. p. 56",
  },
  UNLOCK: {
    syntax: "UNLOCK",
    summary: "Ends a LOCK: interrupt subroutines can run again, and any held back are delivered.",
    source: "Ref. p. 56",
  },
  LOG: {
    syntax: "LOG(<numeric expression>)",
    summary: "Natural logarithm, returned as float. The argument must be above 0.",
    source: "Ref. pp. 56-57",
  },
  'MID$': {
    syntax: "MID$(<target string>,<position>[,<length>])\nMID$(<string variable>,<position>[,<length>])=<replacement string>",
    summary: "As a function: the characters from position (counting from 1) for length, or to the end; \"\" if position is past the end. As a statement: overwrites that part of the variable with the replacement, appending if position is past the end; a left-out or 0 length means the replacement's length.",
    source: "Ref. pp. 57-58",
  },
  NEW: {
    syntax: "NEW",
    summary: "Direct command. Erases the program and clears variables and stacks, closing open files. The user area and file areas are kept.",
    source: "Ref. p. 58",
  },
  NEXT: {
    syntax: "NEXT [<numeric variable>[,<numeric variable>...]]",
    summary: "Ends a FOR loop: adds the step and tests the end value here. With no variable it closes the most recent FOR; naming an outer loop's variable is an error. In direct mode the whole loop must be on the one line.",
    source: "Ref. p. 59",
  },
  ON: {
    syntax: "ON ERROR GOTO {{<line>|<label>}|0}\nON <expression> GOSUB [{<line>|<label>}][,[{<line>|<label>}]...]\nON <expression> GOTO [{<line>|<label>}][,[{<line>|<label>}]...]\nON INTERVAL[(<timer number>)] GOSUB {<line>|<label>}\nON TIMER[(<countdown timer number>)] GOSUB {<line>|<label>}\nON <numeric expression> RESTORE [{<line>|<label>}][,[{<line>|<label>}]...]",
    summary: "ON ERROR GOTO sets an error handler (0 turns it off); an error inside the handler stops the program, RESUME re-arms it, and running off the end gives No RESUME. ON n GOSUB/GOTO/RESTORE picks the nth target (0-131071; 0, too big or a left-out target goes on to the next statement; negative is Illegal function call). ON INTERVAL sets the handler for interval timer 0-23 and ON TIMER for countdown timer 0-7; both start disabled, and ON INTERVAL resets the interval to 60.",
    source: "Ref. pp. 59-64",
  },
  PAD: {
    syntax: "PAD(<function>[,<item>])",
    summary: "Control pad ports. Function -1 / -2: number of devices on port 1 / 2 (0 if none). 0-14 = devices on port 1, 15-29 on port 2. Item 0 = device ID (&H00 digital, &H10 analog, &H20 pointing, &H30 keyboard, &HFF none); 1 = buttons held; 2 = buttons newly pressed (cleared on read, so copy it to a variable); 3-6 analog values. Pad bits: right 15, left 14, down 13, up 12, Start 11, A 10, C 9, B 8, R 7, X 6, Y 5, Z 4, L 3 (see the @PAD_ constants).",
    source: "Ref. pp. 64-67",
  },
  PEEK: {
    syntax: "PEEK(<block>,<address>)",
    summary: "One byte, 0-255, from the user area reserved with CLEAR.",
    source: "Ref. p. 67",
  },
  'PEEK$': {
    syntax: "PEEK$(<block>,<address>,<length>)",
    summary: "A string of length bytes from the user area reserved with CLEAR; it must not run past the area.",
    source: "Ref. p. 68",
  },
  POKE: {
    syntax: "POKE <block>,<address>,{<numeric expression>|<string expression>}[,{<numeric expression>|<string expression>}...]",
    summary: "Writes into the user area reserved with CLEAR: each number is one byte (0-255), each string character one byte (its code). E.g. POKE 0,0,128,64,32,16 or POKE 0,&H3800,BN$.",
    source: "Ref. pp. 68-69",
  },
  USING: {
    syntax: "PRINT USING <format string>;<expression>[{,|;}<expression>...][{,|;}]",
    summary: "Prints values to a format. # digit position (a % in front if the number doesn't fit; extra decimals rounded); . decimal point; + sign; & & a string field as wide as the ampersands and spaces between them; @ a string of any length; ! the first character of a string; _ prints the next format character literally. , and ; don't move the cursor here; the format repeats if there are more values. A trailing , or ; keeps the cursor on the line. E.g. PRINT USING \"#####.###\";1000*A#.",
    source: "Ref. pp. 70-71",
  },
  READ: {
    syntax: "READ <variable>[,<variable>...]",
    summary: "Reads the next DATA items into the variables. An empty item gives 0 or \"\". Running out gives Out of DATA, and the wrong type gives Type mismatch.",
    source: "Ref. p. 72",
  },
  POS: {
    syntax: "POS(<number>)",
    summary: "Text cursor position (fixed point): 0 = X (column), 1 = Y (row).",
    source: "Ref. p. 69",
  },
  PRINT: {
    syntax: "PRINT [<expression>[[{,|;}]<expression>[[{,|;}]<expression>]...]][{,|;}]\n? ...",
    summary: "Prints numbers or strings on the text screen. ; continues at the cursor (also assumed when no separator is given); , moves to the next tab stop. A trailing , or ; keeps the cursor on the line, otherwise it goes to the start of the next line. Control characters in a string act as with CHR$ (e.g. CHR$(&H0C) clears the screen). ? is short for PRINT: ?\"ABC\".",
    source: "Ref. pp. 69-70",
  },
  RANDOMIZE: {
    syntax: "RANDOMIZE <seed>",
    summary: "Starts a new random sequence from the seed, so RND gives the same numbers every time. The sequence is otherwise renewed at start-up, RUN and LOAD.",
    source: "Ref. p. 71",
  },
  RESTORE: {
    syntax: "RESTORE [{<line>|<label>}]",
    summary: "Makes the next READ start at the first DATA at or after the line or label (the line itself need not hold DATA); from the first DATA in the program if left out.",
    source: "Ref. pp. 73-74",
  },
  RESUME: {
    syntax: "RESUME [{NEXT|<line>|<label>}]",
    summary: "Ends an ON ERROR handler: retries the failing statement, or with NEXT goes on after it, or jumps to a line or label. Resets ERR and ERL to 0. A line number can't be given in direct mode (Illegal direct).",
    source: "Ref. p. 74",
  },
  RETURN: {
    syntax: "RETURN",
    summary: "Returns from a subroutine to the statement after its GOSUB.",
    source: "Ref. p. 74",
  },
  'RIGHT$': {
    syntax: "RIGHT$(<target string>,<numeric expression>)",
    summary: "The last n characters of the string; the whole string if n is longer, \"\" if n is 0.",
    source: "Ref. p. 75",
  },
  RND: {
    syntax: "RND(<upper limit>)",
    summary: "A random whole number from 0 to the limit minus 1: RND(10) gives 0-9, RND(1) always 0. Use RANDOMIZE for a repeatable sequence.",
    source: "Ref. pp. 75-76",
  },
  RUN: {
    syntax: "RUN [{<line>|<label>}]",
    summary: "Runs the program, from the start or from a line or label. First zeroes numbers, empties strings, undoes DIMs, resets ERL/ERR, READ position and FOR/IF nesting, closes all files, turns off INTERVAL and TIMER, clears PAD trigger bits, ends USERDATA mode and drops the sound cache.",
    source: "Ref. p. 76",
  },
  SGN: {
    syntax: "SGN(<numeric expression>)",
    summary: "-1, 0 or 1 for a negative, zero or positive value, in the argument's type.",
    source: "Ref. p. 77",
  },
  SHIFT: {
    syntax: "SHIFT",
    summary: "Saturn keyboard modifier keys as bits: 0/1 left/right Shift, 2/3 left/right Ctrl, 4/5 left/right Alt, 6 Caps Lock, 7 Katakana/Hiragana. BASTERM's virtual keyboard sends Shift as &H3 and Ctrl as &HC (no left/right). Three or more keys at once, or a busy CPU, can give wrong bits. E.g. IF SHIFT AND 3 THEN PRINT \"Shift ON\".",
    source: "Ref. pp. 77-78",
  },
  SIN: {
    syntax: "SIN(<angle>)",
    summary: "Sine, returned as float; the angle is in radians (2\u03c0 = 360\u00b0).",
    source: "Ref. pp. 78-79",
  },
  SKCLOSE: {
    syntax: "SKCLOSE",
    summary: "Closes the software keyboard if it is on screen. It can still be opened again from the pad.",
    source: "Ref. p. 79",
  },
  'SPACE$': {
    syntax: "SPACE$(<length>)",
    summary: "A string of that many spaces; \"\" for 0.",
    source: "Ref. p. 79",
  },
  SQR: {
    syntax: "SQR(<numeric expression>)",
    summary: "Square root, as float. A negative argument gives Illegal function call.",
    source: "Ref. p. 80",
  },
  STOP: {
    syntax: "STOP",
    summary: "Stops the program; CONT resumes it.",
    source: "Ref. p. 80",
  },
  'STR$': {
    syntax: "STR$(<numeric expression>[,<suppress>])",
    summary: "Number to decimal string, with a leading space if not negative or \"-\" if negative. Suppress pads with 0s: 0 = none (default), 1 = integer part, 2 = fraction, 3 = both. STR$(123.25,3) gives \" 000123.2500\".",
    source: "Ref. pp. 80-81",
  },
  'STRING$': {
    syntax: "STRING$(<count>,{<numeric expression>|<string expression>})",
    summary: "Repeats one character: a code (low 8 bits) or the first character of a string. STRING$(5,&H41) = \"AAAAA\". Use STRW$ for longer patterns.",
    source: "Ref. pp. 81-82",
  },
  'STRW$': {
    syntax: "STRW$(<count>,{<numeric expression>|<string expression>})",
    summary: "Repeats a whole string, or a 16-bit value (0-65535) as two bytes, high byte first: STRW$(5,&H4142) = \"ABABABABAB\". Handy for RGB data: PALETTE ,STRW$(32,RGB(3,0,0)+&H8000).",
    source: "Ref. p. 82",
  },
  SWAP: {
    syntax: "SWAP <variable 1>,<variable 2>",
    summary: "Exchanges two variables of the same type; for arrays, just the one element named.",
    source: "Ref. p. 83",
  },
  TAN: {
    syntax: "TAN(<angle>)",
    summary: "Tangent, as float; the angle is in radians.",
    source: "Ref. p. 83",
  },
  TIMER: {
    syntax: "TIMER[(<countdown timer number>)] ON [,<time>]\nTIMER[(<countdown timer number>)] <time>\nTIMER[(<countdown timer number>)] OFF",
    summary: "Countdown timers 0-7 (0 if left out), in 1/60 s. ON allows the interrupt and starts the count (a time resets it); a bare time changes only the time; OFF blocks it (not queued). Fires once, unlike INTERVAL; 0 stops the count. Set the handler with ON TIMER GOSUB first. Timers that finish together are served round-robin, one interrupt per BASIC statement.",
    source: "Ref. pp. 84-85",
  },
  USERDATA: {
    syntax: "USERDATA [<block>,<offset>,]\"<string>\",<switch>\nUSERDATA <block>,<offset>\nUSERDATA END\nUSERDATA(<item>)",
    summary: "Keeps DATA in the user area (block 0-4095, offset 0-&H1FFFF): form 1 stores items like a DATA line (switch 1 keeps quotes, 0 drops them) and points READ there; form 2 reads DATA saved earlier with BSAVE and loaded with BLOAD; END goes back to normal DATA. CLEAR, POKE or a BLOAD elsewhere also end it. USERDATA(0-3) gives start block, start offset, end block, end offset, ready for BSAVE.",
    source: "Ref. pp. 86-88",
  },
  VAL: {
    syntax: "VAL(<string expression>)",
    summary: "String to number: decimal, &H hex or &B binary (sign before the prefix). Spaces are skipped; it stops at the first other character; 0 if nothing converts.",
    source: "Ref. p. 89",
  },
  VERSION: {
    syntax: "VERSION",
    summary: "The BASIC version number (fixed point).",
    source: "Ref. p. 89",
  },
  'WADD$': {
    syntax: "WADD$(<string expression>,<add value>[,<start position>])",
    summary: "Treats the string as 16-bit words (high byte first; an odd last character is dropped), starting at word <start position> (1 or more), and returns the result as a string. Adds the value (low 16 bits) to each word: WADD$(\"AAAAAAAA\",&H0102) = \"BCBCBCBC\".",
    source: "Ref. p. 90",
  },
  'WANDOR$': {
    syntax: "WANDOR$(<source string>,<AND value>,<OR value>[,<start position>])",
    summary: "Treats the string as 16-bit words (high byte first; an odd last character is dropped), starting at word <start position> (1 or more), and returns the result as a string. ANDs then ORs each word: WANDOR$(\"AbCdEfGh\",&H5F5F,&H2020) = \"abcdefgh\".",
    source: "Ref. pp. 90-91",
  },
  WIDTH: {
    syntax: "WIDTH [<left>],[<top>][,<right>][,<bottom>]",
    summary: "Sets the text window, 0-127 each, e.g. WIDTH 0,20,63,24. A wide window can run off the TV; scroll it with SCROLL. SCREEN resets it to 1,1,38,26, and Ctrl+P while editing resets it to the system-screen setting.",
    source: "Ref. p. 91",
  },
  'WMUL$': {
    syntax: "WMUL$(<source string>,<multiplier>[,<start position>])",
    summary: "Treats the string as 16-bit words (high byte first; an odd last character is dropped), starting at word <start position> (1 or more), and returns the result as a string. Multiplies each word (low 16 bits kept): WMUL$(\"12\",2) = \"bd\", WMUL$(\"bd\",1/2) = \"12\".",
    source: "Ref. pp. 91-92",
  },
  'WXOR$': {
    syntax: "WXOR$(<source string>,<XOR value>[,<start position>])",
    summary: "Treats the string as 16-bit words (high byte first; an odd last character is dropped), starting at word <start position> (1 or more), and returns the result as a string. XORs each word: WXOR$(\"AAAAAAAA\",&H0304) = \"BEBEBEBE\".",
    source: "Ref. p. 92",
  },
  XATN: {
    syntax: "XATN(<x ratio>,<y ratio>)",
    summary: "Fast fixed-point arctangent, from 0 up to 1 where 1.000 = 360\u00b0: XATN(0,1) = .25, XATN(-1,0) = .5. Returns 0 for (0,0).",
    source: "Ref. p. 93",
  },
  XCOS: {
    syntax: "XCOS(<angle>)",
    summary: "Fast fixed-point cosine. The angle is in turns (1.000 = 360\u00b0; the whole-number part is ignored); the result is -1 to 1.",
    source: "Ref. p. 93",
  },
  XDIST: {
    syntax: "XDIST(<XP>,<YP>[,<ZP>])",
    summary: "Distance from the origin, SQR(XP^2+YP^2[+ZP^2]), in fixed point; over &H1FFFF gives Overflow. XDIST(10000,10000,10000) = 17320.508.",
    source: "Ref. p. 94",
  },
  XSIN: {
    syntax: "XSIN(<angle>)",
    summary: "Fast fixed-point sine. The angle is in turns (1.000 = 360\u00b0; the whole-number part is ignored); the result is -1 to 1.",
    source: "Ref. p. 94",
  },
  XSQR: {
    syntax: "XSQR(<numeric expression>)",
    summary: "Square root; a negative argument gives Illegal function call.",
    source: "Ref. p. 95",
  },
  XTAN: {
    syntax: "XTAN(<angle>)",
    summary: "Fast fixed-point tangent. The angle is in turns (1.000 = 360\u00b0; the whole-number part is ignored).",
    source: "Ref. p. 95",
  },
  BLOAD: {
    syntax: "BLOAD \"[<device>:]<name>\",<start block>,<start offset>   (e.g. BLOAD FILENAME$,0,0)",
    summary: "Reads a .D file into the CLEAR user area at <block>*256+<offset> (offset 0-&H1FFFF). The extension defaults to D; any other gives Bad file name. Device defaults to the last one used. Errors: File still open, Not enough space (past the user area).",
    source: "Ref. p. 98",
  },
  BSAVE: {
    syntax: "BSAVE \"[<device>:]<name>\",<start block>,<start offset>,<end block>,<end offset>   (e.g. BSAVE FILENAME$,0,0,10,10)",
    summary: "Writes the user area from <start block>*256+<start offset> to <end block>*256+<end offset> to a .D file (other extensions give Bad file name). Errors: File still open; Not enough space if the device is full or already holds 99 files.",
    source: "Ref. p. 99",
  },
  CLOSE: {
    syntax: "CLOSE [[#]<file number>]   (e.g. CLOSE, CLOSE #1)",
    summary: "Writes out any data left in the file area and ends access. With no number, closes every file opened by OPEN. Backup devices are only written when the file is closed. Ending the program or any error also closes (and discards) open files.",
    source: "Ref. pp. 96, 100",
  },
  FORMAT: {
    syntax: "FORMAT \"<device>:\"   (e.g. FORMAT \"FD1:\")",
    summary: "Erases and initialises BRAM:, CRAM:, FD0: or FD1:, but only if not already formatted (Already formatted). A floppy is formatted one partition at a time. Bad device name for anything else.",
    source: "Ref. p. 101",
  },
  FREAD: {
    syntax: "FREAD [#]<file number>,<string variable>,<byte count>   (e.g. FREAD #1,A$,10)",
    summary: "File number 1 or 2 (from OPEN). Reads <byte count> bytes (1 or more) into the variable from the file area. The file must be opened FOR INPUT or with no mode. Moves the SEEK position; reading past the end gives Access past EOF.",
    source: "Ref. p. 102",
  },
  FWRITE: {
    syntax: "FWRITE [#]<file number>,<string>   (e.g. FWRITE #1,\"ABC\" or FWRITE 1,A$)",
    summary: "File number 1 or 2 (from OPEN). Writes the string to the file area and moves the SEEK position. The file must be opened FOR OUTPUT, APPEND or with no mode, and the data only reaches the file when it is CLOSEd, so close it before the program ends.",
    source: "Ref. pp. 96, 102-103",
  },
  GLOAD: {
    syntax: "GLOAD \"[<device>:]<name>\"[,<logical BG>][,(<dest X>,<dest Y>)][,P]   (e.g. GLOAD \"COM:TEST.1\")",
    summary: "Loads bitmap data (.0 = 256 colours, .1 = 32768 colours) onto a bitmap screen at (X,Y), default (0,0); clipped like GCOPY. No extension: the current screen mode picks it; a mismatch, or a mode with no bitmap, gives Illegal function call. BG defaults to the last ACTIVE one. P skips the palette of 256-colour data. Needs an unused file buffer bigger than the data (CLEAR): a 320x224 picture needs 282 blocks (.0) or 560 blocks (.1). E.g. SCREEN 1: CLEAR ,600: GLOAD \"GDATA.0\",1. File format: width and height (2 bytes each, high byte first), then for .0 a 512-byte palette and 1 byte per dot (0 = transparent), for .1 2 bytes per dot (bit 15 set; 0 = transparent; black = &H8000).",
    source: "Ref. pp. 103-106",
  },
  GSAVE: {
    syntax: "GSAVE \"[<device>:]<name>\"[,<logical BG>][,(<X1>,<Y1>)-(<X2>,<Y2>)]   (e.g. GSAVE \"COM:PICT\",0)",
    summary: "Saves part of a bitmap screen as .0 (256 colours) or .1 (32768 colours); the area defaults to (0,0)-(319,223). Extension and BG rules as GLOAD. Needs an unused file buffer of 4+512+W*H bytes (.0) or 4+W*H*2 bytes (.1), e.g. CLEAR ,600: GSAVE \"TEMP\",0. A large area takes 1-2 minutes or more to write to COM:.",
    source: "Ref. pp. 106-107",
  },
  KILL: {
    syntax: "KILL \"[<device>:]<name>.<ext>\"   (e.g. KILL \"BRAM:TEST.B\" or KILL F$)",
    summary: "Deletes a file. The extension must be given in full: without it the extension counts as a space and you get File not found. Device defaults to the last one used.",
    source: "Ref. p. 108",
  },
  SEEK: {
    syntax: "SEEK [#]<file number>,<position>   (e.g. SEEK #1,128)",
    summary: "File number 1 or 2 (from OPEN). Sets the read/write position, 0-&H7FFFFFFF. Past the end of a file opened FOR INPUT gives Access past EOF; a writable file can seek past its end but the gap is undefined. The file ends up as long as the furthest byte written. See LOC and LOF.",
    source: "Ref. p. 112",
  },
  DSKF: {
    syntax: "DSKF([<device>:])   (e.g. A = DSKF(\"BRAM:\"), PRINT DSKF(\"\"))",
    summary: "Free space on the device in file blocks of 64 bytes (capped at the fixed-point maximum). \"\" or no device means the last one used. CD: gives Bad device name; a missing device gives Device not connected.",
    source: "Ref. p. 113",
  },
  'FILES$': {
    syntax: "FILES$([<device>:][<pattern>][.<ext>])   (e.g. A$ = FILES$(), PRINT FILES$(\"COM:TEST*.b\"))",
    summary: "Returns the matching names joined into one string. Each entry is the name with its period and extension in 10 characters, the size in file blocks as 5 decimal digits (spaces on CD: and COM:), then CHR$(13)+CHR$(10). Wildcards work; empty string if nothing matches.",
    source: "Ref. p. 114",
  },
  LOC: {
    syntax: "LOC([#]<file number>)   (e.g. A# = LOC(#1): SEEK 1,LOC(#1)+5)",
    summary: "File number 1 or 2 (from OPEN). Returns the current read/write (SEEK) position.",
    source: "Ref. p. 115",
  },
  LOF: {
    syntax: "LOF([#]<file number>)   (e.g. A# = LOF(#1): SEEK 1,LOF(1))",
    summary: "File number 1 or 2 (from OPEN). Returns the position of the end of the file.",
    source: "Ref. p. 115",
  },
  ACTIVE: {
    syntax: "ACTIVE <logical BG>   (e.g. ACTIVE 0, ACTIVE (A AND 3)+4)",
    summary: "Sets the default BG for commands that leave it out. 0-2: bitmap commands (CIRCLE, LINE, GCOPY, PSET, PAINT, KPRINT, CLS, POINT). 4-8: character commands (CCOPY, PUTCHR, SETCHR, READCHR$). 10+: draws into SETTEX texture (logical BG = texture ID + 10); Undefined texture if it is missing. Bitmap and character choices are kept separately; CLS/MOSAIC/DISPLAY ACTIVE use the last one set, and the ROT commands use BG 8 or 9. Logical BG numbers: 0/1 bitmap, 2 bitmap rotation, 4-7 character screens, 8/9 character rotation, 10+ sprites/polygons (texture ID + 10 for a SETTEX texture).",
    source: "Ref. pp. 117-118",
  },
  CCOPY: {
    syntax: "CCOPY [<BG>,](x1,y1)-(x2,y2) TO [<BG>,](x,y)\nCCOPY <string> TO [<BG>,](x,y)\nCCOPY [<BG>,](x1,y1)-(x2,y2) TO <string variable>   (e.g. CCOPY 0,(0,0)-(20,7) TO V$)",
    summary: "Copies a rectangle of a character screen, in characters, always top-left first, line by line. Coordinates wrap by the screen width (for scrolling). The string form is: width and height in characters (1 byte each, 1-128), then 2 bytes per character (pattern name, high byte first). BG defaults to the last ACTIVE character screen.",
    source: "Ref. pp. 118-120",
  },
  CIRCLE: {
    syntax: "CIRCLE(x,y),<radius>[,[<colour>][,F]]\nCIRCLE(x,y),(<x radius>,<y radius>)[,[<colour>][,F]]   (e.g. CIRCLE(100,100),10,15)",
    summary: "Draws a circle or ellipse in dots on the ACTIVE bitmap, inside the WINDOW clip area. Colour defaults to COLOR; F fills it.",
    source: "Ref. p. 120",
  },
  CLS: {
    syntax: "CLS [<logical BG>][,<logical BG>...]\nCLS -1\nCLS ACTIVE   (e.g. CLS, CLS 0,4,5)",
    summary: "Clears screens; no number means the text screen, -1 means every screen except textures. A bitmap (0-2) or texture (10+) is filled with the COLOR background colour inside WINDOW; a character screen (4-8) with word &H0000, and the text screen with spaces (&H20) inside WIDTH.",
    source: "Ref. p. 121",
  },
  COLOR: {
    syntax: "COLOR [<text colour>][,[<draw colour>][,[<background colour>][,<border colour>]]]   (e.g. COLOR 5, COLOR A,,15-A)",
    summary: "At least one value is needed; the rest keep their settings. Text colour 0-15 (via the text palette). Draw/background: RGB(r,g,b) = r+g*32+b*1024 in 32768-colour mode (-1 = transparent), or a palette number 0-255 in 256-colour mode. Border 0-32767, or a word string of up to 224 line colours, top to bottom.",
    source: "Ref. p. 122",
  },
  COLOROFS: {
    syntax: "COLOROFS {ON|OFF}[,]<logical BG>[,<logical BG>...]\nCOLOROFS (<R>,<G>,<B>)",
    summary: "Colour offset (tint) for BG and sprite planes (sprites are 10): the first form picks the screens, the second sets the offset, -255 to +255 each (Illegal function call outside). Several numbers can be listed and ON/OFF mixed; the last mention of a number wins, and ending with ON or OFF applies it to every BG in the mode. Tinting sprites affects the virtual keyboard too. SCREEN turns it off and resets to (0,0,0). Fade out: COLOROFS ON: FOR I=0 TO 255: COLOROFS (-I,-I,-I): VSYNC: NEXT.",
    source: "Ref. p. 123",
  },
  DISPLAY: {
    syntax: "DISPLAY {ON|OFF}[,]<logical BG>[,<logical BG>...]   (e.g. DISPLAY OFF 4)",
    summary: "Shows or hides BG screens; ACTIVE can stand for a number. Several numbers can be listed and ON/OFF mixed; the last mention of a number wins, and ending with ON or OFF applies it to every BG in the mode. DISPLAY OFF hides everything (press F12 to bring the text screen back). Hiding rotation screens while drawing speeds things up. \"DISPLAY OFF,ON 3\" is not allowed: use two statements. SCREEN turns all on.",
    source: "Ref. p. 124",
  },
  GCOPY: {
    syntax: "GCOPY [<BG>,](x1,y1)-(x2,y2) TO [<BG>,](x,y)\nGCOPY <string> TO [<BG>,](x,y)\nGCOPY [<BG>,](x1,y1)-(x2,y2) TO <string variable>   (e.g. GCOPY 0,(0,0)-(99,99) TO 1,(100,0))",
    summary: "Copies a rectangle of a bitmap screen, in dots, top-left first. X wraps at 512 and Y at 256. With a texture (BG 10+) only the string forms work; string to texture clips to the texture (negative positions allowed). Bitmap strings: width and height (2 bytes each, high byte first), then 1 byte per dot (256 colours, no palette) or 2 bytes per dot (32768 colours, bit 15 set, 0 = transparent), the same as a .1 file and a .0 file without its palette.",
    source: "Ref. pp. 125-127",
  },
  KLOAD: {
    syntax: "KLOAD [ON[,{1|2}]]\nKLOAD OFF",
    summary: "Loads the kanji font from the CD so KPRINT can show kanji: 1 = JIS level 1 only (722 blocks of 256 bytes), 2 or nothing = levels 1 and 2 (991 blocks), taken from the program area (Out of memory if the program is too big). OFF frees it. Both do CLEAR 0,256,256, so put KLOAD at the start of a program before CLEAR.",
    source: "Ref. pp. 127-128",
  },
  LINE: {
    syntax: "LINE [(x1,y1)]-(x2,y2)[,[<colour>][,B|BF]]   (e.g. LINE(0,0)-(100,100), LINE-(200,0),,B, LINE(X,Y)-(XX,YY),C,BF)",
    summary: "Draws a line, or with B a box and with BF a filled box, on the ACTIVE bitmap inside WINDOW. Without a start point it continues from the last LINE or PSET point. Colour defaults to COLOR.",
    source: "Ref. pp. 132-133",
  },
  MOSAIC: {
    syntax: "MOSAIC {ON|OFF}[,]<logical BG>[,<logical BG>...]\nMOSAIC (<width dots>,<height dots>)   (e.g. MOSAIC ON 4, MOSAIC (4,4))",
    summary: "Mosaic effect, 1-16 dots each way. Several numbers can be listed and ON/OFF mixed; the last mention of a number wins, and ending with ON or OFF applies it to every BG in the mode. Rotation screens (2, 8, 9) only get horizontal mosaic; sprites and polygons (10+) give Illegal function call. MOSAIC ON 4 blocks the text screen; F12 restores it. SCREEN turns it off and sets (1,1).",
    source: "Ref. pp. 133-134",
  },
  PAINT: {
    syntax: "PAINT(x,y)[,<fill colour>[,<border colour>...]]\nPAINT(x,y) ON [<fill colour>]   (e.g. PAINT(100,100),C, PAINT(X,Y) ON,-1)",
    summary: "Fills on the ACTIVE bitmap inside WINDOW. The first form fills up to the border colour(s) (no border means border = fill colour); ON fills the area of the same colour as the start point. Fill defaults to COLOR; -1 is transparent (colour 0 in 256-colour mode). Does nothing if the start is already the fill colour.",
    source: "Ref. pp. 134-135",
  },
  PALETTE: {
    syntax: "PALETTE [<logical BG>],<palette number>[,{<value>|<word string>}...]\nPALETTE [<logical BG>],-1   (e.g. PALETTE ,C,RGB(R,G,B), PALETTE ,15,A$, PALETTE 0,-1)\nPALETTE([<logical BG>],<palette number>)   (function, e.g. A = PALETTE(0,255))",
    summary: "Sets palette entries from the given number on (1-255; 0 is always transparent): RGB(r,g,b) values, or a word string (2 bytes per entry, high byte first; low 15 bits used). -1 restores the defaults. 16-colour text: entry n*16+15 is the letter colour and n*16+1 the outline. BG 10 sets the sprite/polygon palette (0-511); in mode 6 BGs 8 and 9 share one palette (0-511). As a function it returns the 15-bit colour (r + g*32 + b*1024); BG 10 reads the sprite/polygon palette.",
    source: "Ref. pp. 136-137, 158-159",
  },
  PRIORITY: {
    syntax: "PRIORITY <logical BG>,<priority>   (e.g. PRIORITY 0,5)",
    summary: "Display order, 0-7: higher is in front, ties go to the lower BG, 0 hides it. Defaults: bitmaps 2, character screens 6/5/4/3, rotation 1, sprites 6. BG 10-16 set sprite priority registers 0-6; a sprite uses register n when SETATR adds n*&H1000 to its texture ID (an 8th register is the virtual keyboard's, fixed at 7). The manual's syntax box misprints it as PRIORYTY.",
    source: "Ref. pp. 137-138",
  },
  PSET: {
    syntax: "PSET (x,y)[,<colour>]   (e.g. PSET (100,100),&H7FFF)",
    summary: "Plots a dot on the ACTIVE bitmap inside WINDOW. Colour defaults to COLOR. Also sets where a LINE without a start point begins.",
    source: "Ref. p. 139",
  },
  PUTCHR: {
    syntax: "PUTCHR [<logical BG>][,](<x>,<y>),{<word string>|<value>}[,...]\nPUTCHR [<logical BG>],<VRAM address>,{<word string>|<value>}[,...]   (e.g. PUTCHR 4,(10,10),ASC(\"3\")+&H5000)",
    summary: "Writes pattern-name words to a character screen at a character position (wrapped to the map size) or a VRAM address 0-65535 (made even, wrapped to the screen size). Each word: bits 15-12 palette, 11 flip vertical, 10 flip horizontal, 9-0 character number (the character code on the text screen; pattern number x2 on other character screens). PUTCHR 4,(10,12),STRW$(10,&H5034) writes ten \"4\"s.",
    source: "Ref. pp. 139-141",
  },
  ROTATE: {
    syntax: "ROTATE [<X angle>][,[<Y angle>][,<Z angle>]]   (e.g. ROTATE X,Y,Z, ROTATE ,,0.5)",
    summary: "Only in modes with a rotation screen; in mode 6 it applies to the rotation screen chosen with ACTIVE (8 or 9). Angles are in turns (1.000 = 360\u00b0; the whole-number part is ignored): Z 0.25 turns 90\u00b0 clockwise, 0.5 180\u00b0. X and Y only work in modes 5 and 6 (3-axis); modes 2 and 3 rotate about Z only. SCREEN resets to 0,0,0.",
    source: "Ref. p. 142",
  },
  ROTCENTER: {
    syntax: "ROTCENTER <X>,<Y>,<Z>   (e.g. ROTCENTER 160,112,0)",
    summary: "Only in modes with a rotation screen; in mode 6 it applies to the rotation screen chosen with ACTIVE (8 or 9). Centre of rotation; Z is ignored in modes 2 and 3. On a 1-axis screen it is measured from the top-left (SCREEN sets 160,112,0); on a 3-axis screen from the screen centre, in the opposite direction (SCREEN sets 0,0,0). 3-axis order: ROTPOS move, 1/ROTZOOM scale, ROTATE Z then Y then X, ROTCENTER move.",
    source: "Ref. pp. 142-143",
  },
  ROTOVER: {
    syntax: "ROTOVER <outside mode>[,<repeat character>]   (e.g. ROTOVER 1,ASC(\"X\")+&H7000)",
    summary: "Only in modes with a rotation screen; in mode 6 it applies to the rotation screen chosen with ACTIVE (8 or 9). What shows outside the rotation screen: 0 repeats the image, 1 fills with the repeat character (a pattern-name word as in PUTCHR, 0-65535), 2 transparent (the default; SCREEN sets 2 and 0). In mode 6, mode 2 reserves the last character (&H3FF for 16 colours, &H1FF for 256) as the transparent one.",
    source: "Ref. pp. 143-144",
  },
  ROTPOS: {
    syntax: "ROTPOS [<X distance>][,[<Y distance>][,<Z distance>]]   (e.g. ROTPOS 100, ROTPOS ,,ZP)",
    summary: "Only in modes with a rotation screen; in mode 6 it applies to the rotation screen chosen with ACTIVE (8 or 9). Distance from the viewpoint to the centre of the rotation screen; Z can't be negative and is ignored in modes 2 and 3. SCREEN resets to 0,0,100.",
    source: "Ref. pp. 144-145",
  },
  ROTZOOM: {
    syntax: "ROTZOOM [<X scale>][,[<Y scale>][,<Z scale>]]   (e.g. ROTZOOM 2,2, ROTZOOM -1)",
    summary: "Only in modes with a rotation screen; in mode 6 it applies to the rotation screen chosen with ACTIVE (8 or 9). Scale along each axis; a negative value mirrors that axis. Z is ignored in modes 2 and 3; 3-axis screens are also affected by SETPERS. Normal screens use ZOOM. SCREEN resets to 1,1,1.",
    source: "Ref. p. 145",
  },
  SCROLL: {
    syntax: "SCROLL [<logical BG>],[STEP][<X>][,<Y>]   (e.g. SCROLL 0,SX,SY, SCROLL 4,STEP 0,1)",
    summary: "Sets which point of the screen shows at the top-left, in dots (low 10 bits used). BG 0, 1 or 4-7 only (rotation screens can't scroll); defaults to ACTIVE. A left-out X or Y keeps its value; STEP moves relative to now (left out = 0). SCREEN resets to 0,0.",
    source: "Ref. p. 151",
  },
  SETCHR: {
    syntax: "SETCHR [<logical BG>],[<pattern number>],<string>\nSETCHR [<logical BG>],[<pattern number>],<byte count>,READ   (e.g. SETCHR 4,ASC(\"A\"),STRING$(32,&HFF))",
    summary: "Writes 8x8 character patterns, row by row from the top-left: 64 bytes (1 per dot) on a 256-colour character screen, 32 bytes (4 bits per dot) on the 16-colour text screen. Pattern 0-511 (or 0-1023); left out, it continues after the last SETCHR/READCHR$ (give it when changing BG). READ takes the bytes from hex DATA strings (2 digits per byte, e.g. DATA 00FFF000 or DATA 00,FF,F0,00). Each BG has its own patterns, except BGs 8 and 9 in mode 6. Ctrl+P restores the text font.",
    source: "Ref. pp. 152-154",
  },
  VSYNC: {
    syntax: "VSYNC [<frames>]   (e.g. VSYNC, VSYNC 2)",
    summary: "Waits about n/60 s (default 1; 0 returns at once). Timer interrupts still run meanwhile; don't use VSYNC inside an interrupt routine as well.",
    source: "Ref. p. 154",
  },
  WINDOW: {
    syntax: "WINDOW [<left>],[<top>][,<right>][,<bottom>]   (e.g. WINDOW 0,0,200,223)",
    summary: "Clip area for bitmap drawing (CIRCLE, LINE, PAINT, PSET, ...), shared by all bitmap screens and within the bitmap size; right >= left and bottom >= top. For a texture chosen with ACTIVE it is within the texture and is reset to the texture size on every ACTIVE, so set it after ACTIVE. SCREEN and Ctrl+P reset it to 0,0,319,223.",
    source: "Ref. p. 155",
  },
  ZOOM: {
    syntax: "ZOOM [<logical BG>],[<width scale>][,<height scale>]   (e.g. ZOOM 0,2,2)",
    summary: "Enlarges a normal screen (BG 0, 1 or 4-7 where the mode allows zoom; rotation screens use ROTZOOM). Scales are 1.0 or more; left out they keep their value. BG defaults to ACTIVE. SCREEN resets to 1.0.",
    source: "Ref. p. 156",
  },
  GETCHR: {
    syntax: "GETCHR([<logical BG>],(<x>,<y>))\nGETCHR([<logical BG>],<VRAM address>)   (e.g. A = GETCHR(4,(X,Y)), A = GETCHR(4,&H800))",
    summary: "Function. Reads the pattern-name word (0-65535) at a character position (wrapped to the map size) or VRAM address (made even, wrapped). Bits 15-12 palette, 11 flip vertical, 10 flip horizontal, 9-0 character number (as PUTCHR). BG defaults to the last ACTIVE character screen.",
    source: "Ref. pp. 157-158",
  },
  POINT: {
    syntax: "POINT(x,y)   (e.g. A = POINT(X,Y))",
    summary: "Function. Colour of a dot on the ACTIVE bitmap or texture: 0-32767 in 32768-colour mode (0 is black), 1-255 in 256-colour mode; -1 transparent (colour 0 in 256-colour mode), -2 off the screen. Not limited by WINDOW.",
    source: "Ref. p. 159",
  },
  'READCHR$': {
    syntax: "READCHR$([<logical BG>],[<pattern number>],<byte count>)   (e.g. A$ = READCHR$(,10,10))",
    summary: "Function. Returns character pattern data as a binary string, in the SETCHR layout (64 bytes per 256-colour character, 32 per 16-colour text character). Pattern 0-511 (or 0-1023); left out, it continues after the last READCHR$/SETCHR. BG defaults to ACTIVE.",
    source: "Ref. p. 160",
  },
  'READHEX$': {
    syntax: "READHEX$(<byte count>)   (e.g. PTN$ = READHEX$(16))",
    summary: "Function. Reads that many bytes from hex DATA (DATA AA,BB,CC or DATA 12345678; an odd last digit counts as 0x) and returns them as a binary string, carrying on into the next DATA line. Unlike READ, the rest of the last DATA line is skipped. Out of DATA if there isn't enough.",
    source: "Ref. pp. 161-162",
  },
  RGBADD: {
    syntax: "RGBADD(<RGB value>,<red change>,<green change>,<blue change>)   (e.g. A = RGBADD(PLT,10,-4,2))",
    summary: "Function. Adds to each 5-bit colour part, clamped to 0-31; bits above 14 are kept. Useful for fades.",
    source: "Ref. p. 163",
  },
  RGBTO: {
    syntax: "RGBTO(<RGB value>,<target RGB value>)   (e.g. C = RGBTO(C,TARGET))",
    summary: "Function. Moves each colour part one step towards the target; bits above 14 come from the target. Call it repeatedly for a fade.",
    source: "Ref. p. 164",
  },
  CAMERA: {
    syntax: "CAMERA (XO,YO,ZO)[,<bank>] TO <object no>[,BG]\nCAMERA (XO,YO,ZO)[,<bank>] TO (XT,YT,ZT)[,BG]   (e.g. CAMERA (0,-200,200) TO 1,BG)",
    summary: "Points the camera (OBJECT 0) from (XO,YO,ZO) at an object (1 or more) or a point. Bank tilts about Z, 0-1 turns. Sets OBJECT 0 matrix order to 7 if below 6, its angles and position (-XO,-YO,-ZO). Only objects that are children of OBJECT 0 are aimed correctly. BG also sets the 3-axis rotation screen (BG8) to match, modes 5/6 only (else Illegal function call). CAMERA (0,0,-200) TO (0,0,0) restores the post-SCREEN view.",
    source: "Ref. pp. 165-167",
  },
  SETDISP: {
    syntax: "SETDISP <level>   (e.g. SETDISP 7)",
    summary: "Level 1-7: how far in front of the projection plane perspective polygons are still drawn; larger is nearer. 1 = half the viewpoint-to-plane distance, each step halves it (7 = 1/128).",
    source: "Ref. p. 169",
  },
  SETLIGHT: {
    syntax: "SETLIGHT <X dir>,<Y dir>,<Z dir>[,<light colour>][,<ambient colour>]   (e.g. SETLIGHT 1,0,0)",
    summary: "One parallel light for polygons and textures whose attribute enables lighting. Colours are 15-bit RGB. SCREEN resets to direction 1,1,0.5, light RGB(28,28,28), ambient RGB(0,0,0). Overflow if the direction maths passes &H1FFFF.",
    source: "Ref. p. 170",
  },
  SETPERS: {
    syntax: "SETPERS <angle>   (e.g. SETPERS 90)",
    summary: "Field of view in degrees, 10-160, for perspective objects, sprites and 3-axis rotation screens. SCREEN resets it to 90.",
    source: "Ref. p. 170",
  },
  SETPFONT: {
    syntax: "SETPFONT [<OBJECT ID>],<font no>[,(<scale X>,<scale Y>,<scale Z>)][,(<pos X>,<pos Y>,<pos Z>)][,<colour>][,<attribute ID>]   (e.g. SETPFONT 1,ASC(\"A\"))",
    summary: "Builds a polygon character: font 1-14 simple shapes, 48-57 digits, 65-90 A-Z. Creates vertices and polygons (normals automatic) at the next free IDs. With an OBJECT ID it sets that object's polygon and attribute, and an empty object becomes a TYPE 4 child of OBJECT 0. Scale default 1, position added after scaling. Colour 15-bit RGB, default RGB(15,15,15), for a new attribute. Attribute ID left out: a new one.",
    source: "Ref. pp. 170-171",
  },
  SETPOLYGON: {
    syntax: "SETPOLYGON [<polygon ID>],<count>,<vertex ID>[,{(<normal>)|+|-},(<vertex list>)...]\nSETPOLYGON {(<normal>)|+|-},(<vertex list>)\nSETPOLYGON <polygon ID>,<count>,<vertex ID>,READ   + DATA [(<normal>)],(<vertex list>)...   (e.g. SETPOLYGON 0,1,0,,(0,1,2,3))",
    summary: "Defines a group of quads on a SETVERTEX group. Vertex list (P1,P2,P3,P4) clockwise seen from the front; leave out P4 for a triangle. Normal: a unit vector, or left out to compute it; - reverses it. Form 1 starts a group (ID left out: lowest free, POLYGONID(-1)), form 2 continues it, form 3 reads DATA. IDs must be defined in order from 0; redefine only with the same count. SCREEN clears.",
    source: "Ref. pp. 172-174",
  },
  SETSPRITE: {
    syntax: "SETSPRITE <sprite no>[,<palette 0|1>][,<flip>]   (e.g. SETSPRITE 1,1,&B10)",
    summary: "Sprite 1-255. Palette 0 uses PALETTE 10,0-255; 1 uses PALETTE 10,256-511. Flip 0 none, 1 X, 2 Y, 3 both. Shows the sprite if sprite display is on; values left out are kept. SCREEN resets.",
    source: "Ref. p. 175",
  },
  SETVERTEX: {
    syntax: "SETVERTEX [<vertex ID>],<count>[,[@<vertex no>,](XP,YP,ZP)...]\nSETVERTEX [@<vertex no>,](XP,YP,ZP)\nSETVERTEX [<vertex ID>],<count>,READ[,(<scale X>,<scale Y>,<scale Z>)[,(<pos X>,<pos Y>,<pos Z>)]]   + DATA XP,YP,ZP...   (e.g. SETVERTEX 0,4,(-10,-10,0),(10,-10,0),(10,10,0),(-10,10,0))",
    summary: "Defines a vertex group. Form 1 starts a group (ID left out: lowest free, VERTEXID(-1)), form 2 continues it, form 3 reads DATA (X, Y, Z in one DATA line; scale default 1, position added after scaling). @n rewrites one vertex (0 to count-1); normals are not recalculated, so run SETPOLYGON again. IDs in order from 0. SCREEN clears.",
    source: "Ref. pp. 175-176",
  },
  'SPRITE$': {
    syntax: "SPRITE$(<pattern no>)=<string>   (e.g. SPRITE$(1)=STRING$(16*16,CHR$(&HAA)))",
    summary: "Defines sprite pattern 0-255: always 16x16, 256 colours, one byte per dot (up to 256 bytes, else Table size error). Shares the SETTEX texture area but can be defined in any order; a new pattern takes the slot after the last SETTEX. SCREEN clears.",
    source: "Ref. p. 177",
  },
  SPRWINDOW: {
    syntax: "SPRWINDOW [<left>][,<top>][,<right>][,<bottom>][,<ZLIMIT>][,<CX>][,<CY>]   (e.g. SPRWINDOW ,,,,,0,0)",
    summary: "Clip window for sprites and polygons whose SETATR mode asks for inside/outside the window (SETPFONT uses inside). Width 1-320, height 1-224. ZLIMIT 0-&H7FFF: nothing beyond it is drawn. CX,CY 0-319/0-223: vanishing point and sprite origin. SCREEN sets 0,0,319,223,&H7FFF,160,112.",
    source: "Ref. p. 178",
  },
  OBJ: {
    syntax: "OBJ(<object no>,<item>)=<value>[,<value>...]\nOBJ(<object no>,<item>)   (function)\nOBJ COPY <from> TO <to>[,<to>...]\nOBJ CLEAR\nOBJ NEW\nOBJ PRINT <object no>[,P]   or   OBJ ?[<object no>][,P]   (e.g. OBJ(1,@XP)=100,100,50)",
    summary: "The table behind every sprite and polygon: each object number has numbered items (@TYPE, @XP, @ATR...), shown every frame. Object -1 is the shredder (parent -1 deletes), 0 the world/viewpoint (parent 0 shows), 1 and up are objects. Extra values go into the following items; an empty one is skipped. OBJPOS, OBJROT and similar are shorthands. Positions, speeds and scales are fixed point up to about +-&H7FFF.FFFC (higher bits are dropped with no Overflow, so the sign can flip); angles are 0 to just under 1 turn. OBJ CLEAR resets every object; OBJ NEW also forgets all texture, attribute, vertex and polygon IDs. OBJ PRINT lists an object's children (P pauses each screenful, Ctrl+C stops). Object 0 starts at ZP 200, so the viewpoint is 200 in front of the world origin. Item numbers: hover an @ name such as @TYPE.",
    source: "Ref. pp. 179-214",
  },
  OBJATR: {
    syntax: "OBJATR <object no>[,<polygon ID>][,<attribute ID>]",
    summary: "Gives object 1-255 its polygon ID (SETPOLYGON shape) and attribute ID (SETATR face data). Either can be left out with a comma, but give at least one. Shorthand for OBJ(<object no>,@ATR)=...; see @ATR and @POLYGON. The manual lists the parameters attribute first but the syntax and alias put them in different orders, so check on hardware which comes first.",
    source: "Ref. p. 215",
  },
  OBJLINK: {
    syntax: "OBJLINK <object no>,<parent object no>   (e.g. OBJLINK 1,2)",
    summary: "Makes object 1-255 a child of parent -1-255; its own children move with it. Parent 0 shows it in the world; parent -1 breaks up everything below it and copies object -1 into it (normally back to unused). Shorthand for OBJ(<object no>,@PARENT)=...",
    source: "Ref. pp. 215-216",
  },
  OBJPOS: {
    syntax: "OBJPOS <object no>,[<X>],[<Y>],[<Z>]   (e.g. OBJPOS 1,,,300)",
    summary: "Position of object -1-255 relative to its parent. Values can be left out with commas, but give at least one. Shorthand for OBJ(<object no>,@XP)=...",
    source: "Ref. p. 216",
  },
  OBJROT: {
    syntax: "OBJROT <object no>[,<X angle>][,<Y angle>][,<Z angle>]   (e.g. OBJROT 1,,0.5)",
    summary: "Rotation of object -1-255 relative to its parent, in turns (0.5 = 180 degrees). Values can be left out with commas, but give at least one. Shorthand for OBJ(<object no>,@XR)=...",
    source: "Ref. pp. 216-217",
  },
  OBJTURN: {
    syntax: "OBJTURN <object no>,[<X spin>],[<Y spin>],[<Z spin>]   (e.g. OBJTURN 1,,,&H0.01)",
    summary: "Spin speed of object -1-255: added to its X/Y/Z angle every VSYNC. Any non-zero value keeps an object linked to object 0 turning until the program stops it. Values can be left out with commas, but give at least one. Shorthand for OBJ(<object no>,@XRV)=...",
    source: "Ref. p. 217",
  },
  OBJTYPE: {
    syntax: "OBJTYPE <object no>,<TYPE>   (e.g. OBJTYPE 1,4)",
    summary: "Display type 0-7 of object 1-255 (fraction dropped); see @TYPE. Giving an unused object a type links it to object 0. Shorthand for OBJ(<object no>,@TYPE)=...",
    source: "Ref. pp. 217-218",
  },
  OBJZOOM: {
    syntax: "OBJZOOM <object no>,[<X scale>],[<Y scale>],[<Z scale>]   (e.g. OBJZOOM 1,2,2,2)",
    summary: "Scale of object -1-255 (default 1.0). Scales on objects 1 and up do not pass to children, and normals are not rescaled. For true size on orthographic polygons (type 5) and sprites (type 7) use 0.99995 (&H0.FFFC) for X and Y, not 1. Values can be left out with commas, but give at least one. Shorthand for OBJ(<object no>,@XS)=...",
    source: "Ref. p. 218",
  },
  SETATR: {
    syntax: "(1) SETATR [<attribute ID>],<count>[,(<parameter 1>)][,(<parameter 2>)...]\n(2) SETATR (<parameter 1>)[,(<parameter 2>)...]\n(3) SETATR <attribute ID>,<count>,READ ... DATA (<parameter>)[,(<parameter>)...]\nparameter = (<TYPE>,<SURFACE>,<SORT>,<texture ID>,<COLOR>,<MODE>)   (e.g. SETATR 1,1,(0,1,3,1,0,0))",
    summary: "Defines how each face of a SETPOLYGON polygon is drawn, one parameter group per face; count must be at least the polygon's face count or the object is not shown. (1) starts a new attribute ID (left out: the lowest free one, read with ATRID(-1)); the first group fills every face, and with none the defaults are TYPE 4, SURFACE 1, SORT 2, texture 0, COLOR RGB(0,15,15), MODE 72. (2) continues after the last one. (3) reads groups from DATA. TYPE: 0-3 texture (no flip, left-right, up-down, both), 4 polygon, 5 polyline, 6 line through the first 2 points. SURFACE: 0 one-sided, 1 two-sided. SORT: 0 previous polygon, 1 nearest of the 4 points, 2 farthest, 3 average. Texture ID: a SETTEX ID (texture types only); add a priority register n*&H1000 (PRIORITY). COLOR: for 16/256-colour textures the palette offset (multiple of 16 or 256; address = offset + dot code, 512 sprite colours, set with PALETTE 10...); for types 4-6 an RGB value; 0 for 32768-colour textures. MODE bits: 0-1 draw (0 overwrite, 1 shadow, 2 half-bright, 3 half-transparent), 3 lit by the light source, 5 palette colour for polygons, 6-7 window (0 ignore, 1 inside, 2 outside), 8 mesh. Define IDs in order from 0. Same ID and count can be redefined, otherwise Attribute size mismatch. SCREEN clears all attributes.",
    source: "Ref. pp. 218-221",
  },
  SETTEX: {
    syntax: "(1) SETTEX [<texture ID>],<XS>,<YS>,<COLOR_DEPTH>[,<string>]\n(2) SETTEX <string>\n(3) SETTEX <texture ID>,<XS>,<YS>,<COLOR_DEPTH>,READ ... DATA <hex>   (e.g. SETTEX 1,8,8,256,HEXBIN$(STRW$(64,\"FF\")))",
    summary: "Defines a texture (bitmap pasted on a polygon face; a textured polygon is a sprite). XS 8-504 in steps of 8, YS 1-255, colour depth 16 (1 byte = 2 dots, palette), 256 (1 byte per dot, palette) or 32768 (2 bytes per dot, high byte first: bit 15 = 1 shown, then BBBBB GGGGG RRRRR; &H0000 is transparent). 8x8 needs 32, 64 or 128 bytes. (1) starts a new ID (left out: the lowest free one, read with TEXID(-1)); (2) continues after the last data, extra bytes ignored; (3) reads hex from DATA, either comma-separated (DATA AA,BB,CC) or run together (DATA AABBCC; an odd last digit gets a leading 0), and too little data is an error. Textures sit in sprite VRAM in ID order, so define IDs from 0: starting at 10 means 0-9 can no longer be added (Table size error). Same ID, size and depth can be redefined, otherwise Texture size mismatch; too much data is Texture data over. SCREEN resets the allocation but keeps the pixels. CLS <ID+10> clears one; bitmap commands can draw into it via logical BG ID+10 (ACTIVE).",
    source: "Ref. pp. 222-223",
  },
  ATRID: {
    syntax: "ATRID(<attribute ID>)   (e.g. NEXT_ATTR = ATRID(-1))",
    summary: "Returns the next attribute ID after the highest one defined so far, for a new SETATR. Only -1 is supported as the parameter; fractions are dropped.",
    source: "Ref. p. 224",
  },
  POLYGONID: {
    syntax: "POLYGONID(<polygon ID>[,<element>[,<item>]])   (e.g. POLYGONID(-1), POLYGONID(0))",
    summary: "-1: the next polygon ID after the highest defined, for a new SETPOLYGON. For a defined ID: no element = its face count (0 = undefined); element 0 to count-1 alone = the vertex ID it uses; with item 0-3 = that face's vertex list p1-p4; item 4-6 = that face's normal X, Y, Z. Giving an element for an undefined ID is Undefined polygon. Fractions are dropped.",
    source: "Ref. pp. 224-225",
  },
  TEXID: {
    syntax: "TEXID(<texture ID>[,<item>])   (e.g. TEXID(-1))",
    summary: "-1: the next texture ID after the highest defined, for a new SETTEX. For a defined ID, item 0 = width in dots, 1 = height, 2 = colour depth (16, 256 or 32768). Fractions are dropped.",
    source: "Ref. pp. 225-226",
  },
  VERTEXID: {
    syntax: "VERTEXID(<vertex ID>[,<element>[,<item>]])   (e.g. PRINT VERTEXID(-1))",
    summary: "-1: the next vertex ID after the highest defined, for a new SETVERTEX. For a defined ID: no element = its vertex count (0 = undefined); element 0 to count-1 with item 0, 1 or 2 = that vertex's X, Y or Z. Giving an element for an undefined ID is Undefined vertex. The manual's heading calls it VERTEX. Fractions are dropped.",
    source: "Ref. pp. 226-227",
  },
  FILES: {
    syntax: "FILES \"[<device>:][<pattern>]\"[,P]   (e.g. FILES, FILES \"COM:SAMPLE??\", FILES F$)",
    summary: "Lists matching files, 10 characters per name plus 2 separator spaces, wrapping as needed. Wildcards ? and * work; no pattern lists everything, no extension matches all extensions. P pauses when the screen is full (any key continues). Except on CD:, the last line is \"Free size <free> / <total> file blocks\" (1 block = 64 bytes). Device defaults to the last one used.",
    source: "Ref. pp. 100-101; Tut. pp. 29-30",
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
    syntax: "KPRINT [(x,y[,<x spacing>,<y spacing>,<half-width offset>]),][FIX][<string>][;][,<text colour>][,<SCALE>][,<background colour>]\nKPRINT (x,y)\nKPRINT PALETTE [<BG>],<first palette number>,<base colour>",
    summary: "Draws Shift-JIS or single-byte text on the ACTIVE bitmap (0-2) or sprites (10). Needs KLOAD, except with FIX (the 8x8 text font). SCALE 8-16 sets the size (default 16); spacing and offset are -128 to 127 and stay set. Colours default to COLOR; the background may be -1 (transparent), the text colour may not. \";\" keeps the position for the next KPRINT; CHR$(13)/CHR$(10) work inside the string. KPRINT PALETTE makes 3 shaded palette entries from the base colour for smooth 256-colour text when SCALE is under 16. SCREEN resets the settings.",
    source: "Ref. pp. 128-132",
  },
  LOAD: {
    syntax: "LOAD \"[<device>:]<name>\"[,R][,M]   (e.g. LOAD \"SAMPLE\", LOAD \"BRAM:MAIN\",R, LOAD F$,R)",
    summary: "Loads a program; .B is always added. R runs it. Memory is cleared first, so an error while loading loses the old program. M merges into the current program (COM:, or a .D text file on BRAM:, CRAM:, FD0:, FD1:): lines with the same number are replaced, new ones added, lines without a number ignored. Text files made elsewhere need CR+LF at each line end (CR is ignored, LF ends the line). In a program it keeps the CLEAR user area, textures, vertices, polygons, attributes and sound data. If LOAD/SAVE over COM: fails while the Saturn is busy, press Ctrl+P or F12, or run SCREEN 0.",
    source: "Ref. pp. 97, 108-109; Tut. p. 152",
  },
  OPEN: {
    syntax: "OPEN \"[<device>:]<name>\" [FOR {INPUT|OUTPUT|APPEND}] AS [#]<file number>   (e.g. OPEN \"SAVE.D\" FOR INPUT AS 1)",
    summary: "File number 1 or 2 (from OPEN). INPUT: read only, the file must exist and be .D. OUTPUT: new write-only file (created if missing; old contents not read). APPEND: the file must exist; it is read into the file area and SEEK goes to the end. No FOR: read and write. Files OPEN creates get .D. Errors: File already open, Not enough space (99 files on a backup device).",
    source: "Ref. pp. 110-111",
  },
  PUTSPRITE: {
    syntax: "PUTSPRITE <sprite no>,[(x,y)][,<pattern no>]   (e.g. PUTSPRITE 1,(100,150),0)",
    summary: "Shows sprite 1-255 at (x,y) with pattern 0-255 (SPRITE$). Written into the OBJECT of the same number: @XP = x-CX-8, @YP = y-CY-8, @ZP = 200 (CX,CY from SPRWINDOW). Pattern left out: the last one (0 if never set). Undefined texture if the pattern is not defined. For MSX BASIC compatibility. SCREEN clears it.",
    source: "Ref. pp. 167-168; Tut. p. 53",
  },
  RENUM: {
    syntax: "RENUM [<new number>][,<old number>][,<step>]",
    summary: "Direct command. Renumbers from line <old number> (all lines if left out) to start at <new number> (100) in steps of <step> (10), all 1-99999. Not allowed if lines would collide or go past 99999. E.g. RENUM 1000,320 or RENUM ,,100.",
    source: "Ref. p. 73; Tut. p. 34",
  },
  RGB: {
    syntax: "RGB(<red>,<green>,<blue>)   (e.g. A = RGB(R,G,B))",
    summary: "Function. Colour value (r AND 31) + (g AND 31)*32 + (b AND 31)*1024, for PALETTE and 32768-colour mode. Texture and bitmap-file colours need OR &H8000.",
    source: "Ref. p. 162; Tut. pp. 44, 66",
  },
  SAVE: {
    syntax: "SAVE \"[<device>:]<name>\"[,A]   (e.g. SAVE \"SAMPLE\", SAVE \"BRAM:MAIN\", SAVE F$)",
    summary: "Direct statement only. Saves the program as .B. A (FD0:, FD1:, BRAM:, CRAM: only) saves it as a .D text file that OPEN can read and LOAD \"....D\" can load or merge; this needs a file buffer from CLEAR at least as big as the text, or Out of memory.",
    source: "Ref. pp. 111-112; Tut. p. 29",
  },
  SCREEN: {
    syntax: "SCREEN [<mode>][,[<text BG>][,[<text colours>][,<frame unit>]]]   (e.g. SCREEN 0, SCREEN ,4,256)",
    summary: "Sets the screen mode 0-6 and resets the screens (no mode keeps the current one). Text BG: any character screen in the mode, including a rotation one (default the lowest). Text colours 16 (default) or 256 (then the COLOR text colour is ignored). Frame unit -8..-1 or 1..8 (default 1): sprites/polygons swap buffers every n/60 s; positive waits for all polygons, negative cuts them off. Modes: 0 = bitmap 0 (32768 colours) + char 4, 5; 1 = bitmaps 0, 1 (256) + char 4, 5; 2 = char 4, 5 + rotation 8 (Z); 3 = bitmap rotation 2 (Z) + char 4, 5; 4 = char 4-7 (256 colours); 5 = char 4, 5 + rotation 8 (3-axis); 6 = char 4, 5 + rotation 8, 9 (3-axis). Resets VRAM, scroll, zoom, priorities, rotation, palettes, text font, WIDTH 1,1,38,26, WINDOW 0,0,319,223, ACTIVE, OBJ, textures, vertices, polygons, attributes and SPRWINDOW. Ctrl+P / F12 brings back the edit screen.",
    source: "Ref. pp. 146-150; Tut. pp. 41-44",
  },
};

// @NAME constants (Ref. pp. 11-14).
const OBJ = 'OBJ field';
const PAD = 'pad button bit';
const SND = 'sound parameter';
const CONSTANTS = {
  TYPE: [0, OBJ, 'object type: 0 hidden (default), 1 sprite with scale and Z turn, 2 sprite with X/Y scale, 3 4-point sprite, 4 3D polygon (perspective), 5 3D polygon (orthographic), 6 invisible pivot for children, 7 orthographic sprite (SPRITE$/PUTSPRITE)'], FLAG: [1, OBJ, 'helper flags, bits 0-2: 0 copy the translation into M30-M32 (set automatically when GTEST is non-zero), 1 copy the whole 4x3 matrix into M00-M32, 2 write XD/YD/ZD/RD (types 4-7). Wait 1 VSYNC before reading'], GROUP: [2, OBJ, 'collision groups this object belongs to, 16 bits (default 0); objects 0 and -1 never collide'],
  XP: [4, OBJ, 'X position from the parent'], YP: [5, OBJ, 'Y position from the parent'], ZP: [6, OBJ, 'Z position from the parent'],
  XR: [8, OBJ, 'X rotation from the parent, in turns (0.125 = 45 degrees, default 0)'], YR: [9, OBJ, 'Y rotation from the parent, in turns'], ZR: [10, OBJ, 'Z rotation from the parent, in turns'],
  XS: [12, OBJ, 'X scale (default 1)'], YS: [13, OBJ, 'Y scale (default 1)'], ZS: [14, OBJ, 'Z scale (default 1)'],
  ATR: [16, OBJ, 'attribute ID (SETATR); its face count must be at least the polygon\'s, or the object is not shown (default -1)'], POLYGON: [17, OBJ, 'polygon ID (SETPOLYGON), not needed for types 1-3 (default -1)'], ORDER: [18, OBJ, 'move/rotate order 0-11 (T = move): 0 TXYZ, 1 TXZY, 2 TYXZ, 3 TYZX, 4 TZXY, 5 TZYX, 6 XYZT, 7 XZYT, 8 YXZT, 9 YZXT, 10 ZXYT, 11 ZYXT (default 0)'],
  TIME: [19, OBJ, 'VSYNCs since the object was linked to object 0, 0-&HFFFF, counting from first display'], PARENT: [20, OBJ, 'link: parent object (0 = world, -1 = reset to unused); more than 16 generations deep is not shown'], CHILD: [21, OBJ, 'link: child OBJ (read only)'],
  LEFT: [22, OBJ, 'link: older sibling (read only)'], RIGHT: [23, OBJ, 'link: younger sibling (read only)'],
  XV: [24, OBJ, 'X speed, added to XP every VSYNC (default 0)'], YV: [25, OBJ, 'Y speed, added to YP every VSYNC'], ZV: [26, OBJ, 'Z speed, added to ZP every VSYNC'],
  XA: [28, OBJ, 'X acceleration, added to XV every VSYNC (set XL first)'], YA: [29, OBJ, 'Y acceleration, added to YV every VSYNC'], ZA: [30, OBJ, 'Z acceleration, added to ZV every VSYNC'],
  XL: [32, OBJ, 'X speed limit while XA is non-zero'], YL: [33, OBJ, 'Y speed limit while YA is non-zero'], ZL: [34, OBJ, 'Z speed limit while ZA is non-zero'],
  XRV: [36, OBJ, 'X spin, added to XR every VSYNC (default 0)'], YRV: [37, OBJ, 'Y spin, added to YR every VSYNC'], ZRV: [38, OBJ, 'Z spin, added to ZR every VSYNC'],
  XP0: [48, OBJ, '4-point sprite (type 3) top-left X, relative to XP'], YP0: [49, OBJ, '4-point sprite top-left Y, relative to YP'],
  XP1: [50, OBJ, '4-point sprite top-right X'], YP1: [51, OBJ, '4-point sprite top-right Y'],
  XP2: [52, OBJ, '4-point sprite bottom-right X'], YP2: [53, OBJ, '4-point sprite bottom-right Y'],
  XP3: [54, OBJ, '4-point sprite bottom-left X'], YP3: [55, OBJ, '4-point sprite bottom-left Y'],
  XD: [56, OBJ, 'X on screen from top-left (read only, needs FLAG bit 2)'], YD: [57, OBJ, 'Y on screen from top-left (read only, needs FLAG bit 2)'], ZD: [58, OBJ, 'Z distance (read only, needs FLAG bit 2)'],
  RD: [59, OBJ, 'RADIUS/ZD (read only, needs FLAG bit 2)'], GTEST: [60, OBJ, 'collision groups to test against, 16 bits (default 0 = off); only the first hit is reported'], RADIUS: [61, OBJ, 'collision radius (default 10)'],
  COLIDIST: [62, OBJ, 'collision result: -1 none, else the distance; testing stops until GTEST is written again (read only)'], COLIOBJ: [63, OBJ, 'object hit, valid when COLIDIST >= 0 (read only)'],
  MATRIX: [64, OBJ, 'perspective matrix, read only: items 64-75 are M00 M01 M02 M10 M11 M12 M20 M21 M22 M30 M31 M32'],
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
  ISEL: [70, SND, 'DSP input select: channel 0 in DSP mode, 0-2 (@REV/@DEL/@DST) in DSPEXT mode; default 0'],
  IMIX: [71, SND, 'DSP input mix level (0 = no effect)'], DSEND: [72, SND, 'direct (dry) send level'],
  DPAN: [73, SND, 'direct pan; MML P and PLAYPAN override it until the next @ voice change'],
  REV: [0, 'effect', 'stereo reverb (DSPEXT input 0, output 0-1)'], DEL: [1, 'effect', 'stereo delay (DSPEXT input 1, output 2-3)'],
  DST: [2, 'effect', 'mono distortion (DSPEXT input 2, output 4)'],
  SAW: [0, 'waveform', 'sawtooth'], SQU: [1, 'waveform', 'square'], TRI: [2, 'waveform', 'triangle'],
  NOISE: [3, 'waveform', 'noise'],
};


// Words that belong to a larger statement show that statement's entry.
for (const w of ['THEN', 'ELSE', 'ENDIF']) COMMANDS[w] = COMMANDS.IF;
for (const w of ['TO', 'STEP']) COMMANDS[w] = COMMANDS.FOR;
for (const w of ['OUTPUT', 'APPEND', 'AS']) COMMANDS[w] = COMMANDS.OPEN;

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
