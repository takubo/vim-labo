if !has('gui_running') || (!has('win32') && !has('win64'))
  finish
endif

let g:vimtweak_dll_path = expand('<sfile>:p:h:h') . (has('win64') ? '/vimtweak64.dll' : '/vimtweak32.dll')



command! -nargs=1 -bar VimTweakSetAlpha call libcallnr(g:vimtweak_dll_path, "SetAlpha", 0+<args>)
command! -bar VimTweakEnableMaximize call libcallnr(g:vimtweak_dll_path, "EnableMaximize", 1)
command! -bar VimTweakDisableMaximize call libcallnr(g:vimtweak_dll_path, "EnableMaximize", 0)
command! -bar VimTweakEnableTopMost call libcallnr(g:vimtweak_dll_path, "EnableTopMost", 1)
command! -bar VimTweakDisableTopMost call libcallnr(g:vimtweak_dll_path, "EnableTopMost", 0)
command! -bar VimTweakEnableCaption call libcallnr(g:vimtweak_dll_path, "EnableCaption", 1)
command! -bar VimTweakDisableCaption call libcallnr(g:vimtweak_dll_path, "EnableCaption", 0)
