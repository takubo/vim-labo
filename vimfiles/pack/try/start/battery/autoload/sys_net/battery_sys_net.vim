vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8


if exists('g:loaded_battery_sys')
  finish
endif
g:loaded_battery_sys = true


export def Init(): number
  # 未実装
  return -1
enddef


export def Update(battery_info: dict<any>)
  battery_info.RemainingPercent    = -1
  battery_info.RemainingTimeSecond = -1
  battery_info.ACStatus            = ACStatus.Unknown
enddef
