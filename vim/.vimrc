set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
" plugin on GitHub repo
Plugin 'tpope/vim-sleuth'
" Git plugin diff stuff
Plugin 'airblade/vim-gitgutter'
" Colorscheme
"Plugin 'morhetz/gruvbox'
"Plugin 'altercation/vim-colors-solarized'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" basic settings
set nocompatible
colorscheme desert
set t_Co=256
set background=dark
syntax on

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

" match extra whitespace as an error
match ErrorMsg '\s\+$'

" compatible with transparency
hi Normal ctermbg=none

" show filename in status
set statusline+=%f\ %=line\,col\:\ %l\,\ %c
" always show status
set laststatus=2

" F4 to run code
"autocmd filetype python nnoremap <F4> :w <bar> exec '!python '.shellescape('%')<CR>
"autocmd filetype c nnoremap <F4> :w <bar> exec '!gcc '.shellescape('%').' -o '.shellescape('%:r').' && ./'.shellescape('%:r')<CR>
"autocmd filetype cpp nnoremap <F4> :w <bar> exec '!g++ '.shellescape('%').' -o '.shellescape('%:r').' && ./'.shellescape('%:r')<CR>

