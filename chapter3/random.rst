.. _random:

######
Random
######

I came across an important function that is in Foundation and is really convenient for generating random data:  ``SecRandomCopyBytes``.

.. sourcecode:: swift

    import Foundation

    func randomBinaryData(n: Int = 1) -> [UInt8] {
        var buffer = [UInt8](
            count:n, repeatedValue: 0)
        SecRandomCopyBytes(
            kSecRandomDefault, n, &buffer)
        return buffer
    }

    print(randomBinaryData())
    print(randomBinaryData(8))
    
.. sourcecode:: bash

    > swift test.swift 
    [143]
    [14, 130, 173, 216, 2, 135, 12, 176]
    > 
    
What is going on here is that Swift is giving us access to a C function in Foundation called ``SecRandomCopyBytes``, which takes a pointer to a buffer and fills that buffer with the requested number of random bytes.  Swift will accept a reference (``&buffer``) to an array of UInt8 as that value.  We need to supply the length of the buffer, of course.  

(It's interesting that it doesn't crash if we deliberately give ``SecRandomCopyBytes`` a bad value for ``n``).

Swift itself doesn't have a built-in facility for getting random numbers, that I know of.

However, there are some other Unix functions available (after ``import Foundation``).  

These are 

    - ``arc4random``
    - ``arc4random_uniform``
    - ``rand``
    - ``random``.

Only ``rand`` and ``random`` allow you to set the seed (with ``srand`` or ``srandom`` respectively).  These are usually called with the time, as in ``srand(time(NULL))``.

http://iphonedevelopment.blogspot.com/2008/10/random-thoughts-rand-vs-arc4random.html

For *really* random numbers, it seems that ``arc4random`` is preferred, but it can't be seeded by the caller.

.. sourcecode:: swift

    import Foundation

    var a = Array<Int>()
    for i in 1...100000 {
        a.append(Int(arc4random()))
    }

    var m = 0
    for value in a {
        if value > m { m = value }
    }
    print(m)
    // 4294948471

The error message when you try to put the result of ``arc4random`` directly into an ``[Int]`` says that it is a ``UInt32``, an unsigned integer of 32 bits.

The maximum value ``UInt32.max`` is ``4294967295``.  From the Unix man page 

    The arc4random() function returns pseudo-random numbers in the range of 0 to (2**32)-1, and therefore has twice the range of rand(3) and random(3).

We use a bit of trickery to obtain the familiar Python syntax:

.. sourcecode:: swift

    import Foundation

    infix operator **{}
    func ** (n: Double, p: Double) -> Double {
        return pow(n,p)
    }

    print("\(2**32)")

The definition must be at global scope.  (For more about this see  :ref:`operators`).  We compute

.. sourcecode:: bash

    > swift test.swift 
    4294967296.0
    >

which sounds about right.  (The ``pow`` function takes a pair of ``Double`` values, and returns one as well).

We could certainly work with the result from ``arc4random``.  To obtain a random integer in a particular range, we first need to divide by the maximum value

.. sourcecode:: swift

    import Foundation

    var f = Double(arc4random())/Double(UInt32.max)
    print("\(f)")
    var str = NSString(format: "%7.5f", f)
    print(str)

.. sourcecode:: bash

    > swift test.swift
    0.333160816070894
    0.33316
    >

then do

.. sourcecode:: swift

    import Foundation

    func randomIntInRange(begin: Int, _ end: Int) -> Int {
        var f = Double(arc4random())/Double(UInt32.max)
        // we must convert to allow the * operation
        let r = Double(end - begin)
        let result: Int = Int(f*r)
        return result + begin
    }


    for i in 1...100 {
        print(randomIntInRange(0,2)) 
    }
    
which gives the expected result (only ``0`` and ``1``).

However, rather than doing that, do this:

.. sourcecode:: swift

    import Foundation
    
    for i in 1...10 {
        print(arc4random_uniform(2)) 
    }

The function ``arc4random_uniform(N)`` gives a result in ``0...N-1``, that is, in ``[0,N)``.

If you want to seed the generator, use ``rand`` or ``random``.  The first one generates a ``UInt32``.  The second generates an ``Int32``, although it never emits values less than zero.

.. sourcecode:: swift

    import Foundation

    import Foundation
    var a = Array<Int>()
    for i in 1...100000 {
        a.append(random())
    }

    var m = 0
    for value in a {
        if value > m { m = value }
    }

    print("\(m)") 

.. sourcecode:: bash

    > xcrun swift test.swift
    2147469841
    >

which appears to be in the range 0 to

.. sourcecode:: swift

    pow(Double(2),Double(31)) - 1

as we would expect for a signed Int32.  ``random`` can be seeded:

.. sourcecode:: swift

    import Foundation

    func getSeries(seed: Int) -> [Int] {
        srandom(137)
        var a = Array<Int>()
        for _ in 1...5 {
            a.append(random())
        }
        return a
    }

    func doOne(seed: Int) {
        let a = getSeries(seed)
        for v in a { print("\(v) ")}
        print("")
    }

    for i in 1...2 { doOne(137) }

.. sourcecode:: bash

    > swift test.swift 
    171676246 
    1227563367 
    950914861 
    1789575326 
    941409949 

    171676246 
    1227563367 
    950914861 
    1789575326 
    941409949 
    
    >

Notice that the two runs generate exactly the same sequence of values.