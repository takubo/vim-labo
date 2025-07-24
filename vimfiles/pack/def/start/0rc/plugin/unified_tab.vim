vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8


#=============================================================================================
# Unified Tab
#=============================================================================================


#---------------------------------------------------------------------------------------------
# Mapping

nnoremap <expr> <silent> <Plug>(Unified-Tab-Next) &diff ? '<Plug>(Diff-Hunk-Next)' : '<Plug>(QuickFix-QfNext)'
nnoremap <expr> <silent> <Plug>(Unified-Tab-Prev) &diff ? '<Plug>(Diff-Hunk-Prev)' : '<Plug>(QuickFix-QfPrev)'

nnoremap       t <Plug>(Unified-Tab-Next)
nnoremap       T <Plug>(Unified-Tab-Prev)
nnoremap   <Tab> <Plug>(Unified-Tab-Next)
nnoremap <S-Tab> <Plug>(Unified-Tab-Prev)


# TODO diff 1st, loc 1st
nnoremap <silent>        gt <Cmd>cfirst<CR>
nnoremap <silent>        gT <Cmd>clast<CR>
#nnoremap <silent> <Leader>t <Cmd>cc<CR>
#nnoremap <silent> <Leader>T <Cmd>cc<CR>
