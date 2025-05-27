vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8


import autoload 'util_func.vim' as uf


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
# nnoremap <expr> <C-X> search('\%#[\U2460-\U2473]', 'bcn') ? DotRepeat('C_X2') : "<C-X>"

# Boolean文字列をトグルする
def C_Bool(): bool
  const cw = expand('<cword>')

  var new: string
  if     cw == 'true'
    new = 'false'
  elseif cw == 'false'
    new = 'true'
  elseif cw == 'True'
    new = 'False'
  elseif cw == 'False'
    new = 'True'
  elseif cw == 'TRUE'
    new = 'FALSE'
  elseif cw == 'FALSE'
    new = 'TRUE'
  else
    return false
  endif

  if search('\%#\k', 'bcn', line('.')) == 0
    return false
  endif

  silent exe "silent normal! ciw" .. new .. "\<Esc>b"

  return true
enddef

# 曜日をインリメント、デクリメントする
def C_Week(count: number): bool
  const weeks = '月火水木金土日'

  const cc = uf.GetCursorChar()

  # TODO 

  return false
enddef

# ローマ数字をインリメント、デクリメントする
def C_Roman(count: number): bool
# 2160:Ⅰ
# 2161:Ⅱ
#   :
# 216A:Ⅺ
# 216B:Ⅻ

# 2170:ⅰ
# 2171:ⅱ
#   :
# 217A:ⅺ
# 217B:ⅻ

  const ccc = uf.GetCursorCharCode()

  var cxx: number

  if count > 0
    const cnn = ccc + v:count1

    # \U216B:Ⅻ, \U217B:ⅻ
    if ccc == 0x216B || ccc == 0x217B
      return false  # TODO
    elseif 0x2160 <= ccc && ccc <= 0x216A
      cxx = min([cnn, 0x216B])
    elseif 0x2170 <= ccc && ccc <= 0x217A
      cxx = min([cnn, 0x217B])
    else
      return false
    endif
  else
    const cnn = ccc - v:count1

    # \U2160:Ⅰ, \U2170:ⅰ
    if ccc == 0x2160 || ccc == 0x2170
      return false  # TODO
    elseif 0x2161 <= ccc && ccc <= 0x216B
      cxx = max([cnn, 0x2160])
    elseif 0x2171 <= ccc && ccc <= 0x217B
      cxx = max([cnn, 0x2170])
    else
      return false
    endif
  endif

  silent exe "silent normal! " .. "r" .. nr2char(cxx)
  return true
enddef

def DotRepeat(funcname: string): string
  &operatorfunc = funcname
  return 'g@l'
enddef

def C_A(type: string): void
  if C_Bool()           | return | endif
  if C_Week(+v:count1)  | return | endif
  if C_Roman(+v:count1) | return | endif

  const ccc = uf.GetCursorCharCode()

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
  if C_Bool()           | return | endif
  if C_Week(-v:count1)  | return | endif
  if C_Roman(-v:count1) | return | endif

  const ccc = uf.GetCursorCharCode()

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
  const ccc = uf.GetCursorCharCode()

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
  const ccc = uf.GetCursorCharCode()

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
#   const ccc = uf.GetCursorCharCode()
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
#     cx = v:count1 .. "\<C-X>"
#   endif
#   silent exe "silent normal! " .. cx
#   return
# enddef
# # nnoremap <C-X> :let &operatorfunc = '<SID>C_X3'<CR>g@l
# 
# def C_A3(type: string): void
#   const ccc = uf.GetCursorCharCode()
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
# #nnoremap <C-A> :<C-U>let &opfunc = '<SID>C_A3'<CR>g@l
# #nnoremap <C-A> <Cmd>let &opfunc = '<SID>C_A3'<CR>g@l

#   ⑫ '123
