enum Token {
    case Number(Int)
    case Plus
}

class Lexer {
    enum Error: ErrorType {
        case InvalidCharacter(Character)
    }

    let input: String.CharacterView
    var position: String.CharacterView.Index

    init(input: String) {
        self.input = input.characters
        self.position = self.input.startIndex
    }

    func peek() -> Character? {
        guard position < input.endIndex
            else { return nil }
        return input[position]
    }

    func advance() {
        assert(position < input.endIndex,
            "cannot go past the end!")
        ++position
    }

    func getNumber() -> Int {
        var value = 0
        while let c = peek() {
            switch c {
            case "0" ... "9":
                let v = Int(String(c))!
                value = (10 * value) + v
                advance()
            default: return value
            }
        }
        return value
    }

    func lex() throws -> [Token] {
        var tokens: [Token] = []
        while let c = peek() {
            switch c {
            case "0" ... "9":
                let value = getNumber()
                tokens.append(.Number(value))
            case "+":
                tokens.append(.Plus)
                advance()
            case " ":
                advance()
            default:
                throw Error.InvalidCharacter(c)
            }
        }
        return tokens
    }
}

let s = "1 2 +"
let lx = Lexer(input: s)
do {
    let tokens = try lx.lex()
    print(tokens)
}
catch {
    print(error)
}