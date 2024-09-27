vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 expandtab
scriptencoding utf-8


#----------------------------------------------------------------------------------------
# Focus Wrap Move
#----------------------------------------------------------------------------------------

const NotTerminal = (win: number): bool => (&l:buftype !~ 'terminal' || term_getstatus(winbufnr(win)) =~ 'normal')

export def WindowFocus_WrapMove(dir_key: string, count: number, orth: bool = false): void
  # {{{ optimize
  if count == 1
    const cur_win = winnr()
    exe 'wincmd ' .. dir_key
    const new_win = winnr()
    if (cur_win != new_win) && NotTerminal(new_win)
      return
    endif
  endif
  # }}} optimize

  const num_win = winnr('$')  # Windowの数

  # Windowの数が2なら、もう一方へ移動することは自明。Windowの数が1なら、移動はない。
  if num_win <= 2
    wincmd w
    return
  endif

  # 順方向へ移動
  const fwrd = WindowFocus_WrapMove_Sub(dir_key, count)
  if fwrd.done
    return
  endif

  # 逆方向へ移動
  const rev_dir_key = {'h': 'l', 'j': 'k', 'k': 'j', 'l': 'h'}[dir_key]
  # countをnum_win + とすることで、確実に端まで移動し、且つ、移動完了となってしまわないようにしている。
  const back = WindowFocus_WrapMove_Sub(rev_dir_key, num_win + 1)

  if fwrd.step == 0 &&  back.step == 0
    if !orth
      # 直交移動
      WindowFocus_WrapMove({'h': 'k', 'j': 'l', 'k': 'h', 'l': 'j'}[dir_key], count, true)
    endif
    return
  endif

  const step_around = fwrd.step + back.step + 1  # +1はwrap分
  const step_mod = count % step_around

  if step_mod == 0
  elseif step_mod <= fwrd.step
    exe ':' .. fwrd.win[step_mod] .. 'wincmd ' .. dir_key
  else
    exe ':' .. back.win[back.step - (step_mod - fwrd.step - 1)] .. 'wincmd ' .. rev_dir_key
  endif
enddef

def WindowFocus_WrapMove_Sub(dir_key: string, count: number): dict<any>
  #var ret: dict<any> = {'done': false, 'step': 0, 'win': []}
  var ret: dict<any> = {'done': false, 'step': 0, 'win': range(count)}

  const org_win = winnr()

  var old_win = org_win
  var move_accum = 0
  var move_num = 0

  while true
    move_num += MoveToNextWindow(dir_key)

    const new_win = winnr()

    if new_win == old_win
      # もう動けないので、org_winに戻って終了。
      exe ':' .. org_win .. 'wincmd w'

      ret.done = false
      ret.step = move_accum
      return ret
    endif

    ++move_accum

    ret.win->insert(move_num, move_accum)

    if move_accum == count
      # terminalでないwindowを見つけたので、移動して終了。
      # 一旦戻って、直接移動にしないと、前Window(<C-w>p)が意図しないものとなる。
      exe ':' .. org_win .. 'wincmd w'
      exe ':' .. new_win .. 'wincmd w'

      ret.done = true
      ret.step = move_accum
      return ret
    endif

    old_win = new_win
  endwhile

  return ret  # ここに到達することはないが、returnがないとビルドエラーになる。
enddef

# TODO 開始は、terminalではない前提。
def MoveToNextWindow(dir_key: string): number
  var old_win = winnr()
  var move_accum = 0

  while true
    exe 'wincmd ' .. dir_key

    const new_win = winnr()

    const not_terminal = NotTerminal(new_win)

    if new_win == old_win
      # 端まで移動していた
      return (not_terminal ? move_accum : 0)
    endif

    ++move_accum

    if not_terminal
      return move_accum
    endif

    old_win = new_win
  endwhile

  return 0  # ここに到達することはないが、returnがないとビルドエラーになる。
enddef


#----------------------------------------------------------------------------------------
# Optimal Window Width
#----------------------------------------------------------------------------------------

const OptimalWidth = () => (
    range(line('w0'), line('w$')) -> map((_, val) => virtcol([val, '$'])) -> max()
    +
    (bufname(0) =~ '^NERD_tree' ? -2 : 0)
    +
    (&number || &l:number || &relativenumber || &l:relativenumber ? 5 : 0)
    +
    &l:foldcolumn
  )

export def WindowResizeOptimalWidth()
  exe ':' OptimalWidth() 'wincmd |'
enddef

