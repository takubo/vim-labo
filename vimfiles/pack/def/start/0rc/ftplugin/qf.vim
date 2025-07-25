vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8



if exists('b:did_my_ftplugin')
  finish
endif

# Don't re-load this file for this buffer
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

def g:QuickfixStl(): string
  const GetListFunc = getloclist(g:statusline_winid, {'winid': 0}).winid == 0 ?
                      function('getqflist') :
                      function('getloclist', [g:statusline_winid])

  # Obtain Quick Fix Properties
  const prop = GetListFunc({'all': 0})

  var stl = ''


  # Title
  const title = prop.title
                -> substitute('^:git grep --line-number --no-color -I', ':git grep ', '')
                -> substitute(' -- :!..svn/ :!tags$', '', '')
  # Selected QfList (Stack)
  const stack_max = GetListFunc({'nr': '$'}).nr
  stl ..= ' %t'
  stl ..= ' 《%2(' .. (stack_max - prop.nr + 1) .. '%)/' .. stack_max .. '》'
  stl ..= '%#StlGoldChar#'
  stl ..= ' ' .. title .. ' '


  # QfList Number of Change
  stl ..= '%##'
  stl ..= ' changed:' .. prop.changedtick .. ' '

  # QfList Is Change
  #stl ..= ' changed:' .. (prop.changedtick != 2 ? '+' : '*') .. ' '


  # Entry
  #   Current Select Entry Number
  #   Total Number of Entry
  #   Current Select Entry Percent
  const entry_cur = prop.idx
  const entry_max = prop.size
  const entry_percent = prop.idx * 100.0 / prop.size
  stl ..= '%#StlGoldChar#'
  stl ..= ' Ent:%3(' .. entry_cur .. '%) / %(' .. entry_max .. '%)'
  stl ..= ' %8((' .. printf('%.1f', entry_percent) .. '%%)%) '


  # Truncate
  stl ..= '%<'


  # Saved Directory
  stl ..= '%#StlNoNameDir# '
  stl ..= prop.context .. '  '


  # Current Directory
  #stl ..= '%#StlNoNameDir# ' .. getcwd() .. ' '


  # Separator
  stl ..= '%#StlGoldChar#%='


  # Line-percnt Screen-percnt Total-lines
  stl ..= '%##'
  stl ..= ' %3p%% %4P [%4L] '


  return stl
enddef


setlocal stl=%!QuickfixStl()



#---------------------------------------------------------------------------------------------
# Key Mapping


#--------------------------------------------
# View

def g:Qf_Unified_CR()
  if v:prevcount != 0
    # jumplistに残すために、Gを使用。
    histadd('cmd', v:prevcount .. '')
    exe 'normal!' v:prevcount .. 'G'
  else
    exe "normal! \<CR>"
    CursorJumped
  endif
enddef

nnoremap <buffer>      <CR> <Esc>:call g:Qf_Unified_CR()<CR>
nnoremap <buffer> <C-W><CR> <Esc>:call g:Qf_Unified_CR()<CR>

#nnoremap <buffer>      <CR> <Cmd>if<Bar>v:count != 0 ? g:GotoLine(v:count)<Bar>else<Bar>execute(["normal! <Lt>CR>", 'CursorJumped'])<Bar>endif<CR>
#nnoremap <buffer> <C-W><CR> <Cmd>if<Bar>v:count != 0 ? g:GotoLine(v:count)<Bar>else<Bar>execute(["normal! <Lt>CR>", 'CursorJumped'])<Bar>endif<CR>

#nnoremap <buffer>      <CR> <Cmd>v:count != 0 ? g:GotoLine(v:count) : execute(["normal! <Lt>CR>", 'CursorJumped'])<CR>
#nnoremap <buffer> <C-W><CR> <Cmd>v:count != 0 ? g:GotoLine(v:count) : execute(["normal! <Lt>CR>", 'CursorJumped'])<CR>


#--------------------------------------------
# Consecutive View (Preview)

# noautocmdを付けないと、飛び先のcursorlineが(WinLabelで)Offされるので、どの行へジャンプしたのかがわからなくなる。
# noautocmdの影響で、Quickfixウィンドウのcursorlineが(WinEnterで)付かないので、別途付けている。
# noautocmdを付けなくていいなら、↓でよい、
# nnoremap <buffer> p <CR>zz<C-W>p

nnoremap <buffer> r             <CR>zz<Cmd>CFIPopupNMV<CR><Cmd>noautocmd wincmd p<CR><Cmd>set cursorline<CR>

