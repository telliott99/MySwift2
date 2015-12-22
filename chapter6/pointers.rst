.. _pointers:

#################
Pointers in Swift
#################

We saw some good examples of Swift pointers, used to work with a C library in _____.  I just discovered ``UnsafeBufferPointer`` (and its mutable cousin), which initialize with a count.  These guys allow use of the ``for .. in`` construct.


.. sourcecode:: bash

    var buffer: [UInt8] = [1,33,126,255]
    let p = UnsafeBufferPointer(start: buffer, count: 4)
    for n in p { print(n) }
    print("------")

    var p2 = UnsafeMutablePointer<UInt8>(buffer)
    print(p2.memory)
    p2++
    print(p2.memory)
    let p3 = p2 + 2
    print(p3[0])
    print("------")

    p2[0] = UInt8(55)
    for n in p { print(n) }

.. sourcecode:: bash

    > swift test.swift 
    1
    33
    126
    255
    ------
    1
    33
    255
    ------
    1
    55
    126
    255
    >

These pointers can do pointer arithmetic, and we can write to the buffer using them.

