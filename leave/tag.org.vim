" Tag, Jump, and Unified CR {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

" Browse
if 0
  "nnoremap H <C-o>
  "nnoremap L <C-i>

  "nmap H <Plug>(BrowserJump-Back)
  "nmap L <Plug>(BrowserJump-Foward)

  "nnoremap <silent> H :<C-u>pop<CR>
  "nnoremap <silent> L :<C-u>tag<CR>

  "nmap <BS>H  <Plug>(MyVimrc-WindowSplitAuto)<C-w>p<Plug>(BrowserJump-Back)
  "nmap <BS>L  <Plug>(MyVimrc-WindowSplitAuto)<C-w>p<Plug>(BrowserJump-Foward)

  "nmap <BS>H  <Plug>(MyVimrc-WindowSplitAuto)<Plug>(MyVimrc-WinCmd-p)<Plug>(BrowserJump-Back)
  "nmap <BS>L  <Plug>(MyVimrc-WindowSplitAuto)<Plug>(MyVimrc-WinCmd-p)<Plug>(BrowserJump-Foward)
else
  nmap <C-p>      <Plug>(BrowserJump-Back)
  nmap <C-n>      <Plug>(BrowserJump-Foward)

  nmap <BS><C-p>  <Plug>(MyVimrc-Window-AutoSplit)<Plug>(MyVimrc-WinCmd-p)<C-p>
  nmap <BS><C-n>  <Plug>(MyVimrc-Window-AutoSplit)<Plug>(MyVimrc-WinCmd-p)<C-n>
endif


" ---------------
" Unified CR
"   数字付きなら、行へジャンプ
"   qfなら当該行へジャンプ
"   helpなら当該行へジャンプ
"   それ以外なら、タグジャンプ
" ---------------
function! Unified_CR(mode)

  if v:prevcount
    "jumpする前に登録しないと、v:prevcountが上書されてしまう。
    call histadd('cmd', v:prevcount)
    "jumplistに残すために、Gを使用。
    exe 'normal!' v:prevcount . 'G'
    return
  endif

 "if &ft == 'qf'
  if &buftype == 'quickfix'
    "call feedkeys("\<CR>:FF2\<CR>", 'nt')
    call feedkeys("\<CR>", 'nt')
    return
 "elseif &ft == 'help'
  elseif &buftype == 'help'
    call feedkeys("\<C-]>", 'nt')
    return
  endif

  "if EmIsNum()
  "  EmDispNoTimeOut
  "  return
  "endif

  if JumpToDefine(a:mode) <= 0
    return
  endif

  if &ft == 'vim'
    try
      exe 'help ' . expand('<cword>')

      let g:TagMatch = matchadd('TagMatch', '\<' . expand("<cword>") . '\>')
      let g:TimerTagMatch = timer_start(s:TagHighlightTime, 'TagHighlightDelete')
      let g:TagMatchI[g:TimerTagMatch] = g:TagMatch
      augroup ZZZZ
        au!
        au WinLeave * call TagHighlightDelete(g:TimerTagMatch)
      augroup end
      return
    catch
      "keeppatterns normal! gd
    endtry
  endif
  "keeppatterns normal! gd

  if search('\%#\f', 'bcn')
    try
      normal! gf
      if v:version < 802
        echohl Search
        echo 'Go File' . repeat(' ', &columns - 40)
        echohl None
      elseif 1
        " Cursor 下
        call popup_create('    Go  File    ' , #{
              \ line: 'cursor+3',
              \ col: 'cursor',
              \ posinvert: v:true,
              \ wrap: v:false,
              \ zindex: 200,
              \ highlight: 'SLFileName',
              \ border: [1, 1, 1, 1],
              \ borderhighlight: ['QuickFixLine'],
              \ moved: 'any',
              \ time: 2000,
              \ })
      else
        " Center
        call popup_create('                G o    F i l e                ' , #{
              \ line: 'cursor+2',
              \ col: 'cursor',
              \ pos: 'center',
              \ posinvert: v:true,
              \ wrap: v:false,
              \ zindex: 200,
              \ highlight: 'SLFileName',
              \ border: [1, 1, 1, 1],
              \ borderhighlight: ['QuickFixLine'],
              \ padding: [1, 1, 1, 1],
              \ moved: 'any',
              \ time: 2000,
              \ })
      endif
    catch /E447/
    finally
    endtry
    return
  endif

  keeppatterns normal! gd

