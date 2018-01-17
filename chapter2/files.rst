.. _files:

###############
File Operations
###############

Reading files is a bit more complicated than anything we have done so far.  In Swift 2, it involves use of ``do try catch``, like this:

.. sourcecode:: swift

    import Foundation  // for  NSUTF8StringEncoding

    var s: String = String()
    let filename = "x.txt"
    do {
        s = try String(
            contentsOfFile: filename,
            encoding: NSUTF8StringEncoding)
        print(s)
    }
    catch let error as NSError {
        print("Error: \(error.domain)")
    }
    
.. sourcecode:: bash

    > swift test.swift
    ♥
    >

We "try" to read the file, and enclose that in a "do" brace followed by "catch" to deal with the error, if there is one.

We will not really try to explain this line yet:

.. sourcecode:: swift

    catch let error as NSError

but essentially what we are doing is catching any kind of exception that is an NSError (or a Type derived from NSError) and printing the info it contains.

If the file we try to read doesn't exist, we would see:

.. sourcecode:: bash

    > swift test.swift
    Error: NSCocoaErrorDomain
    >
    
If we just print ``error`` rather than ``error.domain``:

.. sourcecode:: bash

    > swift test.swift
    Error: Error Domain=NSCocoaErrorDomain Code=260 "The file “z.txt” couldn’t be opened because there is no such file." UserInfo={NSFilePath=z.txt, NSUnderlyingError=0x7fd408f06590 {Error Domain=NSPOSIXErrorDomain Code=2 "No such file or directory"}}
    >

In the old days, we would have used a Foundation function to do this.

-------
Writing
-------

Here are two examples one with data and the other with text:

.. sourcecode:: swift

    let data = NSData(
        bytes: input,
        length: input.count)
    data.writeToFile(
        path, 
        atomically: true)

.. sourcecode:: swift

    do {
        try input.writeToFile(
            path,
            atomically: true,
            encoding: NSUTF8StringEncoding)
    }
    catch {
        print("oops")
    }
