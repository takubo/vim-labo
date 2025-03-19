vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8


function SetStatusline(statusline_contents)
  let Gold = v:false

  let stl = ""


  "------------------------------------------------- {{{
  if a:statusline_contents['Winnr']
    "let stl ..= "  %#SLFileName#"
    let stl ..= " [ %{winnr()} ] "

    if Gold
      let stl ..= "%#VertSplit2#"
    else
      let stl ..= "%#SLFileName#"
      "let stl ..= "%##"
    endif
    let stl ..= " ( %n ) "
  else
    let stl ..= " [ %n ] "
  endif
  "------------------------------------------------- }}}


  "------------------------------------------------- {{{
  if a:statusline_contents['Winnr']
    let stl ..= "%##"
  elseif Gold
    let stl ..= "%#VertSplit2#"
  else
    let stl ..= "%#SLFileName#"
    if !a:statusline_contents['Winnr']
      let stl ..= "  "
    endif
  endif
  let stl ..= "%h%w"

  if Gold
    let stl ..= "%#VertSplit2#"
  elseif a:statusline_contents['Winnr']
    let stl ..= "%##"
  else
    let stl ..= "%#SLFileName#  %##"
  endif
  let stl ..= "%m%r%{(!&l:autoread\\\<Bar>\\\<Bar>(&l:autoread==-1&&!&autoread))?'':'[AR]'}"
  "------------------------------------------------- }}}


  " TODO 
  "------------------------------------------------- {{{
  let MyStlFugitive = a:statusline_contents['Branch'] ? ' [fugitive]' : ' fugitive'
  let stl ..= "%#hl_func_name_stl#"
  let stl ..= "%{(bufname('') =~ '^fugitive') \\|\\| (&filetype == 'fugitive') ? MyStlFugitive : ''}"

  if a:statusline_contents['Branch']
    let stl ..= "%{(FugitiveHead(7)!=''&& bufname('')!='NetrwTreeListing'&& bufname('')!~'^NERD_tree') ? (' ['.FugitiveHead(7).']') : ''}"
  endif
  "------------------------------------------------- }}}


  "------------------------------------------------- {{{
  if a:statusline_contents['Path']
    "let stl ..= "%#SLFileName#"
    let stl ..= "%##"
    let stl ..= "%<"
    let stl ..= " %F "
  else
    "let stl ..= "%#VertSplit2#"
    let stl ..= "%#SLFileName#"
    let stl ..= "%##"
    if !a:statusline_contents['Winnr']
      let stl ..= "%#SLFileName#"
    endif
    let stl ..= "  %t  "

    let stl ..= "%<"

    if a:statusline_contents['ShadowDir']
      let stl ..= "%#SLNoNameDir#"
      let stl ..= "  %{bufname('')=='' ? ' '.getcwd(winnr()) : expand('%:p:h')}"
    endif
  endif

  " TODO 
  if a:statusline_contents['Path'] || (a:statusline_contents['NoNameBufPath'] && !a:statusline_contents['ShadowDir'])
    " 無名バッファなら、cwdを常に表示。
    let stl ..= "%#SLNoNameDir#"
    let stl ..= " %{ bufname('') == '' ? getcwd(winnr()) : '' }"
  endif
  "------------------------------------------------- }}}


  "------------------------------------------------- {{{
  if a:statusline_contents['FuncName']
    let stl ..= "%#hl_func_name_stl#"
    let stl ..= " %{cfi#format('%s()', '')}"
  endif
  "------------------------------------------------- }}}


  "------------------------------------------------- {{{
  " ===== Separate Left Right =====
  let stl ..= "    %#SLFileName#%="
  "------------------------------------------------- }}}


  "------------------------------------------------- {{{
  if a:statusline_contents['KeywordChars']
    let stl ..= "%#SLFileName#"
    let stl ..= " ≪%{substitute(substitute(&isk, '\\\\d\\\\+-\\\\d\\\\+', '', 'g'), ',\\\\+', ' ', 'g')}≫"
  endif
  "------------------------------------------------- }}}


  "------------------------------------------------- {{{
  let stl ..= "%##"
  let stl ..= " %-5{ &l:ft == '' ? '@' : &ft }  %-5{ &l:fenc == '' ? &g:fenc : &l:fenc }  %4{ &l:ff } "
  "------------------------------------------------- }}}


  "------------------------------------------------- {{{
  "let stl ..= "%#SLNoNameDir#"
  let stl ..= "%#SLFileName#"

  if a:statusline_contents['Wrap']
    let stl ..= " %1{ &l:wrap ? '  ' : '>>' } "
  endif

  if a:statusline_contents['TabStop']
    let stl ..= " ⇒%{&l:tabstop}"
  endif
  "------------------------------------------------- }}}


  " TODO
  "------------------------------------------------- {{{
  " ===== Padding =====
  let stl ..= "%#SLFileName#"
  let stl ..= "  %{repeat(' ',winwidth(0)-178)}"
  "------------------------------------------------- }}}


  "------------------------------------------------- {{{
  "let stl ..= "%#VertSplit2#"
  "let stl ..= "%##"
  let stl ..= "%#SLFileName#"

  if a:statusline_contents['WordLen']
    let stl ..= " %4{'≪'.len(expand('<cword>'))}≫"
  endif

  if a:statusline_contents['CharCode']
    let stl ..= " %10(《%(0x%B%)》%)"
  endif

  if a:statusline_contents['CharCode10']
    let stl ..= " %10(《%(%b%)》%)"
  endif
  "------------------------------------------------- }}}


  "------------------------------------------------- {{{
  "let stl ..= "%##"
  if Gold
    let stl ..= "%#VertSplit2#"
  else
    let stl ..= "%#SLFileName#"
  endif

  if a:statusline_contents['LinePercent']
    let stl ..= " %3p%%"
  endif
  if a:statusline_contents['ScreenPercent']
    let stl ..= " [%3P%%]"
  endif

  let stl ..= " %6([%L]%)"

  if a:statusline_contents['BytesOfFile']
    let stl ..= " %6oBytes"
  endif

  let stl ..= " "
  "------------------------------------------------- }}}


  "------------------------------------------------- {{{
  "let stl ..= "%#SLFileName#"
  "let stl ..= "%#VertSplit2#"
  let stl ..= "%##"

  if a:statusline_contents['Line']
    let stl ..= " %4l:L"
  endif

  let stl ..= " %3{getcursorcharpos()[2]}:c"
  let stl ..= " %3v:v"

  if a:statusline_contents['ColumnBytes']
    let stl ..= " %3c:b"
  endif

  let stl ..= " "
  "------------------------------------------------- }}}


  exe 'set statusline=' .. substitute(stl, ' ', '\\ ', 'g')
