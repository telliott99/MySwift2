let coins = Coin.allValues

/*
how many ways to change a dollar?
each possible combination is a struct of Type S
(S for "Satchel")
*/

// we should not modify L while also looping over it
var temp = [S]()
var results = [S]()

func test(inout L: [S]) {
    while L.count > 0 {
        for s in L {
            results.append(s)  // we checked uniqueness already
            for c1 in coins {
                for c2 in coins {
                    if c1.rawValue >= c2.rawValue {
                        continue
                    }
                    let rs = change(s, c1, c2)
                    if nil != rs {
                        let us = rs!
                        if !results.contains(us) {
                            if !temp.contains(us) {
                                temp.append(us)
                            }
                        }
                    }
                }
            }
        }
        L = temp
        temp = [S]()
    }

    print(results.count)
    for r in results {
        print(r)
    }
}

let N = 100
var s = S(p:N, n:0, d:0, q:0)
var L = [s]

test(&L)

var a = [String]()
for r in L {
    a.append("\(r)")
}

a.sortInPlace(>)
for r in a {
    print(r)
}