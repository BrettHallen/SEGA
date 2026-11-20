// Created with Claude Opus 5.5, Nov 2026
// Guided by Brett Hallen
'use strict';
// Checks for GAME BASIC for SEGASATURN source. No VS Code dependency, so it
// runs under plain `node --test`.
//
// Errors are things BASTERM itself refuses to send (missing / duplicate / too
// big line numbers, over-long lines), characters Shift-JIS can't carry, and
// missing #include files. Warnings are likely mistakes the Saturn would
// report later: unbalanced brackets, an unclosed string, a GOTO to a line or
// *label that doesn't exist, IF without THEN/GOTO, a PLAY with more notes
// than its song buffer holds.

const K = require('./keywords');

const MAX_LINE_NUMBER = 99999;
const LINE_NUM_RE = /^\s*(\d+)(?=\s|$|[^\d.])/;
const INCLUDE_RE = /^\s*#include\s+"([^"]+)"\s*$/i;
// Unnumbered lines that GAME BASIC runs at once instead of storing, such as
// the LOAD "COM:..." lines at the top of several CD programs. Not program
// lines, so they are never numbered and are left out when sending.
const DIRECT_RE = /^\s*(LOAD|SAVE|RUN|NEW|LIST|LLIST|CONT|FILES|MERGE|DELETE|RENUM|AUTO|KILL|BLOAD|BSAVE|GLOAD|KLOAD)(?![A-Za-z0-9_$])/i;
const COMMENT_RE = /^\s*('|REM(?![A-Za-z0-9_$]))/i;
const LABEL_DEF_RE = /^\*([A-Za-z_][A-Za-z0-9_]*)/;

const SEVERITY = { error: 'error', warning: 'warning', info: 'info' };

// PLAY has only 4 song-data blocks, about 150 quarter notes; more stops with
// "Sound:Song bank full" (Ref. p. 271). Notes are the MML letters A-G and the
// rest R, written in capitals.
const PLAY_NOTE_LIMIT = 150;
const PLAY_RE = /^\s*PLAY(?![A-Za-z0-9_$])/i;

// Split a line body into statements at ':' outside strings.
// Returns [{ text, col }] with col relative to the body.
function statements(body) {
  const out = [];
  let start = 0;
  let inStr = false;
  for (let i = 0; i <= body.length; i++) {
    const ch = body[i];
    if (ch === '"') inStr = !inStr;
    if (i === body.length || (ch === ':' && !inStr)) {
      out.push({ text: body.slice(start, i), col: start });
      start = i + 1;
    }
  }
  return out;
}

// Count the notes and rests in a PLAY statement's MML string literals.
function playNotes(stmt) {
  let notes = 0;
  const re = /"([^"]*)"?/g;
  let m;
  while ((m = re.exec(stmt)) !== null) {
    for (const ch of m[1]) if (/[A-GR]/.test(ch)) notes++;
  }
  return notes;
}

// ---------------------------------------------------------------- Shift-JIS

let sjisSet = null;
function shiftJisChars() {
  if (sjisSet !== null) return sjisSet;
  sjisSet = false;
  try {
    const dec = new TextDecoder('shift_jis', { fatal: true });
    const set = new Set();
    for (let lead = 0x81; lead <= 0xfc; lead++) {
      if (lead > 0x9f && lead < 0xe0) continue;
      for (let trail = 0x40; trail <= 0xfc; trail++) {
        if (trail === 0x7f) continue;
        try {
          const s = dec.decode(new Uint8Array([lead, trail]));
          if (s.length >= 1) set.add(s);
        } catch (e) {
          /* unmapped */
        }
      }
    }
    if (set.size > 6000) sjisSet = set;
  } catch (e) {
    sjisSet = false; // no ICU Shift-JIS support: fall back to ranges
  }
  return sjisSet;
}

