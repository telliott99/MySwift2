.. _numbers:

#######
Numbers
#######

Numbers are at the heart of things in computing, of course.  We have binary numbers, hexadecimal numbers and decimal numbers.  We have integers and floating point numbers.  Longs and shorts, doubles and floats.

--------
Integers
--------

Start with integers.  Integers come in sizes:  8, 16, 32 and 64 (which is the default now).  The sizes show the length of the representation in bits.  

Integers may also be signed or unsigned.  One reason these are different is fundamentally that the sign bit takes up space.

Look at 8 bit integers.  ``UInt8`` can represent [0,255], while ``Int8`` can represent [-128, 127].  In both cases there are 2e8 or 256 total possible values.

.. sourcecode:: bash

    print("\(UInt8.min) \(UInt8.max)")
    print("\(Int8.min) \(Int8.max)")

.. sourcecode:: bash

    > swift test.swift
    0 255
    -128 127
    >

Thus, a single binary number ``10000001`` can represent different things depending on how it is interpreted.  As a ``UInt8``, it is equal to 129 = 2**7 + 1.  As an ``Int8``, the left-hand ``1`` is the "sign bit", signifying minus, so it is equal to -127.

Are you surprised by that last part?  Why not -1?  

The reason is two's complement:

https://en.wikipedia.org/wiki/Two%27s_complement

We want n + (-n) = 0.

So if n = 1:

.. sourcecode:: bash

    n = 0000 0001

then -n = 

.. sourcecode:: bash

    -n = 1111 1111

when we add the two numbers together we get 1 0000 0000 and the 1 is lost by overflow.

.. sourcecode:: bash

    127  = 0111 1111
    -127 = 1000 0001

Added together, we get 0.

It's a little strange.  We can see this more directly:

.. sourcecode:: bash

    let a: [UInt8] = [255]
    let p = UnsafePointer<UInt8>(a)
    print(p.memory)

    let p2 = UnsafePointer<Int8>(p)
    print(p2.memory)

.. sourcecode:: bash

    > swift test.swift
    255
    -1
    >

But that is really getting ahead of ourselves, I think.

Floating point numbers (like 1.2 to 3.0 x 10e23---the number of stars in the visible universe) have two parts:  a *mantissa* and an *exponent*.  The details of how they are represented on disk and in memory is not important right now, but what is important is that they have sizes and a Type for each size.  These are Float (32 bits) and Double (64 bits).

One very common type for data in C is ``char``.  An ``unsigned char`` corresponds to Swift's ``UInt8``.
    