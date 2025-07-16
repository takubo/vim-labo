vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8



#----------------------------------------------------------------------------------------
# Make TabPanelStr

def TabpanelHeader(): string
  return '%#TblDate# ' .. strftime('%Y/%m/%d (%a)') .. '%=' .. strftime('%H:%M  ') .. "\n\n"
 #return "\n"
enddef


def TabpanelFooter(): string
  if 0
    return '%#TblDate#%=[Footer]%='
  elseif 0
    return '%#TblDate#'
  elseif 0
    return '%#StlGoldLeaf#'
  elseif 0
    return '%#StlGoldLeaf#%=[Footer]%='
  elseif 0
    return g:BatteryBar() -> join("\n") .. "\n" .. '%#TblDate#'
  elseif 0
    return g:BatteryGraph_Center() -> join("\n") .. "\n" .. '%#TblDate#'
   #return Border() .. "\n" .. g:BatteryGraph_Center() -> join("\n") .. "\n" .. '%#TblDate#'
   #return g:BatteryGraph() -> join("\n") .. "\n" .. '%#TblDate#'
  else
    const bat_str =
      false ? g:BatteryBar() -> join("\n") :
      false ? g:BatteryGraph_Center() -> join("\n") : ''
    return bat_str .. "\n" .. '%#StlGoldLeaf#%=%#TblDate# [ ' .. DiffOptStr() .. ' ] %#StlGoldLeaf#%='
   #return bat_str .. "\n" .. '%#TblDate#%= [ ' .. DiffOptStr() .. '%#TblDate# ] %='
   #return bat_str .. "\n" .. '%#TblDate#%= [ ' .. DiffOptStr() .. '%#TblDate# ]  '
   #return bat_str .. "\n" .. '%#TblDate#%=%#StlFill# [ ' .. DiffOptStr() .. ' ] %#TblDate#%='
  endif
enddef


def TabpanelAdding(): string
  const fs = g:FuncsString()
  if fs == ''
    return "\n\n"
  else
    return "\n\n" .. Border() .. fs .. "\n" .. Border() .. "\n"
  endif
 #return '%#TblDate# '
 #return "\n\n\n" .. g:FuncsString()
 #return "\n\n" .. repeat('-', 36) .. "\n" .. g:FuncsString() .. "\n" .. repeat('-', 36) .. "\n"
 #return "\n\n" .. repeat('─', 18) .. "\n" .. g:FuncsString() .. "\n" .. repeat('─', 18) .. "\n"
 #return "\n"
enddef


def Border(c: string = '─', hl: string = '%#TabPanel#'): string
  const tc = TabPanelColumn()
  const cw = c -> strdisplaywidth()
  return hl .. repeat(c, tc / cw) .. "\n"
enddef


# TabPanelの桁数を返す
# TODO tabline.vimと重複
def TabPanelColumn(): number
  #? if &showtabpanel == 0 # || (&showtabpanel == 1 && tabpagenr('$') <= 1)
  #?   return 0
  #? endif

  const columns = matchstr(&tabpanelopt, 'columns:\zs\d\+')
  return columns == '' ? 20 : str2nr(columns)
enddef


# str内のcの数を数える
def CountChar(str: string, c: string): number
  return [str] -> matchstrlist(c) -> len()
enddef


# TODO tabline.vimと重複
def DiffOptStr(): string
  const diffopt = split(&diffopt, ',')

  const case = (index(diffopt, 'icase') == -1 ?  '%#TblDiffRedOn#' : '%#TblDiffRedOff#') ..  'Case'

  const white =
    ( ['iblank', 'iwhite', 'iwhiteall', 'iwhiteeol']
        -> map((_, val) => index(diffopt, val))
        -> reduce((acc, val) => acc && (val == -1), true)
      ?  '%#TblDiffRedOn#' : '%#TblDiffRedOff#'
    ) ..  'White'

  # 'Blank'

  return ' ' .. case .. ' ' .. white .. ' '
  # return '%#StlFill# [  ' .. case .. ' ' .. white .. '%#StlFill#  ] '
enddef


var AccumNumLine: number

def g:TabPanel(): string
  var str = ''

  const tabnr = g:actual_curtabpage

  # Header
  const header = (tabnr == 1 ? TabpanelHeader() : '')

  # Tabs
  const body = Tabs(tabnr)

  if tabnr == 1
    AccumNumLine = header -> CountChar("\n")
  endif

  AccumNumLine += body -> CountChar("\n") + 1

  if tabnr == tabpagenr('$')
    # Adding
    const adding = TabpanelAdding()
    AccumNumLine += adding -> CountChar("\n")

    # Footer
    const footer = TabpanelFooter()
    AccumNumLine += footer -> CountChar("\n")

    # Padding
    const tabpanel_height = &lines - &cmdheight
    const padding = '%#TabPanelFill#' .. repeat("\n", tabpanel_height - AccumNumLine)

    # 返り値
    # タブが1つしかない場合に備えて、ここでもheaderを含める必要がある。
    return header .. body .. adding .. padding .. footer
  else
    # 返り値
    return header .. body
  endif
