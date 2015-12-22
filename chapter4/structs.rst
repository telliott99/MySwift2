.. _structs:

#######
Structs
#######

Here is a bare-bones Swift struct

.. sourcecode:: bash

    struct Point {
        var x, y: Int
    }
    var p = Point(x: 10, y: 20)
    print("\(p.x) \(p.y)")
    p.y = 100
    print("\(p.x) \(p.y)")
    
.. sourcecode:: bash

    > swift test.swift
    10 20
    10 100
    >

Structs are passed by value.

.. sourcecode:: bash

    struct Point {
        var x, y: Int
    }
    var p = Point(x: 10, y: 20)
    print("\(p.x) \(p.y)")

    var q = p
    q.x = 90
    print("p: \(p.x) \(p.y)")
    print("q: \(q.x) \(q.y)")

.. sourcecode:: bash

    > swift test.swift
    p: 10 20
    p: 10 20
    q: 90 100
    >

The Struct ``p`` is not affected by alterations made to ``q`` after the copy is made.  The converse is also true.

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

That's a lot, even for structs!      In general, structs should be preferred, unless you plan to subclass.

Let's see what we can demonstrate.

.. sourcecode:: bash

    struct MyStruct {
        var x: Int
        init(x: Int = 20)
    }

    let st = MyStruct()
    print(st)

.. sourcecode:: bash

    > swift test.swift
    MyStruct(x: 20)
    >

Having a default value for ``x`` in the initializer for MyStruct means you will not get an error by calling ``MyStruct()`` (which you would lacking ``init`` and the default value it provides for ``x``).

You might do it differently.  For example:

.. sourcecode:: bash

    struct MyStruct {
        var x: Int
        init(_ input: Int = 20) {
            x = input
        }
    }

    let st = MyStruct(10)

Here we named our input parameter to distinguish it from the property, but because it seems really obvious what ``MyStruct`` does we used the ``_`` syntax to make it unnecessary to provide that name when calling the initializer.

I've always been a bit confused by properties (with getters and setters) and instance variables like ``self.x`` in Objective-C.  In Swift, there is no difference.  Above, we defined ``var x: Int`` and set its value in the initializer.  ``x`` is a property.

On the other hand, properties can be more sophisticated.  We could provide a "getter" and "setter" for ``x``.

.. sourcecode:: bash

    var x {
        get { /* implementation */ }
        set { /* implementation */ }
    }

or, for read-only, just a getter.  A property may be "only calculated when it is needed".

A property (a "stored property")

    is a constant or variable that is stored as part of an instance of a particular class or structure. Stored properties can be either variable stored properties (introduced by the var keyword) or constant stored properties (introduced by the let keyword).
    
--------
mutating
--------

A method which changes the state of a struct (even a variable struct) must be marked ``mutating``:

.. sourcecode:: bash

    struct MyStruct {
        var x: Int
        init(_ input: Int = 20) {
            x = input
        }
        mutating func changeX(input: Int) {
            x = input
        }
    }

    let st = MyStruct(10)

----
self
----

Use of self.

    Every instance of a type has an implicit property called self, which is exactly equivalent to the instance itself. You use the self property to refer to the current instance within its own instance methods.

    In practice, you don’t need to write self in your code very often. If you don’t explicitly write self, Swift assumes that you are referring to a property or method of the current instance whenever you use a known property or method name within a method.
    
When this is not enough:

.. sourcecode:: bash

    struct X {
        var x: Int = 0
        func isLessThan(x: Int) -> Bool {
            return self.x < x
        }
    }

    var x = X(x: 10)
    x
    x.isLessThan(12)  // prints:  true

Here the function ``isLessThan`` has a parameter that is (for better or worse) named ``x``, just like the variable.  Inside the function, the parameter name takes precedence, and that is what ``x`` refers to.  ``self.x`` is used here to refer to the instance variable.

-----------------
Assigning to self 
-----------------

Assigning to self within a Mutating Method

Mutating methods can assign an entirely new instance to the implicit self property. The Point example shown above could have been written in the following way instead:

.. sourcecode:: bash

    struct Point {
        var x = 0.0, y = 0.0
        mutating func moveByX(deltaX: Double, y deltaY: Double) {
            self = Point(x: x + deltaX, y: y + deltaY)
        }
    }
    
This version of the mutating ``moveByX(_:y:)`` method creates a brand new structure whose x and y values are set to the target location.

Mutating methods for enumerations can set the implicit self parameter to be a different case from the same enumeration:

.. sourcecode:: bash

    enum TriStateSwitch {
        case Off, Low, High
        mutating func next() {
            switch self {
            case Off:
                self = Low
            case Low:
                self = High
            case High:
                self = Off
            }
        }
    }
        
    var ovenLight = TriStateSwitch.Low
    ovenLight.next()
    // ovenLight is now equal to .High
    ovenLight.next()
    // ovenLight is now equal to .Off
    
More docs:

    This example defines an enumeration for a three-state switch. The switch cycles between three different power states (Off, Low and High) every time its ``next()`` method is called.

-----
Other
-----

Let's leave subscripts, extensions and protocols for later.

Except: it is possible to print out a nice (programmer-designed) string to describe a struct or class.  ``description`` is a variable (not a method), which must implement ``get``.  

Add something else to ``MyStruct``.  It looks like this:

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
