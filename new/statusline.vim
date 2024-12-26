" 1228
"----------------------------------------------------------------------------------------
" Make Default Statusline

function! s:SetDefaultStatusline(statusline_contents)

  let Gold = v:true


 "let s:stl = "  "
  let s:stl = " "


 "let s:stl .= "%#SLFileName#[ %{winnr()} ]%## ( %n ) "

 "let s:stl .= "%#SLFileName#[ %{winnr()} ] %#VertSplit2# ( %n ) "

"?let s:stl .= "%#SLFileName# [ %{winnr()} ] %#VertSplit2# ( %n ) "
"?let s:stl .= "%#SLFileName# [ %{winnr()} ] %## ( %n ) "
"?let s:stl .= "%#VertSplit2# [ %{winnr()} ] %## ( %n ) "
"?let s:stl .= "%##[ %{winnr()} ] %#VertSplit2# ( %n ) %h%w%#SLFileName# "
 "let s:stl .= "%##[ %{winnr()} ] %#VertSplit2# ( %n )%h%w %#SLFileName#"
"?let s:stl .= "%#SLFileName# [ %{winnr()} ] %## ( %n ) %h%w%#SLFileName# "
"?let s:stl .= " %#VertSplit2# [ %{winnr()} ] %## ( %n ) %h%w%#SLFileName# "
"?let s:stl .= " %#VertSplit2# %{winnr()} %## ( %n ) %h%w%#SLFileName# "

 "let s:stl .= "%#SLFileName#[ %{winnr()} ]%## ( %n )"

  if a:statusline_contents['Winnr']
    if v:true
      let s:stl .= "%##"
    else
      let s:stl .= " %#SLFileName#"
    endif
    let s:stl .= "[ %{winnr()} ]"
    if Gold
      let s:stl .= " "
    endif

    if v:true
      let s:stl .= "%#VertSplit2#"
    elseif v:true
      let s:stl .= "%#SLFileName#"
    else
      let s:stl .= "%##"
    endif
    let s:stl .= " ( %n ) "

  else
    let s:stl .= "%##[ %n ] "
  endif

  " OK
  if v:true
    let s:stl .= "%#VertSplit2#"
  else
    let s:stl .= "%##"
  endif
 "let s:stl .= "%m%r%{(!&l:autoread\\\<Bar>\\\<Bar>(&l:autoread==-1&&!&autoread))?'':'[AR]'}"
  let s:stl .= "%h%w%m%r%{(!&l:autoread\\\<Bar>\\\<Bar>(&l:autoread==-1&&!&autoread))?'':'[AR]'}"


  " OK
  let MyStlFugitive = a:statusline_contents['Branch'] ? ' [fugitive]' : ' fugitive'
  let s:stl .= "%#hl_func_name_stl#%{bufname('') =~ '^fugitive' ? MyStlFugitive : ''}"
  let s:stl .= "%#hl_func_name_stl#%{&filetype == 'fugitive' ? MyStlFugitive : ''}"

  if a:statusline_contents['Branch']
    let s:stl .= "%#hl_func_name_stl#%{(FugitiveHead(7)!=''&& bufname('')!='NetrwTreeListing'&& bufname('')!~'^NERD_tree') ? (' ['.FugitiveHead(7).']') : ''}"
  endif


  " OK
  if a:statusline_contents['Path']
    let s:stl .= "%<"
    "? let s:stl .= "%#SLFileName# %F "
    let s:stl .= "%## %F "
  else
    if v:false
      let s:stl .= "%##  %t  "
    elseif v:true
      let s:stl .= "%#SLFileName#  %t  "
    else
      let s:stl .= "%#VertSplit2# %t "
    endif
    let s:stl .= "%<"

    if a:statusline_contents['ShadowDir']
      if v:false
        let s:stl .= "%#StatuslineNC#  "
      else
        let s:stl .= "%#SLNoNameDir#  "
      endif
      let s:stl .= "%{bufname('')=='' ? ' '.getcwd(winnr()) : expand('%:p:h')}"
      let s:stl .= "    "
    endif
  endif

 if a:statusline_contents['NoNameBufPath'] && !a:statusline_contents['ShadowDir']
   " 無名バッファなら、cwdを常に表示。
   let s:stl .= "%#SLNoNameDir# %{ bufname('') == '' ? getcwd(winnr()) : '' }"
 endif


  " OK
  if a:statusline_contents['FuncName']
    let s:stl .= "%#hl_func_name_stl# %{cfi#format('%s()', '')}"
  endif


  " OK
  " ===== Separate Left Right =====
  let s:stl .= "%#SLFileName#%="
  " ===== Separate Left Right =====


  " OK
  if a:statusline_contents['KeywordChars']
   "let s:stl .= " %1{stridx(&isk,'_')<0?' ':'_'} "
    let s:stl .= " ≪%{substitute(substitute(&isk, '\\\\d\\\\+-\\\\d\\\\+', '', 'g'), ',\\\\+', ' ', 'g')}≫"
  endif


  " OK
 "let s:stl .= "%## %-3{ &ft == '' ? '   ' : ToCapital(&ft) }  %-5{ &fenc == '' ?  '     ' : toupper(&fenc) }  %4{ ToCapital(&ff) } "
 "let s:stl .= "%## %-3{ &l:ft == '' ? '@  ' : ToCapital(&l:ft) }  %-5{ &l:fenc == '' ?  toupper(&g:fenc): toupper(&l:fenc) }  %4{ ToCapital(&l:ff) } "
 "let s:stl .= "%## %-3{ &l:ft == '' ? '@  ' : &ft }  %-5{ &l:fenc == '' ?  &g:fenc : &l:fenc }  %4{ &l:ff } "
 "let s:stl .= "%## %-5Y  %-5{ &l:fenc == '' ? &g:fenc : &l:fenc }  %4{ &l:ff } "
  let s:stl .= "%## %-5{ &l:ft == '' ? '@' : &ft }  %-5{ &l:fenc == '' ? &g:fenc : &l:fenc }  %4{ &l:ff } "


  " OK
  let s:stl .= "%#SLFileName# "
  let s:stl .= "%1{ &l:wrap ? '==' : '>>' } "
 "let s:stl .= "%{&l:scrollbind?'$':'@'} "
 "let s:stl .= "      "
  if a:statusline_contents['TabStop']
    let s:stl .= " ⇒%{&l:tabstop}"
  endif
  "
  "let s:stl .= "%1{ c_jk_local != 0 ? 'L' : 'G' } "
  "let s:stl .= "%4{ &iminsert ? 'Jpn' : 'Code' } "
  "let s:stl .= "%{g:clever_f_use_migemo?'(M)':'(F)'} "


  " OK
  let s:stl .= "%#SLFileName#  %{repeat(' ',winwidth(0)-178)}"


  "------------------------------------------------- {{{
  let s:stl .= "%#VertSplit2#"
  let s:stl .= "%##"
  let s:stl .= "%#SLFileName#"

  " OK
  if a:statusline_contents['WordLen']
    let s:stl .= " %4{'≪'.len(expand('<cword>'))}≫"
  endif

  " OK
  if a:statusline_contents['CharCode']
    "let s:stl .= " 《%8(0x%B%)》"
    "let s:stl .= " 《%8(0x%B%),%b》"
    let s:stl .= " %10(《%(0x%B%)"
    if a:statusline_contents['CharCode10']
      let s:stl .= ",%8b"
    endif
    let s:stl .= "》%)"
  endif
  "------------------------------------------------- }}}

  " OK
  "------------------------------------------------- {{{
  let s:stl .= "%##"
  let s:stl .= "%#SLFileName#"
  let s:stl .= "%#VertSplit2#"

  "let s:stl .= " %3p%% %3P%% [%4L]"

  if a:statusline_contents['LinePercent']
    let s:stl .= " %3p%%"
  endif
  if a:statusline_contents['ScreenPercent']
    let s:stl .= " [%3P%%]"
  endif

  "let s:stl .= " [%4L]"
  let s:stl .= " %6([%L]%)"
  let s:stl .= " "
  "------------------------------------------------- }}}

  "------------------------------------------------- {{{
  let s:stl .= "%#SLFileName#"
  let s:stl .= "%#VertSplit2#"
  let s:stl .= "%##"

  if a:statusline_contents['Line']
    let s:stl .= " %4l:L"
  endif

  let s:stl .= " %3{getcursorcharpos()[2]}:c"
  let s:stl .= " %3v:v"
  if a:statusline_contents['BytesOfColumn']
    let s:stl .= " %3c:b"
  endif
 "let s:stl .= " %3v:v %3c:b"

  if a:statusline_contents['BytesOfFile']
    let s:stl .= " B:%6oBytes"
  endif

  "let s:stl .= "     "
  "let s:stl .= " "
  "------------------------------------------------- }}}


  let s:stl .= "%#SLFileName#"
  let s:stl .= "%#VertSplit2#"
  let s:stl .= "%##"
  " Line系の末尾にスペースを置かないため。
  "let s:stl .= "  "
  let s:stl .= " "


  " call RestoreDefaultStatusline(v:true)
  exe 'set statusline=' .. substitute(s:stl, ' ', '\\ ', 'g')
