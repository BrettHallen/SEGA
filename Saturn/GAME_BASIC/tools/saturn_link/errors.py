# Created with Claude Opus 5.5, Nov 2026
# Guided by Brett Hallen
"""GAME BASIC error messages (Reference Manual appendix, pp. 391-406).

ERRORS maps each error code to (message as the Saturn prints it, cause).
Codes 33, 38, 40 and 49 are not in the manual. MML_DETAILS are the extra
lines the Saturn shows under error 67 "Sound: MML command error". The same
table is in vscode-game-basic/src/reference.js; keep the two in step.
"""
import re
from typing import Optional

ERRORS = {
    1: ("NEXT without FOR", "a NEXT has no matching FOR"),
    2: ("Syntax error", "the statement is written wrongly: its form, the number of brackets, a comma or a separator"),
    3: ("RETURN without GOSUB", "RETURN was reached without a GOSUB"),
    4: ("Out of DATA", "READ, SETCHR, SETPOLYGON or another DATA reader ran out of DATA"),
    5: ("Illegal function call", "a statement or function was called the wrong way"),
    6: ("Overflow", "a number, in a calculation or a polygon, went outside the fixed-point range"),
    7: ("Out of memory", "CLEAR, DIM, a program being typed or loaded, or PEEK/POKE past the user area ran out of memory; change the split with CLEAR"),
    8: ("Undefined line number", "a GOTO, GOSUB or similar names a line number or label that doesn't exist"),
    9: ("Subscript out of range", "an array index is outside the size given in DIM"),
    10: ("Variable already defined", "DIM names a variable that is already defined"),
    11: ("Division by 0", "a calculation divided by 0"),
    12: ("Illegal direct", "this statement can't be typed as a direct command"),
    13: ("Type mismatch", "a value of the wrong type, such as a number put in a string variable"),
    14: ("Sound: MML String too short", "the MML string is too short in time"),
    15: ("String too long", "a string over 65535 characters, or a line typed on the edit screen that is too long"),
    16: ("Formula too complex", "an expression is too complex or functions are nested too deeply"),
    17: ("Can't continue", "the program can't be resumed, for example because it was changed after it stopped"),
    18: ("Undefined array", "an array is used without DIM"),
    19: ("Dimension size error", "an array is used with a different number of dimensions from its DIM"),
    20: ("Communication error", "the link failed. Check the cable, and that the PC's speed matches the Saturn's setting (L+R+Z on the pad), then reconnect"),
    21: ("No RESUME", "the program ended inside an ON ERROR handler without RESUME"),
    22: ("RESUME without error", "RESUME was used when no error had happened"),
    23: ("Illegal line number", "a bad line number, or 0, or over 99999"),
    24: ("Stack overflow", "the FOR-NEXT or GOSUB stack overflowed, or a PAINT shape is too complex"),
    25: ("IF stack overflow", "IF statements are nested too deeply"),
    26: ("ELSE/ENDIF without IF", "an ELSE or ENDIF has no matching IF"),
    27: ("FOR without NEXT", "a FOR has no matching NEXT"),
    28: ("Direct statement only", "this statement can't be used in a program"),
    29: ("Data statement", "a DATA item read by READ has no closing double quote"),
    30: ("String format error", "GCOPY or CCOPY was given a string with the wrong structure"),
    31: ("Parameter mismatch", "the parameters don't match, as in PRINT USING"),
    32: ("IF/ELSE without ENDIF", "an IF or ELSE has no matching ENDIF"),
    34: ("Undefined vertex", "SETVERTEX, SETPOLYGON or VERTEXID used a vertex ID that isn't defined"),
    35: ("Undefined polygon", "SETPOLYGON, an object or POLYGONID used a polygon ID that isn't defined"),
    36: ("Undefined attribute", "SETATR or an object used an attribute ID that isn't defined"),
    37: ("Undefined texture", "SETTEX, SETATR, PUTSPRITE or TEXID used a texture ID that isn't defined (define sprites with SPRITE$ first)"),
    39: ("Version mismatch", "the BASIC program is from a different version"),
    41: ("Unusable charactor", "the line holds a character BASIC can't store"),
    42: ("Buffer full", "FWRITE went past the file buffer set by CLEAR"),
    43: ("Device not connected", "CRAM:, FD0: or FD1: isn't connected, or the Saturn started with no floppy in"),
    44: ("Device not formatted", "the floppy isn't formatted; FORMAT it if its contents can be erased"),
    45: ("Device write protected", "the floppy's write-protect notch is set"),
    46: ("Device verify error", "the file is damaged"),
    47: ("Not enough space", "BRAM:, CRAM:, FD0: or FD1: is too full to write"),
    48: ("Backup RAM error", "another BRAM:, CRAM:, FD0: or FD1: error"),
    50: ("File access error", "the PC's link software couldn't read or write the host file"),
    51: ("Internal error", "internal error"),
    52: ("Sound: Out of layer memory", "not enough layer area"),
    53: ("File not found", "the file doesn't exist"),
    54: ("File already open", "OPEN, KILL or similar on a file that is already open"),
    55: ("Access past EOF", "read past the end of the file"),
    56: ("Bad file name", "the file name isn't valid"),
    57: ("Invalid BASIC file", "LOAD of a file that isn't a BASIC program"),
    58: ("Duplicated label", "the same label is defined twice"),
    59: ("File not OPEN", "a file number was used without OPEN"),
    60: ("Already formatted", "the device is already formatted"),
    61: ("Bad file mode", "the file mode isn't valid"),
    62: ("Bad device name", "the device name isn't valid"),
    63: ("Sound: Not layer mode", "not in layer edit mode"),
    64: ("File still open", "a file that is open was used"),
    65: ("Sound: Command buffer full", "the sound driver's command buffer is full"),
    66: ("Sound: Out of sound memory", "sound memory can't be reserved"),
    67: ("Sound: MML command error", "an MML command error; the next line gives the detail"),
    68: ("Sound:Out of MML data", "the MML string ran out"),
    69: ("File read error", "the file can't be read"),
    70: ("File write error", "the file can't be written"),
    71: ("Sound: Song bank full", "the reserved blocks are used up"),
    72: ("Sound: Layer overflow", "no more layers can be registered"),
    73: ("Sound: Tone overflow", "no more tones can be registered"),
    74: ("Sound: VL overflow", "no more velocity-level data can be registered, or not enough layer area"),
    75: ("Sound: PEG overflow", "no more pitch-envelope data can be registered, or not enough layer area"),
    76: ("Sound: PLFO overflow", "no more pitch-LFO data can be registered, or not enough layer area"),
    77: ("Sound: No layer", "no layer has been registered"),
    78: ("Invalid USERDATA", "the USERDATA isn't valid"),
    79: ("Vertex size mismatch", "SETVERTEX re-registered an ID with a different size"),
    80: ("Vertex number", "a SETPOLYGON vertex number is outside 0 to (vertices - 1) of its vertex group"),
    81: ("Vertex ID over", "SETVERTEX can't register more vertex IDs"),
    82: ("Vertex data over", "SETVERTEX can't register more data"),
    83: ("Vertex out of area", "SETVERTEX defined more vertices than it reserved"),
    84: ("Texture size mismatch", "SETTEX re-registered a texture with a different size"),
    85: ("Texture ID over", "SETTEX can't register more IDs"),
    86: ("Texture data over", "SETTEX was given more data than its area size"),
    87: ("Sound: Invalid WAVE file", "not wave data"),
    88: ("Sound: Bad WAVE file format", "the wave data's format is wrong"),
    89: ("Polygon size mismatch", "SETPOLYGON re-registered an ID with a different size"),
    90: ("Polygon ID over", "SETPOLYGON can't register more IDs"),
    91: ("Polygon data over", "SETPOLYGON can't register more data"),
    92: ("Attribute size mismatch", "SETATR or SETPFONT re-registered an ID with a different size"),
    93: ("Attribute ID over", "SETATR can't register more attribute IDs"),
    94: ("Attribute data over", "SETATR can't register more data"),
    95: ("Attribute out of area", "SETATR was given more data than its size"),
}

