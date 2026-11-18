// Created with Claude Opus 5.5, Nov 2026
// Guided by Brett Hallen
'use strict';
// VS Code front end for GAME BASIC for SEGASATURN.
// Live checks run in-process (diagnostics.js). Anything that touches the
// serial port is done by the Python sender (tools/saturn_send.py).

const vscode = require('vscode');
const cp = require('child_process');
const fs = require('fs');
const path = require('path');
const { analyze, effectiveNumbers } = require('./diagnostics');
const K = require('./keywords');
const R = require('./reference');

const LANG = 'game-basic';
let output;
let diagnostics;
let statusItem;
let extensionPath;
let busy = null; // running child process
let consoleTerminal = null;
let pythonCache = null;

// ------------------------------------------------------------------ config

function cfg() {
  return vscode.workspace.getConfiguration('gameBasic');
}

function numberingOptions() {
  const c = cfg();
  return {
    autoNumber: c.get('autoLineNumbers', false),
    start: c.get('lineNumberStart', 10),
    step: c.get('lineNumberStep', 10),
    labelInterval: c.get('labelLineInterval', 0),
    maxLineBytes: c.get('maxLineBytes', 255),
  };
}

function programArgs() {
  const o = numberingOptions();
  const args = ['--start', String(o.start), '--step', String(o.step),
    '--label-interval', String(o.labelInterval), '--max-line-bytes', String(o.maxLineBytes)];
  if (o.autoNumber) args.unshift('--auto-number');
  return args;
}

function linkArgs() {
  const c = cfg();
  const args = [];
  if (c.get('useMockSaturn', false)) args.push('--mock');
  else args.push('--port', c.get('port', ''));
  args.push('--baud', String(c.get('baudRate', 9600)));
  args.push('--key-delay', String(c.get('keyDelayMs', 30) / 1000));
  if (c.get('trace', false)) args.push('--trace', '--verbose');
  return args;
}

// ------------------------------------------------------------- diagnostics

function decodeFile(buf) {
  try {
    return new TextDecoder('utf-8', { fatal: true }).decode(buf);
  } catch (e) {
    try {
      return new TextDecoder('shift_jis').decode(buf);
    } catch (e2) {
      return buf.toString('latin1');
    }
  }
}

function includeReader(doc) {
  if (doc.uri.scheme !== 'file') return null;
  const dir = path.dirname(doc.uri.fsPath);
  return (name) => {
    try {
      let target = path.join(dir, name);
      if (!fs.existsSync(target)) {
        const hit = fs.readdirSync(dir).find((e) => e.toLowerCase() === name.toLowerCase());
        if (!hit) return null;
        target = path.join(dir, hit);
      }
      return decodeFile(fs.readFileSync(target));
    } catch (e) {
      return null;
    }
  };
}

const SEV = {
  error: vscode.DiagnosticSeverity.Error,
  warning: vscode.DiagnosticSeverity.Warning,
  info: vscode.DiagnosticSeverity.Information,
};

function refresh(doc) {
  if (doc.languageId !== LANG) return;
  const opts = Object.assign(numberingOptions(), { readInclude: includeReader(doc) });
  const found = analyze(doc.getText(), opts).map((d) => {
    const line = Math.min(d.line, doc.lineCount - 1);
    const len = doc.lineAt(line).text.length;
    const range = new vscode.Range(line, Math.min(d.start, len), line, Math.min(d.end, Math.max(len, 1)));
    const diag = new vscode.Diagnostic(range, d.message, SEV[d.severity]);
    diag.source = 'GAME BASIC';
    diag.code = d.code;
    return diag;
  });
  diagnostics.set(doc.uri, found);
}

// ------------------------------------------------------------ editor help

const LABEL_RE = /^\s*(?:\d+\s*)?\*([A-Za-z_][A-Za-z0-9_]*)/;

