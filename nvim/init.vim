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
Plug 'rking/ag.vim'                " Search for code with the_silver_searcher
Plug 'tpope/vim-commentary'        " Comment stuff out
Plug 'moll/vim-bbye'               " Close buffers without closing their window
Plug 'morhetz/gruvbox'             " A very nice colorscheme
Plug 'vim-scripts/mru.vim'         " Show recently opened files in a window
Plug 'Shougo/deoplete.nvim'        " Dark-powered neo-completion
Plug 'ervandew/supertab'           " completion with Tab and Shift-Tab
Plug 'jiangmiao/auto-pairs'        " Auto-close brackets and more
Plug 'derekwyatt/vim-fswitch'      " Quickly switch between .cpp and .h files
Plug 'rkitover/vimpager'           " Use vim as a pager
" Extended session management
Plug 'xolox/vim-misc' | Plug 'xolox/vim-session'
Plug 'marcweber/vim-addon-mw-utils' | Plug 'tomtom/tlib_vim' | Plug 'garbas/vim-snipmate' | Plug 'honza/vim-snippets' " Snippets
Plug 'lervag/vimtex'               " LaTeX support
call plug#end()
" NERDTree
" Open automatically when vim starts, then switch to the editor window
autocmd vimenter * NERDTree | wincmd w
" Close vim if only a NERDTree window is open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" Enable deoplete on startup
let g:deoplete#enable_at_startup = 1
let g:tex_flavor = 'latex' " Who uses Plain TeX anyway?
" Neovim doesn't have --servername
let g:vimtex_latexmk_progname = 'nvr'

" USER INTERFACE
syntax enable
let g:gruvbox_italic = 1
set background=dark
colorscheme gruvbox
" display invisible characters
set list
set listchars=tab:\|-,trail:~,nbsp:%,space:·,extends:>,precedes:<
" Show line numbers
set nu
" Leave some lines/columns visible when scrolling
set so=5 ss=1 siso=8
" Format for the ruler on the right side of the statusbar
set ru ruf=%(%P%=%l:%c%V%)
" Show a line at 80 characters
set colorcolumn=80

" GENERAL
" Be smart about case when searching
set ignorecase smartcase
" Set up tabs
set shiftwidth=4
set tabstop=4
set noexpandtab
" Don't indent C++ namespaces
set cino=N-s
filetype plugin indent on
set hidden " Allow modified buffers to be hidden

" TODO: show indicator at 80 chars
set nowrap

" KEYMAP
let mapleader = "\<space>"
let maplocalleader = "\<space>"
noremap <Leader>n :bp<CR>
noremap <Leader>m :bn<CR>
nmap <silent> <Leader><CR> :nohl<CR>
nmap <Leader>w :Bd<CR>
nmap <Leader>W :q<CR>
nnoremap <silent> <C-\> :NERDTreeToggle<CR>

" EX COMMANDS
" :W sudo saves the file
" (useful for handling the permission-denied error)
command! W w !sudo tee % > /dev/null
