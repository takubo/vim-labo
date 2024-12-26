" vimrc
"----------------------------------------------------------------------------------------
" Make Default Statusline

function! s:SetDefaultStatusline(statusline_contents)

  "let s:stl = "  "
  let s:stl = " "


  let s:stl .= "%#SLFileName#[ %{winnr()} ]%## ( %n ) "
  let s:stl .= "%##%m%r%{(!&autoread&&!&l:autoread)?'[AR]':''}%h%w "


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
    "? let s:stl .= "%#SLFileName#  %t  "
    let s:stl .= "%##  %t  "
    let s:stl .= "%<"

    if a:statusline_contents['ShadowPath']
      "? let s:stl .= "%#SLNoNameDir#"
      let s:stl .= "%#StatuslineNC#"
      let s:stl .= " %{bufname('')=='' ? ' '.getcwd(winnr()) : expand('%:p:h')}"
      let s:stl .= "    "
    endif
  endif

 if a:statusline_contents['NoNameBufPath'] && !a:statusline_contents['ShadowPath']
   " 無名バッファなら、cwdを常に表示。
   let s:stl .= "%#SLNoNameDir#%{ bufname('') == '' ? getcwd(winnr()) : '' }"
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
 "let s:stl .= "%## %-3{ &l:ft == '' ? 'a  ' : ToCapital(&l:ft) }  %-5{ &l:fenc == '' ?  toupper(&g:fenc): toupper(&l:fenc) }  %4{ ToCapital(&l:ff) } "
  let s:stl .= "%## %-3{ &l:ft == '' ? 'a  ' : &ft }  %-5{ &l:fenc == '' ?  &g:fenc : &l:fenc }  %4{ &l:ff } "


  " OK
  let s:stl .= "%#SLFileName# "
  let s:stl .= "%1{ &l:wrap ? '==' : '>>' } "
  let s:stl .= "%{&l:scrollbind?'$':'@'} "
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
  let s:stl .= "%##"

  "let s:stl .= " %3p%% %3P%% [%4L]"

  if a:statusline_contents['LinePercent']
    let s:stl .= " %3p%%"
  endif
  if a:statusline_contents['ScreenPercent']
    let s:stl .= " [%3P%%]"
  endif

  let s:stl .= " [%4L]"

  if a:statusline_contents['Line']
    let s:stl .= " %4l:L"
  endif

  let s:stl .= " %3v:v %3c:b"

  if a:statusline_contents['BytesOfFile']
    let s:stl .= " B:%6oBytes"
  endif


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


" 初期設定のために1回は呼び出す。
call s:SetDefaultStatusline(g:StatuslineContents)
