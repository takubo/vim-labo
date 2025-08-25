vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8


if has('osx')
  finish
endif


augroup MAC_TRY
  autocmd GuiEnter * set guioptions=

  autocmd VimEnter * :call job_start(
        \ ['osascript', '-e', 'tell application "System Events" to key code {102}'],
        \ {'in_io': 'null', 'out_io': 'null', 'err_io': 'null'})
augroup END
