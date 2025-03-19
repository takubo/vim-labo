vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8


var Gold = true

def IsGold(): bool
  return Gold
enddef

com! Gold Gold = !Gold


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
  stl ..= "%m%r%{(!&l:autoread\|\|(&l:autoread==-1&&!&autoread))?'':'[AR]'}"
  #------------------------------------------------- }}}


  # TODO 
  #------------------------------------------------- {{{
  const MyStlFugitive = contents_switch['Branch'] ? ' [fugitive]' : ' fugitive'
  stl ..= "%#hl_func_name_stl#"
  stl ..= "%{(bufname('') =~ '^fugitive') \|\| (&filetype == 'fugitive') ? MyStlFugitive : ''}"

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
    stl ..= " ≪%{substitute(substitute(&isk, '\\\d\\\+-\\\d\\\+', '', 'g'), ',\\\+', ' ', 'g')}≫"
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


  &statusline = substitute(stl, ' ', '\ ', 'g')
  # exe 'set statusline=' .. substitute(stl, ' ', '\\ ', 'g')
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
  'FuncName':      true,
  'KeywordChars':  true,
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
  return keys(StatuslineContentsSwitch) -> filter((_, val) => val =~? ('^' .. ArgLead .. '.*')) -> sort()
enddef

com! -nargs=1 -complete=customlist,CompletionStlContents Stl {
  StatuslineContentsSwitch['<args>'] = !StatuslineContentsSwitch['<args>']
  SetStatusline()
}


#----------------------------------------------------------------------------------------
# Initialize Statusline

# 初期設定のために1回は呼び出す。
SetStatusline()


nnoremap @ <Cmd>Stl Winnr<CR>
nnoremap , <Cmd>Gold<CR><Cmd>redrawstatus!<CR>
#finish

com! -nargs=1 -complete=customlist,CompletionStlContents Stl {
  StatuslineContentsSwitch['<args>'] = !StatuslineContentsSwitch['<args>']
  redrawstatus!
}



# vim9scriptでは、&autoreadの型がboolになるので、-1との比較ができない。
function Autoread(bufnr)
  let l_autoread = getbufvar(a:bufnr, '&l:autoread')
  return (l_autoread == 1 || (l_autoread == -1 && &g:autoread != 0)) ? v:true : v:false
endfunction


def BranchName(bufnr: number): string
  var branch_name = ''

  if exists_compiled('*FugitiveHead')
    branch_name = FugitiveHead(7, bufnr)
    if branch_name == ''
      branch_name = 'not retreive'
    endif
  else
    branch_name = 'no fugitive'
  endif

  return branch_name
enddef


def FuncName(): string
  var func_name = ''

  if exists_compiled('*cfi#format')
    func_name = cfi#format('%s()', '')
    if func_name == ''
      func_name = '[--]'
    endif
  else
    func_name = 'no cfi'
  endif

  return func_name
enddef


