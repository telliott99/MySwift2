.. _characters:

**********
Characters
**********

A character is a Type in Swift.  You will typically initialize a single character with a String, like this:

.. sourcecode:: swift

    let c: Character = "a"
    
When iterating through a string, we first obtain a CharacterView, which is a special type of array of the characters, and go through each one with the for-in construct:

.. sourcecode:: swift

    for c in "abc".characters {
        print(c)
    }
    // prints:
    // a
    // b
    // c

To print all on one line you *could* do:

.. sourcecode:: swift

    for c in "abc".characters {
        print(c, terminator: ".")
    }
    print("\n")
    // prints:
    // a.b.c.

But best is probably:

.. sourcecode:: swift

    let cL = "abc".characters
    let s = String(cL)
    print(s)
    // prints:
    // abc

As in the above example, one can construct a String from its characters by calling a String initializer.  To put a single character onto the end of a String, you can do this:

.. sourcecode:: swift

    var s = "a"
    let c: Character = "b"
    s.append(c)
    print(s)
    // prints:
    // ab
    
As of Swift 2, the ``+=`` operator is only for String concatenation, so to use it with a Character we need to change the Character back into a String first:

.. sourcecode:: swift

    var s = "a"
    let b = Character("b")
    s += String(b)
    print(s)

Here is a quote from the docs:

    String and Character have been revised to follow the changes to Array, which clarifies that the + operator is only for "concatenation", not "append”. Therefore String + Character, Character + String, and String += Character, as well as the analogous Array + Element combinations, have been removed.
     
A note about the global ``print`` function.  (Changed from Swift 1).  ``print`` gives us a newline as the default.  To control this, you use an additional argument:

.. sourcecode:: swift
    
    let a = "a"
    print(a, terminator: "")    // a
    print(a)                    // a\n
    
-------
Unicode
-------

Swift is very modern when it comes to Unicode, even more so than NSString.

NextStep and NSString were designed around the time that Unicode was the a new thing, when it thought that 16 bits would be enough for every possible written character.  

So NSString values are 2 bytes.  Swift's String type are different.

Recall that in Unicode (virtually) every character that can be written is represented as a "code point", which is essentially just a mapping between numbers and glyphs.  Originally it was thought that two bytes (more than one million values), was enough to represent them all.  

Now some values are as much as three bytes.  Wikipedia

    Unicode comprises 1,114,112 code points in the range ``00`` to ``10FFFF``

A unicode code point comes in both decimal and binary equivalents, though binary is more usual.  From the docs:

    A Unicode scalar is any Unicode code point in the range U+0000 to U+D7FF inclusive or U+E000 to U+10FFFF inclusive. Unicode scalars do not include the Unicode surrogate pair code points in the range U+D800 to U+DFFF inclusive.

The question then becomes, how to represent Unicode characters in memory and on disk.  The apparent two byte limit argued for a two byte representation, but there are two different orders for the pair of single bytes, leading to big- and little-endian UTF-16 encoding.

(Mac x86_64 is little-endian, the low value byte of a 4 byte integer comes *first* in memory, so for example the eight bytes ``21000000`` evaluate to decimal 33).

It may be that since we managed pretty well with characters represented in a single byte (or even just 7 bits with ASCII)

http://en.wikipedia.org/wiki/ASCII

it was natural to develop the UTF-8 encoding.  UTF-8 is a **variable length** encoding, often taking only a single byte (when sufficient), but extending to two or three (or four) bytes when necessary.  It is much more compact, yet flexible.

http://en.wikipedia.org/wiki/UTF-8

So really the first issue that comes up with Unicode, after realizing that the representation is critical, is how to count length correctly as characters rather than as bytes when we have variable length, multibyte characters in the most common encoding ``NSUTF8StringEncoding``.

The second issue is that the same character may be formed in different ways (although this is fairly rare, it is not that rare).  We would like two such representations to compare as equal.

Let's look at length first.  

Here is an example of a String literal (``blackHeart``) formed from a Unicode scalar

.. sourcecode:: swift

    let blackHeart = "\u{2665}"
    print("I \(blackHeart) you")
    // prints:
    // I ♥ you

.. sourcecode:: swift

    let s = "♥"
    print(s.utf8, terminator: "")
    // prints:
    // ♥

That's not very helpful!  Try again

.. sourcecode:: swift

    let s = "♥"
    let a = Array(s.utf8)
    a
    // prints:
    // [226, 153, 165]


Here we have told the interpreter to explicitly convert the "String.UTF8View" obtained with ``s.utf8`` to an array.  It isn't absolutely clear to me what the type of these values is, but they could be unsigned integers UInt8 (values 0..255 inclusive), which is a common way of thinking about raw data.  

Accomplish the same thing in the Swift REPL:

.. sourcecode:: swift

    1> let s = "♥"
    s: String = "♥"
      2> for c in s.utf8 { print(c) }
    226
    153
    165
      3>

Another common representation is hex bytes:

.. sourcecode:: swift

    226/16 = 14 (e), 226 % 16 = 2
    153/16 = 9, 153 % 16 = 9
    165/16 = 10 (a), 165 % 16 = 5

Thus the UTF-8 representation of "♥" can also be written as ``e2 99 a5``.

Writing to disk has become complicated in Swift 2.  For the moment, I get around that by using a text editor, pasting in the "♥" character plus a newline and saving as ``x.txt``.

.. sourcecode:: bash

    > hexdump x.txt
    0000000 e2 99 a5 0a                                    
    0000004
    >

Our three bytes for "♥" are followed by ``0a``, which is the newline character "\n".

``hexdump`` prints the bytes but can't deal with the encoded "♥".

On the other hand, ``cat`` does OK  :)

