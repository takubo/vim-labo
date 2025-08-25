scriptencoding utf-8
" vim: set ts=8 sts=2 sw=2 tw=0 :

if !has('win32') || !has('gui_running')
  finish
endif

if exists('loaded_CygTerm')
  finish
endif
let loaded_CygTerm = v:true

let s:save_cpo = &cpo
set cpo&vim


"com! -nargs=0 SH call system('/cygdrive/C/cygwin/bin/mintty.exe --size maxheight,maxwidth')
"com! -nargs=0 SH call system("/cygdrive/C/cygwin/bin/mintty.exe --title 'Vim Term' --size 160,50 -B void ")
"com! -nargs=0 SH call system("/cygdrive/C/cygwin/bin/mintty.exe --title 'Vim Term' --size 160,50 -B frame")
"com! -nargs=0 SH call system("/cygdrive/C/cygwin/bin/mintty.exe --title 'Vim Term' --size 160,50")
"com! -nargs=0 SH call system("/cygdrive/C/cygwin/bin/mintty.exe --title 'Vim Term' --size 160,50 /cygdrive/C/cygwin/bin/zsh.exe")
"com! -nargs=0 SH call system("/cygdrive/C/cygwin/bin/mintty.exe --option Locale=ja_JP --option Charset=UTF-8 --title 'Vim Term' --size 160,50 /cygdrive/C/cygwin/bin/zsh.exe")
"com! -nargs=0 SH call system("/cygdrive/C/cygwin/bin/mintty.exe --option Locale=ja_JP --option Charset=UTF-8 --title 'Vim Term' --size 160,50 -")


function! s:Sh()
python3 << PYCODE
import subprocess
subprocess.Popen(["C:/cygwin64/bin/mintty.exe", "--title", "Vim Term", "--size", "160,50", "-o", "Locale=ja_JP", "-o", "Charset=UTF-8", "C:/cygwin64/bin/zsh.exe"])  # , "-B", "frame"
PYCODE
endfunction


function! s:ShFront()
python3 << PYCODE
import ctypes
hWnd = ctypes.windll.user32.FindWindowW(None, "Vim Term")
if hWnd is not 0:
  ctypes.windll.user32.SetForegroundWindow(hWnd)
  vim.command(':let found = v:true')
else:
  vim.command(':let found = v:false')
PYCODE
  if !found
    SH
  endif
endfunction


com! SH call s:Sh()
com! -nargs=0 SHFront call s:ShFront()

nnoremap <silent> <C-z> :<C-u>SHFront<CR>


let &cpo = s:save_cpo
unlet s:save_cpo