def g:Statusline(): string
  const winid = g:statusline_winid
  const bufnr = winbufnr(winid)
  const bufname = bufname(bufnr)
  const nonamebuf = (bufname == '')

  # ウィンドウローカルオプションの値を取得するための関数
  const W = function('getwinvar', [winid])

  # バッファローカルオプションの値を取得するための関数
  const B = function('getbufvar', [bufnr])

  const filetype = B('&filetype')


  const gold = IsGold()
  const contents_switch = StatuslineContentsSwitch


  # 返り値(statuslineの値となる)
  var stl = ""


  #------------------------------------------------- {{{
  if contents_switch['Winnr']
    #stl ..= "  %#SLFileName#"
    stl ..= " [ " .. win_id2win(winid) .. " ] "

    if gold
      stl ..= "%#VertSplit2#"
    else
      stl ..= "%#SLFileName#"
      #stl ..= "%##"
    endif
    stl ..= " ( %n ) "
  else
    stl ..= " [ %n ] "
  endif
  #------------------------------------------------- }}}


  #------------------------------------------------- {{{
  if contents_switch['Winnr']
    if gold
      stl ..= "%##"
    else
      stl ..= "%#VertSplit2#"
      stl ..= "%#SLFileName#"
    endif
  else
    stl ..= "%#SLFileName#"
  endif

  stl ..= "%h%w"

  if gold
    stl ..= "%#VertSplit2#"
  elseif contents_switch['Winnr']
    stl ..= "%##"
  else
    stl ..= "%#SLFileName#%##"
  endif

  stl ..= "%m%r" .. (Autoread(bufnr) ? '[AR]' : '')
  #------------------------------------------------- }}}


  #------------------------------------------------- {{{
  stl ..= "%#hl_func_name_stl#"

  if bufname =~ '^fugitive' || filetype == 'fugitive'
    const StlFugitive = contents_switch['Branch'] ? ' [fugitive]' : ' fugitive'
    stl ..= StlFugitive
  endif

  if contents_switch['Branch'] && filetype != 'netrw'   #  bufname != 'NetrwTreeListing' && bufname !~ '^NERD_tree'
      stl ..= ' [' .. BranchName(bufnr) .. '] '
  endif
  #------------------------------------------------- }}}


  #------------------------------------------------- {{{
  if contents_switch['Path']
    stl ..= "%#SLFileName#"
    #stl ..= "%##"

    stl ..= "%<"
    stl ..= " %F "
  else
    if gold
      if contents_switch['Winnr']
        stl ..= "%##"
        stl ..= "  %t  "
      else
        stl ..= "%#VertSplit2#"
        stl ..= " %t "
      endif
    else
      if contents_switch['Winnr']
        stl ..= "%##"
        stl ..= " %t "
      else
        stl ..= "%#SLFileName#"
        stl ..= "  %t  "
      endif
    endif

    stl ..= "%<"

    if contents_switch['ShadowDir'] && !nonamebuf
      stl ..= "%#SLNoNameDir#  "
      stl ..= bufname -> fnamemodify(':p:h')
    endif
  endif

  if (contents_switch['Path'] || contents_switch['ShadowDir'] || contents_switch['NoNameBufPath']) && nonamebuf
    # 無名バッファなら、cwdを常に表示。
    stl ..= "%#SLNoNameDir# "
    stl ..= getcwd(winid)
  endif
  #------------------------------------------------- }}}


  #------------------------------------------------- {{{
  if contents_switch['FuncName']
    stl ..= "%#hl_func_name_stl# "
    stl ..= "%#TabLine#"
    stl ..= " %{ cfi#format('%s()', '[--]') }"    #stl ..= " %{ FuncName() }"
  endif
  #------------------------------------------------- }}}


  #------------------------------------------------- {{{
  # ===== Separate Left Right =====
  stl ..= "%#SLFileName#  %="

  if contents_switch['KeywordChars']
    #stl ..= " ≪" .. B('&isk') .. "≫ "
    #stl ..= " ≪" .. B('&isk') -> substitute('\d\+-\d\+', '', 'g') -> substitute(',\+', ' ', 'g') .. "≫ "
    stl ..= " ≪" .. B('&isk') -> substitute('[^,]\zs,', ' ', 'g') -> substitute(',,', ', ', 'g') -> substitute('\d\+-\d\+,\?', '', 'g') .. "≫ "
  endif
  #------------------------------------------------- }}}


  #------------------------------------------------- {{{
  stl ..= "%##"
  const fenc = B('&fenc')
  const ff   = B('&ff')
  stl ..= printf(" %-5s  %-5s  %4s ",
    filetype == '' ? '@' : filetype,
    fenc == '' ? &enc : fenc,
    ff
  )
  #------------------------------------------------- }}}


  #------------------------------------------------- {{{
  stl ..= "%#SLFileName#"

  if contents_switch['Wrap']
    stl ..= " " .. (W('&wrap') ? '  ' : '>>') .. " "
  endif

  if contents_switch['TabStop']
    stl ..= " ⇒" .. B('&tabstop')
  endif

  # ===== Padding =====
  stl ..= "  " .. repeat(' ', winwidth(winid) - 178)
  #------------------------------------------------- }}}


  #------------------------------------------------- {{{
  stl ..= "%#SLFileName#"

  if contents_switch['WordLen']
    stl ..= " ≪%{" .. "len(expand('<cword>'))" .. "}≫"
  endif

  if contents_switch['CharCode']
    stl ..= " %10(《%(0x%B%)》%)"
  endif

  if contents_switch['CharCode10']
    stl ..= " %10(《%(%b%)》%)"
  endif
  #------------------------------------------------- }}}


  #------------------------------------------------- {{{
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
  stl ..= "%##"

  if contents_switch['Line']
    stl ..= " %4l:L"
  endif

  stl ..= printf(" %3d:c", getcursorcharpos()[2])
  stl ..= " %3v:v"

  if contents_switch['ColumnBytes']
    stl ..= " %3c:b"
  endif

  stl ..= " "
  #------------------------------------------------- }}}

  return stl
enddef


set laststatus=2
set statusline=%!Statusline()
