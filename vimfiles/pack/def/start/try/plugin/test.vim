vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8



finish



#---------------------------------------------------------------------------------------------

augroup MyVimrc_ModeShowTTTT
  au!
  # au ModeChanged *:v  :2echowindow 'Visual Character'
  # au ModeChanged *:V  :2echowindow 'Visual Line'
  # au ModeChanged *: :2echowindow 'Visual Block'
augroup end



# ----------------------------------------------------------------------------------------------------
import autoload "popup_info.vim" as pui

com! PuCenter call pui.PopUpInfoMC([ "RRR:   RRRRRRR", "WWWW: 66666666" ], -1)

# nnoremap ; <ScriptCmd>call pui.PopUpInfo(" Command Line ", 2500, 2, 2)<CR>:



#---------------------------------------------------------------------------------------------

nnoremap U <C-R>



#---------------------------------------------------------------------------------------------
def CWord()
  echo search('\%#[^[:keyword:]]*\k\+', 'bcn', line('.'))
enddef
com! CWord CWord()

def VimHelp_OnBIF_Test()
  echo search('\%#[^[:keyword:]]*\k\+(', 'bcn', line('.'))
enddef
com! VimHelpOnBIF VimHelp_OnBIF_Test()

def VimHelp_OnOpt_Test()
  echo search('\%#[^[:keyword:]]*&\%(l:\)\?\k\+', 'bcn', line('.'))
  echo search('&\%#\%(l:\)\?\k\+', 'bcn', line('.'))
  echo search('&\%(l\%#:\)\?\k\+', 'bcn', line('.'))
  echo search('&\%(l:\)\?\%#\k\+', 'bcn', line('.'))
  echo search('\<se\%[t[gl]]\>\s*\%#s*\k\+', 'bcn', line('.'))
enddef
com! VimHelpOnOpt VimHelp_OnOpt_Test()

# &path


#---------------------------------------------------------------------------------------------

set smoothscroll

def Scroll_0(dir: number)
  #const n = win_getid() -> getwininfo()[0].height * 1 / 3
  const n = winheight(0) / 3

  set nocursorcolumn
  #set nocursorline

  const k = dir > 0 ? "\<C-E>2gj" : "\<C-Y>2gk"

  range(n) -> map((_, _) => { # TODO foreach
    execute("normal! 2" .. k)
    redraw
    return 0
  })

  #range(n) -> map((_, _) => { # TODO foreach
  #  execute("normal! 2\<c-e>2gj")
  #  redraw
  #  return 0
  #})

  #for i in range(n)
  #  #execute "normal! 1\<c-d>"
  #  execute "normal! \<c-e>gj"
  #  redraw
  #endfor

  set cursorcolumn
  #set cursorline
enddef

def Scroll_1(dir: number)
  const n = winheight(0) / 3

  set nocursorcolumn

 #const k = dir > 0 ? "2\<C-E>2gj" : "2\<C-Y>2gk"
  const k = dir > 0 ? "\<C-E>gj" : "\<C-Y>gk"

  for i in range(n)
    var u = getchar(1)
    if dir > 0 && u == 'k' || dir < 0 && u =='j'
      break
    endif
    execute("normal! " .. k)
    redraw
  endfor

  set cursorcolumn
enddef

def Scroll_2(dir: number)
  const n0 = winheight(0) / 3
  var n = n0

  set nocursorcolumn

  const k = dir > 0 ? "2\<C-E>2gj" : "2\<C-Y>2gk"
  # const k = dir > 0 ? "\<C-E>gj" : "\<C-Y>gk"

  while true
    while n > 0
      var u = getchar(0) -> nr2char()
      if dir > 0 && u == 'k' || dir < 0 && u == 'j'
        return
      endif
      if dir < 0 && u == 'k' || dir > 0 && u == 'j'
        n += n0
      endif
      execute("normal! " .. k)
      redraw
      sleep 1m
      n -= 1
    endwhile

    var u = getchar(0) -> nr2char()
    if dir > 0 && u == 'k' || dir < 0 && u == 'j'
      return
    endif
    if dir < 0 && u == 'k' || dir > 0 && u == 'j'
      n += n0
    endif

  endwhile

  set cursorcolumn
enddef


#nnoremap <C-D> <ScriptCmd>Scroll(+1)<CR>
#nnoremap <C-U> <ScriptCmd>Scroll(-1)<CR>
nnoremap <Plug>(C-D) <ScriptCmd>Scroll(+1)<CR>
nnoremap <Plug>(C-U) <ScriptCmd>Scroll(-1)<CR>

