vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8

#========================================================================================
# Current Function Name
#========================================================================================


import autoload "popup_info.vim" as pui


const NO_FUNC_STR = "###"


def CFIPopup(display_time: number = 2000, line_off: number = 5, col_off: number = 5, already: bool = false)
  const func_name = cfi#format('%s ( )', NO_FUNC_STR)
  if func_name != NO_FUNC_STR
    pui.PopUpInfo(func_name, display_time, line_off, +24)
  endif
  #pui.PopUpInfo(cfi#format("%s ()", "###"), display_time, line_off, +24)
  #pui.PopUpInfo(cfi#format("%s ()", "###"), display_time, -5, +6)
enddef

def CFIPopupNMV(display_time: number = 2000, line_off: number = 5, col_off: number = 5, already: bool = false)
  const func_name = cfi#format('%s ( )', NO_FUNC_STR)
  if func_name != NO_FUNC_STR
    pui.PopUpInfo_NMV(func_name, display_time, line_off, +24)
  endif
enddef


if 1 || exists('*cfi#format')
  com! -bar -nargs=0 CFIPopup     call CFIPopup(-1)
  com! -bar -nargs=0 CFIPopupAuto call CFIPopup()
  com! -bar -nargs=0 CFIPopupNMV  call CFIPopupNMV(2000)
else
  com! -bar -nargs=0 CFIPopup
  com! -bar -nargs=0 CFIPopupAuto
endif
