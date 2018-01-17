.. _swift_cocoaapp:

##########################
Cocoa Application in Swift
##########################

Fire up Xcode and just choose to make an OS X Cocoa application in Swift.

Xcode will generate the files for you.

.. sourcecode:: bash

    import Cocoa

    import Cocoa

    @NSApplicationMain
    class AppDelegate: NSObject, NSApplicationDelegate {

        @IBOutlet weak var window: NSWindow!

        func applicationDidFinishLaunching(aNotification: NSNotification) {
            // Insert code here to initialize your application
        }

        func applicationWillTerminate(aNotification: NSNotification) {
            // Insert code here to tear down your application
        }
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

Hook the button up to the ``AppDelegate`` in ``MainMenu.xib`` in the usual way.  Remember to first click on the window icon in the palette in the left center.  The main window for the application will become visible, so then drag a button onto the window and re-label it.  

CTL-drag from the button to the First Responder icon (Why not File's Owner? and where is AppDelegate?).  

.. image:: /figures/fileowner.png
   :scale: 100 %

CMD-R to build and run.  Push the button and observe in the console:

.. sourcecode:: bash

    button mashed!
    
We can find out a little about the ``sender``:

.. sourcecode:: bash

    print("\(sender.cell!)")
    
(It's an Optional).  This prints:

.. sourcecode:: bash

    Optional(<NSButtonCell: 0x6080000e1100>)

Buttons really aren't that interesting.  Here we do what we can, by changing the title that is displayed, alternating between "Push" and "Pull" each time the button is pushed:

.. sourcecode:: bash

    @IBAction func buttonMashed(sender: NSButton) {
        print("button mashed!")
        let t = sender.title
        print(t)
        if t == "Push me" {
            sender.title = "Pull me"
        }
        else {
            sender.title = "Push me"
        }
    }

In order to use ``title`` we have to explicitly set the class of sender to ``NSButton``.  Or we can add this

.. sourcecode:: bash

    let button = sender as! NSButton

And then work with ``button``.
    
Here is something a little more sophisticated.  

This project has the class of the main window's view set to be ``MyView``.  Just click on the window icon in the palette on the left, then on the window itself, until the class name as shown in the upper right in the "Identity Inspector" is ``NSView``.  Edit it.

Add a new Swift file to the project, with the same name.  Here is the code:

.. sourcecode:: bash

    import Cocoa

    class MyView : NSView {

        override func drawRect(dirtyRect: NSRect) {
            NSColor.lightGrayColor().set()
            NSRectFill(self.bounds)

            let r = NSMakeRect(50,50,50,50)
            let path = NSBezierPath(rect: r)
            NSColor.redColor().set()
            path.fill()

            let s = "abc"
            let f = NSFont(name: "Arial", size: 48.0)!
            // necessary to put diverse objects into the dict
            var D: [String: AnyObject] = [NSFontAttributeName: f]
            D[NSForegroundColorAttributeName] = NSColor.whiteColor()
            let p = NSMakePoint(50,150)
            s.drawAtPoint(p, withAttributes: D)

            let img = NSImage(named: "moon.png")!
            let sz = img.size
            // let p2 = NSMakePoint(75,75)
            let r2 = NSMakeRect(150,100,sz.width,sz.height)
            img.drawInRect(r2)
        }
    }

I dragged an image into the project file view:  "moon.png"

It can be hard to figure out what the new name of a function is, many of them are changed in Swift compared to what's in the docs, e.g. ``NSBezierPath(rect: r)``.  I paid attention to the suggestions that Xcode made as I was typing, and that helped.

.. image:: /figures/cocoaapp1.png
   :scale: 100 %
