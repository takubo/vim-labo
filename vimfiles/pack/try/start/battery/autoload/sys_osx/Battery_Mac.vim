scriptencoding utf-8
" vim: set ts=8 sts=2 sw=2 tw=0 :

if !has('mac')
  finish
endif


let UpdateBatteryInfoInterval = 10 * 1000    " 10 sec


function! UpdateBatteryInfo(dummy)
  let g:bat_info['RemainingPercent'] = '🔋🔌' . system("ioreg -l | grep 'AppleRaw\\(Max\\|Current\\)Capacity' | sed 's/[^0-9]//g' | awk 'BEGIN{ RS=\"\"}{ printf \"%3d\", int($1 / $2 * 100 + 0.49) }'") . '%%'
  "echo g:bat_info['RemainingPercent']
  let g:BatteryInfo =  g:bat_info['RemainingPercent']
  "let g:BatteryInfo = g:bat_info['Status'] . ' ' . g:bat_info['RemainingPercent'] . ' ' . g:bat_info['RemainingTime']
endfunction

function! UpdateBatteryInfo(dummy)
"
" $ pmset -g batt
" Now drawing from 'AC Power'
"  -InternalBattery-0 (id=5636195)	100%; charged; 0:00 remaining present: true
" 
" $ pmset -g batt
" Now drawing from 'Battery Power'
"  -InternalBattery-0 (id=5636195)	100%; discharging; (no estimate) present: true
"

  let cmd_out = system('pmset -g batt')
  let cmd_out_array = split(cmd_out, '\n')

  "PrettyPrint cmd_out_array

  "let charging = match(cmd_out_array[0], 'AC Power') == -1 ? v:false : v:true
  let charging = match(cmd_out_array[0], 'AC Power') > -1
  "let remaining_percent = matchstr(cmd_out_array[1], '\d\+\(%\)\@=')
  "残り%は、ioregの方が正確？少なくとも、少なく出る。
  let remaining_percent = system("ioreg -l | grep 'AppleRaw\\(Max\\|Current\\)Capacity' | sed 's/[^0-9]//g' | awk 'BEGIN{ RS=\"\"}{ printf \"%3d\", int($1 / $2 * 100 + 0.49) }'")

  "if !charging
  "  let remaining_time = matchstr(cmd_out_array[1], '\d\+:\d\+')
  "else
  "  let remaining_time = 'TODO'
  "endif
  let remaining_time = matchstr(cmd_out_array[1], '\d\+:\d\+')

  "echo charging remaining_percent remaining_time

  let g:bat_info['Changing'] = charging ? '🔌' : '🔋' 

  "let g:bat_info['RemainingPercent'] = printf('%3d', remaining_percent) . '%%'
  let g:bat_info['RemainingPercent'] = remaining_percent . '%%'

  let g:bat_info['RemainingTime'] = printf('%4s', remaining_time)

  let g:BatteryInfo = g:bat_info['Changing'] . ' ' . g:bat_info['RemainingPercent'] . ' ' . g:bat_info['RemainingTime']
  "echo g:BatteryInfo
endfunction

function! UpdateBatteryInfo(dummy = 0)
"
" $ pmset -g batt
" Now drawing from 'AC Power'
"  -InternalBattery-0 (id=5636195)	100%; charged; 0:00 remaining present: true
" 
" $ pmset -g batt
" Now drawing from 'Battery Power'
"  -InternalBattery-0 (id=5636195)	100%; discharging; (no estimate) present: true
"

  let cmd_out = system('pmset -g batt')
  let cmd_out_array = split(cmd_out, '\n')
  "PrettyPrint cmd_out_array

  "let ac_connected = match(cmd_out_array[0], 'AC Power') == -1 ? v:false : v:true
  let ac_connected = match(cmd_out_array[0], 'AC Power') > -1
  let g:bat_info['AcConnected'] = ac_connected ? '🔌' : '🔋' 

  "let g:bat_info['Changing'] = ''

  if 1
    let remaining_percent = matchstr(cmd_out_array[1], '\d\+\(%\)\@=')
    let g:bat_info['RemainingPercent'] = printf('%3d', remaining_percent) . '%%'
  else
    "残り%は、ioregの方が正確？少なくとも、少なく出る。
    let remaining_percent = system("ioreg -l | grep 'AppleRaw\\(Max\\|Current\\)Capacity' | sed 's/[^0-9]//g' | awk 'BEGIN{ RS=\"\"}{ printf \"%3d\", int($1 / $2 * 100 + 0.49) }'")
    let g:bat_info['RemainingPercent'] = remaining_percent . '%%'
  endif

  "if !charging
  "  let remaining_time = matchstr(cmd_out_array[1], '\d\+:\d\+')
  "else
  "  let remaining_time = 'TODO'
  "endif
  let remaining_time = matchstr(cmd_out_array[1], '\d\+:\d\+')
  let g:bat_info['RemainingTime'] = printf('%4s', remaining_time)
  if g:bat_info['RemainingTime'] =~ '^\s*$'
    let g:bat_info['RemainingTime'] = '0:00'
  endif

  "let g:BatteryInfo = g:bat_info['AcConnected'] . ' ' . g:bat_info['RemainingPercent'] . ' ' . g:bat_info['RemainingTime']
  let g:BatteryInfo = g:bat_info['AcConnected'] .. ' [' .. g:bat_info['RemainingPercent'] . '] ' . g:bat_info['RemainingTime']
  "echo g:BatteryInfo
endfunction


" 旧タイマの削除
if exists('TimerUbi')
  call timer_stop(TimerUbi)
endif

let TimerUbi = timer_start(UpdateBatteryInfoInterval, 'UpdateBatteryInfo', {'repeat': -1})


let g:bat_info = {}

try
  call UpdateBatteryInfo()
catch
  let g:BatteryInfo = '？ ---%% [--:--]'
endtry
