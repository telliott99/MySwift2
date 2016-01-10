.. _closures_adv:

#####################
Even more on Closures
#####################

The description of closures given in the docs lists these advantages:

    Closures are self-contained blocks of functionality that can be passed around and used in your code. Closures in Swift are similar to blocks in C and Objective-C and to lambdas in other programming languages.

    Closures can capture and store references to any constants and variables from the context in which they are defined. This is known as closing over those constants and variables, hence the name "closures." Swift handles all of the memory management of capturing for you.

They go on:

    Global and nested functions, as introduced in Functions, are actually special cases of closures. Closures take one of three forms:

    -Global functions are closures that have a name and do not capture any values.
    
    -Nested functions are closures that have a name and can capture values from their en closing function.
    
    -Closure expressions are unnamed closures written in a light weight syntax that can capture values from their surrounding context.

So a key feature is that closures capture values from the environment when they are called.  Global functions don't do this.  Or they shouldn't.  However this:

.. sourcecode:: swift

    let s = "Hello"
    func f() { print(s) }
    f()
    
Actually does print ``Hello``.

In the next example, we return a function from a function.  The function's type is ``() -> ()``, that is, it takes no arguments and returns void.

.. sourcecode:: swift

    let s = "Hello"
    func f() -> () -> () {
        func g() {
             print(s)
        }
        return g
    }
    let h = f()
    h()
    
.. sourcecode:: bash
    
    > swift test.swift
    Hello
    >
    
We can modify it to eliminate the identifier ``g``:

.. sourcecode:: swift

    let s = "Hello"
    func f() -> () -> () {
        return { print(s) }
    }
    let h = f()
    h()
    
.. sourcecode:: bash
    
    > swift test.swift
    Hello
    >
    
The following also works, but I can't say I think it's a good idea:

.. sourcecode:: swift

    let s = "Hello"
    var x = 5
    func f() { 
        x += 1
        print(x) 
    }
    f()
    f()

.. sourcecode:: bash

    > swift test.swift
    6
    7
    >

A great example of progressive simplification of closures is the array ``sort`` function, which we call as a method on an array to be sorted, providing a comparison function as the second argument.  So to sort Strings you might write this code:

.. sourcecode:: swift

    func rev(s1: String, s2: String) -> Bool { return s1 > s2 }
    var a = ["a","b","c"]
    a.sortInPlace(rev)
    print(a)
    // [c, b, a]
    
To sort Ints *or* Strings, you could write a "generic" function, something like this:

.. sourcecode:: swift

    func rev <T:Comparable> (s1: T, s2: T) 
        -> Bool { return s1 > s2 }
    var a = ["a","b","c"]
    a.sortInPlace(rev)
    print(a)

    var b = [1, 2, 3]
    b.sortInPlace(rev)
    print(b)

.. sourcecode:: bash

    > swift test.swift
    ["c", "b", "a"]
    [3, 2, 1]
    >
    
but we'll hold off on those until :ref:`generics`.

In these examples, it does seem a bit long-winded to use a name for ``rev``, since we only put it immediately as the second argument to ``sorted``.  Use a closure:

.. sourcecode:: swift

    var names = ["Bob", "Alex", "Charlie"]
    names.sortInPlace {
         (s1: String, s2: String) -> (Bool)
         in return s1 > s2 }
    print(names)
    
    // [Charlie, Bob, Alex]

In fact, the docs say that the closure's argument types can *always* be inferred from the context when a closure is passed as an argument to another function.  In fact, the return type can be inferred as well.  So we can lose them and the compiler won't complain:

.. sourcecode:: swift

    var names = ["Bob", "Alex", "Charlie"]
    names.sortInPlace { s1, s2 in return s1 > s2 }
    print(names)

If the entire closure is a single expression, the return can also be omitted.

.. sourcecode:: swift

    var names = ["Bob", "Alex", "Charlie"]
    names.sortInPlace { s1, s2 in s1 > s2 }
    print(names)

Now admittedly, this is pretty brief.  

In addition to that, the ``in`` looks weird, so I try to suppress my instinct to parse its meaning, but I just try to remember that it means:  the closure body is beginning now.

As we saw in the previous section :ref:`closures_med`, we don't need variable names

.. sourcecode:: swift

    var names = ["Bob", "Alex", "Charlie"]
    names.sortInPlace { $0 > $1 }
    print(names)

Even passing in a lone operator will work!

.. sourcecode:: swift

    var names = ["Bob", "Alex", "Charlie"]
    names.sortInPlace(>)
    print(names)

This one requires the parentheses.

For a list of different ways to use closures in Swift, you might look here:

http://fuckingclosuresyntax.com

We covered most of these in the sort example above. 

A lot of the complexity (I mean brevity) comes from the compiler being able to infer argument types and return types, and even arguments and return values themselves, as well as being able to dispense with the call operator ``()`` in some cases.

At the top of the list in the web resource are these:

    - variable
    - typealias
    - constant

With this declaration syntax (``c`` is for closure, ``p`` for parameter, and ``r`` for return):

.. sourcecode:: swift

    var cName: (pTypes) -> (rType)
    typealias cType = (pTypes) -> (rType)
    let cName: closureType = { ... }

Let's start with a closure that takes a String argument and returns one as well:

