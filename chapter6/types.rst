.. _types:

#####
Types
#####

As everyone knows, Swift is strongly typed, but there are situations that arise where we may need to cast between types.  There is a nice example from the book of a base class ``MediaItem`` and derived classes ``Movie`` and ``Song``:

.. sourcecode:: swift

    class MediaItem {
        var name: String
        init(name: String) {
            self.name = name
        }
    }

    class Movie: MediaItem {
        var director: String
        init(name: String, director: String) {
            self.director = director
            super.init(name: name)
        }
    }

    class Song: MediaItem {
        var artist: String
        init(name: String, artist: String) {
            self.artist = artist
            super.init(name: name)
        }
    }

We exercise it this way:

.. sourcecode:: swift

    // this is OK b/c all are MediaItem
    let library = [
        Movie(name: "Casablanca", director: "Michael Curtiz"),
        Song(name: "Blue Suede Shoes", artist: "Elvis Presley"),
        Movie(name: "Citizen Kane", director: "Orson Welles"),
        Song(name: "The One And Only", artist: "Chesney Hawkes"),
        Song(name: "Never Gonna Give You Up", artist: "Rick Astley")
    ]

    var movieCount = 0
    var songCount = 0
    for item in library {
        if item is Movie { ++movieCount }
    }
    print(movieCount) // 2

We were able to construct an array containing both Movie and Song objects, because the compiler can find that they are both MediaItem types.  We can use the ``is`` operator to test whether a particular item has the type we are looking for.  Another application is to use a conditional form ``as?`` (which is called "downcasting"):

.. sourcecode:: swift

    for item in library {
        if let song = item as? Song { ++songCount }
    }
    print(songCount)  // 3

This comes up a lot in the context of NSArray.  Objects in an NSArray are untyped, which allows mixed Types.  When we come back to Swift the type of such things is ``AnyObject``.

.. sourcecode:: swift

    import Foundation

    var a: NSArray = ["x", "y", 2]
    let a2: [AnyObject] = ["x","y",2]

    // we can downcast optionally to Int or whatever
    for item in a2 {
        if let value = item as? Int { print(value) }
    }  // prints 2
    
.. sourcecode:: bash

    > swift test.swift 
    2
    >

For the MediaItem example

.. sourcecode:: swift

    let a2: [AnyObject] = [
        Movie(name: "2001: A Space Odyssey",
            director: "Stanley Kubrick"),
        Movie(name: "Moon", director: "Duncan Jones"),
        Movie(name: "Alien", director: "Ridley Scott")]

    for object in a2 {
        let movie = object as! Movie
        print("Movie: '\(movie.name)', dir. \(movie.director)")
    }

    // alternatively
    for movie in a2 as! [Movie] { print("\(movie.name)") }

Here we have used ``as!`` to force the downcast because we're sure it cannot fail.
    
.. sourcecode:: bash

    > swift test.swift 
    Movie: '2001: A Space Odyssey', dir. Stanley Kubrick
    Movie: 'Moon', dir. Duncan Jones
    Movie: 'Alien', dir. Ridley Scott
    2001: A Space Odyssey
    Moon
    Alien
    >

``Any`` is even broader than ``AnyObject``, it can include *function* types

The following works in a Playground, but not from the command line.

.. sourcecode:: swift

    func g() { }
    func h(s: String) -> Bool { return true }

    // let a: [AnyObject] = ["a", 1, g]  // error
    let a: [Any] = ["a", 1, g, h]

    for item in a {
        switch item {
        case let f as ((String) -> (Bool)):
            f("x")
        default:
            print("oops")
        }
    }

Here is a quick demo with a user-defined class and a protocol.

.. sourcecode:: swift

    protocol Incrementable { func addOne() }

    class X: Incrementable {
        var i = 1
        func addOne() {
            i += 1
        }
    }

    func performActivity(obj: AnyObject) {
        if let o = obj as? Incrementable {
            o.addOne()
        }
        else {
            print("oops \(obj)")
        }
    }

    var x = X()
    print(x.i)
    x.addOne()
    print(x.i)

    class Y { }
    let y = Y()

    performActivity(x)
    print(x.i)
    performActivity(y)

    let oa: [AnyObject] = [x,y]
    for o in oa {
        performActivity(o)
    }

    print(x.i)

.. sourcecode:: bash

    > swift test.swift 
    1
    2
    3
    oops test.Y
    oops test.Y
    4
    >