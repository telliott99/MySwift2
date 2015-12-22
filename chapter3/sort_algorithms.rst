.. _sort_algorithms:

###############
Sort Algorithms
###############

Let's just demo a few algorithms for sorting, implemented in Swift.  First, some utility functions.

.. sourcecode:: bash

    func pp (s: String, _ a: [Int]) {
        print (s + " ")
        for n in a { print("\(n) ", terminator: " ") }
        print("")
    }

    func swap(inout a: [Int], _ i: Int, _ j: Int) {
        let tmp = a[i]
        a[i] = a[j]
        a[j] = tmp
    }

Then, the elementary sorts:  bubble, selection and insertion sort:

.. sourcecode:: bash

    func bubble_sort(inout a: [Int]){
        for _ in 0...a.count - 1 {
            for i in 0...a.count - 2 {
                if a[i] > a[i+1] {
                    swap(&a,i,i+1)
                }
            }
        }
    }

    func selection_sort(inout a: [Int]) {
        for i in 0...a.count - 2 {
            for j in i...a.count - 1 {
                if a[j] < a[i] {
                    swap(&a,i,j)
                }
            }
        }
    }

    func insertion_sort(inout a: [Int]) {
        for i in 1...a.count-1 {
            // a[0...i] are guaranteed to be sorted
            var tmp = Array(a[0...i])

            // go up to penultimate value
            let v = tmp.last!
            for j in 0...tmp.count - 2 {
                if tmp[j] > v {
                    tmp.insert(v, atIndex:j)
                    tmp.removeLast()
                    break
                }
            }
            a[0...i] = tmp[0...tmp.count-1]
        }
    }

Very useful:  merge sort

.. sourcecode:: bash

    func merge(a1: [Int], _ a2: [Int]) -> [Int] {
        // a1 and a2 are sorted already
        var ret: [Int] = Array<Int>()
        var i: Int = 0
        var j: Int = 0
        while i < a1.count || j < a2.count {
            if j == a2.count {
                if i == a1.count - 1 { ret.append(a1[i]) }
                else { ret += a1[i...a1.count-1] }
                break
            }
            if i == a1.count {
                if j == a2.count - 1 { ret.append(a2[j]) }
                else { ret += a2[j...a2.count-1] }
                break
            }
            if a1[i] < a2[j] { ret.append(a1[i]); i += 1 }
            else { ret.append(a2[j]); j += 1 }
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

And now to exercise them:

.. sourcecode:: bash

    let a = [32,7,100,29,55,3,19,82,23]
    pp("before: ", a)

    let b = a.sort { $0 < $1 }
    pp("sorted: ", b)

    // make sure we bubble enough times
    var c = [32,7,100,29,55,19,82,23,3]
    pp("before: ", c)
    bubble_sort(&c)
    pp("bubble: ", c)

    c = a
    pp("before: ", c)
    selection_sort(&c)
    pp("select: ", c)

    c = a
    pp("before: ", c)
    insertion_sort(&c)
    pp("insert: ", c)

    c = a
    pp("before: ", c)

    c = merge_sort(c)
    pp("merge : ", c)
    
Output:

.. sourcecode:: bash

    > swift test.swift
    before:  
    32  7  100  29  55  3  19  82  23  
    sorted:  
    3  7  19  23  29  32  55  82  100  
    before:  
    32  7  100  29  55  19  82  23  3  
    bubble:  
    3  7  19  23  29  32  55  82  100  
    before:  
    32  7  100  29  55  3  19  82  23  
    select:  
    3  7  19  23  29  32  55  82  100  
    before:  
    32  7  100  29  55  3  19  82  23  
    insert:  
    3  7  19  23  29  32  55  82  100  
    before:  
    32  7  100  29  55  3  19  82  23  
    merge :  
    3  7  19  23  29  32  55  82  100  
    >
