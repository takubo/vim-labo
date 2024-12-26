
"hi Mode		guifg=#cf302d	guibg=#202020	gui=none	ctermfg=254	ctermbg=235
"hi Mode		guifg=#ef504d	guibg=#202020	gui=none	ctermfg=254	ctermbg=235
"hi Mode		guifg=#ef504d	guibg=#202020	gui=none	ctermfg=254	ctermbg=235
hi Mode		guifg=#cf302d	guibg=#282828	gui=none	ctermfg=159
hi Mode		guifg=#acf0f2	guibg=#202020	gui=none	ctermfg=159
hi Mode		guifg=#eeeeee	guibg=#202020	gui=none	ctermfg=159
hi Mode		guifg=#eeeeee	guibg=#282828	gui=none	ctermfg=159
hi Mode		guifg=#878787	guibg=NONE	gui=NONE	ctermfg=102	ctermbg=NONE	cterm=NONE
hi Mode		guifg=#C7C7C7	guibg=NONE	gui=NONE	ctermfg=102	ctermbg=NONE	cterm=NONE
hi Mode     guifg=#d0c589	guibg=#282828
hi Mode		guifg=#d7d0c7	guibg=NONE	gui=NONE	ctermfg=102	ctermbg=NONE	cterm=NONE

let s:pid = 0

def PopUp()
  var cont = "Mode"

  if state() =~# 'm'
    return
  endif

  const mode_name = {
    'n':        'Normal',  # 'N'
    'no':       'O',  # 'O'
    'nov':      'O',  # 'O'
    'noV':      'O',  # 'O'
    'noCTRL-V': 'O',  # 'O'
    'niI':      'N',  # 'N'
    'niR':      'N',  # 'N'
    'niV':      'N',  # 'N'
    'nt':       'T',  # 'T'
    'v':        'Visual Character',  # 'V'
    'vs':       'V',  # 'V'
    'V':        'Visual Line',  # 'V'
    'Vs':       'V',  # 'V'
    '':       'Visual Block',  # 'V'
    #"\<Ctrl-V>":       'Visual',  # 'V'
    #nr2char(22):       'Visual',  # 'V'
    's':      'V',  # 'V'
    's':        'S',  # 'S'
    'S':        'S',  # 'S'
    '':       'S',  # 'S'
    #'i':        'I I I I I I',  #'I n s e r t',  # 'I'
    'i':        'Insert',  #'I n s e r t',  # 'I'
    'ic':       'I',  #'I n s e r t',  # 'I'
    'ix':       'I',  #'I n s e r t',  # 'I'
    #'R':        'R R R R R R',  # 'R'
    'R':        'Replace',  # 'R'
    'Rc':       'R',  # 'R'
    'Rx':       'R',  # 'R'
    'Rv':       'RV RV RV RV',  # 'V'
    'Rvc':      'V',  # 'V'
    'Rvx':      'V',  # 'V'
    'c':        'Command Line',  # 'C'
    'ct':       'C',  # 'C'
    'cr':       'C',  # 'C'
    'cv':       'V',  # 'V'
    'cvr':      'V',  # 'V'
    'ce':       'N',  # 'N'
    'r':        'H',  # 'H'
    'rm':       'T',  # 'T'
    'r?':       'A',  # 'A'
    '!':        'S',  # 'S'
    't':        'T',  # 'T'
  }

  #cont = mode(v:false)
  cont = mode_name[mode()]

  #echo v:event["new_mode"]
  #echo v:event["old_mode"]
  #cont = mode_name[v:event["new_mode"]]

  #echo cont

  #if exists('s:pid') && w:BrowsingScroll)
  if s:pid != 0
    popup_close(s:pid)
  endif

  s:pid =  popup_create(cont,
    {
      #'line':               'cursor+2',
      'line':               'cursor+4',
      'col':                'cursor+2',
      #'line':               'cursor+2',
      #'col':                'cursor+2',
      #'pos':                'center',
      #'posinvert':          ,
      #'textprop':           ,
      #'textpropwin':        ,
      #'textpropid':         ,
      #'fixed':              ,
      #'flip':               ,
      #'maxheight':          ,
      #'minheight':          ,
      #'maxwidth':           ,
      #'minwidth':           ,
      #'firstline':          ,
      #'hidden':             ,
      #'tabpage':            ,
      #'title':              ,
      #'wrap':               ,
      #'drag':               ,
      #'dragall':            ,
      #'resize':             ,
      #'close':              ,
      'highlight':          'Mode', #'Pmenu', 'Mode', 'SLFilename', 'Special',   'String',

      #'padding':            [1, 2, 1, 3],
      #
#     'padding':            [1, 3, 1, 3],

#     'padding':            [0, 3, 0, 3],

      'padding':            [0, 2, 0, 3],
      'border':             [],
      #'borderhighlight':    ,
      'borderchars':        ['─', '│', '─', '│', '┌', '┐', '┘', '└'],
      #'scrollbar':          ,
      #'scrollbarhighlight': ,
      #'thumbhighlight':     ,
      'zindex':             1000,
      #'mask':               [[1, 1, 3, 2]],
      'time':               1000,
      'moved':              'any',
      #'mousemoved':         ,
      #'cursorline':         ,
      #'filter':             ,
      #'mapping':            ,
      #'filtermode':         ,
      #'callback':           ,
    }
  )
