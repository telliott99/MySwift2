.. _dictionary:

##########
Dictionary
##########
    
Here is a Swift dictionary

.. sourcecode:: bash

    var D = ["a":"apple","b":"banana","c":"cookie"]
    for (k,v) in D {
        print("\(v) starts with the letter: \(k)")
    }
    
.. sourcecode:: bash

    > swift test.swift 
    banana starts with the letter: b
    apple starts with the letter: a
    cookie starts with the letter: c
    >

The construct ``for (tuple) in dictionary`` loops over (key, value) pairs.  The (key,value) pairs in a dictionary are not ordered in the usual sense.  However, if you run this code repeatedly, it will repeat the same output.

The values are held in a data structure that is commonly called a "hash", which is optimized for fast lookup.  

The idea is clever but not all that complicated.  Imagine we have a really big post office with a bunch of mailboxes numbered from 1 to one million.  We compute a "hash" from the key, a value between 1 and one million, and then go insert the value in that mailbox.  It's very quick to do a lookup and see what the value is that corresponds to a particular key, or whether any given key corresponds to a stored value.

On the other hand, to know whether a particular value is contained in an array (without first sorting the array), one must look at every value.  Even with a sorted array, the number of lookups goes like log(n).  

That is not true of a dictionary.

We can ask for these "properties" from a dictionary:

    - ``D.keys`` 
    - ``D.values``
    - ``D.count``

.. sourcecode:: bash

    var D = ["a":"apple","b":"banana","c":"cookie"]
    print(Array(D.keys))
    print(Array(D.values))

.. sourcecode:: bash

    > swift test.swift 
    ["b", "a", "c"]
    ["banana", "apple", "cookie"]
    > 

Without the ``Array()``, you get

.. sourcecode:: bash

    LazyMapCollection<Dictionary<String, String>, String>(_base: ["b": "banana", "a": "apple", "c": "cookie"], _transform: (Function))

Here is the example from the docs:

.. sourcecode:: bash

    let airports = ["DUB":"Dublin", "TYO":"Tokyo"]
    for (code,name) in airports {
        print("\(code): \(name)")
    }

    for city in airports.values {
        print("city: \(city)")
    }

    for code in airports.keys {
        print("code: \(code)")
    }

.. sourcecode:: bash

    > swift test.swift 
    DUB: Dublin
    TYO: Tokyo
    city: Dublin
    city: Tokyo
    code: DUB
    code: TYO
    >
    
We can access the values in a dictionary by subscript notation.

.. sourcecode:: bash

    var D: [String: Int] = ["apple":1, "banana":2]
    print(D)
    D["apple"] = 5
    print(D)
    D["cookie"] = 10
    print(D)

.. sourcecode:: bash

    > swift test.swift 
    ["banana": 2, "apple": 1]
    ["banana": 2, "apple": 5]
    ["banana": 2, "apple": 5, "cookie": 10]
    >

In the code above we declared the type of ``D`` as ``[String: Int]``.  This also works:

.. sourcecode:: bash

    var D = Dictionary<String,Int>()
    var D1: Dictionary<String,Int> = ["apple":1]
    print(D1["apple"]!)
    
and when run it prints ``1``, as you'd expect.  

What is going on is that the ``Dictionary`` class is actually defined as a generic ``Dictionary<KeyType,ValueType>``.  The subscript notation works because that mechanism has been defined inside the class.

In the first line ``var D = Dictionary<String,Int>()``, we are getting an instance of dictionary, so we need the call operator ``( )``, which will call the ``init()`` method of the class.

Dictionary operations return a value if the key is present, and otherwise ``nil`` i.e. and Optional.

.. sourcecode:: bash

    var D: Dictionary<String,Int> = [:]
    print(D["cookie"])  // nil
    D["cookie"] = 100
    print(D["cookie"])  // Optional(100)
    print(D["cookie"]!) // 100

The value of the return type is a ``ValueType?``, which you must force to ``ValueType`` by saying ``ValueType!`` if you're sure it's not ``nil``.  Of course, you should test for ``nil``, so we should really do:
    
So why does the airport example work without "!"  It's because we first asked the dictionary to return its keys and values.  Swift knows what is present, so the returned keys and values in those "LazyMapCollection"'s are not Optionals.

The dictionary method ``updateValue`` returns the old value if present, otherwise it returns ``nil``

.. sourcecode:: bash

    var D: [String: Int] = ["apple":1, "banana":2]
    if let oldValue = D.updateValue(100, forKey:"cookie") {
        print("The old value was \(oldValue)")
    }
    else {
        print("cookie was not in the dictionary")
    }
    print(D)
    print("but it is now")

.. sourcecode:: bash

    > swift test.swift 
    cookie was not in the dictionary
    ["banana": 2, "apple": 1, "cookie": 100]
    but it is now
    >
    
As usual for a dictionary, the keys *are in a particular order* (based on their hash values), but they're not in lexicographical order and appear to be unsorted.

.. sourcecode:: bash

    var D = ["a":"apple","b":"banana","c":"cookie"]
    for k in D.keys.sort() { print("\(k): \(D[k]!) ") }

.. sourcecode:: bash

    > swift test.swift
    a: apple 
    b: banana 
    c: cookie 
    >

--------------------
dict(zip(a,b)) idiom
--------------------

At first, I didn't think there was anything comparable to Python's ``dict(zip(key_list,value_list))`` idiom.  So I decided we would roll our own:

.. sourcecode:: bash

    var L1 = Array(1...3)
    var L2 = ["apple","banana","cookie"]

    func dict_zip (aL: Array<Int>, _ bL: Array<String> ) 
        -> Dictionary<Int,String> {
        var D = [Int:String]()
        for (i,a) in aL.enumerate() {
            let b = bL[i]
            D[a] = b
        }
        return D
    }

    print(dict_zip(L1,L2))

.. sourcecode:: bash

    > swift test.swift
    [2: "banana", 3: "cookie", 1: "apple"]
    >

Update:  I did find Swift's ``zip``, it is called ``Zip2Sequence``

.. sourcecode:: bash

    var kL = Array(1...3)
    var vL = ["apple","banana","cookie"]
    var D = [Int:String]()

    for (key,value) in Zip2Sequence(kL,vL) {
        print("\(key): \(value)")
        D[key] = value
    }
    print(D)
    
.. sourcecode:: bash

    > swift test.swift
    1: apple
    2: banana
    3: cookie
    [2: "banana", 3: "cookie", 1: "apple"]
    >

Later, I found that there is an initializer for Dictionary that will take (key,value) pairs.

http://swiftdoc.org/v2.0/type/Dictionary/

For example, this works:

.. sourcecode:: bash

    let d1 = Dictionary(dictionaryLiteral: ("a",1), ("b",2))

However, this does not work:

.. sourcecode:: bash

    let a1 = ["a", "b"]
    let a2 = [1, 2]
    let z = Zip2Sequence(a1, a2)
    let d2 = Dictionary(z)  // does not work
    print(z)

It seems the reason is that the initializer with arguments ``dictionaryLiteral: ("a",1), ("b",2)`` takes a ``tuple``, while I am trying to use an array.  And the size of the tuple is known at compile time, while the size of my array is not.  This is not allowed.

The technique is apparently called "splatting".

http://stackoverflow.com/questions/26983019/explanation-of-splat

The only thing I've gotten so far is (using ``z`` from above):

.. sourcecode:: bash

    var D = [String:Int]()
    for (k,v) in z {
        D[k] = v
    }

which is not as concise as I would like.


