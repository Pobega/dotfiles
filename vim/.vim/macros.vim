" Usability macros

" :Make will call `make`
command -nargs=* Make make! <args> | redraw!

" Ctrl-j to run Make
map <C-j> :Make<CR>

" :Grep will run :grep and open results in small cwindow
command! -nargs=+ Grep execute 'silent grep! <args>' | cwindow 3 | redraw!
" :todo - Use Grep to find all text files containing a TODO
" (cnoreabbrev allows lowercase named for user-defined commands)
cnoreabbrev todo execute 'Grep -Ri todo `find . -maxdepth 4 -type f \( ! -iname ".*swp" \)`'
