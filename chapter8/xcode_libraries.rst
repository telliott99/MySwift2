.. _xcode_libraries:

##################
Libraries in Xcode
##################

This is just a brief note about some things I've learned about trying to use libraries with Swift projects in Xcode.

First, something which isn't really Xcode, just an OS X thing.  The directory ``~/Library`` isn't visible in the Finder, nor are directories like ``/usr/local``.  I've always just navigated there in Terminal, but there are other options which may be easier.

For the first, you can hold down the OPTION key while doing Go in the menu from Finder.  The option will show ``Library``.  To avoid having to do this all the time, do CMD-J or View > Show View Options.  The resulting window will show a checkbox item "Show Library Folder".  But here's the thing:  this will only happen if you had a finder window open when you did CMD-J!!

.. image:: /figures/show_library.png
  :scale: 100 %

Even better, having ``Library`` displayed in the Finder, drag it to the sidebar in a Finder window (or its subdirectory ``Frameworks``, which is something I've used a lot in earlier sections).

One can also do CMD-SHIFT-G to obtain a search field to go to, say ``/usr/local`` in the Finder.  Having arrived, drag that guy to the sidebar as well.

.. image:: /figures/usr_local.png
  :scale: 100 %

----------------
Linked libraries
----------------

Adding a library to your project is as simple as navigating to the library in the Finder and then dragging it onto the appropriate spot in an Xcode project.  

Namely, with the Xcode project itself selected---top (blue) icon in the project navigator on the left hand side---and the General tab selected, scroll to the bottom and you will see

.. image:: /figures/linked_libraries.png
  :scale: 100 %

I have added two libraries to my project.  I got them from here

.. image:: /figures/libcrypto.png
  :scale: 100 %

The other thing you have to do is to tell Xcode where to find the headers.  Again with the project selected, this time select the Build Phases tab.  There are a lot of settings.  In the search box, type "Search".  You will see an area containing search paths:

.. image:: /figures/search_paths.png
  :scale: 100 %

An easy way to get the right path is to navigate there in the finder, then drag and drop the icon for that folder onto an open window in TextEdit, as shown.

.. image:: /figures/get_path.png
  :scale: 100 %

Typically you will want to set Header Search Paths to point to the ``include`` directory that holds the relevant ones.

Finally, when you have a "build failure" you need to read the fine print.  Here is one from something I am working on now.  The little caret is under the place where Xcode choked (actually, the preprocessor)

.. image:: /figures/openssl_error.png
  :scale: 100 %

Some code in ``openssl`` uses a function argument ``const BIGNUM *I``, but the trouble is, some previous code in the SDK (in complex.h), has already defined ``I``.  You can't have that.

http://stackoverflow.com/questions/24298632/compile-error-with-function-pointer-declaration

Unfortunately, this is not the last error I ran into with openssl.  So for the moment, I haven't got an example that works.
