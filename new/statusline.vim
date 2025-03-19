vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8


var Gold = v:true

def IsGold(): bool
  return Gold
enddef


def SetStatusline()
  const gold = IsGold()
  const contents_switch = StatuslineContentsSwitch

  var stl = ""


  #------------------------------------------------- {{{
  if contents_switch['Winnr']
    #let stl ..= "  %#SLFileName#"
    stl ..= " [ %{winnr()} ] "

    if gold
      stl ..= "%#VertSplit2#"
    else
      stl ..= "%#SLFileName#"
      #let stl ..= "%##"
    endif
    stl ..= " ( %n ) "
  else
    stl ..= " [ %n ] "
  endif
  #------------------------------------------------- }}}


  #------------------------------------------------- {{{
  if contents_switch['Winnr']
    stl ..= "%##"
  elseif gold
    stl ..= "%#VertSplit2#"
  else
    stl ..= "%#SLFileName#"
    if !contents_switch['Winnr']
      stl ..= "  "
    endif
  endif
  stl ..= "%h%w"

  if gold
    stl ..= "%#VertSplit2#"
  elseif contents_switch['Winnr']
    stl ..= "%##"
  else
    stl ..= "%#SLFileName#  %##"
  endif
  stl ..= "%m%r%{(!&l:autoread\\\<Bar>\\\<Bar>(&l:autoread==-1&&!&autoread))?'':'[AR]'}"
  #------------------------------------------------- }}}


  # TODO 
  #------------------------------------------------- {{{
  const MyStlFugitive = contents_switch['Branch'] ? ' [fugitive]' : ' fugitive'
  stl ..= "%#hl_func_name_stl#"
  stl ..= "%{(bufname('') =~ '^fugitive') \\|\\| (&filetype == 'fugitive') ? MyStlFugitive : ''}"

  if contents_switch['Branch']
    stl ..= "%{(FugitiveHead(7)!=''&& bufname('')!='NetrwTreeListing'&& bufname('')!~'^NERD_tree') ? (' ['.FugitiveHead(7).']') : ''}"
  endif
  #------------------------------------------------- }}}


  #------------------------------------------------- {{{
  if contents_switch['Path']
    #let stl ..= "%#SLFileName#"
    stl ..= "%##"
    stl ..= "%<"
    stl ..= " %F "
  else
    stl ..= "%#SLFileName#"
    stl ..= "%##"
    if !contents_switch['Winnr']
      stl ..= "%#SLFileName#"
      stl ..= "%#VertSplit2#"
    endif
    stl ..= "  %t  "

    stl ..= "%<"

    if contents_switch['ShadowDir']
      stl ..= "%#SLNoNameDir#"
      stl ..= "  %{bufname('')=='' ? ' '.getcwd(winnr()) : expand('%:p:h')}"
    endif
  endif

  # TODO 
  if contents_switch['Path'] || (contents_switch['NoNameBufPath'] && !contents_switch['ShadowDir'])
    # 無名バッファなら、cwdを常に表示。
    stl ..= "%#SLNoNameDir#"
    stl ..= " %{ bufname('') == '' ? getcwd(winnr()) : '' }"
  endif
  #------------------------------------------------- }}}


  #------------------------------------------------- {{{
  if contents_switch['FuncName']
    stl ..= "%#hl_func_name_stl#"
    stl ..= " %{cfi#format('%s()', '')}"
  endif
  #------------------------------------------------- }}}


  #------------------------------------------------- {{{
  # ===== Separate Left Right =====
  stl ..= "    %#SLFileName#%="
  #------------------------------------------------- }}}


  #------------------------------------------------- {{{
  if contents_switch['KeywordChars']
    stl ..= "%#SLFileName#"
    stl ..= " ≪%{substitute(substitute(&isk, '\\\\d\\\\+-\\\\d\\\\+', '', 'g'), ',\\\\+', ' ', 'g')}≫"
  endif
  #------------------------------------------------- }}}


  #------------------------------------------------- {{{
  stl ..= "%##"
  stl ..= " %-5{ &l:ft == '' ? '@' : &ft }  %-5{ &l:fenc == '' ? &g:fenc : &l:fenc }  %4{ &l:ff } "
  #------------------------------------------------- }}}


  #------------------------------------------------- {{{
  #let stl ..= "%#SLNoNameDir#"
  stl ..= "%#SLFileName#"

  if contents_switch['Wrap']
    stl ..= " %1{ &l:wrap ? '  ' : '>>' } "
  endif

  if contents_switch['TabStop']
    stl ..= " ⇒%{&l:tabstop}"
  endif
  #------------------------------------------------- }}}


  # TODO
  #------------------------------------------------- {{{
  # ===== Padding =====
  stl ..= "%#SLFileName#"
  stl ..= "  %{repeat(' ',winwidth(0)-178)}"
  #------------------------------------------------- }}}


  #------------------------------------------------- {{{
  #let stl ..= "%#VertSplit2#"
  #let stl ..= "%##"
  stl ..= "%#SLFileName#"

  if contents_switch['WordLen']
    stl ..= " %4{'≪'.len(expand('<cword>'))}≫"
  endif

  if contents_switch['CharCode']
    stl ..= " %10(《%(0x%B%)》%)"
  endif

  if contents_switch['CharCode10']
    stl ..= " %10(《%(%b%)》%)"
  endif
  #------------------------------------------------- }}}


  #------------------------------------------------- {{{
  #let stl ..= "%##"
  if gold
    stl ..= "%#VertSplit2#"
  else
    stl ..= "%#SLFileName#"
  endif

  if contents_switch['LinePercent']
    stl ..= " %3p%%"
  endif
  if contents_switch['ScreenPercent']
    stl ..= " [%3P%%]"
  endif

  stl ..= " %6([%L]%)"

  if contents_switch['BytesOfFile']
    stl ..= " %6oBytes"
  endif

  stl ..= " "
  #------------------------------------------------- }}}


  #------------------------------------------------- {{{
  #let stl ..= "%#SLFileName#"
  #let stl ..= "%#VertSplit2#"
  stl ..= "%##"

  if contents_switch['Line']
    stl ..= " %4l:L"
  endif

  stl ..= " %3{getcursorcharpos()[2]}:c"
  stl ..= " %3v:v"

  if contents_switch['ColumnBytes']
    stl ..= " %3c:b"
  endif

  stl ..= " "
  #------------------------------------------------- }}}


  exe 'set statusline=' .. substitute(stl, ' ', '\\ ', 'g')
enddef


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
