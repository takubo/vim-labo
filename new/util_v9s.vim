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

  const cc = GetCursorChar()

  # TODO 

  return false
enddef

# 曜日をインリメント、デクリメントする
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

  const ccc = GetCursorCharCode()

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
  if C_Bool()           | return | endif
  if C_Week(-v:count1)  | return | endif
  if C_Roman(-v:count1) | return | endif

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
#     cx = v:count1 .. "\<C-X>"
#   endif
#   silent exe "silent normal! " .. cx
#   return
# enddef
# # nnoremap <C-X> :let &operatorfunc = '<SID>C_X3'<CR>g@l
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
# #nnoremap <C-A> :<C-U>let &opfunc = '<SID>C_A3'<CR>g@l
# #nnoremap <C-A> <Cmd>let &opfunc = '<SID>C_A3'<CR>g@l

#   ⑫ '123





nnoremap <Leader><C-E> 0y$o<C-R>=<C-R>"<CR><Esc>
com! Calc normal! 0y$o<C-R>=<C-R>"<CR><Esc>

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





inoreab <silent> q1  ①<C-R>=Eatchar('\s')<CR>
inoreab <silent> q2  ②<C-R>=Eatchar('\s')<CR>
inoreab <silent> q3  ③<C-R>=Eatchar('\s')<CR>
inoreab <silent> q4  ④<C-R>=Eatchar('\s')<CR>
inoreab <silent> q5  ⑤<C-R>=Eatchar('\s')<CR>
inoreab <silent> q6  ⑥<C-R>=Eatchar('\s')<CR>
inoreab <silent> q7  ⑦<C-R>=Eatchar('\s')<CR>
inoreab <silent> q8  ⑧<C-R>=Eatchar('\s')<CR>
inoreab <silent> q9  ⑨<C-R>=Eatchar('\s')<CR>
inoreab <silent> q10 ⑩<C-R>=Eatchar('\s')<CR>
inoreab <silent> q11 ⑪<C-R>=Eatchar('\s')<CR>
inoreab <silent> q12 ⑫<C-R>=Eatchar('\s')<CR>

inoreab <silent> qd ・<C-R>=Eatchar('\s')<CR>

inoreab <silent> zh ←
inoreab <silent> zj ↓
inoreab <silent> zk ↑
inoreab <silent> zL →
inoreab <silent> zl ⇒

inoreab <silent> (( （<C-R>=Eatchar('\s')<CR>
inoreab <silent> )) ）<C-R>=Eatchar('\s')<CR>



    #(&number <Bar><Bar> &l:number <Bar><Bar> &relativenumber <Bar><Bar> &l:relativenumber ? 5 : 0)



nnoremap gG G$

var Redrawtabline = function('execute', ['redrawtabline'])
# Redrawtabline()

com! YankCommandLine @* = getcmdline()
cnoremap <C-Y> <Cmd>YankCommandLine<CR>



onoremap a% aw%
onoremap i% iw%

set formatoptions-=ro


com! EraceWhiteLine :g/^\s\+$/d
com! EraceTrailingWhite :%s/\s\+$//
com! EraceEmptyLine :g/^$/d
com! EraceNullLine EraceEmptyLine

com! EraceSearchLine exe ':g/' .. @/ .. '/d'
com! EraceNotSearchLine exe ':g!/' .. @/ .. '/d'


nnoremap <expr> <Leader>w bufname('') == '' ? '<Cmd>pwd<CR>' : '<Cmd>update<CR>'
nnoremap <expr> <Leader>w bufname('') == '' ? '' : '<Cmd>update<CR>'

#nnoremap gcc S
#nnoremap gcc 0C
nnoremap gc 0C

nnoremap cc 0C
nnoremap gC cc



# ----------------------------------------------------------------------------------------------------
import autoload "./PopUpInfo.vim" as pui

com! PuCenter call pui.PopUpInfoMC([ "RRR:   RRRRRRR", "WWWW: 66666666" ], -1)

# nnoremap ; <ScriptCmd>call pui.PopUpInfo(" Command Line ", 2500, 2, 2)<CR>:
# ----------------------------------------------------------------------------------------------------



# let g:submode_timeoutlen = 5000




#---------------------------------------------------------------------------------------------

com! NoWrap    PushPosAll | exe 'windo set nowrap' | PopPosAll
com! WinNoWrap PushPosAll | exe 'windo set nowrap' | PopPosAll
com! AllNoWrap PushPosAll | exe 'windo set nowrap' | PopPosAll

com! Wrap    PushPosAll | exe 'windo set wrap' | PopPosAll
com! WinWrap PushPosAll | exe 'windo set wrap' | PopPosAll
com! AllWrap PushPosAll | exe 'windo set wrap' | PopPosAll



#---------------------------------------------------------------------------------------------
# Quickfix WinNew Test
#augroup Test1007
#  au!
#  au WinNew * echo "$$"
#  au WinNew * w:echo = "RR"
#augroup end
#com! Test1007 echo w:echo
 


#---------------------------------------------------------------------------------------------
com! Maxline {
      const max = range(1, line('$')) -> map((k, v) => getline(v)->len()) -> max()
      const cur =          line('.')  ->               getline( )->len()
      echo 'Max =' max '  ' 'Cur =' cur '  ' 'Diff =' max - cur
    }



#---------------------------------------------------------------------------------------------
def RegexpEscape(s: string): string
  const = meta_chars = ''
  return escape(s, meta_chars)
enddef



#---------------------------------------------------------------------------------------------

set cursorlineopt=screenline,number



#---------------------------------------------------------------------------------------------

#?? augroup SearchMultiHighLightOnOff
#??   au!
#??   # au OptionSet hlsearch {
#??   #       if v:option_new == 'hlsearch'
#??   #         echo 'On'
#??   #       elseif v:option_new == 'nohlsearch'
#??   #         echo 'Off'
#??   #       else
#??   #         echo 'Other'
#??   #       endif
#??   #    }
#?? augroup end



#---------------------------------------------------------------------------------------------

def CommnadOutput(cmd: string): string
  var output: string
  redir => output
  silent execute cmd
  redir END
  return output
enddef


nnoremap <Leader>p <Cmd>registers - 0 1 2 3 4 5 6 7 8 9<CR>:put<Space>

def ShowRegisters()
  const s = CommnadOutput('registers - 0 1 2 3 4 5 6 7 8 9')->split('\n')
  #const s = CommnadOutput('registers - 0 1 2 3 4 5 6 7 8 9')
  #echo type(s)
  pui.PopUpInfoM(s, -1)
enddef
nnoremap <Leader>p <ScriptCmd>ShowRegisters()<CR>:put<Space>


#---------------------------------------------------------------------------------------------

com! Regex help regexp
com! Pattern help pattern
com! Regex help magic
com! Regex help pattern-overview
com! Pattern help pattern-overview


#---------------------------------------------------------------------------------------------

nnoremap U <C-R>



#---------------------------------------------------------------------------------------------

# IME状態の切り替えをさせない。
inoremap <C-^> <Nop>



#---------------------------------------------------------------------------------------------

com! -nargs=0 -bang NumCommma3 g$.$s/\(\d\)\%(\%(\d\d\d\)\+\>\)\@=/\1,/g



#---------------------------------------------------------------------------------------------
augroup highlightIdegraphicSpace
  autocmd!
  autocmd Colorscheme * highlight IdeographicSpace term=underline ctermbg=DarkGreen guibg=DarkGreen
  autocmd VimEnter,WinEnter * match IdeographicSpace /　/
augroup END
highlight IdeographicSpace term=underline ctermbg=DarkGreen guibg=DarkGreen

com! -bang -nargs=0 HankakuSpace :%s/　/  /g



