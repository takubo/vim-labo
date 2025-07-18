scriptencoding utf-8
" vim:set ts=8 sts=8 sw=2 tw=0 noet: (この行に関しては:help modelineを参照)

set background=dark
hi clear

if exists("syntax_on")
  syntax reset
endif

let colors_name = "rimpa"


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
  hi Normal		guifg=#f6f3f0	guibg=#292927	gui=NONE	cterm=NONE	" Rimpa Last
  hi EndOfBuffer	guifg=#808080	guibg=#383836	gui=NONE	cterm=NONE
  hi NonText		guifg=#c6c3c0	guibg=#585048	gui=NONE	cterm=NONE
  hi NonText		guifg=#808080	guibg=#383838	gui=NONE	cterm=NONE
  hi SpecialKey	        guifg=#857c75	guibg=NONE	gui=NONE	cterm=NONE
  hi CursorLine		guifg=NONE	guibg=NONE	gui=underline	cterm=underline
  hi CursorColumn	guifg=NONE	guibg=#1a1a1a	gui=NONE	cterm=NONE
  hi Visual		guifg=NONE	guibg=#545454	gui=NONE	cterm=NONE
  hi Terminal		guifg=#f6f3f0	guibg=#191917	gui=NONE	cterm=NONE
else
  hi Normal		guifg=#f6f3f0	guibg=#191917	gui=NONE	cterm=NONE
  hi EndOfBuffer	guifg=#a6a3a0	guibg=#292927	gui=NONE	cterm=NONE
  hi NonText		guifg=#c6c3c0	guibg=#484038	gui=NONE	cterm=NONE
  hi SpecialKey	        guifg=#756c65	guibg=NONE	gui=NONE	cterm=NONE
  hi CursorLine		guifg=NONE	guibg=NONE	gui=underline	cterm=underline
  hi CursorColumn	guifg=NONE	guibg=black	gui=NONE	cterm=NONE
  hi Visual		guifg=NONE	guibg=#464544	gui=NONE	cterm=NONE
  hi Terminal		guifg=#f6f3f0	guibg=#292927	gui=NONE	cterm=NONE	" Rimpa Last
endif
hi VisualNOS		guifg=NONE	guibg=black	gui=NONE	cterm=NONE
hi MatchParen		guifg=#f6f3e8	guibg=#857b6f	gui=bold	cterm=bold
"hi Terminal		guifg=NONE	guibg=NONE	gui=NONE	cterm=NONE


"----------------------------------------------------------------------------------------
" Line Number
"
"   LineNr
"   CursorLineNr
"   LineNrAbove
"   LineNrBelow
"
if ! s:dark
  hi LineNr		guifg=#6c6a5f	guibg=white	gui=NONE	cterm=NONE
else
  hi LineNr		guifg=#5c5a4f	guibg=#efd3b8	gui=NONE	cterm=NONE
endif

if ! s:dark
  hi LineNr	guifg=#6c6a5f	guibg=NONE	gui=NONE	ctermfg=239	ctermbg=232
  hi LineNr		guifg=#6c6a5f	guibg=NONE	gui=NONE	cterm=NONE
else
  hi LineNr	guifg=#5c5a4f	guibg=NONE	gui=NONE	ctermfg=239	ctermbg=232
  hi LineNr		guifg=#5c5a4f	guibg=NONE	gui=NONE	cterm=NONE
endif
"hi LineNr		guifg=#6c6a5f	guibg=white	gui=NONE	cterm=NONE

if v:true
  hi CursorLineNr	guifg=#efd3b8	guibg=#7f1f1a	gui=NONE	cterm=NONE
else
  hi CursorLineNr	guifg=#f8f0e0	guibg=bg	gui=NONE	cterm=NONE
endif
if 0
 "hi LineNrAbove	guifg=#ff6666	guibg=NONE	gui=NONE	cterm=NONE
  hi LineNrAbove	guifg=#85b0df	guibg=NONE	gui=NONE	cterm=NONE
  hi LineNrBelow	guifg=#cf403d	guibg=NONE	gui=NONE	cterm=NONE
else
  hi LineNrAbove	guifg=#cf403d	guibg=NONE	gui=NONE	cterm=NONE
  hi LineNrBelow	guifg=#d0c5a9	guibg=NONE	gui=NONE	cterm=NONE
