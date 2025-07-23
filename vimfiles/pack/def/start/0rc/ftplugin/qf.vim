vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8


if exists("b:did_ftplugin")
  #finish
endif

# Don't load another plugin for this buffer
b:did_ftplugin = 1



if exists("b:did_my_ftplugin")
  #finish
endif

# Don't load another plugin for this buffer
b:did_my_ftplugin = 1



#---------------------------------------------------------------------------------------------
# QuickFix or LocationList

# QuickFixならtrue, LocationListならfalse
b:QuickFix = (getloclist(winnr(), {'winid': 0}).winid == 0)



#---------------------------------------------------------------------------------------------
# Options

setl norelativenumber



#---------------------------------------------------------------------------------------------
# Statusline

def g:QfStl(): string
  const GetList = getloclist(g:statusline_winid, {'winid': 0}).winid == 0 ?
                  function('getqflist') :
                  function('getloclist', [g:statusline_winid])

  # Obtain Quick Fix Properties
  const prop = GetList({'all': 0})

  var stl = ''

  # Title
  # Display the command that produced the list in the quickfix window:
  const title = prop.title
                -> substitute('^:git grep --line-number --no-color -I', ':git grep ', '')
                -> substitute(' -- :!..svn/ :!tags$', '', '')
  stl ..= " %t "
  stl ..= "%#StlGoldChar#"
  stl ..= " [ " .. title .. " ] "
  #       " %{exists('w:quickfix_title')? w:quickfix_title : ''} "

  # Separator
  stl ..= "%#StlGoldChar#%="

  # Selected QfList
  const stack_max = GetList(         {'nr': '$'}).nr
  #stl ..= '%#StlGoldChar#'
  #stl ..= "%#StlGoldLeaf#"
  stl ..= '%##'
  stl ..= '《list:%2(' .. (stack_max - prop.nr + 1) .. '%)/' .. stack_max .. '》'

  # QfList Number of Change
  #stl ..= ' changed:' .. prop.changedtick .. ' '

  # QfList Change
  stl ..= ' changed:' .. (prop.changedtick != 2 ? '+' : '*') .. ' '

  # Entry
  #   Current Select Entry Number
  #   Total Number of Entry
  #   Current Select Entry Percent
  const entry_cur = prop.idx
  const entry_max = prop.size
  const entry_percent = prop.idx * 100.0 / prop.size
  stl ..= "%#StlGoldChar#"
  stl ..= ' Ent:%3(' .. entry_cur .. '%) / %(' .. entry_max .. '%)'
  stl ..= ' %8((' .. printf('%.1f', entry_percent) .. '%%)%) '

  # Separator
  stl ..= '%<'

  # Saved Directory
  stl ..= '%#StlNoNameDir# '
  stl ..= prop.context .. '  '

  # Current Directory
  #stl ..= '%#StlNoNameDir# ' .. getcwd() .. ' '

  # Separator
  stl ..= "%#StlGoldChar#%="

  # Line-percnt Screen-percnt Total-lines
  stl ..= "%##"
  stl ..= " %3p%% %4P [%4L] "

  return stl
enddef


setlocal stl=%!QfStl()



#---------------------------------------------------------------------------------------------
# View

nnoremap <buffer>      <CR> <Esc>:call <SID>CR()<CR>
nnoremap <buffer> <C-W><CR> <Esc>:call <SID>CR()<CR>

def CR()
  if v:prevcount != 0
    # jumplistに残すために、Gを使用。
    histadd('cmd', v:prevcount .. '')
    exe 'normal!' v:prevcount .. 'G'
  else
    exe "normal! \<CR>"
  endif
  CursorJumped
enddef



#---------------------------------------------------------------------------------------------
# Continueouse Move

#nnoremap <buffer> p <CR>zz<C-W>p
#nnoremap <buffer> p <CR>zz<cmd>noautocmd wincmd p<CR><Cmd>set cursorline<CR>
#nnoremap <buffer> P <CR>zz<C-W>pj
#nnoremap <buffer> o <CR>zz<C-W>pj
#nnoremap <buffer> O <CR>zz<C-W>pk
#nnoremap <buffer> o <CR>zz<cmd>noautocmd wincmd p<CR>j


nnoremap <buffer> r   <CR>zz<Cmd>CFIPopupNMV<CR><Cmd>noautocmd wincmd p<CR><Cmd>set cursorline<CR>

#nnoremap <buffer> p   <Cmd>call QfJump(+1)<CR>zz<Cmd>CFIPopupNMV<CR><Cmd>noautocmd wincmd p<CR><Cmd>set cursorline<CR>
#nnoremap <buffer> P   <Cmd>call QfJump(-1)<CR>zz<Cmd>CFIPopupNMV<CR><Cmd>noautocmd wincmd p<CR><Cmd>set cursorline<CR>
if b:QuickFix
  nnoremap <buffer> p   <Cmd>cnext<CR>zz<Cmd>CFIPopupNMV<CR><Cmd>noautocmd wincmd p<CR><Cmd>set cursorline<CR>
  nnoremap <buffer> P   <Cmd>cprev<CR>zz<Cmd>CFIPopupNMV<CR><Cmd>noautocmd wincmd p<CR><Cmd>set cursorline<CR>
else
  nnoremap <buffer> p   <Cmd>lnext<CR>zz<Cmd>CFIPopupNMV<CR><Cmd>noautocmd wincmd p<CR><Cmd>set cursorline<CR>
  nnoremap <buffer> P   <Cmd>lprev<CR>zz<Cmd>CFIPopupNMV<CR><Cmd>noautocmd wincmd p<CR><Cmd>set cursorline<CR>
endif

nnoremap <buffer> o   <CR>zz<Cmd>CFIPopupNMV<CR><Cmd>noautocmd wincmd p<CR><Cmd>set cursorline<CR>j
nnoremap <buffer> O   <CR>zz<Cmd>CFIPopupNMV<CR><Cmd>noautocmd wincmd p<CR><Cmd>set cursorline<CR>k

nnoremap <buffer> i gg<CR>zz<Cmd>CFIPopupNMV<CR><Cmd>noautocmd wincmd p<CR><Cmd>set cursorline<CR>
nnoremap <buffer> a  G<CR>zz<Cmd>CFIPopupNMV<CR><Cmd>noautocmd wincmd p<CR><Cmd>set cursorline<CR>

if !exists(':CFIPopupNMV')
  com! -bar CFIPopupNMV echon
endif



#---------------------------------------------------------------------------------------------
# History Stack

if b:QuickFix
  nnoremap <buffer> >> <Cmd>exe 'cnewer' v:count1<CR>
  nnoremap <buffer> << <Cmd>exe 'colder' v:count1<CR>
  nnoremap <buffer> == <Cmd>exe 'cnewer' getqflist({'nr': '$'}).nr - getqflist({'nr': 0}).nr<CR>
  nnoremap <buffer> s  <Cmd>exe 'cnewer' getqflist({'nr': '$'}).nr - getqflist({'nr': 0}).nr<CR>
  nnoremap <buffer> m  <Cmd>chistory<CR>:<C-U>chistory<Space>
  nnoremap <buffer> R  <Cmd>chistory<CR>:<C-U>chistory<Space>
else
  nnoremap <buffer> >> <Cmd>exe 'lnewer' v:count1<CR>
  nnoremap <buffer> << <Cmd>exe 'lolder' v:count1<CR>
  nnoremap <buffer> == <Cmd>exe 'lnewer' getloclist(winnr(), {'nr': '$'}).nr - getloclist(winnr(), {'nr': 0}).nr<CR>
  nnoremap <buffer> s  <Cmd>exe 'lnewer' getloclist(winnr(), {'nr': '$'}).nr - getloclist(winnr(), {'nr': 0}).nr<CR>
  nnoremap <buffer> m  <Cmd>lhistory<CR>:<C-U>lhistory<Space>
  nnoremap <buffer> R  <Cmd>lhistory<CR>:<C-U>lhistory<Space>
endif



#---------------------------------------------------------------------------------------------
# Edit

nnoremap <buffer> dd <Plug>(QuickfixEdit-Delelte)
nnoremap <buffer>  x <Plug>(QuickfixEdit-Delelte)

vnoremap <buffer>  d <Plug>(QuickfixEdit-Delelte-Visual)
vnoremap <buffer>  x <Plug>(QuickfixEdit-Delelte-Visual)

nnoremap <buffer>  u <Plug>(QuickfixEdit-Undo)



#---------------------------------------------------------------------------------------------
# Auto Change Directory

#augroup Qf_AutoChDir
#exe 'augroup Qf_AutoChDir_' .. bufnr()
const augroup_name = 'Qf_AutoChDir_' .. bufnr()

exe 'augroup' augroup_name
  au!

  exe 'au!' augroup_name

  au WinEnter <buffer> if getloclist(winnr(), {'winid': 0}).winid == 0
  # QuickFix
    # copenなどで、再度開いたとき用。
    # DelEntry, UndoEntryも、これで対応。
    au WinEnter <buffer> chdir(getqflist({'context': 0}).context)
  au WinEnter <buffer> else
  # LocationList
    # lopenなどで、再度開いたとき用。
    # DelEntry, UndoEntryも、これで対応。
    au WinEnter <buffer> chdir(getloclist(winnr(), {'context': 0}).context)
  au WinEnter <buffer> endif

  au BufWinEnter <buffer> if getloclist(winnr(), {'winid': 0}).winid == 0
  # QuickFix
    # QuickfixCmdを実行したディレクトリとは別のディレクトリで、copenを実行した時用。
    au BufWinEnter <buffer> if getqflist({'context': 0}).context != ''
    au BufWinEnter <buffer>   chdir(getqflist({'context': 0}).context)
    au BufWinEnter <buffer>   au SafeState <buffer> ++once copen
    au BufWinEnter <buffer> endif
  au BufWinEnter <buffer> else
  # LocationList
    # QuickfixCmdを実行したディレクトリとは別のディレクトリで、lopenを実行した時用。
    #
    # LocationListウィンドウが開いている状態で、LocationListコマンドを実行したときに、
    # この中が発動しないように、if文で囲んでいる。QuickfixCmdPostより、BufWinEnterの方が先に発動するため、その必要がある。
    au BufWinEnter <buffer> if getloclist(winnr(), {'context': 0}).context != ''
    au BufWinEnter <buffer>   chdir(getloclist(winnr(), {'context': 0}).context)
    au BufWinEnter <buffer>   au SafeState <buffer> ++once lopen
    au BufWinEnter <buffer> endif
  au BufWinEnter <buffer> endif
augroup end
