.. _generators:

##########
Generators
##########

The Sequence protocol uses a generator:

.. sourcecode:: bash

    let seq = Range(start:1,end:5)
    var g: RangeGenerator<Int> = seq.generate()
    while let i = g.next() {
      print("\(i) ")
    }

.. sourcecode:: bash

    > swift test.swift
    1 
    2 
    3 
    4 
    >

We don't need the type for ``g`` but I put it there just to document what it actually is.

Let's try to make a generator of our own.
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
    
We can spiff this up a little bit by adding a class that provides the ``generate`` method:

.. sourcecode:: bash

    class Fibonacci {
        typealias GeneratorType = FibonacciGenerator
        func generate() -> FibonacciGenerator {
            return FibonacciGenerator()
        }
    }
    
I'm not quite certain why the ``typealias`` is needed, but it is.  To run this we just substitute:

.. sourcecode:: bash

    let fib = Fibonacci().generate()

which gives the same output.

I thought it might be nice to have a class that generates random numbers suitable for encryption (that is, ``UInt8``).  What follows is not quite it, and I'll explain why afterward.  The motivation for this is the encryption demo shown in :ref:`random`.

.. sourcecode:: bash

    import Darwin

    class RandomGenerator: GeneratorType {
        var a = [UInt8]()
        var s: UInt32
        init(seed: Int) {
            s = UInt32(seed)
            srand(s)
        }
        func next() -> UInt8? {
            if a.isEmpty { 
                a = filledArray()
            }
            return a.removeLast()
        }
        func filledArray() -> [UInt8] {
            var a = [UInt8]()
            let r: UInt32 = UInt32(UInt(rand()))
            let b1 = (r & 0xFF0000FF) >> 24
            a.append(UInt8(b1))
            let b2 = (r & 0x00FF0000) >> 16
            a.append(UInt8(b2))
            let b3 = (r & 0x0000FF00) >> 8
            a.append(UInt8(b3))
            let b4 = r & 0x000000FF
            a.append(UInt8(b4))
            return a
        }
    }

    func test() {
        let rg = RandomGenerator(seed: 137)
        for _ in 1..<10 {
            print("\(rg.next()!) ")
        }
        println()
    }

    test()


.. sourcecode:: bash

    > xcrun swift test1.swift
    95 34 35 0 11 139 165 2 136 
    > xcrun swift test1.swift
    95 34 35 0 11 139 165 2 136 
    >

Two reasons why it's not suitable:  according to StackOverflow, ``rand`` should not be used for encryption because the low value bytes show cycles (they're not random).  Second, ``rand`` gives us an ``Int`` (a signed integer), which means it's missing the top half of its range, so if you repeat the stream for long enough you should see that the 4th 8th 12th and so on numbers are never > 127.

And then of course, it needs to be hooked up to an encryption routine that takes a string and a key and returns the encrypted text.

