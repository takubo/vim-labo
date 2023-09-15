set encoding=utf-8
scriptencoding utf-8
" vim:set ts=8 sts=2 sw=2 tw=0 expandtab:
" (この行に関しては:help modelineを参照)



"---------------------------------------------------------------------------------------------

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



"---------------------------------------------------------------------------------------------

nnoremap m J
vnoremap m J
nnoremap gm gJ
vnoremap gm gJ
nmap M <Plug>(MyVimrc-Window-AutoNew)
nmap U <Plug>(MyVimrc-Window-AutoNew)



"---------------------------------------------------------------------------------------------

iab FORI for ( uint32_t i = 0U; i < N; i++ ) {<CR><CR>}
iab <silent> FORI for ( uint32_t i = 0U; i < N; i++ ) {<CR><CR>}<C-R>=Eatchar('\s')<CR>

iab LOOP while ( 1 ) {<CR>}



"---------------------------------------------------------------------------------------------
nnoremap <Leader><C-s>           :<C-u>g%<C-r>/%s    %%%g<Left><Left><Left>
vnoremap <Leader><C-s>                :g%<C-r>/%s     %%%g<Left><Left><Left>

nnoremap <Leader><C-s>           :<C-u>g!<C-r>/!<Space>
vnoremap <Leader><C-s>                :g!<C-r>/!<Space>



"---------------------------------------------------------------------------------------------
" if-def の構造を可視化する。

let s:Indent = 4

"? function! IfDefStruct()
"?   let ind = -s:Indent
"?   for i in range(1, line('$'))
"?     let c = getline(i)
"? 
"?     if i == line('.')
"?       "echo repeat(' ', ind < 0 ? 0 : s:Indent * ind) . '........................................'
"?     endif
"? 
"?     if     c =~# '^\s*#\s*if'
"?       let ind += s:Indent
"?     elseif c =~# '^\s*#\s*elif'
"?     elseif c =~# '^\s*#\s*else'
"?     elseif c =~# '^\s*#\s*endif'
"?     else
"?       continue
"?     endif
"?     echo repeat(' ', s:Indent * ind) . c
"? 
"?     if     c =~# '^\s*#\s*endif'
"?       " 見やすいように、endifの後には空行を出力。
"?       echo "\n"
"?       let ind -= s:Indent
"?     endif
"?   endfor
"? endfunction

function! IfDefStruct()
  let ind = -s:Indent
  for i in range(1, line('$'))
    let c = getline(i)

    if i == line('.')
      echo repeat(' ', ind + s:Indent) . '........................................'
    endif

    if     c =~# '^\s*#\s*if'
      let ind += s:Indent
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
      let ind -= s:Indent
    endif
  endfor
endfunction

com! IfDefStruct call IfDefStruct()


com! IfDefStructInBuffer call s:IfDefStructInBuffer()

"? function! s:IfDefStructInBuffer()
"?   new
"?   silent put =execute('IfDefStruct')
"?   1,2delete _
"? endfunction

function! s:IfDefStructInBuffer()
  let temp = execute('IfDefStruct')
  new
  silent put =temp
  1,2delete _
endfunction


function! s:CommnadOutput()
  redir => result
  silent execute 'IfDefStruct'
  redir END
  return result
endfunction

" let @*=execute('IfDefStruct')



"---------------------------------------------------------------------------------------------

" コマンドラインで、"<Space>"を入力しやすくする。
cnoremap <expr> <C-v><Space> '<' . 'Space' . '>'



"---------------------------------------------------------------------------------------------

" 無名バッファなら、pwd。そうでなければ、保存。
nnoremap <expr> <silent> <leader>w bufname() == '' ? ':<C-u>pwd<CR>' : ':<C-u>update<CR>'



"---------------------------------------------------------------------------------------------

