.. _drawing:

#######
Drawing
#######

This is just for fun.  I wrote a ``Sorter`` class that generates an array of random values (either seeded or not), which I thought I might extend later to try out various sorting algorithms.

Then, I remembered a post (stimulated by a great site I found on the web)

http://telliott99.blogspot.com/2012/05/view-with-no-window.html

that implements drawing to a pdf without actually having a window on-screen.  So that's where the second class (``MyView``) comes from.

Here is the basic code to draw to pdf:

.. sourcecode:: bash

    import Cocoa

    extension NSView {
        func plotData(fn: String) {
            let data = self.dataWithPDFInsideRect(frame)
            data.writeToFile(fn, atomically: true)
        }
    }

    class MyView : NSView {
        override init(frame: NSRect) {
            super.init(frame: frame)
        }
        // this has changed in Swift 2 to require "init?"
        required init?(coder: NSCoder) {
            super.init(coder: coder)
        }
        override func drawRect(dirtyRect: NSRect) {
            NSColor.redColor().set()
            NSRectFill(self.bounds)
            let r = NSRect(x:10, y:10, width:100, height:50)
            NSColor.blackColor().set()
            NSRectFill(r)
        }
    }

    let frame = NSRect(x:0, y:0,
        width:400, height:300)
    let view = MyView(frame: frame)
    view.plotData("x.pdf")
    

As it grew, it got a bit complicated.  

Here is the resulting figure, which may justify browsing through the code below.

.. image:: /figures/x.png
   :scale: 75 %

.. sourcecode:: bash

    import Cocoa

    extension NSView {
        func plotData(fn: String) {
            let data = self.dataWithPDFInsideRect(frame)
            data.writeToFile(fn, atomically: true)
        }
    }

    class MyView : NSView {
        // will change these later
        var data: [Int] = [Int]()
        var width: Int = 0
        var height: Int = 0

        override init(frame: NSRect) {
            super.init(frame: frame)
        }

        // init? in Swift2
        required init?(coder: NSCoder) {
            super.init(coder: coder)
        }

        convenience init(data: [Int]) {
            let frame = NSRect(x:0, y:0, 
                        width:400, height:300)
            self.init(frame: frame)
            self.data = data
            self.width = 400
            self.height = 300
        }

        override func drawRect(dirtyRect: NSRect) {
            NSColor.whiteColor().set()
            NSRectFill(self.bounds)

            let maxValue = data.reduce(Int.min, combine: { max($0,$1) })
            let f = Double(maxValue)/Double(height-20) * 1.8
            var x: Int = 20
            let y: Int = 20
            let maxw = Int(Double(width - 100)/Double(data.count))
            let w = min(10, maxw)
            let pad = 5 // padding between rects

            for v in data {
                let h = Int(Double(v)*f)
                let r = NSRect(x:x, y:y, width:w, height:h)
                let c = 1.0 - CGFloat(v)/CGFloat(maxValue)
                NSColor(calibratedWhite:c, alpha:1.0).set()
                NSRectFill(r)
                NSColor.blackColor().set()
                NSBezierPath(rect:r).stroke()
                x += w + pad
            }
        }
    }

    // not Printable any more
    class Sorter: CustomStringConvertible {
        var data: [Int] = [Int]()
        var N: Int
        var n: Int
        // let seed = 1337
        init(_ maxValue: Int, _ numValues: Int) {
            N = maxValue
            n = numValues
            resetNonRandom()
        }
        func resetNonRandom(seed: Int = 137){
            let maxrand = (UInt32.max-1)/2
            srand(UInt32(seed))
            var b: [Int] = [Int]()
            var r: Int
            for _ in 0...n-1 {
                r = Int(rand())
                let f = Double(r) / Double(maxrand)
                r = Int(f*Double(N)) + 1
                b.append(r)
            }
            data = b
        } 
        func resetRandom() {
            var b: [Int] = [Int]()
            var r: Int
            for _ in 0...n-1 {
                let t = UInt32(N)
                r = Int(arc4random_uniform(t))
                // no duplicates
                while data.contains(r) {
                    r = Int(arc4random_uniform(t))
                }
                b.append(r+1)
            }
            data = b
        }
        var description: String {
            /* ugly:
            var s = ""
            for (i,r) in data.enumerate() {
                s += String(r)
                if !(i == data.count - 1) {
                    s += " "
                }
            }
            */
            // better with a closure
            let s = data.map( {"\($0)"} ).joinWithSeparator(" ")
            return s
        }
        func test() {
            print("\(sb)")
            sb.resetRandom()
            print("\(sb)")
            sb.resetRandom()
            print("\(sb)")
            sb.resetNonRandom()
            print("\(sb)")
            // let t = UnsafeMutablePointer(null())
            // sb.resetNonRandom(seed: time(t))
            // print("\(sb)")
        }
        func plot(fn: String) {
            let view = MyView(data: data)
            view.plotData(fn)
        }
        func sortInPlace() {
            data.sortInPlace(<)
        }
    }

    var sb = Sorter(200, 20)
    sb.resetRandom()
    print(sb)
    sb.sortInPlace()
    print(sb)
    sb.plot("x.pdf")
    