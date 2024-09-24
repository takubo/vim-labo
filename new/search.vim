vim9script

# Extar
# Asterisk
# Extarisk
# Exterisk



# fun! SS()
#   let s = winsaveview()
#   keepjumps normal! *
#   call winrestview(s)
# endfunction
# nnoremap @ :<C-u>call SS()<CR>:<C-u>set hlsearch<CR>
# 
# nnoremap @ :<C-u>let s = winsaveview()<CR>:keepjumps normal! *<CR>:<C-u>call winrestview(s)<CR>
# 
# nnoremap @ :<C-u>call SS()<CR>:<C-u>set hlsearch<CR>
# 
# " https://x.com/Bakudankun/status/1207057884581900289
# nnoremap <silent><expr> @ v:count ? '*'
# \ : ':sil exe "keepj norm! *" <Bar> call winrestview(' . string(winsaveview()) . ')<CR>'
# 
# 
# fun! SS()
#   let s = winsaveview()
#   let @/ = expand("<cword>")
#   call winrestview(s)
# endfunction
# nnoremap * <cmd>call SS()<CR><cmd>set hlsearch<CR>
# 
# " fun! SS()
# "   let cword = expand("<cword>")
# "   if cword != ''
# "     let @/ = '\<' . cword . '\>'
# "   else
# "     let cWORD = expand("<cWORD>")
# "     if cWORD == ''
# "       return v:false
# "     endif
# "     let @/ = cWORD
# "   endif
# "   "検索履歴に残すための処理
# "   call histadd('/', @/)
# "   return v:true
# " endfunction


