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

# Wrap Focus
nnoremap <Plug>(Window-Focus-WrapMove-h) <cmd>call <SID>WindowFocus_WrapMove('h', v:count1)<CR>
nnoremap <Plug>(Window-Focus-WrapMove-j) <cmd>call <SID>WindowFocus_WrapMove('j', v:count1)<CR>
nnoremap <Plug>(Window-Focus-WrapMove-k) <cmd>call <SID>WindowFocus_WrapMove('k', v:count1)<CR>
nnoremap <Plug>(Window-Focus-WrapMove-l) <cmd>call <SID>WindowFocus_WrapMove('l', v:count1)<CR>


# Optimal Width
com! -nargs=0 -bar WindowResizeOptimalWidth call <SID>WindowResizeOptimalWidth()
nnoremap <Plug>(Window-Resize-OptimalWidth) <cmd>>WindowResizeOptimalWidth<CR>

# Toggle `Optimal Width' <=> `Equal Width'
com! -nargs=0 -bar WindowResizeToggleOptimalWidthEqual call <SID>WindowResizeToggleOptimalWidthEqual()
nnoremap <Plug>(Window-Resize-Toggle-OptimalWidth-Equal) <Cmd>WindowResizeToggleOptimalWidthEqual<CR>

# Optimal Height (Buf)
com! -nargs=0 -bar OptimalHeightBuf call WindowResizeOptimalHeightBuf()
nnoremap <Plug>(Window-Resize-OptimalHeight-Buf) <cmd>OptimalHeightBuf<CR>


# Equal Only Height
com! -nargs=0 -bar WindowSizeEqualOnlyHeight vertical wincmd =
nnoremap <Plug>(Window-Resize-EqualOnlyHeight) <Cmd>vertical   wincdmd =<CR>

# Equal Only Width
com! -nargs=0 -bar OptimalWindowWidth horizontal wincmd =
nnoremap <Plug>(Window-Resize-EqualOnlyWidth)  <Cmd>horizontal wincdmd =<CR>


# All Windows wOptimal Width
com! -nargs=0 -bar AllWinOptimalWidth    {
      var cur_win = winnr()
      windo WindowResizeOptimalWidth
      exe ':' cur_win 'wincmd w'
    }

com! -nargs=0 -bar AllWinOptimalWidthRev {
      var cur_win = winnr()
      for i in reverse(range(1, winnr('$'))) | exe ':' i 'wincmd w' | WindowResizeOptimalWidth | endfor
      exe ':' cur_win 'wincmd w'
    }



#----------------------------------------------------------------------------------------
# Window Ratio
#----------------------------------------------------------------------------------------

# 横長なほど、大きい値が返る。
# 正方形は、 w:h = 178:78 の想定
export def WindowRatio(): float
  const h = winheight(0) + 0.0
  const w =  winwidth(0) + 0.0
  return (w / h - 178.0 / 78.0)
enddef

#       Vert Split すべきとき、正数が返る。
# Horizontal Split すべきとき、負数が返る。
export def SplitDirection(): number
  return ( winwidth(0) > (&columns * 7 / 10) && <SID>WindowRatio() >= 0 ) ? 9999 : -9999
enddef

#       Vert Split すべきとき、'v'が返る。
# Horizontal Split すべきとき、's'が返る。
export def SplitDirectionStr(): string
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

  pui.PopUpInfoM([
    TypewriterScroll ?   'Global    TypewriterScroll' : 'Global No TypewriterScroll',
    '',
    w:TypewriterScroll ? 'Local     TypewriterScroll' : 'Local  No TypewriterScroll'
  ], 2000)
enddef

nnoremap z<Space> <ScriptCmd>call ToggleTypewriterScroll(v:true)<CR>
nnoremap g<Space> <ScriptCmd>call ToggleTypewriterScroll(v:false)<CR>




#----------------------------------------------------------------------------------------
# RC
#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------

# Focus Wrap Move
# Optimal Window Width
# Optimal Window Height

# Trigger
# Split & New
# Close
# Focus
# Resize
# Move

# Reopen as Tab
# Tab (New, Open)
# Tab (close)
# Tab (focus)
# Tab (move)

# Tab (Window Container)

# Window Ratio

# Best Scrolloff
# Typewriter Scroll

# WinCmd <Plug>


import autoload '../impauto/window_ratio.vim' as wr


#----------------------------------------------------------------------------------------
# Initialize

set noequalalways

#set tabclose=uselast,left


#----------------------------------------------------------------------------------------
# Trigger

