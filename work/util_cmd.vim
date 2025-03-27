com! Unicode normal! g8


"---------------------------------------------------------------------------------------------
" vimrc

nnoremap <silent> gL :<C-u>call GLLLL()<CR>

function! GLLLL()
  PushPosAll
  let wrap = !&l:wrap
  windo let &l:wrap = wrap
  PopPosAll
endfunction



" vim.vim {{{

function! TempHighLight()
  let w = expand("<cword>")
  let g:TagMatch0 = matchadd('TagMatch', '\<'.w.'\>')
  let g:TimerTagMatch0 = timer_start(1500, 'QQQQ')
  let g:TagMatchI[g:TimerTagMatch0] = g:TagMatch0
endfunction

" vim.vim }}}



func! s:func_copy_cmd_output(cmd)
  redir @*>
  silent execute a:cmd
  redir END
endfunc

command! -nargs=1 -complete=command CopyCmdOutput call <SID>func_copy_cmd_output(<q-args>)




" type は、"r"かそれ以外""
"exe "r!~/bin/matsub " . expand("#24:p") . " " . expand("#23:p")
function! Test0(type, cmd, ...)

  "let cmd = (a:type == 'r' ? a:type : '') . '!' . a:cmd
  let cmd = (a:type == 'r' ? a:type : '') . '!' . (a:cmd == '0' ? expand('%:p') : a:cmd)

  if a:0 == 0
    let cmd .= ' ' .  expand('%:p')
  else
    for i in a:000
      if i =~ '^\d\+$'
        let cmd .= ' ' . (i == 0 ? expand('%:p') : expand('#' . i . ':p'))
      else 
        let cmd .= ' ' . i
      endif
    endfor
  endif

  "echo cmd
  exe cmd
endfunction
" call Test0("r", "ls", 5, 8)
com! -nargs=* R call Test0('r', <f-args>)
com! -nargs=* P call Test0('n', <f-args>)



" IncSubstitude
"

function! IncSubstitude(...)
  echo a:000 a:0 a:1 a:2 a:3
  normal! gg
  for i in range(1, a:2)
    normal! n
    "echo i
    "exe 'normal! ' . '/' . a:1
    let s = 's/' . a:1 . '/' . printf(a:3, i) . '/'
    "echo s
    exe s
    "red
    "sleep 0.5
  endfor
endfunction
com! -nargs=* IncSubstitude call IncSubstitude('@', <f-args>)
"IncSubstitude 15 【テストケース%d】




"com! -nargs=? CheckIncludes CommnadOutputCapture checkpath! | normal! /<args><CR>
com! -nargs=? CheckIncludes CommnadOutputCapture checkpath! | call feedkeys('/<args><CR>', 'n')
com! -nargs=? CheckPath CommnadOutputCapture checkpath! | call feedkeys('/<args><CR>', 'n')



nnoremap : :<C-u>find<Space>
nnoremap <Leader>: :<C-u>find<Space>
nnoremap <Leader>g :<C-u>find<Space>
nnoremap <Leader>G :<C-u>sfind<Space>



"-------------------------------------------------------------------
" カーソル下のhighlight情報を表示する {{{

function! s:get_syn_id(transparent)
    let synid = synID(line('.'), col('.'), 1)
    return a:transparent ? synIDtrans(synid) : synid
endfunction

function! s:get_syn_name(synid)
    return synIDattr(a:synid, 'name')
endfunction

function! s:get_highlight_info()
    execute "highlight " . s:get_syn_name(s:get_syn_id(0))
    execute "highlight " . s:get_syn_name(s:get_syn_id(1))
endfunction

command! HighlightInfo call s:get_highlight_info()

"-------------------------------------------------------------------

" カーソル下のhighlight情報を表示する {{{

function! s:get_syn_id(transparent, col)
  let synid = synID(line('.'), a:col, 1)
  return a:transparent ? synIDtrans(synid) : synid
endfunction

function! s:get_syn_name(synid)
  return synIDattr(a:synid, 'name')
endfunction

function! g:Get_highlight_info(show, cont)
  let N = 10	" とりあえず10。普通はbreakする。

  let old = ""

  for i in range(N)	" 普通はbreakする。
    let hl = s:get_syn_name(s:get_syn_id(i, col('.')))

    if hl == old | break | endif
    let old = hl

    if a:show | echo '. ' . hl i | endif

    if hl =~? 'comment'	| return -1 | endif		" Block Comment
    if hl =~? 'string'	| return  1 | endif		" String
  endfor

  if a:cont
    let old = ""
    for i in range(N)	" 普通はbreakする。
      let hl = s:get_syn_name(s:get_syn_id(i, 1))

      if hl == old | break | endif
      let old = hl

      if a:show | echo '1 ' . hl | endif

      if hl =~? 'comment'	| return -1 | endif		" Block Comment
      "if hl =~? 'string'	| return  1 | endif		" String
    endfor
  endif

  return 0	" Normal
endfunction

command! HighlightInfo call g:Get_highlight_info(1, 1)


function! g:Get_highlight_info_LineLast(show, cont, off)
  let N = 10	" とりあえず10。普通はbreakする。

  let old = ""

  for i in range(N)	" 普通はbreakする。
    let hl = s:get_syn_name(s:get_syn_id(i, col('.')+a:off))

    if hl == old | break | endif
    let old = hl

    if a:show | echo '. ' . hl i | endif

    if hl =~? 'comment'	| return -1 | endif		" Block Comment
    if hl =~? 'string'	| return  1 | endif		" String
  endfor

  if a:cont
    let old = ""
    for i in range(N)	" 普通はbreakする。
      let hl = s:get_syn_name(s:get_syn_id(i, 1))

      if hl == old | break | endif
      let old = hl

      if a:show | echo '1 ' . hl | endif

      if hl =~? 'comment'	| return -1 | endif		" Block Comment
      "if hl =~? 'string'	| return  1 | endif		" String
    endfor
  endif

  return 0	" Normal
endfunction
