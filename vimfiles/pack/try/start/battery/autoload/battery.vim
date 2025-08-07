vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8


#----------------------------------------------------------------------------------------
# Constants

# TODO
if !exists('ACStatus')
export enum ACStatus
  Unknown,
  NotConnected,
  NotCharging,
  Charging,
endenum
endif

const ACStatusStr = [
  ACStatus.Unknown:      '❔',
  ACStatus.NotConnected: '🔋',
  ACStatus.NotCharging:  '🔌',
  ACStatus.Charging:     '⚡',
]


#----------------------------------------------------------------------------------------
# API

export def g:GetBatteryInfo(): dict<any>
  return BatteryInfo
enddef

export def g:GetBatteryInfoStr(): string
  return BatteryInfoStr
enddef


#----------------------------------------------------------------------------------------
# Variables

var BatteryInfo = {
  'RemainingPercent':          0,
  'RemainingTimeSecond':       0,
  'RemainingTimeFormatedStr':  '--:--:--',
 #'FullTimeSecond':            0,
 #'FullTimeFormatedStr':       '--:--:--',
 #'NeedTimeSecond':            0,
 #'NeedTimeFormatedStr':       '--:--:--',
  'ACStatus':                  ACStatus.Unknown,
  'ACStatusStr':               '❔',
}

var BatteryInfoStr = '❔ ---% [--:--:--]'


#----------------------------------------------------------------------------------------
# 遅延初期化

import autoload "battery_inner.vim" as inner

def Init(dummy: number)
  inner.Init
  so './battery_inner.vim'
enddef

timer_start(3000, Init)
