" ---------------------------------------------------------------------------------------------------------------------------------------------------------
"  Completion

set completeopt=menuone

let g:CompleteKey = "\<C-n>"


" 全文字キーへの補完開始トリガの割り当て
function! SetCpmplKey(str)
  for k in split(a:str, '\zs')
    exec "inoremap <expr> " . k . " pumvisible() ? '" . k . "' : search('\\k\\{1\\}\\%#', 'bcn') ? TriggerCompleteDefault('" . k . "')" . " : '" . k . "'"
  endfor
endfunction
call SetCpmplKey('_0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ')
"inoremap <expr> <BS> pumvisible() ? (search('\k\k\k\k\%#', 'bcn') ? '<BS>' : "\<BS>") : (search('\k\k\k\%#', 'bcn') ? TriggerCompleteDefault("\<BS>") : "\<BS>")
inoremap <expr> <BS> pumvisible() ? "\<BS>" : ((search('\k\k\k\%#', 'bcn') && !search('[あ-ん][あ-ん][あ-ん]\%#', 'bcn')) ? TriggerCompleteDefault("\<BS>") : "\<BS>")


" 補完を開始する
function! TriggerCompleteDefault(insert_key)
  return TriggerComplete(g:CompleteKey, a:insert_key, 'x')
endfunc

let s:compl_kind = 'x'
function! TriggerComplete(start_key, insert_key, kind)
  let s:compl_kind = a:kind
  try
    iunmap jj
    call Map_gg()
  catch
  finally
  endtry
  call feedkeys(a:start_key . "\<C-p>", 'n')
  return a:insert_key
endfunc


" 補完中のj,kキーの処理を行う
function! Complete_jk(key)
  try
    iunmap jj
    call Map_gg()
  catch
  finally
  endtry
  call feedkeys(a:key, 'n')
  return ''
endfunction


function! Map_gg()
  "imap gg <Plug>(Completion-Yes-And-InsertLeave)
  imap <expr> gg pumvisible() ? '<Plug>(Completion-Yes-And-InsertLeave)' : '<Plug>(InsertLeave)'
endfunction


inoremap <Plug>(Completion-Yes) <C-y>

inoremap <expr> <Plug>(InsertLeavePre)  InsertLeavePre_Hook()
inoremap <Plug>(I-Esc) <Esc>
" ここはnnoremapでなければならない。
" nnoremap <Plug>(InsertLeavePost) l:w<CR>
nnoremap <expr> <Plug>(InsertLeavePost) InsertLeavePost_Hook()

imap <Plug>(InsertLeave) <Plug>(InsertLeavePre)<Plug>(I-Esc)<Plug>(InsertLeavePost)
imap <Plug>(Completion-Yes-And-InsertLeave) <Plug>(Completion-Yes)<Plug>(InsertLeave)


" 候補選択
"inoremap <expr> j pumvisible() ? Complete_jk("\<C-n>") : TriggerCompleteDefault('j')
"inoremap <expr> k pumvisible() ? Complete_jk("\<C-p>") : TriggerCompleteDefault('k')
"inoremap <expr> J pumvisible() ? Complete_jk("\<C-n>") : TriggerCompleteDefault('j')
"inoremap <expr> K pumvisible() ? Complete_jk("\<C-p>") : TriggerCompleteDefault('k')

" 日本語入力時用 + 強制補完開始
inoremap <expr> <C-j> pumvisible() ? Complete_jk("\<C-n>") : TriggerCompleteDefault('')
inoremap <expr> <C-k> pumvisible() ? Complete_jk("\<C-p>") : TriggerCompleteDefault('')

" 日本語入力時の補完確定
imap <expr> <C-g> pumvisible() ? '<Plug>(Completion-Yes-And-InsertLeave)' : '<Plug>(InsertLeave)'

" ファイル名補完
inoremap <expr> <C-l>                                         TriggerComplete('<C-x><C-f>', '', 'f')
inoremap <expr> <C-l> "\<C-o>:cd " . GetPrjRoot() . "\<CR>" . TriggerComplete('<C-x><C-f>', '', 'f')

" 短縮入力を展開 & Hook発動 & 行ごとにUndo & 改行
inoremap <expr> <CR>  pumvisible() ? '<C-y>' : '<C-]>' . NewLine_Hook() . '<C-G>u' . '<CR>'
inoremap <expr> <Esc> pumvisible() ? '<C-e>' : '<Esc>l'


augroup MyVimrc_Completion
  au!

  au CompleteDone * if v:completed_item != {} | call s:Completion_Yes_Hook() | else | call s:Completion_Esc_Hook() | endif

  au InsertEnter,CompleteDone * imap jj <Plug>(InsertLeave)
  au InsertEnter let s:erace_num = 0

  " Insert Mode を<C-c>で抜けたとき用に、InsertEnterでも無効化する。
  au InsertEnter,CompleteDone * try | iunmap gg | catch | finally