endfunction


" ----------------------------------------------------------------------------------------------
" Tag Match

augroup MyVimrc_TagMatch
  au!
  au ColorScheme * hi TagMatch	guibg=#c0504d	guifg=white
augroup end

function! TagHighlightDelete(dummy)
  call timer_stop(a:dummy)

  "echo a:dummy
  "sleep 5
  "call matchdelete(g:TagMatch)
  call matchdelete(g:TagMatchI[a:dummy])
  call remove(g:TagMatchI, a:dummy . '')
  "echo g:TagMatchI

  if a:dummy == g:TimerTagMatch0
    au! ZZZZ0
    "ここでreturnしないと、この下のif文でg:TimerTagMatchが未定義エラーになる。
    return
  endif
  if a:dummy == g:TimerTagMatch
    au! ZZZZ
    return
  endif
endfunction

let g:TagMatchI = {}
let s:TagHighlightTime = 1500  " [ms]

" TODO
"   ラベルならf:b
"   変数なら、スクロールしない
"   引数のタグ
"   asmのタグ
function! JumpToDefine(mode)
  let w0 = expand("<cword>")

  if w0 !~ '\<\i\+\>'
    return -1
  endif

  let w = w0

  let g:TagMatch0 = matchadd('TagMatch', '\<'.w.'\>')
  let g:TimerTagMatch0 = timer_start(s:TagHighlightTime, 'TagHighlightDelete')
  let g:TagMatchI[g:TimerTagMatch0] = g:TagMatch0
  augroup ZZZZ0
    au!
    au WinLeave * call TagHighlightDelete(g:TimerTagMatch0)
  augroup end
  redraw

  for i in range(2)
    try
      if 1
        if a:mode =~? 's'
          exe (a:mode =~? 'p' ? 'p' : (a:mode =~? 'w' ? 's' : '')) . "tselect " . w
        else
          exe (a:mode =~? 'p' ? 'p' : (a:mode =~? 'w' ? 's' : '')) . "tjump " . w
        endif
      else
        if ! TTTT(w, a:mode)
          " TODO 無理やり例外を発生させる
          throw ':E426:'
        endif
      endif
      " 表示範囲を最適化
      exe "normal! z\<CR>" . (winheight(0)/4) . "\<C-y>"
      " カーソル位置を調整 (C専用)
      call PostTagJumpCursor_C()
      let g:TagMatch = matchadd('TagMatch', '\<'.w.'\>')
      let g:TimerTagMatch = timer_start(s:TagHighlightTime, 'TagHighlightDelete')
      let g:TagMatchI[g:TimerTagMatch] = g:TagMatch
      augroup ZZZZ
	au!
	au WinLeave * call TagHighlightDelete(g:TimerTagMatch)
      augroup end
      return 0
    catch /:E426:/
      if w0 =~ '^_'
	" 元の検索語は"_"始まり
	let w = substitute(w0, '^_', '', '')
      else
	" 元の検索語は"_"始まりでない
	let w = '_' . w0
      endif
      if i == 0
	" エラーメッセージ表示用にオリジナル単語でのエラー文字列を保存
      let exception = v:exception
      endif
    catch /:E433:/
      echohl ErrorMsg | echo matchstr(v:exception, 'E\d\+:.*') | echohl None
      return 1
    endtry
  endfor
  echohl ErrorMsg | echo matchstr(exception, 'E\d\+:.*') | echohl None
  return 1
endfunction

