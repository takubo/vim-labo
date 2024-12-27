vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 expandtab
scriptencoding utf-8


finish

vimrc

" Window {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{


set noequalalways


"----------------------------------------------------------------------------------------
" Window Ratio
"
"   正方形 w:h = 178:78
"   横長なほど、大きい値が返る。
function! s:WindowRatio()
  let h = winheight(0) + 0.0
  let w = winwidth(0) + 0.0
  return (w / h - 178.0 / 78.0)
endfunction


"----------------------------------------------------------------------------------------
" Trigger

nmap <BS> <C-w>


"----------------------------------------------------------------------------------------
" Split & New

" Auto Split
nnoremap <silent> <expr> <Plug>(MyVimrc-Window-AutoSplit)     ( <SID>WindowRatio() >= 0 ? "\<C-w>v" : "\<C-w>s" ) . ':diffoff<CR>'
nnoremap <silent> <expr> <Plug>(MyVimrc-Window-AutoSplit-Rev) ( <SID>WindowRatio() <  0 ? "\<C-w>v" : "\<C-w>s" ) . ':diffoff<CR>'

nmap <BS><BS>         <Plug>(MyVimrc-Window-AutoSplit)
nmap <Leader><Leader> <Plug>(MyVimrc-Window-AutoSplit-Rev)

" Tag, Jump, and Unified CR を参照。

" Manual
nnoremap <silent> _                <C-w>s:setl noscrollbind<CR>
nnoremap <silent> g_               <C-w>n
nnoremap <silent> U                :<C-u>new<CR>
nnoremap <silent> <Bar>            <C-w>v:setl noscrollbind<CR>
nnoremap <silent> g<Bar>           :<C-u>vnew<CR>

" Auto New
nnoremap <silent> <expr> <Plug>(MyVimrc-Window-AutoNew) ( winwidth(0) > (&columns * 7 / 10) && <SID>WindowRatio() >=  0 ) ? ':<C-u>vnew<CR>' : '<C-w>n'


"----------------------------------------------------------------------------------------
" Close

" TODO NERDTreeも閉じられるようにする。
nnoremap <silent> q         <C-w><C-c>
nnoremap <silent> <Leader>q :<C-u>q<CR>

" 補償
nnoremap <C-q>  q
nnoremap <C-q>: q:
nnoremap <C-q>; q:
nnoremap <C-q>/ q/
nnoremap <C-q>? q?

" ウィンドウレイアウトを崩さないでバッファを閉じる   (http://nanasi.jp/articles/vim/kwbd_vim.html)
com! CloseWindow let s:kwbd_bn = bufnr('%') | enew | exe 'bdel '. s:kwbd_bn | unlet s:kwbd_bn


"----------------------------------------------------------------------------------------
" Focus

" Basic
nmap t <Plug>(Window-Focus-SkipTerm-Inc)
nmap T <Plug>(Window-Focus-SkipTerm-Dec)
" Unified_Spaceを参照。

" Direction Focus
nmap H <Plug>(Window-Focus-WrapMove-h)
nmap J <Plug>(Window-Focus-WrapMove-j)
nmap K <Plug>(Window-Focus-WrapMove-k)
nmap L <Plug>(Window-Focus-WrapMove-l)

" 補償
nnoremap gM M
nnoremap gH H
nnoremap gL L
if 1
  noremap m   J
  noremap gm gJ
else
  noremap M   J
  noremap gM gJ
endif

" Direction Focus (Terminal)
tnoremap <S-Left>  <C-w>h
tnoremap <S-Down>  <C-w>j
tnoremap <S-Up>    <C-w>k
tnoremap <S-Right> <C-w>l

" Terminal Windowから抜ける。 (Windowが１つしかないなら、Tabを抜ける。)
tnoremap <expr> <C-Tab> winnr('$') == 1 ? '<C-w>:tabNext<CR>' : '<C-w>p'


"----------------------------------------------------------------------------------------
" Resize

" 漸次
nnoremap <silent> <C-h> <Esc><C-w>+:call <SID>best_scrolloff()<CR>
nnoremap <silent> <C-l> <Esc><C-w>-:call <SID>best_scrolloff()<CR>
nnoremap <silent> <S-BS> <Esc><C-w>+:call <SID>best_scrolloff()<CR>
nnoremap <silent> <C-BS> <Esc><C-w>-:call <SID>best_scrolloff()<CR>
nnoremap <silent> (     <Esc><C-w>3<
nnoremap <silent> )     <Esc><C-w>3>

tnoremap <silent> <C-up>    <C-w>+:call <SID>best_scrolloff()<CR>
tnoremap <silent> <C-down>  <C-w>-:call <SID>best_scrolloff()<CR>
tnoremap <silent> <C-left>  <C-w><
tnoremap <silent> <C-right> <C-w>>

" 補償
nnoremap <silent> <A-o> <C-l>

" 最小化・最大化
"nnoremap <silent> g<C-j> <esc><C-w>_:call <SID>best_scrolloff()<CR>
"nnoremap <silent> g<C-k> <esc>1<C-w>_:call <SID>best_scrolloff()<CR>
"nnoremap <silent> g<C-h> <esc>1<C-w>|
"nnoremap <silent> g<C-l> <esc><C-w>|

