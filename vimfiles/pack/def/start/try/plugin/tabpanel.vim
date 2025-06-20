vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8


def g:TabPanel(): string
  return printf("[ %d ]\n  %%f", g:actual_curtabpage)
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

set tabpanel=%{g:actual_curtabpage}
set tabpanel=%!g:TabPanel()
set tabpanel=%!g:TabPanel_last_only()
set tabpanel=%!g:TabPanel_cur_only()
set tabpanel=%!g:TabPanel_cur_only_over_test()


#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@@@@@@@@                         @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@@@@@@@@                           @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@@@@@@@@                           @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@@@@@@@@                         @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@@@@@@@@@@@@@                    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@@@@@@@@@@@@@                      @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@@@@@@@@@@@@@                      @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@@@@@@@@@@@@@                    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@@@@@@@@@@@@@@@                  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@@@@@@@@@@@@@@@                    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@@@@@@@@@@@@@@@                    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@@@@@@@@@@@@@@@                  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

const PI = atan2(0, -1) * 2
const tic = 9  # 5
const sins = range(360 / tic) -> map((_, v) => sin(v * tic * PI / 360))
# echo sins
#const sinb = range(15) -> map((_, v) => sin(v * 24 * 3.141592 * 2 / 360)) -> map((_, v) => repeat('*', float2nr(v * 200)))
#const sinb = sins -> mapnew((_, v) => repeat('*', float2nr(v * 100)))
const sinb = sins -> mapnew((_, v) => repeat('*', 22 + float2nr(v * 20)))
#echo sinb
#foreach(sinb, (_, v) => { echo v } )
for i in sinb
  # echo i
endfor
