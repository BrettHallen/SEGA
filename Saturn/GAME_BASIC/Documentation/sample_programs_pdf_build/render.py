import sys,os,json,glob,re,difflib
sys.path.insert(0,os.path.dirname(os.path.abspath(__file__)))
from common import *; import sel as S
units=json.load(open(os.path.join(os.path.dirname(os.path.abspath(__file__)),'units.json')))
TR={}
for f in sorted(glob.glob(os.path.join(os.path.dirname(os.path.abspath(__file__)),'tr','*.tsv'))):
    for line in open(f,encoding='utf-8').read().split('\n'):
        if '\t' in line:
            k,v=line.split('\t',1); TR[int(k)]=v
BYTEXT={u[3]:TR[i] for i,u in enumerate(units) if i in TR}
for line in open(os.path.join(os.path.dirname(os.path.abspath(__file__)),'extra.txt'),encoding='utf-8').read().split('\n'):
    if '\t' in line:
        k,v=line.split('\t',1); BYTEXT[k]=v
missing=set()
def tr_line(l):
    us=jp_units(l)
    for a,b,k,u in sorted(us,reverse=True):
        if u in BYTEXT: t=BYTEXT[u]
        else:
            missing.add(u); t='[untranslated]'
        lead=re.match(r'\s*',u).group()
        if not t.startswith(' ') and lead and k!='c': t=lead+t
        if k=='c' and lead and not t.startswith(' '): t=' '+t
        if k=='d': t=t.replace(',',' ').strip()
        l=l[:a]+t+l[b:]
    # any leftover non-ascii (e.g. in gaps never shown) -> leave
    return l
def listing(f, lines=None):
    L=load(f) if lines is None else lines
    out=[]
    for t,p in S.select(L):
        if t=='l': out.append(tr_line(L[p]).rstrip())
        else:
            a,b=p; nd,n=S.gapinfo(L,a,b)
            first=re.match(r'\s*(\d+)',L[a]); last=re.match(r'\s*(\d+)',L[b-1])
            rng=f"lines {first.group(1)}-{last.group(1)}" if first and last else f"{n} lines"
            pl=lambda x,w: f"{x:,} {w}" + ("" if x==1 else "s")
            what=pl(nd,"DATA line") if nd==n else (pl(nd,"DATA line")+" and "+pl(n-nd,"comment line") if nd else pl(n,"comment line"))
            out.append(f"      ' ... {what} not shown ({rng}) ...")
    return out
def strip_num(l): return re.sub(r'^\s*\d+\s?','',l)
def vdiff(base,var):
    """diff of code (non-DATA) lines, line numbers removed"""
    A=[tr_line(l) for l in load(base) if not is_data(l)]
    B=[tr_line(l) for l in load(var) if not is_data(l)]
    a=[strip_num(x).rstrip() for x in A]; b=[strip_num(x).rstrip() for x in B]
    d=list(difflib.unified_diff(a,b,base,var,n=1,lineterm=''))
    return d
if __name__=='__main__':
    for x in listing(sys.argv[1]): print(x)
