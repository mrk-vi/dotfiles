" Maintainer:	The Vim Project <https://github.com/vim/vim>
" Last Change:	2023 Aug 10
" Former Maintainer:	Bram Moolenaar <Bram@vim.org>
"
" To use it, copy it to
"	       for Unix:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"	 for MS-Windows:  $VIM\_vimrc
"	      for Haiku:  ~/config/settings/vim/vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings, bail
" out.
if v:progname =~? "evim"
  finish
endif

" Get the defaults that most users want.
source $VIMRUNTIME/defaults.vim

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file (restore to previous version)
  if has('persistent_undo')
    set undofile	" keep an undo file (undo changes after closing)
  endif
endif

if &t_Co > 2 || has("gui_running")
  " Switch on highlighting the last used search pattern.
  set hlsearch
endif

" Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78
augroup END

" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
" The ! means the package won't be loaded right away but when plugins are
" loaded during initialization.
if has('syntax') && has('eval')
  packadd! matchit
endif

" My configurations
"

set hlsearch
set incsearch
set relativenumber
set ignorecase
set scrolloff=0

" My Keymaps
"
nnoremap <silent> <Esc><Esc> :<C-u>nohlsearch<CR>

" Set the leader key to space (common preference)
let mapleader = " "

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

" Navigate between splits with Ctrl+hjkl
nnoremap <C-h> <C-w><C-h>
nnoremap <C-l> <C-w><C-l>
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>

" Column guide at 80 chars
set colorcolumn=80
highlight ColorColumn ctermbg=darkgray guibg=#2d2d2d


" Source local overrides
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif
