scriptencoding utf-8
" vim:set ts=8 sts=8 sw=2 tw=0: (この行に関しては:help modelineを参照)

set background=dark
hi clear

if exists("syntax_on")
  syntax reset
endif

let colors_name = "Rimpa"


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
hi LineNrAbove	guifg=#85b0df	guibg=NONE	gui=NONE
hi LineNrBelow	guifg=#cf403d	guibg=NONE	gui=NONE


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

"hi TabLine		guifg=#8c7b73	guibg=black	gui=NONE
"hi TabLine		guifg=#eeddcc	guibg=black	gui=NONE
hi TabLine		guifg=#d0c5a9	guibg=black	gui=NONE
"hi TabLine						gui=underline

hi! link TabLineSel	StatusLine

"hi TabLineSep		guifg=#d0c5a9	guibg=black	gui=NONE	" 錯覚のため、TabLineFillのfgから色を微調整。
"hi TabLineSep						gui=underline
hi! link TabLineSep	TabLine

if s:gold
  hi TabLineFill	guifg=#d0c589	guibg=#d0c589	gui=NONE
else
  "hi TabLineFill	guifg=black	guibg=black	gui=NONE
  hi! link TabLineFill	StlFill
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
hi StlGoldLeaf		guifg=#7f1f1a	guibg=#d0c589	gui=NONE	" guibgは色を錯覚するので#d0c589から補正

hi! link StlGoldChar	TabLine

"hi StlFill		guifg=#cf302d	guibg=#170a00	gui=NONE
hi StlFill		guifg=#cf302d	guibg=#000000	gui=NONE
"hi StlFill		guifg=#df2103	guibg=#000000	gui=NONE
"hi StlFill		guifg=#ef4123	guibg=#000000	gui=NONE

"hi! link StlFileName	StlFill
hi StlNoNameDir		guifg=#5c5a4f	guibg=#000000	gui=NONE
hi! link StlFuncName	stl_blue_char


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
if s:gold
  hi ErrorMsg		guifg=White	guibg=Red	gui=NONE	term=standout	ctermfg=15	ctermbg=4
else
  hi ErrorMsg		guifg=black	guibg=#ffd129	gui=NONE
endif
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
"hi DiffText		guifg=NONE	guibg=#701008	gui=NONE	term=reverse	ctermbg=12	cterm=bold
hi DiffText		guifg=NONE	guibg=#701058	gui=NONE	term=reverse	ctermbg=12	cterm=bold


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
" TODO
"hi QuickFixLine	guifg=NONE	guibg=#600a06	gui=NONE
"hi CurSearch		guifg=White	guibg=#600a06	gui=NONE


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
" FIXME
"hi Boolean		guifg=#bb9999	guibg=NONE	gui=NONE
"hi String		guifg=#acf0f2	guibg=NONE	gui=NONE	ctermfg=159


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


"----------------------------------------------------------------------------------------
"   " {{{
"   "" Base
"   Normal
"   EndOfBuffer
"   NonText
"   SpecialKey
"   Visual
"   VisualNOS
"   MatchParen
"   Terminal
"
"   """ Line Number
"   LineNr
"   LineNrAbove
"   LineNrBelow
"   CursorLineNr
"
"   " Statusline, Tabline, VertSplit
"   StatusLine
"   StatusLineNC
"   StatusLineTerm
"   StatusLineTermNC
"   TabLine
"   TabLineFill
"   TabLineSel
"   VertSplit
"
"   " Message, Question
"   MsgArea
"   MoreMsg
"   ModeMsg
"   Title
"   Question
"   WarningMsg
"   ErrorMsg
"   MessageWindow
"   PopupNotification
"
"   "" Diff
"   DiffAdd
"   DiffChange
"   DiffDelete
"   DiffText
"
"   " Completion Menu, Wild Menu
"   Pmenu
"   PmenuSel
"   PmenuKind
"   PmenuKindSel
"   PmenuExtra
"   PmenuExtraSel
"   PmenuSbar
"   PmenuThumb
"   PmenuMatch
"   PmenuMatchSel
"
"   " Spell Check
"   SpellBad
"   SpellCap
"   SpellLocal
"   SpellRare
"
"   " Directory
"   Directory
"
"   " Fold, Sign
"   Folded
"   FoldColumn
"   CursorLineFold
"   SignColumn
"   CursorLineSign
"
"   " Search, Quickfix
"   QuickFixLine
"   IncSearch
"   Search
"   CurSearch
"
"   " Other
"   ColorColumn
"   Conceal
"   WildMenu
"
"   " GI Cursor
"   Cursor
"   CursorIM
"   lCursor
"   CursorLine
"   CursorColumn
"
"   " GUI
"   Scrollbar
"   Menu
"   Tooltip
"
"   " Syntax Highlighting
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
"   " }}}
