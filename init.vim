" vim: foldmethod=marker foldlevel=0 nowrap

": Plugins {{{

": Install vim-plug if not found {{{
let home=$HOME.'/.config/nvim'
let plug_file=home.'/autoload/plug.vim'
let plug_address='https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

if !filereadable(plug_file)
  silent exe '!curl '.plug_address.' --create-dirs -fLo '.plug_file
endif
": }}}

call plug#begin(home.'/plugged')

" LSP 
Plug 'onsails/lspkind.nvim' " VS Code like pictograms
Plug 'neovim/nvim-lspconfig'

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

" Syntax highlighting
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'nvim-treesitter/playground'

" Completion
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-path'

" Debugging
Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'

" Snippets
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

Plug 'norcalli/nvim-colorizer.lua'
Plug 'tversteeg/registers.nvim', { 'branch': 'main' }

Plug 'nvim-lualine/lualine.nvim'
Plug 'folke/trouble.nvim'

Plug 'airblade/vim-gitgutter'

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'

Plug 'junegunn/vim-easy-align'

Plug 'ryanoasis/vim-devicons'
Plug 'kyazdani42/nvim-web-devicons' " Nice icons for telescope

Plug 'scrooloose/nerdcommenter'

Plug 'preservim/nerdtree',     { 'on':  'NERDTreeToggle' }
Plug 'preservim/tagbar',       { 'on':  'TagbarToggle' }
Plug 'rhysd/vim-clang-format', { 'on':  'ClangFormat' }
Plug 'rust-lang/rust.vim',     { 'for': 'rust' }

call plug#end()


" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
    \| PlugInstall --sync | source $MYVIMRC
    \| endif


": }}}

": Settings {{{

let mapleader = ','
let g:c_syntax_for_h=0
let @/ = "" " Don't highlight after source vimrc
let &showbreak = '>'

syntax on
colorscheme primary

set mouse=a
set number
set laststatus=3
set autoread
set autowrite
set nowrap
set hidden            " Modify buffers not in view
set nobackup
set nowritebackup
set hlsearch
set incsearch
set splitright
set splitbelow
set path=.,/usr/local/include,/usr/local/src,/usr/include
set foldlevel=0
set foldmethod=marker
set tabstop=2
set softtabstop=2
set shiftwidth=2
set noexpandtab
set ignorecase
set smartcase
set smartindent
set smarttab
set breakindent
set breakindentopt=shift:2,min:40,sbr
set scrolloff=7
set sidescrolloff=5
set undolevels=100    " How many undos
set undoreload=1000   " number of lines to save for undo
set undofile          " Save undos after file closes
set wildmenu
set wildignorecase    " case is ignored when completing file names and directories
set shortmess+=c      " Silence insert completion messages
set completeopt=menu,menuone,noselect
set complete+=kspell
set omnifunc=syntaxcomplete#Complete
set cursorline
set showtabline=1
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

" jump to previous position when reopening a file
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
      \| exe "normal! g'\""
      \| endif

autocmd filetype help wincmd L
autocmd TextYankPost * silent! lua vim.highlight.on_yank {higroup="IncSearch", timeout=250}

lua require('tree-sitter-config')
lua require('lsp-config')
lua require('colorizer').setup()
lua require('telescope').setup()
lua require('trouble').setup()
lua require('lualine-config')
lua require('telescope').load_extension 'fzf'
": }}}

": Key maps {{{

inoremap jj <esc>

nnoremap <leader>w <cmd>w<cr>
nnoremap <leader>q <cmd>q<cr>
nnoremap <leader>bd <cmd>bd<cr>
nnoremap <leader>Q <cmd>qa<cr>
nnoremap <leader>m <cmd>make<cr>

nnoremap <silent><tab>    <cmd>bnext<cr>
nnoremap <silent><s-tab>  <cmd>bNext<cr>

xnoremap <tab>   >gv
xnoremap <S-tab> <gv

inoremap <expr> <tab>   pumvisible() ? "\<C-n>" : "<tab>"
inoremap <expr> <S-tab> pumvisible() ? "\<C-p>" : "<S-tab>"
inoremap <expr> <cr>    pumvisible() ? "\<C-y>" : "<cr>"

nnoremap <silent>ø zA

nnoremap <silent><leader>\| <C-W>L

" Move between splits
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l
nnoremap <C-H> <C-W>h

nnoremap <silent> √ <cmd>move+<CR>
nnoremap <silent> ª <cmd>move-2<CR>

" Move visual block
xnoremap √ :m '>+1<CR>gv=gv
xnoremap ª :m '<-2<CR>gv=gv

" Surround selection in quotes
xnoremap <space>q c"<C-R>""

nnoremap <silent> // <cmd>noh<cr>

" Navigate through quick-fix errors
nnoremap <C-N> <cmd>cn<CR>
nnoremap <C-P> <cmd>cp<CR>
nnoremap <silent>co <cmd>copen<CR>
nnoremap <silent>cc <cmd>cclose<CR>

xnoremap <leader>y "*y
nnoremap <leader>y "*y
nnoremap <leader>p "*p

inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O

" Escape from terminal mode
tnoremap <Esc> <C-\><C-n>


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
nnoremap <leader><space> <cmd>call TrimWhitespace()<cr>

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
" nnoremap <Leader>ag :call FloatTerm('"tig"')<CR>

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
