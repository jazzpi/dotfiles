" jazzpi's .vimrc file

" We don't want no vi compatibility
set nocompatible

" Reload .vimrc automatically
autocmd! bufwritepost .vimrc source %

" Better copypaste
set pastetoggle=<F2>
set clipboard=unnamed

" 'Normal' backspace behaviour
set bs=2

" Leave some space when scrolling for better visibilty
set scrolloff=5 " At least 5 lines when scrolling down/up
set sidescrolloff=5 " At least 5 chars left/right

" Rebind Mapleader
let mapleader = ","

" Quicksaving
noremap <C-Z> :update<CR>
vnoremap <C-Z> <C-C>:update<CR>
inoremap <C-Z> <C-O>:update<CR>

" Quickquitting
noremap <Leader>t :q<CR>
noremap <Leader>T :qa!<CR>

" Move around tabs/splits/windows faster
map <C-H> <C-W>H
map <C-J> <C-W>J
map <C-K> <C-W>K
map <C-L> <C-W>L

map <Leader>n <esc>:tabprevious<CR>
map <Leader>m <esc>:tabnext<CR>

" Create new tab and open Ctrlp automatically
map <Leader>l <esc>:tabnew<CR><C-P>
map <leader>k <esc>:tabnew<CR> " Without CtrlP

" Sort by pressing Leader+S
vnoremap <Leader>s :sort<CR>

" Press jk to exit insert mode
inoremap jk <Esc>

" Better indentation
vnoremap < <gv
vnoremap > >gv

" Disable highlighting by pressing ,h
noremap <Leader>h :nohl<CR>

" Get used to hjkl!
noremap <up> <nop>
noremap <down> <nop>
noremap <left> <nop>
noremap <right> <nop>

" {{{ Press <F12> to toggle mouse focus between VIM (for scrolling) and
"     terminal (for selecting text)

fun! s:ToggleMouse()
    if !exists("s:old_mouse")
        let s:old_mouse = "a"
    endif

    if &mouse == ""
        let &mouse = s:old_mouse
        echo "Mouse is for VIM (" . &mouse . ")"
    else
        let s:old_mouse = &mouse
        let &mouse = ""
        echo "Mouse is for terminal"
    endif
endfunction

noremap <F12> :call <SID>ToggleMouse()<CR>
inoremap <F12> <Esc>:call <SID>ToggleMouse()<CR>a

set mouse=a

" }}}

" Mark trailing whitespaces
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
au InsertLeave * match ExtraWhitespace /\s\+$/

" Color Scheme
set t_Co=256
" Default. I'm using different color schemes for different file types (see the
" ftplugins)
color wombat256mod

" Syntax highlighting
filetype off
filetype plugin indent on
filetype plugin on
syntax on

" IDE functions {{{
set number " Turns on line numbers
set tw=79 " gd document width
set nowrap " Don't wrap on load
set fo-=t "Don't wrap when typing
set colorcolumn=80
hi ColorColumn ctermbg=233

" Easier formatting of paragraphs
vmap Q gq
nmap Q gqap

" Better Undo history
set history=1000
set undolevels=1000

" Tabbing
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround
set expandtab

" Better search
set hlsearch " Highlight search terms
set incsearch " Show matches as you type
set ignorecase " Case-insensitive search
set smartcase " ...unless there are uppercase letters in the search term

" Remove highlight of last search
noremap <Leader><del> :nohl<CR>

" Disable swap files, I don't like them
set noswapfile

" ,d (+ length ops) to delete without adding to yank buffer
nnoremap <silent> <leader>d "_d
vnoremap <silent> <leader>d "_d

" Set up Pathogen
let g:pathogen_disabled = [] " Add a module's name to this list to disable it
" Checking something
"call add(g:pathogen_disabled, "jedi-vim")
call pathogen#infect()

" ==============================
" Python IDE setup
" ==============================

" vim-airline settings
set laststatus=2
let g:airline_powerline_fonts=0
let g:airline_theme="dark"
let g:airline_left_sep=""
let g:airline_right_sep=""
let g:airline_linecolumn_prefix="¶"

" Ctrl+P settings
let g:ctrlp_max_height=30
let g:ctrlp_show_hidden=1
let g:ctrlp_clear_cache_on_exit=0 " Don't reindex on every restart/new window
" Ignore useless files
set wildignore+=*/tmp/*,*.pyc,*.zip,*.mp3,*.mp4,*.so,*/.wine/*

" jedi-vim settings
" Checking something
"call add(g:pathogen_disabled, "jedi")
let g:jedi#usages_command="<leader>z"
let g:jedi#popup_on_dot=0
let g:jedi#popup_select_first=0
map <Leader>b 0import ipdb; ipdb.set_trace() # BREAKPOINT<C-c>

" Better completion
set completeopt=longest,menuone
function! OmniPopup(action)
    if pumvisible()
        if a:action == "j"
            return "\<C-N>"
        elseif a:action == "k"
            return "\<C-P>"
        endif
    endif
    return a:action
endfunction

inoremap <silent><C-j> <C-R>=OmniPopup("j")<CR>
inoremap <silent><C-k> <C-R>=OmniPopup("k")<CR>

" Python folding
set nofoldenable

" }}}

" Save and restore open files {{{

" Save and exit
nmap <leader>Q :mksession!<CR>:xa<CR>

" Restore
nmap <leader>E :source Session.vim<CR>

" Restore if vim is opened without open files

function! CheckOpenFiles()
    redir => b:arguments
    args
    redir END
endfunction

" Don't show the arguments
silent call CheckOpenFiles()

" Automatically restore if VIM was called without any arguments
if len(b:arguments) <= 2 && filereadable("Session.vim")
    normal ,E
endif

" unlet b:arguments

" }}}

" PHP IDE features {{{

" Code Sniffing ("better" Standard)
let g:phpqa_codesniffer_args = "--standard=PEAR"

" Mess detection (turn off annoying codesize)
"let g:phpqa_messdetector_ruleset = "design,unusedcode,naming"

" Diable PHPQA for now
"let g:phpqa_codesniffer_autorun = 0
"let g:phpqa_messdetector_autorun = 0
let g:phpqa_run_on_write = 0
let g:phpqa_check = 0

" }}}

" Edit raw text, not source code
fun! RawText()
    set wrap
    set linebreak
    set scrolloff=0
endfun

" Edit source code, not raw text
fun! SourceCode()
    set nowrap
    set scrolloff=5
endfun

" TODO: Get ,H and ,B to change number below cursor to Hex/Bin respectively

" Align current paragraph by equal signs `='
nmap <Leader><Tab> :Tabularize /=<CR>
