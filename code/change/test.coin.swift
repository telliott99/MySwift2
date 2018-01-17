let coins = Coin.allValues

func testChange() {
    let N = 100
    var s = S(p:N,n:0,d:0,q:0)
    
    for c1 in coins {
        for c2 in coins {
            if c1.rawValue >= c2.rawValue {
                continue
            }
            print("\(c1) -> \(c2)")
            print("\(s)")
            if let v = change(s,c1,c2) {
                print(" \(v)\n") 
            }
            else { print("nil\n") }
        }
    }
    print("-----------------")
    s = S(p:50,n:5,d:2,q:1)
    for c1 in coins {
        for c2 in coins {
            if c1.rawValue >= c2.rawValue {
                continue
            }
            print("\(c1) -> \(c2)")
            print("\(s)")
            print("\(change(s,c1,c2)!)\n")
        }
    }
}

func testContains() {
    let s1 = S(p: 100, n: 0, d: 0, q: 0)
    let s2 = S(p: 100, n: 0, d: 0, q: 0)
    let s3 = S(p: 75, n: 0, d: 0, q: 25)
    print("\(s1 == s2)")
    print("\(s1 == s3)")
    let a1 = [s1]
    print("\(a1.contains(s2))")
    print("\(a1.contains(s3))")
}

testChange()
testContains()