enddef


def Tabs(tabnr: number): string
  # Tab Number
  var tabnrstr = ''

  if 1
    if tabnr == tabpagenr()
      tabnrstr ..= '%#TabLineSel#'
    else
      tabnrstr ..= '%#TabPanelTabnr#'
      tabnrstr ..= '%#StlFill#'
      tabnrstr ..= '%#PopupNotification#'
    endif
  elseif 0
    tabnrstr ..= '%#TabLineSel#'
  else
    tabnrstr ..= '%#StlFill#'
    tabnrstr ..= '%#PopupNotification#'
  endif

  tabnrstr ..= printf("[%d]", tabnr)
  if true  # 行全体に色を付けたいなら、falseにする。
    tabnrstr ..= '%##'
  endif
  tabnrstr ..= "\n"

  # ウィンドウのリスト
  const wins = gettabinfo(tabnr)[0].windows -> map((i, winid) => WinStr(i + 1, winid, tabnr))
  const winstr = 1 ?
                 ('  '  .. join(wins, "\n  ")  .. "\n") :
                 ('   ' .. join(wins, "\n   ") .. "\n")

  return tabnrstr .. winstr
enddef


def WinStr(winnr: number, winid: number, tabnr: number): string
  const wininfo = getwininfo(winid)[0]
  const wintype = win_gettype(winid)
  const buftype = getbufvar(wininfo.bufnr, '&buftype')
  const bufname = expand('#' .. wininfo.bufnr .. ':t')
  const diff    = gettabwinvar(tabnr, winnr, '&diff')
  const curwin = tabnr == tabpagenr() && winnr == tabpagewinnr(tabnr)

  const hl_line = true

  const curwin_sign = hl_line ?
                      (curwin ? ' %#TabPanelMySel# ' : '  ') :
                      (curwin ? '%#TabPanelMySel#>%## ' : '  ')

  const winnr_hl   = (hl_line && curwin ? '%#TabPanelWinInfoSel#' : '%#TabPanelWinInfo#')
  const info_hl    = (hl_line && curwin ? '%#TabPanelWinInfoSel#' : '%#TabPanelWinInfo#')
  const bufname_hl = (hl_line && curwin ? '%#TabPanelMySel#'      : '%#TabPanelBufName#')

  const winnr_str = winnr .. '. '

  var info = ''

  info ..= (diff ? '[Diff] ' : '')

  info ..=
        wininfo.loclist  == 1 ? '[Locationリスト]' :  # [Location List]
        wininfo.quickfix == 1 ? '[Quickfixリスト]' :  # [Quickfix List]
        wininfo.terminal == 1 ? '[Terminal]' :
        wintype == 'preview'  ? '[Preview]' :
        buftype == 'help'     ? '[Help]' :
        buftype == 'prompt'   ? '[Prompt]' :
        buftype == 'nowrite'  ? '[No Write]' :
        buftype == 'nofile'   ? '[No File]' :
        ''

  info ..= (info != '' && info[-1] != ' ' ? ' ' : '')

  const bufname_show = bufname != '' ? bufname :
                       wininfo.loclist  == 0 && wininfo.quickfix == 0 ? '[無名]' :  # [No Name]
                       ''

  return curwin_sign
      .. winnr_hl   .. winnr_str
      .. info_hl    .. info
      .. bufname_hl .. bufname_show
      .. '%<'
enddef



#----------------------------------------------------------------------------------------
# TabPanel Timer

# 旧タイマの削除 (再読み込みする際、古いタイマを削除しないと、どんどん貯まっていってしまう。)
if exists('g:RedrawTabpanelTimerId') | timer_stop(g:RedrawTabpanelTimerId) | endif

g:RedrawTabpanelTimerId = 0

def SetTimer(on: bool)
#?  # 一定間隔で更新する必要があるコンテンツがあるときのみ、タイマーを有効にする。
#?  const req_timer_cont = ( ['Battery', 'Date', 'Time', 'TimeSecond']
#?    -> map((_, val) => TabpanelContentsSwitch[val])
#?    -> reduce((acc, val) => acc || val, true)
#?  )
  const req_timer_cont = true

  if on && req_timer_cont
    if timer_info(g:RedrawTabpanelTimerId) == []
      g:RedrawTabpanelTimerId = timer_start(RedrawTabpanelInterval, (dummy) => {
        if mode() != 'c'
          execute('redrawtabpanel')
        endif
      }, {'repeat': -1})
    endif
  else
    timer_stop(g:RedrawTabpanelTimerId)
  endif
enddef



#----------------------------------------------------------------------------------------
# Toggle Show TabPanel

def SwitchShowTabPanel()
  if &showtabpanel == 0
    &showtabpanel = 2
  else
    &showtabpanel = 0
  endif
enddef

nnoremap <Leader>t <ScriptCmd>SwitchShowTabPanel()<CR>


def SwitchShowTabLine()
  if &showtabline == 0
    &showtabline = 2
  else
    &showtabline = 0
  endif
enddef

nnoremap <Leader>T <ScriptCmd>SwitchShowTabLine()<CR>

