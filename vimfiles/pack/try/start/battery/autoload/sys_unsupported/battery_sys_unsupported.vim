vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8


export def Init(): number
  # 未サポートシステムでは、
  # 常に非0(初期化失敗)を返すことで、
  # Update()を呼ばれなくする。
  return -1
enddef


# 常に初期化失敗扱いなのだから、Update()は呼ばれるはずはない。
#
# export def Update(battery_info: dict<any>)
#   battery_info.RemainingPercent    = -1
#   battery_info.RemainingTimeSecond = -1
#   battery_info.ACStatus            = ACStatus.Unknown
# enddef
