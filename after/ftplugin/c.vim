setlocal foldlevel=20
setlocal foldlevelstart=20
setlocal makeprg=make
setlocal fo-=o

setlocal path+=/Library/Developer/CommandLineTools/usr/include/c++/v1
setlocal path+=/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include

" Instead of syntax
setlocal foldmethod=expr
setlocal foldexpr=nvim_treesitter#foldexpr()

setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal expandtab

autocmd filetype cpp setlocal keywordprg=:silent\ !tmux\ new-window\ cppman\ <cword>

" au QuickFixCmdPost [^l]* nested cwindow
" au QuickFixCmdPost    l* nested lwindow

nnoremap <buffer><leader>m :make<cr>
nnoremap <buffer><leader>r :make test<cr>
nnoremap <buffer><leader><bs> :!make clean<cr>
