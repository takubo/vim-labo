vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8


#---------------------------------------------------------------------------------------------
# QuickFix
#---------------------------------------------------------------------------------------------



#---------------------------------------------------------------------------------------------
# Auto Window Open

augroup QuickFix_AutoWinOpen
  au!
  # grepする際に'|cwindow'を付けなくても、Quickfixに結果を表示する
  au QuickfixCmdPost [^l]* exe 'botright cwindow ' .. (&lines / 4)
  au QuickfixCmdPost    l* exe 'lwindow ' .. (winheight(0) / 4)
augroup end



#---------------------------------------------------------------------------------------------
# Auto Change Directory

#--------------------------------------------
# Save
augroup QuickFix_AutoChDir_SaveCwd
  au!
  # QFコマンド実行時のcwdをcontextへ保存。
  au QuickfixCmdPost [^l]* setqflist(          [], 'r', {'context': getcwd()})
  au QuickfixCmdPost    l* setloclist(winnr(), [], 'r', {'context': getcwd()})
augroup end

#--------------------------------------------
# Restore
augroup QuickFix_AutoChDir_RestoreCwd
  au!
  # => ftplugin/qf.vim
augroup end



#---------------------------------------------------------------------------------------------
# QuickFix Jump

# TODO cafter cbefore
def g:QfJump(dir_and_num: number, force_locationlist: bool = false)
  if !HaveLocationlist() && !force_locationlist
    # 例外をキャッチしないと、最初と最後の要素の次に移動しようとして例外で落ちる。
    try
      execute(':' .. abs(dir_and_num) .. (dir_and_num >= 0 ?  'cnext' : 'cprev'))
      CursorJumped
    catch /:E553/
      # echo dir_and_num >= 0 ?  'Last error list.' : '1st error list.'
    endtry

    QfNumPopupAdd
    # echo 'QuickFix Jump'
  else
    # 例外をキャッチしないと、最初と最後の要素の次に移動しようとして例外で落ちる。
    try
      execute(':' .. abs(dir_and_num) .. (dir_and_num >= 0 ?  'lnext' : 'lprev'))
      CursorJumped
    catch /:E553/
      # echo dir_and_num >= 0 ?  'Last location list.' : '1st location list.'
    endtry

    LlNumPopupAdd
    # echo 'LocationList Jump'
  endif
enddef



#---------------------------------------------------------------------------------------------
# QuickFix Utility Functions

# LocationListを持っているか、否か。
def HaveLocationlist(): bool
  return getloclist(winnr(), {'winid': 0}).winid != 0
enddef

# LocationList WindowのWindow IDを返す。
def GetLocationlistWinid(): number
  return getloclist(winnr(), {'winid' : 0}).winid
enddef


# Quickfixのエントリ数を返す
def QfNum(): number
  return execute('clist') -> split('\n') -> len()
enddef

# Locationlistのエントリ数を返す
def LlNum(): number
  return execute('llist') -> split('\n') -> len()
enddef

# Quickfixの"残り"エントリ数(カレントエントリから最後のエントリまでの数)を返す
def QfLeaveNum(): number
  return execute('clist +' .. 999999999) -> split('\n') -> len() - 1
enddef

# Locationlistの"残り"エントリ数(カレントエントリから最後のエントリまでの数)を返す
def LlLeaveNum(): number
  return execute('llist +' .. 999999999) -> split('\n') -> len() - 1
enddef



#---------------------------------------------------------------------------------------------
# QuickFix Show Entry Count

import autoload "popup_info.vim" as pui

def QfNumFormatString(header: string, whole: number, leave: number): string
  return header .. ' [ ' .. (whole - leave) .. ' / ' .. whole .. ' ]'
enddef

def QfNumPopupAdd(header: string, whole: number, leave: number)
  QfNumFormatString(header, whole, leave) -> pui.PopUpInfoA(2500, 8, 24)
enddef

com! QfNumEcho echo QfNumFormatString('Qfix', QfNum(), QfLeaveNum())
com! LlNumEcho echo QfNumFormatString('LocL', LlNum(), LlLeaveNum())

com! QfNumPopupAdd QfNumPopupAdd('QFix ',    QfNum(), QfLeaveNum())
com! LlNumPopupAdd QfNumPopupAdd('LocList ', LlNum(), LlLeaveNum())



#---------------------------------------------------------------------------------------------
finish

# => unified_tab.vim



#---------------------------------------------------------------------------------------------
# # Quickfix & Locationlist
#
# #例外をキャッチしないと、最初と最後の要素の次に移動しようとして例外で落ちる。
# nnoremap <silent> <Plug>(QuickFix-Next) <Cmd>try <Bar> exe (HaveLocationlist ? ':lnext' : 'cnext') <Bar> catch <Bar> endtry<CR>:CursorJumped<CR>
# nnoremap <silent> <Plug>(QuickFix-Prev) <Cmd>try <Bar> exe (HaveLocationlist ? ':lprev' : 'cprev') <Bar> catch <Bar> endtry<CR>:CursorJumped<CR>
#
# #例外をキャッチしないと、最初と最後の要素の次に移動しようとして例外で落ちる。
# nnoremap <silent> <Plug>(QuickFix-QfNext) <Cmd>try <Bar> cnext <Bar> catch <Bar> endtry<CR>:CursorJumped<CR>
# nnoremap <silent> <Plug>(QuickFix-QfPrev) <Cmd>try <Bar> cprev <Bar> catch <Bar> endtry<CR>:CursorJumped<CR>
#
# #例外をキャッチしないと、最初と最後の要素の次に移動しようとして例外で落ちる。
# nnoremap <silent> <Plug>(QuickFix-LlNext) <Cmd>try <Bar> lnext <Bar> catch <Bar> endtry<CR>:CursorJumped<CR>
# nnoremap <silent> <Plug>(QuickFix-LlPrev) <Cmd>try <Bar> lprev <Bar> catch <Bar> endtry<CR>:CursorJumped<CR>



# #---------------------------------------------------------------------------------------------
# # Quickfix cd Project-Root
#
# import autoload 'get_project_root.vim' as gpr
#
# # Quickfixウィンドウを、指定のディレクトリをカレントディレクトリとして開き直す。
# def QfChdir(dir: string)
#   cclose
#
#   const save_autochdir = &autochdir
#   set noautochdir
#
#   const cur_dir = getcwd()
#
#   exe 'noautocmd cd ' dir
#   copen
#
#   exe 'noautocmd cd' cur_dir
#
#   &autochdir = save_autochdir
# enddef
#
# # Quickfixウィンドウを、プロジェクトルートをカレントディレクトリとして開き直す。
# # com! QfChdirPrjRoot call QfChdir(gpr.GetPrjRoot())