#----------------------------------------------------------------------------------------
# Optimal Width

def Window_Resize_SetOptimalWidth()
  # const top = line('w0')
  # const bot = line('w$')
  #const max_len: number = getline(line('w0'), line('w$')) -> map((_, val) => len(val)) -> max()
  const max_len: number = range(line('w0'), line('w$')) -> map((_, val) => virtcol([val, '$'])) -> max()

  const off: number = (bufname(0) =~ '^NERD_tree' ? -2 : 0) + (&number || &l:number || &relativenumber || &l:relativenumber ? 5 : 0) + &l:foldcolumn

  exe max_len + off .. ' wincmd |'
enddef



#---------------------------------------------------------------------------------------------

nnoremap <expr> <silent> <Leader>w bufname() == '' ? '<Cmd>pwd<CR>' : '<Cmd>update<CR>'

#nnoremap <expr> <silent> <Leader>w '<Cmd>' .. (bufname() == '' ? 'pwd' : 'update') .. '<CR>'



#---------------------------------------------------------------------------------------------

##?? def s:BestScrolloff()
##??   # Quickfixでは、なぜかWinNewが発火しないので、exists()で変数の存在を確認せねばならない。
##??   &l:scrolloff = (g:TypewriterScroll || (exists('w:TypewriterScroll') && w:TypewriterScroll)) ? 99999 : ( winheight(0) < 10 ? 0 : winheight(0) < 20 ? 2 : 5 )
##?? enddef
##?? 
##?? let g:TypewriterScroll = v:false
##?? 
##?? augroup MyBestScrollOff
##??   au!
##??   #au WinNew * let w:BrowsingScroll = v:false
##??   #au WinResized * echo v:event
##??   #au WinResized * echo 'Window ID:' win_getid()
##??   # -o, -Oオプション付きで起動したWindowでは、WinNew, WinEnterが発火しないので、別途設定。
##??   # TODO au VimEnter * PushPosAll | exe 'tabdo windo let w:BrowsingScroll = v:false | call <SID>best_scrolloff()' | PopPosAll
##?? augroup end



#----------------------------------------------------------------------------------------
com! Winnr echo '  ' winnr('$')



#----------------------------------------------------------------------------------------
function ToCapital(str)
  return substitute(a:str, '.*', '\L\u&', '')
 "return toupper(a:str[0]) . a:str[1:]
endfunction



#----------------------------------------------------------------------------------------
#hi StatusLineNC		guifg=#7f1f1a	guibg=#d0c589	gui=none	" guibgは色を錯覚するので#d0c589から補正



#---------------------------------------------------------------------------------------------
# from ema.vim

set mouse=a

set formatoptions-=o
set formatoptions-=r

set mps=(:),<:>,[:],{:},（:）,＜:＞,［:］,｛:｝,｟:｠,｢:｣,〈:〉,《:》,「:」,『:』,【:】,〔:〕,〖:〗,〘:〙,〚:〛,⟦:⟧,⟨:⟩,⟪:⟫,⟬:⟭,⟮:⟯,⦃:⦄,⦅:⦆,⦇:⦈,⦉:⦊,⦋:⦌,⦍:⦎,⦏:⦐,⦑:⦒,⦗:⦘,⧼:⧽,❨:❩,❪:❫,❬:❭,❮:❯,❰:❱,❲:❳,❴:❵,⁽:⁾,₍:₎

set ambiwidth=double

set guioptions=

nnoremap <silent> <C-]> g;
nnoremap <silent> <C-\> g,

set vb t_vb=


#---------------------------------------------------------------------------------------------

# nnoremap H <C-w>h
# nnoremap J <C-w>j
# nnoremap K <C-w>k
# nnoremap L <C-w>l



#---------------------------------------------------------------------------------------------

def WWW()
  echo range(1, winnr('$')) -> map((_, w) => [w, win_screenpos(w), winheight(w), winwidth(w)])
enddef
#call WWW()
com! WWW call WWW()
nnoremap @ <Cmd>WWW<CR>

def RRR()
  const c = 3
  const try_num = min([c, winnr('$')])
  echo range(1, try_num + 1) -> map((_, w) => winnr(w .. 'k'))
  echo range(1, try_num + 1) -> map((_, w) => winnr(w .. 'l'))
enddef
#call RRR()
com! RRR call RRR()



#---------------------------------------------------------------------------------------------

noremap! <C-R><C-R> <C-R>*




#---------------------------------------------------------------------------------------------

com! HL echo hlget()->map((k, v) => v.name)

def HL()
  #var hl = hlget()
  #const hn = hl -> mapnew((_, v) => v -> filter((k, _) => (k == 'name' || k == 'guifg' || k == 'guibg' || k == 'gui')))

  const hl = hlget()
  #const hn = hl -> mapnew((k, v) => v.name)
  const hn = hl -> mapnew((_, v) => v.name) -> map((_, v) => matchadd(v, '\<' .. v .. '\>', 90))

  # echo hn
enddef

com! HL HL()



#----------------------------------------------------------------------------------------
# Gold TODO

#var Gold = true
#
#def g:IsGold(): bool
#  return Gold
#enddef
#
#com! Gold Gold = !Gold
#
#nnoremap , <Cmd>Gold<CR><Cmd>redrawtabline<CR><Cmd>redrawstatus!<CR>
#nnoremap @ <Cmd>Stl Winnr<CR>


#---------------------------------------------------------------------------------------------
# Gold

g:RimpaGold = true

com! Gold {
  g:RimpaGold = !g:RimpaGold
  colorscheme super_rimpa
}

def g:IsGold(): bool
  return g:RimpaGold
enddef

nnoremap , <Cmd>Gold<CR><Cmd>redrawtabline<CR><Cmd>redrawstatus!<CR>

#---------------------------------------------------------------------------------------------
# Dark

g:RimpaDark = true

com! Dark {
  g:RimpaDark = !g:RimpaDark
  colorscheme super_rimpa
}

nnoremap @ <Cmd>Dark<CR>


#---------------------------------------------------------------------------------------------

augroup MyVimrc_ModeShowTTTT
  au!
  # au ModeChanged *:v  :2echowindow 'Visual Character'
  # au ModeChanged *:V  :2echowindow 'Visual Line'
  # au ModeChanged *: :2echowindow 'Visual Block'
augroup end



#---------------------------------------------------------------------------------------------

# com! -bang -nargs=0 ScrollBind setl scrollbind

com! -bang -bar -nargs=? ScrollBind {
  var win_id = 0
  var bang = ''

  if winnr('$') == 2
    win_id = (3 - winnr()) -> win_getid()
    bang = '<bang>'
  elseif <q-args> == ''
    win_id = str2nr(<q-args>)
  endif

  if win_id != 0 && bang == ''
    win_execute(win_id, 'setl scrollbind!')
  endif
  setl scrollbind!
}



#---------------------------------------------------------------------------------------------

com! LL echo winnr()->win_getid()->getwininfo()[0].loclist



#---------------------------------------------------------------------------------------------

tnoremap o i
nnoremap <Space> <Nop>

set nrformats=bin,hex #,blank
set nrformats=bin,hex,unsigned

set shortmess+=cC

#---------------------------------------------------------------------------------------------

nnoremap <Leader><C-t> <Cmd>tabs<CR>:tabnext<Space>









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

def MMM3(): string
  #const s = &mps -> split(',') -> map((_, v) => const t = split(v, ':') | [t[0], t[1]])
  #const y = &mps -> split(',') -> map((_, v) => [ split(v, ':')[0], split(v, ':')[1] ])
  const s = &mps -> split(',\|:')
  const l = s -> copy() -> filter((k, _) => k % 2 == 0)
  const r = s -> copy() -> filter((k, _) => k % 2 != 0)
  #const r = s -> copy() -> filter((k, _) => k % 2 != 0) -> reverse()
  const le = l -> join('\|')
  const re = r -> join('\|')
  searchpairpos(le, '', re, 'bcW')
  if r -> index(GetCursorChar()) >= 0
    searchpairpos(le, '', re, 'bW')
  endif
  return ''
