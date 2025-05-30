scriptencoding utf-8
" vim:set ts=8 sts=2 sw=2 tw=0 expandtab :

if exists('loaded_Window')
  "finish
endif
let loaded_Window = v:true

let s:save_cpo = &cpo
set cpo&vim



"----------------------------------------------------------------------------------------
" Focus

" Basic
nnoremap <silent> <Plug>(Window-Focus-SkipTerm-Inc) <Esc>:exe Window#Focus#SkipTerm(+1) . ' wincmd w'<CR>
nnoremap <silent> <Plug>(Window-Focus-SkipTerm-Dec) <Esc>:exe Window#Focus#SkipTerm(-1) . ' wincmd w'<CR>

" Direction Focus
nnoremap <silent> <Plug>(Window-Focus-WrapMove-h) :<C-u>call Window#Focus#WinWrapMove('h')<CR>
nnoremap <silent> <Plug>(Window-Focus-WrapMove-j) :<C-u>call Window#Focus#WinWrapMove('j')<CR>
nnoremap <silent> <Plug>(Window-Focus-WrapMove-k) :<C-u>call Window#Focus#WinWrapMove('k')<CR>
nnoremap <silent> <Plug>(Window-Focus-WrapMove-l) :<C-u>call Window#Focus#WinWrapMove('l')<CR>



"----------------------------------------------------------------------------------------
" Resize

" Equal Only Height
com! WindowSizeEqualOnlyHeight call Window#Resize#EqualOnlyHeight()
nnoremap <silent> <Plug>(Window-Resize-EqualOnlyHeight) :<C-u>call Window#Resize#EqualOnlyHeight()<CR>

" Equal Only Width
com! WindowSizeEqualOnlyWidth call Window#Resize#EqualOnlyWidth()
nnoremap <silent> <Plug>(Window-Resize-EqualOnlyWidth) :<C-u>call Window#Resize#EqualOnlyWidth()<CR>

" Optimal Width
com! OptimalWindowWidth call Window#Resize#SetOptimalWidth()
nnoremap <silent> <Plug>(Window-Resize-OptimalWidth) :<C-u>call Window#Resize#SetOptimalWidth()<CR>

" Optimal Height
com! OptimalWindowHeight call Window#Resize#SetOptimalHeight()
nnoremap <silent> <Plug>(Window-Resize-OptimalHeight) :<C-u>call Window#Resize#SetOptimalHeight()<CR>



let &cpo = s:save_cpo
unlet s:save_cpo
