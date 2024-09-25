vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 expandtab
scriptencoding utf-8


augroup MyVimrc_Visual
  au!
augroup end


#----------------------------------------------------------------------------------------
# Enter each Visual Mode

nnoremap v <C-v>

# nr2char(22) は "<C-V>"
const Ctrl_V = nr2char(22)

vnoremap <expr> v mode() == 'v' ? Ctrl_V : 'v'
vnoremap <expr> v mode() == 'v' ? "\<C-V>" : 'v'
vnoremap <expr> v mode() == 'v' ? '<C-V>' : 'v'

#let s:Ctrl_v = function('nr2char', [22])
#vnoremap <expr> v mode() == 'v' ? <SID>Ctrl_v() : 'v'

#vnoremap <expr> v mode() == 'v' ? nr2char(22) : 'v'

vnoremap <expr> V mode() ==# 'V' ? '' : 'V'


#----------------------------------------------------------------------------------------
# Visual Block i, a

augroup MyVimrc_Visual
  # <buffer>と<nowait>により、各omapより優先させる。
  au ModeChanged *:[\x16]* vmap <buffer> <nowait> i <Cmd>call <SID>Visual_I()<CR>
  au ModeChanged *:[\x16]* vmap <buffer> <nowait> a <Cmd>call <SID>Visual_A()<CR>

  au ModeChanged [\x16]*:* if maparg('i', 'v') != ''| vunmap <buffer> i| endif
  au ModeChanged [\x16]*:* if maparg('a', 'v') != ''| vunmap <buffer> a| endif

  au ModeChanged [\x16]*:* au! MyVimrc_Visual_V
augroup end

# 念のための削除処理と、グループループの生成。
augroup MyVimrc_Visual_V
  au!
augroup end

def Visual_I()
  vunmap <buffer> i
  au MyVimrc_Visual_V CursorMoved * ++once vmap <buffer> <nowait> i <Cmd>call <SID>Visual_I()<CR>
  (line('v') != line('.') ? 'I' : 'i')->feedkeys()
enddef

def Visual_A() 
  unmap <buffer> a
  au MyVimrc_Visual_V CursorMoved * ++once vmap <buffer> <nowait> a <Cmd>call <SID>Visual_A()<CR>
  (line('v') != line('.') ? 'A' : 'a')->feedkeys()
enddef

