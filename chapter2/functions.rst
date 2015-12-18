.. _functions:

#########
Functions
#########

Function definitions are labeled with the keyword ``func``

.. sourcecode:: bash

    func greet(name: String) {
        print("Hello \(name)")
    }
    greet("Tom")

.. sourcecode:: bash

    > swift test.swift 
    Hello Tom
    >

The value of each argument or "parameter" to a function must have a declared type.

.. sourcecode:: bash

    func f(name: String, age: Int) {
        // do something
    }

In calling the function f, you would do this:

.. sourcecode:: bash

    f("Tom", age: 60)

If you don't wish to specify the second argument like this in the calling function, you can change the definition:

.. sourcecode:: bash

    func f(name: String, _ age: Int) {
        // do something
    }

and now this works:

.. sourcecode:: bash

    f("Tom", 60)

What is going on is each parameter always has one parameter name and may additionally have more than one, in which case they are in the order external name, followed by internal parameter name.  

In the special case of the first argument, the parameter name is not used by the code that calls the function.

However, for the second argument the parameter name is required, unless we do a special trick.  The trick is to give it both external and internal names, and use the ``_`` syntax for the external one.  Now you can call the function of two arguments with no parameter names.

Alternatively, you could decide that you want all the parameters to be named in the call.  Then you would do something like this:

.. sourcecode:: bash

    func f(name name: String, age: Int) {
        // do something
    }

and now call it like this:

.. sourcecode:: bash

    f(name: "Tom", age: 60)


Functions may have results called a return value, but they don't have to.  If you want to return a value from a function, that value must be typed.  Here is a function that returns an Int (specified by ``-> Int``)

.. sourcecode:: bash

    func count(name: String) -> Int {
        // global function
        return name.characters.count
    }
    print("Tom".count)

.. sourcecode:: bash

    > swift test.swift 
    3
    >

Functions can return multiple values (from the Apple docs, with slight modification):

.. sourcecode:: bash

    func minMax(a: [Int]) -> (Int,Int) {
        var min = a[0]
        var max = a[0]
        for i in a[1..<a.count] {
            if i < min  {
                min = i
            }
            if i > max {
                max = i
            }
        }
        return (min,max)
    }
    let arr = [8,-6,2,109,3,71]
    var (s1,s2) = minMax(arr)
    print("min = \(s1), and max = \(s2)")
    
.. sourcecode:: bash

    > swift test.swift
    min = -6, and max = 109
    >

Return a function from a function:

.. sourcecode:: bash

    func adder(value: Int) -> (Int -> Int) {
        func f(n:Int) -> Int {
            return value + n
        }
        return f
    }
    var addOne = adder(1)
    print(addOne(5))

.. sourcecode:: bash

    > swift test.swift 
    6
    >

Notice how the return type of ``adder`` is specified as ``(Int -> Int)``.  That's a function that takes an Int argument and returns an Int result.

Provide a function as an argument to a function?  Sure..

.. sourcecode:: bash

    func myfilter(list: [Int], _ cond: Int->Bool) -> [Int] {
        var result:[Int] = []
        for e in list {
           if cond(e) {
              result.append(e)
           }
        }
        return result
    }
    func lessThanTen(number: Int) -> Bool {
        return number < 10
    }
    print(myfilter([1,2,13], lessThanTen))

.. sourcecode:: bash

    > swift test.swift 
    [1, 2]
    >

Default parameters
------------------

A function can also have default parameters.  As in Python, the default parameters *must come after* all non-default parameters:

.. sourcecode:: bash

    func join(s1: String, _ s2: String, joiner: String = " ") -> String {
        return s1 + joiner + s2
    }
    print(join("hello","world"))
    print(join("hello","world",joiner: "-"))
    
.. sourcecode:: bash
     
    > swift test.swift 
    hello world
    hello-world
    >
    
There are several other fancy twists on parameters that you can read about in the docs.

Here is one particular example from the Apple docs:

.. sourcecode:: bash

    func sumOf(numbers: Int...) -> Int {
        var sum = 0
        for n in numbers {
            sum += n
        }
        return sum
    }

    print(sumOf())
    print(sumOf(42,597,12))

.. sourcecode:: bash

    > swift test.swift 
    0
    651
    >

The ``...`` means the function takes a variadic parameter (number of items is unknown at compile-time---see the docs).

And finally they say:

    Functions can be nested. Nested functions have access to variables that were declared in the outer function. You can use nested functions to organize the code in a function that is long or complex.
    
So let's try something.  Add ``let x = 2`` as line 1.

.. sourcecode:: bash

    > swift test.swift 
    2
    653
    >

They're not kidding!  The ``x`` at global scope is available inside ``sumOf``.  You can nest deeper:

.. sourcecode:: bash

    let s = "abc"
    func f() {
        let t = "def"
        print(s)
        func g() {
            print(s + t)
            print(s + "xyz")
        }
        g()
    }
    f()

.. sourcecode:: bash

    > swift test.swift 
    abc
    abcdef
    abcxyz
    >