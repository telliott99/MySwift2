.. _generators:

##########
Generators
##########

We introduced protocols previously (:ref:`protocols`).  Let's extend that discussion by looking at the GeneratorType protocol.

First, and fundamentally, there is some object that provides a method ``next``, where each successive call to ``next`` provides the *next* element.

We will try to do this with a struct rather than a class, because we don't intend to subclass our generator.  This means that the ``next`` function needs to be marked mutating, because it changes state within the struct, and ``i`` needs to be a variable rather than a constant.  (None of this is needed if we use a class).

.. sourcecode:: bash

    struct IntGenerator {
        var i = 0
        mutating func next() -> Int {
            i += 1
            return i
        }
    }

    var o = IntGenerator()
    for _ in 1..<11 { 
        print(o.next(), terminator: " ")
    }
    print("")
    
.. sourcecode:: bash

    > swift test.swift.txt 
    1 2 3 4 5 6 7 8 9 10 
    >

If we now try to say that our struct is

.. sourcecode:: bash

    struct IntGenerator: GeneratorType
    
we'll get some errors that lead us to make a few changes

.. sourcecode:: bash

    struct IntGenerator: GeneratorType {
        typealias Element = Int
        var i = 0
        mutating func next() -> Element? {
            i += 1
            return i
        }
    }

    var o = IntGenerator()
    for _ in 1..<11 { 
        if let n = o.next() {
            print(n, terminator: " ")
        }
    }
    print("")

What have we done?  Fundamentally, the protocol requires a method ``next`` with this signature:

.. sourcecode:: bash

    mutating func next() -> Element?

and that return type of ``Element`` requires a "nested" typealias in the struct definition.

http://swiftdoc.org/v2.0/protocol/GeneratorType/

This code compiles and gives the same output as before.

.. sourcecode:: bash

    > swift test.swift.txt 
    1 2 3 4 5 6 7 8 9 10 
    >

The optional type of ``Element?`` is also required, and its presence suggests the idea that the sequence may have a finite number of values.  So let's modify ``next`` to return ``nil`` when the sequence reaches some maximum value:

.. sourcecode:: bash

    struct IntGenerator: GeneratorType {
        typealias Element = Int
        var i = 0
        mutating func next() -> Element? {
            i += 1
            if i > 5 {
                return nil
            }
            return i
        }
    }

    var o = IntGenerator()
    for _ in 1..<11 { 
        if let n = o.next() {
            print(n, terminator: " ")
        }
    }
    print("")

.. sourcecode:: bash

    > swift test.swift.txt 
    1 2 3 4 5 
    >

Now we try to use the ``for .. in`` construct, by substituting this for the bottom part of the code above:

.. sourcecode:: bash

    var og = IntGenerator()
    for n in og { 
        print(n)
        }
    print("")

The compiler complains that "value of type 'IntGenerator' has no member 'Generator'".  

I am not quite sure what's going on here, but I solved this by adding another struct.  That's the only change to the code.  That and we instantiate the second struct rather than the first in the ``for .. in`` part.

.. sourcecode:: bash

    struct IntGenerator: GeneratorType {
        typealias Element = Int
        var i = 0
        mutating func next() -> Element? {
            i += 1
            if i > 5 { return nil }
            return i
        }
    }

    struct Interator: SequenceType {
        typealias Generator = IntGenerator
        func generate() -> Generator {
            return IntGenerator()
        }
    }

    var og = Interator()
    for n in og { 
        print(n, terminator: " ")
        }
    print("")

This additional struct has a ``generate`` method which returns a ``Generator``

.. sourcecode:: bash

    func generate() -> Generator

``Generator`` needs to be typealiased for this to work.  We also declare that the new struct follows the ``SequenceType`` protocol.

It works!

.. sourcecode:: bash

    > swift test.swift.txt 
    1 2 3 4 5 
    >

Here is another one that gives the Fibonacci numbers.  (It wouldn't be a CS book without the Fibonaccci numbers).
    
http://www.scottlogic.com/blog/2014/06/26/swift-sequences.html
    
.. sourcecode:: bash

    class FibonacciGenerator: GeneratorType {
        var a = 0, b = 1
        typealias Element = Int
        func next() -> Element? {
            let ret = a
            a = b
            b = ret + b
            return ret 
        }
    }

    let fib = FibonacciGenerator()
    for _ in 1..<15 {
        print("\(fib.next()!) ", terminator: "")
    }
    print("")
    
.. sourcecode:: bash    
    
    > swift test.swift
    0 1 1 2 3 5 8 13 21 34 55 89 144 233 
    >
    
As before, we could spiff this up a little bit by adding a class that provides the ``generate`` method, and get it to conform to the SequenceType protocol.

I thought it would be nice to have a class that generates random numbers suitable for encryption (that is, ``UInt8``).  We will use the Foundation function ``SecRandomCopyBytes`` (see :ref:`random`).

.. sourcecode:: bash

    import Foundation

    struct RandGenerator: GeneratorType {
        var buffer: [UInt8] = []
        init() {
            fillBuffer()
        }
        mutating func fillBuffer() {
            buffer = [UInt8](
                count:16, repeatedValue: 0)
            SecRandomCopyBytes(
                kSecRandomDefault, 16, &buffer)
        }
        mutating func next() -> UInt8? {
            if buffer.isEmpty {  fillBuffer() }
            return buffer.removeFirst()
        }
    }

    var r = RandGenerator()
    for _ in 1..<9 { 
        if let n = r.next() {
            print(n, terminator: " ")
        }
    }
    print("")

.. sourcecode:: bash

    > swift test.swift.txt 
    119 15 188 0 228 165 37 
    >

Of course, it needs to be hooked up to an encryption routine that takes a string and a key and returns the encrypted text.