export def WindowResizeToggleOptimalWidthEqual()
  const optimal_width = OptimalWidth()
  if win_getid()->getwininfo()[0].width == optimal_width
    wincmd =
  else
    exe ':' optimal_width 'wincmd |'
  endif
enddef


#----------------------------------------------------------------------------------------
# Optimal Window Height
#----------------------------------------------------------------------------------------

# TODO wrapされた行の考慮も必要。
const OptimalHeightBuf        = (): number => line('$') + 2  # 2に根拠はない。
# const OptimalHeightFunction = (): number => 10
# const OptimalHeightBlock    = (): number => 10
# const OptimalHeightIfBlock  = (): number => 10

def WindowResizeOptimalHeight(height: number)
  exe ':' height 'wincmd _'
  call repeat('<C-Y>', line('$'))->feedkeys('n')
enddef

export const WindowResizeOptimalHeightBuf        = () => OptimalHeightBuf()->WindowResizeOptimalHeight()
# export const WindowResizeOptimalHeightFunction = () => OptimalHeightFunction()->WindowResizeOptimalHeight()
# export const WindowResizeOptimalHeightBlock    = () => OptimalHeightBlock()->WindowResizeOptimalHeight()
# export const WindowResizeOptimalHeightIfBlock  = () => OptimalHeightIfBlock()->WindowResizeOptimalHeight()




#----------------------------------------------------------------------------------------
# Plugin
#----------------------------------------------------------------------------------------


nnoremap <Plug>(Window-Focus-WrapMove-h) <cmd>call <SID>WindowFocus_WrapMove('h', v:count1)<CR>
nnoremap <Plug>(Window-Focus-WrapMove-j) <cmd>call <SID>WindowFocus_WrapMove('j', v:count1)<CR>
nnoremap <Plug>(Window-Focus-WrapMove-k) <cmd>call <SID>WindowFocus_WrapMove('k', v:count1)<CR>
nnoremap <Plug>(Window-Focus-WrapMove-l) <cmd>call <SID>WindowFocus_WrapMove('l', v:count1)<CR>


com! -nargs=0 -bar WindowResizeOptimalWidth call <SID>WindowResizeOptimalWidth()

nnoremap <Plug>(Window-Resize-OptimalWidth) <cmd>>WindowResizeOptimalWidth<CR>


com! -nargs=0 -bar WindowResizeToggleOptimalWidthEqual call <SID>WindowResizeToggleOptimalWidthEqual()

nnoremap <Plug>(Window-Resize-Toggle-OptimalWidth-Equal) <Cmd>WindowResizeToggleOptimalWidthEqual<CR>


com! -nargs=0 -bar OptimalHeightBuf call <SID>WindowResizeOptimalHeightBuf()

nnoremap <Plug>(Window-Resize-OptimalHeight-Buf) <cmd>OptimalHeightBuf<CR>




#----------------------------------------------------------------------------------------
# RC
#----------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------
# Focus

nmap <Left>  <Plug>(Window-Focus-WrapMove-h)
nmap <Down>  <Plug>(Window-Focus-WrapMove-j)
nmap <Up>    <Plug>(Window-Focus-WrapMove-k)
nmap <Right> <Plug>(Window-Focus-WrapMove-l)

nmap H <Plug>(Window-Focus-WrapMove-h)
nmap J <Plug>(Window-Focus-WrapMove-j)
nmap K <Plug>(Window-Focus-WrapMove-k)
nmap L <Plug>(Window-Focus-WrapMove-l)


#----------------------------------------------------------------------------------------
# Resize

nmap <Space><Space> <Plug>(Window-Resize-Toggle-OptimalWidth-Equal)
# nmap <Space><Space> <Plug>(Window-Resize-OptimalHeight-Buf)


#----------------------------------------------------------------------------------------
# Window Container (Tab)

nnoremap  <C-T> <Cmd>tabnew<CR>
nnoremap g<C-T> :<C-U>tabnew<Space>
#nnoremap <silent>  <C-t> <Cmd>tabnew<Bar>SetpathSilent<CR>
# nnoremap <silent> z<C-t> <Cmd>tab split<CR>

nnoremap <C-f> gt
nnoremap <C-b> gT
# nnoremap t gt
# nnoremap T gT

nnoremap g<C-F> <Cmd>exe tabpagenr() == tabpagenr('$') ? 'tabmove 0' : 'tabmove +1'<CR>
nnoremap g<C-B> <Cmd>exe tabpagenr() == 1              ? 'tabmove $' : 'tabmove -1'<CR>

