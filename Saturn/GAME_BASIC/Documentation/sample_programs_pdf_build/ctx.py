import sys,os,json,unicodedata
sys.path.insert(0,'.')
from common import *; import sel as S
units=json.load(open('units.json')); idx={u[3]:i for i,u in enumerate(units)}
f=sys.argv[1]; lo,hi=int(sys.argv[2]),int(sys.argv[3])
L=load(f)
for t,p in S.select(L):
    if t!='l': continue
    l=L[p]; us=jp_units(l)
    if not us: continue
    ids=[idx[u[3]] for u in us]
    if not any(lo<=i<=hi for i in ids): continue
    out=l; 
    for a,b,k,u in sorted(us,reverse=True):
        out=out[:a]+'«%d:%s»'%(idx[u],u)+out[b:]
    out=unicodedata.normalize('NFKC',out)
    out=re.sub(r'^\s*\d+\s*','',out)
    out=re.sub(r'KPRINT\s*','K ',out)
    out=re.sub(r',?,?,?RGB\(\d+,\d+,\d+\)','',out)
    print(out)
