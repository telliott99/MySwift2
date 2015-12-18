.. _set:

###
Set
###

To construct a set we can do

.. sourcecode:: bash

    var S: Set<String> = ["a","b"]
    print(S.contains("a"))  // true

.. sourcecode:: bash

    var S1: Set<String> = []
    S1.insert("a")
    // S1.insert(["b","c"])  // doesn't work
    let S2 = Set<String>(["a","b","c"])
    S1.insert("y")
    S1.insert("z")

.. sourcecode:: bash

    print(S1.intersect(S2))     //  ["a"]
    print(S1.union(S2))         //  ["b", "a", "y", "z", "c"]
    print(S1.exclusiveOr(S2))   //  ["b", "y", "z", "c"]
    print(S1.subtract(S2))      //  ["y", "z"]
