scriptencoding utf-8
" vim:set ts=8 sts=8 sw=2 tw=0: (この行に関しては:help modelineを参照)

set background=dark
hi clear

if exists("syntax_on")
  syntax reset
endif

let colors_name = "Rimpa"





hi slRedChar        guifg=#f63328   guibg=black      gui=NONE
hi qfFileName	guifg=#c0504d
hi AzukiHaikei	guifg=#f6f3f0	guibg=#170a00	gui=NONE	ctermfg=254	ctermbg=235
"hi Normal1	guifg=#f6f3f0	guibg=#d0c589	gui=NONE	ctermfg=254	ctermbg=235	" 金箔背景
hi NormalPop	guifg=#f6f3f0	guibg=#181818	gui=NONE	ctermfg=254	ctermbg=235
"hi KinpakuBG	guifg=#808080	guibg=#d0c589	gui=NONE	ctermfg=242	ctermbg=237	" 金箔背景

hi CursorLineNr2	guifg=#efd3b8	guibg=#bb3333	gui=NONE
hi CursorLineNr3	guifg=#d0c589	guibg=#bb3333	gui=NONE
hi CursorLineNr4	guifg=#bb3333	guibg=NONE	gui=NONE	ctermfg=239	ctermbg=232
hi CursorLineNr5	guifg=#ff6666	guibg=NONE	gui=NONE	ctermfg=239	ctermbg=232

"hi Visual		guifg=NONE	guibg=#444444	gui=NONE	ctermfg=186	ctermbg=238
"hi Terminal		guifg=white	guibg=black	gui=NONE

hi StatusLine1		guifg=#ef4123	guibg=#7f1f1a	gui=NONE	" ない
hi StatusLine2		guifg=#ff6666	guibg=#7f1f1a	gui=NONE	" Rimpaデフォルト 赤字
hi StatusLine3		guifg=#dfc3a8	guibg=#7f1f1a	gui=NONE	" Rimpaデフォルト
hi StatusLine4		guifg=#dfc3a8	guibg=#ef4123	gui=NONE	" 金赤   白字
hi StatusLine5		guifg=#efd3b8	guibg=#bb3333	gui=NONE	" 薄い赤 白字
hi StatusLine6		guifg=#efd3b8	guibg=#802020	gui=NONE	" 秋の色?

hi StatusLineNC11	guifg=#efd3b8   guibg=#9f1f1a   gui=NONE        " Rimpaデフォルト 高コントラスト白字
hi StatusLineNC12	guifg=#efd3b8   guibg=#9f1f0a   gui=NONE        " Rimpaデフォルト 高コントラスト白字
hi StatusLineNC13	guifg=#efd3b8   guibg=#7f1f0a   gui=NONE        " Rimpaデフォルト 高コントラスト白字
hi StatusLineNC14	guifg=#efd3b8   guibg=#6f0f00   gui=NONE        " Rimpaデフォルト 高コントラスト白字
hi StatusLineNC15	guifg=#efd3b8   guibg=#af2f1a   gui=NONE        " Rimpaデフォルト 高コントラスト白字
hi StatusLineNC16	guifg=#efd3b8   guibg=#8f1f0a   gui=NONE        " Rimpaデフォルト 高コントラスト白字
hi StatusLineNC17	guifg=#5c5a4f	guibg=#101010	gui=NONE
hi StatusLineNC110	guifg=#6c6a5f	guibg=#300a03	gui=NONE
hi StatusLineNC112	guifg=#8c8a7f	guibg=#201810	gui=NONE
hi StatusLineNC113	guifg=#8c8a7f	guibg=#804030	gui=NONE
hi StatusLineNC116	guifg=#000000	guibg=#bb9999
hi StatusLineNC117	guifg=#7f1f1a	guibg=#d0c589	gui=NONE	" guibgは色を錯覚するので#d0c589から補正

hi VertSplit21		guifg=#282828	guibg=#282828	gui=NONE	ctermfg=254	ctermbg=235
hi VertSplit11		guifg=#121212	guibg=#121212	gui=NONE
hi VertSplit12		guifg=#1a1a1a	guibg=#1a1a1a	gui=NONE
hi VertSplit22		guifg=#1d1d1d	guibg=#1d1d1d	gui=NONE
hi VertSplit24		guifg=#7f1f1a	guibg=#121212	gui=NONE
hi VertSplit25		guifg=#7f1f1a	guibg=#282828	gui=NONE
hi VertSplit13		guifg=#282828	guibg=#121212	gui=NONE
hi VertSplit15		guifg=#282828	guibg=#1a1a1a	gui=NONE
hi VertSplit26		guifg=#121212	guibg=#300a03	gui=NONE
hi VertSplit27		guifg=#121212	guibg=#282828	gui=NONE
hi VertSplit28	        guifg=black	guibg=#282828	gui=bold
hi VertSplit16		guifg=#1a1aaa	guibg=#efdf89	gui=NONE	" guibgは色を錯覚するので#d0c589から補正	fg青にした間違い
hi VertSplit29		guifg=#d0c589	guibg=#d0c589	gui=NONE
hi VertSplit18		guifg=#dfc3a8	guibg=#d0c589	gui=NONE	" guibgは色を錯覚するので#d0c589から補正

hi TabLine1		guifg=#eeddcc	guibg=black	gui=underline
hi TabLine3		guifg=#7c6b5f	guibg=black	gui=NONE
hi TabLine4		guifg=#8c7b6f	guibg=black	gui=NONE
hi TabLine6		guifg=#ac9b83	guibg=black	gui=NONE
hi TabLine7		guifg=#d0c589	guibg=black	gui=NONE	ctermfg=184

hi TabLineSel1		guifg=#efd3b8	guibg=#7f1f1a	gui=NONE
hi TabLineSel2		guifg=#a63318	guibg=#111111	gui=underline
hi TabLineSel3		guifg=#a63318	guibg=#111111	gui=NONE
hi TabLineSel4		guifg=indianred
hi TabLineSel5		guifg=red
hi TabLineSel6		guifg=#ef4123
hi TabLineSel7		guifg=#bb3333
hi TabLineSel8		guifg=#cc1f1a
hi TabLineSel9		guifg=#cc3333
hi TabLineSel10		guibg=NONE

hi TabLineSep1		guifg=black	guibg=#d0c589	gui=NONE
hi TabLineSep2		guifg=#d0c589	guibg=black	gui=underline
hi TabLineSep3		guifg=#d0c589	guibg=#d0c589	gui=NONE
hi TabLineSep4		guifg=#d0c5b9	guibg=black	gui=NONE	" 錯覚のため、TabLineFillのfgから色を微調整。
hi TabLineSep5		guifg=#d0c5b9	guibg=black	gui=underline	" 錯覚のため、TabLineFillのfgから色を微調整。

hi TabLineFill1		guifg=#343434	guibg=black	gui=NONE

hi TabLineDate1		guifg=#efd3b8	guibg=#bb3333	gui=NONE
hi TabLineDate2		guifg=#efd3b8	guibg=#7f1f1a	gui=NONE

hi hl_func_name		guifg=#cdd129	guibg=NONE	gui=NONE	ctermfg=184
hi green_stl1		guifg=#85ffb0	guibg=black	gui=NONE	ctermfg=184
hi green_stl2		guifg=#85dfb0	guibg=black	gui=NONE	ctermfg=184

