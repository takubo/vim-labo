vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8


#---------------------------------------------------------------------------------------------
# Leader

legacy let mapleader = "\<Space>"

# Leader(Space)の空打ちで、カーソルが一つ進むのが鬱陶しいので。
nnoremap <Leader> <Nop>


#---------------------------------------------------------------------------------------------
# Invalidate

nnoremap <silent> ZZ <Nop>
nnoremap <silent> ZQ <Nop>

# IME状態の切り替えをさせない。
inoremap <C-^> <Nop>


#---------------------------------------------------------------------------------------------
# Basic

nnoremap Y y$

#nnoremap ; :
#nnoremap ; <Cmd>hi CursorLineNr guibg=#d0c589 guifg=#222222 gui=NONE<CR><Cmd>redraw<CR>:
nnoremap ; <Cmd>hi CursorLineNr guifg=#b8d3ef guibg=#4444ee gui=NONE<CR><Cmd>redraw<CR>:

# ; を連続で押してしまったとき用。
cnoremap <expr> ; ((getcmdtype()  == ':') && (getcmdline() =~# '^:*$')) ? ':' : ';'
#cnoremap <expr> : ((getcmdtype()  == ':') && (getcmdline() =~# '^:*$')) ? ';' : ':'

nnoremap gcc 0cc
nnoremap gC  0cc
nnoremap gA  S


nnoremap ' "
vnoremap ' "

nnoremap '' "0
vnoremap '' "0

nnoremap " '
vnoremap " '

nnoremap ` m
vnoremap ` m


#---------------------------------------------------------------------------------------------
# EscEsc

# 'noh'は自動コマンド内では(事実上)実行出来ないので、別途実行の要あり。
# TODO  doautocmd nomodeline User
# コマンドラインモードへの出入りを行うことで、iminsert(or imcmdline?)の効果で、IMEがOFFされる。
nnoremap <Esc><Esc> <Cmd>doautocmd User EscEsc<CR><Cmd>noh<CR><Cmd>normal! :<lt>Esc><CR>
nnoremap <Esc><Esc> <Cmd>doautocmd User EscEsc<CR><Cmd>noh<CR>:<Esc>

if 0

com! -nargs=0 -bar EscEsc {
    # 'noh'は自動コマンド内では(事実上)実行出来ないので、別途実行の要あり。
    noh
    doautocmd nomodeline User EscEsc
  }

# EscEsc内のdoautocmdがエラーにならないよう、1つは自動コマンドを設定しておく。
augroup EscEscDefault
  au!
  # コマンドラインモードへの出入りを行うことで、iminsert(or imcmdline?)の効果で、IMEがOFFされる。
  au User EscEsc normal! :<Esc>
augroup end

nnoremap <silent> <Plug>(EscEsc) <Cmd>EscEsc<CR><Cmd>noh<CR>

endif

#---------------------------------------------------------------------------------------------
# 保存

# 無名バッファなら、pwd。そうでなければ、保存。
nnoremap <expr> <silent> <Leader>w bufname() == '' ? '<Cmd>pwd<CR>' : '<Cmd>update<CR>'
#
#nmap <silent> <Leader>e <Leader>w


#---------------------------------------------------------------------------------------------
# Line Number

set number relativenumber

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

com! -bar SwitchLineNumber SwitchLineNumber()  # TODO


#---------------------------------------------------------------------------------------------
# 空行の挿入

nnoremap <C-O> O<Esc>

# TODO
nnoremap go o<Esc>
nnoremap gO O<Esc>
#nnoremap <silent> <C-o> :<C-u>call append(expand('.'), '')<CR>j


#---------------------------------------------------------------------------------------------
# Undo Redo

call submode#enter_with('undo/redo', 'n', '', 'g-', 'g-')
call submode#enter_with('undo/redo', 'n', '', 'g+', 'g+')
call submode#map(       'undo/redo', 'n', '',  '-', 'g-')
call submode#map(       'undo/redo', 'n', '',  '+', 'g+')


#---------------------------------------------------------------------------------------------
# MRU

nnoremap <Space>o <Cmd>MRU<Space>


#---------------------------------------------------------------------------------------------
# コメント行の前後の新規行の自動コメント化

# 自動コメント化のON/OFF
com! -bang RO {
    if &formatoptions =~# 'o' || <bang>false
      set formatoptions-=o formatoptions-=r
    else
      set formatoptions+=o formatoptions+=r
    endif
    echo &formatoptions
  }

nnoremap <Leader># <Cmd>RO<CR>


#---------------------------------------------------------------------------------------------
# ge

submode#enter_with('word_move_ge', 'nvo', '', 'ge', 'ge')
submode#map(       'word_move_ge', 'nvo', '',  'e', 'ge')
submode#map(       'word_move_ge', 'nvo', '',  'E',  'e')
submode#map(       'word_move_ge', 'nvo', '',  'w',  'w')
submode#map(       'word_move_ge', 'nvo', '',  'b',  'b')


#---------------------------------------------------------------------------------------------
# Case Motion

map <silent> W  <Plug>CamelCaseMotion_w
map <silent> B  <Plug>CamelCaseMotion_b
map <silent> E  <Plug>CamelCaseMotion_e
sunmap W
sunmap B
sunmap E

submode#enter_with('CaseMotion_gE', 'nvo', '', 'gE', '<Plug>CamelCaseMotion_ge')
submode#map(       'CaseMotion_gE', 'nvo', '',  'E', '<Plug>CamelCaseMotion_ge')
submode#map(       'CaseMotion_gE', 'nvo', '',  'e', '<Plug>CamelCaseMotion_e')
submode#map(       'CaseMotion_ge', 'nvo', '',  'W', '<Plug>CamelCaseMotion_w')
submode#map(       'CaseMotion_ge', 'nvo', '',  'B', '<Plug>CamelCaseMotion_b')
submode#map(       'CaseMotion_ge', 'nvo', '',  'w', 'w')
submode#map(       'CaseMotion_ge', 'nvo', '',  'b', 'b')

onoremap <silent> iW <Plug>CamelCaseMotion_ib
vnoremap <silent> iW <Plug>CamelCaseMotion_ib
#onoremap <silent> iB <Plug>CamelCaseMotion_ib
#vnoremap <silent> iB <Plug>CamelCaseMotion_ib
#onoremap <silent> iE <Plug>CamelCaseMotion_ib
#vnoremap <silent> iE <Plug>CamelCaseMotion_ib

onoremap <silent> aW <Plug>CamelCaseMotion_iw
vnoremap <silent> aW <Plug>CamelCaseMotion_iw
#onoremap <silent> aB <Plug>CamelCaseMotion_iw
#vnoremap <silent> aB <Plug>CamelCaseMotion_iw
#onoremap <silent> aE <Plug>CamelCaseMotion_iw
#vnoremap <silent> aE <Plug>CamelCaseMotion_iw


#---------------------------------------------------------------------------------------------
# Short Cut

nnoremap <silent> <Leader>r <Cmd>setl readonly!<CR>
nnoremap <silent> <Leader>R <Cmd>exe 'setl' &l:modifiable ? 'readonly nomodifiable' : 'modifiable'<CR>
com! AR setl autoread!

# is key word
nnoremap <silent> + <Cmd>echo '++ ' <Bar> exe 'setl isk+=' .. GetKeyEcho()<CR>
nnoremap <silent> - <Cmd>echo '-- ' <Bar> exe 'setl isk-=' .. GetKeyEcho()<CR>

# scrollbind
nnoremap <Leader>$ <Cmd>setl scrollbind!<CR>


#---------------------------------------------------------------------------------------------
# Browsing

set jumpoptions=stack

# 進む
nnoremap <C-p> <C-O><Cmd>CursorJumped<CR>
# 戻る
nnoremap <C-n> <C-I><Cmd>CursorJumped<CR>

#nnoremap <BS><C-p> <Plug>(MyVimrc-Window-AutoSplit)<C-O>
#nnoremap <BS><C-n> <Plug>(MyVimrc-Window-AutoSplit)<C-I>

# 変更リスト
nnoremap <silent> <C-]> g;<Cmd>CursorJumped<CR>
nnoremap <silent> <C-\> g,<Cmd>CursorJumped<CR>


#---------------------------------------------------------------------------------------------
# Swap_Exists

var swap_select = true

augroup MyVimrc_SwapExists
  au!
  au SwapExists * if !swap_select | v:swapchoice = 'o' | endif
augroup END

com! SwapSelect {
      swap_select = true
      edit %
      swap_select = false
    }


#---------------------------------------------------------------------------------------------
# Folding


# 折り畳みトグル (現在行)
#com! ToggleFold if foldclosed(line('.')) != -1 | foldopen | else | foldclose | endif


# 折り畳みトグル (ファイル)
#def ToggleFolding()
#  normal! zi
#  if &l:foldenable
#    normal! zM
#  endif
#enddef
#nnoremap zi <Cmd><SID>ToggleFolding()<CR>
#nnoremap ZZ zi


# Move to Hunk
#nnoremap ]z <Cmd>try <Bar> exe 'normal! ]z' <Bar> catch exe 'normal! zj' <Bar> endtry<CR>
#nnoremap [z <Cmd>try <Bar> exe 'normal! [z' <Bar> catch exe 'normal! zk' <Bar> endtry<CR>
nnoremap ]z zj
nnoremap [z zk



#---------------------------------------------------------------------------------------------
# Insert Mode Mappings
#---------------------------------------------------------------------------------------------


#---------------------------------------------------------------------------------------------
# 全角括弧
inoremap (( （
inoremap )) ）



#---------------------------------------------------------------------------------------------
# Command Line Mappings
#---------------------------------------------------------------------------------------------


#---------------------------------------------------------------------------------------------
# Emacs
# コマンドラインでのキーバインドを Emacs スタイルにする

# 行頭へ移動
cnoremap <C-a>	<Home>
# 一文字戻る
cnoremap <C-b>	<Left>
# カーソルの下の文字を削除
cnoremap <C-d>	<Del>
# 行末へ移動
cnoremap <C-e>	<End>
# 一文字進む
cnoremap <C-f>	<Right>
# コマンドライン履歴を一つ進む
cnoremap <C-n>	<Down>
# コマンドライン履歴を一つ戻る
cnoremap <C-p>	<Up>
# Emacs Yank
cnoremap <C-y>  <C-R><C-O>*
# 次の単語へ移動
cnoremap <A-f>	<S-Right>
# 前の単語へ移動
cnoremap <A-b>	<S-Left>
# 単語削除
#cnoremap <A-d>	TODO


#---------------------------------------------------------------------------------------------
# コマンドラインで、"<Space>"を入力しやすくする。
cnoremap <expr> <C-V><Space> "<lt>Space>"



#---------------------------------------------------------------------------------------------
# Search & Regex
#---------------------------------------------------------------------------------------------


#---------------------------------------------------------------------------------------------
# /, ?を楽に入力する
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'


#---------------------------------------------------------------------------------------------
# 単語検索にする
#cnoremap <C-O> <C-\>e(getcmdtype() == '/' <Bar><Bar> getcmdtype() == '?') ? '\<' .. getcmdline() .. '\>' : getcmdline()<CR><Left><Left>
cnoremap <Plug>(Cmap-C-O-S) <C-\>e(getcmdtype() == '/' <Bar><Bar> getcmdtype() == '?') ? '\<' .. getcmdline() .. '\>' : getcmdline()<CR><Left><Left>

#---------------------------------------------------------------------------------------------
# CommnadOutputCapture 付きで実行する
cnoremap <Plug>(Cmap-C-O-C) <C-\>e(getcmdtype() == ':'                               ) ? 'CC ' .. getcmdline() : getcmdline()<CR><End>
cnoremap <Plug>(Cmap-C-O-X) <C-\>e(getcmdtype() == ':'                               ) ? 'CommnadOutputCapture ' .. getcmdline() : getcmdline()<CR><End><CR>
cnoremap <Plug>(Cmap-C-O-V) <C-\>e(getcmdtype() == ':'                               ) ? 'verbose ' .. getcmdline() : getcmdline()<CR><End>

#---------------------------------------------------------------------------------------------
# Unified c_Ctrl-O
cnoremap <C-O> <Plug>(Cmap-C-O-S)<Plug>(Cmap-C-O-X)
cnoremap <C-J> <Plug>(Cmap-C-O-X)
cnoremap <C-G> <Plug>(Cmap-C-O-V)


#---------------------------------------------------------------------------------------------
# 正規表現のメタ文字を楽に入力する
cnoremap (( \(
cnoremap )) \)
cnoremap << \<
cnoremap >> \>
cnoremap <Bar><Bar> \<Bar>


#---------------------------------------------------------------------------------------------
# 正規表現 (肯|否)定(先|後)読み
noremap! <C-@>! \%()\@<!<Left><Left><Left><Left><Left>
noremap! <C-@>@ \%()\@<=<Left><Left><Left><Left><Left>
noremap! <C-@># \%()\@=<Left><Left><Left><Left>
noremap! <C-@>$ \%()\@!<Left><Left><Left><Left>


#---------------------------------------------------------------------------------------------
# スペースへの色付け
# TODO nbsp
highlight ZenkakuSpace guibg=#337733 guifg=#eeeeee cterm=underline ctermfg=lightblue
highlight ZenkakuSpace guibg=#433387 guifg=#eeeeee cterm=underline ctermfg=lightblue
syntax match ZenkakuSpace /　/
augroup MyVimrc_ZenkakuSpace
  au!
  au BufNewFile,BufRead * match ZenkakuSpace /　/
 #au BufNewFile,BufRead * matchadd(ZenkakuSpace, '　')
  au BufNew,BufNewFile,BufRead * syntax match ZenkakuSpace /　/
augroup end


#---------------------------------------------------------------------------------------------
# TBC

nnoremap <C-O> <C-L>


nnoremap <silent> gl           <Cmd>setl nowrap!<CR>
nnoremap <silent> <Leader><CR> <Cmd>setl nowrap!<CR>


nnoremap <silent> gf <Plug>(MyVimrc-Window-AutoSplit)gF


noremap! <C-R><C-R> <C-R><C-R>*

cnoremap <C-X><CR> <Home>echo<Space><CR>

cnoremap <C-X><C-X> <Home>verbose<Space><End>


nnoremap <silent> g<C-o> :<C-u>pwd
         \ <Bar> echon '        ' &fileencoding '  ' &fileformat '  ' &filetype '    ' printf('L %d  C %d  %3.2f %%  TL %3d', line('.'), col('.'), line('.') * 100.0 / line('$'), line('$'))
         \ <Bar> echo expand('%:ph')<CR>


#---------------------------------------------------------------------------------------------
# TBC 2

#set whichwrap+=hl

# parent directory
cnoremap <expr> <C-t> getcmdtype() == ':' ? '../' : '<C-t>'
cnoremap <expr> <C-^> getcmdtype() == ':' ? '../' : '<C-^>'

# select function
cnoremap <expr> <C-t> getcmdtype() == ':' ? '../' : '<C-t>'
vnoremap af ][<ESC>V[[
vnoremap if ][k<ESC>V[[j

# paste register
noremap! <C-r><C-r> <C-r><C-r>*


#---------------------------------------------------------------------------------------------
# Command Line WildMenu TBD

#set wildchar=<C-j>

cnoremap <C-G> <Tab>
cnoremap <C-J> <Tab>
cnoremap <C-K> <S-Tab>

# cnoremap <C-L> <C-D>
# cnoremap <C-J> <C-D>


#---------------------------------------------------------------------------------------------
# TBC 3

inoremap <C-F> <C-P>
inoremap <C-J> <C-N>

inoremap <C-F> <Right>
inoremap <C-B> <Left>
inoremap <C-A> <Home>
inoremap <C-E> <End>

#inoremap <CR> <C-]><C-G>u<CR>
#inoremap <C-H> <C-G>u<C-H>




finish




#---------------------------------------------------------------------------------------------

nnoremap ]3 ]#
nnoremap [3 [#

nnoremap ]8 ]*
nnoremap [8 [*


# 折り畳みトグル
def ToggleFolding()
  for i in range(1, line('$'))
    if foldclosed(i) != -1
      normal! zR
      "echo "folding open"
      return
    endif
  endfor
  normal! zM
  #echo "folding close"
  return
endfunction


nnoremap <C-@> g-
nnoremap <C-^> g+


nnoremap <silent> z+ :exe 'setl isk+=' . substitute(input('isk++ '), '.\($\)\@!', '&,', 'g')<CR>
nnoremap <silent> z- :exe 'setl isk-=' . substitute(input('isk-- '), '.\($\)\@!', '&,', 'g')<CR>
nnoremap <silent> z= :exe 'setl isk+=' . substitute(input('isk++ '), '.\($\)\@!', '&,', 'g')<CR>


nnoremap <C-Tab> <C-w>p
