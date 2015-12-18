.. _compiling_swift:

###############
Compiling Swift
###############

In order to compile Swift programs, you need Xcode.app.  

Currently, I have Xcode 7.2 (7C68)).  

If you have more than one version, you can find out which one is selected by:

.. sourcecode:: bash

    > xcode-select -p
    /Applications/Xcode.app/Contents/Developer
    >

and you can set the default path to the active Developer directory with:

.. sourcecode:: bash

    sudo xcode-select -s /Applications/Xcode7.app/Contents/Developer
    
Then, the following method will work.  

With this file on the Desktop

``test.swift``:

.. sourcecode:: bash

    print("Hello Swift world")

.. sourcecode:: bash

    > xcrun swift Hello.swift
    Hello Swift world
    >

Some other options are to run swift as an "interpreter" by just doing ``swift`` and then try out some code:

.. sourcecode:: bash

    > swift
    Welcome to Apple Swift version 2.1.1 (swiftlang-700.1.101.15 clang-700.1.81). Type :help for assistance.
      1> print("Hello, swift")
    Hello, swift
      2>
      
or, place this as the first line in your code ``#! /usr/bin/xcrun swift``.  Make the file executable before running it:

.. sourcecode:: bash

    > cp test.swift test
    > chmod u+x test
    > ./test
    Hello Swift world

Another possibility is to use a "playground" in Xcode.  These are great.  The only real limitation (also a benefit) is that they are "sandboxed" so you can't load files from or write to the surrounding directory. 

And finally, one can compile and then run a file of swift code:

.. sourcecode:: bash

    > xcrun -sdk macosx swiftc test.swift
    > ./test
    Hello Swift world
    >

or both steps at once

.. sourcecode:: bash

    > xcrun -sdk macosx swiftc test.swift && ./test
    
I have observed a few constructs that work correctly by this last method and not by my standard one.

As shown above, a basic print statement is ``print("a string")`` or ``print("a string")``.  Notice the absence of semicolons.

One of several changes from Swift 1 to Swift 2 was to introduce this way of doing a print statement.

One can also do variable substitution, like this

``test.swift``:

.. sourcecode:: bash

    var n = "Tom"
    print("Hello \(n)")

.. sourcecode:: bash

    > xcrun swift test.swift 
    Hello Tom
    >

Variables are *typed* (with the type coming after the variable name) and there is rarely any implicit conversion between types (except when doing ``print(anInt)`` or ``print(anArray)``).  

Here we print an Int without any explicit conversion:

``test.swift``:

.. sourcecode:: bash

    var x: Int = 2
    print(x)
    var s: String = String(x)
    print(s)
    
This works, and prints what you'd expect.  If a value is not going to change (a constant), always use ``let``:

.. sourcecode:: bash

    let s = "Hello"
    print("\(s)")

which also works, and prints what you'd expect.  

The reason this works (without the ``:String`` type declaration is that the compiler can almost always infer type information from the context.

The usual Swift style would be:

.. sourcecode:: bash

    var x = 2
    var f = 1.23e4
    print(f)
    // prints:  12300.0
    >
