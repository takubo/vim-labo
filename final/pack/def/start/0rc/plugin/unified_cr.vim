vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8


#=============================================================================================
# Unified CR
#=============================================================================================


#---------------------------------------------------------------------------------------------
# Mapping

nnoremap <silent> <CR> <ScriptCmd>Unified_CR('')<CR>


#---------------------------------------------------------------------------------------------
# Unified CR

def Unified_CR(mode: string)
  # 行番号へジャンプ
  if v:count != 0
    GotoLine(v:count)
    return
  endif

  # CommandLine-Window
  if getcmdwintype() != ''
    feedkeys("\<CR>", 'nt')
    return
  endif

  # これらは、Buffer Local Map.
  # &buftype == 'quickfix'
  # &buftype == 'help'

  # 数値の情報を表示 TODO
  #if EmIsNum()
  #  EmDispNoTimeOut
  #  return
  #endif

  const cword = expand('<cword>')
  #if cword == ''
  if cword !~# '\k\+'
    return
  endif
  cword -> TempHighLightWord()

  # Tag Jump
  if TagJump(mode)
    return
  endif

  # VimのHelpを引く
  if &ft == 'vim' && VimHelp()
    return
  endif

  # gF相当
  if GotoFile()
    return
  endif

  # 定義へジャンプ
  if GoToDefinition()
    return
  endif
enddef


#---------------------------------------------------------------------------------------------
# Go to Line

def GotoLine(line: number = v:count)
  # jumplistに残すために、Gを使用。
  exe 'normal!' line .. 'G'
  histadd('cmd', line .. '')
  CursorJumped
enddef


#---------------------------------------------------------------------------------------------
# Tag Jump

def TagJump(mode: string): bool
  const cword = expand('<cword>')

  if cword !~# '\<\i\+\>'
    return 0
  endif

  # エラーメッセージ表示用にオリジナル単語でのエラー文字列を保存
  var err_msg = TagJumpSub(mode, cword)

  # 先頭のアンダーバーを切り替えて、再検索。 (C <--> Assembly)
  if err_msg != ''
    const nword = cword =~ '^_' ?
                  # 元の検索語は"_"始まり。
                  substitute(cword, '^_', '', '') :
                  # 元の検索語は"_"始まりでない。
                  '_' .. cword

    err_msg = TagJumpSub(mode, nword)
  endif

  if err_msg != ''
    # TODO
    # エラーメッセージ表示用にオリジナル単語でのエラー文字列を保存
  endif

  return err_msg == ''
enddef

def TagJumpSub(mode: string, word: string): string
  var err_msg = ''

  try
    if 1
      if mode =~? 's'
        exe (mode =~? 'p' ? 'p' : (mode =~? 'w' ? 's' : '')) .. "tselect " .. word
      else
        exe (mode =~? 'p' ? 'p' : (mode =~? 'w' ? 's' : '')) .. "tjump " .. word
      endif
    else
      if ! TagJumpExe(word, mode)
        # 無理やり例外を発生させる
        throw ':E426:'
      endif
    endif

    # 表示範囲を最適化
    exe "normal! z\<CR>" .. (winheight(0) / 4) .. "\<C-y>"
    # カーソル位置を調整 (C専用)
    PostTagJumpCursor_C()

    TempHighLightWord(word)
  catch /:E426:/
    err_msg = v:exception
  catch /:E433:/
    #echoerr matchstr(v:exception, 'E\d\+:.*')
    err_msg = v:exception
  endtry
  # echohl ErrorMsg | echo matchstr(exception, 'E\d\+:.*') | echohl None

  return err_msg
enddef

# TODO
def TagJumpExe(word: string, mode: string): bool
  const cur_file = expand('%:p')

  const taglist = taglist('^' .. word .. '$', cur_file)

  if len(taglist) == 0
    return false
  endif

  var   cmd_tag     = (mode =~? 'p' ? 'p' : (mode =~? 'w' ? 's' : '')) .. 'tag'
  const cmd_tselect = (mode =~? 'p' ? 'p' : (mode =~? 'w' ? 's' : '')) .. 'tselect'
  if mode =~? 's'
    cmd_tag = cmd_tselect
  endif


  ### タグが1つならそれ
  if len(taglist) == 1
    exe cmd_tag word
    return true
  endif


  ### 内部タグがあればそれ（内部タグ複数はない想定）

  #? const cur_file_dos = fnamemodify(cur_file, ':.')  # カレントディレクトリ相対にしないと、ctagsとDOSでパスの形式が異なる。
  #?
  #? const cur_file_tag_idx = taglist ->
  #?        \ mapnew((_, v) => v.filename = fnamemodify(v.filename, ':.')) ->  # カレントディレクトリ相対
  #?        \ indexof((_, v) => v.filename == cur_file)

  const cur_file_tag_idx = taglist -> indexof((_, v) => v.filename == cur_file)

  if cur_file_tag_idx != -1
    exe cur_file_tag_idx + 1 cmd_tag word
    return true
  endif


  ### include files に対して探索

  #                                       TODO Trim
  const inclist = GetIncludeFiles(expand('%f')) -> map((_, v) => substitute(v, ' \+', '', 'g'))

  const inc_file_tag_idx = taglist -> indexof(
                                        (_, t) =>
                                          inclist -> indexof((_, i) => i == t.filename)
                                        != -1
                                      )

  if inc_file_tag_idx != -1
    exe inc_file_tag_idx + 1 cmd_tag word
    return true
  endif


  exe cmd_tselect word

  return true
