vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8


def TabPanelHeader(): string
  return '%#TblDate# '
    .. strftime('%Y/%m/%d (%a)')
    .. '%=' .. strftime('%H:%M  ')
    .. "\n"

 #return "\n"
enddef


def TabPanelFooter(): string
  if 1
    return '%#TblDate# '
  # return '%#StlGoldLeaf# '
  elseif 0
  # return join(conts, "\n") .. repeat("\n%#tabpanel#", &lines - (&cmdheight) - len(conts)) .. '%#StlGoldLeaf#            [Footer]'
  else
    return g:BatteryGraph() -> join("\n") .. "\n" .. '%#TblDate# '
  endif
  return ''
enddef


def TabPanelAdding(): string
 #return '%#TblDate# '
  return "\n\n\n" .. g:FuncsString()
 #return "\n"
enddef


def CountChar(str: string, c: string): number
  return [str] -> matchstrlist(c) -> len()
enddef

var LinesAccum = 0

def g:TabPanel(): string
  var str = ''

  const tabnr = g:actual_curtabpage

  # Header
  const header = tabnr == 1 ? TabPanelHeader() : ''

  # Tabs
  const body = Tabs(tabnr)

  if tabnr == 1
    LinesAccum = header -> CountChar("\n")
  endif

  LinesAccum += body -> CountChar("\n") + 1

  if tabnr == tabpagenr('$')
    # Adding
    const adding = TabPanelAdding()
    LinesAccum += adding -> CountChar("\n")

    # Footer
    const footer = TabPanelFooter()
    LinesAccum += footer -> CountChar("\n")

    # Padding
    const tabpanel_height = &lines - &cmdheight
    const padding = '%#tabpanel#' .. repeat("\n", tabpanel_height - LinesAccum)

    # 返り値
    return header .. body .. adding .. padding .. footer
  else
    # 返り値
    return header .. body
  endif
enddef


def Tabs(tabnr: number): string
  var str = ''

  # Tab Number
  if 0
    if tabnr == tabpagenr()
      str ..= '%#TabLineSel#'
    else
      str ..= '%#PopupNotification#'
    endif
    str ..= printf("[%d]\n", tabnr)
  elseif 0
    str ..= '%#StlFill#'
    str ..= '%#TabLineSel#'
    str ..= printf("[%d]", tabnr)
    str ..= '%##'
    str ..= "\n"
  else
    if tabnr == tabpagenr()
      str ..= '%#TabLineSel#'
    else
      str ..= '%#StlFill#'
      str ..= '%#PopupNotification#'
    endif
    str ..= printf("[%d]", tabnr)
    str ..= '%##'
    str ..= "\n"
  endif

  # ウィンドウのリスト
  const wins = gettabinfo(tabnr)[0].windows -> map((i, winid) => WinStr(i + 1, winid, tabnr))
  str ..= '  ' .. join(wins, "\n  ") .. "\n"
 #str ..= '   ' .. join(wins, "\n   ") .. "\n"

  return str
enddef

def WinStr(winnr: number, winid: number, tabnr: number): string
  var winstr = ''

  winstr ..= tabnr == tabpagenr() && winnr == tabpagewinnr(tabnr) ? '%#TabLineSel#>%## ' : '  '

  const wininfo = getwininfo(winid)[0]
  const wintype = win_gettype(winid)
  const buftype = getbufvar(wininfo.bufnr, '&buftype')
  const bufname = expand('#' .. wininfo.bufnr .. ':t')
  const diff    = win_execute(winid, "setl diff?")  # getwinvar(winid, '&diff')
  #const diff2   =  getwinvar(winid, '&diff')

  var type = ''

  #type ..= (diff == 'diff' ? '[Diff]' : '')
  #type ..= (type(diff2) == v:t_bool && diff2 || type(diff2) == v:t_string && diff == 'diff' ? '[Diff2] ' : '')
  type ..= (diff !~# 'nodiff' ? '[Diff] ' : '')
  #if diff !~# 'nodiff'
  #  type ..= (type != '' ? ' ' : '') .. '[Diff]'
  #endif

  type ..=
  wininfo.loclist  == 1 ? '[Locationリスト]' :  # [Location List]
  wininfo.quickfix == 1 ? '[Quickfixリスト]' :  # [Quickfix List]
  wininfo.terminal == 1 ? '[Terminal]' :
  wintype == 'preview'  ? '[Preview]' :
  buftype == 'help'     ? '[Help]' :
  buftype == 'prompt'   ? '[Prompt]' :
  buftype == 'nowrite'  ? '[No Write]' :
  buftype == 'nofile'   ? '[No File]' :
  bufname == ''         ? '[無名]' :  # '[No Name]' :
  ''

  type ..= (type != '' && type[-1] != ' ' ? ' ' : '')

  winstr ..= ''
    .. '%#TabPanelBufName#'
    .. '%##'
    .. winnr .. '. '
    .. '%#TabPanelBufName#'
    .. '%##'
    .. type
    #.. type(diff2) .. ' ' .. type(diff)
    .. '%##'
    .. '%#TabPanelBufName#'
    .. bufname .. '%<'

  return winstr
enddef



#----------------------------------------------------------------------------------------
# TabPanale Timer

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
      g:RedrawTabpanelTimerId = timer_start(RedrawTabpanelInterval, (dummy) => execute('redrawtabpanel'), {'repeat': -1})
    endif
  else
    timer_stop(g:RedrawTabpanelTimerId)
  endif
enddef



#----------------------------------------------------------------------------------------
# Options

set tabpanel=%!g:TabPanel_last_only()
set tabpanel=%!g:TabPanel_cur_only_over_test()
set tabpanel=%!g:TabPanel()

set tabpanelopt=align:right,columns:26
set tabpanelopt=align:right,columns:36


const RedrawTabpanelInterval = 1000

SetTimer(true)


#----------------------------------------------------------------------------------------
# Toggle Sho Tab Panel

com! ShowTabPanel {
  if &showtabpanel == 0
    &showtabpanel = 2
  else
    &showtabpanel = 0
  endif
}

nnoremap <Leader>t <Cmd>ShowTabPanel<CR>