.. sourcecode:: bash

    > cat x.txt
    ♥
    >

The default encoding here when we do the write is UTF-8.  (If you check the Preferences for your editor, you will see other possibilities).

The hex value ``e2 99 a5`` is the UTF-8 encoded value of the code point known as "BLACK HEART SUIT" (hex 2665, decimal 9829).  (For more detail on how ``9829`` is encoded as the value ``e2 99 a5`` see the Wikipedia article).

We can just think about "♥" as equivalent to the number 9829 or 0x2665.

To specify it in a Swift String, one way is to just paste "♥" into the code.  

Another way is to recall (or look up) its Unicode scalar value, which is typically written ``U+2665`` but in Swift is ``\u{2665}``.

As mentioned above, the official name for this character is:  "Unicode Character 'BLACK HEART SUIT' (U+2665)".  In html you can write it either as ``&#9829`` or ``&#x2665``.

Similarly, the "White smiling face"  ☺ is ``9786`` in Unicode, which in hexadecimal is ``U+263A``, and its UTF-8 encoding is ``e2 x98 ba``.
    
-------------------
Counting characters
-------------------

And now, the big question is, how many characters are there in ``blackHeart``?  

.. sourcecode:: swift

    let blackHeart = "\u{2665}"
    let n = blackHeart.characters.count
    print("\(blackHeart) has \(n) character.")
    
.. sourcecode:: bash

    > swift test.swift
    ♥ has 1 character.
    >

Three bytes in memory and on disk, but one character according to ``count``.

Expand the example:

.. sourcecode:: swift

    import Foundation

    var str = NSString(unicodeScalarLiteral: "\u{2665}")
    print(str.length)
    print(str.characterAtIndex(0))
    
NSString says:

.. sourcecode:: bash

    > swift test.swift
    1
    9829
    >

Seems like NSString counts correctly too, in this case, though when it yields the character it gives us back the decimal value of the Unicode code point in UTF-16!

Here is another example, from the docs, where the same character can be formed in two different ways:

.. sourcecode:: swift

    // é
    let eAcute: Character = "\u{E9}"

    // e followed by ́
    let combinedEAcute: Character = "\u{65}\u{301}"
    print("\(eAcute) \(combinedEAcute)")

    let s1 = String(eAcute)
    let s2 = String(combinedEAcute)

    print(s1.characters.count)
    print(s2.characters.count)
    print(eAcute == combinedEAcute)

.. sourcecode:: bash

    > swift test.swift
    é é
    1
    1
    true
    >

Now try the same thing with NSString.  Add this:

.. sourcecode:: swift

    import Foundation

    let s3 = NSString(string: s1)
    let s4 = NSString(string: s2)

    print("\(s3.length)")
    print("\(s4.length)")
    print(s3.isEqualTo(s4))

Now the combined output is:

.. sourcecode:: bash

    > swift test.swift
    é é
    1
    1
    true
    1
    2
    false
    >

So, the problem (solved by Swift and not by NSString) is how to deal with "extended grapheme clusters".  Such a cluster is a single character composed of multiple graphemes, such as ``"\u{65}\u{301}"``.

There used to be a global function ``countElements(s)`` that could be called on a String.  No more in Swift 2.  The reason is that the number of elements depends on your point of view:  are we talking about "characters", UTF-8, UTF-16, or "extended grapheme clusters"?

https://www.mikeash.com/pyblog/friday-qa-2015-11-06-why-is-swifts-string-api-so-hard.html

Let's try a menagerie of characters:

.. sourcecode:: swift

    let eAcute: Character = "\u{E9}"
    let combinedEAcute: Character = "\u{65}\u{301}"
    let blackHeart = "\u{2665}"
    let smiley = "\u{263a}"

    var s = "abc" + blackHeart + smiley
    s.append(eAcute)
    s.append(combinedEAcute)
    print(s)

.. sourcecode:: bash

    > swift test.swift
    abc♥☺éé
    >

Add this

.. sourcecode:: swift

    print(s.characters.count)
    print(s.utf8.count)
    print(s.utf16.count)
    print(s.unicodeScalars.count)
    print(Array(s.utf8))

.. sourcecode:: bash

    > swift test.swift
    abc♥☺éé
    7
    14
    8
    8
    [97, 98, 99, 226, 153, 165, 226, 152, 186, 195, 169, 101, 204, 129]
    >

7 characters, 14 UTF8 and 8 unicode scalars.

As explained in the Swift ebook:

    The length of an NSString is based on the number of 16-bit code units within the string’s UTF-16 representation and not the number of Unicode characters within the string. To reflect this fact, the length property from NSString is called utf16count when it is accessed on a Swift String value.
    
Finally, here is an example of incorporating characters into a String by using the string interpolation method:

.. sourcecode:: swift

    let dog: Character = "\u{1F436}"
    let cow: Character = "\u{1F42E}"
    let dogCow = "\(dog) \(cow)"
    print("\(dogCow)")
.. sourcecode:: bash

    > swift test.swift
    ������ ������
    >

If you want to convert a String to data (of UTF-8 encoding), one way is to do this:

.. sourcecode:: swift

    let dog = "\u{1F436}"
    for codeunit in dog.utf8 {
        print("\(codeunit) ")
    }
    print("")

    for codeunit in "Tom".utf8 {
        print("\(codeunit) ")
    }
    print("")

.. sourcecode:: bash

    > swift test.swift
    240 
    159 
    144 
    182 

    84 
    111 
    109 

    >

According to the book:

    You can access a UTF-8 representation of a String by iterating over its utf8 property. This property is of type UTF8View, which is a collection of unsigned 8-bit (UInt8) values, one for each byte in the string’s UTF-8 representation