enddef
com! MMM MMM3()
onoremap <silent> is :<C-U>call <SID>MMM3() <Bar> normal! v%hol<CR>
vnoremap <silent> is <Cmd>normal! <Esc><CR><Cmd>call <SID>MMM3<CR>v%hol
vnoremap <silent> is <Esc><Cmd>MMM<CR>v%hol
# TODO 最後のoをなくす。
vnoremap <silent> is <Esc><Cmd>call <SID>MMM3()<CR>v%holo


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


#---------------------------------------------------------------------------------------------

def ColorColumn(arg: number = 0)
  #augroup AutoCC
  #  au!
  #augroup end

  if arg != 0
    &l:tabstop = arg
  endif

  if &l:colorcolumn == '' || arg != 0
    &l:colorcolumn = range(1, 50) -> map((_, v) => v * &l:ts) -> join(',')
    #augroup AutoCC
    #  #au OptionSet
    #augroup end
  else
    &l:colorcolumn = ''
  endif
enddef

com! -nargs=? -bar CC ColorColumn(<f-args>)


#---------------------------------------------------------------------------------------------

#=============================================================================================
# EscEsc.vim

com! -nargs=0 -bar EscEsc {
  # 'noh'は自動コマンド内では(事実上)実行出来ないので、別途実行の要あり。
  noh
  doautocmd User EscEsc
  #doautocmd nomodeline User EscEsc   TODO
}

# EscEsc内のdoautocmdがエラーにならないよう、1つは自動コマンドを設定しておく。
# 実際には、自動コマンド内のnohは意味をなさない。
augroup EscEscDefault
  au!
 #au User EscEsc noh
  au User EscEsc echon
augroup end

# 最後にコマンドラインモードへの出入りを行うことで、iminsert(or imcmdline?)の効果で、IMEがOFFされる。
nnoremap <silent> <Plug>(EscEsc) <Cmd>EscEsc<CR>:<Esc>

nmap <Esc><Esc> <Plug>(EscEsc)

#=============================================================================================

augroup EscEscCleverf
  au!
  au User EscEsc call clever_f#reset()
  #au User EscEsc call GotoFunc_CloseWin()
  #au User EscEsc call RestoreDefaultStatusline(v:true)
augroup end


#----------------------------------------------------------------------------------------
# Current Function Name

# import autoload "./PopUpInfo.vim" as pui

const NO_FUNC_STR = "###"

def CFIPopup(display_time: number = 2000, line_off: number = 5, col_off: number = 5, already: bool = false)
  const func_name = cfi#format('%s ( )', NO_FUNC_STR)
  if func_name != NO_FUNC_STR
    pui.PopUpInfo(func_name, display_time, line_off, +24)
  endif
  #pui.PopUpInfo(cfi#format("%s ()", "###"), display_time, line_off, +24)
  #pui.PopUpInfo(cfi#format("%s ()", "###"), display_time, -5, +6)
enddef

if 1 || exists('*cfi#format')
 #com! -bar -nargs=0 CFIPopup     echo cfi#format("%s ()", "###")
  com! -bar -nargs=0 CFIPopup     call CFIPopup(-1)
  com! -bar -nargs=0 CFIPopupAuto call CFIPopup()
else
  com! -bar -nargs=0 CFIPopup
  com! -bar -nargs=0 CFIPopupAuto
endif

com! -bar -nargs=0 CursorJumped CFIPopupAuto

#---------------------------------------------------------------------------------------------

#=============================================================================================
# PushposPopPos.vim


var org_win_view: dict<number>

def PushPos()
  org_win_view = winsaveview()  # カレントウィンドウのビューを取得
enddef

def PopPos()
  winrestview(org_win_view)  # カレントウィンドウのビューを復元
enddef


### データ構造定義 ###############
#  dict {
#    'org_win_id' : number;
#    'org_buf_nr' : number;
#  } PosAll[];
##################################
var PosAll = []

var org_win_id: number
var org_buf_nr: number

def PushPosAll()
  PushPos
  org_buf_nr = bufnr()
  org_win_id = win_getid()
enddef

def PopPosAll()
  win_gotoid(org_win_id)
  exe 'buffer' org_buf_nr
  PopPos
enddef

com PPP {
    PushPosAll()
    tabdo wind echon
    PopPosAll()
  }
if 0
com! -bar -nargs=0 PushPos    call PushPos()
com! -bar -nargs=0 PopPos     call PopPos()

com! -bar -nargs=0 PushPosAll call PushPosAll()
com! -bar -nargs=0 PopPosAll  call PopPosAll()
endif
#=============================================================================================

#inoreab pppos const org_win_view = winsaveview()  # カレントウィンドウのビューを取得<CR>winrestview(org_win_view)           # カレントウィンドウのビューを復元
#inoreab <silent> pppos const org_win_view = winsaveview()  # カレントウィンドウのビューを取得<CR>winrestview(org_win_view)           # カレントウィンドウのビューを復元<C-R>=Eatchar('\s')<CR>
inoreab <silent> pppos const org_win_view = winsaveview()   # push win view<CR>winrestview(org_win_view)   # pop win view<C-R>=Eatchar('\s')<CR>

#inoreab ppwin const org_win_id = win_getid()<CR>PushPoswin  win_gotoid(org_win_id)
inoreab <silent> ppwin const org_win_id = win_getid()  # push window<CR>win_gotoid(org_win_id)   # pop window<C-R>=Eatchar('\s')<CR>

