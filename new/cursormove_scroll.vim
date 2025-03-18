1228

" Cursor Move, CursorLine, CursorColumn, and Scroll {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{


"----------------------------------------------------------------------------------------
" Vertical Move

"set noshowcmd

nnoremap j  gj
nnoremap k  gk

xnoremap j  gj
xnoremap k  gk


"----------------------------------------------------------------------------------------
" Horizontal Move

" ^に、|の機能を付加
nnoremap <silent> ^ <Esc>:exe v:prevcount ? ('normal! ' . v:prevcount . '<Bar>') : 'normal! ^'<CR>


"----------------------------------------------------------------------------------------
" Vertical Scroll

set sidescroll=1
set sidescrolloff=5

nnoremap <silent> <C-j> <C-d>
nnoremap <silent> <C-k> <C-u>

vnoremap <silent> <Space>   <C-d>
vnoremap <silent> <S-Space> <C-u>

let g:comfortable_motion_friction = 253.0
let g:comfortable_motion_air_drag = 45.0
let g:comfortable_motion_impulse_multiplier = 38.0
nnoremap <silent> <Plug>(ComfortableMotion-Flick-Down) :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * min([64, winheight(0)])     )<CR>
nnoremap <silent> <Plug>(ComfortableMotion-Flick-Up)   :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * min([64, winheight(0)]) * -1)<CR>

nmap gj <Plug>(ComfortableMotion-Flick-Down)
nmap gk <Plug>(ComfortableMotion-Flick-Up)
" HHKB
nmap <Leader>j <Plug>(ComfortableMotion-Flick-Down)
nmap <Leader>k <Plug>(ComfortableMotion-Flick-Up)

vnoremap gj <C-d>
vnoremap gk <C-u>


"----------------------------------------------------------------------------------------
" Horizontal Scroll

call submode#enter_with('HorizScroll', 'n', '', 'zl', 'zl')
call submode#enter_with('HorizScroll', 'n', '', 'zh', 'zh')
call submode#map(       'HorizScroll', 'n', '', 'l' , 'zl')
call submode#map(       'HorizScroll', 'n', '', 'h' , 'zh')

call submode#enter_with('HorizScroll', 'n', '', 'zj', '<c-e>')
call submode#enter_with('HorizScroll', 'n', '', 'zk', '<c-y>')
call submode#map(       'HorizScroll', 'n', '', 'j' , '<c-e>')
call submode#map(       'HorizScroll', 'n', '', 'k' , '<c-y>')

"sidescrolloffが1以上のとき、タブ文字(または多バイト文字)上にカーソルがあると、水平スクロールできないバグ(?)があるので、カーソルを動かせるようにしておく。
if 0
  call submode#map(       'HorizScroll', 'n', '', 'w' , 'w')
  call submode#map(       'HorizScroll', 'n', '', 'b' , 'w')
else
  set sidescrolloff=0
 "call submode#map(       'HorizScroll', 'n', '', 'l' , ':set virtualedit=all<CR>zl:set virtualedit=block<CR>')
 "call submode#map(       'HorizScroll', 'n', '', 'l' , ':set sidescrolloff=0<CR>zl:set sidescrolloff=5<CR>')
 "call submode#map(       'HorizScroll', 'n', '', 'h' , 'zh')
endif

"----------------------------------------------------------------------------------------
" Cursorline & Cursorcolumn

set cursorline
set cursorcolumn

augroup MyVimrc_Cursor
  au!
  au WinEnter,BufEnter * setl cursorline "cursorcolumn
  au WinEnter,BufEnter * setl cursorline  cursorcolumn
  au WinLeave          * setl nocursorline nocursorcolumn

  if 1
    au CursorHold  * setl nocursorcolumn
    au CursorMoved * setl cursorcolumn
  else
    au CursorHold  * setl nocursorcolumn
    au CursorHold  * au CursorMoved * ++once setl cursorcolumn
  endif
augroup end

nnoremap <silent> <Leader>c :<C-u>setl cursorline!<CR>
nnoremap <silent> <leader>C :<C-u>setl cursorcolumn!<CR>


"----------------------------------------------------------------------------------------
" Scrolloff

function! s:best_scrolloff()
  " Quickfixでは、なぜかWinNewが発火しないので、exists()で変数の存在を確認せねばならない。
  let &l:scrolloff = (g:BrowsingScroll || (exists('w:BrowsingScroll') && w:BrowsingScroll)) ? 99999 : ( winheight(0) < 10 ? 0 : winheight(0) < 20 ? 2 : 5 )
endfunction

function! BestScrolloff()
  call s:best_scrolloff()
endfunction

let g:BrowsingScroll = v:false
nnoremap g<Space>  :<C-u> let g:BrowsingScroll = !g:BrowsingScroll
                  \ <Bar> exe g:BrowsingScroll ? 'normal! zz' : ''
                  \ <Bar> call <SID>best_scrolloff()
                  \ <Bar> echo g:BrowsingScroll ? 'Global BrowsingScroll' : 'Global NoBrowsingScroll'<CR>
nnoremap z<Space>  :<C-u> let w:BrowsingScroll = !w:BrowsingScroll
                  \ <Bar> exe w:BrowsingScroll ? 'normal! zz' : ''
                  \ <Bar> call <SID>best_scrolloff()
                  \ <Bar> echo w:BrowsingScroll ? 'Local BrowsingScroll' : 'Local NoBrowsingScroll'<CR>

