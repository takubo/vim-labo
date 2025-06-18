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
  var cont = printf('[ %d ]', g:actual_curtabpage)
    .. "\n" ..  printf('[ %d ]', g:actual_curtabpage)
    .. "\n" ..  printf('[ %d ]', g:actual_curtabpage)
    .. "\n" ..  printf('[ %d ]', g:actual_curtabpage)
    .. "\n" ..  line('.') # getcurpos()

  const conts = split(cont, "\n", 1) -> map((_, v) => '%#tabpanel#' .. v)

  return join(conts, "\n") .. repeat("\n%#tabpanel#", &lines - (&cmdheight) - len(conts)) .. '%#StlGoldLeaf#Footer'
 #return '\b%#tabpanel#'
enddef

set tabpanel=%{g:actual_curtabpage}
set tabpanel=%!g:TabPanel()
set tabpanel=%!g:TabPanel_last_only()
set tabpanel=%!g:TabPanel_cur_only()
