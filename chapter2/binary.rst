.. _binary:

######
Binary
######

.. sourcecode:: bash

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

    - ``~`` not
    - ``|`` or
    - ``^`` xor
    - ``<<`` left shift
    - ``>>`` right shift

.. sourcecode:: bash

    import Foundation

    import Foundation

    let b1: UInt8 =       0b10100101
    let b2: UInt8 =       0b00001111
    let b3 = b1 ^ b2  //  0b10101010

    print("\(b3)")
    print(NSString(format: "%x", b3))
    
.. sourcecode:: bash

    > xcrun swift test.swift
    170
    aa
    >

Note:  ``a`` is ``1010``.

.. sourcecode:: bash


    let pink: UInt32 = 0xCC6699
    let redComponent = (pink & 0xFF0000) >> 16    
    // redComponent is 0xCC, or 204
    let greenComponent = (pink & 0x00FF00) >> 8   
    // greenComponent is 0x66, or 102
    let blueComponent = pink & 0x0000FF           
    // blueComponent is 0x99, or 153

Having exclusive or immediately suggests encryption.  Here is a silly example:

.. sourcecode:: bash

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