#!/bin/python

from ctypes import windll
from ctypes import Structure, byref
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

def UpdateBatteryInfoSys():
  windll.kernel32.GetSystemPowerStatus(byref(sps))

  ac_line_status = sps.ACLineStatus
  bat_flag = sps.BatteryFlag & 0x08

  charging = bat_flag & 0x08

  if ac_line_status == 1 and charging:
      ac_status = AC_Charging
  elif ac_line_status == 1:
      ac_status = AC_NotCharging
  elif (ac_line_status != 255) and ((bat_flag & 128) != 0) and (bat_flag != 255):
      ac_status = Battery
  else:
      ac_status = Unknown

  # 0～100. 不明時は、-1.
  remaining_percent = sps.BatteryLifePercent

  # 不明時は、-1.
  remaining_time_sec = sps.BatteryLifeTime

  # full_time_sec = sps.BatteryFullLifeTime

  return {
           'RemainingPercent':    remaining_percent,
           'RemainingTimeSecond': remaining_time_sec,
           #'FullTimeSecond':     full_time_sec,
           #'NeedTimeSecond':     need_time_sec,
           'ACStatus':            ac_status,
         }


print(UpdateBatteryInfoSys())


#  status = '?' if ac_line == 255 else '$' if charging else '#' if ac_line == 1 else '@'
#  bat_info['Status'] = status
#
#  percent = sps.BatteryLifePercent
#  bat_info['RemainingPercent'] = ('%3d' % percent if percent != -1 else '---') # + '%%'
#
#  rem_sec = sps.BatteryLifeTime
#  bat_info['RemainingTime'] = '[%2d:%02d:%02d]' % ( rem_sec / 3600, rem_sec % 3600 / 60, rem_sec % 60 ) if rem_sec != -1 else '[--:--:--]'
#
#  bat_info['FullTime'] = '[%2d:%02d:%02d]' % ( full_sec / 3600, full_sec % 3600 / 60, full_sec % 60 ) if full_sec != -1 else '[--:--:--]'
