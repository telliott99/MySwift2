.. _errors:

******
Errors
******

This section is not completed yet

.. sourcecode:: swift

    import Foundation

    let b = false
    assert(b, "So b is not true!")
    exit(1)
    

.. sourcecode:: swift

    let b = false
    assert(b, "So b is not true!")

.. sourcecode:: swift

    guard let value = possibleNil else {leave scope}
    guard some condition else {continue}

.. sourcecode:: swift

    assert 
    check your code for errors

.. sourcecode:: swift

    precondition
    check that your clients have given you valid args

    .. sourcecode:: swift


    try catch