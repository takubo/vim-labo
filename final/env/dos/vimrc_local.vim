scriptencoding utf-8
" vim:set ts=8 sts=2 sw=2 tw=0:


if !has('win32')
  finish
endif


let s:cygwin_root = isdirectory('C:/cygwin64') ? 'C:/cygwin64' : 'C:/cygwin'

let s:home = $'{s:cygwin_root}/home/{$USERNAME}'


" Shellの設定 (Cygwinでも、なぜか設定しないとbashになる。)
exe $'set sh={s:cygwin_root}/bin/zsh'


" Cygwinから起動されたときの設定
" (Cygwinから起動されたときは、$HOMEが最初から設定されていることを利用して判定している。)
if substitute($HOME, '\', '/', 'g') == s:home
  " $TMPを、(Cygwinではなく)Windowsのパスにそろえる。
  "let $TMP  = $'C:/Users/{$USERNAME}/AppData/Local/Temp'
  "let $TEMP = $TMP

  " Cygwinから起動されたときは、これ以降の設定を実施すると二重になる。
  finish
endif


" $HOMEの設定
if isdirectory(s:home)
  let $HOME=s:home
endif

" LANGの設定
let $LANG = 'ja_JP.UTF-8'

" PATHの追加
"let $PATH = $';{s:cygwin_root}/bin;{$PATH}'    " 先頭へ追加
let $PATH ..= $';{s:cygwin_root}/bin;'          " 末尾へ追加
" let $PATH ..= $'{$HOME}/bin;'                 " 末尾へ追加
let $PATH = $'{$HOME}/bin;{$PATH}'              " 先頭へ追加


" ファイル名の展開にスラッシュを使う
set shellslash

" ! や :! 等のコマンドを実行するためにシェルに渡されるフラグ。
" 末尾のスペースは必要!!
set shellcmdflag=-c\ 

" ! や :! 等のコマンドでコマンドをシェルに渡すときに、コマンドを囲む引用符(の列)。
set shellxquote=\"


" runtimepathの追加
exe 'set runtimepath+=' .. $'{s:home}/vimfiles/'
exe 'set runtimepath+=' .. $'{s:home}/vimfiles/after'

" packpathの追加
exe 'set packpath+=' .. $'{s:home}/vimfiles/'
exe 'set packpath+=' .. $'{s:home}/vimfiles/after'
