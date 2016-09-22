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
Plug 'ap/vim-buftabline'           " Buffers in tab bar
Plug 'rking/ag.vim'                " Search for code with the_silver_searcher
Plug 'tpope/vim-commentary'        " Comment stuff out
Plug 'moll/vim-bbye'               " Close buffers without closing their window
Plug 'morhetz/gruvbox'             " A very nice colorscheme
Plug 'vim-scripts/mru.vim'         " Show recently opened files in a window
" Plug 'Shougo/deoplete.nvim'        " Dark-powered neo-completion
" Plug 'ervandew/supertab'           " completion with Tab and Shift-Tab
Plug 'jiangmiao/auto-pairs'        " Auto-close brackets and more
Plug 'derekwyatt/vim-fswitch'      " Quickly switch between .cpp and .h files
Plug 'rkitover/vimpager'           " Use vim as a pager
" Extended session management
Plug 'xolox/vim-misc' | Plug 'xolox/vim-session'
Plug 'marcweber/vim-addon-mw-utils' | Plug 'tomtom/tlib_vim' | Plug 'garbas/vim-snipmate' | Plug 'honza/vim-snippets' " Snippets
Plug 'lervag/vimtex'               " LaTeX support
Plug 'peterhoeg/vim-qml'           " QML language highlighting
Plug 'brookhong/cscope.vim'        " cscope support
" Automatically update ctags
Plug 'xolox/vim-misc' | Plug 'xolox/vim-easytags'
Plug 'majutsushi/tagbar'           " Window with all tags in the file
Plug 'digitaltoad/vim-pug'         " Pug (formerly Jade) language support
Plug 'isRuslan/vim-es6'            " ES6 Syntax & Snippets
Plug 'derekwyatt/vim-fswitch'      " Quickly switch source and header files
" Markdown Preview
Plug 'JamshedVesuna/vim-markdown-preview'
" Amazing tab completion
Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer --tern-completer' }
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
let g:vimtex_view_general_viewer = 'okular'
let g:vimtex_view_general_options = '--unique @pdf\#src:@line@tex'
let g:vimtex_view_general_options_latexmk = '--unique'
" Config for buftabline
let g:buftabline_numbers = 2 " Show numbers next to buffers (1 to 10)
let g:buftabline_indicators = 1 " Show modified indicator in buftabline
" Markdown preview config
let vim_markdown_preview_hotkey='<C-m>'
let vim_markdown_preview_toggle=2
" Keybinds for cscope
nnoremap <leader>fa :call CscopeFindInteractive(expand('<cword>'))<CR>
nnoremap <leader>l :call ToggleLocationList()<CR>
" s: Find this C symbol
nnoremap  <leader>fs :call CscopeFind('s', expand('<cword>'))<CR>
" g: Find this definition
nnoremap  <leader>fg :call CscopeFind('g', expand('<cword>'))<CR>
" d: Find functions called by this function
nnoremap  <leader>fd :call CscopeFind('d', expand('<cword>'))<CR>
" c: Find functions calling this function
nnoremap  <leader>fc :call CscopeFind('c', expand('<cword>'))<CR>
" t: Find this text string
nnoremap  <leader>ft :call CscopeFind('t', expand('<cword>'))<CR>
" e: Find this egrep pattern
nnoremap  <leader>fe :call CscopeFind('e', expand('<cword>'))<CR>
" f: Find this file
nnoremap  <leader>ff :call CscopeFind('f', expand('<cword>'))<CR>
" i: Find files #including this file
nnoremap  <leader>fi :call CscopeFind('i', expand('<cword>'))<CR>
" Silver Searcher config
let g:ag_prg="ag --vimgrep --smart-case --ignore assets/ --ignore bin/"

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

" Automatically restore views when opening a file
augroup autosave_view
	au!
	au BufWinLeave ?* mkview
	au BufWinEnter ?* silent! loadview
augroup END

" Exclude quickfix list from :bn and :bp
augroup qf
	autocmd!
	autocmd FileType qf set nobuflisted
augroup END

" Setup for FSwitch
augroup fsw
	au!
	au BufEnter *.cpp let b:fswitchdst = 'h,hpp'
	au BufEnter *.c let b:fswitchdst = 'h'
	au BufEnter *.hpp let b:fswitchdst = 'cpp'
	au BufEnter *.h let b:fswitchdst = 'cpp,c'
augroup END

" KEYMAP
let mapleader = "\<space>"
let maplocalleader = "\<space>"
noremap <Leader>n :bp<CR>
noremap <Leader>m :bn<CR>
noremap <Leader>N :tabp<CR>
noremap <Leader>M :tabn<CR>
nmap <silent> <Leader><CR> :nohl<CR>
nmap <Leader>w :Bd<CR>
nmap <Leader>W :q<CR>
nnoremap <silent> <C-\> :NERDTreeToggle<CR>
" Go to buffers 1-10
nmap <Leader>1 <Plug>BufTabLine.Go(1)
nmap <Leader>2 <Plug>BufTabLine.Go(2)
nmap <Leader>3 <Plug>BufTabLine.Go(3)
nmap <Leader>4 <Plug>BufTabLine.Go(4)
nmap <Leader>5 <Plug>BufTabLine.Go(5)
nmap <Leader>6 <Plug>BufTabLine.Go(6)
nmap <Leader>7 <Plug>BufTabLine.Go(7)
nmap <Leader>8 <Plug>BufTabLine.Go(8)
nmap <Leader>9 <Plug>BufTabLine.Go(9)
nmap <Leader>0 <Plug>BufTabLine.Go(10)
nmap <silent> <Leader>of :FSHere<cr>
nmap <silent> <Leader>ol :FSSplitRight<cr>
nmap <silent> <Leader>oL :FSRight<cr>
nmap <silent> <Leader>oh :FSSplitLeft<cr>
nmap <silent> <Leader>oH :FSLeft<cr>

" EX COMMANDS
" :W sudo saves the file
" (useful for handling the permission-denied error)
command! W w !sudo tee % > /dev/null
