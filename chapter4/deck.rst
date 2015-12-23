.. _deck:

***************
A Deck of Cards
***************

We continue with the example from the previous section 

``CardArray.swift``:

.. sourcecode:: swift

    // a class so we can differentiate Deck and Hand
    class CardArray: CustomStringConvertible,
                     CollectionType {

        var a: [Card] = []

        init(_ input: [Card]) {
            a = input
        }

        var count: Int {
            get {
                return a.count
            }
        }

        var description: String {
            get {
                let maxValuesToShow = 13
                var ret = [String]()

                if a.count <= maxValuesToShow {
                    for c in a {
                        ret.append("\(c)")
                    }
                }

                else {
                    let m = maxValuesToShow/2
                    for (i,c) in a.enumerate() {
                        if i == m {
                            ret.append(" ... ")
                        }

                        if i < m || (a.count - i - 1) < m {
                            ret.append("\(c)")
                        }
                    }
                }
                return ret.joinWithSeparator(" ")
            }
        }

        func sortInPlace() {
            self.a.sortInPlace() { $0 > $1 }
        }

        var startIndex : Int { return 0 }

        var endIndex : Int { return a.count }

        subscript(position : Int) -> Card {
            get {
                return a[position]
            }
        }

        subscript(range: Range<Int>) -> CardArray {
            get {
                // cannot subscript a value of type [Card]
                // why not?
                let end = range.endIndex
                var i = range.startIndex
                var ret = [Card]()
                while true {
                    if i == end { break }
                    ret.append(a[i])
                    i += 1
                }
                return CardArray(ret)
            }
        }
    }

    class Deck: CardArray {

        init() {
            var arr = [Card]()
            for suit in Suit.allValues {
                for rank in Rank.allValues {
                    arr.append(Card(rank: rank, suit: suit))
                }
            }
            super.init(arr)
        }

        override var description: String {
            get {
                return "Deck: \(super.description)"
            }
        }

        func shuffleInPlace() {
            self.a.shuffleInPlace()
        }

        func deal() -> [Hand] {
            let r = 0..<52
            let r1 = r.filter {$0 % 4 == 0}.map{ self[$0] }
            let r2 = r.filter {$0 % 4 == 1}.map{ self[$0] }
            let r3 = r.filter {$0 % 4 == 2}.map{ self[$0] }
            let r4 = r.filter {$0 % 4 == 3}.map{ self[$0] }

            var ret: [Hand] = []
            for ca in [r1,r2,r3,r4] {
                let h = Hand(input: ca)
                // a constant class can mutate a property
                h.sortInPlace()
                ret.append(h)
            }
            return ret
        }
    }

    class Hand: CardArray {

        init(input: [Card]) {
            super.init(input)
        }

        override var description: String {
            get {
                return "Hand: \(super.description)"
            }
        }
    }

We need some accessory functions in ``intstuff.swift``

.. sourcecode:: swift

    import Foundation

    func randomIntInRange(begin: Int, _ end: Int) -> Int {
        let top = Double((UInt32.max - 1)/2)
        let f = Double(random())/top
        let range = end - begin
        // we must convert to allow the * operation
        let result = Int(f * Double(range))
        return result + begin
    }

    func getNShuffledInts(n: Int) -> [Int] {
        var a = Array(Range(0..<n))
        for i in 0..<(n-1) {
            let j = randomIntInRange(i+1,n)
            // Swift.print("\(i), \(j)")
            swap(&a[i], &a[j])
        }
        return a
    }

    extension Array {
        func shuffled() -> [Element] {
            var a: [Element] = []
            let iL = getNShuffledInts(self.count)
            for i in iL {
                a.append(self[i])
            }
            return a
        }

        mutating func shuffleInPlace() {
            var a: [Element] = []
            let iL = getNShuffledInts(self.count)
            for i in iL {
                a.append(self[i])
            }
            self = a
        }
    }


To test it, we write a new ``main.swift``:

.. sourcecode:: swift

    func runTests(currentDeck: Deck) {
        test1()
        test2(currentDeck)
        test3(currentDeck)
    }

    func test1() {
        print("test1:")
        let c1 = Card(rank: .Ten, suit: .Spades)
        let c2 = Card(rank: .Ace, suit: .Spades)
        let c3 = Card(rank: .Jack, suit: .Diamonds)
        let c4 = Card(rank: .Two, suit: .Clubs)

        Swift.print("\(c2 > c1) \(c3 < c1) \(c4 < c1)")
        Swift.print("\(c2 > c3) \(c2 > c4)")
        Swift.print("\(c3 > c4)")

        let ca = CardArray([c1,c2,c3,c4])
        Swift.print("\(ca)")
        Swift.print("\(ca.a)")
        ca.sortInPlace()
        Swift.print("\(ca)")
    }

    func test2(currentDeck: Deck) {
        print("test2:")
        let d = Deck()
        Swift.print(d)

        d.sortInPlace()
        Swift.print("sorted:\n\(d)")

        d.shuffleInPlace()
        Swift.print("shuffled:\n\(d)")

        d.sortInPlace()
        Swift.print("sorted again:\n\(d)")

        Swift.print("current:\n\(currentDeck)\n")
    }

    func test3(currentDeck: Deck) {
        print("test3:")
        var hA = currentDeck.deal()
        for h in hA {
             Swift.print("\(h)")
        }
        Swift.print()

        let d = Deck()  // not shuffled
        d.shuffleInPlace()
        hA = d.deal()
        for h in hA {
            Swift.print("\(h)")
        }
    }

    let d = Deck()
    runTests(d)

Compile it:

.. sourcecode:: bash

    > swiftc intstuff.swift card.swift CardArray.swift -o prog -framework Foundation -sdk $(xcrun --show-sdk-path --sdk macosx) main.swift
    >
    
and then run it:

.. sourcecode:: bash

    > ./prog
    test1:
    true true true
    true true
    true
    T♠ A♠ J♦ 2♣
    [T♠, A♠, J♦, 2♣]
    A♠ T♠ J♦ 2♣
    test2:
    Deck: 2♣ 3♣ 4♣ 5♣ 6♣ 7♣  ...  9♠ T♠ J♠ Q♠ K♠ A♠
    sorted:
    Deck: A♠ K♠ Q♠ J♠ T♠ 9♠  ...  7♣ 6♣ 5♣ 4♣ 3♣ 2♣
    shuffled:
    Deck: T♣ 6♥ Q♣ J♣ 6♣ Q♥  ...  A♠ 2♥ 2♠ T♠ 3♥ K♥
    sorted again:
    Deck: A♠ K♠ Q♠ J♠ T♠ 9♠  ...  7♣ 6♣ 5♣ 4♣ 3♣ 2♣
    current:
    Deck: 2♣ 3♣ 4♣ 5♣ 6♣ 7♣  ...  9♠ T♠ J♠ Q♠ K♠ A♠

    test3:
    Hand: J♠ 7♠ 3♠ Q♥ 8♥ 4♥ K♦ 9♦ 5♦ A♣ T♣ 6♣ 2♣
    Hand: Q♠ 8♠ 4♠ K♥ 9♥ 5♥ A♦ T♦ 6♦ 2♦ J♣ 7♣ 3♣
    Hand: K♠ 9♠ 5♠ A♥ T♥ 6♥ 2♥ J♦ 7♦ 3♦ Q♣ 8♣ 4♣
    Hand: A♠ T♠ 6♠ 2♠ J♥ 7♥ 3♥ Q♦ 8♦ 4♦ K♣ 9♣ 5♣

    Hand: Q♠ 7♠ 6♠ A♥ Q♦ J♦ T♦ 8♦ A♣ 7♣ 6♣ 5♣ 3♣
    Hand: 5♠ 9♥ 3♥ 2♥ A♦ K♦ 9♦ 7♦ 6♦ K♣ T♣ 4♣ 2♣
    Hand: K♠ T♠ 8♠ 4♠ Q♥ J♥ T♥ 7♥ 4♦ 3♦ 2♦ Q♣ 9♣
    Hand: A♠ J♠ 9♠ 3♠ 2♠ K♥ 8♥ 6♥ 5♥ 4♥ 5♦ J♣ 8♣
    > 
    

The tests demonstrate our ability to generate a deck of cards, shuffle it, and then sort it.  Also, we can deal out four hands and would be ready for a real card game.

The command for compilation is complicated by the fact that we need Foundation.  (We need it to get random numbers to use in shuffling the deck).  When using this method, we need to tell the linker where to find the Foundation framework, in 

.. sourcecode:: bash

    > xcrun --show-sdk-path --sdk macosx
    /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.11.sdk
    >

