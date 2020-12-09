" Third party plugin stuff

" colorscheme fallback (if submodule not cloned)
try
  colorscheme gruvbox " https://github.com/morhetz/gruvbox
catch
  colorscheme desert  " fallback built-in colorscheme
endtry

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Python-Vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable extended highlighting
let g:python_highlight_all = 1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" rust.vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" 4 space indents and textwidth 99
let g:rust_recommended_style = 1
""" code folding
let g:rust_fold = 1
""" Open :Crun terminal in a new tab rather than a window
let g:cargo_shell_command_runner = 'tab :terminal'
