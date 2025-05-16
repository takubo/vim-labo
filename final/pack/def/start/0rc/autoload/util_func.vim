vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 expandtab
scriptencoding utf-8


#----------------------------------------------------------------------------------------
# Util Functions
#----------------------------------------------------------------------------------------


export def IsEmptyBuf(): bool
  return bufname('') == '' && &buftype == '' && !&modified
enddef


export def ToCapital(str: string): string
  return substitute(str, '.*', '\L\u&', '')
 #return toupper(str[0]) .. str[1:]
enddef


# 数値比較用の関数 lhs のほうが大きければ正数，小さければ負数，lhs と rhs が等しければ 0 を返す
export def CompNr(lhs: number, rhs: number): number
  return lhs - rhs
enddef


export def GetKey(): string
  return nr2char(getchar())
enddef


export def GetKeyEcho(): string
  const k = nr2char(getchar())
  echon k
  return k
enddef


function Eatchar(pat)
  let c = nr2char(getchar(0))
  return (c =~ a:pat) ? '' : c
endfunc
# 例 iabbr <silent> if if ()<Left><C-R>=Eatchar('\s')<CR>


export def ProcTopUnderScore(word: string): string
  if word[0] == '_'
    return '_\?' .. word[1:]
  elseif word[0] =~ '\a'
    return '_\?' .. word
  endif
  return word
enddef


function Factorial(n)
  python3 import math
  return pyxeval('math.factorial(' . a:n . ')')
endfunction


# 返り値
#   CursorがWordの上:       正整数
#   CursorがWordの上でない: 0
export def IsCursorOnWord(): number
  return search('\%#\k', 'cnz')
enddef


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
export def CursorWord(): number
  return search('\<\%#\k', 'cnz') ? -1 : search('\%#\k', 'cnz') ? 1 : 0
enddef

# TODO rename CursorWord() -> CursorOnWord()


const NumWin = function('winnr',     ['$'])
const NumTab = function('tabpagenr', ['$'])


# カーソル下の文字を返す
export def GetCursorChar(): string
  return getline('.') -> strcharpart(getcursorcharpos()[2] - 1, 1)
enddef

com! GetCursorChar echo GetCursorChar()

# カーソル下の文字の文字コードを返す
export def GetCursorCharCode(): number
  return getline('.') -> strcharpart(getcursorcharpos()[2] - 1, 1) -> char2nr()
enddef

com! GetCursorCharCode echo printf('0x%x', GetCursorCharCode())
