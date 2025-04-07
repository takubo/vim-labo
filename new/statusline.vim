vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8



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
  'LinePercent':   true,
  'NoNameBufPath': true,
  'ScreenPercent': false,
  'ShadowDir':     false,
  'TabStop':       false,
  'Winnr':         false,
  'WordLen':       false,
  'Wrap':          true,
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


  #const gold = g:IsGold()
  const gold = !exists('g:RimpaGold') || g:RimpaGold


  const contents_switch = StatuslineContentsSwitch


  # 返り値('statusline'の値となる)
  var stl = ""


  #------------------------------------------------- {{{
  # Window Number & Buffer Number
  if contents_switch.Winnr
    stl ..= " [ " .. win_id2win(winid) .. " ] "

    if gold
      stl ..= "%#StlGoldLeaf#"
    else
      stl ..= "%#StlFill#"
    endif
    stl ..= " ( %n ) "
  else
    stl ..= " [ %n ] "
  endif
  #------------------------------------------------- }}}


  #------------------------------------------------- {{{
  # Buffer Information
  if contents_switch.Winnr
    if gold
      stl ..= "%##"
    else
     #stl ..= "%#StlGoldLeaf#"
      stl ..= "%#StlFill#"
    endif
  else
    if gold
      stl ..= "%#StlGoldChar#"
    else
      stl ..= "%#StlFill#"
      stl ..= "%#StlGoldChar#"
    endif
  endif

  stl ..= "%( %h%w %)"

  if gold
    stl ..= "%#StlGoldLeaf#"
    stl ..= "%#StlGoldChar#"
    stl ..= "%#StlGoldChar#"
  elseif contents_switch.Winnr
    stl ..= "%##"
    stl ..= "%#StlFill#"
    stl ..= "%#StlGoldLeaf#"
    stl ..= "%#StlGoldChar#"
  else
    stl ..= "%#StlFill#"
    stl ..= "%##"
    stl ..= "%#StlGoldLeaf#"
    stl ..= "%#StlGoldChar#"
  endif

 #stl ..= "%( %m%r %)" .. (AutoRead(bufnr) ? '[AR]' : '')
  stl ..= "%( %m%r%{'" .. (AutoRead(bufnr) ? '[AR]' : '') .. "'} %)"
 #stl ..= "%(%m%r%{'" .. (AutoRead(bufnr) ? '[AR]' : '') .. "'}%)"
  #------------------------------------------------- }}}


  #------------------------------------------------- {{{
  # Branch
  stl ..= "%#StlFuncName#"

  if bufname =~ '^fugitive' || filetype == 'fugitive'
    const StlFugitive = contents_switch.Branch ? ' [fugitive]' : ' fugitive'
    stl ..= StlFugitive
  endif

  if contents_switch.Branch && filetype != 'netrw'   #  bufname != 'NetrwTreeListing' && bufname !~ '^NERD_tree'
      stl ..= ' [' .. BranchName(bufnr) .. '] '
  endif
  #------------------------------------------------- }}}


  #------------------------------------------------- {{{
  # Path
  if gold
    if contents_switch.Winnr
      stl ..= "%##"
      #stl ..= "  %t  "
      stl ..= " %t "
    else
      stl ..= "%#StlGoldLeaf#"
      stl ..= " %t "
    endif
  else
    if contents_switch.Winnr
      stl ..= "%##"
      stl ..= " %t "
    else
      stl ..= "%#StlGoldLeaf#"
      stl ..= "%#StlGoldChar#"      # ?? semi-gold
      stl ..= "%#StlFill#"
      #stl ..= "  %t  "
      stl ..= " %t "
    endif
  endif

  stl ..= "%#StlGoldChar# %<"

  if contents_switch.ShadowDir && !nonamebuf
    stl ..= "%#StlNoNameDir#  "

    stl ..= bufname -> fnamemodify(':p:h')
  endif

  if (contents_switch.ShadowDir || contents_switch.NoNameBufPath) && nonamebuf
    # 無名バッファなら、cwdを常に表示。
    stl ..= "%#StlNoNameDir# "

    stl ..= getcwd(winid)
  endif
  #------------------------------------------------- }}}


  #------------------------------------------------- {{{
  # Current Function Name
  if contents_switch.FuncName
   #stl ..= "%#StlFuncName#"
    stl ..= "%#StlGoldChar#"

    stl ..= "  %{ cfi#format('%s()', '[--]') }"    #stl ..= " %{ FuncName() }"
  endif
  #------------------------------------------------- }}}


  #------------------------------------------------- {{{
  # ===== Separate Left Right =====
  if gold
    stl ..= "%#StlGoldChar#  %="
  else
    stl ..= "%#StlFill#  %="
  endif
  #------------------------------------------------- }}}


  #------------------------------------------------- {{{
  # Keyword Characters
  if contents_switch.KeywordChars
    #if 0
    #  stl ..= " ≪ " .. B('&isk') -> substitute('[^,]\zs,', ' ', 'g') -> substitute(',,', ', ', 'g') -> substitute('\d\+-\d\+,\?', '', 'g') .. "≫ "
    #else
    #  const kws = B('&isk') -> substitute('[^,]\zs,', ' ', 'g') -> substitute(',,', ', ', 'g') -> substitute('\d\+-\d\+,\?', '', 'g')
    #  const keyword_str = kws -> substitute('^ *', ' ', '') -> substitute(' *$', ' ', '')
    #  stl ..= " ≪" .. keyword_str .. "≫ "
    #endif
    const kwc = B('&isk') -> substitute('[^,]\zs,', ' ', 'g') -> substitute(',,', ', ', 'g') -> substitute('\d\+-\d\+,\?', '', 'g')
                -> substitute('^ *', ' ', '') -> substitute(' *$', ' ', '')
    stl ..= " ≪" .. kwc .. "≫ "
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
  stl ..= "%#StlFill#"
  stl ..= "%#StlGoldChar#"

  if contents_switch.Wrap
    stl ..= " " .. (W('&wrap') ? '  ' : '>>') .. " "
  endif

  stl ..= W('&scrollbind') ?  " $" : "  "

  if contents_switch.TabStop
    stl ..= " ⇒" .. B('&tabstop')
  endif
  #------------------------------------------------- }}}


  #------------------------------------------------- {{{
  # Under Cursor Information
  if winwidth(winid) > 120

    stl ..= "%#StlFill#"
    stl ..= "%#StlGoldChar#"
    stl ..= "%##"

    if contents_switch.WordLen
      stl ..= " ≪%{" .. "len(expand('<cword>'))" .. "}≫"
    endif

    if contents_switch.CharCode
      stl ..= " %10(《%(0x%B%)》%)"
    else
      stl ..= "%#StlGoldChar#" .. "           "
    endif

    if contents_switch.CharCode10
      stl ..= " %10(《%(%b%)》%)"
    else
      stl ..= "%#StlGoldChar#" .. "           "
    endif

  endif
  #------------------------------------------------- }}}


  #------------------------------------------------- {{{
  # ===== Padding =====
  stl ..= "  " .. repeat(' ', winwidth(winid) - 178)
  #------------------------------------------------- }}}


  #------------------------------------------------- {{{
  # Overall Buffer
  if gold
    stl ..= "%#StlGoldLeaf#"
  else
    stl ..= "%#StlFill#"
  endif

  if contents_switch.LinePercent
    stl ..= " %3p%%"
    stl ..= " %6([%L]%)"
  endif
  if contents_switch.ScreenPercent
   #stl ..= " %6([%P]%)"
    stl ..= " %4P"
    stl ..= " %6([%L]%)"
   #stl ..= " %4( %L %)"
  endif


  if contents_switch.BytesOfFile
    stl ..= " %6oBytes"
  endif

  stl ..= " "
  #------------------------------------------------- }}}


  #------------------------------------------------- {{{
  # Line & Column
  stl ..= "%##"

  if contents_switch.Line
    stl ..= " %4l:L"
  endif

  stl ..= printf(" %3d:c", getcursorcharpos()[2])
  stl ..= " %3v:v"

  if contents_switch.ColumnBytes
    stl ..= " %3c:b"
  endif

  stl ..= " "
  #------------------------------------------------- }}}

  return stl
enddef



#----------------------------------------------------------------------------------------
# Initialize

set laststatus=2
set statusline=%!Statusline()
