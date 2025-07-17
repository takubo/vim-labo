vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8



#----------------------------------------------------------------------------------------
# TabPanel Contents Switch

var TabpanelContentsSwitch = {
  'BatteryBar':     false,
  'BatteryGraph':   false,
  'Footer':         true,
  'FooterDiff':     true,
  'FooterStr':      true,
  'Functions':      true,
  'Header':         true,
  'HeaderDateTime': true,
}



#----------------------------------------------------------------------------------------
# Make TabPanelStr

def Header(): string
  const contents_switch = TabpanelContentsSwitch

  if !contents_switch.Header
    return ''
  endif

  if contents_switch.Header && contents_switch.HeaderDateTime
    return '%#TblDate# ' .. strftime('%Y/%m/%d (%a)') .. '%=' .. strftime('%H:%M  ') .. "\n\n"
  elseif contents_switch.Header
    return "%#TblDate#\n"
  endif

  return ''
enddef


def After(): string
  const contents_switch = TabpanelContentsSwitch

  const fs = g:FuncsString()

  if fs != '' && contents_switch.Functions
    return "\n\n" .. Border() .. fs .. "\n" .. Border() .. "\n"
  else
    return "\n\n"
  endif
enddef


def Footer(): string
  const contents_switch = TabpanelContentsSwitch

  var str = ''

  if contents_switch.BatteryBar
    str ..= g:BatteryBar() -> join("\n") .. "\n"
  elseif contents_switch.BatteryGraph
    str ..= g:BatteryGraph_Center() -> join("\n") .. "\n"
  endif

  if !contents_switch.Footer
  elseif contents_switch.FooterDiff
    str ..= '%#StlGoldLeaf#%=%#TblDate# [ ' .. DiffOptStr() .. ' ] %#StlGoldLeaf#%='
   #str ..= '%#TblDate#%= [ ' .. DiffOptStr() .. '%#TblDate# ] %='
   #str ..= '%#TblDate#%= [ ' .. DiffOptStr() .. '%#TblDate# ]  '
   #str ..= '%#TblDate#%=%#StlFill# [ ' .. DiffOptStr() .. ' ] %#TblDate#%='
  elseif contents_switch.FooterStr
    str ..= '%#TblDate#%=[Footer]%='
   #str ..= '%#StlGoldLeaf#%=[Footer]%='
  else
    str ..= '%#TblDate#'
   #str ..= '%#StlGoldLeaf#'
  endif

  return str
enddef


def Border(c: string = '─', hl: string = '%#TabPanel#'): string
  const tc = TabPanelColumn()
  const cw = c -> strdisplaywidth()
  return hl .. repeat(c, tc / cw) .. "\n"
enddef


var AccumNumLine: number

def g:TabPanel(): string
  var str = ''

  const tabnr = g:actual_curtabpage

  # Header
  const header = (tabnr == 1 ? Header() : '')

  # TabLabel
  const body = TabLabel(tabnr)

  if tabnr == 1
    AccumNumLine = header -> CountChar("\n")
  endif

  AccumNumLine += body -> CountChar("\n") + 1

  if tabnr == tabpagenr('$')
    # After
    const after = After()
    AccumNumLine += after -> CountChar("\n")

    # Footer
    const footer = Footer()
    AccumNumLine += footer -> CountChar("\n")

    # Padding
    const tabpanel_height = &lines - &cmdheight
    const padding = '%#TabPanelFill#' .. repeat("\n", tabpanel_height - AccumNumLine)

    # 返り値
    # タブが1つしかない場合に備えて、ここでもheaderを含める必要がある。
    return header .. body .. after .. padding .. footer
  else
    # 返り値
    return header .. body
  endif
enddef


def TabLabel(tabnr: number): string
  # Tab Number
  const tabnrstr = (true && tabnr == tabpagenr() ?
                     '%#TabLineSel#'   :
                     '%#TabPanelTabnr#'
                   )
                   .. printf("[%d]", tabnr) .. "%#TabPanelFill#\n"

  # ウィンドウのリスト
  const winlabels = gettabinfo(tabnr)[0].windows -> map((i, winid) => WinLabel(i + 1, winid, tabnr))
  const winstr = join(winlabels, "\n")  .. "\n"

  return tabnrstr .. winstr
