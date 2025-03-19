vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8


#----------------------------------------------------------------------------------------
# Switch TabLine Contents

var TablineContentsSwitch = {
  'Battery':    false,
  'Date':       false,
  'FuncName':   true,
  'TabLabel':    true,
  'Time':        true,
  'TimeSecond': false,
  'tlWinnum':   false,
  'tlModified': false,
  'tlBufname':  false,
}

#def CompletionStlContents(ArgLead: string, CmdLine: string, CusorPos: number): list<string>
#  return keys(StatuslineContentsSwitch) -> filter((_, val) => val =~? ('^' .. ArgLead .. '.*')) -> sort()
#enddef
#
#com! -nargs=1 -complete=customlist,CompletionStlContents Stl {
#  StatuslineContentsSwitch['<args>'] = !StatuslineContentsSwitch['<args>']
#  redrawstatus!
#}


#----------------------------------------------------------------------------------------
# Make TabLineStr

def g:TabLine(): string
  const gold = true
  const contents_switch = TablineContentsSwitch


  # Left
  var left: string

  if contents_switch.Date && contents_switch.Time
    left ..= '%#TabLineDate# ◎ '
    left ..= '%#TabLineDate# ' .. strftime('%Y/%m/%d (%a)') .. '  '
    left ..= '%#SLFileName#  '  .. strftime('%X') .. '  '
    left ..= "%#TabLineDate#    "
  elseif contents_switch.Date
    left ..= '%#TabLineDate# ◎ '
    left ..= '%#TabLineDate# ' .. strftime('%Y/%m/%d (%a)') .. '  '
  elseif contents_switch.Time
    if contents_switch.TimeSecond
      if 0
        left ..= '%#TabLineDate# ◎ '
        left ..= '%#TabLineDate# ' .. strftime('%X') .. ' '
      else
        left ..= '%#TabLineDate# ' .. strftime('%X') .. ' '
      endif
    else
      left ..= '%#TabLineDate# ◎'
      left ..= '%#TabLineDate# ' .. strftime('%H:%M') .. '  '
    endif
  else
    left ..= '%#TabLineDate# ◎ '
  endif

  if contents_switch.Battery
    left ..= '%#SLFileName# ' .. BatteryStr() .. '  '
    left ..= '%#TabLineDate#    '
  endif


  # Tab Pages
  var tabpages: string

  if contents_switch.TabLabel
    # Tab Label
    const tab_labels = tabpagenr('$') -> range() -> map((_, val) => MakeTabpageLabel(val + 1))


    # Tab Separater
    var sep: string

    sep = '%#SLFileName# | '  # タブ間の区切り
    sep = '%#TabLineSep#| '  # タブ間の区切り
    sep = '%#TabLineSep# | '  # タブ間の区切り



    tabpages = sep .. join(tab_labels, sep) .. sep .. '%#TabLineFill#%T'
    tabpages = sep .. join(tab_labels, sep) .. sep .. '%#TabLineDate#    ' #.. '%#TabLineFill#%T'
    tabpages = '%#TabLineSep#  ' .. join(tab_labels, sep) .. '%#TabLineSep#  %#TabLineDate#    ' .. '%#TabLineFill#%T'
    tabpages = '%##      ' .. '%#TabLineSep#  ' .. join(tab_labels, sep) .. '%#TabLineSep#  %#TabLineDate#    ' .. '%#TabLineFill#%T'
  else
   #tabpages =  '%#SLFileName#    ' .. '%#TabLine#  [ ' ..  tabpagenr() .. ' / ' .. tabpagenr('$') .. ' ]  %#SLFileName# '
    tabpages =  '%#SLFileName#    ' .. '%#TabLineDate#  [ ' ..  tabpagenr() .. ' / ' .. tabpagenr('$') .. ' ]  %#SLFileName# '
  endif


  # Right
  var right: string


  # Current Function Name
  if contents_switch['FuncName']
   #right ..= "%#hl_func_name_stl#"
    right ..= "%#TabLine#"

    right ..= "  %{ cfi#format('%s()', '[--]') }  "    #right ..= " %{ FuncName() }"
  endif


  right ..= "%#TabLineDate#    "

  right ..= "%#SLFileName# [ "
  #right ..= "%#SLFileName#  "
  right ..= DiffOptStr()
  right ..= "%#SLFileName# ] "
  #right ..= "%#SLFileName#  "

  if 0
    const TablineStatus = 1
    const TablineStatusNum = 9
    right ..= '%#TabLineDate# ' .. TablineStatus .. '/' .. (TablineStatusNum - 1)
  else
    right ..= '%#TabLineDate# ' .. tabpagenr() .. ' / ' .. tabpagenr('$')
  endif
  right ..= '%#TabLineDate# '


  var fill_color: string

  if gold
    fill_color = '%#TabLineFill#'
  else
    fill_color = '%#SLFileName#'
  endif

  return left .. '%<' .. tabpages .. fill_color .. '%=' .. right
