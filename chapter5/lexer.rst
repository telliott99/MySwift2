.. _lexer:

#####
Lexer
#####

I bought the Big Nerd Ranch book on Swift programming:

http://www.amazon.com/dp/0134398017

I like it pretty well.  It builds through the book to reach a pretty sophisticated level in the end.  (I *really* liked Aaron Hillegass's books on Objective-C).

On the other hand, there is one thing that I like to do differently, use examples that are stripped to the minimum in terms of identifiers:  ``f``, ``s``, ``i``, and so on.  Keep the distractions to a minimum.

I want to work through one example.  The BNR book builds a lexer, which processes text to identify and package valid "tokens" which comprise a stream of ints plus the addition operator.

It is mostly an exercise to show error handling.

My own simple-minded approach might be a two-pass solution where first we use a standard method to split a string into words:

.. sourcecode:: swift

    let s = "1 2 +"
    let a = s.characters.split{ $0 == " " }.map { String($0) }

Alternatively, we could actually go through each individual character:

.. sourcecode:: swift

    var ret: [String] = []
    var current: [Character] = []
    let space = Character(" ")

    for c in s.characters {
        if c == space {
            ret.append(String(current))
            current = []
        } else {
            current.append(c)
        }
    }
    ret.append(String(current))

This works as long as the first and last characters are not spaces.

Their approach is quite a bit fancier.  Here is a slightly modified version of what is in the book.

First of all, each word of the text will be converted to a Token, an enum which carries "type" information as well as the actual value.  A second enum follows the ErrorType protocol (which is actually an empty definition).

http://swiftdoc.org/v2.0/protocol/ErrorType/

The parser is an instance of a ``Lexer`` class, initialized with a CharacterView.

.. literalinclude:: lexer.swift
   :language: swift

.. sourcecode:: bash

    > swift test.swift
    [test.Token.Number(1), test.Token.Number(2), test.Token.Plus]
    >

