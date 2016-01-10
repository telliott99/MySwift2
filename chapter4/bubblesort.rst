.. _bubblesort:

##########
Bubblesort
##########

Let's demonstrate Swift implementations for a few of the algorithms for sorting.  

First, here are a print utility function and a function to exercise the algorithms.

``utils.swift``:

.. sourcecode:: swift

    func pp (a: [Int]) {
        for n in a { 
            print("\(n)", 
                terminator: " ") 
        }
        print("")
    }

    func test(f: (inout [Int]) -> ()  ) {
        let a = [32,7,100,29,55,3,19,82,23]
        pp(a)
        var c = a
        f(&c)
        pp(c)
    }
    
``pp`` stands for "pretty print".

``test`` takes a sort function of signature:  ``(inout [Int]) -> ()``.

The elementary sorting algorithms are bubble sort, selection sort and insertion sort.

-----------
Bubble sort
-----------

https://en.wikipedia.org/wiki/Bubble_sort

In this method

    Bubble sort, sometimes referred to as sinking sort, is a simple sorting algorithm that repeatedly steps through the list to be sorted, compares each pair of adjacent items and swaps them if they are in the wrong order.
    
    It is too slow and impractical for most problems even when compared to insertion sort.
    
If you watch the animation on wikipedia, you will see that the result of this process is to find the largest element in the array on the first pass and place it at the end, the next pass will find the second largest, and so on.  Rather than remember which value was the largest seen so far on any one pass, we swap repeatedly.

``test.swift``:

.. sourcecode:: swift

    func bubbleSort(inout a: [Int]) {
        var n = a.count
        while n > 0 {
            for j in 0..<n-1 {
                if a[j] > a[j+1] {
                    swap(&a[j],&a[j+1])
                    pp(a)
                }
            }
            n--
        }
    }

    test(bubbleSort)

.. sourcecode:: bash
    
    > swift test.swift 
    32 7 100 29 55 3 19 82 23 
    7 32 100 29 55 3 19 82 23 
    7 32 29 100 55 3 19 82 23 
    7 32 29 55 100 3 19 82 23 
    7 32 29 55 3 100 19 82 23 
    7 32 29 55 3 19 100 82 23 
    7 32 29 55 3 19 82 100 23 
    7 32 29 55 3 19 82 23 100 
    7 29 32 55 3 19 82 23 100 
    7 29 32 3 55 19 82 23 100 
    7 29 32 3 19 55 82 23 100 
    7 29 32 3 19 55 23 82 100 
    7 29 3 32 19 55 23 82 100 
    7 29 3 19 32 55 23 82 100 
    7 29 3 19 32 23 55 82 100 
    7 3 29 19 32 23 55 82 100 
    7 3 19 29 32 23 55 82 100 
    7 3 19 29 23 32 55 82 100 
    3 7 19 29 23 32 55 82 100 
    3 7 19 23 29 32 55 82 100 
    3 7 19 23 29 32 55 82 100 
    >

You can see how the value ``100`` "bubbles" to the end of the array in the first part of the results.  You can also see that there are a lot of swaps, compared with the later examples.  For random data, on the average the first value requires n/2 swaps, the second (n-1)/2, and so on.

(We also could use the Swift compiler to combine code in two different files to make an executable ``main`` which we would then run with ``./main``).

Bubblesort is a really inefficient algorithm.  We'll see better ones in the next two sections.