nmap <BS> <C-W>
nmap <C-J> <C-W>


#----------------------------------------------------------------------------------------
# Split & New

nnoremap  _     <C-W>s<Cmd>diffoff <Bar> setl noscrollbind<CR>
nnoremap g_     <C-W>n

nnoremap  <Bar> <C-W>v<Cmd>diffoff <Bar> setl noscrollbind<CR>
nnoremap g<Bar> <Cmd>vnew<CR>

# Auto Optimal Ratio Split
#nnoremap <expr> <Plug>(MyVimrc-Window-AutoSplit)     ( wr.WindowRatio() >= 0 ? '<C-W>v' : '<C-W>s' ) .. '<Cmd>diffoff<CR>'
#nnoremap <expr> <Plug>(MyVimrc-Window-AutoSplit-Rev) ( wr.WindowRatio() <  0 ? '<C-W>v' : '<C-W>s' ) .. '<Cmd>diffoff<CR>'

#nmap <BS><BS>         <Plug>(MyVimrc-Window-AutoSplit)
#nmap <Leader><Leader> <Plug>(MyVimrc-Window-AutoSplit)

nnoremap <expr> <Plug>(MyVimrc-Window-AutoSplit)          ( '<C-W>' .. wr.SplitDirectionStr() >= 0 ? ) .. '<Cmd>diffoff <Bar> setl noscrollbind<CR>'
nnoremap <expr> <Plug>(MyVimrc-Window-AutoSplit-Rev)      ( '<C-W>' .. wr.SplitDirectionStr() <  0 ? ) .. '<Cmd>diffoff <Bar> setl noscrollbind<CR>'

nnoremap <expr> <Plug>(MyVimrc-Window-AutoSplit-Dumb)     ( wr.WindowRatio() >= 0 ? '<C-W>v' : '<C-W>s' ) .. '<Cmd>diffoff <Bar> setl noscrollbind<CR>'
nnoremap <expr> <Plug>(MyVimrc-Window-AutoSplit-Rev-Dumb) ( wr.WindowRatio() <  0 ? '<C-W>v' : '<C-W>s' ) .. '<Cmd>diffoff <Bar> setl noscrollbind<CR>'

nmap <BS><BS>         <Plug>(MyVimrc-Window-AutoSplit-Dumb)
#nmap <Leader><Leader> <Plug>(MyVimrc-Window-AutoSplit-Rev-Dumb)

# Auto Optimal Ratio New
nnoremap <expr> <Plug>(MyVimrc-Window-AutoNew) (winwidth(0) > (&columns * 7 / 10) && wr.WindowRatio() >=  0) ? '<Cmd>vnew<CR>' : '<C-W>n'
nmap M <Plug>(MyVimrc-Window-AutoNew)
#nmap U <Plug>(MyVimrc-Window-AutoNew)


#----------------------------------------------------------------------------------------
# Close

# TODO NERDTreeも閉じられるようにする。
# nnoremap q  <C-W>c
nnoremap gq <C-W>c

# 補償
nnoremap <C-q> q
# <C-q>: => q
# <C-q>: => q:
# <C-q>/ => q/
# <C-q>? => q?

# コマンドラインへの遷移に合わせる
nnoremap <C-q>; q:


#----------------------------------------------------------------------------------------
# Focus

# Direction Focus
nmap <Left>  <Plug>(Window-Focus-WrapMove-h)
nmap <Down>  <Plug>(Window-Focus-WrapMove-j)
nmap <Up>    <Plug>(Window-Focus-WrapMove-k)
nmap <Right> <Plug>(Window-Focus-WrapMove-l)

nmap H <Plug>(Window-Focus-WrapMove-h)
nmap J <Plug>(Window-Focus-WrapMove-j)
nmap K <Plug>(Window-Focus-WrapMove-k)
nmap L <Plug>(Window-Focus-WrapMove-l)

# vnoremap H <C-W>h
# vnoremap J <C-W>j
# vnoremap K <C-W>k
# vnoremap L <C-W>l

# 便利化
#let g:WinFocusThresh = 5
#nmap <expr> J winnr('$') >= g:WinFocusThresh ? '<Plug>(Window-Focus-WrapMove-j)' : '<Plug>(Window-Focus-SkipTerm-Inc)'
#nmap <expr> K winnr('$') >= g:WinFocusThresh ? '<Plug>(Window-Focus-WrapMove-k)' : '<Plug>(Window-Focus-SkipTerm-Dec)'

