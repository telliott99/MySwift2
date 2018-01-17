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