vim9script


vnoremap J  <Cmd>call <SID>BlockMove(+1)<CR>
vnoremap K  <Cmd>call <SID>BlockMove(-1)<CR>
vnoremap gj <Cmd>call <SID>BlockMove(+1)<CR>
vnoremap gk <Cmd>call <SID>BlockMove(-1)<CR>

vnoremap H <Cmd>call <SID>BlockMove(+1)<CR>oO<Cmd>call <SID>BlockMove(-1)<CR>Oo
#vmap     H KoOJOo
#vmap     L JoOKOo


nmap <C-V><C-V> vKoOJ
nmap <C-V><C-V> vJoOK
nnoremap <C-V><C-V> <C-V><Cmd>call <SID>BlockMove(+1)<CR>oO<Cmd>call <SID>BlockMove(-1)<CR>Oo
nnoremap <C-V><C-V> <C-V><Cmd>call <SID>BlockMove(-1)<CR>oO<Cmd>call <SID>BlockMove(+1)<CR>Oo
nnoremap <C-V><C-V> <C-V><Cmd>call <SID>BlockMove(+1)<CR>oO<Cmd>call <SID>BlockMove(-1)<CR>
nmap <C-V>0 <C-V><C-V>0i
nmap <C-V>$ <C-V><C-V>$a
nmap <C-V>i <C-V><C-V>i
nmap <C-V>a <C-V><C-V>a


nnoremap <Leader>j <Cmd>call <SID>BlockMove(+1)<CR>
nnoremap <Leader>k <Cmd>call <SID>BlockMove(-1)<CR>


def BlockMove(dir: number, force: bool = false)
  #const pos = getcursorcharpos()
  var pos = getcursorcharpos()

  const row = pos[1]
  const col0 = pos[2] + pos[3]

  const col = getline('.')->strcharpart(0, col0)->strdisplaywidth()

  #echo 'col' col
  #red
  #sleep 1

  var crow = row

  var rev = 0   # バッファの最下行、最上行まで行ったことで、ループを抜けるとき以外、戻しは不要

  while 0 < crow && crow <= line('$')
    crow += dir

    const len = getline(crow)->strdisplaywidth()

    #echo 'len' len
    #red
    #sleep 1

    if len < col
      rev = dir
      break
    endif
  endwhile

  const lrow = crow - rev

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



# Test
#  call BlockMove(-1)
#  call BlockMove(+1)



# vnoremap <expr> J  BlockMove(+1)
# vnoremap <expr> K  BlockMove(-1)
# vnoremap <expr> gj BlockMove(+1)
# vnoremap <expr> gk BlockMove(-1)
# 
# vnoremap <expr> H  BlockMove(+1) . 'oO' . BlockMove(-1) . 'Oo'
# vmap            H KoOJOo
# vmap            L JoOKOo
#
#
# nmap <C-V><C-V> vL
#
# nnoremap <expr> gj BlockMove(+1)
# nnoremap <expr> gk BlockMove(-1)
#
#
# def BlockMove(dir: number): string
#   const pos = getcursorcharpos()
# 
#   const col = pos[2] + pos[3]
#   const row = pos[1]
#   #echo row col
# 
#   var crow = row
# 
#   var rev = 0	# バッファの最下行、最上行まで行ったことで、ループを抜けるとき以外、戻しは不要
# 
#   while crow > 0 && crow < line('$')
#     crow += dir
#     const cont = getline(crow)
# 
#     const len = strdisplaywidth(cont)
#     #echo crow cont len
#     if len < col
#       rev = dir
#       break
#     endif
#   endwhile
# 
#   const lrow = crow - (rev)
#   # echo lrow
#   # setcursorcharpos(lrow, pos[2], pos[3])
# 
#   #return abs(nrow - row) .. (dir > 0 ? 'j' : 'k')
#   # echo abs(lrow - row)
#   return repeat(dir > 0 ? 'j' : 'k', abs(lrow - row))
# enddef