augroup MyVimrc_ScrollOff
  au!
  au WinNew              * let w:BrowsingScroll = v:false
  au WinEnter,VimResized * call <SID>best_scrolloff()
  " -o, -Oオプション付きで起動したWindowでは、WinNew, WinEnterが発火しないので、別途設定。
  au VimEnter * PushPosAll | exe 'tabdo windo let w:BrowsingScroll = v:false | call <SID>best_scrolloff()' | PopPosAll
augroup end


""----------------------------------------------------------------------------------------
"" Scrolloff vimrc
"
"function! s:best_scrolloff()
"  " Quickfixでは、なぜかWinNewが発火しないので、exists()で変数の存在を確認せねばならない。
"  let &l:scrolloff = (g:BrowsingScroll || (exists('w:BrowsingScroll') && w:BrowsingScroll)) ? 99999 : ( winheight(0) < 10 ? 0 : winheight(0) < 20 ? 2 : 5 )
"endfunction
"
"function! BestScrolloff()
"  call s:best_scrolloff()
"endfunction
"
"let g:BrowsingScroll = v:false
"nnoremap z<Space>  :<C-u> let g:BrowsingScroll = !g:BrowsingScroll
"                  \ <Bar> exe g:BrowsingScroll ? 'normal! zz' : ''
"                  \ <Bar> call <SID>best_scrolloff()
"                  \ <Bar> echo g:BrowsingScroll ? 'Global BrowsingScroll' : 'Global NoBrowsingScroll'<CR>
"nnoremap g<Space>  :<C-u> let w:BrowsingScroll = !w:BrowsingScroll
"                  \ <Bar> exe w:BrowsingScroll ? 'normal! zz' : ''
"                  \ <Bar> call <SID>best_scrolloff()
"                  \ <Bar> echo w:BrowsingScroll ? 'Local BrowsingScroll' : 'Local NoBrowsingScroll'<CR>
"
"augroup MyVimrc_ScrollOff
"  au!
"  au WinNew              * let w:BrowsingScroll = v:false
"  "au WinEnter,VimResized * call <SID>best_scrolloff()
"  " -o, -Oオプション付きで起動したWindowでは、WinNew, WinEnterが発火しないので、別途設定。
"  au VimEnter * call PushPos_All() | exe 'tabdo windo let w:BrowsingScroll = v:false | call <SID>best_scrolloff()' | call PopPos_All()
"augroup end


" Cursor Move, CursorLine, CursorColumn, and Scroll }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}





Unified_Tab_Note

"---------------------------------------------------------------------------------------------

" ^に、|の機能を付加
"nnoremap <silent> U <Esc>:exe v:prevcount ? ('normal! ' . v:prevcount . '<Bar>') : 'normal! ^'<CR>
"nnoremap <expr> <silent> U v:prevcount ? (v:prevcount . '<Bar>') : '^'
"nnoremap <expr> <silent> U v:prevcount ? (v:prevcount . '<Bar>') : search('^\s*\%#', 'bcn') ? '0' : '^'
"nnoremap <expr> <silent> U v:prevcount ? (v:prevcount . '<Bar>') : search('^\s\+\%#\S', 'bcn') ? '0' : '^'
nnoremap <expr> <silent> U v:prevcount ? (v:prevcount . '<Bar>') : search('^\s\+\%#\S\?', 'bcn') ? '0' : '^'
vnoremap <expr> <silent> U v:prevcount ? (v:prevcount . '<Bar>') : search('^\s\+\%#\S\?', 'bcn') ? '0' : '^'
"nnoremap <expr> <silent> U v:prevcount ? (v:prevcount . '<Bar>') : search('^\s\+\%#\(\S\|\s$\)', 'bcn') ? '0' : '^'
"vnoremap <expr> <silent> U v:prevcount ? (v:prevcount . '<Bar>') : '^'

"""  " ^に、|の機能を付加
"""  nnoremap <silent> ^ <Esc>:exe v:prevcount ? ('normal! ' . v:prevcount . '<Bar>') : 'normal! ^'<CR>
nnoremap <silent> U <Esc>:exe 'normal!' v:prevcount ? (v:prevcount . '<Bar>') : search('^\s\+\%#\S\?', 'bcn') ? '0' : '^' <CR>
vnoremap <silent> U <Esc>:exe 'normal!' v:prevcount ? (v:prevcount . '<Bar>') : search('^\s\+\%#\S\?', 'bcn') ? '0' : '^' <CR>
"onoremap <silent> U <Esc>:exe 'normal!' v:prevcount ? (v:prevcount . '<Bar>') : search('^\s\+\%#\S\?', 'bcn') ? '0' : '^' <CR>
onoremap <expr> <silent> U search('^\s\+\%#\S\?', 'bcn') ? '0' : '^'
"nnoremap <expr> <silent> U v:prevcount ? (v:prevcount . '<Bar>') : search('^\s\+\%#\S\?', 'bcn') ? '0' : '^' <CR>

nnoremap zU g0

"nnoremap U ^
nnoremap : $
"vnoremap U ^
vnoremap : $

nnoremap 0 g0
nnoremap $ g$

" 補償
vnoremap gu u
vnoremap gU U


" 矯正
" nnoremap ^ <Nop>
" nnoremap $ <Nop>
" vnoremap ^ <Nop>
" vnoremap $ <Nop>



