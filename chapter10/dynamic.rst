.. _dynamic:

###################
Dynamic Programming
###################

The next example is a technique called "dynamic programming."  I've blogged about it here:

http://telliott99.blogspot.com/2009/06/dynamic-programming.html

The method was invented by Richard Bellman

https://en.wikipedia.org/wiki/Richard_E._Bellman

who explained its curious name by saying:  "[find the quote]".

An intermediate example is one of the Project Euler problems (# 18, see also # 67).

.. image:: /figures/maxpath.png
    :scale: 100 %

For the very simple example in the figure, we are asked to proceed from the top row to the bottom row, summing each value along the path, and find the maximum. There are 8 possible paths (2^(n-1)).  The path in red has the maximum value.  Project Euler # 18 has 15 rows and 16384 possible paths.  # 67 has 100 rows and 2^99 = 633825300114114700748351602688 possible paths = 6.33 e 29.

That's a lot of paths.

The trick is to start from the end.  Consider transitions from the second to the last row into the last row.  The first position is 2 and the choices are 8 and 5.  Since 10 is larger we choose to go "left" at this point.  

My solution is to save this state as a tuple containing the value, 2, the direction L, and an array of all the values obtained by following this path, [2,8].  The array isn't really necessary, but it allows us to skip the step of recapturing the values at the end, which we could do by following the path.

Here is my Python code to do this:

.. sourcecode:: python

    def solve(L):
        prev = [(n,"",[n]) for n in L.pop()]
        while L:
            sL = list()
            curr = L.pop()
            for i,n in enumerate(curr):
                tL = prev[i]
                tR = prev[i+1]
                if tL[0] > tR[0]:
                    v = n + tL[0]
                    path = 'L' + tL[1]
                    nL = [n] + tL[2]
                else:
                    v = n + tR[0]
                    path = 'R' + tR[1]
                    nL = [n] + tR[2]
                result = (v,path,nL)
                # print 'n', n, 'result', result
                sL.append(result)
            prev = sL
        return prev

    if __name__ == "__main__":
        L = [[3],
             [7,4],
             [2,4,6],
             [8,5,9,3]]

        rL = solve(L)
        print rL

It prints:

.. sourcecode:: bash

    > python simplesum.py 
    [(23, 'LRR', [3, 7, 4, 9])]
    >

And here is a straightforward translation of the code to Swift:

.. sourcecode:: swift

    var L = [[3],
             [7,4],
             [2,4,6],
             [8,5,9,3]]

    struct S {
        var v: Int
        var s: String
        var a: [Int]
    }

    let sL = L.removeLast()

    var prev: [S] = []
    for n in sL {
        let s = S(v: n, s: "", a: [])
        prev.append(s)
    }

    while L.count != 0 {
        let curr = L.removeLast()
        var t: S
        var sL: [S] = []
        var p: String
        for (i,n) in curr.enumerate() {
            let tL = prev[i]
            let tR = prev[i+1]
            if tL.v > tR.v {
                t = tL
                p = "L"
            }
            else {
                t = tR
                p = "R"
            }
            let st = S(v: t.v + n,
                       s: p + t.s,
                       a: [n] + t.a)
            sL.append(st)
        }
        prev = sL
    }

    let result = prev[0]
    print(result.v)
    print(result.s)
    print(result.a)

which prints:

.. sourcecode:: bash

    > swift dynamic.swift
    23
    LRR
    [3, 7, 4]
    >

One gratifying thing about this solution is that it runs unmodified on bigger problems:

.. sourcecode:: bash

    75
    95 64
    17 47 82
    18 35 87 10
    20 04 82 47 65
    19 01 23 75 03 34
    88 02 77 73 07 63 67
    99 65 04 28 06 16 70 92
    41 41 26 56 83 40 80 70 33
    41 48 72 33 47 32 37 16 94 29
    53 71 44 65 25 43 91 52 97 51 14
    70 11 33 28 77 73 17 78 39 68 17 57
    91 71 52 38 17 14 91 43 58 50 27 29 48
    63 66 04 68 89 53 67 30 73 16 69 87 40 31
    04 62 98 27 23 09 70 98 73 93 38 53 60 04 23

If this is saved in a file ``euler18.txt``, the Python code to solve it just uses what we had above:

.. sourcecode:: python

    from simplesum import solve

    def solve_file(fn):
        FH = open(fn)
        data = FH.read().strip().split('\n')
        FH.close()
        L = list()
        for line in data:
            sL = [int(e) for e in line.strip().split()]
            L.append(sL)
        return solve(L)

    if __name__ == "__main__":
        fn = 'euler18.txt'
        result = solve_file(fn)
        print result

I haven't yet translated this to Swift.  This prints:

.. sourcecode:: bash

    > python euler18mod.py 
    [(1074, 'RRLLRLLRRRRRLR', [75, 64, 82, 87, 82, 75, 73, 28, 83, 32, 91, 78, 58, 73, 93])]
    >


