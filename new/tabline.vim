" vimrc



" Tabline {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{


"----------------------------------------------------------------------------------------
" Make TabLineStr

function! TabLineStr()
  " Tab Label
  let tab_labels = map(range(1, tabpagenr('$')), 's:make_tabpage_label(v:val)')
  let sep = '%#SLFileName# | '  " タブ間の区切り
  let tabpages = sep . join(tab_labels, sep) . sep . '%#TabLineFill#%T'

  " Left
  let left = ''
  if 0
    let left .= '%#TabLineDate#  ' . strftime('%Y/%m/%d (%a) %X') . '  '
  else
    let left .= '%#TabLineDate#  ' . strftime('%X') . ' '
  endif
  let left .= '%#SLFileName#  ' . g:BatteryInfo . '  '
  let left .= '%#TabLineDate#  '

  " Right
  let right = ''
  let right .= "%#TabLineDate#  "
 "let right .= "%#SLFileName# %{'[ '. substitute(&diffopt, ',', ', ', 'g') . ' ]'} "
  let right .= '%#TabLineDate#  ' . s:TablineStatus . '/' . (s:TablineStatusNum - 1)
  let right .= '%#TabLineDate#  '

  return left . '%##    %<' . tabpages . '%=  ' . right
endfunction
function! TabLineStr()
  " Tab Label
  let tab_labels = map(range(1, tabpagenr('$')), 's:make_tabpage_label(v:val)')
 "let sep = '%#SLFileName# | '  " タブ間の区切り
  let sep = '%#TabLineSep#| '  " タブ間の区切り
  let sep = '%#TabLineSep# | '  " タブ間の区切り
  let tabpages = sep . join(tab_labels, sep) . sep . '%#TabLineFill#%T'

  " Left
  let left = ''
  if 0
    let left .= '%#TabLineDate#  ' . strftime('%Y/%m/%d (%a) %X') . '  '
  else
   "let left .= '%#TabLineDate# 💮 %#SLFileName#  ' . strftime('%X') . '  %#TabLineDate#    '
    let left .= '%#TabLineDate# ' . (winnr('$') > g:WinFocusThresh ? '💎' : '🐎') . ' %#SLFileName#  ' . strftime('%X') . '  %#TabLineDate#    '
  endif
  let left .= '%#SLFileName# ' . g:BatteryInfo . '  '
  let left .= '%#TabLineDate#    '

  " Right
  let right = ''
  let right .= "%#TabLineDate#  "

  if 0
    let right .= "%#SLFileName# %{'[ '. substitute(&diffopt, ',', ', ', 'g') . ' ]'} "
  elseif 0
    let right .= "%#SLFileName# [ "
    let right .= "(&diffopt =~ '\<iwhite\>' ? '%#SLNoNameDir#' : '%#SLFileName#') " . "White"
    let right .= "(&diffopt =~ 'icase'  ? '%#SLNoNameDir#' : '%#SLFileName#') " . "Case"
    let right .= "%#SLFileName ] "
  else
    let right .= "%#SLFileName# [ "
    let right .= (&diffopt =~ '\<iwhite\>' ? "%#SLNoNameDir#" : "%#SLFileName#") . "White "
    let right .= (&diffopt =~ 'icase'  ? "%#SLNoNameDir#" : "%#SLFileName#") . "Case"
    let right .= "%#SLFileName# ] "
  endif

 "let right .= '%#TabLineDate#  ' . s:TablineStatus . '/' . (s:TablineStatusNum - 1)
  let right .= '%#TabLineDate# 💻 ' . s:TablineStatus . '/' . (s:TablineStatusNum - 1)
  let right .= '%#TabLineDate#  '

  return left . '%#TabLineFill#    %<' . tabpages . '%#TabLineFill#%=  ' . right
  "return left . '%#SLFileName#    %<' . tabpages . '%#SLFileName#%=  ' . right
  return left . '%##%<' . tabpages . '%=  ' . right
