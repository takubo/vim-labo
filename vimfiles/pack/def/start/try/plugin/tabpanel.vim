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
  if 1
    return '%#TblDate#'
  elseif 0
    return '%#StlGoldLeaf#'
  elseif 0
    return '%#StlGoldLeaf#%=[Footer]%='
  else
    return g:BatteryGraph() -> join("\n") .. "\n" .. '%#TblDate#'
  endif
enddef


def TabpanelAdding(): string
 #return '%#TblDate# '
  return "\n\n\n" .. g:FuncsString()
 #return "\n"
enddef


# str内のcの数を数える
def CountChar(str: string, c: string): number
  return [str] -> matchstrlist(c) -> len()
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
      g:RedrawTabpanelTimerId = timer_start(RedrawTabpanelInterval, (dummy) => execute('redrawtabpanel'), {'repeat': -1})
    endif
  else
    timer_stop(g:RedrawTabpanelTimerId)
  endif
enddef



#----------------------------------------------------------------------------------------
# Toggle Show TabPanel

com! ShowTabPanel {
  if &showtabpanel == 0
    &showtabpanel = 2
  else
    &showtabpanel = 0
  endif
}

nnoremap <Leader>t <Cmd>ShowTabPanel<CR>



#----------------------------------------------------------------------------------------
# Initialize

#--------------------------------------------
# Options

set tabpanel=%!g:TabPanel_last_only()
set tabpanel=%!g:TabPanel_cur_only_over_test()
set tabpanel=%!g:TabPanel()

set tabpanelopt=align:right,columns:26
set tabpanelopt=align:right,columns:36


#--------------------------------------------
# Timer

const RedrawTabpanelInterval = 1000

SetTimer(true)
