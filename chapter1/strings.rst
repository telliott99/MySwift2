.. _strings:

#######
Strings
#######

Strings are fundamental to programming.

.. sourcecode:: bash

    var greeting = "Hello"
    greeting += " world"
    print(greeting)
    
.. sourcecode:: bash

    > swift test.swift 
    Hello world
    >

A Swift String presents a simple face to the world:  a sequence of characters that can be printed to the screen.

We can obtain a ``CharacterView`` from a String, by calling ``characters``, in order to examine its component characters:

.. sourcecode:: bash

    let greeting = "Hello"
    let cL = greeting.characters
    for c in cL { print(c) }   
     
.. sourcecode:: bash

    > swift test.swift 
    H
    e
    l
    l
    o
    >

Here, the "type" of ``greeting`` has been changed to constant String by using the ``let`` keyword, because we no longer intend to modify ``greeting``.

It works, although the ``print`` command also generates a newline each time we go through the ``for .. in`` loop.

We can add an extra argument ``terminator`` on line 3 in order to suppress the default newline that we would otherwise get with each call to ``print``:

.. sourcecode:: bash

    let greeting = "Hello"
    let cL = greeting.characters
    for c in cL { print(c, terminator: "-") }
    
.. sourcecode:: bash

    > swift test.swift 
    H-e-l-l-o->

but now we can see that our cursor is in the wrong place;  we have to add an additional ``print("")`` to obtain a newline at the very end.

.. sourcecode:: bash

    let greeting = "Hello"
    let cL = greeting.characters
    for c in cL { print(c, terminator: "-") }
    print("")
    
.. sourcecode:: bash

    > swift test.swift 
    H-e-l-l-o-
    >

``print()`` with no arguments is (unfortunately) an error!  

This is still not exactly right, I would like to suppress the final ``-``.

We could count our way through the loop:

.. sourcecode:: bash

    let greeting = "Hello"
    let cL = greeting.characters
    let n = cL.count - 1
    var i = 0

    for c in cL { 
        if i == n {
            print(c)
        }
        else {
            print(c, terminator: "-")
        }
        i += 1
    }
    
.. sourcecode:: bash

    > swift test.swift 
    H-e-l-l-o
    >

That gets to be a bit of a mess for what seemed like such a simple task.

Isn't there a cleaner solution?  Maybe we can get an entire "array" of characters and give it to ``joinWithSeparator``.

.. sourcecode:: bash

    let a = ["H","e","l","l","o"]
    let s = a.joinWithSeparator("-")
    print(s)
    
.. sourcecode:: bash

    > swift test.swift 
    H-e-l-l-o
    >

This works!  Unfortunately, it doesn't solve our original problem.  We constructed ``a`` to be an array of String values.  Our array of characters is a different type.

.. sourcecode:: bash

    let s = "Hello"
    let cL = s.characters
    let s2 = cL.joinWithSeparator("-")
    print(s2)

.. sourcecode:: bash

    > swift test.swift 
    test.swift:3:10: error: ambiguous reference to member 'joinWithSeparator'
    let s2 = cL.joinWithSeparator("-")
             ^~
    Swift.SequenceType:9:17: note: found this candidate
        public func joinWithSeparator<Separator : SequenceType where Separator.Generator.Element == Generator.Element.Generator.Element>(separator: Separator) -> JoinSequence<Self>
                    ^
    Swift.SequenceType:7:17: note: found this candidate
        public func joinWithSeparator(separator: String) -> String
                    ^
    >

This isn't going to work, obviously.  

Our problems come about because Swift is obsessed with keeping the distinction between Character and String.  We will see why in the next chapter.  It seems crazy, but that is the root of it.  

And so the question is, how to convert a CharacterView, which is not quite an Array of Character, [Character], into a [String]?

Google, and you will find.

The best solution I know is to convert each Character into a String.

.. sourcecode:: bash

    let s = "Hello"
    var a: [String] = []
    for c in s.characters {
        a.append(String(c))
    }
    let s2 = a.joinWithSeparator("-")
    print(s2)

We declare ``a`` to be an array of ``String``, and that it's variable, and that it will start out being empty ``= []``.  Then we loop through the characters, convert each one to a String, and add it to the array.
    
.. sourcecode:: bash

    > swift test.swift 
    H-e-l-l-o
    >

More compactly:

