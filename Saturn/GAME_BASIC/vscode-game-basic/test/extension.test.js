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
  for (const id of ['send', 'sendAndRun', 'run', 'stop', 'receive', 'typeText', 'serve',
    'selectPort', 'showProcessed', 'selfTest']) {
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
  assert.match(ext.hoverText('@pad_start'), /@PAD_START\*\* = &H800/);
  assert.match(ext.hoverText('@XP'), /= 4: OBJ field, X position/);
  assert.match(ext.hoverText('VERTEXID'), /function/);
  assert.match(ext.hoverText('NOT!'), /operator/);
  assert.strictEqual(ext.hoverText('TIME'), null);
  assert.strictEqual(ext.hoverText('@NOPE'), null);
});
