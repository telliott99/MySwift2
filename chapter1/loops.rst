.. _loops:

#####
Loops
#####

We are going to use some arrays below, even though they haven't been introduced yet.  I hope what we're doing is fairly obvious, if not, see :ref:`array`.

.. sourcecode:: bash

    var intList = [2,4,6]
    for x in intList { print(String(x) + " ", terminator:"")}
    print("")

.. sourcecode:: bash

    > swift test.swift
    2 4 6 
    >

Here we need the explicit conversion to String, because the first thing that is evaluated inside ``print()`` is the addition of ``x`` to the String ``" "``.

We can get a range of values (including 3)

.. sourcecode:: bash

    var i:Int
    for i in 1...3 { print(String(i) + " ", terminator:"") }
    print("")

.. sourcecode:: bash

    > swift test.swift 
    1 2 3 
    >

A while loop:

.. sourcecode:: bash

    while true {
        print("Yes")
        break
    }

.. sourcecode:: bash

    > swift test.swift 
    Yes
    >

And a traditional loop

.. sourcecode:: bash

    var count = 0
    for i = 0; i < 3; ++i {
        count += 1
    }
    print(count)

.. sourcecode:: bash

    > swift test.swift
    3
    >

If you want to access the value of ``i`` after the loop terminates, you must declare it outside the loop as ``var i: Int``.

.. sourcecode:: bash

    var i: Int
    for i = 0; i < 3; ++i {
        ..
    }
    print(i)
    // i == 3  !!!

An odd way to do something ``n`` times.  Notice the``_`` variable (a way of saying we will ignore this value, and it's not available inside the loop)

.. sourcecode:: bash

    let base = 2
    let power = 10
    var result = 1
    for _ in 1...power {
        result *= base
    }
    // result == 1024
    
This is legal!

.. sourcecode:: bash

    var i: Int
    let ifeellikeit = true
    for i = 0; i < 10; i++ {
        print("\(i) ", terminator: "") 
        if ifeellikeit {
            i += 3
        }
    }
    print("")
    \\ prints 0 4 8
