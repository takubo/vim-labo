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
iab FORI for ( uint32_t i = 0U; i < N; i++ ) {<CR><CR>}
iab <silent> FORI for ( uint32_t i = 0U; i < N; i++ ) {<CR><CR>}<C-R>=Eatchar('\s')<CR>



"---------------------------------------------------------------------------------------------
nnoremap <Leader><C-s>           :<C-u>g%<C-r>/%s    %%%g<Left><Left><Left>
vnoremap <Leader><C-s>                :g%<C-r>/%s     %%%g<Left><Left><Left>

nnoremap <Leader><C-s>           :<C-u>g!<C-r>/!<Space>
vnoremap <Leader><C-s>                :g!<C-r>/!<Space>



"---------------------------------------------------------------------------------------------

"? cmap <expr> <CR> ( getcmdtype() == '/' ) ?
"?                \ ( '<Plug>(Search-SlashCR)' ) :
"?                \ ( getcmdtype() == ':' && getcmdline() =~# '^:*cd ') ?
"?                \ ( '<C-e><C-u>echo "cdは使用禁止。pw[d]かlc[d]を使用。"<CR>' ) :
"?                \ ( getcmdtype() == ':' && getcmdline() =~# '^:*lcd\? *$') ?
"?                \ ( '<C-e><C-u>echo "引数なしのlcdは使用禁止。pw[d]を使用。"<CR>' ) :
"?                \ ( '<CR>' )



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
"nnoremap : $
"vnoremap U ^
"vnoremap : $

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

if 0
  nnoremap <silent> t <Esc>:exe 'normal!' v:prevcount ? (v:prevcount . '<Bar>') : search('^\s\+\%#\S\?', 'bcn') ? '0' : '^' <CR>
  vnoremap <silent> t <Esc>:exe 'normal!' v:prevcount ? (v:prevcount . '<Bar>') : search('^\s\+\%#\S\?', 'bcn') ? '0' : '^' <CR>

  nmap U *
  nnoremap T $
endif



"---------------------------------------------------------------------------------------------

nnoremap <Leader>6 ^y$/\C\V<C-r>=substitute(escape(@", '/\|\\'), '\s', '\\s\\+', 'g')<CR><CR>



"---------------------------------------------------------------------------------------------

iab LOOP while ( 1 ) {<CR>}


"---------------------------------------------------------------------------------------------

nmap ? *


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

"set foldtext=MyFoldText()
"function MyFoldText()
"  let line = getline(v:foldstart)
"  let sub = substitute(line, '^\t\?\zs\t', repeat(' ', &tabstop), 'g')
"  let sub = substitute(line, '/\*\|\*/\|{{{\d\=', '', 'g')
"  return v:folddashes . sub
"endfunction



"---------------------------------------------------------------------------------------------

" com! Tac !tac


"---------------------------------------------------------------------------------------------
" ファイル内全てのシンボルを置換
nnoremap <silent> <Leader>S :<C-u>PushPos<CR>:g$.$s    /<C-r>//<C-r><C-w>/g<CR>:PopPos<CR>:let @/='<C-r><C-w>'<CR>
nmap gS <Leader>S



"---------------------------------------------------------------------------------------------
cab <silent> J *<C-R>=Eatchar('\s')<CR>
cab J *
cab G *
cab K *
cnoremap <C-j> *
cnoremap <C-g> %
