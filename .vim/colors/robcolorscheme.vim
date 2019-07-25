" Vim color file
" Maintainer:   Rob
" Last Change:  2018 Sep 26

" robcolorscheme -- colors that I, Rob, like

hi clear
if exists("syntax_on")
	syntax reset
endif

set cursorline
let colors_name = "robcolorscheme"

hi CursorLine	cterm=bold
hi CursorLineNR	ctermfg=red ctermbg=233 cterm=bold
hi Normal		guifg=#c0c0c0 guibg=#000040						ctermfg=39 ctermbg=none
hi ErrorMsg		guifg=#ffffff guibg=#287eff						ctermfg=black ctermbg=lightblue
hi Visual		guifg=#8080ff guibg=fg gui=reverse				ctermfg=lightblue ctermbg=black cterm=reverse,bold
hi VisualNOS	guifg=#8080ff guibg=fg gui=reverse,underline	ctermfg=lightblue ctermbg=fg cterm=reverse,underline
hi Todo			guifg=#d14a14 guibg=#1248d1						ctermfg=215 ctermbg=Blue cterm=bold
hi Search		guifg=#90fff0 guibg=#2050d0						ctermfg=black ctermbg=darkblue cterm=underline term=underline
hi IncSearch	guifg=#b0ffff guibg=#2050d0						ctermfg=darkblue ctermbg=red

hi SpecialKey	guifg=darkcyan				ctermfg=darkcyan
hi Directory	guifg=darkblue				ctermfg=darkblue
hi Title		guifg=magenta gui=none		ctermfg=magenta cterm=bold
hi WarningMsg	guifg=red					ctermfg=red
hi WildMenu		guifg=yellow guibg=black	ctermfg=yellow ctermbg=black cterm=none term=none
hi ModeMsg		guifg=#22cce2				ctermfg=lightblue
hi MoreMsg		ctermfg=darkgreen			ctermfg=darkgreen
hi Question		guifg=green gui=none		ctermfg=green cterm=none
hi NonText		guifg=#0030ff				ctermfg=darkblue

hi StatusLine	guifg=black guibg=darkgray gui=none	ctermfg=black ctermbg=yellow term=bold cterm=bold
hi StatusLineNC	guifg=black guibg=darkgray gui=none	ctermfg=black ctermbg=darkmagenta term=none cterm=none
hi VertSplit	guifg=black guibg=darkgray gui=none	ctermfg=black ctermbg=darkmagenta term=none cterm=none

hi Folded		guifg=#808080 guibg=#000040	ctermfg=darkgrey ctermbg=black cterm=bold term=bold
hi FoldColumn	guifg=#808080 guibg=#000040	ctermfg=darkgrey ctermbg=black cterm=bold term=bold
hi LineNr		guifg=#90f020				ctermfg=red cterm=none

hi DiffAdd		guibg=darkblue						ctermbg=darkblue term=none cterm=none
hi DiffChange	guibg=darkmagenta					ctermbg=magenta cterm=none
hi DiffDelete	gui=bold guifg=Blue guibg=DarkCyan	ctermfg=blue ctermbg=cyan
hi DiffText		gui=bold guibg=Red					cterm=bold ctermbg=red

hi Cursor		guifg=black guibg=yellow	ctermfg=black ctermbg=yellow
hi lCursor		guifg=black guibg=white		ctermfg=black ctermbg=white

hi Comment		guifg=#80a0ff			ctermfg=yellow
hi Constant		guifg=#ffa0a0			ctermfg=165 cterm=none
hi Special		guifg=Orange gui=none	ctermfg=81 cterm=none
hi Identifier	guifg=#40ffff			ctermfg=cyan cterm=none
hi Statement	guifg=#ffff60 gui=none	ctermfg=202 cterm=none
hi PreProc		guifg=#ff80ff gui=none	ctermfg=darkred cterm=none
hi type			guifg=#60ff60 gui=none	ctermfg=green cterm=none
hi Underlined	cterm=underline			term=underline

hi Pmenu		guifg=#c0c0c0	guibg=#404080
hi PmenuSel		guifg=#c0c0c0	guibg=#2050d0
hi PmenuSbar	guifg=blue		guibg=darkgray
hi PmenuThumb	guifg=#c0c0c0

hi SpellBad		guifg=black guibg=red		ctermfg=black ctermbg=red term=bold cterm=bold
hi SpellCap		guifg=black guibg=yellow	ctermfg=black ctermbg=yellow term=bold cterm=bold

hi SignColumn	ctermbg=232