"? cmap <expr> <CR> ( getcmdtype() == '/' ) ?
"?                \ ( '<Plug>(Search-SlashCR)' ) :
"?                \ ( getcmdtype() == ':' && getcmdline() =~# '^:*cd ') ?
"?                \ ( '<C-e><C-u>echo "cdは使用禁止。pw[d]かlc[d]を使用。"<CR>' ) :
"?                \ ( getcmdtype() == ':' && getcmdline() =~# '^:*lcd\? *$') ?
"?                \ ( '<C-e><C-u>echo "引数なしのlcdは使用禁止。pw[d]を使用。"<CR>' ) :
"?                \ ( '<CR>' )



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

nnoremap <Leader><C-p> :<C-u>call <SID>next_modified_nonamebuf(-1)<CR>
nnoremap <Leader><C-n> :<C-u>call <SID>next_modified_nonamebuf(+1)<CR>

function! s:next_modified_nonamebuf(n)
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

  if !s:next_modified_nonamebuf_sub(sta1, end1, dis)
    if !s:next_modified_nonamebuf_sub(sta2, end2, dis)
      echo '変更された無名バッファはありません。'
    endif
  endif
endfunction

function! s:next_modified_nonamebuf_sub(sta, end, dis )
  "echo  a:sta a:end a:dis
  for i in range(a:sta, a:end, a:dis)
    if buflisted(i) && bufname(i) == '' && getbufinfo(i)[0].changed
      exe 'b' i
      return v:true
    endif
  endfor
  return v:false
endfunction



"---------------------------------------------------------------------------------------------

nnoremap ' "
vnoremap ' "
nnoremap '' "0
vnoremap '' "0

nnoremap " '
vnoremap " '
nnoremap ` m
vnoremap ` m


"---------------------------------------------------------------------------------------------
inoremap $$ ${}<LEFT>
inoremap HH ${}<LEFT>



"---------------------------------------------------------------------------------------------

" ^に、|の機能を付加
"nnoremap <silent> U <Esc>:exe v:prevcount ? ('normal! ' . v:prevcount . '<Bar>') : 'normal! ^'<CR>
"nnoremap <expr> <silent> U v:prevcount ? (v:prevcount . '<Bar>') : '^'
"nnoremap <expr> <silent> U v:prevcount ? (v:prevcount . '<Bar>') : search('^\s*\%#', 'bcn') ? '0' : '^'
"nnoremap <expr> <silent> U v:prevcount ? (v:prevcount . '<Bar>') : search('^\s\+\%#\S', 'bcn') ? '0' : '^'
nnoremap <expr> <silent> U v:prevcount ? (v:prevcount . '<Bar>') : search('^\s\+\%#\S\?', 'bcn') ? '0' : '^'
vnoremap <expr> <silent> U v:prevcount ? (v:prevcount . '<Bar>') : search('^\s\+\%#\S\?', 'bcn') ? '0' : '^'
"nnoremap <expr> <silent> U v:prevcount ? (v:prevcount . '<Bar>') : search('^\s\+\%#\(\S\|\s$\)', 'bcn') ? '0' : '^'
"vnoremap <expr> <silent> U v:prevcount ? (v:prevcount . '<Bar>') : '^'

"""  " ^に、|の機能を付加
"""  nnoremap <silent> ^ <Esc>:exe v:prevcount ? ('normal! ' . v:prevcount . '<Bar>') : 'normal! ^'<CR>
nnoremap <silent> U <Esc>:exe 'normal!' v:prevcount ? (v:prevcount . '<Bar>') : search('^\s\+\%#\S\?', 'bcn') ? '0' : '^' <CR>
vnoremap <silent> U <Esc>:exe 'normal!' v:prevcount ? (v:prevcount . '<Bar>') : search('^\s\+\%#\S\?', 'bcn') ? '0' : '^' <CR>
"onoremap <silent> U <Esc>:exe 'normal!' v:prevcount ? (v:prevcount . '<Bar>') : search('^\s\+\%#\S\?', 'bcn') ? '0' : '^' <CR>
onoremap <expr> <silent> U search('^\s\+\%#\S\?', 'bcn') ? '0' : '^'
"nnoremap <expr> <silent> U v:prevcount ? (v:prevcount . '<Bar>') : search('^\s\+\%#\S\?', 'bcn') ? '0' : '^' <CR>