// Bytes one character takes in Shift-JIS, or 0 if it can't be encoded.
function sjisBytes(ch) {
  const c = ch.codePointAt(0);
  if (c < 0x80) return 1;
  if (c >= 0xff61 && c <= 0xff9f) return 1; // half-width katakana
  if (c === 0xa5 || c === 0x203e) return 1; // yen and overline (JIS-Roman)
  const set = shiftJisChars();
  if (set) return set.has(ch) ? 2 : 0;
  // Fallback: common JIS X 0208 ranges.
  if ((c >= 0x3000 && c <= 0x30ff) || (c >= 0x4e00 && c <= 0x9fff) ||
      (c >= 0xff01 && c <= 0xff60) || (c >= 0x0391 && c <= 0x03c9) ||
      (c >= 0x0401 && c <= 0x0451) || (c >= 0x2500 && c <= 0x254b) ||
      (c >= 0x2010 && c <= 0x2312)) return 2;
  return 0;
}

// --------------------------------------------------------------- tokenising

// Split a statement body into code segments, skipping strings and comments.
// Returns { code: [{text, col}], strings: [...], unclosedString: col|null, commentCol }
function scan(body, offset) {
  const segs = [];
  let i = 0;
  let start = 0;
  let unclosed = null;
  let commentCol = null;
  let stmtStart = true;
  const push = (end) => {
    if (end > start) segs.push({ text: body.slice(start, end), col: offset + start });
  };
  while (i < body.length) {
    const ch = body[i];
    if (stmtStart && ch !== ' ' && ch !== '\t') {
      stmtStart = false;
      // DATA items are literal text up to the next ':' (outside quotes):
      // a ' or ( inside them is data, not a comment or a bracket.
      if (/^DATA(?![A-Za-z0-9_$])/i.test(body.slice(i))) {
        push(i);
        let j = i + 4;
        let inStr = false;
        while (j < body.length && (inStr || body[j] !== ':')) {
          if (body[j] === '"') inStr = !inStr;
          j++;
        }
        i = start = j;
        continue;
      }
    }
    if (ch === ':') stmtStart = true;
    if (ch === '"') {
      push(i);
      const close = body.indexOf('"', i + 1);
      if (close < 0) {
        unclosed = offset + i;
        i = body.length;
        start = i;
        break;
      }
      i = close + 1;
      start = i;
      continue;
    }
    if (ch === "'") {
      push(i);
      commentCol = offset + i;
      start = i = body.length;
      break;
    }
    if ((ch === 'R' || ch === 'r') && /^REM(?![A-Za-z0-9_$])/i.test(body.slice(i)) &&
        !/[A-Za-z0-9_$]/.test(body[i - 1] || '')) {
      push(i);
      commentCol = offset + i;
      start = i = body.length;
      break;
    }
    i++;
  }
  push(i);
  return { segs, unclosed, commentCol };
}

// ------------------------------------------------------------------ analyse

/**
 * @param {string} text             document text
 * @param {object} [opts]
 * @param {boolean} [opts.autoNumber=false]
 * @param {number}  [opts.start=10]
 * @param {number}  [opts.step=10]
 * @param {number}  [opts.labelInterval=0]
 * @param {number}  [opts.maxLineBytes=255]
 * @param {(name:string)=>string|null} [opts.readInclude]  returns file text or null
 * @returns {{line:number,start:number,end:number,severity:string,message:string,code:string}[]}
 */
