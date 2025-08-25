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
 #ACStatus.Unknown.ordinal:      '❔',
 #ACStatus.NotConnected.ordinal: '🔋',
 #ACStatus.NotCharging.ordinal:  '🔌',
 #ACStatus.Charging.ordinal:     '⚡',
]


const ACStatusEmoji = [
  '❔',
  '🔋',
  '🔌',
  '⚡',
]


const ACStatusChar = [
  '?',
  '@',
  '#',
  '$',
]



#----------------------------------------------------------------------------------------
# API

export def BatteryInfo(): dict<any>
  return batteryInfo
enddef

export def BatteryInfoStr(): string
  return batteryInfoStr
enddef

export def BatteryPercent(): number
  return batteryPercent
# TODO 削除
 #return max([batteryInfo.RemainingPercent, 0])
 #return batteryInfo.RemainingPercent
enddef



#----------------------------------------------------------------------------------------
# 更新

import autoload 'util_func.vim' as uf

def Update(_: number = 0)
  if false
    # TODO UpdateSim()
  else
    sys.Update(batteryInfo)
  endif

  # 残り時間の文字列表現 (HH:MM:SS)
  batteryInfo.RemainingTimeFormatedStr = batteryInfo.RemainingTimeSecond >= 0 ?
                                         uf.TimeFormat_Sec2Str(batteryInfo.RemainingTimeSecond) :
                                         '--:--:--'

  batteryInfo.ACStatusEmoji = ACStatusEmoji[batteryInfo.ACStatus.ordinal]  # 電源への接続状態の絵文字表現
  batteryInfo.ACStatusChar  = ACStatusChar[batteryInfo.ACStatus.ordinal]   # 電源への接続状態のASCII文字表現

 #'FullTimeFormatedStr':       '--:--:--',        # 満充電時の使用可能時間の文字列表現 (HH:MM:SS)
 #'NeedTimeFormatedStr':       '--:--:--',        # 満充電までの時間の文字列表現 (HH:MM:SS)
 #'ACPlugedStatusEmoji':       Unknown,
 #'ChargingStatusEmoji':       Unknown,
 #'RemainingPercentStr':       printf('%3d%%', RemainingPercent),

  # Example:
  #                  '❓ ---% [--:--:--]'
  #                  '🔋  35% [ 2:04:43]'
  #                  '🔌 100% [10:04:43]'
  #                  '⚡  87% [ 8:04:43]'
  batteryInfoStr = batteryInfo.ACStatusEmoji
                   .. (batteryInfo.RemainingTimeSecond >= 0 ?
                        printf(' %3d%%%%%', batteryInfo.RemainingPercent) :  # tablineなどで使えるように、%を重ねている。
                        ' ---%%'
                      )
                   .. printf(' [%8s]', batteryInfo.RemainingTimeFormatedStr)

  batteryPercent = max([batteryInfo.RemainingPercent, 0])

  # Callback
  doautocmd User BatteryInfoUpdate
enddef


var Dummy = 0
augroup BatteryDummy
  au!
  au User BatteryInfoUpdate Dummy = 0
augroup end



#----------------------------------------------------------------------------------------
# 初期化


#--------------------------------------------
# Variables

var batteryInfo = {
  'RemainingPercent':          -1,                # 残りパーセント
  'RemainingTimeSecond':       -1,                # 残り秒数
  'RemainingTimeFormatedStr':  '--:--:--',        # 残り時間の文字列表現 (HH:MM:SS)
 #'FullTimeSecond':            -1,                # 満充電時の使用可能秒数
 #'FullTimeFormatedStr':       '--:--:--',        # 満充電時の使用可能時間の文字列表現 (HH:MM:SS)
 #'NeedTimeSecond':            -1,                # 満充電までの秒数
 #'NeedTimeFormatedStr':       '--:--:--',        # 満充電までの時間の文字列表現 (HH:MM:SS)
  'ACStatus':                  ACStatus.Unknown,  # 電源への接続状態 (不明 / 非接続 / 接続&非充電 / 充電中 )
  'ACStatusEmoji':             '❔',              # 電源への接続状態の絵文字表現
  'ACStatusChar':              '?',               # 電源への接続状態のASCII文字表現
 #'ACPlugedStatus':            Unknown,
 #'ChargingStatus':            Unknown,
 #'ACPlugedStatusEmoji':       Unknown,
 #'ChargingStatusEmoji':       Unknown,
 #'SaverMode':                 Unknown,
 #'RemainingPercentStr':       printf('%3d%%', RemainingPercent),
}

var batteryInfoStr = '❓ ---% [--:--:--]'
#                    '❔ ---% [--:--:--]'
#                    '? ---% [--:--:--]'

var batteryPercent = 0


#--------------------------------------------
# システム選択

if exists('g:BatteryNet') && g:BatteryNet
  import autoload 'sys_net/battery_sys_net.vim' as sys
elseif has('osx')
  import autoload 'sys_osx/battery_sys_osx.vim' as sys
elseif has('win32')
  import autoload 'sys_dos/battery_sys_dos.vim' as sys
else
  import autoload 'sys_unsupported/battery_sys_unsupported.vim' as sys
endif


#--------------------------------------------
# 遅延初期化

def Init(_: number)
  const init_status = sys.Init()
  # oecho init_status

  if init_status == 0
    Update()  # 初回更新
    timer_start(15000, Update, {'repeat': -1})
  endif
enddef

timer_start(3000, Init)  # 遅延初期化のタイマー
