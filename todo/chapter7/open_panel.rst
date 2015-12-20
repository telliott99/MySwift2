.. _open_panel:

###########
NSOpenPanel
###########

.. sourcecode:: bash

    import Cocoa

    var op = NSOpenPanel()
    op.prompt = "Open File:"
    op.title = "A title"
    op.message = "A message"
    // op.canChooseFiles = true  // default
    // op.worksWhenModal = true  // default
    op.allowsMultipleSelection = false
    // op.canChooseDirectories = true  // default
    op.resolvesAliases = true
    op.allowedFileTypes = ["txt"]

    let home = NSHomeDirectory()
    let d = home.stringByAppendingString("/Desktop/")
    op.directoryURL = NSURL(string: d)

    var readError: NSError?
    op.runModal()
    // op.orderOut()

    // op.URL contains the user's choice
    let s = NSString(
        contentsOfURL:op.URL,
        encoding:NSUTF8StringEncoding,
        error: &readError)

    if readError != nil {
        let e = readError!
        let msg = e.localizedDescription
        println("read failure: \(msg)")
        // return nil
    }
    else {
        let str = s as String
        println("str = \(str)*")
    }
    
    // NSFileHandlingPanelOKButton
    // [savePanel orderOut:nil]

.. sourcecode:: bash

    > echo "abc" > x.txt
    > xcrun swift test.swift
    str = abc
    *
    >
    
.. image:: /figures/open_panel.png
   :scale: 100 %