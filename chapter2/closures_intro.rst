.. _closures_intro:

########
Closures
########

According to the docs:

    Closures are self-contained blocks of functionality that can be passed around and used in your code. Closures in Swift are similar to blocks in C and Objective-C and to lambdas in other programming languages.

Here is the docs' example where the comparison function is turned into a closure.  First, sorting with a function:

.. sourcecode:: swift

    let names = ["Chris", "Alex", "Barry"]

    func backwards(s1: String, _ s2: String) -> Bool {
        return s1 > s2
    }
    print(names.sort { backwards($0,$1) } )
    print(names)

.. sourcecode:: bash

    > swift test.swift 
    ["Chris", "Barry", "Alex"]
    ["Chris", "Alex", "Barry"]
    >

Notice that the array is not sorted in place.  Instead a copy is returned that is sorted.  Now for the closure version:

.. sourcecode:: swift

    let names = ["Chris", "Alex", "Barry"]
    let r = names.sort({ (s1: String, s2: String) -> Bool in return s1 > s2 })
    print(r)

.. sourcecode:: bash

    > swift test.swift 
    ["Chris", "Barry", "Alex"]
    >

Personally, I don't see what the big deal is here.  I prefer the named function for this one.

Where they do come in handy is for callbacks.  If we start a dialog to obtain a filename, we can pass into the dialog the code where we want execution to go after the name is obtained.

We'll have a lot more to say about closures later.  But you can think of a closure as a kind of unnamed function, typically passed into another function as an argument.