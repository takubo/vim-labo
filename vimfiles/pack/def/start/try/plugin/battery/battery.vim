vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8


#----------------------------------------------------------------------------------------
# API

export def g:GetBatteryInfo(): dict<any>
  return BatteryInfo
enddef

export def g:GetBatteryInfoStr(): string
  return 'BatteryInfo'
enddef



finish



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