# 便利化 (数値指定対応)
#nmap <expr> J v:prevcount ? '<Esc>' . v:prevcount . '<C-w>w' : winnr('$') > g:WinFocusThresh ? '<Plug>(Window-Focus-WrapMove-j)' : '<Plug>(Window-Focus-SkipTerm-Inc)'
#nmap <expr> K v:prevcount ? '<Esc>' . v:prevcount . '<C-w>w' : winnr('$') > g:WinFocusThresh ? '<Plug>(Window-Focus-WrapMove-k)' : '<Plug>(Window-Focus-SkipTerm-Dec)'


#----------------------------------------------------------------------------------------
# Focus (補償)

#--------------------------------------------
# Join

nnoremap m   J
nnoremap gm gJ
vnoremap m   J
vnoremap gm gJ

# noremap M   J
# noremap gM gJ

# nnoremap U   J
# nnoremap gU gJ

# nnoremap  <C-J>  J
# nnoremap g<C-J> gJ

#--------------------------------------------
# H, M, L

nnoremap <Leader>H H
nnoremap <Leader>M M
nnoremap <Leader>L L

# nnoremap gM M
# nnoremap gH H
# nnoremap gL L

# noremap zH H
# noremap zL L
# noremap zM M


#----------------------------------------------------------------------------------------
# Window Move

# ウィンドウを上端、下端に動かすと、ウィンドウ高さが最大になってしまうことの対策を入れている。
# <C-W>J, <C-K>で、'horizontal wincmd ='が走ってしまうことの対策にもなっている。
# これらの挙動はhelpの記述tと食い違うので、バグかもしれない？ TODO 
#
# 対策方法としては、ウィンドウを移動させるのではなく、
#   ・「splitiで開き直して、旧ウィンドウを閉じる」
# ということをしている。

#nnoremap <expr> <Plug>(MyVimrc-Window-Move-H) '<Cmd>vert topleft  split<Bar>exe win_id2win(' .. win_getid() .. ') "wincmd c"<CR>'
nnoremap        <Plug>(MyVimrc-Window-Move-H)  <C-W>H<CR>
nnoremap <expr> <Plug>(MyVimrc-Window-Move-J) '<Cmd>botright split<Bar>exe win_id2win(' .. win_getid() .. ') "wincmd c"<CR>'
#nnoremap <expr> <Plug>(MyVimrc-Window-Move-J) '<Cmd>botright split<Bar>exe win_id2win(' .. win_getid() .. ') "wincmd c"<CR>' .. '<Cmd>vertical wincmd =<CR>'
nnoremap <expr> <Plug>(MyVimrc-Window-Move-K) '<Cmd>topleft  split<Bar>exe win_id2win(' .. win_getid() .. ') "wincmd c"<CR>'
#nnoremap <expr> <Plug>(MyVimrc-Window-Move-K) '<Cmd>topleft  split<Bar>exe win_id2win(' .. win_getid() .. ') "wincmd c"<CR>' .. '<Cmd>vertical wincmd =<CR>'
#nnoremap <expr> <Plug>(MyVimrc-Window-Move-L) '<Cmd>vert botright split<Bar>exe win_id2win(' .. win_getid() .. ') "wincmd c"<CR>'
nnoremap        <Plug>(MyVimrc-Window-Move-L)  <C-W>L<CR>

nmap <A-h> <Plug>(MyVimrc-Window-Move-H)
nmap <A-j> <Plug>(MyVimrc-Window-Move-J)
nmap <A-k> <Plug>(MyVimrc-Window-Move-K)
nmap <A-l> <Plug>(MyVimrc-Window-Move-L)

nmap <Left>  <Plug>(MyVimrc-Window-Move-H)
nmap <Down>  <Plug>(MyVimrc-Window-Move-J)
nmap <Up>    <Plug>(MyVimrc-Window-Move-K)
nmap <Right> <Plug>(MyVimrc-Window-Move-L)

nmap <C-W>h <Plug>(MyVimrc-Window-Move-H)
nmap <C-W>j <Plug>(MyVimrc-Window-Move-J)
nmap <C-W>k <Plug>(MyVimrc-Window-Move-K)
nmap <C-W>l <Plug>(MyVimrc-Window-Move-L)

nmap <C-W>H <Plug>(MyVimrc-Window-Move-H)
nmap <C-W>J <Plug>(MyVimrc-Window-Move-J)
nmap <C-W>K <Plug>(MyVimrc-Window-Move-K)
nmap <C-W>L <Plug>(MyVimrc-Window-Move-L)