.. sourcecode:: swift

    func f (name: String, _ myC: (String) -> String) -> String {
            let t = myC(name)
            return "*" + t + "*"
        }

    let result = f("Peter Pan", { s in "Hello " + s } )
    print(result)

.. sourcecode:: bash

    > swift test.swift
    *Hello Peter Pan*
    >

In this part of the above definition

.. sourcecode:: swift

    func f (name: String, _ myC: (String) -> String) -> String {

The last ``{`` is the beginning of the function, the last ``-> String`` is the functions return type, and the function's argument list consists of

.. sourcecode:: swift

    (name: String, _ myC: (String) -> String)

We can modify this example by using a ``typealias``, as follows

.. sourcecode:: swift

    typealias greeting = (String) -> (String)
    func f(name: String, _ myC: greeting) -> String {
        let t = myC(name)
        return "*" + t + "*"
    }

    let result = f("Peter Pan", { s in "Hello " + s } )
    print(result)

That helps, but only a little bit.  What helps more (though it makes things a little murkier), is being able to leave things out.  If the function doesn't return anything, we can do this:


(more)


One important usage is the Cocoa idiom to use blocks for callbacks from open and save panels.  In Objective C we have this method:

.. sourcecode:: objective-c

    [panel beginWithCompletionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton) {
                NSURL*  theFile = [panel URL];
                // Write the contents in the new format.
        }
    }];
    
The structure here is that the method takes an Objective C "block", similar to what we now know as closures in Swift.  The block's code is contained inside the method call, anonymously, comprising everything up to the ``}];``.

The second parameter is 

.. sourcecode:: objective-c

    completionHandler:^(NSInteger result) { }
    
An ``^(NSInteger result) { .. }`` defines a block that takes an ``NSInteger`` and doesn't return anything.  That's the type of block that this method on NSOpenPanel is declared to take, and the compiler looks for it.

If we're going to do this in Swift, we'll do something like

.. sourcecode:: swift

    func f (name: String, myC: (String) -> String) -> String {

from before, except our closure won't return anything and the method won't return anything either..

.. sourcecode:: swift

    panel.beginWithCompletionHandler(handler:###)

We need to replace the ``###`` with a block/closure that takes an NSInteger and doesn't return anything..

.. sourcecode:: swift

    let op = NSOpenPanel()
    op.prompt = "Open File:"
    op.title = "A title"
    op.message = "A message"
    // op.canChooseFiles = true  // default
    // op.worksWhenModal = true  // default
    op.allowsMultipleSelection = false
    // op.canChooseDirectories = true  // default
    op.resolvesAliases = true
    op.allowedFileTypes = ["txt"]

    let home = NSHomeDirectory()
    let d = home.stringByAppendingString("/Desktop/")
    op.directoryURL = NSURL(string: d)

    op.beginWithCompletionHandler( { (result: NSInteger) -> Void in
        if (result == NSFileHandlingPanelOKButton) {
            let theFile = op.URL
            print(theFile)
        }
    })

This used to work in a playground but not any more!  Paste it into an Xcode project).

Another example uses a "trailing" closure:

http://meandmark.com/blog/

.. sourcecode:: swift

    op.beginWithCompletionHandler { (result: NSInteger) -> Void in 
        if (result == NSFileHandlingPanelOKButton) {
            let theFile = op.URL
            println(theFile)
        }
    }

The method has no ``()`` call operator.

You can wrap everything from ``{ result: Int .. println(f) }}`` in parentheses like a regular method call, and that'll still work.

We can also separate the handler code from its invocation.  Define a variable to hold the ``handler``:

.. sourcecode:: swift

    var handler = { (result: Int) -> Void in
        if (result == NSFileHandlingPanelOKButton) {
            let f = op.URL
            println(f)
        }
    }

Put the above just after ``var op = NSOpenPanel()`` and call

.. sourcecode:: swift

    op.beginWithCompletionHandler(handler)

Or we could think about just turning it into a named function.

.. sourcecode:: swift

    func handler(result: NSInteger) {
        if (result == NSFileHandlingPanelOKButton) {
            let f = op.URL
            println(f)
        }
    }

That works.  And in this latter case, we can lose the return type of ``Void`` that seems to be required when we define ``handler`` as a closure.'

Note:  the function approach should not work, because according to the docs, a function should not be able to capture the variable ``op`` from the surrounding scope.  So fire up a new Xcode project (Swift-only) and let's see:

Stick this into the AppDelegate and call it from ``applicationDidFinishLaunching``:

.. sourcecode:: swift

    func doOpenPanel() {
        var op = NSOpenPanel()
        func handler(result: NSInteger) {
            if (result == NSFileHandlingPanelOKButton) {
                let f = op.URL
                Swift.print(f)
            }
            else {
                Swift.print("user cancelled")
            }
        }
        op.prompt = "Open File:"
        op.title = "A title"
        op.message = "A message"
        // op.canChooseFiles = true  // default
        // op.worksWhenModal = true  // default
        op.allowsMultipleSelection = false
        // op.canChooseDirectories = true  // default
        op.resolvesAliases = true
        op.allowedFileTypes = ["txt"]

        let home = NSHomeDirectory()
        let d = home.stringByAppendingString("/Desktop/")
        op.directoryURL = NSURL(string: d)
        op.beginWithCompletionHandler(handler)     
    }
    
It works.