enddef


def GetIncludeFiles(file: string): list<string>
  # TODO checkpathが遅すぎる
  const inclist = execute('checkpath!')

  var incs = split(inclist, '\n')

  remove(incs, 0)
  filter(incs, (_, val) => val !~ '-->$'  )
  filter(incs, (_, val) => val !~ ')$'    )  # '(既に列挙)'行を削除
  filter(incs, (_, val) => val !~ '"\f\+"')  # '見つかりません'行を削除

  return incs
enddef

com! GetIncludeFiles echo GetIncludeFiles(expand('%f')) -> join("\n")

# カーソル位置を調整 (C専用)
def PostTagJumpCursor_C()
  if &ft == 'c' || &ft == 'h' || &ft == 'cpp'
  else
    return
  endif

  if search('\%##define\s\+\k\+(', 'bcn') != 0
    # 関数形式マクロ
    normal! ww
  elseif search('\%##define\s\+\k\+\s\+', 'bcn') != 0
    # 定数マクロ
    normal! ww
  elseif search('\%#.\+;', 'bcn') != 0
    # 変数
    normal! f;b
  else
    # 関数
    normal! $F(b
  endif
enddef


#---------------------------------------------------------------------------------------------
# Vim Help

# Helpの呼び出しに成功したら、非0を返す。
def VimHelp(): bool
  try
    const word = expand('<cword>')

    # オプション, 組み込み関数(BIF), その他を分ける
    var prefix = ''
    var sufix = ''

    if VimHelp_OnBIF()
      sufix = '()'
    elseif VimHelp_OnOpt()
      prefix = "'"
      sufix  = "'"
    endif

    exe 'help ' .. prefix .. word .. sufix

    TempHighLight(word, 1200)
    return true
  catch /:E149/
  endtry

  return false
enddef

def VimHelp_OnBIF(): bool
  return search('\%#[^[:keyword:]]*\k\+(', 'bcn', line('.')) != 0
enddef

def VimHelp_OnOpt(): bool
  return search('\%#[^[:keyword:]]*&\%(l:\)\?\k\+', 'bcn', line('.')) != 0
      || search('&\%#\%(l:\)\?\k\+', 'bcn', line('.')) != 0
      || search('&\%(l\%#:\)\?\k\+', 'bcn', line('.')) != 0
      || search('&\%(l:\)\?\%#\k\+', 'bcn', line('.')) != 0
      || search('\<\W*se\%[t[gl]]\>\s*\k*\%#\k\+', 'bcn', line('.')) != 0
      || search('\<\W*se\%[t[gl]]\>\s*\%#\s*\k\+', 'bcn', line('.')) != 0
enddef


#---------------------------------------------------------------------------------------------
# Go to File

def GotoFile(): bool
  #if search('\%#\f', 'bcn') != 0
  #endif
  try
    normal! gF
    popup_create('    Go  File    ', {
          line: 'cursor+3',
          col: 'cursor',
          posinvert: v:true,
          wrap: v:false,
          zindex: 200,
          highlight: 'QuickFixLine',
          border: [1, 1, 1, 1],
          borderhighlight: ['Search'],
          moved: 'any',
          time: 2000,
          })
    return true
  catch /E447/
  endtry
  return false
enddef


#---------------------------------------------------------------------------------------------
# Go to Definition

def GoToDefinition(): bool
  # keeppatterns normal! gd

  const word = expand('<cword>')

  if !searchdecl(word, 1, 1)
    # 表示範囲を最適化 TODO

    TempHighLightWord(word)
    return true
  endif

  return false
enddef



#=============================================================================================
# TempHighLight.vim

var MatchDelete = null_function
var TimerId = 0

hi TempHighLight	guibg=#c0504d	guifg=white

augroup TempHighLight
  au!
  au ColorScheme * hi TempHighLight	guibg=#c0504d	guifg=white
  au WinLeave * TempHighLightDelete(0)
augroup end

def TempHighLight(str: string, time: number = 1500)
  TempHighLightDelete(0)  # 古いのを一旦消す。
  MatchDelete = function('matchdelete', [matchadd('TempHighLight', str), win_getid()])
  TimerId = timer_start(time, TempHighLightDelete)
enddef

def TempHighLightWord(str: string, time: number = 1500)
  TempHighLight('\<' .. str .. '\>', time)
enddef

def TempHighLightDelete(_: number)
  if MatchDelete != null_function
    MatchDelete()
    MatchDelete = null_function
  endif
  if TimerId != 0
    timer_stop(TimerId)
    TimerId = 0
  endif
enddef



finish



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

      let g:TagMatch = matchadd('TagMatch', '\<' . expand('<cword>') . '\>')
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
      if 1
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
function! JumpToDefinition(mode)
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



# var TimerStop = null_function
  #TimerStop = function('timer_stop', [timer_start(1500, Callback)])

# TempHighLight('def')


# function! TempHighLight()
#   let w = expand("<cword>")
#   let g:TagMatch0 = matchadd('TagMatch', '\<'.w.'\>')
#   let g:TimerTagMatch0 = timer_start(1500, 'QQQQ')
#   let g:TagMatchI[g:TimerTagMatch0] = g:TagMatch0
# endfunction
