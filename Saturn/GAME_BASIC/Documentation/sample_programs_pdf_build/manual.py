import re,sys,json
def blocks(path, minnum=8):
    lines=open(path,encoding='utf-8').read().split('\n')
    heads=[]; out=[]; inb=False; buf=[]; start=0
    for i,l in enumerate(lines):
        if not inb and re.match(r'#+ ',l): heads.append((l.count('#',0,l.index(' ')),l.split(' ',1)[1].strip(),i))
        if l.startswith('```'):
            if inb:
                num=sum(1 for b in buf if re.match(r'\s*\d+\s+\S',b))
                if num>=minnum:
                    # context: headings path
                    path_=[]; 
                    for lv,t,li in heads:
                        path_=[p for p in path_ if p[0]<lv]+[(lv,t)]
                    # preceding paragraph
                    j=start-1
                    while j>0 and lines[j].strip()=='': j-=1
                    k=j
                    while k>0 and lines[k-1].strip()!='' and not lines[k-1].startswith('```'): k-=1
                    para=' '.join(lines[k:j+1])
                    out.append(dict(path=[t for lv,t in path_],code='\n'.join(buf),para=para,line=start+1))
                buf=[]
            else: start=i
            inb=not inb; continue
        if inb: buf.append(l)
    return out
if __name__=='__main__':
    for b in blocks(sys.argv[1]):
        print('####', ' > '.join(b['path'][-3:]), '| line',b['line']); print('PARA:',b['para'][:300]); print(b['code'][:200]); print()
