vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8


function SetStatusline(statusline_contents)

  let Gold = v:true


 "let stl = "  "
  let stl = " "


 "let stl ..= "%#SLFileName#[ %{winnr()} ]%## ( %n ) "

 "let stl ..= "%#SLFileName#[ %{winnr()} ] %#VertSplit2# ( %n ) "

"?let stl ..= "%#SLFileName# [ %{winnr()} ] %#VertSplit2# ( %n ) "
"?let stl ..= "%#SLFileName# [ %{winnr()} ] %## ( %n ) "
"?let stl ..= "%#VertSplit2# [ %{winnr()} ] %## ( %n ) "
"?let stl ..= "%##[ %{winnr()} ] %#VertSplit2# ( %n ) %h%w%#SLFileName# "
 "let stl ..= "%##[ %{winnr()} ] %#VertSplit2# ( %n )%h%w %#SLFileName#"
"?let stl ..= "%#SLFileName# [ %{winnr()} ] %## ( %n ) %h%w%#SLFileName# "
"?let stl ..= " %#VertSplit2# [ %{winnr()} ] %## ( %n ) %h%w%#SLFileName# "
"?let stl ..= " %#VertSplit2# %{winnr()} %## ( %n ) %h%w%#SLFileName# "

 "let stl ..= "%#SLFileName#[ %{winnr()} ]%## ( %n )"

  if a:statusline_contents['Winnr']
    if v:true
      let stl ..= "%##"
    else
      let stl ..= " %#SLFileName#"
    endif
    let stl ..= "[ %{winnr()} ]"
    if Gold
      let stl ..= " "
    endif

    if v:true
      let stl ..= "%#VertSplit2#"
    elseif v:true
      let stl ..= "%#SLFileName#"
    else
      let stl ..= "%##"
    endif
    let stl ..= " ( %n ) "

  else
    let stl ..= "%##[ %n ] "
  endif

  " OK
  if v:true
    let stl ..= "%#VertSplit2#"
  else
    let stl ..= "%##"
  endif
 "let stl ..= "%m%r%{(!&l:autoread\\\<Bar>\\\<Bar>(&l:autoread==-1&&!&autoread))?'':'[AR]'}"
  let stl ..= "%h%w%m%r%{(!&l:autoread\\\<Bar>\\\<Bar>(&l:autoread==-1&&!&autoread))?'':'[AR]'}"


  " OK
  let MyStlFugitive = a:statusline_contents['Branch'] ? ' [fugitive]' : ' fugitive'
  let stl ..= "%#hl_func_name_stl#%{bufname('') =~ '^fugitive' ? MyStlFugitive : ''}"
  let stl ..= "%#hl_func_name_stl#%{&filetype == 'fugitive' ? MyStlFugitive : ''}"

  if a:statusline_contents['Branch']
    let stl ..= "%#hl_func_name_stl#%{(FugitiveHead(7)!=''&& bufname('')!='NetrwTreeListing'&& bufname('')!~'^NERD_tree') ? (' ['.FugitiveHead(7).']') : ''}"
  endif


  " OK
  if a:statusline_contents['Path']
    let stl ..= "%<"
    "? let stl ..= "%#SLFileName# %F "
    let stl ..= "%## %F "
  else
    if v:false
      let stl ..= "%##  %t  "
    elseif v:true
      let stl ..= "%#SLFileName#  %t  "
    else
      let stl ..= "%#VertSplit2# %t "
    endif
    let stl ..= "%<"

    if a:statusline_contents['ShadowDir']
      if v:false
        let stl ..= "%#StatuslineNC#  "
      else
        let stl ..= "%#SLNoNameDir#  "
      endif
      let stl ..= "%{bufname('')=='' ? ' '.getcwd(winnr()) : expand('%:p:h')}"
      let stl ..= "    "
    endif
  endif

 if a:statusline_contents['NoNameBufPath'] && !a:statusline_contents['ShadowDir']
   " 無名バッファなら、cwdを常に表示。
   let stl ..= "%#SLNoNameDir# %{ bufname('') == '' ? getcwd(winnr()) : '' }"
 endif


  " OK
  if a:statusline_contents['FuncName']
    let stl ..= "%#hl_func_name_stl# %{cfi#format('%s()', '')}"
  endif


  " OK
  " ===== Separate Left Right =====
  let stl ..= "%#SLFileName#%="
  " ===== Separate Left Right =====


  " OK
  if a:statusline_contents['KeywordChars']
   "let stl ..= " %1{stridx(&isk,'_')<0?' ':'_'} "
    let stl ..= " ≪%{substitute(substitute(&isk, '\\\\d\\\\+-\\\\d\\\\+', '', 'g'), ',\\\\+', ' ', 'g')}≫"
  endif


  " OK
 "let stl ..= "%## %-3{ &ft == '' ? '   ' : ToCapital(&ft) }  %-5{ &fenc == '' ?  '     ' : toupper(&fenc) }  %4{ ToCapital(&ff) } "
 "let stl ..= "%## %-3{ &l:ft == '' ? '@  ' : ToCapital(&l:ft) }  %-5{ &l:fenc == '' ?  toupper(&g:fenc): toupper(&l:fenc) }  %4{ ToCapital(&l:ff) } "
 "let stl ..= "%## %-3{ &l:ft == '' ? '@  ' : &ft }  %-5{ &l:fenc == '' ?  &g:fenc : &l:fenc }  %4{ &l:ff } "
 "let stl ..= "%## %-5Y  %-5{ &l:fenc == '' ? &g:fenc : &l:fenc }  %4{ &l:ff } "
  let stl ..= "%## %-5{ &l:ft == '' ? '@' : &ft }  %-5{ &l:fenc == '' ? &g:fenc : &l:fenc }  %4{ &l:ff } "


  " OK
  let stl ..= "%#SLFileName# "
  let stl ..= "%1{ &l:wrap ? '==' : '>>' } "
 "let stl ..= "%{&l:scrollbind?'$':'@'} "
 "let stl ..= "      "
  if a:statusline_contents['TabStop']
    let stl ..= " ⇒%{&l:tabstop}"
  endif
  "
  "let stl ..= "%1{ c_jk_local != 0 ? 'L' : 'G' } "
  "let stl ..= "%4{ &iminsert ? 'Jpn' : 'Code' } "
  "let stl ..= "%{g:clever_f_use_migemo?'(M)':'(F)'} "


  " OK
  let stl ..= "%#SLFileName#  %{repeat(' ',winwidth(0)-178)}"


  "------------------------------------------------- {{{
  let stl ..= "%#VertSplit2#"
  let stl ..= "%##"
  let stl ..= "%#SLFileName#"

  " OK
  if a:statusline_contents['WordLen']
    let stl ..= " %4{'≪'.len(expand('<cword>'))}≫"
  endif

  " OK
  if a:statusline_contents['CharCode']
    "let stl ..= " 《%8(0x%B%)》"
    "let stl ..= " 《%8(0x%B%),%b》"
    let stl ..= " %10(《%(0x%B%)"
    if a:statusline_contents['CharCode10']
      let stl ..= ",%8b"
    endif
    let stl ..= "》%)"
  endif
  "------------------------------------------------- }}}

  " OK
  "------------------------------------------------- {{{
  let stl ..= "%##"
  let stl ..= "%#SLFileName#"
  let stl ..= "%#VertSplit2#"

  "let stl ..= " %3p%% %3P%% [%4L]"

  if a:statusline_contents['LinePercent']
    let stl ..= " %3p%%"
  endif
  if a:statusline_contents['ScreenPercent']
    let stl ..= " [%3P%%]"
  endif

  "let stl ..= " [%4L]"
  let stl ..= " %6([%L]%)"
  let stl ..= " "
  "------------------------------------------------- }}}

  "------------------------------------------------- {{{
  let stl ..= "%#SLFileName#"
  let stl ..= "%#VertSplit2#"
  let stl ..= "%##"

  if a:statusline_contents['Line']
    let stl ..= " %4l:L"
  endif

  let stl ..= " %3{getcursorcharpos()[2]}:c"
  let stl ..= " %3v:v"
  if a:statusline_contents['BytesOfColumn']
    let stl ..= " %3c:b"
  endif
 "let stl ..= " %3v:v %3c:b"

  if a:statusline_contents['BytesOfFile']
    let stl ..= " B:%6oBytes"
  endif

  "let stl ..= "     "
  "let stl ..= " "
  "------------------------------------------------- }}}


  let stl ..= "%#SLFileName#"
  let stl ..= "%#VertSplit2#"
  let stl ..= "%##"
  " Line系の末尾にスペースを置かないため。
  "let stl ..= "  "
  let stl ..= " "


  " call RestoreDefaultStatusline(v:true)
  exe 'set statusline=' .. substitute(stl, ' ', '\\ ', 'g')
