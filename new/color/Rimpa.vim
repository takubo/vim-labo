scriptencoding utf-8
" vim:set ts=8 sts=8 sw=2 tw=0: (この行に関しては:help modelineを参照)


finish


set background=dark
hi clear

if exists("syntax_on")
  syntax reset
endif

let colors_name = "Rimpa"



finish



# Base
Normal
EndOfBuffer
NonText
MatchParen
SpecialKey

## Cursor
Cursor
CursorIM
lCursor
CursorLine
CursorColumn

## Line Number
LineNr
LineNrAbove
LineNrBelow
CursorLineNr

## Visual
Visual
VisualNOS


# Diff
DiffAdd
DiffChange
DiffDelete
DiffText


# Fold
Folded
FoldColumn
CursorLineFold

# Sign
SignColumn
CursorLineSign


# Statusline, Tabline, VertSplit
StatusLine
StatusLineNC
StatusLineTerm
StatusLineTermNC
TabLine
TabLineFill
TabLineSel
VertSplit


# Completion Menu, Wild Menu
Pmenu
PmenuSel
PmenuKind
PmenuKindSel
PmenuExtra
PmenuExtraSel
PmenuSbar
PmenuThumb
PmenuMatch
PmenuMatchSel


# Search, Quickfix
QuickFixLine
IncSearch
Search
CurSearch


# Message, Question
ErrorMsg
ModeMsg
MsgArea
MoreMsg
Question
Title
WarningMsg


# File Tree
Directory


# Syntax Highlighting
# TODO

# Spell Check
SpellBad
SpellCap
SpellLocal
SpellRare


# GUI

# Cursor

# Other
Scrollbar
Menu
Tooltip

# PopUpInfo


# Special
ColorColumn
Conceal
Terminal
WildMenu
MessageWindow
PopupNotification


# Gold
# Mode Change


" My favarite color  : #c0504d



" ====================================================================================================
scriptencoding utf-8
" vim:set ts=8 sts=8 sw=2 tw=0: (この行に関しては:help modelineを参照)

set background=dark
hi clear

if exists("syntax_on")
  syntax reset
endif

let colors_name = "Rimpa"


" My favarite color  : #c0504d


" General colors
hi Normal	guifg=#f6f3f0	guibg=#202020	gui=none	ctermfg=254	ctermbg=235
hi Normal	guifg=#f6f3f0	guibg=#1c1c1c	gui=none	ctermfg=254	ctermbg=235
hi Normal	guifg=#f6f3f0	guibg=#282828	gui=none	ctermfg=254	ctermbg=235
hi Normal	guifg=#f6f3f0	guibg=#292927	gui=none	ctermfg=254	ctermbg=235
"hi Normal	guifg=#f6f3f0	guibg=#383838	gui=none	ctermfg=254	ctermbg=235
hi NormalNC	guifg=NONE	guibg=#181818	gui=none	ctermfg=254	ctermbg=235
hi NormalNC	guifg=NONE	guibg=#343434	gui=none	ctermfg=254	ctermbg=235
hi NormalNC	guifg=NONE	guibg=#383838	gui=none	ctermfg=254	ctermbg=235
hi NormalNC	guifg=NONE	guibg=#484848	gui=none	ctermfg=254	ctermbg=235
hi NormalPop	guifg=#f6f3f0	guibg=#181818	gui=none	ctermfg=254	ctermbg=235
"hi Normal	guifg=#f6f3f0	guibg=#0A0017	gui=none	ctermfg=254	ctermbg=235
"hi Normal	guifg=#f6f3f0	guibg=#170A00	gui=none	ctermfg=254	ctermbg=235
"hi Normal	guifg=#f6f3f0	guibg=#d0c589	gui=none	ctermfg=254	ctermbg=235	" 金箔背景
hi NonText	guifg=#808080	guibg=#303030	gui=none	ctermfg=242	ctermbg=237
hi NonText	guifg=#808080	guibg=#383838	gui=none	ctermfg=242	ctermbg=237
"hi NonText	guifg=#808080	guibg=#585858	gui=none	ctermfg=242	ctermbg=237
"hi NonText	guifg=#808080	guibg=#d0c589	gui=none	ctermfg=242	ctermbg=237	" 金箔背景
"hi Visual	gui=reverse
"hi Visual	guifg=#ffffd7	guibg=#444444	gui=none	ctermfg=186	ctermbg=238
hi Visual	guifg=NONE	guibg=#444444	gui=none	ctermfg=186	ctermbg=238
hi FoldColumn	guifg=#ff5d28	guibg=#444444
"hi FoldColumn	guifg=#ff5d28	guibg=#d0c589
hi Folded	guifg=#c0c0c0	guibg=#252525	gui=none
hi SignColumn	guifg=White	guibg=Red
hi SpecialKey	guifg=#2D2D2D	guibg=#222222	gui=none
hi SpecialKey	guifg=#343434	guibg=#282828	gui=none
hi SpecialKey	guifg=#3c3c3c	guibg=#282828	gui=none
hi SpecialKey	guifg=#3c3c3c	guibg=NONE	gui=none
hi Cursor	guifg=NONE	guibg=NONE	gui=reverse			ctermbg=0x241
hi CursorLine	guifg=NONE	guibg=NONE	gui=underline			ctermbg=NONE	cterm=underline
hi CursorColumn	guifg=NONE	guibg=#121212	gui=NONE			ctermbg=236
hi CursorColumn	guifg=NONE	guibg=#202020	gui=NONE			ctermbg=236
hi CursorColumn	guifg=NONE	guibg=#1A1A1A	gui=NONE			ctermbg=236

