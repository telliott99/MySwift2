.. _change:

##################
The Change Problem
##################

Discussion?

Algorithm:

.. sourcecode:: python

    '''
    algorithm:
    for each dict that we have discovered but not tried to manipulate:
        save it in our permanent list of solutions
        work with it further...
        for each coin type i from penny to dime:
            for each coin type j from the next highest to the last one:
                try to make change from i to j
                if we succeed:
                    check to be sure this is not a solution we know already
                    add it to the list for the next round and mark "not done"
    '''

.. sourcecode:: python

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

.. sourcecode:: bash

    > python change.py
    242
    {1: 100, 10: 0, 5: 0, 25: 0}
    {1: 95, 10: 0, 5: 1, 25: 0}
    {1: 90, 10: 0, 5: 2, 25: 0}
    {1: 90, 10: 1, 5: 0, 25: 0}
    {1: 85, 10: 0, 5: 3, 25: 0}
    >

The problem grows very fast as the value of N increases:

.. sourcecode:: bash

    N = 100 => 242
    N = 200 => 1463
    N = 300 => 4464
    N = 400 => 10045
    
Now, to convert the algorithm to Swift.  First we write the ``Coin`` enum Type, and then a struct ``S`` to hold the data.  S for "Satchel".  The struct is subscriptable with ``Coin``, so we can write

.. sourcecode:: swift

    let s = S(p: 100, n: 0, d: 0, q: 0)
    let value = s[.penny]   // value is 100
    
Using hard-coded values for the coins makes the code less extensible, but I thought it was a good place to show off enum subscripting.

The accessory function ``change`` checks to see whether we have enough of one coin (like 5 pennies) to change into a nickel.  If so, we construct a new satchel to hold the result.  A special case is conversion of dime => quarter, where we also need a nickel as well as two dimes.

Because the conversion often fails, we return an Optional.

.. sourcecode:: swift

    enum Coin: Int {
        case penny = 1
        case nickel = 5
        case dime = 10
        case quarter = 25
        static let allValues = [penny,nickel,dime,quarter]
    }

    func == (lhs: S, rhs: S) -> Bool {
        return "\(lhs)"  == "\(rhs)"
    }

    struct S: CustomStringConvertible, Equatable, Hashable {
        var p: Int
        var n: Int
        var d: Int
        var q: Int
        var description: String {
            get {
                return "\(p)p \(n)n \(d)d \(q)q"
            }
        }
        var hashValue: Int {
            return p + n * 100 + d * 2000 + q * 200000
        }
        subscript(coin: Coin) -> Int {
            get {
                switch coin {
                    case .penny:   return self.p
                    case .nickel:  return self.n
                    case .dime:    return self.d
                    case .quarter: return self.q
                }
            }
            set {
                switch coin {
                    case .penny:   self.p = newValue
                    case .nickel:  self.n = newValue
                    case .dime:    self.d = newValue
                    case .quarter: self.q = newValue
                }
            }
        }
    }

    func change(s: S, _ c1: Coin, _ c2: Coin) -> S? {
        var v1 = s[c1]
        var v2 = s[c2]
        // dime and quarter are special because need a nickel too
        if c1 == .dime && c2 == .quarter {
            if s[.nickel] < 1 || s[.dime] < 2 { 
                return nil
            }
            let v0 = s[.nickel] - 1
            v1 -= 2
            v2 += 1
            return S(p: s.p, n: v0, d: v1, q: v2)
        }
        else {
            if v1 * c1.rawValue < c2.rawValue { 
                return nil 
            }
            // we know the types of c1 and c2, find the other two
            let others = Set(coins).subtract(Set([c1,c2]))
            var rs = S(p: 0, n: 0, d: 0, q: 0)
            for c in others {
                rs[c] = s[c]
            }
            rs[c1] = v1 - c2.rawValue/c1.rawValue
            rs[c2] = v2 + 1
            // print("rs \(rs)")
            return rs
        }
    }

To begin with, we put this code into its own file and then add a test suite.  

.. sourcecode:: swift

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

One awkward bit is:

.. sourcecode:: swift

    for c1 in coins {
        for c2 in coins {
            if c1.rawValue >= c2.rawValue {
                continue
            }

I would like to loop over the Coin enum in order twice, only picking coins for c2 with higher value than c1.  I don't know how to do this elegantly yet.

To use the two-file approach, the second file must be named ``main.swift``.  We copy to this file from the source before compiling.

.. sourcecode:: bash

    > cp test.coin.swift main.swift
    > swiftc coin.swift main.swift && ./main
    penny -> nickel
    100p 0n 0d 0q
     95p 1n 0d 0q

    penny -> dime
    100p 0n 0d 0q
     90p 0n 1d 0q

    penny -> quarter
    100p 0n 0d 0q
     75p 0n 0d 1q

    nickel -> dime
    100p 0n 0d 0q
    nil

    nickel -> quarter
    100p 0n 0d 0q
    nil

    dime -> quarter
    100p 0n 0d 0q
    nil

    -----------------
    penny -> nickel
    50p 5n 2d 1q
    45p 6n 2d 1q

    penny -> dime
    50p 5n 2d 1q
    40p 5n 3d 1q

    penny -> quarter
    50p 5n 2d 1q
    25p 5n 2d 2q

    nickel -> dime
    50p 5n 2d 1q
    50p 3n 3d 1q

    nickel -> quarter
    50p 5n 2d 1q
    50p 0n 2d 2q

    dime -> quarter
    50p 5n 2d 1q
    50p 4n 0d 2q

    true
    false
    true
    false
    > 

Everything works as expected.  Finally, to actually implement the algorithm.

``change.swift``:

.. sourcecode:: swift

     /*
     how many ways to change a dollar?
     each possible combination is a struct of Type S
     */

     // we should not modify L while also looping over it
     var temp = [S]()
     var results = [S]()

     func test(inout L: [S]) -> [S] {
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
         return results
     }

     let N = 100
     var s = S(p:N, n:0, d:0, q:0)
     var L = [s]

     results = test(&L)
     print(results.count)

     var a = [String]()
     for r in results {
         a.append("\(r)")
     }

     a.sortInPlace(>)
     for r in a {
         print(r)
     }
    
.. sourcecode:: bash
     
     > cp change.swift main.swift
     > swiftc coin.swift main.swift && ./main
     242
     95p 1n 0d 0q
     90p 2n 0d 0q
     90p 0n 1d 0q
     85p 3n 0d 0q
     85p 1n 1d 0q
     
     ...
     0p 10n 5d 0q
     0p 10n 0d 2q
     0p 0n 5d 2q
     0p 0n 10d 0q
     0p 0n 0d 4q
     >

(``100p..`` sorts between ``10p..`` and ``0p..``)

I changed to an array of Strings at the end to allow easy sorting of the results.  This could also be done better using the actual type S.

We get the same answer for both the Python and the Swift implementations.

Compare with the SICP book, page ___.

