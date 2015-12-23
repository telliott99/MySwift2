.. _set:

###
Set
###

To construct a set we can do

.. sourcecode:: swift

    var S1: Set<String> = []
    S1.insert("a")
    // S1.insert(["b","c"])              // doesn't work
    
    let S2 = Set<String>(["a","b","c"])  // does work
    S1.insert("d")
    S1.insert("e")

    print(S1)                   //  ["d", "a", "e"]
    print(S2)                   //  ["b", "a", "c"]
    print(S1.intersect(S2))     //  ["a"]
    print(S1.union(S2))         //  ["b", "e", "a", "d", "c"]
    print(S1.exclusiveOr(S2))   //  ["b", "e", "d", "c"]
    print(S1.subtract(S2))      //  ["d", "e"]

Sets are very fast for testing membership.  Inserting and removing items is also fast.

But no matter how many times you try, you'll never have any duplicates.  Meet the Beatles:

.. sourcecode:: swift

    import Foundation

    let beatles = ["John", "Paul", "George", "Ringo"]
    var group = Set<String>()
    var counter = 0
    var i = 0

    while group.count < 4 {
        counter += 1
        i = Int(arc4random_uniform(4))
        let next = beatles[i]
        print(next)
        group.insert(next)
    }
    print(counter)
    print(Array(group).sort())
    
.. sourcecode:: bash

    > swift test.swift 
    Paul
    George
    Paul
    John
    George
    Ringo
    6
    ["George", "John", "Paul", "Ringo"]
    > swift test.swift 
    John
    Ringo
    John
    George
    George
    George
    George
    George
    George
    George
    John
    George
    Ringo
    Paul
    14
    ["George", "John", "Paul", "Ringo"]
    >

That is an unusually large number of attempts.  And what's up with George?


