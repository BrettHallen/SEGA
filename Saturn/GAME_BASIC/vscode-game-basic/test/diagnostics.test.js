// Created with Claude Opus 5.5, Nov 2026
// Guided by Brett Hallen
'use strict';
// npm test  (or: node --test)
const test = require('node:test');
const assert = require('node:assert');
const { analyze, effectiveNumbers } = require('../src/diagnostics');

const codes = (text, opts) => analyze(text, opts).map((d) => `${d.line}:${d.code}`);

test('clean program has no problems', () => {
  const src = [
    '10 REM HELLO',
    '20 FOR I=1 TO 10',
    '30 PRINT "I=";I',
    '40 NEXT I',
    '50 IF I>5 THEN 70',
    '60 GOSUB 100',
    '70 END',
    '100 OBJ(1,@ATR) = 1,1:RETURN',
  ].join('\n');
  assert.deepStrictEqual(analyze(src), []);
});

test('line number errors match BASTERM checks', () => {
  const src = '10 A=1\nB=2\n10 C=3\n100000 D=4\n';
  assert.deepStrictEqual(codes(src), [
    '1:no-line-number', '2:duplicate-line-number', '3:line-number-range',
  ]);
});

test('auto numbering follows the BASTERM help example', () => {
  const src = 'print i\n\n1234 print j\nprint z\n';
  const opts = { autoNumber: true, start: 100, step: 1 };
  assert.deepStrictEqual(analyze(src, opts), []);
  const nums = effectiveNumbers(src, opts);
  assert.deepStrictEqual([...nums.entries()], [[0, 100], [2, 1234], [3, 1235]]);
});

test('auto numbering can collide with an explicit number', () => {
  const src = 'A=1\nB=2\n20 C=3\n';
  assert.deepStrictEqual(codes(src, { autoNumber: true, start: 10, step: 10 }), [
    '2:duplicate-line-number',
  ]);
});

test('labels and jump targets', () => {
  const src = '*START\nPRINT 1\nGOTO *START\nGOTO *NOWHERE\nGOSUB 9999\nRESTORE *START\n';
  assert.deepStrictEqual(codes(src, { autoNumber: true }), ['3:unknown-label', '4:unknown-line']);
  assert.deepStrictEqual(codes('10 ON A GOTO 10,20,30\n20 END\n'), ['0:unknown-line']);
});

test('strings, comments and brackets', () => {
  assert.deepStrictEqual(codes('10 PRINT "(((":REM )))\n20 A=(1+2\n30 B=1)\n'), [
    '1:unbalanced-paren', '2:unbalanced-paren',
  ]);
  assert.deepStrictEqual(codes('10 PRINT "OPEN\n'), ['0:unclosed-string']);
  assert.deepStrictEqual(codes("10 ' GOTO 999 (\n"), []);
  assert.deepStrictEqual(codes('10 PRINT "GOTO 999"\n'), []);
});

test('IF without THEN', () => {
  assert.deepStrictEqual(codes('10 IF A=1 PRINT 2\n'), ['0:if-without-then']);
  assert.deepStrictEqual(codes('10 IF A=1 GOTO 10\n'), []);
});

test('Shift-JIS and line length', () => {
  assert.deepStrictEqual(codes('10 PRINT "セガサターン"\n'), []);
  assert.deepStrictEqual(codes('10 PRINT "😀"\n'), ['0:not-shift-jis']);
  const long = '10 PRINT "' + 'あ'.repeat(130) + '"';
  assert.deepStrictEqual(codes(long), ['0:line-too-long']);
  assert.deepStrictEqual(codes(long, { maxLineBytes: 512 }), []);
});

test('#include is expanded for numbering and missing files are errors', () => {
  const files = { 'DATA.B': '10000 DATA 1\n10010 DATA 2\n' };
  const readInclude = (n) => files[n.toUpperCase()] ?? null;
  const src = '10 RESTORE 10000\n#include "data.b"\n#include "NOPE.B"\n20 GOTO 10010\n';
  assert.deepStrictEqual(codes(src, { readInclude }), ['2:include-missing']);
  const dup = '10000 REM CLASH\n#include "DATA.B"\n';
  assert.deepStrictEqual(codes(dup, { readInclude }), ['1:duplicate-line-number']);
});

test('variables named like Saturn fields are not flagged (GIRL.B style)', () => {
  const src = '1004 TYPE = 0: FLAG = 1\n1006 ATR = 16: POLYGON = 17\n4013 OBJ(1,ATR)  = 1,1\n';
  assert.deepStrictEqual(analyze(src), []);
});

