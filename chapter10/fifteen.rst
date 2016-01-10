.. _fifteen:

##############
Fifteen Puzzle
##############

Here is the Swift code for a puzzle app called Fifteen.  It looks like this:

.. image:: /figures/fifteen1.png
    :scale: 75 %

After tapping the square labeled 12:

.. image:: /figures/fifteen2.png
    :scale: 75 %

In this version, I have not yet implemented the proper alignment of the numbers in their squares (it's a pain, it changed in Swift 2 and I haven't figured it out yet).

The other missing piece is to shuffle the board properly to start a new game.  My understanding is that there are two sets of possible arrangements of the tiles:  only one set is solvable, or to think of it the other way around, only one set can be reached by legal moves from a solved starting board.  

The previous incarnation of the game (Objective-C) is here:

http://telliott99.blogspot.com/2011/02/fifteen.html

All that is required is to make a new Xcode project---a Cocoa Swift application.  In the nib set the ContentView of the window to be the class MyView, and then have this code in the project.

.. sourcecode:: swift

    import Cocoa

    class MyView: NSView {
        // both arrays have 0-based indexing
        var ra = Array<NSRect>()
        var a = Array(1...16)
        let outlineColor = NSColor.blackColor()
        let attr =  [
            NSFontAttributeName:NSFont(name: "Arial", size: 48.0)!,
            NSForegroundColorAttributeName:NSColor.blackColor() ]
            // as [String : AnyObject]
    
        override func awakeFromNib() {
            setUpRects()
        }

        override func drawRect(dirtyRect: NSRect) {
            Swift.print("drawRect")
            pprint()
            NSColor.whiteColor().set()
            NSRectFill(self.bounds)
        
            for (i,n) in a.enumerate() {
                let rect = ra[i]
                switch n {
                    case 16:  NSColor.grayColor().set()
                    case 2,4,6,8,10,12,14: NSColor.redColor().set()
                    default: NSColor.whiteColor().set()
                }
            
                NSBezierPath.fillRect(rect)
                NSBezierPath.setDefaultLineWidth(3)
                outlineColor.set()
                NSBezierPath.strokeRect(rect)
                let s = "\(n)"
                if !(n==16) {
                    let p = NSMakePoint(NSMidX(rect)-30,NSMidY(rect)-30)
                    s.drawAtPoint(p, withAttributes: attr )
                }
            }
        }
    
        func setUpRects() {
            let wd = bounds.width
            let ht = bounds.height
            let offset = CGFloat(20)
            let sq = min(wd,ht) - 2 * offset
            let u = sq/4
        
            // 0-based indexing for the rect array
            for i in 1...16 {
                let col = (i - 1) % 4
                let row = (16 - i) / 4
                let x = CGFloat(col) * u + offset
                let y = CGFloat(row) * u + offset
                let rect = NSMakeRect(x,y,u,u)
                ra.append(rect)
            }
        }
    
        override func mouseDown(theEvent: NSEvent) {
            for (i,r) in ra.enumerate() {
                if NSPointInRect(theEvent.locationInWindow, r) {
                    handleMouse(i)
                    return
                }
            }
        }
    
        func handleMouse(i: Int) {
            /*
            i is 0...15
            are we adjacent to blank square?
            switch to 1-based index
            */
            let L = adjacentSquares(i+1)
            for j in L {
                if a[j-1] == 16 {
                    swap(&a[i], &a[j-1])
                    break
                }
            }
            pprint()
            self.window!.display()
        }
    
        func adjacentSquares(i: Int) -> [Int] {
            if i == 1  { return [2,5] }
            if i == 2  { return [1,3,6] }
            if i == 3  { return [2,4,7] }
            if i == 4  { return [3,8] }
            if i == 5  { return [1,6,9] }
            if i == 6  { return [2,5,7,10] }
            if i == 7  { return [3,6,8,11] }
            if i == 8  { return [4,7,12] }
            if i == 9  { return [5,10,13] }
            if i == 10 { return [6,9,11,14] }
            if i == 11 { return [7,10,12,15] }
            if i == 12 { return [8,11,16] }
            if i == 13 { return [9,14] }
            if i == 14 { return [10,13,15] }
            if i == 15 { return [11,14,16] }
            if i == 16 { return [12,15] }
            return []
        }
    
        func pprint() {
            for n in a { Swift.print(n, terminator: " ") }
            Swift.print("")
        }
    }