endfunction


"----------------------------------------------------------------------------------------
" Switch Statusline Contents

let g:StatuslineContents = {}

let g:StatuslineContents['Branch']        = v:false
let g:StatuslineContents['BytesOfColumn'] = v:false
let g:StatuslineContents['BytesOfFile']   = v:false
let g:StatuslineContents['CharCode']      = v:true
let g:StatuslineContents['CharCode10']    = v:false
let g:StatuslineContents['Column']        = v:true
let g:StatuslineContents['FuncName']      = v:false
let g:StatuslineContents['KeywordChars']  = v:false
let g:StatuslineContents['Line']          = v:false
let g:StatuslineContents['LinePercent']   = v:true
let g:StatuslineContents['NoNameBufPath'] = v:false
let g:StatuslineContents['Path']          = v:false
let g:StatuslineContents['ScreenPercent'] = v:false
let g:StatuslineContents['ShadowDir']     = v:true
let g:StatuslineContents['TabStop']       = v:false
let g:StatuslineContents['Winnr']         = v:true
let g:StatuslineContents['WordLen']       = v:false

function! s:CompletionStlContents(ArgLead, CmdLine, CusorPos)
  let l = copy(g:StatuslineContents)
  return l->filter({ key -> key =~? ('^'..a:ArgLead..'.*') })->keys()->sort()
  "return g:StatuslineContents->filter((key, val) => !!(key =~? ('^'..ArgLead)))->keys()->sort()
  "return sort(keys(g:StatuslineContents))
