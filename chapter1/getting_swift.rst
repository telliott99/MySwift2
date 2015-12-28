.. _getting_swift:

#############
Getting Swift
#############

In order to write Swift programs, you will need Xcode, otherwise known as Xcode.app, and the tools that come with it.

Currently, I have Xcode 7.2 (7C68).  

One possibility is to use a "Playground" in Xcode.  These are great.  You can see how much possibility there is for these things if you take the tour

The only real limitation (although it's also a benefit) is that they are "sandboxed" so you can't load files from or write to the surrounding directory.

One thing that's always bothered me about Playgrounds is that they don't show the output for each step in a loop, by default.  But I learned recently you can do:

.. image:: /figures/show_debug.png
  :scale: 100 %

So

.. image:: /figures/debug.png
  :scale: 100 %

(In fact, the tiny icon at the lower left toggles the debug area on and off).

For my typical usage, I prefer to run Swift from the command line, in Terminal.

If you have more than one version of Xcode, you can find out which one is selected as the default by doing this in Terminal:

.. sourcecode:: bash

    > xcode-select -p
    /Applications/Xcode.app/Contents/Developer
    >

and you can set the path to the active Developer directory with:

.. sourcecode:: bash

    sudo xcode-select -s /Applications/Xcode7.app/Contents/Developer
    
Then, the following method will work.  

With this file on the Desktop

``test.swift``:

.. code-block:: swift

    print("Hello Swift world")

the way I have done this forever is to do:

.. sourcecode:: bash

    > xcrun swift test.swift
    Hello Swift world
    >

Recently, I found that you can just do:

.. sourcecode:: bash

    > swift test.swift
    Hello Swift world
    >

Some other options are to run Swift as an "interpreter" or REPL (read-evaluate-print-loop) by entering ``swift`` and then try out some code by typing or pasting it there:

.. sourcecode:: bash

    > swift
    Welcome to Apple Swift version 2.1.1 (swiftlang-700.1.101.15 clang-700.1.81). Type :help for assistance.
      1> print("Hello, swift")
    Hello, swift
      2>
      
Alternatively, make the equivalent of a ``bash`` or ``python`` script.  Place this as the first line in your code file:

    - ``#! /usr/bin/swift``

Make the file executable before trying to run it:

.. sourcecode:: bash

    > cp test.swift test
    > chmod u+x test
    > ./test
    Hello Swift world

And finally, one can compile and then run a file of swift code:

.. sourcecode:: bash

    > swiftc test.swift
    > ./test
    Hello Swift world
    >

or both steps at once

.. sourcecode:: bash

    > swiftc test.swift && ./test
    
I have observed a few constructs that worked correctly by this last method and not by my standard one, but that was back in Swift 1 days.

-----------
Basic Swift
-----------

As shown, a simple print statement is

.. code-block:: swift

    print("a string")
    
Notice the absence of semicolons.

One of several changes from Swift 1 to Swift 2 was to change to this way of doing a print statement (previously ``println`` or "print line", now not allowed).

One can also carry out what's called "string interpolation", like this

``test.swift``

.. code-block:: swift

    var n = "Tom"
    print("Hello \(n)")

.. sourcecode:: bash

    > swift test.swift 
    Hello Tom
    >

Variables are introduced with the ``var`` keyword, and are *typed*.  The type may be specified, with the type coming *after* the variable name, rather than before, as in other languages.

.. code-block:: swift

    var s: String = "hello"

But the compiler can figure out what the type is most of the time, so it's not necessary or usual to specify it in this way.

.. code-block:: swift

    var s = "hello"

There is only rarely any implicit conversion between types---one example is when doing ``print(anInt)`` or ``print(someArray)``.  

Here we print an Int:

``test.swift``:

.. code-block:: swift

    var x: Int = 2
    print(x)
    var s: String = String(x)
    print(s)
    
This works, and prints what you'd expect.  Going back the other way:

.. code-block:: swift

    let x = Int("2")

The type of x is an "Optional".  Optionals are a big topic in Swift programming.

For the moment, what this means is that the value of ``x`` may be ``nil`` because the conversion failed.  

To use an optional, one must first unwrap it (preferably after first testing to make sure it is not ``nil``):

.. code-block:: swift

    let x = Int("2")
    let y = x! + 2
    print(y)
    // prints:
    // 4

If a value is not going to change (it's a constant), always use ``let``:

.. code-block:: swift

    let s = "Tom"
    print("Hello \(s)")

which also works, and prints what you'd expect.  