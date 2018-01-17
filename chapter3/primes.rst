.. _primes:

######
Primes
######


Here is an example of applying the Sieve of Eratosthenes to find prime numbers:

https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes

We employ the (highly inefficient) function ``removeAtIndex``, modified to allow us to remove (the first occurrence of) any particular value:

.. sourcecode:: swift

    func removeValue(inout a: [Int], _ v: Int) {
        for (i, item) in a.enumerate() {
            if item == v {
                a.removeAtIndex(i)
            }
            if item > v { break }
        }
    }

The algorithm involves setting up an array of all the integers starting from 2.  Take the first element from the current version of the array, that will be a prime number.  Now go through the array and remove all elements that are multiples of the chosen prime:  4, 6, 8, etc.  

Then, carry out the same process with the next integer still present in the array:  3.  Repeat until the array is exhausted.

.. sourcecode:: swift

    let N = 51
    var a = Array(2..<N)
    var pL: [Int] = []
    while a.count != 0 {
        let p = a.first!
        removeValue(&a,p)
        pL.append(p)

        // the Sieve part, remove multiples of p
        if a.count == 0 { break }
        var n = p + p
        while n <= a.last! {
            removeValue(&a,n)
            n += p
        }
    }

    print(pL)

.. sourcecode:: bash

    > swift test.swift 
    [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47]
    >

In the code above, we forcibly unwrap optionals twice.  But both times the unwrapping is preceded by a test to ensure that the value will exist.

Here is a much better implementation of the Sieve, first in Python.  We will rewrite it in Swift.

.. sourcecode:: swift

    def primesLessThanN(N = 200):
        # Sieve of Eratosthenes
        L = [True] * (N+1)
        L[0] = False
        L[1] = False

        for i in range(2,len(L)):
            if not L[i]:
                continue
            p = i
            while True:
                p += i
                if p > N:
                    break
                L[p] = False
        return [i for i in range(len(L)) if L[i]]

    pL = primesLessThanN()
    print pL[:7]

.. sourcecode:: bash

    > python test.py 
    [2, 3, 5, 7, 11, 13, 17]
    >

The Swift version is very similar:

.. sourcecode:: swift

    func primesLessThanValue(N: Int = 200) -> [Int] {
        var a = Array(count:N, repeatedValue:true)
        a[0] = false
        a[1] = false

        for i in 2..<N {
            if !a[i] {
                continue
            }
            var p = i
            while true {
                p += i
                if p >= N {
                    break
                }
                a[p] = false
            }
        }
        var ret = [Int]()
        for i in 0..<a.count-1 {
            if a[i] {
                ret.append(i)
            }
        }
        return ret
    }

    let pL = primesLessThanValue()
    print("\(pL[0..<7])")
    
.. sourcecode:: bash

    > swift test.swift
    [2, 3, 5, 7, 11, 13, 17]
    >

There are a number of tests which rule out many non-primes without false negatives.  One is due to Fermat.  Here is the Python version:

.. sourcecode:: bash

    class Fermat:
        def __init__(self, e):
            self.e = e
            self.values = [1,2]

        def grow(self, n):
            while len(self.values) < n:
                next = self.values[-1]
                next *= self.e
                self.values.append(next)

        def test(self, n):
            self.grow(n)
            v = self.values[n-1]
            assert v == self.e**(n-1)
            return v % n == 1

    f2 = Fermat(2)
    pL = primesLessThanN(int(500))

    def test():
        # 341 passes but is not prime
        for i in range(11,351,2):
            print i, f2.test(i), i in pL

    test()

I started to implement this in Swift but discovered that the values become too large for ``n > 63``.  The reason is that the maximum value for a signed 64 bit integer (Int.max) is equal to 2**63 - 1 and so is unable to store the value 2**64. 

It would take special code to get around that problem.

.. sourcecode:: swift

    struct Fermat {
        var e: Int
        var a: [Int]

        init(e: Int) {
            self.e = e
            a = [1,2]
            a.reserveCapacity(100)
        }
        mutating func grow(n: Int) {
            while a.count < n {
                var next = a.last!
                next *= e
                print("\(a.count) \(next)")
                a.append(next)
            }
        }
        mutating func test(n: Int) -> Bool {
            self.grow(n)
            // note:  one more call to grow and
            // next will be > Int.max
            assert(n <= 63, "cannot exceed Int.max")
            let v = a[a.count - 1]
            return v % n == 1
        }
    }

    var f2 = Fermat(e: 2)
    f2.grow(63)
    print("\(f2.test(53))")


    