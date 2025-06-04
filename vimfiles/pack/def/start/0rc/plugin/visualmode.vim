vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 expandtab
scriptencoding utf-8


#----------------------------------------------------------------------------------------
# Reset Auto-Command

augroup MyVimrc_Visual
  au!
augroup end


#----------------------------------------------------------------------------------------
# Enter each Visual Mode

nnoremap v <C-V>

vnoremap <expr> v mode() !=# '<C-V>' ? '<C-V>' : 'v'
vnoremap <expr> V mode() !=# 'V'     ? 'V'     : ''


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

# 念のための削除処理と、グループの生成。
augroup MyVimrc_Visual_V
  au!
augroup end

def Visual_I()
  vunmap <buffer> i
  au MyVimrc_Visual_V CursorMoved * ++once vmap <buffer> <nowait> i <Cmd>call <SID>Visual_I()<CR>
  feedkeys(line('v') != line('.') ? 'I' : 'i')
enddef

def Visual_A() 
  unmap <buffer> a
  au MyVimrc_Visual_V CursorMoved * ++once vmap <buffer> <nowait> a <Cmd>call <SID>Visual_A()<CR>
  feedkeys(line('v') != line('.') ? 'A' : 'a')
enddef


#----------------------------------------------------------------------------------------
# Block Visual で、以下の挙動にする。
#     o  (小文字) : 対角
#     O  (大文字) : 横
#     ^O (Ctrl-O) : 縦

vnoremap <expr> <C-O> mode() == '<C-V>' ? 'Oo' : 'o'


#----------------------------------------------------------------------------------------
# zyと同じ動作を、zdやzcでも出来るようにする。

vnoremap zd zygv"_d
vnoremap zc zygv"_c

# 大文字で、押しやすくする。
vnoremap Y zy
vnoremap D zygv"_d
vnoremap C zygv"_c


# #----------------------------------------------------------------------------------------
# # TODO 行単位にする
# 
# vnoremap Y Vy
# vnoremap D Vd
# vnoremap C Vc


#----------------------------------------------------------------------------------------
# Virtual Edit

augroup MyVimrc_Visual
  # virtualeditが有効だと、タブ文字上を移動するのが面倒。
  au ModeChanged [^vV\x16]*:[\x16]* set virtualedit-=block
augroup end

# Visualモード中の、virtualedit=blockのためのトグル。
vnoremap . <Cmd>exe 'set virtualedit' .. (stridx(&virtualedit, 'block') < 0 ? '+=' : '-=') .. 'block'<CR>

# 行右端で、なお右に進もうとしたら、virtualeditにblockを追加して、何事もなかったかのように右へ移動する。
vnoremap <expr> l (mode() == '<C-V>' && !!search('\%#$', 'bcn') ? '<Cmd>set virtualedit+=block<CR>' : '') .. 'l'


#----------------------------------------------------------------------------------------
# Show Entering Visual Mode

import autoload "popup_info.vim" as pui

def ShowEnteringVisualMode()
  if state() =~# 'm'
    return
  endif

  const mode_msg = {
    'v':  'Visual Character',
    'V':  'Visual Line',
    '': 'Visual Block'
  }[v:event["new_mode"]]

  pui.PopUpInfo(mode_msg, 1000)
  echo 
enddef

augroup MyVimrc_ModeShow
  au!
  au ModeChanged *:[vV]* call ShowEnteringVisualMode()
augroup end
