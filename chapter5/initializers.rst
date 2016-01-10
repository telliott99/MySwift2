.. _initializers:

############
Initializers
############

As mentioned before, Swift gives us a "free" default (member-wise) initializer.


.. sourcecode:: swift

    struct S {
        let x: Int
        let s: String
    }

    let s = S(x: 2, s: "str")
    print("s: \(s)")

.. sourcecode:: bash

    > swift test.swift 
    s: S(x: 2, s: "str")
    >

Suppose we decide to write our own initializer, that needs only an Int argument:

.. sourcecode:: swift

    struct T{
        let x: Int
        let s: String
        init(x: Int) {
            self.x = x
            s = "default"
        }
    }

    let t = T(x: 3)
    print("t: \(t)")

    /*
    error:
    let t2 = T(x: 4, s: "str")
    error: extra argument 's' in call
    */

.. sourcecode:: bash

    > swift test.swift 
    t: T(x: 3, s: "default")

As the annotation states, the commented code is an error.  The reason is that we have provided a custom initializer in the struct definition, so Swift no longer provides the default one.

If you want the default too, in this situation, you can add the custom initializer in an extension on the Type:

.. sourcecode:: swift

    struct S {
        let x: Int
        let s: String
    }

    extension S {
        init(x: Int) {
            self.x = x
            s = "default"
        }
    }

    let s2 = S(x: 5)
    print("s2: \(s2)")

    let s3 = S(x: 6, s: "str")
    print("s3: \(s3)")
    

.. sourcecode:: bash

    > swift test.swift 
    s2: S(x: 5, s: "default")
    s3: S(x: 6, s: "str")
    >