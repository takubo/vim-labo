vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8


if !has('win32')
  finish
endif


import autoload 'battery.vim' as bat


export def Init(): number
  try
    python3 << EOF

from ctypes          import windll
from ctypes          import Structure, byref
from ctypes.wintypes import BYTE, LONG

class SystemPowerStatus(Structure):
  # https://msdn.microsoft.com/ja-jp/library/windows/desktop/aa373232(v=vs.85).aspx
  _fields_ = [
    ('ACLineStatus', BYTE),
    ('BatteryFlag', BYTE),
    ('BatteryLifePercent', BYTE),
    ('Reserved1', BYTE),
    ('BatteryLifeTime', LONG),
    ('BatteryFullLifeTime', LONG),
  ]

sps = SystemPowerStatus()

def update_battery_info():
  windll.kernel32.GetSystemPowerStatus(byref(sps))

  return {
    'percent'       : sps.BatteryLifePercent,
    'remaining_sec' : sps.BatteryLifeTime,
   #'full_sec'      : sps.BatteryFullLifeTime,
    'ac_line'       : sps.ACLineStatus,
    'charging'      : sps.BatteryFlag & 0x08,
  }

EOF

  catch
    return -1
  endtry
  return 0
enddef


export def Update(battery_info: dict<any>)
  const sys_battery_info = py3eval('update_battery_info()')

  # TODO -1の確認

  battery_info.RemainingPercent    = sys_battery_info.percent
  battery_info.RemainingTimeSecond = sys_battery_info.remaining_sec
 #battery_info.FullTimeSecond      = sys_battery_info.full_sec
  battery_info.ACStatus            = sys_battery_info.ac_line == 255 ? bat.ACStatus.Unknown      :
                                     sys_battery_info.charging       ? bat.ACStatus.Charging     :
                                     sys_battery_info.ac_line == 1   ? bat.ACStatus.NotCharging  :
                                                                       bat.ACStatus.NotConnected
enddef
