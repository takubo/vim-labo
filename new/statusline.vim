vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8


#----------------------------------------------------------------------------------------
# Gold

var Gold = true

def IsGold(): bool
  return Gold
enddef

com! Gold Gold = !Gold


#----------------------------------------------------------------------------------------
# Switch Statusline Contents

var StatuslineContentsSwitch = {
  'Branch':        false,
  'BytesOfFile':   false,
  'CharCode':      true,
  'CharCode10':    false,
 #'Column':        true,
  'ColumnBytes':   false,
  'FuncName':      false,
  'KeywordChars':  true,
  'Line':          false,
  'LinePercent':   false,
  'NoNameBufPath': true,
  'ScreenPercent': true,
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
  redrawstatus!
}


#----------------------------------------------------------------------------------------
# Statusline

# vim9scriptでは、&autoreadの型がboolになるので、-1との比較ができない。
function AutoRead(bufnr)
  let l_autoread = getbufvar(a:bufnr, '&l:autoread')
  return (l_autoread == 1 || (l_autoread == -1 && &g:autoread != 0)) ? v:true : v:false
endfunction


# 現在のブランチ名を返す
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


# カーソル位置の関数名を返す
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


# 'Statusline'へ設定される関数
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


  # 返り値('statusline'の値となる)
  var stl = ""


  #------------------------------------------------- {{{
  # Window Number & Buffer Number
  if contents_switch['Winnr']
    stl ..= " [ " .. win_id2win(winid) .. " ] "

    if gold
      stl ..= "%#VertSplit2#"
    else
      stl ..= "%#SLFileName#"
    endif
    stl ..= " ( %n ) "
  else
    stl ..= " [ %n ] "
  endif
  #------------------------------------------------- }}}


  #------------------------------------------------- {{{
  # Buffer Information
  if contents_switch['Winnr']
    if gold
      stl ..= "%##"
    else
     #stl ..= "%#VertSplit2#"
      stl ..= "%#SLFileName#"
    endif
  else
    if gold
      stl ..= "%#TabLine#"
    else
      stl ..= "%#SLFileName#"
      stl ..= "%#TabLine#"
    endif
  endif

  stl ..= "%( %h%w %)"

  if gold
    stl ..= "%#VertSplit2#"
    stl ..= "%#TabLine#"
  elseif contents_switch['Winnr']
    stl ..= "%##"
  else
    stl ..= "%#SLFileName#%##"
  endif

 #stl ..= "%( %m%r %)" .. (AutoRead(bufnr) ? '[AR]' : '')
  stl ..= "%( %m%r%{'" .. (AutoRead(bufnr) ? '[AR]' : '') .. "'} %)"
 #stl ..= "%(%m%r%{'" .. (AutoRead(bufnr) ? '[AR]' : '') .. "'}%)"
  #------------------------------------------------- }}}


  #------------------------------------------------- {{{
  # Branch
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
  # Path
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
      stl ..= "%#VertSplit2#"
      stl ..= "%#TabLine#"      # ?? semi-gold
      stl ..= "%#SLFileName#"
      stl ..= "  %t  "
    endif
  endif

  stl ..= "%<"

  if contents_switch['ShadowDir'] && !nonamebuf
    stl ..= "%#SLNoNameDir#  "

    stl ..= bufname -> fnamemodify(':p:h')
  endif

  if (contents_switch['ShadowDir'] || contents_switch['NoNameBufPath']) && nonamebuf
    # 無名バッファなら、cwdを常に表示。
    stl ..= "%#SLNoNameDir# "

    stl ..= getcwd(winid)
  endif
  #------------------------------------------------- }}}


  #------------------------------------------------- {{{
  # Current Function Name
  if contents_switch['FuncName']
   #stl ..= "%#hl_func_name_stl#"
    stl ..= "%#TabLine#"

    stl ..= "  %{ cfi#format('%s()', '[--]') }"    #stl ..= " %{ FuncName() }"
  endif
  #------------------------------------------------- }}}


  #------------------------------------------------- {{{
  # ===== Separate Left Right =====
  if Gold
    stl ..= "%#TabLine#  %="
  else
    stl ..= "%#SLFileName#  %="
  endif
  #------------------------------------------------- }}}


  #------------------------------------------------- {{{
  # Keyword Characters
  if contents_switch['KeywordChars']
    stl ..= " ≪ " .. B('&isk') -> substitute('[^,]\zs,', ' ', 'g') -> substitute(',,', ', ', 'g') -> substitute('\d\+-\d\+,\?', '', 'g') .. "≫ "
  endif
  #------------------------------------------------- }}}


  #------------------------------------------------- {{{
  # Buffer Character Options
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
  # Buffer Local Options
  stl ..= "%#SLFileName#"

  if contents_switch['Wrap']
    stl ..= " " .. (W('&wrap') ? '  ' : '>>') .. " "
  endif

  if contents_switch['TabStop']
    stl ..= " ⇒" .. B('&tabstop')
  endif
  #------------------------------------------------- }}}


  #------------------------------------------------- {{{
  # ===== Padding =====
  stl ..= "  " .. repeat(' ', winwidth(winid) - 178)
  #------------------------------------------------- }}}


  #------------------------------------------------- {{{
  # Under Cursor Information
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
  # Overall Buffer
  if gold
    stl ..= "%#VertSplit2#"
  else
    stl ..= "%#SLFileName#"
  endif

  if contents_switch['LinePercent']
    stl ..= " %3p%%"
    stl ..= " %6([%L]%)"
  endif
  if contents_switch['ScreenPercent']
   #stl ..= " %6([%P]%)"
    stl ..= " %4P"
    stl ..= " %6([%L]%)"
   #stl ..= " %4( %L %)"
  endif


  if contents_switch['BytesOfFile']
    stl ..= " %6oBytes"
  endif

  stl ..= " "
  #------------------------------------------------- }}}


  #------------------------------------------------- {{{
  # Line & Column
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


#----------------------------------------------------------------------------------------
# Initialize Statusline

set laststatus=2
set statusline=%!Statusline()


#----------------------------------------------------------------------------------------
# 

nnoremap @ <Cmd>Stl Winnr<CR>
nnoremap , <Cmd>Gold<CR><Cmd>redrawstatus!<CR>
