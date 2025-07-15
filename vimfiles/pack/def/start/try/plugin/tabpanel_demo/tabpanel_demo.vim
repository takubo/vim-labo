vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8


finish


def g:TabPanel_Demo_new(): string
  # Header
  const header = TabPanel_Demo_Header()

  # Footer
  const footer = TabPanel_Demo_Footer()

  # Body
  const body = TabPanel_Demo_Body()

  # Padding
  const cont_lines = len(header) + len(body) + len(footer)
  const padding = repeat("%#tabpanel#\n", &lines - &cmdheight - cont_lines)

  return join(header, "\n") .. "\n" .. join(body, "\n") .. "\n" .. padding .. join(footer, "\n")
enddef

# Header
def TabPanel_Demo_Header(): list<string>
  var header: list<string>
  const tabnr = '%#StlGoldLeaf# [' .. g:actual_curtabpage .. ']'
  header = [tabnr, '%#TabLine#']
  return header
enddef

import './battery_demo.vim' as b

hi TabPanelSel	guifg=#d0c5a9	guibg=black	gui=NONE	cterm=NONE

# Footer
def TabPanel_Demo_Footer(): list<string>
  var footer: list<string>

  footer = [
    '',
    '',
    '',
    '',
  ]

  footer += b.Demo()

  footer += [
    '',
    '',
    '%#StlGoldLeaf#            [Footer]',
  ]

  return footer
enddef

import './funcs.vim' as f

# Body
def TabPanel_Demo_Body(): list<string>
  var body: list<string>

  body = f.Funcs()

  if body == []
    body = ['']
  endif

  body = body -> map((_, v) => '%#TabLine#' .. v .. '%<%')

  return body
enddef

def Old()
  const footer = TabPanel_Demo_Footer()
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


set tabpanelopt=align:right,columns:25
set tabpanelopt=align:right,columns:35
set tabpanel=%!g:TabPanel_Demo_new()


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


#----------------------------------------------------------------------------------------
# TabLine Timer

# 旧タイマの削除 (再読み込みする際、古いタイマを削除しないと、どんどん貯まっていってしまう。)
if exists('g:RedrawTabPanelTimerId') | timer_stop(g:RedrawTabPanelTimerId) | endif

g:RedrawTabPanelTimerId = 0

def SetTimer(on: bool = true)
  # TODO 一定間隔で更新する必要があるコンテンツがあるときのみ、タイマーを有効にする。

  if timer_info(g:RedrawTabPanelTimerId) == []
    g:RedrawTabPanelTimerId = timer_start(RedrawTabPanelInterval, (dummy) => execute('redrawtabpanel'), {'repeat': -1})
  endif
enddef


#----------------------------------------------------------------------------------------
# Initial Setting

const RedrawTabPanelInterval = 1500

SetTimer(true)
