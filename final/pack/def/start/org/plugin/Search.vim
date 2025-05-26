scriptencoding utf-8
" vim:set ts=8 sts=2 sw=2 tw=0 expandtab: (この行に関しては:help modelineを参照)

if exists('loaded_Search')
  "finish
  call MultiHighLight_Reset()
else
  call EscEsc_Add('call MultiHighLight_Suspend()')
  call EscEsc_Add('let g:MultiHighLightState = 2')
endif
let loaded_Search = v:true

let g:anzu_status_format = '/%p ( %i / %l )'
let g:anzu_search_limit = 999

let g:SearchProcTopUnderScore = v:false
let g:SearchMultiHighLight = v:true


let g:MultiHighLightState = 0
"    0:初期値、multipleは未実施。または、/や*で再検索されリセットされた状態。
"    1:multipleによるハイライト中
"    2:EscEscでハイライトが中断された状態


function! s:SearchToggleProcTopUnderScore()
  let g:SearchProcTopUnderScore = !g:SearchProcTopUnderScore
  echo 'ProcTopUnderScore ' g:SearchProcTopUnderScore ? 'ON' : 'OFF'
endfunction


function! s:SearchToggleMultiHighLight()
  let g:SearchMultiHighLight = !g:SearchMultiHighLight
  if !g:SearchMultiHighLight
    call MultiHighLight_Reset()
  endif
  echo 'MultiHighLight ' g:SearchMultiHighLight ? 'ON' : 'OFF'
endfunction


function! s:SearchSlashCR()
  if g:SearchMultiHighLight
    "call MultiHighLight_Suspend()
    call MultiHighLight_Reset()
    let g:MultiHighLightState = 0
  endif
  call <SID>SearchPost()
endfunction


function! s:SearchN()
  if g:SearchMultiHighLight
    if g:MultiHighLightState == 2
      call MultiHighLight_Resume()
    endif
    let g:MultiHighLightState = 1
  endif
  call <SID>SearchPost()
endfunction


function! s:SearchCWord(add, proc_top_underscore, aword, keep_pos)
  let search_str = expand('<cword>')

  if a:proc_top_underscore
    let search_str = ProcTopUnderScore(search_str)
  endif

  if a:aword
    let search_str = '\<' . search_str . '\>'
  endif

  if g:SearchMultiHighLight
    if a:add && g:MultiHighLightState == 0
      call MultiHighLight_Add(@/)
    elseif a:add && g:MultiHighLightState == 2
      call MultiHighLight_Resume()
    elseif !a:add
      call MultiHighLight_Reset()
    endif
    call MultiHighLight_Add(search_str)
    let g:MultiHighLightState = 1
  endif

  if a:add
    let @/ .= '\|' . search_str
  else
    let @/ = search_str
  endif

  "検索履歴に残すための処理
  call histadd('/', @/)

  let cursor_word = CursorWord()
  let old_cursor_pos = getpos('.')

  try
    normal! n
  catch
  endtry

  " ここの複雑な条件は、keep処理と、常にカーソルを単語の先頭に動かすための処理が合わさっているもの。
  let new_cursor_pos = getpos('.')
  if (a:keep_pos && (old_cursor_pos != new_cursor_pos && cursor_word != 0 || cursor_word == 1)) ||
   \ (!a:keep_pos && old_cursor_pos == new_cursor_pos && cursor_word == 1)
    try
      normal! N
    catch
    endtry
  endif

  call s:SearchPost()
endfunction


function! s:SearchPost()
  normal! zv
  AnzuUpdateSearchStatusOutput
  FuncNameStl
  call AddAltStatusline('      %<%#hl_func_name_stl#  %{anzu#search_status()} %##', 'l', 0)
endfunction


com! SearchToggleProcTopUnderScore * call <SID>SearchToggleProcTopUnderScore()
com! SearchToggleMultiHighLight    * call <SID>SearchToggleMultiHighLight()


" CONST
"
unlockvar s:SearchNew s:SearchAdd s:MatchWord s:MatchPart

let s:SearchNew = v:false
let s:SearchAdd = v:true

let s:MatchWord = v:true
let s:MatchPart = v:false

let s:CursorKeep = v:true
let s:CursorMove = v:false

lockvar s:SearchNew s:SearchAdd s:MatchWord s:MatchPart

com! SearchCWordNewWordMove call <SID>SearchCWord(s:SearchNew, g:SearchProcTopUnderScore, s:MatchWord, s:CursorMove) | set hlsearch
com! SearchCWordNewPartMove call <SID>SearchCWord(s:SearchNew, g:SearchProcTopUnderScore, s:MatchPart, s:CursorMove) | set hlsearch
com! SearchCWordAddWordMove call <SID>SearchCWord(s:SearchAdd, g:SearchProcTopUnderScore, s:MatchWord, s:CursorMove) | set hlsearch
com! SearchCWordAddPartMove call <SID>SearchCWord(s:SearchAdd, g:SearchProcTopUnderScore, s:MatchPart, s:CursorMove) | set hlsearch

com! SearchCWordNewWordKeep call <SID>SearchCWord(s:SearchNew, g:SearchProcTopUnderScore, s:MatchWord, s:CursorKeep) | set hlsearch
com! SearchCWordNewPartKeep call <SID>SearchCWord(s:SearchNew, g:SearchProcTopUnderScore, s:MatchPart, s:CursorKeep) | set hlsearch
com! SearchCWordAddWordKeep call <SID>SearchCWord(s:SearchAdd, g:SearchProcTopUnderScore, s:MatchWord, s:CursorKeep) | set hlsearch
com! SearchCWordAddPartKeep call <SID>SearchCWord(s:SearchAdd, g:SearchProcTopUnderScore, s:MatchPart, s:CursorKeep) | set hlsearch




" Plug Mapping

nnoremap <silent> <Plug>(Search-CWord-New-Word-Move) :<C-u>SearchCWordNewWordMove<CR>
nnoremap <silent> <Plug>(Search-CWord-New-Part-Move) :<C-u>SearchCWordNewPartMove<CR>
nnoremap <silent> <Plug>(Search-CWord-Add-Word-Move) :<C-u>SearchCWordAddWordMove<CR>
nnoremap <silent> <Plug>(Search-CWord-Add-Part-Move) :<C-u>SearchCWordAddPartMove<CR>

nnoremap <silent> <Plug>(Search-CWord-New-Word-Keep) :<C-u>SearchCWordNewWordKeep<CR>
nnoremap <silent> <Plug>(Search-CWord-New-Part-Keep) :<C-u>SearchCWordNewPartKeep<CR>
nnoremap <silent> <Plug>(Search-CWord-Add-Word-Keep) :<C-u>SearchCWordAddWordKeep<CR>
nnoremap <silent> <Plug>(Search-CWord-Add-Part-Keep) :<C-u>SearchCWordAddPartKeep<CR>

nnoremap <silent> <Plug>(Search-n) n:call <SID>SearchN()<CR>
nnoremap <silent> <Plug>(Search-N) N:call <SID>SearchN()<CR>

cnoremap <silent> <Plug>(Search-SlashCR) <CR>:call <SID>SearchSlashCR()<CR>

nnoremap <silent> <Plug>(Search-TopUnderScore)         :call <SID>SearchToggleProcTopUnderScore()<CR>
nnoremap <silent> <Plug>(SearchT-ToggleMultiHighLight) :call <SID>SearchToggleMultiHighLight()<CR>


" Test
com! TestProcTopUnderScore echo ProcTopUnderScore('word') | echo ProcTopUnderScore('_word') | echo ProcTopUnderScore('0word')

