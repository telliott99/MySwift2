.. _sort:

#######
Sorting
#######

A significant change in Swift 2 is the move to methods on a Type, rather than global functions.  So now we do:  ``array.sort()`` rather than ``sort(array)``.  In the Swift REPL, we first try with a constant array:

.. sourcecode:: swift

    1> let a = ["Chris", "Alex", "Barry"]
    a: [String] = 3 values {
      [0] = "Chris"
      [1] = "Alex"
      [2] = "Barry"
    }
      2> a.sort()
    $R0: [String] = 3 values {
      [0] = "Alex"
      [1] = "Barry"
      [2] = "Chris"
    }
      3> a
    $R1: [String] = 3 values {
      [0] = "Chris"
      [1] = "Alex"
      [2] = "Barry"
    }

The original constant array is unchanged and the call ``a.sort()`` returns the sorted array.  To sort "in place", we need a variable array, and call ``sortInPlace``.

.. sourcecode:: swift

    4> var b = a
    b: [String] = 3 values {
      [0] = "Chris"
      [1] = "Alex"
      [2] = "Barry"
    }
      5> b.sortInPlace()
      6> b
    $R2: [String] = 3 values {
      [0] = "Alex"
      [1] = "Barry"
      [2] = "Chris"
    }

A similar result is seen when invoking ``swift`` with an input file:

.. sourcecode:: swift

    let names = ["Chris", "Alex", "Barry"]
    let sorted_names = names.sort()
    print(names)
    print(sorted_names)

This prints:

.. sourcecode:: bash
    
    > swift test.swift
    ["Chris", "Alex", "Barry"]
    ["Alex", "Barry", "Chris"]
    >
If you ask to use the global ``sort`` function:

.. sourcecode:: swift

    7> sort(b)
    repl.swift:7:6: error: passing value of type '[String]' to an inout parameter requires explicit '&'
    sort(b)
         ^
         &

      7> sort(&b)
    repl.swift:7:1: error: 'sort' is unavailable: call the 'sortInPlace()' method on the collection
    sort(&b)
    ^~~~
    Swift.sort:10:13: note: 'sort' has been explicitly marked unavailable here
    public func sort<T : Comparable>(inout array: [T])
                ^

Taking the first suggestion leads to a second problem, that "'sort' has been marked explicitly unavailable"

``sort`` is non-mutating.  It returns the modified array, and leaves the original unchanged.  On the other hand, ``sortInPlace`` does what it says.
    
We are using a closure (with brackets ``{ }``) rather than a named function.  See (:ref:`closures_med`).

.. sourcecode:: swift

    var a = ["Chris", "Alex", "Barry"]
    a.sortInPlace { $0 < $1 }
    print(a)


One of the unusual properties of closures is that under certain circumstances (what is called a "trailing closure" as a single argument), there is no need for a call operator ``( )``, even though ``sortInPlace`` is being called with the closure as its argument.  

Here is a ``cmp`` function for Strings:

.. sourcecode:: swift

   func cmp(a: String, b: String) -> Bool {
       let m = a.characters.count
       let n = b.characters.count
       if m < n { return true }
       if m > n { return false }
       return a < b
   }

   let a = ["a","abc","c","cd"]
   print(a.sort(cmp))
   print(a.sort())

.. sourcecode:: bash

    > swift test.swift 
    ["a", "c", "cd", "abc"]
    ["a", "abc", "c", "cd"]
    >

We've sorted first by length and then lexicographically, as desired.