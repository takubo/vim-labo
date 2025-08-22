vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8



import autoload 'battery.vim' as bat


com! BatteryInfo    echo <SID>bat.BatteryInfo()
com! BatteryInfoStr echo <SID>bat.BatteryInfoStr()
com! BatteryPercent echo <SID>bat.BatteryPercent()