#submode#enter_with('VertScrollDn', 'nv', '', 'gj', '<Cmd>Scroll(+1)<CR>')
#submode#enter_with('VertScrollUp', 'nv', '', 'gk', '<Cmd>Scroll(-1)<CR>')
#submode#map(       'VertScrollDn', 'nv', '',  'j', '<Cmd>Scroll(+1)<CR>')
#submode#map(       'VertScrollUp', 'nv', '',  'k', '<Cmd>Scroll(-1)<CR>')
#submode#enter_with('VertScrollDn', 'nv', '', 'gj', '<Plug>(C-D)')
#submode#enter_with('VertScrollUp', 'nv', '', 'gk', '<Plug>(C-U)')
#submode#map(       'VertScrollDn', 'nv', '',  'j', '<Plug>(C-D)')
#submode#map(       'VertScrollUp', 'nv', '',  'k', '<Plug>(C-U)')


#---------------------------------------------------------------------------------------------

#=============================================================================================
# EscEsc
#=============================================================================================

if 0

com! -nargs=0 -bar EscEsc {
    # 'noh'は自動コマンド内では(事実上)実行出来ないので、別途実行の要あり。
    noh
    doautocmd nomodeline User EscEsc
  }

# EscEsc内のdoautocmdがエラーにならないよう、1つは自動コマンドを設定しておく。
augroup EscEscDefault
  au!
  # コマンドラインモードへの出入りを行うことで、iminsert(or imcmdline?)の効果で、IMEがOFFされる。
  au User EscEsc normal! :<Esc>
augroup end

nnoremap <silent> <Plug>(EscEsc) <Cmd>EscEsc<CR>
nnoremap <silent> <Plug>(EscEsc) <Cmd>EscEsc<CR><Cmd>noh<CR>


#---------------------------------------------------------------------------------------------
# EscEsc

# EscEsc内のdoautocmdがエラーにならないよう、1つは自動コマンドを設定しておく。
augroup EscEscDefault
  au!
  # コマンドラインモードへの出入りを行うことで、iminsert(or imcmdline?)の効果で、IMEがOFFされる。
  au User EscEsc normal! :<Esc>
augroup end

# 'noh'は自動コマンド内では(事実上)実行出来ないので、別途実行の要あり。 TODO  doautocmd nomodeline User
nnoremap <Esc><Esc> <Cmd>doautocmd User EscEsc<CR><Cmd>noh<CR>

else


nnoremap <Esc><Esc> <Cmd>doautocmd User EscEsc<CR><Cmd>noh<CR><Cmd>normal! :<lt>Esc><CR>


endif


#---------------------------------------------------------------------------------------------
# Case Motion

def CaseMotion_0(dir: number, mode: string)
  #echo ""

  #? if search('\%#\k', 'bcn', line('.')) == 0
  #?   return
  #? endif

  # 記号列の先頭 (アンダーバー除く)
  if search('\%#[_[:alnum:]]\+\zs\k\@=_\@![[:punct:]]', '', line('.')) != 0
    #echo "$$$"
    return
  endif
# abc_def  abc#def abc__def  abc###def abc-def G
# RAMCheck RAM RR175 GET_MAN GET#REM  GET-K RR175BB Check___R Check###R Check###5
# RAMCheck#RRT

  # 記号の後の英数字
  if search('\%#\k\{-}[[:punct:]]\zs\k\@<=[[:alnum:]]', '', line('.')) != 0
    #echo "%%%"
    return
  endif

  # パート先頭の大文字
  if search('\%#\k\{-1,}\zs[A-Z]\k\@=[a-z]', '', line('.')) != 0
    #echo "rrr1"
    return
  endif
  if search('\%#\k\{-1,}\zs[^A-Z]\@<=[A-Z]', '', line('.')) != 0
    #echo "rrr2"
    return
  endif

  #if search('\%#\k\{-}\zs[A-Z]\@<![A-Z][^A-Z]', '', line('.')) != 0
  #  echo "rrr"
  #  return
  #endif

  #echo "######"
  normal! w

  # const cc = GetCursorChar()

  # if cc =~# '[A-Z]'
  #   echo "######"
  #   if search('[A-Z]sakiyomi\k[^A-Z]', '', line('.')) == 0
  #     normal! w
  #   endif
  # elseif cc =~# '[[:alnum:]]'
  # else
  #   # 記号の上
  # endif
enddef

