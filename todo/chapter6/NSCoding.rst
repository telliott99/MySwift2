.. _NSCoding:

#################
NSCoding protocol
#################

This works, but I have to run it in the special way (with ``-sdk macosx swiftc``).

http://stackoverflow.com/questions/25701476/how-to-implement-nscoding

.. sourcecode:: bash

    import Foundation

    class C: NSObject, NSCoding {
        var n: String = ""

        override init() {
            super.init()
            n = "instance of class C"
        }

        convenience init(_ name: String) {
            self.init()
            n = name
        }

        required init(coder: NSCoder) {
            n = coder.decodeObjectForKey("name") as String
        }

        func encodeWithCoder(coder: NSCoder) {
            coder.encodeObject(n, forKey:"name")
        }

        override var description: String {
            get { return "C instance: \(n)" }
        }
    }

    let c = C("Tom")
    println(c)
    if NSKeyedArchiver.archiveRootObject(c, toFile: "demo") {
        println("OK")
    }
    let c2: C = NSKeyedUnarchiver.unarchiveObjectWithFile("demo") as C
    println(c2)
    

.. sourcecode:: bash

    > xcrun -sdk macosx swiftc coder.swift && ./coder
    C instance: Tom
    OK
    C instance: Tom
    >
