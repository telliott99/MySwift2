.. _subscripts:

##########
Subscripts
##########

Here is a slightly reworked example from the docs

.. sourcecode:: bash

    struct TimesTable {
        let multiplier: Int
        subscript(index: Int) -> Int {
            return multiplier * index
        }
    }

    var n = 6
    let t3 = TimesTable(multiplier: 3)
    print("\(n) times \(t3.multiplier) is \(t3[n])")

I think you can guess what this is going to print.  

.. sourcecode:: bash

    > swift test.swift
    6 times 3 is 18
    >
    
Subscripts are like what we call the ``__getitem__`` operator in Python:  ``[index]``.

You define ``subscript(index: Int) -> Int { }`` and then you can use it by calling ``mystruct[3]`` or whatever.

.. sourcecode:: bash

    > xcrun swift test.swift
    6 times 3 is 18
    > 

Additional behavior includes the ability to replace both "getters" and "setters" with subscripts, as if your class were a type of dictionary.

What's wild is that:

    Subscripts can take any number of input parameters, and these input parameters can be of any type. Subscripts can also return any type. Subscripts can use variable parameters and variadic parameters, but cannot use in-out parameters or provide default parameter values.

    A class or structure can provide as many subscript implementations as it needs, and the appropriate subscript to be used will be inferred based on the types of the value or values that are contained within the subscript braces at the point that the subscript is used. This definition of multiple subscripts is known as subscript overloading.

    While it is most common for a subscript to take a single parameter, you can also define a subscript with multiple parameters if it is appropriate for your type.
    
OK, that's a mouthful.  Notice that we can use subscripts with either structs or classes.  Here's a simple example of overloading with a struct.  The first subscript takes an Int and returns a String, the second returns an Int.

.. sourcecode:: bash

    struct S {
        var a: [String] = ["Tom", "Joan", "Sean"]
        var ia: [Int] = [72, 63, 69]  // height
        subscript(i: Int) -> String {
            // drop the "get" b/c no setter
            return a[i]
        }
        subscript(i: Int) -> Int {
            get {
                return ia[i]
            }
            set(newValue) {
                ia[i] = newValue
            }
        }
    }

    let s = S()
    var result: String = s[0]
    print(result)
    var i: Int = s[0]
    print(i)

.. sourcecode:: bash

    > swift test.swift
    Tom
    72
    >
    
This is a little tricky because the two subscripts are overloaded on the return type.  We help the compiler by providing explicit type information for the variables ``result`` and ``i``.  We can also call the setter and find it.

All of this is more than a little baroque.

Where I found it useful was in writing a class that wraps an array of binary data.  Here is the class definition:

.. sourcecode:: bash

    import Foundation

    public func intToHexByte(n: UInt8) -> String {
        let s = NSString(format: "%x", n) as String
        if s.characters.count == 1 {
            return "0" + s
        }
        return s
    }

    public class BinaryData : CustomStringConvertible, Indexable, CollectionType {

        public var data: [UInt8] = []

        // we allow data to be empty as default
        public init(_ input: [UInt8] = []) {
            data = input
        }

        public var description : String {
            get {
                let sa = data.map { intToHexByte($0) }
                // return sa.joinWithSeparator(" ")
                return sa.joinWithSeparator("")
                // doesn't work
                // return ByteString(self.data)
            }
        }

        public var count : Int {
            get {
                return self.data.count
            }
        }

        public var endIndex: Int {
            get {
                return data.count
            }
        }

        public var startIndex: Int {
            get {
                return 0
            }
        }

        public subscript (position: Int) -> UInt8 {
            get {
                return data[position]
            }
        }

        public subscript (r: Range<Int>) -> BinaryData {
            get {
                var ret: [UInt8] = []
                for (i,v) in data.enumerate() {
                    if r.contains(i) {
                        ret.append(v)
                    }
                }
                return BinaryData(ret)
            }
        }
    }
    
We declare ``BinaryData`` to follow the ``Indexable`` protocol, and that means we need to provide implementations of ``startIndex`` and ``endIndex``, as well as overloaded ``subscript`` for an Int or a Range<Int>.

Having done that we can do something like:

.. sourcecode:: bash

    let b = BinaryData([0,10,128,255])
    print("\(b)")
    print("\(b[0..<2])")
    

.. sourcecode:: bash

    > swift test.swift
    000a80ff
    000a
    >

Strictly speaking the declaration about ``Indexable`` is covered under ``CollectionType``.  I am not quite sure why the compiler lets us get away from this definition in the latter case, since we seem to be missing some things from CollectionType.  But it works.
    