.. _extensions:

##########
Extensions
##########
    
In this section we'll develop some extensions, starting with the Int type.

This might be handy:

.. sourcecode:: bash

    import Foundation

    public extension Int {
        static func random(min: Int = 0, max: Int) -> Int {
            return Int(arc4random_uniform(UInt32((max - min) + 1))) + min
        }
    }

    let N = 10
    for i in 1...10 {
        let x = Int.random(max: N)
        print("\(x) ", terminator:"")
    }
    print("")

.. sourcecode:: bash

    > swift test.swift
    2 5 7 4 10 10 9 10 7 3 
    > 
    
Moving to extensions on the String type, currently, the syntax 

.. sourcecode:: bash

    var s = "Hello, world"
    print(s[0...4])

doesn't work.  We can fix that with the following code, although it's probably not a good idea :)  :

.. sourcecode:: bash

    extension String {
        subscript(i: Int) -> Character {
            let index = startIndex.advancedBy(i)
            return self[index]
        }
        subscript(r: Range<Int>) -> String {
            let start = startIndex.advancedBy(r.startIndex)
            let end = startIndex.advancedBy(r.endIndex)
            return self[start..<end]
        }
    }
    var s = "Hello, world"
    print(s[4])
    print(s[0...4])
    
.. sourcecode:: bash

    > swift x.swift
    o
    Hello
    >

The Swift language does not provide the facility to just index into a String.  Instead, being prepared to deal gracefully with all the complexity of Unicode means that we are supposed to let the compiler generate a valid range for us.

Since ``r`` is a ``Range<Int>``, ``r.startIndex`` is just the first Int in the range.  However, the string indices are not Int values.  Hence, we ask for the ``self.startIndex`` and then use the range as a counter to advance it to where we want to be.

And after that we advance it to where we want to stop.  We really should do some bounds checking, or not?

Here is an extension on the Array type that I got from 

https://github.com/pNre/ExSwift/blob/master/ExSwift/Array.swift

.. sourcecode:: bash

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

This is a bit sophisticated.  (There are lots of sophisticated things in Swift, and unfortunately they don't seem to be very well documented yet).  The array method ``all`` is going to take as a parameter a function that can be used on each element of the array and will return a Boolean.  The end result of the ``all`` method will also return a Boolean.

We can call ``all`` with a closure, or wrap it in a function. 

This all makes perfect sense *except* for the ``Element``, which is a name known to Swift.  You can't replace it with some other name.