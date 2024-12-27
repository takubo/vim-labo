vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 expandtab
scriptencoding utf-8


finish

vimrc

"---------------------------------------------------------------------------------------------

com! NoWrap PushPosAll | exe 'windo set nowrap' | PopPosAll
com! WinNoWrap PushPosAll | exe 'windo set nowrap' | PopPosAll
com! AllNoWrap PushPosAll | exe 'windo set nowrap' | PopPosAll

com! Wrap PushPosAll | exe 'windo set wrap' | PopPosAll
com! WinWrap PushPosAll | exe 'windo set wrap' | PopPosAll
com! AllWrap PushPosAll | exe 'windo set wrap' | PopPosAll



"---------------------------------------------------------------------------------------------

"nmap <C-t> <Plug>(TabSplit)
nmap     t <Plug>(TabSplit)
nnoremap T <C-w>T

" <c-t> g<c-t> T gT
nmap gt <Plug>(Window-Resize-OptimalWidth)
nmap gT <C-w>=
" nmap <Leader><Leader> <C-w>=



"nmap <C-t> <Plug>(TabSplit)
nnoremap T <C-w>T

" <c-t> g<c-t> T gT
nmap gt <Plug>(Window-Resize-OptimalWidth)
nmap gT <C-w>=
" nmap <Leader><Leader> <C-w>=
nnoremap t gt
nnoremap T gT



nmap     t <Plug>(TabSplit)
nnoremap T <C-w>T
"nmap     <Leader><Leader> <Plug>(TabSplit)


