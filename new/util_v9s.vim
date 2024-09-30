vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8


# def! DotRepeat(funcname: string): string
#   &operatorfunc = funcname
#   return 'g@l'
#  #return repeat('g@l', v:count1)
# enddef
# def! C_X2(type: string): void
#   var cx = C_X(v:count1)
#   exe "normal! " .. cx
#   return
# enddef
# nnoremap <expr> <C-x> search('\%#[\U2460-\U2473]', 'bcn') ? DotRepeat('C_X2') : "<C-x>"

def C_B(): bool
  const cw = expand('<cword>')
echo cw
  var new: string
  if     cw == 'true'
    new = 'false'
  elseif cw == 'false'
    new = 'true'
  elseif cw == 'True'
    new = 'False'
  elseif cw == 'False'
    new = 'True'
  else
    return false
  endif

  if search('\%#\k', 'bcn', line('.')) == 0
    return false
  endif

  silent exe "silent normal! ciw" .. new .. "\<Esc>b"

  return true
enddef

def DotRepeat(funcname: string): string
  &operatorfunc = funcname
  return 'g@l'
enddef

def C_A(type: string): void
  if C_B()
    return
  endif

  const ccc = GetCursorCharCode()

  var cx: string

  # \U2460:①, \U2473:⑳
  if ccc == 0x2473
    return
  elseif 0x2460 <= ccc && ccc <= 0x2473
    const cn = nr2char(ccc + +v:count1)
    #cx =  "s" .. cn .. "\<Esc>"  # 遅すぎる
    cx =  "r" .. cn
  else
    cx = v:count1 .. "\<C-A>"
  endif
  silent exe "silent normal! " .. cx

  return
enddef

def C_X(type: string): void
  if C_B()
    return
  endif

  const ccc = GetCursorCharCode()

  var cx: string

  # \U2460:①, \U2473:⑳
  if 0x2460 == ccc
    return
  elseif 0x2460 <= ccc && ccc <= 0x2473
    const cn = nr2char(ccc + -v:count1)
    #cx =  "s" .. cn .. "\<Esc>"  # 遅すぎる
    cx =  "r" .. cn
  else
    cx = v:count1 .. "\<C-X>"
  endif
  silent exe "silent normal! " .. cx

  return
enddef

nnoremap <expr> <C-A> DotRepeat('C_A')
nnoremap <expr> <C-X> DotRepeat('C_X')


def C_A2(type: string): void
  const ccc = GetCursorCharCode()

  var cx: string

  # \U2460:①, \U2473:⑳
  if ccc == 0x2473
    return
  elseif 0x2460 <= ccc && ccc <= 0x2473
    const cn = nr2char(ccc + +v:count1)
    #cx =  "s" .. cn .. "\<Esc>"  # 遅すぎる
    cx =  "r" .. cn
  else
    cx = v:count1 .. "\<C-A>"
  endif
  silent exe "silent normal! " .. cx

  return
enddef

def C_X2(type: string): void
  const ccc = GetCursorCharCode()

  var cx: string

  # \U2460:①, \U2473:⑳
  if 0x2460 == ccc
    return
  elseif 0x2460 <= ccc && ccc <= 0x2473
    const cn = nr2char(ccc + -v:count1)
    #cx =  "s" .. cn .. "\<Esc>"  # 遅すぎる
    cx =  "r" .. cn
  else
    cx = v:count1 .. "\<C-X>"
  endif
  silent exe "silent normal! " .. cx

  return
enddef

# nnoremap <expr> <C-A> DotRepeat('C_A2')
# nnoremap <expr> <C-X> DotRepeat('C_X2')


