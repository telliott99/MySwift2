.. _random:

######
Random
######

[UPDATE:  I came across a really important function that is in Foundation and is really convenient for generating random data.

.. sourcecode:: bash

    import Foundation

    func randomBinaryData(n: Int = 1) -> [UInt8] {
        var buffer = [UInt8](
            count:n, repeatedValue: 0)
        SecRandomCopyBytes(
            kSecRandomDefault, n, &buffer)
        return buffer
    }

    print(randomBinaryData(6))
    print(randomBinaryData(6))
    print(randomBinaryData(6))
    
.. sourcecode:: bash

    > swift test.swift 
    [215, 97, 73, 135, 187, 18]
    [64, 186, 241, 149, 113, 227]
    [45, 206, 43, 4, 70, 146]
    >
    
We need to wait a while to explain this, but it's really convenient. ] 

Swift itself doesn't seem to have a built-in facility for getting random numbers.

However, there are some Unix functions available, after an ``import Foundation``.  These are ``arc4random``, ``arc4random_uniform``, ``rand``, and ``random``.

Only ``rand`` and ``random`` allow you to set the seed (with ``srand`` or ``srandom`` respectively).  These are usually called with the time, as in ``srand(time(NULL))``.

http://iphonedevelopment.blogspot.com/2008/10/random-thoughts-rand-vs-arc4random.html

For *really* random numbers, it seems that ``arc4random`` is preferred, but it can't be seeded by the caller.

.. sourcecode:: bash

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

.. sourcecode:: bash

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

.. sourcecode:: bash

    import Foundation

    var f = Double(arc4random())/Double(UInt32.max)
    print("\(f)")
    var str = NSString(format: "%7.5f", f)
    print(str)

.. sourcecode:: bash

    > xcrun swift test.swift
    0.333160816070894
    0.33316
    >

then do

.. sourcecode:: bash

    import Foundation

    import Foundation

    func randomIntInRange(begin: Int, _ end: Int) -> Int {
        var f = Double(arc4random())/Double(UInt32.max)
        // we must convert to allow the * operation
        let range = Double(end - begin)
        let result: Int = Int(f*range)
        return result + begin
    }


    for i in 1...100 {
        print(randomIntInRange(0,2)) 
    }
    
which gives the expected result (only ``0`` and ``1``).

However, rather than doing that, do this:

.. sourcecode:: bash

    import Foundation
    
    for i in 1...10 {
        print(arc4random_uniform(2)) 
    }

The function ``arc4random_uniform(N)`` gives a result in ``0...N-1``, that is ``[0,N)``.

If you want to seed the generator, use ``rand`` or ``random``.  The first one generates a ``UInt32``.  The second generates an ``Int32``, although it never emits values less than zero.

.. sourcecode:: bash

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

.. sourcecode:: bash

    pow(Double(2),Double(31)) - 1

as we would expect for a signed Int32.  ``random`` can be seeded:

.. sourcecode:: bash

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

-------
Shuffle
-------

If you want to "shuffle", rearrange the items in an array randomly, one correct algorithm is to move through the array with an index and exchange the value at current position with a random value *from the current position* through the end of the array (i.e. not from the beginning).

First, we need a function that produces a random Int in any range.  We choose to use a half-open range, which does not include the end value.

.. sourcecode:: bash

    import Foundation

    // we do not include end in the values
    
    func randomIntInHalfOpenRange(begin begin: Int, end: Int) -> Int {
        let r = end - begin
        let value = Int(arc4random_uniform(UInt32(r)))
        return begin + value
    }

    func test() {
        for _ in 0..<50 { 
            let n = randomIntInHalfOpenRange(begin: 0, end: 10)
            print(n)
        }
    }

    test()
    
It works.  In particular, we see both ``0`` and ``9`` in the output.
    
Now implement the algorithm described above.

.. sourcecode:: bash

    func swap(inout a: [Int], _ i: Int, _ j: Int) {
        let tmp = a[i]
        a[i] = a[j]
        a[j] = tmp
    }

    func shuffleIntArray(inout a: [Int]) {
        let n = a.count
        for i in 0..<n-1 {
            let j = randomIntInHalfOpenRange(begin: i, end: n)
            if i == j { continue }
            swap(&a,i,j)
        }
    }

    var a: [Int] = [1,2,3,4,5,6,7]
    shuffleIntArray(&a)
    print("\(a)")

.. sourcecode:: bash

    > swift test.swift 
    [7, 5, 6, 3, 4, 1, 2]
    > swift test.swift 
    [5, 3, 2, 7, 1, 6, 4]
    >

For this code to work, we must mark the array parameter as ``inout`` and then pass a reference to the array ``&a`` into both the original function ``shuffleIntArray`` and also the one that actually changes the array, ``swap``.
