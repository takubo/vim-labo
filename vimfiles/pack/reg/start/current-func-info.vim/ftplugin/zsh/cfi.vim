" vim:foldmethod=marker:fen:
scriptencoding utf-8

runtime! ftplugin/sh/cfi.vim
call cfi#register_simple_finder('zsh', cfi#get_finder('sh'))
