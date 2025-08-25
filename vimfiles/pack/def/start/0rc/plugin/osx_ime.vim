vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8


if has('osx')
  finish
endif


augroup OSX_IME
    au!
    au InsertLeave * job_start(
                                ['osascript', '-e', 'tell application "System Events" to key code {102}'],
                                {'in_io': 'null', 'out_io': 'null', 'err_io': 'null'}
                              )
    au CmdwinLeave * job_start(
                                ['osascript', '-e', 'tell application "System Events" to key code {102}'],
                                {'in_io': 'null', 'out_io': 'null', 'err_io': 'null'}
                              )
augroup END


def OSX_IME_Off()
  job_start(
        ['osascript', '-e', 'tell application "System Events" to key code {102}'],
        {'in_io': 'null', 'out_io': 'null', 'err_io': 'null'}
  )
enddef
