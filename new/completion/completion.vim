vim9script
# vim:set ts=8 sts=2 sw=2 tw=0 expandtab2
scriptencoding utf-8


# ---------------------------------------------------------------------------------------------------------------------------------------------------------
# JK-Complete.vim
# ---------------------------------------------------------------------------------------------------------------------------------------------------------


# ---------------------------------------------------------------------------------------------------------------------------------------------------------
#  Initialize

set complete=.,w,b,u,i,t
set completeopt=menuone,noselect # TODO ,fuzzy
set pumheight=30


#au! JKComplete
augroup JKComplete
  au!
augroup end


def MapCoompleteTriggerChar(idx_dummy: number, char: string): string
  exec "inoremap <expr> " .. char .. " <bool>pumvisible() ? '" .. char .. "' : search('\\k\\{1\\}\\%#', 'bcn') != 0 ? StartComplete('" .. char .. "')" .. " : '" .. char .. "'"
  return ""
enddef

defcompile

# TODO foreach
call map('_0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', MapCoompleteTriggerChar)
call map('ァアィイゥウェエォオカガキギクグケゲコゴサザシジスズセゼソゾタダチヂッツヅテデトドナニヌネノハバパヒビピフブプヘベペホボポマミムメモャヤュユョヨラリルレロヮワヰヱヲンヴヵヶヷヸヹヺー', MapCoompleteTriggerChar)

# inoremap <expr> <BS> <bool>pumvisible() ? "\<BS>" : ((search('\k\k\k\%#', 'bcn') != 0 && search('[ぁ-ん][ぁ-ん][ぁ-ん]\%#', 'bcn') == 0) ? StartComplete("\<BS>") : "\<BS>")


# 候補選択
augroup JKComplete
  #au InsertEnter,CompleteDone * exec "inoremap <expr> " .. "j" .. " <bool>pumvisible() ? '" .. "\<C-n>" .. "' : search('\\k\\{1\\}\\%#', 'bcn') != 0 ? StartComplete('" .. "j" .. "')" .. " : '" .. "j" .. "'"
  au InsertEnter,CompleteDone * inoremap <expr> j search('\k\{1\}\%#', 'bcn') != 0 ? StartComplete('j') : 'j'
augroup end

#exec "inoremap <expr> " .. "k" .. " <bool>pumvisible() ? '" .. "\<C-p>" .. "' : search('\\k\\{1\\}\\%#', 'bcn') != 0 ? StartComplete('" .. "k" .. "')" .. " : '" .. "k" .. "'"
inoremap <expr> k <bool>pumvisible() ? "\<C-p>" : search('\k\{1\}\%#', 'bcn') != 0 ? StartComplete('k') : 'k'

# 日本語入力時用 + 強制補完開始
inoremap <expr> <A-j>  pumvisible() ? "\<C-n>" : StartComplete('')
inoremap <expr> <A-k>  pumvisible() ? "\<C-p>" : StartComplete('')
inoremap <expr> <Down> pumvisible() ? "\<C-n>" : StartComplete('')
inoremap <expr> <Up>   pumvisible() ? "\<C-p>" : StartComplete('')
inoremap <expr> <C-j>  pumvisible() ? "\<C-n>" : StartComplete('')
inoremap <expr> <C-k>  pumvisible() ? "\<C-p>" : StartComplete('')
inoremap <expr> ｊｊ pumvisible() ? '<C-N><C-N>' : '<cmd>update<CR>'
inoremap <expr>   ｊ pumvisible() ? '<C-N><C-N>' : '<cmd>update<CR>'
inoremap <expr> っｊ pumvisible() ? '<C-N><C-N>' : '<cmd>update<CR>'

# 日本語入力時の補完確定
imap <C-g> <Plug>(JK-Complete-GG)


# ---------------------------------------------------------------------------------------------------------------------------------------------------------
#  Enter InsertMode


# ---------------------------------------------------------------------------------------------------------------------------------------------------------
#  Start Completion

def StartComplete(insert_char: string): string
  return "\<C-n>" .. insert_char
enddef

# ModeChanged
augroup JKComplete
  au InsertEnter,CompleteDone * inoremap jj <Esc><Cmd>update<CR>
  # TODO au InsertEnter,CompleteDone * imap jj <Plug>(InsertLeave)
  # TODO なぜか効かない
  #au InsertEnter,CompleteDone * if mapcheck('gg', 'i') != '' | iunmap gg| endif
  # E31 : そのようなマッピングはありません
  au InsertEnter,CompleteDone * try | iunmap gg| catch /^Vim\%((\a\+)\)\=:E31:/ | finally | endtry
  au ModeChanged *:i[cx]* try | iunmap jj| catch /^Vim\%((\a\+)\)\=:E31:/ | finally | endtry
  au ModeChanged *:i[cx]* inoremap j <C-n>
  # TODO なぜかuを入力したら落ちる
  #au ModeChanged *:i[cx]* if mapcheck('jj', 'i') != '' | iunmap jj| endif

  #au ModeChanged *:i[cx]* imap <expr> gg pumvisible() ? '<Plug>(JK-Complete-GG)' : '<Plug>(InsertLeave)'
  au ModeChanged *:i[cx]* imap gg <Plug>(JK-Complete-GG)
  #au ModeChanged *:i[cx]* inoremap <expr> gg pumvisible() ? '<C-Y><Esc>:update<CR>' : ''