enddef


# TODO
#   タブもhighlightするか
#   マークか、highlightか
#   インデント数
#   ウィンドウ番号の左のhighlightの数
def WinLabel(winnr: number, winid: number, tabnr: number): string
  const wininfo = getwininfo(winid)[0]
  const wintype = win_gettype(winid)
  const buftype = getbufvar(wininfo.bufnr, '&buftype')
  const bufname = expand('#' .. wininfo.bufnr .. ':t')
  const diff    = gettabwinvar(tabnr, winnr, '&diff')

  const curwin = tabnr == tabpagenr() && winnr == tabpagewinnr(tabnr)

  const hl_line = true

  var indent = ''
  var curwin_sign = ''

  if hl_line
    indent ..= (false && curwin ? '%#TabPanelMySel#' : '' )
               .. (false ? ('  ') : ('   '))
    indent ..= (curwin ? '%#TabPanelMySel#' : '' )
               .. (true ? (' ') : (''))
  else
    indent ..= (1 ? ('  ') : ('   '))

    curwin_sign = #(curwin ? '%#StlFill#>%##' : ' ')
                   (curwin ? '%#TblDate#>%##' : ' ')
                  .. ' '
  endif

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
                       wininfo.loclist == 0 && wininfo.quickfix == 0 ? '[無名]' :  # [No Name]
                       ''

  return indent
      .. curwin_sign
      .. winnr_hl   .. winnr_str
      .. info_hl    .. info
      .. bufname_hl .. bufname_show
      .. '%<'
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



#----------------------------------------------------------------------------------------
# Utility Functions


# TabPanelの桁数を返す
# TODO tabline.vimと重複?
def TabPanelColumn(): number
  #? if &showtabpanel == 0 # || (&showtabpanel == 1 && tabpagenr('$') <= 1)
  #?   return 0
  #? endif

  const columns = matchstr(&tabpanelopt, 'columns:\zs\d\+')
  return columns == '' ? 20 : str2nr(columns)
enddef


# str内のcの数を数える
# TODO utilへ
def CountChar(str: string, c: string): number
  return [str] -> matchstrlist(c) -> len()
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
# Switch TabPanel Status & Contents

def SwitchTabpanel(...args: list<string>)
  if args == []
    &showtabpanel = (&showtabpanel == 0 ? 2 : 0 )
    SetTimer(&showtabpanel != 0)
    return
  endif

  args -> foreach((_, val) => {
                    TabpanelContentsSwitch[val] = !TabpanelContentsSwitch[val]
                  } )

  redrawtabpanel

  SetTimer(true)
enddef

def CompletionTbpContents(ArgLead: string, CmdLine: string, CusorPos: number): list<string>
  return keys(TabpanelContentsSwitch) -> filter((_, val) => val =~? ('^' .. ArgLead .. '.*')) -> sort()
enddef

com! -nargs=* -complete=customlist,CompletionTbpContents Tpnl {
  SwitchTabpanel(<f-args>)
}



#----------------------------------------------------------------------------------------
# Switch Show


#--------------------------------------------
# Toggle Show TabPanel

def SwitchShowTabPanel()
  if &showtabpanel == 0
    &showtabpanel = 2
  else
    &showtabpanel = 0
  endif
enddef

nnoremap <Leader>t <ScriptCmd>SwitchShowTabPanel()<CR>


#--------------------------------------------
# Toggle Show TabLine

def SwitchShowTabLine()
  if &showtabline == 0
    &showtabline = 2
  else
    &showtabline = 0
  endif
enddef

nnoremap <Leader>T <ScriptCmd>SwitchShowTabLine()<CR>


#--------------------------------------------
# Switch TabPanel Align

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


#--------------------------------------------
# Change TabPanel Column

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
