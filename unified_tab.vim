vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8


#=============================================================================================
# Unified_Tab.vim
#=============================================================================================



nnoremap <silent>         t <ScriptCmd>Unified_Tab(v:count1 * +1)<CR>
nnoremap <silent>         T <ScriptCmd>Unified_Tab(v:count1 * -1)<CR>
nnoremap <silent>     <Tab> <ScriptCmd>Unified_Tab(v:count1 * +1)<CR>
nnoremap <silent>   <S-Tab> <ScriptCmd>Unified_Tab(v:count1 * -1)<CR>
# TODO diff 1st, loc 1st
nnoremap <silent>        gt <Cmd>cfirst<CR>
nnoremap <silent>        gT <Cmd>clast<CR>
#nnoremap <silent> <Leader>t <Cmd>cc<CR>
#nnoremap <silent> <Leader>T <Cmd>cc<CR>



def Unified_Tab(dir: number)
  if &diff
    DiffHunkJump(dir)
  else
    QfJump(dir)
  endif
enddef


def DiffHunkJump(dir_num: number)
  if dir_num > 0
    # Next Hunk
    exe 'normal!' dir_num .. ']c'
  else
    # Previouse Hunk
    exe 'normal!' dir_num .. '[c'
  endif

  CursorJumped
enddef

# TODO cafter cbefore
def QfJump(dir_num: number)
  if !HaveLocationlist()
    # 例外をキャッチしないと、最初と最後の要素の次に移動しようとして例外で落ちる。
    try
      execute(':' .. abs(dir_num) .. (dir_num >= 0 ?  'cnext' : 'cprev'))
      CursorJumped
    catch /:E553/
      # echo dir_num >= 0 ?  'Last error list.' : '1st error list.'
    endtry
    QfNumAdd
  else
    # 例外をキャッチしないと、最初と最後の要素の次に移動しようとして例外で落ちる。
    try
      execute(':' .. abs(dir_num) .. (dir_num >= 0 ?  'lnext' : 'lprev'))
      CursorJumped
    catch /:E553/
      # echo dir_num >= 0 ?  'Last location list.' : '1st location list.'
    endtry
    LlNumAdd
  endif
enddef

def HaveLocationlist(): bool
  return getloclist(winnr(), {'winid': 0}).winid != 0
enddef

def GetLocationlistWinid(): number
  return getloclist(winnr(), {'winid' : 0}).winid
enddef


const QfNum = () => execute('clist') -> split('\n') -> len()
const LlNum = () => execute('llist') -> split('\n') -> len()

const QfLeaveNum = () => execute('clist +' .. 999999999) -> split('\n') -> len() - 1
const LlLeaveNum = () => execute('llist +' .. 999999999) -> split('\n') -> len() - 1

def QfNumString(title: string, whole: number, leave: number): string
  return title .. ' [ ' .. (whole - leave) .. ' / ' .. whole .. ' ]'
enddef

def QfNumPopup(title: string, whole: number, leave: number)
  pui.PopUpInfoA(QfNumString(title, whole, leave), 2500, 8, 24)
enddef

com! QfNum echo QfNumString('Qfix', QfNum(), QfLeaveNum())
com! LlNum echo QfNumString('LocL', LlNum(), LlLeaveNum())

com! QfNumAdd QfNumPopup('Q ', QfNum(), QfLeaveNum())
com! LlNumAdd QfNumPopup('R ', LlNum(), LlLeaveNum())


#---------------------------------------------------------------------------------------------


## def QfNumString(): string
##   const whole = execute('clist') -> split('\n') -> len()
##   const leave = execute('clist +' .. whole) -> split('\n') -> len() - 1
##   return '[' .. (whole - leave) .. '/' .. whole .. ']'
## enddef
##
## def QfNumString(): string
##   const whole = QfNum()
##   const leave = QfLeaveNum()
##   return '[' .. (whole - leave) .. '/' .. whole .. ']'
## enddef
##
## def QfNumString(): string
##   const whole = QfNum()
##   const leave = QfLeaveNum()
##   return '[' .. (whole - leave) .. '/' .. whole .. ']'
## enddef
##
## def LlNumString(): string
##   const whole = LlNum()
##   const leave = LlLeaveNum()
##   return '[' .. (whole - leave) .. '/' .. whole .. ']'
## enddef

#const QfNum = () => execute('clist') -> split('\n') -> len()
#const LlNum = () => execute('llist') -> split('\n') -> len()
#
#const QfLeaveNum = () => execute('clist +' .. 999999999) -> split('\n') -> len() - 1
#const LlLeaveNum = () => execute('llist +' .. 999999999) -> split('\n') -> len() - 1
#
#def QfNumString(title: string, whole: number, leave: number): string
#  return title .. ' [ ' .. (whole - leave) .. ' / ' .. whole .. ' ]'
#enddef
#
#com! EchoQfNum echo QfNumString('', QfNum(), QfLeaveNum())
#com! EchoLlNum echo QfNumString('', LlNum(), LlLeaveNum())
#
#com! QfNumAdd pui.PopUpInfoA(QfNumString('Qfix', QfNum(), QfLeaveNum()), 2500, 8)
#com! LlNumAdd pui.PopUpInfoA(QfNumString('LocL', LlNum(), LlLeaveNum()), 2500, 8)


#def QfJump(dir_num: number)
#  if !HaveLocationlist()
#    # 例外をキャッチしないと、最初と最後の要素の次に移動しようとして例外で落ちる。
#    try
#      execute(abs(dir_num) ..( dir_num >= 0 ?  'cnext' : 'cprev'))
#      CursorJumped
#    catch /:E553/
#      # echo dir_num >= 0 ?  'Last error list.' : '1st error list.'
#    endtry
#    QfNumAdd
#  else
#    # 例外をキャッチしないと、最初と最後の要素の次に移動しようとして例外で落ちる。
#    try
#      execute(abs(dir_num) .. (dir_num >= 0 ?  'lnext' : 'lprev'))
#      CursorJumped
#    catch /:E553/
#      # echo dir_num >= 0 ?  'Last location list.' : '1st location list.'
#    endtry
#    LlNumAdd
#  endif
#enddef


