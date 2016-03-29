expresso.vim
============

Expresso evaluates text as a math expression, replacing the text with the result.

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

- `g=` after selecting text with `v`/`V`. The selected text will be replaced with the result.

### Normal mode

- `g=` with a motion. For example, `g=$` evaluates text from the cursor to the end of the line.
- `g==` evaluates the current line.

### Command mode

- With a range like `:1,7Expresso`

License
-------

MIT