endfunction
com! -nargs=1 -complete=customlist,s:CompletionStlContents Stl let g:StatuslineContents['<args>'] = !g:StatuslineContents['<args>'] | call <SID>SetDefaultStatusline(g:StatuslineContents)


"----------------------------------------------------------------------------------------
function! ToCapital(str)
  return substitute(a:str, '.*', '\L\u&', '')
 "return toupper(a:str[0]) . a:str[1:]
endfunction


"----------------------------------------------------------------------------------------
" Initialize Statusline

" 初期設定のために1回は呼び出す。
call s:SetDefaultStatusline(g:StatuslineContents)


"----------------------------------------------------------------------------------------
com! Winnr echo '  ' winnr('$')


"----------------------------------------------------------------------------------------
"hi StatusLineNC		guifg=#7f1f1a	guibg=#d0c589	gui=none	" guibgは色を錯覚するので#d0c589から補正


finish


"----------------------------------------------------------------------------------------
" Alt Statusline

function! s:SetStatusline(stl, local, time)
  " 旧タイマの削除
  if a:time > 0 && exists('s:TimerUsl') | call timer_stop(s:TimerUsl) | unlet s:TimerUsl | endif

  " Local Statusline の保存。および、WinLeaveイベントの設定。
  if a:local == 'l'
    let w:stl = getwinvar(winnr(), 'stl', &l:stl)
    augroup MyVimrc_Restore_LocalStl
      au!
      au WinLeave * if exists('w:stl') | let &l:stl = w:stl | unlet w:stl | endif
      au WinLeave * au! MyVimrc_Restore_LocalStl
    augroup end
  else
    let save_cur_win = winnr()
    windo let w:stl = getwinvar(winnr(), 'stl', &l:stl)
    silent exe save_cur_win . 'wincmd w'
    augroup MyVimrc_Restore_LocalStl
      au!
    augroup end
  endif

  " Statusline の設定
  exe 'set' . a:local . ' stl=' . substitute(a:stl, ' ', '\\ ', 'g')

  " タイマスタート
  if a:time > 0 | let s:TimerUsl = timer_start(a:time, 'RestoreDefaultStatusline', {'repeat': v:false}) | endif
endfunction

function! RestoreDefaultStatusline(force)
  " AltStlになっていないときは、強制フラグが立っていない限りDefaultへ戻さない。
  if !exists('s:TimerUsl') && !a:force | return | endif

  " 旧タイマの削除
  if exists('s:TimerUsl') | call timer_stop(s:TimerUsl) | unlet s:TimerUsl | endif

  " TODO これの呼び出し意図確認
  call s:SetStatusline(s:stl, '', -1)

  let save_cur_win = winnr()

  " Localしか設定してないときは、全WindowのStlを再設定するより、if existsの方が速いか？
  "windo let &l:stl = getwinvar(winnr(), 'stl', '')
  windo if exists('w:stl') | let &l:stl = w:stl | unlet w:stl | endif

  silent exe save_cur_win . 'wincmd w'
endfunction

