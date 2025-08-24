finish

if has('mac')
  augroup IME_Mac
    autocmd!
    autocmd InsertLeave * :call job_start(
	  \ ['osascript', '-e', 'tell application "System Events" to key code {102}'],
	  \ {'in_io': 'null', 'out_io': 'null', 'err_io': 'null'})
    autocmd VimEnter * :call job_start(
	  \ ['osascript', '-e', 'tell application "System Events" to key code {102}'],
	  \ {'in_io': 'null', 'out_io': 'null', 'err_io': 'null'})
    autocmd GuiEnter * set guioptions=
  augroup END



  function! Mac_ime_off()
    call job_start(
	  \ ['osascript', '-e', 'tell application "System Events" to key code {102}'],
	  \ {'in_io': 'null', 'out_io': 'null', 'err_io': 'null'})
  endfunction
  "call EscEsc_Add('call Mac_ime_off()')
endif