hi LineNr	guifg=#5c5a4f	guibg=#121212	gui=none	ctermfg=239	ctermbg=232
"hi CursorLineNr	guifg=#ffffff	guibg=#000000	gui=NONE	ctermfg=yellow			cterm=bold,underline
"hi CursorLineNr	guifg=#ffffff	guibg=#121212	gui=NONE	ctermfg=yellow			cterm=bold,underline
"hi CursorLineNr	guibg=#5c5a4f	guifg=#121212	gui=none	ctermfg=239	ctermbg=232
"hi CursorLineNr	guibg=#5c5a5f	guifg=#ffffff	gui=none	ctermfg=239	ctermbg=232
"hi CursorLineNr	guibg=#5c5a5f	guifg=#121212	gui=none	ctermfg=239	ctermbg=232
"hi CursorLineNr	guibg=#ff302d	guifg=#121212	gui=none	ctermfg=239	ctermbg=232
hi CursorLineNr	guibg=#cf302d	guifg=#121212	gui=none	ctermfg=239	ctermbg=232
hi CursorLineNr	guifg=#cf302d	guibg=NONE	gui=none	ctermfg=239	ctermbg=232
hi CursorLineNr	guifg=#cf302d	guibg=#121212	gui=none	ctermfg=239	ctermbg=232
hi CursorLineNr	guifg=#cf302d	guibg=NONE	gui=none	ctermfg=239	ctermbg=232
"hi CursorLineNr	guibg=#121212	guifg=#cf302d	gui=none	ctermfg=239	ctermbg=232
"hi CursorLineNr	guibg=#000000	guifg=#cf302d	gui=none	ctermfg=239	ctermbg=232
hi CursorLineNr	guifg=#ff6666	guibg=NONE	gui=none	ctermfg=239	ctermbg=232
hi CursorLineNr	guifg=#bb3333	guibg=NONE	gui=none	ctermfg=239	ctermbg=232
hi CursorLineNr	guifg=#efd3b8	guibg=#bb3333	gui=none
"hi CursorLineNr	guifg=#d0c589	guibg=#bb3333	gui=none
hi CursorLineNr	guifg=#efd3b8	guibg=#7f1f1a	gui=none
hi CursorLineNr	guifg=#cf302d	guibg=#282828	gui=none
hi CursorLineNr	guifg=#ff0000	guibg=#282828	gui=none
hi CursorLineNr	guifg=#ff302d	guibg=#282828	gui=none
hi CursorLineNr	guifg=#efd3b8	guibg=#7f1f1a	gui=none

hi Search	guifg=white	guibg=#b7282e
"hi QuickFixLine	guifg=NONE	guibg=NONE	gui=reverse
hi QuickFixLine	guifg=white	guibg=#87282e
hi QuickFixLine	guifg=NONE	guibg=NONE	gui=reverse
hi QuickFixLine	guifg=NONE	guibg=#404040	gui=none
hi MatchParen	guifg=#f6f3e8	guibg=#857b6f	gui=bold	ctermbg=59
hi Title	guifg=#f6f3e8	guibg=NONE	gui=bold


" For Completion Menu
hi Pmenu	guifg=#dcda8f	guibg=black	ctermfg=239	ctermbg=232
hi PmenuSel 	guifg=#000000	guibg=#c0504d	ctermfg=0	ctermbg=184
hi PmenuSbar 	guifg=#000000	guibg=black	ctermfg=0	ctermbg=184
hi PmenuThumb 	guifg=#000000	guibg=white	ctermfg=0	ctermbg=184

hi Pmenu	guifg=#eeeeee	guibg=#111111	ctermfg=239	ctermbg=232
hi PmenuSel 	guifg=#dcda8f	guibg=black	ctermfg=0	ctermbg=184

hi Pmenu	guifg=#eeeeee	guibg=black	ctermfg=239	ctermbg=232
hi PmenuSel 	guifg=#dcda8f	guibg=#333333	ctermfg=0	ctermbg=184

hi Pmenu	guifg=#eeeeee	guibg=#121212	ctermfg=239	ctermbg=232
hi PmenuSel 	guifg=#eeeeee	guibg=black	gui=none	ctermfg=0	ctermbg=184

hi Pmenu	guifg=#eeeeee	guibg=#121212	ctermfg=239	ctermbg=232
hi PmenuSel 	guifg=#121212	guibg=#eeddaa	gui=none	ctermfg=0	ctermbg=184

hi PmenuThumb 	guifg=#ddbbaa	guibg=#ddbbaa	ctermfg=0	ctermbg=184
hi PmenuSel	guifg=#eeeeee	guibg=#121212	ctermfg=239	ctermbg=232
hi Pmenu 	guifg=#fefefe	guibg=#343434	gui=none	ctermfg=0	ctermbg=184

hi Pmenu 	guifg=#cc4444	guibg=#343434	gui=none	ctermfg=0	ctermbg=184

