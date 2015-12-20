.. _optionals:

#########
Optionals
#########

It's useful to allow an operation that may or may not succeed, and if it doesn't work, just deal with it.  Swift is strongly typed, but to cover this situation it has values called "Optionals" that may either be ``nil`` or may have a value including a basic type like Int or String.  Consider the following:

.. sourcecode:: bash

    var s: String = "123"
    let m: Int? = Int(s)
    s += "x"
    let n: Int? = Int(s)
    print(m)
    print(n)
    
The second conversion ``Int(s)`` will fail because the value ``"123x"`` can't be converted to an integer.  Nevertheless, the code compiles and when run it prints

.. sourcecode:: bash

    Optional(123)
    nil
    > 

The values ``m`` and ``n`` are "Optionals".  Test for ``nil`` by doing either of the following:

.. sourcecode:: bash

    
    let m: Int? = Int("123x")
    let n = Int("123")
    // "forced unwrapping"
    
    if m != nil { print("m: Int? = Int(\"123x\") worked: \(m!)") }
    if n != nil { print("n = Int(\"123\") worked: \(n!)") }
    if let o = Int("123") {  print("really") }
    
.. sourcecode:: bash

    > swift test.swift
    n = Int("123") worked: 123
    really
    > 
    
Use of the ! symbol in ``n!`` forces the value of ``n`` as an Int to be used, which is fine, once we know for sure that it is not ``nil``.

.. sourcecode:: bash
    
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

Another idiom in Swift is "optional binding"

.. sourcecode:: bash

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
    
.. sourcecode:: bash
    
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