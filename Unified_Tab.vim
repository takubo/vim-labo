set encoding=utf-8
scriptencoding utf-8
" vim:set ts=8 sts=2 sw=2 tw=0 expandtab:
" (この行に関しては:help modelineを参照)


function Unified_Tab(m)
  if &diff
    if a:m > 0
      " Next Hunk
      normal! ]c
    else
      " Previouse Hunk
      normal! [c
    endif
    normal! ^

  "elseif win_getid()->getwininfo()[0].loclist == 1
  elseif IsLocationlistWindowOpen()
    "例外をキャッチしないと、最初と最後の要素の次に移動しようとして例外で落ちる。
    try
      if a:m > 0
        lnext
      else
        lprev
      endif
    catch /:E553/
      " TODO Popup Windowにする？
      echohl Search
      echo a:m > 0 ?  'Last location list.' : '1st location list.'
      echohl None
    endtry

  else
    "例外をキャッチしないと、最初と最後の要素の次に移動しようとして例外で落ちる。
    try
      if a:m > 0
        cnext
      else
        cprev
      endif
    catch /:E553/
      " TODO Popup Windowにする？
      echohl Search
      echo a:m > 0 ?  'Last error list.' : '1st error list.'
      echohl None
    endtry
  endif

  FuncNameStl
  return
endfunction


function! GetLocationlistWinid()
  return getloclist(winnr(), {'winid' : 0}).winid
endfunction

function! IsLocationlistWindowOpen()
  return GetLocationlistWinid() != 0
endfunction



"---------------------------------------------------------------------------------------------
nnoremap <silent>         t :<C-u>call Unified_Tab( 1)<CR>
nnoremap <silent>         T :<C-u>call Unified_Tab(-1)<CR>
nnoremap <silent>        gt :<C-u>cfirst<CR>
nnoremap <silent>        gT :<C-u>clast<CR>
nnoremap <silent> <Leader>T :<C-u>cc<CR>


nnoremap <silent>       m :<C-u>call Unified_Tab( 1)<CR>
nnoremap <silent>       M :<C-u>call Unified_Tab(-1)<CR>

nnoremap <silent>         <Tab> :<C-u>call Unified_Tab( 1)<CR>
nnoremap <silent>       <S-Tab> :<C-u>call Unified_Tab(-1)<CR>
nnoremap <silent>        g<Tab> :<C-u>cfirst<CR>
nnoremap <silent>        g<Tab> :<C-u>clast<CR>
nnoremap <silent> <Leader><Tab> :<C-u>cc<CR>

"nnoremap <silent>       t ^
"nnoremap <silent>       T $

"nnoremap <silent>       m J



"---------------------------------------------------------------------------------------------
com! IIG InsertIncludeGurd
com! InsertIncludeGurd call s:InsertIncludeGurd()


function! s:InsertIncludeGurd()
  let fn = expand('%')
  let fn = toupper(fn)
  let fn = substitute(fn, '\W', '_', 'g')
  let fn = (exists('g:IncludeGuardPrefix') ? g:IncludeGuardPrefix : '') . fn
  let fn0 = "#ifndef\t" . fn
  let fn1 = "#define\t" . fn
  let fn2 = "#endif\t/* " . fn . " */"
  call append(0, fn0)
  call append(1, fn1)
  call append(line('$'), fn2)
  echo fn
endfunction



"---------------------------------------------------------------------------------------------

" com! -nargs=? -complete=customlist,s:CompletionTabline Tabline call <SID>ToggleTabline(<args>)

function! s:ToggleTabline(arg)
  if (a:arg . '') == ''
    echo s:TablineStatus
  elseif (a:arg . '') == '+'
    let s:TablineStatus = ( s:TablineStatus + 1 ) % s:TablineStatusNum
  elseif (a:arg . '') == '-'
    let s:TablineStatus = ( s:TablineStatus - 1 ) % s:TablineStatusNum
  elseif a:arg < s:TablineStatusNum
    let s:TablineStatus = a:arg
  else
    echoerr 'Tabline:Invalid argument.'
    return
  endif

  let &showtabline = ( s:TablineStatus == 0 ? 0 : 2 )

  call UpdateTabline(0)
endfunction

let s:TablineStatusNum = 8

function! s:CompletionTabline(ArgLead, CmdLine, CusorPos)
  return map(range(0, s:TablineStatusNum), 'v:val . ""') + ['+', '-']
endfunction


nnoremap m J
vnoremap m J
nnoremap gm gJ
vnoremap gm gJ
nmap M <Plug>(MyVimrc-Window-AutoNew)
nmap U <Plug>(MyVimrc-Window-AutoNew)



"---------------------------------------------------------------------------------------------
iab FORI for ( uint32_t i = 0U; i < N; i++ ) {<CR><CR>}
iab <silent> FORI for ( uint32_t i = 0U; i < N; i++ ) {<CR><CR>}<C-R>=Eatchar('\s')<CR>



"---------------------------------------------------------------------------------------------
nnoremap <Leader><C-s>           :<C-u>g%<C-r>/%s    %%%g<Left><Left><Left>
vnoremap <Leader><C-s>                :g%<C-r>/%s     %%%g<Left><Left><Left>

nnoremap <Leader><C-s>           :<C-u>g!<C-r>/!<Space>
vnoremap <Leader><C-s>                :g!<C-r>/!<Space>


"---------------------------------------------------------------------------------------------

let s:Ind = 4

function! IfStruct()
  let ind = -s:Ind
  for i in range(1, line('$'))
    let c = getline(i)

    if c =~# 'T_PortLvdsCfg'
      "echo repeat(' ', ind < 0 ? 0 : s:Ind * ind) . '........................................'
      echo repeat(' ', s:Ind + ind) . '........................................'
    endif
    if i == line('.')
      "echo repeat(' ', ind < 0 ? 0 : s:Ind * ind) . '........................................'
    endif

    if     c =~# '^\s*#\s*if'
      let ind += s:Ind
    elseif c =~# '^\s*#\s*elif'
    elseif c =~# '^\s*#\s*else'
    elseif c =~# '^\s*#\s*endif'
    else
      continue
    endif
    echo repeat(' ', s:Ind * ind) . c

    if     c =~# '^\s*#\s*endif'
      " 見やすいように、endifの後には空行を出力。
      echo "\n"
      let ind -= s:Ind
    endif
  endfor
endfunction

function! IfStruct()
  let ind = -s:Ind
  for i in range(1, line('$'))
    let c = getline(i)

    if c =~# 'T_PortLvdsCfg'
      echo repeat(' ', ind + s:Ind) . "T_PortLvdsCfg"
    endif
    if i == line('.')
      "echo repeat(' ', ind + s:Ind) . '........................................'
    endif

    if     c =~# '^\s*#\s*if'
      let ind += s:Ind
    elseif c =~# '^\s*#\s*elif'
    elseif c =~# '^\s*#\s*else'
    elseif c =~# '^\s*#\s*endif'
    else
      continue
    endif
    echo repeat(' ', ind) . c

    if     c =~# '^\s*#\s*endif'
      " 見やすいように、endifの後には空行を出力。
      echo "\n"
      let ind -= s:Ind
    endif
  endfor
endfunction

com! IfStruct call IfStruct()


com! IfS call s:cmd_out_capture()

function! s:cmd_out_capture()
  new
  silent put =execute('IfStruct')
  1,2delete _
endfunction


function! s:CommnadOutput()
  redir => result
  silent execute 'IfStruct'
  redir END
  return result
endfunction

" let @*=execute('IfStruct')



"---------------------------------------------------------------------------------------------

cnoremap <expr> <C-v><Space> '<' . 'Space' . '>'



"---------------------------------------------------------------------------------------------

" 無名バッファなら、pwd。そうでなければ、保存。
nnoremap <expr> <silent> <leader>w bufname() == '' ? ':<C-u>pwd<CR>' : ':<C-u>update<CR>'



"---------------------------------------------------------------------------------------------

cmap <expr> <CR> ( getcmdtype() == '/' ) ?
               \ ( '<Plug>(Search-SlashCR)' ) :
               \ ( getcmdtype() == ':' && getcmdline() =~# '^:*cd \?') ?
               \ ( '<C-e><C-u>echo "cdは使用禁止。pw[d]かlc[d]を使用。"<CR>' ) :
               \ ( getcmdtype() == ':' && getcmdline() =~# '^:*lcd\? *$') ?
               \ ( '<C-e><C-u>echo "引数なしのlcdは使用禁止。pw[d]を使用。"<CR>' ) :
               \ ( '<CR>' )



"---------------------------------------------------------------------------------------------

nnoremap <Leader><C-p> :<C-u>call <SID>next_nonamebuf(-1)<CR>
nnoremap <Leader><C-n> :<C-u>call <SID>next_nonamebuf(+1)<CR>

function! s:next_nonamebuf(n)
  let first_buf = 1
  let cur_buf = bufnr()
  let last_buf = bufnr('$')

  if a:n > 0
    let sta1 = cur_buf + 1
    let end1 = last_buf

    let sta2 = first_buf
    let end2 = cur_buf - 1

    let dis = +1
  else
    let sta1 = cur_buf - 1
    let end1 = first_buf

    let sta2 = last_buf
    let end2 = cur_buf + 1

    let dis = -1
  endif

  if !s:next_nonamebuf_sub(sta1, end1, dis)
    call s:next_nonamebuf_sub(sta2, end2, dis)
  endif
endfunction

function! s:next_nonamebuf_sub(sta, end, dis )
  "echo  a:sta a:end a:dis
  for i in range(a:sta, a:end, a:dis)
    "echo i bufname(i)
    if buflisted(i) && bufname(i) == '' " && buf modified
      exe 'b' i
      return v:true
    endif
  endfor
  return v:false
endfunction



"---------------------------------------------------------------------------------------------

nnoremap ' "






"---------------------------------------------------------------------------------------------




