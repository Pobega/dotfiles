" Third party plugin stuff

" colorscheme fallback (if submodule not cloned)
try
  colorscheme gruvbox " https://github.com/morhetz/gruvbox
catch
  colorscheme desert  " fallback built-in colorscheme
endtry

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" Git
" https://github.com/tpope/vim-fugitive
set runtimepath^=~/.vim/bundle/vim-fugitive
" https://github.com/airblade/vim-gitgutter
set runtimepath^=~/.vim/bundle/vim-gitgutter

""" Tabstop
" https://github.com/tpope/vim-sleuth
set runtimepath^=~/.vim/bundle/vim-sleuth

""" Coding
"" Autocomplete
" https://github.com/ervandew/vim-mucomplete
set runtimepath^=~/.vim/bundle/vim-mucomplete
" https://github.com/davidhalter/jedi-vim
set runtimepath^=~/.vim/bundle/jedi-vim
" https://github.com/Rip-Rip/clang_complete
set runtimepath^=~/.vim/bundle/clang_complete

"" Syntax highlighting
" https://github.com/justinmk/vim-syntax-extra
set runtimepath^=~/.vim/bundle/vim-syntax-extra
" https://github.com/justinmk/python-syntax
set runtimepath^=~/.vim/bundle/python-syntax

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
