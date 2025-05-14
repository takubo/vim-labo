vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 expandtab
scriptencoding utf-8


#----------------------------------------------------------------------------------------
# Util Functions
#----------------------------------------------------------------------------------------


function IsEmptyBuf()
  return bufname('')=='' && &buftype=='' && !&modified
endfunction


function ToCapital(str)
  return substitute(a:str, '.*', '\L\u&', '')
 "return toupper(a:str[0]) . a:str[1:]
endfunction


# 数値比較用の関数 lhs のほうが大きければ正数，小さければ負数，lhs と rhs が等しければ 0 を返す
function CompNr(lhs, rhs)
  return a:lhs - a:rhs
endfunction


function GetKey()
  return nr2char(getchar())
endfunction


function GetKeyEcho()
  let k = nr2char(getchar())
  echon k
  return k
endfunction


function Eatchar(pat)
  let c = nr2char(getchar(0))
  return (c =~ a:pat) ? '' : c
endfunc
# 例 iabbr <silent> if if ()<Left><C-R>=Eatchar('\s')<CR>


function ProcTopUnderScore(word)
  if a:word[0] == '_'
    return '_\?' . a:word[1:]
  elseif a:word[0] =~ '\a'
    return '_\?' . a:word
  endif
  return a:word
endfunction


function Factorial(n)
  python3 import math
  return pyxeval('math.factorial(' . a:n . ')')
endfunction


# 返り値
#   CursorがWordの上:       正整数
#   CursorがWordの上でない: 0
function IsCursorOnWord()
  return search('\%#\k', 'cnz')
endfunction


# 返り値
#   CursorがWordの先頭:             -1
#   CursorがWordの上(先頭でなはい):  1
#   CursorがWordの上でない:          0
function CursorWord_old()
  if search('\<\%#\k', 'cnz')
    return -1
  elseif search('\%#\k', 'cnz')
    return 1
  endif
  return 0
endfunction


# 返り値
#   CursorがWordの先頭:             -1
#   CursorがWordの上(先頭でなはい):  1
#   CursorがWordの上でない:          0
function CursorWord()
  return search('\<\%#\k', 'cnz') ? -1 : search('\%#\k', 'cnz') ? 1 : 0
endfunction

# TODO rename CursorWord() -> CursorOnWord()


const NumWin = function('winnr',     ['$'])
const NumTab = function('tabpagenr', ['$'])