endfunction


"----------------------------------------------------------------------------------------
" Make TabLabel

function! s:make_tabpage_label(n)
  " カレントタブページかどうかでハイライトを切り替える
  "let hi = a:n is tabpagenr() ? '%#Directory#' : '%#TabLine#'
  "let hi = a:n is tabpagenr() ? '%#SLFileName#' : '%#TabLine#'
  "let hi = a:n is tabpagenr() ? '%#TabLineSel#' : '%#TabLine#'
  let hi = a:n is tabpagenr() ? '%#TabLineSel#' : '%#VertSplit#'

  if s:TablineStatus == 1 | return hi . ' [ ' . a:n . ' ] %#TabLineFill#' | endif

  " タブ内のバッファのリスト
  let bufnrs = tabpagebuflist(a:n)

  " タブ内に変更ありのバッファがあったら '+' を付ける
  let mod = len(filter(copy(bufnrs), 'getbufvar(v:val, "&modified")')) ? ' +' : ''

  " バッファ数
  let num = '(' . len(bufnrs) . ')'

  if s:TablineStatus == 2 | return hi . ' [ ' . a:n . ' ' . num . mod . ' ] %#TabLineFill#' | endif

  " タブ番号
  let no = '[' . a:n . ']'

  " カレントバッファ
  let curbufnr = bufnrs[tabpagewinnr(a:n) - 1]  " tabpagewinnr() は 1 origin
  let buf_name = ( s:TablineStatus =~ '[345]' ? expand('#' . curbufnr . ':t') : pathshorten(bufname(curbufnr)) )  " let buf_name = pathshorten(expand('#' . curbufnr . ':p'))
 "let buf_name = buf_name == '' ? 'No Name' : buf_name  " 無名バッファは、バッファ名が出ない。
 "let buf_name = buf_name == '' ? '-' : buf_name  " 無名バッファは、バッファ名が出ない。
  let buf_name = buf_name == '' ? ' ' : buf_name  " 無名バッファは、バッファ名が出ない。

  " 最終的なラベル
  let label = no . (s:TablineStatus != 3 ? (' ' . num) : '') . (s:TablineStatus =~ '[57]' ? mod : '') . ' '  . buf_name
  return '%' . a:n . 'T' . hi . '  ' . label . '%T  %#TabLineFill#'
endfunction


"----------------------------------------------------------------------------------------
" Switch TabLine Status

function! s:ToggleTabline(arg)
  if (a:arg . '') == ''
    let s:TablineStatus = ( s:TablineStatus + 1 ) % s:TablineStatusNum
  elseif a:arg < s:TablineStatusNum
    let s:TablineStatus = a:arg
  else
    echoerr 'Tabline:Invalid argument.'
    return
  endif

  let &showtabline = ( s:TablineStatus == 0 ? 0 : 2 )

  call UpdateTabline(0)
endfunction

nnoremap <silent> <leader>= :<C-u>call <SID>ToggleTabline('')<CR>
function! s:CompletionTabline(ArgLead, CmdLine, CusorPos)
  return range(0, s:TablineStatusNum)
endfunction
com! -nargs=? -complete=customlist,s:CompletionTabline Tabline call <SID>ToggleTabline(<args>)


"----------------------------------------------------------------------------------------
" TabLine Timer

function! UpdateTabline(dummy)
  redrawtabline
  return
  set tabline=%!TabLineStr()
endfunction

" 旧タイマの削除  vimrcを再読み込みする際、古いタイマを削除しないと、どんどん貯まっていってしまう。
if exists('TimerTabline') | call timer_stop(TimerTabline) | endif

let s:UpdateTablineInterval = 1000
let TimerTabline = timer_start(s:UpdateTablineInterval, 'UpdateTabline', {'repeat': -1})
"let TimerTabline = timer_start(s:UpdateTablineInterval, { dummy -> execute('redrawtabline') }, {'repeat': -1})