nnoremap <A-F>  <Cmd>exe tabpagenr() == tabpagenr('$') ? 'tabmove 0' : 'tabmove +1'<CR>
nnoremap <A-B>  <Cmd>exe tabpagenr() == 1              ? 'tabmove $' : 'tabmove -1'<CR>

nnoremap gt <Cmd>tabs<CR>:tabnext<Space>




#----------------------------------------------------------------------------------------
# Window Ratio
#----------------------------------------------------------------------------------------

# 横長なほど、大きい値が返る。
def WindowRatio(): number
  const h = winheight(0) + 0.0
  const w =  winwidth(0) + 0.0
  # 正方形 w:h = 178:78 の想定
  return (w / h - 178.0 / 78.0)
enddef

#       Vert Split すべきとき、正数が返る。
# Horizontal Split すべきとき、負数が返る。
export def BestSplitDirection(): number
  return ( winwidth(0) > (&columns * 7 / 10) && <SID>WindowRatio() >= 0 ) ? 9999 : -9999
enddef

#       Vert Split すべきとき、'v'が返る。
# Horizontal Split すべきとき、's'が返る。
export def SplitDirection(): string
  return ( winwidth(0) > (&columns * 7 / 10) && <SID>WindowRatio() >= 0 ) ? 'v' : 's'
enddef

#       Vert Split すべきとき、true が返る。
# Horizontal Split すべきとき、falseが返る。
export def VertSplit(): bool
  return ( winwidth(0) > (&columns * 7 / 10) && <SID>WindowRatio() >= 0 )
enddef




#----------------------------------------------------------------------------------------
# Best Scrolloff
#----------------------------------------------------------------------------------------

augroup MyVimrc_BestScrollOff
  au!
  # au WinResized * echo v:event
  au WinResized * call ExeBestScrolloff()
augroup end

# def BestScrolloff()
#   map(v:event, (_, win_id) => { win_execute(win_id, 'echo winnr()')
#                                 return 0
#   } )
# enddef

def ExeBestScrolloff()
  # var evt: list<number> = copy(v:event.windows)
  # TODO foreach にしたら、str2nr2は不要になる。
  map(v:event.windows, (_, win_id) => str2nr(win_execute(win_id, 'BestScrolloff()')))
enddef

def BestScrolloff()
  # Quickfixでは、なぜかWinNewが発火しないので、exists()で変数の存在を確認せねばならない。
  &l:scrolloff = (TypewriterScroll || (exists('w:TypewriterScroll') && w:TypewriterScroll)) ?
                 9999 :
                 ( winheight(0) < 10 ? 0 : winheight(0) < 20 ? 2 : 5 )
enddef



#----------------------------------------------------------------------------------------
# Typewriter Scroll
#----------------------------------------------------------------------------------------

import autoload "./PopUpInfo.vim" as pui


var TypewriterScroll = false

augroup MyVimrc_TypewriterScroll
  au!
  au WinNew * call setwinvar(0, 'TypewriterScroll', false)
  # -o, -Oオプション付きで起動したWindowでは、WinNew, WinEnterが発火しないので、別途設定。
  au VimEnter * PushPosAll | exe "tabdo windo call setwinvar(0, 'TypewriterScroll', false) | call <SID>BestScrolloff()" | PopPosAll
augroup end

def ToggleTypewriterScroll(global: bool)
  if global
    TypewriterScroll = !TypewriterScroll
    exe TypewriterScroll ? 'normal! zz' : ''
  else
    w:TypewriterScroll = !w:TypewriterScroll
    exe w:TypewriterScroll ? 'normal! zz' : ''
  endif

  call BestScrolloff()

  pui.PopUpInfo([
    TypewriterScroll ?   'Global    TypewriterScroll' : 'Global No TypewriterScroll',
    '',
    w:TypewriterScroll ? 'Local     TypewriterScroll' : 'Local  No TypewriterScroll'
  ], 2000)
enddef

nnoremap z<Space> <ScriptCmd>call ToggleTypewriterScroll(v:true)<CR>
nnoremap g<Space> <ScriptCmd>call ToggleTypewriterScroll(v:false)<CR>



# nnoremap <Leader>H H
# nnoremap <Leader>M M
# nnoremap <Leader>L L




#----------------------------------------------------------------------------------------


