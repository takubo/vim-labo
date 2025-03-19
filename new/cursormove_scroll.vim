vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8


#========================================================================================
# Cursor Move, CursorLine, CursorColumn, and Scroll


#----------------------------------------------------------------------------------------
# Vertical Move

#set noshowcmd

#noremap j  gj
#noremap k  gk
noremap <expr> j v:count1 == 1 ? 'gj' : 'j'
noremap <expr> k v:count1 == 1 ? 'gk' : 'k'
sunmap j
sunmap k


#----------------------------------------------------------------------------------------
# Horizontal Move

# ^に、|の機能を付加
noremap <expr> <silent> ^ v:count != 0 ? '<Bar>' : '^'
sunmap ^

#? #noremap <expr> <silent> U v:prevcount ? (v:prevcount . '<Bar>') : search('^\s\+\%#\(\S\|\s$\)', 'bcn') ? '0' : '^'
#? #noremap <expr> <silent> U v:prevcount ? (v:prevcount . '<Bar>') : search('^\s\+\%#\(\S\|\s$\)', 'bcn') ? '0' : '^'
#? noremap <silent> U <Esc>:exe 'normal!' v:prevcount ? (v:prevcount .. '<Bar>') : search('^\s\+\%#\S\?', 'bcn') ? '0' : '^' <CR>
#? #onoremap <silent> <expr> U search('^\s\+\%#\S\?', 'bcn') ? '0' : '^'
#? sunmap U
#?
#? noremap : $
#? sunmap :
#?
#? # nnoremap 0 g0
#? # nnoremap $ g$
#?
#? # 補償
#? vnoremap gu u
#? vnoremap gU U

# FIXME g^


#----------------------------------------------------------------------------------------
# Vertical Scroll

set sidescroll=1
set sidescrolloff=5

# FIXME
g:comfortable_motion_friction = 253.0
g:comfortable_motion_air_drag = 45.0
g:comfortable_motion_impulse_multiplier = 38.0

nnoremap <silent> <Plug>(ComfortableMotion-Flick-Down) <Cmd>comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * min([64, winheight(0)])     )<CR>
nnoremap <silent> <Plug>(ComfortableMotion-Flick-Up)   <Cmd>comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * min([64, winheight(0)]) * -1)<CR>

# FIXME
nmap     gj <Plug>(ComfortableMotion-Flick-Down)
nmap     gk <Plug>(ComfortableMotion-Flick-Up)
vnoremap gj <C-d>
vnoremap gk <C-u>


#----------------------------------------------------------------------------------------
# Horizontal Scroll

var ve: string
augroup HorizScroll
  au!
  au User SubmodeEnterHorizScroll ve = &ve | &ve = 'all'
  au User SubmodeLeaveHorizScroll &ve = ve
augroup end

submode#enter_with('HorizScroll', 'nv', '', 'zh', 'zh'   )
submode#enter_with('HorizScroll', 'nv', '', 'zj', '<c-e>')
submode#enter_with('HorizScroll', 'nv', '', 'zk', '<c-y>')
submode#enter_with('HorizScroll', 'nv', '', 'zl', 'zl'   )
submode#map(       'HorizScroll', 'nv', '',  'h', 'zh'   )
submode#map(       'HorizScroll', 'nv', '',  'j', '<c-e>')
submode#map(       'HorizScroll', 'nv', '',  'k', '<c-y>')
submode#map(       'HorizScroll', 'nv', '',  'l', 'zl'   )

submode#map(       'HorizScroll', 'nv', '',  'J', 'j')
submode#map(       'HorizScroll', 'nv', '',  'K', 'k')

# sidescrolloffが1以上のとき、タブ文字(または多バイト文字)上にカーソルがあると、水平スクロールできないバグがあるので、カーソルを動かせるようにしておく。
submode#map(       'HorizScroll', 'nv', '',  'w', 'w')
submode#map(       'HorizScroll', 'nv', '',  'b', 'b')
set sidescrolloff=0

# FIXME set ve=all {{{
#submode#on_entering('HorizScroll', 'set ve=all')
#submode#on_leaving( 'HorizScroll', 'set ve=')

# submode#map(       'HorizScroll', 'nv', 'r',  'l', '<Plug>(More-Right)'   )
# # 行右端で、なお右に進もうとしたら、virtualeditにallを追加して、何事もなかったかのように右へ移動する。
# noremap <expr> <Plug>(More-Right) (!!search('\%#$', 'bcn') ? '<Cmd>set virtualedit+=all<CR>' : '') .. 'l'
# noremap <expr> <Plug>(More-Right) (!!search('\%#$', 'bcn') ? '<Cmd>set virtualedit+=all<CR>' : '') .. 'zl'
# noremap <expr> <Plug>(More-Right) (!!search('\%#.\?$', 'bcn') ? '<Cmd>set virtualedit+=all<CR>' : '') .. 'zl'
# # search()の最後の .\? は、onemore の有効向こう次第で、カーソルの右の文字の有無が変わるから。
# noremap <expr> <Plug>(More-Right) (!!search('\%#.\?$', 'bcn') && ScreenCol() == 1 ? '<Cmd>set virtualedit+=all<CR>' : '') .. 'zl'
#
# const ScreenCol = () => screencol() - win_getid()->getwininfo()[0].textoff
# nnoremap <expr> : ":echom " .. (screencol() - win_getid()->getwininfo()[0].textoff) .. "\n"
# }}}


#----------------------------------------------------------------------------------------
# Scrolloff

# FIXME WindowFocus.vim にあり。
  #----------------------------------------------------------------------------------------
  # Best Scrolloff
  #----------------------------------------------------------------------------------------
  #----------------------------------------------------------------------------------------
  # Typewriter Scroll
  #----------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------
# Cursorline & Cursorcolumn

set cursorline
set cursorcolumn

augroup CursorLineCursorColumn
  au!
  au WinEnter,BufEnter * setl   cursorline   cursorcolumn
  au WinLeave          * setl nocursorline nocursorcolumn

  au CursorHold  * setl nocursorcolumn
  au CursorHold  * au CursorLineCursorColumn CursorMoved * ++once setl cursorcolumn
augroup end

# com! -bar -bang CursorLine   {
#                   if '<bang>' == '!'
#                     setg cursorline!
#                   else
#                     setl cursorline!
#                   endif
#                 }
# com! -bar -bang CursorColumn {
#                   if '<bang>' == '!'
#                     setg cursorcolumn!
#                   else
#                     setl cursorcolumn!
#                   endif
#                 }