def SearchCWord(whole_wword: bool = true, add: bool = false): bool
  const cword = expand("<cword>")

  if cword == ''
    return false
  endif

  var search: string

  if cword[0] =~# '\k'
    search = whole_wword ? ('\<' .. cword .. '\>') : cword

    # カーソルを、検索文字列の先頭に持って行く。
    #   キーワードの先頭
    if     search('\%#\<\k', 'bcn', line('.')) != 0
    #   キーワードの中ほど
    elseif search('\%#\k', 'bcn', line('.')) != 0
      normal! b
    #   キーワードの前の方(スペース、記号のいずれも、混在でも。)
    else
      exe 'normal! f' .. cword[0]
    endif
  else
    search = escape(cword, '*^$.~[\')

    # カーソルを、検索文字列の先頭に持って行く。
    #   非キーワードの先頭
    if     search('[[:keyword:][:space:]]\%#\S', 'bcn', line('.')) != 0
    #   非キーワードの中ほど
    elseif search('\%#\S', 'bcn', line('.')) != 0
      normal! b
    #   非キーワードの前のスペース
    elseif search('\%#\s', 'bcn', line('.')) != 0
      normal! w
    endif
  endif

  @/ = (add ? (@/ .. '\|') : '') .. search

  # 検索履歴に残すための処理
  histadd('/', @/)

  # 自前でechoしないと、前の検索文字列表示が残っていることがある。
  echo '/' .. @/

  SearchCountStr

  return v:true
enddef

nnoremap  * <cmd>if <SID>SearchCWord(v:true,  v:false) <Bar> set hlsearch <Bar> endif<CR>
nnoremap  # <cmd>if <SID>SearchCWord(v:true,  v:true ) <Bar> set hlsearch <Bar> endif<CR>
nnoremap g* <cmd>if <SID>SearchCWord(v:false, v:false) <Bar> set hlsearch <Bar> endif<CR>
nnoremap g# <cmd>if <SID>SearchCWord(v:false, v:true ) <Bar> set hlsearch <Bar> endif<CR>

# normalにしないと、検索対象がないときに、SearchCountStrが発動しない。
nnoremap n <cmd>normal! n<CR><Cmd>SearchCountStr<CR>
nnoremap N <cmd>normal! N<CR><Cmd>SearchCountStr<CR>

cnoremap <silent> <Plug>(CommandlineCR-Colon) <CR>
cnoremap <silent> <Plug>(CommandlineCR-Debug) <CR>
cnoremap <silent> <Plug>(CommandlineCR-Slash) <CR><cmd>SearchCountStr<CR>
cnoremap <silent> <Plug>(CommandlineCR-Input) <CR>
cnoremap <silent> <Plug>(CommandlineCR-InApp) <CR>
cnoremap <silent> <Plug>(CommandlineCR-Equal) <CR>
cnoremap <silent> <Plug>(CommandlineCR-Other) <CR>
cmap <expr> <CR> getcmdtype() == '/' ? '<Plug>(CommandlineCR-Slash)' : '<Plug>(CommandlineCR-Other)'
# TODO cmdwin


## キーワードの中ほど
#echo search('\k\%#', 'bcn', line('.')) != 0
#
## キーワードの先頭
#echo search('\%#\<\k', 'bcn', line('.')) != 0
#
## 非キーワードの中ほど
#echo search('\S\%#', 'bcn', line('.')) != 0
#
## キーワードの前のスペース
## 非キーワードの前のスペース
#echo search('\%#\s', 'bcn', line('.')) != 0
#
## 非キーワードの先頭
#echo search('\s\%#\S', 'bcn', line('.')) != 0



# nnoremap * <cmd>if <SID>SearchCWord() <Bar> SearchCountStr <Bar> set hlsearch <Bar> endif<CR>


  # カーソルを、検索文字列の先頭に持って行く。
    # キーワードの中ほど
    # キーワードの先頭
    # キーワードの前のスペース
    # 非キーワードの先頭
    # 非キーワードの中ほど
    # 非キーワードの前のスペース

#    if     search('[[:keyword:][:space:]]\%#\S', 'bcn', line('.')) != 0
#    #if     search('\(\k\|\s\)\%#', 'bcn', line('.')) != 0
#    #if     search('[\k\s]\%#\S', 'bcn', line('.')) != 0

# def SearchCWord(): bool
#   var cword = expand("<cword>")
#   if cword == ''
#     return v:false
#   endif
#   if cword[0] =~# '\k'
#     @/ = '\<' .. cword .. '\>'
# 
#     # {{{ カーソル移動
#     # キーワードの先頭
#     if     search('\%#\<\k', 'bcn', line('.')) != 0
#     # キーワードの中ほど
#     elseif search('\k\%#', 'bcn', line('.')) != 0
#       normal! b
#     # キーワードの前のスペース
#     elseif search('\%#\s', 'bcn', line('.')) != 0
# 	exe 'normal! f' cword[0]
#     endif
#     # }}} カーソル移動
#   else
#     @/ = escape(cword, '.\[')
# 
#     # {{{ カーソル移動
#     # 非キーワードの先頭
#     if     search('\s\%#\S', 'bcn', line('.')) != 0
#     # 非キーワードの中ほど
#     elseif search('\S\%#', 'bcn', line('.')) != 0
#       normal! b
#     # 非キーワードの前のスペース
#     elseif search('\%#\s', 'bcn', line('.')) != 0
#       normal! w
#     endif
#     # }}} カーソル移動
#   endif
# 
#   # 検索履歴に残すための処理
#   histadd('/', @/)
#   # 自前でechoしないと、前の検索文字列表示が残っていることがある。
#   echo '/' .. @/
#   # カーソルを、検索文字列の先頭に持って行く。
#     # キーワードの中ほど
#     # キーワードの先頭
#     # キーワードの前のスペース
#     # 非キーワードの先頭
#     # 非キーワードの中ほど
#     # 非キーワードの前のスペース
#   return v:true
# enddef





#----------------------------------------------------------------------------------------
# Search Count String
#----------------------------------------------------------------------------------------

def SearchCountStr(): string
  const count = searchcount({"maxcount": 99999, "timeout": 250})

  return count["current"] .. (count["exact_match"] || (count["total"] == 0) ? "" : " +") .. " / " ..  count["total"] .. (count["incomplete"] ? "+" : "")
  #return count["current"] .. (count["exact_match"] || (count["total"] == 0) ? "" : " >") .. " / " ..  count["total"] .. (count["incomplete"] ? "+" : "")
  #return count["current"] .. (count["exact_match"] || (count["total"] == 0) ? "" : ">") .. "/" ..  count["total"] .. (count["incomplete"] ? "+" : "")
  #return count["current"] .. " / " ..  count["total"] .. (count["incomplete"] ? "+" : "")
enddef

com! -bar -nargs=0 SearchCountStr call PopUpInfo([@/, "", SearchCountStr()], 2600)
com! -bar -nargs=0 SearchCountStr call PopUpInfo([SearchCountStr() . '  [' . @/ . ']'], 2600)
com! -bar -nargs=0 SearchCountStr call PopUpInfo([SearchCountStr()], 2000)
nnoremap <Leader>n <Cmd>SearchCountStr<CR>

# def SearchCountStr(): string
#   const count = searchcount({"maxcount": 99999, "timeout": 250})
# 
#   # count["current"]
#   # count["exact_match"]
#   # count["total"]
#   # count["incomplete"]
# 
#   #var ret = count["current"] .. (count["exact_match"] || (count["total"] == 0) ? "" : ">") .. "/" ..  count["total"] .. (count["incomplete"] ? "+" : "")
#   #var ret = count["current"] .. (count["exact_match"] || (count["total"] == 0) ? "" : " >") .. " / " ..  count["total"] .. (count["incomplete"] ? "+" : "")
#   var ret = count["current"] .. " / " ..  count["total"] .. (count["incomplete"] ? "+" : "")
#   count["exact_match"]
#   count["incomplete"]
#   return ret
# enddef

#echo @/ SearchCountStr()
#call popup_atcursor((@/ . "\n" . SearchCountStr()), {})
#com! -nargs=0 -bar SearchCountPop call popup_atcursor((@/ . "\n" . SearchCountStr()), {})
#com! -nargs=0 -bar SearchCountPop call popup_atcursor((SearchCountStr()), {})
#call (@/ . "\n" . SearchCountStr())->popup_atcursor({})