enddef


#----------------------------------------------------------------------------------------
# Make TabLabel

def MakeTabpageLabel(tabn: number): string
  var   hi: string
  hi = tabn == tabpagenr() ? '%#TabLineSel#' : '%#VertSplit#'
  hi = tabn == tabpagenr() ? '%#TabLineSel#' : '%#TabLineSep#'
  hi = tabn == tabpagenr() ? '%#SLFileName#' : '%#TabLineSep#'
  hi = tabn == tabpagenr() ? '%#TabLineDate#' : '%#TabLineSep#'

  const tabn_str = '[' .. tabn .. ']'

  # タブ内のバッファのリスト
  var bufnrs = tabpagebuflist(tabn)

  # バッファ数
  const bufnum_str = '(' .. len(bufnrs) .. ')'

  # カレントバッファ番号
  const curbufnr = bufnrs[tabpagewinnr(tabn) - 1]  # tabpagewinnr()は、 1始まり。

  # カレントバッファ名
  # const bufname_tmp = expand('#' .. curbufnr .. ':t')
  # const bufname_tmp = pathshorten(bufname(curbufnr)) )
  # const bufname_tmp = pathshorten(expand('#' .. curbufnr .. ':p'))
  # const bufname = bufname_tmp == '' ? 'No Name' : bufname_tmp  # 無名バッファは、バッファ名が出ない。
  # const bufname = bufname_tmp == '' ? ' ' : bufname_tmp  # 無名バッファは、バッファ名が出ない。

  # タブ内に変更ありのバッファがあったら '+' を付ける
  const mod = bufnrs -> filter((_, val) => getbufvar(val, "&modified")) -> len() != 0 ? '+' : ''

  return hi .. tabn_str
 #return hi .. tabn_str .. mod

 #return hi .. tabn_str .. ' ' .. bufnum_str .. mod
 #return hi .. '%' .. tabn .. 'T' .. tabn_str .. '%T'
enddef


def BatteryStr(): string
  #return '🔋  85%% [10:04:43]'
  return '🔌  85%% [10:04:43]'
  #return '? ---% [--:--:--]'
enddef


def DiffOptStr(): string
  const diffopts = split(&diffopt, ',')

  const case  = (index(diffopts, 'icase') == -1 ?  '%#SLFileName#' : '%#SLNoNameDir#') ..  'Case'

  const white =
    ( ['iblank', 'iwhite', 'iwhiteall', 'iwhiteeol']
        -> map((_, val) => index(diffopts, val))
        -> reduce((acc, val) => acc && (val == -1), true)
      ?  '%#SLFileName#' : '%#SLNoNameDir#'
    ) ..  'White'

  # 'Blank'

  return '%#SLFileName# ' .. case .. ' ' .. white .. '%#SLFileName# '
enddef


#----------------------------------------------------------------------------------------
# Switch TabLine Status & Contents

def CompletionTblContents(ArgLead: string, CmdLine: string, CusorPos: number): list<string>
enddef


def ToggleTabline(arg: string)
enddef


#----------------------------------------------------------------------------------------
# TabLine Timer

# 旧タイマの削除  vimrcを再読み込みする際、古いタイマを削除しないと、どんどん貯まっていってしまう。
if exists('TimerTabline') | call timer_stop(TimerTabline) | endif

const UpdateTablineInterval = 1000
var TimerTabline = timer_start(UpdateTablineInterval, (dummy) => execute('redrawtabline'), {'repeat': -1})


#----------------------------------------------------------------------------------------
# Initial Setting

set showtabline=2
set tabline=%!TabLine()


#----------------------------------------------------------------------------------------
# Mayday

# Tablineを非表示にする
com! Mayday set showtabline=0
com! MayDay Mayday
com! MAYDAY Mayday



