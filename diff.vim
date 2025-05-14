vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8


#---------------------------------------------------------------------------------------------
# Initialize

# 一括で設定すると値が重複するバグ?
# (既定では "internal,filler,closeoff")
#
# set diffopt+=filler
# set diffopt+=context:{6}
# set diffopt-=iblank
# set diffopt-=icase
# set diffopt-=iwhite
# set diffopt-=iwhiteall
# set diffopt-=iwhiteeol
# set diffopt-=horizontal
# set diffopt+=vertical
 set diffopt-=closeoff
# set diffopt-=hiddenoff
# set diffopt+=foldcolumn:{n}
# set diffopt-=followwrap
# set diffopt+=internal
 set diffopt+=indent-heuristic
 set diffopt+=algorithm:histogram


#---------------------------------------------------------------------------------------------
# Diff On/Off/Update

# diff Update
nmap du d<Space>

# diff Cancel
nnoremap dc    :<C-u>diffoff<CR>
nnoremap d<BS> :<C-u>diffoff<CR>

# diff (all window) Quit
nnoremap <silent> dq <Cmd>PushPosAll<CR><Cmd>windo diffoff<CR><Cmd>PopPosAll<CR><Cmd>echo 'windo diffoff'<CR>

# diff (all window and buffer) Quit
nnoremap <silent> dQ <Cmd>PushPosAll<CR><Cmd>bufdo diffoff<CR><Cmd>windo diffoff<CR><Cmd>PopPosAll<CR><Cmd>echo 'bufdo diffoff <Bar> windo diffoff'<CR>

# diff toggle
nnoremap <expr> dx &diff ?
      \ '<Cmd>diffoff<CR>' :
      \ winnr('$') == 2 ? '<Cmd>PushPosAll <Bar> exe "windo diffthis" <Bar> PopPosAll<CR>' : '<Cmd>diffthis<CR>'


#---------------------------------------------------------------------------------------------
#
# Diff On/Off/Update (Special)

def DiffSpecial()
  # このwindowがdiff実行中なら、diffupdate
  if &diff | echo 'diffupdate' | diffupdate | return | endif

  # diff対象となるべきwindowのリストを取得
  # (対象となるべきwindowが2つでないときは、空リストが返る。)
  const win_list = Get_diff_windows()

  # diff対象となるべきwindowが2つでないなら、とりあえず、このwindowをdiffthis
  if win_list == [] | echo 'diffthis' | diffthis | return | endif

  # diff対象となるべきwindowを全てdiffthis
  echo 'Diff Execute Win' win_list
  PushPosAll
  for w in win_list
    # TODO foreach()
    # 2個なら、直書きでよいかも。
    exe ':' w 'wincmd w' | diffthis
  endfor
  PopPosAll
enddef

# diff対象となるべきwindowのリストを返す
# (対象となるべきwindowが2つでないときは、空リストを返す。)
def Get_diff_windows(): list<number>
  var win_list = []

  # TODO filler()
  for w in range(1, winnr('$'))
    if Is_diff_window(w)
      call add(win_list, w)
    endif
  endfor

  return (len(win_list) == 2) ? win_list : []
enddef

# diff対象のwindowであるか否かを返す。
#
# 次のWindow以外が、diff対象である。
#   Quickfix, Locationlist, Terminal, NERDTree, NetrwTreeListing
#
# ※ DiffSpecialでは、これらのWindowを除いて、Window数が2個ならDiffするようにしている。
#
def Is_diff_window(winnr: number): bool
  const bufnr   = winbufnr(winnr)
  const bufname = bufname(bufnr)
  const buftype = getbufvar(bufnr, '&buftype')

  if buftype =~ 'quickfix' || buftype =~ 'help' || buftype =~ 'terminal'
    return v:false
  elseif bufname =~ '^NERD_tree_' || bufname =~ '^NetrwTreeListing'
    return v:false
  endif
  return v:true
enddef

nnoremap d<Space> <Cmd>call <SID>DiffSpecial()<CR>


