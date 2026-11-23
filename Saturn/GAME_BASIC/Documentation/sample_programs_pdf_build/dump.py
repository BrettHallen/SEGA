import sys,os,glob,json,unicodedata
sys.path.insert(0,os.path.dirname(os.path.abspath(__file__)))
from common import *; import sel as S
ORDER=sys.argv[1:]
seen={}; units=[]
files=ORDER or sorted(os.path.basename(f) for f in glob.glob(CD+'/*.B'))
for f in files:
    L=load(f)
    for t,p in S.select(L):
        if t!='l': continue
        for a,b,kd,u in jp_units(L[p]):
            if u in seen: continue
            seen[u]=len(units); units.append((f,p,kd,u))
json.dump(units,open('units.json','w'),ensure_ascii=False)
cur=None
for i,(f,p,kd,u) in enumerate(units):
    if f!=cur: print('##',f); cur=f
    print(f"{i}{kd} {unicodedata.normalize('NFKC',u).strip()}")