hi DiffChange1		guifg=NONE	guibg=#141414	gui=NONE	term=NONE	ctermbg=NONE
hi DiffText1		guifg=NONE	guibg=#600c04	gui=NONE	term=reverse	ctermbg=12	cterm=bold
hi DiffText2		guifg=NONE	guibg=#802010	gui=NONE	term=reverse	ctermbg=12	cterm=bold	" 赤漆
hi DiffTextA		guifg=NONE	guibg=#503058	gui=NONE	term=reverse	ctermbg=12	cterm=bold

hi IncSearch1		guifg=white	guibg=red	gui=NONE
hi CurSearch5		guifg=#b7282e	guibg=white
hi CurSearch6		guifg=red	guibg=white	gui=NONE
hi CurSearch1		guifg=white	guibg=red
hi CurSearch2		guifg=black	guibg=#b7282e
hi CurSearch3		guifg=#eeddcc	guibg=#b7282e
hi CurSearch4		guifg=white	guibg=red
"hi CurSearch7		guifg=#b7282e	guibg=white	gui=NONE
"hi! link CurSearch	Search

hi QuickFixLine1		guifg=NONE	guibg=#404040	gui=NONE
hi QuickFixLine2		guifg=NONE	guibg=#403c38	gui=NONE
hi QuickFixLine3		guifg=NONE	guibg=#403a36	gui=NONE

hi Question1	guifg=#cc1f1a
hi Question2	guifg=#ff6666
hi Question3	guifg=#dd3333
hi Question4	guifg=#cf302d
hi WarningMsg1	guifg=#cf302d
hi WarningMsg2	guifg=#4444cc
hi WarningMsg4	guifg=#cc4444
hi ErrorMsg1	guifg=black	guibg=#ffd129
hi ErrorMsg2	guifg=#ffd129	guibg=black
hi ErrorMsg3	guifg=#fff129	guibg=black
hi ErrorMsg4	guifg=#f1ff29	guibg=NONE
hi ErrorMsg6	guifg=#000000	guibg=#ef4123	gui=bold
hi ErrorMsg5	guifg=#fff129	guibg=NONE	gui=NONE
hi ErrorMsg15		guifg=#ff88cd	guibg=NONE	gui=NONE
hi ErrorMsg16		guifg=#ffd488	guibg=NONE	gui=NONE
hi ErrorMsg14		guifg=#ffcc88	guibg=#000000	gui=NONE
hi ErrorMsg18		guifg=#ee6688	guibg=NONE	gui=NONE
hi ErrorMsg11		guifg=#ffd129	guibg=black
hi PopupNotification1	guifg=#ffcc88	guibg=#000000	gui=NONE
hi MessageWindow1	guifg=#ffff00	guibg=#000000	gui=NONE
hi MessageWindow2	guifg=#cc1f1a	guibg=black

hi Pmenu8	guifg=#cc4444	guibg=#343434	gui=NONE	ctermfg=0	ctermbg=184
hi Pmenu1	guifg=#000000	guibg=#c0504d	ctermfg=0	ctermbg=184
hi Pmenu9	guifg=#fef0ee	guibg=#343024	gui=NONE	ctermfg=0	ctermbg=184
hi Pmenu7	guifg=#fefefe	guibg=#343434	gui=NONE	ctermfg=0	ctermbg=184
hi Pmenu6	guifg=#eeeeee	guibg=#121212	ctermfg=239	ctermbg=232
hi Pmenu5	guifg=#eee8e0	guibg=#121002	ctermfg=239	ctermbg=232
hi Pmenu3	guifg=#eeeeee	guibg=#111111	ctermfg=239	ctermbg=232
hi Pmenu4	guifg=#eeeeee	guibg=black	ctermfg=239	ctermbg=232
hi PmenuA		guifg=#c0504d	guibg=#000000	gui=NONE
hi PmenuB		guifg=#d8c08c	guibg=#121002	gui=NONE	ctermfg=239	ctermbg=232
hi PmenuSel3	guifg=#dcda8f	guibg=black	ctermfg=0	ctermbg=184
hi PmenuSel4	guifg=#dcda8f	guibg=#333333	ctermfg=0	ctermbg=184
hi PmenuSel5	guifg=#eeeeee	guibg=black	gui=NONE	ctermfg=0	ctermbg=184
hi PmenuSel6	guifg=#121212	guibg=#eeddaa	gui=NONE	ctermfg=0	ctermbg=184
hi PmenuSel7	guifg=#eeeeee	guibg=#121212	ctermfg=239	ctermbg=232
hi PmenuSel0	guifg=black	guibg=#dcda8f	gui=NONE	ctermfg=0	ctermbg=184
hi Pmenu0	guifg=#dcda8f	guibg=black	ctermfg=239	ctermbg=232
hi PmenuSelA	guifg=#121002	guibg=#dcda8f	gui=NONE	ctermfg=0	ctermbg=184
"hi PmenuSelX		guifg=#121002	guibg=#ccc08c	gui=NONE	ctermfg=0	ctermbg=184
hi PmenuA	guifg=#dcda8f	guibg=#121002	ctermfg=239	ctermbg=232
hi PmenuThumbA	guifg=#ddbbaa	guibg=#c0504d	ctermfg=0	ctermbg=184

hi Folded1		guifg=#c0c0c0	guibg=#252525	gui=NONE
hi FoldColumn1		guifg=#ff5d28	guibg=#444444
hi FoldColumn2		guifg=#ff5d28	guibg=#605c58
hi FoldColumn3		guifg=#f6f3f0	guibg=#191917	gui=NONE	ctermfg=254	ctermbg=235
hi FoldColumn5		guifg=#f63328   guibg=black	gui=NONE
hi FoldColumn6		guifg=#000000	guibg=#c0504d	ctermfg=0	ctermbg=184
hi FoldColumn8		guifg=#7f1f1a	guibg=#d0c589	gui=NONE
hi CursorLineFoldA	guifg=White	guibg=Red
hi CursorLineFoldB	guifg=#d0c589	guibg=#bb3333	gui=NONE
hi FoldColumnC		guifg=#121212	guibg=#eeddaa	gui=NONE	ctermfg=0	ctermbg=184
hi CursorLineFoldD	guifg=#121212	guibg=#bb3333	gui=NONE

