scriptencoding utf-8
" vim:set ts=8 sts=2 sw=2 tw=0:
" (この行に関しては:help modelineを参照)


" GUI {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

" nnoremap <silent> <F9>  :exe 'winpos' getwinposx() - 1 ' ' getwinposy() - 0<CR>
" nnoremap <silent> <F10> :exe 'winpos' getwinposx() + 0 ' ' getwinposy() + 1<CR>
" nnoremap <silent> <F11> :exe 'winpos' getwinposx() - 0 ' ' getwinposy() - 1<CR>
" nnoremap <silent> <F12> :exe 'winpos' getwinposx() + 1 ' ' getwinposy() + 0<CR>
" 
" nnoremap <silent> <S-F9>  :let &columns -= 1<CR>
" nnoremap <silent> <S-F10> :let &lines   += 1<CR>
" nnoremap <silent> <S-F11> :let &lines   -= 1<CR>
" nnoremap <silent> <S-F12> :let &columns += 1<CR>

" GUI }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}


" {{{

hi HlWord	guifg=#4050cd	guibg=white
hi HlWord	guibg=#4050cd	guifg=white
hi HlWord	guibg=NONE	guifg=NONE
hi HlWord	gui=reverse
hi HlWord	gui=NONE
hi HlWord	guibg=gray30	guifg=gray80
nnoremap <silent> <leader>` :<C-u>match HlWord /\<<C-r><C-w>\>/<CR>
"call EscEsc_Add('PushPosAll')
"call EscEsc_Add('windo match')
"call EscEsc_Add('PopPosAll')
augroup MyHiLight
  au!
  au WinLeave * match
augroup end


"match CursorLineNr /\%#./

" `}}}


let plugin_dicwin_disable = v:true


"nnoremap  ]]  ]]f(bzt
"nnoremap g]]  ]]f(b
"nnoremap  [[  [[f(bzt
"nnoremap g[[  [[f(b
"nnoremap  ][  ][zb
"nnoremap g][  ][
"nnoremap  []  []zb
"nnoremap g[]  []


cabb f find


"com! -nargs=+ F
"      \ exe 'sfind ' . ('<args>'[0] == '.' ? '' : '*') . substitute('<args>', ' ', '*', 'g') . '*'


com! -nargs=+ F
      \ try | exe 'find' <q-args> | catch |
      \ try | exe 'find ' . ('<args>'[0] == '.' ? '' : '*') . substitute('<args>', ' ', '*', 'g') . '*' | catch |
      \ call feedkeys(':find *' . substitute('<args>', ' ', '*', 'g') . '*<Tab><Tab><Tab>', 'nt') | endtry | endtry

com! -nargs=+ S
      \ try | exe 'sfind' <q-args> | catch |
      \ try | exe 'sfind ' . ('<args>'[0] == '.' ? '' : '*') . substitute('<args>', ' ', '*', 'g') . '*' | catch |
      \ call feedkeys(':sfind *' . substitute('<args>', ' ', '*', 'g') . '*<Tab><Tab><Tab>', 'nt') | endtry | endtry

com! -nargs=+ T
      \ try | exe 'tab sfind' <q-args> | catch |
      \ try | exe 'tab sfind ' . ('<args>'[0] == '.' ? '' : '*') . substitute('<args>', ' ', '*', 'g') . '*' | catch |
      \ call feedkeys(':tab sfind *' . substitute('<args>', ' ', '*', 'g') . '*<Tab><Tab><Tab>', 'nt') | endtry | endtry


if 0
  com! -nargs=+ S
        \ try | exe 'sfind' <q-args> | catch
        \ try | exe 'sfind ' . ('<args>'[0] == '.' ? '' : '*') . substitute('<args>', ' ', '*', 'g') . '*' | 
        \ catch | call feedkeys(':sfind *' . substitute('<args>', ' ', '*', 'g') . '*<Tab>', 'nt') | endtry

  com! -nargs=+ T
        \ try | exe 'tab sfind' <q-args> | catch
        \ try | exe 'tab sfind ' . ('<args>'[0] == '.' ? '' : '*') . substitute('<args>', ' ', '*', 'g') . '*' | 
        \ catch | call feedkeys(':tab sfind *' . substitute('<args>', ' ', '*', 'g') . '*<Tab>', 'nt') | endtry
endif

"com! -nargs=+ F
"      \ exe 'find ' . ('<args>'[0] == '.' ? '' : '*') . substitute('<args>', ' ', '*', 'g') . '*'


