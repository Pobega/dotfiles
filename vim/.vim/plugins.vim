" Third party plugin stuff

" colorscheme fallback (if submodule not cloned)
try
  colorscheme gruvbox " https://github.com/morhetz/gruvbox
catch
  colorscheme desert  " fallback built-in colorscheme
endtry

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" mu-complete
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Automatically complete when typing
let g:mucomplete#enable_auto_at_startup = 1
" No autocomplete delay
let g:mucomplete#completion_delay = 0
" Paths are relative to the open buffer
let g:mucomplete#buffer_relative_paths = 0

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Jedi-Vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Disable Docstrings by default in jedi-vim
autocmd FileType python setlocal completeopt-=preview
" Jedi write call signatures to status line
let g:jedi#show_call_signatures = 2
" Popup autocomplete when typing a dot character
let g:jedi#popup_on_dot = 1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Python-Vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable extended highlighting
let g:python_highlight_all = 1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Clang_Complete
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use clang library instead of executable (faster)
let g:clang_use_library=1
" Disable auto popup, use <Tab> to autocomplete
let g:clang_complete_auto = 0
" Show clang errors in the quickfix window
let g:clang_complete_copen = 1
