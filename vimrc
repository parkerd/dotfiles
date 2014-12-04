" pathogen settings
execute pathogen#infect()

" key mappings
let mapleader = ','
inoremap jj <Esc>
inoremap kk <Esc>
set pastetoggle=<F2>
map <leader>r :NERDTreeToggle<CR>
map <leader>f :CtrlP<CR>
map <leader>= :Tab /=<CR>
map <leader>- :Tab /=><CR>
nmap <space> zz

" commands
command Q :q
command W :w %
command WW :w !sudo tee % >/dev/null

" general settings
set encoding=utf-8
set nocompatible
set nobackup
set noswapfile

" coding settings
syntax on
set number
set showmatch

" tab settings
set tabstop=8
set shiftwidth=8
set softtabstop=8
set noexpandtab
set autoindent
set smartindent

" colors
colorscheme gardener
hi NonText cterm=NONE ctermbg=233

" crosshair
hi CursorLine   cterm=NONE ctermbg=235
hi CursorColumn cterm=NONE ctermbg=235
set cursorline! cursorcolumn!
nmap <silent> <Leader>c :set cursorline! cursorcolumn!<CR>

" line length
let w:m1=matchadd('VertSplit', '\%<81v.\%>77v', -1)
let w:m2=matchadd('Cursor', '\%>80v.\+', -1)
nmap <silent> <Leader>l
  \ :if exists('w:m1') <Bar>
  \   silent! call matchdelete(w:m1) <Bar>
  \   silent! call matchdelete(w:m2) <Bar>
  \   unlet w:m1 <Bar>
  \   unlet w:m2 <Bar>
  \ else <Bar>
  \   let w:m1=matchadd('NonText', '\%<81v.\%>77v', -1) <Bar>
  \   let w:m2=matchadd('Cursor', '\%>80v.\+', -1) <Bar>
  \ endif<CR>
"\   let w:long_line_match = matchadd('Cursor', '\%>80v.\+', -1) <Bar>

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