##     # if &l:buftype !~ 'terminal' || term_getstatus(winbufnr(new_win)) =~ 'normal'
##   #? ret.done = v:false
##   #? ret.step = 0
## 
##   #? terminalを全てSkipする必要があるので、forではなく無限ループする。
##     #? const satisfied = (move_count == count)
## 
## def WindowFocus_WrapMove_Sub_Old(dir_key: string, count: number): dict<any>
##   var ret: dict<any>
## 
##   const org_win = winnr()
## 
##   var old_win = org_win
## 
##   var move_count = 0
## 
##   # terminalを全てSkipする必要があるので、forではなく無限ループする。
##   while 1
## 
##     exe 'wincmd ' .. dir_key
## 
##     const new_win = winnr()
## 
##     const reached_edge = (new_win == old_win)
## 
##     const is_terminal = (&l:buftype =~ 'terminal' && term_getstatus(winbufnr(new_win)) !~ 'normal')
## 
##     if !is_terminal
##       move_count++
##     endif
## 
##     const satisfied =(new == old)
## 
##     if satisfied && !is_terminal
##       " terminalでないwindowを見つけたので、移動して終了。
##       " 一旦戻って、直接移動にしないと、前Window(<C-w>p)が意図しないものとなる。
##       exe org_win 'wincmd w'
##       exe new_win 'wincmd w'
## 
##       ret.done = v:true
##       ret.step = move_count
##       return
##     endif
## 
## 
##       " もう動けないので、orgに戻って終了。
##       exe org 'wincmd w'
## 
## 
##     if &l:buftype !~ 'terminal' || term_getstatus(winbufnr(new_win)) =~ 'normal'
##     else
##     endif
##   endwhile
## 
## 
##   ret.done = v:false
##   ret.step = 0
## 
##   return ret
## enddef


  # var old_win ; number
  # var cur_win2 number

  # var step_fwrd 2 number
  # var step_back 2 number
  #
  # var moved_fwrd: bool
  # var moved_back: bool

  # var last_moved_win_fwrd: number
  # var last_moved_win_back: number

  # if count >= 2
  #   exe count .. 'wincmd ' .. dir_key
  # endif


