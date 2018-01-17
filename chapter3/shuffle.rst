.. _shuffle:

##############
Random Shuffle
##############

If you want to "shuffle" an array, rearranging the items randomly, one correct algorithm is to move through the array with an index and exchange the value at current position with a random value *from the current position* through the end of the array (i.e. do not pick a value from the whole range).

First, we need a function that produces a random Int in any range.  We choose to use a half-open range, which does not include the end value.

.. sourcecode:: swift

    import Foundation

    // we do not include end in the values
    
    func randomIntInHalfOpenRange(begin begin: Int, end: Int) -> Int {
        let r = end - begin
        let value = Int(arc4random_uniform(UInt32(r)))
        return begin + value
    }

    func test() {
        for _ in 0..<50 { 
            let n = randomIntInHalfOpenRange(begin: 0, end: 10)
            print(n)
        }
    }

    test()
    
It seems to work:  we see both ``0`` and ``9`` in the output.
    
Now implement the algorithm described above.

.. sourcecode:: swift

    func swap(inout a: [Int], _ i: Int, _ j: Int) {
        let tmp = a[i]
        a[i] = a[j]
        a[j] = tmp
    }

    func shuffleIntArray(inout a: [Int]) {
        let n = a.count
        for i in 0..<n-1 {
            let j = randomIntInHalfOpenRange(begin: i, end: n)
            if i == j { continue }
            swap(&a,i,j)
        }
    }

    var a: [Int] = Array(0..<20)
    shuffleIntArray(&a)
    print("\(a)")

.. sourcecode:: bash

    > swift test.swift 
    [11, 19, 2, 12, 17, 0, 6, 3, 16, 5, 1, 14, 18, 10, 4, 8, 15, 9, 13, 7]
    >

For this code to work, we must mark the array parameter as ``inout`` and then pass a reference to the array ``&a`` into both the original function ``shuffleIntArray`` and also the one that actually changes the array, ``swap``.
