vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8


if !has('osxdarwin')
  finish
endif

if exists('g:loaded_battery_sys')
  finish
endif
g:loaded_battery_sys = true


export def Init(): number
  # 未実装
  return -1
enddef


export def Update(battery_info: dict<any>)
enddef
