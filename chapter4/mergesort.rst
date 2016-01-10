.. _mergesort:

#########
Mergesort
#########

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

    let a = [32,7,100,29,55,3,19,82,23]
    pp("before: ", a)
    c = merge_sort(a)
    pp("merge : ", c)
    
Output:

.. sourcecode:: bash 

    > swiftc utils.swift main.swift && ./main
    before:  
    32  7  100  29  55  3  19  82  23  
    merge :  
    3  7  19  23  29  32  55  82  100  
    >

 