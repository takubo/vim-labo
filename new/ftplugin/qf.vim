vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8


if exists("b:did_ftplugin")
  # finish
endif

# Don't load another plugin for this buffer
b:did_ftplugin = 1

b:undo_ftplugin = "set stl<"



#---------------------------------------------------------------------------------------------
# Statusline

# Display the command that produced the list in the quickfix window:
#setlocal stl=%t%{exists('w:quickfix_title')?\ '\ '.w:quickfix_title\ :\ ''}\ %#StlFill#%=%##\ %-15(%3l,\ %3c%3V%)\ %P\ 
#let &l:stl = " %t %#StlGoldChar# [%{exists('w:quickfix_title')? w:quickfix_title : ''}] %#StlFill#%=%## %-15(%3l, %3c%3V%) %p%% %P [%4L] "

def g:QfStl(): string
  const prop = getqflist({'all': 0})

  var stl = ''

 #stl ..= " %t %#StlGoldChar# [%{exists('w:quickfix_title')? w:quickfix_title : ''}] "
  stl ..= " %t %#StlGoldChar# [ " .. prop.title .. " ] "

  stl ..= ' %7(cur:' .. prop.idx .. '%) '
  stl ..= ' %10(total:' .. prop.size .. '%) '

  stl ..= '%8((' .. printf('%.1f', prop.idx * 100.0 / prop.size) .. '%%)%) '

  stl ..= '%<'

  stl ..= ' changedtick:' .. prop.changedtick .. ' '

 #stl ..= ' 《stack:' .. prop.nr .. '》 '
 #stl ..= ' ' .. getqflist({'nr': '$'}).nr .. ' '
  const stack_max = getqflist({'nr': '$'}).nr
 #stl ..= ' 《stack:' .. prop.nr .. '/' .. stack_max .. '》 '
  stl ..= ' 《stack:' .. (stack_max - prop.nr + 1) .. '/' .. stack_max .. '》 '

  stl ..= '%#StlNoNameDir# ' .. getcwd() .. ' '

  stl ..= "%#StlGoldChar#%="
 #stl ..= "%## %-15(%3l, %3c%3V%) %3p%% %4P [%4L] "
  stl ..= "%#StlGoldChar# %-15(%3l, %3c%3V%) %## %3p%% %4P [%4L] "

  return stl
enddef

setlocal stl=%!QfStl()



#---------------------------------------------------------------------------------------------
# View
nnoremap <buffer>      <CR> <CR><Cmd>CursorJumped<CR>
nnoremap <buffer> <C-W><CR> <CR><Cmd>CursorJumped<CR>



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
nnoremap <buffer> p   <Cmd>cnext<CR>zz<Cmd>CFIPopupNMV<CR><Cmd>noautocmd wincmd p<CR><Cmd>set cursorline<CR>
nnoremap <buffer> P   <Cmd>cprev<CR>zz<Cmd>CFIPopupNMV<CR><Cmd>noautocmd wincmd p<CR><Cmd>set cursorline<CR>

nnoremap <buffer> o   <CR>zz<Cmd>CFIPopupNMV<CR><Cmd>noautocmd wincmd p<CR><Cmd>set cursorline<CR>j
nnoremap <buffer> O   <CR>zz<Cmd>CFIPopupNMV<CR><Cmd>noautocmd wincmd p<CR><Cmd>set cursorline<CR>k

nnoremap <buffer> i gg<CR>zz<Cmd>CFIPopupNMV<CR><Cmd>noautocmd wincmd p<CR><Cmd>set cursorline<CR>
nnoremap <buffer> a  G<CR>zz<Cmd>CFIPopupNMV<CR><Cmd>noautocmd wincmd p<CR><Cmd>set cursorline<CR>

if !exists(':CFIPopupNMV')
  com! -bar CFIPopupNMV echon
endif



#---------------------------------------------------------------------------------------------
# History Stack
# TODO LL未対応
nnoremap <buffer> >> <Cmd>exe 'cnewer' v:count1<CR>
nnoremap <buffer> << <Cmd>exe 'colder' v:count1<CR>
nnoremap <buffer> == <Cmd>exe 'cnewer' getqflist({'nr': '$'}).nr - getqflist({'nr': 0}).nr<CR>
nnoremap <buffer> s  <Cmd>exe 'cnewer' getqflist({'nr': '$'}).nr - getqflist({'nr': 0}).nr<CR>
nnoremap m <Cmd>chistory<CR>:<C-U>chistory<Space>
nnoremap R <Cmd>chistory<CR>:<C-U>chistory<Space>



#---------------------------------------------------------------------------------------------
# Edit

nnoremap <silent> <buffer> dd <ScriptCmd>Del_entry()<CR>
nnoremap <silent> <buffer>  x <ScriptCmd>Del_entry()<CR>

vnoremap <silent> <buffer>  d :call <SID>Del_entry()<CR>
vnoremap <silent> <buffer>  x :call <SID>Del_entry()<CR>

nnoremap <silent> <buffer>  u <ScriptCmd>Undo_entry()<CR>


function Del_entry() range
  let qf = getqflist()
  let history = get(w:, 'qf_history', [])
  call add(history, copy(qf))
  let w:qf_history = history
  unlet! qf[a:firstline - 1 : a:lastline - 1]
  " TODO noau がないと、FTloadが走る。
  "      function <SNR>82_del_entry[6]..FileType Autocommands for "*"..function <SNR>12_LoadFTPlugin[18]..script C:\Users\U351376\vimfiles\ftplugin\qf.vim の処理中にエラーが検出されました:
  "      行  121:
  " E127: 関数 <SNR>82_del_entry を再定義できません: 使用中です
  noau call setqflist(qf, 'r')
  execute a:firstline
endfunction


function Undo_entry()
  let history = get(w:, 'qf_history', [])
  if !empty(history)
    call setqflist(remove(history, -1), 'r')
  endif
endfunction
