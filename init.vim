" vim: foldlevel=0

": Plugins {{{

": Install vim-plug if not found {{{
let home=$HOME.'/.config/nvim'
let plug_file=home.'/autoload/plug.vim'
let plug_address='https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

if !filereadable(plug_file)
  silent exe '!curl '.plug_address.' --create-dirs -o '.plug_file
endif
": }}}

call plug#begin(home.'/plugged')

Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Completion
" Plug 'hrsh7th/nvim-cmp'
" Plug 'hrsh7th/cmp-nvim-lsp'
" Plug 'hrsh7th/cmp-buffer'
" Plug 'hrsh7th/cmp-path'
Plug 'L3MON4D3/LuaSnip'

Plug 'airblade/vim-gitgutter'
Plug 'christianchiarulli/nvcode-color-schemes.vim'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'tversteeg/registers.nvim', { 'branch': 'main' }

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'tpope/vim-fugitive'
" Plug 'tpope/vim-surround'

Plug 'mhinz/vim-startify'
Plug 'ryanoasis/vim-devicons'
Plug 'kyazdani42/nvim-web-devicons' " Nice icons for telescope

Plug 'scrooloose/nerdcommenter'

Plug 'preservim/nerdtree'
Plug 'preservim/tagbar'

Plug 'rust-lang/rust.vim'
Plug 'rhysd/vim-clang-format'

call plug#end()


" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
    \| PlugInstall --sync | source $MYVIMRC
    \| endif


": }}}

": Settings {{{

let mapleader = ','
let g:c_syntax_for_h=1
let @/ = "" " Don't highlight after source vimrc

syntax on

set mouse=a
set nonumber
set autoread
set hidden
set nobackup
set nowritebackup
set hlsearch
set incsearch
set splitright
set splitbelow
set foldlevel=0
set foldmethod=marker
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set ignorecase
set smartcase
set smartindent
set smarttab
set scrolloff=7
set sidescrolloff=5
set undolevels=100    " How many undos
set undoreload=1000   " number of lines to save for undo
set undofile          " Save undos after file closes
set wildmenu
set wildignorecase    " case is ignored when completing file names and directories
set shortmess+=c      " Silence insert completion messages
set completeopt=menu,menuone,noselect
set omnifunc=syntaxcomplete#Complete
set cursorline
set showtabline=2
set noshowmode
set termguicolors
set encoding=UTF-8
set fillchars=eob:\ ,fold:\ ,
set diffopt+=vertical
set updatetime=100
set grepprg=rg
set belloff+=ctrlg
set signcolumn=yes

filetype plugin on
filetype indent on

autocmd filetype help wincmd L

" jump to previous position when reopening a file
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
      \| exe "normal! g'\""
      \| endif


lua require('tree-sitter-config')
lua require('lsp-config')
" lua require('cmp-config')
lua require'colorizer'.setup()

": }}}

": Key maps {{{

inoremap jj <esc>

nnoremap <leader>w :w<cr>
nnoremap <leader>q :q<cr>
nnoremap <leader>d :bd<cr>
nnoremap <leader>Q :qa<cr>
nnoremap <leader>m :make<cr>

nnoremap <silent><tab>    :bnext<cr>
nnoremap <silent><s-tab>  :bNext<cr>

xnoremap <tab>   >gv
xnoremap <S-tab> <gv

inoremap <expr> <tab>   pumvisible() ? "\<C-n>" : "<tab>"
inoremap <expr> <S-tab> pumvisible() ? "\<C-p>" : "<S-tab>"

nnoremap <silent>ø zA

nnoremap <silent><leader>\| <C-W>L

" Move between splits
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l
nnoremap <C-H> <C-W>h

nnoremap <silent> √ :move+<CR>
nnoremap <silent> ª :move-2<CR>

nnoremap <silent> // :noh<cr>

" Navigate through quick-fix errors
nnoremap <C-N> :cn<CR>
nnoremap <C-P> :cp<CR>
nnoremap <silent>co :copen<CR>
nnoremap <silent>cc :cclose<CR>

nnoremap <leader>y "*y
nnoremap <leader>p "*p

inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O

" Escape from terminal mode
tnoremap <Esc> <C-\><C-n>
nnoremap <silent> <leader>e :NERDTreeToggle<CR>


" Show syntax highlighting groups for word under cursor
command! CheckHighlightUnderCursor echo {l,c,n ->
      \   'hi:'    . synIDattr(synID(l, c, 1), n)             . ' -> '
      \  .'trans:' . synIDattr(synID(l, c, 0), n)             . ' -> '
      \  .'lo:'    . synIDattr(synIDtrans(synID(l, c, 1)), n)
      \ }(line("."), col("."), "name")
