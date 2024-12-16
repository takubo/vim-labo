vim9script
# vim:set ts=8 sts=2 sw=2 tw=0 expandtab2
scriptencoding utf-8


# ---------------------------------------------------------------------------------------------------------------------------------------------------------
# JK-Complete.vim
# ---------------------------------------------------------------------------------------------------------------------------------------------------------


# ---------------------------------------------------------------------------------------------------------------------------------------------------------
# Initialize

set complete=.,w,i,t,b,u
set completeopt=menuone,noselect # TODO ,fuzzy
set pumheight=30

# こうしないと、「イベントグループが存在しない」というエラーになる。
augroup JKComplete | au! | augroup end

augroup JKComplete
  au InsertLeave * normal! l
augroup end


# -----------------------------------------
# Basic

# <Esc>
inoremap <expr> <Esc> pumvisible() ? '<C-E>' : '<Esc>'

# jj
augroup JKComplete
  au InsertEnter,CompleteDone * inoremap jj <Esc><Cmd>update<CR>
augroup end

# <CR> 短縮入力を展開 & Hook発動 & 行ごとにUndo & 改行
inoremap <expr> <CR>  pumvisible() ? '<C-Y>' : '<C-]>' .. '<C-G>u' .. '<CR>'

# gg
inoremap <expr> <Plug>(JK-Complete-GG) (pumvisible() ? '<C-Y>' : '') .. '<Esc>' .. (bufname('') == '' ? '' : ":update\<CR>")


# -----------------------------------------
# Completion

def MapCoompleteTriggerChar(idx_dummy: number, char: string): string
  exec "inoremap <expr> " .. char .. " <bool>pumvisible() ? '" .. char .. "' : search('\\k\\{1\\}\\%#', 'bcn') != 0 ? StartComplete('" .. char .. "')" .. " : '" .. char .. "'"
  return ""
enddef

map('_0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', MapCoompleteTriggerChar) # TODO foreach
map('ァアィイゥウェエォオカガキギクグケゲコゴサザシジスズセゼソゾタダチヂッツヅテデトドナニヌネノハバパヒビピフブプヘベペホボポマミムメモャヤュユョヨラリルレロヮワヰヱヲンヴヵヶヷヸヹヺー', MapCoompleteTriggerChar) # TODO foreach

# TODO BackSpace
# inoremap <expr> <BS> <bool>pumvisible() ? "\<BS>" : ((search('\k\k\k\%#', 'bcn') != 0 && search('[ぁ-ん][ぁ-ん][ぁ-ん]\%#', 'bcn') == 0) ? StartComplete("\<BS>") : "\<BS>")

# 候補選択
augroup JKComplete
  au InsertEnter,CompleteDone * inoremap <expr> j search('\k\{1\}\%#', 'bcn') != 0 ? StartComplete('j') : 'j'
augroup end
inoremap <expr> k <bool>pumvisible() ? "\<C-P>" : search('\k\{1\}\%#', 'bcn') != 0 ? StartComplete('k') : 'k'

# 日本語入力時用 + 強制補完開始
inoremap <expr> <A-j>  pumvisible() ? "\<C-N>" : StartComplete('')
inoremap <expr> <A-k>  pumvisible() ? "\<C-P>" : StartComplete('')
inoremap <expr> <Down> pumvisible() ? "\<C-N>" : StartComplete('')
inoremap <expr> <Up>   pumvisible() ? "\<C-P>" : StartComplete('')
inoremap <expr> ｊｊ pumvisible() ? '<C-N><C-N>' : '<Esc><Cmd>update<CR>'
inoremap <expr>   ｊ pumvisible() ? '<C-N>'      : '<Esc><Cmd>update<CR>'
inoremap <expr> っｊ pumvisible() ? '<C-N><C-N>' : '<Esc><Cmd>update<CR>'

# 日本語入力時の補完確定
imap <C-G> <Plug>(JK-Complete-GG)


