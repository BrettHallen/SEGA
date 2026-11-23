const { chromium } = require('playwright');
const fs = require('fs');
const [,, bodyFile, cssFile, outPdf] = process.argv;
const title = 'GAME BASIC for SEGA SATURN: Sample Programs';
const html = `<!doctype html><html lang="en"><head><meta charset="utf-8"><title>${title}</title><style>${fs.readFileSync(cssFile,'utf8')}</style></head><body>${fs.readFileSync(bodyFile,'utf8')}</body></html>`;
(async () => {
  const b = await chromium.launch(); const p = await b.newPage();
  await p.setContent(html, { waitUntil: 'load', timeout: 0 });
  await p.evaluate(() => {
    document.querySelectorAll('table').forEach(t => { if (t.rows.length <= 16) t.classList.add('keep'); });
    document.querySelectorAll('pre').forEach(el => { if (el.textContent.split('\n').length <= 30) el.classList.add('keep'); });
    document.querySelectorAll('p').forEach(el => {
      const n = el.nextElementSibling;
      if (n && /^(TABLE|PRE|UL|OL|DIV)$/.test(n.tagName) && (el.textContent.trim().endsWith(':') || el.textContent.length < 200)) el.classList.add('lead');
    });
  });
  await p.pdf({ path: outPdf, format: 'A4', printBackground: true, displayHeaderFooter: true, timeout: 0,
    margin: { top: '18mm', bottom: '20mm', left: '18mm', right: '18mm' },
    headerTemplate: '<span></span>',
    footerTemplate: `<div style="width:100%;text-align:center;font-family:'DejaVu Sans',sans-serif;font-size:7px;color:#555">${title} · <span class="pageNumber"></span> / <span class="totalPages"></span></div>` });
  await b.close();
})();
