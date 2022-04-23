let g:gitgutter_map_keys             = 0
let g:gitgutter_set_sign_backgrounds = 1
let g:gitgutter_grep                 = 'rg'
let g:gitgutter_highlight_lines      = 0
let g:gitgutter_highlight_linenrs    = 0
let g:gitgutter_preview_win_floating = 1

let g:gitgutter_sign_added                   = '+'
let g:gitgutter_sign_modified                = '~'
let g:gitgutter_sign_removed                 = '_'
let g:gitgutter_sign_removed_first_line      = '‾'
let g:gitgutter_sign_removed_above_and_below = '_¯'
let g:gitgutter_sign_modified_removed        = '~-'

set foldtext=gitgutter#fold#foldtext()

command! Gqf GitGutterQuickFix | copen
nnoremap <leader>G :Gqf<cr>

nmap <leader>ga <Plug>(GitGutterStageHunk)
nmap <leader>gu <Plug>(GitGutterUndoHunk)
nmap         gp <Plug>(GitGutterPreviewHunk)

nmap <leader>g[ <Plug>(GitGutterPrevHunk)
nmap <leader>g] <Plug>(GitGutterNextHunk)

" Defaults
" hi link GitGutterAdd          DiffAdd
" hi link GitGutterChange       DiffChange
" hi link GitGutterDelete       DiffDelete
" hi link GitGutterChangeDelete DiffChange

" Not default but not used
" hi link GitGutterAddLineNr          DiffAdd
" hi link GitGutterChangeLineNr       DiffChange
" hi link GitGutterDeleteLineNr       DiffDelete
" hi link GitGutterChangeDeleteLineNr DiffChange
