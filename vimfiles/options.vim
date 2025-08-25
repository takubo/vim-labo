vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8

#=============================================================================================
# Options
#=============================================================================================



def SetFlagOption(option: string, add_flags: string, remove_flags: string)
  # TODO foreach
  remove_flags -> map((_, flag) => {
    exe 'set' option .. '-=' .. flag
    return ''
  } )

  exe 'set' option .. '+=' .. add_flags
enddef



# VIM - Vi IMproved 9.1 (2024 Jan 02, compiled Jan  2 2024 23:51:27)
# MS-Windows 64 ビット GUI 版 with OLE サポート
# Compiled by appveyor@APPVEYOR-VM
# Huge 版 with GUI.  機能の一覧 有効(+)/無効(-)


#  1 重要
#  2 移動、検索とパターン
#  3 タグ
#  4 テキストの表示
#  5 構文ハイライトとスペルチェック
#  6 複数ウィンドウ
#  7 複数タブページ
#  8 端末
#  9 マウスの使用
# 10 GUI
# 11 印刷
# 12 メッセージと情報
# 13 テキスト選択
# 14 テキスト編集
# 15 タブとインデント
# 16 折畳み
# 17 差分モード
# 18 マッピング
# 19 ファイルの読み書き
# 20 スワップファイル
# 21 コマンドライン編集
# 22 外部コマンドの実行
# 23 make の実行とエラーへのジャンプ (quickfix)
# 24 システム固有
# 25 言語固有
# 26 マルチバイト文字
# 27 その他


#  1 重要

#set compatible
#set cpoptions
#set insertmode
#set paste
#set pastetoggle
#set runtimepath
#set packpath
#set helpfile

#  2 移動、検索とパターン