"com! -nargs=+ F
"     \ call feedkeys(':find *' . substitute('<args>', ' ', '*', 'g') . '*<Tab>', 'nt')
"     \ try | exe 'find' <q-args> | catch
"     \ try | exe 'find ' . ('<args>'[0] == '.' ? '' : '*') . substitute('<args>', ' ', '*', 'g') . '*' | endtry |
"     \ catch | call feedkeys(':find *' . substitute('<args>', ' ', '*', 'g') . '*<Tab>', 'nt') | endtry

"---------------------------------------------------------------------------------------------

function! Find(arg)
  "echo a:arg
  "et f = a:arg

  let f = substitute(a:arg, ' ', '*', 'g')

  if a:arg !~ '^\^'
    let f = substitute(f, '^', '*', '')
  elseif a:arg !~ '^;'
    let f = substitute(f, '^;', '^', '')
  else
    let f = substitute(f, '^\^', '', '')
  endif

  if a:arg !~ '\$$'
    let f = substitute(f, '$', '*', '')
  elseif a:arg !~ ';$'
    let f = substitute(f, ';$', '$', '')
  else
    let f = substitute(f, '\$$', '', '')
  endif

  "exe 'find' f
  call feedkeys(':find '. f . "\<Tab>\<Tab>", 'nt')
endfunction

com! -bar -nargs=* Find call Find(<q-args>)
com! -bar -nargs=* F Find <args>


nnoremap <Leader>9 :<C-u>RainbowParenthesesToggle<CR>


augroup MyVimrc_ChDir
  au!
 "au DirChanged window,tabpage,global pwd
  au DirChanged global pwd
augroup end


" test.vim {{{


function! s:GoToDeclaration()
  let cl0 = line(".")
  let bn0 = bufnr(0)

  set tags=./tags
  try
    "tjump
    "exe "normal! \<C-]>"
    normal! 
  catch
  endtry
  let cl = line(".")
  let bn = bufnr(0)
  if cl0 != cl || bn0 != bn | return | endif

  set tags=tags;
  try
    "tjump
    "exe "normal! \<C-]>"
    normal! 
  catch
  endtry
  let cl = line(".")
  let bn = bufnr(0)
  if cl0 != cl || bn0 != bn | return | endif

  try
    normal! gD
    let cl = line(".")
    let bn = bufnr(0)
  catch
  endtry
  if cl0 != cl || bn0 != bn | return | endif

  try
    normal! gd
    let cl = line(".")
    if cl0 != cl | return | endif
  catch
  endtry

  " echoe 'Declaration not found.'
  echo 'Declaration not found.'
endfunction
"call <SID>GoToDeclaration()
"nnoremap <buffer> <silent> <CR> :<C-u>call <SID>GoToDeclaration()<CR>
"nnoremap  <CR> :<C-u>call <SID>GoToDeclaration()<CR>

" TODO
" 念のため、バッファが変わったことも確認する。
" なぜか、statusline用のauが効かないので、独自にbuf_name_lenの設定を行う。
"