augroup MyVimrc_Stl
  au!
  " このイベントがないと、AltStlが設定されているWindowを分割して作ったWindowの&l:stlに、
  " 分割元WindowのAltStlの内容が設定されっぱなしになってしまう。
  au WinEnter * let &l:stl = ''
augroup end


"----------------------------------------------------------------------------------------
" Alt-Statusline API

function! SetAltStatusline(stl, local, time)
  call s:SetStatusline(a:stl, a:local, a:time)
endfunction

function! AddAltStatusline(stl, local, time)
  call s:SetStatusline((a:local == 'l' ? &l:stl : &stl) . a:stl, a:local, a:time)
endfunction


"----------------------------------------------------------------------------------------
function! s:SetDefaultStatusline(statusline_contents)

  let Gold = v:true


 "let s:stl = "  "
  let s:stl = " "


 "let s:stl .= "%#SLFileName#[ %{winnr()} ]%## ( %n ) "

 "let s:stl .= "%#SLFileName#[ %{winnr()} ] %#VertSplit2# ( %n ) "

"?let s:stl .= "%#SLFileName# [ %{winnr()} ] %#VertSplit2# ( %n ) "
"?let s:stl .= "%#SLFileName# [ %{winnr()} ] %## ( %n ) "
"?let s:stl .= "%#VertSplit2# [ %{winnr()} ] %## ( %n ) "
"?let s:stl .= "%##[ %{winnr()} ] %#VertSplit2# ( %n ) %h%w%#SLFileName# "
 "let s:stl .= "%##[ %{winnr()} ] %#VertSplit2# ( %n )%h%w %#SLFileName#"