nnoremap zU g0

"nnoremap U ^
nnoremap : $
"vnoremap U ^
vnoremap : $

nnoremap 0 g0
nnoremap $ g$

" 補償
vnoremap gu u
vnoremap gU U


" 矯正
" nnoremap ^ <Nop>
" nnoremap $ <Nop>
" vnoremap ^ <Nop>
" vnoremap $ <Nop>



"---------------------------------------------------------------------------------------------

" 行右端で、なお右に進もうとしたら、virtualeditにblockを追加して、何事もなかったかのように右へ移動する。
vnoremap <expr> l
      \ &virtualedit !~# 'block' && search('\%#$', 'bcn') ?
      \ '<Esc>' . ':<C-u>set virtualedit+=block<CR>' . 'gv' . 'l' :
      \ 'l'



"---------------------------------------------------------------------------------------------

onoremap ia iW
onoremap aa aW
vnoremap ia iW
vnoremap aa aW



"---------------------------------------------------------------------------------------------

if 0
  nnoremap <silent> t <Esc>:exe 'normal!' v:prevcount ? (v:prevcount . '<Bar>') : search('^\s\+\%#\S\?', 'bcn') ? '0' : '^' <CR>
  vnoremap <silent> t <Esc>:exe 'normal!' v:prevcount ? (v:prevcount . '<Bar>') : search('^\s\+\%#\S\?', 'bcn') ? '0' : '^' <CR>

  nmap U *
  nnoremap T $
endif



"---------------------------------------------------------------------------------------------

