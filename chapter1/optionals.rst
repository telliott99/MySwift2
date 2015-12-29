.. _optionals:

#########
Optionals
#########

It's useful to allow an operation that may or may not succeed, and if it doesn't work, just deal with it.  Swift is strongly typed, but to cover this situation it has values called "Optionals" that may either be ``nil`` *or* have a value including a basic type like Int or String.  Consider the following:

.. sourcecode:: swift

    var s: String = "123"
    let m: Int? = Int(s)
    s += "x"
    let n: Int? = Int(s)
    print(m)
    print(n)
    
The second conversion ``Int(s)`` will fail because the value ``"123x"`` can't be converted to an integer.  Nevertheless, the code compiles and when run it prints

.. sourcecode:: swift

    Optional(123)
    nil
    > 

The values ``m`` and ``n`` are "Optionals".  Test for ``nil`` by doing either of the following:

.. sourcecode:: swift

    
    let m: Int? = Int("123x")
    let n = Int("123")
    // "forced unwrapping"
    
    if m != nil { 
        print("m: Int? = Int(\"123x\") worked: \(m!)") 
    }
    if n != nil { 
        print("n = Int(\"123\") worked: \(n!)") 
    }
    if let o = Int("123") {  
        print("really") 
    }
    
.. sourcecode:: bash

    > swift test.swift
    n = Int("123") worked: 123
    really
    > 
    
Use of the ! symbol in ``n!`` forces the value of ``n`` as an Int to be used, which is fine, once we know for sure that it is not ``nil``.

.. sourcecode:: swift
    
    import Foundation
    func getOptional() -> Int? {
        let r = Int(arc4random_uniform(10))
        if r < 6 {
            return nil
        }
        return r
    }

    var n: Int?
    for i in 1...6 {
        n = getOptional()
        if (n != nil) { 
            print("\(i): \(n!)")
        }
    }

.. sourcecode:: bash

    > swift test.swift
    1: 8
    2: 7
    5: 8
    6: 9
    >

Here is an application where we test candidate primes for division by an array of prime numbers.

.. sourcecode:: swift

    func hasDivisorInArray(n: Int, _ a: [Int]) -> Int? {
        for i in a {
            if n % i == 0 {
                return i
            }
        }
        return nil
    }

    func addNextPrime(inout a: [Int]) {
        print("\naddNextPrime:  \(a)")
        var q = a.last! + 1
        while true {
            print("\(q): ", terminator: " ")
            if let p = hasDivisorInArray(q,a) {
                print("\(p) divides \(q) evenly, giving \(q/p)")
                q++
                continue
            }
            a.append(q)
            print("found new prime \(q)")
            return
        }
    }

    var pL = [2]
    for i in 0..<10{
        addNextPrime(&pL)
    }
    print(pL)

.. sourcecode:: bash

    > swift test.swift 

    addNextPrime:  [2]
    3:  found new prime 3

    addNextPrime:  [2, 3]
    4:  2 divides 4 evenly, giving 2
    5:  found new prime 5

    addNextPrime:  [2, 3, 5]
    6:  2 divides 6 evenly, giving 3
    7:  found new prime 7

    addNextPrime:  [2, 3, 5, 7]
    8:  2 divides 8 evenly, giving 4
    9:  3 divides 9 evenly, giving 3
    10:  2 divides 10 evenly, giving 5
    11:  found new prime 11

    addNextPrime:  [2, 3, 5, 7, 11]
    12:  2 divides 12 evenly, giving 6
    13:  found new prime 13

    addNextPrime:  [2, 3, 5, 7, 11, 13]
    14:  2 divides 14 evenly, giving 7
    15:  3 divides 15 evenly, giving 5
    16:  2 divides 16 evenly, giving 8
    17:  found new prime 17

    addNextPrime:  [2, 3, 5, 7, 11, 13, 17]
    18:  2 divides 18 evenly, giving 9
    19:  found new prime 19

    addNextPrime:  [2, 3, 5, 7, 11, 13, 17, 19]
    20:  2 divides 20 evenly, giving 10
    21:  3 divides 21 evenly, giving 7
    22:  2 divides 22 evenly, giving 11
    23:  found new prime 23

    addNextPrime:  [2, 3, 5, 7, 11, 13, 17, 19, 23]
    24:  2 divides 24 evenly, giving 12
    25:  5 divides 25 evenly, giving 5
    26:  2 divides 26 evenly, giving 13
    27:  3 divides 27 evenly, giving 9
    28:  2 divides 28 evenly, giving 14
    29:  found new prime 29

    addNextPrime:  [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]
    30:  2 divides 30 evenly, giving 15
    31:  found new prime 31
    [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31]
    >  

Another idiom in Swift is "optional binding"

.. sourcecode:: swift

    if let n = dodgyNumber.toInt() {
        print("\(dodgyNumber) has an integer value of \(n)")
           } 
    else {
        print("\(dodgyNumber) could not be converted to an integer")
    }

Normally one has to use a Boolean value in an ``if`` construct, but here we're allowed to use an optional.  If it evaluates to ``nil`` we do the ``else``, otherwise ``n`` has an Int value and we can use it.

A bit stranger is the "implicitly unwrapped optional":

    Sometimes it is clear from a program’s structure that an optional will always have a value, after that value is first set. In these cases, it is useful to remove the need to check and unwrap the optional's value every time it is accessed, because it can be safely assumed to have a value all of the time.

    These kinds of optionals are defined as implicitly unwrapped optionals. You write an implicitly unwrapped optional by placing an exclamation mark (String!) rather than a question mark (String?) after the type..
    
.. sourcecode:: swift
    
    let possibleString: String? = "standard optional string"
    print("\(possibleString!)")

    let assumedString: String! = "implicitly unwrapped optional"
    if assumedString != nil {
        print("\(assumedString)")
    }

.. sourcecode:: bash

    > swift test.swift
    standard optional string
    implicitly unwrapped optional
    >
    
The second string is an Optional (and could have nil assigned to it), but we are telling the compiler that we will check to make sure it's non-nil right away, and we're requesting the convenience of not having to write ``assumedString!`` everywhere we want to access its value.

Finally, we have the *failable initializer*.  At the beginning of this section, when we did:

.. sourcecode:: swift

    Int('123')

what was going on behind the scenes is that an "initializer" for Int was called that has the following signature:

.. sourcecode:: swift

    init?(_ text: String, radix: Int = default)

Without worrying too much about what exactly the initializer was doing, the ``?`` means that the initializer may fail (if the String input is not convertible to an integer).  If the initializer succeeds, an Int is produced;  if it fails, we get ``nil``.