"----------------------------------------------------------------------------------------
" Initial Setting

" 0
" 1  タブ番号
" 2  タブ番号 バッファ数 Mod
" 3  タブ番号                バッファ名
" 4  タブ番号 バッファ数     バッファ名
" 5  タブ番号 バッファ数 Mod バッファ名
" 6  タブ番号 バッファ数     フルバッファ名
" 7  タブ番号 バッファ数 Mod フルバッファ名
let s:TablineStatusNum = 8

" 初期設定
" 最後に実施する必要あり。
"silent call <SID>ToggleTabline(3)


" Tabline }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}






" vimrc.new



" Tabline {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{


"----------------------------------------------------------------------------------------
" Make TabLineStr

function! TabLineStr()
  " Tab Label
  let tab_labels = map(range(1, tabpagenr('$')), 's:make_tabpage_label(v:val)')
  let sep = '%#SLFileName# | '  " タブ間の区切り
  "let tabpages = sep . join(tab_labels, sep) . sep . '%#TabLineFill#%T'
  "let tabpages = join(tab_labels, sep) . '%#TabLineDate#    ' . '%#TabLineFill#%T'
  let tabpages = sep . join(tab_labels, sep) . sep . '%#TabLineDate#    ' ". '%#TabLineFill#%T'

  let tabpages =  '%#SLFileName#    ' .. '%#TabLineDate#  [ ' ..  tabpagenr() .. ' / ' .. tabpagenr('$') .. ' ]  %#SLFileName# '
  let tabpages =  '%#SLFileName#    ' .. '%#TabLine#  [ ' ..  tabpagenr() .. ' / ' .. tabpagenr('$') .. ' ]  %#SLFileName# '

  " Left
  let left = ''
  "let left .= '%#TabLineDate#  ' . strftime('%X') . '  '
  "let left .= '%#SLFileName# ' . g:BatteryInfo . ' '
  "let left .= '%#TabLineDate#  '
  let left .= '%#TabLineDate# ◎ '

  " Right
  let right = ''
  let right .= "%#TabLineDate#  "
  let right .= "%#SLFileName# %{'[ '. substitute(&diffopt, ',', ', ', 'g') . ' ]'} "
  "let right .= '%#TabLineDate#  ' . s:TablineStatus . '/' . (s:TablineStatusNum - 1)
  let right .= '%#TabLineDate#  '

  return left . '%<' . tabpages . '%=  ' . right
  return left . '%##    %<' . tabpages . '%=  ' . right
endfunction


"----------------------------------------------------------------------------------------
" Make TabLabel

function! s:make_tabpage_label(n)
  " カレントタブページかどうかでハイライトを切り替える
  let hi = a:n is tabpagenr() ? '%#TabLineSel#' : '%#TabLine#'

  if s:TablineStatus == 1 | return hi . ' [ ' . a:n . ' ] %#TabLineFill#' | endif

  " タブ内のバッファのリスト
  let bufnrs = tabpagebuflist(a:n)

  " タブ内に変更ありのバッファがあったら '+' を付ける
  let mod = len(filter(copy(bufnrs), 'getbufvar(v:val, "&modified")')) ? ' +' : ''

  if s:TablineStatus == 2 | return hi . ' [ ' . a:n . ' ' . mod . ' ] %#TabLineFill#' | endif

  " バッファ数
  let num = '(' . len(bufnrs) . ')'

  if s:TablineStatus == 3 | return hi . ' [ ' . a:n . ' ' . num . mod . ' ] %#TabLineFill#' | endif

  " タブ番号
  let no = '[' . a:n . ']'

  " カレントバッファ
  let curbufnr = bufnrs[tabpagewinnr(a:n) - 1]  " tabpagewinnr() は 1 origin

  let buf_name = ( s:TablineStatus =~ '[456]' ? expand('#' . curbufnr . ':t') : pathshorten(bufname(curbufnr)) )  " let buf_name = pathshorten(expand('#' . curbufnr . ':p'))

  let buf_name = buf_name == '' ? 'No Name' : buf_name  " 無名バッファは、バッファ名が出ない。

  let label = no . (s:TablineStatus != 4 ? (' ' . num) : '') . (s:TablineStatus =~ '[68]' ? mod : '') . ' '  . buf_name

  return '%' . a:n . 'T' . hi . '  ' . label . '%T  %#TabLineFill#'