MML_DETAILS = [
    "MML Syntax error", "Bad note length", "Velocity value", "Not gate time ratio",
    "Bad gate time ratio", "Bad pitch bend value", "Not chord", "Can't nest - plets",
    "Bad note number", "Bad tone number", "Bad signature", "Bad transpose value",
    "Bad tempo value", "Tempo change over", "Bad volume value", "Bad direct pan value",
    "Bad octave value", "Not MML command", "Bad damper value", "Macro error",
    "Software layer error", "Pitch bend cmd.buffer overflow", "Not base track", "Bad label",
    "D.S. without", "Bad '$'or'*'or'ds'position", "Repeat command error", "Bad effect pan value",
    "Bad effect level", "Bad effect number", "Not DSP mode", "Bad DSP mixer number",
    "Bad status value", "Not code name", "Chord note over",
]

_BY_MESSAGE = {msg.lower(): code for code, (msg, _) in ERRORS.items()}

# Longest first, so "Sound: MML command error" wins over "MML Syntax error".
_ALL = sorted([m for m, _ in ERRORS.values()] + MML_DETAILS, key=len, reverse=True)
ERROR_RE = re.compile("|".join(re.escape(m) for m in _ALL), re.I)


def explain(line: str) -> Optional[str]:
    """'Syntax error in 100' -> 'error 2: the statement is written wrongly ...'.

    Returns None when the line holds no known error message.
    """
    m = ERROR_RE.search(line)
    if not m:
        return None
    code = _BY_MESSAGE.get(m.group(0).lower())
    if code is None:
        return "MML detail for error 67 (Sound: MML command error)"
    return f"error {code}: {ERRORS[code][1]}"
