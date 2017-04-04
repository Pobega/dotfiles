" basic settings
set nocompatible
set t_Co=256
colorscheme gruvbox
set background=dark
syntax on


" 4 space tabs
set tabstop=4
set shiftwidth=4
set softtabstop=4
set smartindent
set expandtab

" Python specific configuration
au BufNewFile,BufRead *.py set autoindent foldmethod=indent

" C specific configuration
au BufNewFile,BufRead *.c set tabstop=8
au BufNewFile,BufRead *.h set tabstop=8

" black highlighting
set cursorcolumn
set cursorline
hi CursorColumn cterm=NONE ctermbg=16 ctermfg=NONE
hi CursorLine cterm=NONE ctermbg=16 ctermfg=NONE

" code folding hotkeys
nnoremap <space> za
vnoremap <space> zf

" match extra whitespace as an error
match ErrorMsg '\s\+$'

" compatible with transparency
hi Normal ctermbg=none