# ---------------------------------------------------------------------------------------------------------------------------------------------------------
# Start Completion

def StartComplete(insert_char: string): string
  # TODO
  sleep 10m
  #if pumvisible()
  #  # こうしないと、負荷が高いとき、MS-IMEの予測変換を確定した時の挙動がおかしくなる。
  #  # TODO 同事例のURLを貼る、
  #  return insert_char
  #endif
  return "\<C-N>" .. insert_char
enddef

augroup JKComplete
  au InsertEnter,CompleteDone * if maparg('gg', 'i') != '' | iunmap gg| endif
  au ModeChanged *:i[cx]*       if maparg('jj', 'i') != '' | iunmap jj| endif

  au ModeChanged *:i[cx]* inoremap j <C-N>
  au ModeChanged *:i[cx]* imap gg <Plug>(JK-Complete-GG)
augroup end


# ---------------------------------------------------------------------------------------------------------------------------------------------------------
# 重複部分削除

# こうしないと、「イベントグループが存在しない」というエラーになる。
augroup JKCompleteDDS | au! | augroup end

augroup JKComplete
  au CompleteDone * if v:completed_item != {} | DeleteDuplicateString() | endif
  au InsertEnter * au! JKCompleteDDS
augroup end

def DeleteDuplicateString()
  # TODO メタ文字 兼 キーワードのエスケープ
  if search('\%#\k\+', 'cnz') != 0
    const compl_word = v:completed_item['word']

    const cursor_word = expand('<cword>')
    #const cursor_word = expand(s:compl_kind == 'f' ? '<cfile>' : '<cword>')  # ファイル名補完のとき

    const left_word = compl_word
    const right_word = substitute(cursor_word, '^\V' .. left_word, '', 'g')

    if len(right_word) > 1  # 念のため
      const left_left_word  = substitute(left_word, '\V' .. right_word .. '\$', '', 'g')
      const erace_num = len(left_word) - len(left_left_word)
      # <Del>じゃなく、<BS>にしておかないと、ドットリピート時に意図しないことになる。
      feedkeys(repeat("\<BS>", erace_num) .. repeat("\<Right>", erace_num), 'ni')

      # 中間補完のとき、カーソルが補完位置にとどまるようにようにする。
      autocmd_add( [ {
        group: 'JKCompleteDDS',
        event: 'InsertLeave',
        pattern: '*',
        once: v:true,
        cmd: 'normal! ' .. erace_num .. 'h'
      } ] )
      # TODO どちらかでよい
      au JKCompleteDDS CursorMovedI  * ++once au! JKCompleteDDS
      au JKCompleteDDS InsertCharPre * ++once au! JKCompleteDDS
    endif
  endif
  return
enddef


# ---------------------------------------------------------------------------------------------------------------------------------------------------------
#  改行フック、インサートモード終了フック

# def AutoSemicolon(): string
#   # if &ft == 'c' || &ft == 'cpp'
#   #   # TODO semicolon
#   #   # enumなどの中なら、セミコロンではなく、カンマとする。
#   #   return ''
#   # endif
#   return ''
# enddef
# 
# #   <CR> 短縮入力を展開 & Hook発動 & 行ごとにUndo & 改行
# inoremap <expr> <CR>  pumvisible() ? '<C-Y>' : '<C-]>' .. AutoSemicolon() .. '<C-G>u' .. '<CR>'
# 
# #   gg
# inoremap <expr> <Plug>(JK-Complete-GG) (pumvisible() ? '<C-Y>' : '') .. <SID>AutoSemicolon() .. '<Esc>' .. (bufname('') == '' ? '' : ":update\<CR>")


# -----------------------------------------------------------------------------
# ファイル名補完

inoremap <C-F> <C-X><C-F>
# プロジェクトルートに移動してから補完
inoremap <expr> <C-K> '<Cmd>cd ' .. GetPrjRoot() .. '\<CR>' .. '<C-X><C-F>'