""" Form Vimrc


"nnoremap s f_l
"nnoremap S F_h
"nnoremap ci s
"nnoremap cI S


" test.vim }}}


" 起動速度

" どうしようもない時間は、170ms程度。余裕を見て180～200msくらいか。

"let did_install_default_menus = 1
" TODO $VIMRUNTIME/menu.vimを削除する。

" 以下を削除。
" $VIM\gvimrc
" $HOME\_gvimrc
" $VIMRUNTIME\gvimrc_example.vim


" TODO 不正なプリプロ命令をハイライト


" Bug Issue
"     ・E443のメッセージ
"     ・NerdTreeVCS が無限ループ
"     ・zl zh が動かなくなる
"     ・find でワイルドカードを使用すると、E480のエラー。
"     ・CursorLineがONで、改行を含む文字列を検索したとき、hlsearchでの改行のハイライトがカレント行のときだけになるのは、おかしい。
"


" Gdiffsplit
" :ReVimrc
" ":!git
" :e


" nmap alt 使用済み <A-
" f b o n p
" h j k l


set cedit=<C-q>

hi PPP	guifg=#f6f3f0	guibg=#292927	gui=none	ctermfg=254	ctermbg=235
set previewpopup=height:30,width:120,highlight:PPP


let g:EmAutoState = v:false


nnoremap <Leader>D :<C-u>e .<CR>


if 0
  set shellpipe=2>\&1\|iconv\ -f\ cp932\ -t\ utf-8\ -c>%s
  set shellpipe=2>\&1\|iconv\ -f\ cp932\ -t\ utf-8\ -c\ 2>\&1\|tee\ >%s
  set shellpipe=2>\&1\|iconv\ -f\ cp932\ -t\ utf-8\ -c\ 2>\&1\|tee
else
  "set shellpipe&
  set shellpipe=2>\&1\|tee
endif


if g:UseHHKB
  inoremap <Down>   <C-n>
  inoremap <Up>     <C-p>
  cnoremap <Down>   <C-n>
  cnoremap <Up>     <C-p>
endif


"++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
" from Unified_Tab.vim


function! GetLocationlistWinid()
  return getloclist(winnr(), {'winid' : 0}).winid
endfunction

function! IsLocationlistWindowOpen()
  return GetLocationlistWinid() != 0
endfunction


"---------------------------------------------------------------------------------------------

iab FORI for ( uint32_t i = 0U; i < N; i++ ) {<CR><CR>}
iab <silent> FORI for ( uint32_t i = 0U; i < N; i++ ) {<CR><CR>}<C-R>=Eatchar('\s')<CR>

iab LOOP while ( 1 ) {<CR>}

" iab IF0 #if 0
" #else
" #endif<C-R>=Eatchar('\s')<CR>


"---------------------------------------------------------------------------------------------

" ^に、|の機能を付加
"nnoremap <silent> U <Esc>:exe v:prevcount ? ('normal! ' . v:prevcount . '<Bar>') : 'normal! ^'<CR>
"nnoremap <expr> <silent> U v:prevcount ? (v:prevcount . '<Bar>') : '^'
"nnoremap <expr> <silent> U v:prevcount ? (v:prevcount . '<Bar>') : search('^\s*\%#', 'bcn') ? '0' : '^'
"nnoremap <expr> <silent> U v:prevcount ? (v:prevcount . '<Bar>') : search('^\s\+\%#\S', 'bcn') ? '0' : '^'
nnoremap <expr> <silent> U v:prevcount ? (v:prevcount . '<Bar>') : search('^\s\+\%#\S\?', 'bcn') ? '0' : '^'
vnoremap <expr> <silent> U v:prevcount ? (v:prevcount . '<Bar>') : search('^\s\+\%#\S\?', 'bcn') ? '0' : '^'
"nnoremap <expr> <silent> U v:prevcount ? (v:prevcount . '<Bar>') : search('^\s\+\%#\(\S\|\s$\)', 'bcn') ? '0' : '^'
"vnoremap <expr> <silent> U v:prevcount ? (v:prevcount . '<Bar>') : '^'

"""  " ^に、|の機能を付加
"""  nnoremap <silent> ^ <Esc>:exe v:prevcount ? ('normal! ' . v:prevcount . '<Bar>') : 'normal! ^'<CR>
nnoremap <silent> U <Esc>:exe 'normal!' v:prevcount ? (v:prevcount . '<Bar>') : search('^\s\+\%#\S\?', 'bcn') ? '0' : '^' <CR>
vnoremap <silent> U <Esc>:exe 'normal!' v:prevcount ? (v:prevcount . '<Bar>') : search('^\s\+\%#\S\?', 'bcn') ? '0' : '^' <CR>
"onoremap <silent> U <Esc>:exe 'normal!' v:prevcount ? (v:prevcount . '<Bar>') : search('^\s\+\%#\S\?', 'bcn') ? '0' : '^' <CR>
onoremap <expr> <silent> U search('^\s\+\%#\S\?', 'bcn') ? '0' : '^'
"nnoremap <expr> <silent> U v:prevcount ? (v:prevcount . '<Bar>') : search('^\s\+\%#\S\?', 'bcn') ? '0' : '^' <CR>

nnoremap zU g0

nnoremap 0 g0
nnoremap $ g$

" 補償
vnoremap gu u
vnoremap gU U


" 矯正
" nnoremap ^ <Nop>
" nnoremap $ <Nop>
" vnoremap ^ <Nop>
" vnoremap $ <Nop>


"---------------------------------------------------------------------------------------------

if 0
  nnoremap <silent> t <Esc>:exe 'normal!' v:prevcount ? (v:prevcount . '<Bar>') : search('^\s\+\%#\S\?', 'bcn') ? '0' : '^' <CR>
  vnoremap <silent> t <Esc>:exe 'normal!' v:prevcount ? (v:prevcount . '<Bar>') : search('^\s\+\%#\S\?', 'bcn') ? '0' : '^' <CR>

  nmap U *
  nnoremap T $
endif


"---------------------------------------------------------------------------------------------

nnoremap ! q


"---------------------------------------------------------------------------------------------

" com! Tac !tac


"---------------------------------------------------------------------------------------------
cab <silent> J *<C-R>=Eatchar('\s')<CR>
cab J *
cnoremap <C-j> *
cnoremap <C-g> %
