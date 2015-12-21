.. _encryption:

##########
Encryption
##########

I love encryption!  

It can be very simple or much more complex for real-world examples.  We introduced the simple stuff in :ref:`binary`, and here is some more.  The ideas are still simple, the setup is a little more complicated.

If I have a UInt8 (value from 0...255) that represents my *plaintext*, let's call it *p*, and I also have a UInt8 value that represents my *key*, call it *k*, then the encrypted *ciphertext c* is: ``c = p ^ k``.  

Here, ``^`` is the "exclusive or" (XOR) operator applied to these two operands.

The XOR truth table is

.. sourcecode:: bash

    - p ^ k = c
    - 0 ^ 0 = 0
    - 0 ^ 1 = 1
    - 1 ^ 0 = 1
    - 1 ^ 1 = 0

In Boolean, logic, the result of ``x ^ y`` is true if just one of ``x`` and ``y`` is true, and false otherwise.  

The wonderful result here is that the reverse is also correct:  ``c ^ k`` is equal to ``p``.  (On every line, if we switched the ``=`` and the ``^``, the expression would still be true).

To put that another way, encryption is reversed by XOR'ing the ciphertext with the same key value that was used to encrypt that bit.

Here is the example from the docs, pasted into the Swift interpreter:

.. sourcecode:: bash

    1> let firstBits: UInt8 = 0b00010100 
    2. let otherBits: UInt8 = 0b00000101 
    3. let outputBits = firstBits ^ otherBits  // equals 00010001
    firstBits: UInt8 = 20
    otherBits: UInt8 = 5
    outputBits: UInt8 = 17
    4>

.. image:: /figures/xor.png
   :scale: 100 %

The operator ``^`` gives correct results with bytes (i.e. UInt8), as the output shows.  It even works for longer UInts..

.. sourcecode:: bash

    let b1: UInt16 = 0b0001010000010100
    let b2: UInt16 = 0b0001010000000101
    let b3 = b1 ^ b2

    for b in [b1,b2,b3] {
        let s = String(b, radix:2)
        let n = 16 - s.characters.count
        for _ in 0..<n {
            print("0", terminator: "")
            }
        print(s)
    }

    print("\n\(b1) ^ \(b2) = \(b1 ^ b2)")
    print("\(b1) ^ \(b3) = \(b1 ^ b3)")
    print("\(b2) ^ \(b3) = \(b2 ^ b3)")

.. sourcecode:: bash

    > swift test.swift
    0001010000010100
    0001010000000101
    0000000000010001

    5140 ^ 5125 = 17
    5140 ^ 17 = 5125
    5125 ^ 17 = 5140
    >

The only thing hard about this example is printing the byte values as binary strings.  ``String(b, radix:2)`` does part of what we want, but the default is to strip leading zeros.  I tried doing ``"0" * n`` but Swift won't allow it.  There may be a more direct way of doing this.  I have some String extensions for doing ``ljust`` and ``rjust`` in :ref:`extensions`.

----
Keys
----

In one sense, a really long message is just a big Int.  And the same is true of a good key.  

So, encryption is just about XOR'ing really big numbers.

The most significant problem for encryption is key generation, storage, and sharing.  Alice encrypts her message and wants Bob to be able to decrypt and read it, but hide it from anyone else.  

Let's explore the first stage of that series:  key generation, as well as actual use, using the CommonCrypto library.  I've blogged about using the library

http://telliott99.blogspot.com/2015/12/commoncrypto.html

(plus three more directly after).

This code will work in a Swift Cocoa app that has a "bridging header".  (To get a bridging header, simply add an empty Objective-C file to the project, and click yes when asked whether you want Xcode to generate the header for you).  Then put

.. sourcecode:: bash

    #import <CommonCrypto/CommonCrypto.h>

in the header.  This won't work from the command line, but there is a trick to make the library available, which is explained in the post.

The first function below, we saw previously in :ref:`random` 

.. sourcecode:: bash

    import Foundation

    func randomBinaryData(n: Int = 1) -> [UInt8] {
        var buffer = [UInt8](
            count:n, repeatedValue: 0)
        SecRandomCopyBytes(
            kSecRandomDefault, n, &buffer)
        return buffer
    }

We'll use that function in what follows.  Let me list the code first and then explain it.

.. sourcecode:: bash

    import Foundation
    import CommonCrypto

    let pw = "password"
    print("pw: \(pw)")
    
    let pwBytes = pw.utf8.map { Int8($0) }
    let pwLen = pwBytes.count

    let saltLen = 6
    let salt = randomBinaryData(saltLen)
    print("salt: \(salt)")

    // zero a key buffer of the correct size
    let keyLen = Int(CC_SHA1_DIGEST_LENGTH)
    let key = Array<UInt8>(
        count:keyLen,
        repeatedValue:0)

    print("key length: \(keyLen)")
    
    let rounds = UInt32(1500001)

    CCKeyDerivationPBKDF(
        CCPBKDFAlgorithm(kCCPBKDF2),
        pw,
        pwLen,
        UnsafePointer<UInt8>(salt),
        saltLen,
        CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA1),
        rounds,
        UnsafeMutablePointer<UInt8>(key),
        keyLen)

    let mid = keyLen/2
    print(key[0..<mid])
    print(key[mid..<keyLen])

.. sourcecode:: bash

    > swift test.swift
    pw: password
    salt: [235, 82, 70, 120, 43, 26]
    key length: 20
    [158, 210, 102, 151, 70, 149, 83, 214, 90, 130]
    [154, 133, 96, 115, 174, 137, 140, 1, 3, 124]
    >

What is going on here?  The big picture is that the password has very little *entropy* (there aren't that many possible values).  Then we crank algorithm in the library 1.5 million times.  It takes about one second to do this.  The idea is to make it computationally expensive for a "password cracker" to turn a candidate into the correct answer.

We start with a String (hard-coded here as "password") and turn it first into utf8 and then into [UInt8].  Then, to that is added some random data as "salt".  Note that the salt really is *random* data (the PRNG is not seeded), so you will see a different output each time you run this.

The library function ``CCKeyDerivationPBKDF`` is used to "stretch" the key.  This is a C library, and in C, the common way to get data in and out of a function is to pass a pointer to data structure (because a function can only return a single value).  

In Swift these are marked ``UnsafePointer<UInt8>`` and ``UnsafeMutablePointer<UInt8>``, the latter being used for the key, because the function is going to write into that buffer.  It turns out that in some cases (like with ``pw`` here), you can pass an array or even a String.

If you want to figure out how many rounds are needed so that the computation takes 1000 ms, run this:

.. sourcecode:: bash

    let rounds = CCCalibratePBKDF(
        alg,
        pwLen,
        saltLen,
        hmac,
        Int(CC_SHA1_DIGEST_LENGTH),
        1000)

I found out the result is variable.  (unless you are in a Playground!).  So I just put in a number that is close.

