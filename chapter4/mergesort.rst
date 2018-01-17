.. _mergesort:

#########
Mergesort
#########

In the real world, mergesort and quicksort are common.  The first one works by the following idea:  if two arrays are already sorted, then they can be merged quickly into one sorted array.  

We practice divide and conquer, at each stage we divide a larger list into two smaller ones that are themselves mergesort'ed.  Eventually we reach arrays of length 1, which are already "sorted".

.. sourcecode:: swift

    func pp (a: [Int]) {
        for n in a { 
            print("\(n)", 
                terminator: " ") 
        }
        print("")
    }

    func merge(array1: [Int], _ array2: [Int]) -> [Int] {
        // array1 and array2 are sorted already
        var ret: [Int] = Array<Int>()
        var a = array1
        var b = array2
        while a.count > 0 || b.count > 0 {
            if a.count == 0 {
                ret += b
                break
            }
            if b.count == 0 {
                ret += a
                break
            }
            if a[0] < b[0] {
                ret.append(a.removeFirst())
            }
            else {
                ret.append(b.removeFirst())
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

    let a = [32,7,100,29,55,3,19,82,23]
    pp(a)
    let c = merge_sort(a)
    pp(c)
    
Output:

.. sourcecode:: bash 

    > swift test.swift 
    32 7 100 29 55 3 19 82 23 
    3 7 19 23 29 32 55 82 100 
    >

 