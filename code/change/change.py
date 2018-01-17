# how many ways to change a dollar?
# each possible combination is a dict
coins = [1,5,10,25]
N = 100
D = dict(zip(coins, [N] + [0] * (len(coins)-1)))
L = [ D ]
#print D   # {1: 100, 10: 0, 5: 0, 25: 0}

# make substitution if possible 
# change n * coin 1 => coin 2
def change(D,c1,c2):
    rD = dict()
    for k in D:  
        rD[k] = D[k]
    # 10 => 25 is special
    if c1 is 10 and c2 is 25:
        if rD[10] < 2 or rD[5] < 1:  
            return None
        else:
            rD[5] -= 1
            rD[10] -= 2
            rD[25] += 1        
    else:
        if not c1*rD[c1] >= c2:  
            return None
        rD[c1] = rD[c1] - c2/c1
        rD[c2] += 1
    return rD
# - - - - - - - - - - - - - - - - - - - - - - - - - -
# start with N pennies
# for each coin 1..10, try changing to higher denom
# save results in L to explore further changes...

# keep a temp copy separate from L so we can append in loop
temp = list()
results = list()

while L:
    for D in L:  # we already checked, D is not yet in results
        results.append(D)
        # for each possible change given coins available
        for i in range(len(coins)-1):
            for j in range(i,len(coins)):
                # change if possible
                rD = change(D,coins[i],coins[j])
                #if we haven't seen this one yet
                if rD and not (rD in results or rD in temp):
                    temp.append(rD)
                    # since there is a new one(s) do not quit
    L = temp[:]
    temp = list()

print len(results)
results.sort(reverse=True)
for D in results[:5]:  
    print D
