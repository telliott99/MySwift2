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
    2014-09-01 08:20:15.692 prog[857:507] 8546
    2014-09-01 08:20:15.696 prog[857:507] Aaron
    2014-09-01 08:20:15.696 prog[857:507] Isaac
    2014-09-01 08:20:15.697 prog[857:507] Lievaart
    2014-09-01 08:20:15.697 prog[857:507] Maarten
    2014-09-01 08:20:15.697 prog[857:507] Raanan
    2014-09-01 08:20:15.698 prog[857:507] Saad
    2014-09-01 08:20:15.698 prog[857:507] Sjaak
    > 

Here is my Swift translation.  We see the way to handle ``NSError`` again here.  We use NSString interchangeably with String, but ``componentsSeparatedByString`` returns an ``[AnyObject]``, so we cast it as we want it.

Normally we would pass ``NSCaseInsensitiveSearch`` as an option (as in the Objective C version above).  But I am getting "unresolved identifier" as the error.  So instead, each string is converted to its ``uppercaseString``.

.. sourcecode:: bash

    import Foundation

    let p = "/usr/share/dict/propernames"
    var e: NSError?
    var s = NSString.stringWithContentsOfFile(p,
                encoding:NSUTF8StringEncoding,
                error:&e)
    let nl = "\n"
    println(s.length)

    let names = s.componentsSeparatedByString(nl) as [String]
    for n in names {
        let s1 = n.uppercaseString
        if let r = s1.rangeOfString("AA",options: nil) {
            println(n)
        }
    }

.. sourcecode:: bash

    > xcrun swift test.swift
    8546
    Aaron
    Isaac
    Lievaart
    Maarten
    Raanan
    Saad
    Sjaak
    >