hi WildMenu1		guifg=#ffffff	guibg=#000000	gui=NONE
hi WildMenu2		guifg=#ffffff	guibg=#000000
hi WildMenu3		guifg=#efd3b8	guibg=#bb3333
hi WildMenu4		guifg=#efd3b8	guibg=#7f1f1a	gui=NONE	" Rimpaデフォルト 高コントラスト白字
hi WildMenu5		guifg=#efd3b8	guibg=#802020	gui=NONE	" 秋の色?
hi WildMenu6		guifg=#dfc3a8	guibg=#ef4123	gui=NONE	" 金赤   白字
hi WildMenu7		guifg=#efd3b8	guibg=#bb3333	gui=NONE	" 薄い赤 白字
hi WildMenu8		guifg=#000000	guibg=#ef4123	gui=bold	" 
hi WildMenu9		guifg=#ffffff	guibg=#2a2f5f	gui=NONE
hi WildMenu10		guifg=#ffffff	guibg=#1a1f7f	gui=NONE
hi WildMenu11		guifg=#ffffff	guibg=#000000	gui=NONE
hi WildMenu12		guifg=#ffffff	guibg=#000000	gui=NONE
hi WildMenu13		guifg=#cf302d	guibg=#000000
hi WildMenu14		guifg=#d0c589	gui=NONE	ctermfg=184
hi WildMenu15		guifg=#d0c589	guibg=#181818	gui=NONE	ctermfg=184
hi WildMenu16		guifg=#d0c589	guibg=#080808	gui=NONE	ctermfg=184
hi WildMenu17		guifg=#cdd129	guibg=#080808	gui=NONE	ctermfg=184
hi WildMenu18		guifg=#dde139	guibg=#080808	gui=NONE	ctermfg=184
hi WildMenu19		guifg=#acf0f2	guibg=#080808	gui=NONE	ctermfg=184
hi WildMenu20		guifg=#85b0df	guibg=#080808	gui=NONE	ctermfg=184

hi Title1	guifg=#f6f3e8	guibg=NONE	gui=bold
hi Title2	guifg=#f63328	guibg=NONE	gui=NONE
hi ErrorMsg6	guifg=#44cc44
hi ErrorMsg7	guifg=#4444cc
hi ErrorMsg8	guifg=#cc4444

hi QuickFixLine1		guifg=white	guibg=#87282e
hi QuickFixLine2		guifg=NONE	guibg=#87282e

hi Cursor1	guifg=NONE	guibg=NONE	gui=reverse	ctermbg=0x241
hi Cursor2	guifg=NONE	guibg=red
hi Cursor3	guifg=NONE	guibg=black	gui=NONE
hi Cursor4	guifg=#c01f1a	guibg=black	gui=reverse	ctermbg=0x241
hi Cursor5	guifg=#ffffff	guibg=black	gui=reverse	ctermbg=0x241
hi CursorIM1	guifg=indianred	guibg=indianred

"----------------------------------------------------------------------------------------------------
"let s:cln[0].name = 'CursorLineNrOrg'
"call hlset(s:cln)

" 選択中項目は WildMenu
"
if 1
" モードごとの色変更
  "'Insert'
    hi StatusLine101	guifg=white	guibg=#1a1f7f		gui=NONE	ctermfg=blue	ctermbg=yellow	cterm=NONE
    hi StatusLine103	guifg=#efd3b8	guibg=#d0330b		gui=NONE

  "'Command'
    hi StatusLine204	guifg=white	guibg=#000000		gui=NONE	ctermfg=blue	ctermbg=yellow	cterm=NONE
    hi StatusLine205	guifg=NONE	guibg=#181818		gui=NONE	ctermfg=254	ctermbg=235
    hi StatusLine201	guifg=darkblue	guibg=darkyellow	gui=NONE	ctermfg=blue	ctermbg=yellow	cterm=NONE
    hi StatusLine303	guifg=white	guibg=#2a2f5f		gui=NONE	ctermfg=blue	ctermbg=yellow	cterm=NONE

  "'Insert'
    hi CursorLineNr101	guifg=White	guibg=#1a1f7f		gui=NONE	ctermfg=Blue	cterm=bold,underline
    hi CursorLineNr102	guifg=#aaccff	guibg=#1a1f7f		gui=NONE	ctermfg=Blue	cterm=bold,underline
    hi CursorLineNr103	guifg=black	guibg=darkyellow	gui=NONE	ctermfg=Blue	cterm=bold,underline
    hi CursorLineNr104	guifg=#aaccff	guibg=#0000ff		gui=NONE	ctermfg=Blue	cterm=bold,underline
    hi CursorLineNr107	guibg=#d0c589	guifg=#222222		gui=NONE	ctermfg=Blue	cterm=bold,underline
    hi CursorLineNr108	guibg=#d0c589	guifg=#111111		gui=NONE	ctermfg=Blue	cterm=bold,underline
    hi CursorLineNr109	guibg=#d0c589	guifg=black		gui=NONE	ctermfg=Blue	cterm=bold,underline
    hi CursorLineNr405	guifg=#b8d3ef	guibg=#4444ee		gui=NONE	ctermfg=Blue	cterm=bold,underline
    hi CursorLineNr406	guifg=#efd3b8	guibg=#d0330b		gui=NONE	ctermfg=Blue	cterm=bold,underline
endif
"----------------------------------------------------------------------------------------------------

hi AnzuPopWin	guifg=#85b0df	guibg=#181818	gui=NONE	ctermfg=254	ctermbg=235

"set guicursor=n-v-c:block-Cursor/lCursor,ve:ver35-Cursor,o:hor50-Cursor,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor,a:blinkon0
"set guicursor=n-v-c:ver10-Cursor/lCursor,ve:ver35-Cursor,o:hor50-Cursor,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor,a:blinkon0
"set guicursor=n-v-c:block-blinkwait2000-blinkon600-blinkoff400-Cursor/lCursor,ve:ver35-Cursor,o:hor50-Cursor,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor
"set guicursor=n-v-c:ver10-blinkwait2000-blinkon600-blinkoff400-Cursor/lCursor,ve:ver35-Cursor,o:hor50-Cursor,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor
"set guicursor=n-v-c:ver10-blinkwait2000-blinkon600-blinkoff400-Cursor/lCursor,ve:ver35-Cursor,o:hor50-Cursor,i-ci:hor30-Cursor/lCursor,r-cr:Block-Cursor/lCursor
"set guicursor=n-v-c:hor20-blinkwait2000-blinkon600-blinkoff400-Cursor/lCursor,ve:ver35-Cursor,o:hor50-Cursor,i-ci:hor30-Cursor/lCursor,r-cr:Block-Cursor/lCursor
"set guicursor=n-v-c:block-blinkwait1000-blinkon600-blinkoff400-Cursor/lCursor,ve:ver35-Cursor,o:hor50-Cursor,i-ci:hor30-Cursor/lCursor,r-cr:Block-Cursor/lCursor

