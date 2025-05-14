vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8


nnoremap <buffer> <silent> ]f <ScriptCmd>FileJmp(']')<CR>
nnoremap <buffer> <silent> [f <ScriptCmd>FileJmp('[')<CR>

vnoremap <buffer> <silent> ]f <ScriptCmd>FileJmp(']')<CR>
vnoremap <buffer> <silent> [f <ScriptCmd>FileJmp('[')<CR>

nnoremap <buffer> <silent> }  <ScriptCmd>BraceJmp('}')<CR>
nnoremap <buffer> <silent> {  <ScriptCmd>BraceJmp('{')<CR>

vnoremap <buffer> <silent> }  <ScriptCmd>BraceJmp('{')<CR>
vnoremap <buffer> <silent> {  <ScriptCmd>BraceJmp('}')<CR>

nnoremap <buffer> <silent> ]] <ScriptCmd>BracketJmp(']]')<CR>
nnoremap <buffer> <silent> ][ <ScriptCmd>BracketJmp('][')<CR>
nnoremap <buffer> <silent> [[ <ScriptCmd>BracketJmp('[[')<CR>
nnoremap <buffer> <silent> [] <ScriptCmd>BracketJmp('[]')<CR>

vnoremap <buffer> <silent> ]] <ScriptCmd>BracketJmp(']]')<CR>
vnoremap <buffer> <silent> ][ <ScriptCmd>BracketJmp('][')<CR>
vnoremap <buffer> <silent> [[ <ScriptCmd>BracketJmp('[[')<CR>
vnoremap <buffer> <silent> [] <ScriptCmd>BracketJmp('[]')<CR>


function BracketJmp(key)
  let dest = '^\(+\|-\|!\) '
  if a:key == ']]'
    "jump next diff line
    let step = +1
  elseif a:key == '[['
    "jump current or previous diff line
    let step = -1
  elseif a:key == ']['
    "jump current or next diff line
    let step = +1
  elseif a:key == '[]'
    "jump previous diff line
    let step = -1
  else
    return
  endif

  let lnum = line(".")

  if a:key == '][' || a:key == '[['
    let lnum += step
  endif

  let cur_line = getline(lnum)

  if cur_line =~ '^+ '
    let cur =  '^+ '
  elseif cur_line =~ '^- '
    let cur =  '^- '
  elseif cur_line =~ '^! '
    let cur =  '^! '
  else
    let cur = ''
    "let cur = '^\[^\s\S\]'
  endif

  "skip
  if cur != ''
    while 1
      let lnum += step
      if lnum < 0 || line("$") < lnum
        return
      endif
      let line = getline(lnum)
      if line !~ cur
        if a:key == '][' || a:key == '[['
          let lnum -= step
          call cursor(lnum, 0)	"カーソルを指定した位置に移動させる
          return
        else
          break
        endif
      endif
    endwhile
  endif

  while 1
    let lnum += step
    if lnum < 0 || line("$") < lnum
      return
    endif
    let line = getline(lnum)
    if line =~ dest
      if a:key == ']]' || a:key == '[]'
        call cursor(lnum, 0)	"カーソルを指定した位置に移動させる
        return
      else
        echo getline(lnum)
        break
      endif
    endif
  endwhile

  let cur_line = getline(lnum)

  if cur_line =~ '^+ '
    let cur =  '^+ '
  elseif cur_line =~ '^- '
    let cur =  '^- '
  elseif cur_line =~ '^! '
    let cur =  '^! '
    "else
    "let cur = '^\[^\s\S\]' "何にもマッチしない正規表現
  endif

  "goto
  while 1
    let lnum += step
    if lnum < 0 || line("$") < lnum
      return
    endif
    let line = getline(lnum)
    if line !~ cur
      let lnum -= step
      call cursor(lnum, 0)	"カーソルを指定した位置に移動させる
      return
    endif
  endwhile
endfunc

function BraceJmp(key)
  let dest = '^\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*'
  if a:key == '}'
    "jump next diff
    let step = +1
  elseif a:key == '{'
    "jump previous diff
    let step = -1
  else
    return
  endif

  let lnum = line(".")
  while 1
    let lnum += step
    if lnum < 0 || line("$") < lnum
      return
    endif
    let line = getline(lnum)
    if line =~? dest
      call cursor(lnum, 0)	"カーソルを指定した位置に移動させる
      return
    endif
  endwhile
endfunc

function FileJmp(key)
  let dest = '^Index: \S'
  if a:key == ']'
    "jump next file
    let step = +1
  elseif a:key == '['
    "jump previous file
    let step = -1
  else
    return
  endif

  let lnum = line(".")
  while 1
    let lnum += step
    if lnum < 0 || line("$") < lnum
      return
    endif
    let line = getline(lnum)
    if line =~? dest
      call cursor(lnum, 0)	"カーソルを指定した位置に移動させる
      if line =~?  '^Index: \S'
        normal 02w
      endif
      return
    endif
  endwhile
endfunc