inoreab <silent> ppbuf const org_buf_nr = bufnr(  # push buffer)<CR>exe 'buffer' org_buf_n  # pop bufferr<C-R>=Eatchar('\s')<CR>

# defer winrestview('winsaveview()')
# defer win_gotoid('win_getid()')


#---------------------------------------------------------------------------------------------


#=============================================================================================
# Configuration

import autoload '../impauto/window_ratio.vim' as wr


const vimrc_path = $HOME .. (has('win32') ? '/vimfiles/vimrc' : '/.vimrc')

const colors_dir = $HOME .. (has('win32') ? '/vimfiles/colors/' : '/.vim/colors/')  # TODO
const color_path = colors_dir .. g:colors_name .. '.vim'


def Vimrc(path: string, bang: string = '')
  const buf_name = '^' .. path
  const win_id_list = bufnr(buf_name) -> win_findbuf()

  # 現在のタブページ内で開かれていれば
  const cur_win_idx = win_id_list -> mapnew((_, v) => win_id2win(v)) -> indexof((_, v) => v > 0)

  if cur_win_idx != -1
    win_gotoid(win_id_list[cur_win_idx])
    return
  endif

  # 別のタブページで開かれていれば
  if bang == '!'
    const othr_win_idx = win_id_list -> mapnew((_, v) => win_id2tabwin(v)) -> flattennew() -> indexof((_, v) => v > 0)
    if othr_win_idx != -1
      win_gotoid(win_id_list[othr_win_idx])
      return
    endif
  endif

  if IsEmptyBuf()
    exe 'edit'   path
  elseif wr.VertSplit()
    exe 'vsplit' path
  else
    exe 'split'  path
  endif
enddef


com! -bang -bar EditVIMRC Vimrc(vimrc_path, '<bang>')
com! -bang -bar EditColor Vimrc(color_path, '<bang>')
com! -bang -bar VIMRC EditVIMRC

nnoremap <silent> <Leader>v <Cmd>EditVIMRC<CR>
nnoremap <silent> <Leader>V <Cmd>EditColor<CR>


#=============================================================================================


#---------------------------------------------------------------------------------------------

def IsEmptyBuf(): bool
  return bufname('') == '' && &buftype == '' && !&modified
enddef

#---------------------------------------------------------------------------------------------

#=============================================================================================
# SetPath.vim


#set path+=./**
#set path+=;

set wildignore+=**/.git/**
set wildignore+=**/.svn/**


var PrjRootFile = '.git'
PrjRootFile = '.gitignore'

const MaxParent = 20


# {
# BufReadのタイミングでは、カレントディレクトリが当該バッファに変わってないのだが、
# set autochdirすることで、なぜかカレントディレクトリが変わるので、この処理を行っている。
# saveなどすると、なぜか上手くいかない。。。
#let save_autochdir = &autochdir
#set autochdir
#let &autochdir = save_autochdir
# }
def GetPrjRoot(): string
  var prj_root: string

  prj_root = finddir(PrjRootFile, '.;')
  if prj_root != ''
    return prj_root -> fnamemodify(':h:p')
  endif

  prj_root = findfile(PrjRootFile, '.;')
  return prj_root -> fnamemodify(':h:p')
enddef

 # TODO スペースをエスケープ
 # TODO コンマをエスケープ
def GetPrjRootPath(): string
  const prj_root = GetPrjRoot() -> substitute('.\zs/$', '', '')  # root dirを除外するため'/'の前に1文字以上必要。

  return prj_root == '' ?  '' : (prj_root .. '/**' .. ',')
 #return prj_root == '' ?  '' : (',' .. prj_root .. '/**')
enddef

def GetIncludePath(): string
  return ''
enddef


com! -bang -bar -nargs=0 SetPath {
      if '<bang>' == '!'
        setl path&
      endif
      &l:path ..= (&l:path[-1] != ',' ? ',' : '') .. GetPrjRootPath() .. GetIncludePath()
      echo &l:path
    }

com! -bang -bar -nargs=0 ResetPath SetpathSilent<bang> | echo &l:path
com! -bang -bar -nargs=0 SetpathForce ResetPath<bang>


augroup SetPath
  au!
 #au BufRead,BufNew
 # TODO ChDir
  au BufReadPost,BufNewFile * silent SetPath!
augroup end

#=============================================================================================

## def GetPrjRootNum(): number
##   var num: number
##   const parent_path = range(MaxParent) -> map((_, v) => repeat('../', v))
## 
##   num = parent_path -> mapnew((_, v) => finddir(PrjRootFile, v)) -> indexof((k, v) => v != '')
##   if num != -1 | return num | endif
## 
##   num = parent_path -> mapnew((_, v) => findfile(PrjRootFile, v)) -> indexof((k, v) => v != '')
##   return num
## enddef



#---------------------------------------------------------------------------------------------


#=============================================================================================
# Buffer.vim


nnoremap <C-K>         :<C-U>ls <CR>:b<Space>
nnoremap g<C-K>        :<C-U>ls!<CR>:b<Space>
nnoremap <Leader><C-K> :<C-U>ls <CR>:bdel<Space>

nnoremap <silent> g<A-n> :<C-U>bnext<CR>
nnoremap <silent> g<A-p> :<C-U>bprev<CR>

nnoremap <Leader>z :<C-U>bdel
nnoremap <Leader>Z :<C-U>bdel!


#---------------------------------------------------------------------------------------------
# EasyBuffer

if 0
  packadd EasyBuffer
  nnoremap <silent> <C-K> :<Cmd>EasyBufferBotRight<CR><Cmd>OptimalWindowHeight<CR>
endif


#---------------------------------------------------------------------------------------------
# Move to No Name Buffer

const MODIFIED_ONLY = 2
const NO_MODIFIED_ONLY = 1
const REGARDLESS_OF_MODIFY = 0

def NextModifiedNonameBuf(dir: number = 0, modified: number = MODIFIED_ONLY)
  const cur_buf = bufnr()
  const last_buf = bufnr('$')

  const Func = (_, v) => buflisted(v) && bufname(v) == '' &&
                         ( modified == REGARDLESS_OF_MODIFY ||
                           modified == NO_MODIFIED_ONLY && ! getbufinfo(v)[0].changed ||
                           modified == MODIFIED_ONLY    &&   getbufinfo(v)[0].changed )

  # 0からとすることで、リストのインデックスとバッファ番号を一致させる。
  # cur_bufがlast_bufだったときのために、ダミー要素を末尾に追加している。
  const bufs = range(0, last_buf) -> map(Func) + [false]

  var bufidxs = []

  if dir >= 0
    bufidxs = range(cur_buf + 1, last_buf) + range(1, cur_buf - 1)
  else
    bufidxs = range(cur_buf - 1, 1, -1) + range(last_buf, cur_buf + 1, -1)
  endif

  const nnbufs = bufidxs -> filter((_, v) => bufs[v])

  if nnbufs != []
      exe 'buffer' nnbufs[0]
      return
  endif

  echo modified == MODIFIED_ONLY    ? '変更された無名バッファはありません。'       :
       modified == NO_MODIFIED_ONLY ? '変更されていない無名バッファはありません。' :
                                      '無名バッファはありません。'
enddef

com! -bar -bang -nargs=0 NonameBufPrev NextModifiedNonameBuf(-1, '<bar>' == '!' ? REGARDLESS_OF_MODIFY : NO_MODIFIED_ONLY)
com! -bar -bang -nargs=0 NonameBufNext NextModifiedNonameBuf(+1, '<bar>' == '!' ? REGARDLESS_OF_MODIFY : NO_MODIFIED_ONLY)

nnoremap <A-p>         <ScriptCmd>NextModifiedNonameBuf(-1)<CR>
nnoremap <A-n>         <ScriptCmd>NextModifiedNonameBuf(+1)<CR>

nnoremap g<A-p>        <ScriptCmd>NextModifiedNonameBuf(-1, NO_MODIFIED_ONLY)<CR>
nnoremap g<A-n>        <ScriptCmd>NextModifiedNonameBuf(+1, NO_MODIFIED_ONLY)<CR>

nnoremap <Leader><A-p> <ScriptCmd>NextModifiedNonameBuf(-1, REGARDLESS_OF_MODIFY)<CR>
nnoremap <Leader><A-n> <ScriptCmd>NextModifiedNonameBuf(+1, REGARDLESS_OF_MODIFY)<CR>

#=============================================================================================

  #for i in bufidxs
  #  if bufs[i]
  #    exe 'buffer' i
  #    return
  #  endif
  #endfor

  #const IsModifiedNonameBuf = (_, v) => buflisted(v) && bufname(v) == '' && getbufinfo(v)[0].changed
  #const IsNonameBuf         = (_, v) => buflisted(v) && bufname(v) == ''

#def NextModifiedNonameBuf(dir: number = 0)
#  const cur_buf = bufnr()
#  const last_buf = bufnr('$')
#
#  # 0からとすることで、リストのインデックスとバッファ番号を一致させる。
#  const bufs = range(0, last_buf) -> map((_, v) => buflisted(v) && bufname(v) == '' && getbufinfo(v)[0].changed)
#
#  var bufidx = 0
#
#  if dir >= 0
#    bufidx = bufs[cur_buf + 1 : last_buf] -> indexof((_, v) => v)
#    if bufidx == -1 && bufidx != 0
#      bufidx = bufs[1 : cur_buf - 1] -> indexof((_, v) => v)
#    endif
#  else
#    bufidx = reverse(bufs[1 : cur_buf - 1]) -> indexof((_, v) => v)
#    if bufidx == -1 && bufidx != 0
#      bufidx = reverse(bufs[cur_buf + 1 : last_buf]) -> indexof((_, v) => v)
#    endif
#  endif
#
#  if bufidx != 0
#      exe 'buffer' bufs[bufidx]
#  else
#    echo '変更された無名バッファはありません。'
#  endif
#enddef

#---------------------------------------------------------------------------------------------

## #---------------------------------------------------------------------------------------------
## # Move to No Name Buffer
## 
## def NextModifiedNonameBuf(dir: number = 0, modified_only: bool = true)
##   const cur_buf = bufnr()
##   const last_buf = bufnr('$')
## 
##   const Predicate = modified_only ?
##         (_, v) => buflisted(v) && bufname(v) == '' && getbufinfo(v)[0].changed :
##         (_, v) => buflisted(v) && bufname(v) == ''
## 
##   # 0からとすることで、リストのインデックスとバッファ番号を一致させる。
##   # cur_bufがlast_bufだったときのために、ダミー要素を末尾に追加している。
##   const bufs = range(0, last_buf) -> map(Predicate) + [false]
## 
##   var bufidxs = []
## 
##   if dir >= 0
##     bufidxs = range(cur_buf + 1, last_buf) + range(1, cur_buf - 1)
##   else
##     bufidxs = range(cur_buf - 1, 1, -1) + range(last_buf, cur_buf + 1, -1)
##   endif
## 
##   const nnbufs = bufidxs -> filter((_, v) => bufs[v])
## 
##   if nnbufs != []
##       exe 'buffer' nnbufs[0]
##       return
##   endif
## 
##   echo '変更された無名バッファはありません。'
## enddef
## 
## nnoremap <A-p>         <ScriptCmd>NextModifiedNonameBuf(-1)<CR>
## nnoremap <A-n>         <ScriptCmd>NextModifiedNonameBuf(+1)<CR>
## 
## nnoremap <Leader><A-p> <ScriptCmd>NextModifiedNonameBuf(-1, false)<CR>
## nnoremap <Leader><A-n> <ScriptCmd>NextModifiedNonameBuf(+1, false)<CR>


#---------------------------------------------------------------------------------------------

#=============================================================================================
# Unified_Tab.vim


def Unified_Tab(dir: number)
  if &diff
    DiffHunkJump(dir)
  else
    QfJump(dir)
  endif
enddef


nnoremap <silent>         t <ScriptCmd>Unified_Tab(v:count1 * +1)<CR>
nnoremap <silent>         T <ScriptCmd>Unified_Tab(v:count1 * -1)<CR>
nnoremap <silent>     <Tab> <ScriptCmd>Unified_Tab(v:count1 * +1)<CR>
nnoremap <silent>   <S-Tab> <ScriptCmd>Unified_Tab(v:count1 * -1)<CR>
# TODO diff 1st, loc 1st
nnoremap <silent>        gt <Cmd>cfirst<CR>
nnoremap <silent>        gT <Cmd>clast<CR>
#nnoremap <silent> <Leader>t <Cmd>cc<CR>
#nnoremap <silent> <Leader>T <Cmd>cc<CR>


def DiffHunkJump(dir_num: number)
  if dir_num > 0
    # Next Hunk
    exe 'normal!' dir_num .. ']c'
  else
    # Previouse Hunk
    exe 'normal!' dir_num .. '[c'
  endif

  CursorJumped
enddef

# TODO cafter cbefore
def QfJump(dir_num: number)
  if !HaveLocationlist()
    # 例外をキャッチしないと、最初と最後の要素の次に移動しようとして例外で落ちる。
    try
      execute(':' .. abs(dir_num) .. (dir_num >= 0 ?  'cnext' : 'cprev'))
      CursorJumped
    catch /:E553/
      # echo dir_num >= 0 ?  'Last error list.' : '1st error list.'
    endtry
    QfNumAdd
  else
    # 例外をキャッチしないと、最初と最後の要素の次に移動しようとして例外で落ちる。
    try
      execute(':' .. abs(dir_num) .. (dir_num >= 0 ?  'lnext' : 'lprev'))
      CursorJumped
    catch /:E553/
      # echo dir_num >= 0 ?  'Last location list.' : '1st location list.'
    endtry
    LlNumAdd
  endif
enddef

def HaveLocationlist(): bool
  return getloclist(winnr(), {'winid': 0}).winid != 0
enddef

def GetLocationlistWinid(): number
  return getloclist(winnr(), {'winid' : 0}).winid
enddef


const QfNum = () => execute('clist') -> split('\n') -> len()
const LlNum = () => execute('llist') -> split('\n') -> len()

const QfLeaveNum = () => execute('clist +' .. 999999999) -> split('\n') -> len() - 1
const LlLeaveNum = () => execute('llist +' .. 999999999) -> split('\n') -> len() - 1

def QfNumString(title: string, whole: number, leave: number): string
  return title .. ' [ ' .. (whole - leave) .. ' / ' .. whole .. ' ]'
enddef

def QfNumPopup(title: string, whole: number, leave: number)
  pui.PopUpInfoA(QfNumString(title, whole, leave), 2500, 8, 24)
enddef

com! QfNum echo QfNumString('Qfix', QfNum(), QfLeaveNum())
com! LlNum echo QfNumString('LocL', LlNum(), LlLeaveNum())

com! QfNumAdd QfNumPopup('Q ', QfNum(), QfLeaveNum())
com! LlNumAdd QfNumPopup('R ', LlNum(), LlLeaveNum())


#---------------------------------------------------------------------------------------------


## def QfNumString(): string
##   const whole = execute('clist') -> split('\n') -> len()
##   const leave = execute('clist +' .. whole) -> split('\n') -> len() - 1
##   return '[' .. (whole - leave) .. '/' .. whole .. ']'
## enddef
##
## def QfNumString(): string
##   const whole = QfNum()
##   const leave = QfLeaveNum()
##   return '[' .. (whole - leave) .. '/' .. whole .. ']'
## enddef
##
## def QfNumString(): string
##   const whole = QfNum()
##   const leave = QfLeaveNum()
##   return '[' .. (whole - leave) .. '/' .. whole .. ']'
## enddef
##
## def LlNumString(): string
##   const whole = LlNum()
##   const leave = LlLeaveNum()
##   return '[' .. (whole - leave) .. '/' .. whole .. ']'
## enddef

#const QfNum = () => execute('clist') -> split('\n') -> len()
#const LlNum = () => execute('llist') -> split('\n') -> len()
#
#const QfLeaveNum = () => execute('clist +' .. 999999999) -> split('\n') -> len() - 1
#const LlLeaveNum = () => execute('llist +' .. 999999999) -> split('\n') -> len() - 1
#
#def QfNumString(title: string, whole: number, leave: number): string
#  return title .. ' [ ' .. (whole - leave) .. ' / ' .. whole .. ' ]'
#enddef
#
#com! EchoQfNum echo QfNumString('', QfNum(), QfLeaveNum())
#com! EchoLlNum echo QfNumString('', LlNum(), LlLeaveNum())
#
#com! QfNumAdd pui.PopUpInfoA(QfNumString('Qfix', QfNum(), QfLeaveNum()), 2500, 8)
#com! LlNumAdd pui.PopUpInfoA(QfNumString('LocL', LlNum(), LlLeaveNum()), 2500, 8)


#def QfJump(dir_num: number)
#  if !HaveLocationlist()
#    # 例外をキャッチしないと、最初と最後の要素の次に移動しようとして例外で落ちる。
#    try
#      execute(abs(dir_num) ..( dir_num >= 0 ?  'cnext' : 'cprev'))
#      CursorJumped
#    catch /:E553/
#      # echo dir_num >= 0 ?  'Last error list.' : '1st error list.'
#    endtry
#    QfNumAdd
#  else
#    # 例外をキャッチしないと、最初と最後の要素の次に移動しようとして例外で落ちる。
#    try
#      execute(abs(dir_num) .. (dir_num >= 0 ?  'lnext' : 'lprev'))
#      CursorJumped
#    catch /:E553/
#      # echo dir_num >= 0 ?  'Last location list.' : '1st location list.'
#    endtry
#    LlNumAdd
#  endif
#enddef


#---------------------------------------------------------------------------------------------

#=============================================================================================
# Unified_CR.vim

def Unified_CR(mode: string)
  if v:count != 0
    GotoLine(v:count)
    return
  endif

  # # TODO
  # Buffer Local Map
  # if &buftype == 'quickfix'
  #   call feedkeys("\<CR>", 'nt')
  #   CursorJumped
  #   return
  # endif
  # if &buftype == 'help'
  #   call feedkeys("\<C-]>", 'nt')
  #   return
  # endif

  #if EmIsNum()
  #  TODO
  #  EmDispNoTimeOut
  #  return
  #endif

  if JumpToDefinition(mode)
  #  TODO
    #keeppatterns normal! gd
    return
  endif

  if &ft == 'vim' && VimHelp()
    return
  endif

  if GotoFile()
    return
  endif

  keeppatterns normal! gd
enddef

nnoremap <silent> <CR> <ScriptCmd>Unified_CR('')<CR>

# qf.vim FIXME
# nnoremap <buffer> <CR> <CR><Cmd>CursorJumped<CR>
# help.vim FIXME
#nnoremap <buffer> <CR> <C-]>

def GotoLine(line: number)
  # jumplistに残すために、Gを使用。
  exe 'normal!' line .. 'G'
  histadd('cmd', line .. '')
enddef

def GotoLineVCount(line: number): number
  if v:count
    GotoLine(v:count)
    return 1
  endif
  return 0
enddef

com! UnifiedCR Unified_CR('')


def JumpToDefinition(mode: string): number
  const cword = expand("<cword>")

  if cword !~ '\<\i\+\>'
    return 0
  endif

  TempHighLightWord(cword)

  # エラーメッセージ表示用にオリジナル単語でのエラー文字列を保存
  var err_msg = JumpToDefinition_Sub(mode, cword)

  # if err_msg != ''
  #   var nword: string
  #
  #   if cword =~ '^_'
  #     # 元の検索語は"_"始まり
  #     nword = substitute(cword, '^_', '', '')
  #   else
  #     # 元の検索語は"_"始まりでない
  #     nword = '_' .. cword
  #   endif
  #
  #   err_msg = JumpToDefinition_Sub(mode, nword)
  # endif

  if err_msg != ''
    # TODO
    # エラーメッセージ表示用にオリジナル単語でのエラー文字列を保存
    # TempHighLightDelete()
  endif

  return err_msg == '' ? 1 : 0
enddef


def JumpToDefinition_Sub(mode: string, word: string): string
  var err_msg = ''

  try
    if 1
      # TODO
      if mode =~? 's'
        exe (mode =~? 'p' ? 'p' : (mode =~? 'w' ? 's' : '')) .. "tselect " .. word
      else
        exe (mode =~? 'p' ? 'p' : (mode =~? 'w' ? 's' : '')) .. "tjump " .. word
      endif
    else
      if ! TaggJumpExt(word, mode)
        # TODO 無理やり例外を発生させる
        throw ':E426:'
      endif
    endif

    # 表示範囲を最適化
    exe "normal! z\<CR>" .. (winheight(0) / 4) .. "\<C-y>"
    # カーソル位置を調整 (C専用)
    PostTagJumpCursor_C()

    TempHighLightWord(word)

    err_msg = ''
  catch /:E426:/
    err_msg = v:exception
  catch /:E433:/
    #echoerr matchstr(v:exception, 'E\d\+:.*')
    err_msg = v:exception
  endtry
  # echohl ErrorMsg | echo matchstr(exception, 'E\d\+:.*') | echohl None

  return err_msg
enddef

def TaggJumpExt(word: string, mode: string): bool
  const cur_file = expand('%:p')

  const taglist = taglist('^' .. word .. '$', cur_file)

  if len(taglist) == 0
    return false
  endif

  var   cmd_tag     = (a:mode =~? 'p' ? 'p' : (a:mode =~? 'w' ? 's' : '')) . 'tag'
  const cmd_tselect = (a:mode =~? 'p' ? 'p' : (a:mode =~? 'w' ? 's' : '')) . 'tselect'
  if mode =~? 's'
    cmd_tag = cmd_tselect
  endif

  ### タグが1つならそれ
  if len(taglist) == 1
    exe cmd_tag word
    return true
  endif

  ### 内部タグがあればそれ（内部タグ複数はない想定）

  const cur_file_dos = fnamemodify(cur_file, ':.')  # カレントディレクトリ相対にしないと、ctagsとDOSでパスの形式が異なる。

  const cur_file_tag_idx = taglist ->
                           mapnew((_, v) => v.filename = fnamemodify(v.filenam, ':.')) ->  # カレントディレクトリ相対
                           indexof((_, v) => v.filename == cur_file_dos)

  if cur_file_tag_idx != -1
    exe cur_file_tag_idx + 1 cmd_tag word
    return v:true
  endif

  ### include files に対して探索

  var inclist = GetIncludeFiles(expand('%f'))
  # TODO Trim
  var inclist = inclist -> map((_, v) => substitute(v, ' \+', '', 'g'))

  const inc_file_tag_idx = taglist ->
                           indexof((_, t) => indexof(inclist,
                             (_, i) => i == t.filename) != -1
                           )
  if inc_file_tag_idx != -1
    exe inc_file_tag_idx + 1 cmd_tag word
    return true
  endif

  exe cmd_tselect word

  return true
enddef


def GetIncludeFiles(file: string): list<string>
  const inclist = execute('checkpath!')

  var incs = split(inclist, '\n')

  remove(incs, 0)
  filter(incs, (_, val) => val !~ '-->$'  )
  filter(incs, (_, val) => val !~ ')$'    )  # '(既に列挙)'行を削除
  filter(incs, (_, val) => val !~ '"\f\+"')  # '見つかりません'行を削除

  return incs
enddef

com! GetIncludeFiles echo GetIncludeFiles(expand('%f')) -> join("\n")

# カーソル位置を調整 (C専用)
def PostTagJumpCursor_C()
  if &ft == 'c' || &ft == 'h' || &ft == 'cpp'
  else
    return
  endif

  if search('\%##define\s\+\k\+(', 'bcn')
    # 関数形式マクロ
    normal! ww
  elseif search('\%##define\s\+\k\+\s\+', 'bcn')
    # 定数マクロ
    normal! ww
  elseif search('\%#.\+;', 'bcn')
    # 変数
    normal! f;b
  else
    # 関数
    normal! $F(b
  endif
enddef


# Helpの呼び出しに成功したら、非0を返す。
def VimHelp(): number
  try
    #exe 'help ' .. expand('<cword>')

    # TODO オプション 関数 コマンド

    const word = expand('<cword>')
    # TODO const on_opt = VimHelp_OnOpt()
    const sufix = VimHelp_OnBIF() ? '()' : ''
    exe 'help ' .. word .. sufix
    TempHighLight(word, 1500)
    return 1
  catch /:E149/
  endtry
  return 0
enddef

def GotoFile(): number
  #if search('\%#\f', 'bcn') != 0
  #endif
  try
    normal! gF
    popup_create('    Go  File    ', {
          line: 'cursor+3',
          col: 'cursor',
          posinvert: v:true,
          wrap: v:false,
          zindex: 200,
          highlight: 'QuickFixLine',
          border: [1, 1, 1, 1],
          borderhighlight: ['Search'],
          moved: 'any',
          time: 2000,
          })
    return 1
  catch /E447/
  endtry
  return 0
enddef

function Unified_CR_00()

" Tag, Jump, and Unified CR {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

" Browse
if 0
  "nnoremap H <C-o>
  "nnoremap L <C-i>

  "nmap H <Plug>(BrowserJump-Back)
  "nmap L <Plug>(BrowserJump-Foward)

  "nnoremap <silent> H :<C-u>pop<CR>
  "nnoremap <silent> L :<C-u>tag<CR>

  "nmap <BS>H  <Plug>(MyVimrc-WindowSplitAuto)<C-w>p<Plug>(BrowserJump-Back)
  "nmap <BS>L  <Plug>(MyVimrc-WindowSplitAuto)<C-w>p<Plug>(BrowserJump-Foward)

  "nmap <BS>H  <Plug>(MyVimrc-WindowSplitAuto)<Plug>(MyVimrc-WinCmd-p)<Plug>(BrowserJump-Back)
  "nmap <BS>L  <Plug>(MyVimrc-WindowSplitAuto)<Plug>(MyVimrc-WinCmd-p)<Plug>(BrowserJump-Foward)
else
  nmap <C-p>      <Plug>(BrowserJump-Back)
  nmap <C-n>      <Plug>(BrowserJump-Foward)

  nmap <BS><C-p>  <Plug>(MyVimrc-Window-AutoSplit)<Plug>(MyVimrc-WinCmd-p)<C-p>
  nmap <BS><C-n>  <Plug>(MyVimrc-Window-AutoSplit)<Plug>(MyVimrc-WinCmd-p)<C-n>
endif


" ---------------
" Unified CR
"   数字付きなら、行へジャンプ
"   qfなら当該行へジャンプ
"   helpなら当該行へジャンプ
"   それ以外なら、タグジャンプ
" ---------------
function! Unified_CR(mode)

  if v:prevcount
    "jumpする前に登録しないと、v:prevcountが上書されてしまう。
    call histadd('cmd', v:prevcount)
    "jumplistに残すために、Gを使用。
    exe 'normal!' v:prevcount . 'G'
    return
  endif

 "if &ft == 'qf'
  if &buftype == 'quickfix'
    "call feedkeys("\<CR>:FF2\<CR>", 'nt')
    call feedkeys("\<CR>", 'nt')
    return
 "elseif &ft == 'help'
  elseif &buftype == 'help'
    call feedkeys("\<C-]>", 'nt')
    return
  endif

  "if EmIsNum()
  "  EmDispNoTimeOut
  "  return
  "endif

  if JumpToDefine(a:mode) <= 0
    return
  endif

  if &ft == 'vim'
    try
      exe 'help ' . expand('<cword>')

      let g:TagMatch = matchadd('TagMatch', '\<' . expand("<cword>") . '\>')
      let g:TimerTagMatch = timer_start(s:TagHighlightTime, 'TagHighlightDelete')
      let g:TagMatchI[g:TimerTagMatch] = g:TagMatch
      augroup ZZZZ
        au!
        au WinLeave * call TagHighlightDelete(g:TimerTagMatch)
      augroup end
      return
    catch
      "keeppatterns normal! gd
    endtry
  endif
  "keeppatterns normal! gd

  if search('\%#\f', 'bcn')
    try
      normal! gf
      if 1
        " Cursor 下
        call popup_create('    Go  File    ' , #{
              \ line: 'cursor+3',
              \ col: 'cursor',
              \ posinvert: v:true,
              \ wrap: v:false,
              \ zindex: 200,
              \ highlight: 'SLFileName',
              \ border: [1, 1, 1, 1],
              \ borderhighlight: ['QuickFixLine'],
              \ moved: 'any',
              \ time: 2000,
              \ })
      endif
    catch /E447/
    finally
    endtry
    return
  endif

  keeppatterns normal! gd

endfunction


" ----------------------------------------------------------------------------------------------
" Tag Match

augroup MyVimrc_TagMatch
  au!
  au ColorScheme * hi TagMatch	guibg=#c0504d	guifg=white
augroup end

function! TagHighlightDelete(dummy)
  call timer_stop(a:dummy)

  "echo a:dummy
  "sleep 5
  "call matchdelete(g:TagMatch)
  call matchdelete(g:TagMatchI[a:dummy])
  call remove(g:TagMatchI, a:dummy . '')
  "echo g:TagMatchI

  if a:dummy == g:TimerTagMatch0
    au! ZZZZ0
    "ここでreturnしないと、この下のif文でg:TimerTagMatchが未定義エラーになる。
    return
  endif
  if a:dummy == g:TimerTagMatch
    au! ZZZZ
    return
  endif
endfunction

let g:TagMatchI = {}
let s:TagHighlightTime = 1500  " [ms]

" TODO
"   ラベルならf:b
"   変数なら、スクロールしない
"   引数のタグ
"   asmのタグ
function! JumpToDefinition(mode)
  let w0 = expand("<cword>")

  if w0 !~ '\<\i\+\>'
    return -1
  endif

  let w = w0

  let g:TagMatch0 = matchadd('TagMatch', '\<'.w.'\>')
  let g:TimerTagMatch0 = timer_start(s:TagHighlightTime, 'TagHighlightDelete')
  let g:TagMatchI[g:TimerTagMatch0] = g:TagMatch0
  augroup ZZZZ0
    au!
    au WinLeave * call TagHighlightDelete(g:TimerTagMatch0)
  augroup end
  redraw

  for i in range(2)
    try
      if 1
        if a:mode =~? 's'
          exe (a:mode =~? 'p' ? 'p' : (a:mode =~? 'w' ? 's' : '')) . "tselect " . w
        else
          exe (a:mode =~? 'p' ? 'p' : (a:mode =~? 'w' ? 's' : '')) . "tjump " . w
        endif
      else
        if ! TTTT(w, a:mode)
          " TODO 無理やり例外を発生させる
          throw ':E426:'
        endif
      endif
      " 表示範囲を最適化
      exe "normal! z\<CR>" . (winheight(0)/4) . "\<C-y>"
      " カーソル位置を調整 (C専用)
      call PostTagJumpCursor_C()
      let g:TagMatch = matchadd('TagMatch', '\<'.w.'\>')
      let g:TimerTagMatch = timer_start(s:TagHighlightTime, 'TagHighlightDelete')
      let g:TagMatchI[g:TimerTagMatch] = g:TagMatch
      augroup ZZZZ
	au!
	au WinLeave * call TagHighlightDelete(g:TimerTagMatch)
      augroup end
      return 0
    catch /:E426:/
      if w0 =~ '^_'
	" 元の検索語は"_"始まり
	let w = substitute(w0, '^_', '', '')
      else
	" 元の検索語は"_"始まりでない
	let w = '_' . w0
      endif
      if i == 0
	" エラーメッセージ表示用にオリジナル単語でのエラー文字列を保存
      let exception = v:exception
      endif
    catch /:E433:/
      echohl ErrorMsg | echo matchstr(v:exception, 'E\d\+:.*') | echohl None
      return 1
    endtry
  endfor
  echohl ErrorMsg | echo matchstr(exception, 'E\d\+:.*') | echohl None
  return 1
endfunction

" カーソル位置を調整 (C専用)
function! PostTagJumpCursor_C()
  if search('\%##define\s\+\k\+(', 'bcn')
  "関数形式マクロ
    normal! ww
  elseif search('\%##define\s\+\k\+\s\+', 'bcn')
  "定数マクロ
    normal! ww
  elseif search('\%#.\+;', 'bcn')
  "変数
    normal! f;b
  else
    "関数
    normal! $F(b
  endif
endfunction

" 対象
"   カーソル下  ->  Normal mode デフォルト
"   Visual      ->  Visual mode デフォルト
"   (入力)      ->  対応なし

" タグ動作
"   直接ジャンプ -> なし
"   よきに計らう(タグの数次第で) -> デフォルトとする
"   強制選択

" ウィンドウ
"   そのまま
"   別ウィンドウ
"   プレビュー

" mode
"   s:select
"   p:preview
"   w:別ウィンドウ
"
" 最初の<Esc>がないと、prevcountをうまく処理できない。
nnoremap <silent> <CR>         <Esc>:call Unified_CR('')<CR>
nnoremap <silent> g<CR>        <Esc>:call Unified_CR('p')<CR>
nnoremap <silent> <Leader><CR> <Esc>:call Unified_CR('w')<CR>
nnoremap <silent> <C-CR>       <Esc>:call Unified_CR('s')<CR>
nnoremap <silent> <S-CR>       <Esc>:call Unified_CR('sp')<CR>
nnoremap <silent> <C-S-CR>     <Esc>:call Unified_CR('sw')<CR>
nnoremap          <C-S-CR>     <Esc>:tags<CR>;pop

nmap <BS><CR>     <Plug>(MyVimrc-Window-AutoSplit)<CR>
nmap <S-CR>       <Plug>(MyVimrc-Window-AutoSplit)<CR>
nmap <Leader><CR> <Plug>(MyVimrc-Window-AutoSplit-Rev)<CR>

" Tag, Jump, and Unified CR }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}


endfunction



#---------------------------------------------------------------------------------------------

#=============================================================================================
# TempHighLight.vim

var MatchDelete = null_function
var TimerId = 0

hi TempHighLight	guibg=#c0504d	guifg=white

augroup TempHighLight
  au!
  au ColorScheme * hi TempHighLight	guibg=#c0504d	guifg=white
  au WinLeave * Callback(0)
augroup end

def TempHighLight(str: string, time: number = 1500)
  Callback(0)  # 古いのを一旦消す。
  MatchDelete = function('matchdelete', [matchadd('TempHighLight', str), win_getid()])
  TimerId = timer_start(time, Callback)
enddef

def TempHighLightWord(str: string, time: number = 1500)
  TempHighLight('\<' .. str .. '\>', time)
enddef

def Callback(_: number)
  if MatchDelete != null_function
    MatchDelete()
    MatchDelete = null_function
  endif
  if TimerId != 0
    timer_stop(TimerId)
    TimerId = 0
  endif
enddef

# var TimerStop = null_function
  #TimerStop = function('timer_stop', [timer_start(1500, Callback)])

# TempHighLight('def')


#---------------------------------------------------------------------------------------------


var gf_win_id = 0

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

  gf_win_id = popup_create( funcs, {
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

  setbufvar(winbufnr(gf_win_id), '&filetype', getbufvar(bufnr(), '&filetype'))

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

  popup_close(gf_win_id)
enddef

def GotoFunc_CloseWin()
  popup_close(gf_win_id)
enddef

call EscEsc_Add('call GotoFunc_CloseWin()')

nnoremap <silent> <Leader>f <ScriptCmd>GotoFunc()<CR>
com! -bar -bang GotoFuncCloseWin GotoFunc_CloseWin()


#---------------------------------------------------------------------------------------------

nnoremap ga <Cmd>%yank<CR>


#---------------------------------------------------------------------------------------------

nnoremap ; <Cmd>hi CursorLineNr	guibg=#d0c589	guifg=#222222	gui=NONE<CR><Cmd>redraw<CR>:
nnoremap ; <Cmd>hi CursorLineNr	guifg=#b8d3ef	guibg=#4444ee	gui=NONE<CR><Cmd>redraw<CR>:
nnoremap : <Nop>


#---------------------------------------------------------------------------------------------

#inoreab IA inoreab <silent> xxx yyyyyy<lt>C-R>=Eatchar('\s')<lt>CR><C-R>=Eatchar('\s')<CR>
#inoreab IA inoreab <silent> xxx yyyyyy<lt>C-R>=Eatchar('\s')<lt>CR><Esc>bbbbbbbbbbbbi<C-R>=Eatchar('\s')<CR>
#inoreab IA inoreab <silent>  yyyyyy<lt>C-R>=Eatchar('\s')<lt>CR><Esc>bbbbbbbbbbb<Left>i<C-R>=Eatchar('\s')<CR>
inoreab IA inoreab <silent>  <lt>C-R>=Eatchar('\s')<lt>CR><Esc>bbbbbbbbbb<Left>i<C-R>=Eatchar('\s')<CR>

inoreab <silent> qqv (_, v) =>
inoreab <silent> qkv (k, v) =>
inoreab <silent> qiv (i, v) =>
inoreab <silent> qqq const name = (a1: t1, a2: t2): type =>


#---------------------------------------------------------------------------------------------

#vsp tabline.vim.old
#vsp tabline.old1.5
#vsp tabline.vim.old2
#vsp tabline.vim.old3
#vsp tabline.vim.old4
#vsp tabline.vim.old5
#vsp tabline.vim.old6
#vsp tabline.vim.old7
#vsp tabline.vim.old8
#vsp tabline.vim.old9
#vsp tabline.vim.old.10
#vsp tabline.vim.old11
#vsp tabline.vim



#---------------------------------------------------------------------------------------------
def CWord()
  echo search('\%#[^[:keyword:]]*\k\+', 'bcn', line('.'))
enddef
com! CWord CWord()

def VimHelp_OnBIF(): bool
  return search('\%#[^[:keyword:]]*\k\+(', 'bcn', line('.')) != 0
enddef
def VimHelp_OnBIF_Test()
  echo search('\%#[^[:keyword:]]*\k\+(', 'bcn', line('.'))
enddef
com! VimHelpOnBIF VimHelp_OnBIF_Test()

def VimHelp_OnOpt(): bool
  return search('\%#[^[:keyword:]]*&\%(l:\)\?\k\+', 'bcn', line('.')) != 0
      || search('&\%#\%(l:\)\?\k\+', 'bcn', line('.')) != 0
      || search('&\%(l\%#:\)\?\k\+', 'bcn', line('.')) != 0
      || search('&\%(l:\)\?\%#\k\+', 'bcn', line('.')) != 0
      || search('\<se\%[t[gl]]\>\s*\%#s*\k\+', 'bcn', line('.')) != 0
enddef

def VimHelp_OnOpt_Test()
  echo search('\%#[^[:keyword:]]*&\%(l:\)\?\k\+', 'bcn', line('.'))
  echo search('&\%#\%(l:\)\?\k\+', 'bcn', line('.'))
  echo search('&\%(l\%#:\)\?\k\+', 'bcn', line('.'))
  echo search('&\%(l:\)\?\%#\k\+', 'bcn', line('.'))
  echo search('\<se\%[t[gl]]\>\s*\%#s*\k\+', 'bcn', line('.'))
enddef
com! VimHelpOnOpt VimHelp_OnOpt_Test()

# &path

#---------------------------------------------------------------------------------------------

nnoremap <Leader>0 <Cmd>set relativenumber!<CR>

def SwitchLineNumber()
  if !&l:number && !&l:relativenumber
    &l:number = 1
  elseif &l:number && !&l:relativenumber
    &l:number = 1
    &l:relativenumber = 1
  else
    &l:number = 0
    &l:relativenumber = 0
  endif
enddef

# nnoremap <silent> <Leader># <ScriptCmd>SwitchLineNumber()<CR>
com! -bar SwitchLineNumber SwitchLineNumber()


#---------------------------------------------------------------------------------------------



#---------------------------------------------------------------------------------------------



#---------------------------------------------------------------------------------------------