" カーソル位置を調整 (C専用)
function! PostTagJumpCursor_C()
  if search('\%##define\s\+\k\+(', 'bcn')
  "関数形式マクロ
    normal! ww
  elseif search('\%##define\s\+\k\+\s\+', 'bcn')
  "定数マクロ
    normal! ww
  elseif search('\%#.\+;', 'bcn')
  "変数
    normal! f;b
  else
    "関数
    normal! $F(b
  endif
endfunction

" 対象
"   カーソル下  ->  Normal mode デフォルト
"   Visual      ->  Visual mode デフォルト
"   (入力)      ->  対応なし

" タグ動作
"   直接ジャンプ -> なし
"   よきに計らう(タグの数次第で) -> デフォルトとする
"   強制選択

" ウィンドウ
"   そのまま
"   別ウィンドウ
"   プレビュー

" mode
"   s:select
"   p:preview
"   w:別ウィンドウ
"
" 最初の<Esc>がないと、prevcountをうまく処理できない。
nnoremap <silent> <CR>         <Esc>:call Unified_CR('')<CR>
nnoremap <silent> g<CR>        <Esc>:call Unified_CR('p')<CR>
nnoremap <silent> <Leader><CR> <Esc>:call Unified_CR('w')<CR>
nnoremap <silent> <C-CR>       <Esc>:call Unified_CR('s')<CR>
nnoremap <silent> <S-CR>       <Esc>:call Unified_CR('sp')<CR>
nnoremap <silent> <C-S-CR>     <Esc>:call Unified_CR('sw')<CR>
nnoremap          <C-S-CR>     <Esc>:tags<CR>;pop

nmap <BS><CR>     <Plug>(MyVimrc-Window-AutoSplit)<CR>
nmap <S-CR>       <Plug>(MyVimrc-Window-AutoSplit)<CR>
nmap <Leader><CR> <Plug>(MyVimrc-Window-AutoSplit-Rev)<CR>

" Tag, Jump, and Unified CR }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}



" Tag, Jump, and Unified CR {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{


" -----------------------------------------------------------------------------
" Unified_CR

" ------------------------------------------------------------
"   count付き実行されたら、count行へジャンプ。
"   qfならエラー元へジャンプ。
"   helpならリンクへジャンプ。
"   カーソルが数値上なら、基数変換。
"   それ以外なら、タグジャンプ。
"   失敗したら、マニュアルを引く。
"   失敗したら、Go File。
"   失敗したら、Go Define。
" ------------------------------------------------------------

" ------------------------------------------------------------
" 対象
"   カーソル下  ->  Normal mode デフォルト
"   Visual      ->  Visual mode デフォルト
"   (入力)      ->  対応なし

" タグ動作
"   直接ジャンプ -> なし
"   よきに計らう(タグの数次第で) -> デフォルトとする
"   強制選択

" ウィンドウ
"   そのまま
"   別ウィンドウ
"   プレビュー
" ------------------------------------------------------------

" TODO selectの扱い。   よきに計らう(タグの数次第で) -> デフォルトとする
" TODO 端末用に、もっと、モディファイア＋特殊キーを使わなくて良いようにする。

" ノーマル (最初の<Esc>がないと、prevcountをうまく処理できない。)
nnoremap <silent>         <CR>    <Esc>:call Unified_CR('')<CR>
" スプリット (端末では通常<S-CR>が使えないので、別のパターンを用意しておく。)
nmap                    <S-CR>    <Plug>(MyVimrc-Window-AutoSplit)<CR>
nmap                  <BS><CR>    <Plug>(MyVimrc-Window-AutoSplit)<CR>
nmap               <Space><CR>    <Plug>(MyVimrc-Window-AutoSplit)<CR>
" プレビュー
nnoremap <silent>       <C-CR>    :call Unified_CR('p')<CR>
" セレクト
nnoremap <silent>        g<CR>    :call Unified_CR('s')<CR>
" スプリットセレクト
nmap                   g<S-CR>    <Plug>(MyVimrc-Window-AutoSplit)g<CR>
" プレビューセレクト
nnoremap <silent>      g<C-CR>    <Esc>:call Unified_CR('sp')<CR>

" 引数のmodeは、次の文字をから構成される文字列。
"   s:select
"   p:preview
"   w:別ウィンドウ
function! Unified_CR(mode)

  " count付き実行されたら、count行へジャンプ。
  if v:prevcount
    "jumpする前に登録しないと、v:prevcountが上書されてしまう。
    call histadd('cmd', v:prevcount)
    "jumplistに残すために、Gを使用。
    exe 'normal!' v:prevcount . 'G'
    " TODO CFI
    return
  endif

  " qfならエラー元へジャンプ。
  if &buftype == 'quickfix'
    call feedkeys("\<CR>:FF2\<CR>", 'nt')
    return
  " helpならリンクへジャンプ。
  elseif &buftype == 'help'
    call feedkeys("\<C-]>", 'nt')
    return
  endif

  if 0
    " カーソルが数値上なら、基数変換。
    if EmIsNum()
      EmDispNoTimeOut
      " TODO Splitなら、別ウィンドウで表示。
      return
    endif
  endif

  let cword = expand('<cword>')

  " それ以外なら、タグジャンプ。
  if TagJump(cword, a:mode)
    return
  endif

  " TODO 暫定対応
  if &ft == 'vim' && isk !~ '#'
    set isk+=#
    let cword2 = expand('<cword>')
    let res = TagJump(cword2, a:mode)
    set isk-=#
    if res
      return
    endif
  endif

  " 失敗したら、マニュアルを引く。
  if s:lookup_in_man(cword)
    return
  endif

  " 失敗したら、Go File。
  if s:go_file_curfile(a:mode)
    return
  endif

  " 失敗したら、Go Define。
  keeppatterns normal! gd

endfunction


" -----------------------------------------------------------------------------
" マニュアルを引く

function! s:lookup_in_man(word)
  if &ft == 'vim'
    try
      exe 'help ' . a:word
      call TemporaryHighlightWord(a:word, v:false)
      return v:true
    catch /E149/  " Sorry no help for ...
    endtry
  endif
  return v:false
endfunction


" -----------------------------------------------------------------------------
" Go File

" カーソル下のファイルにgf
"
" go fileに
"   成功したら、true、
"   失敗したら、fals、
" を返す。
"
" TODO Preview対応
"
function! s:go_file_curfile(mode)
  if search('\%#\f', 'bcn')
    try
      normal! gf
      call popup_create('    Go  File    ' , #{
            \ line: 'cursor+3',
            \ col: 'cursor',
            \ posinvert: v:true,
            \ wrap: v:false,
            \ zindex: 200,
            \ highlight: 'SLFileName',
            \ border: [1, 1, 1, 1],
            \ borderhighlight: ['QuickFixLine'],
            \ moved: 'any',
            \ time: 2000,
            \ })
      return v:true
    catch /E447/
    finally
    endtry
  endif
  return v:false
