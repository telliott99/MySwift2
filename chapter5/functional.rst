.. _functional:

######################
Functional Programming
######################

In this section, we look at the three staples of functional programming:  ``filter``, ``map`` and ``reduce``.

------
Filter
------

A ``filter`` takes an array of values and a predicate, which is a function that takes a single value, tests it, and returns a boolean.

There used to be a built-in ``filter`` global function:  called like ``filter(myarray)``.  Now the array class has a ``filter`` method, which is called as ``myarray.filter()``.  We can use it with a closure:

.. sourcecode:: swift

    let a = Array(0...10)
    let result = a.filter { $0 < 5 && $0 % 2 == 0 }
    print("\(result)")

.. sourcecode:: bash

    > swift test.swift
    [0, 2, 4]
    >

Sets are particularly good for testing membership:

.. sourcecode:: swift

    let set = Set(["a","b"])
    let a = ["a","b","c"]

    var result = a.filter { !set.contains($0) }
    print(result)
    
.. sourcecode:: bash

    > swift test.swift
    ["c"]
    >

Here is another example with String and a home-made version of split.  (Later we'll see a better and shorter way to do this with ``map``).

.. sourcecode:: swift

    func mysplit(s: String) -> [String] {
        var ret = Array<String>()
        for c in s.characters {
            // convert Character to String
            ret.append(String(c))
        }
        return ret
    }

    func isVowel(str: String) -> Bool {
        let vowels = mysplit("aeiou")
        return vowels.contains(str)
    }

    let a1 = mysplit("abcde")
    print("\(a1)")
    let a2 = a1.filter(isVowel)
    print("\(a2)")

.. sourcecode:: bash

    > swift test.swift
    [a, b, c, d, e]
    [a, e]
    >
    
Now, let's write our own version of filter, as a generic function that takes an array parameter.
    
.. sourcecode:: swift

    func myfilter <T> (a: Array<T>, _ pred: (T) -> (Bool)) -> Array<T> {
        var ret = Array<T>()
        for t in a {
            if pred(t) { 
                ret.append(t) 
            }
        }
        return ret
    }

    let a1 = Array(0...4)

    func lessThan2(i: Int) -> Bool { return i < 2 }
    let a2 = myfilter(a1,lessThan2)
    print("\(a2)")

    let a3 = myfilter(a1, { $0 < 3 })
    print("\(a3)")

We pass either a function or a closure.

.. sourcecode:: bash

    > swift test.swift
    [0, 1]
    [0, 1, 2]
    >

A String example using ``myfilter`` from above:

.. sourcecode:: swift

    let a1 = ["a","b","c","d","e"]

    func isVowel(s: String) -> Bool {
        let vowels = ["a","e","i","o","u"]
        return vowels.contains(s)
    }

    let a2 = myfilter(a1, isVowel)
    print("\(a2)")
    
.. sourcecode:: bash

    > swift test.swift
    [a, e]
    >

---
Map
---

A ``map`` function takes an array and a function which transforms the values.  ``map`` applies ``transform`` to each element of the array and returns the result as an array.

.. sourcecode:: swift

    func mymap <T,U> (a: [T], _ transform: (T) -> (U) ) -> [U] {
          var ret = [U]()
          for t in a {
              ret.append(transform(t))
          }
          return ret
    }

    let a1 = Array(0...4)
    func sub(i: Int) -> Int { return i - 1 }
    let a2 = mymap(a1,sub)
    print("\(a2)")
    
.. sourcecode:: bash

    > swift test.swift
    [0, 1, 2, 3, 4]
    [-1, 0, 1, 2, 3]
    >

I got ``ord`` from here:

https://github.com/practicalswift/Pythonic.swift/blob/master/src/Pythonic.swift

.. sourcecode:: swift

    import Foundation

    func ord(c: Character) -> Int? {
        return ord(String(c))
    }

    func ord(s: String) -> Int? {
        // limit to ASCII
        if s == "" { return nil }
        let n = UInt8(s.utf8.first!)
        if n > 126 { return nil }
        return Int(n)
    }

    func mysplit(str: String, _ seps: String) -> [String] {
        let cs = NSCharacterSet(charactersInString:seps)
        return str.componentsSeparatedByCharactersInSet(cs)
    }

    func toData(str: String) -> Int {
        var i: Int = 0
        for c in str.characters {
            if let o = ord(c) { i += o }
        }
        return i
    }

    let a1 = mysplit("My name is Tom", " ")
    print("\(a1)")
    let a2 = a1.map(toData)
    print("\(a2)")
    
.. sourcecode:: bash

    > swift test.swift 
    ["My", "name", "is", "Tom"]
    [198, 417, 220, 304]
    >
    
There is also a function called ``flatMap``:

.. sourcecode:: swift

    let a = [[1,2], [3]]
    print(a.flatMap { $0 })
    
    
.. sourcecode:: bash

    > swift test.swift
    [1, 2, 3]
    > 

However, ``flatMap`` fails if the nesting goes another level down:  ``[[1, 2], [3], [4, [5, 6]]]``.  This gives "error: type of expression is ambiguous without more context".
    

Here is another one.  ``mymap`` returns nil when the element is nil, and the transformed element otherwise.  To me the most interesting part is that we can switch on ``optstr`` as Optional

.. sourcecode:: swift

    func mymap<T, U>(x: T?, f: T -> U) -> U? {
      switch x {
      case .Some(let value): return .Some(f(value))
      case .None: return .None
      }
    }

    var optstr: String? = "hello"
    switch optstr {
    case .Some:  print("some")
    case .None:  print("none")
    }
    
    // prints "some"

Apparently, ``.Some`` and ``.None`` are the two possible enum values for an Optional.  (The compiler does not complain about the absence of a ``default`` case).  If we do ``optstr = nil``, the ``print`` statement will give "none".

------
Reduce
------

.. sourcecode:: swift

    let a = 1..<100
    let sum = a.reduce(0, combine: +)
    print(sum)  // 4950

.. sourcecode:: swift

    let a = 1..<10
    let product = a.reduce(1, combine: *)
    print(product)  // 362880 == 10!
    

