.. _framework:

##########
Frameworks
##########

Frameworks are collections of reusable code, a more modern type of library.  Each individual framework 

    encapsulates shared resources, such as a dynamic shared library, nib files, image files, localized strings, header files, and reference documentation in a single package.

https://developer.apple.com/library/mac/documentation/MacOSX/Conceptual/BPFrameworks/Concepts/WhatAreFrameworks.html

We've used **Foundation** and **Cocoa** in this book.  A few frameworks are in ``~/Library/Frameworks`` and ``/Library/Frameworks``, but mainly they are in ``System/Library/Frameworks``.  Although Apple recommends that "third-party" frameworks should avoid installation in a user directory like ``~/Library/Frameworks`` we will explore this as our primary option, since we don't need ``sudo`` to write there.

Before we start, navigate to ``~/Library`` by holding down OPT as you click on Go in the Finder

.. image:: /figures/framework/library.png
   :scale: 100 %

or by doing CMD-SHIFT-G in the Finder and typing in ``~/Library``

.. image:: /figures/framework/fw1.png
   :scale: 100 %

and drag the Frameworks folder to the sidebar.

.. image:: /figures/framework/fw2.png
  :scale: 100 %

Then in Xcode:

OS X > New Project > Framework & Library > Cocoa Framework > Swift

.. image:: /figures/framework/fw3.png
   :scale: 100 %

Name it Speaker.  Add a new Swift file:

``speaker.swift``

.. sourcecode:: swift

    import Foundation

    public class Speaker {
        public init() {
        }
        public func speak() -> String {
            return "woof"
        }
        public func testSpeaker() {
            Swift.print("woof")
        }
    }

Build it.  Then, under products, find Speaker.framework.

.. image:: /figures/framework/fw4.png
   :scale: 100 %

do CTL-click, Show in Finder

.. image:: /figures/framework/fw5.png
   :scale: 100 %

you will see

.. image:: /figures/framework/fw6.png
   :scale: 100 %

and drag it into ``~/Library/Frameworks``.

Alternatively, just drag the framework icon to the Desktop and then do this in Terminal:

.. sourcecode:: bash

    cp -r SpeakerFramework.framework ~/Library/Frameworks
    
Substitute the following command, if you wish to use ``/Library/Frameworks``:

.. sourcecode:: bash

    sudo cp -r SpeakerFramework.framework /Library/Frameworks

Now for the app. In Xcode:

New Project > OS X > Application > Cocoa App > Swift

.. image:: /figures/framework/MyApp.png
   :scale: 100 %

Name it MyApp. In ``AppDelegate.swift`` add

.. sourcecode:: bash

    import SpeakerFramework
    
This import statement gives an error and the project will not build (No such module 'SpeakerFramework').

.. image:: /figures/framework/fw8.png
   :scale: 100 %

To fix this, select the MyApp project in the Project Navigator. 

.. image:: /figures/framework/project.png
   :scale: 100 %

In the tab view, select General and scroll to the bottom where it says Linked Frameworks and Libraries.

.. image:: /figures/framework/fw9.png
   :scale: 100 %

Click the + symbol below that line.

Click Add Other... 

.. image:: /figures/framework/addother.png
   :scale: 100 %

Then navigate to the framework in ``~/Library/Frameworks/Speaker.framework`` and select it.

Alternatively just drag the framework icon (from ``~/Library/Frameworks`` in Finder) onto the spot where it says "Add frameworks and libraries here".

The MyApp project now shows the framework in the General tab

.. image:: /figures/framework/addedfw.png
   :scale: 100 %

Go back to the AppDelegate. The warning should be gone.

.. image:: /figures/framework/nowarning.png
   :scale: 100 %

MyApp will build now. So let's use it. 

Edit the AppDelegate to instantiate a Speaker, and then call its speak method:

.. sourcecode:: swift

    import Cocoa
    import SpeakerFramework

    @NSApplicationMain
    class AppDelegate: NSObject, NSApplicationDelegate {
        @IBOutlet weak var window: NSWindow!

        func applicationDidFinishLaunching(aNotification: NSNotification) {
            let sp = Speaker()
            Swift.print(sp.speak())
        }

        func applicationWillTerminate(aNotification: NSNotification) {
        }
    }

In the Debug window, we can see the expected output:

.. image:: /figures/framework/woof.png
   :scale: 100 %

It would be nice to make a bigger statement. 

I'll just outline the steps briefly. Delete the default window in ``MainMenu.xib``. Add a new Cocoa class ``MainWindowController.swift``, subclassing NSWindowController. Have Xcode make the xib file too ``MainWindowController.xib``. Drag a label onto that window. Make it really, really big.

.. image:: /figures/framework/label.png
   :scale: 100 %

Hook it up to the new class (MainWindowController) as an IBOutlet (by doing the File's Owner trick), with this code for the AppDelegate:

.. sourcecode:: swift

    import Cocoa

    @NSApplicationMain
    class AppDelegate: NSObject, NSApplicationDelegate {

        @IBOutlet weak var window: NSWindow!


        var mainWindowController: MainWindowController?
    
        func applicationDidFinishLaunching(aNotification: NSNotification) {
            // Create a window controller with a XIB file of the same name
            let mainWindowController = MainWindowController()
        
            // Put the window of the window controller on screen
            mainWindowController.showWindow( self)
        
            // Set the property to point to the window controller
            self.mainWindowController = mainWindowController
        }

    }

and for MainWindowController:

.. sourcecode:: swift

    import Cocoa
    import SpeakerFramework

    class MainWindowController: NSWindowController {
    
        @IBOutlet weak var labelTextField: NSTextField!

        override func windowDidLoad() {
            super.windowDidLoad()
            let sp = Speaker()
            sp.testSpeaker()
            labelTextField.stringValue = sp.speak()
        }
    
        override var windowNibName: String {
            return "MainWindowController"
        }
    }

.. image:: /figures/framework/bigwoof.png
   :scale: 100 %

Pretty impressive:

If we select Products > MyApp.app, then show in the Finder, and drag it to the Desktop, and delete everything else except the framework in ~/Library/Frameworks, it still works. 

If we then do

.. sourcecode:: bash

    > mkdir ~/Library/Frameworks/tmp
    > mv ~/Library/Frameworks/Speaker.framework/ tmp
    > ls ~/Library/Frameworks
    >

.. image:: /figures/framework/problem.png
   :scale: 100 %

So it looks like everything MyApp depends on the copy of the framework that is in ``~/Library/Frameworks/Speaker.framework`` as expected.  Move the framework back to the right place and confirm that it starts working again.

