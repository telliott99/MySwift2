.. _tuples:

######
Tuples
######

Tuples may contain two or more values of any type you like.  

.. sourcecode:: bash

    let status = (404, "Not Found")

    // access by dot
    print("\(status.1)")

    let (_, str) = status
    print("\(str)")

    let status2 = (statusCode:200, description:"OK")
    print("\(status2.description)")
    
.. sourcecode:: bash

    > xcrun swift test.swift
    Not Found
    Not Found
    OK
    >

Tuples can be used to return multiple values from a function.  A silly example:

.. sourcecode:: bash

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

    > xcrun swift test.swift
    5
    >
    
Tuples can be used for multiple assignment:

.. sourcecode:: bash

    func myswap(i: Int, j: Int) -> (Int, Int) {
        return (j, i)
    }

    let (i,j) = (1,2)
    print("i: \(i) j: \(j)")
    var (x,y) = (i,j)
    print("x: \(x) y: \(y)")
    (x,y) = myswap(x,y)
    print("x: \(x) y: \(y)")
    (x,y) = (y,x)
    print("x: \(x) y: \(y)")

    var (a,b,c) = (1,2,3)
    print("a: \(a) b: \(b) c: \(c)")
    
.. sourcecode:: bash

    > xcrun swift test.swift
    i: 1 j: 2
    x: 1 y: 2
    x: 2 y: 1
    x: 1 y: 2
    a: 1 b: 2 c: 3
    >
