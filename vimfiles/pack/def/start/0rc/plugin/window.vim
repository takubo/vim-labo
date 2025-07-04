vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 expandtab
scriptencoding utf-8


#----------------------------------------------------------------------------------------
# Focus Wrap Move
#----------------------------------------------------------------------------------------

const NotTerminal = (win: number): bool => {
  const bufnr = winbufnr(win)
  return getbufvar(bufnr, '&l:buftype') !~ 'terminal' || term_getstatus(bufnr) =~ 'normal'
}

export def WindowFocus_WrapMove(dir_key: string, count: number): void
  const cur_win = winnr()

  # {{{ optimize
  if count == 1
    const new_win = winnr(dir_key)
    if (cur_win != new_win) && NotTerminal(new_win)
      exe 'wincmd ' .. dir_key
      return
    endif
  endif
  # }}} optimize

  const num_win = winnr('$')  # Windowの数

  # 順方向へ移動した場合の情報を収集 & 順方向へ移動
  const fwrd_wins = range(1, num_win) -> map((_, v) => winnr(v .. dir_key)) -> filter((_, v) => NotTerminal(v))
  const fwrd_last_win = fwrd_wins[-1]

  var fwrd_wins_new = []
  if fwrd_last_win != cur_win
    const fwrd_idx = fwrd_wins ->  indexof((_, v) => v == fwrd_last_win)
    if count - 1 <= fwrd_idx
      # 順方向へ移動
      exe ':' .. fwrd_wins[count - 1] .. 'wincmd w'
      return
    endif
    fwrd_wins_new = fwrd_wins[0 : fwrd_idx]
  endif

  # 逆方向へ移動した場合の情報を収集
  const rev_dir_key = {'h': 'l', 'j': 'k', 'k': 'j', 'l': 'h'}[dir_key]

  const back_wins = range(1, num_win) -> map((_, v) => winnr(v .. rev_dir_key)) -> filter((_, v) => NotTerminal(v))
  const back_last_win = back_wins[-1]

  var back_wins_new = []
  if back_last_win != cur_win
    const back_idx = back_wins ->  indexof((_, v) => v == back_last_win)
    back_wins_new = back_wins[0 : back_idx]
  endif

  const sum_len = len(fwrd_wins_new) + len(back_wins_new) + 1  # + 1は、カレントウィンドウの分
  const count_pure = count % sum_len

  if count_pure == 0
    # カレントウィンドウに留まる
    return
  endif

  if count_pure <= len(fwrd_wins_new)
    # 順方向へ移動
    exe ':' .. fwrd_wins_new[count_pure - 1] .. 'wincmd w'
    return
  endif

  # 逆方向へ移動
  exe ':' .. back_wins_new[-(count_pure - len(fwrd_wins_new))] .. 'wincmd w'
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
    horizontal wincmd =
    # wincmd =
  else
    exe ':' optimal_width 'wincmd |'
  endif
enddef


#----------------------------------------------------------------------------------------
# Optimal Window Height
#----------------------------------------------------------------------------------------

# TODO wrapされた行の考慮も必要。
const OptimalHeightBuf        = (): dict<number> => {
  return {height: line('$') + 2, top_line: 1}  # 2に根拠はない。
}

