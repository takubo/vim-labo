vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8



#---------------------------------------------------------------------------------------------
# Initialize
#---------------------------------------------------------------------------------------------


#---------------------------------------------------------------------------------------------
# Leader
legacy let mapleader = "\<Space>"

# Leader(Space)の空打ちで、カーソルが一つ進むのが鬱陶しいので。
nnoremap <Leader> <Nop>


#---------------------------------------------------------------------------------------------
# 無名バッファなら、pwd。そうでなければ、保存。
nnoremap <expr> <silent> <Leader>w bufname() == '' ? '<Cmd>pwd<CR>' : '<Cmd>update<CR>'


#---------------------------------------------------------------------------------------------
# Basic
noremap ; :

# ; を連続で押してしまったとき用。
cnoremap <expr> ; getcmdline() =~# '^:*$' ? ':' : ';'
cnoremap <expr> : getcmdline() =~# '^:*$' ? ';' : ':'

nnoremap Y y$

# nnoremap ' "

nnoremap <silent> ZZ <Nop>
nnoremap <silent> ZQ <Nop>

# IME状態の切り替えをさせない。
inoremap <C-^> <Nop>

nnoremap gcc 0cc
nnoremap gC  0cc
#nnoremap gA S


#---------------------------------------------------------------------------------------------
nnoremap <silent> <C-o> o<Esc>
#nnoremap <silent> <C-o> :<C-u>call append(expand('.'), '')<CR>j


#---------------------------------------------------------------------------------------------
nnoremap g4 g$
nnoremap g6 g^

