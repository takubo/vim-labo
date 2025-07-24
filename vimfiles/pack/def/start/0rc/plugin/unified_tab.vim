vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8


#=============================================================================================
# Unified Tab
#=============================================================================================


#---------------------------------------------------------------------------------------------
# Mapping

nnoremap <silent>         t <ScriptCmd>Unified_Tab(v:count1 * +1)<CR>
nnoremap <silent>         T <ScriptCmd>Unified_Tab(v:count1 * -1)<CR>
nnoremap <silent>     <Tab> <ScriptCmd>Unified_Tab(v:count1 * +1)<CR>
nnoremap <silent>   <S-Tab> <ScriptCmd>Unified_Tab(v:count1 * -1)<CR>
# TODO diff 1st, loc 1st
nnoremap <silent>        gt <Cmd>cfirst<CR>
nnoremap <silent>        gT <Cmd>clast<CR>
#nnoremap <silent> <Leader>t <Cmd>cc<CR>
#nnoremap <silent> <Leader>T <Cmd>cc<CR>


#---------------------------------------------------------------------------------------------
# Unified Tab

def Unified_Tab(dir_and_num: number)
  if &diff
    DiffHunkJump(dir_and_num)
  else
    QfJump(dir_and_num)
  endif
enddef


#---------------------------------------------------------------------------------------------
# Diff Hunk Jump

def DiffHunkJump(dir_and_num: number)
  if dir_and_num > 0
    # Next Hunk
    exe 'normal!' dir_and_num .. ']c'
  else
    # Previouse Hunk
    exe 'normal!' abs(dir_and_num) .. '[c'
  endif

  CursorJumped
enddef


#---------------------------------------------------------------------------------------------
# QuickFix Jump

# TODO cafter cbefore
def QfJump(dir_and_num: number)
  if !HaveLocationlist()
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


#----------------------------------------------------------------------------------------
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


#----------------------------------------------------------------------------------------
# QuickFix Utility Commands

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
