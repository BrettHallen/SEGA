#!/usr/bin/env python3
"""Scale the cover pages of a manual PDF to fill A4 and check it prints correctly double-sided.

  python3 covers_to_a4.py manual.pdf [out.pdf]

Any page that is not A4 (normally the scanned front and back covers) is scaled up or down to fill an
A4 page without stretching; a sliver of the scan is trimmed where its proportions differ from A4.
Links and other pages are untouched. With no out.pdf the file is rewritten in place.
It also reports whether the back cover lands on the back of the last sheet when printed double-sided
(that needs an even page count, with the back cover as the last page). Needs python3 with pypdf.
"""
import os, sys
from pypdf import PdfReader, PdfWriter, Transformation
from pypdf.generic import RectangleObject

A4 = (595.92, 842.88)

def to_a4(page):
    x0, y0 = float(page.mediabox.left), float(page.mediabox.bottom)
    w, h = float(page.mediabox.width), float(page.mediabox.height)
    s = max(A4[0] / w, A4[1] / h)
    page.add_transformation(Transformation().scale(s, s).translate((A4[0] - w * s) / 2 - x0 * s, (A4[1] - h * s) / 2 - y0 * s))
    for box in ('/MediaBox', '/CropBox', '/TrimBox', '/BleedBox', '/ArtBox'):
        if box in page: del page[box]
    page.mediabox = RectangleObject([0, 0, A4[0], A4[1]])
    return page

def main(src, dst=None):
    w = PdfWriter(clone_from=src)
    n = len(w.pages)
    changed = []
    for i, p in enumerate(w.pages):
        if abs(float(p.mediabox.width) - A4[0]) > 1 or abs(float(p.mediabox.height) - A4[1]) > 1:
            to_a4(p); changed.append(i + 1)
    print('scaled to A4: pages', changed or 'none')
    print('%d pages: %s' % (n, 'even, so the last page is the back of the last sheet' if n % 2 == 0
                            else 'ODD, so the last page would print on the front of a sheet; add a blank page before it'))
    out = (dst or src) + '.tmp'
    with open(out, 'wb') as f: w.write(f)
    os.replace(out, dst or src)

if __name__ == '__main__':
    main(*sys.argv[1:3])
