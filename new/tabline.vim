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

  const gold = g:IsGold()


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
  #? if contents_switch.FuncName
  #?   right ..= "%#StlFuncName#"
  #?   right ..= "%#TabLine#"
  #?
  #?   right ..= "  %{ cfi#format('%s()', '[--]') }  "
  #?   #right ..= " %{ FuncName() }"
  #? endif

  right ..= "%#TblDate#    "

  right ..= "%#StlFill# [ " .. DiffOptStr() .. "%#StlFill# ] "
  #right ..= DiffOptStr()

  right ..= '%#TblDate# %7(' .. tabpagenr() .. ' / ' .. tabpagenr('$') .. '%)'

  right ..= '%#TblDate# '


  # ------------------------------------------------------------------------
  # Tab Pages
  var tabpages: string

  if contents_switch.TabLabel

    # ----------------------------------------------------------------------
    # Tab Separater
    #const sep = '%#TabLineSep# | '  # タブ間の区切り
    const sep = '%#TabLineSep# │ '  # タブ間の区切り


    #const cur_tabnr = tabpagenr()


    # ----------------------------------------------------------------------
    # Tab Label
    const tab_labels = tabpagenr('$') -> range() -> map((_, val) => MakeTabpageLabel(val + 1))  # cur_tabnr TODO

    # TODO
    const KARI = 12

    # Highlighting命令を除いた表示長を返す
    # TODO Highlightの名称は既知なので、置換せずに引き算だけでよい。
    def DispLen(s: string): number
      return s -> substitute('%#\w\+#', '', 'g') -> strdisplaywidth()
    enddef

    const win_width = &columns
    const l_width = DispLen(left)  # strdisplaywidth(left)
    const r_width = DispLen(right) # strdisplaywidth(right)
    # TODO fill考慮
    const label_space = win_width - l_width - r_width

    #const sep_width = strdisplaywidth(sep)
    const sep_width = DispLen(sep)

    const labels_width = tab_labels -> mapnew((_, val) => val -> DispLen() + sep_width) -> reduce((acc, val) => acc + val, -sep_width + KARI)

    const cur_tab_idx = tabpagenr() - 1
    const end_tab_idx = tabpagenr('$') - 1

    #const triangle_hi = "%#StlFill#"
    const triangle_hi = "%#TabLineSep#"

    var triangle_l = triangle_hi .. "    "
    var triangle_r = triangle_hi .. "   "

    var tab_labels_disp: list<string>

    if contents_switch.Bufname && labels_width > label_space
      #const N = &columns / 40 # 4
      #const N = label_space / 30 # 4
      const N = max([1, label_space / 24])
      #const N = max([1, label_space / 30])
      #const N = 4
      #const N = 5                            # タブ表示最大数
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

      tab_labels_disp = tab_labels[sta_idx : end_idx]
      if sta_idx != 0
        #tab_labels_disp = [triangle_hi .. "◀"] + tab_labels_disp
        triangle_l = triangle_hi .. "  ◀"
      endif
      if end_idx != end_tab_idx
        #tab_labels_disp = tab_labels_disp + [triangle_hi .. "▶"]
        triangle_r = triangle_hi .. " ▶"
      endif
    else
      tab_labels_disp = tab_labels
    endif

    # Tabpages
    tabpages = '%#TabLineFill#' .. (gold ? '     ' : '  ')  .. triangle_l .. '%<%#TabLineSep#' .. join(tab_labels_disp, sep) .. triangle_r .. '%#TabLineSep# ' .. '%#TabLineFill#'
  else
    # Tabpages
    tabpages =  '%#StlFill#    ' .. '%#TabLine#  [ ' ..  tabpagenr() .. ' / ' .. tabpagenr('$') .. ' ]  %#StlFill# %<'
  endif


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

def MakeTabpageLabel(tabn: number): string
  var label: string  # 最終的なラベル (返り値)

  const contents_switch = TablineContentsSwitch

  const cur_tabnr = tabpagenr()

  # 表示桁数を容易に算出できるよう、非アクティブのときのhighlightは、
  # TabLineではな(TabLineSelと文字数が等しい)くTabLineSepとしておく。
  #const hi = tabn == cur_tabnr ? '%#TabLineSel#' : '%#TabLineSep#'
  #const hi = tabn == cur_tabnr ? '%#StlFill#' : '%#TabLineSep#'
  const hi = tabn == cur_tabnr ? '%#TabLineSel#' : '%#TabLineSep#'

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

    const bufname = bufname_tmp == '' ? 'No Name' : bufname_tmp  # 無名バッファは、バッファ名が出ない。

    label = tabn_str .. ' ' .. bufname

    # アクティブタブ名の廻りにNormalを付ける
    if 1
      if tabn == cur_tabnr
        label = '%#Normal# ' .. hi .. label .. '%#Normal# '
      else
        label = ' ' .. hi .. label .. ' '
      endif
    endif
  else
    label = hi .. tabn_str
  endif

  # タブ内に変更ありのバッファがあったら '+' を付ける
  #? const mod = bufnrs -> filter((_, val) => getbufvar(val, "&modified")) -> len() != 0 ? '+' : ''

  return label
enddef


def BatteryStr(): string
  #return '🔋  85%% [10:04:43]'
  return '🔌  85%% [10:04:43]'
  #return '? ---% [--:--:--]'
enddef


def DiffOptStr(): string
  const diffopts = split(&diffopt, ',')

  const case = (index(diffopts, 'icase') == -1 ?  '%#TblDiffOn#' : '%#TblDiffOff#') ..  'Case'

  const white =
    ( ['iblank', 'iwhite', 'iwhiteall', 'iwhiteeol']
        -> map((_, val) => index(diffopts, val))
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
