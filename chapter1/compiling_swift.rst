.. _compiling_swift:

###############
Compiling Swift
###############

In order to compile Swift programs, you need Xcode, formally known as Xcode.app.

Currently, I have Xcode 7.2 (7C68).  

If you have more than one version, you can find out which one is currently selected as the default by:

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

The way I have done this forever is to do:

.. sourcecode:: bash

    > xcrun swift test.swift
    Hello Swift world
    >

Now, recently, I found that you can just do:

.. sourcecode:: bash

    > swift test.swift
    Hello Swift world
    >

Some other options are to run Swift as an "interpreter" or REPL (read-evaluate-print-loop) by just doing ``swift`` and then try out some code:

.. sourcecode:: bash

    > swift
    Welcome to Apple Swift version 2.1.1 (swiftlang-700.1.101.15 clang-700.1.81). Type :help for assistance.
      1> print("Hello, swift")
    Hello, swift
      2>
      
Alternatively, make the equivalent of a ``bash`` or ``python`` script.  Place this as the first line in your code 

    - ``#! /usr/bin/swift``

Make the file executable before trying to run it:

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
    
I have observed a few constructs that worked correctly by this last method and not by my standard one, but that was back in Swift 1 days.

As shown, a basic print statement is

.. sourcecode:: bash

    print("a string")
    
Notice the absence of semicolons.

One of several changes from Swift 1 to Swift 2 was to change to this way of doing a print statement.

One can also do "string interpolation", like this

``test.swift``:

.. sourcecode:: bash

    var n = "Tom"
    print("Hello \(n)")

.. sourcecode:: bash

    > swift test.swift 
    Hello Tom
    >

Variables are introduced with the ``var`` keyword, and are *typed*.  The type may be specified, with the type coming after the variable name).

.. sourcecode:: bash

    var s: String = "hello"

But the compiler can figure out what the type is most of the time, so it's not necessary or usual to specify it in this way.

.. sourcecode:: bash

    var s = "hello"

There is rarely any implicit conversion between types---except when doing ``print(anInt)`` or ``print(anArray)``.  

Here we print an Int:

``test.swift``:

.. sourcecode:: bash

    var x: Int = 2
    print(x)
    var s: String = String(x)
    print(s)
    
This works, and prints what you'd expect.  Going back the other way:

.. sourcecode:: bash

    let x = Int("2")

The type of x is an "Optional".  What this means is that the value may be ``nil`` (because the conversion failed).  

To use an optional, one must first unwrap it:

.. sourcecode:: bash

    let x = Int("2")
    let y = x! + 2
    print(y)
    // prints:
    // 4

If a value is not going to change (it's a constant), always use ``let``:

.. sourcecode:: bash

    let s = "Tom"
    print("Hello \(s)")

which also works, and prints what you'd expect.  