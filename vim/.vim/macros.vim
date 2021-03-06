" Usability macros

" Ctrl-j to run make
map <C-j> :make<CR>
" K for showing documentation for code under cursor
setlocal keywordprg=:LspHover

" :Grep will run :grep and open results in small cwindow
command! -nargs=+ Grep execute 'silent grep! <args>' | cwindow 3 | redraw!
" :todo - Use Grep to find all text files containing a TODO
" (cnoreabbrev allows lowercase named for user-defined commands)
cnoreabbrev todo execute 'Grep -Ri todo `find . -maxdepth 4 -type f \( ! -iname ".*swp" \)`'

au BufNewFile,BufRead *.rs map <C-k> :Crun<CR>
au BufNewFile,BufRead *.rs map <C-l> :Ctest<CR>