" Syntax
hi String31	guifg=#ff5d28	guibg=NONE	gui=NONE	ctermfg=202
hi String32	guifg=indianred
hi String33	guifg=#bdbd89	gui=NONE	ctermfg=184
hi String35	guifg=#ff9678	gui=NONE	ctermfg=184
hi String37	guifg=#ffffaa	gui=NONE	ctermfg=159
hi String39	guifg=#acf0f2	gui=NONE	ctermfg=159
hi String22	guifg=#b7ef97	gui=NONE	ctermfg=184
hi String11	guifg=#ffddaa	guibg=NONE	gui=NONE	ctermfg=254	ctermbg=235
hi String12	guifg=#9999bb
hi String13	guifg=#e9eaea
hi String14	guifg=#99bb99
hi String15	guifg=#ff9797	gui=NONE	ctermfg=184
hi String16	guifg=#ef3787	gui=NONE	ctermfg=184
hi String17	guifg=#ef6787	gui=NONE	ctermfg=184
hi String18	guifg=#ef7787	gui=NONE	ctermfg=184
hi String19	guifg=#ef5787	gui=NONE	ctermfg=184
hi String20	guifg=#ff8787	gui=NONE	ctermfg=184
hi String23	guifg=#bf97ff	gui=NONE	ctermfg=184
hi String24	guifg=#b797ef	gui=NONE	ctermfg=184
if 1
hi String26	guifg=#af5f5f	gui=NONE	ctermfg=131
hi String27	guifg=#ffdf87 guibg=#121212 gui=NONE ctermfg=222 ctermbg=233 cterm=NONE
hi String28	guifg=#ffdf87 guibg=#1c1c1c gui=NONE ctermfg=222 ctermbg=234 cterm=NONE
hi String29	guifg=#ffdf87 guibg=#262626 gui=NONE ctermfg=222 ctermbg=235 cterm=NONE
hi String30	guifg=#ffdf87 guibg=NONE ctermfg=222 ctermbg=NONE cterm=NONE gui=NONE
endif
hi String1	guifg=#ffbb88	guibg=NONE	gui=NONE	ctermfg=159
hi String2	guifg=#ffaa88	guibg=NONE	gui=NONE	ctermfg=159
hi String3	guifg=#ffa678	guibg=NONE	gui=NONE	ctermfg=184
hi String5	guifg=#df9678	guibg=NONE	gui=NONE	ctermfg=184
hi Statement1	guifg=indianred	guibg=NONE	gui=NONE
hi Statement2	guifg=#878787	guibg=NONE	gui=NONE	ctermfg=102	ctermbg=NONE	cterm=NONE
hi Identifier1	guifg=#87afaf	guibg=NONE	gui=NONE	ctermfg=109	ctermbg=NONE	cterm=NONE
hi Type1		guifg=#ffad68	gui=NONE	ctermfg=202
hi Type2		guifg=#fdbd89	gui=NONE	ctermfg=184
hi Type3		guifg=#adb110	gui=NONE	ctermfg=184
hi Type4		guifg=#ff5d28	gui=NONE	ctermfg=184
hi Type5		guifg=#ffa678	gui=NONE	ctermfg=184
hi Type6		guifg=#bdbd89	gui=NONE	ctermfg=184
hi Type7		guifg=#bab889	gui=NONE	ctermfg=184
hi Type8		guifg=#beb589	gui=NONE	ctermfg=184
hi Type9		guifg=#cea589	gui=NONE	ctermfg=184
hi Type10		guifg=#d3ca94	gui=NONE	ctermfg=184
hi Type11		guifg=#f0c589	gui=NONE	ctermfg=184
hi Type12		guifg=#d8c589	gui=NONE	ctermfg=184
hi Type13		guifg=#cec589	gui=NONE	ctermfg=184
hi Type14		guifg=#af875f guibg=NONE gui=NONE ctermfg=137 ctermbg=NONE cterm=NONE
hi Type15		guifg=gold	gui=NONE	ctermfg=184
hi Number1	guifg=indianred
hi Number2	guifg=#ff5d28	gui=NONE	ctermfg=202
hi Number3	guifg=#8cf2a0	gui=NONE	ctermfg=159
hi Number4	guifg=#ede39e	gui=NONE	ctermfg=187
hi Number5	guifg=#acf0f2	gui=NONE	ctermfg=159
hi Number6	guifg=#fca08c	gui=NONE	ctermfg=159
hi Number7	guifg=#ff9678	gui=NONE	ctermfg=184
hi Number8	guifg=#ff8f6f	gui=NONE	ctermfg=184	" Vim
hi Number9	guifg=#ff9777	gui=NONE	ctermfg=184	" Vim
hi Number10	guifg=#f08060	gui=NONE	ctermfg=184	" Vim
hi Number11	guifg=#ff9797	gui=NONE	ctermfg=184	" C
hi Number12	guifg=NONE	gui=NONE	ctermfg=184	" C
hi Number13	guifg=NONE	gui=NONE	ctermfg=184	" C
hi Number14 guifg=#af5f00 guibg=NONE gui=NONE ctermfg=130 ctermbg=NONE cterm=NONE

if 1
  " COMMON COLORS AND SETTINGS
  hi PreProc0	guifg=#dfaf87 guibg=NONE gui=NONE ctermfg=180 ctermbg=NONE cterm=NONE
  hi Include0	guifg=#dfaf87 guibg=NONE gui=NONE ctermfg=180 ctermbg=NONE cterm=NONE
  hi Define0	guifg=#dfaf87 guibg=NONE gui=NONE ctermfg=180 ctermbg=NONE cterm=NONE
endif

hi PreProc1	guifg=#ede39e	gui=NONE	ctermfg=187
hi PreProc2	guifg=indianred
hi PreProc3	guifg=#ff5d28	gui=NONE	ctermfg=202
hi PreProc4	guifg=#bb99bb
hi PreProc5	guifg=#9999bb
hi Include6	guifg=#aaaaaa
hi Include7	guifg=#cccccc
hi Include8	guifg=#9999bb

hi PreProc10	guifg=#9999bb
hi Include10	guifg=#9999bb
hi Define10	guifg=#bbeeff
hi Define10	guifg=#bb9999
hi PreCondit10	guifg=#9999bb

"hi PreProc	guifg=#9999bb	guibg=NONE	gui=NONE
"hi Include	guifg=#9999bb	guibg=NONE	gui=NONE
"hi Define	guifg=#bbeeff	guibg=NONE	gui=NONE
"hi PreCondit	guifg=#9999bb	guibg=NONE	gui=NONE
"hi PreProc	guifg=#ffb787	guibg=NONE	gui=NONE	ctermfg=184
"hi PreProc	guifg=#bb9999
"hi PreProc	guifg=#cccccc
"hi PreProc	guifg=#efa787	guibg=NONE	gui=NONE	ctermfg=184
"
"hi PreProc	guifg=#9999bb
"hi PreProc	guifg=#bb99bb
"hi PreProc	guifg=#aaaaaa
"hi PreCondit guifg=#dfaf87 guibg=NONE gui=NONE ctermfg=180 ctermbg=NONE cterm=NONE

"hi link Macro Define

" {{{
hi PreProc777	guifg=#e06058	guibg=NONE	gui=NONE	ctermfg=202
hi PreCondit777	guifg=#9999bb	guibg=NONE	gui=NONE

hi String666	guifg=#f06860	gui=NONE	ctermfg=202
hi PreProc666	guifg=#bb9999	guibg=NONE	gui=NONE
hi Constant666	guifg=#f0bcf0	guibg=NONE	gui=NONE	ctermfg=184

hi PreProc555	guifg=#f06860	gui=NONE	ctermfg=202
"hi Constant	guifg=#acf0f2	guibg=NONE	gui=NONE	ctermfg=159
hi String51	guifg=#ffc8ff	guibg=NONE	gui=NONE	ctermfg=184
hi String52	guifg=#f0c0f0	guibg=NONE	gui=NONE	ctermfg=184
hi String53	guifg=#f0bcf0	guibg=NONE	gui=NONE	ctermfg=184
hi StringOO 	guifg=#df9678	gui=none	ctermfg=184
"hi String	guifg=#ff5d28	gui=NONE	ctermfg=202
"hi String	guifg=#ffad98	gui=NONE	ctermfg=202
"hi String	guifg=#ff8d78	gui=NONE	ctermfg=202
"hi String	guifg=#ff8d58	gui=NONE	ctermfg=202
"hi String	guifg=#ff6666	gui=NONE	ctermfg=202
"
" *Constant        定数
"  Character       文字定数: 'c', '\n'
"  Boolean         ブール値の定数: TRUE, false
"
"  Keyword         その他のキーワード
"
"hi Keyword	guifg=#cdd129	gui=NONE	ctermfg=184

