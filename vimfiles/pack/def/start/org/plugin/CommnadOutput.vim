scriptencoding utf-8
" vim: set ts=8 sts=2 sw=2 tw=0 :

if exists('loaded_CommnadOutput')
  finish
endif
let loaded_CommnadOutput = v:true

let s:save_cpo = &cpo
set cpo&vim


function! s:cmd_out_capture(args, banged)
  new
  silent put =CommnadOutput(join(a:args))
  1,2delete _
endfunction


function! s:cmd_out_yank(args, banged)
  silent let @* = CommnadOutput(join(a:args))
endfunction


function! CommnadOutputLine(args)
  return split(CommnadOutput(a:args), '\n')
endfunction


function! CommnadOutput(cmd)
  redir => result
  silent execute a:cmd
  redir END
  return result
endfunction


command! -nargs=+ -bang -complete=command CommnadOutputCapture call s:cmd_out_capture([<f-args>], <bang>0)
command! -nargs=+ -bang -complete=command CommnadOutputYank    call s:cmd_out_yank([<f-args>], <bang>0)


let &cpo = s:save_cpo
unlet s:save_cpo
