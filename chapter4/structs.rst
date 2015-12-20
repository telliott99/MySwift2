.. _structs:

#######
Structs
#######

Here is a Swift Struct

.. sourcecode:: bash

    struct Point { 
        var x = 0, y = 1 
    }
    var p = Point()
    p.y = 100
    print("\(p.x) \(p.y)")
    
.. sourcecode:: bash

    > swift test.swift
    0 100
    >

Structs are passed by value.

.. sourcecode:: bash

    struct Point { var x = 0, y = 1 }
    var p = Point()
    p.y = 100
    print("p: \(p.x) \(p.y)")

    var q = p
    q.x = 90
    print("p: \(p.x) \(p.y)")
    print("q: \(q.x) \(q.y)")

.. sourcecode:: bash

    > swift test.swift
    p: 0 100
    p: 0 100
    q: 90 100
    >

The Struct ``p`` is not affected by alterations made to ``q`` after the copy is made.  And the converse is also true.

Structs are substantially more capable, or complex, in Swift than in C.  What structs can do:

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

.. sourcecode:: bash

    struct MyStruct {
        var x: Int
    }

    let st = MyStruct(x: 10)
    print(st)

.. sourcecode:: bash

    > swift test.swift
    MyStruct(x: 10)
    >

If you should call MyStruct(), you will get an error saying the ``x`` needs to be initialized.

A property (a "stored property")

    is a constant or variable that is stored as part of an instance of a particular class or structure. Stored properties can be either variable stored properties (introduced by the var keyword) or constant stored properties (introduced by the let keyword).

We saw properties in the first example.  On the other hand, properties can be more sophisticated.  A property may be "only calculated when it is needed".

Not complicated.  Let's leave subscripts, extension and protocols for later.

Except: it is possible to print out a nice (programmer-designed) string to describe a struct or class.  ``description`` is a variable (not a method), which must implement ``get``.  Let's add something else to ``MyStruct``

It looks like this:

.. sourcecode:: bash

    struct MyStruct {
        var x: Int
        var description: String {
            get {
                return "MyStruct:  x = \(x)"
            }
        }
    }

    let st = MyStruct(x: 10)
    print(st)
    print(st.description)
    
.. sourcecode:: bash

    > swift test.swift
    MyStruct(x: 10)
    MyStruct:  x = 10
    >
    
Wouldn't it be nice if we could call ``print(st)`` and have it print things exactly how we want?

To do this, we need to implement ``description`` as above, and declare that the struct conforms to a protocol with a very fancy name.  Substitute what follows for the first line (and delete the last line):

.. sourcecode:: bash

    struct MyStruct: CustomStringConvertible {

Now ``print(st)`` will give:

.. sourcecode:: bash

    > swift test.swift
    MyStruct:  x = 10
    >
    
One more thing about structs.

    By default, the properties of a value type (and a struct *is* a value type), cannot be modified from within its instance methods.  
    
    In the following code, in ``mutating func changeIt``, the ``mutating`` is required, it declares to the compiler we are going to allow this function to change properties of the struct.

.. sourcecode:: bash

    struct S {
        var x = 42
        mutating func changeIt() {
            x = 43
        }
    }

    var s = S()
    print(s.x)
    s.changeIt()
    print(s.x)
    if (s.x == 43) { print("OK") }

.. sourcecode:: bash

    > swift test.swift
    42
    43
    OK
    >
