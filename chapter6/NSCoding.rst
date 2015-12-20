.. _NSCoding:

#################
NSCoding protocol
#################

I have a working example of a class that follows the NSCoding protocol.  I need to write more about this, but here it is for now.

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
            n = coder.decodeObjectForKey("name") as! String
        }

        func encodeWithCoder(coder: NSCoder) {
            coder.encodeObject(n, forKey:"name")
        }

        override var description: String {
            get { return "C instance: \(n)" }
        }
    }

    let c = C("Tom")
    print(c)
    if NSKeyedArchiver.archiveRootObject(c, toFile: "demo") {
        print("OK")
    }
    let c2: C = NSKeyedUnarchiver.unarchiveObjectWithFile("demo") as! C
    print(c2)
    

.. sourcecode:: bash

    > swift test.swift 
    C instance: Tom
    OK
    C instance: Tom
    >
