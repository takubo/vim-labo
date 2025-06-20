vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8


def g:TabPanel_cur_only_new(): string
  # Header
  # Footer

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

set tabpanel=%!g:TabPanel_cur_only()