#set whichwrap
set nostartofline  # TODO
#set paragraphs
#set sections
set path+=./**,;  # TODO
set cdhome
# TODO set cdpath
set autochdir
#set autoshelldir
set nowrapscan  # 検索時にファイルの末尾で先頭に戻らない
set incsearch
#set magic
#set regexpengine
set ignorecase
set smartcase
#set casemap
set maxmempattern=2000000
#set define
#set include
#set includeexpr

#  3 タグ

#set tagbsearch
#set taglength
set tags+=./tags,./tags;  # TODO
set tagcase=match  # TODO set tagcase=followscs
#set tagrelative
#set tagstack
set showfulltag  # TODO
# TODO set tagfunc
#set cscopeprg
#set cscopetag
#set cscopetagorder
#set cscopeverbose
#set cscopepathcomp
#set cscopequickfix
#set cscoperelative

#  4 テキストの表示

# TODO set scroll
#set smoothscroll  #@ cursor_move_and_scroll
#set scrolloff  #@ cursor_move_and_scroll
set wrap  # 長い行を折り返して表示
#set linebreak
# TODO set breakindent
# TODO set breakindentopt
#set breakat
set showbreak=<  # TODO 再考
#set sidescroll  #@ cursor_move_and_scroll
#set sidescrolloff  #@ cursor_move_and_scroll
set display=lastline  # TODO 再確認
set fillchars=vert:\|,fold:-,eob:~,lastline:@
# TODO set fillchars=vert:@,fold:-,eob:~,lastline:@
set cmdheight=2  # TODO Windows用gvim使用時はgvimrcを編集すること
#set columns  #@ GUI
#set lines  #@ GUI
# TODO set window
#set nolazyredraw
#set redrawtime
#set writedelay=0
set list
set listchars=tab:>_,trail:$,extends:>,precedes:<,conceal:?,nbsp:X
set number
set relativenumber
set numberwidth=3
set chistory=100
set lhistory=100
#set conceallevel
#set concealcursor

#  5 構文ハイライトとスペルチェック

#set background=dark  #@ ColorScheme
#set filetype
#set syntax
# TODO set synmaxcol
#set highlight
if !&hlsearch
  # sourceする度にハイライトされるのを避ける。
  set hlsearch
endif
#set wincolor
set termguicolors
#set cursorcolumn  # cursor_move_and_scroll
#set cursorline  # cursor_move_and_scroll
#set cursorlineopt=screenline,number  # cursor_move_and_scroll
#set colorcolumn=
#set spell
#set spelllang
#set spellfile
#set spellcapcheck
#set spelloptions
#set spellsuggest
#set mkspellmem

#  6 複数ウィンドウ

set laststatus=2  # 常にステータス行を表示
#set statusline  #@ statusline
#set noequalalways  #@ window
#set eadirection
set winheight=3  # TODO
set winminheight=3  # TODO
#set winfixbuf
#set winfixheight
#set winfixwidth
set winwidth=15  # 動的 ウィンドウサイズtと、 numberwidth
set winminwidth=5  # 動的 ウィンドウサイズtと、 numberwidth
# TODO set helpheight
# TODO set previewpopup
# TODO set previewheight
#set previewwindow
set hidden
set switchbuf=useopen,uselast  # TODO ,split
set splitbelow  # TODO
set splitkeep=topline # TODO
set splitkeep=screen  # TODO
set splitkeep=cursor  # TODO
set splitright  # TODO
#set scrollbind
#set scrollopt=ver,jump
#set cursorbind
# TODO set termwinsize
# TODO set termwinkey
set termwinscroll=1000000000  # 10億: とくに根拠はないが、3倍しても、4GB未満。
#set termwintype
#set winptydll

#  7 複数タブページ

#set showtabline=2  #@ tabline
#set tabclose=uselast  #@ tabline
set tabpagemax=50
#set tabline  #@ tabline
#set guitablabel
#set guitabtooltip

#  8 端末

#set term
#set ttytype
#set ttybuiltin
#set ttyfast
# TODO set xtermcodes
#set weirdinvert
# TODO set keyprotocol
# TODO set esckeys
#set scrolljump=1
# TODO set ttyscroll
#set guicursor  #@ vimrc, Rimpa
# vimrc, 1228
#set guicursor=n-v-c:block-Cursor/lCursor,ve:ver35-Cursor,o:hor50-Cursor,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor,a:blinkon0
# Rimpa
#set guicursor=n-v-c:ver20-blinkwait1000-blinkon600-blinkoff400-Cursor/lCursor,ve:ver35-Cursor,o:hor50-Cursor,i-ci:hor30-Cursor/lCursor,r-cr:Block-Cursor/lCursor
# TODO set title
# TODO set titlelen
# TODO set titlestring
# TODO set titleold
# TODO set icon
# TODO set iconstring
set restorescreen

#  9 マウスの使用

set mouse=a  # TODO gvimrc
#set nomousefocus
# TODO set scrollfocus
#set mousehide
# TODO set mousemoveevent
#set mousemodel
#set mousetime
#set ttymouse
#set mouseshape

# 10 GUI

if has('win32')
  set guifont=BIZ_UDゴシック:h11:cSHIFTJIS:qDRAFT
endif
# TODO set guifontwide
#set guioptions=!cd  # gvimrc
if has('win32')
  set renderoptions=type:directx,scrlines:1  # TODO
endif
# TODO set guipty
#set browsedir
#set langmenu
#set menuitems
#set winaltkeys=no
# TODO set linespace
#set balloondelay
#set ballooneval
# TODO set balloonevalterm
#set balloonexpr

# 11 印刷

#set printoptions
#set printdevice
#set printfont
#set printheader
#set printmbcharset
#set printmbfont

# 12 メッセージと情報

#set noterse
SetFlagOption('shortmess', 'imxcCS', 'flnrwastTWAIq')  # set shortmess
set messagesopt=hit-enter,history:10000
#set showcmd  # 入力中のコマンドを表示
# TODO set showcmdloc=tabline
#set showmode
#set ruler
#set rulerformat
set report=0  # or 1
#set verbose
# TODO set verbosefile
#set more
# TODO set confirm
#set noerrorbells
set visualbell
set belloff=backspace,error,esc,insertmode,term,wildmode
#set visualbell t_vb=
#set helplang=ja

# 13 テキスト選択

#set selection=inclusive
#set selectmode
set clipboard=unnamed
#set keymodel

# 14 テキスト編集

set undolevels=10000  # デフォルトは 100
# TODO set noundofile
#set undodir=$HOME/vim_undo
set undoreload=-1  # リロードするときにアンドゥのためにバッファ全体を保存する
#set modified
#set readonly
#set modifiable
#set textwidth=0
#set wrapmargin=0
set backspace=indent,eol,start  # バックスペースでインデントや改行を削除できるようにする
#set comments
SetFlagOption('formatoptions', 'mMBj', 'roa')  # set formatoptions  # テキスト挿入中の自動折り返しを日本語に対応させる
# TODO set formatlistpat
#set formatexpr
#set complete  #@ completion
#set completefuzzycollect  #@ completion
#set completeopt  #@ completion
#set completeitemalign  #@ completion
#set completepopup  #@ completion
#set pumheight  #@ completion
#set pumwidth  #@ completion
#set pummaxwidth
#set completefunc
#set omnifunc
#set dictionary
#set thesaurus
#set thesaurusfunc
#set noinfercase
#set digraph
#set notildeop
#set operatorfunc
set showmatch  # 括弧入力時に対応する括弧を表示
set matchtime=2  # 0.2秒
# Unicodeの全ての括弧
set matchpairs+=(:),<:>,[:],{:},（:）,＜:＞,［:］,｛:｝,｟:｠,｢:｣,〈:〉,《:》,「:」,『:』,【:】,〔:〕,〖:〗,〘:〙,〚:〛,⟦:⟧,⟨:⟩,⟪:⟫,⟬:⟭,⟮:⟯,⦃:⦄,⦅:⦆,⦇:⦈,⦉:⦊,⦋:⦌,⦍:⦎,⦏:⦐,⦑:⦒,⦗:⦘,⧼:⧽,❨:❩,❪:❫,❬:❭,❮:❯,❰:❱,❲:❳,❴:❵,⁽:⁾,₍:₎
set matchpairs+=?::
#set matchpairs+==:;
set nojoinspaces  # TODO
#set nrformats=hex,bin,blank  # FIXME unsigned  blankは最新バージョンのみ
set nrformats=hex,bin,unsigned

# 15 タブとインデント

#set tabstop=8
set shiftwidth=2  # TODO 8
#set vartabstop
#set varsofttabstop
set smarttab
set softtabstop=-1  # 'マイナスなら 'shiftwidth' の値が使われる。
set shiftround  # TODO set noshiftround
set expandtab  # TODO
set autoindent
#set smartindent
#set cindent
# TODO set cinoptions
#set cinkeys
#set cinwords
#set cinscopedecls
#set indentexpr
#set indentkeys
set copyindent
# TODO set preserveindent
#set lisp
#set lispwords
#set lispoptions

# 16 折畳み

# TODO set foldenable
#set foldlevel
#set foldlevelstart
# TODO set foldcolumn=2
# TODO set foldtext
#set foldclose
# TODO set foldopen
# TODO set foldminlines=0
#set commentstring
#set foldmethod
#set foldexpr
#set foldignore
#set foldmarker
#set foldnestmax

# 17 差分モード

#set diff
#set diffopt  #@ diff
# TODO git diffにする？ set diffexpr
# TODO set patchexpr

# 18 マッピング

#set maxmapdepth
#set remap
#set timeout
#set nottimeout
set timeoutlen=1100  #@ misc
#set ttimeoutlen=-1

# 19 ファイルの読み書き

#set modeline
#set modelineexpr
#set modelines
#set binary
#set endofline
#set endoffile
# TODO set fixendofline
#set nobomb
# TODO set fileformat=unix  # for 1st empty buffer
set fileformats=unix,dos,mac
#set textmode
#set textauto
#set write
#set writebackup
#set nobackup
# TODO set backupskip
# TODO set backupcopy
set backupdir=$HOME/vim_buckup
# TODO set backupext
#set noautowrite
#set noautowriteall
#set nowriteany
#set noautoread
#set patchmode=.org
#set fsync
#set shortname
#set cryptmethod

# 20 スワップファイル

set directory=$HOME/vim_swap
#set swapfile
# TODO set swapsync
set updatecount=100  # TODO
# TODO set updatetime  # この時間 (ミリ秒単位) 入力がなければ、スワップファイルがディスクに書き込まれる。また autocommand のイベントCursorHoldにも使われる。
# TODO set maxmem=2000000
# TODO set maxmemtot=2000000

# 21 コマンドライン編集

set history=10000  # 最大値
# TODO set wildchar=<Tab>
# TODO set wildcharm
set wildmode=full
set wildoptions=pum,tagfile  # TODO options コマンドで出て来なかった。 TODO fuzzyの有効か？tagfileの効果もよくわからない。 fuzzy,
# TODO set suffixes
# TODO set suffixesadd
set wildignore+=**/.git/**,**/.svn/**,*.o,*.obj,*.exe
#set fileignorecase
# TODO set wildignorecase
set wildmenu
exe "set cedit=\<C-Q>"
set cmdwinheight=20  # TODO 動的変更

# 22 外部コマンドの実行

#set shell  #@ vim_local
# TODO set shellquote
#set shellxquote  #@ vim_local
#set shellxescape
#set shellcmdflag  #@ vim_local
# TODO set shellredir
# TODO set shelltemp
#set equalprg
# TODO set formatprg
# TODO set keywordprg
#set warn

# 23 make の実行とエラーへのジャンプ (quickfix)

#set errorfile
# TODO set errorformat
#set makeprg
# TODO set shellpipe
#set makeef
#set grepprg  #@ grep
# TODO set grepformat
# TODO DOS set makeencoding
#set quickfixtextfunc

# 24 システム固有

set shellslash
# TODO set completeslash=backslash

# 25 言語固有

set isfname-=:  # grepの出力を取り込んで、gfするため。
#set isident
#set isexpand  # TODO
#set iskeyword
#set isprint
#set quoteescape
#set rightleft
#set rightleftcmd
#set revins
#set allowrevins
#set aleph
#set hkmap
#set hkmapp
#set arabic
#set arabicshape
#set termbidi
#set keymap
#set langmap
#set langremap
#set iminsert=0
#set imstyle
#set imsearch=-1

# 26 マルチバイト文字

#set encoding
#set fileencoding
# TODO set fileencodings
# TODO set termencoding
#set charconvert
#set delcombine
#set maxcombine
set ambiwidth=double  # TODO if has('kaoriya') | set ambiwidth=auto | endif
#set emoji

# 27 その他

#set virtualedit=
#set eventignore=
#set eventignorewin=
#set loadplugins
#set exrc
#set secure
#set nogdefault
#set edcompatible
#set opendevice
#set maxfuncdepth=200
set sessionoptions+=unix,slash  # TODO
set viewoptions+=unix,slash  # TODO
set viewdir=$HOME/vim_view
# TODO set viminfo
# TODO set viminfofile
#set bufhidden
#set buftype
#set buflisted
#set debug=
#set signcolumn=auto
#set luadll
#set perldll
#set pyxversion
#set pythondll
#set pythonhome
#set pythonthreedll
#set pythonthreehome
#set rubydll
#set tcldll
#set mzschemedll
#set mzschemegcdll



#
# shortmess
#
#
# -   f "(file 3 of 5)" の代わりに "(3 of 5)" を表示    *shm-f*
# +   i "[Incomplete last line]" の代わりに "[noeol]" を表示  *shm-i*
# -   l "999 行, 888 バイト" の代わりに "999L, 888B" を表示 *shm-l*
# +   m "[Modified]" の代わりに "[+]" を表示      *shm-m*
# -   n "[New File]" の代わりに "[New]" を表      *shm-n*
# -   r "[readonly]" の代わりに "[RO]" を表示     *shm-r*
# -   w 書き込みコマンドには "書込み" の代わりに "[w]" を、 *shm-w*
#       コマンド':w >> file' には "追加" の代わりに "[a]" を表示
# +   x "[dos format]" の代わりに "[dos]", "[unix format]"  *shm-x*
#       の代わりに "[unix]", "[mac format]" の代わりに "[mac]" を表示
# -   a 上記の省略を全て行う          *shm-a*
#
# q   o ファイルの書き込み時のメッセージを、その後のファイル  *shm-o*
#       の読み込み時のメッセージで上書きする (":wn" を使うときやオプ
#       ション 'autowrite' がオンのときに便利である)
#
# q   O ファイルの読み込み時のメッセージや Quickfix 関係の  *shm-O*
#       メッセージ (例えば ":cn") がその前のメッセージを必ず上書きする
#
# -   s "下まで検索したので上に戻ります" と "上まで検索した *shm-s*
#       ので下に戻ります" というメッセージを表示しない。検索件数を使用
#       する場合、件数メッセージの前に "W" が表示されない（下記の |shm-S| を参照）
#
# -   t ファイル間連のメッセージが長すぎてコマンドラインに  *shm-t*
#       収まらないときは、先頭を切り詰める。先頭には "<" が表示される。
#       Exモードでは無視される
#
# -   T その他のメッセージが長すぎてコマンドラインに収まら  *shm-T*
#       ないときは、中央を切り詰める。中央には "..." が表示される。Ex
#       モードでは無視される
#
# -   W ファイルの書き込み時に "書込み" や "[w]" を表示しない *shm-W*
#
# -   A スワップファイルがすでにあることが発見されたときに  *shm-A*
#       "注意" メッセージを表示しない
#
# -   I Vimの開始時に挨拶メッセージを表示しない |:intro|  *shm-I*
#
# +   c |ins-completion-menu| 関連のメッセージを表示しない。  *shm-c*
#       例えば、"-- XXX補完 (YYY)"、"1 番目の該当 (全該当 2 個中)"、
#       "唯一の該当"、"パターンは見つかりませんでした"、"始めに戻る"、
#       など
#
# +   C "scanning tags" など、挿入モードの補完項目のスキャン  *shm-C*
#       中にメッセージを表示しない
#
# -   q "記録中 @a" の代わりに "記録中" を表示      *shm-q*
#
# q   F コマンドに対する |:silent| のように、ファイルを編集中 *shm-F*
#       にファイル情報を表示しない。note これは autocommand および
#       'autoread' の再読み込みからのメッセージにも影響する
#
# +   S 検索時に検索件数メッセージを表示しない。例えば    *shm-S*
#       "[1/5]"。"S" フラグが指定されない (例えば、検索件数が表示され
#       る) 場合、"search hit BOTTOM, continuing at TOP" および
#       "search hit TOP, continuing at BOTTOM" メッセージは、検索件数
#       統計の前に "W" (覚え方: Wrapped) 文字のみで示される。


#
# formatoptions
#
# n   t
# n   c
# -   r
# -   o
# ?   /
# ?   q
# ?   w
# -   a
# ?   n
# ?   2
# n   v
# n   b
# n   l
# n   m
# +   M
# +   B
# n   1
# n   ]
# +   j
# n   p
