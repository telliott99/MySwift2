.. _bubblesort:

##########
Bubblesort
##########

In what follows we will construct Swift implementations for the standard sorting algorithms.  

To begin with, here are a print utility function and a function to exercise the algorithms.  We place them in a separate file:

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

We start at the left end of the array, indexes and compare the first two values, call them ``a[0]`` and ``a[1]``.  If ``a[1]`` is smaller than ``a[0]``, swap the two items.  More generally, compare the value at index ``i`` with that at ``i+1``, starting from ``i=0`` and moving through the array until ``i+1`` is equal to ``a.count-1``.
    
If you watch the animation on wikipedia, you will see that the result of this process is to find the largest element in the array on the first pass and place it at the end.

On the second pass, we need to go only until ``i+1`` is equal to ``a.count-2``.  This pass will find the second largest value, and so on.

Rather than remember which value was the largest seen so far on any one pass, we swap repeatedly.

``main.swift``:

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

Since we are using code from two separate files, the procedure to run the program is different. The explanation is at the end.

.. sourcecode:: bash
    
    > swiftc utils.swift main.swift && ./main
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
    
You can see how the value ``100`` "bubbles" to the end of the array in the first part of the results.  

It is also clear that there are a lot of swaps, compared with the later examples.  For random data, on the average the first value requires n/2 swaps, the second (n-1)/2, and so on.

Bubblesort is a really inefficient algorithm.  We'll see better ones in the next two sections.

In this code:

.. sourcecode:: bash
    
    > swiftc utils.swift main.swift && ./main

we invoke the Swift compiler directly with ``swiftc``, and pass to it two filenames:  ``utils.swift`` and ``main.swift``.  The latter name is required.  The result is an "executable" called ``main``.  

``&&`` separates two instructions to the shell.  In order to run the executable, Unix requires prepending ``./`` which is shorthand for "start in the current directory" when you look for ``main``.