hi Identifier2	guifg=NONE	guibg=NONE	gui=NONE	ctermfg=202

hi Type6	guifg=#bdbd89	gui=NONE	ctermfg=184

"hi String	guifg=#efa787	guibg=NONE	gui=NONE	ctermfg=184
"hi String	guifg=#ffa787	guibg=NONE	gui=NONE	ctermfg=184
"hi String	guifg=#ffb787	guibg=NONE	gui=NONE	ctermfg=184

"hi String	guifg=#efa787	guibg=NONE	gui=NONE	ctermfg=184

"hi Special	guifg=#acf0f2	gui=NONE	ctermfg=159

"hi Constant	guifg=#ff5d28	guibg=NONE	gui=NONE	ctermfg=202
"hi String	guifg=#acf0f2	gui=NONE	ctermfg=159
"hi Special	guifg=#efa787	guibg=NONE	gui=NONE	ctermfg=184
"
"hi String	guifg=#bb9999
"
"hi String	guifg=#bb9999
"hi Special	guifg=#efa787	guibg=NONE	gui=NONE	ctermfg=184
" }}}

if 0
  " COMMON COLORS AND SETTINGS
  highlight PreProc guifg=#dfaf87 guibg=NONE gui=NONE ctermfg=180 ctermbg=NONE cterm=NONE
  highlight Function guifg=#875f5f guibg=NONE gui=NONE ctermfg=95 ctermbg=NONE cterm=NONE
  highlight Constant guifg=#af8787 guibg=NONE gui=NONE ctermfg=138 ctermbg=NONE cterm=NONE
  highlight Label guifg=#878787 guibg=NONE gui=NONE ctermfg=102 ctermbg=NONE cterm=NONE
  highlight Special guifg=#af5f5f guibg=NONE gui=NONE ctermfg=131 ctermbg=NONE cterm=NONE
  highlight Operator guifg=#878787 guibg=NONE gui=NONE ctermfg=102 ctermbg=NONE cterm=NONE
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
  highlight Exception guifg=#878787 guibg=NONE gui=NONE ctermfg=102 ctermbg=NONE cterm=NONE
  highlight Character guifg=#af5f00 guibg=NONE gui=NONE ctermfg=130 ctermbg=NONE cterm=NONE
  highlight Boolean guifg=#af5f00 guibg=NONE gui=NONE ctermfg=130 ctermbg=NONE cterm=NONE
  highlight Float guifg=#af5f00 guibg=NONE gui=NONE ctermfg=130 ctermbg=NONE cterm=NONE
  highlight Include guifg=#dfaf87 guibg=NONE gui=NONE ctermfg=180 ctermbg=NONE cterm=NONE
  highlight Define guifg=#dfaf87 guibg=NONE gui=NONE ctermfg=180 ctermbg=NONE cterm=NONE
  highlight Repeat guifg=#87875f guibg=NONE gui=NONE ctermfg=101 ctermbg=NONE cterm=NONE
  highlight Conditional guifg=#87875f guibg=NONE gui=NONE ctermfg=101 ctermbg=NONE cterm=NONE
endif


"----------------------------------------------------------------------------------------
" Dark, Gold
let s:dark = exists('g:RimpaDark') && g:RimpaDark
let s:gold = exists('g:RimpaGold') && g:RimpaGold


"----------------------------------------------------------------------------------------
" Base
"
"   Normal
"   EndOfBuffer
"   NonText
"   SpecialKey
"   CursorLine
"   CursorColumn
"   Visual
"   VisualNOS
"   MatchParen
"   Terminal
"
if ! s:dark
  hi Normal		guifg=#f6f3f0	guibg=#292927	gui=NONE	ctermfg=254	ctermbg=235	" Rimpa Last
  hi EndOfBuffer	guifg=#808080	guibg=#383836	gui=NONE	ctermfg=242	ctermbg=237
  hi NonText		guifg=#c6c3c0	guibg=#585048	gui=NONE	ctermfg=254	ctermbg=235
  hi NonText		guifg=#808080	guibg=#383838	gui=none	ctermfg=242	ctermbg=237
  hi SpecialKey	        guifg=#857c75	guibg=NONE	gui=NONE
  hi CursorLine		guifg=NONE	guibg=NONE	gui=underline	ctermbg=NONE	cterm=underline
  hi CursorColumn	guifg=NONE	guibg=#1a1a1a	gui=NONE			ctermbg=236
  hi Visual		guifg=NONE	guibg=#545454	gui=NONE	ctermfg=186	ctermbg=238
  hi Terminal		guifg=#f6f3f0	guibg=#191917	gui=NONE	ctermfg=254	ctermbg=235
else
  hi Normal		guifg=#f6f3f0	guibg=#191917	gui=NONE	ctermfg=254	ctermbg=235
  hi EndOfBuffer	guifg=#a6a3a0	guibg=#292927	gui=NONE	ctermfg=254	ctermbg=235
  hi NonText	        guifg=#c6c3c0	guibg=#484038	gui=NONE	ctermfg=254	ctermbg=235
  hi SpecialKey	        guifg=#756c65	guibg=NONE	gui=NONE
  hi CursorLine		guifg=NONE	guibg=NONE	gui=underline	ctermbg=NONE	cterm=underline
  hi CursorColumn	guifg=NONE	guibg=black	gui=NONE			ctermbg=236
  hi Visual		guifg=NONE	guibg=#464544	gui=NONE	ctermfg=186	ctermbg=238
  hi Terminal		guifg=#f6f3f0	guibg=#292927	gui=NONE	ctermfg=254	ctermbg=235	" Rimpa Last
endif
hi VisualNOS		guifg=NONE	guibg=black	gui=NONE	ctermfg=186	ctermbg=238
hi MatchParen		guifg=#f6f3e8	guibg=#857b6f	gui=bold	ctermbg=59
"hi Terminal		guifg=NONE	guibg=NONE	gui=NONE


"----------------------------------------------------------------------------------------
" Line Number
"
"   LineNr
"   CursorLineNr
"   LineNrAbove
"   LineNrBelow
"
if ! s:dark
  hi LineNr	guifg=#6c6a5f	guibg=NONE	gui=NONE	ctermfg=239	ctermbg=232
else
  hi LineNr	guifg=#5c5a4f	guibg=NONE	gui=NONE	ctermfg=239	ctermbg=232
endif
if v:true
  hi CursorLineNr	guifg=#efd3b8	guibg=#7f1f1a	gui=NONE
else
  hi CursorLineNr	guifg=#f8f0e0	guibg=bg	gui=NONE	ctermfg=yellow	cterm=bold,underline
endif
"hi LineNrAbove	guifg=#ff6666	guibg=NONE	gui=NONE
hi LineNrAbove	guifg=#cf403d	guibg=NONE	gui=NONE
hi LineNrBelow	guifg=#85b0df	guibg=NONE	gui=NONE


