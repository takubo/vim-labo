vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8


def Funcs_Body(): list<string>
  var n = 0
  var funcs = []
  var ftop = []

  PushPos

  keepjumps normal! gg

  var prev_line = line('.')

  while 1
    #if &ft != 'vim'
    if &ft == 'c'
      keepjumps normal! ]]
    else
      # VimScriptの]]は、デフォルトftpluginでマッピングされている。
      keepjumps normal ]]
    endif

    var cur_line = line('.')
    if cur_line == prev_line
      break
    endif
    prev_line = cur_line

    if line(".") == line("$")
      break
    endif

    #if &ft != 'vim'
    if &ft == 'c'
      keepjumps normal! k
    endif

    # TODO 各スタイルに対応

    add(funcs, printf("%s", getline(".")))

    if &ft != 'vim'
      # 空行を入れる。
      add(funcs, '')
    endif

    add(ftop, line('.'))
    n += 1

    #if &ft != 'vim'
    if &ft == 'c'
      keepjumps normal! j
    endif
  endwhile

  PopPos

  # echo funcs
  return funcs
enddef

export def g:Funcs(): string
  return Funcs_Body() -> join("\n")
enddef
