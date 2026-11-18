// Created with Claude Opus 5.5, Nov 2026
// Guided by Brett Hallen
'use strict';
// Copies ../tools (saturn_send.py + saturn_link) into ./python so a packaged
// .vsix carries its own sender. Run automatically by `npm run package`.
const fs = require('fs');
const path = require('path');

const src = path.join(__dirname, '..', '..', 'tools');
const dst = path.join(__dirname, '..', 'python');
if (!fs.existsSync(path.join(src, 'saturn_send.py'))) {
  console.error(`tools folder not found at ${src}`);
  process.exit(1);
}
fs.rmSync(dst, { recursive: true, force: true });
fs.mkdirSync(path.join(dst, 'saturn_link'), { recursive: true });
fs.copyFileSync(path.join(src, 'saturn_send.py'), path.join(dst, 'saturn_send.py'));
for (const f of fs.readdirSync(path.join(src, 'saturn_link'))) {
  if (f.endsWith('.py')) {
    fs.copyFileSync(path.join(src, 'saturn_link', f), path.join(dst, 'saturn_link', f));
  }
}
console.log(`copied sender into ${path.relative(process.cwd(), dst)}`);