" For Statusline
"hi StatusLine		guifg=#EF4123	guibg=#7f1f1a	gui=none	" ない
"hi StatusLine		guifg=#ff6666	guibg=#7f1f1a	gui=none	" Rimpaデフォルト 赤字
hi StatusLine		guifg=#dfc3a8	guibg=#7f1f1a	gui=none	" Rimpaデフォルト
hi StatusLine		guifg=#efd3b8	guibg=#7f1f1a	gui=none	" Rimpaデフォルト 高コントラスト白字
"hi StatusLine		guifg=#dfc3a8	guibg=#EF4123	gui=none	" 金赤   白字
"hi StatusLine		guifg=#efd3b8	guibg=#bb3333	gui=none	" 薄い赤 白字
"hi StatusLine		guifg=#efd3b8	guibg=#802020	gui=none	" 秋の色?
hi StatusLineNC		guifg=#5c5a4f	guibg=#300a03	gui=none
hi StatusLineNC		guifg=#5c5a4f	guibg=#101010	gui=none
hi SLNoNameDir		guifg=#5c5a4f	guibg=#000000	gui=none
hi SLFileName		guifg=#EF4123	guibg=#000000
hi SLFileName		guifg=#dF2103	guibg=#000000
hi SLFileName		guifg=#cf302d	guibg=#000000
"hi SLFileName		guifg=#cf302d	guibg=#170A00
"hi SLFileName		guifg=#EF4123	guibg=#000000
"hi SLFileName		guifg=#7f1f1a	guibg=#d0c589	gui=none	" guibgは色を錯覚するので#d0c589から補正

hi StatusLineTerm	guifg=#efd3b8	guibg=#d0330b	gui=none
hi StatusLineTermNC	guifg=#8f7368	guibg=#6d2006	gui=none

hi WildMenu		guifg=#ffffff	guibg=#000000
hi WildMenu		guifg=#efd3b8	guibg=#bb3333
hi WildMenu		guifg=#efd3b8	guibg=#7f1f1a	gui=none	" Rimpaデフォルト 高コントラスト白字
hi WildMenu		guifg=#efd3b8	guibg=#802020	gui=none	" 秋の色?
hi WildMenu		guifg=#dfc3a8	guibg=#EF4123	gui=none	" 金赤   白字
hi WildMenu		guifg=#efd3b8	guibg=#bb3333	gui=none	" 薄い赤 白字
hi WildMenu		guifg=#000000	guibg=#EF4123	gui=bold	" 
hi WildMenu		guifg=#ffffff	guibg=#2a2f5f	gui=none
hi WildMenu		guifg=#ffffff	guibg=#1a1f7f	gui=none
hi WildMenu		guifg=#ffffff	guibg=#000000	gui=none
hi WildMenu		guifg=#ffffff	guibg=#000000	gui=none
hi WildMenu		guifg=#cf302d	guibg=#000000
hi WildMenu		guifg=#d0c589	gui=none	ctermfg=184
hi WildMenu		guifg=#d0c589	guibg=#181818	gui=none	ctermfg=184
hi WildMenu		guifg=#d0c589	guibg=#080808	gui=none	ctermfg=184
hi WildMenu		guifg=#cdd129	guibg=#080808	gui=none	ctermfg=184
hi WildMenu		guifg=#dde139	guibg=#080808	gui=none	ctermfg=184
hi WildMenu		guifg=#acf0f2	guibg=#080808	gui=none	ctermfg=184
hi WildMenu		guifg=#85b0df	guibg=#080808	gui=none	ctermfg=184

"hi VertSplit		guifg=#121212	guibg=#300a03	gui=none
"hi VertSplit		guifg=#7f1f1a	guibg=black	gui=none
"hi VertSplit		guifg=#7f1f1a	guibg=#121212	gui=none
"hi VertSplit		guifg=#7f1f1a	guibg=#282828	gui=none
"hi VertSplit		guifg=#282828	guibg=#282828	gui=none	ctermfg=254	ctermbg=235
hi VertSplit		guifg=#121212	guibg=#121212	gui=none
"hi VertSplit		guifg=#282828	guibg=#282828	gui=none

hi MyMru		guifg=#E94040

if 1
  hi LineNr	guifg=#7c7a6f	guibg=#181818	gui=none
  hi VertSplit	guifg=#282828	guibg=#121212	gui=none
 "hi VertSplit	guifg=#121212	guibg=#282828	gui=none

 "hi LineNr	guifg=#7c7a6f	guibg=#282828	gui=none
 "hi VertSplit	guifg=#000000	guibg=#282828	gui=bold

  hi LineNr	guifg=#7c7a6f	guibg=#282828	gui=none
  hi VertSplit	guifg=#282828	guibg=#000000	gui=none
  hi LineNr	guifg=#7c7a6f	guibg=#1a1a1a	gui=none
  hi LineNr	guifg=#5c5a4f	guibg=#1a1a1a	gui=none
  hi VertSplit	guifg=#282828	guibg=#1a1a1a	gui=none
  hi VertSplit	guifg=#1a1a1a	guibg=#1a1a1a	gui=none
 "hi LineNr	guifg=#7c7a6f	guibg=#1d1d1d	gui=none
 "hi VertSplit	guifg=#1d1d1d	guibg=#1d1d1d	gui=none
 "hi VertSplit	guifg=#282828	guibg=#282828	gui=none
  hi LineNr	guifg=#5c5a4f	guibg=#282828	gui=none
  hi LineNr	guifg=#5c5a4f	guibg=NONE	gui=none
endif
"hi VertSplit		guifg=#d0c589	guibg=#d0c589	gui=none
"hi VertSplit		guifg=#1a1aaa	guibg=#efdf89	gui=none	" guibgは色を錯覚するので#d0c589から補正	fg青にした間違い
hi VertSplit		guifg=#1a1a1a	guibg=#d0c589	gui=none	" guibgは色を錯覚するので#d0c589から補正
hi VertSplit		guifg=#dfc3a8	guibg=#d0c589	gui=none	" guibgは色を錯覚するので#d0c589から補正
hi VertSplit		guifg=#7f1f1a	guibg=#d0c589	gui=none	" guibgは色を錯覚するので#d0c589から補正


