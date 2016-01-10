.. _extensions:

##########
Extensions
##########
    
In this section we'll develop some extensions, starting with the Int type.

This might be handy:

.. sourcecode:: swift

    import Foundation

    public extension Int {
        static func random(min: Int = 0, max: Int) -> Int {
            return Int(arc4random_uniform(UInt32((max - min) + 1))) + min
        }
    }

    let N = 10
    for i in 1...10 {
        let x = Int.random(max: N)
        print("\(x) ", terminator:"")
    }
    print("")

.. sourcecode:: bash

    > swift test.swift
    2 5 7 4 10 10 9 10 7 3 
    > 
    
We can make Swift like Ruby!

.. sourcecode:: swift

    extension Int {
        func repetitions(task: () -> Void) {
            for _ in 0..<self {
                task()
            }
        }
    }

    3.repetitions {
        print("Goodbye!")
    }
    
.. sourcecode:: bash
 
    > swift test.swift 
    Goodbye!
    Goodbye!
    Goodbye!
    >

And another one from the docs:

.. sourcecode:: swift

    extension Int {
        enum Kind {
            case Negative, Zero, Positive
        }
        var kind: Kind {
            switch self {
            case 0:
                return .Zero
            case let x where x > 0:
                return .Positive
            default:
                return .Negative
            }
        }
    }
    
    // using self above (second case)
    // rror: expression pattern of type 'Bool' cannot match values of type 'Int'
    
    func printIntegerKinds(numbers: [Int]) {
        for number in numbers {
            switch number.kind {
            case .Negative:
                print("- ", terminator: "")
            case .Zero:
                print("0 ", terminator: "")
            case .Positive:
                print("+ ", terminator: "")
            }
        }
        print("")
    }
    printIntegerKinds([3, 19, -27, 0, -6, 0, 7])
    
.. sourcecode:: bash

    > swift test.swift 
    + + - 0 - 0 + 
    >