endif


"----------------------------------------------------------------------------------------
" Statusline, VertSplit, Tabline, TabPanel
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
"   TabPanel
"   TabPanelSel
"   TabPanelFill
"
hi StatusLine		guifg=#efd3b8	guibg=#7f1f1a	gui=NONE	cterm=NONE	" Rimpaデフォルト 高コントラスト白字
"hi StatusLineNC	guifg=#5c5a4f	guibg=#300a03	gui=NONE	cterm=NONE
hi StatusLineNC		guifg=#7f1f1a	guibg=#efd3b8	gui=NONE	cterm=NONE
if ! s:dark
  "hi StatusLineNC	guifg=#6c6a5f	guibg=#101010	gui=NONE	cterm=NONE
  "hi StatusLineNC	guifg=#6c6a5f	guibg=#201810	gui=NONE	cterm=NONE
else
  "hi StatusLineNC	guifg=#8c8a7f	guibg=#484440	gui=NONE	cterm=NONE
endif
hi StatusLineTerm	guifg=#efd3b8	guibg=#d0330b	gui=NONE	cterm=NONE
hi StatusLineTermNC	guifg=#8f7368	guibg=#6d2006	gui=NONE	cterm=NONE

"hi VertSplit		guifg=#1a1a1a	guibg=#d0c589	gui=NONE	cterm=NONE	" guibgは色を錯覚するので#d0c589から補正
"hi VertSplit		guifg=#7f1f1a	guibg=#d0c589	gui=NONE	cterm=NONE	" guibgは色を錯覚するので#d0c589から補正
"hi VertSplit		guifg=#7f1f1a	guibg=black	gui=NONE	cterm=NONE
hi VertSplit		guifg=#d0c5a9	guibg=black	gui=NONE	cterm=NONE
"hi VertSplit		guifg=#282828	guibg=black	gui=NONE	cterm=NONE

"hi TabLine		guifg=#8c7b73	guibg=black	gui=NONE	cterm=NONE
"hi TabLine		guifg=#eeddcc	guibg=black	gui=NONE	cterm=NONE
hi TabLine		guifg=#d0c5a9	guibg=black	gui=NONE	cterm=NONE
"hi TabLine						gui=underline	cterm=underline

hi! link TabLineSel	StatusLine

"hi TabLineSep		guifg=#d0c5a9	guibg=black	gui=NONE	cterm=NONE	" 錯覚のため、TabLineFillのfgから色を微調整。
"hi TabLineSep						gui=underline	cterm=underline
hi! link TabLineSep	TabLine

if s:gold
  hi TabLineFill	guifg=#d0c589	guibg=#d0c589	gui=NONE	cterm=NONE
else
  "hi TabLineFill	guifg=black	guibg=black	gui=NONE	cterm=NONE
  hi! link TabLineFill	StlFill
endif

"hi TabPanel		guifg=#d0c5a9	guibg=black	gui=NONE	cterm=NONE
hi TabPanel		guifg=#cccccc	guibg=black	gui=NONE	cterm=NONE
hi TabPanelFill		guifg=black	guibg=black	gui=NONE	cterm=NONE
hi! link TabPanelSel	TabPanelFill


"----------------------------------------------------------------------------------------
" For Statusline, Tabline, and TabPanel

hi! link TblDate	StatusLine
hi! link TblDiffOn	StlFill
hi! link TblDiffOff	StlNoNameDir

"hi stl_orange_char	guifg=#ff5d28	guibg=black	gui=NONE	cterm=NONE
"hi stl_yellow_char	guifg=#cdd129	guibg=black	gui=NONE	cterm=NONE
"hi stl_green_char	guifg=#85efb0	guibg=black	gui=NONE	cterm=NONE
hi stl_blue_char	guifg=#85b0df	guibg=black	gui=NONE	cterm=NONE

"hi stl_gold_back_red	guifg=#7f1f1a	guibg=#d0c589	gui=NONE	cterm=NONE	" guibgは色を錯覚するので#d0c589から補正
"hi stl_gold_back_black	guifg=#1a1a1a	guibg=#d0c589	gui=NONE	cterm=NONE
hi StlGoldLeaf		guifg=#7f1f1a	guibg=#d0c589	gui=NONE	cterm=NONE	" guibgは色を錯覚するので#d0c589から補正