enddef

def! PopUpC()
  pid =  popup_create(getcmdtype() == '/' ? 'Search' : "Command",
    {
      'line':               &lines - 6,
      'col':                5,
      #'line':               'cursor+2',
      #'col':                'cursor+2',
      #'pos':                'center',
      #'posinvert':          ,
      #'textprop':           ,
      #'textpropwin':        ,
      #'textpropid':         ,
      #'fixed':              ,
      #'flip':               ,
      #'maxheight':          ,
      #'minheight':          ,
      #'maxwidth':           ,
      #'minwidth':           ,
      #'firstline':          ,
      #'hidden':             ,
      #'tabpage':            ,
      #'title':              ,
      #'wrap':               ,
      #'drag':               ,
      #'dragall':            ,
      #'resize':             ,
      #'close':              ,
      'highlight':          'Mode', #'Pmenu', #'Mode', #'SLFilename', #'Special',  # 'String',

      #'padding':            [1, 2, 1, 3],
      #
      #     'padding':            [1, 3, 1, 3],

      #     'padding':            [0, 3, 0, 3],

      'padding':            [0, 2, 0, 3],
      'border':             [],
      #'borderhighlight':    ,
      'borderchars':        ['─', '│', '─', '│', '┌', '┐', '┘', '└'],
      #'scrollbar':          ,
      #'scrollbarhighlight': ,
      #'thumbhighlight':     ,
      'zindex':             1000,
      #'mask':               [[1, 1, 3, 2]],
      'time':               1000,
      'moved':              'any',
      #'mousemoved':         ,
      #'cursorline':         ,
      #'filter':             ,
      #'mapping':            ,
      #'filtermode':         ,
      #'callback':           ,
    }
  )
enddef
defcompile

"call PopUp()

augroup MyVimrc_ModeShow
  au!

  "au CmdlineEnter * call PopUp()

  "?? au ModeChanged [^i]*:[i]* call PopUp()
  "?? au ModeChanged [^R]*:[Rv]* call PopUp()
  "????  au ModeChanged *:[vV]* call PopUp()
  " au ModeChanged [^iR]*:[iRvV]* call PopUp()

  " CommandLineに入ったときは、redrawしないとPopUpが表示されない。
  " TODO au ModeChanged *:c* call PopUpC() | redraw

  "au ModeChanged [iv]*:n* call PopUp()
  "au ModeChanged *:* call PopUp()
augroup end