endfunction


"----------------------------------------------------------------------------------------
" Switch TabLine Status

function! s:ToggleTabline(arg)
  if (a:arg . '') == ''
    let s:TablineStatus = ( s:TablineStatus + 1 ) % s:TablineStatusNum
  elseif a:arg < s:TablineStatusNum
    let s:TablineStatus = a:arg
  else
    echoerr 'Tabline:Invalid argument.'
    return
  endif

  let &showtabline = ( s:TablineStatus == 0 ? 0 : 2 )

  "call UpdateTabline(0)
  set tabline=%!TabLineStr()
endfunction

nnoremap <silent> <leader>= :<C-u>call <SID>ToggleTabline('')<CR>
com! -nargs=1 Tabline call <SID>ToggleTabline(<args>)


"----------------------------------------------------------------------------------------
" Initial Setting

let s:TablineStatusNum = 9
" 0
" 1  タブ番号
" 2  タブ番号            Mod
" 3  タブ番号 バッファ数 Mod
" 4  タブ番号                バッファ名
" 5  タブ番号 バッファ数     バッファ名
" 6  タブ番号 バッファ数 Mod バッファ名
" 7  タブ番号 バッファ数     フルバッファ名
" 8  タブ番号 バッファ数 Mod フルバッファ名

" 初期設定
silent call <SID>ToggleTabline(4)


"----------------------------------------------------------------------------------------
" TabLine Timer

" function! UpdateTabline(dummy)
"   redrawtabline
"   return
"   set tabline=%!TabLineStr()
" endfunction

" 旧タイマの削除  vimrcを再読み込みする際、古いタイマを削除しないと、どんどん貯まっていってしまう。
if exists('TimerTabline') | call timer_stop(TimerTabline) | endif

" let s:UpdateTablineInterval = 1000
" let TimerTabline = timer_start(s:UpdateTablineInterval, 'UpdateTabline', {'repeat': -1})
" set tabline=%!TabLineStr()


" Tabline }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}






" 1228



" Tabline {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{


"----------------------------------------------------------------------------------------
" Make TabLineStr

function! TabLineStr()
  " Tab Label
  let tab_labels = map(range(1, tabpagenr('$')), 's:make_tabpage_label(v:val)')
  let sep = '%#SLFileName# | '  " タブ間の区切り
  let tabpages = sep . join(tab_labels, sep) . sep . '%#TabLineFill#%T'

  " Left
  let left = ''
 "let left .= '%#TabLineDate# '. strftime('%Y/%m/%d (%a)   ') . strftime('%X') . '  '
  let left .= '%#TabLineDate#  ' . strftime('%X') . '  '
  let left .= '%#SLFileName# ' . g:BatteryInfo . ' '
  let left .= '%#TabLineDate#  '

  " Right
  let right = ''
  let right .= "%#TabLineDate#  "
  let right .= "%#SLFileName# %{'[ '. substitute(&diffopt, ',', ', ', 'g') . ' ]'} "
  let right .= '%#TabLineDate#  ' . s:TablineStatus . '/' . (s:TablineStatusNum - 1)
  let right .= '%#TabLineDate#  '

  return left . '%##    %<' . tabpages . '%=  ' . right
endfunction


"----------------------------------------------------------------------------------------
" Make TabLabel

