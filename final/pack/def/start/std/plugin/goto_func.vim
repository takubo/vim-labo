vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8


var popup_win_id = 0


def GotoFunc()
  #const keys = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
  #const keys = '123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ0'
  #const keys = 'FJGHKDLTUYREA;\123456789BCIMNOPSVWXZ0Q'
  #const keys = 'JFHGKDLSTUYREA;\123456789BCIMNOPVWXZ0Q'
  # Qは使わない
  const keys = 'JFHGKDLSTUYREA;\123456789BCIMNOPVWXZ0'

  # 便宜上の措置
  GotoFuncCloseWin

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

    #? TODO Tour
    #? echo getline('.')
    #? redraw
    #? sleep 1

    # TODO 各スタイルに対応

   #add(funcs, printf("%2d  %2s  %s", n + 1, n < len(keys) ? keys[n] : n + 1, getline(".")))
   #add(funcs, printf("%2s  %s    // %2d  ", n < len(keys) ? keys[n] : n + 1, getline("."), n + 1))
    add(funcs, printf("%2s   %s", n < len(keys) ? keys[n] : n + 1, getline(".")))

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

  #if &ft == 'vim'
  #if &ft == 'c'
    # Total前の空行を入れる。
    add(funcs, '')
  #endif

  add(funcs, printf("[  %d  ]  ", n))

  PopPos

  popup_win_id = popup_create( funcs, {
        \ line: 'cursor+1',
        \ col: 'cursor',
        \ posinvert: v:true,
        \ pos: 'center',
        \ minwidth: 30,
        \ maxheight: &lines - 4 - 3,
        \ tabpage: 0,
        \ wrap: v:false,
        \ zindex: 200,
        \ mousemoved: [0, 0, 0],
        \ drag: 1,
        \ highlight: 'NormalPop',
        \ border: [1, 1, 1, 1],
        \ close: 'click',
        \ padding: [1, 4, 1, 1],
        \ })
        # cursorline: 1,
        # moved: 'any',
        # time: a:time,
        # mask: mask
        # filter: 'popup_filter_menu',

  setbufvar(winbufnr(popup_win_id), '&filetype', getbufvar(bufnr(), '&filetype'))

  redraw

  var m: string

  if n >= len(keys)
    m = input("> ")
  else
    echo "> "
    m = nr2char(getchar())
    feedkeys("<CR>")
  endif

  var nn = match(keys, m)

  if nn >= 0 && nn < n
   #exe "normal!" ftop[nn] .. "G"
    exe "normal!" ftop[nn] .. "Gz\<CR>"
    normal! 0f(bz<CR>
  elseif m =~ '\d\+'
    # 救済
   #exe "normal!" ftop[m - 1] .. "G"
    exe "normal!" ftop[str2nr(m) - 1] .. "Gz\<CR>"
    normal! 0f(bz<CR>
  endif

  popup_close(popup_win_id)
enddef

def GotoFunc_CloseWin()
  popup_close(popup_win_id)
enddef


augroup EscEscGotoFunc
  au!
  au User EscEsc GotoFunc_CloseWin()
augroup end


com! -bar -bang -nargs=0 GotoFunc         GotoFunc()
com! -bar -bang -nargs=0 GotoFuncCloseWin GotoFunc_CloseWin()


nnoremap <silent> <Leader>f <ScriptCmd>GotoFunc()<CR>
