.. _array:

#####
Array
#####

The three basic collection types are arrays, dictionaries and sets. Let's start with arrays.

.. sourcecode:: swift

    let fruits = ["cats", "apples", "bananas"]
    print(fruits[0])
    for f in fruits { print(f + " ", terminator: "") }
    print("")

.. sourcecode:: bash

    > swift test.swift 
    cats
    cats apples bananas  
    >

A Swift array is a collection of items in a certain order.  All the items must be of the same type, at least generally.  Later we will talk about some fancier uses that are allowed because Objective-C ``NSArray`` does not enforce type restrictions and so may consist of objects with different types.

Any Swift array is typed by the type of the objects it contains.  Above, ``fruits`` is an ``Array<String>``, usually written as ``[String]``.

Array access starts from ``0`` (indexing is 0-based).  The simplicity of the ``for f in fruits`` usage is really nice.

To check the number of items in an array, query the ``count`` property.  If there are no items, then ``isEmpty()`` will return ``true``.

.. sourcecode:: swift
    
    var a = [4,5,6]
    a.count      // 3
    a.isEmpty()  // false
    
.. sourcecode:: swift

    var a = ["a","b","c","d"]
    print(a)
    a[2] = "k"
    print(a)
    
.. sourcecode:: bash

    > swift test.swift 
    ["a", "b", "c", "d"]
    ["a", "b", "k", "d"]
    >

This use of subscripting to change the contents of one element in the array requires that the array be declared as variable with the ``var`` keyword, rather than as a constant with ``let``.

Arrays have the properties ``first`` and ``last``.  Since a particular array may be empty, the result of ``a.first`` and ``a.last`` may or may not contain a value.  Swift deals with this by declaring that this result is an "Optional".  We'll talk more about Optionals later, but for now, we just note that to "unwrap" the value of an Optional and use it as the underlying variable, the trailing ``!`` is required.

.. sourcecode:: swift

    var a = Array(1..<10)
    print("\(a.first!), \(a.last!)")
    a = [1,2,3,4]
    print("\(a.first), \(a.last)")

.. sourcecode:: bash

    > swift test.swift
    1, 9
    Optional(1), Optional(4)
    >

(Best practice says that one must first query whether the Optional variable has a value or is ``nil`` before using it.  If you should happen to do ``x!`` and ``x`` is equal to ``nil``, your program will crash).  For more details, see :ref:`optionals`.

There is a global function ``contains`` to test whether a value is included in a Collection.

.. sourcecode:: swift

    let a = [1,2,3]
    print(a.contains(3))  // true

------------------
Modifying an array
------------------

One way is to use subscript access, as shown above.
 
To insert at a particular position, use ``insert(value, atIndex: index)``, like so:

.. sourcecode:: swift

    var a = ["a","b","c"]
    a.insert("spam", atIndex: 1)
    print(a)
    // ["a","spam","b","c"]
    print(a.count)    // 4

When adding onto the end of an array, use ``append`` for a single value or what is really nice, use *concatenation* with ``+=`` as the equivalent of Python's ``extend``.

.. sourcecode:: swift

    var a = [4,5,6]
    a.append(10)
    // a is [4,5,6,10]
    a += [21,22,23]
    // a is [4,5,6,10,21,22,23]

One can also use Range notation with arrays.

.. sourcecode:: swift

    var a = ["a","b","c"]    

    // fatal error: Array index out of range
    // a[1...3] = ["x","y","z"]

    a[1...2] = ["x","y"]
    print(a)   // ["a", "x", "y"]
    

The valid indexes in an array run from 0 to ``count - 1``.

As the docs say

    You can also use subscript syntax to change a range of values at once, even if the replacement set of values has a different length than the range you are replacing:

.. sourcecode:: swift

    var a = ["a","b","c","d","e","f"]
    a[1...4] = ["x"]
    print(a)
    var b = a
    b[1] = "j"
    print(a)
    print(b)
    
.. sourcecode:: bash

    > swift test.swift 
    ["a", "x", "f"]
    ["a", "x", "f"]
    ["a", "j", "f"]
    >
    
Arrays are value types, so ``a`` and ``b`` refer to different arrays, despite the assignment.  

Swift implements copy-on-write, which means that ``a`` and ``b`` refer to the same underlying storage until the moment that we do ``b[1] = "j"``.

The docs again:

    A value type is a type whose value is copied when it is assigned to a variable or constant

Removing a value by index

.. sourcecode:: swift

    var a = ["a","b","c"]
    print("\(a.removeAtIndex(1))")
    print(a)
    a.insert("x", atIndex:0)
    print(a)

``removeAtIndex`` returns the value:

.. sourcecode:: bash

    > swift test.swift 
    b
    ["a", "c"]
    ["x", "a", "c"]
    >
    
Rather than "pop" use ``removeLast`` (or ``removeFirst``):

.. sourcecode:: swift

    var a = [4,5,6]
    let b = a.removeLast()
    print(a)    //  [4,5]
    print(b)    //  6

One can specify the type of an array using two different approaches:  ``[Int]`` or ``Array<Int>``.  Usually the first, shorthand way is preferred.  

To instantiate an empty array, add the call operator ``()``:

.. sourcecode:: swift

    var a = [Int]()
    print(a)
    print("a is of type [Int]")
    print("a has \(a.count) items")
    for x in 1...3 { a.append(x) }
    print(a)
    print("Now, a has \(a.count) items")
    
.. sourcecode:: bash

    > swift test.swift 
    []
    a is of type [Int]
    a has 0 items
    [1, 2, 3]
    Now, a has 3 items
    >
    
In this last example, we've used string interpolation to print the value of the property ``count``.

``repeatedValue`` works as you'd expect

.. sourcecode:: swift

    var intArr = [Double](count: 3, repeatedValue: 2.5)
    
Looping over the values can be done by ``for-in``:

.. sourcecode:: swift

    var a = 1...2
    for var i in a { print("\(i)") }
    // 1
    // 2

---------
Enumerate
---------

Swift also has enumerate:

.. sourcecode:: swift

    var fruitArr = ["apples", "bananas", "cats"]
    for (i,v) in fruitArr.enumerate() {
        print("Item \(i + 1): \(v)")
    }
.. sourcecode:: bash

    > swift test.swift 
    Item 1: apples
    Item 2: bananas
    Item 3: cats
    >

A little functional programming:

.. sourcecode:: swift

    var a = Array(1...10)
    func isEven(i: Int) -> Bool {
       let x = i % 2
       return x == 0
    }
    let b = a.filter(isEven)
    print(b)
    
.. sourcecode:: bash

    > .. code-block:: swift
    
    swift test.swift
    [2, 4, 6, 8, 10]
    >

------------------
List comprehension
------------------

List comprehension is not built-in to Swift, but the functional programming constructs make it fairly easy.  

The previous example would normally be done this way:  with a trailing closure.

http://stackoverflow.com/questions/24003584/list-comprehension-in-swift

.. sourcecode:: swift

    let evens = (1..<10).filter { $0 % 2 == 0 }
    print(evens)    // [2, 4, 6, 8]

See ::ref:`closures_intro`
