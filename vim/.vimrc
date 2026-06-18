colorscheme darkblue
syntax on
filetype plugin indent on
set showcmd
set autoread
set wildmenu

set hlsearch
set incsearch
set relativenumber
set ignorecase
set scrolloff=0
set backup
set undofile

" Centralize backup, swap, and undo files
if !isdirectory(expand('~/.vim/backups'))
    call mkdir(expand('~/.vim/backups'), 'p', 0700)
endif
if !isdirectory(expand('~/.vim/swap'))
    call mkdir(expand('~/.vim/swap'), 'p', 0700)
endif
if !isdirectory(expand('~/.vim/undo'))
    call mkdir(expand('~/.vim/undo'), 'p', 0700)
endif
set backupdir=~/.vim/backups//
set directory=~/.vim/swap//
set undodir=~/.vim/undo//

" Set the leader key to space (common preference)
let mapleader = " "
let maplocalleader = " "

" My Keymaps
"
nnoremap <silent> <Esc><Esc> :<C-u>nohlsearch<CR>

" Copy to system clipboard
vnoremap <leader>y "+y
nnoremap <leader>y "+y

" Paste from system clipboard
"   After cursor
nnoremap <leader>p "+p
vnoremap <leader>p "+p
"   Before cursor
nnoremap <leader>P "+P
vnoremap <leader>P "+P

" Column guide at 80 chars
set colorcolumn=80
highlight ColorColumn ctermbg=darkgray guibg=#2d2d2d

" Vim-only plugins and keymaps
if !has('nvim')
  " Auto-install vim-plug
  let data_dir = '~/.vim'
  if empty(glob(data_dir . '/autoload/plug.vim'))
    silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  endif

  call plug#begin()
  Plug 'junegunn/fzf'
  Plug 'junegunn/fzf.vim'
  Plug 'christoomey/vim-tmux-navigator'
  call plug#end()

  nnoremap <leader>ff :Files<CR>
  nnoremap <leader>fg :Rg<CR>
  nnoremap <leader>fb :Buffers<CR>
  nnoremap <leader>fh :Helptags<CR>
endif

" Source local overrides
if filereadable(expand("~/.vimrc.local"))
   source ~/.vimrc.local
 endif
