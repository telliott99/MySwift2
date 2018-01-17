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

That's a really deep stack!.  Python gives us 999.

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

Recursion is a natural way to express the solutions to certain problems.  One classic example is the factorial function:

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

In Swift (without the command line arguments):

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

--------------
Tower of Hanoi
--------------

A last example of recursion is the Tower(s) of Hanoi

https://en.wikipedia.org/wiki/Tower_of_Hanoi

.. image:: /figures/towers.png
    :scale: 100 %

http://telliott99.blogspot.com/2009/08/towers-of-hanoi.html

The game consists of three pegs and a set of disks of decreasing size, say integral values from 4 to 1.  The fundamental restriction of the game is that a larger disk may never be placed on top of a smaller one.

The goal of the game is to move all the disks from the left peg to the right-hand one.  Symbolize the disks as o, oo, ooo, and oooo;  while the pegs are L, M, R.

For the n = 2 case, the moves are

- ``o ->  M``
- ``oo -> R``
- ``o ->  R``

We use the middle peg as a convenient place to cache an intermediate structure.

What about the n = 3 case?  

Move the disks o and oo in the same order as for n = 2, but with the middle peg as the target and the right-hand peg as the cache:

- ``o ->   R``
- ``oo ->  M``
- ``o ->   M``

Now move the triple-disk ooo to R.

- ``ooo -> R``

Finally, move the disks o and oo to R, with the left peg as the cache.

- ``o ->   L``
- ``oo ->  R``
- ``o ->   R``

To state the recursion in words:  if we know how to move (n-1) pegs, then we can move nth peg to the target.

- move n-1 pegs to the cache
- move the nth peg to the target
- move n-1 pegs to the target.

In thinking about this problem, I decided to first write a function to plot positions in the game:

.. sourcecode:: swift

    func hanoiRep(a_in: [Int], n: Int) -> [String] {
        func lineRep(v: Int, n: Int) -> String {
            let sp = Array(count:n-v, 
                     repeatedValue:" ").joinWithSeparator("")
            let dash = Array(count:v, 
                     repeatedValue:"-").joinWithSeparator("")
            return " \(sp)\(dash)|\(dash)\(sp) "
        }
        var a = a_in.sort(<)
        var ret = [String]()
        for _ in 0..<n {
            if a.count > 0 {
                let v = a.removeLast()
                ret.append(lineRep(v, n: n))
            }
            else {
                ret.append(lineRep(0, n: n))
            }
        }
        return ret.reverse()
    }

    func addTwo(a: [String], _ b: [String]) -> [String] {
        assert(a.count == b.count, "arrays must be the same size")
        var ret = [String]()
        for (s1,s2) in Zip2Sequence(a,b) {
            ret.append(s1 + s2)
        }
        return ret
    }

    func completeHanoiRep(left: [Int], _ middle: [Int], 
                        _ right: [Int]) -> String {
        func maxValue(a: [Int]) -> Int {
            var m = 0
            for v in a { 
                if v > m { 
                    m = v 
                } 
            }
            return m
        }
        let n = maxValue(left + middle + right)
        let s1 = hanoiRep(left, n: n)
        let s2 = hanoiRep(middle, n: n)
        var s = addTwo(s1,s2)
        let s3 = hanoiRep(right, n: n)
        s = (addTwo(s,s3))
        return s.joinWithSeparator("\n")
    }

    func test() {
        print("")
        var s = completeHanoiRep([1,2,3,4],[],[])
        print(s)
        print("\n----------------------------------\n")
        s = completeHanoiRep([3,4],[2],[1])
        print(s)
        print("\n----------------------------------\n")
        s = completeHanoiRep([4],[1,2],[3])
        print(s)
    }

    test()
    
.. sourcecode:: bash

    > swift test.swift 
    
        -|-         |          |     
       --|--        |          |     
      ---|---       |          |     
     ----|----      |          |     

    ----------------------------------

         |          |          |     
         |          |          |     
      ---|---       |          |     
     ----|----    --|--       -|-    

    ----------------------------------

         |          |          |     
         |          |          |     
         |         -|-         |     
     ----|----    --|--     ---|---  
    >

