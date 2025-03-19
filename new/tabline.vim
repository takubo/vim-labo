vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8


#----------------------------------------------------------------------------------------
# TabLine Contents Switch

var TablineContentsSwitch = {
  'Battery':    false,
  'Date':       false,
  'FuncName':   false,
  'TabLabel':    true,
  'Time':        true,
  'TimeSecond': false,
# Tab Label
  'Bufname':     true,
  'Modified':   false,
  'Path':       false,
  'Winnum':     false,
}


#----------------------------------------------------------------------------------------
# Make TabLineStr

def g:TabLine(): string
  const gold = g:IsGold()
  const contents_switch = TablineContentsSwitch


  var fill_color: string
  if gold
    fill_color = '%#TabLineFill#'
  else
    fill_color = '%#TabLineSel#'
    fill_color = '%#SLFileName#'
  endif


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
    sep = '%#TabLineSep# │ '  # タブ間の区切り


    tabpages = sep .. join(tab_labels, sep) .. sep .. '%#TabLineFill#%T'
    tabpages = sep .. join(tab_labels, sep) .. sep .. '%#TabLineDate#    ' #.. '%#TabLineFill#%T'
    tabpages = '%#TabLineSep#  ' .. join(tab_labels, sep) .. '%#TabLineSep#  %#TabLineDate#    ' .. '%#TabLineFill#%T'
    tabpages = '%##      ' .. '%#TabLineSep#  ' .. join(tab_labels, sep) .. '%#TabLineSep#  %#TabLineDate#    ' .. '%#TabLineFill#%T'
    tabpages = fill_color .. '      ' .. '%#TabLineSep#  ' .. join(tab_labels, sep) .. '%#TabLineSep#  ' .. '%#TabLineFill#%T'
    #tabpages = fill_color .. '      ' .. '%#TabLineSep#  ' .. join(tab_labels, sep) .. '%#TabLineSep#  %#TabLineDate#    ' .. '%#TabLineFill#%T'
  else
   #tabpages =  '%#SLFileName#    ' .. '%#TabLine#  [ ' ..  tabpagenr() .. ' / ' .. tabpagenr('$') .. ' ]  %#SLFileName# '
    tabpages =  '%#SLFileName#    ' .. '%#TabLineDate#  [ ' ..  tabpagenr() .. ' / ' .. tabpagenr('$') .. ' ]  %#SLFileName# '
  endif


  # Right
  var right: string


  # Current Function Name
  if contents_switch.FuncName
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


  return left .. '%<' .. tabpages .. fill_color .. '%=' .. right
enddef


#----------------------------------------------------------------------------------------
# Make TabLabel
#
# 0
# 1  タブ番号
# 2  タブ番号            Mod
# 3  タブ番号 バッファ数 Mod
# 4  タブ番号                バッファ名
# 5  タブ番号 バッファ数     バッファ名
# 6  タブ番号 バッファ数 Mod バッファ名
# 7  タブ番号 バッファ数     フルバッファ名
# 8  タブ番号 バッファ数 Mod フルバッファ名

def MakeTabpageLabel(tabn: number): string
  var label: string  # 最終的なラベル (返り値)

  const contents_switch = TablineContentsSwitch

  # const hi = tabn == tabpagenr() ? '%#TabLineSel#' : '%#VertSplit#'
  # const hi = tabn == tabpagenr() ? '%#TabLineSel#' : '%#TabLineSep#'

  var hi: string

  const tabn_str = '[' .. tabn .. ']'

  if contents_switch.Bufname
    # タブ内のバッファのリスト
    var bufnrs = tabpagebuflist(tabn)

    # バッファ数
    #? const bufnum_str = '(' .. len(bufnrs) .. ')'

    # カレントバッファ番号
    const curbufnr = bufnrs[tabpagewinnr(tabn) - 1]  # tabpagewinnr()は、 1始まり。

    # カレントバッファ名
    const bufname_tmp = expand('#' .. curbufnr .. ':t')

    # const bufname_tmp = pathshorten(bufname(curbufnr)) )
    # const bufname_tmp = pathshorten(expand('#' .. curbufnr .. ':p'))

    const bufname = bufname_tmp == '' ? 'No Name' : bufname_tmp  # 無名バッファは、バッファ名が出ない。
    # const bufname = bufname_tmp == '' ? ' ' : bufname_tmp  # 無名バッファは、バッファ名が出ない。

    hi = tabn == tabpagenr() ? '%#SLFileName#' : '%#TabLineSep#'
    hi = tabn == tabpagenr() ? '%#TabLineDate#' : '%#TabLineSep#'
    label = tabn_str .. ' ' .. bufname
    #label = ' ' .. tabn_str .. ' ' .. bufname .. ' '

    # アクティブタブ名の廻りにNormalを付ける
    if 1
      if tabn == tabpagenr()
        label = '%#Normal# ' .. hi .. label .. '%#Normal# '
      else
        label = ' ' .. hi .. label .. ' '
      endif
      return label
    endif
  else
    hi = tabn == tabpagenr() ? '%#TabLineDate#' : '%#TabLineSep#'
    label = tabn_str
  endif

  # タブ内に変更ありのバッファがあったら '+' を付ける
  #? const mod = bufnrs -> filter((_, val) => getbufvar(val, "&modified")) -> len() != 0 ? '+' : ''

  return hi .. label
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

def SwitchTabline(...args: list<string>)
  if args == []
    &showtabline = (&showtabline == 0 ? 2 : 0 )
    SetTimer(false)
    return
  endif

  # TODO foreach
  args->mapnew((_, val) => {
    TablineContentsSwitch[val] = !TablineContentsSwitch[val]
    return 0
  })

  redrawtabline
  SetTimer(true)
enddef

def CompletionTblContents(ArgLead: string, CmdLine: string, CusorPos: number): list<string>
  return keys(TablineContentsSwitch) -> filter((_, val) => val =~? ('^' .. ArgLead .. '.*')) -> sort()
enddef

com! -nargs=* -complete=customlist,CompletionTblContents Tbl {
  SwitchTabline(<f-args>)
}


#----------------------------------------------------------------------------------------
# TabLine Timer

# 旧タイマの削除 (再読み込みする際、古いタイマを削除しないと、どんどん貯まっていってしまう。)
if exists('g:RedrawTablineTimerId') | timer_stop(g:RedrawTablineTimerId) | endif

g:RedrawTablineTimerId = 0

def SetTimer(on: bool)
  # 一定間隔で更新する必要があるコンテンツがあるときのみ、タイマーを有効にする。
  const req_timer_cont = ( ['Battery', 'Date', 'Time', 'TimeSecond']
    -> map((_, val) => TablineContentsSwitch[val])
    -> reduce((acc, val) => acc || val, true)
  )

  if on && req_timer_cont
    if timer_info(g:RedrawTablineTimerId) == []
      g:RedrawTablineTimerId = timer_start(RedrawTablineInterval, (dummy) => execute('redrawtabline'), {'repeat': -1})
    endif
  else
    timer_stop(g:RedrawTablineTimerId)
  endif
enddef


#----------------------------------------------------------------------------------------
# Initial Setting

const RedrawTablineInterval = 1000

set showtabline=2
set tabline=%!TabLine()

SetTimer(true)


#----------------------------------------------------------------------------------------
# Mayday

# Tablineを非表示にする
com! Mayday set showtabline=0
com! MayDay Mayday
com! MAYDAY Mayday
