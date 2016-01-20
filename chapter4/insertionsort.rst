.. _insertionsort:

##############
Insertion sort
##############

https://en.wikipedia.org/wiki/Insertion_sort

As before, the part of the array to the left of the current index is maintained in sorted order.  However, the values to the right of the index are not all larger than the ones to the left.

.. image:: /figures/insertionsort.png
    :scale: 100 %

In insertion sort, we move across the array from left to right and simply take the next value as it comes, no matter whether large or small.  For each new value, we determine the correct place to insert it.  

Elements must be moved as necessary.  We make fewer comparisons and more swaps than in selection sort.

This one was hard to write.  For a first pass at a solution, I found it easier to construct a new array to place the value correctly.

.. sourcecode:: swift

    func insertItem(a: [Int], _ n: Int) -> [Int] {
        var tmp: [Int] = []
        var foundIt = false
        for v in a {
            if v > n && !foundIt {
                tmp.append(n)
                foundIt = true
            }
            tmp.append(v)
        }
        if !foundIt {
            tmp.append(n)
        }
        return tmp
    }

    func insertionSort(inout a: Array<Int>) {
        for i in 1..<a.count {
            var tmp = Array(a[0..<i])
            tmp = insertItem(tmp, a[i])
            a = tmp + a[i+1..<a.count]
            pp(a)
        }
    }

    test(insertionSort)

.. sourcecode:: bash

    > swiftc utils.swift main.swift && ./main
    32 7 100 29 55 3 19 82 23 
    7 32 100 29 55 3 19 82 23 
    7 32 100 29 55 3 19 82 23 
    7 29 32 100 55 3 19 82 23 
    7 29 32 55 100 3 19 82 23 
    3 7 29 32 55 100 19 82 23 
    3 7 19 29 32 55 100 82 23 
    3 7 19 29 32 55 82 100 23 
    3 7 19 23 29 32 55 82 100 
    3 7 19 23 29 32 55 82 100 
    >

It is curious that on this line:

.. sourcecode:: swift

    var tmp = Array(a[0..<i])

without the ``Array()`` part, we get an error:

.. sourcecode:: bash

    > swift test.swift
    test.swift:35:26: error: cannot convert value of type 'ArraySlice<Int>' to expected argument type '[Int]' 
    tmp = insertItem(tmp, a[i])
                             ^~~

We must explicitly convert the ``ArraySlice<Int>`` to an ``Array<Int>``.

A more compact approach in terms of memory is to modify the array in place.  Here is an alternative version of insertItem which does just that.

.. sourcecode:: swift

    func insertItem(inout a: [Int], _ p: Int) {
        // find the correct place to insert
        var i = 0
        while i < p {
            if a[i] > a[p] { break }
            i++
        }
        if i == p { return }
        // swap until we get there
        var j = p
        while true { 
            swap(&a[j-1],&a[j])
            j--
            if j == i { break }
        }
    }

    func insertionSort(inout a: Array<Int>) {
        for i in 1..<a.count {
            insertItem(&a,i)
            pp(a)
        }
    }

    test(insertionSort)

.. sourcecode:: bash

    > swiftc utils.swift main.swift && ./main
    32 7 100 29 55 3 19 82 23 
    7 32 100 29 55 3 19 82 23 
    7 32 100 29 55 3 19 82 23 
    7 29 32 100 55 3 19 82 23 
    7 29 32 55 100 3 19 82 23 
    3 7 29 32 55 100 19 82 23 
    3 7 19 29 32 55 100 82 23 
    3 7 19 29 32 55 82 100 23 
    3 7 19 23 29 32 55 82 100 
    3 7 19 23 29 32 55 82 100 
    >

