.. _c_library:

########################
Working with a C library
########################

This section describes using C code from a Swift application.

We have our famous Add functionality

http://telliott99.blogspot.com/2015/12/swift-using-c-framework.html


``add1.c``:

.. sourcecode:: c

    #include <stdio.h>

    int f1(int x) {
        printf( "f1: %d;", x);
        return x+1;
    }

``add1.h``:

.. sourcecode:: c

    int f1(int);

Can we use this from Swift?  

https://developer.apple.com/library/ios/documentation/Swift/Conceptual/BuildingCocoaApps/MixandMatch.html

Make a new Xcode project, a Swift Cocoa application, called MyApp.

Add those two files to it, or do File > New > File and construct the files to contain that code.  When Xcode asks if you want a bridging header, say yes.

.. image:: /figures/header.png
   :scale: 100 %

In the bridging header (``MyApp-Bridging-Header.h``), put ``#import "C.h"``.

I also accepted some additional code that Xcode gave me for

``C.h``:

.. sourcecode:: c

    #ifndef C_h
    #define C_h

    #include <stdio.h>
    int f1(int);

    #endif /* C_h */

The app should build and run without error, though it won't use the new code yet.

Change ``AppDelegate.swift`` to be like this:

.. sourcecode:: swift

    func applicationDidFinishLaunching(aNotification: NSNotification) {
            let i = f1(2)
            Swift.print("  Swift: \(i)")
        }

The Debug window prints:

.. sourcecode:: bash

    f1: 2;  Swift: 3

If you read the docs, there might be an issue with paths.

    In Build Settings, in Swift Compiler - Code Generation, make sure the Objective-C Bridging Header build setting under has a path to the bridging header file.
    
    The path should be relative to your project, similar to the way your Info.plist path is specified in Build Settings. In most cases, you should not need to modify this setting.

I didn't need to do anything.

How about if we already have a library containing this code?  Maybe an old fashioned static library made with ``otool``.

.. sourcecode:: bash

    > clang -g -Wall -c add1.c
    > libtool -static add1.o -o libadd.a

We might previously have used this library by writing:

``useadd.c``

.. sourcecode:: bash

    #include <stdio.h>
    #include "add1.h"

    int main(int argc, char** argv){
        printf("  main %d\n", f1(1));
        return 0;
    }

.. sourcecode:: bash

    > clang -g -Wall -o useadd useadd.c -L. -ladd
    > ./useadd
    f1: 1;  main 2
    >

Now the goal is to write a Cocoa app that uses ``f1``. 

I thought at first we would need a framework, but we don't. Just copy ``libadd.a``

.. sourcecode:: bash

    cp libadd.a ~/Library/Frameworks

Make a new Xcode project MyOCApp, a Cocoa app in Objective C. 

Add the library to the project (by clicking + on Linked Frameworks and Libraries, and navigating to the directory with the framework, or by dragging the icon from ``~/Library/Frameworks``).

We still have the header issue. For this version using ``libadd.a`` I just dragged the header into the project, did copy items, and then did ``#import "add1.h"`` in either AppDelegate.h or AppDelegate.m.  Now add this code to ``applicationDidFinishLaunching:``

.. sourcecode:: bash

    printf("  main %d\n", f1(1));

Build and run, and the Debug window prints:

.. sourcecode:: bash

    f1: 1;  main 2

Now, for a Swift app that uses the C code.

I don't know how to make this work without using a real framework (i.e. how to use ``libadd.a``).  Let's try it all out in Objective-C, then we'll move on to Swift.

Make a new Xcode framework in Objective C, called Adder. Drag in ``add1.c`` and and do copy items. Put the (original) declarations from ``add.h`` into ``Adder.h`` which Xcode has provided. 

Build it. Use the Show in Finder trick to find and then drag the framework to the Desktop and then to ~/Library/Frameworks.

Test by trying to use the framework from the command line.  I specify the path to find the header folder which is in the framework.

.. sourcecode:: bash

    > clang -g -o useadd -F ~/Library/Frameworks/ -framework Adder useadd.c -I ~/Library/Frameworks/Adder.framework/Headers
    
And it works:

.. sourcecode:: bash

    > ./useadd
    f1: 1;  main 2
    >

Make a new Xcode Project for a Cocoa app in Objective-C. Call it MyOCApp. 

In ``AppDelegate.h`` do 

.. sourcecode:: objc

    #import <Adder/Adder.h>

Fix the error.  First add the framework to Linked Frameworks and Binaries.  The app should build and run now.  To use ``f1``, add the following:

.. sourcecode:: objc

    - (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
        printf("  AD %d\n", f1(1));
    }

Build and run, and the Debug window will show:

.. sourcecode:: bash

    f1: 1;  AD 2

Now, finally, for Swift.  

Make a new Xcode Project for a Cocoa app in Swift. Call it MyApp. In the AppDelegate do 

.. sourcecode:: swift

    import Adder

Fix the error that appears by dragging the framework to Linked Frameworks and Binaries.  The error should go away.  If not do CMD-Shift-K to "clean".

In ``applicationDidFinishLaunching`` add:

.. sourcecode:: swift

    let result = f1(10)
    Swift.print("\nSwift: \(result)")

Build and run the app.  In the Debug window, it prints

.. sourcecode:: bash

    f1: 10;
    Swift: 11

It works!
