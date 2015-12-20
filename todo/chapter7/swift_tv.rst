.. _swift_tv:

###################
Table View in Swift
###################

The docs don't seem to be completely up-to-date for Swift and Cocoa.  Translating methods from Objective C to Swift can be a challenge.  

An NSTableView or subclass (using old style non-"view-based" table views) needs a dataSource, and that class *must* implement two methods:

.. sourcecode:: objective-c

    -(int) numberOfRowsInTableView:
    -(id) tableView:objectValueForTableColumn:row:

Translating the first method is fairly easy.  We just do

.. sourcecode:: bash

    func numberOfRowsInTableView(tv: NSTableView) -> Int {

The method name is the same, we've just added ``func`` and an explicit return type, given the type for the single argument.

The other method takes some thought.  Here it is:

.. sourcecode:: bash

    func tableView(objectValueForTableColumn: NSTableColumn, 
        row: Int) -> String {

So, here is the code to add to ``AppDelegate.swift`` for our first example of a table view:

.. sourcecode:: bash

    func numberOfRowsInTableView(tv: NSTableView!) -> Int {
            return 3  // change this later
        }
    
        func tableView(tv: NSTableView!, objectValueForTableColumn tc: NSTableColumn,
                row: Int) -> String {
                    var D0, D1: Dictionary<Int,String>
                    D0 = [0:"a",1:"b",2:"c"]
                    D1 = [0:"x",1:"y",2:"z"]
                    var D: [String: Dictionary<Int,String>]
                    D = ["0":D0, "1":D1]
                    let dict = D[tc.identifier]
                    if let value = dict![row] {
                        return value }
                    return ""
            }

I am not quite together with the ``!`` idiom yet.  When we do ``dict = D[tc.identifier]``, the compiler seems to think there is the possibility that we won't get anything back from the dictionary ``D``, hence out value is an Optional.  In the next line ``if let value = dict![row]``, we're forcing the actual value of ``dict`` to yield its object for the key ``row``.  For some reason we don't need ``value!`` when we do the return (and it's an error).

In ``MainMenu.xib``, drag a table view out onto the window and then CTL-drag from the table view to the icon for the AppDelegate in the palette.  Set the AppDelegate as the dataSource for the table view.  Set the identifier for the table columns to be 0 and 1.  These will come into the AppDelegate as Strings.  That's it.

.. image:: /figures/tableview.png
   :scale: 125 %

A second version moves the data to a class variable.

.. sourcecode:: bash

    var D: [String: Dictionary<Int,String>]
    override init() {
        var D0, D1: Dictionary<Int,String>
        D0 = [0:"a",1:"b",2:"c"]
        D1 = [0:"x",1:"y",2:"z"]
        self.D = ["0":D0, "1":D1]
        super.init()
    }
    
The compiler requires the ``override`` and that ``super.init()`` come after the initialization of the variable ``D``.  The only other change is to modify ``let dict = self.D[tc.identifier]``.

Here is the entire listing:

.. sourcecode:: bash

    import Cocoa

    class AppDelegate: NSObject, NSApplicationDelegate {

        @IBOutlet weak var window: NSWindow!

        var D: [String: Dictionary<Int,String>]
        var D0, D1: Dictionary<Int,String>
        override init() {
            self.D0 = [0:"a",1:"b",2:"c"]
            self.D1 = [0:"x",1:"y",2:"z"]
            self.D = ["0": self.D0, "1": self.D1]
            super.init()
        }

        func numberOfRowsInTableView(tv: NSTableView!) -> Int {
            let dict = self.D0
            return dict.count
            //return 3
        }

        func tableView(tv: NSTableView!,
            objectValueForTableColumn tc: NSTableColumn,
            row: Int) -> String {
                let dict = self.D[tc.identifier]
                if let value = dict![row] {
                    return value }
                return ""
        }
    }
    

.. _swift_view: