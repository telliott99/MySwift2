.. _strings:

#######
Strings
#######

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

Not only is the ``NSString`` method called, but the type that is returned is a Swift ``[String]`` (also known as ``Array<String>``) rather than an Objective-C NSArray containing NSString objects.

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

A lot of the complexity of the String class comes from the nature of a String's component characters.  In the simplest case, above, a Character is a single ASCII character like "a".  The "a" is a string, but we construct a Character by calling the Character class initializer on "a".  We'll look at Characters in the next section.

To check identity, use the operator ``==``.  

Operators 
    - ``+``
    - ``+=``
    - ``==``
    - ``<``, ``>``

.. sourcecode:: bash

    print("Tom" > "Joan")
    // prints:  true

The reason for the last operator is to allow sorting of String values.

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
    let a = s.characters.split() {$0 == "\n"}.map{String($0)}
    a
    // ["a", "b"]

Let's look at Characters next.

(If you need to split on all whitespace characters, see :ref:`stdin`).