function lineIndex(doc) {
  const nums = effectiveNumbers(doc.getText(), numberingOptions());
  const byNumber = new Map();
  for (const [docLine, n] of nums) byNumber.set(n, docLine);
  const labels = new Map();
  for (let i = 0; i < doc.lineCount; i++) {
    const m = LABEL_RE.exec(doc.lineAt(i).text);
    if (m) labels.set(m[1].toUpperCase(), i);
  }
  return { nums, byNumber, labels };
}

const definitionProvider = {
  provideDefinition(doc, pos) {
    const range = doc.getWordRangeAtPosition(pos, /\*?[A-Za-z_][A-Za-z0-9_]*|\d+/);
    if (!range) return null;
    const word = doc.getText(range);
    const idx = lineIndex(doc);
    let target;
    if (word.startsWith('*')) target = idx.labels.get(word.slice(1).toUpperCase());
    else if (/^\d+$/.test(word)) {
      const before = doc.lineAt(pos.line).text.slice(0, range.start.character);
      if (!new RegExp(`(?:${K.JUMP_WORDS.join('|')})\\s*(?:[\\d*\\w]+\\s*,\\s*)*$`, 'i').test(before)) return null;
      target = idx.byNumber.get(parseInt(word, 10));
    }
    if (target === undefined) return null;
    return new vscode.Location(doc.uri, new vscode.Position(target, 0));
  },
};

const inlayHintsProvider = {
  provideInlayHints(doc, range) {
    const o = numberingOptions();
    if (!o.autoNumber) return [];
    const nums = effectiveNumbers(doc.getText(), o);
    const hints = [];
    for (let i = range.start.line; i <= range.end.line && i < doc.lineCount; i++) {
      const text = doc.lineAt(i).text;
      if (!nums.has(i) || /^\s*\d/.test(text)) continue;
      const hint = new vscode.InlayHint(new vscode.Position(i, 0), `${nums.get(i)}`,
        vscode.InlayHintKind.Type);
      hint.paddingRight = true;
      hint.tooltip = 'Line number this line will be sent with (automatic numbering)';
      hints.push(hint);
    }
    return hints;
  },
};

const symbolProvider = {
  provideDocumentSymbols(doc) {
    const out = [];
    for (let i = 0; i < doc.lineCount; i++) {
      const text = doc.lineAt(i).text;
      const m = LABEL_RE.exec(text);
      if (m) {
        const r = doc.lineAt(i).range;
        out.push(new vscode.DocumentSymbol(`*${m[1]}`, '', vscode.SymbolKind.Function, r, r));
      }
    }
    return out;
  },
};

const completionProvider = {
  provideCompletionItems() {
    const items = [];
    const add = (list, kind, detail) => {
      for (const w of list) {
        const it = new vscode.CompletionItem(w, kind);
        it.detail = detail + (K.CONFIRMED.includes(w) ? '' : ' (from standard BASIC, unconfirmed)');
        items.push(it);
      }
    };
    add(K.CONTROL, vscode.CompletionItemKind.Keyword, 'control');
    add(K.STATEMENTS, vscode.CompletionItemKind.Keyword, 'statement');
    add(K.OPERATORS, vscode.CompletionItemKind.Operator, 'operator');
    add(K.FUNCTIONS, vscode.CompletionItemKind.Function, 'function');
    for (const it of items) {
      const c = R.COMMANDS[it.label];
      if (c) it.documentation = `${c.syntax}\n\n${c.summary} (${c.source})`;
    }
    return items;
  },
};

// Hover text for keywords (syntax from reference.js when known) and @NAME
// constants (values from the Reference Manual, pp. 11-14).
function hoverText(word) {
  if (word.startsWith('@')) {
    const c = R.CONSTANTS[word.slice(1).toUpperCase()];
    return c ? `**${word.toUpperCase()}** = ${c[0]}: ${c[1]}, ${c[2]} (Ref. pp. 11-14)` : null;
  }
  const w = word.toUpperCase();
  if (!K.ALL.includes(w)) return null;
  const c = R.COMMANDS[w];
  if (c) return '```game-basic\n' + c.syntax + '\n```\n' + c.summary + ` *(${c.source})*`;
  const kind = K.FUNCTIONS.includes(w) ? 'function' : K.OPERATORS.includes(w) ? 'operator'
    : K.CONTROL.includes(w) ? 'control' : 'statement';
  return `**${w}**: GAME BASIC ${kind}`;
}

