.. _images:

######
Images
######

Much of this material is borrowed from the incomparable Mike Ash:

https://mikeash.com/pyblog/friday-qa-2012-08-31-obtaining-and-interpreting-image-data.html

We have an image on the Desktop called "x.png".

.. sourcecode:: swift

    import Cocoa

    let imgLoad = NSImage(contentsOfFile: "x.png")

    if nil == imgLoad { exit(1) }
    let img = imgLoad!
    print(img.className)
    print(img.size)
    print("\(img)")

.. sourcecode:: bash

    > swift test.swift 
    NSImage
    (165.0, 175.0)
    <NSImage 0x7ff42062eb80 Size={165, 175} Reps=(
        "NSBitmapImageRep 0x7ff4206260c0 Size={165, 175} ColorSpace=(not yet loaded) BPS=8 BPP=(not yet loaded) Pixels=165x175 Alpha=YES Planar=NO Format=(not yet loaded) CurrentBacking=nil (faulting) CGImageSource=0x7ff42062b3d0"
    )>
    >

If you're working in a Playground, you can drag an image file to Resources (do:  showProject Navigator).  Then do ``let imgLoad = NSImage(named:"x.png")``.

NSImage is a *container* for one or more image representations.  Add this:

.. sourcecode:: swift

    print(img.representations.count)
    let imgRep = img.representations[0] as! NSBitmapImageRep
    print(imgRep.className)

.. sourcecode:: bash

    > swift test.swift 
    NSImage
    (165.0, 175.0)
    1
    NSBitmapImageRep
    >

So, in an NSBitmapImageRep, the data are stored in pixels.  Typically each pixel is 4 bytes:  red, green, blue, alpha.  Other orderings are possible.  Also, they can be stored separately (all the red pixels, then all the green ones ..):  that's called planar.

However, (according to Mike Ash) the above code is *not* a good way to get it because we don't know what the pixel format is or how to handle all the possible cases.  Using the bit map obtained in this way is "not reliable".

What we do instead is to "draw" it and then look at that data.

.. sourcecode:: swift

    import Cocoa

    let imgLoad = NSImage(contentsOfFile: "x.png")

    if nil == imgLoad { exit(1) }
    let img = imgLoad!
    let w = Int(img.size.width)
    let h = Int(img.size.height)

    let imgRep = NSBitmapImageRep(
        bitmapDataPlanes: nil,
        pixelsWide: w,
        pixelsHigh: h,
        bitsPerSample: 8,
        samplesPerPixel: 4,
        hasAlpha: true,
        isPlanar: false,
        colorSpaceName: NSCalibratedRGBColorSpace,
        bytesPerRow: w * 4,
        bitsPerPixel: 32)

    // unwrap it:
    let ir = imgRep!
    print("\(ir)")
    
.. sourcecode:: bash

    > swift test.swift 
    NSImage
    (165.0, 175.0)
    NSBitmapImageRep 0x7f8315100430 Size={165, 175} ColorSpace=Generic RGB colorspace BPS=8 BPP=32 Pixels=165x175 Alpha=YES Planar=NO Format=0 CurrentBacking=nil (faulting)
    >
    
Next, we need to draw the image into the bitmapRepresentation.  For that we need a "graphics context".  Add this code to what's above:

.. sourcecode:: swift

    let gc = NSGraphicsContext(bitmapImageRep: ir)
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.setCurrentContext(gc)

    let op = NSCompositingOperation.CompositeCopy
    let f = CGFloat(1.0)

    // draw the image! not the imageRep
    img.drawAtPoint(
        NSZeroPoint,
        fromRect: NSZeroRect,
        operation: op,
        fraction: f)

    gc?.flushGraphics()
    NSGraphicsContext.restoreGraphicsState()

We'll discuss ``drawAtPoint`` below, but note here that ``NSZeroRect`` is a shorthand that is allowed by Cocoa, rather than having to specify the source rectangle (of the image).

Now the data is in the imageRep (``ir``), and we can use it.

.. sourcecode:: swift

    let data = ir.bitmapData  // red, green, blue, alpha
    for i in 0..<8 { print(data[i], terminator: " ") }
    print("")
    
.. sourcecode:: bash

    > swift test.swift 
    73 108 163 255 73 108 164 255 
    >

Now we can write it to another file:

.. sourcecode:: swift

    let pngData = ir.representationUsingType(
        .NSPNGFileType,
        properties: [:])
    
    pngData!.writeToFile(
        "out.png", atomically: true)

The file ``out.png`` should be on the Desktop.

So what might we do with this?  The simplest idea is to rescale the image.  For example, we might squish it into an image that is half the original size.

To do that, change the NSBitmapImageRep to have:

.. sourcecode:: swift

    pixelsWide: w/2,
    pixelsHigh: h/2,
    
and replace the ``drawAtPoint`` code above with this:

.. sourcecode:: swift

    let dst = CGRectMake(0, 0, CGFloat(w)/2, CGFloat(h)/2)

    img.drawInRect(
        dst,
        fromRect: NSZeroRect,
        operation: op,
        fraction: f)

The source ``src`` is a CGRect of the size of the image we just loaded (unless you want to clip or something), The destination dst is a rect of the size of image we want to produce. By changing dst we change the reduction or magnification of the image produced.

