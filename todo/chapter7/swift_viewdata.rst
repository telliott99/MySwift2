.. _swift_viewdata:

##########################
Problem with View in Swift
##########################

I'm having trouble updating the data used to draw a View in Swift---the problematic classes are in the folder labeled ``notworking``  :)  .  Here is an attempt at a minimal example, but it does in fact work as intended.  Also, it demonstrates the use of font attributes.

Set up a new project in Xcode in the usual way, with Swift code.  Add a Cocoa class MyView and change the class of the window's ___ view in the nib to be MyView.

For the code use this:

.. sourcecode:: objective-c

    import Cocoa

    class MyView: NSView {
    
        var x: Int = 1
        override func drawRect(dirtyRect: NSRect) {
            super.drawRect(dirtyRect)
            var r: NSRect = self.bounds
            NSColor.whiteColor().set()
            NSRectFill(r)
            let s = String(x)
        
            let f = NSFont(name: "Arial", size: 48.0)
            var D: [String: AnyObject] = [NSFontAttributeName: f]
            // https://github.com/robb/swamp/blob/master/swamp.swift
            let paragraphStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy()
                as NSMutableParagraphStyle!
            paragraphStyle.alignment = NSTextAlignment.CenterTextAlignment
            D[NSParagraphStyleAttributeName] = paragraphStyle
            s.drawInRect(r, withAttributes:D)
        }
    
        override func mouseDown(theEvent: NSEvent) {
            x *= 2
            println(x)
            self.display()  // necessary
        }
    
    }

Here is a screenshot after I've clicked on the window a few times:

.. image:: /figures/binary_view.png
    :scale: 75 %
    
Here is another test that works:

.. sourcecode:: objective-c

    import Cocoa

    class MyView: NSView {
        var a :[Int] = [1,2,3]
    
        override func drawRect(dirtyRect: NSRect) {
            super.drawRect(dirtyRect)
            if a[1] % 2 == 0 {
                NSColor.purpleColor().set()
            }
            else {
                NSColor.yellowColor().set()
            }
            NSRectFill(self.bounds)
        }
    
        override func mouseDown(theEvent: NSEvent) {
            a[1] += 1
            println(a[1])
            self.display()
        }
    }