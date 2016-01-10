.. _generics:

########
Generics
########

Swift is all about type safety, but provides the tools to do unsafe things when you really want to.  For example, as we saw in :ref:`array`, one can write a function that modifies an array in place, or indeed any type.

We convert call-by-value into call-by-reference.  The parameters are marked with the label ``inout`` and there is no return value.  Notice the use of ``&x`` and ``&y``, with a meaning at least analogous to that in C and C++.

.. sourcecode:: swift

    func swapInts(inout a: Int, inout _ b: Int) {
        let tmp = a
        a = b
        b = tmp
    }
    var x: Int = 1
    var y: Int = 2
    print("x = \(x)  y = \(y)")
    swapInts(&x,&y)
    print("x = \(x)  y = \(y)")
    
.. sourcecode:: bash
    
    > swift test.swift 
    x = 1  y = 2
    x = 2  y = 1
    >

We can replace the above by a generic version.  A generic function will work with any type T.

.. sourcecode:: swift

    func swapTwo<T>(inout a: T, inout _ b: T) {
        let tmp = a
        a = b
        b = tmp
    }
    var x: Int = 1
    var y: Int = 2
    print("x = \(x)  y = \(y)")
    swapTwo(&x,&y)
    print("x = \(x)  y = \(y)")

.. sourcecode:: bash

    > swift test.swift
    x = 1, y = 2
    x = 2, y = 1
    >

For example, the above will work with an Array<String>.

.. sourcecode:: swift

    func swapTwo <T> (a: T, _ b: T) -> (T,T) {
        return (b, a)
    }

    var a = ["x"], b = ["y"]
    print("a = \(a), b = \(b)")

    (a,b) = swapTwo(a,b)
    print("a = \(a), b = \(b)")

.. sourcecode:: bash

    > swift test.swift 
    a = ["x"], b = ["y"]
    a = ["y"], b = ["x"]
    >

An alternative approach would be to just use multiple return values in a tuple:

.. sourcecode:: swift

    func swapTwo <T> (a: T, _ b: T) -> (T,T) {
        return (b, a)
    }

    var x = 1, y = 2
    print("x = \(x), y = \(y)")

    (x,y) = swapTwo(x,y)
    print("x = \(x), y = \(y)")

We declare the return type as `(T,T)`.

.. sourcecode:: bash

    >  swift test.swift
    x = 1, y = 2
    x = 2, y = 1
    >

You might have wondered about the function's name (swapTwo).  The reason for this is that ``swap`` actually exists in the standard library as a generic:

.. sourcecode:: swift

    var m = 1
    var n = 2
    swap(&m,&n)
    print("m = \(m) n = \(n)")  // m = 2 n = 1

That's a lot of ink to describe something that could just be done with a tuple (or a variable that I would name ``tmp``).

.. sourcecode:: swift

    var x = 1, y = 2
    (x,y) = (y,x)
    print("x = \(x), y = \(y)")  // x = 2, y = 1
    
The real point is that you can pass a reference to a variable into a function that will modify it, using the ``&`` operator, as long as the function parameter is marked ``inout``.

--------
Optional
--------

Here is reimplementation of the Optional enum type:

.. sourcecode:: swift

    enum OptionalValue<T> {
        case None
        case Some(T)
    }
    
    var maybeInt: OptionalValue<Int> = .None
    maybeInt = .Some(100)

-----
Stack
-----

Here is an implementation (from the docs, mostly) of a stack:

.. sourcecode:: swift

    struct StringStack {
        var items = [String]()
        mutating func push(item: String) {
            items.append(item)
        }
        mutating func pop() -> String {
            return items.removeLast()
        } 
    }

    var StrSt = StringStack()
    StrSt.push("uno")
    StrSt.push("dos")
    StrSt.push("tres")
    StrSt.push("cuatro")
    print(StrSt.pop())

.. sourcecode:: bash

    > swift test.swift
    cuatro
    >

And now, let's rewrite it to use generics

.. sourcecode:: swift

    struct Stack <T> {
        var items = [T]()
        mutating func push(item:T) {
            items.append(item)
        }
        mutating func pop() -> T {
            return items.removeLast()
        } 
    }

    var StrSt = Stack<String>()
    StrSt.push("uno")
    StrSt.push("dos")
    StrSt.push("tres")
    StrSt.push("cuatro")
    print(StrSt.pop())

Prints the same as before.

Use the same struct but with Ints:

.. sourcecode:: swift

    var IntSt = Stack<Int>()
    for i in 1...3 { IntSt.push(i) }
    print(IntSt.pop())

.. sourcecode:: bash

    > swift test.swift
    3
    >

I don't have a good use case yet, but you can have more than one generic type:

.. sourcecode:: swift

    func pprint <S,T> (s: S, t: T) {
        print("The value of s is \(s) and t is \(t)")
    }
    pprint(1.33, 17)

.. sourcecode:: bash

    > swift test.swift
    The value of s is 1.33 and t is 17
    >

You can name the generic types anything you like (although caps are standard)

.. sourcecode:: swift

    func pprint <SillyType1,SillyType2> 
        (s: SillyType1, _ t: SillyType2) {
        print("The value of s is \(s) and t is \(t)")
    }
    pprint(1.33, 17)

This next example deals with both generics and protocols.  An efficient collection to use when you want to check whether a value is present is a dictionary.  Since String and Int types can be KeyValue types for a dictionary, this works great:

.. sourcecode:: swift

    func singles <T: Hashable> (input: [T]) -> [T] {
        var D = [T: Bool]()
        var a = [T]()
        for k in input {
            if let _ = D[k] {
                // pass
            }
            else {
                D[k] = true
                a.append(k)
            }
        }
        return a
    }

    print(singles(["a","b","a"]))
    print(singles([0,0,0,0,0]))

What this says is that we'll take an array of type T and then return an array of type T.  For each value in the input, we check if we've seen it (by checking if it's in the dictionary).  The subscript operator is defined.  So we use the ``if let value = D[key]`` construct, which returns ``nil`` if the key is not in the dictionary.

.. sourcecode:: bash

    > swift test.swift 
    ["a", "b"]
    [0]
    >

Of course, a set would be even better.  (Swift 1 didn't have them).

.. sourcecode:: swift

    var a = ["a","b","a"]
    a = Array(Set(a))
    a.sortInPlace()
    print(a)

The ``Hashable`` protocol requires that the array contain objects that are "hashable", i.e. either the compiler (or we) have to be able to compute from it an integer value that is (almost always) unique.  The compiler does this for primitive types on its own.

In order to use this for a user-defined object, that object must follow the Hashable protocol.  We'll talk more about :ref:`protocols` here.
    
Declarations involving generics can get pretty complicated.  Notice all the qualifiers that come after ``where``.  (Also, this example has changed since the Swift book was released, ``Sequence`` has become ``SequenceType`` and ``T.Generator.Element`` replaces ``T.GeneratorType.Element``).

.. sourcecode:: swift

    func anyCommonElements <T, U where
        T: SequenceType, U: SequenceType, 
        T.Generator.Element: Equatable,   
        T.Generator.Element == U.Generator.Element> 
        (lhs: T, rhs: U) -> Bool {
        for lhsItem in lhs {
            for rhsItem in rhs {
                if lhsItem == rhsItem {
                    return true
                }
            }
        }
        return false
    }

    println("\(anyCommonElements([1, 2, 3], [3]))")

.. sourcecode:: bash

    > swift test.swift
    true
    >

Note:  this is a highly inefficient way to do this, but it works.  To make it more efficient, sort both arrays, or use a dictionary.