const hoverProvider = {
  provideHover(doc, pos) {
    const range = doc.getWordRangeAtPosition(pos, /@?[A-Za-z_][A-Za-z0-9_]*[$!#]?/);
    if (!range) return null;
    const text = hoverText(doc.getText(range));
    return text ? new vscode.Hover(new vscode.MarkdownString(text), range) : null;
  },
};

// ----------------------------------------------------------------- python

function runQuiet(cmd, args) {
  return new Promise((resolve) => {
    cp.execFile(cmd, args, { timeout: 10000 }, (err, stdout, stderr) =>
      resolve({ ok: !err, out: `${stdout}${stderr}` }));
  });
}

async function python() {
  const configured = cfg().get('pythonPath', '').trim();
  if (configured) return [configured];
  if (pythonCache) return pythonCache;
  const candidates = process.platform === 'win32'
    ? [['py', '-3'], ['python'], ['python3']]
    : [['python3'], ['python']];
  for (const c of candidates) {
    const r = await runQuiet(c[0], [...c.slice(1), '--version']);
    if (r.ok && /Python 3\./.test(r.out)) {
      pythonCache = c;
      return c;
    }
  }
  throw new Error('Python 3 was not found. Install it, or set "gameBasic.pythonPath".');
}

function senderScript() {
  const configured = cfg().get('senderScript', '').trim();
  const candidates = [
    configured,
    path.join(extensionPath, 'python', 'saturn_send.py'),
    path.join(extensionPath, '..', 'tools', 'saturn_send.py'),
  ].filter(Boolean);
  const hit = candidates.find((p) => fs.existsSync(p));
  if (!hit) {
    throw new Error('saturn_send.py not found. Set "gameBasic.senderScript" to its path.');
  }
  return hit;
}

async function toolCommand(args) {
  const py = await python();
  return { cmd: py[0], args: [...py.slice(1), senderScript(), ...args] };
}

// Runs the sender with a progress notification. Resolves {code, stdout, stderr}.
async function runTool(args, title, { cancellable = true, show = true } = {}) {
  if (busy) {
    vscode.window.showWarningMessage('GAME BASIC: another transfer is still running.');
    return null;
  }
  const { cmd, args: full } = await toolCommand(args);
  if (show) {
    output.appendLine('');
    output.appendLine(`> ${title}`);
  }
  return vscode.window.withProgress(
    { location: vscode.ProgressLocation.Notification, title: `Saturn: ${title}`, cancellable },
    (progress, token) => new Promise((resolve) => {
      let stdout = '';
      let stderr = '';
      const child = cp.spawn(cmd, full, { env: Object.assign({}, process.env, { PYTHONUNBUFFERED: '1' }) });
      busy = child;
      token.onCancellationRequested(() => child.kill('SIGINT'));
      const onLine = (chunk, isErr) => {
        const text = chunk.toString();
        if (isErr) stderr += text; else stdout += text;
        if (show) output.append(text);
        const last = text.trim().split(/\r?\n/).pop();
        if (last) progress.report({ message: last.slice(0, 80) });
      };
      child.stdout.on('data', (c) => onLine(c, false));
      child.stderr.on('data', (c) => onLine(c, true));
      child.on('error', (err) => {
        busy = null;
        output.appendLine(String(err));
        resolve({ code: -1, stdout, stderr: String(err) });
      });
      child.on('close', (code) => {
        busy = null;
        resolve({ code, stdout, stderr });
      });
    }),
  );
}

async function reportFailure(res, what) {
  if (!res) return;
  const text = `${res.stderr}\n${res.stdout}`;
  if (/pyserial is not installed/.test(text)) {
    const pick = await vscode.window.showErrorMessage(
      'GAME BASIC needs the pyserial Python package.', 'Install pyserial');
    if (pick) {
      const py = await python();
      const t = vscode.window.createTerminal('Install pyserial');
      t.show();
      t.sendText(`${py.join(' ')} -m pip install pyserial`);
    }
    return;
  }
  const msg = (res.stderr.trim().split(/\r?\n/).pop() || `exit code ${res.code}`).replace(/^Error: /, '');
  const pick = await vscode.window.showErrorMessage(`${what} failed: ${msg}`, 'Show Log');
  if (pick) output.show(true);
}

// ------------------------------------------------------------ commands

async function ensurePort() {
  const c = cfg();
  if (c.get('useMockSaturn', false) || c.get('port', '')) return true;
  await selectPort();
  return Boolean(cfg().get('useMockSaturn', false) || cfg().get('port', ''));
}

function closeConsole() {
  if (consoleTerminal) {
    consoleTerminal.dispose();
    consoleTerminal = null;
    output.appendLine('(closed the Saturn console so the port is free)');
  }
}

async function activeProgram() {
  const ed = vscode.window.activeTextEditor;
  if (!ed || ed.document.languageId !== LANG) {
    vscode.window.showWarningMessage('Open a GAME BASIC file first.');
    return null;
  }
  const doc = ed.document;
  if (doc.isUntitled) {
    const ok = await doc.save();
    if (!ok || doc.isUntitled) return null;
  } else if (doc.isDirty) {
    await doc.save();
  }
  refresh(doc);
  const errors = diagnostics.get(doc.uri).filter((d) => d.severity === vscode.DiagnosticSeverity.Error);
  if (errors.length) {
    const pick = await vscode.window.showErrorMessage(
      `Not sent: the program has ${errors.length} error(s).`, 'Show Problems');
    if (pick) vscode.commands.executeCommand('workbench.actions.view.problems');
    return null;
  }
  return doc;
}

async function send(run) {
  const doc = await activeProgram();
  if (!doc || !(await ensurePort())) return;
  closeConsole();
  const serveDir = cfg().get('serveDirectory', '') || path.dirname(doc.uri.fsPath);
  const args = ['send', doc.uri.fsPath, ...programArgs(), ...linkArgs(), '--serve-dir', serveDir];
  if (run) args.push('--run');
  const res = await runTool(args, `${run ? 'Send and run' : 'Send'} ${path.basename(doc.uri.fsPath)}`);
  if (!res) return;
  const warning = (res.stdout.match(/^Warning: .*$/m) || [])[0];
  if (res.code === 0) {
    const summary = (res.stdout.match(/^Sent .*$/m) || ['Sent.'])[0];
    vscode.window.setStatusBarMessage(`$(check) Saturn: ${summary}`, 8000);
    if (warning) {
      const pick = await vscode.window.showWarningMessage(warning.replace(/^Warning: /, ''), 'Show Log');
      if (pick) output.show(true);
    }
  } else if (res.code === 4) {
    // Sent, but the Saturn printed an error (tutorial manual p. 163: BASTERM
    // itself may miss these, so check what the Saturn says).
    // The cause comes from the manual's error list (Ref. pp. 391-406).
    const msg = (res.stderr.trim().split(/\r?\n/).pop() || '').replace(/^Error: /, '');
    const why = R.explainError(msg);
    const pick = await vscode.window.showErrorMessage(
      `Sent, but ${msg.charAt(0).toLowerCase()}${msg.slice(1)}${why ? ` (${why})` : ''}`, 'Show Log');
    if (pick) output.show(true);
  } else {
    await reportFailure(res, 'Send');
  }
}

async function simple(args, title) {
  if (!(await ensurePort())) return;
  closeConsole();
  const res = await runTool([...args, ...linkArgs()], title);
  if (res && res.code !== 0) await reportFailure(res, title);
  else if (res) vscode.window.setStatusBarMessage(`$(check) Saturn: ${title} done`, 5000);
}

async function receive() {
  if (!(await ensurePort())) return;
  const folder = vscode.workspace.workspaceFolders?.[0]?.uri;
  const uri = await vscode.window.showSaveDialog({
    defaultUri: folder ? vscode.Uri.joinPath(folder, 'RECEIVED.B') : undefined,
    filters: { 'GAME BASIC': ['b', 'B', 'gbas'] },
    title: 'Save the program received from the Saturn',
  });
  if (!uri) return;
  closeConsole();
  const res = await runTool(
    ['receive', ...linkArgs(), '-o', uri.fsPath, '--encoding', 'cp932'], 'Receive');
  if (res && res.code === 0) {
    const doc = await vscode.workspace.openTextDocument(uri);
    await vscode.window.showTextDocument(doc);
  } else {
    await reportFailure(res, 'Receive');
  }
}

async function typeText() {
  const text = await vscode.window.showInputBox({
    prompt: 'Text to type at the Saturn (Enter is pressed after it)',
    placeHolder: 'LIST',
  });
  if (text === undefined) return;
  await simple(['type', text], 'Type text');
}

async function serve() {
  if (!(await ensurePort())) return;
  if (busy) {
    vscode.window.showWarningMessage('Wait for the current transfer to finish.');
    return;
  }
  const ed = vscode.window.activeTextEditor;
  const fallback = ed && ed.document.uri.scheme === 'file' ? path.dirname(ed.document.uri.fsPath)
    : vscode.workspace.workspaceFolders?.[0]?.uri.fsPath;
  const dir = cfg().get('serveDirectory', '') || fallback;
  const { cmd, args } = await toolCommand(['serve', ...linkArgs(), ...(dir ? ['--serve-dir', dir] : [])]);
  closeConsole();
  consoleTerminal = vscode.window.createTerminal({ name: 'Saturn console', shellPath: cmd, shellArgs: args });
  consoleTerminal.show();
}

async function showProcessed() {
  const doc = await activeProgram();
  if (!doc) return;
  const res = await runTool(['build', doc.uri.fsPath, ...programArgs(), '-o', '-'],
    'Build', { cancellable: false, show: false });
  if (!res) return;
  if (res.code !== 0) {
    output.append(res.stderr);
    await reportFailure(res, 'Build');
    return;
  }
  const view = await vscode.workspace.openTextDocument({ language: LANG, content: res.stdout });
  await vscode.window.showTextDocument(view, { preview: true, viewColumn: vscode.ViewColumn.Beside });
}

async function selectPort() {
  let ports = [];
  const res = await runTool(['ports', '--json'], 'List ports', { cancellable: false, show: false });
  if (res && res.code === 0) {
    try { ports = JSON.parse(res.stdout); } catch (e) { ports = []; }
  } else if (res) {
    await reportFailure(res, 'Listing ports');
  }
  const current = cfg().get('port', '');
  const items = ports.map((p) => ({
    label: p.device,
    description: p.device === current ? `${p.description} (current)` : p.description,
    detail: p.hwid,
    port: p.device,
  }));
  items.push({ label: '$(edit) Enter a port name...', manual: true });
  items.push({ label: '$(beaker) Use the mock Saturn (no hardware)', mock: true });
  const pick = await vscode.window.showQuickPick(items, {
    placeHolder: ports.length ? 'Serial port of the USB-TTL adapter' : 'No serial ports found',
  });
  if (!pick) return;
  const target = vscode.ConfigurationTarget.Global;
  if (pick.mock) {
    await cfg().update('useMockSaturn', true, target);
    return;
  }
  let port = pick.port;
  if (pick.manual) {
    port = await vscode.window.showInputBox({ prompt: 'Serial port', value: current });
    if (!port) return;
  }
  await cfg().update('port', port, target);
  await cfg().update('useMockSaturn', false, target);
}

async function selfTest() {
  const res = await runTool(['selftest'], 'Self-test', { cancellable: false });
  if (!res) return;
  output.show(true);
  if (res.code === 0) vscode.window.showInformationMessage('GAME BASIC self-test passed.');
  else await reportFailure(res, 'Self-test');
}

// ------------------------------------------------------------ status bar

function updateStatus() {
  const c = cfg();
  const ed = vscode.window.activeTextEditor;
  if (!ed || ed.document.languageId !== LANG) {
    statusItem.hide();
    return;
  }
  if (c.get('useMockSaturn', false)) {
    statusItem.text = '$(beaker) Saturn: mock';
    statusItem.tooltip = 'Using the pretend Saturn. Click to pick a real serial port.';
  } else {
    const port = c.get('port', '');
    statusItem.text = port ? `$(plug) Saturn: ${path.basename(port)} @ ${c.get('baudRate', 9600)}`
      : '$(plug) Saturn: no port';
    statusItem.tooltip = port ? `${port}, ${c.get('baudRate', 9600)} baud. Click to change.`
      : 'Click to pick the serial port';
  }
  statusItem.show();
}

// -------------------------------------------------------------- activate

function activate(context) {
  extensionPath = context.extensionPath;
  output = vscode.window.createOutputChannel('GAME BASIC');
  diagnostics = vscode.languages.createDiagnosticCollection(LANG);
  statusItem = vscode.window.createStatusBarItem(vscode.StatusBarAlignment.Left, 50);
  statusItem.command = 'gameBasic.selectPort';

  const sel = { language: LANG };
  const timers = new Map();
  const later = (doc) => {
    clearTimeout(timers.get(doc.uri.toString()));
    timers.set(doc.uri.toString(), setTimeout(() => refresh(doc), 250));
  };

  const reg = (id, fn) => vscode.commands.registerCommand(id, (...a) =>
    Promise.resolve(fn(...a)).catch((err) => vscode.window.showErrorMessage(`GAME BASIC: ${err.message}`)));

  context.subscriptions.push(
    output, diagnostics, statusItem,
    reg('gameBasic.send', () => send(false)),
    reg('gameBasic.sendAndRun', () => send(true)),
    reg('gameBasic.run', () => simple(['run'], 'Run')),
    reg('gameBasic.stop', () => simple(['stop'], 'Stop')),
    reg('gameBasic.showError', () => simple(['show-error'], 'Show error line')),
    reg('gameBasic.receive', receive),
    reg('gameBasic.typeText', typeText),
    reg('gameBasic.serve', serve),
    reg('gameBasic.selectPort', selectPort),
    reg('gameBasic.showProcessed', showProcessed),
    reg('gameBasic.selfTest', selfTest),
    vscode.languages.registerDefinitionProvider(sel, definitionProvider),
    vscode.languages.registerInlayHintsProvider(sel, inlayHintsProvider),
    vscode.languages.registerDocumentSymbolProvider(sel, symbolProvider),
    vscode.languages.registerCompletionItemProvider(sel, completionProvider),
    vscode.languages.registerHoverProvider(sel, hoverProvider),
    vscode.workspace.onDidOpenTextDocument(refresh),
    vscode.workspace.onDidChangeTextDocument((e) => later(e.document)),
    vscode.workspace.onDidCloseTextDocument((doc) => diagnostics.delete(doc.uri)),
    vscode.window.onDidChangeActiveTextEditor(updateStatus),
    vscode.window.onDidCloseTerminal((t) => { if (t === consoleTerminal) consoleTerminal = null; }),
    vscode.workspace.onDidChangeConfiguration((e) => {
      if (!e.affectsConfiguration('gameBasic')) return;
      pythonCache = null;
      updateStatus();
      vscode.workspace.textDocuments.forEach(refresh);
    }),
  );
  vscode.workspace.textDocuments.forEach(refresh);
  updateStatus();
}

function deactivate() {
  if (busy) busy.kill();
}

module.exports = { activate, deactivate, hoverText };
