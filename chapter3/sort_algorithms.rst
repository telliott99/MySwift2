.. _sort_algorithms:

###############
Sort Algorithms
###############

Let's demonstrate a few of the algorithms for sorting, implemented in Swift.  First, here are a print utility function and a function to exercise the algorithms.

.. sourcecode:: swift

    func pp (s: String, _ a: [Int]) {
        print (s + " ")
        for n in a { print("\(n) ", terminator: " ") }
        print("")
    }

    func test(f: (inout [Int]) -> ()  ) {
        let a = [32,7,100,29,55,3,19,82,23]
        pp("before: ", a)
        var c = a
        f(&c)
        pp("after: ", c)
    }

Here are the elementary sorting algorithms.

-----------
Bubble sort
-----------

https://en.wikipedia.org/wiki/Bubble_sort

In this method

    Bubble sort, sometimes referred to as sinking sort, is a simple sorting algorithm that repeatedly steps through the list to be sorted, compares each pair of adjacent items and swaps them if they are in the wrong order.
    
Effectively, what we do is to find the largest element in the array on the first pass, the next largest on the second. 

    It is too slow and impractical for most problems even when compared to insertion sort.

.. sourcecode:: swift

    func bubbleSort(inout a: [Int]){
        var n = a.count
        while n > 0 {
            for j in 0..<n-1 {
                if a[j] > a[j+1] {
                    swap(&a[j],&a[j+1])
                }
            }
            n--
        }
    }

    test(bubbleSort)

.. sourcecode:: bash
    
    > swift test.swift 
    before:  
    32  7  100  29  55  3  19  82  23  
    after:  
    3  7  19  23  29  32  55  82  100  
    >
    
--------------
Selection sort
--------------

The idea of selection sort

https://en.wikipedia.org/wiki/Selection_sort

divide the array into a sorted portion (on the left), and an unsorted part on the right.  We maintain an index where we will place the next value.  On each pass, we find the minimum value remaining in the unsorted part and then swap.
    
.. sourcecode:: swift

    func selectionSort(inout a: [Int]) {
        let n = a.count
        var smallest: Int = 0
        for i in 0..<n-1 {
            smallest = i
            // look for one smaller
            for j in i+1..<n {
                if a[j] < a[smallest] {
                    smallest = j
                }
            }
            if smallest > i { 
                swap(&a[i], &a[smallest]) 
            }
        }
    }

    test(selectionSort)
    
.. sourcecode:: bash

    > swift test.swift 
    before:  
    32  7  100  29  55  3  19  82  23  
    after:  
    3  7  19  23  29  32  55  82  100  
    >

--------------
Insertion sort
--------------

https://en.wikipedia.org/wiki/Insertion_sort

.. sourcecode:: swift

    // still working on this one

---------
Mergesort
---------

In the real world, mergesort and quicksort are common.  The first one works by the following idea:  if two arrays are already sorted, then they can be merged quickly into one sorted array.  

We practice divide and conquer, at each stage we divide a larger list into two smaller ones that are themselves mergesort'ed.  Eventually we reach arrays of length 1, which are already "sorted".

.. sourcecode:: swift

    func merge(a1: [Int], _ a2: [Int]) -> [Int] {
        // a1 and a2 are sorted already
        var ret: [Int] = Array<Int>()
        var i: Int = 0
        var j: Int = 0
        while i < a1.count || j < a2.count {
            if j == a2.count {
                if i == a1.count - 1 { 
                    ret.append(a1[i]) 
                }
                else { 
                    ret += a1[i...a1.count-1] 
                }
                break
            }
            if i == a1.count {
                if j == a2.count - 1 { 
                    ret.append(a2[j]) 
                }
                else { 
                    ret += a2[j...a2.count-1] 
                }
                break
            }
            if a1[i] < a2[j] { 
                ret.append(a1[i]); i += 1 
            }
            else { 
                ret.append(a2[j]); j += 1 
            }
        }
        return ret
    }

    func merge_sort(a: [Int]) -> [Int] {
        if a.count == 1 { return a }
        if a.count == 2 { return merge([a[0]],[a[1]]) }
        let i = a.count/2
        let a1 = merge_sort(Array(a[0...i]))
        let a2 = merge_sort(Array(a[i+1...a.count-1]))
        return merge(a1, a2)
    }

.. sourcecode:: swift

    let a = [32,7,100,29,55,3,19,82,23]
    pp("before: ", a)
    c = merge_sort(a)
    pp("merge : ", c)
    
Output:

.. sourcecode:: bash

    > swift test.swift
    before:  
    32  7  100  29  55  3  19  82  23  
    merge :  
    3  7  19  23  29  32  55  82  100  
    >

---------
Quicksort
---------

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
    