In order, these are the starting position, after the second move in n = 3 game, and after the fourth move in the same game.

A simple way to remember the rules for the game is that the piece to be chosen at each stage (oriented top to bottom and plotted in order left to right), the result is a binary ruler.

.. sourcecode:: bash

                  o
          o       o       o 
      o   o   o   o   o   o   o
    o o o o o o o o o o o o o o o

To form the next stage we would take this whole thing, then add 

.. sourcecode:: bash

    o
    o 
    o
    o
    o

then another copy of:

.. sourcecode:: bash

                  o
          o       o       o 
      o   o   o   o   o   o   o
    o o o o o o o o o o o o o o o

The result is:

.. sourcecode:: bash

                                  o
                  o               o               o
          o       o       o       o       o       o       o    
      o   o   o   o   o   o   o   o   o   o   o   o   o   o   o  
    o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o 
    

The other rule is that for odd numbered games the middle peg is the target for even numbered disks, and so on.

A much simpler representation is to print the arrays, e.g.:

.. sourcecode:: bash

    [4,3] [1] [2]

Maybe it's just me, but for something moderately complex like this problem, I find it easier to write a solution in Python, and then go back to Swift and look for ways to use Swift's unique features.

Here is a Python solution to the Tower of Hanoi problem.

.. sourcecode:: python

    def pprint():
        pL = []
        for k in 'LMR':
            pL.append(str(D[k]).ljust(20))
        print '\n'.join(pL)

    def validate(v, dst):
        for item in D[dst]:
            assert item > v

    def find_value(value):
        for k in D:
            if value in D[k]:
                return k

    def find_cache(src,dst):
        pD = { 'LM':'R', 'LR':'M', 'MR':'L' }
        k = ''.join(sorted([src,dst]))
        return pD[k]

    def move(value, dst='R'):
        print "move %s dst %s" % (value, dst)
        src = find_value(value)
        validate(value,dst)
        assert value == D[src].pop()
        D[dst].append(value)

    def solve(value,dst):
        pprint()
        print "solve value: %s" % value
        if value == 1:
            move(1, dst)
            return
        src = find_value(value)
        cache = find_cache(src,dst)
        print "src %s dst %s cache %s" % (src, dst, cache)

        solve(value-1,cache)
        move(value,dst)
        solve(value-1,dst)

    N = 3
    sL = range(1,N+1)
    sL.reverse()
    D = { 'L':sL,
          'M':[],
          'R':[] }

    solve(N,'R')
    pprint()
    
And here is what it prints for ``N = 3``:

.. sourcecode:: bash

    > cd ..
    > python test.py
    [3, 2, 1]           
    []                  
    []                  
    solve value: 3
    src L dst R cache M
    [3, 2, 1]           
    []                  
    []                  
    solve value: 2
    src L dst M cache R
    [3, 2, 1]           
    []                  
    []                  
    solve value: 1
    move 1 dst R
    move 2 dst M
    [3]                 
    [2]                 
    [1]                 
    solve value: 1
    move 1 dst M
    move 3 dst R
    []                  
    [2, 1]              
    [3]                 
    solve value: 2
    src M dst R cache L
    []                  
    [2, 1]              
    [3]                 
    solve value: 1
    move 1 dst L
    move 2 dst R
    [1]                 
    []                  
    [3, 2]              
    solve value: 1
    move 1 dst R
    []                  
    []                  
    [3, 2, 1]           
    >  
    
For ``N = 17`` it takes a while, but at the end it prints:

.. sourcecode:: bash

    solve value: 1
    move 1 dst R
    []                  
    []                  
    [17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1]
    >

According to wikipedia:

    The puzzle was invented by the French mathematician Édouard Lucas in 1883. There is a legend about a Vietnamese temple which contains a large room with three time-worn posts in it surrounded by 64 golden disks. The monks of Hanoi, acting out the command of an ancient prophecy, have been moving these disks, in accordance with the rules of the puzzle, since that time. The puzzle is therefore also known as the Tower of Brahma puzzle. According to the legend, when the last move of the puzzle is completed, the world will end.

Want to try ``N = 64``?