function analyze(text, opts = {}) {
  const o = Object.assign(
    { autoNumber: false, start: 10, step: 10, labelInterval: 0, maxLineBytes: 255, readInclude: null },
    opts,
  );
  const out = [];
  const add = (line, start, end, severity, code, message) =>
    out.push({ line, start, end: Math.max(end, start + 1), severity, code, message });

  // Expand includes into a flat list of { text, line (in this doc), via }.
  const lines = [];
  const docLines = text.split(/\r?\n/);
  const includeStack = [];
  const expand = (srcLines, docLine, via) => {
    srcLines.forEach((t, idx) => {
      const ln = docLine === null ? idx : docLine;
      const m = INCLUDE_RE.exec(t);
      if (m) {
        if (docLine !== null && includeStack.length > 8) return;
        if (!o.readInclude) {
          if (docLine === null) lines.push({ text: null, line: ln, include: m[1] });
          return;
        }
        const name = m[1];
        if (includeStack.includes(name.toUpperCase())) {
          add(ln, 0, t.length, SEVERITY.error, 'include-loop', `#include loop through "${name}"`);
          return;
        }
        const inc = o.readInclude(name);
        if (inc === null || inc === undefined) {
          const col = t.indexOf('"');
          add(ln, col, col + name.length + 2, SEVERITY.error, 'include-missing',
            `#include file not found: "${name}" (looked next to this file)`);
          return;
        }
        includeStack.push(name.toUpperCase());
        expand(inc.split(/\r?\n/), ln, (via ? via + ' > ' : '') + name);
        includeStack.pop();
        return;
      }
      lines.push({ text: t, line: ln, via, srcIndex: idx + 1 });
    });
  };
  expand(docLines, null, null);

  // Pass 1: line numbers and labels.
  let counter = o.start;
  const seen = new Map(); // number -> entry
  const labels = new Map(); // NAME -> number
  const entries = [];
  let lastExplicit = -1;
  for (const l of lines) {
    if (l.text === null) continue;
    const raw = l.text.replace(/[\s\x00-\x1f]+$/, '');
    const inc = l.via ? ` (in ${l.via}, line ${l.srcIndex})` : '';
    const m = LINE_NUM_RE.exec(raw);
    let num;
    let body;
    let bodyCol;
    let numCol = 0;
    let numLen = 0;
    if (m) {
      num = parseInt(m[1], 10);
      numCol = m.index + m[0].indexOf(m[1]);
      numLen = m[1].length;
      bodyCol = m[0].length;
      body = raw.slice(bodyCol);
      counter = num + o.step;
      if (num < lastExplicit && !l.via) {
        add(l.line, numCol, numCol + numLen, SEVERITY.info, 'out-of-order',
          `Line ${num} comes after line ${lastExplicit}. The Saturn sorts lines on LOAD, so it will move.`);
      }
      if (!l.via) lastExplicit = Math.max(lastExplicit, num);
    } else {
      const stripped = raw.trim();
      if (stripped === '') continue;
      const lead = raw.length - raw.trimStart().length;
      const dm = DIRECT_RE.exec(raw);
      if (dm) {
        add(l.line, lead, lead + dm[1].length, SEVERITY.info, 'direct-command',
          `${dm[1].toUpperCase()} without a line number is a direct command, not a program line${inc}. ` +
          'Send to Saturn leaves it out.');
        continue;
      }
      if (!o.autoNumber && COMMENT_RE.test(raw)) {
        add(l.line, lead, raw.length, SEVERITY.info, 'unnumbered-comment',
          `Comment without a line number${inc}. Send to Saturn leaves it out.`);
        continue;
      }
      if (!o.autoNumber) {
        add(l.line, lead, raw.length, SEVERITY.error, 'no-line-number',
          'Line has no line number' + inc + '. Add one, or turn on "gameBasic.autoLineNumbers".');
        continue;
      }
      if (stripped.startsWith('*') && o.labelInterval > 0) {
        counter = Math.ceil(counter / o.labelInterval) * o.labelInterval;
      }
      num = counter;
      counter += o.step;
      bodyCol = raw.length - raw.trimStart().length;
      body = raw.slice(bodyCol);
    }
    const entry = { l, num, body, bodyCol, numCol, numLen, inc };
    if (num > MAX_LINE_NUMBER) {
      add(l.line, numCol, numCol + Math.max(numLen, 1), SEVERITY.error, 'line-number-range',
        `Line number ${num} is above ${MAX_LINE_NUMBER}${inc}.` +
        (m ? '' : ' Automatic numbering ran past the limit; use a smaller step.'));
      continue;
    }
    if (seen.has(num)) {
      const prev = seen.get(num);
      add(l.line, numCol, numCol + Math.max(numLen, 1), SEVERITY.error, 'duplicate-line-number',
        `Duplicate line number ${num}${inc} (first used on line ${prev.l.line + 1}).`);
      continue;
    }
    seen.set(num, entry);
    const lm = LABEL_DEF_RE.exec(body.trimStart());
    if (lm) labels.set(lm[1].toUpperCase(), num);
    entries.push(entry);
  }

  // Pass 2: per-line checks.
  const jumpRe = new RegExp(
    `(?<![A-Za-z0-9_$])(${K.JUMP_WORDS.join('|')})\\s*((?:\\d+|\\*[A-Za-z_][A-Za-z0-9_]*)(?:\\s*,\\s*(?:\\d+|\\*[A-Za-z_][A-Za-z0-9_]*))*)`,
    'gi',
  );
  for (const e of entries) {
    const { l, body, bodyCol, inc } = e;
    const lineNo = l.line;
    const own = !l.via; // only point at columns inside this document

    // byte length and encodability
    let bytes = String(e.num).length + 1;
    let col = 0;
    for (const ch of body) {
      const b = sjisBytes(ch);
      if (b === 0) {
        const c = bodyCol + col;
        add(lineNo, own ? c : 0, own ? c + ch.length : 1, SEVERITY.error, 'not-shift-jis',
          `"${ch}" (U+${ch.codePointAt(0).toString(16).toUpperCase().padStart(4, '0')}) can't be sent: ` +
          `the Saturn uses Shift-JIS${inc}.`);
      }
      bytes += b || 2;
      col += ch.length;
    }
    if (bytes > o.maxLineBytes) {
      add(lineNo, 0, l.text.length, SEVERITY.error, 'line-too-long',
        `Line is ${bytes} bytes as sent; the limit is ${o.maxLineBytes}${inc}.`);
    }
    if (!own) continue; // keep the rest to this document's own lines

    const { segs, unclosed } = scan(body, bodyCol);
    if (unclosed !== null) {
      add(lineNo, unclosed, l.text.length, SEVERITY.warning, 'unclosed-string',
        'String has no closing quote (GAME BASIC may accept this, but check it).');
    }
    const code = segs.map((s) => s.text).join(' ');

    // brackets, per statement
    let depth = 0;
    let firstOpen = -1;
    for (const s of segs) {
      for (let i = 0; i < s.text.length; i++) {
        const ch = s.text[i];
        if (ch === ':' && depth > 0) {
          add(lineNo, firstOpen, s.col + i, SEVERITY.warning, 'unbalanced-paren', 'Missing ")".');
          depth = 0;
        } else if (ch === '(') {
          if (depth === 0) firstOpen = s.col + i;
          depth++;
        } else if (ch === ')') {
          if (depth === 0) {
            add(lineNo, s.col + i, s.col + i + 1, SEVERITY.warning, 'unbalanced-paren', 'Unexpected ")".');
          } else depth--;
        }
      }
    }
    if (depth > 0) {
      add(lineNo, firstOpen, firstOpen + 1, SEVERITY.warning, 'unbalanced-paren', 'Missing ")".');
    }

    // jump targets
    for (const s of segs) {
      jumpRe.lastIndex = 0;
      let jm;
      while ((jm = jumpRe.exec(s.text)) !== null) {
        const word = jm[1].toUpperCase();
        const listStart = jm.index + jm[0].length - jm[2].length;
        const targetRe = /\d+|\*[A-Za-z_][A-Za-z0-9_]*/g;
        let tm;
        while ((tm = targetRe.exec(jm[2])) !== null) {
          const t = tm[0];
          const c = s.col + listStart + tm.index;
          if (t.startsWith('*')) {
            if (!labels.has(t.slice(1).toUpperCase())) {
              add(lineNo, c, c + t.length, SEVERITY.warning, 'unknown-label', `Label ${t} is not defined.`);
            }
          } else if (!['LIST', 'DELETE'].includes(word)) {
            const n = parseInt(t, 10);
            if (n !== 0 && !seen.has(n)) { // ON ERROR GOTO 0, RESUME 0
              add(lineNo, c, c + t.length, SEVERITY.warning, 'unknown-line',
                `${word} ${n}: there is no line ${n}.`);
            }
          }
        }
      }
    }

    // IF without THEN / GOTO, per statement
    const stmts = code.split(':');
    for (const st of stmts) {
      if (/(?<![A-Za-z0-9_$])IF(?![A-Za-z0-9_$])/i.test(st) &&
          !/(?<![A-Za-z0-9_$])(THEN|GOTO|GOSUB)(?![A-Za-z0-9_$])/i.test(code)) {
        const c = body.search(/(?<![A-Za-z0-9_$])IF(?![A-Za-z0-9_$])/i);
        add(lineNo, bodyCol + Math.max(c, 0), bodyCol + Math.max(c, 0) + 2, SEVERITY.warning,
          'if-without-then', 'IF without THEN or GOTO.');
        break;
      }
    }

    // PLAY strings longer than PLAY's song buffer
    for (const st of statements(body)) {
      if (!PLAY_RE.test(st.text)) continue;
      const n = playNotes(st.text);
      if (n > PLAY_NOTE_LIMIT) {
        const c = bodyCol + st.col + st.text.search(/\S/);
        add(lineNo, c, bodyCol + st.col + st.text.length, SEVERITY.warning, 'play-too-long',
          `PLAY has ${n} notes and rests. PLAY only has room for about ${PLAY_NOTE_LIMIT} quarter notes ` +
          '(fewer with options such as pitch bend), so the Saturn may stop with "Sound:Song bank full". ' +
          'Split it over several PLAY lines, or register it with SETSONG and play it with BGM or EFFECT.');
      }
    }
  }
  return out.sort((a, b) => a.line - b.line || a.start - b.start);
}

