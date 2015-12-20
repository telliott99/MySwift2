.. _classess:

#######
Classes
#######

.. sourcecode:: bash

    class Obj: CustomStringConvertible {
        var name: String
        init(name: String) {
            self.name = name
        }
        var description: String {
            get {
                return "Obj: \(self.name)"
            }
        }
    }

    var o = Obj(name: "Tom")
    print(o.name)
    print(o)

.. sourcecode:: bash

    > swift test.swift
    Tom
    Obj: Tom
    >

My favorite simple example of a class is one which keeps track of the count of instances.  The docs say to do this with a ``class`` variable.

.. sourcecode:: bash

    class Counter {
        static var count = 0
        var name: String
        init(s: String) {
            name = s
            Counter.count += 1
        }
    }

    var o1 = Counter(s: "Tom")
    print("name: \(o1.name), \(Counter.count)")
    var o2 = Counter(s: "Joan")
    print("name: \(o2.name), \(Counter.count)")
    print("name: \(o1.name), \(Counter.count)")
    

.. sourcecode:: bash

    > swift test.swift
    name: Tom, 1
    name: Joan, 2
    name: Tom, 2
    >