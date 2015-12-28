.. _basic_sort_alg:

#####################
Basic sort algorithms
#####################

Let's demonstrate Swift implementations for a few of the algorithms for sorting.  First, here are a print utility function and a function to exercise the algorithms.

``utils.swift``:

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

``test`` takes a sort function of signature:  ``(inout [Int]) -> ()``.

The elementary sorting algorithms are bubble sort, selection sort and insertion sort.

-----------
Bubble sort
-----------

https://en.wikipedia.org/wiki/Bubble_sort

In this method

    Bubble sort, sometimes referred to as sinking sort, is a simple sorting algorithm that repeatedly steps through the list to be sorted, compares each pair of adjacent items and swaps them if they are in the wrong order.
    
    It is too slow and impractical for most problems even when compared to insertion sort.
    
If you watch the animation on wikipedia, you will see that the result of this process is to find the largest element in the array on the first pass and place it at the end, then the next largest on the second, and so on.  Rather than remember which value was the largest seen so far on any one pass, we swap repeatedly.

``main.swift``:

.. sourcecode:: swift

    func bubbleSort(inout a: [Int]) {
        var n = a.count
        while n > 0 {
            for j in 0..<n-1 {
                if a[j] > a[j+1] {
                    swap(&a[j],&a[j+1])
                    print("a:    \(a)")
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
    a:    [7, 32, 100, 29, 55, 3, 19, 82, 23]
    a:    [7, 32, 29, 100, 55, 3, 19, 82, 23]
    a:    [7, 32, 29, 55, 100, 3, 19, 82, 23]
    a:    [7, 32, 29, 55, 3, 100, 19, 82, 23]
    a:    [7, 32, 29, 55, 3, 19, 100, 82, 23]
    a:    [7, 32, 29, 55, 3, 19, 82, 100, 23]
    a:    [7, 32, 29, 55, 3, 19, 82, 23, 100]
    a:    [7, 29, 32, 55, 3, 19, 82, 23, 100]
    a:    [7, 29, 32, 3, 55, 19, 82, 23, 100]
    a:    [7, 29, 32, 3, 19, 55, 82, 23, 100]
    a:    [7, 29, 32, 3, 19, 55, 23, 82, 100]
    a:    [7, 29, 3, 32, 19, 55, 23, 82, 100]
    a:    [7, 29, 3, 19, 32, 55, 23, 82, 100]
    a:    [7, 29, 3, 19, 32, 23, 55, 82, 100]
    a:    [7, 3, 29, 19, 32, 23, 55, 82, 100]
    a:    [7, 3, 19, 29, 32, 23, 55, 82, 100]
    a:    [7, 3, 19, 29, 23, 32, 55, 82, 100]
    a:    [3, 7, 19, 29, 23, 32, 55, 82, 100]
    a:    [3, 7, 19, 23, 29, 32, 55, 82, 100]
    after:  
    3  7  19  23  29  32  55  82  100  
    >

(We are using the Swift compiler to combine code in two different files to make an executable ``main`` which we then run with ``./main``).

--------------
Selection sort
--------------

The idea of selection sort

https://en.wikipedia.org/wiki/Selection_sort

is to divide the target array into two parts, a sorted portion on the left, and an unsorted part on the right.

We maintain an index that moves from left to right, where we will place the next value.  On each pass, we find the minimum value remaining in the unsorted part and then swap with the value at that index.
    
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
                print("a:    \(a)")
            }
        }
    }

    test(selectionSort)
    
.. sourcecode:: bash

    > swift test.swift 
    before:  
    32  7  100  29  55  3  19  82  23  
    a:    [3, 7, 100, 29, 55, 32, 19, 82, 23]
    a:    [3, 7, 19, 29, 55, 32, 100, 82, 23]
    a:    [3, 7, 19, 23, 55, 32, 100, 82, 29]
    a:    [3, 7, 19, 23, 29, 32, 100, 82, 55]
    a:    [3, 7, 19, 23, 29, 32, 55, 82, 100]
    after:  
    3  7  19  23  29  32  55  82  100  
    >

--------------
Insertion sort
--------------

https://en.wikipedia.org/wiki/Insertion_sort

I found this one hard to write.  We move across the array from left to right and take the next value as it comes, no matter whether large or small.  The part of the array to the left of the current index is maintained in sorted order.  For each new value, we find the correct place to insert it, moving elements as necessary.

I found it easier to construct a new array to place the value correctly.

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
            print("a:    \(a)")
        }
    }

    test(insertionSort)

.. sourcecode:: bash

    > swift test.swift 
    before:  
    32  7  100  29  55  3  19  82  23  
    a:    [7, 32, 100, 29, 55, 3, 19, 82, 23]
    a:    [7, 32, 100, 29, 55, 3, 19, 82, 23]
    a:    [7, 29, 32, 100, 55, 3, 19, 82, 23]
    a:    [7, 29, 32, 55, 100, 3, 19, 82, 23]
    a:    [3, 7, 29, 32, 55, 100, 19, 82, 23]
    a:    [3, 7, 19, 29, 32, 55, 100, 82, 23]
    a:    [3, 7, 19, 29, 32, 55, 82, 100, 23]
    a:    [3, 7, 19, 23, 29, 32, 55, 82, 100]
    after:  
    3  7  19  23  29  32  55  82  100  
    >

It is curious that on this line:

.. sourcecode:: swift

    var tmp = Array(a[0..<i])

without the ``Array()`` part, we get this error:

    > swift test.swift
    test.swift:35:26: error: cannot convert value of type 'ArraySlice<Int>' to expected argument type '[Int]'
            tmp = insertItem(tmp, a[i])
                             ^~~

We must explicitly convert the ``ArraySlice<Int>`` to an ``Array<Int>``.

