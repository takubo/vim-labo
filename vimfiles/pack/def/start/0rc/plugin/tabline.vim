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

def! g:TabLine(): string
  const contents_switch = TablineContentsSwitch

  #const gold = g:IsGold()
  const gold = exists('g:RimpaGold') && g:RimpaGold


  # ------------------------------------------------------------------------
  # Left
  var left: string

  if contents_switch.Date && contents_switch.Time
    left ..= '%#TblDate# ◎ '
    left ..= '%#TblDate# ' .. strftime('%Y/%m/%d (%a)') .. '  '
    left ..= '%#StlFill#  '  .. strftime('%X') .. '  '
    left ..= "%#TblDate#    "
  elseif contents_switch.Date
    left ..= '%#TblDate# ◎ '
    left ..= '%#TblDate# ' .. strftime('%Y/%m/%d (%a)') .. '  '
  elseif contents_switch.Time
    if contents_switch.TimeSecond
      if 0
        left ..= '%#TblDate# ◎ '
        left ..= '%#TblDate# ' .. strftime('%X') .. ' '
      else
        left ..= '%#TblDate# ' .. strftime('%X') .. ' '
      endif
    else
      left ..= '%#TblDate# ◎'
      left ..= '%#TblDate# ' .. strftime('%H:%M') .. '  '
    endif
  else
    left ..= '%#TblDate# ◎ '
  endif

  if contents_switch.Battery
    left ..= '%#StlFill# ' .. BatteryStr() .. '  '
    left ..= '%#TblDate#    '
  endif


  # ------------------------------------------------------------------------
  # Right
  var right: string

  # Current Function Name
  # if contents_switch.FuncName
  #   right ..= "%#StlFuncName#"
  #   right ..= "%#TabLine#"
  #
  #   right ..= "  %{ cfi#format('%s()', '[--]') }  "
  #   #right ..= " %{ FuncName() }"
  # endif

  right ..= "%#TblDate#    "

  right ..= "%#StlFill# [ " .. DiffOptStr() .. "%#StlFill# ] "
  #right ..= DiffOptStr()

  right ..= '%#TblDate# %7(' .. tabpagenr() .. ' / ' .. tabpagenr('$') .. '%)'

  right ..= '%#TblDate# '

  # right ..= '  %6.6(    %S%)'


  # ------------------------------------------------------------------------
  # Tab Pages
  var tabpages: string

  # --------------------------------------------------------
  # Tab Separater
  #const sep = '%#TabLineSep# | '  # タブ間の区切り
  const sep = '%#TabLineSep# │ '  # タブ間の区切り


  # --------------------------------------------------------
  # Tab Label
  const cur_tabnr = tabpagenr()
  const tab_labels = tabpagenr('$') -> range() -> map((_, val) => {
    const tabnr = val + 1
    return MakeTabpageLabel(tabnr, tabnr == cur_tabnr)
  })

  # --------------------------------------------------------
  # Highlighting命令を除いた表示長を返す
  # TODO Highlightの名称は既知なので、置換せずに引き算だけでよい。
  def DispWidth(s: string): number
    return s -> substitute('%#\w\+#', '', 'g') -> strdisplaywidth()
  enddef

  # --------------------------------------------------------
  #  TabPanel Width
  def TabPanelWidth(): number
    if &showtabpanel == 0 # || (&showtabpanel == 1 && tabpagenr('$') <= 1)
      return 0
    endif

    const columns = matchstr(&tabpanelopt, 'columns:\zs\d\+')
    return columns == '' ? 20 : str2nr(columns)
  enddef

  # --------------------------------------------------------
  # Calculate Tab Label Space
  const win_width = &columns - TabPanelWidth()
  const l_width = DispWidth(left)
  const r_width = DispWidth(right)
  const label_space = win_width - l_width - r_width

  # --------------------------------------------------------
  # Calculate Tab Label Width
  const KARI = 12  # TODO
  const sep_width = DispWidth(sep)
  const labels_width = tab_labels -> mapnew((_, val) =>  DispWidth(val) + sep_width) -> reduce((acc, val) => acc + val, -sep_width + KARI)

  # --------------------------------------------------------
  # Make Tab Label String

  const cur_tab_idx = tabpagenr() - 1
  const end_tab_idx = tabpagenr('$') - 1

  var triangle_l = "%#TabLineSep#" .. "    "
  var triangle_r = "%#TabLineSep#" .. "   "

  var tab_labels_disp: list<string> = tab_labels

  if labels_width > label_space
    const N = max([1, label_space / 24])    # TODO contents_switch.Bufname
    const base_idx = cur_tab_idx / N * N    # タブをN個ずつまとめたときの、カレントタブを含む群の先頭タブのインデックス

    var sta_idx: number
    var end_idx: number
    if end_tab_idx < N
      # タブ個数が、最大表示数未満
      sta_idx = base_idx              # 開始は、現在タブ
      end_idx = end_tab_idx           # 終了は、最終タブ
    elseif (end_tab_idx - base_idx + 1) < N
      # カレントタブを含む群のタブ数は、最大表示数未満である。(末尾群のときのみ、あり得る。)
      sta_idx = end_tab_idx - N  + 1  # 開始は、最終-N (N個のタブが表示されるようにしている。)
      end_idx = end_tab_idx           # 終了は、最終タブ
    else
      sta_idx = base_idx
      end_idx = base_idx + N - 1
    endif

    if sta_idx != 0
      triangle_l = "%#TabLineSep#" .. "  ◀"
    endif
    if end_idx != end_tab_idx
      triangle_r = "%#TabLineSep#" .. " ▶"
    endif

    tab_labels_disp = tab_labels[sta_idx : end_idx]
  endif

  # Tabpages
  tabpages = '%#TabLineFill#' .. (gold ? '     ' : '  ')  .. triangle_l .. '%<%#TabLineSep#' .. join(tab_labels_disp, sep) .. triangle_r .. '%#TabLineSep# ' .. '%#TabLineFill#'

  # if !contents_switch.TabLabel
  #   # Tabpages
  #   tabpages =  '%#StlFill#    ' .. '%#TabLine#  [ ' ..  tabpagenr() .. ' / ' .. tabpagenr('$') .. ' ]  %#StlFill# %<'
  # endif


  return left .. tabpages .. '%#TabLineFill#' .. '%=' .. right
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

