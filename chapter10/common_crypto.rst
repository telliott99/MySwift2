.. _common_crypto:

##################
Using CommonCrypto
##################

We saw an introduction to :ref:`encryption` already.  In the previous section (:ref:`common_crypto_setup`), we did some setup to allow expanded application of the Common Crypto library.  

Now, open a new Swift Playground and do this:

import CommonCrypto
print(print(CC_SHA1_DIGEST_LENGTH))

If you type slowly Xcode will do a suggested completion for you.  It already knows.  Paste in the following code:

.. sourcecode:: swift

    let s = "The quick brown fox jumps over the lazy dog."
    let n = Int(CC_MD5_DIGEST_LENGTH)
    let len = CC_LONG(s.utf8.count)

    let ctx = UnsafeMutablePointer<CC_MD5_CTX>.alloc(1)
    var digest = Array<UInt8>(count:n, repeatedValue:0)

    CC_MD5_Init(ctx)
    CC_MD5_Update(ctx, s, len)
    CC_MD5_Final(&digest, ctx)

    ctx.dealloc(1)

    digest

.. image:: /figures/CC1.png
  :scale: 100 %

Now let's do some encryption and decryption.  I'll put the code and the output and then we can talk about it afterward:

``test.swift``:

.. sourcecode:: swift

    import Foundation
    import CommonCrypto
    import Security

    let key = "asecret16bytekey"
    let keyLen = key.utf8.count

    let msg = "message"
    let msgLen = msg.utf8.count
    let msgBytes = [UInt8](msg.utf8)
    print("msgBytes:  \(msgBytes)")


    let operation = CCOperation(kCCEncrypt)
    let algorithm = CCAlgorithm(kCCAlgorithmAES)
    let options = CCOptions(kCCOptionPKCS7Padding | kCCOptionECBMode)

    // AES128 block size is 16 bytes or 128 bits
    let blockSize = 128
    let bufferSize = 128
    var cipherData = [UInt8](count: bufferSize, repeatedValue: 0)
    var resultLen = 0
    var status: Int32 = 0

    status = CCCrypt(
        operation,
        algorithm,
        options,
        key,
        keyLen,  // can do size_t(keyLen) but unnecessary
        //iv,
        nil,
        msg,
        msgLen,
        UnsafeMutablePointer<Void>(cipherData),
        bufferSize,
        &resultLen)

    print("\nstatus:  \(status)")
    print("resultLen:  \(resultLen)")
    print("cipherData:  \(cipherData[0..<8])")
    print("cipherData:  \(cipherData[8..<16])")
    print("cipherData:  \(cipherData[16..<24])")

    /* decryption */

    var decrypted = [UInt8](count: bufferSize, repeatedValue: 0)

    status = CCCrypt(
        CCOperation(kCCDecrypt),
        algorithm,
        options,
        key,
        keyLen,
        // iv,
        nil,
        cipherData,
        bufferSize,
        UnsafeMutablePointer<Void>(decrypted),
        bufferSize,
        &resultLen)

    print("\nstatus:  \(status)")
    print("resultLen:  \(resultLen)")
    print("decrypted:  \(decrypted[0..<8])")
    print("decrypted:  \(decrypted[8..<16])")
    print("decrypted:  \(decrypted[16..<24])")

Output:

.. sourcecode:: bash

    msgBytes:  [109, 101, 115, 115, 97, 103, 101]

    status:  0
    resultLen:  16
    cipherData:  [212, 142, 248, 154, 122, 235, 247, 231]
    cipherData:  [52, 217, 175, 131, 206, 45, 107, 146]
    cipherData:  [0, 0, 0, 0, 0, 0, 0, 0]

    status:  0
    resultLen:  128
    decrypted:  [109, 101, 115, 115, 97, 103, 101, 9]
    decrypted:  [9, 9, 9, 9, 9, 9, 9, 9]
    decrypted:  [138, 157, 241, 62, 58, 5, 71, 96]
    >

We encrypt and decrypt using AES, using ECB mode, where the plaintext message is padded to 16 bytes.  "mysecret" is ASCII:

.. sourcecode:: bash

    [109, 101, 115, 115, 97, 103, 101]

CBC mode requires an "initialization vector" but the current mode, ECB, does not.

It's wild, but we are allowed to pass the key and the msg as String types.

We pass in a reference to an Int to hold the result length, and the status is the return value of the function, an Int32.  A returned status of 0 indicates success.  The return codes for an error are odd:  -4301 ..  You can read more about that in the header which is online 

http://www.opensource.apple.com/source/CommonCrypto/CommonCrypto-36064/CommonCrypto/CommonCryptor.h

or you can search and find it at ``/usr/include/CommonCrypto/CommonCryptor.h`` (or in the SDK).


One tricky part is that we have to pass ``UnsafeMutablePointer<Void>(cipherData)`` and ``UnsafeMutablePointer<Void>(decrypted)`` buffers *of the correct size*.

The message is padded to 16 bytes and it's not surprising that after encryption, the first 16 bytes of the cipherData are non-zero, while those following are still zero.

We obtain the correct result in decrypted, followed by a series of ``9`` until we reach the size 16.  Somewhat surprising to me, the rest of the buffer has also been filled up with junk.  I am not sure why the value of ``9`` is but it's not too surprising that they pad out to byte 16.

Rather than write any more about it now, I will just point you to the blog posts I did on this.  They include an example using CBC mode, a longer example where the message is encrypted and decrypted in chunks, and a Framework called Encryptor that bundles up all this functionality.  

http://telliott99.blogspot.com/2015/12/commoncrypto2.html

http://telliott99.blogspot.com/2015/12/commoncrypto3.html
