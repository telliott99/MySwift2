This project (MySwift) is a collection of working examples for various simple constructs in Swift, plus assorted other topics and advice.  Since I am a neophyte in Swift, this may not be useful to others, but I really constructed these pages for myself.

Update:

Swift 2 changes things significantly.  It's not just that ``print`` is substituted for ``println``.  Many global functions have disappeared.  For example, now we do ``array.sort()`` rather than ``sort(array)``.  I'm going to leave these docs up for reference, but be advised that many things need modification in order to run with Xcode 7.

They are on github because I wanted to improve my `git` fu, and practice using a remote repository.

As for the other "MyX" guides, the files posted here comprise the source to be used by [Sphinx][1] to generate pages in html.  The html is not part of this repository.  If you wish to generate it yourself, you need to install Sphinx (`pip install sphinx`) and then do `make html` from within the project directory.

It is also possible to ``make epub``, as well as other things.

[1]: http://sphinx-doc.org

Note:  the index feature does not work properly yet.