nmap @ <Plug>(Window-Resize-EqualOnlyWidth)
nmap g@ <Plug>(Window-Resize-EqualOnlyHeight)

nmap <Leader><Leader> <Plug>(Window-Resize-OptimalWidth)

" Submode
call submode#enter_with('WinSize', 'n', 's', '<C-w>+', '<C-w>+:call BestScrolloff()<CR>')
call submode#enter_with('WinSize', 'n', 's', '<C-w>-', '<C-w>-:call BestScrolloff()<CR>')
call submode#enter_with('WinSize', 'n', 's', '<C-w>>', '<C-w>>')
call submode#enter_with('WinSize', 'n', 's', '<C-w><', '<C-w><')
call submode#map(       'WinSize', 'n', 's', '+', '<C-w>+:call BestScrolloff()<CR>')
call submode#map(       'WinSize', 'n', 's', '=', '<C-w>+:call BestScrolloff()<CR>') " Typo対策
call submode#map(       'WinSize', 'n', 's', '-', '<C-w>-:call BestScrolloff()<CR>')
call submode#map(       'WinSize', 'n', 's', '>', '<C-w>>')
call submode#map(       'WinSize', 'n', 's', '<', '<C-w><')
if 1
  call submode#enter_with('WinSize', 'n', 's', '<C-w>h', '<C-w><')
  call submode#enter_with('WinSize', 'n', 's', '<C-w>j', '<C-w>+:call BestScrolloff()<CR>')
  call submode#enter_with('WinSize', 'n', 's', '<C-w>k', '<C-w>-:call BestScrolloff()<CR>')
  call submode#enter_with('WinSize', 'n', 's', '<C-w>l', '<C-w>>')
endif
if 0
  call submode#map(       'WinSize', 'n', 's', 'h', '<C-w>h')
  call submode#map(       'WinSize', 'n', 's', 'j', '<C-w>j')
  call submode#map(       'WinSize', 'n', 's', 'k', '<C-w>k')
  call submode#map(       'WinSize', 'n', 's', 'l', '<C-w>l')
else
  call submode#map(       'WinSize', 'n', 's', 'h', '<C-w><')
  call submode#map(       'WinSize', 'n', 's', 'j', '<C-w>+:call BestScrolloff()<CR>')
  call submode#map(       'WinSize', 'n', 's', 'k', '<C-w>-:call BestScrolloff()<CR>')
  call submode#map(       'WinSize', 'n', 's', 'l', '<C-w>>')
endif


"----------------------------------------------------------------------------------------
" Window Move

nnoremap <silent> <A-h> <C-w>H:call <SID>best_scrolloff()<CR>
nnoremap <silent> <A-j> <C-w>J:call <SID>best_scrolloff()<CR>
nnoremap <silent> <A-k> <C-w>K:call <SID>best_scrolloff()<CR>
nnoremap <silent> <A-l> <C-w>L:call <SID>best_scrolloff()<CR>

tnoremap <silent> <A-left>  <C-w>H:call <SID>best_scrolloff()<CR>
tnoremap <silent> <A-down>  <C-w>J:call <SID>best_scrolloff()<CR>
tnoremap <silent> <A-up>    <C-w>K:call <SID>best_scrolloff()<CR>
tnoremap <silent> <A-right> <C-w>L:call <SID>best_scrolloff()<CR>


"----------------------------------------------------------------------------------------
" Reopen as Tab
" TODO diffのバッファも再現する。

nnoremap <C-w><C-w> :<C-u>tab split<CR>
nnoremap <C-w><C-t> <C-w>T

tnoremap <C-w><C-t> <C-w>T


"----------------------------------------------------------------------------------------
" Plug WinCmd

nnoremap <Plug>(MyVimrc-WinCmd-p) <C-w>p


" Window }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}



" Window Temp {{{{{{{{{{{{{{{{{{{{{{{


" Submode Window Size {{{

if 0
  call submode#enter_with('WinSize', 'n', '', '<Space>l', '<C-w>>')
  call submode#enter_with('WinSize', 'n', '', '<Space>h', '<C-w><')
  call submode#enter_with('WinSize', 'n', '', '<Space>j', '<C-w>+')
  call submode#enter_with('WinSize', 'n', '', '<Space>k', '<C-w>-')
  call submode#map(       'WinSize', 'n', '', 'l', '<C-w>>')
  call submode#map(       'WinSize', 'n', '', 'h', '<C-w><')
  call submode#map(       'WinSize', 'n', '', 'j', '<C-w>+')
  call submode#map(       'WinSize', 'n', '', 'k', '<C-w>-')

  let g:submode_timeoutlen = 5000
endif

let g:submode_timeoutlen = 5000

" Submode Window Size }}}


" Window Wrap Focus 補償 {{{

"noremap zh H
"noremap zl L
"noremap zm M
"noremap zk H
"noremap zj L

"nnoremap <C-h> H
"nnoremap <C-l> L
"nnoremap <C-j> M


nnoremap M <C-w>n
nmap U *
nmap M <Plug>(MyVimrc-Window-AutoNew)


" Window Wrap Focus 補償 }}}



" Window Temp }}}}}}}}}}}}}}}}}}}}}}}