def MakeTabpageLabel(tabn: number, cur_tab: bool): string
  var label: string  # 最終的なラベル (返り値)

  const contents_switch = TablineContentsSwitch

  # 表示桁数を容易に算出できるよう、非アクティブのときのhighlightは、
  # TabLineではな(TabLineSelと文字数が等しい)くTabLineSepとしておく。
  const hi = cur_tab ? '%#TabLineSel#' : '%#TabLineSep#'

  const tabn_str = '[' .. tabn .. ']'

  if contents_switch.Bufname
    # タブ内のバッファのリスト
    const bufnrs = tabpagebuflist(tabn)

    # バッファ数
    # const bufnum_str = '(' .. len(bufnrs) .. ')'

    # カレントウィンドウ番号
    const curwinnr = tabpagewinnr(tabn)

    # カレントウィンドウID
    #const tabinfo = gettabinfo(tabn)
    const winid = gettabinfo(tabn)[0].windows[curwinnr - 1]  # tabpagewinnr()は1始まりなので、リストのインデックスにするために1を引く。

    # ウィンドウ情報
    const wininfo = getwininfo(winid)[0]

    # カレントバッファ番号
    const curbufnr = bufnrs[curwinnr - 1]  # tabpagewinnr()は1始まりなので、リストのインデックスにするために1を引く。

    # カレントバッファ名
    const bufname_tmp = expand('#' .. curbufnr .. ':t')

    const bufname = bufname_tmp == '' ?
                        wininfo.loclist  == 1 ? '[Locationリスト]' :  # [Location List]
                        wininfo.quickfix == 1 ? '[Quickfixリスト]' :  # [Quickfix List]
                        '[無名]'  # 'No Name'
                    : bufname_tmp

    label = tabn_str .. ' ' .. bufname

    # アクティブタブ名の廻りにNormalを付ける
    if 1
      if cur_tab
        label = '%#Normal# ' .. hi .. label .. '%#Normal# '
      else
        label = ' ' .. hi .. label .. ' '
      endif
    endif
  else
    label = hi .. tabn_str
  endif

  # タブ内に変更ありのバッファがあったら '+' を付ける
  # const mod = bufnrs -> filter((_, val) => getbufvar(val, "&modified")) -> len() != 0 ? '+' : ''

  return label
enddef


#--------------------------------------------
# Battery

import autoload 'battery.vim' as bat

def BatteryStr(): string
  return bat.BatteryInfoStr()
enddef


#--------------------------------------------
# Diff Option

def DiffOptStr(): string
  const diffopt = split(&diffopt, ',')

  const case = (index(diffopt, 'icase') == -1 ?  '%#TblDiffOn#' : '%#TblDiffOff#') ..  'Case'

  const white =
    ( ['iblank', 'iwhite', 'iwhiteall', 'iwhiteeol']
        -> map((_, val) => index(diffopt, val))
        -> reduce((acc, val) => acc && (val == -1), true)
      ?  '%#TblDiffOn#' : '%#TblDiffOff#'
    ) ..  'White'

  # 'Blank'

  return ' ' .. case .. ' ' .. white .. ' '
  # return '%#StlFill# [  ' .. case .. ' ' .. white .. '%#StlFill#  ] '
enddef


#----------------------------------------------------------------------------------------
# Switch TabLine Status & Contents

def SwitchTabline(...args: list<string>)
  if args == []
    &showtabline = (&showtabline == 0 ? 2 : 0 )
    SetTimer(&showtabline != 0)
    return
  endif

  args -> foreach((_, val) => {
                    TablineContentsSwitch[val] = !TablineContentsSwitch[val]
                  } )

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
      g:RedrawTablineTimerId = timer_start(RedrawTablineInterval, (dummy) => {
        if mode() !~# '^[cr]'
          execute('redrawtabline')
        endif
      }, {'repeat': -1})
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