#---------------------------------------------------------------------------------------------
# Git Diff
#
#   ・Windowが1つだけならそのタブで、そうでなければ新しいタブでGdiffsplitを実行。
#   ・元のWindowを左に配置し、Focusを元のWindowへ戻す。
#   ・Gdiffsplit実行中は、コマンドラインにGdiffsplitが見えるようにする。
nnoremap <silent> d<CR> <Cmd>exe ( winnr('$') > 1 ? 'tab split' : '' )<Bar>Gdiffsplit<Bar>wincmd r<Bar>wincmd p<Bar>echo 'Gdiffsplit'<CR>


#---------------------------------------------------------------------------------------------
# Block Diff

vmap <leader>1 <Plug>(BlockDiff-GetBlock1)
vmap <leader>2 <Plug>(BlockDiff-GetBlock2andExe)


#---------------------------------------------------------------------------------------------
# Diff Option Change

# diff I(l)gnorecase
nnoremap <expr> dl match(&diffopt, '\<icase\>' ) < 0 ? ':<C-u>set diffopt+=icase<CR>'  : ':<C-u>set diffopt-=icase<CR>'

# diff whi(Y)tespace (iwhite: 空白の数の違いを無視する。)
nnoremap <expr> dy match(&diffopt, '\<iwhite\>') < 0 ? ':<C-u>set diffopt+=iwhite<CR>' : ':<C-u>set diffopt-=iwhite<CR>'


#---------------------------------------------------------------------------------------------
# Diff Context Increment & Decrement

def GetDiffContext(): number
  const diffcontext_str = matchstr(&diffopt, 'context:\zs\d\+')
  return diffcontext_str != '' ? str2nr(diffcontext_str) : 6
enddef

def SetDiffContext(diffcontext_new: string)
  const diffopt = &diffopt
  if diffopt =~ 'context'
    const diffcontext_old = matchstr(diffopt, 'context:\zs\d\+')
    exe 'set diffopt-=context:' .. diffcontext_old
  endif
  exe 'set diffopt+=context:' .. diffcontext_new
  return
enddef

com! -bang -nargs=? DiffContextInc   call SetDiffContext( printf('%s', GetDiffContext() + (<q-args> == '' ? 1 : str2nr(<q-args>) )) )
com! -bang -nargs=? DiffContextDec   call SetDiffContext( printf('%s', GetDiffContext() - (<q-args> == '' ? 1 : str2nr(<q-args>) )) )
com! -bang -nargs=0 DiffContextReset call SetDiffContext( 6 )

nnoremap d+ <Cmd>exe 'DiffContextInc' v:count1<CR>
nnoremap d- <Cmd>exe 'DiffContextDec' v:count1<CR>
nnoremap d= <Cmd>DiffContextReset<CR>


#---------------------------------------------------------------------------------------------
# Move to Hunk

# Next Hunk
nnoremap <silent> <Plug>(Diff-Hunk-Next) ]c^zz<Cmd>CursorJumped<CR>
nnoremap <silent> <Plug>(Diff-Hunk-Next) ]c^<Cmd>CursorJumped<CR>

# Previouse Hunk
nnoremap <silent> <Plug>(Diff-Hunk-Prev) [c^zz<Cmd>CursorJumped<CR>
nnoremap <silent> <Plug>(Diff-Hunk-Prev) [c^<Cmd>CursorJumped<CR>

# Next Hunk
nmap <silent> <Tab>   <Plug>(Diff-Hunk-Next)
# Previouse Hunk
nmap <silent> <S-Tab> <Plug>(Diff-Hunk-Prev)


#---------------------------------------------------------------------------------------------
# Sequential Patch Apply
#   diff accept (obtain and next, obtain and previouse) (dotは、repeatの'.')

# TODO var g:DiffAcceptComfirmTime = 500  # [ms]

nnoremap d. do<Cmd>exe 'sleep' g:DiffAcceptComfirmTime .. 'm'<CR>]c^zz
nnoremap d, do<Cmd>exe 'sleep' g:DiffAcceptComfirmTime .. 'm'<CR>[c^zz
