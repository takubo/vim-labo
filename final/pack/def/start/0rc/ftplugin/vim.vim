vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8


import autoload "popup_info.vim" as pui


def VimSaveAndExe(force: bool = false)
  if bufname('') == ''
    pwd
    return
  endif

  if !&readonly
    update
  endif

  if (!&readonly || force) && &l:filetype == 'vim'
    const dir = expand('%') -> fnamemodify(':p:h')

    if dir -> match('[/\\]colors$') >= 0
      exe 'colorscheme' expand('%:r')
      # PopUpInfo ColorScheme!!
      pui.PopUpInfo('ColorScheme!!', 2500)
    elseif dir -> match('[/\\]ftplugin$') == -1 || expand('%') == 'vim.vim'
    # ftpluginなら、実行しない。
      exe 'source' expand('%')
      # PopUpInfo Source!!
      pui.PopUpInfo('Source!!', 2500)
    else
      # PopUpInfo None!!
      pui.PopUpInfo('Source!!', 2500)
    endif

    #PopUpInfo Execute!!
  endif
enddef

#nnoremap <buffer> <Leader>e <ScriptCmd>VimSaveAndExe()<CR><Cmd>echohl ModeMsg<Bar>echo 'source!'<Bar>echohl None<CR>

nnoremap <buffer> <Leader>e <ScriptCmd>VimSaveAndExe(false)<CR>
nnoremap <buffer> <Leader>E <ScriptCmd>VimSaveAndExe( true)<CR>


#+++++ vtags ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##!/bin/sh
#
#cd ~/vimfiles/
#
#ctags -R && ctags -a --langmap=Vim:+.vimrc --langmap=Vim:+.gvimrc .vimrc .gvimrc
