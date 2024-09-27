vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 expandtab

scriptencoding utf-8

#----------------------------------------------------------------------------------------
# Focus Wrap Move
#----------------------------------------------------------------------------------------

def WindowFocus_WrapMove(dir_key: string, count: number, orth: bool = v:false): void
  # {{{ optimize
  if count == 1
    const cur_win = winnr()
    exe 'wincmd ' .. dir_key
    const new_win = winnr()
    if cur_win != new_win
      const terminal = (&l:buftype =~ 'terminal' && term_getstatus(winbufnr(new_win)) !~ 'normal')
      if !terminal
	return
      endif
    endif
  endif
  # }}} optimize

  const num_win = winnr('$')

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
      WindowFocus_WrapMove({'h': 'k', 'j': 'l', 'k': 'h', 'l': 'j'}[dir_key], count, v:true)
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
  #var ret: dict<any> = {'done': v:false, 'step': 0, 'win': []}
  var ret: dict<any> = {'done': v:false, 'step': 0, 'win': range(count)}

  const org_win = winnr()

  var old_win = org_win
  var move_accum = 0
  var move_num = 0

  while 1
    move_num += MoveToNextWindow(dir_key)

    const new_win = winnr()

    if new_win == old_win
      # もう動けないので、org_winに戻って終了。
      exe ':' .. org_win .. 'wincmd w'

      ret.done = v:false
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

      ret.done = v:true
      ret.step = move_accum
      return ret
    endif

    old_win = new_win
  endwhile

  return ret  # unreachable
enddef

# TODO 開始は、terminalではない前提。
def MoveToNextWindow(dir_key: string): number
  var old_win = winnr()
  var move_accum = 0

  while true
    exe 'wincmd ' .. dir_key

    const new_win = winnr()

    const terminal = (&l:buftype =~ 'terminal' && term_getstatus(winbufnr(new_win)) !~ 'normal')

    if new_win == old_win
      # 端まで移動していた
      return (terminal ? 0 : move_accum)
    endif

    ++move_accum

    if !terminal
      return move_accum
    endif

    old_win = new_win
  endwhile

  return 0  # unreachable
enddef

defcompile

nnoremap <Left>  <cmd>call <SID>WindowFocus_WrapMove('h', v:count1)<CR>
nnoremap <Down>  <cmd>call <SID>WindowFocus_WrapMove('j', v:count1)<CR>
nnoremap <Up>    <cmd>call <SID>WindowFocus_WrapMove('k', v:count1)<CR>
nnoremap <Right> <cmd>call <SID>WindowFocus_WrapMove('l', v:count1)<CR>

nnoremap H <cmd>call <SID>WindowFocus_WrapMove('h', v:count1)<CR>
nnoremap J <cmd>call <SID>WindowFocus_WrapMove('j', v:count1)<CR>
nnoremap K <cmd>call <SID>WindowFocus_WrapMove('k', v:count1)<CR>
nnoremap L <cmd>call <SID>WindowFocus_WrapMove('l', v:count1)<CR>


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