endfunction


" -----------------------------------------------------------------------------
" Jump (Browsing)

nmap <C-p>      <Plug>(BrowserJump-Back)
nmap <C-n>      <Plug>(BrowserJump-Foward)

nmap <BS><C-p>  <Plug>(MyVimrc-Window-AutoSplit)<Plug>(MyVimrc-WinCmd-p)<C-p>
nmap <BS><C-n>  <Plug>(MyVimrc-Window-AutoSplit)<Plug>(MyVimrc-WinCmd-p)<C-n>


" Tag, Jump, and Unified CR }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}



" Tag_Test {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

"■仕様
"
" タグが1つならそれ
" 内部タグがあればそれ（内部タグ複数はない想定）
" 外タグなら
"   IncludeFilesに対して
"     1つならそれ
"     同Dirに1つならそれ
"     下位Dirに1つならそれ
"     TODO: ファイル名の特徴から推測
"   非IncludeFilesに対して
"     同Dirに1つならそれ
"     下位Dirに1つならそれ
"     TODO: ファイル名の特徴から推測
" ユーザ選択
"

function! GetTags(word)
 "echo len(taglist(expand('<cword>')))
 "let word = expand('<cword>')
 "let taglist = len(taglist(word))
  let taglist = taglist(a:word)
  let num_tag = len(taglist)
  PrettyPrint taglist
  echo num_tag
endfunction

com! GetTags call GetTags(expand('<cword>'))


function! GetIncludeFiles(file)
  let inclist = execute('checkpath!')
  "echo inclist
  let incs = split(inclist, '\n')
  call remove(incs, 0)
  call filter(incs, { idx, val -> val !~ '-->$' })
  call filter(incs, { idx, val -> val !~ ')$' })  " '(既に列挙)'行を削除
  call filter(incs, { idx, val -> val !~ '"\f\+"' })  " '見つかりません'行を削除
  "PrettyPrint incs

  return incs
endfunction

com! GetIncludeFiles call GetIncludeFiles(expand('%f'))

