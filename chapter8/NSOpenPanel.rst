.. _open_panel:

###########
NSOpenPanel
###########

.. sourcecode:: swift

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
    op.runModal()

    let url = op.URL
    if url == nil { print("nope");  exit(1) }
    var s: String = ""
    do {
        s = try String(
            contentsOfURL:url!,
            encoding: NSUTF8StringEncoding)
            print(s)
    }
    catch {
        print("oops")
    }

.. sourcecode:: bash

    > echo "abc" > x.txt
    > swift test.swift
    abc

    >
    
``echo`` puts a newline in the file and then there is one added as print returns, I guess.

.. image:: /figures/open_panel.png
   :scale: 100 %