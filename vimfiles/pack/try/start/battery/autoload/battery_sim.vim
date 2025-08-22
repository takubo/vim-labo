vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8


import autoload 'battery.vim' as bat


#----------------------------------------------------------------------------------------
# Configuration TODO

# Update()が1回呼ばれるごとに、バッテリー残量を最大何%減らすか。
g:BatterySimReducePercent = exists('g:BatterySimReducePercent') ? g:BatterySimReducePercent : 8.0
# フル充電時の(残り)使用可能時間。
g:BatterySimFullTimeSecond = exists('g:BatterySimFullTimeSecond') ? g:BatterySimFullTimeSecond : 36000

#----------------------------------------------------------------------------------------
# Variables

# 他から自由に干渉できるよう、グローバルスコープとしておく。
g:BatterySimRemainingPercent = 100.0
g:BatterySimRemainingTimeSecond = 36000
g:BatterySimACStatus = bat.ACStatus.NotConnected

g:BatterySimAutoReduce = true


#----------------------------------------------------------------------------------------
# API

export def Update(battery_info: dict<any>)
  BatteryReduce()
  battery_info.RemainingPercent    = g:BatterySimRemainingPercent -> float2nr()
  battery_info.RemainingTimeSecond = g:BatterySimRemainingTimeSecond
  battery_info.ACStatus            = g:BatterySimACStatus
enddef


#----------------------------------------------------------------------------------------
# Changing Status

#--------------------------------------------
# Remaining

def BatteryReduce()
  if !g:BatterySimAutoReduce
    return
  endif

  var remaining_percent = g:BatterySimRemainingPercent

  if remaining_percent <= 0
    remaining_percent = 100
  else
    # 0..N の範囲の乱数を生成して引く
    remaining_percent -= (rand() / pow(2, 32) * g:BatterySimReducePercent)
    if remaining_percent < 0
      remaining_percent = 0
    endif
  endif

  g:BatterySimRemainingPercent = remaining_percent
  g:BatterySimRemainingTimeSecond = float2nr(g:BatterySimFullTimeSecond * remain_percent / 100)   # TODO
enddef

#--------------------------------------------
# AC Status

def ACStatusCompl(ArgLead: string, CmdLine: string, CursorPos: number): string
  return "?\n@\n#\n$"
enddef

com! -nargs=1 -bar -complete=custom,ACStatusCompl BatterySimACStatus {
      #g:BatterySimACStatus = [
      #  '?': bat.ACStatus.Unknown,
      #  '@': bat.ACStatus.NotConnected,
      #  '#': bat.ACStatus.NotCharging,
      #  '$': bat.ACStatus.Changing,
      #][<q-args>]
      g:BatterySimACStatus = <q-args> == '@' ? bat.ACStatus.NotConnected
                           : <q-args> == '#' ? bat.ACStatus.NotCharging
                           : <q-args> == '$' ? bat.ACStatus.Charging
                           :                   bat.ACStatus.Unknown
    }



finish



#----------------------------------------------------------------------------------------
# Dummy (for Demo)

# 旧タイマの削除 (再読み込みする際、古いタイマを削除しないと、どんどん貯まっていってしまう。)
if exists('g:BatteryDemoTimerId') | timer_stop(g:BatteryDemoTimerId) | endif

g:BatteryDemoTimerId = 0


def SimMode(on_off: bool)
  if on_off
    if timer_info(g:BatteryDemoTimerId) == []
      g:BatteryDemoTimerId = timer_start(1000, BatteryReduce, {'repeat': -1})
    endif
  else
    timer_stop(g:BatteryDemoTimerId)
  endif
enddef

SetTimer(true)