# TODO この下の関数をλにすると、ロード時に評価されて、PushPosが未定義のエラーになる。
# TODO const OptimalHeightFunction = (): dict<number> => {
def OptimalHeightFunction(): dict<number>
  # TODO normalに!を付けると、飛び先がおかしくなる。
  #const cur_line = line('.')
  PushPos
  normal [[
  const f_top = line('.')
  normal ][
  const f_bot = line('.')
  PopPos
  return {height: f_bot - f_top + 2 + &l:scrolloff, top_line: max([f_top, 1])}  # 2に根拠はない。
enddef
# const OptimalHeightBlock    = (): dict<number> => 10
# const OptimalHeightIfBlock  = (): dict<number> => 10

def WindowResizeOptimalHeight(arg: dict<number>)
  echo arg
  const cur_line = line('.')
  exe ':' arg.height 'wincmd _'
  exe 'normal! ' .. arg.top_line .. "z\<CR>" .. cur_line .. 'G'
  #exe 'normal! ' .. arg.top_line .. 'z' .. arg.height .. "\<CR>"
  #call repeat("\<C-Y>", line('$'))->feedkeys('n')
enddef

export const WindowResizeOptimalHeightBuf        = () => OptimalHeightBuf()->WindowResizeOptimalHeight()
# TODO この下の行を実行すると、OptimalHeightFunction()が評価されていまって、「PushPosが未定義エラー」となる。
# TODO export const WindowResizeOptimalHeightFunction = () => OptimalHeightFunction()->WindowResizeOptimalHeight()
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

# Optimal Height (Function)
com! -nargs=0 -bar OptimalHeightFunction call WindowResizeOptimalHeightFunction()
nnoremap <Plug>(Window-Resize-OptimalHeight-Function) <cmd>OptimalHeightFunction<CR>


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


import autoload 'window_ratio.vim' as wr


#----------------------------------------------------------------------------------------
# Initialize
#----------------------------------------------------------------------------------------

set noequalalways

#set tabclose=uselast,left


#----------------------------------------------------------------------------------------
# Trigger
#----------------------------------------------------------------------------------------

nmap <BS> <C-W>
nmap <C-J> <C-W>


#----------------------------------------------------------------------------------------
# Split & New
#----------------------------------------------------------------------------------------

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
#----------------------------------------------------------------------------------------

# TODO NERDTreeも閉じられるようにする。
nnoremap q  <C-W>c
# nnoremap gq <C-W>c

# 補償
# nnoremap <C-Q> q
# <C-Q>: => q
# <C-Q>: => q:
# <C-Q>/ => q/
# <C-Q>? => q?

# コマンドラインへの遷移に合わせる
nnoremap <C-Q>; q:


#----------------------------------------------------------------------------------------
# Focus
#----------------------------------------------------------------------------------------

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
#nmap <expr> J v:prevcount ? '<Esc>' . v:prevcount . '<C-W>w' : winnr('$') > g:WinFocusThresh ? '<Plug>(Window-Focus-WrapMove-j)' : '<Plug>(Window-Focus-SkipTerm-Inc)'
#nmap <expr> K v:prevcount ? '<Esc>' . v:prevcount . '<C-W>w' : winnr('$') > g:WinFocusThresh ? '<Plug>(Window-Focus-WrapMove-k)' : '<Plug>(Window-Focus-SkipTerm-Dec)'


#----------------------------------------------------------------------------------------
# Focus (補償)
#----------------------------------------------------------------------------------------

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
#----------------------------------------------------------------------------------------

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

nmap <A-H> <Plug>(MyVimrc-Window-Move-H)
nmap <A-J> <Plug>(MyVimrc-Window-Move-J)
nmap <A-K> <Plug>(MyVimrc-Window-Move-K)
nmap <A-L> <Plug>(MyVimrc-Window-Move-L)

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

nnoremap <C-W>h <C-W>H
nnoremap <C-W>j <C-W>J
nnoremap <C-W>k <C-W>K
nnoremap <C-W>l <C-W>L

nunmap <C-W>H
nunmap <C-W>J
nunmap <C-W>K
nunmap <C-W>L


#----------------------------------------------------------------------------------------
# Resize
#----------------------------------------------------------------------------------------

#--------------------------------------------
# 漸次

nnoremap <C-H> <C-W>+
nnoremap <C-L> <C-W>-
nnoremap (     <C-W>3<
nnoremap )     <C-W>3>

#--------------------------------------------
# 補償
nnoremap <silent> <A-O> <C-L>

#--------------------------------------------
# 最大化・最小化・最適化

# 最大高さ
nnoremap g<C-H> <C-W>_
# 最小最適高さ
nmap     g<C-L> <Plug>(Window-Resize-OptimalHeight-Buf)
# 最大幅
nnoremap g)     <C-W>|
# 最小最適幅
nmap     g(     <Plug>(Window-Resize-OptimalWidth)

# 最大高さ
#nnoremap g<C-J> <C-W>_
# 最小高さ
#nnoremap g<C-K> 1<C-W>_
# 最小幅
#nnoremap g<C-H> 1<C-W>|
# 最大幅
#nnoremap g<C-L> <C-W>|

#nmap @ <Plug>(Window-Resize-EqualOnlyWidth)
#nmap @ <Plug>(Window-Resize-EqualOnlyHeight)

nmap <Leader><Leader> <Plug>(Window-Resize-Toggle-OptimalWidth-Equal)
nmap <Leader><BS>     <Plug>(Window-Resize-OptimalHeight-Buf)

#--------------------------------------------
# Submode Window Resize
if 0
  call submode#enter_with('WinResize', 'n', '', '<Space>l', '<C-W>>')
  call submode#enter_with('WinResize', 'n', '', '<Space>h', '<C-W><')
  call submode#enter_with('WinResize', 'n', '', '<Space>j', '<C-W>+')
  call submode#enter_with('WinResize', 'n', '', '<Space>k', '<C-W>-')

  call submode#map(       'WinResize', 'n', '', 'l', '<C-W>>')
  call submode#map(       'WinResize', 'n', '', 'h', '<C-W><')
  call submode#map(       'WinResize', 'n', '', 'j', '<C-W>+')
  call submode#map(       'WinResize', 'n', '', 'k', '<C-W>-')

  legacy let g:submode_timeoutlen = 5000
endif


#----------------------------------------------------------------------------------------
# <Plug> (他機能での再帰マップ用)
#----------------------------------------------------------------------------------------

nnoremap <Plug>(MyVimrc-WinCmd-p) <C-W>p


#----------------------------------------------------------------------------------------
# Reopen as Tab
#----------------------------------------------------------------------------------------

# TODO diffのバッファも再現する。

# nnoremap <C-W><C-W> :<C-U>tab split<CR>

nnoremap <Plug>(MyVimrc-Window-TabSplit) <Cmd>tab split <Bar> diffoff<CR>
nmap     <C-W><C-W> <Plug>(MyVimrc-Window-TabSplit)
# nmap     <Leader><Leader> <Plug>(MyVimrc-Window-TabSplit)
# nmap     <C-T> <Plug>(MyVimrc-Window-TabSplit)

nnoremap <C-W><C-T> <C-W>T
nnoremap <C-W>T     <C-W>T

# nmap     t <Plug>(MyVimrc-Window-TabSplit)
# nnoremap T <C-W>T


#----------------------------------------------------------------------------------------
# Tab (Window Container)
#----------------------------------------------------------------------------------------

set tabclose=uselast

# クリーンなバッファのバッファ番号を返す。
# クリーンなバッファがないなら、0以下の数を返す。
def GetCleanBuf(): number
  const bufs = getbufinfo()
                -> filter((_, b) => b.name == '' && b.listed && b.loaded && !b.changed && b.linecount == 1)  # 無名で、リストされており、ロードされており、変更がなく、1行しかないバッファ。
                -> map((_, b) => b.bufnr)                                                                    # ここでmapで、バッファ番号に変える。
                -> filter(getbufoneline(bufnr, 1) == '')                                                     # (唯一存在する行である)1行目は空文字である。
                -> filter((_, bufnr) => undotree(bufnr).seq_last == 0)                                       # 変更履歴が一切ない(バッファ生成後、1度も編集されていない。)
  #echo bufs
  return len(bufs) >= 1 ? bufs[0] : -1
enddef

def New(split_cmd: string)
  const bufnr = GetCleanBuf()
  exe split_cmd
  if bufnr >= 1
    exe 'b' bufnr
  else
    enew
  endif
enddef

nnoremap  <C-T> <ScriptCmd>New('tab split')<CR>
nnoremap g<C-T> :<C-U>tabnew<Space>
# nnoremap <silent>  <C-T> <Cmd>tabnew<Bar>SetpathSilent<CR>
# nnoremap <silent> z<C-T> <Cmd>tab split<CR>

nnoremap <C-F> gt
nnoremap <C-B> gT
# nnoremap t gt
# nnoremap T gT

nnoremap g<C-F> <Cmd>exe tabpagenr() == tabpagenr('$') ? 'tabmove 0' : 'tabmove +1'<CR>
nnoremap g<C-B> <Cmd>exe tabpagenr() == 1              ? 'tabmove $' : 'tabmove -1'<CR>

nnoremap <A-F>  <Cmd>exe tabpagenr() == tabpagenr('$') ? 'tabmove 0' : 'tabmove +1'<CR>
nnoremap <A-B>  <Cmd>exe tabpagenr() == 1              ? 'tabmove $' : 'tabmove -1'<CR>

nnoremap gt <Cmd>tabs<CR>:tabnext<Space>


#--------------------------------------------
# Select Tab

def SelectTab()
  tabs

  var n = input('#Tab#> ')

  if n =~# '\d\+'
    exe ':' n 'tabnext'
  endif
enddef

com! -nargs=0 -bar SelectTab SelectTab()

# nnoremap <Leader>t <Cmd>SelectTab<CR>


#----------------------------------------------------------------------------------------
# Terminal
#----------------------------------------------------------------------------------------

# Escape Terminal
# Windowから抜ける。 (Windowが１つしかないなら、Tabから抜ける。)
tnoremap <expr> <C-Tab>    winnr('$') == 1 ? '<C-W>:tabNext<CR>' : '<C-W>p'
tnoremap <expr> <C-T>      winnr('$') == 1 ? '<C-W>:tabNext<CR>' : '<C-W>p'
tnoremap <expr> <C-W><C-W> winnr('$') == 1 ? '<C-W>:tabNext<CR>' : '<C-W>p'
tnoremap <expr> <C-W><C-T> winnr('$') == 1 ? '<C-W>:tabNext<CR>' : '<C-W>p'

# Direction Focus (Terminal)
#tnoremap <S-Left>  <C-W>h
#tnoremap <S-Down>  <C-W>j
#tnoremap <S-Up>    <C-W>k
#tnoremap <S-Right> <C-W>l

# Reopen as Tab
tnoremap <C-W><C-T> <C-W>T
tnoremap <C-W>T     <C-W>T

# terminal
tnoremap <C-Up>    <C-W>+
tnoremap <C-Down>  <C-W>-
tnoremap <C-Left>  <C-W><
tnoremap <C-Right> <C-W>>