#----------------------------------------------------------------------------------------
# Resize

#--------------------------------------------
# 漸次

nnoremap <C-H> <C-W>+
nnoremap <C-L> <C-W>-
nnoremap (     <C-W>3<
nnoremap )     <C-W>3>

#--------------------------------------------
# 補償
nnoremap <silent> <A-o> <C-l>

#--------------------------------------------
# 最大化・最小化・最適化

# 最大高さ
nnoremap g<C-h> <C-w>_
# 最小最適高さ
nmap     g<C-l> <Plug>(Window-Resize-OptimalHeight-Buf)
# 最大幅
nnoremap g)     <C-w>|
# 最小最適幅
nmap     g(     <Plug>(Window-Resize-OptimalWidth)

# 最大高さ
#nnoremap g<C-j> <C-W>_
# 最小高さ
#nnoremap g<C-k> 1<C-W>_
# 最小幅
#nnoremap g<C-h> 1<C-W>|
# 最大幅
#nnoremap g<C-l> <C-W>|

#nmap @ <Plug>(Window-Resize-EqualOnlyWidth)
#nmap @ <Plug>(Window-Resize-EqualOnlyHeight)

nmap <Leader><Leader> <Plug>(Window-Resize-Toggle-OptimalWidth-Equal)
nmap <Leader><BS>     <Plug>(Window-Resize-OptimalHeight-Buf)

#--------------------------------------------
# Submode Window Resize
if 0
  call submode#enter_with('WinResize', 'n', '', '<Space>l', '<C-w>>')
  call submode#enter_with('WinResize', 'n', '', '<Space>h', '<C-w><')
  call submode#enter_with('WinResize', 'n', '', '<Space>j', '<C-w>+')
  call submode#enter_with('WinResize', 'n', '', '<Space>k', '<C-w>-')

  call submode#map(       'WinResize', 'n', '', 'l', '<C-w>>')
  call submode#map(       'WinResize', 'n', '', 'h', '<C-w><')
  call submode#map(       'WinResize', 'n', '', 'j', '<C-w>+')
  call submode#map(       'WinResize', 'n', '', 'k', '<C-w>-')

  legacy let g:submode_timeoutlen = 5000
endif


#----------------------------------------------------------------------------------------
# <Plug> (他機能での再帰マップ用)

nnoremap <Plug>(MyVimrc-WinCmd-p) <C-w>p


#----------------------------------------------------------------------------------------
# Reopen as Tab

# TODO diffのバッファも再現する。

# nnoremap <C-w><C-w> :<C-u>tab split<CR>

nnoremap <Plug>(MyVimrc-Window-TabSplit) <Cmd>tab split <Bar> diffoff<CR>
nmap     <C-W><C-W> <Plug>(MyVimrc-Window-TabSplit)
# nmap     <Leader><Leader> <Plug>(MyVimrc-Window-TabSplit)
# nmap     <C-T> <Plug>(MyVimrc-Window-TabSplit)

nnoremap <C-W><C-T> <C-W>T
nnoremap <C-W>T     <C-W>T

# nmap     t <Plug>(MyVimrc-Window-TabSplit)
# nnoremap T <C-w>T


#----------------------------------------------------------------------------------------
# Tab (Window Container)

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
# Terminal

# Escape Terminal
# Windowから抜ける。 (Windowが１つしかないなら、Tabから抜ける。)
tnoremap <expr> <C-Tab>    winnr('$') == 1 ? '<C-W>:tabNext<CR>' : '<C-W>p'
tnoremap <expr> <C-T>      winnr('$') == 1 ? '<C-W>:tabNext<CR>' : '<C-W>p'
tnoremap <expr> <C-W><C-W> winnr('$') == 1 ? '<C-W>:tabNext<CR>' : '<C-W>p'
tnoremap <expr> <C-W><C-T> winnr('$') == 1 ? '<C-W>:tabNext<CR>' : '<C-W>p'

# Direction Focus (Terminal)
#tnoremap <S-Left>  <C-w>h
#tnoremap <S-Down>  <C-w>j
#tnoremap <S-Up>    <C-w>k
#tnoremap <S-Right> <C-w>l

# Reopen as Tab
tnoremap <C-W><C-T> <C-W>T
tnoremap <C-W>T     <C-W>T

# terminal
tnoremap <C-Up>    <C-W>+
tnoremap <C-Down>  <C-W>-
tnoremap <C-Left>  <C-W><
tnoremap <C-Right> <C-W>>