hi! link StlGoldChar	TabLine

"hi StlFill		guifg=#cf302d	guibg=#170a00	gui=NONE	cterm=NONE
hi StlFill		guifg=#cf302d	guibg=#000000	gui=NONE	cterm=NONE
"hi StlFill		guifg=#df2103	guibg=#000000	gui=NONE	cterm=NONE
"hi StlFill		guifg=#ef4123	guibg=#000000	gui=NONE	cterm=NONE

"hi! link StlFileName	StlFill
hi StlNoNameDir		guifg=#5c5a4f	guibg=#000000	gui=NONE	cterm=NONE
hi! link StlFuncName	stl_blue_char

hi! link TabPanelWinInfo	TabPanel
hi TabPanelWinInfo	guifg=#d0c5a9	guibg=black	gui=NONE	cterm=NONE
hi TabPanelBufName	guifg=#cccccc	guibg=black	gui=NONE	cterm=NONE
hi! link TabPanelBufName	TabPanel

if 0
  hi! link TabPanelMySel	TblDate
  hi TabPanelMySel	guifg=#cccccc	guibg=#7f1f1a	gui=NONE	cterm=NONE		" TblDate
  hi TabPanelWinInfoSel	guifg=#d0c5a9	guibg=#7f1f1a	gui=NONE	cterm=NONE		" TblDate
else
  hi! link TabPanelMySel	QuickFixLine
  hi TabPanelMySel	guifg=#cccccc	guibg=#603a36	gui=NONE	cterm=NONE		" QuickFixLine
  hi TabPanelWinInfoSel	guifg=#d0c5a9	guibg=#603a36	gui=NONE	cterm=NONE		" QuickFixLine
endif

hi! link TabPanelTabnr	StlFill
hi! link TabPanelTabnr	TblDate
hi! link TabPanelTabnr	PopupNotification

hi! link TblDiffRedOn	TblDate
hi TblDiffRedOff	guifg=#7f6358	guibg=#7f1f1a	gui=NONE	cterm=NONE

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
" hi MsgArea		guifg=black	guibg=orange	gui=NONE	cterm=NONE	" TODO
hi ModeMsg		guifg=#cc4444	guibg=NONE	gui=NONE	cterm=NONE
hi Title		guifg=#dfaf87	guibg=NONE	gui=NONE	cterm=NONE
hi MoreMsg		guifg=SeaGreen	guibg=NONE	gui=bold	cterm=bold
hi Question		guifg=#666666
hi WarningMsg		guifg=#44cc44	guibg=NONE	gui=NONE	cterm=NONE
"hi ErrorMsg		guifg=#fff129	guibg=NONE	gui=NONE	cterm=NONE
"hi ErrorMsg		guifg=#ffaacc	guibg=NONE	gui=NONE	cterm=NONE
if s:gold
  hi ErrorMsg		guifg=White	guibg=Red	gui=NONE	cterm=NONE
else
  hi ErrorMsg		guifg=black	guibg=#ffd129	gui=NONE	cterm=NONE
endif
hi PopupNotification	guifg=#cc4444	guibg=black	gui=NONE	cterm=NONE
hi MessageWindow	guifg=#cc4444	guibg=black	gui=NONE	cterm=NONE


"----------------------------------------------------------------------------------------
" Diff
"
"   DiffAdd
"   DiffChange
"   DiffDelete
"   DiffText
"
hi DiffAdd		guifg=NONE	guibg=#200a0a	gui=NONE	cterm=NONE
hi DiffDelete		guifg=#101010	guibg=#111130	gui=NONE	cterm=NONE
if ! s:dark
  hi DiffChange		guifg=NONE	guibg=#101010	gui=NONE	cterm=NONE
else
  hi DiffChange		guifg=NONE	guibg=#000000	gui=NONE	cterm=NONE
endif
"hi DiffText		guifg=NONE	guibg=#701008	gui=NONE	cterm=NONE
hi DiffText		guifg=NONE	guibg=#701058	gui=NONE	cterm=NONE


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
if 0
  hi Pmenu		guifg=#dcda8f	guibg=#121002
  hi PmenuSel		guifg=#f6f3f0	guibg=#802010	gui=NONE	cterm=NONE	" 赤漆
  hi! link PmenuMatch Pmenu
  hi! link PmenuMatchSel PmenuSel