nnoremap ]3 ]#
nnoremap [3 [#

nnoremap ]8 ]*
nnoremap [8 [*


#---------------------------------------------------------------------------------------------
def SwitchLineNumber()
  if !&l:number && !&l:relativenumber
    &l:number = true
  elseif &l:number && !&l:relativenumber
    &l:relativenumber = true
  else
    &l:number = false
    &l:relativenumber = false
  endif
enddef
nnoremap <silent> <Leader># <ScriptCmd>SwitchLineNumber()<CR>


#---------------------------------------------------------------------------------------------
# MRU
nnoremap <Space>o :<C-u>MRU<Space>


#---------------------------------------------------------------------------------------------
# Undo Redo
call submode#enter_with('undo/redo', 'n', '', 'g-', 'g-')
call submode#enter_with('undo/redo', 'n', '', 'g+', 'g+')
call submode#map(       'undo/redo', 'n', '', '-',  'g-')
call submode#map(       'undo/redo', 'n', '', '+',  'g+')


#---------------------------------------------------------------------------------------------
# コメント行の後の新規行の自動コメント化のON/OFF
#nnoremap <expr> <Leader>@
#      \ &formatoptions =~# 'o' ?
#      \ ':<C-u>set formatoptions-=o<CR>:set formatoptions-=r<CR>' :
#      \ ':<C-u>set formatoptions+=o<CR>:set formatoptions+=r<CR>'


#---------------------------------------------------------------------------------------------
# TODO
#nmap <silent> W <Plug>CamelCaseMotion_w
#nmap <silent> B <Plug>CamelCaseMotion_b
#if 0
#  noremap E ge
#  map <silent> ge <Plug>CamelCaseMotion_e
#  map <silent> gE <Plug>CamelCaseMotion_ge
#elseif 1
#  map E  <Plug>CamelCaseMotion_e
#  map gE <Plug>CamelCaseMotion_ge
#else
#  map E  <Plug>CamelCaseMotion_e
#  map gE <Plug>CamelCaseMotion_ge
#
#  call submode#enter_with('ge', 'nvo', '', 'ge', 'ge')
#  call submode#map(       'ge', 'nvo', '', 'e',  'ge')
#  call submode#map(       'ge', 'nvo', '', 'E',  'e')
#  call submode#enter_with('gE', 'nvo', 'r', 'gE', '<Plug>CamelCaseMotion_ge')
#  call submode#map(       'gE', 'nvo', 'r', 'E',  '<Plug>CamelCaseMotion_ge')
#  call submode#map(       'gE', 'nvo', 'r', 'e',  '<Plug>CamelCaseMotion_e')
#endif


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
# 検索時に/, ?を楽に入力する
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'

#---------------------------------------------------------------------------------------------
# 正規表現のメタ文字を楽に入力する
cnoremap (( \(
cnoremap )) \)
cnoremap << \<
cnoremap >> \>
cnoremap <Bar><Bar> \<Bar>

#---------------------------------------------------------------------------------------------
# 正規表現 (肯|否)定(先|後)読み
# cnoremap <C-@>! \%()\@<!<Left><Left><Left><Left><Left>
# cnoremap <C-@>@ \%()\@<=<Left><Left><Left><Left><Left>
# cnoremap <C-@># \%()\@=<Left><Left><Left><Left>
# cnoremap <C-@>$ \%()\@!<Left><Left><Left><Left>

#---------------------------------------------------------------------------------------------
# 単語検索にする
cnoremap <C-o> <C-\>e(getcmdtype() == '/' <Bar><Bar> getcmdtype() == '?') ? '\<' .. getcmdline() .. '\>' : getcmdline()<CR><Left><Left>


finish



nnoremap ' "
vnoremap ' "
nnoremap '' "0
vnoremap '' "0

nnoremap " '
vnoremap " '
nnoremap ` m
vnoremap ` m



" Basic {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

cnoremap <expr> <C-t> getcmdtype() == ':' ? '../' : '<C-t>'
cnoremap <expr> <C-^> getcmdtype() == ':' ? '../' : '<C-^>'


nmap <Leader>2 <Leader>@
nmap <Leader>3 <Leader>#


vnoremap af ][<ESC>V[[
vnoremap if ][k<ESC>V[[j


nnoremap <silent> +  :echo '++ ' <Bar> exe 'setl isk+=' . GetKeyEcho()<CR>
nnoremap <silent> -  :echo '-- ' <Bar> exe 'setl isk-=' . GetKeyEcho()<CR>
nnoremap <silent> z+ :exe 'setl isk+=' . substitute(input('isk++ '), '.\($\)\@!', '&,', 'g')<CR>
nnoremap <silent> z- :exe 'setl isk-=' . substitute(input('isk-- '), '.\($\)\@!', '&,', 'g')<CR>
nnoremap <silent> z= :exe 'setl isk+=' . substitute(input('isk++ '), '.\($\)\@!', '&,', 'g')<CR>

" Basic }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}


" EscEsc {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

nmap <Esc><Esc> <Plug>(EscEsc)

if !exists('s:EscEsc_Add_Done')
  " おかしくなったときにEscEscで復帰できるように、念のためforceをTrueにして呼び出す。
  call EscEsc_Add('call RestoreDefaultStatusline(v:true)')
  call EscEsc_Add('call clever_f#reset()')
endif
"let s:EscEsc_Add_Done = v:true

" EscEsc }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}


" Other Key-Maps {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

nnoremap <leader>w :<C-u>w<CR>
nnoremap <silent> <leader>w :<C-u>update<CR>
"nnoremap <silent> <expr> <leader>w ':<C-u>' . (bufname('')=='' ? 'write' : 'update') . '<CR>'
"nnoremap <silent> <Leader>e :update<CR>
nmap <silent> <Leader>e <Leader>w

nnoremap <silent> <expr> <Leader>r &l:readonly ? ':<C-u>setl noreadonly<CR>' : ':<C-u>setl readonly<CR>'
nnoremap <silent> <expr> <Leader>R &l:modifiable ? ':<C-u>setl nomodifiable <BAR> setl readonly<CR>' : ':<C-u>setl modifiable<CR>'
nnoremap <leader>L :<C-u>echo len("<C-r><C-w>")<CR>
nnoremap <silent> yx :PushPos<CR>ggyG:PopPos<CR> | ":echo "All lines yanked."<CR>

"nnoremap <silent> <C-o> :<C-u>exe (g:alt_stl_time > 0 ? '' : 'normal! <C-l>')
"                      \ <Bar> let g:alt_stl_time = 12
nnoremap <silent> g<C-o> :<C-u>pwd
                      \ <Bar> echon '        ' &fileencoding '  ' &fileformat '  ' &filetype '    ' printf('L %d  C %d  %3.2f %%  TL %3d', line('.'), col('.'), line('.') * 100.0 / line('$'), line('$'))
                      \ <Bar> call SetAltStatusline('%#hl_buf_name_stl#  %F', 'g', 10000)<CR>


"nnoremap <C-Tab> <C-w>p
inoremap <C-f> <C-p>
inoremap <C-e>	<End>
"inoremap <CR> <C-]><C-G>u<CR>
inoremap <C-H> <C-G>u<C-H>

nnoremap <silent> gl :setl nowrap!<CR>
nnoremap <silent> <Leader><CR> :setl nowrap!<CR>

nnoremap gG G

nnoremap <silent> gf :<C-u>aboveleft sp<CR>gF

nnoremap <Plug>(Normal-gF) gF
nmap <silent> gf <Plug>(MyVimrc-Window-AutoSplit)<Plug>(Normal-gF)

" Other Key-Maps }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}


nnoremap <Leader>$ :<C-u>setl scrollbind!<CR>
nmap <Leader>4 <Leader>$


"+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
if 0
  nnoremap <C-i> g;
  nnoremap <C-o> g,

  nmap ' \

  set whichwrap+=hl
endif
"+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

"cmap <C-j> <Tab>
"cmap <C-k> <S-Tab>
"set wildchar=<C-j>


cnoremap <C-l> <C-d>
cnoremap <C-j> <C-d>
" cunmap <C-d>
cnoremap <C-j> <C-d>
cnoremap <C-k> <S-Tab>


"highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=#ffffff
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=#333377
augroup MyVimrc_ZenkakuSpace
  au!
  au BufNewFile,BufRead * match ZenkakuSpace /　/
augroup end


cnoremap <C-r><C-t> <C-r><C-r>*
cnoremap <C-r><C-r> <C-r><C-r>*
inoremap <C-r><C-r> <C-r><C-r>*


" Fold {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{


nnoremap ]z :try <Bar> exe 'normal! ]z' <Bar> catch exe 'normal! zj' <Bar> endtry<CR>

com! ToggleFold if foldclosed(line('.')) != -1 | foldopen | else | foldclose | endif

" Fold }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}


" 折り畳みトグル
function! Toggle_folding()
  for i in range(1, line('$'))
    if foldclosed(i) != -1
      normal! zR
      "echo "folding open"
      return
    endif
  endfor
  normal! zM
  "echo "folding close"
  return
endfunction
nnoremap ZZ :<C-u>call Toggle_folding()<CR>


" 折り畳みトグル
function! Toggle_folding()
  normal! zi
  if &l:foldenable
    normal! zM
  endif
  return
endfunction
nnoremap zi :<C-u>call Toggle_folding()<CR>
