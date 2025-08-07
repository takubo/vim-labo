vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8

import "./t1.vim" as t1

export def F(): t1.ACStatus
  return t1.ACStatus.Unknown
enddef
