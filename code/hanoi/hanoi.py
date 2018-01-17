def pprint():
    pL = []
    for k in 'LMR':
        pL.append(str(D[k]).ljust(20))
    print '\n'.join(pL)

def validate(v, dst):
    for item in D[dst]:
        assert item > v

def find_value(value):
    for k in D:
        if value in D[k]:
            return k

def find_cache(src,dst):
    pD = { 'LM':'R', 'LR':'M', 'MR':'L' }
    k = ''.join(sorted([src,dst]))
    return pD[k]
    
def move(value, dst='R'):
    print "move %s dst %s" % (value, dst)
    src = find_value(value)
    validate(value,dst)
    assert value == D[src].pop()
    D[dst].append(value)

def solve(value,dst):
    pprint()
    print "solve value: %s" % value
    if value == 1:
        move(1, dst)
        return
    src = find_value(value)
    cache = find_cache(src,dst)
    print "src %s dst %s cache %s" % (src, dst, cache)
    
    solve(value-1,cache)
    move(value,dst)
    solve(value-1,dst)

N = 5
sL = range(1,N+1)
sL.reverse()
D = { 'L':sL,
      'M':[],
      'R':[] }

solve(N,'R')
pprint()
