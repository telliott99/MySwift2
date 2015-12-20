.. _protocols:

#########
Protocols
#########

The basic idea with a protocol is that, to define a new one, we say what function or property an object must have if it is going to be said to follow that protocol.

.. sourcecode:: bash

    protocol Stylish {
        var style: Bool { get }
    }

    struct X: Stylish {
        var style: Bool {
            get { return true }
        }
    }

    let x = X()
    print(x.style)
    
.. sourcecode:: bash

    > swift test.swift 
    true
    >

By far the most common example is to outfit a struct or class with the ability to print itself in a useful way.
    
.. sourcecode:: bash

    struct X: CustomStringConvertible {
        var description: String {
            get {
                return "I am the greatest"
            }
        }
    }

    let x = X()
    print("\(x)")

.. sourcecode:: bash

    > swift test.swift 
    I am the greatest
    >
    
The Hashable and Equatable protocols are required to be followed by objects that want to be included in a Set or a Dictionary.

.. sourcecode:: bash

    // must be at global scope
    func == (a: X, b: X) -> Bool {
        return true
    }

    struct X: Hashable, Equatable {
        var hashValue: Int {
            get { return 0 }
        }
    }

    let x1 = X()
    let x2 = X()
    let s = Set([x1,x2])
    print(s.count)
    
.. sourcecode:: bash

    > swift test.swift 
    1
    >

Given these definitions, only one object of type X can be included in a Set<X>.

Here is a slightly more reasonable implementation.

We obtain a unique id for each object from the current time (slightly different since they are initialized sequentially):

.. sourcecode:: bash

    import Cocoa

    class Obj: Comparable, Equatable {
        var n: Int
        init() {
            let d = NSDate().timeIntervalSince1970
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
    print("\(o1.n) \(o2.n)")
    print(o1 == o2)
    print(o1 < o2)

.. sourcecode:: bash

    > swift test.swift 
    1450574977019510 1450574977019523
    false
    true
    >
    
As you can see, the second object was initialized approximately 0.45 milliseconds after the first one, so it compares as not equal, and less than the second.

For the Hashable protocol, an object is required to have a property ``hashValue``, but is also required to respond to ``==`` (it's undoubtedly faster to check that first).

.. sourcecode:: bash

    import Cocoa

    class Obj: Hashable, CustomStringConvertible {
        var n: Int
        var name: String
        init(name: String) {
            let d = NSDate().timeIntervalSince1970
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
            if let _ = D[v] {
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
    print(singles([o1,o1,o1,o1,o1,o1]))

.. sourcecode:: bash

    > swift test.swift 
    o1:1450575084856957 
    o2:1450575084856970 
    [o1:1450575084856957]
    >

Here is another simple example.

.. sourcecode:: bash

    import Foundation
    class Obj: CustomStringConvertible {
        var n: Int
        init() {
            let d = NSDate().timeIntervalSince1970
            self.n = Int(1000000*d)
        }
        var description: String {
            get { return "Obj: \(n)" }
        }
    }

    var o = Obj()
    print("\(o)")

.. sourcecode:: bash
    
    > swift test.swift 
    Obj: 1450575158979457
    >

Here is another one from the Swift docs:

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