"hi VertSplit	guifg=#282828	guibg=#000000	gui=none
hi VertSplit2	guifg=#7f1f1a	guibg=#d0c589	gui=none	" guibgは色を錯覚するので#d0c589から補正

hi StlGold		guifg=#1a1a1a	guibg=#d0c589	gui=none


" Asche
if 0
hi Normal	guifg=#f6f3f0	guibg=grey18	gui=none	ctermfg=254	ctermbg=235
hi NonText	guifg=#808080	guibg=grey22	gui=none	ctermfg=242	ctermbg=237
hi Normal	guifg=#f6f3f0	guibg=grey20	gui=none	ctermfg=254	ctermbg=235
hi NonText	guifg=#808080	guibg=grey30	gui=none	ctermfg=242	ctermbg=237
hi SpecialKey	guifg=#343434	guibg=NONE	gui=none
hi SpecialKey	guifg=#454545	guibg=NONE	gui=none
hi LineNr	guifg=#5c5a4f	guibg=NONE	gui=none	ctermfg=239	ctermbg=232
hi LineNr	guifg=#5c574f	guibg=NONE	gui=none	ctermfg=239	ctermbg=232
hi LineNr	guifg=#6c6a5f	guibg=NONE	gui=none	ctermfg=239	ctermbg=232
endif


" Tab
hi TabLine		guifg=#eeddcc	guibg=black	gui=underline
hi TabLine		guifg=#eeddcc	guibg=black	gui=none
hi TabLine		guifg=#7c6b5f	guibg=black	gui=none
hi TabLine		guifg=#8c7b6f	guibg=black	gui=none
hi TabLine		guifg=#d0c5a9	guibg=black	gui=none
hi TabLine		guifg=#8c7b73	guibg=black	gui=none
hi TabLine		guifg=#ac9b83	guibg=black	gui=none
hi TabLine      	guifg=#d0c589	gui=none	ctermfg=184
hi TabLineSel		guifg=#efd3b8	guibg=#7f1f1a	gui=none
hi TabLineSel		guifg=#a63318	guibg=#111111	gui=underline
hi TabLineSel		guifg=#a63318	guibg=#111111	gui=none
hi TabLineSel		guifg=indianred
hi TabLineSel		guifg=red
hi TabLineSel		guifg=#EF4123
hi TabLineSel		guifg=#bb3333
hi TabLineSel		guifg=#cc1f1a
hi TabLineSel		guifg=#cc3333
hi TabLineSel		guibg=NONE
hi TabLineFill		guifg=#343434	guibg=black
hi TabLineDate		guifg=#efd3b8	guibg=#bb3333	gui=none
hi TabLineDate		guifg=#efd3b8	guibg=#7f1f1a	gui=none
hi TabLineFill		guifg=#d0c589	guibg=#d0c589
hi TabLineSep		guifg=black	guibg=#d0c589	gui=none
hi TabLineSep		guifg=#d0c589	guibg=black	gui=underline
hi TabLineSep		guifg=#d0c589	guibg=#d0c589	gui=none
hi TabLineSep		guifg=#d0c5b9	guibg=black	gui=none	" 錯覚のため、TabLineFillのfgから色を微調整。
hi TabLineSep		guifg=#d0c5b9	guibg=black	gui=underline	" 錯覚のため、TabLineFillのfgから色を微調整。
hi TabLineSep		guifg=#d0c5a9	guibg=black	gui=underline	" 錯覚のため、TabLineFillのfgから色を微調整。
hi TabLineSep		guifg=#d0c5a9	guibg=black	gui=NONE	" 錯覚のため、TabLineFillのfgから色を微調整。


" func_name
hi hl_func_name		guifg=#cdd129			gui=none	ctermfg=184
hi hl_func_name		guifg=#cdd129	guibg=black	gui=none	ctermfg=184
hi hl_func_name_stl	guifg=#85b0df	guibg=black	gui=none	ctermfg=184
hi green_stl        	guifg=#85ffb0	guibg=black	gui=none	ctermfg=184
hi green_stl        	guifg=#85dfb0	guibg=black	gui=none	ctermfg=184
hi green_stl        	guifg=#85efb0	guibg=black	gui=none	ctermfg=184
hi hl_buf_name_stl	guifg=#ff5d28	guibg=black	gui=none	ctermfg=202

" Anzu PopWin
hi AnzuPopWin	guifg=#85b0df	guibg=#181818	gui=none	ctermfg=254	ctermbg=235

" Syntax highlighting
hi Comment 	guifg=#808080			ctermfg=244	| " gui=italic
hi Comment 	guifg=#848280			ctermfg=244	| " gui=italic
hi Todo 	guifg=#8f8f8f	gui=italic	ctermfg=245
hi Constant 	guifg=#acf0f2	gui=none	ctermfg=159
hi String 	guifg=#ff5d28	gui=none	ctermfg=202
hi Identifier 	guifg=#ff5d28	gui=none	ctermfg=202
hi Function 	guifg=#cdd129	gui=none	ctermfg=184
hi Type 	guifg=#ffad68	gui=none	ctermfg=202
hi Type 	guifg=#fdbd89	gui=none	ctermfg=184
hi Type 	guifg=#adb110	gui=none	ctermfg=184
hi Type 	guifg=#ff5d28	gui=none	ctermfg=184
hi Type 	guifg=#ffa678	gui=none	ctermfg=184
hi Type 	guifg=#bdbd89	gui=none	ctermfg=184
hi Type 	guifg=#bab889	gui=none	ctermfg=184
hi Type 	guifg=#beb589	gui=none	ctermfg=184
hi Type 	guifg=#cea589	gui=none	ctermfg=184
hi Type 	guifg=#d3ca94	gui=none	ctermfg=184
hi Type 	guifg=#f0c589	gui=none	ctermfg=184
hi Type 	guifg=#d8c589	gui=none	ctermfg=184
hi Type 	guifg=#cec589	gui=none	ctermfg=184
hi Type 	guifg=#d0c589	gui=none	ctermfg=184
"hi Type 	guifg=gold	gui=none	ctermfg=184
hi Statement 	guifg=#af5f5f	gui=none	ctermfg=131
hi Keyword	guifg=#cdd129	gui=none	ctermfg=184
hi PreProc 	guifg=#ede39e	gui=none	ctermfg=187
hi PreProc	guifg=indianred
hi PreProc 	guifg=#ff5d28	gui=none	ctermfg=202
hi PreProc	guifg=#bb99bb
hi PreProc	guifg=#9999bb
hi Include	guifg=#aaaaaa
hi Include	guifg=#cccccc
hi Include	guifg=#9999bb