"----------------------------------------------------------------------------------------
" Statusline, Tabline, VertSplit
"
"   StatusLine
"   StatusLineNC
"   StatusLineTerm
"   StatusLineTermNC
"
"   VertSplit
"
"   TabLine
"   TabLineSel
"   TabLineSep
"   TabLineFill
"
hi StatusLine		guifg=#efd3b8	guibg=#7f1f1a	gui=NONE	" Rimpaデフォルト 高コントラスト白字
"hi StatusLineNC	guifg=#5c5a4f	guibg=#300a03	gui=NONE
hi StatusLineNC		guibg=#efd3b8	guifg=#7f1f1a	gui=NONE
if ! s:dark
  "hi StatusLineNC	guifg=#6c6a5f	guibg=#101010	gui=NONE
  "hi StatusLineNC	guifg=#6c6a5f	guibg=#201810	gui=NONE
else
  "hi StatusLineNC	guifg=#8c8a7f	guibg=#484440	gui=NONE
endif
hi StatusLineTerm	guifg=#efd3b8	guibg=#d0330b	gui=NONE
hi StatusLineTermNC	guifg=#8f7368	guibg=#6d2006	gui=NONE

"hi VertSplit		guifg=#1a1a1a	guibg=#d0c589	gui=NONE	" guibgは色を錯覚するので#d0c589から補正
"hi VertSplit		guifg=#7f1f1a	guibg=#d0c589	gui=NONE	" guibgは色を錯覚するので#d0c589から補正
"hi VertSplit		guifg=#7f1f1a	guibg=black	gui=NONE
hi VertSplit		guifg=#d0c5a9	guibg=black	gui=NONE
"hi VertSplit		guifg=#282828	guibg=black	gui=NONE

" TODO
hi TabLine		guifg=#8c7b73	guibg=black	gui=NONE
hi TabLine		guifg=#eeddcc	guibg=black	gui=NONE
hi TabLine		guifg=#d0c5a9	guibg=black	gui=NONE
"hi TabLine						gui=underline

hi! link TabLineSel	StatusLine

hi TabLineSep		guifg=#d0c5a9	guibg=black	gui=NONE	" 錯覚のため、TabLineFillのfgから色を微調整。
"hi TabLineSep						gui=underline
"hi! link TabLineSep	TabLine

if s:gold
  hi TabLineFill	guifg=#d0c589	guibg=#d0c589	gui=NONE
else
  hi TabLineFill	guifg=black	guibg=black	gui=NONE
  hi! link TabLineFill SLFileName
endif

"----------------------------------------------------------------------------------------
" For Statusline and Tabline

hi! link TblDate	StatusLine
hi! link TblDiffOn	StlFill
hi! link TblDiffOff	StlNoNameDir

"hi stl_orange_char	guifg=#ff5d28	guibg=black	gui=NONE	ctermfg=202
"hi stl_yellow_char	guifg=#cdd129	guibg=black	gui=NONE	ctermfg=184
"hi stl_green_char	guifg=#85efb0	guibg=black	gui=NONE	ctermfg=184
hi stl_blue_char	guifg=#85b0df	guibg=black	gui=NONE	ctermfg=184

"hi stl_gold_back_red	guifg=#7f1f1a	guibg=#d0c589	gui=NONE	" guibgは色を錯覚するので#d0c589から補正
"hi stl_gold_back_black	guifg=#1a1a1a	guibg=#d0c589	gui=NONE
hi StlGold		guifg=#7f1f1a	guibg=#d0c589	gui=NONE	" guibgは色を錯覚するので#d0c589から補正

hi! link StlGoldChar	TabLine

"hi StlFill		guifg=#cf302d	guibg=#170a00	gui=NONE
"hi StlFill		guifg=#cf302d	guibg=#000000	gui=NONE
"hi StlFill		guifg=#df2103	guibg=#000000	gui=NONE
hi StlFill		guifg=#ef4123	guibg=#000000	gui=NONE

"hi! link StlFileName	StlFill
hi StlNoNameDir		guifg=#5c5a4f	guibg=#000000	gui=NONE
hi! link StlFuncName	stl_blue_char

"TODO {{{
hi! link TabLineDate	StatusLine
hi! link SLNoNameDir		StlNoNameDir
hi! link VertSplit2		StlGold
hi! link hl_func_name_stl	StlFuncName
hi! link SLFileName		StlFill

if 0
  %s/\<#TabLineDate#\>/#TblDate#/g
  %s/\<#SLNoNameDir#/#StlNoNameDir#/g
  %s/\<#VertSplit2#/#StlGold#/g
  %s/\<#hl_func_name_stl#/#StlFuncName#/g
  %s/\<#SLFileName#/#StlFill#/g

  TabLineDiffOn
  TabLineDiffOff

  "%s/\<#TabLine#\>/#StlGoldChar#/g
  "%s/\<#TabLineSep#\>/#StlGoldChar#/g
endif
" }}}


"----------------------------------------------------------------------------------------
" Message, Question
"   MsgArea
"   ModeMsg
"   Title
"   MoreMsg
"   Question    補完中にも使われる。(候補を探しているファイル名)
"   WarningMsg  補完中にも使われる。(可能なアクション候補？di)
"   ErrorMsg
"   MessageWindow
"   PopupNotification
"
hi MsgArea		guifg=black	guibg=orange	gui=NONE        " FIXME
hi ModeMsg		guifg=#cc4444	guibg=NONE	gui=NONE
hi Title		guifg=#dfaf87	guibg=NONE	gui=NONE	ctermfg=180	ctermbg=NONE	cterm=NONE
hi MoreMsg		guifg=SeaGreen	guibg=NONE	gui=bold	term=bold	ctermfg=10
hi Question		guifg=#666666
hi WarningMsg		guifg=#44cc44	guibg=NONE	gui=NONE
"hi ErrorMsg		guifg=#fff129	guibg=NONE	gui=NONE
"hi ErrorMsg		guifg=#ffaacc	guibg=NONE	gui=NONE
"hi ErrorMsg		guifg=black	guibg=#ffd129
hi ErrorMsg		term=standout ctermfg=15 ctermbg=4 guifg=White guibg=Red
hi PopupNotification	guifg=#cc4444	guibg=black	gui=NONE
hi MessageWindow	guifg=#cc4444	guibg=black	gui=NONE


"----------------------------------------------------------------------------------------
" Diff
"
"   DiffAdd
"   DiffChange
"   DiffDelete
"   DiffText
"
hi DiffAdd		guifg=NONE	guibg=#200a0a	gui=NONE	term=bold	ctermbg=1
hi DiffDelete		guifg=#101010	guibg=#111130	gui=NONE	term=bold	ctermbg=1
if ! s:dark
  hi DiffChange		guifg=NONE	guibg=#101010	gui=NONE	term=NONE	ctermbg=NONE
else
  hi DiffChange		guifg=NONE	guibg=#000000	gui=NONE	term=NONE	ctermbg=NONE
endif
hi DiffText		guifg=NONE	guibg=#701008	gui=NONE	term=reverse	ctermbg=12	cterm=bold