def CaseMotion_1(dir: number, mode: string)
  echo ''

  #? if search('\%#\k', 'bcn', line('.')) == 0
  #?   return
  #? endif

  const or = '\|'
  const b = '\%('
  const e = '\)'

  var pat = ''

  # 記号列の先頭 (アンダーバー除く)
  pat ..= b .. '\%#[_[:alnum:]]\+\zs\k\@=_\@![[:punct:]]' .. e

  pat ..= or

  # 記号の後の英数字
  pat ..= b .. '\%#\k\{-}[[:punct:]]\zs\k\@<=[[:alnum:]]' .. e

  pat ..= or

  # パート先頭の大文字
  pat ..= b .. '\%#\k\{-1,}\zs[A-Z]\k\@=[a-z]' .. e

  # pat ..= or

  if search(pat, 'z', line('.')) != 0
    echo "%%%%%%"
    return
  endif

  echo "######"
  normal! w
enddef

def CaseMotion_W_0(dir: number, mode: string)
  # echo ''

  # if search('\%#\k', 'bcn', line('.')) == 0
  #   return
  # endif

  const pat = [
    # 記号列の先頭 (アンダーバー除く)
    # TODO punctは句読点だけか？
    #'\%#[_[:alnum:]]\+\zs\k\@=_\@![[:punct:]]',

    # 記号の後の英数字
    '\%#\k\{-}[[:punct:]]\zs\k\@<=[[:alnum:]]',

    # パート先頭の大文字
    '\C\%#\k\{-1,}\zs[A-Z]\k\@=[a-z]',
  ]

  const pos = pat -> mapnew((_, v) => searchpos(v, 'nz', line('.'))) -> map((_, v) => v[1]) -> filter((_, v) => v != 0)
  #echo pos

  const ini = col('$') + 1
  const min_col = pos -> reduce((acc, val) => acc > val ? val : acc, ini)
  #echo min_col

  if min_col != ini
    # echo "%%%%%%"
    setpos('.', [bufnr(), line('.'), min_col, 0])
  else
    # echo "######"
    normal! w
  endif

  #if search(pat, 'z', line('.')) != 0
  #  echo "%%%%%%"
  #  return
  #endif
enddef

def CaseMotion_B_0(dir: number, mode: string)
  echo ''

  #? if search('\%#\k', 'bcn', line('.')) == 0
  #?   return
  #? endif

  const pat = [
    # 記号列の先頭 (アンダーバー除く)
    '\%#[_[:alnum:]]\+\zs\k\@=_\@![[:punct:]]',

    # 記号の後の英数字
    '\%#\k\{-}[[:punct:]]\zs\k\@<=[[:alnum:]]',

    # パート先頭の大文字
    '\%#\k\{-1,}\zs[A-Z]\k\@=[a-z]',
  ]

  const pos = pat -> mapnew((_, v) => searchpos(v, 'nz', line('.'))) -> map((_, v) => v[1]) -> filter((_, v) => v != 0)
  #echo pos

  const ini = col('$') + 1
  const min_col = pos -> reduce((acc, val) => acc > val ? val : acc, ini)
  #echo min_col

  if min_col != ini
    echo "%%%%%%"
    setpos('.', [bufnr(), line('.'), min_col, 0])
  else
    echo "######"
    normal! w
  endif

  #if search(pat, 'z', line('.')) != 0
  #  echo "%%%%%%"
  #  return
  #endif
enddef

def CaseMotion_E_0(dir: number, mode: string)
  # echo ''

  # if search('\%#\k', 'bcn', line('.')) == 0
  #   return
  # endif

  const pat = [
    # # 記号列の先頭 (アンダーバー除く)
    # #'\%#[_[:alnum:]]\+\zs\k\@=_\@![[:punct:]]',

    # # 記号の後の英数字
    # '\%#\k\{-}[[:punct:]]\zs\k\@<=[[:alnum:]]',

    # # パート先頭の大文字
    # '\%#\k\{-1,}\zs[A-Z]\k\@=[a-z]',


    #'\%#\k\{-1,}\zs[[:alnum:]]_',
    #'\%#\k\{-1,}\zs[[:keyword:]]\>',


    # 大文字の手前の、小文字か数字
    '\C\%#\k\{-1,}\zs[a-z0-9]\u',
    '\C\%#\S\s\+\k\{-1,}\zs[a-z0-9]\u',

    # 記号の手前の英数字
    '\%#\w\{-1,}\zs\w[[:punct:]]\@=\k\@=',
    '\%#\S\s\+\k\{-1,}\zs\w[[:punct:]]\@=\k\@=',


    #'\%#\k\\+\zs[a-z0-9]',
  ]

  const pos = pat -> mapnew((_, v) => searchpos(v, 'nz', line('.'))) -> map((_, v) => v[1]) -> filter((_, v) => v != 0)
  echo pos

  const ini = col('$') + 1
  const min_col = pos -> reduce((acc, val) => acc > val ? val : acc, ini)
  echo min_col

  if min_col != ini
    #echo "%%%%%%"
    setpos('.', [bufnr(), line('.'), min_col, 0])
  else
    #echo "######"
    normal! e
  endif

  #if search(pat, 'z', line('.')) != 0
  #  echo "%%%%%%"
  #  return
  #endif
