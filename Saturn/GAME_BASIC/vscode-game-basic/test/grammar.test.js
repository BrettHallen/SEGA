'use strict';
// Tokenises sample lines with the same engine VS Code uses.
// Needs the dev dependencies: npm install
const test = require('node:test');
const assert = require('node:assert');
const fs = require('fs');
const path = require('path');

let vsctm;
let onig;
try {
  vsctm = require('vscode-textmate');
  onig = require('vscode-oniguruma');
} catch (e) {
  test('grammar (skipped: run npm install for vscode-textmate)', { skip: true }, () => {});
  return;
}

const grammarPath = path.join(__dirname, '..', 'syntaxes', 'game-basic.tmLanguage.json');

async function loadGrammar() {
  const wasm = fs.readFileSync(require.resolve('vscode-oniguruma/release/onig.wasm')).buffer;
  await onig.loadWASM(wasm);
  const registry = new vsctm.Registry({
    onigLib: Promise.resolve({
      createOnigScanner: (p) => new onig.OnigScanner(p),
      createOnigString: (s) => new onig.OnigString(s),
    }),
    loadGrammar: async () =>
      vsctm.parseRawGrammar(fs.readFileSync(grammarPath, 'utf8'), grammarPath),
  });
  return registry.loadGrammar('source.game-basic');
}

function tokens(grammar, line) {
  const r = grammar.tokenizeLine(line, vsctm.INITIAL);
  return r.tokens.map((t) => [line.slice(t.startIndex, t.endIndex), t.scopes[t.scopes.length - 1]]);
}

function scopeOf(toks, text) {
  const t = toks.find(([s]) => s === text);
  return t ? t[1] : undefined;
}

test('grammar scopes', async () => {
  const g = await loadGrammar();
  let t = tokens(g, '100 FOR I=1 TO 10:PRINT MID$(A$,1,2);:NEXT');
  assert.strictEqual(scopeOf(t, '100'), 'constant.numeric.line-number.game-basic');
  assert.strictEqual(scopeOf(t, 'FOR'), 'keyword.control.game-basic');
  assert.strictEqual(scopeOf(t, 'PRINT'), 'keyword.other.statement.game-basic');
  assert.strictEqual(scopeOf(t, 'MID$'), 'support.function.builtin.game-basic');
  assert.strictEqual(scopeOf(t, 'A$'), 'variable.other.game-basic');

  t = tokens(g, '20 GOTO 100 \' jump');
  assert.strictEqual(scopeOf(t, '100'), 'constant.numeric.line-reference.game-basic');
  assert.strictEqual(scopeOf(t, ' jump'), 'comment.line.apostrophe.game-basic');

  t = tokens(g, '30 REM GOTO 10 "x"');
  assert.strictEqual(scopeOf(t, 'REM'), 'keyword.other.rem.game-basic');
  assert.strictEqual(scopeOf(t, ' GOTO 10 "x"'), 'comment.line.rem.game-basic');

  t = tokens(g, '*LOOP');
  assert.strictEqual(scopeOf(t, '*LOOP'), 'entity.name.label.game-basic');
  t = tokens(g, '40 A = B * C: GOSUB *LOOP');
  assert.strictEqual(scopeOf(t, '*'), 'keyword.operator.arithmetic.game-basic');
  assert.strictEqual(scopeOf(t, '*LOOP'), 'entity.name.label.reference.game-basic');

  t = tokens(g, '2060 OBJ(1,@ATR)  = 1,1');
  assert.strictEqual(scopeOf(t, 'OBJ'), 'keyword.other.statement.game-basic');
  assert.strictEqual(scopeOf(t, '@ATR'), 'constant.language.object-field.game-basic');

  t = tokens(g, '#include "TESTDATA.B"');
  assert.strictEqual(scopeOf(t, '#include'), 'keyword.control.directive.include.game-basic');

  t = tokens(g, '50 X=&H1F+1.5E3:PRINTER=1');
  assert.strictEqual(scopeOf(t, '&H1F'), 'constant.numeric.hex.game-basic');
  assert.strictEqual(scopeOf(t, '1.5E3'), 'constant.numeric.decimal.game-basic');
  assert.strictEqual(scopeOf(t, 'PRINTER'), 'variable.other.game-basic');

  t = tokens(g, "2588 DATA \\a=\\(N46'8 N30'8), 12:PRINT 'note");
  assert.ok(!t.some(([s, sc]) => s.includes("'8") && sc.startsWith('comment')), JSON.stringify(t));
  assert.strictEqual(scopeOf(t, 'PRINT'), 'keyword.other.statement.game-basic');
  assert.strictEqual(t.find(([s]) => s === 'note')[1], 'comment.line.apostrophe.game-basic');

  t = tokens(g, '60 print "unterminated');
  assert.strictEqual(scopeOf(t, 'print'), 'keyword.other.statement.game-basic');
});
