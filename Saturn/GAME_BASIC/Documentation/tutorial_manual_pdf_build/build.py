#!/usr/bin/env python3
"""Build the English Tutorial Manual PDF.

  python3 build.py <manual.md> <manual.pdf> [--covers covers.pdf]

* Converts the Markdown with pandoc and prints it with Chromium (build.js, style.css).
* Each chapter starts on a new page. Sections (Introduction, Contents, 2.1, 2.2 ...) flow on, but a
  section heading that would land near the bottom of a page moves to the next one (style.css).
  Each smaller heading is kept on the same page as at least a few lines of what follows it.
* Page numbers count every page of the PDF, covers included, so the footer and a PDF viewer agree.
* The front and back covers are copied from --covers (a 2-page PDF), or else from the first and last
  page of the existing <manual.pdf>, and scaled to fill an A4 page. A blank page follows the front
  cover and one or two precede the back cover, as needed to make the page count even: printed
  double-sided, the manual starts on a right-hand page and the back cover is the back of the last sheet.
Needs: pandoc, node with playwright, python3 with beautifulsoup4 and pypdf.
"""
import os, subprocess, sys, tempfile, shutil
from bs4 import BeautifulSoup
from pypdf import PdfReader, PdfWriter, PageObject
from covers_to_a4 import to_a4

HERE = os.path.dirname(os.path.abspath(__file__))
TITLE = 'GAME BASIC for SEGA SATURN Tutorial Manual (English)'
LEAD, TAIL = '<div class="dummy-lead"></div>', '<div class="dummy-tail"></div>'
MIN_LINES = 5               # a smaller heading is kept with at least this many lines of what follows
MAX_KEEP = 50               # ... unless that would need a block taller than this (in lines)

HEADS = ('h3', 'h4', 'h5')
MAX_TABLE_ROWS = 30         # tables up to this many rows are kept whole on one page

def is_label(el):
    """A paragraph that acts as a heading: bold-only text such as "■ Bitmap screen" or
    "Screen mode 1", or a short lead-in line ending in a colon."""
    if el.name != 'p':
        return False
    text = el.get_text().strip()
    kids = [k for k in el.contents if not (isinstance(k, str) and not k.strip())]
    if len(kids) == 1 and getattr(kids[0], 'name', None) == 'strong' and len(text) < 90:
        return True
    return text.endswith(':') and len(text) < 160

def page_breaks(soup):
    # keep tables whole, and notes (blockquotes) in one piece (see style.css)
    for t in soup.find_all('table'):
        if len(t.find_all('tr')) <= MAX_TABLE_ROWS:
            t['class'] = t.get('class', []) + ['keep']
    # keep each smaller heading or label on the same page as at least MIN_LINES lines of what follows it
    # (one level of wrapping only: Chromium does not reliably honour nested keep blocks, so a
    # heading's group runs on through any labels and needs MIN_LINES after the last of them)
    for h in soup.find_all(lambda e: e.name in HEADS or is_label(e)):
        if h.find_parent('div', class_='keep-with-next'):
            continue
        group, lines = [], 0
        for nxt in h.find_next_siblings():
            if nxt.name == 'section' or nxt.name in HEADS:
                break
            if is_label(nxt):
                if h.name == 'p':
                    break
                lines = 0
            group.append(nxt); lines += est_lines(nxt)
            if lines >= MIN_LINES or nxt.name in ('table', 'blockquote'):
                break
        # a small table that closes the item (e.g. a "Shortcut" table) stays with it too
        after = group[-1].find_next_sibling() if group else None
        if after is not None and after.name == 'table' and len(after.find_all('tr')) <= 4:
            group.append(after)
        if group and sum(est_lines(g) for g in group) <= MAX_KEEP:
            wrap = soup.new_tag('div', attrs={'class': 'keep-with-next'})
            h.insert_before(wrap); wrap.append(h.extract())
            for g in group: wrap.append(g.extract())

def est_lines(el):
    """Rough height of a block, in body text lines (about 95 characters each)."""
    if el.name == 'table':
        return 1.5 * len(el.find_all('tr')) + 1
    if el.name == 'div':
        return sum(est_lines(c) for c in el.find_all(recursive=False))
    if el.name == 'pre':
        return el.get_text().count('\n') + 2
    if el.name in ('ul', 'ol'):
        return sum(len(li.get_text()) // 85 + 1 for li in el.find_all('li')) + 1
    return len(el.get_text()) // 95 + 2

def build(md_path, pdf_path, covers=None):
    work = tempfile.mkdtemp(prefix='tmbuild_')
    html = os.path.join(work, 'body.html')
    subprocess.run(['pandoc', '-f', 'gfm', '-t', 'html5', '--section-divs', '--wrap=none', md_path, '-o', html], check=True)
    soup = BeautifulSoup(open(html, encoding='utf-8').read(), 'html.parser')
    page_breaks(soup)
    body = str(soup)
    raw = os.path.join(work, 'raw.pdf')
    for tail in (2, 3):   # a third stand-in (an extra blank page) only if the page count would be odd
        open(html, 'w', encoding='utf-8').write(LEAD * 2 + body + TAIL * tail)
        subprocess.run(['node', os.path.join(HERE, 'build.js'), html, os.path.join(HERE, 'style.css'), raw, TITLE], check=True)
        if len(PdfReader(raw).pages) % 2 == 0:
            break
    cov = PdfReader(covers) if covers else PdfReader(pdf_path)
    front, back = cov.pages[0], cov.pages[-1]
    for p in (front, back):
        res = p.get('/Resources', {})
        assert '/Font' not in res and '/XObject' in res, 'cover source has no cover pages (expected an image-only first and last page)'
    w = PdfWriter(clone_from=raw)
    n = len(w.pages)
    assert n % 2 == 0
    a4 = (float(w.pages[2].mediabox.width), float(w.pages[2].mediabox.height))
    blank = lambda: PageObject.create_blank_page(width=a4[0], height=a4[1])
    # replace the stand-ins: front cover, blank ... blank(s), back cover
    w.insert_page(to_a4(back), n)
    for _ in range(tail - 1):
        w.insert_page(blank(), n)
    for i in range(n - 1, n - 1 - tail, -1):
        del w.pages[i]
    w.insert_page(blank(), 0); w.insert_page(to_a4(front), 0)
    del w.pages[3]; del w.pages[2]
    w.add_metadata({'/Title': TITLE})
    tmp = pdf_path + '.new'
    with open(tmp, 'wb') as f:
        w.write(f)
    return tmp, raw, work

if __name__ == '__main__':
    a = sys.argv[1:]
    covers = None
    if '--covers' in a:
        i = a.index('--covers'); covers = a[i + 1]; del a[i:i + 2]
    tmp, raw, work = build(a[0], a[1], covers)
    os.replace(tmp, a[1])
    shutil.rmtree(work, ignore_errors=True)
    print('wrote', a[1], '(%d pages)' % len(PdfReader(a[1]).pages))
