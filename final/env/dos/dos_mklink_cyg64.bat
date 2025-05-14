rem リンクを作る場所へ移動する
C:
cd C:\cygwin64\home\%USERNAME%

rem こっちはハードリンクでなくてよいのか、要確認。
mklink .vimrc  vimfiles\vimrc
mklink .gvimrc vimfiles\gvimrc


rem リンクを作る場所へ移動する
C:
cd C:\Users\%USERNAME%\bin\vim\vim*\

rem mklink /H vimrc_local.vim C:\cygwin64\home\%USERNAME%\vimfiles\vimrc_local.vim kaoriya版だけ?
mklink /H vimrc C:\cygwin64\home\%USERNAME%\vimfiles\vimrc_local.vim

mklink /H startuptime.bat C:\cygwin64\home\%USERNAME%\vimfiles\startuptime.bat


rem DOS窓から実行したときのために戻る
C:
cd C:\cygwin64\home\%USERNAME%\vimfiles\env\dos


pause
