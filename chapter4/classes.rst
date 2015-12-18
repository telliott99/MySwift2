.. _classess:

#######
Classes
#######

.. sourcecode:: bash

    class Obj {
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
    println(o.name)
    println(o.description())

.. sourcecode:: bash

    > xcrun swift test.swift 
    Tom
    Obj: Tom
    >

My favorite simple example of a class is one which keeps track of the count of instances.  The docs say to do this with a ``class`` variable, but the compiler says this is not implemented *yet*.  So we'll use a global

.. sourcecode:: bash

    var count = 0
    class O {
        // not implemented yet!
        // class var count = 0
        var name: String
        init(s: String) {
            count += 1
            name = s
        }
    }

    var o1: O = O(s: "Tom")
    println("name: \(o1.name), \(count)")
    var o2: O = O(s: "Joan")
    println("name: \(o1.name), \(count)")
    println("name: \(o2.name), \(count)")
    

.. sourcecode:: bash

    > xcrun swift test.swift
    name: Tom, 1
    name: Tom, 2
    name: Joan, 2
    >