"PreProc
hi PreProc	guifg=#9999bb
hi Include	guifg=#9999bb
hi Define	guifg=#bbeeff
hi Define	guifg=#bb9999
hi link Macro Define
hi PreCondit	guifg=#9999bb

hi String 	guifg=indianred
hi String	guifg=#bdbd89	gui=none	ctermfg=184
hi String 	guifg=#ffa678	gui=none	ctermfg=184
hi String 	guifg=#ff9678	gui=none	ctermfg=184
hi String 	guifg=#df9678	gui=none	ctermfg=184
"hi String 	guifg=#af5f5f	gui=none	ctermfg=131
hi String 	guifg=#ff9678	gui=none	ctermfg=184
"hi Statement	guifg=indianred
hi Number	guifg=indianred
hi Number 	guifg=#ff5d28	gui=none	ctermfg=202
hi Number 	guifg=#8cf2a0	gui=none	ctermfg=159
hi Number	guifg=#ede39e	gui=none	ctermfg=187
hi Number 	guifg=#acf0f2	gui=none	ctermfg=159
hi Number 	guifg=#fca08c	gui=none	ctermfg=159
hi Number	guifg=#ff9678	gui=none	ctermfg=184
hi String 	guifg=#ffbb88	gui=none	ctermfg=159
hi String 	guifg=#ffffaa	gui=none	ctermfg=159
hi String 	guifg=#ffaa88	gui=none	ctermfg=159
hi String 	guifg=#acf0f2	gui=none	ctermfg=159
"hi String 	guifg=#ffa678	gui=none	ctermfg=184
hi String	guifg=NONE	guibg=NONE	gui=italic	ctermfg=254	ctermbg=235
hi String	guifg=#ffddaa	guibg=NONE	gui=none	ctermfg=254	ctermbg=235
hi String	guifg=#9999bb
hi String	guifg=#E9EAEA
hi String	guifg=#99bb99
hi Number	guifg=#ff8f6f	gui=none	ctermfg=184	" Vim
hi Number	guifg=#ff9777	gui=none	ctermfg=184	" Vim
hi Number	guifg=#f08060	gui=none	ctermfg=184	" Vim
hi Number	guifg=#ff9797	gui=none	ctermfg=184	" C

hi Number	guifg=NONE	gui=NONE	ctermfg=184	" C
hi String	guifg=#ff9797	gui=none	ctermfg=184	" C
hi Number	guifg=NONE	gui=NONE	ctermfg=184	" C
hi Number	guifg=#e5e2d0	gui=NONE	ctermfg=184	" C
hi String	guifg=#ef3787	gui=none	ctermfg=184	" C
hi String	guifg=#ef6787	gui=none	ctermfg=184	" C
hi String	guifg=#ef7787	gui=none	ctermfg=184	" C
hi String	guifg=#ff8787	gui=none	ctermfg=184	" C
hi String	guifg=#ef5787	gui=none	ctermfg=184	" C
hi String	guifg=#ff8787	gui=none	ctermfg=184	" C
hi String	guifg=#efa787	gui=none	ctermfg=184	" C
hi String	guifg=#b7ef97	gui=none	ctermfg=184	" C
hi String	guifg=#bf97ff	gui=none	ctermfg=184	" C
hi String	guifg=#b797ef	gui=none	ctermfg=184	" C
hi String 	guifg=#df9678	gui=none	ctermfg=184

hi Special	guifg=#acf0f2	gui=none	ctermfg=159

