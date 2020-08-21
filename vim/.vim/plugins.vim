" Third party plugin stuff

" colorscheme fallback (if submodule not cloned)
try
  colorscheme gruvbox " https://github.com/morhetz/gruvbox
catch
  colorscheme desert  " fallback built-in colorscheme
endtry

" Load language server configurations
source ~/.vim/langservs.vim

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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" rust.vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" 4 space indents and textwidth 99
let g:rust_recommended_style = 1
""" code folding
let g:rust_fold = 1
""" Open :Crun terminal in a new tab rather than a window
let g:cargo_shell_command_runner = 'tab :terminal'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" asyncomplete
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" Force refresh completion
imap <c-space> <Plug>(asyncomplete_force_refresh)
""" Auto popup
let g:asyncomplete_auto_popup = 0
""" Menu options
let g:asyncomplete_auto_completeopt = 0
set completeopt=menuone,noinsert,noselect,preview
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif
""" Tab to complete
function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ asyncomplete#force_refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-lsp
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" Omnifunc
set omnifunc=lsp#complete
""" folding
set foldmethod=expr
  \ foldexpr=lsp#ui#vim#folding#foldexpr()
  \ foldtext=lsp#ui#vim#folding#foldtext()
""" signs
let g:lsp_signs_enabled = 1         " enable signs
let g:lsp_diagnostics_echo_cursor = 1 " enable echo under cursor when in normal mode
""" highlight references
let g:lsp_highlight_references_enabled = 1
""" disable documentation float
let g:lsp_documentation_float = 0
