// Render a manual's HTML to PDF with Chromium (Playwright).
// Usage: node build.js body.html style.css out.pdf "Footer title"
const { chromium } = require('playwright');
const fs = require('fs');
const [,, bodyFile, cssFile, outPdf, title] = process.argv;
const html = `<!doctype html><html lang="en"><head><meta charset="utf-8"><title>${title}</title><style>${fs.readFileSync(cssFile,'utf8')}</style></head><body>${fs.readFileSync(bodyFile,'utf8')}</body></html>`;
(async () => {
  const b = await chromium.launch(); const p = await b.newPage();
  await p.setContent(html, { waitUntil: 'load', timeout: 0 });
  // Page margins come from @page in style.css (18 mm; 18.2 mm on the right).
  await p.pdf({ path: outPdf, format: 'A4', printBackground: true, displayHeaderFooter: true, timeout: 0,
    headerTemplate: '<span></span>',
    footerTemplate: `<div style="width:100%;text-align:center;font-family:'DejaVu Sans',sans-serif;font-size:6.5px;color:#555">${title} · <span class="pageNumber"></span> / <span class="totalPages"></span></div>` });
  await b.close();
})();
