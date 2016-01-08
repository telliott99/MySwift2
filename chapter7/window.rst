.. _window:

######
Window
######

The following code sample shows a way to get a window on screen from the command line.  It is lifted essentially verbatim from the link in the example:

https://forums.developer.apple.com/thread/5137

which in turn is a modification of the code at this link for Swift 2:

http://practicalswift.com/2014/06/27/a-minimal-webkit-browser-in-30-lines-of-swift/

Simply paste the code into a file ``app.swift``, do ``chmod +x app.swift`` and then ``./app.swift`` and you should see:

.. image:: /figures/window.png
   :scale: 100 %

Here is the listing:

.. sourcecode:: swift

    #!/usr/bin/swift  
    import WebKit

    let application = NSApplication.sharedApplication()
    application.setActivationPolicy(
        NSApplicationActivationPolicy.Regular)

    let mask = NSTitledWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask
    let store = NSBackingStoreType.Buffered
    let rect = NSMakeRect(0, 0, 960, 720)

    let window = NSWindow(contentRect: rect,
                          styleMask: mask,
                          backing: store,
                          `defer`: false)

    window.center()
    window.title = "Minimal Swift WebKit Browser"
    window.makeKeyAndOrderFront(window)

    class WindowDelegate: NSObject, NSWindowDelegate {
        func windowWillClose(notification: NSNotification) {
            NSApplication.sharedApplication().terminate(0)
        }
    }

    let windowDelegate = WindowDelegate()
    window.delegate = windowDelegate
    let url = "https://forums.developer.apple.com/thread/5137"

    class ApplicationDelegate: NSObject, NSApplicationDelegate {
        var _window: NSWindow
        init(window: NSWindow) {
            self._window = window
        }
        func applicationDidFinishLaunching(notification: NSNotification) {
            let webView = WebView(frame: self._window.contentView!.frame)
            self._window.contentView!.addSubview(webView)
            webView.mainFrame.loadRequest(NSURLRequest(URL: NSURL(string: url)!))
        }
    }  
    let applicationDelegate = ApplicationDelegate(window: window)  
    application.delegate = applicationDelegate  
    application.activateIgnoringOtherApps(true)  
    application.run()


