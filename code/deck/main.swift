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