test('DATA items are literal text', () => {
  assert.deepStrictEqual(codes("10 DATA \\a=\\(N46'8 N30'8\n20 DATA 1,(2:A=(3\n"), ['1:unbalanced-paren']);
});

test('ON ERROR GOTO 0 and a DOS end-of-file mark are fine', () => {
  assert.deepStrictEqual(codes('10 ON ERROR GOTO 0\n20 RESUME 0\n\x1a\n'), []);
});

test('unnumbered direct commands and comments are notes, not errors (DEMO.B)', () => {
  const src = 'LOAD"COM:DDD"\n 1000 \' GAME BASIC\n\'LOAD END\nload "com:dummy"\nRUN\n1010 END\n';
  assert.deepStrictEqual(codes(src), [
    '0:direct-command', '2:unnumbered-comment', '3:direct-command', '4:direct-command',
  ]);
  assert.ok(analyze(src).every((d) => d.severity === 'info'));
  // With automatic numbering, direct commands still get no number.
  const nums = effectiveNumbers('LOAD"COM:X"\nPRINT 1\n', { autoNumber: true });
  assert.deepStrictEqual([...nums.entries()], [[1, 10]]);
  // A real statement without a number is still an error.
  assert.deepStrictEqual(codes('PRINT 1\n'), ['0:no-line-number']);
});

test('PLAY with more notes than its song buffer holds', () => {
  const notes = (n) => 'CDEFGAB'.repeat(Math.ceil(n / 7)).slice(0, n);
  assert.deepStrictEqual(codes(`10 PLAY 60,"${notes(150)}"\n`), []);
  assert.deepStrictEqual(codes(`10 PLAY "${notes(80)}","${notes(71)}"\n`), ['0:play-too-long']);
  // Lower-case MML commands and other statements on the line don't count.
  assert.deepStrictEqual(codes(`10 PLAY "v100 ${notes(100)}":PRINT "${notes(100)}"\n`), []);
  assert.deepStrictEqual(codes(`10 X=PLAYSTAT(0):EFFECT 1,"${notes(200)}"\n`), []);
  const d = analyze(`10 A=1:PLAY "${notes(160)}"\n`)[0];
  assert.strictEqual(d.code, 'play-too-long');
  assert.strictEqual(d.start, 7);
  assert.match(d.message, /160 notes/);
});

// Runs over the sample programs on the GAME BASIC CD when they have been
// extracted next to this folder, either straight into GAME_BASIC/GAME_BASIC_CD
// or into GAME_BASIC_CD/extracted (tools/gbcd_extract.py --out). They should
// come up with no errors or warnings apart from two strings with no closing
// quote.
const fs = require('fs');
const path = require('path');
const cdRoot = path.join(__dirname, '..', '..', 'GAME_BASIC_CD');
const hasB = (d) => fs.existsSync(d) && fs.readdirSync(d).some((f) => /\.B$/i.test(f));
const cd = [cdRoot, path.join(cdRoot, 'extracted')].find(hasB);
test('GAME BASIC CD samples', { skip: !cd && 'no extracted GAME BASIC CD samples found' }, () => {
  const allowed = new Set(['direct-command', 'unnumbered-comment', 'unclosed-string', 'out-of-order']);
  const files = fs.readdirSync(cd).filter((f) => /\.B$/i.test(f));
  assert.ok(files.length > 0);
  for (const f of files) {
    const text = new TextDecoder('shift_jis').decode(fs.readFileSync(path.join(cd, f)));
    for (const d of analyze(text)) {
      assert.ok(allowed.has(d.code), `${f}:${d.line + 1} ${d.code}: ${d.message}`);
    }
  }
});

test('direct-only commands in a program line', () => {
  const codes = (t) => analyze(t).filter((d) => d.code === 'direct-only').map((d) => d.start);
  assert.deepStrictEqual(codes('10 NEW'), [3]);
  assert.deepStrictEqual(codes('10 PRINT "LIST":LIST'), [16]);
  assert.deepStrictEqual(codes('10 IF A THEN SAVE "X" ELSE NEW'), [13, 27]);
  assert.deepStrictEqual(codes('10 LISTX=1'), []);
  assert.deepStrictEqual(codes('10 DATA NEW,LIST'), []);
  assert.deepStrictEqual(codes('10 REM NEW'), []);
  assert.deepStrictEqual(codes('10 LOAD "COM:A"'), []);
});
