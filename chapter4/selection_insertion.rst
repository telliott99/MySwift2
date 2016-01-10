.. _selection_insertion:

##########################
Selection & insertion sort
##########################

In selection sort

https://en.wikipedia.org/wiki/Selection_sort

we divide the target array into two parts, a sorted portion on the left, and an unsorted part on the right.  We maintain an index at one past the sorted portion.  The index moves from left to right, and it is where we will place the next value.  On each pass, we start at the index and then find the minimum value remaining in the unsorted part, and finally swap with the value at the index.
    
.. sourcecode:: swift

    func selectionSort(inout a: [Int]) {
        let n = a.count
        var smallest: Int = 0
        for i in 0..<n-1 {
            smallest = i
            // now look for one even smaller
            for j in i+1..<n {
                if a[j] < a[smallest] {
                    smallest = j
                }
            }
            if smallest > i { 
                swap(&a[i], &a[smallest]) 
                pp(a)
            }
        }
    }

    test(selectionSort)
    
.. sourcecode:: bash

    > swift test.swift 
    32 7 100 29 55 3 19 82 23 
    3 7 100 29 55 32 19 82 23 
    3 7 19 29 55 32 100 82 23 
    3 7 19 23 55 32 100 82 29 
    3 7 19 23 29 32 100 82 55 
    3 7 19 23 29 32 55 82 100 
    3 7 19 23 29 32 55 82 100 
    >

--------------
Insertion sort
--------------

https://en.wikipedia.org/wiki/Insertion_sort

As before, the part of the array to the left of the current index is maintained in sorted order.  

We move across the array from left to right and simply take the next value as it comes, no matter whether large or small.  For each new value, we determine the correct place to insert it, moving elements as necessary.

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

    > swift test.swift 
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

without the ``Array()`` part, we get this error:

.. sourcecode:: bash

    > swift test.swift
    test.swift:35:26: error: cannot convert value of type 'ArraySlice<Int>' to expected argument type '[Int]' 
    tmp = insertItem(tmp, a[i])
                             ^~~

We must explicitly convert the ``ArraySlice<Int>`` to an ``Array<Int>``.

A more compact approach in terms of memory is to modify the array in place.  Here is an alternative version of insertion sort that does just that.

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

    > swift test.swift 
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

