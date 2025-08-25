vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8


import autoload 'battery.vim' as bat


export def Init(): number
  # 未実装
  return -1
enddef


export def Update(battery_info: dict<any>)
  battery_info.RemainingPercent    = -1
  battery_info.RemainingTimeSecond = -1
  battery_info.ACStatus            = bat.ACStatus.Unknown
enddef