"                これらのオプションが設定できる:
"                        border
"                        borderchars
"                        borderhighlight
"                        callback
"                        close
"                        cursorline
"                        drag
"                        filter
"                        firstline
"                        flip
"                        highlight
"                        mapping
"                        mask
"                        moved
"                        padding
"                        resize
"                        scrollbar
"                        scrollbarhighlight
"                        thumbhighlight
"                        time
"                        title
"                        wrap
"                        zindex
"                popup_move() からのオプションも使用できる。
"                一般的に、設定のオプション値がゼロもしくは空文字列だと値をデ
"                フォルト値にリセットするが、例外がある。
"                "hidden" のために popup_hide() と popup_show() を使用する。
"                "tabpage" は変更できない。
"
"                method としても使用できる: >
"                        GetPopup()->popup_setoptions(options)
"<
"                戻り値の型: Number
"
"
"popup_settext({id}, {text})                             popup_settext()
"                ポップアップウィンドウ {id} でバッファのテキストを設定する。
"                {text} は、ポップアップに表示される文字列または文字列のリスト
"                である。
"                テキストの違いが生じる以外の、ウィンドウのサイズや位置は変わら
"                ない。
"
"                method としても使用できる: >
"                        GetPopup()->popup_settext('hello')
"<
"                戻り値の型: Number
"
"
"popup_show({id})                                                popup_show()
"                {id} が非表示のポップアップの場合は、それを表示する。
"                {id} については `popup_hide()` を参照。
"                {id} が情報ポップアップの場合、現在のポップアップメニュー項目
"                の隣に配置される。
"
"                戻り値の型: Number
"
"
"==============================================================================
"3. 使用方法                                             popup-usage
"
"
"☆POPUP_CREATE() の引数                           popup_create-arguments
"
"popup_create() の最初の引数(と popup_settext() の第2引数)は表示されるテキ
"ストと、オプションでテキストプロパティを指定する。それは4つの形式のうちの1つで
"ある:  E1284
"- バッファ番号
"- 文字列
"- 文字列のリスト
"- 辞書のリスト。各辞書は次のエントリを持つ:
"        text            表示するテキストを含む文字列。
"        props           テキストプロパティのリスト。任意。
"                        各エントリは prop_add() の第3引数のような辞書だが、
"                        辞書の "col" エントリを使って桁を指定する。以下を参照:
"                        popup-props.
"
"自分で新しいバッファを作成したい場合は、bufadd() を使用して、バッファ番号を
"popup_create() に渡す。
"
"popup_create() の第2引数は以下のオプションを持つ辞書である:
"        line            ポップアップを配置する画面の行。数値または、カーソルの
"                        行を使用して行数を加算または減算するには、"cursor"、
"                        "cursor+1"、または "cursor-1" を使用できる。省略もしく
"                        はゼロの場合、ポップアップは垂直方向の中央に配置され
"                        る。最初の行は1である。
"                        "textprop" を使用する場合、数値はテキストプロパティに
"                        関連していて、負の値にすることができる。
"        col             ポップアップを配置する画面の桁。数値または、カーソルの
"                        桁を使用するには "cursor" を使用し、桁を加算または減算
"                        するには "cursor+9" または "cursor-9" が使用できる。省
"                        略もしくはゼロの場合、ポップアップは水平方向の中央に配
"                        置される。最初の桁は1である。
"                        "textprop" を使用する場合、数値はテキストプロパティに
"                        関連していて、負の値にすることができる。
"        pos             "topleft"、"topright"、"botleft" または "botright":
"                        ポップアップのどのコーナーに "line" と "col" が使われ
"                        るかを定義する。設定されていない場合は "topleft" が使
"                        用される。あるいは "center" を使ってポップアップをVim
"                        のウィンドウの中央に配置することもできる。その場合は
"                        "line" と "col" は無視される。
"        posinvert       FALSE の場合、"pos" の値が常に使用される。TRUE (デフォ
"                        ルト)で、ポップアップが垂直に収まらず、反対側により多
"                        くのスペースがある場合、ポップアップは "line" で示され
"                        る位置の反対側に配置される。
"        textprop        指定した場合、ポップアップはこの名前のテキストプロパ
"                        ティの隣に配置され、テキストプロパティが移動すると移動
"                        する。削除するには空の文字列を使用すること。
"                        popup-textprop-pos を参照。
"        textpropwin     テキストプロパティを検索するウィンドウ。省略または無効
"                        な場合、現在のウィンドウが使用される。"textprop" が指
"                        定された場合に使用される。
"        textpropid      "textprop" が指定された場合にテキストプロパティを識別
"                        するために使用される。0 を使用してリセットする。
"        fixed           FALSE (デフォルト)の場合は:
"                         - "pos" は "botleft" または "topleft" で、
"                         - "wrap" はオフで、
"                         - ポップアップは画面の右端で切り捨てられ、
"                        ポップアップは画面の内容に合うように左に移動される。こ
"                        れを無効にするには、TRUEに設定する。
"        flip            TRUE (デフォルト)かつ位置がカーソルからの相対位置であ
"                        る場合は、popupmenu-completion または、より高い
"                        "zindex" を持つ別のポップアップと重ならないようにカー
"                        ソルの下または上に動かす。
"                        カーソルの上/下にスペースがない場合は、ポップアップま
"                        たはポップアップメニューの横にポップアップを表示する。
"                        {未実装} {not implemented yet}
"        maxheight       コンテンツの最大高さ(ボーダーとパディングを除く)
"        minheight       コンテンツの最小高さ(ボーダーとパディングを除く)
"        maxwidth        コンテンツの最大幅(ボーダーとパディングとスクロールバー
"                        を除く)
"        minwidth        コンテンツの最小幅(ボーダーとパディングとスクロールバー
"                        を除く)
"        firstline       表示する最初のバッファ行。1より大きい場合は、テキスト
"                        が上にスクロールしたように見える。範囲外の場合、最後の
"                        バッファ行はウィンドウの最上部に表示される。
"                        コマンドによって設定された位置のままにするには、0 に設
"                        定する。"scrollbar" も参照。
"        hidden          TRUEの場合、ポップアップは存在するが表示されない。表示
"                        するには `popup_show()` を使う。
"        tabpage         -1の場合: すべてのタブページにポップアップを表示する。
"                        0 (デフォルト)の場合: カレントタブページにポップアップ
"                        を表示する。
"                        それ以外の場合は、ポップアップが表示されるタブページの
"                        番号。無効な場合、ポップアップは生成されず、エラーに
"                        なる。 E997
"        title           ポップアップの最初の項目の上、ボーダーの上に表示される
"                        テキスト。上枠がない場合は、タイトルを付けるために1行
"                        のパディングが追加される。最初と最後に1つ以上のスペー
"                        スをパディングとして追加することを薦める。
"        wrap            行を折り返す場合はTRUE(デフォルトはTRUE)。
"        drag            ボーダーを掴んでマウスでポップアップをドラッグできるよ
"                        うにする場合はTRUE。ポップアップにボーダーがない場合は
"                        効果がない。"pos" が "center" の場合は、ドラッグが始ま
"                        るとすぐに "topleft" に変更される。
"        dragall         TRUEを設定すると、ポップアップを任意の位置にドラッグで
"                        きる。ポップアップ内のテキストの選択は非常に難しくな
"                        る。
"        resize          TRUEを設定すると、マウスで右下隅をつかんでポップアップ
"                        のサイズを変更できる。ポップアップにボーダーがない場合
"                        は効果がない。
"        close           "button" の場合、X が右上隅、境界線、パディング、また
"                        はテキストの上に表示される。X をクリックすると、ポップ
"                        アップは閉じる。任意のコールバックが値 -2 で呼び出され
"                        る。
"                        "click" の場合、ポップアップ内の任意のマウスクリックで
"                        ポップアップが閉じる。
"                        "none" (デフォルト)の場合、マウスクリックはポップアッ
"                        プウィンドウを閉じない。
"        highlight       'wincolor' オプションに格納されている、テキストに使用
"                        するハイライトグループ名。
"        padding         ポップアップの上/右/下/左のパディングを定義する数値の
"                        リスト(CSSと同様)。空のリストは、すべて 1 のパディング
"                        を使用する。パディングは、テキストをボーダーの内側で囲
"                        む。パディングは 'wincolor' ハイライトを使う。
"                        例: [1, 2, 1, 3] は上に1行、右に2桁、下に1行、左に3桁
"                        のパディングにする。
"        border          ポップアップの上/右/下/左のボーダーの太さを定義する数
"                        値のリスト(CSSと同様)。現在ゼロとゼロ以外の値のみが認
"                        識される。空のリストは、周囲にボーダーを使用する。
"        borderhighlight ボーダーに使用するハイライトグループ名のリスト。1つの
"                        エントリの場合はそれがすべてのボーダーに使用される、そ
"                        れ以外の場合は上/右/下/左のボーダーのハイライトになる。
"                        例: ['TopColor', 'RightColor', 'BottomColor,
"                        'LeftColor']
"        borderchars     上/右/下/左のボーダーに使用する文字を定義する、文字の
"                        リスト。左上/右上/右下/左下の隅に使用する文字が任意で
"                        続く。
"                        例: ['-', '|', '-', '|', '┌', '┐', '┘', '└']
"                        リストに1文字が含まれている場合は、それがすべてに使用
"                        される。リストに2文字が含まれている場合、最初の文字は
"                        ボーダーに使用され、2番目の文字はコーナーに使用される。
"                        'encoding' が "utf-8" かつ 'ambiwidth' が "single" の
"                        ときはデフォルトで2重線が使われる。それ以外の場合は
"                        ASCII文字が使われる。
"        scrollbar       1か true: テキストが収まらない場合にスクロールバーを
"                        表示する。0: スクロールバーを表示しない。デフォルトは
"                        0以外である。popup-scrollbar も参照。
"        scrollbarhighlight  スクロールバー用のハイライトグループ名。背景色が重
"                        要である。指定しない場合、PmenuSbar が使用される。
"        thumbhighlight  スクロールバーのつまみ用のハイライトグループ名。背景色
"                        が重要である。指定しない場合、PmenuThumb が使用される。
"        zindex          ポップアップの優先度。デフォルトは50。最小値は1、最大
"                        値は32000。
"        mask            ポップアップの透明な部分を定義する座標付きリストのリス
"                        ト。
"        time            ポップアップが閉じるまでの時間(msec)。省略した場合は
"                        popup_close() を使用する必要がある。
"        moved           カーソルが移動した場合にポップアップを閉じるように指定
"                        する:
"                        - "any": 少しでもカーソルが移動した場合
"                        - "word": カーソルが <cword> の外側に移動した場合
"                        - "WORD": カーソルが <cWORD> の外側に移動した場合
"                        - "expr": カーソルが <cexpr> の外側に移動した場合
"                        - [{start}, {end}]: カーソルが桁 {start} の前、または
"                          {end} の後に移動した場合
"                        - [{lnum}, {start}, {end}]: カーソルが行 {lnum} から離
"                          れた場合、または、桁が {start} の前、または {end} の
"                          後に移動した場合
"                        - [0, 0, 0]: カーソルが移動するときにポップアップを閉
"                          じない
"                        カーソルが別の行または別のウィンドウに移動した場合も
"                        ポップアップは閉じる。
"        mousemoved      "moved" に似ているが、マウスポインタの位置を参照する。
"        cursorline      TRUE:    カーソル行をハイライトする。また、テキストを
"                                 スクロールしてこの行を表示する( 'wrap' がオフ
"                                 の場合のみ適切に機能する)。
"                        0:       カーソル行をハイライトしない。
"                        popup_menu() を除いて、デフォルトは0である。
"        filter          入力した文字をフィルタ処理できるコールバック。
"                        popup-filter を参照。
"        mapping         キーマッピングを許可する。FALSEで、かつポップアップが
"                        表示され、フィルターコールバックがある場合、キーマッピ
"                        ングは無効になっている。 デフォルト値はTRUEである。
"        filtermode      どのモードでフィルターが使用されるか(hasmapto() と同
"                        じフラグと "a"):
"                                n       ノーマルモード
"                                v       ビジュアルまたは選択モード
"                                x       ビジュアルモード
"                                s       選択モード
"                                o       オペレータ待機モード
"                                i       挿入モード
"                                l       言語引数 ("r", "f", "t" 等)
"                                c       コマンドラインモード
"                                a       すべてのモード
"                        デフォルト値は "a" である。
"        callback        ポップアップが閉じたときに呼び出されるコールバック。
"                        例えば、popup_filter_menu() を使用する場合、
"                        popup-callback を参照。


"     ###'border':             ,
"     ###'borderchars':        ,
"     ###'borderhighlight':    ,
"     ###'callback':           ,
"     ###'close':              ,
"     ###'cursorline':         ,
"     ###'drag':               ,
"     ###'filter':             ,
"     ###'firstline':          ,
"     ###'flip':               ,
"     ###'highlight':          ,
"     ###'mapping':            ,
"     ###'mask':               ,
"     ###'moved':              ,
"     ###'padding':            ,
"     ###'resize':             ,
"     ###'scrollbar':          ,
"     ###'scrollbarhighlight': ,
"     ###'thumbhighlight':     ,
"     ###'time':               500,
"     ###'title':              ,
"     ###'wrap':               ,
"     ###'zindex':             1000,



"defcompile

"def! PopUpInfoS(cont: string)
"  PopUpInfo([cont])
"enddef
"
"defcompile



augroup MyCmdLineEnter
  au!
  "au CmdlineLeave * echo "Leac"
  "au CmdlineEnter * call PopUp()
  "au CmdlineEnter * echo "PopUp()"
  "au CmdlineEnter * let g:test = "PopUp()"
augroup end
