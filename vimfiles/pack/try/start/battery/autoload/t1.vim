vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8

import "./t2.vim" as t2

export enum ACStatus
  Unknown,
  NotConnected,
  NotCharging,
  Charging
endenum

def G()
  echo t2.F()
enddef

def H()
  echo 90
enddef

com! TTT call <SID>G()
