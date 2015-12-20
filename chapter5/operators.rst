.. _operators:

#########
Operators
#########

I believe I put this in the section on random numbers, but it is pretty cool so I'll repeat it here.

What I want is an operator to do exponentiation.  Swift doesn't have one, but I can define my own.  Here is one:

.. sourcecode:: bash

    import Foundation  // for `pow`

    infix operator ** { }
    func ** (n: Double, p: Double) -> Double {
        return pow(n,p)
    }
    print("\(2**5)")

This prints what you'd expect (except that the type of the result is Double).

Here is another one that works with Ints only, and doesn't require ``import Foundation``.

.. sourcecode:: bash

    infix operator ** { }
    func ** (n: Int, p: Int) -> Int {
        var result = 1
        for _ in 0..<p {
            result *= n
        }
        return result
    }

    print("\(2**5)")  // 32

Another operator is ``??``, defined as

    A new ?? nil coalescing operator.. ?? is a short-circuiting operator, similar to && and ||, which takes an optional on the left and a lazily-evaluated non-optional expression on the right.
    
    The nil coalescing operator provides commonly useful behavior when working with optionals, and codifies this operation with a standardized name. If the optional has a value, its value is returned as a non-optional; otherwise, the expression on the right is evaluated and returned.
    
Say what?

.. sourcecode:: bash

    let D = ["a":"apple"]
    var v = D["a"]
    var result = v ?? "no result"
    print(result)
    result = D["b"] ?? "no result"
    print(result)

.. sourcecode:: bash

    > swift test.swift
    apple
    no result
    >

I think the key here is that the right-hand side rhs is "lazily-evaluated", but I don't have a good example at the moment.

What is actually *really* useful is that we can define new operators, and those can be any symbol we want, here is an obvious one:

.. sourcecode:: bash

    import Foundation

    prefix operator √ { }
    prefix func √(f: Double) -> Double {
        return sqrt(f)
    }

    print("\(√(2.0))")

.. sourcecode:: bash

    > xcrun swift test.swift 
    1.4142135623731
    >

If you are starting to think these Swift folks are entirely too clever for their own good, we are thinking along the same lines.

.. sourcecode:: bash

    infix operator  ☂ { }

    func ☂ (a: [String:Int], b: [String:Int]) -> [String:Int] {
        var D = a
        for k in b.keys {
            let v = b[k]
            if let value = D[k] {
                D.updateValue(value + v!, forKey:k)
            }
            else {
                D[k] = v
            }
        }
        return D
    }

    let D1 = ["a":1]
    let D2 = ["a":2, "b":2]
    let rD = D1 ☂ D2
    print("\(rD)")
    
.. sourcecode:: bash

    > swift test.swift
    ["b": 2, "a": 3]
    >