# 
# 
# 
# 
#   "++++++++++++ 元々指定された方向に動く ++++++++++++
# 
#   let last_moved_win = org
# 
#   while 1
#     " terminalを全てSkipする必要があるので、ループする。
# 
#     let old = winnr()
#     exe 'wincmd ' . a:m
#     let new = winnr()
# 
#     if new == old
#       " もう動けないので、orgに戻って終了。
#       exe org 'wincmd w'
#       break
#     endif
# 
#     if &l:buftype !~ 'terminal' || term_getstatus(winbufnr(new)) =~ 'normal'
#       " terminalでないwindowを見つけたので、移動して終了。
#       " 一旦戻って、直接移動にしないと、前Window(<C-w>p)が意図しないものとなる。
#       exe org 'wincmd w'
#       exe new 'wincmd w'
#       return
#     else
#       " 移動できた最後のwindowを憶えておく。 (直交移動で使う。)
#       let last_moved_win = new
#     endif
#   endwhile
# 
# 
#   "++++++++++++ 元々指定されのと反対方向に動く ++++++++++++
# 
#   let rev = {'h'2 'l', 'j'2 'k', 'k'2 'j', 'l'2 'h'}
# 
#   " ここでorgで初期化しておかないと、terminal windowへしか動けなったときに変数未定義になる。
#   let last_not_term_win = org
# 
#   while 1
#     " 逆端まで動く必要があるのでループする。
# 
#     let old = winnr()
#     exe 'wincmd ' . rev[a:m]
#     let new = winnr()
# 
#     if &l:buftype !~ 'terminal' || term_getstatus(winbufnr(new)) =~ 'normal'
#       " 移動できた最後のterminalでないwindowを憶えておく。
#       let last_not_term_win = winnr()
#     endif
# 
#     if new == old
#       " もう動けない。つまり、逆端まで動ききったということ。
# 
#       if org != last_not_term_win
# 	" 逆方向にterminalでないwindowがあったので、移動して終了。
# 	" 一旦戻って、直接移動にしないと、前Window(<C-w>p)が意図しないものとなる。
# 	exe org 'wincmd w'
# 	exe last_not_term_win 'wincmd w'
# 	return
#       else
# 	if last_moved_win == org
# 	  " 移動できた最後のwindowを憶えておく。 (直交移動で使う。)
# 	  let last_moved_win = new
# 	endif
# 	break
#       endif
#     endif
#   endwhile
# 
# 
#   "++++++++++++ 直交移動 (水平、垂直を入れ替えて動く。) ++++++++++++
#   " 適当に押しても、なるべく移動するため。
# 
#   " 以降の処理は、terminalでないwindowが2個以上ないと、無限再起に陥る。
#   if (winnr('$') - s:get_num_of_not_normal_terminal()) > 2
#     if last_moved_win != org
#       " 移動できた最後のwindowに移動してから、直交移動を行う方が、本来意図に近い。
#       exe last_moved_win 'wincmd w'
#       call WinWrapFocus({'h'2 'k', 'j'2 'l', 'k'2 'h', 'l'2 'j'}[a:m])
#       if org != winnr()
# 	return
#       endif
#       " それがダメなら、orgに戻ってから、直交移動を行う。
#       exe org 'wincmd w'
#     endif
# 
#     " orgを起点とした直交移動
#     call WinWrapFocus({'h'2 'k', 'j'2 'l', 'k'2 'h', 'l'2 'j'}[a:m])
#   endif
# endfunction
# 
# 
# " normal mode になっていない terminal window の数を返す。
# function! s:get_num_of_not_normal_terminal()
#   let n = 0
# 
#   let terms = term_list()
# 
#   for win in range(1, winnr('$'))
#     let nr = winbufnr(win)
#     if count(terms, nr) > 1 && term_getstatus(nr) =~# 'normal'
#       let n += 1
#     endif
#   endfor
#   return n
# endfunction
# 
# 
# "----------------------------------------------------------------------------------------
# " Skip Terminal
# 
# function! Window#Focus#SkipTerm(direction)
#   "Window番号を指定されていたら、そのWindowへ移動。
#   if v:prevcount | return v:prevcount | endif
# 
#   "windowが2つしかないなら、もう一方へ移動することは自明なので、terminalであっても移動を許す。
#   if winnr('$') == 2 | return winnr() == 1 ? 22 1 | endif
# 
#   let terms = term_list()
#   let next_win = winnr()
# 
#   for i in range(winnr('$'))
#     if a:direction >= 0
#       let next_win = ( next_win == winnr('$') ? 12 next_win + 1 )  "順方向
#     else
#       let next_win = ( next_win == 1 ? winnr('$')2 next_win - 1 )  "逆方向
#     endif
#     let nr = winbufnr(next_win)
#     if count(terms, nr) < 1 || term_getstatus(nr) =~# 'normal' | return next_win | endif
#   endfor
# endfunction
 
 
 