.. sourcecode:: bash

    let s = "Hello"
    let a = s.characters.map { String($0) }
    let s2 = a.joinWithSeparator("-")
    print(s2)
    
.. sourcecode:: bash

    > swift test.swift 
    H-e-l-l-o
    >

``map`` takes an array and goes through it, applying the function that is given---namely ``String($0)``---to each element.  Technically, this function is called a closure, and ``$0`` is a special way of referring to the element without giving it a name.

But that is getting ahead of ourselves.

Now that we've introduced map, I can show you a simple way to view the UTF-8 encoding of ``greeting``:

.. sourcecode:: bash

    let greeting = "Hello"
    let u = greeting.utf8
    let a = u.map { UInt8($0) }
    print(a)
    
.. sourcecode:: bash

    > swift test.swift 
    [72, 101, 108, 108, 111]
    >

--------------
String methods
--------------

Whereas in Objective-C we might ask an NSString for its length, in Swift the ``count`` property could differ depending on the view we are looking at:  whether its a CharacterView or the UTF-8 encoded form.  

For this reason, Swift does not provide a ``count`` method for a String.

But we can do this:

.. sourcecode:: bash

    var greeting = "Hello"
    print(greeting.characters.count)    // 5
    print(greeting.utf8.count)          // 5

The encoding (UTF-8) prints as a string, but it can also be viewed as a sequence of numbers.

To check identity, use the operator ``==``.  

Operators 
    - ``+``
    - ``+=``
    - ``==``
    - ``<``, ``>``

The reason for the last operators is to allow sorting of String values.

.. sourcecode:: bash

    print("Tom" > "Joan")
    // prints:  true

.. sourcecode:: bash

    let a = ["Tom", "Joan"]
    a.sort()
    // default sort uses <
    // a is now ["Joan", "Tom"]

-----------------
Splitting strings
-----------------

Something we do all the time in text processing is to split up a String into components, expecially the lines (separated by newlines ``\n``), or the words separated by " ".

If you need to split on a single character (like a space), one way to do it is to use an NSString method:

.. sourcecode:: bash

    import Foundation

    let s = NSString(string: "a b")
    s.componentsSeparatedByString(" ")
    // ["a", "b"]

A pure Swift implementation is a lot more complicated

.. sourcecode:: bash

    let s = "a\nb"
    let a = s.characters.split() { $0 == "\n" }.map {String($0) }
    a
    // ["a", "b"]

(If you need to split on all whitespace characters, see :ref:`stdin`).

This is a good thing to remember about Strings:

    Swift’s String type is bridged seamlessly to Foundation’s NSString class. If you are working with the Foundation framework in Cocoa or Cocoa Touch, the entire NSString API is available to call on any String value you create, in addition to the String features described in this chapter. You can also use a String value with any API that requires an NSString instance.

This helped me to finally figure out some things that had been confusing.  Without being explicit about the problems, the answer is that NSString methods are available to String variables, but *only* if we've done ``import Foundation``.

.. sourcecode:: bash

    import Foundation 

    let s = "Tom,Sean,Joan"
    let names = s.componentsSeparatedByString(",")
    print(names)

.. sourcecode:: bash

    > swift test.swift 
    [Tom, Sean, Joan]
    >

Not only is the ``NSString`` method called, but the type that is returned is a Swift ``[String]`` (also known as ``Array<String>``) rather than an Objective-C NSArray containing what appear to be NSString objects (but are actually something else, see the end of the book).

Another useful thing is that one can go back and forth between String and NSString pretty easily:

.. sourcecode:: bash

    import Foundation 
    let s: NSString = "supercalifragilistic"
    let r = NSRange(location:0,length:5)
    print(s.substringWithRange(r))
    // prints:  super

    import Foundation 
    let s: NSString = "supercalifragilistic"
    print(s.rangeOfString("cali"))    
    // prints:  (5,4)

The location is 5 and the length is 4.

Basic String methods:

    - ``isEmpty: -> Bool``
    - ``hasPrefix(s: String) -> Bool``
    - ``hasSuffix(s: String) -> Bool``
    - ``isEqual(s) -> Bool``
    - ``init(count: Int, repeatedValue c: Character)``

.. sourcecode:: bash

    let c = Character("a")
    let s = String.init(count: 5, repeatedValue: c)
    s
    // "aaaaa"
