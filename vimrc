" pathogen settings
filetype off
call pathogen#runtime_append_all_bundles()

" key mappings
let mapleader = ','
inoremap jj <Esc>
inoremap kk <Esc>
set pastetoggle=<F2>
map <leader>r :NERDTreeToggle<CR>
map <leader>f :CtrlP<CR>
nmap <space> zz

" commands
command W :w %
command WW :w !sudo tee % >/dev/null

" general settings
colorscheme gardener
set encoding=utf-8
set nocompatible
set nobackup
set noswapfile

" coding settings
syntax on
set number
set showmatch
let w:m1=matchadd('NonText', '\%<81v.\%>77v', -1)
let w:m2=matchadd('Cursor', '\%>80v.\+', -1)

" tab settings
set tabstop=8
set shiftwidth=8
set softtabstop=8
set noexpandtab
set autoindent
set smartindent

" automatically return to previous position
if has("autocmd")
  filetype plugin indent on
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif
endif

" mvim settings
if has("gui_macvim")
  set vb
  set go=
  set transparency=25
  set gfn=inconsolata-dz:h14
  colorscheme jellybeans
  map <C-T> :vs<CR>
endif