nnoremap <Leader>6 ^y$/\C\V<C-r>=substitute(escape(@", '/\|\\'), '\s', '\\s\\+', 'g')<CR><CR>



"---------------------------------------------------------------------------------------------

nmap ? *


"---------------------------------------------------------------------------------------------

com! KakkoZenkaku s/(/（/g |  s/)/）/g


"---------------------------------------------------------------------------------------------

function! Find(arg)
  "echo a:arg
  "et f = a:arg

  let f = substitute(a:arg, ' ', '*', 'g')

  if a:arg !~ '^\^'
    let f = substitute(f, '^', '*', '')
  elseif a:arg !~ '^;'
    let f = substitute(f, '^;', '^', '')
  else
    let f = substitute(f, '^\^', '', '')
  endif

  if a:arg !~ '\$$'
    let f = substitute(f, '$', '*', '')
  elseif a:arg !~ ';$'
    let f = substitute(f, ';$', '$', '')
  else
    let f = substitute(f, '\$$', '', '')
  endif

  "exe 'find' f
  call feedkeys(':find '. f . "\<Tab>\<Tab>", 'nt')
endfunction

com! -bar -nargs=* Find call Find(<q-args>)
com! -bar -nargs=* F Find <args>


"---------------------------------------------------------------------------------------------

com! NoWrap PushPosAll | exe 'windo set nowrap' | PopPosAll
com! WinNoWrap PushPosAll | exe 'windo set nowrap' | PopPosAll
com! AllNoWrap PushPosAll | exe 'windo set nowrap' | PopPosAll

com! Wrap PushPosAll | exe 'windo set wrap' | PopPosAll
com! WinWrap PushPosAll | exe 'windo set wrap' | PopPosAll
com! AllWrap PushPosAll | exe 'windo set wrap' | PopPosAll



"---------------------------------------------------------------------------------------------

" 折り畳みトグル
function! Toggle_folding()
  normal! zi
  if &l:foldenable
    normal! zM
  endif
  return
endfunction
"nnoremap zi :<C-u>call Toggle_folding()<CR>



"---------------------------------------------------------------------------------------------

com! MacroStart normal! qq
com! MacroEnd   normal! q

nnoremap ! q



"---------------------------------------------------------------------------------------------

nnoremap <Leader><C-s> :<C-u>wind %s/<C-r>//<C-r><C-w>/g<CR>:wind up<CR><C-w>t



"---------------------------------------------------------------------------------------------

nnoremap ^ :<C-u>normal!<Space>



"---------------------------------------------------------------------------------------------

"nmap <C-t> <Plug>(TabSplit)
nmap     t <Plug>(TabSplit)
nnoremap T <C-w>T

" <c-t> g<c-t> T gT
nmap gt <Plug>(Window-Resize-OptimalWidth)
nmap gT <C-w>=
" nmap <Leader><Leader> <C-w>=



"nmap <C-t> <Plug>(TabSplit)
nnoremap T <C-w>T

" <c-t> g<c-t> T gT
nmap gt <Plug>(Window-Resize-OptimalWidth)
nmap gT <C-w>=
" nmap <Leader><Leader> <C-w>=
nnoremap t gt
nnoremap T gT



nmap     t <Plug>(TabSplit)
nnoremap T <C-w>T
"nmap     <Leader><Leader> <Plug>(TabSplit)






"---------------------------------------------------------------------------------------------

"set foldtext=MyFoldText()
"function MyFoldText()
"  let line = getline(v:foldstart)
"  let sub = substitute(line, '^\t\?\zs\t', repeat(' ', &tabstop), 'g')
"  let sub = substitute(line, '/\*\|\*/\|{{{\d\=', '', 'g')
"  return v:folddashes . sub
"endfunction



"---------------------------------------------------------------------------------------------

" nnoremap <silent> d<S-CR> :<C-u>Gdiffsplit<CR>



"---------------------------------------------------------------------------------------------

" com! Tac !tac


"---------------------------------------------------------------------------------------------

"set diffopt+=closeoff

function! s:get_diff_context()
  let diffopt = &diffopt
  if diffopt =~ 'context'
    let diffopts = split(diffopt. ',')
    let diffopts_joined = join(diffopts)
    let diffcontext = matchstr(diffopts_joined, 'context:\zs\d\+')
  else
    let diffcontext = 6
  endif
  return diffcontext
endfunction

function! s:set_diff_context(diffcontext_new)
  let diffopt = &diffopt
  if diffopt =~ 'context'
    let diffopts = split(diffopt. ',')
    let diffopts_joined = join(diffopts)
    let diffcontext = matchstr(diffopts_joined, 'context:\d\+')
    exe 'set diffopt-=' . diffcontext
  endif
  exe 'set diffopt+=context:' . a:diffcontext_new
  return
endfunction

com! -bang -nargs=? DiffContextInc call s:set_diff_context( s:get_diff_context() + (<q-args> == '' ? 1 : <q-args>) )
com! -bang -nargs=? DiffContextDec call s:set_diff_context( s:get_diff_context() - (<q-args> == '' ? 1 : <q-args>) )
com! -bang -nargs=0 DiffContextReset call s:set_diff_context( 6 )

"nnoremap d+ :<C-u>DiffContextInc v:count1<CR>
"nnoremap d- :<C-u>DiffContextDec v:count1<CR>
nnoremap d+ :<C-u>exe 'DiffContextInc' v:count1<CR>
nnoremap d- :<C-u>exe 'DiffContextDec' v:count1<CR>
nnoremap d= :<C-u>DiffContextReset<CR>


"---------------------------------------------------------------------------------------------
" ファイル内全てのシンボルを置換
nnoremap <silent> <Leader>S :<C-u>PushPos<CR>:g$.$s    /<C-r>//<C-r><C-w>/g<CR>:PopPos<CR>:let @/='<C-r><C-w>'<CR>
nmap gS <Leader>S



"---------------------------------------------------------------------------------------------
nnoremap ZZ zi



"---------------------------------------------------------------------------------------------
cab <silent> J *<C-R>=Eatchar('\s')<CR>
cab J *
cab G *
cab K *
cnoremap <C-j> *
cnoremap <C-g> %


"---------------------------------------------------------------------------------------------