"?let s:stl .= "%#SLFileName# [ %{winnr()} ] %## ( %n ) %h%w%#SLFileName# "
"?let s:stl .= " %#VertSplit2# [ %{winnr()} ] %## ( %n ) %h%w%#SLFileName# "
"?let s:stl .= " %#VertSplit2# %{winnr()} %## ( %n ) %h%w%#SLFileName# "

 "let s:stl .= "%#SLFileName#[ %{winnr()} ]%## ( %n )"

  if a:statusline_contents['Winnr']
    let s:stl .= " %#SLFileName#[ %{winnr()} ]"
    let s:stl .= "%## ( %n ) "
  else
    let s:stl .= "%##[ %n ] "
  endif

  " OK
  if Gold
    let s:stl .= "%#VertSplit2#"
  else
    let s:stl .= "%##"
  endif
 "let s:stl .= "%m%r%{(!&l:autoread\\\<Bar>\\\<Bar>(&l:autoread==-1&&!&autoread))?'':'[AR]'}"
  let s:stl .= "%h%w%m%r%{(!&l:autoread\\\<Bar>\\\<Bar>(&l:autoread==-1&&!&autoread))?'':'[AR]'}"


  " OK
  let MyStlFugitive = a:statusline_contents['Branch'] ? ' [fugitive]' : ' fugitive'
  let s:stl .= "%#hl_func_name_stl#%{bufname('') =~ '^fugitive' ? MyStlFugitive : ''}"
  let s:stl .= "%#hl_func_name_stl#%{&filetype == 'fugitive' ? MyStlFugitive : ''}"

  if a:statusline_contents['Branch']
    let s:stl .= "%#hl_func_name_stl#%{(FugitiveHead(7)!=''&& bufname('')!='NetrwTreeListing'&& bufname('')!~'^NERD_tree') ? (' ['.FugitiveHead(7).']') : ''}"
  endif


  " OK
  if a:statusline_contents['Path']
    let s:stl .= "%<"
    "? let s:stl .= "%#SLFileName# %F "
    let s:stl .= "%## %F "
  else
    if v:false
      let s:stl .= "%##  %t  "
    elseif v:true
      let s:stl .= "%#SLFileName#  %t  "
    else
      let s:stl .= "%#VertSplit2# %t "
    endif
    let s:stl .= "%<"

    if a:statusline_contents['ShadowDir']
      if v:false
        let s:stl .= "%#StatuslineNC#  "
      else
        let s:stl .= "%#SLNoNameDir#  "
      endif
      let s:stl .= "%{bufname('')=='' ? ' '.getcwd(winnr()) : expand('%:p:h')}"
      let s:stl .= "    "
    endif
  endif

 if a:statusline_contents['NoNameBufPath'] && !a:statusline_contents['ShadowDir']
   " 無名バッファなら、cwdを常に表示。
   let s:stl .= "%#SLNoNameDir# %{ bufname('') == '' ? getcwd(winnr()) : '' }"
 endif


  " OK
  if a:statusline_contents['FuncName']
    let s:stl .= "%#hl_func_name_stl# %{cfi#format('%s()', '')}"
  endif


  " OK
  " ===== Separate Left Right =====
  let s:stl .= "%#SLFileName#%="
  " ===== Separate Left Right =====


  " OK
  if a:statusline_contents['KeywordChars']
   "let s:stl .= " %1{stridx(&isk,'_')<0?' ':'_'} "
    let s:stl .= " ≪%{substitute(substitute(&isk, '\\\\d\\\\+-\\\\d\\\\+', '', 'g'), ',\\\\+', ' ', 'g')}≫"
  endif


  " OK
 "let s:stl .= "%## %-3{ &ft == '' ? '   ' : ToCapital(&ft) }  %-5{ &fenc == '' ?  '     ' : toupper(&fenc) }  %4{ ToCapital(&ff) } "
 "let s:stl .= "%## %-3{ &l:ft == '' ? '@  ' : ToCapital(&l:ft) }  %-5{ &l:fenc == '' ?  toupper(&g:fenc): toupper(&l:fenc) }  %4{ ToCapital(&l:ff) } "
 "let s:stl .= "%## %-3{ &l:ft == '' ? '@  ' : &ft }  %-5{ &l:fenc == '' ?  &g:fenc : &l:fenc }  %4{ &l:ff } "
 "let s:stl .= "%## %-5Y  %-5{ &l:fenc == '' ? &g:fenc : &l:fenc }  %4{ &l:ff } "
  let s:stl .= "%## %-5{ &l:ft == '' ? '@' : &ft }  %-5{ &l:fenc == '' ? &g:fenc : &l:fenc }  %4{ &l:ff } "


  " OK
  let s:stl .= "%#SLFileName# "
  let s:stl .= "%1{ &l:wrap ? '==' : '>>' } "
 "let s:stl .= "%{&l:scrollbind?'$':'@'} "
 "let s:stl .= "      "
  if a:statusline_contents['TabStop']
    let s:stl .= " ⇒%{&l:tabstop}"
  endif
  "
  "let s:stl .= "%1{ c_jk_local != 0 ? 'L' : 'G' } "
  "let s:stl .= "%4{ &iminsert ? 'Jpn' : 'Code' } "
  "let s:stl .= "%{g:clever_f_use_migemo?'(M)':'(F)'} "


  " OK
  let s:stl .= "%#SLFileName#  %{repeat(' ',winwidth(0)-178)}"


  " OK
  "-----------------------------------------------------
  let s:stl .= "%#SLFileName#"

  "let s:stl .= " %3p%% %3P%% [%4L]"

  if a:statusline_contents['LinePercent']
    let s:stl .= " %3p%%"
  endif
  if a:statusline_contents['ScreenPercent']
    let s:stl .= " [%3P%%]"
  endif

  let s:stl .= " [%4L]"
  let s:stl .= "     "
  "-----------------------------------------------------

  "-----------------------------------------------------
  let s:stl .= "%##"

  if a:statusline_contents['Line']
    let s:stl .= " %4l:L"
  endif

  let s:stl .= " %3v:v %3c:b"

  if a:statusline_contents['BytesOfFile']
    let s:stl .= " B:%6oBytes"
  endif
  "-----------------------------------------------------


  " OK
  if a:statusline_contents['WordLen']
    let s:stl .= " %4{'≪'.len(expand('<cword>'))}≫"
  endif


  " OK
  if a:statusline_contents['CharCode']
    let s:stl .= " 《0x%-4B》"
  endif


  " Line系の末尾にスペースを置かないため。
  let s:stl .= "  "


  " call RestoreDefaultStatusline(v:true)
  exe 'set statusline=' .. substitute(s:stl, ' ', '\\ ', 'g')
endfunction



  " OK
  "-----------------------------------------------------
  let s:stl .= "%#SLFileName#"

  if a:statusline_contents['Line']
    let s:stl .= " %4l:L"
  endif

  let s:stl .= " %3v:v %3c:b"

  if a:statusline_contents['BytesOfFile']
    let s:stl .= " B:%6oBytes"
  endif

 "let s:stl .= "     "
  let s:stl .= " "
  "-----------------------------------------------------

  "-----------------------------------------------------
  let s:stl .= "%##"

  "let s:stl .= " %3p%% %3P%% [%4L]"

  if a:statusline_contents['LinePercent']
    let s:stl .= " %3p%%"
  endif
  if a:statusline_contents['ScreenPercent']
    let s:stl .= " [%3P%%]"
  endif

  let s:stl .= " [%4L]"
  "-----------------------------------------------------