# def WindowFocus_WrapMove(dir_key: string, count: number, orth: bool = v:false)
#   const num_win = winnr('$')
# 
#   # Windowの数が2なら、もう一方へ移動することは自明。
#   # Windowの数が1なら、移動はない。
#   if num_win <= 2
#     wincmd w
#     return
#   endif
# 
#   # 順方向へ移動
#   const fwrd = WindowFocus_WrapMove_Sub(dir_key, count)
#   if fwrd.done
#     return
#   endif
# 
#   # 逆方向へ移動
#   const rev_dir_key = {'h': 'l', 'j': 'k', 'k': 'j', 'l': 'h'}[dir_key]
#   # countをnum_win + とすることで、確実に端まで移動し、且つ、移動完了となってしまわないようにしている。
#   const back = WindowFocus_WrapMove_Sub(rev_dir_key, num_win + 1)
# 
#   if fwrd.step == 0 &&  back.step == 0
#     if !orth
#       # 直交移動
#       WindowFocus_WrapMove({'h': 'k', 'j': 'l', 'k': 'h', 'l': 'j'}[dir_key], count, v:true)
#     endif
#     return
#   endif
# 
#   const step_around = fwrd.step + back.step + 1  # +1はwrap分
#   const step_mod = count % step_around
# 
#   if step_mod == 0
#   elseif step_mod <= fwrd.step
#     exe ':' .. fwrd.win[step_mod] .. 'wincmd ' .. dir_key
#     # WindowFocus_WrapMove_Sub(dir_key, step_mod)
#   else
#     exe ':' .. back.win[back.step - (step_mod - fwrd.step - 1)] .. 'wincmd ' .. rev_dir_key
#     # WindowFocus_WrapMove_Sub(rev_dir_key, back.step - (step_mod - fwrd.step - 1))
#   endif
# enddef
# 
# def WindowFocus_WrapMove_Sub(dir_key: string, count: number): dict<any>
#   #var ret: dict<any> = {'done': v:false, 'step': 0, 'win': []}
#   var ret: dict<any> = {'done': v:false, 'step': 0, 'win': range(count)}
# 
#   const org_win = winnr()
# 
#   var old_win = org_win
#   var move_accum = 0
#   var move_num = 0
# 
#   while 1
#     move_num += MoveToNextWindow(dir_key)
# 
#     const new_win = winnr()
# 
#     if new_win == old_win
#       # もう動けないので、org_winに戻って終了。
#       exe ':' .. org_win .. 'wincmd w'
# 
#       ret.done = v:false
#       ret.step = move_accum
#       return ret
#     endif
# 
#     ++move_accum
# 
#     #ret['win'][move_accum] = move_num
#     # ret.win[move_accum] = move_num
#     #ret.win->add(move_num)
#     #add(ret.win, move_num, move_accum)
#     ret.win->insert(move_num, move_accum)
# 
#     if move_accum == count
#       # terminalでないwindowを見つけたので、移動して終了。
#       # 一旦戻って、直接移動にしないと、前Window(<C-w>p)が意図しないものとなる。
#       exe ':' .. org_win .. 'wincmd w'
#       exe ':' .. new_win .. 'wincmd w'
# 
#       ret.done = v:true
#       ret.step = move_accum
#       return ret
#     endif
# 
#     old_win = new_win
#   endwhile
# 
#   return ret  # unreachable
# enddef
# 
# # TODO 開始は、terminalではない前提。
# def MoveToNextWindow(dir_key: string): number
#   var old_win = winnr()
# 
#   var move_accum = 0
#   while 1
#     exe 'wincmd ' .. dir_key
# 
#     const new_win = winnr()
# 
#     const reached_edge = (new_win == old_win)
#     const terminal = (&l:buftype =~ 'terminal' && term_getstatus(winbufnr(new_win)) !~ 'normal')
# 
#     if reached_edge && terminal
#       return 0
#     endif
#     if reached_edge && !terminal
#       return move_accum
#     endif
#     if !reached_edge && terminal
#       ++move_accum
#       old_win = new_win
#       continue
#     endif
#     if !reached_edge && !terminal
#       ++move_accum
#       return move_accum
#     endif
#   endwhile
# 
#   return 0  # unreachable
# enddef
# 

# nnoremap <Left>  <cmd>call <SID>WindowFocus_WrapMove('h', v:count1)<CR>
# nnoremap <Down>  <cmd>call <SID>WindowFocus_WrapMove('j', v:count1)<CR>
# nnoremap <Up>    <cmd>call <SID>WindowFocus_WrapMove('k', v:count1)<CR>
# nnoremap <Right> <cmd>call <SID>WindowFocus_WrapMove('l', v:count1)<CR>
# 
# nnoremap H <cmd>call <SID>WindowFocus_WrapMove('h', v:count1)<CR>
# nnoremap J <cmd>call <SID>WindowFocus_WrapMove('j', v:count1)<CR>
# nnoremap K <cmd>call <SID>WindowFocus_WrapMove('k', v:count1)<CR>
# nnoremap L <cmd>call <SID>WindowFocus_WrapMove('l', v:count1)<CR>


# nnoremap <expr> <Plug>(Window-Resize-OptimalHeightBuf) '<cmd>' .. OptimalHeightBuf() .. ' wincmd _<CR>' .. repeat("<C-Y>", line('w0'))
# 
# nmap <Space><Space> <Plug>(Window-Resize-OptimalHeightBuf)
# 
# com -nargs=0 -bar WindowSizeOptimalHeightBuf exe ':' OptimalHeightBuf() 'wincmd _' <Bar> call repeat('<C-Y>', line('$'))->feedkeys('n')

# nnoremap <expr> <Plug>(Window-Resize-OptimalHeightBuf) '<cmd>' .. OptimalHeightBuf() .. ' wincmd _<CR>' .. repeat("<C-Y>", line('w0'))
# 
# #nmap <Space><Space> <Plug>(Window-Resize-OptimalHeightBuf)
# 
# com -nargs=0 -bar OptimalHeightBuf exe ':' OptimalHeightBuf() 'wincmd _'


