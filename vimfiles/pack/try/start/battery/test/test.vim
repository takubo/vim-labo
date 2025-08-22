vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8


import autoload 'battery.vim' as bat


com! -nargs=0 -bar BatteryInfo    echo <SID>bat.BatteryInfo()
com! -nargs=0 -bar BatteryInfoStr echo <SID>bat.BatteryInfoStr()
com! -nargs=0 -bar BatteryPercent echo <SID>bat.BatteryPercent()