else
  hi Pmenu		guifg=#f6f3f0	guibg=#121002
  if 0
    "hi PmenuSel		guifg=black	guibg=#ccc08c	gui=NONE	cterm=NONE
  else
    "hi PmenuSel		guifg=NONE	guibg=#802010	gui=NONE	cterm=NONE	" 赤漆
    "hi PmenuSel		guifg=white
    "hi PmenuSel		guifg=#d0c589
  endif
  hi PmenuSel		guifg=#f6f3f0	guibg=#802010	gui=NONE	cterm=NONE	" 赤漆
  "hi PmenuMatch		guifg=#c0504d	guibg=#000000	gui=NONE	" FIXME
  hi PmenuMatch		guifg=#dcda8f	guibg=#000000	gui=NONE	" FIXME
  "hi PmenuMatchSel	guifg=#000000	guibg=#c0504d	gui=NONE	" FIXME
  hi PmenuMatchSel	guifg=#dcda8f	guibg=#802010	gui=NONE	" FIXME	        " 赤漆
endif
"hi PmenuExtra		guifg=#c0504d	guibg=#000000	gui=NONE	cterm=NONE
"hi PmenuExtra		guifg=#d8c08c	guibg=#121002	gui=NONE	cterm=NONE
"hi PmenuExtra		guifg=#85b0df	guibg=black	gui=NONE	cterm=NONE
"hi PmenuExtra		guifg=#857c75	guibg=#121002	gui=NONE	cterm=NONE
hi PmenuExtra		guifg=#5c5a4f	guibg=#121002	gui=NONE	cterm=NONE
"hi PmenuExtraSel	guifg=#000000	guibg=#c0504d	gui=NONE	cterm=NONE
"hi PmenuExtraSel	guifg=#5c5a4f	guibg=#000000	gui=NONE	cterm=NONE
"hi! link PmenuExtraSel	PmenuSel
hi PmenuExtraSel	guifg=#121002	guibg=#5c5a4f	gui=NONE	cterm=NONE
hi PmenuKind		guifg=#85b0df	guibg=black	gui=NONE	cterm=NONE
hi PmenuKindSel		guifg=black	guibg=#85b0df	gui=NONE	cterm=NONE
hi PmenuSbar		guifg=#ffffff	guibg=black	gui=NONE	cterm=NONE
hi PmenuThumb		guifg=#000000	guibg=#c0504d	gui=NONE	cterm=NONE


"----------------------------------------------------------------------------------------
" Spell Check
"
"   SpellBad
"   SpellCap
"   SpellLocal
"   SpellRare
"
hi SpellBad		guifg=NONE	guibg=NONE	guisp=Red	gui=undercurl	cterm=undercurl
hi SpellCap		guifg=NONE	guibg=NONE	guisp=Blue	gui=undercurl	cterm=undercurl
hi SpellRare 		guifg=NONE	guibg=NONE	guisp=Magenta	gui=undercurl	cterm=undercurl
hi SpellLocal		guifg=NONE	guibg=NONE	guisp=Cyan	gui=undercurl	cterm=undercurl


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
hi Folded		guifg=#c0c0c0	guibg=#202020	gui=NONE	cterm=NONE
hi FoldColumn		guifg=#7f1f1a	guibg=#eeddaa	gui=NONE	cterm=NONE
hi CursorLineFold	guifg=#7f1f1a	guibg=#bb3333	gui=NONE	cterm=NONE
"hi! link CursorLineFold	FoldColumn

hi SignColumn		guifg=#ff5d28	guibg=#605c58	gui=NONE	cterm=NONE
hi CursorLineSign	guifg=#7f1f1a	guibg=#bb3333	gui=NONE	cterm=NONE
"hi! link CursorLineSign	SignColumn


"----------------------------------------------------------------------------------------
" Search, Quickfix
"
"   QuickFixLine
"   IncSearch
"   Search
"   CurSearch
"
hi Search		guifg=white	guibg=#b7282e	gui=NONE	cterm=NONE
hi CurSearch		guifg=#b7282e	guibg=white	gui=NONE	cterm=NONE
hi IncSearch		guifg=white	guibg=blue	gui=NONE	cterm=NONE
hi QuickFixLine		guifg=NONE	guibg=#603a36	gui=NONE	cterm=NONE
" TODO
"hi QuickFixLine	guifg=NONE	guibg=#600a06	gui=NONE	cterm=NONE
"hi CurSearch		guifg=White	guibg=#600a06	gui=NONE	cterm=NONE


