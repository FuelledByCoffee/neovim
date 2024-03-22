setlocal foldlevel=20
setlocal foldlevelstart=20
setlocal makeprg=make

setlocal path+=/Library/Developer/CommandLineTools/usr/include/c++/v1
setlocal path+=/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include
setlocal path+=/home/linuxbrew/.linuxbrew/include
setlocal path+=/opt/homebrew/include
setlocal path+=$HOME/.local/llvm/include/c++/v1

" Instead of syntax
setlocal foldmethod=expr
setlocal foldexpr=nvim_treesitter#foldexpr()

setlocal tabstop=3
setlocal softtabstop=3
setlocal shiftwidth=0
setlocal noexpandtab

autocmd filetype cpp setlocal keywordprg=:silent\ !tmux\ new-window\ cppman\ <cword>

" au QuickFixCmdPost [^l]* nested cwindow
" au QuickFixCmdPost    l* nested lwindow

nnoremap <buffer><leader>m :make<cr>
nnoremap <buffer><leader>r :make test<cr>
nnoremap <buffer><leader><bs> :!make clean<cr>
