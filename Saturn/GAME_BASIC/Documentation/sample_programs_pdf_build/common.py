import re, glob, os
CD=os.path.join(os.path.dirname(__file__),'..','cd')
JP=re.compile(r'[^\x00-\x7f]')
def load(f):
    raw=open(os.path.join(CD,f) if not os.path.isabs(f) else f,'rb').read()
    return raw.decode('cp932','replace').replace('\r\n','\n').replace('\r','\n').rstrip('\n').split('\n')
def is_data(l):
    return re.match(r'\s*\d*\s*DATA\b',l,re.I) is not None
def spans(l):
    """yield (start,end,kind) for string literals and comments"""
    i=0;n=len(l);out=[]
    while i<n:
        c=l[i]
        if c=='"':
            j=l.find('"',i+1); j=n if j<0 else j
            out.append((i+1,j,'s')); i=j+1; continue
        if c=="'" :
            out.append((i+1,n,'c')); break
        if l[i:i+3].upper()=='REM' and (i==0 or not l[i-1].isalnum()):
            out.append((i+3,n,'c')); break
        i+=1
    return out
def jp_units(l):
    r=[]
    for a,b,k in spans(l):
        t=l[a:b]
        if JP.search(t): r.append((a,b,k,t))
    m=[0]*len(l)
    for a,b,k in spans(l):
        for x in range(max(a-1,0),min(b+1,len(l))): m[x]=1
    for mm in re.finditer(r'[^\x00-\x7f]+',l):
        if not m[mm.start()]: r.append((mm.start(),mm.end(),'d',mm.group()))
    return r