enddef

def CaseMotion_W(dir: number, mode: string)
  # echo ''

  const pat = [
    # 記号列の先頭 (アンダーバー除く)
    # TODO punctは句読点だけか？
    '\%#[_[:alnum:]]\+\zs\k\@=_\@![[:punct:]]',

    # 記号の後の英数字
    '\%#\k\{-}[[:punct:]]\zs\k\@<=[[:alnum:]]',

    # パート先頭の大文字
    '\C\%#\k\{-1,}\zs[A-Z]\k\@=[a-z]',
  ]

  const pos = pat -> mapnew((_, v) => searchpos(v, 'nz', line('.'))) -> map((_, v) => v[1]) -> filter((_, v) => v != 0)
  #echo pos

 #const ini = col('$') + 1
  const ini = col('$')
  const min_col = pos -> reduce((acc, val) => acc > val ? val : acc, ini)
  #echo min_col

  if min_col != ini
    # echo "%%%%%%"
    setpos('.', [bufnr(), line('.'), min_col, 0])
  else
    # echo "######"
    normal! w
  endif
enddef

def CaseMotion_E(dir: number, mode: string)
  # echo ''

  const pat = [
    # 大文字の手前の、小文字か数字
    '\C\%#\k\{-1,}\zs[a-z0-9]\u',                # カーソルが単語内
    '\C\%#\S\s\+\k\{-1,}\zs[a-z0-9]\u',          # カーソルが単語末尾。なので、次の単語で探す。

    # 記号の手前の英数字
    '\%#\w\{-1,}\zs\w[[:punct:]]\@=\k\@=',       # カーソルが単語内
    '\%#\S\s\+\k\{-1,}\zs\w[[:punct:]]\@=\k\@=', # カーソルが単語末尾。なので、次の単語で探す。
  ]

  const pos = pat -> mapnew((_, v) => searchpos(v, 'nz', line('.'))) -> map((_, v) => v[1]) -> filter((_, v) => v != 0)
  # echo pos

 #const ini = col('$') + 1
  const ini = col('$')
  const min_col = pos -> reduce((acc, val) => acc > val ? val : acc, ini)
  # echo min_col

  if min_col != ini
    #echo "%%%%%%"
    setpos('.', [bufnr(), line('.'), min_col, 0])
  else
    #echo "######"
    normal! e
  endif
enddef

