.. _characters:

**********
Characters
**********

A character is a Type in Swift and may be output as ``'a'`` for example, with single quotes, representing the single character a.  But as a programmer, you will not initialize a character with a literal character.  Instead do this:

.. sourcecode:: bash

    let c: Character = "a"
    
which converts the string ``"a"`` to the corresponding character.  

Or, when iterating through a string, we get CharacterView, which is a special type of array of the characters, and go through each one with the for-in construct:

.. sourcecode:: bash

    for c in "abc".characters {
        print(c)
    }
    // prints:
    // a
    // b
    // c

To print all on one line you *could* do:

.. sourcecode:: bash

    for c in "abc".characters {
        print(c, terminator: ".")
    }
    print("*")
    // prints:
    // a.b.c.*

But best is probably:

.. sourcecode:: bash

    let s = "abc"
    let s2 = String(s.characters)
    print(s2)
    // prints:
    // abc

As in the above example, one can put together a String from its characters by just calling a String initializer.  To put a single character onto the end of a String, you can do this:

.. sourcecode:: bash

    var s = "a"
    let c: Character = "b"
    s.append(c)
    print(s)
    // prints:
    // ab
    
As of recently, the ``+=`` operator is only for String concatenation, so we need to change the Character back into a String first:

.. sourcecode:: bash

    var s = "a"
    let b = Character("b")
    s += String(b)
    print(s)
    
     String and Character have been revised to follow the changes to Array, which clarifies that the + operator is only for "concatenation", not "append”. Therefore String + Character, Character + String, and String += Character, as well as the analogous Array + Element combinations, have been removed.
     
-------
Unicode
-------

Swift is very modern when it comes to Unicode, even more so than NSString.

NextStep and NSString were designed around the time that Unicode was the next new thing, but it was surely only going to be 16 bit.  So NSString's are 2 bytes.  Swift Strings are different.

Recall that in Unicode (virtually) every character that can be written is represented as a "code point", which is essentially just a mapping between numbers and glyphs.  Originally it was thought that 2e16, or two bytes (more than one million), was enough to represent them all.  

Now some values are as much as three bytes.  Wikipedia

    Unicode comprises 1,114,112 code points in the range ``00`` to ``10FFFF``

A unicode code point comes in both decimal and binary equivalents, though binary is more usual.  From the docs:

    A Unicode scalar is any Unicode code point in the range U+0000 to U+D7FF inclusive or U+E000 to U+10FFFF inclusive. Unicode scalars do not include the Unicode surrogate pair code points in the range U+D800 to U+DFFF inclusive.

The question then becomes, how to represent Unicode characters in memory and on disk.  The apparent two byte limit argued for a two byte representation, but there are two different orders for the pair of single bytes, leading to big- and little-endian UTF-16 encoding.

(Mac x86_64 is little-endian, the low value byte of a 4 byte integer comes *first* in memory, so for example ``21000000`` is the decimal 33).

It may be that since we managed pretty well with characters represented in a single byte (or even just 7 bits with ASCII)

http://en.wikipedia.org/wiki/ASCII

it was natural to develop the UTF-8 encoding.  UTF-8 is a **variable length** encoding, often taking only a single byte (when sufficient), but extending to two or three (or four) bytes when necessary.  It is much more compact, yet flexible.

http://en.wikipedia.org/wiki/UTF-8

So really the first issue that comes up with Unicode, after realizing that the representation is critical, is how to count length correctly as characters rather than as bytes when we have variable length, multibyte characters.

The second issue is that the same character may be formed in different ways (although this is fairly rare, it is not that rare), and we would like those two representations to compare as equal.

Let's look at length first.  

Here is an example of a String literal (``blackHeart``) formed from a Unicode scalar

.. sourcecode:: bash

    let blackHeart = "\u{2665}"
    print("I \(blackHeart) you")
    // prints:
    // I ♥ you
    
To keep things simple, I will copy this character and paste it into the Python interpreter:

.. sourcecode:: bash

    >>> s = "♥"
    >>> s
    '\xe2\x99\xa5'

The default encoding here when we do the paste is UTF-8.  The hex value ``e2 99 a5`` is the UTF-8 encoded value of the code point known as "BLACK HEART SUIT" (hex 2665, decimal 9829).  

.. sourcecode:: bash

    >>> h = '0x2665'
    >>> int(h,16)
    9829
    >>>

To specify it in a Swift String, one way is to recall (or look up) its Unicode scalar value, which is typically written ``U+2665``.  Python again:

    >>> s = "♥"
    >>> s
    '\xe2\x99\xa5'
    >>> unicode(s,'utf-8')
    u'\u2665'
    >>> s.decode('utf-8')
    u'\u2665'
    >>>

In order to interpret these three bytes, one must know the encoding (for say, two bytes, the result will be much different for UTF-16 versus UTF-8).

One could also write the data to disk and use ``hexdump``

