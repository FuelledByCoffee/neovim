autocmd FileType c,cpp,objc,json nnoremap <buffer><leader>f :<C-u>ClangFormat<CR>
autocmd FileType c,cpp,objc,json xnoremap <buffer><leader>f :ClangFormat<CR>
autocmd FileType c,cpp,objc,json nmap             <leader>C :ClangFormatAutoToggle<CR>
