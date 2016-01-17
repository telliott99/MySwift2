.. _palindromes:

###########
Palindromes
###########

Just for fun, we look at palindromes in this section.  They are a common feature of the early Project Euler problems.

First, a function that returns an array of each digit in an Int as an ``[Int]``:

.. sourcecode:: swift

    func digits(n: Int) -> [Int] {
        var a = [Int]()
        var m = n
        while m > 0 {
            a.append(m % 10)
            m /= 10
        }
        return a
    }

    for i in [2, 11, 131, 132] {
        print("\(i) \(digits(i))")
    }

.. sourcecode:: bash

    > swift test.swift
    2 [2]
    11 [1, 1]
    131 [1, 3, 1]
    132 [2, 3, 1]
    >

Now we use the digits to test whether an Integer is palindromic:

.. sourcecode:: swift

    func isPalindrome(n: Int) -> Bool {
        if n < 10 { return false }
        let a = digits(n)
        let z = Array(a.reverse())
        return a == z
    }

    for i in [2, 11, 131, 132] {
        print("\(i) \(isPalindrome(i))")
    
.. sourcecode:: bash

    > swift test.swift
    2 false
    11 true
    131 true
    132 false
    >

There is an easier solution, however.  Just turn the Int into its String representation:

.. sourcecode:: swift

    func isPalindrome(s: String) -> Bool {
        let a = Array(s.characters)
        if a.count == 1 { return false }
        let z = Array(a.reverse())
        return a == z
    }

    for i in [2, 11, 131, 132] {
        n = String(i)
        print("\(i) \(isPalindrome(n))")
    }
    
.. sourcecode:: bash

    > swift test.swift
    2 false
    11 true
    131 true
    132 false
    >