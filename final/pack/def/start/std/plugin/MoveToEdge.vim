vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8


#---------------------------------------------------------------------------------------------
# Mapping

vnoremap J  <ScriptCmd>MoveToEdge(+1)<CR>
vnoremap K  <ScriptCmd>MoveToEdge(-1)<CR>
vnoremap gj <ScriptCmd>MoveToEdge(+1)<CR>
vnoremap gk <ScriptCmd>MoveToEdge(-1)<CR>


vnoremap H <ScriptCmd>MoveToEdge(+1)<CR>oO<ScriptCmd>MoveToEdge(-1)<CR>
vnoremap L <ScriptCmd>MoveToEdge(-1)<CR>oO<ScriptCmd>MoveToEdge(+1)<CR>


nnoremap <C-V><C-V> <C-V><ScriptCmd>MoveToEdge(+1)<CR>oO<ScriptCmd>MoveToEdge(-1)<CR>


nmap <C-V>0 <C-V><C-V>0i
nmap <C-V>$ <C-V><C-V>$a
nmap <C-V>i <C-V><C-V>i
nmap <C-V>a <C-V><C-V>a


nnoremap <Leader>j <ScriptCmd>MoveToEdge(+1)<CR>
nnoremap <Leader>k <ScriptCmd>MoveToEdge(-1)<CR>


#---------------------------------------------------------------------------------------------
# Functions

def MoveToEdge(dir: number, force: bool = false)
  const pos = getcursorcharpos()  # カーソル位置情報

  const row = pos[1]              # 現在行番号
  const col0 = pos[2] + pos[3]    # 現在桁番号 (文字数換算)

  const col = getline('.')->strcharpart(0, col0)->strdisplaywidth()  # 現在行の長さ (見た目換算)

  # デバッグ表示
  #echo 'col' col
  #red
  #sleep 1

  var crow = row  # ループの現在行カウンタ

  var rev = 0  # 戻し量 (-1～+1の範囲) バッファの最下行、最上行まで行ったことで、ループを抜けるとき以外、戻しは不要。

  while 0 < crow && crow <= line('$')
    crow += dir  # 次行番号を算出

    const len = getline(crow)->strdisplaywidth()  # この行の長さ (見た目換算)

    # デバッグ表示
    #echo 'len' len
    #red
    #sleep 1

    # この行の長さが、元居た行より短いなら、ループ終了。
    if len < col
      rev = dir
      break
    endif
  endwhile

  const lrow = crow - rev  # 移動先行番号

  # 移動処理
  if 0
    var new_pos = pos[1 : ]
    new_pos[0] = lrow
    setcursorcharpos(new_pos)
  elseif 1
    const n = (lrow - row) -> abs()
    if n > 0
      #(n .. (dir > 0 ? 'j' : 'k')) -> feedkeys('ni')
      exe 'normal!' (n .. (dir > 0 ? 'j' : 'k'))
    endif
  else
    repeat(dir > 0 ? 'j' : 'k', abs(lrow - row))->feedkeys('ni')
    #exe 'normal! ' .. repeat(dir > 0 ? 'j' : 'k', abs(lrow - row))
  endif
enddef