#nnoremap <buffer> p <Cmd>call QfJump(+1)<CR>zz<Cmd>CFIPopupNMV<CR><Cmd>noautocmd wincmd p<CR><Cmd>set cursorline<CR>
#nnoremap <buffer> P <Cmd>call QfJump(-1)<CR>zz<Cmd>CFIPopupNMV<CR><Cmd>noautocmd wincmd p<CR><Cmd>set cursorline<CR>
if b:QuickFix
  nnoremap <buffer> p <Cmd>cnext<CR>zz<Cmd>CFIPopupNMV<CR><Cmd>noautocmd wincmd p<CR><Cmd>set cursorline<CR>
  nnoremap <buffer> P <Cmd>cprev<CR>zz<Cmd>CFIPopupNMV<CR><Cmd>noautocmd wincmd p<CR><Cmd>set cursorline<CR>
else
  nnoremap <buffer> p <Cmd>lnext<CR>zz<Cmd>CFIPopupNMV<CR><Cmd>noautocmd wincmd p<CR><Cmd>set cursorline<CR>
  nnoremap <buffer> P <Cmd>lprev<CR>zz<Cmd>CFIPopupNMV<CR><Cmd>noautocmd wincmd p<CR><Cmd>set cursorline<CR>
endif

nnoremap <buffer> o             <CR>zz<Cmd>CFIPopupNMV<CR><Cmd>noautocmd wincmd p<CR><Cmd>set cursorline<CR>j
nnoremap <buffer> O             <CR>zz<Cmd>CFIPopupNMV<CR><Cmd>noautocmd wincmd p<CR><Cmd>set cursorline<CR>k

nnoremap <buffer> i           gg<CR>zz<Cmd>CFIPopupNMV<CR><Cmd>noautocmd wincmd p<CR><Cmd>set cursorline<CR>
nnoremap <buffer> a            G<CR>zz<Cmd>CFIPopupNMV<CR><Cmd>noautocmd wincmd p<CR><Cmd>set cursorline<CR>


if !exists(':CFIPopupNMV')
  com! -bar CFIPopupNMV echon
endif


#--------------------------------------------
# History Stack

if b:QuickFix
  nnoremap <buffer> >> <Cmd>silent exe 'cnewer' v:count1<CR>
  nnoremap <buffer> << <Cmd>silent exe 'colder' v:count1<CR>
  nnoremap <buffer> == <Cmd>silent exe 'chistory' getqflist({'nr': '$'}).nr<CR>
  nnoremap <buffer> S  <Cmd>chistory<CR>:<C-U>chistory<Space>
else
  nnoremap <buffer> >> <Cmd>silent exe 'lnewer' v:count1<CR>
  nnoremap <buffer> << <Cmd>silent exe 'lolder' v:count1<CR>
  nnoremap <buffer> == <Cmd>silent exe 'lhistory' getloclist(winnr(), {'nr': '$'}).nr<CR>
  nnoremap <buffer> S  <Cmd>lhistory<CR>:<C-U>lhistory<Space>
endif
nmap <buffer> <C-A> >>
nmap <buffer> <C-X> <<
nmap <buffer> <C-S> ==


#--------------------------------------------
# Edit

nnoremap <buffer> dd <Plug>(QuickfixEdit-Delelte)
nnoremap <buffer>  x <Plug>(QuickfixEdit-Delelte)

vnoremap <buffer>  d <Plug>(QuickfixEdit-Delelte-Visual)
vnoremap <buffer>  x <Plug>(QuickfixEdit-Delelte-Visual)

nnoremap <buffer>  u <Plug>(QuickfixEdit-Undo)



#---------------------------------------------------------------------------------------------
# Auto Change Directory

augroup QuickFix_AutoChDir_RestoreCwd
  if b:QuickFix
    # QuickFix
    #   copenなどで、再度開いたとき用。
    #   DelEntry, UndoEntryも、これで対応。
    au WinEnter <buffer> getqflist({'context': 0}).context -> chdir()
  else
    # LocationList
    #   lopenなどで、再度開いたとき用。
    #   DelEntry, UndoEntryも、これで対応。
    au WinEnter <buffer> getloclist(winnr(), {'context': 0}).context -> chdir()
  endif

  if b:QuickFix
    # QuickFix
    #   QuickfixCmdを実行したディレクトリとは別のディレクトリで、copenを実行した時用。
    au BufWinEnter <buffer> if getqflist({'context': 0}).context != ''
    au BufWinEnter <buffer>   getqflist({'context': 0}).context -> chdir()
    au BufWinEnter <buffer>   au SafeState <buffer> ++once copen
    au BufWinEnter <buffer> endif
  else
    # LocationList
    #   QuickfixCmdを実行したディレクトリとは別のディレクトリで、lopenを実行した時用。
    #
    #   LocationListウィンドウが開いている状態で、LocationListコマンドを実行したときに、
    #   この中が発動しないように、if文で囲んでいる。QuickfixCmdPostより、BufWinEnterの方が先に発動するため、その必要がある。
    au BufWinEnter <buffer> if getloclist(winnr(), {'context': 0}).context != ''
    au BufWinEnter <buffer>   getloclist(winnr(), {'context': 0}).context -> chdir()
    au BufWinEnter <buffer>   au SafeState <buffer> ++once lopen
    au BufWinEnter <buffer> endif
  endif
augroup end
