// Created with Claude Opus 5.5, Nov 2026
// Guided by Brett Hallen
'use strict';
// Loads extension.js against a stub of the VS Code API and drives the real
// commands end to end: Send / Send and Run go through the Python sender to the
// mock Saturn. Skipped if Python 3 is not on PATH.
const test = require('node:test');
const assert = require('node:assert');
const Module = require('module');
const path = require('path');
const fs = require('fs');
const os = require('os');
const cp = require('child_process');

const hasPython = ['python3', 'python'].some((p) => {
  try { return /Python 3/.test(cp.execFileSync(p, ['--version'], { encoding: 'utf8', stdio: 'pipe' })); } catch (e) { return false; }
});

function makeVscode(state) {
  class Range { constructor(a, b, c, d) { Object.assign(this, { start: { line: a, character: b }, end: { line: c, character: d } }); } }
  class Position { constructor(l, c) { this.line = l; this.character = c; } }
  class Diagnostic { constructor(range, message, severity) { Object.assign(this, { range, message, severity }); } }
  const disposable = { dispose() {} };
  const cfgValues = state.config;
  return {
    Range, Position, Diagnostic,
    Location: class { constructor(uri, pos) { this.uri = uri; this.range = { start: pos }; } },
    InlayHint: class { constructor(pos, label) { this.position = pos; this.label = label; } },
    DocumentSymbol: class { constructor(name) { this.name = name; } },
    CompletionItem: class { constructor(label) { this.label = label; } },
    DiagnosticSeverity: { Error: 0, Warning: 1, Information: 2 },
    InlayHintKind: { Type: 1 }, SymbolKind: { Function: 11 },
    CompletionItemKind: { Keyword: 13, Operator: 11, Function: 2 },
    ProgressLocation: { Notification: 15 }, StatusBarAlignment: { Left: 1 },
    ConfigurationTarget: { Global: 1 }, ViewColumn: { Beside: -2 },
    Uri: { joinPath: (u, p) => ({ fsPath: path.join(u.fsPath, p) }) },
    commands: {
      registerCommand: (id, fn) => { state.commands[id] = fn; return disposable; },
      executeCommand: () => {},
    },
    languages: {
      createDiagnosticCollection: () => ({
        set: (uri, d) => state.diags.set(uri.fsPath, d),
        get: (uri) => state.diags.get(uri.fsPath) || [],
        delete: () => {}, dispose() {},
      }),
      registerDefinitionProvider: (s, p) => { state.providers.definition = p; return disposable; },
      registerInlayHintsProvider: (s, p) => { state.providers.inlay = p; return disposable; },
      registerDocumentSymbolProvider: (s, p) => { state.providers.symbols = p; return disposable; },
      registerCompletionItemProvider: (s, p) => { state.providers.completion = p; return disposable; },
      registerHoverProvider: (s, p) => { state.providers.hover = p; return disposable; },
    },
    workspace: {
      getConfiguration: () => ({
        get: (k, d) => (k in cfgValues ? cfgValues[k] : d),
        update: async (k, v) => { cfgValues[k] = v; },
      }),
      textDocuments: [],
      workspaceFolders: undefined,
      onDidOpenTextDocument: () => disposable,
      onDidChangeTextDocument: () => disposable,
      onDidCloseTextDocument: () => disposable,
      onDidChangeConfiguration: () => disposable,
      openTextDocument: async (o) => { state.opened.push(o); return o; },
    },
    window: {
      activeTextEditor: state.editor,
      createOutputChannel: () => ({
        append: (t) => { state.log += t; }, appendLine: (t) => { state.log += t + '\n'; },
        show() {}, dispose() {},
      }),
      createStatusBarItem: () => ({ show() {}, hide() {}, dispose() {} }),
      withProgress: (o, fn) => fn({ report() {} }, { onCancellationRequested() {} }),
      showErrorMessage: async (m) => { state.errors.push(m); },
      showWarningMessage: async (m) => { state.errors.push(m); },
      showInformationMessage: async (m) => { state.info.push(m); },
      showQuickPick: async (items) => items[state.pick || 0],
      showInputBox: async (o) => (o && o.value) || '',
      setStatusBarMessage: (m) => { state.info.push(m); },
      showTextDocument: async () => {},
      onDidChangeActiveTextEditor: () => disposable,
      onDidCloseTerminal: () => disposable,
    },
  };
}

