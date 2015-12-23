.. _card:

***************************
Playing Cards:  Card struct
***************************

Constructing a deck of playing cards, and then developing a simple game seems like a good project for a starting intermediate programmer.  In this section and the next is my version of a Card struct and a CardArray class to be used as the basis for such a program.

I use an enum for the Suit and the Rank of each card.

All the code from this section is in one file named ``card.swift``, in the ``code`` folder.

The first thing is to define ``enum``s for Suit and Rank.

.. sourcecode:: bash

    /*
    enum Suit and Rank have a "raw value" Int (for <, > and == )
    and are convertible to a String which prints  A♣ etc.
    */

    enum Suit: Int, CustomStringConvertible {

        // Bridge ordering
        case Clubs = 1, Diamonds, Hearts, Spades

        // usage:  for suit in Suit.allValues() ...
        static let allValues = [Clubs, Diamonds, Hearts, Spades]

        var description: String {
            get {
                switch self {
                case .Clubs: return String("\u{2663}")    //  "♣"
                case .Diamonds: return String("\u{2666}") //  "♦"
                case .Hearts: return String("\u{2665}")   //  "♥"
                case .Spades: return String("\u{2660}")   //  "♠"
                }
            }
        }
    }

    enum Rank: Int,  CustomStringConvertible {

        case Two = 2, Three, Four, Five, Six, Seven, Eight, 
             Nine, Ten, Jack, Queen, King, Ace

        static let allValues = [      
                Two, Three, Four, Five, Six, Seven, Eight, 
                Nine, Ten, Jack, Queen, King, Ace ]

        var description: String {
            get {
                switch self {
                case .Ace:  return "A"
                case .King: return "K"
                case .Queen: return "Q"
                case .Jack: return "J"
                case .Ten: return "T"
                default: return "\(self.rawValue)"
                }
            }
        }
    }

So Suit and Rank know how to order themselves, and how to print as an appropriate symbol.

Next for the Card struct.  The struct definition and some of the methods are marked as ``public``.  This is required in order to use them from a different module, which we will use to test this one.  

.. sourcecode:: bash

    public func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.suit == rhs.suit && lhs.rank == rhs.rank
    }

    // this is less elegant than using Suit and Rank
    // but I had trouble with sorting not working so ...

    public func < (lhs: Card, rhs: Card) -> Bool {
        if lhs.n < rhs.n { return true }
        return false
    }

    public func > (lhs: Card, rhs: Card) -> Bool {
        if lhs < rhs { return false }
        if lhs == rhs { return false }
        return true
    }

    public struct Card: Equatable, Hashable, Comparable,
                 CustomStringConvertible {

        let rank: Rank
        let suit: Suit
        let n: Int

        init(rank: Rank, suit: Suit) {
            self.rank = rank
            self.suit = suit
            let v = suit.rawValue * 13
            n = v + rank.rawValue
        }

        public var hashValue: Int {
            get { return n }
        }

        public var description: String {
            get { return "\(self.rank)\(self.suit)" }
        }
    }

That's quite a bit of code.  And we haven't even got to playing Hearts yet.  How to test it? 

Google hasn't helped much so far with documentation for how to use Swift outside of Xcode.  The compiler's help says some things, but I am still working on it.

What I did find in an answer here:

http://stackoverflow.com/questions/24296470/how-do-i-import-a-swift-function-declared-in-a-compiled-swiftmodule-into-anothe

is that if we have a file ``main.swift`` and we are in the same directory as the file with our code to be tested, then we can do

.. sourcecode:: bash

    > swiftc card.swift main.swift -o prog
    > ./prog
    A♠ K♠ Q♠ J♠ T♠ 9♠ ... 7♣ 6♣ 5♣ 4♣ 3♣ 2♣
    >

The name ``main`` is required.
    
This won't work yet, however, I still need to write ``main.swift``.

.. sourcecode:: bash

    func test() {
        var a: [Card] = []
        for s in Suit.allValues {
            for r in Rank.allValues {
                a.append(Card(rank: r, suit:s))
            }
        }
        a.sortInPlace(>)
        let n = 6
        let m = a.count
        let s1 = a[0..<n].map { String($0) }.joinWithSeparator(" ")
        let s2 = a[m-n..<m].map { String($0) }.joinWithSeparator(" ")
        print(s1 + " ... " + s2)
    }

    test()

And then we get the output that I put above.

