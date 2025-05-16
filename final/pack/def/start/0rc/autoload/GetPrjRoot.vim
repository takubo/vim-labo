vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8


#---------------------------------------------------------------------------------------------
# Initialize

var PrjRootFile = '.git'


#---------------------------------------------------------------------------------------------
# GetPrjRoot

# プロジェクトルートディレクトリの絶対パスを返す。
# プロジェクトルートディレクトリが見つからないときは、
# カレントディレクトリ(絶対パス)を返す。
export def GetPrjRoot(): string
  # TODO 7階層上のディレクトリまで確認
  # TODO 'cd ..'してもディレクトリ名が変わらないなら、rootなので、制限をなくす？
  for i in range(7)
    const dir = repeat('../', i)
    if glob(dir .. PrjRootFile) != ''  # PrjRootFileファイルの存在確認
      const ret = fnamemodify(dir, ":p")  # 絶対パスにする
      return ret
    endif
  endfor
  const ret = fnamemodify('./', ":p")  # 絶対パスにする
  return ret
enddef

com! -nargs=0 -bar ShowPrjRoot echo GetPrjRoot()
