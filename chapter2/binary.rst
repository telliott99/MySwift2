.. _binary:

######
Binary
######

In Swift, ``0b10100101`` is a "binary literal", with which you can initialize a UInt8, the standard data type for binary data.

.. sourcecode:: swift

    import Foundation

    let b: UInt8 = 0b10100101
    print("\(b)")
    print(NSString(format: "%x", b))
    
    let b2 = ~b
    print("\(b2)")
    print(NSString(format: "%x", b2))

.. sourcecode:: bash

    > xcrun swift test.swift
    165
    a5
    90
    5a
    >

Binary ``10100101`` is equal to 128 + 32 + 4 + 1 = 165 in decimal, and 10*16 + 5 in hexadecimal, or ``a5``.  The ``~`` operator negates bits, so we have that ``b2`` is equal to ``01011010`` which is 64 + 16 + 8 + 2 = 90.  In hexadecimal 90 is equal to 10*5 + 10 or ``5a``.

It is just a peculiarity of this example that ``5 = ~a``, that is, ``0101`` = ~``1010``.

These are the binary operators.

    - ``~`` not
    - ``|`` or
    - ``^`` xor
    - ``<<`` left shift
    - ``>>`` right shift

The shift operators are used like so.  Suppose we have decimal 257 which is ``0000000100000001``, when we do ``257 << 8`` the whole pattern is shifted right by eight places (and the low value bits are discarded).  So we end up with ``00000001`` which is just equal to decimal 1.

.. sourcecode:: swift

    > swift
    Welcome to Apple Swift version 2.1.1 (swiftlang-700.1.101.15 clang-700.1.81). Type :help for assistance.
      1> 257 << 8
    $R1: Int = 1
      3>

Here is exclusive or:

.. sourcecode:: swift

    import Foundation

    let b1: UInt8 =       0b10100101
    let b2: UInt8 =       0b00001111
    let b3 = b1 ^ b2  //  0b10101010

    print("\(b3)")
    print(NSString(format: "%x", b3))
    
.. sourcecode:: bash

    > swift test.swift
    170
    aa
    >

``NSString(format: "%x", n))`` is a convenient way to convert a UInt8 to its String hexadecimal representation.

Note:  ``a`` is decimal 10 or binary ``1010``.

A pure Swift way to do it is with ``String(n, radix: 16)``.

.. sourcecode:: swift

    func intToHexString(n: UInt) -> String {
        let s = String(n, radix: 16)
        if s.characters.count % 2 == 1 {
            return "0" + s
        }
        return s
    }

    func test() {
        let a: [UInt] = [1,36,255,257]
        print(a.map { intToHexString(UInt($0)) })

        print(intToHexString(UInt(Int.max)))
        print(intToHexString(UInt.max))
    }

    test()

Result:

.. sourcecode:: bash

    > swift test.swift
    ["01", "24", "ff", "0101"]
    7fffffffffffffff
    ffffffffffffffff
    >

Unfortunately, we have to supply a Type for the function's input.  I don't think there is a way to write a generic Int function.

http://blog.krzyzanowskim.com/2015/03/01/swift_madness_of_generic_integer/

Here is an example from the docs:

.. sourcecode:: swift


    let pink: UInt32 = 0xCC6699
    let redComponent = (pink & 0xFF0000) >> 16    
    // redComponent is 0xCC, or 204
    let greenComponent = (pink & 0x00FF00) >> 8   
    // greenComponent is 0x66, or 102
    let blueComponent = pink & 0x0000FF           
    // blueComponent is 0x99, or 153

Having exclusive or immediately suggests encryption.  Here is a silly example:

.. sourcecode:: swift

    import Foundation

    let key = "MYFAVORITEKEY"
    let text = "TOMISANERD"
    let kA = key.utf8
    let tA = text.utf8
    assert (kA.count > tA.count)

    var cA = [UInt8]()
    for (k,t) in Zip2Sequence(kA,tA) {
        let c = t^k
        print("\(t) \(k) \(c)")
        cA.append(c)
    }

    var pA = [Character]()
    for (k,c) in Zip2Sequence(kA,cA) {
        let t = c^k
        print("\(t) ")
        let s = Character(UnicodeScalar(UInt32(t)))
        pA.append(s)
    }
    print(String(pA))

.. sourcecode:: bash

    > swift test.swift 
    84 77 25
    79 89 22
    77 70 11
    73 65 8
    83 86 5
    65 79 14
    78 82 28
    69 73 12
    82 84 6
    68 69 1
    84 
    79 
    77 
    73 
    83 
    65 
    78 
    69 
    82 
    68 
    TOMISANERD
    > 
    

See discussion here:

http://stackoverflow.com/questions/24465475/how-can-i-create-a-string-from-utf8-in-swift