def CaseMotion_B(dir: number, mode: string)
  # echo ''

  const pat = [
    # パート先頭の大文字 TODO
    #'\C\u\%(\k\+\%#\)\@=\U\+\%#',                     # カーソルが単語内  OK
    #'\C\u\%(\k\+\%#\)\@=\U\+[^[:punct:]]\%#',                     # カーソルが単語内  OK

    #'\C\u\%(\k\+\%#\)\@=\k\+\[[:punct:]]\%#',                     # カーソルが単語内

    #'\C\u\%(\k\+\%#\)\@=\k\+\u\@<!\[[:punct:]]\+\%#',                     # カーソルが単語内
    #'\C\u\%(\k\+\%#\)\@=\%(\U\+\|\w\+\[[:punct:]]\)\%#',                     # カーソルが単語内
    #'\C\%#\S\s\+\k\{-1,}\zs[a-z0-9]\u',          # カーソルが単語末尾。なので、次の単語で探す。

   #'\C\u\%(\k\+\%#\)\@=[\u\d]\+[[:punct:]]\+\%#',    # カーソルが単語内

    #'\C\U\zs\u\%(\k\+\s\+\%#\)\@=\U\+\s\+\%#',   # カーソルが単語内 TODO

    # パート先頭の大文字 TODO
    '\C\u\%(\k\+\%#\)\@=\U\+[[:punct:]]\+\%#',               # カーソルが単語内
    '\C\U\zs\u\%(\k\+\%#\)\@=[0-9A-Z]*[[:punct:]]\+\%#',     # カーソルが単語内
    '\C\zs\u\%(\k\+\%#\)\@=[0-9a-z]\+\%#',                   # カーソルが単語内

    '\C\u\%(\k\+\s\+\%#\)\@=[0-9A-Z]*[[:punct:]]*\s\+\%#',   # カーソルが単語先頭。なので、前の単語で探す。
    '\C\u\%(\k\+\s\+\%#\)\@=[0-9a-z]\+[[:punct:]]*\s\+\%#',  # カーソルが単語先頭。なので、前の単語で探す。

    # 記号の後の英数字 TODO
    '[[:punct:]]\@<=\k\@<=[[:alnum:]]\{-1,}\%#',      # カーソルが単語内
    '[[:punct:]]\@<=\k\@<=[[:alnum:]]\k\{-}\%#',      # カーソルが単語内

    '[[:punct:]]\@<=\k\@<=[[:alnum:]]\{-1,}\s\+\%#',  # カーソルが単語先頭。なので、前の単語で探す。
    '[[:punct:]]\@<=\k\@<=[[:alnum:]]\k\{-}\s\+\%#',  # カーソルが単語先頭。なので、前の単語で探す。

    # TODO 行頭 行末
  ]

  const pos = pat -> mapnew((_, v) => searchpos(v, 'bn', line('.'))) -> map((_, v) => v[1]) -> filter((_, v) => v != 0)
  echo pos

  const ini = 0
  const min_col = pos -> reduce((acc, val) => acc < val ? val : acc, ini)
  # echo min_col

  if min_col != ini
    #echo "%%%%%%"
    setpos('.', [bufnr(), line('.'), min_col, 0])
  else
    #echo "######"
    normal! b
  endif
enddef

# abc_def  abc#def abc__def  abc###def abc-def G
# RAMCheck RAM RR175 GET_MAN GET#REM  GET-K RR175BB Check___R Check###R Check###5
# RAMCheck_RRT
# RamCheck#RRT  KTR_WER_QAS  ktr_wer_qas
# RamCheck_RRT RAMCheck Ram100Check100_RRT  KTR100_R_WER_QAS  k1tr_wer100_qas

com! GGG CaseMotion_W(1, "")
nnoremap W <Cmd>GGG<CR>

nnoremap W <Cmd>call <SID>CaseMotion_W(1, "")<CR>
nnoremap E <Cmd>call <SID>CaseMotion_E(1, "")<CR>
nnoremap B <Cmd>call <SID>CaseMotion_B(1, "")<CR>


#---------------------------------------------------------------------------------------------

augroup AAA
  au!
  #au QuickFixCmdPost * echo getqflist({'title': 0}).title
  #au QuickFixCmdPost * redraw
  #au QuickFixCmdPost * sleep 2
augroup end



#---------------------------------------------------------------------------------------------
# Break Point Sign

def InitBreakPoint()
  hi hlBreakPointText		guifg=#f62300	guibg=NONE	gui=NONE	cterm=NONE
  hi hlBreakPointLine		guifg=NONE	guibg=#ccaa22	gui=NONE	cterm=NONE
  sign define BreakPoint text=* texthl=hlBreakPointText linehl=hlBreakPointLine
enddef

def PlaceBreakPoint()
  sign_place(0, 'BP', 'BreakPoint', bufnr(), {'lnum': line('.')})
enddef

def UnPlaceBreakPoint()
  sign unplace group=BP
enddef

InitBreakPoint()
com!   SetBP call <SID>PlaceBreakPoint()
com! UnSetBP call <SID>UnPlaceBreakPoint()



#---------------------------------------------------------------------------------------------

def BufSummary(): string
  for l in range(1, line('$'))
    const c = getline(l)
    if c != ''
      return c -> substitute('^\s\+', '', '') -> substitute('\s\+', ' ', 'g')
    endif
  endfor
  return ''
enddef

#echo BufSummary()



#---------------------------------------------------------------------------------------------

var a = [1, 2]
var b = {'x': 8, 'y': 9}

def A()
  B(a, b)
  echo a b
enddef

def B(s: list<number>, t: dict<number>)
  s[0] = 3
  t.x = 7
enddef

A()



#---------------------------------------------------------------------------------------------



#---------------------------------------------------------------------------------------------



#---------------------------------------------------------------------------------------------



#---------------------------------------------------------------------------------------------



