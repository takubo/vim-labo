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
    g:QfJump(dir_and_num)
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
