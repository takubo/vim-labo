vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 expandtab
scriptencoding utf-8


# Extar
# Asterisk
# Extarisk
# Exterisk


#----------------------------------------------------------------------------------------
# Search Cursor Word
#----------------------------------------------------------------------------------------

import autoload './multihighlight.vim' as mh
# import autoload '../impauto/multihighlight.vim' as mh

# 検索の成否を返すことで、呼び出し元が`set hlsearch'の実行要否を判断できる。
def SearchCWord(whole_wword: bool = true, add: bool = false): bool
  const cword = expand('<cword>')

  if cword == ''
    return false
  endif

  var pattern: string

  if cword[0] =~# '\k'
    pattern = whole_wword ? ('\<' .. cword .. '\>') : cword

    # カーソルを、検索文字列の先頭に持って行く。 {{{
    #   キーワードの先頭
    if     search('\%#\<\k', 'bcn', line('.')) != 0
    #   キーワードの中ほど
    elseif search('\%#\k', 'bcn', line('.')) != 0
      normal! b
    #   キーワードの前の方(スペース、記号のいずれも、混在でも。)
    else
      exe 'normal! f' .. cword[0]
    endif
    # }}}
  else
    pattern = escape(cword, '*^$.~[\')

    # カーソルを、検索文字列の先頭に持って行く。 {{{
    #   非キーワードの先頭
    if     search('[[:keyword:][:space:]]\%#\S', 'bcn', line('.')) != 0
    #   非キーワードの中ほど
    elseif search('\%#\S', 'bcn', line('.')) != 0
      normal! b
    #   非キーワードの前のスペース
    elseif search('\%#\s', 'bcn', line('.')) != 0
      normal! w
    endif
    # }}}
  endif

  @/ = (add ? (@/ .. '\|') : '') .. pattern

  # 検索履歴に残すための処理
  histadd('/', @/)

  # multihighlight
  if add
    mh.Add(pattern)
  else
    mh.Reset()
  endif
  #? if !add
  #?   mh.Reset()
  #? endif
  #? mh.Add(pattern)

  # 自前でechoしないと、前の検索文字列表示が残っていることがある。
  echo '/' .. @/

  CursorJumped
  SearchCountAdd

  return true
enddef


#----------------------------------------------------------------------------------------
# Search Count
#----------------------------------------------------------------------------------------

import autoload './PopUpInfo.vim' as pui
# import autoload '../impauto/Search.vim' as s
# import autoload '../impauto/Search_MultiHilight.vim' as smh

def SearchCountStr(): string
  const sc = searchcount({'maxcount': 99999, 'timeout': 1500})
  return sc.current .. (sc.exact_match || (sc.total == 0) ? '' : ' >') .. ' / ' .. sc.total .. (sc.incomplete ? '+' : '')
enddef

def SearchCountPopup(display_time: number = 2000)
  pui.PopUpInfo(SearchCountStr(), display_time)
enddef

def SearchCountPopupAdd(display_time: number = 2000)
  pui.PopUpInfoA(SearchCountStr(), display_time)
enddef

com! -bar -nargs=0 SearchCount     call SearchCountPopup(-1)  # カーソル移動するまで、表示しっぱなし。
com! -bar -nargs=0 SearchCountAuto call SearchCountPopup()    # 一定時間で消える。
com! -bar -nargs=0 SearchCountAdd  call SearchCountPopupAdd()


#----------------------------------------------------------------------------------------
# Mapping
#----------------------------------------------------------------------------------------

nnoremap  * <Cmd> if <SID>SearchCWord(v:true,  v:false) <Bar> set hlsearch <Bar> endif <CR>
nnoremap  # <Cmd> if <SID>SearchCWord(v:true,  v:true ) <Bar> set hlsearch <Bar> endif <CR>
nnoremap g* <Cmd> if <SID>SearchCWord(v:false, v:false) <Bar> set hlsearch <Bar> endif <CR>
nnoremap g# <Cmd> if <SID>SearchCWord(v:false, v:true ) <Bar> set hlsearch <Bar> endif <CR>

# normalを使わないと、検索対象がない場合に、SearchCountが発動しない。
nnoremap n <Cmd>normal! n<CR><ScriptCmd>call mh.Resume()<CR><Cmd>CursorJumped<CR><Cmd>SearchCountAdd<CR>
nnoremap N <Cmd>normal! N<CR><ScriptCmd>call mh.Resume()<CR><Cmd>CursorJumped<CR><Cmd>SearchCountAdd<CR>

nnoremap <Leader>n <Cmd>SearchCount<CR>

# /, ? で検索したとき (`cnoremap <CR>'の代替)
augroup SearchCR
  au!
  au CmdlineLeave,CmdwinLeave * {
       if expand('<afile>') == '/'
         # <Esc>または<C-C>でコマンドライン・モード抜けたときは、SearchCountStr()がエラーとなるので、tryで囲んでいる。
         # なお、エラー終了した場合は、onceでイベントが消されない。
         # エラーとなることで、PopUpは表示されないので、<Esc>や<C-C>で抜けたときはPopUpが表示されないことになり、都合がよい。
         #exe 'au SearchCR SafeState * ++once CursorJumped | try | SearchCountAuto | catch | endtry'
         exe 'au SearchCR SafeState * ++once CursorJumped'
         exe 'au SearchCR SafeState * ++once try | SearchCountAdd | catch | endtry'
         exe 'au SearchCR SafeState * ++once call mh.Reset()'
       endif
     }
augroup end

if 0
  # 最後にコマンドラインモードへの出入りを行うことで、iminsert(or imcmdline?)の効果で、IMEがOFFされる。
  nnoremap <silent> <Plug>(EscEsc) <ScriptCmd> mh.Suspend() <Bar> noh  <Bar> echon <CR>:<Esc>
  nmap <Esc><Esc> <Plug>(EscEsc)
elseif 0
  g:EscEsc_Add('MHD')
endif

augroup EscEscSearch
  au!
  au User EscEsc mh.Suspend()
augroup end
