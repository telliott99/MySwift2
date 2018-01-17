.. _pointers:

#################
Pointers in Swift
#################

We saw some good examples of Swift pointers, used to work with a C library in _____.  I just discovered ``UnsafeBufferPointer`` (and its mutable cousin), which initialize with a count.  These guys allow use of the ``for .. in`` construct.


.. sourcecode:: swift

    var buffer: [UInt8] = [1,33,126,255]
    let p = UnsafeBufferPointer(start: buffer, count: 4)
    for n in p { print(n) }
    print("------")

    var p2 = UnsafeMutablePointer<UInt8>(buffer)
    print(p2.memory)
    p2++
    print(p2.memory)
    let p3 = p2 + 2
    print(p3[0])
    print("------")

    p2[0] = UInt8(55)
    for n in p { print(n) }

.. sourcecode:: bash

    > swift test.swift 
    1
    33
    126
    255
    ------
    1
    33
    255
    ------
    1
    55
    126
    255
    >

These pointers can do pointer arithmetic, and we can write to the buffer using them.

Here is an example where we add some C code that uses pointers to a Swift app, and then call those functions from Swift.

``p.c``

.. sourcecode:: c

    #include "p.h"

    void f1(int *ptr, int n) {
        printf("f1\n");
        for (int i = 0; i < n; i++) {
            printf("%d ", ptr[i]);
        }
        printf("\n");
    }

    int f2(int *ptr, int n) {
        printf("f2\n");
        for (int i = 0; i < n; i++) {
            int v = ptr[i];
            ptr[i] = v*v;
        }
        return 0;
    }

    int f3(int *ptr, double *ptr2, int n) {
        printf("f3\n");
        for (int i = 0; i < n; i++) {
            int v = ptr[i];
            ptr2[i] = sqrt(sqrt(v));
        }
        return 0;
    }

``p.h``

.. sourcecode:: c

    #include <stdio.h>
    #include <math.h>

    void f1(int *ptr, int n);
    int f2(int *ptr, int n);
    int f3(int *ptr, double *ptr2, int n);

Using this code from C, compiling on the command line.

``main.c``:

.. sourcecode:: c

    #include "p.h"

    int main(int argc, char* argv[]) {
        const int n = 5;
        int a[n] = { 1, 2, 3, 4, 5 };
        f1(a,n);
        f2(a,n);
        for (int i = 0; i < n; i++) {
            printf("%d ", a[i]);
        }
        printf("\n");
        double b[n];
        f3(a,b,n);
        for (int i = 0; i < n; i++) {
            printf("%3.2f ", b[i]);
        }
        printf("\n");
        return 0;
    }

It works:

.. sourcecode:: bash

    > clang -Wall p.c main.c -o prog
    > ./prog
    f1
    1 2 3 4 5 
    f2
    1 4 9 16 25 
    f3
    1.00 1.41 1.73 2.00 2.24 
    >

And the point is that the code to use this C "library" from Swift is trivial.  Make a new Xcode project, a Cocoa app in Swift.  

To keep path issues away, I simply added the C files ``p.c`` and ``p.h`` to a new Xcode Cocoa app project written in Swift. I get a bridging header in the usual way (by adding a dummy Objective-C file), and add to it a statement #import "p.h".

Put this code in a new Swift file (named whatever..):

.. sourcecode:: swift

    import Foundation

    func t() {
        let a: [Int32] = [1,2,3,4,5]
        let n = Int32(a.count)
        Swift.print("Swift: a = \(a)")

        let ptr = UnsafeMutablePointer<Int32>(a)
        f1(ptr, n)

        let i = f2(ptr, n)
        Swift.print("result2: \(i)")
        Swift.print("Swift: a = \(a)")

        let b: [Double] = [0, 0, 0, 0, 0]
        let ptr2 = UnsafeMutablePointer<Double>(b)
        let j = f3(ptr,ptr2,n)
        Swift.print("result3: \(j)")

        Swift.print("Swift b: ", terminator: "")
        for v in b {
        print(String(format: "%.3f", v), terminator: " ")
        }
    }

And in the debugger it prints:

.. sourcecode:: bash

    Swift: a = [1, 2, 3, 4, 5]
    f1
    1 2 3 4 5 
    f2
    result2: 0
    Swift: a = [1, 4, 9, 16, 25]
    f3
    result3: 0
    Swift b: 1.000 1.414 1.732 2.000 2.236