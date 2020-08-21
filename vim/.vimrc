" basic settings
set nocompatible
set t_Co=256
set background=dark
syntax on

" Load plugin stuff
source ~/.vim/plugins.vim

" Load macros
source ~/.vim/macros.vim

" black highlighting
set cursorcolumn
set cursorline
hi CursorColumn cterm=NONE ctermbg=8 ctermfg=NONE
hi CursorLine cterm=NONE ctermbg=8 ctermfg=NONE

" code folding hotkeys
nnoremap <space> za
vnoremap <space> zf

" xclip hotkeys.
" Y to yank to clipboard
map Y :w !xclip -selection clipboard<CR><CR>
" P to paste from clipboard
map P :r!xclip -o -selection clipboard<CR>

" tab hotkeys
" open new tab
map gC :tabe
" close current tab
map gc :tabclose<CR>

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
autocmd FileType gitcommit setlocal textwidth=72

" Allow local .vimrc files
set exrc
" Secure them
set secure

" Open buffers in tab
:set switchbuf+=usetab,newtab

" Shut off completion messages
set shortmess+=c
" If Vim beeps during completion
set belloff+=ctrlg