# def C_X3(type: string): void
#   const ccc = GetCursorCharCode()
# 
#   var cx: string
# 
#   # \U2460:①, \U2473:⑳
#   if 0x2460 == ccc
#     return
#   elseif 0x2460 <= ccc && ccc <= 0x2473
#     const cn = nr2char(ccc + -v:count1)
#     #cx =  "s" .. cn .. "\<Esc>"
#     cx =  "r" .. cn
#   else
#     cx = v:count1 .. "\<C-x>"
#   endif
#   silent exe "silent normal! " .. cx
#   return
# enddef
# # nnoremap <C-x> :let &operatorfunc = '<SID>C_X3'<CR>g@l
# 
# def C_A3(type: string): void
#   const ccc = GetCursorCharCode()
# 
#   var cx: string
# 
#   # \U2460:①, \U2473:⑳
#   if ccc == 0x2473
#     return
#   elseif 0x2460 <= ccc && ccc <= 0x2473
#     const cn = nr2char(ccc + +v:count1)
#     #cx =  "s" .. cn .. "\<Esc>"
#     cx =  "r" .. cn
#   else
#     cx = v:count1 .. "\<C->"
#   endif
#   silent exe "silent normal! " .. cx
#   return
# enddef
# 
# #nnoremap <C-A> :let &opfunc = '<SID>C_A3'<CR>g@l
# #nnoremap <C-A> :<C-u>let &opfunc = '<SID>C_A3'<CR>g@l
# #nnoremap <C-A> <Cmd>let &opfunc = '<SID>C_A3'<CR>g@l

#   ⑫ '123





nnoremap <Leader><C-e> 0y$o<C-r>=<C-r>"<CR><Esc>
com! Calc normal! 0y$o<C-r>=<C-r>"<CR><Esc>

nnoremap <Leader><C-X> <Cmd>Calc<CR>
nnoremap <Leader><C-E> <Cmd>Calc<CR>
inoremap <C-X><CR>     <Esc><Cmd>Calc<CR>



export def GetCursorChar(): string
  return getline('.')->strcharpart(getcursorcharpos()[2] - 1, 1)
enddef

com! GetCursorChar echo GetCursorChar()

export def GetCursorCharCode(): number
  return char2nr(getline('.')->strcharpart(getcursorcharpos()[2] - 1, 1))
enddef

com! GetCursorCharCode echo printf('0x%x', GetCursorCharCode())





iab <silent> q1  ①<C-R>=Eatchar('\s')<CR>
iab <silent> q2  ②<C-R>=Eatchar('\s')<CR>
iab <silent> q3  ③<C-R>=Eatchar('\s')<CR>
iab <silent> q4  ④<C-R>=Eatchar('\s')<CR>
iab <silent> q5  ⑤<C-R>=Eatchar('\s')<CR>
iab <silent> q6  ⑥<C-R>=Eatchar('\s')<CR>
iab <silent> q7  ⑦<C-R>=Eatchar('\s')<CR>
iab <silent> q8  ⑧<C-R>=Eatchar('\s')<CR>
iab <silent> q9  ⑨<C-R>=Eatchar('\s')<CR>
iab <silent> q10 ⑩<C-R>=Eatchar('\s')<CR>
iab <silent> q11 ⑪<C-R>=Eatchar('\s')<CR>
iab <silent> q12 ⑫<C-R>=Eatchar('\s')<CR>

iab <silent> qd ・<C-R>=Eatchar('\s')<CR>

iab <silent> zh ←
iab <silent> zj ↓
iab <silent> zk ↑
iab <silent> zL →
iab <silent> zl ⇒

iab <silent> (( （<C-R>=Eatchar('\s')<CR>
iab <silent> )) ）<C-R>=Eatchar('\s')<CR>



    #(&number <Bar><Bar> &l:number <Bar><Bar> &relativenumber <Bar><Bar> &l:relativenumber ? 5 : 0)



nnoremap gG G$

var Redrawtabline = function('execute', ['redrawtabline'])
# Redrawtabline()

com! YankCommandLine @* = getcmdline()
cnoremap <C-y> <Cmd>YankCommandLine<CR>



onoremap a% aw%
onoremap i% iw%

set formatoptions-=ro


com! EraceWhiteLine :g/^\s*$/d
com! EraceEmptyLine :g/^$/d


nnoremap <Leader>w <Cmd>update<CR>

#nnoremap gcc S
#nnoremap gcc 0C
nnoremap gc 0C

nnoremap cc 0C
nnoremap gC cc



# ----------------------------------------------------------------------------------------------------
import autoload "./PopUpInfo.vim" as pui

com! PuCenter call pui.PopUpInfoMC([ "RRR:   RRRRRRR", "WWWW: 66666666" ], -1)
# ----------------------------------------------------------------------------------------------------



