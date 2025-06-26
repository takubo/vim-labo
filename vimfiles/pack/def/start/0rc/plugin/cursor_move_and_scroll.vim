vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8


#========================================================================================
# Cursor Move, CursorLine, CursorColumn, and Scroll
#========================================================================================


#----------------------------------------------------------------------------------------
# Vertical Move
#----------------------------------------------------------------------------------------

noremap <expr> j v:count1 == 1 ? 'gj' : 'j'
noremap <expr> k v:count1 == 1 ? 'gk' : 'k'
sunmap j
sunmap k


#----------------------------------------------------------------------------------------
# Horizontal Move
#----------------------------------------------------------------------------------------

# ^に、|の機能を付加
noremap <expr> <silent> ^ v:count == 0 ? '^' : '<Bar>'
sunmap ^


#----------------------------------------------------------------------------------------
# Cursorline & Cursorcolumn
#----------------------------------------------------------------------------------------

set cursorline
set cursorcolumn
set cursorlineopt=screenline,number

augroup CursorLineCursorColumn
  au!
  au WinEnter,BufEnter * setl   cursorline   cursorcolumn
  au WinLeave          * setl nocursorline nocursorcolumn

  au CursorHold  * setl nocursorcolumn
  au CursorHold  * au CursorLineCursorColumn CursorMoved * ++once setl cursorcolumn
augroup end


#----------------------------------------------------------------------------------------
# Vertical Scroll
#----------------------------------------------------------------------------------------

set smoothscroll

def Scroll_0(dir: number)
  const k = dir >= 0 ? "2\<C-E>2gj" : "2\<C-Y>2gk"
 #const k = dir >= 0 ? "\<C-E>gj" : "\<C-Y>gk"

  const n0 = winheight(0) / 3

  var n = n0

  set nocursorcolumn

  while true
    var c = getchar(0) -> nr2char()
    if dir >= 0 && c == 'k' || dir < 0 && c == 'j'
      set cursorcolumn
      return
    endif
    if dir >= 0 && c == 'j' || dir < 0 && c == 'k'
      n += n0
    endif

    if n > 0
      execute 'normal!' k
      redraw
      sleep 1m
      n -= 1
    endif
  endwhile
enddef

def Scroll(dir: number)
  const n0 = winheight(0) / 2 #3

  var n = n0

  set nocursorcolumn

  while true
    var c = getchar(0) -> nr2char()
    if (dir >= 0 && c == 'k') || (dir < 0 && c == 'j') || (c == "\<Esc>")
      set cursorcolumn
      return
    endif
    if (dir >= 0 && c == 'j') || (dir < 0 && c == 'k')
      n += n0
    endif

    if n > 0
      const count = max([1, min([n / n0, n0]) / 2])
      const keys = (dir >= 0) ? (count .. "\<C-E>" .. count .. "gj") : (count .. "\<C-Y>" .. count .. "gk")

      execute 'normal!' keys
      redraw
      sleep 1m
      n -= 1
    endif
  endwhile
enddef

noremap <Plug>(Scroll-Down) <ScriptCmd>Scroll(+1)<CR>
noremap <Plug>(Scroll-Up)   <ScriptCmd>Scroll(-1)<CR>

nnoremap gj <Plug>(Scroll-Down)
nnoremap gk <Plug>(Scroll-Up)

vnoremap gj <Plug>(Scroll-Down)
vnoremap gk <Plug>(Scroll-Up)


#----------------------------------------------------------------------------------------
# Horizontal Scroll
#----------------------------------------------------------------------------------------

set sidescroll=1
set sidescrolloff=5

var ve_save: string

augroup HorizScroll
  au!
  au User SubmodeEnterHorizScroll ve_save = &ve | &ve = 'all'
  au User SubmodeLeaveHorizScroll &ve = ve_save
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

# sidescrolloffが1以上のとき、タブ文字(または多バイト文字)上にカーソルがあると、
# 水平スクロールできないバグがあるので、カーソルを動かせるようにしておく。
set sidescrolloff=0
submode#map(       'HorizScroll', 'nv', '',  'w', 'w')
submode#map(       'HorizScroll', 'nv', '',  'b', 'b')



#----------------------------------------------------------------------------------------
# Scrolloff
#----------------------------------------------------------------------------------------

set scrolloff=5  # TODO

# Best Scrolloff

augroup BestScrollOff
  au!
  au WinResized * EvtBestScrolloff()
augroup end

def EvtBestScrolloff()
  foreach(v:event.windows, (_, win_id) => win_execute(win_id, 'SetBestScrolloff()'))
enddef

def SetBestScrolloff()
  const winheight = winheight(0)
  # Quickfixでは、なぜかWinNewが発火しないので、exists()で変数の存在を確認せねばならない。
  &l:scrolloff = (!TypewriterScroll && (!exists('w:TypewriterScroll') || !w:TypewriterScroll)) ?
                   ( winheight < 10 ? 0 :
                     winheight < 20 ? 2 :
                     5 ) :
                   9999
enddef


#----------------------------------------------------------------------------------------
# Typewriter Scroll
#----------------------------------------------------------------------------------------

import autoload "popup_info.vim" as pui

var TypewriterScroll = false

def ToggleTypewriterScroll(global: bool)
  # Quickfixでは、なぜかWinNewが発火しないので、ここで変数を定義する。
  if !exists('w:TypewriterScroll')
    w:TypewriterScroll = false
  endif

  if global
    TypewriterScroll = !TypewriterScroll
    exe TypewriterScroll ? 'normal! zz' : ''
  else
    w:TypewriterScroll = !w:TypewriterScroll
    exe w:TypewriterScroll ? 'normal! zz' : ''
  endif

  SetBestScrolloff()

  pui.PopUpInfoM([
    TypewriterScroll   ? 'Global    TypewriterScroll' : 'Global No TypewriterScroll',
    '',
    w:TypewriterScroll ? 'Local     TypewriterScroll' : 'Local  No TypewriterScroll'
  ], 2000)
enddef

nnoremap z<Space> <ScriptCmd>ToggleTypewriterScroll(true)<CR>
nnoremap g<Space> <ScriptCmd>ToggleTypewriterScroll(false)<CR>


#----------------------------------------------------------------------------------------
# Virtual Edit
#----------------------------------------------------------------------------------------
nnoremap <expr> <Leader>$ '<Cmd>set virtualedit' .. (&virtualedit =~# 'onemore' ? '-=' : '+=') .. 'onemore<CR><Cmd>set virtualedit<CR>'


#----------------------------------------------------------------------------------------
# TODO
#----------------------------------------------------------------------------------------

#set noshowcmd

#noremap j  gj
#noremap k  gk


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


# #----------------------------------------------------------------------------------------
# # Vertical Scroll (ComfortableMotion)
#----------------------------------------------------------------------------------------
# # FIXME
#
# if 0
#   g:comfortable_motion_friction = 253.0
#   g:comfortable_motion_air_drag = 45.0
#   g:comfortable_motion_impulse_multiplier = 38.0
#
#   nnoremap <silent> <Plug>(ComfortableMotion-Flick-Down) <Cmd>comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * min([64, winheight(0)])     )<CR>
#   nnoremap <silent> <Plug>(ComfortableMotion-Flick-Up)   <Cmd>comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * min([64, winheight(0)]) * -1)<CR>
#
#   #nmap     gj <Plug>(ComfortableMotion-Flick-Down)
#   #nmap     gk <Plug>(ComfortableMotion-Flick-Up)
#   #vnoremap gj <C-d>
#   #vnoremap gk <C-u>
# endif
