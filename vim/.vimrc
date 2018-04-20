" basic settings
set nocompatible
colorscheme desert
set t_Co=256
set background=dark
syntax on

" Plugins
" https://github.com/tpope/vim-fugitive
set runtimepath^=~/.vim/bundle/vim-fugitive
" https://github.com/airblade/vim-gitgutter
set runtimepath^=~/.vim/bundle/vim-gitgutter
" https://github.com/tpope/vim-sleuth
set runtimepath^=~/.vim/bundle/vim-sleuth

" Python specific configuration
" enable code folding by default
au BufNewFile,BufRead *.py set autoindent foldmethod=indent

" black highlighting
set cursorcolumn
set cursorline
hi CursorColumn cterm=NONE ctermbg=8 ctermfg=NONE
hi CursorLine cterm=NONE ctermbg=8 ctermfg=NONE

" code folding hotkeys
nnoremap <space> za
vnoremap <space> zf

" xclip hotkeys. Y to yank to clipboard, P to paste from clipboard
map Y :w !xclip -selection clipboard<CR><CR>
map P :r!xclip -o -selection clipboard<CR>

" match extra whitespace as an error
match ErrorMsg '\s\+$'

" disable mouse
set mouse=
set ttymouse=

" compatible with transparency
hi Normal ctermbg=none

" show filename in status
set statusline+=%f\ %=line\,col\:\ %l\,\ %c
" always show status
set laststatus=2

" Git commit message specific configuration
autocmd FileType gitcommit setlocal spell
autocmd FileType gitcommit setlocal textwidth=80

" F4 to run code
"autocmd filetype python nnoremap <F4> :w <bar> exec '!python '.shellescape('%')<CR>
"autocmd filetype c nnoremap <F4> :w <bar> exec '!gcc '.shellescape('%').' -o '.shellescape('%:r').' && ./'.shellescape('%:r')<CR>
"autocmd filetype cpp nnoremap <F4> :w <bar> exec '!g++ '.shellescape('%').' -o '.shellescape('%:r').' && ./'.shellescape('%:r')<CR>

