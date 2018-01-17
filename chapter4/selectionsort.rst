.. _selectionsort:

##############
Selection sort
##############

Selection sort and insertion sort can be viewed as smarter versions of bubble sort.  In selection sort, we *remember the index* of the largest value at each stage.

https://en.wikipedia.org/wiki/Selection_sort

Divide the target array into two parts, a sorted portion on the left up to the value at an index, and an unsorted part beyond that.  The fact that the part up to the index is sorted is called an *invariant*.

We maintain the index at one past the sorted portion.  Think of it as keeping our finger on that position, while our eyes scan the remaining elements to the right.  We "select" the smallest such element.

The index moves from left to right, and it is where we will place the next value.  On each pass, we start at the index and then find the minimum value remaining in the unsorted part, and finally swap with the value at the index.
    
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

    > swiftc utils.swift main.swift && ./main
    32 7 100 29 55 3 19 82 23 
    3 7 100 29 55 32 19 82 23 
    3 7 19 29 55 32 100 82 23 
    3 7 19 23 55 32 100 82 29 
    3 7 19 23 29 32 100 82 55 
    3 7 19 23 29 32 55 82 100 
    3 7 19 23 29 32 55 82 100 
    >

In this screenshot of the animation in the wikipedia article, freezing a late stage in the sort, you can see the division into the sorted part on the left, and the unsorted part on the right, where all values in the unsorted part are larger than those in the sorted port.

.. image:: /figures/selectionsort.png
    :scale: 100 %

Note that in this line:

.. sourcecode:: swift

    var smallest: Int = 0

we set our sentinel value to be the lowest possible value.  If the array were to contain values less than zero, we would need to pick a smaller sentinel, e.g. ``Int.min``.

.. sourcecode:: bash

    > swift
    Welcome to Apple Swift version 2.1.1 (swiftlang-700.1.101.15 clang-700.1.81). Type :help for assistance.
    1> Int.min
    $R0: Int = -9223372036854775808
