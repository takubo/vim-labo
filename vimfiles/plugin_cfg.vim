vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8

#=============================================================================================
# Plugins
#=============================================================================================



#---------------------------------------------------------------------------------------------
# Submode
#---------------------------------------------------------------------------------------------

g:submode_timeout = true
g:submode_timeoutlen = 10000



#---------------------------------------------------------------------------------------------
# Clever-f
#---------------------------------------------------------------------------------------------

g:clever_f_smart_case = 1

g:clever_f_use_migemo = 1

com! CleverfUseMigemoToggle {
        g:clever_f_use_migemo = !g:clever_f_use_migemo
        echo g:clever_f_use_migemo ? 'clever-f Use Migemo' : 'clever-f No Migemo'
      }


# 任意の記号にマッチする文字を設定する
g:clever_f_chars_match_any_signs = "\<BS>"

# 過去の入力の再利用
g:clever_f_repeat_last_char_inputs = ["\<CR>"]  # ["\<CR>", "\<Tab>"]


# fは必ず右方向に移動，Fは必ず左方向に移動する
g:clever_f_fix_key_direction = 1


# タイムアウト
g:clever_f_timeout_ms = 3000


# Highlighting

augroup MyVimrc_Clever_f
  au!
  au ColorScheme * hi My_cleverf_Cursor guifg=yellow guibg=black
  au ColorScheme * hi My_cleverf_Char   guifg=#cff412 guibg=black
 #au ColorScheme * hi My_cleverf_Cursor guifg=cyan   guibg=black
 #au ColorScheme * hi My_cleverf_Char   guifg=yellow guibg=black
augroup end

hi My_cleverf_Cursor guifg=yellow  guibg=black
hi My_cleverf_Char   guifg=#cff412 guibg=black

g:clever_f_mark_cursor_color = 'My_cleverf_Cursor'
g:clever_f_mark_char_color   = 'My_cleverf_Char'

g:clever_f_mark_cursor = 1
g:clever_f_mark_char = 1

# clever-fが重い場合、
#   g:clever_f_mark_char = 0
# とするか、
#   g:clever_f_use_migemo = 0
# とするかすれば、重いのが解消される。



#---------------------------------------------------------------------------------------------
# MRU
#---------------------------------------------------------------------------------------------

augroup MyVimrc_MRU
  au!
 #au VimEnter,VimResized,WinResized * legacy let MRU_Window_Height = max([8, &lines / 3 ])
  au VimEnter,VimResized,WinResized * legacy let MRU_Window_Height = max([8, &lines / 2 ])
augroup end

# FIXME
highlight link MRUFileName MyMru
highlight link MRUFileName String
highlight link MRUFileName Statement

# nnoremap <Leader>o :<C-u>MRU<Space>
# nnoremap <C-o> :<C-u>MRU<Space>



#---------------------------------------------------------------------------------------------
# Snippets
#---------------------------------------------------------------------------------------------

# ru snipMate.vim
if exists('*TriggerSnippet')
  inoremap <silent> <Tab>   <C-R>=<SID>TriggerSnippet()<CR>
endif



#---------------------------------------------------------------------------------------------
# Smartchr
#---------------------------------------------------------------------------------------------

if exists('*smartchr#one_of') && 0
  # TODO 行末
  inoremap <expr> , smartchr#one_of(', ', ',')

  # 演算子の間に空白を入れる
  inoremap <expr> + smartchr#one_of(' = ', ' == ', '=')
  inoremap <expr> + smartchr#one_of(' + ', '++', '+')
  inoremap <expr> - smartchr#one_of(' - ', '--', '-')
  inoremap <expr> * smartchr#one_of(' * ', '*')
  inoremap <expr> / smartchr#one_of(' / ', '/')
  inoremap <expr> % smartchr#one_of(' % ', '%')
  inoremap <expr> & smartchr#one_of(' & ', ' && ', '&')
  inoremap <expr> <Bar> smartchr#one_of(' <Bar> ', ' <Bar><Bar> ', '<Bar>')

  if &filetype == "c"
    # 下記の文字は連続して現れることがまれなので、二回続けて入力したら改行する
    inoremap <buffer><expr> } smartchr#one_of('}', '}<cr>')
    inoremap <buffer><expr> ; smartchr#one_of(';', ';<cr>')
  endif
  inoremap <expr> + smartchr#one_of(' = ', ' == ', '=')
endif



#---------------------------------------------------------------------------------------------
# EasyAlign
#---------------------------------------------------------------------------------------------

if 0
  vnoremap ga :EasyAlign<Space>//<Left>
  vnoremap g= :EasyAlign<Space>//<Left>
  vnoremap A  :EasyAlign<Space>//<Left>
endif
