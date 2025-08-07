vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8


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


com!       EraceWhiteLine     :g/^\s\+$/d
com!       EraceTrailingWhite :%s/\s\+$//
com!       EraceEmptyLine     :g/^$/d
com! -bang EraceSearchLine    exe ':g<bang>/' .. @/ .. '/d'
#com!       EraceNotSearchLine exe ':g!/' .. @/ .. '/d'
#com!       EraceNullLine      EraceEmptyLine


#nnoremap gcc S
#nnoremap gcc 0C
nnoremap gc 0C

nnoremap cc 0C
nnoremap gC cc



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


#---------------------------------------------------------------------------------------------

nnoremap <Leader>p <Cmd>registers - 0 1 2 3 4 5 6 7 8 9<CR>:put<Space>

def ShowRegisters()
  const s = CommnadOutput('registers - 0 1 2 3 4 5 6 7 8 9')->split('\n')
  #const s = CommnadOutput('registers - 0 1 2 3 4 5 6 7 8 9')
  #echo type(s)
  pui.PopUpInfoM(s, -1)
enddef
nnoremap <Leader>p <ScriptCmd>ShowRegisters()<CR>:put<Space>

def SelectPaste_0()
  const r = '-0123456789'
  const s = CommnadOutput('registers ' .. r) -> split('\n')
  pui.PopUpInfoM(s, -1)
  redraw
  const k = uf.GetKey()
  if stridx(r, k) != -1
    exe 'put' k
  endif
  pui.PopUpInfoClose()
enddef

def SelectPaste(c: string)
  const r = '-0123456789'
  const s = CommnadOutput('registers ' .. r) -> split('\n')
  pui.PopUpInfoM(s, -1)
  redraw
  const k = uf.GetKey()
  if stridx(r, k) != -1
    exe 'normal! ' .. v:count1 .. '"' .. k .. c
  endif
  pui.PopUpInfoClose()
enddef

nnoremap <Leader>p <ScriptCmd>SelectPaste('p')<CR>
nnoremap <Leader>P <ScriptCmd>SelectPaste('P')<CR>


#---------------------------------------------------------------------------------------------

# IME状態の切り替えをさせない。
inoremap <C-^> <Nop>



#---------------------------------------------------------------------------------------------

com! -nargs=0 -bang NumCommma3 g$.$s/\(\d\)\%(\%(\d\d\d\)\+\>\)\@=/\1,/g



#---------------------------------------------------------------------------------------------
augroup highlightIdeographicSpace
  autocmd!
  autocmd Colorscheme * highlight IdeographicSpace term=underline guibg=#6622cc
  autocmd VimEnter,WinEnter * match IdeographicSpace /　/
augroup END
highlight IdeographicSpace term=underline guibg=#6622cc

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

com! WinId echo winnr() -> win_getid()




#----------------------------------------------------------------------------------------
function ToCapital(str)
  return substitute(a:str, '.*', '\L\u&', '')
 "return toupper(a:str[0]) . a:str[1:]
endfunction



#----------------------------------------------------------------------------------------
#hi StatusLineNC		guifg=#7f1f1a	guibg=#d0c589	gui=none	" guibgは色を錯覚するので#d0c589から補正



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

nnoremap <Space> <Nop>

set nrformats=bin,hex #,blank
set nrformats=bin,hex,unsigned



#---------------------------------------------------------------------------------------------

nnoremap <Leader><C-t> <Cmd>tabs<CR>:tabnext<Space>



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

com! -nargs=? -bar ColorColumn ColorColumn(<f-args>)


#---------------------------------------------------------------------------------------------

#=============================================================================================

augroup EscEscCleverf
  au!
  au User EscEsc call clever_f#reset()
  #au User EscEsc call GotoFunc_CloseWin()
  #au User EscEsc call RestoreDefaultStatusline(v:true)
augroup end


#---------------------------------------------------------------------------------------------

nnoremap ga <Cmd>%yank<CR>


#---------------------------------------------------------------------------------------------

#nnoremap ; <Cmd>hi CursorLineNr	guibg=#d0c589	guifg=#222222	gui=NONE<CR><Cmd>redraw<CR>:
#nnoremap ; <Cmd>hi CursorLineNr	guifg=#b8d3ef	guibg=#4444ee	gui=NONE<CR><Cmd>redraw<CR>:
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

def PFPF()
  PushPosAll
  normal! gF
  #const b = bufnr()
  const f = expand('%:p')
  const l = line('.')
  # redraw
  # sleep 1
  PopPosAll
  #exe 'pedit +set\ nowrap +' .. l f
  exe 'pedit +' .. l f
  #normal! <C-o>
enddef
com! PFPF PFPF()
if 0
nnoremap <buffer> <CR> <Cmd>PFPF<CR>
endif