function! s:make_tabpage_label(n)
  " カレントタブページかどうかでハイライトを切り替える
  let hi = a:n is tabpagenr() ? '%#TabLineSel#' : '%#TabLine#'

  if s:TablineStatus == 1 | return hi . ' [ ' . a:n . ' ] %#TabLineFill#' | endif

  " タブ内のバッファのリスト
  let bufnrs = tabpagebuflist(a:n)

  " タブ内に変更ありのバッファがあったら '+' を付ける
  let mod = len(filter(copy(bufnrs), 'getbufvar(v:val, "&modified")')) ? ' +' : ''

  if s:TablineStatus == 2 | return hi . ' [ ' . a:n . ' ' . mod . ' ] %#TabLineFill#' | endif

  " バッファ数
  let num = '(' . len(bufnrs) . ')'

  if s:TablineStatus == 3 | return hi . ' [ ' . a:n . ' ' . num . mod . ' ] %#TabLineFill#' | endif

  " タブ番号
  let no = '[' . a:n . ']'

  " カレントバッファ
  let curbufnr = bufnrs[tabpagewinnr(a:n) - 1]  " tabpagewinnr() は 1 origin

  let buf_name = ( s:TablineStatus =~ '[456]' ? expand('#' . curbufnr . ':t') : pathshorten(bufname(curbufnr)) )  " let buf_name = pathshorten(expand('#' . curbufnr . ':p'))

  let buf_name = buf_name == '' ? 'No Name' : buf_name  " 無名バッファは、バッファ名が出ない。

  let label = no . (s:TablineStatus != 4 ? (' ' . num) : '') . (s:TablineStatus =~ '[68]' ? mod : '') . ' '  . buf_name

  return '%' . a:n . 'T' . hi . '  ' . label . '%T  %#TabLineFill#'
endfunction


"----------------------------------------------------------------------------------------
" Switch TabLine Status

function! s:ToggleTabline(arg)
  if (a:arg . '') == ''
    let s:TablineStatus = ( s:TablineStatus + 1 ) % s:TablineStatusNum
  elseif a:arg < s:TablineStatusNum
    let s:TablineStatus = a:arg
  else
    echoerr 'Tabline:Invalid argument.'
    return
  endif

  let &showtabline = ( s:TablineStatus == 0 ? 0 : 2 )

  call UpdateTabline(0)
endfunction

nnoremap <silent> <leader>= :<C-u>call <SID>ToggleTabline('')<CR>
com! -nargs=1 Tabline call <SID>ToggleTabline(<args>)


"----------------------------------------------------------------------------------------
" Initial Setting

let s:TablineStatusNum = 9
" 0
" 1  タブ番号
" 2  タブ番号            Mod
" 3  タブ番号 バッファ数 Mod
" 4  タブ番号                バッファ名
" 5  タブ番号 バッファ数     バッファ名
" 6  タブ番号 バッファ数 Mod バッファ名
" 7  タブ番号 バッファ数     フルバッファ名
" 8  タブ番号 バッファ数 Md  フルバッファ名

" 初期設定
silent call <SID>ToggleTabline(4)


"----------------------------------------------------------------------------------------
" TabLine Timer

function! UpdateTabline(dummy)
  redrawtabline
  return
  set tabline=%!TabLineStr()
endfunction

" 旧タイマの削除  vimrcを再読み込みする際、古いタイマを削除しないと、どんどん貯まっていってしまう。
if exists('TimerTabline') | call timer_stop(TimerTabline) | endif

let s:UpdateTablineInterval = 1000
let TimerTabline = timer_start(s:UpdateTablineInterval, 'UpdateTabline', {'repeat': -1})


" Tabline }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}



" 初期設定
" 最後に実施する必要あり。
silent call <SID>ToggleTabline(3)



" メーデー Tablineを非表示にする
com! Mayday set showtabline=0
com! MayDay Mayday
com! MAYDAY Mayday



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


