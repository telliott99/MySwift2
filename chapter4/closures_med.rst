.. _closures_med:

#############
More Closures
#############

A closure is like function with no name.  Kind of like Clint Eastwood

http://en.wikipedia.org/wiki/Man_with_No_Name

You have a function and you are going to use it right away, so it seems like a shame to waste a good name on it.

Maybe the simplest closure is the one I used in the chapter on sorting:

.. sourcecode:: bash

    var a = ["Chris", "Alex", "Barry"]
    a.sortInPlace { $0 < $1 }
    print(a)

.. sourcecode:: bash

    > xcrun swift x.swift 
    ["Alex", "Barry", "Chris"]
    >
    
The second line has a closure in it ``{ $0 < $1 }``.  It uses special built-in variables ``$0`` and ``$1`` and will be called with two arguments that are to be compared to each other.  

The ``<`` is our contribution.  We might as well have put ``>``, to sort in the reverse order. 

We could do this more explicitly as:

.. sourcecode:: bash

    { (a: String, b: String) -> Bool 
        in return a < b }

Fairly compactly as

.. sourcecode:: bash

    { a,b in a < b }
    
Or ridiculously compactly as

.. sourcecode:: bash

    { < }

The Array class method ``map`` takes a function as an argument and applies it to each member of the array.  Here is a first example, using ``map`` with a function (rather than a closure):

.. sourcecode:: bash

    var a = ["a","b","c"]
    func star (s: String) -> String {
        return s + "*" 
    }
    let result = a.map(star)
    print(result)

.. sourcecode:: bash

    > xcrun swift x.swift 
    [a*, b*, c*]
    >

Now, maybe we don't expect we will reuse ``star`` in any other place.  Or... well, there are some common usages we can talk about in a bit.  So modify the example to use a closure:

.. sourcecode:: bash

    var a = ["a","b","c"]
    let result = a.map({
        (s: String) -> String in
        return s + "*" 
        })
    
    print(result)

This second version (above) gives the same result as the first.  The keyword ``in`` separates the argument list and return type from the body.

Here is another example:

.. sourcecode:: bash

    var a = [20, 19, 7, 12]
    let result = a.map({
        (number: Int) -> Int in
        let result = 3 * number
        return result
        })

    print(result)
    
    .. sourcecode:: bash
    
    > xcrun swift x.swift 
    [60, 57, 21, 36]
    >

The rules allow you to omit things if they're obvious.  In the above example, we can omit the argument type since it's obvious from the array we use:

.. sourcecode:: bash

    var a = [20, 19, 7, 12]
    let result = a.map({
        number -> Int in
        let result = 3 * number
        return result
        })
    
You can omit the return type because it is also obvious (but you must omit the ``-> Int``, the variable ``result`` and the ``return`` statement).

.. sourcecode:: bash
    
    var a = [20, 19, 7, 12]
    let result = a.map({
        number in 3 * number
        })

Similarly, for the other example this works:

.. sourcecode:: bash

    var a = ["a","b","c"]
    let result = a.map({ s in s + "*" })
    print(result)

And so does this:

.. sourcecode:: bash

    var a = ["a","b","c"]
    let result = a.map({ $0 + "*" })
    print(result)

You can even omit the parentheses!

.. sourcecode:: bash

    var a = ["a","b","c"]
    let result = a.map { $0 + "*" }
    print(result)

Here are some common use cases for me:

.. sourcecode:: bash

    let cL = "ab".characters
    let a1 = cL.map { String($0) }

``characters`` gives a value of type ``String.CharacterView``.  I'd like an array of String values, and this does it.  Similarly,

.. sourcecode:: bash

    let iL = "ab".utf8
    let a2 = iL.map { UInt($0) }

``iL`` is a value of type ``String.UTF8View``.  I'd like an Array<Int>, and this does it.



