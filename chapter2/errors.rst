.. _errors:

******
Errors
******

    This section is not written yet

    import Foundation

    let b = false
    assert(b, "So b is not true!")
    exit(1)
    

.. sourcecode:: swift

    let b = false
    assert(b, "So b is not true!")




    guard let value = possibleNil else {leave scope}
    guard some condition else {continue}

    assert 
    check your code for errors

    precondition
    check that your clients have given you valid args
    
    try catch