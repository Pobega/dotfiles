" basic settings
set nocompatible
set t_Co=256
set background=dark
colorscheme gruvbox
syntax on

" Plugins
" https://github.com/tpope/vim-fugitive
set runtimepath^=~/.vim/bundle/vim-fugitive
" https://github.com/airblade/vim-gitgutter
set runtimepath^=~/.vim/bundle/vim-gitgutter
" https://github.com/tpope/vim-sleuth
set runtimepath^=~/.vim/bundle/vim-sleuth

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

" Allow local .vimrc files
set exrc
" Secure them
set secure

" Open buffers in tab
:set switchbuf+=usetab,newtab

" :Make will call make and put errors in a small cwindow
command -nargs=* Make make! <args> | cwindow 3 | redraw!

" Ctrl-j to run Make
map <C-j> :Make<CR>

" :Grep will run :grep and open results in small cwindow
command! -nargs=+ Grep execute 'silent grep! <args>' | cwindow 3 | redraw!
" :todo - Use Grep to find all text files containing a TODO
" (cnoreabbrev allows lowercase named for user-defined commands)
cnoreabbrev todo execute 'Grep -Ri todo `find . -maxdepth 4 -type f \( ! -iname ".*swp" \)`'

" enable code folding by default
au BufNewFile,BufRead *.py set autoindent foldmethod=indent
au BufNewFile,BufRead *.lua set autoindent foldmethod=indent

