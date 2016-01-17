enum Coin: Int {
    case penny = 1
    case nickel = 5
    case dime = 10
    case quarter = 25
    static let allValues = [penny,nickel,dime,quarter]
}

func == (lhs: S, rhs: S) -> Bool {
    return "\(lhs)"  == "\(rhs)"
}

struct S: CustomStringConvertible, Equatable, Hashable {
    var p: Int
    var n: Int
    var d: Int
    var q: Int
    var description: String {
        get {
            return "\(p)p \(n)n \(d)d \(q)q"
        }
    }
    var hashValue: Int {
        return p + n * 100 + d * 2000 + q * 200000
    }
    subscript(coin: Coin) -> Int {
        get {
            switch coin {
                case .penny:   return self.p
                case .nickel:  return self.n
                case .dime:    return self.d
                case .quarter: return self.q
            }
        }
        set {
            switch coin {
                case .penny:   self.p = newValue
                case .nickel:  self.n = newValue
                case .dime:    self.d = newValue
                case .quarter: self.q = newValue
            }
        }
    }
}
                 
func change(s: S, _ c1: Coin, _ c2: Coin) -> S? {
    var v1 = s[c1]
    var v2 = s[c2]
    // dime and quarter are special because need a nickel too
    if c1 == .dime && c2 == .quarter {
        if s[.nickel] < 1 || s[.dime] < 2 { 
            return nil
        }
        let v0 = s[.nickel] - 1
        v1 -= 2
        v2 += 1
        return S(p: s.p, n: v0, d: v1, q: v2)
    }
    else {
        if v1 * c1.rawValue < c2.rawValue { 
            return nil 
        }
        // we know the types of c1 and c2, find the other two
        let others = Set(coins).subtract(Set([c1,c2]))
        var rs = S(p: 0, n: 0, d: 0, q: 0)
        for c in others {
            rs[c] = s[c]
        }
        rs[c1] = v1 - c2.rawValue/c1.rawValue
        rs[c2] = v2 + 1
        // print("rs \(rs)")
        return rs
    }
}
