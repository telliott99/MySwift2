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