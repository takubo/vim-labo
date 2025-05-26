scriptencoding utf-8
" vim:set ts=8 sts=2 sw=2 tw=0 expandtab: (この行に関しては:help modelineを参照)

if exists('loaded_MultipleHighLight')
  "finish
endif
let loaded_MultipleHighLight = v:true

if !has("gui_running")
  echoerr 'MultiHighLight.vim suppote GUI only.'
  "finish
endif


let s:BgColorSequence = [ "red",   "blue",  "yellow", "magenta", "green", "cyan",  "#ee8822", "#22ee88", "#8822ee", "#ee2288", "#2288ee" ]
let s:FgColorSequence = [ "white", "white", "black",  "white",   "black", "black", "black",   "black",   "black",   "black",   "black"   ]


" ---------------
" Add
" ---------------
function! MultiHighLight_Add(pat)
  if a:pat == ''
    return
  endif

  let n = len(g:HighlightPatterns)

  if n == 0
    call s:set_autocmd()
  endif

  call PushPos_All()
  silent tabdo windo call matchadd('MultiHighLight' . n % s:ColorMax, a:pat, 1, 4 + n)
  call PopPos_All()

  call add(g:HighlightPatterns, a:pat)

  let s:Suspending = v:false
endfunction


" ---------------
" Reset
" ---------------
function! MultiHighLight_Reset()
  call MultiHighLight_Suspend()

  let g:HighlightPatterns = []
endfunction


" ---------------
" Suspend
" ---------------
function! MultiHighLight_Suspend()
  if !s:Suspending
    call PushPos_All()
    silent tabdo windo for i in range(len(g:HighlightPatterns)) | call matchdelete(4 + i) | endfor
    call PopPos_All()
  endif

  call s:unset_autocomd()

  let s:Suspending = v:true
endfunction


" ---------------
" Resume
" ---------------
function! MultiHighLight_Resume()
  call PushPos_All()
  silent tabdo windo for i in range(len(g:HighlightPatterns)) | call matchadd('MultiHighLight' . i % s:ColorMax, g:HighlightPatterns[i], 1, 4 + i) | endfor
  call PopPos_All()

  call s:set_autocmd()

  let s:Suspending = v:false
endfunction


" ---------------
" AutoCmd
" ---------------
function! s:set_autocmd()
  augroup MultiHighLight
    " 新規Windowを開いたときに、auで色を付けないといけない。
    au WinNew * for i in range(len(g:HighlightPatterns)) | call matchadd('MultiHighLight' . i % s:ColorMax, g:HighlightPatterns[i], 1, 4 + i) | endfor
  augroup end
endfunction

function! s:unset_autocomd()
  augroup MultiHighLight
    au!
  augroup end
endfunction


" ---------------
" Init
" ---------------
function! s:init()
  " All Clear
  call PushPos_All()
  silent tabdo windo call clearmatches()
  call PopPos_All()

  " Init Vars
  let s:ColorMax = len(s:BgColorSequence)
  let g:HighlightPatterns = []
  let s:Suspending = v:false  " Suspend中にResetされるとmatchdeleteがエラーになってしまう。

  " Make highlight
  augroup MultiHighLightColor
    au!
  augroup end
  for i in range(s:ColorMax)
    exe 'autocmd MultiHighLightColor VimEnter,ColorScheme * highlight MultiHighLight' . i . ' guifg=' . s:FgColorSequence[i] . ' guibg=' . s:BgColorSequence[i]
  endfor

  call s:unset_autocomd()
endfunction


call s:init()


" TODO
" matchaddのIDを自動取得にする
" Initでは clearmatches しない
" tabdo ではなく、auにする。
" 関数化を進める
" au を set unsetするのではなく、関数内のスイッチで制御する
" EscEsc_Addの処置
" Suspendingをなくしたい
