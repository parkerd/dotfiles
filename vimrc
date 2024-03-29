" begin neobundle
if has('vim_starting')
  if &compatible
    set nocompatible               " Be iMproved
  endif

  " Required:
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

" Required:
call neobundle#begin(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'
" General
"NeoBundle 'editorconfig/editorconfig-vim'
" Visual
NeoBundle 'bling/vim-airline'
NeoBundle 'vim-airline/vim-airline-themes'
NeoBundle 'edkolev/tmuxline.vim'
NeoBundle 'edkolev/promptline.vim'
" Usability
NeoBundle 'airblade/vim-gitgutter'
NeoBundle 'ervandew/supertab'
NeoBundle 'godlygeek/tabular'
NeoBundle 'majutsushi/tagbar'
NeoBundle 'mhinz/vim-startify'
NeoBundle 'scrooloose/nerdcommenter'
"NeoBundle 'scrooloose/syntastic'
NeoBundle 'Shougo/neocomplete'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'tpope/vim-surround'
NeoBundle 'vim-scripts/bats.vim'
NeoBundleLazy 'kien/ctrlp.vim'
NeoBundleLazy 'rizzatti/dash.vim'
NeoBundleLazy 'scrooloose/nerdtree'
" Languages
NeoBundle 'cespare/vim-toml'
NeoBundle 'elixir-editors/vim-elixir'
NeoBundle 'elzr/vim-json'
NeoBundle 'fatih/vim-go'
NeoBundle 'hashivim/vim-terraform'
NeoBundle 'plasticboy/vim-markdown'
NeoBundle 'rodjek/vim-puppet'
NeoBundle 'rust-lang/rust.vim'
NeoBundle 'solarnz/thrift.vim'
NeoBundle 'stephpy/vim-yaml'
" Python
NeoBundle 'hdima/python-syntax'
NeoBundle 'hynek/vim-python-pep8-indent'
NeoBundle 'tmhedberg/SimpylFold'

call neobundle#end()

" Required:
filetype plugin indent on

 " If there are uninstalled bundles found on startup,
 " this will conveniently prompt you to install them.
NeoBundleCheck
" end neobundle

" key mappings
let mapleader = ','
inoremap jj <Esc>
inoremap kk <Esc>
set pastetoggle=<F2>
map <leader>c :SyntasticToggleMode<CR>
map <leader>f :CtrlP<CR>
map <leader>r :NERDTreeToggle<CR>
map <leader>t :TagbarToggle<CR>
map <leader>= :Tab /=<CR>
map <leader>- :Tab /=><CR>
map <leader>/ :noh<CR>
nmap <space> zz

" commands
command Q :q
command W :w %
command Wq :wq %
command WW :w !sudo tee % >/dev/null

" general settings
set encoding=utf-8
"set nocompatible
set nobackup
set noswapfile

" coding settings
syntax on
set number
set showmatch
set hlsearch

" indent settings
set tabstop=8
set shiftwidth=8
set softtabstop=8
set noexpandtab
set autoindent
set smartindent

" colors
colorscheme gardener
hi NonText cterm=NONE ctermbg=233
hi Folded cterm=NONE ctermbg=235
hi Search cterm=NONE ctermbg=237
hi Label cterm=NONE ctermbg=NONE ctermfg=Cyan
"hi String cterm=NONE ctermbg=NONE ctermfg=White

" crosshair
hi CursorLine   cterm=NONE ctermbg=235
hi CursorColumn cterm=NONE ctermbg=235
set cursorline! cursorcolumn!
nmap <silent> <Leader>c :set cursorline! cursorcolumn!<CR>

" line length
let w:m1=matchadd('Todo', '\%<81v.\%>77v', -1)
let w:m2=matchadd('Error', '\%>80v.\+', -1)
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

" automatically return to previous position
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif

" remove all trailing spaces on save
autocmd BufWritePre * %s/\s\+$//e

" mvim settings
if has("gui_macvim")
  set vb
  set go=
  set transparency=25
  set gfn=inconsolata-dz:h14
  map <C-T> :vs<CR>
  colorscheme jellybeans
endif

" neocomplete
if has("lua")
  let g:neocomplete#enable_at_startup = 1
  let g:neocomplete#sources#syntax#min_keyword_length = 3

  " <CR>: close popup and save indent.
  inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
  function! s:my_cr_function()
    return neocomplete#close_popup() . "\<CR>"
    " For no inserting <CR> key.
    return pumvisible() ? neocomplete#close_popup() : "\<CR>"
  endfunction

  " <TAB>: completion.
  inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
endif

" crontab
autocmd filetype crontab setlocal nobackup nowritebackup

" golang
let g:go_fmt_command = "goimports"

" highlight bad whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" vim-airline
set laststatus=2
let g:airline_powerline_fonts = 1
let g:airline_theme = 'oldhope'

" jedi-vim
"let g:jedi#completions_enabled = 0
"let g:jedi#show_call_signatures = "1"
"let g:jedi#goto_command = "<leader>g"
"let g:jedi#goto_assignments_command = "<leader>a"
"let g:jedi#goto_definitions_command = "<leader>s"
"let g:jedi#documentation_command = "K"
"let g:jedi#usages_command = "<leader>n"
"let g:jedi#completions_command = "<C-Space>"
"let g:jedi#rename_command = ""
"let g:jedi#use_tabs_not_buffers = 1
""let g:jedi#use_splits_not_buffers = "right"
""let g:jedi#popup_select_first = 1
"autocmd FileType python setlocal completeopt-=preview

" supertab
let g:SuperTabDefaultCompletionType = "<c-n>"

" vim-markdown
let g:vim_markdown_folding_disabled = 1

" vim-dash
nmap <silent> <leader>d :Dash<CR>

" tmuxline.vim
" :Tmuxline powerline powerline

"\'$(aws-env current)',
"\"$(docker-env | grep '^*' | grep -v local | awk '{print $2}')",
"\"$(asdf current elixir | awk '{print $2}' | grep -v system)",
"\"$(asdf current nodejs | awk '{print $2}' | grep -v system)",
"\"$(asdf current python | awk '{print $2}' | grep -v system)",
" promptline.vim
let g:promptline_theme = 'airline'
let g:promptline_preset = {
  \'a': [
    \'$(kube-env | grep -v rancher-desktop:)',
    \'$(if [[ -d .terraform ]]; then terraform workspace show; fi)',
    \'$(__pp_git_branch)',
  \],
  \'b': [ '$__pp_name' ],
  \'c': [ '$(__pp_pwd_clean)' ],
  \'warn': [ promptline#slices#last_exit_code() ],
  \'z': [ promptline#slices#host({ 'only_if_ssh': 1 }) ]
\}

" syntastic
"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0
"let g:syntastic_loc_list_height = 3
"let g:syntastic_puppet_checkers = ['puppet-lint']

" vim
let g:vim_json_syntax_conceal = 0
