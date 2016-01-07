.. _errors:

******
Errors
******

We discussed the ``do..try..catch`` idiom in :ref:`files`:

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

Trying to read the contents of a file, given a filename, is something that could easily fail.  Perhaps the file does not exist, or the user does not have the right permissions, or it is not valid UTF-8.  ``do..try..catch`` gives the opportunity to deal gracefully with an error.

The ``assert`` statement is meant as a check on programmer sanity.  It has the form

.. sourcecode:: swift

    assert(Bool, optional error message)

If the Bool is not true, code execution stops immediately, and the error message is printed.

.. sourcecode:: swift

    let b = false
    assert(b, "So b is not true!")
    
.. sourcecode:: swift

    import Foundation // for exit
    let b = false
    if !b {
        print("So b is not true!")
        exit(1)
    }

[ This section is not yet complete ]

.. sourcecode:: swift

    guard let value = possibleNil else {leave scope}
    guard some condition else {continue}

.. sourcecode:: swift

    precondition
    check that your clients have given you valid args