if 0
  " COMMON COLORS AND SETTINGS
  highlight PreProc guifg=#dfaf87 guibg=NONE gui=NONE ctermfg=180 ctermbg=NONE cterm=NONE
  highlight Function guifg=#875f5f guibg=NONE gui=NONE ctermfg=95 ctermbg=NONE cterm=NONE
  highlight Identifier guifg=#87afaf guibg=NONE gui=NONE ctermfg=109 ctermbg=NONE cterm=NONE
  highlight Statement guifg=#878787 guibg=NONE gui=NONE ctermfg=102 ctermbg=NONE cterm=NONE
  highlight Constant guifg=#af8787 guibg=NONE gui=NONE ctermfg=138 ctermbg=NONE cterm=NONE
  highlight Type guifg=#af875f guibg=NONE gui=NONE ctermfg=137 ctermbg=NONE cterm=NONE
  highlight Label guifg=#878787 guibg=NONE gui=NONE ctermfg=102 ctermbg=NONE cterm=NONE
  highlight Special guifg=#af5f5f guibg=NONE gui=NONE ctermfg=131 ctermbg=NONE cterm=NONE
  highlight Operator guifg=#878787 guibg=NONE gui=NONE ctermfg=102 ctermbg=NONE cterm=NONE
  highlight Title guifg=#dfaf87 guibg=NONE gui=NONE ctermfg=180 ctermbg=NONE cterm=NONE
  highlight Conditional guifg=#878787 guibg=NONE gui=NONE ctermfg=102 ctermbg=NONE cterm=NONE
  highlight StorageClass guifg=#875f5f guibg=NONE gui=NONE ctermfg=95 ctermbg=NONE cterm=NONE
  highlight htmlStatement guifg=#878787 guibg=NONE gui=NONE ctermfg=102 ctermbg=NONE cterm=NONE
  highlight htmlItalic guifg=#dfaf87 guibg=NONE gui=NONE ctermfg=180 ctermbg=NONE cterm=NONE
  highlight htmlArg guifg=#875f5f guibg=NONE gui=NONE ctermfg=95 ctermbg=NONE cterm=NONE
  highlight cssIdentifier guifg=#dfaf87 guibg=NONE gui=NONE ctermfg=180 ctermbg=NONE cterm=NONE
  highlight cssClassName guifg=#dfaf87 guibg=NONE gui=NONE ctermfg=180 ctermbg=NONE cterm=NONE
  highlight Structure guifg=#875f5f guibg=NONE gui=NONE ctermfg=95 ctermbg=NONE cterm=NONE
  highlight Typedef guifg=#875f5f guibg=NONE gui=NONE ctermfg=95 ctermbg=NONE cterm=NONE
  highlight Repeat guifg=#878787 guibg=NONE gui=NONE ctermfg=102 ctermbg=NONE cterm=NONE
  highlight Keyword guifg=#878787 guibg=NONE gui=NONE ctermfg=102 ctermbg=NONE cterm=NONE
  highlight Exception guifg=#878787 guibg=NONE gui=NONE ctermfg=102 ctermbg=NONE cterm=NONE
  highlight Number guifg=#af5f00 guibg=NONE gui=NONE ctermfg=130 ctermbg=NONE cterm=NONE
  highlight Character guifg=#af5f00 guibg=NONE gui=NONE ctermfg=130 ctermbg=NONE cterm=NONE
  highlight Boolean guifg=#af5f00 guibg=NONE gui=NONE ctermfg=130 ctermbg=NONE cterm=NONE
  highlight Float guifg=#af5f00 guibg=NONE gui=NONE ctermfg=130 ctermbg=NONE cterm=NONE
  highlight Include guifg=#dfaf87 guibg=NONE gui=NONE ctermfg=180 ctermbg=NONE cterm=NONE
  highlight Define guifg=#dfaf87 guibg=NONE gui=NONE ctermfg=180 ctermbg=NONE cterm=NONE
  "highlight Comment guifg=#87875f guibg=NONE gui=NONE ctermfg=101 ctermbg=NONE cterm=NONE
  highlight Repeat guifg=#87875f guibg=NONE gui=NONE ctermfg=101 ctermbg=NONE cterm=NONE
  highlight Conditional guifg=#87875f guibg=NONE gui=NONE ctermfg=101 ctermbg=NONE cterm=NONE

  highlight String guifg=#ffdf87 guibg=#121212 gui=NONE ctermfg=222 ctermbg=233 cterm=NONE
  highlight String guifg=#ffdf87 guibg=#1c1c1c gui=NONE ctermfg=222 ctermbg=234 cterm=NONE
  highlight String guifg=#ffdf87 guibg=#262626 gui=NONE ctermfg=222 ctermbg=235 cterm=NONE
  highlight String guifg=#ffdf87 guibg=NONE ctermfg=222 ctermbg=NONE cterm=NONE gui=NONE
endif

" Diff
hi DiffAdd	guifg=NONE	guibg=#200a0a	gui=NONE	term=bold	ctermbg=1
hi DiffDelete	guifg=#1a1a4a	guibg=#111130	gui=NONE	term=bold	ctermbg=1
hi DiffChange	guifg=NONE	guibg=NONE	gui=NONE	term=NONE	ctermbg=NONE
hi DiffText	guifg=NONE	guibg=#303088	gui=NONE	term=reverse	ctermbg=12	cterm=bold
hi DiffChange	guifg=NONE	guibg=#101010	gui=NONE	term=NONE	ctermbg=NONE
hi DiffText	guifg=NONE	guibg=#503058	gui=NONE	term=reverse	ctermbg=12	cterm=bold
if 0
  hi DiffText	guifg=white	guibg=red	gui=NONE	term=reverse	ctermbg=12	cterm=bold
endif

hi DiffDelete	guifg=#101010	guibg=#101010	gui=NONE	term=bold	ctermbg=1
hi DiffChange	guifg=NONE	guibg=#111130	gui=NONE	term=NONE	ctermbg=NONE

hi DiffDelete	guifg=#101010	guibg=#111130	gui=NONE	term=bold	ctermbg=1
hi DiffChange	guifg=NONE	guibg=#101010	gui=NONE	term=NONE	ctermbg=NONE
hi DiffChange	guifg=NONE	guibg=#141414	gui=NONE	term=NONE	ctermbg=NONE

"hi DiffChange	guifg=NONE	guibg=NONE	gui=NONE	term=NONE	ctermbg=NONE
"hi DiffText	guifg=NONE	guibg=#111130	gui=NONE	term=reverse	ctermbg=12	cterm=bold
"hi DiffText	guifg=NONE	guibg=#802010	gui=NONE	term=reverse	ctermbg=12	cterm=bold
"hi DiffText	guifg=NONE	guibg=#701008	gui=NONE	term=reverse	ctermbg=12	cterm=bold
"hi DiffText	guifg=NONE	guibg=#600c04	gui=NONE	term=reverse	ctermbg=12	cterm=bold
"hi DiffAdd	guifg=NONE	guibg=#111130	gui=NONE	term=bold	ctermbg=1

