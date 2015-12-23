.. _enums:

************
Enumerations
************

Historically, enumerations or ``enum`` s are a way to pass around an integer as a code for something, in a type-safe way.  From the Objective-C docs:

.. sourcecode:: objective-c

    enum {
        NSASCIIStringEncoding = 1,		/* 0..127 only */
        NSNEXTSTEPStringEncoding = 2,
        NSJapaneseEUCStringEncoding = 3,
        NSUTF8StringEncoding = 4,
        ..
    };
    typedef NSUInteger NSStringEncoding;

In the actual call to a string method, what will be passed in an NSUInteger, but the compiler makes sure your code uses  ``NSUTF8StringEncoding`` rather than 4.

Similarly, 

.. sourcecode:: objective-c

    enum {
       NSNotFound = NSIntegerMax
    };

In Swift:

.. sourcecode:: swift

    // one-liner variant
    enum CoinFlip { case Heads, Tails }

    var flip = CoinFlip.Heads
    flip = .Tails
    if flip == .Tails { print("tails") }

The shorthand ``.Tails`` can be used because the compiler is able to deduce that the type of ``flip`` is ``CoinFlip`` from its declaration/definition ``var flip = CoinFlip.Heads``.
    
.. sourcecode:: objective-c

    > swift test.swift 
    tails
    > 

If the definition is on multiple lines, it's slightly different:

.. sourcecode:: swift

    enum CompassPoint {
        case North
        case South
        case East
        case West
    }

    var directionToHead = CompassPoint.West
    directionToHead = .South

    switch directionToHead {
    case .North:
        print("Lots of planets have a north")
    case .South:
        print("Watch out for penguins")
    case .East:
        print("Where the sun rises")
    case .West:
        print("Where the skies are blue")
    }

.. sourcecode:: bash

    > swift test.swift 
    Watch out for penguins
    >
    
If you see a leading period on something (like ``.None``), it's an enumeration.

Here is another example

.. sourcecode:: swift

    enum Result: Int, CustomStringConvertible {
        case Failure, Success
        var description: String {
            switch self {
                case .Failure:
                    return "dang!"
                case .Success:
                    return "oh joy!"
            }
        }
    }

    let r = Result.Failure
    switch r {
        case .Failure: 
            print("N")
        case .Success: 
            print("Y")
    }
    print("\(r)")

.. sourcecode:: bash

    > swift test.swift
    N
    dang!
    >

As the docs describe, enumerations in Swift are much more sophisticated than what you might be used to from other languages.

Here is an example based on the fact that bar-codes can be an array of 4 integers (UPCA) or a graphic that can be converted to a potentially very long String.

.. sourcecode:: swift

    enum Barcode {
        case UPCA(Int, Int, Int, Int)
        case QRCode(String)
    }

    var productBarcode = Barcode.UPCA(8, 85909, 51226, 3)
    productBarcode = .QRCode("ABCDEFGHIJKLMNOP")

    switch productBarcode {
        case .UPCA(let numberSystem, let manufacturer, let product, let check):
            print("UPC-A: \(numberSystem), \(manufacturer), \(product), \(check).")
        case .QRCode(let productCode):
            print("QR code: \(productCode).")
    }
    
.. sourcecode:: bash

    > swift test.swift 
    QR code: ABCDEFGHIJKLMNOP.
    >

The above example is really pretty amazing.  We have two different values for the Barcode enum, which are based on different underlying types of data.  Furthermore, each instance of a Barcode has its individual data.  In this code:

.. sourcecode:: swift

    var productBarcode = Barcode.UPCA(8, 85909, 51226, 3)
    productBarcode = .QRCode("ABCDEFGHIJKLMNOP")

in the second line we are re-assigning the variable to a different Barcode.  Because the type of ``productBarcode`` is known to the compiler, we can leave it off and just use ``.QRCode``.

Also seen in this example is the additional flexibility of ``switch`` flow control in Swift.  Each case is allowed to have setup code in parentheses

.. sourcecode:: swift

    case .QRCode(let productCode):

Here are some other enum definitions from the docs that I haven't really made into full examples yet:

.. sourcecode:: swift

    enum ASCIIControlCharacter: Character {
        case Tab = "\t"
        case LineFeed = "\n"
        case CarriageReturn = "\r"
    }

    enum Planet: Int {
        case Mercury = 1, Venus, Earth, Mars, 
                          Jupiter, Saturn, Uranus, Neptune 
    }