#---------------------------------------------------------------------------------------------
command! -nargs=+ -bang -complete=command CC CommnadOutputCapture <args>


#---------------------------------------------------------------------------------------------
# from new vimrc

if 0
  set wildmode=list:full
  set wildoptions-=pum
else
  set wildmode=full
  set wildoptions+=pum
  cnoremap <expr> j pumvisible() ? '<C-n>' : 'j'
  cnoremap <expr> k pumvisible() ? '<C-p>' : 'k'
  cnoremap <expr> J pumvisible() ? '<C-n>' : 'J'
  cnoremap <expr> K pumvisible() ? '<C-p>' : 'K'
  cnoremap <expr> <CR> pumvisible() ? '<C-y>' : '<CR>'
endif

# let g:winresizer_start_key = "U"
# let g:winresizer_gui_enable = 1
# let g:winresizer_gui_start_key = "!"


#---------------------------------------------------------------------------------------------

# CommandLine Windowを開く
cnoremap <C-Q> <C-F>
nnoremap : q:i


#---------------------------------------------------------------------------------------------

augroup StartupMRU
  au!
  #au VimEnter * {
  #    if winnr('$') == 1 && bufnr('$') == 1 && bufname('$') == ''
  #      exe 'MRU'
  #    endif
  #  }
augroup end


#---------------------------------------------------------------------------------------------

nnoremap <Leader><C-E> 0y$o<C-R>=<C-R>"<CR><Esc>
com! Calc normal! 0y$o<C-R>=<C-R>"<CR><Esc>

nnoremap <Leader><C-X> <Cmd>Calc<CR>
nnoremap <Leader><C-E> <Cmd>Calc<CR>
inoremap <C-X><CR>     <Esc><Cmd>Calc<CR>



#---------------------------------------------------------------------------------------------

com! -nargs=1 -complete=file_in_path Find echo <q-args>
com! -nargs=1 -complete=runtime Configure echo <q-args>


#---------------------------------------------------------------------------------------------

augroup ExpandTab
  au!
  #au InsertEnter * setl noexpandtab
  #au InsertLeave * setl   expandtab
augroup end

inoremap <Plug>(C-t) <C-t>
inoremap <Plug>(C-d) <C-d>

inoremap <C-T> <Cmd>setl expandtab<CR><Plug>(C-t)<Cmd>setl noexpandtab<CR>
inoremap <C-D> <Cmd>setl expandtab<CR><Plug>(C-d)<Cmd>setl noexpandtab<CR>

inoremap <C-S> <Cmd>setl expandtab!<CR><Cmd>set expandtab?<CR>
inoremap <C-L> <Cmd>set expandtab?<CR>

inoremap <S-Tab> <C-V><Tab>
inoremap <C-]> <C-V><Tab>
inoremap <C-@> <C-V><Tab>

set softtabstop=0



#---------------------------------------------------------------------------------------------
# is key word

import autoload "popup_info.vim" as pui
import autoload 'util_func.vim' as uf

def Isk(plus_minus: string)
  pui.PopUpInfo_NMV(plus_minus .. plus_minus, -1, 1, 1)
  redraw
  const c = uf.GetKey()

  #echo plus_minus .. plus_minus .. ' '
  #const c = uf.GetKeyEcho()

  exe 'setl isk' .. plus_minus .. '=' .. c
  pui.PopUpInfoM([plus_minus .. plus_minus .. '  ' .. c, '', &isk], -1, 1, 1)
enddef

nnoremap <silent> + <ScriptCmd>Isk('+')<CR>
nnoremap <silent> - <ScriptCmd>Isk('-')<CR>



#---------------------------------------------------------------------------------------------

# const N = 3333
# var startTime = reltime()
# startTime = reltime()
# range(N) -> foreach((_, _) => Registers())
# g:Registers_t = startTime->reltime()->reltimestr()
# 
# startTime = reltime()
# range(N) -> foreach((_, _) => Registers_0())
# g:Registers_0_t = startTime->reltime()->reltimestr()
# 
# com! RegistersEcho echo g:Registers_t g:Registers_0_t



#---------------------------------------------------------------------------------------------

nnoremap <expr> G v:count == 0 ? 'G' : ':tabnext ' .. v:count .. '<CR>'  #(v:count .. 'gt')
nnoremap <expr> G v:count == 0 ? 'G' : 'gt'
nnoremap U <Cmd>tabnext #<CR>


#---------------------------------------------------------------------------------------------



#---------------------------------------------------------------------------------------------



#---------------------------------------------------------------------------------------------



#---------------------------------------------------------------------------------------------



#---------------------------------------------------------------------------------------------



#---------------------------------------------------------------------------------------------



#---------------------------------------------------------------------------------------------



#---------------------------------------------------------------------------------------------



