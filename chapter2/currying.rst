.. _currying:

******************
Currying functions
******************

Example:  take a function that takes two arguments and break it up into (i) a function that takes one argument and returns another function and (ii) that second function taking the second argument.

From the Big Nerd Ranch book, entered into a Playground:

.. sourcecode:: swift

    func greetName(n: String, s: String) -> String {
        return "\(s) \(n)"
    }

    print(greetName("Matt", s: "Hello"))
    // "Hello Matt\n"

    //-----------------------

    // curried form

    func greetingForName(n: String) -> (String) -> String {
        func greeting(s: String) -> String {
            return "\(s) \(n)"
        }
        return greeting
    }

    let g = greetingForName("Matt")
    print(g("Hello"))
    // "Hello Matt\n"

    //-----------------------

    // more concise
    func greeting(s: String)(n: String) -> String {
        return "\(s) \(n)"
    }

    let friendlyGreeting = greeting("Hello")
    print(friendlyGreeting(n: "Matt"))
    // "Hello Matt\n"