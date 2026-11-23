import sys,re,glob,os
sys.path.insert(0,os.path.dirname(os.path.abspath(__file__)))
from common import *
MIN=6
def cls(l):
    s=re.sub(r'^\s*\d*\s*','',l)
    if re.match(r'DATA\b',s,re.I): return 'D'
    if s=='' or s.startswith("'") or re.match(r'REM\b',s,re.I): return 'C'
    if re.match(r'\*\w+\s*(:?\s*\'.*)?$',s): return 'L'
    return 'X'
def select(lines):
    c=[cls(l) for l in lines]; n=len(lines); out=[]; i=0
    while i<n:
        if c[i] in 'DCL':
            j=i
            while j<n and c[j] in 'DCL': j+=1
            # trim leading/trailing non-D within block to treat as normal
            nd=c[i:j].count('D')
            if nd>=MIN:
                keep=set()
                d=[k for k in range(i,j) if c[k]=='D']
                a=d[0]; b=d[-1]
                keep.update(range(i,a))           # comments/labels before first DATA
                keep.update(d[:3]); keep.add(b); keep.update(range(b+1,j))
                for k in range(a,b):
                    if c[k]=='L':
                        keep.add(k)
                        if k+1<=b: keep.add(k+1)
                        if k-1>=a and c[k-1]=='C' and JP.search(lines[k-1]) is None and lines[k-1].strip(" '0123456789")!='': keep.add(k-1)
                # don't hide runs of 1-2 lines
                k=i
                while k<j:
                    if k not in keep:
                        m=k
                        while m<j and m not in keep: m+=1
                        if m-k<=2: keep.update(range(k,m))
                        k=m
                    else: k+=1
                prev=None; gs=None
                for k in range(i,j):
                    if k in keep:
                        if gs is not None: out.append(('gap',(gs,k))); gs=None
                        out.append(('l',k))
                    elif gs is None: gs=k
                if gs is not None: out.append(('gap',(gs,j)))
            else:
                out+= [('l',k) for k in range(i,j)]
            i=j
        else:
            out.append(('l',i)); i+=1
    return out
def gapinfo(lines,a,b):
    nd=sum(1 for k in range(a,b) if cls(lines[k])=='D')
    return nd, b-a
if __name__=='__main__':
    r=[]; T=0; U={}
    for f in sorted(glob.glob(os.path.join(CD,'*.B'))):
        L=load(f); s=select(L); k=[p for t,p in s if t=='l']
        u=set(t for i in k for a,b,kd,t in jp_units(L[i])); T+=len(k)
        for x in u: U[x]=1
        r.append((len(k),len(u),sum(len(x) for x in u),os.path.basename(f)))
    for x in sorted(r): print(*x)
    print(T,len(U),sum(len(x) for x in U))