augroup end


function! s:Completion_Yes_Hook()
  " TODO 重複部分を消す
  " TODO メタ文字 兼 キーワードのエスケープ
  if search('\%#\k\+', 'cnz')
    let s:compl_word = v:completed_item['word']
    let s:cursor_word = expand('<cword>')

    let s:left_word = s:compl_word
    let s:right_word = substitute(s:cursor_word, '^\V' . s:left_word, '', 'g')

    if len(s:right_word) > 1
      " 念のため
      let s:left_left_word  = substitute(s:left_word, '\V' . s:right_word . '\$', '', 'g')
      let s:erace_num = len(s:left_word) - len(s:left_left_word)
      "let s:key = repeat("\<Del>", s:erace_num)
      "call feedkeys(repeat("\<Del>", s:erace_num), 'ni')
      " Delじゃなく、BSにしておかないと、ドットリピート時に意図しないことになる。
      "   例: 下記で、DefをXyzに変える場合。
      "       Abc_Def_ghi0
      "       Abc_Def_ghi1
      call feedkeys(repeat("\<BS>", s:erace_num) . repeat("\<Right>", s:erace_num), 'ni')
    endif
  endif
  return ''
endfunction
function! s:Completion_Yes_Hook()
  " TODO 重複部分を消す
  " TODO メタ文字 兼 キーワードのエスケープ
  if search('\%#\k\+', 'cnz')
    let s:compl_word = v:completed_item['word']
    let s:cursor_word = expand(s:compl_kind == 'f' ? '<cfile>' : '<cword>')

    let s:left_word = s:compl_word
    let s:right_word = substitute(s:cursor_word, '^\V' . s:left_word, '', 'g')

    if len(s:right_word) > 1
      " 念のため
      let s:left_left_word  = substitute(s:left_word, '\V' . s:right_word . '\$', '', 'g')
      let s:erace_num = len(s:left_word) - len(s:left_left_word)
      "let s:key = repeat("\<Del>", s:erace_num)
      "call feedkeys(repeat("\<Del>", s:erace_num), 'ni')
      " Delじゃなく、BSにしておかないと、ドットリピート時に意図しないことになる。
      "   例: 下記で、DefをXyzに変える場合。
      "       Abc_Def_ghi0
      "       Abc_Def_ghi1
      call feedkeys(repeat("\<BS>", s:erace_num) . repeat("\<Right>", s:erace_num), 'ni')
    endif
  endif
  return ''
endfunction
com! CCC echo s:left_word s:compl_word s:cursor_word s:right_word s:left_left_word s:erace_num | "s:key


function! s:Completion_Esc_Hook()
  " do nothing
  return ''
endfunction

function! NewLine_Hook()
  " TODO semicolon
  return InsertLast()
  return ''
endfunction

function! InsertLeavePre_Hook()
  " TODO semicolon
  return InsertLast()
  return ''
endfunction


" 中間補完のとき、カーソルが補完位置にとどまるようにようにした。
let s:erace_num = 0

function! InsertLeavePost_Hook()
 "return "l:w\<CR>"
 "return repeat('h', s:erace_num) . "l:w\<CR>"
 "return repeat('h', s:erace_num) . "l:update\<CR>"
 "return repeat('h', s:erace_num) . 'l' . (bufname('')=='' ? '' : ":update\<CR>")
  return repeat('h', s:erace_num) . 'l' . ":update\<CR>"
 "return repeat('h', s:erace_num) . 'l' . ':update<CR>'
endfunction


function! Completion_Yes_Hook()
  normal! "zye
  echo @z
endfunction

function! Completion_Yes_Hook()
  let compl_word = v:completed_item['word']
  let right_word = ''
endfunction


" -----------------------------------------------------------------------------
  " TODO semicolon

function! InsertLast()
  if &ft == 'c' || &ft == 'cpp'
    " enumなどの中なら、セミコロンではなく、カンマとする。
    return Semicolon_plus()
  else
    return ''
  endif
endfunction

function! Semicolon_plus()
  return ''
endfunction

" -----------------------------------------------------------------------------




" inoremap <expr> <Plug>(I-NewLine) '<C-]>' . NewLine_Hook() . '<C-G>u' . '<CR>'

" inoremap <silent> <expr> <Plug>(Completion-Yes) '<C-y>' . Completion_Yes_Hook()
" inoremap <silent> <expr> <Plug>(Completion-Esc) '<C-e>' . Completion_Esc_Hook()
"inoremap <expr> <C-l>  pumvisible() ? "\<C-l>" : TriggerComplete2('<C-x><C-f>')



