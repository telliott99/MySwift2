.. _translating_objc:

#######################
Translating Objective-C
#######################

Here is an example of translating Objective C code to Swift.  (There are more in :ref:`files`).

The exercise is from Hillegass, Objective C.  We load all the propernames from a file (without error checking), and do a case-insensitive search for ``"AA"``.

``test.m``

.. sourcecode:: bash

    #import <Foundation/Foundation.h>

    int main (int argc, const char * argv[]){
        @autoreleasepool {
            NSString *p = @"/usr/share/dict/propernames";
            NSString *s = [NSString stringWithContentsOfFile:p
                    encoding:NSUTF8StringEncoding
                    error:NULL];
            NSString *nl = @"\n";
            NSLog(@"%lu", s.length );
            NSArray *names = [s componentsSeparatedByString:nl];
            for (NSString *n in names) {
                NSRange r = [n rangeOfString:@"AA"
                    options:NSCaseInsensitiveSearch];
                if (r.location != NSNotFound){
                    NSLog(@"%@", n);
                }
            }
        }
    }

.. sourcecode:: bash

    > clang test.m -o prog -framework Foundation
    > ./prog
    2015-12-20 11:09:57.455 prog[3778:184447] 8546
    2015-12-20 11:09:57.459 prog[3778:184447] Aaron
    2015-12-20 11:09:57.459 prog[3778:184447] Isaac
    2015-12-20 11:09:57.459 prog[3778:184447] Lievaart
    2015-12-20 11:09:57.459 prog[3778:184447] Maarten
    2015-12-20 11:09:57.460 prog[3778:184447] Raanan
    2015-12-20 11:09:57.460 prog[3778:184447] Saad
    2015-12-20 11:09:57.460 prog[3778:184447] Sjaak
    >

Here is my Swift translation.  We use NSString interchangeably with String, but ``componentsSeparatedByString`` returns an ``[AnyObject]``, so we cast it as we want it.

.. sourcecode:: bash

    import Foundation

    let p = "/usr/share/dict/propernames"

    var s: String = ""
    do {
        s = try String(
            contentsOfFile:p,
            encoding: NSUTF8StringEncoding)
    }
    catch { exit(1) } 
    print(s.characters.count)           

    let names = s.componentsSeparatedByString("\n") as [String]
    for n in names {
        if let r = n.rangeOfString(
            "AA", 
            options: .CaseInsensitiveSearch) 
                { print(n) }
    }

.. sourcecode:: bash

    > swift test.swift
    8546
    Aaron
    Isaac
    Lievaart
    Maarten
    Raanan
    Saad
    Sjaak
    >

That wasn't so difficult.  We had to remember the ``do .. try .. catch`` idiom for file reading in Swift(:ref:`files`), and that Swift Strings don't have a length but instead ``s.characters.count`` (:ref:`strings`), and then look up ``NSSearchCompareOptions`` for ``.CaseInsensitiveSearch``, adding the ``.`` for ``NS``.

Of course, we are still using an NSString method:  ``componentsSeparatedByString``.  We looked at that before too, and came up with:

.. sourcecode:: bash

    s.characters.split() { $0 == "\n" }.map{ String($0) }