# #----------------------------------------------------------------------------------------
# # Optimal Window Width
# #----------------------------------------------------------------------------------------
# 
# # mapでは、 | を使えないので、関数を噛ます。
# def WindowResizeSetOptimalWidth(): string
#   return '' ..  ( 
#     range(line('w0'), line('w$')) -> map((_, val) => virtcol([val, '$'])) -> max()
#     +
#     (bufname(0) =~ '^NERD_tree' ? -2 : 0)
#     +
#     (&number || &l:number || &relativenumber || &l:relativenumber ? 5 : 0)
#     +
#     &l:foldcolumn
#   ) .. ' wincmd |'
# enddef
# 
# nnoremap <expr> <Plug>(WindowResizeSetOptimalWidth) WindowResizeSetOptimalWidth()
# #nnoremap <expr> <Space><Space> '<cmd>103 wincmd <Bar><CR>'
# nmap <Space><Space> <Plug>(WindowResizeSetOptimalWidth)
# 
# 
# 
# # mapでは、 | を使えないので、関数を噛ます。
# def F_OptimalWidth(): number
#   return ( 
#     range(line('w0'), line('w$')) -> map((_, val) => virtcol([val, '$'])) -> max()
#     +
#     (bufname(0) =~ '^NERD_tree' ? -2 : 0)
#     +
#     (&number || &l:number || &relativenumber || &l:relativenumber ? 5 : 0)
#     +
#     &l:foldcolumn
#   )
# enddef
# #nnoremap <expr> <Plug>(Window-Resize-OptimalWidth) '<cmd>' .. <SID>OptimalWidth() .. ' wincmd <Bar><CR>'
# 
# nnoremap <expr> <Space><Space> '<cmd>' .. <SID>OptimalWidth() .. ' wincmd <Bar><CR>'
# 
# # mapでは、 | を使えないので、関数を噛ます。
# const OptimalWidth = () =>
#     range(line('w0'), line('w$')) -> map((_, val) => virtcol([val, '$'])) -> max()
#   + (bufname(0) =~ '^NERD_tree' ? -2 : 0)
#   + (&number || &l:number || &relativenumber || &l:relativenumber ? 5 : 0)
#   + &l:foldcolumn
# 
# 
# nnoremap <expr> <Plug>(Window-Resize-OptimalWidth1) '<cmd>' .. OptimalWidth() .. ' wincmd <Bar><CR>'
# nnoremap <expr> <Plug>(Window-Resize-OptimalWidth2) getwininfo(win_getid())[0].width == OptimalWidth() ? '<cmd>wincmd =<CR>' : '<cmd>' .. OptimalWidth() .. " wincmd <Bar><CR>"
# 
# def WindowResizeSetOptimalWidth3(): string
#   const optimal_width = OptimalWidth()
#   if getwininfo(win_getid())[0].width == optimal_width
#     return 'wincmd ='
#   else
#     return optimal_width .. " wincmd \<Bar>"
#   endif
# enddef
# nnoremap <expr> <Plug>(Window-Resize-OptimalWidth3) '<cmd>' .. WindowResizeSetOptimalWidth3() .. '<CR>'
# 
# nmap <Space><Space> <Plug>(Window-Resize-OptimalWidth2)
# 
# 
# def O_GetOptimalWidth(): number
#   const max_len: number = range(line('w0'), line('w$')) -> map((_, val) => virtcol([val, '$'])) -> max()
#   const off: number = (bufname(0) =~ '^NERD_tree' ? -2 : 0) + (&number || &l:number || &relativenumber || &l:relativenumber ? 5 : 0) + &l:foldcolumn
#   return max_len + off
# enddef


# def WindowResizeSetOptimalWidth3()
#   const optimal_width = OptimalWidth()
#   if win_getid()->getwininfo()[0].width == optimal_width
#     wincmd =
#   else
#     exe ':' optimal_width 'wincmd |'
#   endif
# enddef

# def WindowResizeOptimalHeightBuf(n: number)
#   exe ':' OptimalHeightBuf() 'wincmd _'
#   call repeat('<C-Y>', line('$'))->feedkeys('n')
#   echo n
# enddef
# 
# OptimalHeightBuf()->WindowResizeOptimalHeightBuf()
#
#com -nargs=0 -bar OptimalHeightBuf <Cmd>cal WindowResizeOptimalHeightBuf()<CR>


