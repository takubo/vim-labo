vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8



finish


# => unified_tab.vim


# Quickfix & Locationlist {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

let c_jk_local = 0

nnoremap <silent> <Plug>(MyVimrc-Toggle-Qf-Ll) :<C-u>let c_jk_local = !c_jk_local<CR>

#例外をキャッチしないと、最初と最後の要素の次に移動しようとして例外で落ちる。
nnoremap <silent> <Plug>(MyVimrc-CNext) :<C-u>try <Bar> exe (c_jk_local ? ':lnext' : 'cnext') <Bar> catch <Bar> endtry<CR>:FuncNameStl<CR>
nnoremap <silent> <Plug>(MyVimrc-CPrev) :<C-u>try <Bar> exe (c_jk_local ? ':lprev' : 'cprev') <Bar> catch <Bar> endtry<CR>:FuncNameStl<CR>

#例外をキャッチしないと、最初と最後の要素の次に移動しようとして例外で落ちる。
nnoremap <silent> <Plug>(MyVimrc-QfNext) :<C-u>try <Bar> cnext <Bar> catch <Bar> endtry<CR>:FuncNameStl<CR>
nnoremap <silent> <Plug>(MyVimrc-QfPrev) :<C-u>try <Bar> cprev <Bar> catch <Bar> endtry<CR>:FuncNameStl<CR>

#例外をキャッチしないと、最初と最後の要素の次に移動しようとして例外で落ちる。
nnoremap <silent> <Plug>(MyVimrc-LlNext) :<C-u>try <Bar> lnext <Bar> catch <Bar> endtry<CR>:FuncNameStl<CR>
nnoremap <silent> <Plug>(MyVimrc-LlPrev) :<C-u>try <Bar> lprev <Bar> catch <Bar> endtry<CR>:FuncNameStl<CR>

nmap <silent> <Del> <Plug>(MyVimrc-QfNext)
nmap <silent> <Ins> <Plug>(MyVimrc-QfPrev)
#nmap <silent> <A-n> <Plug>(MyVimrc-LlNext)
#nmap <silent> <A-m> <Plug>(MyVimrc-LlPrev)

# Quickfix & Locationlist }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}



# #----------------------------------------------------------------------------------
# # Quickfix cd Project-Root
#
# import autoload '../impauto/GetPrjRoot.vim' as gpr
#
# # Quickfixウィンドウを、指定のディレクトリをカレントディレクトリとして開き直す。
# def QfChdir(dir: string)
#   cclose
#
#   const save_autochdir = &autochdir
#   set noautochdir
#
#   const org_dir = getcwd()
#   exe 'noautocmd cd ' dir
#
#   copen
#   exe 'noautocmd cd' org_dir
#
#   &autochdir = save_autochdir
# enddef
#
# # Quickfixウィンドウを、プロジェクトルートをカレントディレクトリとして開き直す。
# com! QfChdirPrjRoot call QfChdir(gpr.GetPrjRoot())
#
# #----------------------------------------------------------------------------------



# #----------------------------------------------------------------------------------
# augroup MyVimrc_Grep
#   au!
#   exe 'au WinEnter * if (&buftype == 'quickfix') | cd ' .. getcwd() .. ' | endif'
# augroup end
# #----------------------------------------------------------------------------------
