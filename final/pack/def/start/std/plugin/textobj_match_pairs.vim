vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8



#---------------------------------------------------------------------------------------------

onoremap <silent> is :<C-U>normal! 0f(hviw<CR>
onoremap <silent> as :<C-U>normal! 0f(hviwf)<CR>

com! SCP echo searchpairpos('{\|(', '', '}\|)', 'bW')

onoremap <silent> is :<C-U>call searchpairpos('{\|(', '', '}\|)', 'bW') <Bar> normal! v%<CR>
vnoremap <silent> is :<C-U>call searchpairpos('{\|(', '', '}\|)', 'bW')<CR>v%
#onoremap <silent> is :<C-U>call searchpairpos('{\|(', '', '}\|)', 'bW')<CR>v%<CR>

# ^{  (  ) }$

def MMM(): string
  #const s = &mps -> split(',') -> map((_, v) => const t = split(v, ':') | [t[0], t[1]])
  #const y = &mps -> split(',') -> map((_, v) => [ split(v, ':')[0], split(v, ':')[1] ])
  const s = &mps -> split(',\|:')
  const l = s -> copy() -> filter((k, _) => k % 2 == 0)
  const r = s -> copy() -> filter((k, _) => k % 2 != 0) -> reverse()
  const le = l -> join('\|')
  const re = r -> join('\|')
  #echo le
  #echo re
  searchpairpos(le, '', re, 'bcW')
  return ''
enddef
com! MMM MMM()
#MMM
#onoremap <silent> as :<C-U>call <SID>MMM() <Bar> normal! v%<CR>
#onoremap <silent> as <Cmd>call <SID>MMM()<CR>v%<CR>
#onoremap <silent> as :<C-U>call <SID>MMM() <CR>v%<CR>
onoremap <silent> as <Cmd>MMM<CR>:<C-U>normal! v%<CR>
onoremap <expr><silent> as MMM() .. ':<C-U>normal! v%<CR>'
onoremap <silent> as :<C-U>call <SID>MMM() <Bar> normal! v%<CR>
#set ww=<,>
onoremap <silent> is :<C-U>call <SID>MMM() <Bar> normal! v%<BS>o<Space><CR>
onoremap <silent> is :<C-U>call <SID>MMM() <Bar> normal! v%<Left>o<Right><CR>
onoremap <silent> is :<C-U>call <SID>MMM() <Bar> normal! v%hol<CR>
onoremap <silent> is :<C-U>call <SID>MMM() <Bar> normal! v%<Esc>`<v%hol<CR>
#vnoremap <silent> as :<C-U>call <SID>MMM() <Bar> normal! %
#vnoremap <silent> as <Cmd>normal! <Esc><CR><Cmd>call <SID>MMM()<CR><Cmd>normal! v%<CR>
#nnoremap <silent> ? :<C-U>call <SID>MMM()<CR>
vnoremap <silent> as <Cmd>normal! <Esc><CR><Cmd>MMM<CR>v%
vnoremap <silent> as <Cmd>normal! <Esc><CR><Cmd>call <SID>MMM<CR>v%
vnoremap <silent> as <Esc><Cmd>MMM<CR>v%

omap i<Space> is
omap a<Space> as
vmap i<Space> is
vmap a<Space> as

if 0
UK『トラトラトラ』PR

UK『
トラトラトラ
』PR
endif

def MMM2(): string
  #const s = &mps -> split(',') -> map((_, v) => const t = split(v, ':') | [t[0], t[1]])
  #const y = &mps -> split(',') -> map((_, v) => [ split(v, ':')[0], split(v, ':')[1] ])
  const s = &mps -> split(',\|:')
  const l = s -> copy() -> filter((k, _) => k % 2 == 0)
  const r = s -> copy() -> filter((k, _) => k % 2 != 0) -> reverse()
  const le = l -> join('\|')
  const re = r -> join('\|')
  #echo le
  #echo re
  #? const b = getpos('.')
  #? searchpairpos(le, '', re, 'bcW')
  #? if b == getpos('.')
  #?   searchpairpos(le, '', re, 'bW')
  #? endif
  return ''
enddef

import autoload 'util_func.vim' as uf

def MMM3(): string
  #const s = &mps -> split(',') -> map((_, v) => const t = split(v, ':') | [t[0], t[1]])
  #const y = &mps -> split(',') -> map((_, v) => [ split(v, ':')[0], split(v, ':')[1] ])
  const s = &mps -> split(',\|:')
  const l = s -> copy() -> filter((k, _) => k % 2 == 0)
  const r = s -> copy() -> filter((k, _) => k % 2 != 0)
  #const r = s -> copy() -> filter((k, _) => k % 2 != 0) -> reverse()
  const le = l -> join('\|')
  const re = r -> join('\|')
  searchpairpos(le, '', re, 'bcW')  # カーソル移動
  #if r -> index(uf.GetCursorChar()) >= 0
  #  searchpairpos(le, '', re, 'bW')
  #endif
  return ''
enddef
com! MMM MMM3()
onoremap <silent> is :<C-U>call <SID>MMM3() <Bar> normal! v%hol<CR>
vnoremap <silent> is <Cmd>normal! <Esc><CR><Cmd>call <SID>MMM3<CR>v%hol
vnoremap <silent> is <Esc><Cmd>MMM<CR>v%hol
# TODO 最後のoをなくす。
vnoremap <silent> is <Esc><Cmd>call <SID>MMM3()<CR>v%holo

#----------------------------------------------------------------------------------------------------
def MoveToMatchPairStart(): string
  const mps = &mps -> split(',\|:')
  const left  = mps -> copy() -> filter((k, _) => k % 2 == 0)
  const right = mps -> copy() -> filter((k, _) => k % 2 != 0)

  #const le = left  -> join('\|')
  #const re = right -> join('\|')

  # TODO
  #const le = left  -> join('\|') -> substitute('[', '\\[', '')
  #const re = right -> join('\|') -> substitute(']', '\\]', '')
  const le = '[' .. ( left  -> join('') -> substitute('[', '\\[', '') ) .. ']'
  const re = '[' .. ( right -> join('') -> substitute(']', '\\]', '') ) .. ']'

  # TODO   後に "\zs" をつけるとよいかもしれない。するとカーソルがendの
  searchpairpos(le, '', re, 'bcW')        # カーソル移動
  if right -> index(uf.GetCursorChar()) >= 0 # カーソルが閉じ括弧の上にあるときは、上のsearchpairpos()で開始括弧へカーソルが移動しない。
    searchpairpos(le, '', re, 'bW')
  endif
  return ''
enddef

def OperatorMatchPairInner()
  MoveToMatchPairStart()
  const whichwrap = &whichwrap
  set whichwrap=hl
  normal! v%hol
  &whichwrap = whichwrap
enddef

def OperatorMatchPairAll()
  MoveToMatchPairStart()
  normal! v%
enddef

onoremap <silent> is      <ScriptCmd>OperatorMatchPairInner()<CR>
# vi(などとの互換のため、最後のoを付けている。
vnoremap <silent> is <Esc><ScriptCmd>OperatorMatchPairInner()<CR>o

onoremap <silent> as      <ScriptCmd>MoveToMatchPairStart()<Bar>normal! v%<CR>
vnoremap <silent> as <Esc><ScriptCmd>MoveToMatchPairStart()<CR>v%

onoremap <silent> as      <ScriptCmd>OperatorMatchPairAll()<CR>
vnoremap <silent> as <Esc><ScriptCmd>OperatorMatchPairAll()<CR>



#onoremap <silent> as      <ScriptCmd>MoveToMatchPairStart()<CR>v%
#onoremap <silent> as :<C-U>call <SID>MoveToMatchPairStart() <Bar> normal! v%<CR>
#onoremap <silent> as      <ScriptCmd>MoveToMatchPairStart()<CR><Cmd>normal! v%<CR>

#com! MoveToMatchPairStartTest MoveToMatchPairStart()
#onoremap <silent> is :<C-U>call <SID>MoveToMatchPairStart() <Bar> normal! v%hol<CR>
#onoremap <silent> is <ScriptCmd>MoveToMatchPairStart()<CR><ScriptCmd>OperatorMatchPairInner()<CR><CR>
#vnoremap <silent> is <Cmd>normal! <Esc><CR><Cmd>call <SID>MoveToMatchPairStart<CR>v%hol
#vnoremap <silent> is <Esc><Cmd>MMM<CR>v%hol
# TODO 最後のoをなくす。
#vnoremap <silent> is <Esc><Cmd>call <SID>MoveToMatchPairStart()<CR>v%holo
#----------------------------------------------------------------------------------------------------

if 0
単語先頭
  英数字
    → 
  アンダーバー
    → 

単語でない
    → iw, awと同じ

単語途中
  英大文字
    → 
  英小文字、数字
    → 
  アンダーバー
    → 

単語末尾 & アンダーバー
    → 
endif






finish

#----------------------------------------------------------------------------------------------------
# 調査

def g:MatchPair()
  if 0
    echo searchpair('{', '', '}', 'bcW')
    # { xxxx
    #   aaa { bbb { ccc } ddd } eee { rrr } ppp
    # yyy }
  endif


  const mps = &mps -> split(',\|:')
  const left  = mps -> copy() -> filter((k, _) => k % 2 == 0) # -> filter((k, _) => k != 2)
  const right = mps -> copy() -> filter((k, _) => k % 2 != 0) # -> filter((k, _) => k != 2)
  #const le = left  -> join('\|') -> substitute('[', '\\[', '')
  #const re = right -> join('\|') -> substitute(']', '\\]', '')
  const le = '[' .. ( left  -> join('') -> substitute('[', '\\[', '') ) .. ']'
  const re = '[' .. ( right -> join('') -> substitute(']', '\\]', '') ) .. ']'

  echo le
  echo re

  echo searchpairpos(le, '', re, 'bcW')        # カーソル移動


  #var lee = '「\|『'
  #var ree = '」\|』'
  #echo searchpairpos(lee, '', ree, 'bcW')        # カーソル移動

  # echo searchpairpos('「\|『', '', '」\|』', 'bcW')
enddef


if 0
  これは『あああ』だおおおお「あああ」あだお【おおお】という。
「これは『あああ』だおおおお「あああ」あだお【おおお】という。」
『これは「あああ」だおあだお【おおお】という。』

(これは(あああ)だおあだお(おおお)という。)

[]
if 1
  aaa
  if 2
    bbb
  endif
  ccc
  if 3
    bbb
  endif
  ccc
endif

endif
