vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8


# https://www.choge-blog.com/programming/macterminal-checkbattery/
# https://qiita.com/ktdatascience/items/47ace06ca266f6afd075


if !has('osx')
  finish
endif


export def Init(): number
  # 一度実行してみる。
  # 出力行数も確認。
  try
    const cmd_out_len = system('pmset -g batt') -> split('\n') -> len()
    if cmd_out_len < 2
      return -2
    endif
  catch
    return -1
  endtry
  return 0
enddef


export def Update(battery_info: dict<any>)
  # Example of Output of `pmset' Command:
  #
  #   $ pmset -g batt
  #   Now drawing from 'AC Power'
  #    -InternalBattery-0 (id=5636195)	100%; charged; 0:00 remaining present: true
  #
  #   $ pmset -g batt
  #   Now drawing from 'Battery Power'
  #    -InternalBattery-0 (id=5636195)	100%; discharging; (no estimate) present: true
  #

  # https://www.choge-blog.com/programming/macterminal-checkbattery/
  #
  # 電源状態：’AC Power’（電源接続）または ‘Battery Power’（バッテリー駆動）
  # 充電レベル：81%（現在の充電残量）
  # 状態：discharging（放電中）、charging（充電中）、charged（充電完了）
  # 残り時間：2:34 remaining（推定残り時間）


  const cmd_out_array = system('pmset -g batt') -> split('\n')
  # PrettyPrint cmd_out_array


  var ac_status: ACStatus = ACStatus.Unknown
  {
    if match(cmd_out_array[0], 'Battery Power') >= 0
      ac_status = ACStatus.NotConnected
    elseif match(cmd_out_array[1], '\<charging\>') >= 0
      ac_status = ACStatus.Charging
    else
      ac_status = ACStatus.NotCharging
    endif
  }


  const remaining_percent = matchstr(cmd_out_array[1], '\t\zs\d\+\ze%;') -> str2nr()
  # 残り%は、ioregの方が正確？少なくとも、少なく出る。
  # const remaining_percent = system("ioreg -l | grep 'AppleRaw\\(Max\\|Current\\)Capacity' | sed 's/[^0-9]//g' | awk 'BEGIN{ RS=\"\"}{ printf \"%3d\", int($1 / $2 * 100 + 0.49) }'")


  var remaining_time: number
  {

    const remaining_time_str = matchstr(cmd_out_array[1], '\d\+:\d\+')

    if remaining_time_str != ''
      const remaining_time_array = split(remaining_time_str, ':')
      const hour    = str2nr(remaining_time_array[0])
      const minutes = str2nr(remaining_time_array[1])
      remaining_time = hour * 3600 + minutes * 60
    else
      remaining_time = -1
    endif

    #if !charging
    #  let remaining_time = matchstr(cmd_out_array[1], '\d\+:\d\+')
    #else
    #  let remaining_time = 'TODO'
    #endif
  }


  # echo remaining_percent remaining_time ac_status


  battery_info.RemainingPercent    = remaining_percent
  battery_info.RemainingTimeSecond = remaining_time
 #battery_info.FullTimeSecond      = -1
  battery_info.ACStatus            = ac_status
enddef
