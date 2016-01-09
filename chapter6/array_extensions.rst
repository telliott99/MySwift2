.. _array_extensions:

#####################
Extensions for Arrays
#####################
    
In this section we'll develop some extensions for the Array type.

.. sourcecode:: swift

    extension Array {
        func elementCount<T: Equatable> (input: T) -> Int {
            var count = 0
            for el in self {
                if el as! T == input {
                    count += 1
                }
            }
            return count
        }
    }

Here is an extension on the Array type that I got from 

https://github.com/pNre/ExSwift/blob/master/ExSwift/Array.swift

.. sourcecode:: swift

    public extension Array {
        func all(test: (Element) -> Bool) -> Bool {
            for item in self {
                if !test(item) {
                    return false
                }
            }
            return true
        }
    }

    func f(a: [Int]) -> Bool {
        return a.all { $0 > 0 }
    }

    var a = [1,2,3]
    print("\(f(a))")
    print("\(a.all { $0 > 0 })")
    a += [0]
    print("\(f(a))")

.. sourcecode:: bash

    > swift test.swift
    true
    true
    false
    >

The array method ``all`` is going to take as a parameter a function that can be used on each element of the array and will return a Boolean.  The end result of the ``all`` method will also return a Boolean.

We can call ``all`` with a closure, or wrap it in a function. 

This all makes perfect sense *except* for the ``Element``, which is a name known to Swift.  You can't replace it with some other name.

And here is an extension on CollectionType that returns the median value in an Array.

.. sourcecode:: swift

    extension CollectionType {
        func median() -> Generator.Element? {
            let n = self.count as! Int
            if n == 0 {
                return nil
            }
            for (i,v) in self.enumerate() {
                if i == (n-1)/2 {
                    return v
                }
            }
            return nil
        }
    }

We return an optional to cover the case where the collection is empty.  This isn't necessarily the best solution because it adds complexity to the client code.  We return the ith element when ``i == (n-1)/2``, so for an even number of elements (like 4) we return the element with index 1.

To exercise it:

.. sourcecode:: swift

    var a = [Int]()
    for i in 1...7 {
        print("\(a) ", terminator: " ")
        if let m = a.median() {
            print("\(m)")
        }
        else {
            print("nil")
        }
        a.append(i)
    }

.. sourcecode:: bash

    []  nil
    [1]  1
    [1, 2]  1
    [1, 2, 3]  2
    [1, 2, 3, 4]  2
    [1, 2, 3, 4, 5]  3
    [1, 2, 3, 4, 5, 6]  3


