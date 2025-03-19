vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8


var Gold = v:true

def IsGold(): bool
  return Gold
enddef


function SetStatusline()
  let gold = s:IsGold()
  let contents_switch = s:StatuslineContentsSwitch

  let stl = ""


  "------------------------------------------------- {{{
  if contents_switch['Winnr']
    "let stl ..= "  %#SLFileName#"
    let stl ..= " [ %{winnr()} ] "

    if gold
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
  if contents_switch['Winnr']
    let stl ..= "%##"
  elseif gold
    let stl ..= "%#VertSplit2#"
  else
    let stl ..= "%#SLFileName#"
    if !contents_switch['Winnr']
      let stl ..= "  "
    endif
  endif
  let stl ..= "%h%w"

  if gold
    let stl ..= "%#VertSplit2#"
  elseif contents_switch['Winnr']
    let stl ..= "%##"
  else
    let stl ..= "%#SLFileName#  %##"
  endif
  let stl ..= "%m%r%{(!&l:autoread\\\<Bar>\\\<Bar>(&l:autoread==-1&&!&autoread))?'':'[AR]'}"
  "------------------------------------------------- }}}


  " TODO 
  "------------------------------------------------- {{{
  let MyStlFugitive = contents_switch['Branch'] ? ' [fugitive]' : ' fugitive'
  let stl ..= "%#hl_func_name_stl#"
  let stl ..= "%{(bufname('') =~ '^fugitive') \\|\\| (&filetype == 'fugitive') ? MyStlFugitive : ''}"

  if contents_switch['Branch']
    let stl ..= "%{(FugitiveHead(7)!=''&& bufname('')!='NetrwTreeListing'&& bufname('')!~'^NERD_tree') ? (' ['.FugitiveHead(7).']') : ''}"
  endif
  "------------------------------------------------- }}}


  "------------------------------------------------- {{{
  if contents_switch['Path']
    "let stl ..= "%#SLFileName#"
    let stl ..= "%##"
    let stl ..= "%<"
    let stl ..= " %F "
  else
    "let stl ..= "%#VertSplit2#"
    let stl ..= "%#SLFileName#"
    let stl ..= "%##"
    if !contents_switch['Winnr']
      let stl ..= "%#SLFileName#"
    endif
    let stl ..= "  %t  "

    let stl ..= "%<"

    if contents_switch['ShadowDir']
      let stl ..= "%#SLNoNameDir#"
      let stl ..= "  %{bufname('')=='' ? ' '.getcwd(winnr()) : expand('%:p:h')}"
    endif
  endif

  " TODO 
  if contents_switch['Path'] || (contents_switch['NoNameBufPath'] && !contents_switch['ShadowDir'])
    " 無名バッファなら、cwdを常に表示。
    let stl ..= "%#SLNoNameDir#"
    let stl ..= " %{ bufname('') == '' ? getcwd(winnr()) : '' }"
  endif
  "------------------------------------------------- }}}


  "------------------------------------------------- {{{
  if contents_switch['FuncName']
    let stl ..= "%#hl_func_name_stl#"
    let stl ..= " %{cfi#format('%s()', '')}"
  endif
  "------------------------------------------------- }}}


  "------------------------------------------------- {{{
  " ===== Separate Left Right =====
  let stl ..= "    %#SLFileName#%="
  "------------------------------------------------- }}}


  "------------------------------------------------- {{{
  if contents_switch['KeywordChars']
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

  if contents_switch['Wrap']
    let stl ..= " %1{ &l:wrap ? '  ' : '>>' } "
  endif

  if contents_switch['TabStop']
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

  if contents_switch['WordLen']
    let stl ..= " %4{'≪'.len(expand('<cword>'))}≫"
  endif

  if contents_switch['CharCode']
    let stl ..= " %10(《%(0x%B%)》%)"
  endif

  if contents_switch['CharCode10']
    let stl ..= " %10(《%(%b%)》%)"
  endif
  "------------------------------------------------- }}}


  "------------------------------------------------- {{{
  "let stl ..= "%##"
  if gold
    let stl ..= "%#VertSplit2#"
  else
    let stl ..= "%#SLFileName#"
  endif

  if contents_switch['LinePercent']
    let stl ..= " %3p%%"
  endif
  if contents_switch['ScreenPercent']
    let stl ..= " [%3P%%]"
  endif

  let stl ..= " %6([%L]%)"

  if contents_switch['BytesOfFile']
    let stl ..= " %6oBytes"
  endif

  let stl ..= " "
  "------------------------------------------------- }}}


  "------------------------------------------------- {{{
  "let stl ..= "%#SLFileName#"
  "let stl ..= "%#VertSplit2#"
  let stl ..= "%##"

  if contents_switch['Line']
    let stl ..= " %4l:L"
  endif

  let stl ..= " %3{getcursorcharpos()[2]}:c"
  let stl ..= " %3v:v"

  if contents_switch['ColumnBytes']
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
  SetStatusline()
}


#----------------------------------------------------------------------------------------
# Initialize Statusline

# 初期設定のために1回は呼び出す。
SetStatusline()
