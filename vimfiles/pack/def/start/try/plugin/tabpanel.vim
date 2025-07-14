vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8


def TabPanelHeader(): string
  return "\n"
enddef

def g:TabPanel(): string
  var str = ''

  # Header
  const header = TabPanelHeader()

  const tabnr = g:actual_curtabpage

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

  # str ..= "  %t%<\n"

  if 0
    # タブ内のバッファのリスト
    const bufnrs = tabpagebuflist(tabnr)

    # バッファ数
    # const bufnum_str = '(' .. len(bufnrs) .. ')'

    # カレントバッファ番号
    const curbufnr = bufnrs[tabpagewinnr(tabnr) - 1]  # tabpagewinnr()は、 1始まり。

    # カレントバッファ名
    const bufname_tmp = expand('#' .. curbufnr .. ':t')

    const bufname = bufname_tmp == '' ? 'No Name' : bufname_tmp  # 無名バッファは、バッファ名が出ない。

    str ..= '  ' .. bufname
  endif

  if 0
    # タブ内のバッファのリスト
    const bufnrs = tabpagebuflist(tabnr)

    # バッファ名のリスト
    const bufnames = bufnrs -> mapnew((i, bufnr) => BufNameStr(i + 1, bufnr))

    # 無名バッファは、バッファ名が出ない。

    # const bufnames = bufname_tmp == '' ? 'No Name' : bufname_tmp

    str ..= '   ' .. join(bufnames, "\n   ") .. "\n"
  endif

  if 0
    # タブ内のウィンドウのリスト
    const winnrs = range(1, tabpagewinnr(tabnr, '$'))

    # ウィンドウ名のリスト
    const winnames = winnrs -> mapnew((i, winnr) => WinStr(winnr, 0))

    str ..= '   ' .. join(winnames, "\n   ") .. "\n"
  endif

  if 1
    # ウィンドウ名のリスト
    const winnames = gettabinfo(tabnr)[0].windows -> map((i, winid) => WinStr(i + 1, winid, tabnr))

    str ..= '  ' .. join(winnames, "\n  ") .. "\n"
   #str ..= '   ' .. join(winnames, "\n   ") .. "\n"
  endif

  #str ..= "\n"
  return str
enddef

def WinStr(winnr: number, winid: number, tabnr: number): string
  var winstr = ''

  winstr ..= tabnr == tabpagenr() && winnr == tabpagewinnr(tabnr) ? '%#TabLineSel#>%## ' : '  '

  const wininfo = getwininfo(winid)[0]
  const wintype = win_gettype(winid)
  const buftype = getbufvar(wininfo.bufnr, '&buftype')
  const bufname = BufName(wininfo.bufnr)
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

def BufNameStr(winnr: number, bufnr: number): string
 #const bufnamestr = winnr .. '. ' .. BufName(bufnr) .. '%<'
  var bufnamestr = ''
  bufnamestr ..= '%#TabPanelBufName#'
  bufnamestr ..= '%##'
  bufnamestr ..= winnr .. '. ' .. BufName(bufnr) .. '%<'
  return bufnamestr
enddef

def BufName(bufnr: number): string
  var bufname_tmp = expand('#' .. bufnr .. ':t')
  #if bufname_tmp == ''
  #  bufname_tmp = '[No Name]'
  #endif
  const bufinfo = getbufinfo(bufnr)
  return bufname_tmp
enddef


def g:TabPanel_last_only(): string
 #if g:actual_curtabpage == tabpagenr('$')
  if g:actual_curtabpage == 1
    return '%#TabLineSel#Func' .. repeat("\n", 200)
  endif
  return '\b%#tabpanel#'
 #return '\b%#tabpanel#' .. repeat("\n", 200)
enddef

def g:TabPanel_cur_only_0(): string
  return "%#tabpanel#" .. printf("[ %d ]", g:actual_curtabpage) .. repeat("\n%#tabpanel#", &lines - (&cmdheight) - 1)
 #return '\b%#tabpanel#'
