vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8



#----------------------------------------------------------------------------------------
# 即時実行


import autoload "popup_info.vim" as pui


def VimSaveAndExe(force: bool = false)
  if bufname('') == ''
    pwd
  elseif !&readonly
    update
  endif

  if (!&readonly || force) && &l:filetype == 'vim'
    const dir = expand('%') -> fnamemodify(':p:h')

    if dir -> match('[/\\]colors$') >= 0
      exe 'colorscheme' expand('%:r')
      pui.PopUpInfo('ColorScheme!!', 2500)
    elseif dir -> match('[/\\]ftplugin$') == -1
      # ftpluginなら、実行しない。
      source
      pui.PopUpInfo('Source!!', 2500)
   #elseif dir -> match('[/\\]ftplugin$') >= 0 && expand('%') == 'vim.vim'
   #  # vimの場合、sourceすると、「実行中の関数を再定義しようとしている。」というエラーになる。
   #  setfiletype vim
   #  pui.PopUpInfo('SetFietype Vim!!', 2500)
    else
      pui.PopUpInfo('None!!', 2500)
    endif
  endif
enddef


nnoremap <buffer> <Leader>e <ScriptCmd>VimSaveAndExe(false)<CR>
nnoremap <buffer> <Leader>E <ScriptCmd>VimSaveAndExe( true)<CR>


xnoremap <buffer> <Leader>e :vim9cmd source<CR>
xnoremap <buffer> <Leader>E :source<CR>



#----------------------------------------------------------------------------------------
# タグファイル生成

#+++++ vtags ++++++++++++++++++++++++++++++++++++++++++
##!/bin/sh
#
#cd ~/vimfiles/
#
#ctags -R && ctags -a --langmap=Vim:+.vimrc --langmap=Vim:+.gvimrc .vimrc .gvimrc
