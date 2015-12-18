.. _structs:

#######
Structs
#######

Here is a Swift Struct

.. sourcecode:: bash

    struct Point { var x = 0, y = 1 }
    var p = Point()
    p.y = 100
    println("\(p.x) \(p.y)")

.. sourcecode:: bash

    > xcrun swift test.swift
    0 100
    >

Structs are passed by value.

.. sourcecode:: bash

    struct Point { var x = 0, y = 1 }
    var p = Point()
    p.y = 100
    println("\(p.x) \(p.y)")

    var q = p
    q.x = 90
    println("\(p.x) \(p.y)")
    println("\(q.x) \(q.y)")

.. sourcecode:: bash

    > xcrun swift test.swift
    0 100
    0 100
    90 100
    >

The Struct ``p`` is not affected by what happens to ``q`` after the copy is made.

Structs are substantially more complex in Swift than in C.  What structs can do:

    - define properties to store values
    - define methods 
    - define subscripts to provide access
    - define initializers to set up their initial state
    - be extended
    - conform to a protocol

Classes are still more powerful, though.  Things that classes can do that structs cannot:

    - have more than a single instance
    - inherit from superclasses
    - check type at runtime
    - de-initialize
    - be reference counted

That's a lot, even for structs!  Let's see what we can demonstrate.

A property (a "stored property")

    is a constant or variable that is stored as part of an instance of a particular class or structure. Stored properties can be either variable stored properties (introduced by the var keyword) or constant stored properties (introduced by the let keyword).

We saw properties in the first example.  On the other hand, properties can be more sophisticated.  A property may be "only calculated when it is needed".

A method (just like in a class)

.. sourcecode:: bash

    struct S {
        var n: Int
        var description: String {
            get {
                return "\(n)"
            }
        }
    }

An initializer is exactly as you would expect, if you imagined making a struct more like a class:

.. sourcecode:: bash

    struct Fahrenheit {
        var temperature: Double
        init() {
            temperature = 32.0
        }
    }

Not complicated.  Let's leave subscripts, extension and protocols for later.

It is possible to print out a nice (programmer-designed) string to describe a struct or class.  ``description`` is a variable (not a method), which must implement ``get``.  It looks like this:

.. sourcecode:: bash

    var description: String {
        get {
            return "my string with some variable:  \(v)"
        }
    }

This wasn't working for me, but I discovered that my standard compilation method fails in some cases where other approaches (such as Playgrounds) work.  To make this work compile it as follows:

.. sourcecode:: bash

    xcrun -sdk macosx swiftc codefile.swift

One more thing about structs.

    By default, the properties of a value type cannot be modified from within its instance methods.  
    
    In the following code, in ``mutating func changeIt``, the ``mutating`` is required, it declares to the compiler we are going to not do the default thing and allow this function to change properties of the struct.

.. sourcecode:: bash

    struct S {
        var x = 42
        mutating func changeIt() {
            x = 43
        }
    }

    var s = S()
    println(s.x)
    s.changeIt()
    println(s.x)
    if (s.x == 43) { println("OK") }

Here it is in an Xcode "playground"

.. image:: /figures/struct_pg.png
    :scale: 75 %