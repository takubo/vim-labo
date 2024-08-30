" nr2char(22) は "<C-V>"

let Ctrl_V = nr2char(22)
vnoremap <expr> v mode() == 'v' ? Ctrl_V : 'v'

"let s:Ctrl_v = function('nr2char', [22])
"vnoremap <expr> v mode() == 'v' ? <SID>Ctrl_v() : 'v'

"vnoremap <expr> v mode() == 'v' ? nr2char(22) : 'v'

vnoremap <expr> V mode() ==# 'V' ? '' : 'V'


" Block Visual で、以下の挙動にする。
" o  : 対角
" O  : 横
" ^o : 縦
vnoremap <expr> <C-o> mode() == Ctrl_V ? 'Oo' : 'o'
"vnoremap <C-o> Oo


vnoremap zd zygv"_d
vnoremap zc zygv"_c

"vnoremap Y zy
"vnoremap D zygv"_d
"vnoremap C zygv"_c

"vnoremap y zy
"vnoremap d zygv"_d
"vnoremap c zygv"_c

onoremap a% aw%
onoremap i% iw%

set formatoptions-=ro


" 重点実施
"    1. Window
"    2. Completion
"    3. CWord Search
"    4. Tag & Browse
"    5. Clever-f
"    6. Block Visual
