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