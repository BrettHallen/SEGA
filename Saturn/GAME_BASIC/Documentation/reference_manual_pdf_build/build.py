#!/usr/bin/env python3
"""Build the English Reference Manual PDF, with an index whose page numbers come from the PDF itself.

  python3 build.py <manual.md> <manual.pdf> [--covers covers.pdf]

* The index entries (name, book page) are kept in index_entries.tsv, taken from the Japanese index
  (pp. 416-421). Each entry is matched to its heading in the translation, and the PDF page of that
  heading is written into the Markdown index and the PDF index.
* The build runs until the page numbers stop changing (normally two passes).
* Page numbers count every page of the PDF, covers included, so the footer number, the index
  and the page number shown by a PDF viewer all agree.
* The front and back cover pages are copied from --covers (a 2-page PDF), or else from the first
  and last page of the existing <manual.pdf>, and scaled to fill an A4 page. A blank page follows the
  front cover and precedes the back cover, so the page count stays even and, printed double-sided,
  the manual starts on a right-hand page and the back cover is the back of the last sheet.
Needs: pandoc, node with playwright, python3 with beautifulsoup4 and pypdf.
"""
import csv, os, re, subprocess, sys, tempfile, shutil
from bs4 import BeautifulSoup
from pypdf import PdfReader, PdfWriter
from resolve import resolve
HEADS = ['h1', 'h2', 'h3', 'h4', 'h5', 'h6']

HERE = os.path.dirname(os.path.abspath(__file__))
INDEX_RE = re.compile(r'\n## Index\n.*?(?=\n\*\[Two blank pages follow)', re.S)
LEAD, TAIL = '<div class="dummy-lead"></div>', '<div class="dummy-tail"></div>'

def load_entries():
    rows = list(csv.DictReader(open(os.path.join(HERE, 'index_entries.tsv'), encoding='utf-8'), delimiter='\t'))
    groups = []
    for r in rows:
        if not groups or groups[-1]['head'] != r['group']:
            groups.append({'head': r['group'], 'entries': []})
        e = {'name': r['name'], 'book': [int(x) for x in r['book_pages'].split(',')], 'subs': []}
        (groups[-1]['entries'][-1]['subs'] if r['parent'] else groups[-1]['entries']).append(e)
    return groups

def flat(groups):
    for g in groups:
        for e in g['entries']:
            yield e
            yield from e['subs']

def pandoc(md_text, out_html):
    subprocess.run(['pandoc', '-f', 'gfm', '-t', 'html5', '--section-divs', '--wrap=none', '-o', out_html],
                   input=md_text.encode('utf-8'), check=True)

def index_md(groups, pages):
    """The Markdown index. pages: target id -> PDF page (None on the first pass)."""
    out = ['', '## Index', '', '*[pp. 416–421]*', '',
           'Page numbers are the page numbers of the English PDF. Each entry is linked to its section.', '']
    for g in groups:
        out += ['### ' + g['head'], '']
        for e in g['entries']:
            for depth, x in [(0, e)] + [(1, s) for s in e['subs']]:
                name = '`%s`' % x['name'] if g['head'] == 'Symbols' else x['name']
                seen, links = set(), []
                for bp, tid, real in zip(x['book'], x['targets'], x['mdlink']):
                    pg = pages.get(tid) if pages else bp
                    if pg in seen: continue
                    seen.add(pg); links.append('[%s](#%s)' % (pg, tid) if real else '%s' % pg)
                out.append('  ' * depth + '- %s · %s' % (name, ', '.join(links)))
            # (subs written right after their parent)
        out.append('')
    return '\n'.join(out)

def style_index(soup, ents, pages):
    """Turn the index section's lists into the two-column dotted-leader layout."""
    sec = soup.find('section', id='index')
    ix = soup.new_tag('div', attrs={'class': 'ix'})
    sec.find('section', recursive=False).insert_before(ix)
    it = iter(ents)
    for child in list(sec.find_all('section', recursive=False)):
        ix.append(child.find('h3').extract())
        for li in child.find('ul').find_all('li'):
            e = next(it)
            sub = li.find_parent('li') is not None
            nested = li.find('ul')
            if nested: nested.extract()
            name = li.decode_contents().split(' · ')[0].strip()
            div = BeautifulSoup('<div class="%s"><span class="nm">%s</span><span class="dots"></span><span class="pg"></span></div>'
                                % ('e sub' if sub else 'e', name), 'html.parser').div
            pg, seen = div.find('span', class_='pg'), set()
            for bp, tid in zip(e['book'], e['targets']):
                n = pages.get(tid) if pages else bp
                if n in seen: continue
                if seen: pg.append(', ')
                seen.add(n)
                a = soup.new_tag('a', href='#' + tid); a.string = str(n); pg.append(a)
            ix.append(div)
            if nested: li.append(nested)
        for extra in [c for c in child.find_all(recursive=False) if c.name not in ('h3', 'ul')]:
            ix.insert_after(extra.extract())   # e.g. the closing note after the last letter
        child.decompose()
    assert next(it, None) is None