augroup end

# ---------------------------------------------------------------------------------------------------------------------------------------------------------
#  Select 候補


# ---------------------------------------------------------------------------------------------------------------------------------------------------------
#  重複部分削除

augroup JKComplete
  au CompleteDone * if v:completed_item != {} | DeleteDuplicateString() | endif
  au InsertEnter * au! JKCompleteDDS
augroup end

def DeleteDuplicateString()
  # TODO 重複部分を消す
  # TODO メタ文字 兼 キーワードのエスケープ
  # TODO gg以外の場合
  if search('\%#\k\+', 'cnz') != 0
    const compl_word = v:completed_item['word']

    const cursor_word = expand('<cword>')
    #const cursor_word = expand(s:compl_kind == 'f' ? '<cfile>' : '<cword>')

    const left_word = compl_word
    const right_word = substitute(cursor_word, '^\V' .. left_word, '', 'g')

    if len(right_word) > 1  # 念のため
      const left_left_word  = substitute(left_word, '\V' .. right_word .. '\$', '', 'g')
      const erace_num = len(left_word) - len(left_left_word)
      #let key = repeat("\<Del>", erace_num)
      #call feedkeys(repeat("\<Del>", erace_num), 'ni')
      # Delじゃなく、BSにしておかないと、ドットリピート時に意図しないことになる。
      #   例: 下記で、DefをXyzに変える場合。
      #       Abc_Def_ghi0
      #       Abc_Def_ghi1
      feedkeys(repeat("\<BS>", erace_num) .. repeat("\<Right>", erace_num), 'ni')

      # 中間補完のとき、カーソルが補完位置にとどまるようにようにする。
      var acmd: dict<any> = {
        group: 'JKCompleteDDS',
        event: 'InsertLeave',
        pattern: '*',
        once: v:true,
        cmd: 'normal! ' .. g:EraceNum .. 'h'
      }
      autocmd_add([acmd])
      au JKCompleteDDS CursorMovedI  * ++once au! JKCompleteDDS
      au JKCompleteDDS InsertCharPre * ++once au! JKCompleteDDS
    endif
  endif
  return
enddef


# ---------------------------------------------------------------------------------------------------------------------------------------------------------
#  未分類

augroup JKComplete
  au InsertLeave * normal! l
augroup end

#   <Esc>
inoremap <expr> <Esc> pumvisible() ? '<C-e>' : '<Esc>'

#   jj

#   <CR>
# 短縮入力を展開 & Hook発動 & 行ごとにUndo & 改行
inoremap <expr> <CR>  pumvisible() ? '<C-Y>' : '<C-]>' .. AutoSemicolon() .. '<C-G>u' .. '<CR>'

#   gg
#imap           <Plug>(Completion-Yes-And-InsertLeave) <Plug>(Completion-Yes)<Plug>(InsertLeave)
inoremap <expr> <Plug>(JK-Complete-GG) (pumvisible() ? '<C-Y>' : '') .. <SID>AutoSemicolon() .. '<Esc>' .. (bufname('') == '' ? '' : ":update\<CR>")


def AutoSemicolon(): string
  # if &ft == 'c' || &ft == 'cpp'
  #   # TODO semicolon
  #   # enumなどの中なら、セミコロンではなく、カンマとする。
  #   return ''
  # endif
  return ''
enddef


defcompile


# -----------------------------------------------------------------------------
# ファイル名補完

inoremap <expr> <C-l>                                         TriggerComplete('<C-x><C-f>', '', 'f')
inoremap <expr> <C-l> "\<C-o>:cd " . GetPrjRoot() . "\<CR>" . TriggerComplete('<C-x><C-f>', '', 'f')