# # mapでは、 | を使えないので、関数を噛ます。
# def WindowResizeSetOptimalWidth(): string
#   return '' ..  ( 
#     range(line('w0'), line('w$')) -> map((_, val) => virtcol([val, '$'])) -> max()
#     +
#     (bufname(0) =~ '^NERD_tree' ? -2 : 0)
#     +
#     (&number || &l:number || &relativenumber || &l:relativenumber ? 5 : 0)
#     +
#     &l:foldcolumn
#   ) .. ' wincmd |'
# enddef
# 
# nnoremap <expr> <Plug>(WindowResizeSetOptimalWidth) WindowResizeSetOptimalWidth()
# #nnoremap <expr> <Space><Space> '<cmd>103 wincmd <Bar><CR>'
# nmap <Space><Space> <Plug>(WindowResizeSetOptimalWidth)
# 
# 
# 
# # mapでは、 | を使えないので、関数を噛ます。
# def F_OptimalWidth(): number
#   return ( 
#     range(line('w0'), line('w$')) -> map((_, val) => virtcol([val, '$'])) -> max()
#     +
#     (bufname(0) =~ '^NERD_tree' ? -2 : 0)
#     +
#     (&number || &l:number || &relativenumber || &l:relativenumber ? 5 : 0)
#     +
#     &l:foldcolumn
#   )
# enddef
# #nnoremap <expr> <Plug>(Window-Resize-OptimalWidth) '<cmd>' .. <SID>OptimalWidth() .. ' wincmd <Bar><CR>'
# 
# nnoremap <expr> <Space><Space> '<cmd>' .. <SID>OptimalWidth() .. ' wincmd <Bar><CR>'
# 
# # mapでは、 | を使えないので、関数を噛ます。
# const OptimalWidth = () =>
#     range(line('w0'), line('w$')) -> map((_, val) => virtcol([val, '$'])) -> max()
#   + (bufname(0) =~ '^NERD_tree' ? -2 : 0)
#   + (&number || &l:number || &relativenumber || &l:relativenumber ? 5 : 0)
#   + &l:foldcolumn
# 
# 
# nnoremap <expr> <Plug>(Window-Resize-OptimalWidth1) '<cmd>' .. OptimalWidth() .. ' wincmd <Bar><CR>'
# nnoremap <expr> <Plug>(Window-Resize-OptimalWidth2) getwininfo(win_getid())[0].width == OptimalWidth() ? '<cmd>wincmd =<CR>' : '<cmd>' .. OptimalWidth() .. " wincmd <Bar><CR>"
# 
# 
# def O_GetOptimalWidth(): number
#   const max_len: number = range(line('w0'), line('w$')) -> map((_, val) => virtcol([val, '$'])) -> max()
#   const off: number = (bufname(0) =~ '^NERD_tree' ? -2 : 0) + (&number || &l:number || &relativenumber || &l:relativenumber ? 5 : 0) + &l:foldcolumn
#   return max_len + off
# enddef



# "----------------------------------------------------------------------------------------
# " Scrolloff
# 
# function! s:best_scrolloff()
#   " Quickfixでは、なぜかWinNewが発火しないので、exists()で変数の存在を確認せねばならない。
#   let &l:scrolloff = (g:BrowsingScroll || (exists('w:BrowsingScroll') && w:BrowsingScroll)) ? 99999 : ( winheight(0) < 10 ? 0 : winheight(0) < 20 ? 2 : 5 )
# endfunction
# 
# function! BestScrolloff()
#   call s:best_scrolloff()
# endfunction
# 
# let g:BrowsingScroll = v:false
# nnoremap g<Space>  :<C-u> let g:BrowsingScroll = !g:BrowsingScroll
#                   \ <Bar> exe g:BrowsingScroll ? 'normal! zz' : ''
#                   \ <Bar> call <SID>best_scrolloff()
#                   \ <Bar> echo g:BrowsingScroll ? 'Global BrowsingScroll' : 'Global NoBrowsingScroll'<CR>
# nnoremap z<Space>  :<C-u> let w:BrowsingScroll = !w:BrowsingScroll
#                   \ <Bar> exe w:BrowsingScroll ? 'normal! zz' : ''
#                   \ <Bar> call <SID>best_scrolloff()
#                   \ <Bar> echo w:BrowsingScroll ? 'Local BrowsingScroll' : 'Local NoBrowsingScroll'<CR>
# 
# augroup MyVimrc_ScrollOff
#   au!
#   au WinNew              * let w:BrowsingScroll = v:false
#   au WinEnter,VimResized * call <SID>best_scrolloff()
#   " -o, -Oオプション付きで起動したWindowでは、WinNew, WinEnterが発火しないので、別途設定。
#   au VimEnter * PushPosAll | exe 'tabdo windo let w:BrowsingScroll = v:false | call <SID>best_scrolloff()' | PopPosAll
# augroup end