def to_a4(page, a4):
    """Scale a cover page to fill an A4 page, keeping its proportions (a sliver at the edges is trimmed)."""
    from pypdf import Transformation
    x0, y0 = float(page.mediabox.left), float(page.mediabox.bottom)
    w, h = float(page.mediabox.width), float(page.mediabox.height)
    s = max(a4[0] / w, a4[1] / h)
    tx, ty = (a4[0] - w * s) / 2 - x0 * s, (a4[1] - h * s) / 2 - y0 * s
    page.add_transformation(Transformation().scale(s, s).translate(tx, ty))
    for box in ('/MediaBox', '/CropBox', '/TrimBox', '/BleedBox', '/ArtBox'):
        if box in page: del page[box]
    from pypdf.generic import RectangleObject
    page.mediabox = RectangleObject([0, 0, a4[0], a4[1]])
    return page

def dest_pages(pdf):
    r = PdfReader(pdf)
    idx = {p.indirect_reference.idnum: i + 1 for i, p in enumerate(r.pages)}
    out = {}
    for name, d in r.named_destinations.items():
        out[name.lstrip('/')] = idx.get(d.page.idnum if hasattr(d.page, 'idnum') else None)
    return out

def build(md_path, pdf_path, covers=None):
    md = open(md_path, encoding='utf-8').read()
    assert INDEX_RE.search(md), 'Index section not found'
    md = md.replace('*[p. 415 is blank.]*\n\n*[p. 416]*\n', '*[p. 415 is blank.]*\n')
    groups = load_entries()
    work = tempfile.mkdtemp(prefix='rmbuild_')
    # match each entry to its heading (the index itself is left out of the search)
    pandoc(md, os.path.join(work, 'src.html'))
    soup = BeautifulSoup(open(os.path.join(work, 'src.html'), encoding='utf-8').read(), 'html.parser')
    idx = soup.find('section', id='index')
    ents = list(flat(groups))
    res = resolve(soup, ents, in_index=lambda el: el is idx or idx in el.parents)
    heads = soup.find_all(HEADS)
    order = {id(h): k for k, h in enumerate(heads)}
    for e, r in zip(ents, res):
        e['targets'], e['mdlink'] = [], []
        for bp, el, kind in r:
            assert kind == 'heading', (e['name'], bp, kind)
            k = order[id(el)]
            real = el.parent.get('id') if el.parent.name == 'section' else el.get('id')
            e['targets'].append('ix-h%d' % k if not real else real)
            e['mdlink'].append(bool(real))
        e['heads'] = [order[id(el)] for bp, el, kind in r]
    # cover pages
    cov = PdfReader(covers) if covers else PdfReader(pdf_path)
    front, back = cov.pages[0], cov.pages[-1]
    for p in (front, back):
        assert '/Font' not in p.get('/Resources', {}) and '/XObject' in p.get('/Resources', {}), \
            'cover source has no cover pages (expected an image-only first and last page)'
    pages, prev = None, None
    for n in range(1, 6):
        new_md = INDEX_RE.sub(lambda m: index_md(groups, pages), md, count=1)
        html = os.path.join(work, 'body.html'); pandoc(new_md, html)
        s = BeautifulSoup(open(html, encoding='utf-8').read(), 'html.parser')
        hs = s.find_all(HEADS)
        for e in ents:
            for k, tid, real in zip(e['heads'], e['targets'], e['mdlink']):
                if not real:
                    hs[k].parent['id'] = tid
        style_index(s, ents, pages)
        body = LEAD * 2 + str(s) + TAIL * 2   # stand-ins for the cover pages, so page numbers count them
        open(html, 'w', encoding='utf-8').write(body)
        raw = os.path.join(work, 'raw.pdf')
        subprocess.run(['node', os.path.join(HERE, 'build.js'), html, os.path.join(HERE, 'style.css'), raw], check=True)
        dp = dest_pages(raw)
        pages = {e2: dp.get(e2) for e in ents for e2 in e['targets']}
        missing = [k for k, v in pages.items() if not v]
        assert not missing, missing
        print('pass %d: %d pages, %d targets' % (n, len(PdfReader(raw).pages), len(pages)))
        if pages == prev: break
        prev = pages
    else:
        sys.exit('page numbers did not settle')
    # final PDF: front cover, blank, manual, blank, back cover (the four stand-in pages are replaced)
    from pypdf import PageObject
    w = PdfWriter(clone_from=raw)
    n = len(w.pages)
    a4 = (float(w.pages[2].mediabox.width), float(w.pages[2].mediabox.height))
    front, back = to_a4(front, a4), to_a4(back, a4)
    w.insert_page(back, n)
    w.insert_page(PageObject.create_blank_page(width=a4[0], height=a4[1]), n)
    for i in (n - 1, n - 2):
        del w.pages[i]
    w.insert_page(PageObject.create_blank_page(width=a4[0], height=a4[1]), 0)
    w.insert_page(front, 0)
    for i in (3, 2):
        del w.pages[i]
    w.add_metadata({'/Title': 'GAME BASIC for SEGA SATURN Reference Manual (English)'})
    tmp = pdf_path + '.new'
    with open(tmp, 'wb') as f:
        w.write(f)
    md_out = INDEX_RE.sub(lambda m: index_md(groups, pages), md, count=1)
    return tmp, md_out, work

if __name__ == '__main__':
    a = sys.argv[1:]
    covers = None
    if '--covers' in a:
        i = a.index('--covers'); covers = a[i + 1]; del a[i:i + 2]
    tmp, md_out, work = build(a[0], a[1], covers)
    os.replace(tmp, a[1])
    with open(a[0], 'w', encoding='utf-8') as f:
        f.write(md_out)
    shutil.rmtree(work, ignore_errors=True)
    print('wrote', a[0], 'and', a[1])
