.. _str_extensions:

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

