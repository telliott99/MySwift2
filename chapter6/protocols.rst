.. _protocols:

#########
Protocols
#########


However before dealing with Hashable, let's start by looking at Comparable and Equatable.  For Comparable, an object must respond to the operators ``==`` and ``<``.  These functions must be defined *at global scope*.

We obtain a unique id for each object from the current time (slightly different since they are initialized sequentially):

.. sourcecode:: bash

    import Cocoa

    class Obj: Comparable, Equatable {
        var n: Int
        init() {
            var d = NSDate().timeIntervalSince1970
            let i = Int(1000000*d)
            self.n = i
        }    
    }

    // must be at global scope
    func < (a: Obj, b: Obj) -> Bool {
        return a.n < b.n
    }

    func == (a: Obj, b: Obj) -> Bool {
        return a.n == b.n
    }

    var o1 = Obj()
    var o2 = Obj()
    println("\(o1.n) \(o2.n)")
    println(o1 == o2)
    println(o1 < o2)

.. sourcecode:: bash

    > xcrun swift test.swift 
    1409051635.29793
    1409051635.29838
    1409051635297932 1409051635298383
    false
    true
    >

As you can see, the second object was initialized approximately 0.45 milliseconds after the first one, so it compares as not equal, and less than the second.

For the Hashable protocol, an object is required to have a property ``hashValue``, but is also required to respond to ``==`` (it's undoubtedly faster to check that first).

.. sourcecode:: bash

    import Cocoa

    class Obj: Hashable, Printable {
        var n: Int
        var name: String
        init(name: String) {
            var d = NSDate().timeIntervalSince1970
            self.n = Int(1000000*d)
            self.name = name
        }
        var hashValue: Int {
            get { return self.n }
        }
        var description: String {
            get { return "\(self.name):\(self.n)" }
        }
    }

    func == (a: Obj, b: Obj) -> Bool {
        return a.n == b.n
    }

    func singles <T: Hashable> (input: [T]) -> [T] {
        var D = [T: Bool]()
        var a = [T]()
        for v in input {
            if let f = D[v] {
                // pass
            }
            else {
                D[v] = true
                a.append(v)
            }
        }
        return a
    }

    var o1 = Obj(name:"o1")
    var o2 = Obj(name:"o2")
    let result = singles([o1,o2,o1])
    for o in result {
        print("\(o) ")
    }
    println()
    println(singles([o1,o1,o1,o1,o1,o1]))


This *almost* works.  For some reason, it isn't printing the representation correctly.

.. sourcecode:: bash

    > xcrun swift test.swift
    test.Obj test.Obj 
    [test.Obj]
    >

Here is another simple example.

.. sourcecode:: bash

    import Foundation
    class Obj: Printable {
        var n: Int
        init() {
            var d = NSDate().timeIntervalSince1970
            self.n = Int(1000000*d)
        }
        var description: String {
            get { return "Obj: \(n)" }
        }
    }

    var o = Obj()
    println("\(o)")

.. sourcecode:: bash
    
    > xcrun swift test.swift
    test.Obj
    > xcrun -sdk macosx swiftc test.swift && test
    > xcrun -sdk macosx swiftc test.swift && ./test
    Obj: 1410536845136505
    >
    
Notice that it only works correctly by invoking the swift compiler directly (method 2).




Here is an example from the docs

.. sourcecode:: bash

    protocol FullyNamed {
        var fullName: String { get }
    }

    struct Person: FullyNamed {
        var fullName: String
    }

    let john = Person(fullName: "John Appleseed")
    print("\(john): \(john.fullName)")

What this means is that we are constructing a protocol named ``FullyNamed``, and to follow the protocol an instance must have a property ``fullName`` that is a String and is accessible by ``get`` (``obj.fullName`` returns a String).  The ``struct`` Person is declared as following the protocol, and the compiler can check that it does.

.. sourcecode:: bash

    > swift test.swift
    test.Person: John Appleseed
    >

Here is another one:

.. sourcecode:: bash

    protocol FullyNamed {
        var fullName: String { get }
    }

    class Starship: FullyNamed {
        var prefix: String?
        var name: String
        init(name: String, prefix: String? = nil) {
            self.name = name
            self.prefix = prefix
        }
        var fullName: String {
            return (prefix != nil ? prefix! + " " : "") + name
        }
    }
    var ncc1701 = Starship(name: "Enterprise", prefix: "USS")
    print("\(ncc1701): \(ncc1701.fullName)")

.. sourcecode:: bash

    > xcrun swift test.swift
    test.Starship: USS Enterprise
    >

The neat thing about this example is we see a good use of Optional.  ``prefix`` is declared as ``var prefix: String?``, and when we call

.. sourcecode:: bash

    return (prefix != nil ? prefix! + " " : "") + name
    
We first test whether ``prefix`` holds a value, and if so, we get rid of the Optional part with ``prefix!``.

Some other common protocols mentioned already are Equatable, Comparable, Hashable, and CustomPrintConvertible.  

For more about all of these, see Generics.

Here is a bit more about CustomStringConvertible (preivously Printable):  an implementation that is done as an extension on ``Object``

.. sourcecode:: bash

    class Object {
        var n: String
        init(name: String) {
            self.n = name
        }
    }

    extension Object: CustomStringConvertible {
        var description: String { return n }
    }

    var o = Object(name: "Tom")
    print("\(o.description)")
    print("\(o)")

.. sourcecode:: bash

    > swift test.swift
    Tom
    Tom
    >
    
I believe the second call should work (that's the point of this?), but it doesn't yet.

As before, the protocol definition gives the property that must be present, specifies the type of what we'll get back and that a "getter" will do it.

To be able to create a set containing objects from a User-defined class, the class must implement two protocols:

.. sourcecode:: bash

    class Simple: Hashable, Equatable, CustomStringConvertible {
        var value: Int
        init(x: Int) { value = x }
        var hashValue: Int {
            get { return value }
        }
        var description: String {
            get { return String(value) }
        }
    }

    func == (lhs: Simple, rhs: Simple) -> Bool {
        return lhs.value == rhs.value
    }

    var s1 = Simple(x: 42)
    var s2 = Simple(x: 43)
    print(s1 == s2)     // false

    var S = Set<Simple>()
    S.insert(s1)
    S.insert(s2)

    print("\(S)")
    S.insert(Simple(x: 41))
    print("\(S)")

.. sourcecode:: bash

    > swift test.swift
    false
    [43, 42]
    [43, 41, 42]
    >
