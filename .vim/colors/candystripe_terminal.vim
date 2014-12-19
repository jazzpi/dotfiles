set background=dark

hi clear
if exists("syntax_on")
    syntax reset
endif

let colors_name = "candystripe_terminal"

" Vim >= 7.0 specific colors
if version >= 700
hi CursorLine                       ctermbg=0                                       guibg=#000000
hi CursorColumn                     ctermbg=236                                     guibg=#2d2d2d
hi MatchParen       ctermfg=15      ctermbg=236     cterm=bold      guifg=#ffffff   guibg=#333333   gui=bold
hi Pmenu            ctermfg=15      ctermbg=242                     guifg=#ffffff   guibg=#666666
hi PmenuSel         ctermfg=15      ctermbg=109                     guifg=#ffffff   guibg=#93b5bf
endif

" General colors
hi Cursor                           ctermbg=23                                      guibg=#1c686d
" jazzpi: I want transparent background!
"hi Normal           ctermfg=255     ctermbg=236                     guifg=#f0f0f0   guibg=#292929
hi Normal           ctermfg=255     ctermbg=none                    guifg=#f0f0f0   guibg=#292929
hi NonText          ctermfg=247     ctermbg=236                     guifg=#a0a0a0   guibg=#292929
" jazzpi: I don't really like the color of the line number bar, so I made it
" darker
"hi LineNr           ctermfg=247     ctermbg=236                     guifg=#a0a0a0   guibg=#303030
hi LineNr           ctermfg=247     ctermbg=232                     guifg=#a0a0a0   guibg=#303030
hi StatusLine       ctermfg=236     ctermbg=254     cterm=none      guifg=#333333   guibg=#e0e0e0   gui=italic
hi StatusLineNC     ctermfg=236     ctermbg=241                     guifg=#303030   guibg=#606060
hi VertSplit        ctermfg=236     ctermbg=236                     guifg=#333333   guibg=#333333
hi Folded           ctermfg=237     ctermbg=248                     guibg=#384048   guifg=#a0a8b0
hi Title            ctermfg=15                      cterm=bold      guifg=#ffffff                   gui=bold
hi Visual           ctermfg=15      ctermbg=238                     guifg=#ffffff   guibg=#444444
hi SpecialKey       ctermfg=244     ctermbg=236                     guifg=#808080   guibg=#292929
hi ColorColumn                  ctermbg=236                                     guibg=#333333
" jazzpi: This looks too much like an error
"hi Search           ctermfg=15      ctermbg=52      cterm=none      guifg=#ffffff   guibg=#4f2b49   gui=italic
hi Search           ctermfg=126      ctermbg=226      cterm=bold      guifg=#ffffff   guibg=#4f2b49   gui=italic

" Syntax highlighting
" jazzpi: This is too bright for my setup
"hi Comment          ctermfg=247                     cterm=none      guifg=#999999                   gui=italic
hi Comment          ctermfg=242                     cterm=none      guifg=#6c6c6c                   gui=italic
hi Boolean          ctermfg=190                                     guifg=#cdff00
" jazzpi: This doesn't highlight strings well enough.
"hi String           ctermfg=193                                     guifg=#CFFFB0
hi String           ctermfg=83                                      guifg=#CFFFB0
hi Identifier       ctermfg=210                                     guifg=#ff7789
hi Function         ctermfg=86                                      guifg=#6ee4ef
hi Type             ctermfg=221                                     guifg=#fcc56d
hi Statement        ctermfg=210                                     guifg=#ff7789
hi Keyword          ctermfg=114                                     guifg=#7fed96
hi Constant         ctermfg=114                                     guifg=#7fed96
hi Number           ctermfg=114                                     guifg=#7fed96
hi Special          ctermfg=221                                     guifg=#fcc56d
hi PreProc          ctermfg=114                                     guifg=#7fed96
hi Todo                             ctermbg=114     cterm=none                      guibg=#7fed96   gui=italic

" PHP specific colors
hi phpIdentifier    ctermfg=123                                     guifg=#75f3ff
hi phpComment       ctermfg=246                                     guifg=#999999
hi phpClasses       ctermfg=228                                     guifg=#fff685
hi phpSpecial       ctermfg=218                                     guifg=#f8a4e7
hi phpMethodsVar    ctermfg=228                                     guifg=#fff685

" Git gutter
hi SignColumn                       ctermbg=233                                     guibg=#111111