function fakeDoc(file) {
  const text = fs.readFileSync(file, 'utf8');
  const lines = text.split(/\r?\n/);
  return {
    uri: { fsPath: file, scheme: 'file', toString: () => file },
    languageId: 'game-basic', isUntitled: false, isDirty: false,
    getText: () => text, lineCount: lines.length,
    lineAt: (i) => ({ text: lines[i], range: { start: { line: i, character: 0 } } }),
    getWordRangeAtPosition: () => null,
  };
}

function load(state) {
  const realLoad = Module._load;
  Module._load = function (req, ...rest) {
    if (req === 'vscode') return makeVscode(state);
    return realLoad.call(this, req, ...rest);
  };
  const p = require.resolve('../src/extension');
  delete require.cache[p];
  const ext = require(p);
  Module._load = realLoad;
  ext.activate({ extensionPath: path.join(__dirname, '..'), subscriptions: [] });
  return ext;
}

test('extension commands drive the sender against the mock Saturn', { skip: !hasPython }, async () => {
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'satbas-'));
  const good = path.join(dir, 'HELLO.B');
  fs.writeFileSync(good, '*TOP\nPRINT "HELLO SATURN"\nGOTO *TOP\n');
  const state = {
    config: { useMockSaturn: true, autoLineNumbers: true, keyDelayMs: 0 },
    commands: {}, providers: {}, diags: new Map(), errors: [], info: [], opened: [], log: '',
    editor: { document: fakeDoc(good) },
  };
  const ext = load(state);
  for (const id of ['send', 'sendAndRun', 'run', 'stop', 'showError', 'receive', 'typeText', 'serve',
    'selectPort', 'showProcessed', 'selfTest', 'toSaturnBitmap', 'toPng', 'toSetchr', 'toSprite']) {
    assert.ok(state.commands[`gameBasic.${id}`], `command ${id} registered`);
  }

  await state.commands['gameBasic.sendAndRun']();
  assert.deepStrictEqual(state.errors, [], state.log);
  assert.match(state.log, /Sent 48 bytes in 2 blocks/);
  assert.match(state.log, /Program is running/);

  await state.commands['gameBasic.showProcessed']();
  assert.strictEqual(state.opened[0].content, '10 *TOP\r\n20 PRINT "HELLO SATURN"\r\n30 GOTO *TOP\r\n');

  const hints = state.providers.inlay.provideInlayHints(state.editor.document,
    { start: { line: 0 }, end: { line: 5 } });
  assert.deepStrictEqual(hints.map((h) => h.label), ['10', '20', '30']);

  // A program with an error is refused before Python is even started.
  const bad = path.join(dir, 'BAD.B');
  fs.writeFileSync(bad, '10 A=1\n10 B=2\n');
  state.config.autoLineNumbers = false;
  state.editor.document = fakeDoc(bad);
  await state.commands['gameBasic.send']();
  assert.match(state.errors[0], /1 error/);
  ext.deactivate();
});