.. sourcecode:: bash

    >>> s = "♥"
    >>> FH = open('x.txt','w')
    >>> FH.write(s)
    >>> FH.close()
    >>> 
    [2]+  Stopped                 python
    > hexdump -C x.txt
    00000000  e2 99 a5                                              
    |...|
    00000003
    >

As mentioned above, the official name for this character is:  "Unicode Character 'BLACK HEART SUIT' (U+2665)".  In html you can write it either as ``&#9829`` or ``&#x2665``.

Similarly, the "White smiling face"  ☺ is ``9786`` in Unicode, which in hexadecimal is ``U+263A``.

In Python, if I have the character as Unicode I convert it to UTF-8 before writing to disk:

.. sourcecode:: bash

    >>> u = unichr(9786)
    >>> u
    u'\u263a'
    >>> ord(u)
    9786
    >>> print u
    ☺
    >>> s = u.encode('utf-8')
    >>> s
    '\xe2\x98\xba'
    >>> FH = open('x.txt','w')
    >>> FH.write(s + "\n")
    >>> FH.close()
    >>> 
    [1]+  Stopped                 python
    > cat x.txt
    ☺
    >

In Swift, this is done as follows with ``.utf8``:

.. sourcecode:: bash

    let smiley = "\u{263a}"
    for codeUnit in smiley.utf8 {
        print("\(codeUnit) ", terminator: "")
    }
    print("")

.. sourcecode:: bash

    > xcrun swift test.swift 
    226 152 186 
    >
    
``226`` is the decimal value equal to ``e2``, and so on.  Python again:

.. sourcecode:: bash

    >>> hex(226)
    '0xe2'
    >>> hex(152)
    '0x98'
    >>> hex(186)
    '0xba'
    >>>
    
-------------------
Counting characters
-------------------

And now, the big question is, how many characters are there in ``blackHeart``?  

.. sourcecode:: bash

    let blackHeart = "\u{2665}"
    let n = blackHeart.characters.count
    print("\(blackHeart) has \(n) character.")
    
.. sourcecode:: bash

    > xcrun swift test.swift
    ♥ has 1 character.
    >

Three bytes in memory and on disk, but one character according to ``countElements``.

Expand the example:

.. sourcecode:: bash

    import Foundation

    var str = NSString(unicodeScalarLiteral: "\u{2665}")
    print(str.length)
    print(str.characterAtIndex(0))
    print(str.characterAtIndex(0))
    
NSString says:

.. sourcecode:: bash

    > xcrun swift test.swift
    1
    9829
    >

Seems like NSString counts correctly too, in this case, though when it yields the character it gives us back the decimal value of the Unicode code point.

Here is another example, from the docs, where the same character can be formed in two different ways:

.. sourcecode:: bash

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

    > xcrun swift test.swift
    é é
    1
    1
    true
    >

Now try the same thing with NSString.  Add this:

.. sourcecode:: bash

    import Foundation

    let s3 = NSString(string: s1)
    let s4 = NSString(string: s2)

    print("\(s3.length)")
    print("\(s4.length)")
    print(s3.isEqualTo(s4))

Now the combined output is:

.. sourcecode:: bash

    > xcrun swift test.swift
    é é
    1
    1
    true
    1
    2
    false
    >

So, the problem (solved by Swift and not by NSString) is how to deal with "extended grapheme clusters".  Such a cluster is a single character composed of multiple graphemes, such as ``"\u{65}\u{301}"``.

There used to be a global function ``countElements(s)`` that could be called on a String.  No more in Swift 2.  The reason is that the number of elements depends on your point of view:  are we talking about "characters", UTF8, UTF16, or "extended grapheme clusters"?

Let's try a menagerie of characters:

.. sourcecode:: bash

    let eAcute: Character = "\u{E9}"
    let combinedEAcute: Character = "\u{65}\u{301}"
    let blackHeart = "\u{2665}"
    let smiley = "\u{263a}"

    var s = "abc" + blackHeart + smiley
    s.append(eAcute)
    s.append(combinedEAcute)
    print(s)

.. sourcecode:: bash

    > xcrun swift test.swift
    abc♥☺éé
    >

Add this

.. sourcecode:: bash

    print(s.characters.count)
    print(s.utf8.count)
    print(s.utf16.count)
    print(s.unicodeScalars.count)
    print(Array(s.utf8))

.. sourcecode:: bash

    > xcrun swift test.swift
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

.. sourcecode:: bash

    let dog: Character = "\u{1F436}"
    let cow: Character = "\u{1F42E}"
    let dogCow = "\(dog) \(cow)"
    print("\(dogCow)")
.. sourcecode:: bash

    > xcrun swift test.swift
    ������ ������
    >

If you want to convert a String to data (of UTF-8 encoding), one way is to do this:

.. sourcecode:: bash

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

    > xcrun swift test.swift
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

