.. _fifteen:

##############
Fifteen Puzzle
##############

Here is the Swift code for a puzzle app called Fifteen.  It looks like this:

.. image:: /figures/fifteen.png
    :scale: 75 %
    
Its previous incarnation is here:

http://telliott99.blogspot.com/2011/02/fifteen.html

There is a single subclass of ``NSView``, set up in the usual way.  The idea is that each of the sixteen squares occupies a fixed position in an array (indexed 0...15 as usual).  To make a move, we exchange the ``title`` attributes of the current black square with the one that's been chosen to be next.

One issue is that it is possible to make puzzles that can't be solved.  I forget at the moment what the invariant is, but the way I solve it here is to make 500 legal moves at random, starting from a solved position.  The Xcode project is in the ``projects`` folder.

.. sourcecode:: objective-c

    import Cocoa

    struct S {
        let i: Int
        var title: String
        let r: NSRect
        mutating func changeTitle(s: String) {
            title = s
        }
    }

    class MyView: NSView {
        var a = Array<S>()
        var blank = 16
    
        override func awakeFromNib() {
            setUpSquares()
            for i in 1...500 { shuffle() }
        }
    
        func shuffle() {
            let near = adjacentSquares(blank)  // 1-based
            let r = arc4random_uniform(UInt32(near.count)) // 0-based
            let next = near[Int(r)]            // 1-based
            switchSquares(next,j:blank)        // 1-based
        }
    
        func setUpSquares() {
            let wd = self.bounds.width
            let ht = self.bounds.height
            let offset = CGFloat(20)
            let sq = min(wd,ht) - 2 * offset
            let u = sq/4
            var tmp = [S]()
            for i in 1...16 {
                let col = (i - 1) % 4
                let row = (16 - i) / 4
                let x = CGFloat(col) * u + offset
                let y = CGFloat(row) * u + offset
                let r = NSMakeRect(x,y,u,u)
            
                var s: String
                if i != blank { s = String(i) }
                else { s = "" }
                var st = S(i:i, title:s, r:r)
            
                tmp.append(st)
            }
            a = tmp
        }
    
        func prettyPrint(s:String, a: [S]) {
            var t = ""
            for st in a {
                let title = st.title
                if title == "" { t += "* " }
                else { t +=  st.title + " " }
            }
            println(s + t)
        }

        override func drawRect(dirtyRect: NSRect) {
            NSColor.whiteColor().set()
            NSRectFill(self.bounds)
            //println("drawRect")
            var tmp = a
            for (i,st) in enumerate(tmp) {
                NSColor.redColor().set()
                let p = NSBezierPath(rect: st.r)
                p.stroke()
                drawInRect(st)
            }
        }
    
        func drawInRect(st: S) {
            let s = st.title
            let r = st.r
            let f = NSFont(name: "Arial", size: 48.0)
            // necessary to put diverse objects into the dict
            var D: [String: AnyObject] = [NSFontAttributeName: f]
            let t = st.title
            var color = NSColor.blackColor()
            let n = t.toInt()
            if n != nil {
                if n! % 2 == 0 { color = NSColor.redColor() }
            }
            D[NSForegroundColorAttributeName] = color
        
            // https://github.com/robb/swamp/blob/master/swamp.swift
            let paragraphStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy()
                as NSMutableParagraphStyle!
            paragraphStyle.alignment = NSTextAlignment.CenterTextAlignment
            D[NSParagraphStyleAttributeName] = paragraphStyle
            let r2 = NSMakeRect(r.origin.x, r.origin.y - 15,
                r.width, r.height)
            s.drawInRect(r2, withAttributes: D)
        
        }
    
        override func mouseDown(theEvent: NSEvent) {
            for st in a {
                if NSPointInRect(theEvent.locationInWindow, st.r) {
                    handleClick(st)
                return
                }
            }
        }
    
        func handleClick(st: S) {
            println("mouseDown: \(st.i) \(st.title)")
            // 1-based indexing everywhere in this function !!
            // i is index of Struct.rect with mouse event
            let i = st.i
            // j is index of Struct.rect with blank title
            let j = blank
            // test whether we allow switch:
            let adj = adjacentSquares(i)
            println("\(i) \(j) \(adj) \(contains(adj,j))")
            if !contains(adj,j) {
                println("not adjacent: \(i) \(j)")
                return
            }
            switchSquares(i, j:j)
        }
    
        // note:  index of blank square must be j not i
        func switchSquares(i: Int, j: Int) {
            // i,j come in as 1-based indexing
            // switch here to 0-based indexing of a
            var next = a[i-1]
            var title = next.title
            var curr = a[j-1]
        
            curr.changeTitle(title)
            next.changeTitle("")
        
            a[i-1] = next
            a[j-1] = curr
        
            // switch back to 1-based for blank
            blank = i
            display()
        }
    
        func adjacentSquares(i:Int) -> [Int] {
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
    }
   
