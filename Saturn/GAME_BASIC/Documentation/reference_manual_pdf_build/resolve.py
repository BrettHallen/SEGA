import re,csv,sys
from bs4 import BeautifulSoup, NavigableString, Tag
MARK=re.compile(r'^\[pp?\. (\d+)')
def norm(s):
    s=s.replace('～','–').replace('~','–').replace('`','').replace(' ',' ')
    return re.sub(r'\s+',' ',s).strip()
def walk(soup):
    """Yield ('mark',page,el) / ('head',text,el) / ('block',text,el) in document order."""
    for el in soup.body.descendants if soup.body else soup.descendants:
        if not isinstance(el,Tag): continue
        if el.name=='em':
            m=MARK.match(el.get_text().strip())
            if m: yield ('mark',int(m.group(1)),el)
        elif el.name in ('h2','h3','h4','h5'):
            yield ('head',norm(el.get_text()),el)
        elif el.name in ('p','li','td','th','pre','dt','dd'):
            yield ('block',norm(el.get_text()),el)
def score(name,h):
    n=norm(name)
    if h==n: return 3
    if h.startswith(n+' ('): return 2
    if n in [x.strip() for x in re.split(r' / | or ',h)]: return 2
    m=re.match(r'^(\d+) \((@?\w+)\)$',n)
    if m and re.match(r'^%s[ (]'%m.group(1),h) and re.search(r'(?<![\w@])%s(?!\w)'%re.escape(m.group(2)),h): return 2
    return 0
def resolve(soup,entries,in_index=None):
    page=None; ev=[]
    for kind,val,el in walk(soup):
        if in_index is not None and in_index(el): break
        if kind=='mark': page=val
        ev.append((kind,val,el,page))
    # next-marker page for each event
    nxt=None; nm=[None]*len(ev)
    for i in range(len(ev)-1,-1,-1):
        if ev[i][0]=='mark': nxt=ev[i][1]
        nm[i]=nxt
    marks={}
    for kind,val,el,pg in ev:
        if kind=='mark': marks.setdefault(val,el)
    out=[]
    for e in entries:
        name=e['name']; res=[]
        for bp in e['book']:
            best=None
            for i,(kind,val,el,pg) in enumerate(ev):
                if kind!='head': continue
                if pg==bp or (nm[i]==bp and pg==bp-1):
                    s=score(name,val)+(0.5 if pg==bp else 0)
                    if s>=2 and (best is None or s>best[0]): best=(s,el,'heading')
            if best is None:
                for i,(kind,val,el,pg) in enumerate(ev):
                    if kind=='block' and pg==bp and re.search(r'(?<![\w$@])%s(?![\w$(])'%re.escape(norm(name)),val):
                        best=(1,el,'text'); break
            if best is None and bp in marks: best=(0,marks[bp],'marker')
            res.append((bp,)+((best[1],best[2]) if best else (None,'none')))
        out.append(res)
    return out