nmap <F2> <cmd>CheckHighlightUnderCursor<cr>


function! TrimWhitespace()
  let l:save = winsaveview()
  keeppatterns %s/\s\+$//e
  call winrestview(l:save)
endfun
nnoremap <leader><space> :call TrimWhitespace()<cr>

": }}}

": Floating terminal {{{

" Floating Term
let s:float_term_border_win = 0
let s:float_term_win = 0
function! FloatTerm(...)
  " Configuration
  let height = float2nr((&lines - 2) * 0.6)
  let row = float2nr((&lines - height) / 2)
  let width = float2nr(&columns * 0.6)
  let col = float2nr((&columns - width) / 2)
  " Border Window
  let border_opts = {
        \ 'relative': 'editor',
        \ 'row': row - 1,
        \ 'col': col - 2,
        \ 'width': width + 4,
        \ 'height': height + 2,
        \ 'style': 'minimal'
        \ }
  " Terminal Window
  let opts = {
        \ 'relative': 'editor',
        \ 'row': row,
        \ 'col': col,
        \ 'width': width,
        \ 'height': height,
        \ 'style': 'minimal'
        \ }
  let top = "╭" . repeat("─", width + 2) . "╮"
  let mid = "│" . repeat(" ", width + 2) . "│"
  let bot = "╰" . repeat("─", width + 2) . "╯"
  let lines = [top] + repeat([mid], height) + [bot]
  let bbuf = nvim_create_buf(v:false, v:true)
  call nvim_buf_set_lines(bbuf, 0, -1, v:true, lines)
  let s:float_term_border_win = nvim_open_win(bbuf, v:true, border_opts)
  let buf = nvim_create_buf(v:false, v:true)
  let s:float_term_win = nvim_open_win(buf, v:true, opts)
  " Styling
  hi FloatWinBorder guifg=#4499f7
  call setwinvar(s:float_term_border_win, '&winhl', 'Normal:FloatWinBorder')
  call setwinvar(s:float_term_win, '&winhl', 'Normal:Normal')
  if a:0 == 0
    terminal
  else
    call termopen(a:1)
  endif
  startinsert
  " Close border window when terminal window close
  autocmd TermClose * ++once :bd! | call nvim_win_close(s:float_term_border_win, v:true)
endfunction

" Open terminal
nnoremap <Leader>at :call FloatTerm()<CR>
" Open tig, yes TIG, A FLOATING TIGGGG!!!!!!
nnoremap <Leader>ag :call FloatTerm('"tig"')<CR>

" Terminal Function
let g:term_buf = 0
let g:term_win = 0
function! TermToggle(height, command)

  if win_gotoid(g:term_win)
    hide
    return
  endif

  botright new
  exec "resize " . a:height
  try
    exec "buffer " . g:term_buf
  catch
    call termopen(a:command , {"detach": 0})
    let g:term_buf = bufnr("")
    set nonumber
    set norelativenumber
    set signcolumn=no
  endtry
  startinsert!
  let g:term_win = win_getid()
endfunction

" Toggle terminal on/off (neovim)
nnoremap <silent><leader>t :call TermToggle(12, $SHELL)<CR>
nnoremap <silent><leader>r :call TermToggle(12, "make test")<CR>
tnoremap <silent><leader>t <C-\><C-n>:call TermToggle(12, $SHELL)<CR>


": }}}

": Colorscheme {{{

let g:nvcode_termcolors=256

" No background color. Persist after setting colorscheme.
" Only sets when colorsceme is set
au colorscheme * highlight Normal             ctermbg=NONE guibg=NONE
au colorscheme * highlight NonText            ctermbg=NONE guibg=NONE
au colorscheme * highlight Text               ctermbg=NONE guibg=NONE
au colorscheme * highlight LineNr             ctermbg=NONE guibg=NONE
au colorscheme * highlight CursorLineNR       ctermbg=NONE guibg=NONE
au colorscheme * highlight SignColumn         ctermbg=NONE guibg=NONE
au colorscheme * highlight EndOfBuffer        ctermfg=NONE guifg=NONE

" au colorscheme * highlight folded             ctermbg=NONE guibg=NONE
" au colorscheme * highlight FoldColumn         ctermbg=NONE guibg=NONE

set background=dark
colorscheme primary
": }}}

": airline {{{
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 0
let g:airline#extensions#tabline#show_tab_nr = 0
let g:airline_theme='powerlineish'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#whitespace#mixed_indent_algo = 2
let g:airline_detect_modified = 0
let g:airline_skip_empty_sections = 0

" let g:airline_left_sep=''
" let g:airline_right_sep=''
": }}}
