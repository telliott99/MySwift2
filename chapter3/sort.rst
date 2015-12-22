.. _sort:

#######
Sorting
#######

To obtain a sorted array using built-in methods, one can use either ``sort`` (in-place sort) or ``sorted`` (returns a new sorted array).  These used to be global functions in Swift 1, but now they should be called on a Collection like Array.

.. sourcecode:: bash

    let names = ["Chris", "Alex", "Barry"]
    let sorted_names = names.sort()
    print(sorted_names)   // ["Alex", "Barry", "Chris"]

.. sourcecode:: bash

    var a = ["Chris", "Alex", "Barry"]
    a.sortInPlace { $0 < $1 }
    print(a)
    
``sort`` is non-mutating.  It returns the modified array, and leaves the original unchanged.  On the other hand, ``sortInPlace`` does what it says.
    
We are using a closure (with brackets ``{ }``) rather than a named function.  See (:ref:`closures_med`).  

One of the unusual properties of closures is that under certain circumstances (what is called a "trailing closure" as a single argument), there is no need for a call operator ``( )``, even though ``sortInPlace`` is being called with the closure as its argument.  

Here is a ``cmp`` function for Strings:

.. sourcecode:: bash

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