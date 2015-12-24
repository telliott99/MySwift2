.. _common_crypto_setup:

###########################
Setting up for CommonCrypto
###########################

We used some functions from the CommonCrypto (CC) library earlier.  This is not a framework, and so it takes a bit more work to have access to the functions defined there.  It is worth taking the time learning how to do that.

First of all, to use CC from a Swift App is pretty easy.  Make a new Xcode project, a Cocoa App in Swift called MyApp.

Obtain a bridging header by adding a dummy Objective-C file to the project, and accept when Xcode asks.

.. image:: /figures/header.png
   :scale: 100 %

Then delete the dummy file.  In the bridging header, add:

.. sourcecode:: objc

    #import <CommonCrypto/CommonCrypto.h>

That's it!  (No import needed in Swift).  Now we have access to CC symbols like

.. sourcecode:: swift

    Swift.print(CC_SHA1_DIGEST_LENGTH)

which prints ``20`` in the debugger.

With some additional effort, we can make CC available

    - in an Xcode project without the bridging header
    - in a framework
    - in an Xcode Playground
    - from the command line:  

``test.swift``:

.. sourcecode:: swift

    import CommonCrypto
    print(CC_SHA1_DIGEST_LENGTH)

.. sourcecode:: bash

    > swift test.swift
    20
    >

Now for the cool part. Deep within Xcode there are one (or more for some people) SDKs. Software Development Kits.

.. sourcecode:: bash

    > xcrun --show-sdk-path --sdk macosx
    /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform\
    /Developer/SDKs/MacOSX10.11.sdk

Copy that somewhere so it's all on one line, then you can feed it to the compiler with the ``-sdk`` flag in front.  Alternatively, get Xcode to do it for you with this invocation:

.. sourcecode:: bash

    -sdk $(xcrun --show-sdk-path --sdk macosx)

Now, deep within that is:

.. sourcecode:: bash

    > ls /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform\
    /Developer/SDKs/MacOSX10.11.sdk/System/Library/Frameworks
    AGL.framework
    AVFoundation.framework
    AVKit.framework
    Accelerate.framework
    ...

As I said, CommonCrypto is *not* a framework. But we can make it quack like it is one. We are going to make a directory in the same place as all these other ones within the SDK, call it CommonCrypto.framework and inside that put a file ``module.map`` with this listing

``module.map``:

    module CommonCrypto [system] {
    header "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform\
    /Developer/SDKs/MacOSX10.11.sdk/usr/include/CommonCrypto/CommonCrypto.h"
    header "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform\
    /Developer/SDKs/MacOSX10.11.sdk/usr/include/CommonCrypto/CommonRandom.h"
    export *
    }

Put the file on the Desktop for the moment.

Make sure there are no line breaks for the two statements above, I don't have them in my original.

Then do this:

.. sourcecode:: bash

    cd /Applications/Xcode.app/Contents/Developer\
    /Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.11.sdk\
    /System/Library/Frameworks
    > sudo mkdir CommonCrypto.framework
    Password:
    > sudo cp ~/Desktop/module.map CommonCrypto.framework
    >
    > cat CommonCrypto.framework/module.map 
    module CommonCrypto [system] {
    ...
    >

Having "corrupted" the SDK in this way, we are ready to roll