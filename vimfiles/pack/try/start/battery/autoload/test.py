def hello():
  print('helpgre')

hello()

def update_battery_info():
  return {
    'percent'       : 'sps.BatteryLifePercent',
    'remaining_sec' : 'sps.BatteryLifeTime',
   #'full_sec'      : 'sps.BatteryFullLifeTime',
    'ac_line'       : 'sps.ACLineStatus',
    'charging'      : 'sps.BatteryFlag & 0x08',
  }

print(update_battery_info())
