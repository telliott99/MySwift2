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