" supplemental
hi qfFileName	guifg=#c0504d
hi ErrorMsg	guifg=black	guibg=#ffd129
hi ErrorMsg	guibg=black	guifg=#ffd129
hi ErrorMsg	guibg=black	guifg=#fff129
hi ErrorMsg	guibg=NONE	guifg=#f1ff29
hi ErrorMsg	guibg=NONE	guifg=#fff129


" File Tree
hi Directory	guifg=#ff2222	guibg=NONE
hi Directory	guifg=#ff4444	guibg=NONE
hi Directory	guifg=#ff6666	guibg=NONE




"""""""""""""""""""""""""""""""挿入モード時、ステータスラインの色を変更""""""""""""""""""""""""""""""

augroup InsertModeStlColor
  au!
  "? au InsertEnter  * call s:SetStatusLineColor('Insert')
  "? au InsertLeave  * call s:SetStatusLineColor('Normal')
  "? au CmdlineEnter * call s:SetStatusLineColor('CmdLine')
  "? au CmdlineLeave * call s:SetStatusLineColor('Normal')
augroup END

function! s:SetStatusLineColor(mode)
  if a:mode == 'Insert'
    silent highlight	StatusLine	guifg=white	guibg=#1a1f7f		gui=NONE	ctermfg=blue	ctermbg=yellow	cterm=NONE
  "elseif a:mode == 'Command'
    "silent highlight	StatusLine	guifg=darkblue	guibg=darkyellow	gui=NONE	ctermfg=blue	ctermbg=yellow	cterm=NONE
  else
    highlight clear StatusLine
    silent exec s:slhlcmd
  endif
endfunction

let s:sss = 1

if s:sss
function! s:SetStatusLineColor(mode)
  if a:mode == 'Insert'
    "silent highlight	CursorLineNr	guifg=White	guibg=#1a1f7f	gui=NONE	ctermfg=Blue			cterm=bold,underline
    "silent highlight	CursorLineNr	guifg=#aaccff	guibg=#1a1f7f	gui=NONE	ctermfg=Blue			cterm=bold,underline
    "silent highlight	CursorLineNr	guifg=black	guibg=darkyellow	gui=NONE	ctermfg=Blue			cterm=bold,underline
    "silent highlight	CursorLineNr	guifg=#aaccff	guibg=#0000ff	gui=NONE	ctermfg=Blue			cterm=bold,underline
    silent highlight	CursorLineNr	guifg=#b8d3ef	guibg=#4444ee	gui=NONE	ctermfg=Blue			cterm=bold,underline
  elseif a:mode == 'CmdLine'
   "silent highlight	StatusLine	guifg=white	guibg=#1a1f7f		gui=NONE	ctermfg=blue	ctermbg=yellow	cterm=NONE
    silent highlight	StatusLine	guifg=white	guibg=#2a2f5f		gui=NONE	ctermfg=blue	ctermbg=yellow	cterm=NONE
   "silent highlight	StatusLine	guifg=white	guibg=#000000		gui=NONE	ctermfg=blue	ctermbg=yellow	cterm=NONE
   "silent highlight	StatusLine	guifg=NONE	guibg=#181818	gui=none	ctermfg=254	ctermbg=235
    " 選択中項目は WildMenu 
    "redrawstatus
  else
    highlight clear CursorLineNr
    silent exec s:slhlcmdd
    highlight clear StatusLine
    silent exec s:slhlcmd
  endif
endfunction
endif

function! s:GetHighlight(hi)
  redir => hl
  exec 'highlight '.a:hi
  redir END
  let hl = substitute(hl, '[\r\n]', '', 'g')
  let hl = substitute(hl, 'xxx', '', '')
  return hl
endfunction

"silent! let s:slhlcmd = 'highlight ' . s:GetHighlight('StatusLine')	" これだけだと、Command Lineの色が取得される。
augroup GetStatusLineHighlight
  au!
  "? au ColorScheme * silent! let s:slhlcmd = 'highlight ' . s:GetHighlight('StatusLine')
  "? au ColorScheme * au! GetStatusLineHighlight
augroup end


silent! let s:slhlcmdd = 'highlight ' . s:GetHighlight('CursorLineNr')



"""""""""""""""""""""""""""""""挿入モード時、ステータスラインの色を変更""""""""""""""""""""""""""""""

augroup InsertModeStlColor
  au!
  au InsertEnter * call s:SetStatusLineColor('Insert')
  au InsertLeave * call s:SetStatusLineColor('Normal')
augroup END

function! s:SetStatusLineColor(mode)
  if a:mode == 'Insert'
    "silent highlight	StatusLine	guifg=white	guibg=#1a1f7f		gui=NONE	ctermfg=blue	ctermbg=yellow	cterm=NONE
    silent highlight	StatusLine	guifg=#efd3b8	guibg=#d0330b	gui=NONE
  "elseif a:mode == 'Command'
    "silent highlight	StatusLine	guifg=darkblue	guibg=darkyellow	gui=NONE	ctermfg=blue	ctermbg=yellow	cterm=NONE
  else
    highlight clear StatusLine
    silent exec s:slhlcmd
  endif
endfunction

let s:sss = 1

if s:sss
function! s:SetStatusLineColor(mode)
  if a:mode == 'Insert'
    "silent highlight	CursorLineNr	guifg=White	guibg=#1a1f7f	gui=NONE	ctermfg=Blue			cterm=bold,underline
    "silent highlight	CursorLineNr	guifg=#aaccff	guibg=#1a1f7f	gui=NONE	ctermfg=Blue			cterm=bold,underline
    "silent highlight	CursorLineNr	guifg=black	guibg=darkyellow	gui=NONE	ctermfg=Blue			cterm=bold,underline
    "? silent highlight	CursorLineNr	guifg=#aaccff	guibg=#0000ff	gui=NONE	ctermfg=Blue			cterm=bold,underline

    silent highlight	CursorLineNr	guifg=#efd3b8	guibg=#d0330b	gui=NONE         ctermfg=Blue			cterm=bold,underline

    "silent highlight	CursorLineNr	guibg=#d0c589	guifg=#222222 gui=none	gui=NONE         ctermfg=Blue	cterm=bold,underline
    "silent highlight	CursorLineNr	guibg=#d0c589	guifg=#111111 gui=none	gui=NONE         ctermfg=Blue	cterm=bold,underline
    "silent highlight	CursorLineNr	guibg=#d0c589	guifg=black   gui=none	gui=NONE         ctermfg=Blue	cterm=bold,underline

  else
    highlight clear CursorLineNr
    silent exec s:slhlcmdd
  endif
endfunction
endif

"function! s:SetStatusLineColor(mode)
"endfunction

function! s:GetHighlight(hi)
  redir => hl
  exec 'highlight '.a:hi
  redir END
  let hl = substitute(hl, '[\r\n]', '', 'g')
  let hl = substitute(hl, 'xxx', '', '')
  return hl
endfunction

silent! let s:slhlcmd = 'highlight ' . s:GetHighlight('StatusLine')

silent! let s:slhlcmdd = 'highlight ' . s:GetHighlight('CursorLineNr')



" gui cursor

"hi Cursor guifg=NONE guibg=red
"hi Cursor guifg=NONE guibg=black gui=none
hi Cursor	guifg=#c01f1a	guibg=black	gui=reverse	ctermbg=0x241
hi Cursor	guifg=#ffffff	guibg=black	gui=reverse	ctermbg=0x241
hi Cursor	guifg=indianred	guibg=black	gui=reverse	ctermbg=0x241
"hi CursorLine	guifg=NONE	guibg=NONE	gui=underline	ctermbg=NONE	cterm=underline

highlight CursorIM guifg=indianred guibg=indianred
highlight CursorIM guifg=yellow guibg=yellow

set guicursor=n-v-c:block-Cursor/lCursor,ve:ver35-Cursor,o:hor50-Cursor,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor,a:blinkon0
set guicursor=n-v-c:block-Cursor/lCursor,ve:ver35-Cursor,o:hor50-Cursor,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor,a:blinkon0
set guicursor=n-v-c:ver10-Cursor/lCursor,ve:ver35-Cursor,o:hor50-Cursor,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor,a:blinkon0

set guicursor=n-v-c:block-blinkwait2000-blinkon600-blinkoff400-Cursor/lCursor,ve:ver35-Cursor,o:hor50-Cursor,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor
set guicursor=n-v-c:ver10-blinkwait2000-blinkon600-blinkoff400-Cursor/lCursor,ve:ver35-Cursor,o:hor50-Cursor,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor
set guicursor=n-v-c:ver10-blinkwait2000-blinkon600-blinkoff400-Cursor/lCursor,ve:ver35-Cursor,o:hor50-Cursor,i-ci:hor30-Cursor/lCursor,r-cr:Block-Cursor/lCursor
set guicursor=n-v-c:hor20-blinkwait2000-blinkon600-blinkoff400-Cursor/lCursor,ve:ver35-Cursor,o:hor50-Cursor,i-ci:hor30-Cursor/lCursor,r-cr:Block-Cursor/lCursor
set guicursor=n-v-c:block-blinkwait1000-blinkon600-blinkoff400-Cursor/lCursor,ve:ver35-Cursor,o:hor50-Cursor,i-ci:hor30-Cursor/lCursor,r-cr:Block-Cursor/lCursor
set guicursor=n-v-c:ver20-blinkwait1000-blinkon600-blinkoff400-Cursor/lCursor,ve:ver35-Cursor,o:hor50-Cursor,i-ci:hor30-Cursor/lCursor,r-cr:Block-Cursor/lCursor




" 琳派
" Thinkpad
" Modern Red (Windows XP Zune)
" Zplus
"
" (Star Saver)
" (Comboy)


" kinaka 金赤	#EF4123	#ef4123
"
"
" TODO 赤っぽい橙 #FF3300


" Temp
hi Question	guifg=#cc1f1a
hi Question	guifg=#ff6666
hi Question	guifg=#dd3333
hi Question	guifg=#cf302d
hi WarningMsg	guifg=#cf302d

hi ErrorMsg	guifg=#44cc44
hi WarningMsg	guifg=#4444cc
hi Question	guifg=#666666

if 0

  hi ErrorMsg	guifg=#4444cc
  hi WarningMsg	guifg=#44cc44

  hi ErrorMsg	guifg=#cc4444
  hi WarningMsg	guifg=#cc4444

endif

hi ModeMsg	guifg=#cc4444	guibg=NONE


" 薄緑 hi TabLineFill		guifg=#00c589	guibg=#d0c589
com! KKK call s:SetStatusLineColor('CmdLine')



" #D13438
" #FF4141
" #F94C40
" #963634
" #EF3E0E
" #BFED9B 薄緑 Statusline へのアクセントに
" #963634 少し薄い漆赤
