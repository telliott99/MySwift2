.. _sequence_type:

########################
Generators and Sequences
########################

We introduced protocols in a general way previously (:ref:`protocols`).  

Let's extend that discussion by looking at the GeneratorType protocol.

First, and fundamentally, there is some object that provides a method ``next``, where each successive call to ``next`` provides the *next* element of whatever type it is that the object provides.

We will accomplish this with a struct rather than a class, just to show that we can, and because classes are really intended for a situation where we intend to subclass our generator, which we aren't going to do.

Since any function that changes state within the struct needs to be specially marked, the ``next`` function needs to have the label ``mutating``.  Also, ``i`` has to be a variable rather than a constant.  (Neither would be true if we had used a class).

.. sourcecode:: bash

    struct IntGenerator {
        var i = 0
        mutating func next() -> Int {
            i += 1
            return i
        }
    }

    var g = IntGenerator()
    for _ in 1..<11 { 
        print(g.next(), terminator: " ")
    }
    print("")
    
.. sourcecode:: bash

    > swift test.swift.txt 
    1 2 3 4 5 6 7 8 9 10 
    >

If we now try to say that our struct conforms to the ``GeneratorType`` protocol:

.. sourcecode:: bash

    struct IntGenerator: GeneratorType
    
we'll get some errors that lead us to make a few additional changes

.. sourcecode:: bash

    struct IntGenerator: GeneratorType {
        typealias Element = Int
        var i = 0
        mutating func next() -> Element? {
            i += 1
            return i
        }
    }

    var g = IntGenerator()
    for _ in 1..<11 { 
        if let n = g.next() {
            print(n, terminator: " ")
        }
    }
    print("")

What have we done?  Fundamentally, the protocol requires a method ``next`` with this signature:

.. sourcecode:: bash

    mutating func next() -> Element?

and having the return type of ``Element`` requires a "nested" typealias in the struct definition that says ``typealias Element = `` whatever type we are returning.

http://swiftdoc.org/v2.0/protocol/GeneratorType/

This code compiles and gives the same output as before.

.. sourcecode:: bash

    > swift test.swift.txt 
    1 2 3 4 5 6 7 8 9 10 
    >

``Element?`` is of type Optional Int, and that is also required---its presence suggests the idea that the sequence may have a finite number of values.  So let's modify ``next`` to return ``nil`` when the sequence reaches a maximum value of 5:

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

    var g = IntGenerator()
    for _ in 1..<11 { 
        if let n = g.next() {
            print(n, terminator: " ")
        }
    }
    print("")

.. sourcecode:: bash

    > swift test.swift.txt 
    1 2 3 4 5 
    >

Now, finally we will try to use the ``for .. in`` construct, by substituting this for the bottom part of the code above:

.. sourcecode:: bash

    var g = IntGenerator()
    for n in g { 
        print(n)
        }
    print("")

The compiler complains that "value of type 'IntGenerator' has no member 'Generator'".  

I am not quite sure of all the subtleties here, but I googled a bit and the problem can be solved by adding another struct.  We don't change what is already there, except to instantiate the second struct rather than the first in the ``for .. in`` part.

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

    struct IntGeneratorFactory: SequenceType {
        typealias Generator = IntGenerator
        func generate() -> Generator {
            return IntGenerator()
        }
    }

    var g = IntGeneratorFactory()
    for n in g { 
        print(n, terminator: " ")
        }
    print("")

Our additional struct has one method:  ``generate``.  And all that method does is to instantiate and return an ``IntGenerator``.  Swift is looking for a particular function signature for ``generate``.  So as with ``Element``, the type it's looking for is ``Generator`` which must be typealiased to ``IntGenerator``.  And with that change, the compiler allows us to claim that the struct ```IntGeneratorFactory`` conforms to the ``SequenceType`` protocol.

Now we can do ``for n in g`` and it works.

.. sourcecode:: bash

    > swift test.swift.txt 
    1 2 3 4 5 
    >

Here is another similar struct that produces the Fibonacci numbers.  (It wouldn't be a CS book without the Fibonaccci numbers).
    
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
    
If need be, we could spiff this up by adding a class that provides the ``generate`` method, and get it to conform to the SequenceType protocol in exactly the same way as before.

I thought it would be nice to have a class that generates random numbers suitable for encryption (that is, ``UInt8``).  We will adapt the Foundation function ``SecRandomCopyBytes`` to this purpose (see :ref:`random`).

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
            if buffer.isEmpty {  
                fillBuffer() 
            }
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

There is much, much more to this topic including CollectionType and SliceType and ...

If you are interested, I suggest you start with:

http://nshipster.com/swift-collection-protocols/