"----------------------------------------------------------------------------------------
" Other
"   ColorColumn
"   Conceal
"   WildMenu
"   PopupNotification
"
hi ColorColumn		guifg=NONE	guibg=#880000	gui=NONE	cterm=NONE
hi Conceal		guifg=LightGrey	guibg=DarkGrey	gui=NONE	cterm=NONE
hi WildMenu		guifg=#85b0df	guibg=#080808	gui=NONE	cterm=NONE


"----------------------------------------------------------------------------------------
" GUI Cursor
"   Cursor
"   CursorIM
"   lCursor
"
hi Cursor		guifg=indianred	guibg=black	gui=reverse	cterm=reverse
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
hi Comment		guifg=#848280	guibg=NONE	gui=NONE	cterm=NONE	| " gui=italic	cterm=italic
hi Constant		guifg=#df9678	guibg=NONE	gui=NONE	cterm=NONE
hi String		guifg=#bb9999	guibg=NONE	gui=NONE	cterm=NONE
hi Character		guifg=#99bb99	guibg=NONE	gui=NONE	cterm=NONE
hi Number		guifg=#e5e2d0	guibg=NONE	gui=NONE	cterm=NONE
hi Boolean		guifg=#acf0f2	guibg=NONE	gui=NONE	cterm=NONE
hi! link Float		Number
hi Identifier		guifg=NONE	guibg=NONE	gui=NONE	cterm=NONE	" FIXME
hi Function		guifg=#cdd129	guibg=NONE	gui=NONE	cterm=NONE
hi Statement		guifg=#af5f5f	guibg=NONE	gui=NONE	cterm=NONE
hi Keyword		guifg=#b7ef97	guibg=NONE	gui=NONE	cterm=NONE
hi PreProc		guifg=#d85850	guibg=NONE	gui=NONE	cterm=NONE
hi PreCondit		guifg=#f0bcf0	guibg=NONE	gui=NONE	cterm=NONE
hi Type			guifg=#d0c589	guibg=NONE	gui=NONE	cterm=NONE
hi Special		guifg=#bb9999
hi SpecialSp		guifg=#ff5d28	guibg=NONE	gui=NONE	cterm=NONE
hi! link SpecialChar	SpecialSp
hi! link Tag		SpecialSp
hi! link Delimiter	Special     " VimScriptでは、丸括弧もDelimiterとしてハイライトされる。
hi! link SpecialComment	SpecialSp
hi! link Debug		SpecialSp
hi Underlined		guifg=#80a0ff	guibg=NONE	gui=underline	cterm=underline
hi Ignore		guifg=bg	guibg=NONE	gui=NONE	cterm=NONE	" FIXME
hi Ignore		guifg=red	guibg=NONE	gui=NONE	cterm=NONE	" FIXME
hi Error		guifg=White	guibg=Red	gui=NONE	cterm=NONE
hi Todo			guifg=#8f8f8f	guibg=Yellow	gui=italic	cterm=italic
hi Added		guifg=white	guibg=red	gui=NONE        " FIXME
hi Changed		guifg=black	guibg=green	gui=NONE        " FIXME
hi Removed		guifg=white	guibg=blue	gui=NONE        " FIXME
" FIXME
"hi Boolean		guifg=#bb9999	guibg=NONE	gui=NONE	cterm=NONE
"hi String		guifg=#acf0f2	guibg=NONE	gui=NONE	cterm=NONE


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
  au InsertEnter *           hi CursorLineNr	guifg=#efd3b8	guibg=#d0330b	gui=NONE	cterm=NONE
 "au ModeChanged *:[vV\x16]* hi CursorLineNr	guifg=#b8d3ef	guibg=#4444ee	gui=NONE	cterm=NONE
  au ModeChanged *:[vV\x16]* hi CursorLineNr	guifg=#222222	guibg=#d0c589	gui=NONE	cterm=NONE
 "au CmdlineEnter *          hi CursorLineNr	guifg=#222222	guibg=#d0c589	gui=NONE	cterm=NONE	| redraw
  au ModeChanged *:n*        call hlset(s:CursorLineNrOrg)
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
