setlocal spell

" https://unix.stackexchange.com/a/475219/183703
au! VimEnter COMMIT_EDITMSG exec 'norm gg' | startinsert!
