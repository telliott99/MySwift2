.. _recursion:

#########
Recursion
#########

The code inside a function can call the same function again.  In principle, this might continue forever, but the operating system pulls the plug on us:

.. sourcecode:: swift

    func f(n: Int) {
        print(n)
        let m = n + 1
        f(m)
    }

    f(1)
    
.. sourcecode:: bash

    > swift test.swift 
    1
    ..
    104628
    Segmentation fault: 11
    >

That's a really deep stack!.  Python gives us 1000.

.. sourcecode:: python
    
    >>> def f(n):
    ...     print(n)
    ...     f(n+1)
    ... 
    >>> f(1)
    1
    ..
    999
    Traceback (most recent call last):
      File "<stdin>", line 1, in <module>
      File "<stdin>", line 3, in f
    ...
      File "<stdin>", line 3, in f
    RuntimeError: maximum recursion depth exceeded
    >>>

Recursion is a natural way to express certain problems.  The classic example is the factorial function:

.. sourcecode:: swift

    func factorial(n: Int) -> Int {
        if n == 0 || n == 1 {
            return 1
        }
        return n * factorial(n-1)
    }

    print(factorial(10))
    
    > swift test.swift 
    3628800
    >

I am tempted to try ``factorial(104627)``, but we will exceed ``Int.max`` pretty quickly.

A second fun example of recursion is binary exponentiation:

https://en.wikipedia.org/wiki/Exponentiation_by_squaring

The general observation is that for

- even x:  ``x^n = (x^2)^(n/2)``
- odd x:   ``x^n = (x^2)^(n-1)/2  * x``

A Python version:

.. sourcecode:: python

    import sys
    n,e = sys.argv[1:3]
    n,e = int(n), int(e)

    def exp_by_squaring(n,e):
        print "exp_by_squaring: n = %d, e = %d" % (n,e)
        if e < 0:   
            return exp_by_squaring(1.0/n, -e)
        if e == 0:  return 1
        if e == 1:  return n
        if e % 2 == 0:
            print "recurse:  exp_by_squaring(%d,%d)" % (n*n,e/2)
            return exp_by_squaring(n*n, e/2)
        print "recurse:  %d * exp_by_squaring(%d,%d)" % (n,n*n,(e-1)/2)
        return n * (exp_by_squaring(n*n, (e-1)/2))

    print exp_by_squaring(n,e)

.. sourcecode:: bash

    > python test.python 2 15
    exp_by_squaring: n = 2, e = 15
    recurse:  2 * exp_by_squaring(4,7)
    exp_by_squaring: n = 4, e = 7
    recurse:  4 * exp_by_squaring(16,3)
    exp_by_squaring: n = 16, e = 3
    recurse:  16 * exp_by_squaring(256,1)
    exp_by_squaring: n = 256, e = 1
    32768
    >

In Swift:

.. sourcecode:: swift

    func sqExp(n: Int, _ e:Int) -> Int {
        if e == 0 { return 1 }
        if e == 1 { return n }
        if e % 2 == 0 {
            return sqExp(n*n, e/2)
        }
        return n * sqExp(n*n, (e-1)/2)
    }

    print(sqExp(2,15))
    print(sqExp(5,23))

.. sourcecode:: bash

    > swift test.swift 
    32768
    11920928955078125
    >