"----------------------------------------------------------------------------------------
" Completion Popup
"
"   Pmenu
"   PmenuSel
"   PmenuMatch
"   PmenuMatchSel
"   PmenuExtra
"   PmenuExtraSel
"   PmenuKind
"   PmenuKindSel
"   PmenuSbar
"   PmenuThumb
"
hi Pmenu		guifg=#dcda8f	guibg=#121002	ctermfg=239	ctermbg=232
if 0
  hi PmenuSel		guifg=black	guibg=#ccc08c	gui=NONE	ctermfg=0	ctermbg=184
else
  hi PmenuSel		guifg=NONE	guibg=#802010	gui=NONE	term=reverse	ctermbg=12	cterm=bold	" 赤漆
  "hi PmenuSel		guifg=white
  "hi PmenuSel		guifg=#d0c589
endif
hi PmenuMatch		guifg=#c0504d	guibg=#000000	gui=NONE        " FIXME
hi PmenuMatchSel	guifg=#000000	guibg=#c0504d	gui=NONE        " FIXME
"hi PmenuExtra		guifg=#c0504d	guibg=#000000	gui=NONE
"hi PmenuExtra		guifg=#d8c08c	guibg=#121002	gui=NONE	ctermfg=239	ctermbg=232
"hi PmenuExtra		guifg=#85b0df	guibg=black	gui=NONE
"hi PmenuExtra		guifg=#857c75	guibg=#121002	gui=NONE
hi PmenuExtra		guifg=#5c5a4f	guibg=#121002	gui=NONE
"hi PmenuExtraSel	guifg=#000000	guibg=#c0504d	gui=NONE
"hi PmenuExtraSel	guifg=#5c5a4f	guibg=#000000	gui=NONE
"hi! link PmenuExtraSel	PmenuSel
hi PmenuExtraSel	guibg=#5c5a4f	guifg=#121002	gui=NONE
hi PmenuKind		guifg=#85b0df	guibg=black	gui=NONE
hi PmenuKindSel		guifg=black	guibg=#85b0df	gui=NONE
hi PmenuSbar		guifg=#ffffff	guibg=black	gui=NONE	ctermfg=0	ctermbg=184
hi PmenuThumb		guifg=#000000	guibg=#c0504d	gui=NONE	ctermfg=0	ctermbg=184


"----------------------------------------------------------------------------------------
" Spell Check
"
"   SpellBad
"   SpellCap
"   SpellLocal
"   SpellRare
"
hi SpellBad		guifg=NONE	guibg=NONE	gui=undercurl	guisp=Red	term=reverse	ctermbg=12
hi SpellCap		guifg=NONE	guibg=NONE	gui=undercurl	guisp=Blue	term=reverse	ctermbg=9
hi SpellRare 		guifg=NONE	guibg=NONE	gui=undercurl	guisp=Magenta	term=reverse	ctermbg=13
hi SpellLocal		guifg=NONE	guibg=NONE	gui=undercurl	guisp=Cyan	term=underline	ctermbg=11


"----------------------------------------------------------------------------------------
" Directory
"
hi Directory		guifg=#ff6666	guibg=NONE


"----------------------------------------------------------------------------------------
" Fold, Sign
"
"   Folded
"   FoldColumn
"   CursorLineFold
"
"   SignColumn
"   CursorLineSign
"
hi Folded		guifg=#c0c0c0	guibg=#202020	gui=NONE
hi FoldColumn		guifg=#7f1f1a	guibg=#eeddaa	gui=NONE
hi CursorLineFold	guifg=#7f1f1a	guibg=#bb3333	gui=NONE
"hi! link CursorLineFold	FoldColumn

hi SignColumn		guifg=#ff5d28	guibg=#605c58	gui=NONE
hi CursorLineSign	guifg=#7f1f1a	guibg=#bb3333	gui=NONE
"hi! link CursorLineSign	SignColumn


"----------------------------------------------------------------------------------------
" Search, Quickfix
"
"   QuickFixLine
"   IncSearch
"   Search
"   CurSearch
"
hi Search		guifg=white	guibg=#b7282e	gui=NONE
hi CurSearch		guifg=#b7282e	guibg=white	gui=NONE
hi IncSearch		guifg=white	guibg=blue	gui=NONE
hi QuickFixLine		guifg=NONE	guibg=#603a36	gui=NONE


"----------------------------------------------------------------------------------------
" Other
"   ColorColumn
"   Conceal
"   WildMenu
"   PopupNotification
"
hi ColorColumn		guifg=NONE	guibg=#880000	gui=NONE
hi Conceal		guifg=LightGrey	guibg=DarkGrey	gui=NONE
hi WildMenu		guifg=#85b0df	guibg=#080808	gui=NONE	ctermfg=184


"----------------------------------------------------------------------------------------
" GUI Cursor
"   Cursor
"   CursorIM
"   lCursor
"
hi Cursor		guifg=indianred	guibg=black	gui=reverse	ctermbg=0x241
hi CursorIM		guifg=yellow	guibg=yellow

set guicursor=n-v-c:ver20-blinkwait1000-blinkon600-blinkoff400-Cursor/lCursor,ve:ver35-Cursor,o:hor50-Cursor,i-ci:hor30-Cursor/lCursor,r-cr:Block-Cursor/lCursor


"----------------------------------------------------------------------------------------
" GUI
"
"  Scrollbar
"  Menu
"  Tooltip
"


