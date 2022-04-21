autocmd FileType c,cpp,objc nnoremap <buffer><leader>f :<C-u>ClangFormat<CR>
autocmd FileType c,cpp,objc xnoremap <buffer><leader>f :ClangFormat<CR>
autocmd FileType c,cpp,objc nmap             <leader>C :ClangFormatAutoToggle<CR>
