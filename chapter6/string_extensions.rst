.. _string_extensions:

#####################
Extensions for String
#####################
    
In this section we'll develop some extensions for the String type.

.. sourcecode:: bash

    extension String {

        func divideIntoChunks(chunkSize n: Int) -> [String] {
            var ret = [String]()
            let cL = self.characters
            if n >= cL.count { return [s] }

            let start = cL.startIndex
            var current = start
            var i = 0
            while true {
                // handle the last chunk
                if i + n >= cL.count {
                    let value = cL[Range(start: current,
                        end: cL.endIndex)]
                    ret.append(String(value))
                    break
                }
                // otherwise
                i += n
                let last = current.advancedBy(n)
                let value = cL[Range(start: current,
                    end: last)]
                ret.append(String(value))
                current = last
            }
            return ret
        }

        func insertSeparator(sep: String, every n: Int) -> String {
            let ret = self.divideIntoChunks(chunkSize: n)
            return ret.joinWithSeparator(sep)
        }

        func withNewlines(every n: Int) -> String {
            let ret = self.divideIntoChunks(chunkSize: n)
            return ret.joinWithSeparator("\n")
        }

        func splitOnNewlines() -> [String] {
            let a = self.characters.split() {$0 == "\n"}
            return a.map{ String($0) }
        }

        func withoutNewlines() -> String {
            let r = self.splitOnNewlines()
            return r.joinWithSeparator("")
        }

        func stripCharactersInList(cL: CharacterView) -> String {
            var a = [Character]()
            for c in self.characters {
                if cL.contains(c) { continue }
                a.append(c)
            }
            return a.map{ String($0) }.joinWithSeparator("")
        }
    }

    // test them:

    var s = "abcdefgh"
    for n in [2,3,9] {
        print(s.divideIntoChunks(chunkSize: n))
    }

    s = "abc \ndef"
    let s2 = s.stripCharactersInList(" \n".characters)
    print(s2)

.. sourcecode:: bash

    > swift test.swift
    ["ab", "cd", "ef", "gh"]
    ["abc", "def", "gh"]
    ["abcdefgh"]
    abcdef
    >

And some useful for dealing with hexadecimal strings:

.. sourcecode:: bash

    /*
    but first, a utility to print a UInt8
    255 -> "ff"
     10 -> "0a"
    */

    public func intToHexByte(n: UInt8) -> String {
        let s = NSString(format: "%x", n) as String
        if s.characters.count == 1 {
            return "0" + s
        }
        return s
    }

    /* e.g. "ff" -> 255 */

    public func singleHexByteStringToInt(h: String) -> UInt8 {
        let sL = h.characters.map { String($0) }
        assert (sL.count == 2, "not 2 character byte")

        func f(s: String) -> Int {
            let D = ["a":10,"b":11,"c":12,
                "d":13,"e":14,"f":15]
            if let v = D[s] { return v }
            return Int(s)!
        }

        let ret = f(sL.last!) + 16 * f(sL.first!)
        return UInt8(ret)
    }


    public func hexByteStringToIntArray() -> [UInt8] {
        let cL = " ".characters
        let s = self.stripCharactersInList(cL)
        let sL = s.divideIntoChunks(size: 2)
        return sL.map { singleHexByteStringToInt($0) }
    }