"----------------------------------------------------------------------------------------
" Syntax Highlighting
"
"   *Comment         コメント
"
"   *Constant        定数
"    String          文字列定数: "これは文字列です"
"    Character       文字定数: 'c', '\n'
"    Number          数値定数: 234, 0xff
"    Boolean         ブール値の定数: TRUE, false
"    Float           浮動小数点数の定数: 2.3e10
"
"   *Identifier      変数名
"    Function        関数名(クラスメソッドを含む)
"
"   *Statement       命令文
"    Conditional     if, then, else, endif, switch, その他
"    Repeat          for, do, while, その他
"    Label           case, default, その他
"    Operator        "sizeof", "+", "*", その他
"    Keyword         その他のキーワード
"    Exception       try, catch, throw
"
"   *PreProc         一般的なプリプロセッサー命令
"    Include         #include プリプロセッサー
"    Define          #define プリプロセッサー
"    Macro           Defineと同値
"    PreCondit       プリプロセッサーの #if, #else, #endif, その他
"
"   *Type            int, long, char, その他
"    StorageClass    static, register, volatile, その他
"    Structure       struct, union, enum, その他
"    Typedef         typedef宣言
"
"   *Special         特殊なシンボル
"    SpecialChar     特殊な文字定数
"    Tag             この上で CTRL-] を使うことができる
"    Delimiter       注意が必要な文字
"    SpecialComment  コメント内の特記事項
"    Debug           デバッグ命令
"
"   *Underlined      目立つ文章, HTMLリンク
"
"   *Ignore          (見た目上)空白, 不可視  |hl-Ignore|
"
"   *Error           エラーなど、なんらかの誤った構造
"
"   *Todo            特別な注意が必要なもの; 大抵はTODO FIXME XXXなどのキーワード
"
"   *Added           差分内の追加行
"   *Changed         差分内の変更行
"   *Removed         差分内の削除行
"
hi Comment		guifg=#848280	guibg=NONE	gui=NONE	ctermfg=244	| " gui=italic
hi Constant		guifg=#df9678	guibg=NONE	gui=NONE	ctermfg=184
hi String		guifg=#bb9999	guibg=NONE	gui=NONE
hi Character		guifg=#99bb99	guibg=NONE	gui=NONE
hi Number		guifg=#e5e2d0	guibg=NONE	gui=NONE	ctermfg=184
hi Boolean		guifg=#acf0f2	guibg=NONE	gui=NONE	ctermfg=159
hi! link Float		Number
hi Identifier		guifg=NONE	guibg=NONE	gui=NONE	" FIXME
hi Function		guifg=#cdd129	guibg=NONE	gui=NONE	ctermfg=184
hi Statement		guifg=#af5f5f	guibg=NONE	gui=NONE	ctermfg=131
hi Keyword		guifg=#b7ef97	guibg=NONE	gui=NONE	ctermfg=184
hi PreProc		guifg=#d85850	guibg=NONE	gui=NONE	ctermfg=202
hi PreCondit		guifg=#f0bcf0	guibg=NONE	gui=NONE	ctermfg=184
hi Type			guifg=#d0c589	guibg=NONE	gui=NONE	ctermfg=184
hi Special		guifg=#bb9999
hi SpecialSp		guifg=#ff5d28	guibg=NONE	gui=NONE	ctermfg=202
hi! link SpecialChar	SpecialSp
hi! link Tag		SpecialSp
hi! link Delimiter	Special     " VimScriptでは、丸括弧もDelimiterとしてハイライトされる。
hi! link SpecialComment	SpecialSp
hi! link Debug		SpecialSp
hi Underlined		guifg=#80a0ff	guibg=NONE	gui=underline	cterm=underline	cterm=underline	ctermfg=9
hi Ignore		guifg=bg	guibg=NONE	gui=NONE	ctermfg=0	" FIXME
hi Ignore		guifg=red	guibg=NONE	gui=NONE	ctermfg=0	" FIXME
hi Error		guifg=White	guibg=Red	gui=NONE	term=reverse ctermfg=15 ctermbg=12
hi Todo			guifg=#8f8f8f	guibg=Yellow	gui=italic	term=standout	ctermfg=245	ctermbg=14
hi Added		guifg=white	guibg=red	gui=NONE        " FIXME
hi Changed		guifg=black	guibg=green	gui=NONE        " FIXME
hi Removed		guifg=white	guibg=blue	gui=NONE        " FIXME


"----------------------------------------------------------------------------------------
" Plugins
"
" TODO
"
" PopUpInfo
hi MyMru		guifg=#e94040


"----------------------------------------------------------------------------------------
" モード変更時に色を変える
"
let s:CursorLineNrOrg = hlget('CursorLineNr')
augroup ColorChangeAtMode
  au!
  au InsertEnter *           hi CursorLineNr	guifg=#efd3b8	guibg=#d0330b	gui=NONE	ctermfg=Blue	cterm=bold,underline
 "au ModeChanged *:[vV\x16]* hi CursorLineNr	guifg=#b8d3ef	guibg=#4444ee	gui=NONE	ctermfg=Blue	cterm=bold,underline
  au ModeChanged *:[vV\x16]* hi CursorLineNr	guibg=#d0c589	guifg=#222222	gui=NONE	ctermfg=Blue	cterm=bold,underline
 "au CmdlineEnter *          hi CursorLineNr	guibg=#d0c589	guifg=#222222	gui=NONE	ctermfg=Blue	cterm=bold,underline | redraw
  au ModeChanged *:n* call hlset(s:CursorLineNrOrg)
 "au InsertLeave * call hlset(s:CursorLineNrOrg)
augroup END


finish


" {{{
"" Base
Normal
EndOfBuffer
NonText
SpecialKey
Visual
VisualNOS
MatchParen
Terminal

""" Line Number
LineNr
LineNrAbove
LineNrBelow
CursorLineNr

" Statusline, Tabline, VertSplit
StatusLine
StatusLineNC
StatusLineTerm
StatusLineTermNC
TabLine
TabLineFill
TabLineSel
VertSplit

" Message, Question
MsgArea
MoreMsg
ModeMsg
Title
Question
WarningMsg
ErrorMsg
MessageWindow
PopupNotification

"" Diff
DiffAdd
DiffChange
DiffDelete
DiffText

" Completion Menu, Wild Menu
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

" Spell Check
SpellBad
SpellCap
SpellLocal
SpellRare

" Directory
Directory

" Fold, Sign
Folded
FoldColumn
CursorLineFold
SignColumn
CursorLineSign

" Search, Quickfix
QuickFixLine
IncSearch
Search
CurSearch

" Other
ColorColumn
Conceal
WildMenu

" GI Cursor
Cursor
CursorIM
lCursor
CursorLine
CursorColumn

" GUI
Scrollbar
Menu
Tooltip

" Syntax Highlighting
*Comment         コメント

*Constant        定数
 String          文字列定数: "これは文字列です"
 Character       文字定数: 'c', '\n'
 Number          数値定数: 234, 0xff
 Boolean         ブール値の定数: TRUE, false
 Float           浮動小数点数の定数: 2.3e10

*Identifier      変数名
 Function        関数名(クラスメソッドを含む)

*Statement       命令文
 Conditional     if, then, else, endif, switch, その他
 Repeat          for, do, while, その他
 Label           case, default, その他
 Operator        "sizeof", "+", "*", その他
 Keyword         その他のキーワード
 Exception       try, catch, throw

*PreProc         一般的なプリプロセッサー命令
 Include         #include プリプロセッサー
 Define          #define プリプロセッサー
 Macro           Defineと同値
 PreCondit       プリプロセッサーの #if, #else, #endif, その他

*Type            int, long, char, その他
 StorageClass    static, register, volatile, その他
 Structure       struct, union, enum, その他
 Typedef         typedef宣言

*Special         特殊なシンボル
 SpecialChar     特殊な文字定数
 Tag             この上で CTRL-] を使うことができる
 Delimiter       注意が必要な文字
 SpecialComment  コメント内の特記事項
 Debug           デバッグ命令

*Underlined      目立つ文章, HTMLリンク

*Ignore          (見た目上)空白, 不可視  |hl-Ignore|

*Error           エラーなど、なんらかの誤った構造

*Todo            特別な注意が必要なもの; 大抵はTODO FIXME XXXなどのキーワード

*Added           差分内の追加行
*Changed         差分内の変更行
*Removed         差分内の削除行
" }}}


" ====================================================================================================

" PopUpInfo

" Mode Change
" Gold
" Dark

" My favarite color  : #c0504d

" General colors

" For Completion Menu

" Anzu PopWin

" 琳派
" Thinkpad
" Modern Red (Windows XP Zune)
" Zplus
" (Star Saver)
" (Comboy)

" kinaka 金赤	#EF4123	#ef4123

" ☆ ☆ ☆ 赤っぽい橙 #FF3300

" 薄緑 hi TabLineFill		guifg=#00c589	guibg=#d0c589com! KKK call s:SetStatusLineColor('CmdLine')

" #D13438
" #FF4141
" #F94C40
" #963634
" #EF3E0E
" #BFED9B 薄緑 Statusline へのアクセントに
" #963634 少し薄い漆赤
" ====================================================================================================
