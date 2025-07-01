vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8


#---------------------------------------------------------------------------------------------
# QuickFix
#---------------------------------------------------------------------------------------------



augroup QuickFix_AutoWinOpen
  au!
  # grepする際に'|cwindow'を付けなくても、Quickfixに結果を表示する
  au QuickfixCmdPost make,grep,grepadd,vimgrep,helpgrep,cbuffer,cfile exe 'botright cwindow ' .. (&lines / 4)
  au QuickfixCmdPost lmake,lgrep,lgrepadd,lvimgrep,lhelpgrep,lcbuffer,lcfile exe 'lwindow ' .. (winheight(0) / 4)
augroup end



#augroup QuickFix_AutoChDir
augroup QuickFix_AutoChDir_SaveCwd
  au!

  # QFコマンド実行時のcwdをcontextへ保存。
  au QuickfixCmdPost [^l]* setqflist([], 'r', {'context': getcwd()})
  au QuickfixCmdPost    l* setloclist(winnr(), [], 'r', {'context': getcwd()})
augroup end



# => unified_tab.vim



# #----------------------------------------------------------------------------------
# # Quickfix & Locationlist
#
# var c_jk_local = 0
#
# nnoremap <silent> <Plug>(QuickFix-Toggle-Qf-Ll) <Cmd>c_jk_local = !c_jk_local<CR>
#
# #例外をキャッチしないと、最初と最後の要素の次に移動しようとして例外で落ちる。
# nnoremap <silent> <Plug>(QuickFix-CNext) <Cmd>try <Bar> exe (c_jk_local ? ':lnext' : 'cnext') <Bar> catch <Bar> endtry<CR>:CursorJumped<CR>
# nnoremap <silent> <Plug>(QuickFix-CPrev) <Cmd>try <Bar> exe (c_jk_local ? ':lprev' : 'cprev') <Bar> catch <Bar> endtry<CR>:CursorJumped<CR>
#
# #例外をキャッチしないと、最初と最後の要素の次に移動しようとして例外で落ちる。
# nnoremap <silent> <Plug>(QuickFix-QfNext) <Cmd>try <Bar> cnext <Bar> catch <Bar> endtry<CR>:CursorJumped<CR>
# nnoremap <silent> <Plug>(QuickFix-QfPrev) <Cmd>try <Bar> cprev <Bar> catch <Bar> endtry<CR>:CursorJumped<CR>
#
# #例外をキャッチしないと、最初と最後の要素の次に移動しようとして例外で落ちる。
# nnoremap <silent> <Plug>(QuickFix-LlNext) <Cmd>try <Bar> lnext <Bar> catch <Bar> endtry<CR>:CursorJumped<CR>
# nnoremap <silent> <Plug>(QuickFix-LlPrev) <Cmd>try <Bar> lprev <Bar> catch <Bar> endtry<CR>:CursorJumped<CR>
#
# #nmap <silent> <Del> <Plug>(QuickFix-QfNext)
# #nmap <silent> <Ins> <Plug>(QuickFix-QfPrev)
# #nmap <silent> <A-n> <Plug>(QuickFix-LlNext)
# #nmap <silent> <A-m> <Plug>(QuickFix-LlPrev)



# #----------------------------------------------------------------------------------
# # Quickfix cd Project-Root
#
# import autoload '../impauto/GetPrjRoot.vim' as gpr
# import autoload 'get_project_root.vim' as gpr
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