test('hover text: command syntax, @ constants, plain keywords', () => {
  const state = { config: {}, commands: {}, providers: {}, diags: new Map(), errors: [], info: [], opened: [], log: '', editor: null };
  const ext = load(state);
  assert.ok(state.providers.hover, 'hover provider registered');
  assert.match(ext.hoverText('kprint'), /KPRINT \[\(x,y/);
  assert.match(ext.hoverText('bin$'), /BIN\$\(<numeric expression>\[,<suppress>\]\)/);
  assert.match(ext.hoverText('endif'), /IF <condition> THEN/);
  assert.match(ext.hoverText('INKEY$'), /Page Down 251/);
  assert.match(ext.hoverText('files$'), /CHR\$\(13\)\+CHR\$\(10\)/);
  assert.match(ext.hoverText('pset'), /PSET \(x,y\)\[,<colour>\]/);
  assert.match(ext.hoverText('vsync'), /VSYNC \[<frames>\]/);
  assert.match(ext.hoverText('palette'), /PALETTE\(\[<logical BG>\],<palette number>\)/);
  assert.match(ext.hoverText('append'), /OPEN "\[<device>:\]<name>" \[FOR/);
  assert.match(ext.hoverText('sprite$'), /16x16, 256 colours/);
  assert.match(ext.hoverText('setvertex'), /VERTEXID\(-1\)/);
  assert.match(ext.hoverText('obj'), /OBJ COPY <from> TO <to>/);
  assert.match(ext.hoverText('@isel'), /DSPEXT/);
  assert.match(ext.hoverText('@type'), /6 invisible pivot/);
  assert.match(ext.hoverText('@pad_start'), /@PAD_START\*\* = &H800/);
  assert.match(ext.hoverText('@XP'), /= 4: OBJ field, X position/);
  assert.match(ext.hoverText('SFRE'), /function/);
  assert.match(ext.hoverText('mmlstat'), /control command/);
  assert.match(ext.hoverText('on'), /ON MMLSTAT GOSUB/);
  assert.match(ext.hoverText('vertexid'), /Undefined vertex/);
  assert.match(ext.hoverText('settex'), /BBBBB GGGGG RRRRR/);
  assert.match(ext.hoverText('@order'), /0 TXYZ/);
  assert.match(ext.hoverText('NOT!'), /operator/);
  assert.strictEqual(ext.hoverText('TIME'), null);
  assert.strictEqual(ext.hoverText('@NOPE'), null);
});

test('error list: Saturn messages get their cause (Ref. pp. 391-406)', () => {
  const R = require('../src/reference');
  assert.strictEqual(Object.keys(R.ERRORS).length, 91);
  assert.match(R.explainError('The Saturn reported: Syntax error in 100'), /^error 2: /);
  assert.match(R.explainError('Communication error'), /L\+R\+Z/);
  assert.match(R.explainError('Sound: MML command error'), /^error 67: /);
  assert.match(R.explainError('Bad octave value(0 <=> 8)'), /error 67/);
  assert.strictEqual(R.explainError('Line 120'), null);
});

test('PNG and Saturn bitmaps convert both ways', { skip: !hasPython }, async () => {
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'satbmp-'));
  // A 2x1 .1 file: one black dot (&H8000) and one transparent dot (0).
  const one = path.join(dir, 'PIC.1');
  fs.writeFileSync(one, Buffer.from([0, 2, 0, 1, 0x80, 0, 0, 0]));
  const state = {
    config: {}, commands: {}, providers: {}, diags: new Map(), errors: [], info: [], opened: [], log: '',
    editor: null, pick: 1,
  };
  load(state);
  await state.commands['gameBasic.toPng']({ fsPath: one });
  assert.deepStrictEqual(state.errors, []);
  assert.ok(fs.existsSync(path.join(dir, 'PIC.png')), state.info.join('\n'));
  await state.commands['gameBasic.toSaturnBitmap']({ fsPath: path.join(dir, 'PIC.png') });
  assert.deepStrictEqual(state.errors, []);
  const zero = fs.readFileSync(path.join(dir, 'PIC.0'));
  assert.strictEqual(zero.length, 4 + 512 + 2);
  assert.match(state.info.join('\n'), /256 colours/);
  // An 8x8 .1 picture (all black) -> PNG -> SETCHR lines.
  const eight = path.join(dir, 'CHR.1');
  fs.writeFileSync(eight, Buffer.concat([Buffer.from([0, 8, 0, 8]), Buffer.alloc(128, 0x80).map((b, i) => (i % 2 ? 0 : 0x80))]));
  await state.commands['gameBasic.toPng']({ fsPath: eight });
  state.pick = 0;
  await state.commands['gameBasic.toSetchr']({ fsPath: path.join(dir, 'CHR.png') });
  assert.deepStrictEqual(state.errors, []);
  assert.match(fs.readFileSync(path.join(dir, 'CHR_chr.B'), 'ascii'), /SETCHR 4,0,32,READ\r\nDATA 11111111/);
  // A 16x16 .1 picture (all black) -> PNG -> SPRITE$ lines.
  const sixteen = path.join(dir, 'SPR.1');
  fs.writeFileSync(sixteen, Buffer.concat([Buffer.from([0, 16, 0, 16]), Buffer.alloc(512, 0).map((b, i) => (i % 2 ? 0 : 0x80))]));
  await state.commands['gameBasic.toPng']({ fsPath: sixteen });
  state.pick = 1;
  await state.commands['gameBasic.toSprite']({ fsPath: path.join(dir, 'SPR.png') });
  assert.deepStrictEqual(state.errors, []);
  const spr = fs.readFileSync(path.join(dir, 'SPR_spr.B'), 'ascii');
  assert.match(spr, /PALETTE 10,257,RGB\(0,0,0\)/);
  assert.match(spr, /SPRITE\$\(0\)=READHEX\$\(256\)\r\nDATA (01){16}\r\n/);
});