def SetTabPanelAlign(align: string)
  const tabpanelopt = &tabpanelopt

  if match(tabpanelopt, 'align:\w\+') != -1
    &tabpanelopt = substitute(tabpanelopt, 'align:\zs\w\+', align, '')
  else
    &tabpanelopt ..= ',align:' .. align
  endif
enddef

nnoremap <Leader>[ <ScriptCmd>SetTabPanelAlign('left')<CR>
nnoremap <Leader>] <ScriptCmd>SetTabPanelAlign('right')<CR>


def SetTabPanelColumnNum(column: number)
  const tabpanelopt = &tabpanelopt

  if match(tabpanelopt, 'columns:\d\+') != -1
    &tabpanelopt = substitute(tabpanelopt, 'columns:\zs\d\+', column, '')
  else
    &tabpanelopt ..= ',columns:' .. column
  endif
enddef

def SetTabPanelColumn(arg: string)
  const cur_column = TabPanelColumn()

  const ope = arg == '+' ? '+1' :
              arg == '-' ? '-1' : arg

  const sign = matchstr(ope, '^[+-]')
  const num  = matchstr(ope, '^[+-]\?\zs\d\+') -> str2nr()

  var new_column = cur_column

  if sign == '+'
    new_column = cur_column + num
  elseif sign == '-'
    new_column = cur_column - num
  elseif num > 0
    new_column = num
  endif

  SetTabPanelColumnNum(new_column)
enddef

com! -nargs=1 SetTabPanelColumn call <SID>SetTabPanelColumn(<f-args>)

# nnoremap <Leader><lt> <ScriptCmd>SetTabPanelColumn('-2')<CR>
# nnoremap <Leader>>    <ScriptCmd>SetTabPanelColumn('+2')<CR>
# nnoremap <Leader>-    <ScriptCmd>SetTabPanelColumn('-2')<CR>
# nnoremap <Leader>+    <ScriptCmd>SetTabPanelColumn('+2')<CR>

#call submode#enter_with('TabPanelColumn', 'n', 's', "\<Space>+",    ':<C-U>SetTabPanelColumn +1<CR>')  #"<ScriptCmd>SetTabPanelColumn('+2')<CR>")
#call submode#enter_with('TabPanelColumn', 'n', 's', "\<Space>-",    ':<C-U>SetTabPanelColumn -1<CR>')  #"<ScriptCmd>SetTabPanelColumn('-2')<CR>")
#call submode#enter_with('TabPanelColumn', 'n', 's', "\<Space>>",    ':<C-U>SetTabPanelColumn +1<CR>')  #"<ScriptCmd>SetTabPanelColumn('+2')<CR>")
#call submode#enter_with('TabPanelColumn', 'n', 's', "\<Space><lt>", ':<C-U>SetTabPanelColumn -1<CR>')  #"<ScriptCmd>SetTabPanelColumn('-2')<CR>")
#call submode#map(       'TabPanelColumn', 'n', 's', "+",            ':<C-U>SetTabPanelColumn +1<CR>')  #"<ScriptCmd>SetTabPanelColumn('+2')<CR>")
#call submode#map(       'TabPanelColumn', 'n', 's', "-",            ':<C-U>SetTabPanelColumn -1<CR>')  #"<ScriptCmd>SetTabPanelColumn('-2')<CR>")
#call submode#map(       'TabPanelColumn', 'n', 's', ">",            ':<C-U>SetTabPanelColumn +1<CR>')  #"<ScriptCmd>SetTabPanelColumn('+2')<CR>")
#call submode#map(       'TabPanelColumn', 'n', 's', "\<lt>",        ':<C-U>SetTabPanelColumn -1<CR>')  #"<ScriptCmd>SetTabPanelColumn('-2')<CR>")

def SetTabPanelColumnRepeat(arg: string)
  SetTabPanelColumn(arg)

  while true
    const c = getchar(-1) -> nr2char()
    if c !~# '[+-><]'
      return
    endif

    const a = c == '>' ? '+' : c == '<' ? '-' : c

    SetTabPanelColumn(a)
  endwhile
enddef

nnoremap <Leader><lt> <ScriptCmd>SetTabPanelColumnRepeat('-')<CR>
nnoremap <Leader>>    <ScriptCmd>SetTabPanelColumnRepeat('+')<CR>
nnoremap <Leader>-    <ScriptCmd>SetTabPanelColumnRepeat('-')<CR>
nnoremap <Leader>+    <ScriptCmd>SetTabPanelColumnRepeat('+')<CR>



#----------------------------------------------------------------------------------------
# Initialize

#--------------------------------------------
# Options

set tabpanel=%!g:TabPanel_last_only()
set tabpanel=%!g:TabPanel_cur_only_over_test()
set tabpanel=%!g:TabPanel()

set tabpanelopt=align:right,columns:26
set tabpanelopt=align:right,columns:36
set tabpanelopt=align:right,columns:28

set showtabpanel=2

#--------------------------------------------
# Timer

const RedrawTabpanelInterval = 1000

SetTimer(true)
