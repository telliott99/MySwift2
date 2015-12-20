.. _from_objc:

######################
Swift from Objective C
######################

When I saw the syntax of the Swift Programming Language, I immediately liked it.  More like Python, and not at all like Objective C.  However, looks can be deceptive, Objective C is fairly simple, while Swift is surprisingly complex.

http://www.bignerdranch.com/blog/ios-developers-need-to-know-objective-c/

I wanted to implement an example of a class written in Swift, but called from an Objective C class.  This required a few key points that I didn't quite get from the Apple docs, so here they are.

Create a new Xcode project, a Cocoa Application

.. image:: /figures/swift1.png
   :scale: 75 %

and call it "MyProject".

.. image:: /figures/swift2.png
   :scale: 75 %

Accept the defaults (Cocoa Application, files in the Document directory).

Under File > New > File, add a new Swift File

.. image:: /figures/swift3.png
   :scale: 75 %

and name it "MyFile.swift".  

.. image:: /figures/swift4.png
   :scale: 75 %

When asked if you want to create headers, say yes.

.. image:: /figures/swift5.png
   :scale: 75 %

Check by building and running, yep, it still works.  Now, add some code to 

``MyFile.swift``:

.. sourcecode:: bash

    import Foundation

    @objc class MySwiftClass : NSObject {
        func myFunc() -> String {
            return "hello"
        }
    
    }

    func test() {
        var obj = MySwiftClass()
        println(obj.myFunc())
    }

    test()

You can test a version of it from the command line (with the code saved in ``test.swift``) by

.. sourcecode:: bash

    > xcrun swift test.swift
    hello
    >

Before going any further, comment out the last line:  ``// test()``.

Notice two crucial features, we have "decorated" (if that's the right word in Swift) our class ``MySwiftClass`` with ``@objc``.  And this class inherits from ``NSObject`` (hence the ``import Foundation``).

Now switch the editor to ``AppDelegate.h``.  

Just after the line ``#import <Cocoa/Cocoa.h>`` put this:

.. sourcecode:: bash

    #import "MyProject-Swift.h"

    @class MySwiftClass;

and then after that should come what was already there, ``@interface`` and the rest of it.

Finally, add this to ``applicationDidFinishLaunching``:

.. sourcecode:: bash

    NSLog(@"Got here!");
    MySwiftClass* obj = [[MySwiftClass alloc] init];
    NSString* s = [obj myFunc];
    NSLog(@"%@", s);

If you have any issues, try "clean".  For me, the console prints:

.. sourcecode:: bash

    014-08-18 19:31:45.903 MyProject[2698:303] Got here!
    2014-08-18 19:31:45.903 MyProject[2698:303] hello

This only took me 4 or 5 hours to figure to get working.  I'm not sure yet that I have it really figured out.  One of the problems is that I couldn't find a model as simple as this on the web or in the Apple docs.

The other is something you just have to get used to with a compiler that is sophisticated as what is in Xcode.  The error messages are often downright misleading.  I didn't save them but I was told repeatedly that ``[[MySwiftClass alloc] init];`` was just *wrong*, and yet look, there it is in the final product.

The key sticking points were

    - the decorator @objc
    - inheriting from NSObject (to get alloc and init)
    - ``@class MySwiftClass;`` in the Objective C header
    
Only this part (``#import "MyProject-Swift.h"``) was clear from quick reading of the docs.