// Work out the effective line number of every document line (for hovers /
// the "show numbering" view). Returns Map(docLine -> number).
function effectiveNumbers(text, opts = {}) {
  const o = Object.assign({ autoNumber: false, start: 10, step: 10, labelInterval: 0 }, opts);
  const map = new Map();
  let counter = o.start;
  text.split(/\r?\n/).forEach((raw, i) => {
    if (INCLUDE_RE.test(raw)) return;
    const m = LINE_NUM_RE.exec(raw);
    if (m) {
      const n = parseInt(m[1], 10);
      map.set(i, n);
      counter = n + o.step;
      return;
    }
    const s = raw.trim();
    if (!s || !o.autoNumber || DIRECT_RE.test(raw)) return;
    if (s.startsWith('*') && o.labelInterval > 0) {
      counter = Math.ceil(counter / o.labelInterval) * o.labelInterval;
    }
    map.set(i, counter);
    counter += o.step;
  });
  return map;
}

// Where each *LABEL is defined and used in a document (no #include
// expansion). Returns Map(NAME -> { defs: [{line, col, name}],
// refs: [{line, col, word, name}] }); lines are 0-based document lines and
// col is where the '*' is. A use is a label after a jump word (GOTO, GOSUB,
// THEN, ELSE, RESTORE, RUN, RESUME, LIST, DELETE), including lists such as
// ON N GOTO *A,,*B; strings, comments and DATA are skipped.
function labelUses(text) {
  const out = new Map();
  const get = (name) => {
    const k = name.toUpperCase();
    if (!out.has(k)) out.set(k, { defs: [], refs: [] });
    return out.get(k);
  };
  const T = '(?:\\d+|\\*[A-Za-z_][A-Za-z0-9_]*)';
  const jumpRe = new RegExp(
    `(?<![A-Za-z0-9_$])(${K.JUMP_WORDS.join('|')})((?:\\s*,)*\\s*${T}(?:(?:\\s*,)+\\s*${T})*)`, 'gi');
  text.split(/\r?\n/).forEach((raw, line) => {
    if (INCLUDE_RE.test(raw)) return;
    const m = LINE_NUM_RE.exec(raw);
    const bodyCol = m ? m[0].length : 0;
    const body = raw.slice(bodyCol);
    const lead = body.length - body.trimStart().length;
    const dm = LABEL_DEF_RE.exec(body.slice(lead));
    if (dm) get(dm[1]).defs.push({ line, col: bodyCol + lead, name: dm[1] });
    for (const s of scan(body, bodyCol).segs) {
      jumpRe.lastIndex = 0;
      let jm;
      while ((jm = jumpRe.exec(s.text)) !== null) {
        const listStart = jm.index + jm[1].length;
        const targetRe = /\*([A-Za-z_][A-Za-z0-9_]*)/g;
        let tm;
        while ((tm = targetRe.exec(jm[2])) !== null) {
          get(tm[1]).refs.push({ line, col: s.col + listStart + tm.index, word: jm[1].toUpperCase(), name: tm[1] });
        }
      }
    }
  });
  return out;
}

module.exports = { analyze, effectiveNumbers, labelUses, sjisBytes, MAX_LINE_NUMBER };
