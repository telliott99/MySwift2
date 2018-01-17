.. _extensions1:

##########
Extensions
##########

Here is a brief introduction to extensions.  We'll have more to say later in :ref:`extensions`.

Extensions can provide new behavior for either built-in Types like Int, String and Array, or else user-defined objects (which we'll get to later).

Consider the problem of printing an integer.  Here is an NSString method to print an integer with formatting:

.. sourcecode:: objc

    [NSString stringWithFormat:@"An integer: %d", 2];

The format characters are prefaced by "%" and include "d" for decimal, in the case of an integer.

 https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/Strings/Articles/FormatStrings.html

The Swift version of this method is:

.. sourcecode:: swift

    import Foundation

    let i = 2
    let s = NSString(format: "%d", i)
    print(s) // 2

Of course, we can also use string interpolation to do that, by we may like to have more control.  For example 

.. sourcecode:: swift

    import Foundation

    let i = 2
    let s = NSString(format: "%.3d", i)
    print(s) // 2

.. sourcecode:: bash

    > swift test.swift 
    002
    >

To hide the NSString part, write a simple extension on the built-in Swift Int type:

.. sourcecode:: swift

    import Foundation

    extension Int {
        func format(f: String) -> String {
            let s = NSString(format: "%\(f)d", self)
            return String(s)
        }
    }

    let s = 3.format(".4")
    print(s)

.. sourcecode:: bash

    > swift test.swift 
    0003
    >

Similarly, for a Double:

.. sourcecode:: swift

    import Foundation

    extension Double {
        func format(f: String) -> String {
            let s = NSString(format: "%\(f)f", self)
            return String(s)
        }
    }

    let f = 3.14159265
    let s = f.format("3.4")
    print(s)

.. sourcecode:: bash

    > swift test.swift 
    3.1416
    >

For a String example:

.. sourcecode:: swift

    extension String {
        func rjust(n: Int, _ padChar: String = " ") -> String {
            let diff = n - self.characters.count
            if diff <= 0 { return self }
            let c = Character(padChar)
            let cL = Array(count: diff, repeatedValue: c)
            return String(cL) + self
        }
    }

    let s = "abc"
    print(s.rjust(5))
    print(s.rjust(5,"."))

.. sourcecode:: bash

    > swift test.swift 
      abc
    ..abc
    >


