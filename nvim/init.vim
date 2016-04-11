""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" jazzpi's (n)vimrc
" Taken from various sources, e.g. https://github.com/amix/vimrc
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" PLUGINS
" Use vim-plug as plugin manager <https://github.com/junegunn/vim-plug>
" Run :PlugInstall once to install all plugins
call plug#begin()
Plug 'ctrlpvim/ctrlp.vim'          " Simple file opening
Plug 'tpope/vim-fugitive'          " Git integration
Plug 'airblade/vim-gitgutter'      " Show git status of lines in gutter
Plug 'tpope/vim-surround'          " Powerful quote etc. handling
Plug 'scrooloose/nerdtree'         " File tree
Plug 'Xuyuanp/nerdtree-git-plugin' " git integrating for NERDTree
Plug 'fholgado/minibufexpl.vim'    " List open buffers
call plug#end()
" NERDTree
" Open automatically when vim starts
autocmd vimenter * NERDTree

" USER INTERFACE
syntax enable
colorscheme slate
" display invisible characters
set list
set listchars=tab:\|-,trail:~,nbsp:%,space:·,extends:>,precedes:<
hi SpecialKey ctermfg=240
" Show line numbers
set nu
" Leave some lines/columns visible when scrolling
set so=5 ss=1 siso=8
" Format for the ruler on the right side of the statusbar
set ru ruf=%(%P%=%l:%c%V%)

" GENERAL
" Be smart about case when searching
set ignorecase smartcase
" Set up tabs
set shiftwidth=4
set tabstop=4
set noexpandtab
filetype plugin indent on
set hidden " Allow modified buffers to be hidden

" TODO: show indicator at 80 chars
set nowrap

" KEYMAP
let mapleader = "\<space>"
" Remove some gitgutter binds that interfere with <Leader>h
unmap <Leader>hp
unmap <Leader>hr
unmap <Leader>hs
noremap <Leader>h :bp<CR>
noremap <Leader>l :bn<CR>
nmap <silent> <Leader><CR> :nohl<CR>
nmap <Leader>w :bd<CR>
nmap <Leader>W :qa<CR>

" EX COMMANDS
" :W sudo saves the file
" (useful for handling the permission-denied error)
command W w !sudo tee % > /dev/null