### Test ###
vnoremap ia i(


##? nnoremap v <C-v>
##? 
##? augroup MyVimrc_Visual
##?   au!
##?   # <buffer>と<nowait>により、各omapより優先させる。
##?   au ModeChanged *:[vV\x16]* vmap <expr> <buffer> <nowait> i mode() == "\x16" ? '<Cmd>call g:Visual_I()<CR>' : 'i'
##?   au ModeChanged *:[vV\x16]* vmap <expr> <buffer> <nowait> a mode() == "\x16" ? '<Cmd>call g:Visual_A()<CR>' : 'a'
##? 
##?   au ModeChanged [vV\x16]*:[^vV\x16]* au! MyVimrc_Visual_V
##?   au ModeChanged [vV\x16]*:[^vV\x16]* au! MyVimrc_Visual_V
##? augroup end
##? 
##? augroup MyVimrc_Visual_V
##?   au!
##? augroup end
##? 
##? def g:Visual_I()
##?   vunmap <buffer> i
##?   au MyVimrc_Visual_V CursorMoved * ++once vmap <expr> <buffer> <nowait> i mode() == "\x16" ? '<Cmd>call g:Visual_I()<CR>' : 'i'
##?   call feedkeys(line('v') != line('.') ? 'I' : 'i')
##? enddef
##? 
##? def g:Visual_A() 
##?   unmap <buffer> a
##?   au MyVimrc_Visual_V CursorMoved * ++once vmap <expr> <buffer> <nowait> a mode() == "\x16" ? '<Cmd>call g:Visual_A()<CR>' : 'a'
##?   call feedkeys(line('v') != line('.') ? 'A' : 'a')
##? enddef
##? 
##? ### Test ###
##? vnoremap ia i(


##? nnoremap v <C-v>
##? 
##? augroup MyVimrc_Visual
##?   au!
##?   # <buffer>と<nowait>により、各omapより優先させる。
##?   au ModeChanged *:[vV\x16]* vmap <buffer> <nowait> i <Plug>(Visual-I)
##?   au ModeChanged *:[vV\x16]* vmap <buffer> <nowait> a <Plug>(Visual-A)
##? augroup end
##? 
##? vnoremap <Plug>(Visual-I) <Cmd>if mode() == "\x16" && line('v') != line('.')<Bar>vunmap <buffer> i<Bar>call feedkeys('I')<Bar>else<Bar>call feedkeys('i')<Bar>endif<CR>
##? vnoremap <Plug>(Visual-A) <Cmd>if mode() == "\x16" && line('v') != line('.')<Bar>vunmap <buffer> a<Bar>call feedkeys('A')<Bar>else<Bar>call feedkeys('a')<Bar>endif<CR>
##? 
##? #vmap <expr> <nowait> i (mode() == "\x16" && line('v') != line('.')) ? 'Ia' : 'Io'
##? #vmap <expr> <nowait> i (mode() == "\x16" && line('v') != line('.')) ? 'I' : 'i'
##? #vmap <expr>          i (mode() == "\x16" && line('v') != line('.')) ? 'I' : 'i'
##? 
##? ### Test ###
##? vnoremap ia i(


##? nnoremap v <C-v>
##? 
##? augroup MyVimrc_Visual
##?   au!
##?   # <buffer>と<nowait>により、各omapより優先させる。
##?   au ModeChanged *:[vV\x16]* vmap <expr> <buffer> <nowait> i mode() == "\x16" && line('v') != line('.') ? '<Plug>(Visual-I)' : 'i'
##?   au ModeChanged *:[vV\x16]* vmap <expr> <buffer> <nowait> a mode() == "\x16" && line('v') != line('.') ? '<Plug>(Visual-A)' : 'a'
##? augroup end
##? 
##? vnoremap <Plug>(Visual-I) <Cmd>vunmap <buffer> i<Bar>call feedkeys( ? 'I' : 'i', 'i')<CR>
##? vnoremap <Plug>(Visual-A) <Cmd>vunmap <buffer> a<Bar>call feedkeys( ? 'A' : 'a', 'i')<CR>
##? 
##? #vmap <expr> <nowait> i (mode() == "\x16" && line('v') != line('.')) ? 'Ia' : 'Io'
##? #vmap <expr> <nowait> i (mode() == "\x16" && line('v') != line('.')) ? 'I' : 'i'
##? #vmap <expr>          i (mode() == "\x16" && line('v') != line('.')) ? 'I' : 'i'
##? 
##? ### Test ###
##? vnoremap ia i(


#----------------------------------------------------------------------------------------
# Block Visual で、以下の挙動にする。
#   o  (小文字) : 対角
#   O  (大文字) : 横
#   ^O (Ctrl)   : 縦

vnoremap <expr> <C-O> mode() == '<C-V>' ? 'Oo' : 'o'


#----------------------------------------------------------------------------------------
# zyと同じ動作を、zdやzcでも出来るようにする。

vnoremap zd zygv"_d
vnoremap zc zygv"_c

#vnoremap Y zy
#vnoremap D zygv"_d
#vnoremap C zygv"_c


#----------------------------------------------------------------------------------------
# Virtual Edit

augroup MyVimrc_Visual
  # virtualeditが有効だと、タブ文字上を移動するのが面倒。
  au ModeChanged *:[vV\x16]* set virtualedit-=block
augroup end

vnoremap . <Cmd>exe 'set virtualedit' .. (stridx(&virtualedit, 'block') < 0 ? '+=' : '-=') ..'block'<CR>

# 行右端で、なお右に進もうとしたら、virtualeditにblockを追加して、何事もなかったかのように右へ移動する。
vnoremap <expr> l (&virtualedit !~# 'block' && !!search('\%#$', 'bcn')) ?
		\ ('<Cmd>set virtualedit+=block<CR>' .. 'l') : 'l'