finish









function Make_tabpage_label(tab)
  " カレントタブページかどうかでハイライトを切り替える
  "let hi = tab is tabpagenr() ? '%#Directory#' : '%#TabLine#'
  "let hi = tab is tabpagenr() ? '%#SLFileName#' : '%#TabLine#'
  "let hi = tab is tabpagenr() ? '%#TabLineSel#' : '%#TabLine#'
  let hi = tab is tabpagenr() ? '%#TabLineSel#' : '%#VertSplit#'

  if s:TablineStatus == 1 | return hi . ' [ ' . tab . ' ] %#TabLineFill#' | endif

# " タブ内のバッファのリスト
# let bufnrs = tabpagebuflist(tab)

# " タブ内に変更ありのバッファがあったら '+' を付ける
# let mod = len(filter(copy(bufnrs), 'getbufvar(v:val, "&modified")')) ? ' +' : ''

# " バッファ数
# let num = '(' . len(bufnrs) . ')'

  if s:TablineStatus == 2 | return hi . ' [ ' . tab . ' ' . mod . ' ] %#TabLineFill#' | endif

  if s:TablineStatus == 2 | return hi . ' [ ' . tab . ' ' . num . mod . ' ] %#TabLineFill#' | endif

  " タブ番号
  let no = '[' . tab . ']'

# " カレントバッファ
# let curbufnr = bufnrs[tabpagewinnr(tab) - 1]  " tabpagewinnr() は 1 origin
# let buf_name = ( s:TablineStatus =~ '[345]' ? expand('#' . curbufnr . ':t') : pathshorten(bufname(curbufnr)) )  " let buf_name = pathshorten(expand('#' . curbufnr . ':p'))
#"let buf_name = buf_name == '' ? 'No Name' : buf_name  " 無名バッファは、バッファ名が出ない。
#"let buf_name = buf_name == '' ? '-' : buf_name  " 無名バッファは、バッファ名が出ない。
# let buf_name = buf_name == '' ? ' ' : buf_name  " 無名バッファは、バッファ名が出ない。

  " 最終的なラベル
  let label = no . (s:TablineStatus != 3 ? (' ' . num) : '') . (s:TablineStatus =~ '[57]' ? mod : '') . ' '  . buf_name
  return '%' . tab . 'T' . hi . '  ' . label . '%T  %#TabLineFill#'
endfunction




function! s:make_tabpage_label(n)
  " カレントタブページかどうかでハイライトを切り替える
  "let hi = tab is tabpagenr() ? '%#Directory#' : '%#TabLine#'
  "let hi = tab is tabpagenr() ? '%#SLFileName#' : '%#TabLine#'
  "let hi = tab is tabpagenr() ? '%#TabLineSel#' : '%#TabLine#'
  let hi = tab is tabpagenr() ? '%#TabLineSel#' : '%#VertSplit#'

  if s:TablineStatus == 1 | return hi . ' [ ' . tab . ' ] %#TabLineFill#' | endif

  " タブ内のバッファのリスト
  let bufnrs = tabpagebuflist(tab)

  " タブ内に変更ありのバッファがあったら '+' を付ける
  let mod = len(filter(copy(bufnrs), 'getbufvar(v:val, "&modified")')) ? ' +' : ''

  " バッファ数
  let num = '(' . len(bufnrs) . ')'

  if s:TablineStatus == 2 | return hi . ' [ ' . tab . ' ' . mod . ' ] %#TabLineFill#' | endif

  if s:TablineStatus == 2 | return hi . ' [ ' . tab . ' ' . num . mod . ' ] %#TabLineFill#' | endif

  " タブ番号
  let no = '[' . tab . ']'

  " カレントバッファ
  let curbufnr = bufnrs[tabpagewinnr(tab) - 1]  " tabpagewinnr() は 1 origin
  let buf_name = ( s:TablineStatus =~ '[345]' ? expand('#' . curbufnr . ':t') : pathshorten(bufname(curbufnr)) )  " let buf_name = pathshorten(expand('#' . curbufnr . ':p'))
 "let buf_name = buf_name == '' ? 'No Name' : buf_name  " 無名バッファは、バッファ名が出ない。
 "let buf_name = buf_name == '' ? '-' : buf_name  " 無名バッファは、バッファ名が出ない。
  let buf_name = buf_name == '' ? ' ' : buf_name  " 無名バッファは、バッファ名が出ない。

  " 最終的なラベル
  let label = no . (s:TablineStatus != 3 ? (' ' . num) : '') . (s:TablineStatus =~ '[57]' ? mod : '') . ' '  . buf_name
  return '%' . tab . 'T' . hi . '  ' . label . '%T  %#TabLineFill#'