endfunction


#----------------------------------------------------------------------------------------
# Switch Statusline Contents

g:StatuslineContents = {
  'Branch':         v:false,
  'BytesOfColumn':  v:false,
  'BytesOfFile':    v:false,
  'CharCode':       v:true,
  'CharCode10':     v:false,
  'Column':         v:true,
  'FuncName':       v:false,
  'KeywordChars':   v:false,
  'Line':           v:false,
  'LinePercent':    v:true,
  'NoNameBufPath':  v:false,
  'Path':           v:false,
  'ScreenPercent':  v:false,
  'ShadowDir':      v:true,
  'TabStop':        v:false,
  'Winnr':          v:true,
  'WordLen':        v:false,
  '':               v:false
}

function CompletionStlContents(ArgLead, CmdLine, CusorPos)
  let l = copy(g:StatuslineContents)
  return l->filter({ key -> key =~? ('^'..a:ArgLead..'.*') })->keys()->sort()
  "return g:StatuslineContents->filter((key, val) => !!(key =~? ('^'..ArgLead)))->keys()->sort()
  "return sort(keys(g:StatuslineContents))
endfunction
com! -nargs=1 -complete=customlist,CompletionStlContents Stl let g:StatuslineContents['<args>'] = !g:StatuslineContents['<args>'] | call <SID>SetDefaultStatusline(g:StatuslineContents)


#----------------------------------------------------------------------------------------
function ToCapital(str)
  return substitute(a:str, '.*', '\L\u&', '')
 "return toupper(a:str[0]) . a:str[1:]
endfunction


#----------------------------------------------------------------------------------------
# Initialize Statusline

# 初期設定のために1回は呼び出す。
call SetStatusline(g:StatuslineContents)


#----------------------------------------------------------------------------------------
#hi StatusLineNC		guifg=#7f1f1a	guibg=#d0c589	gui=none	" guibgは色を錯覚するので#d0c589から補正
