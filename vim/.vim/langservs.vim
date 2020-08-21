" Language server configurations
"
" https://github.com/prabirshrestha/asyncomplete.vim#sources
" https://github.com/prabirshrestha/vim-lsp/wiki/Servers


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" rust
""" rustup install rls
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if executable('rls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'rls',
        \ 'cmd': {server_info->['rustup', 'run', 'stable', 'rls']},
        \ 'whitelist': ['rust'],
        \ })
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" python
""" pip install python-language-server[all]
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if executable('pyls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'whitelist': ['python'],
        \ })
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" clang (C/C++)
""" [Fedora]  dnf install clang-tools-extra
""" [RHEL]    yum install clang
""" [Debian]  apt-get install clang-tools
""" [Ubuntu]  apt-get install clang-5.0
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if executable('clangd')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'clangd',
        \ 'cmd': {server_info->['clangd', '-background-index']},
        \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
        \ })
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Go
" go get -u golang.org/x/tools/gopls
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if executable('gopls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'gopls',
        \ 'cmd': {server_info->['gopls']},
        \ 'whitelist': ['go'],
        \ })
    autocmd BufWritePre *.go LspDocumentFormatSync
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Ruby
" gem install solargraph
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if executable('solargraph')
    " gem install solargraph
    au User lsp_setup call lsp#register_server({
        \ 'name': 'solargraph',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'solargraph stdio']},
        \ 'initialization_options': {"diagnostics": "true"},
        \ 'whitelist': ['ruby'],
        \ })
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Javascript
" npm install typescript typescript-language-server
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if executable('typescript-language-server')
    au User lsp_setup call lsp#register_server({
      \ 'name': 'javascript support using typescript-language-server',
      \ 'cmd': { server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
      \ 'root_uri': { server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_directory(lsp#utils#get_buffer_path(), '.git/..'))},
      \ 'whitelist': ['javascript', 'javascript.jsx', 'javascriptreact']
      \ })
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Docker
" npm install dockerfile-language-server-nodejs
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if executable('docker-langserver')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'docker-langserver',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'docker-langserver --stdio']},
        \ 'whitelist': ['dockerfile'],
        \ })
endif
