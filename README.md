expresso.vim
============

Evaluate text as a math expression and replace it with the result.

![screenshot](https://cloud.githubusercontent.com/assets/199775/14120183/84e7a998-f5a6-11e5-8e5a-2856ee4e2f91.gif)

Installation
------------

Using [vim-plug](https://github.com/junegunn/vim-plug):

```vim
Plug 'm1foley/vim-expresso'
```

Usage
-----

### Visual mode

- `g=` after selecting text replaces it with the result.

### Normal mode

- `g=` with a motion. For example, `g=$` evaluates text from the cursor to the end of the line.
- `g==` evaluates the current line.

### Command mode

- With a range like `:1,7Expresso`

Limitations
-------------

Expresso uses Vim expressions, so it has the same limitations of `@=`, the expression register. If none of the numbers have a decimal, it evaluates to a whole number: `3/2` = `1`. To force a `Float` conversion, add a decimal to one of the numbers: `3/2.0` = `1.5`

Similar Projects
----------------
- [crunch](https://github.com/arecarn/crunch.vim) is a more powerful & expressive math plugin, and gets around the `Float` conversion issue.

License
-------

MIT