endfunction





function! TabLineStr()
  " Tab Label
  let tab_labels = map(range(1, tabpagenr('$')), 's:make_tabpage_label(v:val)')
  let sep = '%#SLFileName# | '  " タブ間の区切り
  let tabpages = sep . join(tab_labels, sep) . sep . '%#TabLineFill#%T'

  " Left
  let left = ''
  if 0
    let left .= '%#TabLineDate#  ' . strftime('%Y/%m/%d (%a) %X') . '  '
  else
    let left .= '%#TabLineDate#  ' . strftime('%X') . ' '
  endif
  let left .= '%#SLFileName#  ' . g:BatteryInfo . '  '
  let left .= '%#TabLineDate#  '

  " Right
  let right = ''
  let right .= "%#TabLineDate#  "
 "let right .= "%#SLFileName# %{'[ '. substitute(&diffopt, ',', ', ', 'g') . ' ]'} "
  let right .= '%#TabLineDate#  ' . s:TablineStatus . '/' . (s:TablineStatusNum - 1)
  let right .= '%#TabLineDate#  '

  return left . '%##    %<' . tabpages . '%=  ' . right
endfunction
function! TabLineStr()
  " Tab Label
  let tab_labels = map(range(1, tabpagenr('$')), 's:make_tabpage_label(v:val)')
 "let sep = '%#SLFileName# | '  " タブ間の区切り
  let sep = '%#join#| '  " タブ間の区切り
  let sep = '%#join# | '  " タブ間の区切り
  let tabpages = sep . join(tab_labels, sep) . sep . '%#TabLineFill#%T'

  " Left
  let left = ''
  if 0
    let left .= '%#TabLineDate#  ' . strftime('%Y/%m/%d (%a) %X') . '  '
  else
   "let left .= '%#TabLineDate# 💮 %#SLFileName#  ' . strftime('%X') . '  %#TabLineDate#    '
    let left .= '%#TabLineDate# ' . (winnr('$') > g:WinFocusThresh ? '💎' : '🐎') . ' %#SLFileName#  ' . strftime('%X') . '  %#TabLineDate#    '
  endif
  let left .= '%#SLFileName# ' . g:BatteryInfo . '  '
  let left .= '%#TabLineDate#    '

  " Right
  let right = ''
  let right .= "%#TabLineDate#  "

  if 0
    let right .= "%#SLFileName# %{'[ '. substitute(&diffopt, ',', ', ', 'g') . ' ]'} "
  elseif 0
    let right .= "%#SLFileName# [ "
    let right .= "(&diffopt =~ '\<iwhite\>' ? '%#SLNoNameDir#' : '%#SLFileName#') " . "White"
    let right .= "(&diffopt =~ 'icase'  ? '%#SLNoNameDir#' : '%#SLFileName#') " . "Case"
    let right .= "%#SLFileName ] "
  else
    let right .= "%#SLFileName# [ "
    let right .= (&diffopt =~ '\<iwhite\>' ? "%#SLNoNameDir#" : "%#SLFileName#") . "White "
    let right .= (&diffopt =~ 'icase'  ? "%#SLNoNameDir#" : "%#SLFileName#") . "Case"
    let right .= "%#SLFileName# ] "
  endif

 "let right .= '%#TabLineDate#  ' . s:TablineStatus . '/' . (s:TablineStatusNum - 1)
  let right .= '%#TabLineDate# 💻 ' . s:TablineStatus . '/' . (s:TablineStatusNum - 1)
  let right .= '%#TabLineDate#  '

  return left . '%#TabLineFill#    %<' . tabpages . '%#TabLineFill#%=  ' . right
  "return left . '%#SLFileName#    %<' . tabpages . '%#SLFileName#%=  ' . right
  return left . '%##%<' . tabpages . '%=  ' . right
endfunction


