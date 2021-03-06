.. _range:

##################
Range and Interval
##################

Swift has the notions of intervals, ranges, and strides.

From StackOverflow

http://stackoverflow.com/questions/25308978/what-are-intervals-in-swift-ranges

    A Range type is optimized for generating values that increment through the range, and works with types that can be counted and incremented.

    An Interval type is optimized for testing whether a given value lies within the interval. It works with types that don't necessarily need a notion of incrementing, and provides [other] operations

    Because the ``..<`` and ``...`` operators have two forms each--one that returns a Range and one that returns an Interval --- type inference automatically uses the right one based on context.

Swift has both half-open and closed intervals and ranges.  A closed interval includes both endpoints, and a half-open one extends up to but does not include the top value.  In Swift you see half-open intervals most.  For example

.. sourcecode:: swift

    let r = 0..<5   // 0,1,2,3,4
    
``r`` is a ``Range<Int>``.

A Swift interval "contains" the values between two endpoints, but it does not know anything about iterating through the values or incrementing them.  An interval can even extend between one (or two) *non-integer* values, and a value of interest can then be tested for inclusion in the interval.

Here the type information isn't required, but I want to tell the compiler what we expect:

.. sourcecode:: swift

    let i1: ClosedInterval = 1...5
    print(i1.contains(3))
    // prints:  true

This doesn't work:  ``print(i1.contains(3.14159265))`` but the reason is that the interval is typed!  In the interpreter:

.. sourcecode:: swift

    1> let i = 1.5...3.5
    i: ClosedInterval<Double> = {
      _start = 1.5
      _end = 3.5
    }
      2> i.contains(3.14)
    $R0: Bool = true
      3>

A new operator ``~=`` can be used to do the ``contains`` test:

.. sourcecode:: swift

    let i1: ClosedInterval = 1...5
    print(i1.contains(3))
    print(i1 ~= 3)
    // both are true

The operators for ranges and intervals are the same.

.. sourcecode:: swift

    let r1: Range = 1...5
    let r2: Range = 1..<6
    r1 == r2
    // true

(The previously used half-open notation ``..`` has been replaced by ``..<``, which is definitely clearer).

To reverse a range, use ``reverse``

.. sourcecode:: swift

    let r: Range = 1...3
    for i in r.reverse() { print(String(i) + " ") }

.. sourcecode:: bash

    > swift test.swift
    3 
    2 
    1 
    >

There is also ``stride``, which is sort of like ``range`` in Python with the optional third argument.  In Swift:

.. sourcecode:: swift

    for i in 0.stride(through: -4, by: -2) {
      print(i)
    }

.. sourcecode:: bash

    > swift test.swift
    0
    -2
    -4
    >

The Swift "interpreter" REPL prints:

.. sourcecode:: swift

      5> let st = 0.stride(through: -4, by: -2)
    st: StrideThrough<Int> = {
      start = 0
      end = -4
      stride = -2
    }
    
Sequences can be generated lazily (only as needed for use), which is useful with very long ones.

.. sourcecode:: swift

    let r: Range = 1...3
    for i in r.lazy.reverse() {
        print(String(i) + " ")
    }

.. sourcecode:: bash

    > swift test.swift
    3 
    2 
    1 
    >

And finally:

.. sourcecode:: swift

    let x = 6
    switch (x) {
        case (5...10):
            print("OK")
        default:
            print("not in interval 5-10")
    }
    // OK

We will talk about ``switch`` statements a bit later.  I hope it is obvious how this works.

.. sourcecode:: swift

    let x = 6
    let y = 5

    switch (x,y) {
        case (5...10, 3...6):
            print("OK")
        default:
            print("not in specified intervals")
    }
    // also OK
