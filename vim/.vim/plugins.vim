" Third party plugin stuff

" colorscheme fallback (if submodule not cloned)
try
  colorscheme gruvbox " https://github.com/morhetz/gruvbox
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme desert  " fallback built-in colorscheme
endtry

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Git
" https://github.com/tpope/vim-fugitive
set runtimepath^=~/.vim/bundle/vim-fugitive
" https://github.com/airblade/vim-gitgutter
set runtimepath^=~/.vim/bundle/vim-gitgutter

"" Tabstop
" https://github.com/tpope/vim-sleuth
set runtimepath^=~/.vim/bundle/vim-sleuth

"" Coding
" https://github.com/ervandew/supertab
set runtimepath^=~/.vim/bundle/supertab
" https://github.com/davidhalter/jedi-vim
set runtimepath^=~/.vim/bundle/jedi-vim
" https://github.com/Rip-Rip/clang_complete
set runtimepath^=~/.vim/bundle/clang_complete

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Supertab
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Default Supertab to omnicompletion, fallback to context completion
let g:SuperTabDefaultCompletionType = 'context'
autocmd FileType *
  \ if &omnifunc != '' |
  \   call SuperTabChain(&omnifunc, "<c-n>") |
  \   call SuperTabSetDefaultCompletionType("<c-x><c-o>") |
  \ endif

" move from top->bottom rather than bottom->top
let g:SuperTabMappingForward  = '<s-tab>'
let g:SuperTabMappingBackward = '<tab>'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Jedi-Vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Disable Docstrings by default in jedi-vim
autocmd FileType python setlocal completeopt-=preview

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Clang_Complete
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use clang library instead of executable (faster)
let g:clang_use_library=1
" Disable auto popup, use <Tab> to autocomplete
let g:clang_complete_auto = 0
" Show clang errors in the quickfix window
let g:clang_complete_copen = 1
