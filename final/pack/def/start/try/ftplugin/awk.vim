scriptencoding utf-8
" vim:set ts=8 sts=2 sw=2 tw=0:


finish


"let s:mdHed = -99	"行頭
let s:mdCmt = -1	"コメント
let s:mdNon =  0	"デフォルト
let s:mdStr =  1	"文字列
let s:mdReg =  2	"正規表現

function! s:in_str()
  let mode = s:mdNon
  let lin = getline(".")
  let col = col(".") - 1

  let i = 0
  while i < col
    let chr = strpart(lin, i, 1)
    let i += 1
    if chr == '#'
      let mode = s:mdCmt
      break
    elseif chr == '"'
      let mode = s:mdStr
      while i < col
	let chr = strpart(lin, i, 1)
	let i += 1
	if chr == '\'
	  if i < col
	    let chr = strpart(lin, i, 1)
	    let i += 1
	  endif
	  continue
	elseif chr == '"'
	  let mode = s:mdNon
	  break
	endif
      endwhile
    elseif chr == '/' && match(strpart(lin, 0, i), "\\(^\\\<bar>\\~\\\<bar>(\\\<bar>,\\)\\s*/$") >= 0
      let mode = s:mdReg
      while i < col
	let chr = strpart(lin, i, 1)
	let i += 1
	if chr == '\'
	  if i < col
	    let chr = strpart(lin, i, 1)
	    let i += 1
	  endif
	  continue
	elseif chr == '/'
	  let mode = s:mdNon
	  break
	endif
      endwhile
    else
      let mode = s:mdNon
    endif
  endwhile
  return mode
endfunction
func! Test()
    echo <SID>in_str()
endfunc


if 0
  inoremap <buffer><expr> ~ (<SID>in_str() > 0) ? '~' : smartchr#loop(' ~ ', ' !~ ', '~')
  inoremap <buffer><expr> + (<SID>in_str() > 0) ? '+' : smartchr#loop(' + ', '++ ', ' ++', '+')
  inoremap <buffer><expr> - (<SID>in_str() > 0) ? '-' : smartchr#loop(' - ', '-- ', ' --', '-')
  inoremap <buffer><expr> * (<SID>in_str() > 0) ? '*' : smartchr#loop(' * ', '**', '*')
  inoremap <buffer><expr> % (<SID>in_str() > 0) ? '%' : smartchr#loop(' % ', '%')
  inoremap <buffer><expr> ^ (<SID>in_str() > 0) ? '^' : smartchr#loop(' ^ ', '^')
  inoremap <buffer><expr> / (<SID>in_str() > 0) <bar><bar> search("\\(^\\\<bar>\\~\\\<bar>(\\\<bar>,\\)\\s*\\%#", 'bcn') ? '/' : smartchr#loop(' / ', '/')
  inoremap <buffer><expr> <bar> (<SID>in_str() > 0) ? '<bar>' : smartchr#loop(' <bar> ', ' <bar><bar> ', ' <bar>& ', '<bar>')
  inoremap <buffer><expr> & (<SID>in_str() > 0) ? '&' : smartchr#loop(' && ', ' <bar>& ', '&')

  inoremap <buffer><expr> { ((<SID>in_str() > 0) <bar><bar> search('^\s*\%#', 'bcn')) ? '{' : smartchr#loop(' {', '{')

  inoremap <buffer><expr> = (<SID>in_str() != 0) ? '=' : Imap_eq('=')

  " if/switch/while/for文直後の(は自動で間に空白を入れる
  inoremap <buffer><expr> ( search('\<\if\%#', 'bcn')? ' (': '('
  inoremap <buffer><expr> ( search('\<\switch\%#', 'bcn')? ' (': '('
  inoremap <buffer><expr> ( search('\<\while\%#', 'bcn')? ' (': '('
  inoremap <buffer><expr> ( search('\<\for\%#', 'bcn')? ' (': '('


  " 補完
  so $HOME/.vim/macros/complete.vim
endif