endfunction


#----------------------------------------------------------------------------------------
# Switch Statusline Contents

var StatuslineContentsSwitch = {
  'Branch':        false,
  'BytesOfFile':   false,
  'CharCode':      false,
  'CharCode10':    false,
  #'Column':        true,
  'ColumnBytes':   false,
  'FuncName':      false,
  'KeywordChars':  false,
  'Line':          false,
  'LinePercent':   true,
  'NoNameBufPath': true,
  'Path':          false,
  'ScreenPercent': false,
  'ShadowDir':     false,
  'TabStop':       false,
  'Winnr':         false,
  'WordLen':       false,
  'Wrap':          true
}

def CompletionStlContents(ArgLead: string, CmdLine: string, CusorPos: number): list<string>
  return copy(StatuslineContentsSwitch) -> filter((key, _) => key =~? ('^' .. ArgLead .. '.*')) -> keys() -> sort()
enddef

com! -nargs=1 -complete=customlist,CompletionStlContents Stl {
  StatuslineContentsSwitch['<args>'] = !StatuslineContentsSwitch['<args>']
  SetStatusline(StatuslineContentsSwitch)
}


#----------------------------------------------------------------------------------------
# Initialize Statusline

# 初期設定のために1回は呼び出す。
SetStatusline(StatuslineContentsSwitch)
