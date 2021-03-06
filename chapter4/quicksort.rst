.. _quicksort:

#########
Quicksort
#########

The idea of quicksort is described here:

https://en.wikipedia.org/wiki/Quicksort

http://www.algolist.net/Algorithms/Sorting/Quicksort

The implementation I show is similar to the one above for mergesort in using a lot of memory by allocating new arrays at each stage.  In return we gain simplicity.  

Again, the divide-and-conquer strategy is employed.

At each stage, pick a pivot (not necessarily a value contained in the array, but lying between the min and max elements).  Then, divide the array into two sub-arrays consisting of elements that are ``<=`` or ``>`` than the pivot.

Although some sources say the pivot can be chosen randomly (or, for example, as the mid element of the array), for certain arrays this strategy results in a process that never ends.

To fix this, we find the largest and smallest elements and pick a value that is halfway between them using ``minMax``:

``qsort.swift``:

.. sourcecode:: swift

    func minMax(a: [Int]) -> (Int,Int) {
        var m = a[0]
        var n = a[0]
        for v in a {
            if v < m { m = v }
            if v > n { n = v }
        }
        return (m,n)
    }

    func qsort(a: [Int]) -> [Int] {
        print("\nqsort \(a)")
        let count = a.count
        if count == 0 { return [Int]() }
        if count == 1 { return a }
        let (m,n) = minMax(a)
        if m == n { return a }

        let p = (n-m)/2 + m
        print("p = \(p)")
        var a1: [Int] = []
        var a2: [Int] = []

        for v in a {
            if v <= p { 
                print("append \(v) to \(a1)")
                a1.append(v)
            }
            else { 
                print("append \(v) to \(a2)")
                a2.append(v) 
            }
        }
        return  qsort(a1) + qsort(a2)
    }

    var a = [4,37,1,2,15,6,3,7,9,13,6,1]
    let r = qsort(a)
    print(r)

.. sourcecode:: bash

    > swift quicksort.swift 

    qsort [4, 37, 1, 2, 15, 6, 3, 7, 9, 13, 6, 1]
    p = 19
    append 4 to []
    append 37 to []
    append 1 to [4]
    append 2 to [4, 1]
    append 15 to [4, 1, 2]
    append 6 to [4, 1, 2, 15]
    append 3 to [4, 1, 2, 15, 6]
    append 7 to [4, 1, 2, 15, 6, 3]
    append 9 to [4, 1, 2, 15, 6, 3, 7]
    append 13 to [4, 1, 2, 15, 6, 3, 7, 9]
    append 6 to [4, 1, 2, 15, 6, 3, 7, 9, 13]
    append 1 to [4, 1, 2, 15, 6, 3, 7, 9, 13, 6]

    qsort [4, 1, 2, 15, 6, 3, 7, 9, 13, 6, 1]
    p = 8
    append 4 to []
    append 1 to [4]
    append 2 to [4, 1]
    append 15 to []
    append 6 to [4, 1, 2]
    append 3 to [4, 1, 2, 6]
    append 7 to [4, 1, 2, 6, 3]
    append 9 to [15]
    append 13 to [15, 9]
    append 6 to [4, 1, 2, 6, 3, 7]
    append 1 to [4, 1, 2, 6, 3, 7, 6]

    qsort [4, 1, 2, 6, 3, 7, 6, 1]
    p = 4
    append 4 to []
    append 1 to [4]
    append 2 to [4, 1]
    append 6 to []
    append 3 to [4, 1, 2]
    append 7 to [6]
    append 6 to [6, 7]
    append 1 to [4, 1, 2, 3]

    qsort [4, 1, 2, 3, 1]
    p = 2
    append 4 to []
    append 1 to []
    append 2 to [1]
    append 3 to [4]
    append 1 to [1, 2]

    qsort [1, 2, 1]
    p = 1
    append 1 to []
    append 2 to []
    append 1 to [1]

    qsort [1, 1]

    qsort [2]

    qsort [4, 3]
    p = 3
    append 4 to []
    append 3 to []

    qsort [3]

    qsort [4]

    qsort [6, 7, 6]
    p = 6
    append 6 to []
    append 7 to []
    append 6 to [6]

    qsort [6, 6]

    qsort [7]

    qsort [15, 9, 13]
    p = 12
    append 15 to []
    append 9 to []
    append 13 to [15]

    qsort [9]

    qsort [15, 13]
    p = 14
    append 15 to []
    append 13 to []

    qsort [13]

    qsort [15]

    qsort [37]
    [1, 1, 2, 3, 4, 6, 6, 7, 9, 13, 15, 37]
    > 

I'm sure you can write better implementations than these.  We should try to do mergesort and quicksort without all this array allocation.
    