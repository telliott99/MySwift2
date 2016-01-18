.. _array_mod:

##################
Array Modification
##################

If you pass an array to a function with the intention of modifying it, declare the array parameter as ``inout`` and pass a reference to the array to the function, like this: ``&a``

.. sourcecode:: swift

    import Foundation

    func swap(inout a: [Int], _ i: Int, _ j: Int) {
        // note a tuple would work here:
        let tmp = a[i]
        a[i] = a[j]
        a[j] = tmp
    }

    func cavemanSort(inout a: [Int]) -> Int {
        let ref = a.sort(<)
        let n = UInt32(a.count)
        var round = 0
        while a != ref {
            round += 1
            let i = Int(arc4random_uniform(n))
            let j = Int(arc4random_uniform(n))
            swap(&a,i,j)
        }
        return round
    }

    var a = [32,7,100,29,55,3,19,82,23]
    print(cavemanSort(&a))

This is the world's stupidest sort function.  For more about ``arc4random_uniform`` see ::ref:`random`.  It just gives us a random Int in the range of valid indexes for the array.  We pick two such random indexes and swap the corresponding values.  For each pass through the loop we see if the result is equal to a correctly sorted version of ``a``.  It takes a really long time.
      
.. sourcecode:: bash

    > swift test.swift 
    495786
    > swift test.swift 
    535310
    > swift test.swift 
    1652444
    >

Formerly, if you forgot ``inout`` in the parameters, or ``&`` in the call, you would get a funny error:

.. sourcecode:: bash

    > xcrun swift test.swift
    test.swift:8:5: error: '@lvalue $T8' is not identical to 'Int'
        a[i] = a[j]
        ^
    test.swift:9:5: error: '@lvalue $T5' is not identical to 'Int'
        a[j] = tmp
        ^
    >

But the compiler is new and improved, now it says:

.. sourcecode:: bash

    test.swift:28:16: error: passing value of type '[Int]' to an inout parameter requires explicit '&'
    selection_sort(a)
                   ^
                   &
    >

