.. _structs:

#######
Structs
#######

Here is a bare-bones Swift struct

.. sourcecode:: swift

    struct P {
        var x, y: Int
    }
    var p = P(x: 10, y: 20)
    print("\(p.x) \(p.y)")
    p.y = 100
    print("\(p.x) \(p.y)")
    
.. sourcecode:: bash

    > swift test.swift
    10 20
    10 100
    >

Our struct simply contains two Int variables.  Swift provides an "initializer" automatically in this case to allow the two variables to obtain defined values before the struct is used.  This one is called a "memberwise initializer", we provide the parameters needed in the same order as they are declared in the class.

Alternatively, if you didn't need to pass in parameters for initialization you could do this:

.. sourcecode:: bash

    struct P {
        var x = 0
        var y = 0
    }
    var p = P()
    print("\(p.x) \(p.y)")

.. sourcecode:: bash

    > swift test.swift
    0 0
    >

---------------------
String Representation
---------------------

One great addition is to print out a nice (programmer-designed) string to describe a struct or class.  ``description`` is a variable (not a method), which must implement ``get``.  

Add something else to ``P``.  It looks like this:

.. sourcecode:: swift

    struct P {
        var x, y: Int
        var description: String {
            get { return "P:  x = \(x), y = \(y)" }
        }
    }

    let p = P(x: 10, y: 20)
    print(p)
    print(p.description)
    
.. sourcecode:: bash

    > swift test.swift 
    P(x: 10, y: 20)
    P:  x = 10, y = 20
    >
    
The first line of output is the default given by Swift, which isn't that bad, really.  And the next line is what we get by calling ``description``.

Wouldn't it be nice if we could just call ``print(st)`` and have it print things exactly how we want?  Or maybe ``print("some text:  \(st)")``.

To do this, we need to declare that this struct conforms to a protocol with a very fancy name (it used to be called ``Printable``).  Substitute:

.. sourcecode:: swift

    struct P: CustomStringConvertible {
        var x, y: Int
        var description: String {
            get { return "P:  x = \(x), y = \(y)" }
        }
    }

    let p = P(x: 10, y: 20)
    print("printing:  \(p)")

Now ``print("\(p)")`` will give:

.. sourcecode:: bash

    > swift test.swift 
    printing:  P:  x = 10, y = 20
    >

----------
Value Type
----------

Structs are passed by value, they are "value types".

.. sourcecode:: swift

    struct P: CustomStringConvertible {
        var x, y: Int
        var description: String {
            get { return "P:  x = \(x), y = \(y)" }
        }
    }
    
    let p = P(x: 10, y: 20)
    var p1 = p
    p1.x = 90
    print("p: \(p)\np1: \(p1)")

.. sourcecode:: bash

    > swift test.swift 
    p: P:  x = 10, y = 20
    p1: P:  x = 90, y = 20
    >

The Struct ``p`` is not affected by alterations made to ``p1`` after the copy is made.  The converse is also true.

Structs are substantially more capable in Swift than in C.  What structs can do:

    - define properties to store values
    - define methods 
    - define subscripts to provide access
    - define initializers to set up their initial state
    - be extended
    - conform to a protocol

That is, structs do nearly everything that historically we have used classes to do.

Classes are still more powerful, though.  Things that classes can do that structs cannot:

    - have more than a single instance
    - inherit from superclasses
    - check type at runtime
    - de-initialize
    - be reference counted

If you are big into inheritance, then classes are for you.

That's a lot, even for structs!  In general, structs should be preferred, unless you plan to subclass.

Let's see what we can do.

.. sourcecode:: swift

    struct X: CustomStringConvertible {
        var x: Int
        init(input: Int = 0) {
            x = input
        }
        var description: String {
            get { return "X:  x = \(x)" }
        }
    }

    let x = X()
    print("\(x)")
    
.. sourcecode:: bash

    > swift test.swift 
    X:  x = 0
    >

Having a default value for ``input`` in the initializer for X means you will not get an error by calling ``X()`` (which you would, lacking ``init`` and the default value it provides for the ``x`` variable).

You might do it differently.  For example:

.. sourcecode:: swift

    struct IKnowWhatThisIs {
        var x: Int
        init(_ input: Int = 20) {
            x = input
        }
    }

    let a = IKnowWhatThisIs(10)
    print("\(a)")

.. sourcecode:: bash

    > swift test.swift 
    IKnowWhatThisIs(x: 10)
    >

Here we named our input parameter to distinguish it from the property, but because it seems really obvious what ``IKnowWhatThisIs`` does we used the ``_`` syntax to make it unnecessary to provide that name when calling the initializer.

A more traditional way of writing a ``Point`` struct:

.. sourcecode:: swift

    struct Point: CustomStringConvertible {
        var x, y: Int
        init(x: Int, y: Int) {
            self.x = x
            self.y = y
        }
        var description: String {
            get { return "Point:  x = \(x), y = \(y)" }
        }
    }

    let p = Point(x: 10, y:20)
    print("\(p)")

.. sourcecode:: bash

    > swift test.swift 
    Point:  x = 10, y = 20
    >

Although this works, it is worth pointing out that the initializer is unnecessary in this case.  Swift will give us a default member-wise initializer for free.  If you remove ``init`` from the above code, it will work exactly the same.

See more in ::ref:`initializers`.

-------------------
getting and setting
-------------------

I confess to being a bit confused (in Objective-C) by properties (with getters and setters) and instance variables like ``self.x``.  In Swift, there is no difference.  Above, we defined ``var x: Int`` and set its value in the initializer.  ``x`` is a property.

On the other hand, properties can be more sophisticated.  We could provide a "getter" and "setter" for ``myvar``.

.. sourcecode:: swift

    var myvar {
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

.. sourcecode:: swift

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
    st.changeX(20)
    print(st)
    
.. sourcecode:: bash

    > swift test.swift 
    test.swift:12:1: error: cannot use mutating member on immutable value: 'st' is a 'let' constant
    st.changeX(20)
    ^~
    test.swift:11:1: note: change 'let' to 'var' to make it mutable
    let st = MyStruct(10)
    ^~~
    var
    >

Oops.  Make that change:

.. sourcecode:: swift

    var st = MyStruct(10)
    
.. sourcecode:: bash

    > swift test.swift 
    MyStruct(x: 20)
    >
    
-----------
Use of self
-----------

    Every instance of a type has an implicit property called self, which is exactly equivalent to the instance itself. You use the self property to refer to the current instance within its own instance methods.

    In practice, you don’t need to write self in your code very often. If you don’t explicitly write self, Swift assumes that you are referring to a property or method of the current instance whenever you use a known property or method name within a method.
    
When this is not enough:

.. sourcecode:: swift

    struct X {
        var x: Int = 0
        func isLessThan(x: Int) -> Bool {
            return self.x < x
        }
    }

    var x = X(x: 10)
    x
    x.isLessThan(12)  // prints:  true

Here the function ``isLessThan`` has a parameter that is (for better or worse) named ``x``, just like the variable.  Inside the function, the parameter name takes precedence, so that is what ``x`` refers to.  Then, ``self.x`` is used to refer to the instance variable.

-----------------
Assigning to self 
-----------------

Assigning to self within a Mutating Method

Mutating methods can assign an entirely new instance to the implicit self property.

.. sourcecode:: swift

    struct Point {
        var x = 0.0, y = 0.0
        mutating func moveByX(deltaX: Double, y deltaY: Double) {
            self = Point(x: x + deltaX, y: y + deltaY)
        }
    }
    
This version of the mutating ``moveByX(_:y:)`` method creates a brand new structure whose x and y values are set to the target location.

Mutating methods for enumerations can set the implicit self parameter to be a different case from the same enumeration.  Here is a cool example from the docs:

.. sourcecode:: swift

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
    print(ovenLight)

    ovenLight.next()
    print(ovenLight)
    // ovenLight is now equal to .High

    ovenLight.next()
    print(ovenLight)
    // ovenLight is now equal to .Off

.. sourcecode:: bash

    > swift test.swift 
    Low
    High
    Off
    >
    
More docs:

    This example defines an enumeration for a three-state switch. The switch cycles between three different power states (Off, Low and High) every time its ``next()`` method is called.

We will come back to talk about subscripts, extensions and protocols for structs later.