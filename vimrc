colorscheme Tomorrow-Night

" global settings
set nocompatible

set mouse=a
set showmatch
set number
set ruler
" highlight cursor in xy
set cursorline
set cursorcolumn
set clipboard=unnamed " yank and paste with the system clipboard


" indent settings
set autoindent
set shiftround
set preserveindent
set shiftwidth=4
set tabstop=4
set noexpandtab
set showmatch

" highlighting shows tabs as pipes and spaces as underlines
" set list listchars=tab:\|\ 

" search options
set ignorecase
set smartcase
set incsearch
set hlsearch

set showcmd

filetype plugin on
filetype indent on

" custom movement
set scrolloff=8
set sidescrolloff=15
set whichwrap+=<,>,[,]

set runtimepath^=~/.vim/bundle/ctrlp.vim

" out of insert mode
inoremap jk <Esc>

" Create Blank Newlines and stay in Normal mode
nnoremap <silent> zj o<Esc>
nnoremap <silent> zk O<Esc>

" keyboard shortcuts
let mapleader = ','
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
