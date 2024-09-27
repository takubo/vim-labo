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

# nnoremap gH H
# nnoremap gM M
# nnoremap gL L



