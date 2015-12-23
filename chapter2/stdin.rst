.. _stdin:

#####
StdIn
#####

Here is an example of reading data from a file input on the command line in swift.  We first compile the swift code, and then execute it.  The listing for 

``test.swift``

.. sourcecode:: swift

    import Foundation

    func get_input() -> NSString? {
        let keyboard = NSFileHandle.fileHandleWithStandardInput()
        let inputData = keyboard.availableData
        let s = NSString(data: inputData, encoding: NSUTF8StringEncoding)
        return s
    }

    func convert_string(s: NSString) -> [Int]? {
        let cs = NSCharacterSet.whitespaceAndNewlineCharacterSet()
        let sa: [String] = s.componentsSeparatedByCharactersInSet(cs)
        var a: [Int] = Array<Int>()
        for c in sa {
            if let n = Int(c) {
                a.append(n)
            }
        }
        if a.count == 0 { return nil }
        return a
    }

    let s = get_input()
    if (s != nil) {
        let a = convert_string(s!)
        if (a != nil) {
            print(a!)
        }
    }

.. sourcecode:: bash

    > > swift test.swift < x.txt
    [1, 2, 3]
    >

Note:  if run without ``< x.txt``, it will hang, awaiting keyboard input.  I haven't figured out how to write to stdout conditionally to cover that case.