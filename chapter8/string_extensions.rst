.. _string_extensions:

#####################
Extensions for String
#####################

Moving to extensions on the String type, currently, the syntax 

.. sourcecode:: swift

    var s = "Hello, world"
    print(s[0...4])

doesn't work.  We can fix that with the following code, although it's probably not a good idea :)  :

.. sourcecode:: swift

    extension String {
        subscript(i: Int) -> Character {
            let index = startIndex.advancedBy(i)
            return self[index]
        }
        subscript(r: Range<Int>) -> String {
            let start = startIndex.advancedBy(r.startIndex)
            let end = startIndex.advancedBy(r.endIndex)
            return self[start..<end]
        }
    }
    var s = "Hello, world"
    print(s[4])
    print(s[0...4])
    
.. sourcecode:: bash

    > swift x.swift
    o
    Hello
    >

The Swift language does not provide the facility to just index into a String.  Instead, being prepared to deal gracefully with all the complexity of Unicode means that we are supposed to le-t the compiler generate a valid range for us.

Since ``r`` is a ``Range<Int>``, ``r.startIndex`` is just the first Int in the range.  However, the string indices are not Int values.  Hence, we ask for the ``self.startIndex`` and then use the range as a counter to advance it to where we want to be.

And after that we advance it to where we want to stop.  We really should do some bounds checking, or not?

In the next section we'll develop some extensions for the String type.

.. sourcecode:: swift

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

.. sourcecode:: swift

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