# # ---------------------------------------------------------------------------------------------------------------------------------------------------------
# #  TODO delete
# #? # 補完中のj,kキーの処理を行う
# #? def Complete_jk(key: string): string
# #?   try
# #?     iunmap jj
# #?     call Map_gg()
# #?   catch
# #?   finally
# #?   endtry
# #?   call feedkeys(key, 'n')
# #?   return ''
# #? enddef
# 
# # CompleteDone map jj
# 
# # inoremap <expr> j      pumvisible() ? Complete_jk("\<C-n>") : StartComplete('j')
# # inoremap <expr> k      pumvisible() ? Complete_jk("\<C-p>") : StartComplete('k')
# # inoremap <expr> <C-j>  pumvisible() ? Complete_jk("\<C-n>") : StartComplete('')
# # inoremap <expr> <C-k>  pumvisible() ? Complete_jk("\<C-p>") : StartComplete('')
# # inoremap <expr> <A-j>  pumvisible() ? Complete_jk("\<C-n>") : StartComplete('')
# # inoremap <expr> <A-k>  pumvisible() ? Complete_jk("\<C-p>") : StartComplete('')
# # inoremap <expr> <Down> pumvisible() ? Complete_jk("\<C-n>") : StartComplete('')
# # inoremap <expr> <Up>   pumvisible() ? Complete_jk("\<C-p>") : StartComplete('')
# 
# # augroup JKComplete
# #   #au ModeChanged *:i[cx]* try | iunmap jj | catch | finally | endtry
# #   au ModeChanged *:i[cx]* if mapcheck('jj', 'i') != '' | iunmap jj| endif
# #   #de
# #   #au ModeChanged *:i[cx]* echo mapcheck('jj', 'i')
# #   #au ModeChanged *:i[cx]* call UnmapJJ()
# # augroup end
# # #? def UnmapJJ()
# # #?   if mapcheck('jj', 'i') != ''
# # #?     iunmap jj| endif
# # #? enddef
# 
# 
# #def StartComplete(insert_char: string): string
# #  # try
# #  #   iunmap jj
# #  #   # call Map_gg()
# #  # catch
# #  # finally
# #  # endtry
# #  return "\<C-n>\<C-p>" .. insert_char
# #  # call feedkeys("\<C-n>\<C-p>", 'n')
# #  # return insert_char
# #enddef
# 
# #def Map_gg()
# #  #imap gg <Plug>(Completion-Yes-And-InsertLeave)
# #  imap <expr> gg pumvisible() ? '<Plug>(Completion-Yes-And-InsertLeave)' : '<Plug>(InsertLeave)'
# #enddef


### # ---------------------------------------------------------------------------------------------------------------------------------------------------------
### #  重複部分削除
### 
### var EraceNum = 0  # TODO 必要性
### 
### if !exists('g:EraceNum')
###   var g:EraceNum = 0  # TODO 必要性
### endif
### 
### augroup JKComplete
###   au CompleteDone * if v:completed_item != {} | DeleteDuplicateString() | endif
###   au InsertEnter * g:EraceNum = 0
###   #au InsertEnter * EraceNum = 0
###   #au InsertEnter * call g:ResetEraceNum()
###   #au InsertEnter * <ScriptCmd> :call :ResetEraceNum()
###   #au InsertEnter * call <SID>ResetEraceNum()
###   #au InsertEnter * ResetEraceNum
### augroup end
### 
### def g:ResetEraceNum()
###   g:EraceNum = 0
### enddef
### def ResetEraceNum()
###   EraceNum = 0
### enddef
### com! ResetEraceNum call <SID>ResetEraceNum()
### 
### def DeleteDuplicateString()
###   # TODO 重複部分を消す
###   # TODO メタ文字 兼 キーワードのエスケープ
###   # TODO gg以外の場合
###   if search('\%#\k\+', 'cnz') != 0
###     const compl_word = v:completed_item['word']
### 
###     const cursor_word = expand('<cword>')
###     #const cursor_word = expand(s:compl_kind == 'f' ? '<cfile>' : '<cword>')
### 
###     const left_word = compl_word
###     const right_word = substitute(cursor_word, '^\V' .. left_word, '', 'g')
### 
###     if len(right_word) > 1  # 念のため
###       const left_left_word  = substitute(left_word, '\V' .. right_word .. '\$', '', 'g')
###       const erace_num = len(left_word) - len(left_left_word)
###       #let key = repeat("\<Del>", erace_num)
###       #call feedkeys(repeat("\<Del>", erace_num), 'ni')
###       # Delじゃなく、BSにしておかないと、ドットリピート時に意図しないことになる。
###       #   例: 下記で、DefをXyzに変える場合。
###       #       Abc_Def_ghi0
###       #       Abc_Def_ghi1
###       feedkeys(repeat("\<BS>", erace_num) .. repeat("\<Right>", erace_num), 'ni')
###       g:EraceNum = erace_num
###     endif
###   endif
###   return
### enddef
### 
### # 中間補完のとき、カーソルが補完位置にとどまるようにようにした。
### def InsertLeavePost_Hook(): string
###   return repeat('h', g:EraceNum)
### enddef
### 
### 
