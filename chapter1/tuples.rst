.. _tuples:

######
Tuples
######

Tuples may contain two (or more) values of any Type or Types you like.  

.. sourcecode:: swift

    let status = (404, "Not Found")

    // access by dot
    print("\(status.1)")

    let (_, str) = status
    print("\(str)")

    let status2 = (statusCode:200, description:"OK")
    print("\(status2.description)")
    
.. sourcecode:: bash

    > swift test.swift
    Not Found
    Not Found
    OK
    >

A couple of points to make here.  First, indexing always starts with ``0``.  Hence ``status.1`` is the *second* component of the tuple ``status``.  Also, Swift encourages the use of ``_`` to ignore or throw away the value of a result when it is not actually going to be used.  And third, assignment of a tuple to ``(_, str)`` requires the parentheses.

Tuples are useful for returning multiple values from a function.  A silly example:

.. sourcecode:: swift

    func f(str: String) -> ([String], Int) {
        var ret = Array<String>()
        for c in str {
            ret.append(String(c))
        }
        return (ret, ret.count)
    }

    let (_, count) = f("Swift")
    print("\(count)")

.. sourcecode:: bash

    > swift test.swift
    5
    >
    
Tuples can be used for multiple assignment:

.. sourcecode:: swift

    func myswap(i: Int, _ j: Int) -> (Int, Int) {
        return (j, i)
    }

    let (i,j) = (1,2)
    var (x,y) = (i,j)     // equals (1,2)
    (x,y) = myswap(x,y)   // equals (2,1)
    (x,y) = (y,x)         // equals (1,2)

    var (a,b,c) = (1,2,3)