enddef

def g:TabPanel_cur_only(): string
  var cont =    printf('[ %d ]', g:actual_curtabpage)
    .. "\n" ..  printf('[ %d ]', g:actual_curtabpage)
    .. "\n" ..  printf('[ %d ]', g:actual_curtabpage)
    .. "\n" ..  printf('[ %d ]', g:actual_curtabpage)
    .. "\n" ..  line('.') # getcurpos()


    .. "\n" .. ''
    .. "\n" .. ''
    .. "\n" .. ''
    .. "\n" .. ''
   #.. "\n" .. '@@@@@@@@@@@@@@@@@@@@@@@@'
   #.. "\n" .. '@@@@@@@@@@@@@@@@@@@@@@@@'
   #.. "\n" .. '@@                  @@@@'
   #.. "\n" .. '@@                    @@'
   #.. "\n" .. '@@                    @@'
   #.. "\n" .. '@@                  @@@@'
   #.. "\n" .. '@@@@@@@@@@@@@@@@@@@@@@@@'
   #.. "\n" .. '@@@@@@@@@@@@@@@@@@@@@@@@'


 #const sinc = sins -> mapnew((_, v) => repeat('*', 12 + float2nr(v * 10))) -> join("\n") .. "\n"
 #const sinc = sins -> mapnew((_, v) => repeat('*', abs(float2nr(v * 20)))) -> join("\n") .. "\n"
 #cont ..= sinc


  const grfs = range(30) -> mapnew((_, v) => repeat('*', float2nr(20 * rand() / pow(2, 32)))) -> join("\n") .. "\n"
 #cont ..= grfs


  cont ..=
       "\n" .. ''
    .. "\n" .. ''
    .. "\n" .. ''
    .. "\n" .. ''
   #.. "\n" .. '@@@@@@@@@@@@@@@@@@@@@@@@'
   #.. "\n" .. '@@@@@@@@@@@@@@@@@@@@@@@@'
   #.. "\n" .. '@@                  @@@@'
   #.. "\n" .. '@@                    @@'
   #.. "\n" .. '@@                    @@'
   #.. "\n" .. '@@                  @@@@'
   #.. "\n" .. '@@@@@@@@@@@@@@@@@@@@@@@@'
   #.. "\n" .. '@@@@@@@@@@@@@@@@@@@@@@@@'


  const conts = split(cont, "\n", 1) -> map((_, v) => '%#tabpanel#' .. v)

  return join(conts, "\n") .. repeat("\n%#tabpanel#", &lines - (&cmdheight) - len(conts)) .. '%#StlGoldLeaf#            [Footer]'
 #return join(conts, "\n") .. repeat("\n%#tabpanel#", &lines - (&cmdheight) - len(conts))
 #return '\b%#tabpanel#'
enddef

def g:TabPanel_cur_only_over_test(): string
  # set line=102 cmdheight=2
  const t = g:actual_curtabpage
  const l = (&lines - 2)
  const ADD = 0
  # const sta = ((t - 1) * l) + ((t - 1) * 2) + 1 + 1
  const sta = line('w0')
  const end = sta + l - &cmdheight - 1 + ADD
  var cont =    printf('[ %d ]', g:actual_curtabpage)
  #.. ( range(2, 100) -> map((_, v) => "\n" .. v) -> join(''))
  .. ( range(sta, end) -> map((_, v) => "\n" .. v) -> join(''))
  #.. repeat("\n$", 98 + 98)

  const conts = split(cont, "\n", 1) -> map((_, v) => '%#tabpanel#' .. v)

  return join(conts, "\n") .. "\n" .. '%#StlGoldLeaf#            [Footer]'
enddef


#----------------------------------------------------------------------------------------
# Options

set tabpanel=%!g:TabPanel_last_only()
set tabpanel=%!g:TabPanel_cur_only_over_test()
set tabpanel=%!g:TabPanel()

set tabpanelopt=align:right,columns:26


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