function! TTTT(word, mode)
  let taglist = taglist(a:word)
  "PrettyPrint taglist

  " タグが1つならそれ
  if len(taglist) == 1
    "return v:false
    exe 'tag' a:word
    return v:true
  endif

  let cmd_tag     = (a:mode =~? 'w' ? 's' : '') . 'tag'
  let cmd_tselect = (a:mode =~? 'w' ? 's' : '') . 'tselect'

  let t_file = range(len(taglist))

  " 内部タグがあればそれ（内部タグ複数はない想定）
  let cur_file = expand('%:p')
  for i in range(len(taglist))
    let t_file = fnamemodify(taglist[i]['filename'], ':p')
    " cache
    "let t_file[i] = fnamemodify(taglist[i]['filename'], ':p')
    if t_file == cur_file
      "exe i (a:mode =~? 'w' ? 's' : '')) . 'tag' a:word
      exe i cmd_tag a:word
      return v:true
    endif
    "echo i
  endfor

  "   IncludeFilesに対して
  let incs = GetIncludeFiles(expand('%f'))

  for i in range(len(taglist))
    "let t_file = fnamemodify(taglist[i]['filename'], ':p')
    for j in incs
      " TODO
      let inc = substitute(j, ' \+', '', 'g')
      let inc_file = fnamemodify(inc, ':p')
      "echo inc_file
      if t_file == inc_file
        "exe i (a:mode =~? 'w' ? 's' : '')) . 'tag' a:word
        exe i cmd_tag a:word
        return v:true
      endif
    endfor
    "echo i
  endfor

  " TODO
  "exe (a:mode =~? 'w' ? 's' : '')) . 'tselect' a:word
  exe cmd_tselect a:word

  """  "let num_tag = len(taglist)
  """  "echo num_tag

  """  "let org_dir = getcwd()

  """  if 0
  """    if 0
  """      for i in tagfiles()
  """        let dir = fnamemodify(i, ':h')
  """        echo dir
  """      endfor
  """    else
  """      let dir = GetPrjRoot()
  """    endif
  """  endif

  """  "exe 'cd ' . org_dir

  return v:false
endfunction

function! TTTT(word, mode)
  "let org_dir = getcwd()

  "if 0
  "  for i in tagfiles()
  "    let dir = fnamemodify(i, ':h')
  "    echo dir
  "  endfor
  "else
  "  let dir = GetPrjRoot()
  "endif
  "exe 'cd ' . dir

  let taglist = taglist('\<' . a:word . '\>')
  "PrettyPrint taglist

  "exe 'cd ' . org_dir

  if len(taglist) == 0
    return v:false
  endif

  let cmd_tag     = (a:mode =~? 'p' ? 'p' : (a:mode =~? 'w' ? 's' : '')) . 'tag'
  let cmd_tselect = (a:mode =~? 'p' ? 'p' : (a:mode =~? 'w' ? 's' : '')) . 'tselect'
  if a:mode =~? 's'
    let cmd_tag = cmd_tselect
  endif

  " タグが1つならそれ
  if len(taglist) == 1
    "return v:false
    exe cmd_tag a:word
    return v:true
  endif

  " 内部タグがあればそれ（内部タグ複数はない想定）
  let cur_file = expand('%:p')
  " カレントディレクトリ相対にしないと、ctagsとDOSでパスの形式が異なる。
  let cur_file = fnamemodify(cur_file, ':.')

  for i in range(len(taglist))
    let t_file = taglist[i]['filename']
    let t_file = fnamemodify(t_file, ':.')

     "echo '^r' t_file '$'
     "echo '^r' cur_file '$'
     "echo '^m' fnamemodify(t_file, ':.') '$'
     "echo '^m' fnamemodify(cur_file, ':.') '$'

    if t_file == cur_file
      "echo i
      exe i+1 cmd_tag a:word
      return v:true
    endif
    "echo i
  endfor

  "   IncludeFilesに対して

  "let dir = GetPrjRoot()
  "exe 'cd ' . dir
  let incs = GetIncludeFiles(expand('%f'))
  "exe 'cd ' . org_dir

  for i in range(len(taglist))
    let t_file = taglist[i]['filename']
    for j in incs
      " TODO Trim
      let inc = substitute(j, ' \+', '', 'g')

      let inc_file = inc
      "echo inc_file
      if t_file == inc_file
        " echo i
        " echo taglist[i - 1]
        " echo taglist[i    ]
        " echo taglist[i + 1]
        " sleep 2
        exe i+1 cmd_tag a:word
        return v:true
      endif
    endfor
    "echo i
  endfor

  exe cmd_tselect a:word

  return v:true
endfunction

com! TTTT call TTTT(expand('<cword>'), '')

if 0
  augroup TTTT
    au!
    au CursorHold *.[ch] nested exe "silent! psearch " . expand("<cword>")
  augroup end
  set previewpopup=
else
  augroup TTTT
    au!
  augroup end
endif

" Tag_Test }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}