function! TabLineStr()
  " Tab Label
  let tab_labels = map(range(1, tabpagenr('$')), 's:make_tabpage_label(v:val)')
  let sep = '%#SLFileName# | '  " タブ間の区切り
  "let tabpages = sep . join(tab_labels, sep) . sep . '%#TabLineFill#%T'
  "let tabpages = join(tab_labels, sep) . '%#TabLineDate#    ' . '%#TabLineFill#%T'
  let tabpages = sep . join(tab_labels, sep) . sep . '%#TabLineDate#    ' ". '%#TabLineFill#%T'

  let tabpages =  '%#SLFileName#    ' .. '%#TabLineDate#  [ ' ..  tabpagenr() .. ' / ' .. tabpagenr('$') .. ' ]  %#SLFileName# '
  let tabpages =  '%#SLFileName#    ' .. '%#TabLine#  [ ' ..  tabpagenr() .. ' / ' .. tabpagenr('$') .. ' ]  %#SLFileName# '

  " Left
  let left = ''
  "let left .= '%#TabLineDate#  ' . strftime('%X') . '  '
  "let left .= '%#SLFileName# ' . g:BatteryInfo . ' '
  "let left .= '%#TabLineDate#  '
  let left .= '%#TabLineDate# ◎ '

  " Right
  let right = ''
  let right .= "%#TabLineDate#  "
  let right .= "%#SLFileName# %{'[ '. substitute(&diffopt, ',', ', ', 'g') . ' ]'} "
  "let right .= '%#TabLineDate#  ' . s:TablineStatus . '/' . (s:TablineStatusNum - 1)
  let right .= '%#TabLineDate#  '

  return left . '%<' . tabpages . '%=  ' . right
  return left . '%##    %<' . tabpages . '%=  ' . right
endfunction


function! TabLineStr()
  " Tab Label
  let tab_labels = map(range(1, tabpagenr('$')), 's:make_tabpage_label(v:val)')
  let sep = '%#SLFileName# | '  " タブ間の区切り
  let tabpages = sep . join(tab_labels, sep) . sep . '%#TabLineFill#%T'

  " Left
  let left = ''
  let left .= '%#TabLineDate#  ' . strftime('%X') . '  '
  let left .= '%#SLFileName# ' . g:BatteryInfo . ' '
  let left .= '%#TabLineDate#  '

  " Right
  let right = ''
  let right .= "%#TabLineDate#  "
  let right .= "%#SLFileName# %{'[ '. substitute(&diffopt, ',', ', ', 'g') . ' ]'} "
  let right .= '%#TabLineDate#  ' . s:TablineStatus . '/' . (s:TablineStatusNum - 1)
  let right .= '%#TabLineDate#  '

  return left . '%##    %<' . tabpages . '%=  ' . right
endfunction


" 1228
"---------------------------------------------------------------------------------------------
function! s:ToggleTabline(arg)
  if (a:arg . '') == ''
    echo s:TablineStatus
  elseif (a:arg . '') == '+'
    let s:TablineStatus = ( s:TablineStatus + 1 ) % s:TablineStatusNum
  elseif (a:arg . '') == '-'
    let s:TablineStatus = ( s:TablineStatus - 1 ) % s:TablineStatusNum
  elseif a:arg < s:TablineStatusNum
    let s:TablineStatus = a:arg
  else
    echoerr 'Tabline:Invalid argument.'
    return
  endif

  let &showtabline = ( s:TablineStatus == 0 ? 0 : 2 )

  call UpdateTabline(0)
  "set tabline=%!TabLineStr()
endfunction


"----------------------------------------------------------------------------------------
" Initial Setting
let s:TablineStatusNum = 9
" 0
" 1  タブ番号
" 2  タブ番号            Mod
" 3  タブ番号 バッファ数 Mod
" 4  タブ番号                バッファ名
" 5  タブ番号 バッファ数     バッファ名
" 6  タブ番号 バッファ数 Mod バッファ名
" 7  タブ番号 バッファ数     フルバッファ名
" 8  タブ番号 バッファ数 Mod フルバッファ名


com! -nargs=? -complete=customlist,s:CompletionTabline Tabline call <SID>ToggleTabline(<args>)

" 1228
function! s:CompletionTabline(ArgLead, CmdLine, CusorPos)
  return map(range(0, s:TablineStatusNum), 'v:val . ""') + ['+', '-']
endfunction



" vimrc
"nnoremap <silent> <leader>= :<C-u>call <SID>ToggleTabline('')<CR>
