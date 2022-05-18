# An April REPL
A simple command line REPL for [April](https://github.com/phantomics/april).

To use APL symbols in the terminal, you can follow the guides [here](https://aplwiki.com/wiki/Typing_glyphs).

Make sure you have [quicklisp](https://www.quicklisp.org/) in order to load April.
Run with `rlwrap sbcl --load repl.lisp`. All testing for this REPL has been done on SBCL.

Multiline definitions begin when you end a line with `{`, and they automatically end when all braces are closed.

