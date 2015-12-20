.. _swift_cocoaapp:

##########################
Cocoa Application in Swift
##########################

Fire up Xcode and just choose to make a Swift-based application.

Xcode will generate the files for you.

.. sourcecode:: bash

    import Cocoa

    class AppDelegate: NSObject, NSApplicationDelegate {
                            
        @IBOutlet weak var window: NSWindow!

        func applicationDidFinishLaunching(aNotification: NSNotification?) {
            // Insert code here to initialize your application
            println("Got here!")
        }

        func applicationWillTerminate(aNotification: NSNotification?) {
            // Insert code here to tear down your application
        }

We get a hint from this how to deal with an IBOutlet.  

Notice the lack of header files, the only visible code file is ``AppDelegate.swift``.  (There are others to be seen if you expand the folders).

For an IBAction like a button push, just add something like this:

.. sourcecode:: bash

    @IBAction func buttonMashed(sender: AnyObject) {
        println("button mashed!")      
    }

For Objective C we would do

.. sourcecode:: objective-c

    - (IBAction)buttonMashed:(id)sender{

but ``id`` is replaced here by ``AnyObject``

Hook the button up to the ``AppDelegate`` in ``MainMenu.xib`` in the usual way.  Remember to first click on the window icon in the palette in the left center.  The main window for the application will become visible, so then drag a button onto the window and re-label it.  CTL-drag from the button to the AppDelegate icon.  CMD-R to build and run.  Push the button and observe in the console:

.. sourcecode:: bash

    button mashed!
    
We can find out a little about the ``sender``:

.. sourcecode:: bash

    println("\(sender.cell())")

prints

.. sourcecode:: bash

    <NSButtonCell: 0x6000000f3780>

Buttons really aren't that interesting.  Here we do what we can, by changing the title that is displayed, alternating between "Push" and "Pull" each time the button is pushed:

.. sourcecode:: bash

    @IBAction func buttonMashed(sender: NSButton) {
        println("button mashed!")
        var t = sender.title
        println(t)
        if t == "Push me" {
            sender.title = "Pull me"
        }
        else {
            sender.title = "Push me"
        }
    }

In order to use ``title`` we have to explicitly set the class of sender to ``NSButton``.
    
Here is something a little more sophisticated.  

.. image:: /figures/swiftapp3.png
   :scale: 75 %

This project has the class of the main window's view set to be ``MyView``.  Just click on the window icon in the palette on the left, then on the window itself, until the class name as shown in the upper right in the "Identity Inspector" is ``NSView``.  Edit it.

Add a new swift file to the project, with the same name.  Here is the code:

.. sourcecode:: bash

    import Cocoa

    class MyView : NSView {
    
        override func drawRect(dirtyRect: NSRect) {
            NSColor.lightGrayColor().set()
            NSRectFill(self.bounds)
        
            var r = NSMakeRect(50,50,50,50)
            var path = NSBezierPath(rect: r)
            NSColor.redColor().set()
            path.fill()
        
            var s = "abc"
            var f = NSFont(name: "Arial", size: 48.0)
            // necessary to put diverse objects into the dict
            var D: [String: AnyObject] = [NSFontAttributeName: f]
            D[NSForegroundColorAttributeName] = NSColor.whiteColor()
            var p = NSMakePoint(50,150)
            s.drawAtPoint(p, withAttributes: D)
        
            let img = NSImage(named: "moon.png")
            let sz = img.size
            let p2 = NSMakePoint(75,75)
            let r2 = NSMakeRect(150,100,sz.width,sz.height)
            img.drawInRect(r2)
        }
    }

It can be hard to figure out what the new name of a function is, many of them are changed in Swift compared to what's in the docs, e.g. ``NSBezierPath(rect: r)``.  I paid attention to the suggestions that Xcode made as I was typing, and that helped.

There is a trick with the dictionary definition ``var D: [String: AnyObject]``.

I added an image to the project by just drag and drop onto the file view (I think it's called a source list) at the very left, and then, with the file name selected, do File > Add, etc.  

.. image:: /figures/swiftapp2.png
   :scale: 75 %

The fancy image display function

.. sourcecode:: bash

    img.drawAtPoint(point: p2, fromRect: r2,
    operation: NSCompositeCopy, fraction: 1.0)

doesn't work because the symbol ``NSCompositeCopy`` (and its cousins), can't be found, yet are one of the required arguments.