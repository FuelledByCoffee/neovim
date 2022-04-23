
function! LightlineFilename()
  let filename = expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
  let modified = &modified ? ' +' : ''
  let readonly = &readonly ? ' ' : ''
  return readonly . filename . modified
endfunction

function! LightlineBranch()
  let branchname = FugitiveHead()
  return branchname != '' ? ' ' . branchname : ''
endfunction

function! GitStatus()
  let [a,m,r] = GitGutterGetHunkSummary()
  return printf('+%d ~%d -%d', a, m, r)
endfunction

set statusline+=%{GitStatus()}
let g:lightline = {
      \ 'colorscheme': 'default',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'gitstatus', 'filename' ] ]
      \ },
      \ 'component_function': {
      \   'gitstatus' : 'GitStatus',
      \   'gitbranch' : 'LightlineBranch',
      \   'filename': 'LightlineFilename',
      \ },
      \ }

": Powerlineglyphs {{{
"                                          
": }}}
 
" let g:lightline.subseparator = { 'left': '│', 'right': '│' }
let g:lightline.separator = { 'left': " ", 'right': "" }
let g:lightline.subseparator = { 'left': "", 'right': "" }

let g:lightline.component_raw = { 'Hello' : 1 }

let g:lightline.mode_map = {
    \ 'n' : 'NORMAL',
    \ 'i' : 'INSERT',
    \ 'R' : 'REPLACE',
    \ 'v' : 'VISUAL',
    \ 'V' : 'V-LINE',
    \ "\<C-v>": 'V-BLOCK',
    \ 'c' : 'COMMAND',
    \ 's' : 'SELECT',
    \ 'S' : 'S-LINE',
    \ "\<C-s>": 'S-BLOCK',
    \ 't': 'TERMINAL',
    \ }

function! LightlineReadonly()
  return &ft !~? 'help\|vimfiler' && &readonly ? '' : ''
endfunction
