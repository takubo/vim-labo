vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8


import autoload "./battery.vim" as bat


#----------------------------------------------------------------------------------------
# Initialize

export def Init()
  #--------------------------------------------
  # Timer

  #--------------------------------------------
  # System-Initialize
enddef


#----------------------------------------------------------------------------------------
# Battery Infomation Update

def UpdateBatteryInfo(dummy: number)
  #--------------------------------------------
  # System
  const bi = UpdateBatteryInfoSys()

  #--------------------------------------------
  # Format
  const ac_status_str = bat.ACStatusStr[bi.ACStatus]

  if bi.RemainingTimeSecond != -1
    const hour    = bi.RemainingTimeSecond / 3600
    const minutes = bi.RemainingTimeSecond % 3600 / 60
    const second  = bi.RemainingTimeSecond % 60 )
    const remaining_time_formated_str = printf('%2d:%02d:%02d', hour, minutes, second)
  else
    const remaining_time_formated_str = '--:--:--'
  endif

  bi.ACStatusStr = ac_status_str
  bi.RemainingTimeFormatedStr = remaining_time_formated_str

  #--------------------------------------------
  # Battery Information Str
  battery_info_str = ac_status_str .. ' ' ..
                     printf('%3d', bi.RemainingPercent) .. '%% ' ..
                     '[' .. remaining_time_formated_str .. ']'
  #--------------------------------------------
  # Update
  BatteryInfo    = bi
  BatteryInfoStr = battery_info_str

  #--------------------------------------------
  # Callback
enddef



finish



def time_format(sec: number): dict<number>
  const hour    = rem_sec / 3600
  const minutes = rem_sec % 3600 / 60
  const second  = rem_sec % 60 )
enddef


#----------------------------------------------------------------------------------------
# Battery Infomation Update

def UpdateBatteryInfo(dummy: number)
  const info = UpdateBatteryInfoEnv()

  return {
    'RemainingPercent':          info.RemainingPercent,
    'RemainingPercentStr':       printf('%3d%%', info.Percent)
    'RemainingTimeSecond':       0,
    'RemainingTimeFormatedStr':  0.0,
    'FullTimeSecond':            0.0,
    'FullTimeFormatedStr':       0.0,
    'ACPlugedStatus':            0.0,
    'ACPlugedStatusEmoji':       0.0,
    'ChargingStatus':            0.0,
    'ChargingStatusEmoji':       0.0,
  }
  return {
    'RemainingPercent':          info.RemainingPercent,
    'RemainingTimeSecond':       0,
    'RemainingTimeFormatedStr':  0.0,
   #'FullTimeSecond':            0.0,
   #'FullTimeFormatedStr':       0.0,
    'NeedTimeSecond':            0.0,
    'NeedTimeFormatedStr':       0.0,
    'ACStatus':                  0.0,
    'ACStatusStr':               0.0,
  }
enddef

def UpdateBatteryInfoEnv()
  return {
    'RemainingPercent':          0.0,
    'RemainingTimeSecond':       0,
    'FullTimeSecond':            0.0,
    'ACPlugedStatus':            0.0,
    'ChargingStatus':            0.0,
  }
  return {
    'RemainingPercent':    0.0,
    'RemainingTimeSecond': 0,
   #'FullTimeSecond':      0,
    'NeedTimeSecond':      0,
    'ACStatus':            Unknown,
   #'SaverMode':           Unknown,
  }
enddef


#----------------------------------------------------------------------------------------
# Information Update Timer

# 旧タイマの削除 (再読み込みする際、古いタイマを削除しないと、どんどん貯まっていってしまう。)
if exists('g:UpdateBatteryInfoTimerId') | timer_stop(g:UpdateBatteryInfoTimerId) | endif

g:UpdateBatteryInfoTimerId = 0

def SetTimer(on: bool)
  if on
    if timer_info(g:UpdateBatteryInfoTimerId) == []
      g:UpdateBatteryInfoTimerId = timer_start(UpdateBatteryInfoInterval, 'UpdateBatteryInfo', {'repeat': -1})
    endif
  else
    timer_stop(g:UpdateBatteryInfoTimerId)
  endif
enddef


#----------------------------------------------------------------------------------------
# Initialize

#--------------------------------------------
# TODO

const InitialStatus = false

#--------------------------------------------
# Timer

const BatteryInfoUpdateInterval = 15000

SetTimer(InitialStatus)


#--------------------------------------------

#  ❔  ?
#  🔋  @
#  🔌  #
#  ⚡  $

#export def g:GetBatteryInfoStr(): string
#  #return '🔋  85%% [10:04:43]'
#  return '🔌  85%% [10:04:43]'
#  #return '? ---% [--:--:--]'
#enddef



#--------------------------------------------

❓

❔
🔋
🔌
⚡

Unknown
Battery
AC_NotCharging
AC_Charging

Unknown
Battery
AC-NotCharging
AC-Charging



Unknown
Battery
AC

Unknown
NotCharging
Charging








const ACStatusStr = [
  bat.ACStatus.Unknown:      '❔',
  bat.ACStatus.NotConnected: '🔋',
  bat.ACStatus.NotCharging:  '🔌',
  bat.ACStatus.Charging:     '⚡',
]
