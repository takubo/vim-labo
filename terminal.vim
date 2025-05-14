vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8


#---------------------------------------------------------------------------------------------
# Mapping

# コマンドラインモードへ入りやすくする
tnoremap <C-w>; <C-w>:

# ノーマルモードへ
tnoremap <Esc><Esc> <C-w>N

# oでも、挿入モードに戻れるようにする。
nmap <expr> o &buftype == 'terminal' ? 'i' : 'o'

# <A-*>を、<Esc>*にマッピングする。
for k in split('0123456789abcdefghijklmnopqrstuvwxyz', '\zs')
  exec 'tnoremap <A-' .. k .. '> <Esc>' .. k
endfor

# 無名レジスタをペースト
tnoremap <A-Y> <C-w>"*

# バッファのカレントディレクトリへ、cdする。
tnoremap <expr> <A-D> 'cd ' .. expand('#' .. winbufnr(1) .. ':p:h')

# マップしなくても大丈夫？
# tnoremap <C-l> <C-l>


#---------------------------------------------------------------------------------------------
# Terminal Open

# 対象terminalへ、カレントウィンドウからwincmd wで移動する際の、count数を返す。
def OpenTerm_Sub(idx: number, term_bufnr: number): number
  if bufwinnr(term_bufnr) < 0
    # このterminalは、別のタブで開かれている
    return 9999
  endif
  if bufwinnr(term_bufnr) >= winnr()
    # このterminalのウィンドウ番号は、カレントウィンドウのウィンドウ番号以上
    # ウィンドウ番号の差を返す。
    return bufwinnr(term_bufnr) - winnr()
  else
    # このterminalのウィンドウ番号は、カレントウィンドウのウィンドウ番号未満
    # ラップの考慮したウィンドウ番号の差を返す。
    return winnr('$') - winnr() + bufwinnr(term_bufnr)
  endif
  return 0  # unreachable
enddef

def OpenTerm()
  # 現在開かれているtermsの一覧を得る。
  var terms = term_list()

  # 各terminalへ、カレントウィンドウからwincmd wで移動する際の、countへ変換
  map(terms, function('OpenTerm_Sub'))

  # カレントウィンドウからwincmd wで移動する際の、countが最も少ないterminalへ移動するためのcountを得る。
  const minval = min(terms)

  if minval != 0 && minval != 9999
    # カレントウィンドウからwincmd wで移動する際の、countが最も少ないterminalへ移動する。
    exe (minval + winnr() - 1) % (winnr('$')) + 1 .. ' wincmd w'
  else
    # このタブで開かれているterminalはないので、新規に開く。
    terminal
    # wincmd p
  endif
enddef

# terminalを開く
# nnoremap <silent> gT         :<C-U>terminal<CR>
# nnoremap <silent> <Leader>gt :<C-U>vvert terminal<CR>
# nnoremap g<C-d> <Cmd>call <SID>OpenTerm()<CR>


#---------------------------------------------------------------------------------------------
# Escap Terminal

# Focus Move (Terminal)
tnoremap <S-Left>  <C-w>h
tnoremap <S-Down>  <C-w>j
tnoremap <S-Up>    <C-w>k
tnoremap <S-Right> <C-w>l

# Terminal Windowから抜ける。 (Windowが１つしかないなら、Tabを抜ける。)
tnoremap <expr> <C-Tab>    winnr('$') == 1 ? '<C-w>:tabNext<CR>' : '<C-w>p'
tnoremap <expr> <C-t>      winnr('$') == 1 ? '<C-w>:tabNext<CR>' : '<C-w>p'
tnoremap <expr> <C-w><C-w> winnr('$') == 1 ? '<C-w>:tabNext<CR>' : '<C-w>p'
