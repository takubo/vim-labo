vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8


import autoload '../impauto/GetPrjRoot.vim' as gpr


#---------------------------------------------------------------------------------------------
# Set Grep-Program

set grepprg=git\ grep\ --no-color\ -I\ --line-number\ --no-index
# set grepprg=git\ grep\ --no-color\ -I\ --line-number

# -aオプションは、バイナリファイルもテキストとして扱えるようにする。
# 日本語文字コードが、Unicode以外のときにも必要。
# set grepprg=grep\ --color=never\ -an
# set grepprg=/usr/bin/grep\ --color=never\ -an

# set grepprg=$HOME/bin/ag\ --line-numbers

# vimgrepを使う
#   TODO 検索後を二重引用符で囲む必要あり
# set grepprg=internal


#---------------------------------------------------------------------------------------------
# プロジェクトルートディレクトリへcdしてから、grep実行

def GGrep(word: string, path: string = '', add: bool = false, location_list: bool = false)
  echo word
  # if 1 | return | endif

  # git grepのとき
  var cmd = 'silent ' .. (location_list ? 'l' : '') .. 'grep' .. (add ? 'add' : '') .. "! '" .. word .. "' -- :!..svn/ :!tags"
  # TODO git greo の -Eオプション時の正規表現の書式が不明。ドキュメントにも、明記なし。
  # var cmd = 'silent ' .. (location_list ? 'l' : '') .. 'grep' .. (add ? 'add' : '') .. '!' .. "  -E '" .. word .. "' -- :!..svn/ :!tags"

  # 通常のgrepコマンドのとき
  # TODO -E オプションは、Macのgrepにはない。
  # var cmd = 'silent ' .. (location_list ? 'l' : '') .. 'grep' .. (add ? 'add' : '') .. '! ' .. word

  # 内部grepのとき
  # var cmd = 'silent ' .. (location_list ? 'l' : '') .. 'vimgrep' .. (add ? 'add' : '') .. '! "' .. word .. '" **/*'

  if getftype(path) == 'dir'
    # Quickfixウィンドウに表示されるパスが長くならないよう、pathがディレクトリのときはcdしている。
    # noautocmdは、歴史的に付加しているが、必要性は未検証。
    exe 'noautocmd cd' path
  else
    # 対象がファイルのときは、コマンドに付加する。
    cmd ..= ' ' .. path
  endif

  # echo cmd

  # noautocmdを付加しないと、Quickfixの結果パスが、意図したディレクトリ(PrrRoot)にならない。
  exe 'noautocmd' cmd

  # noautocmdしているので、自分で開く必要がある。
  if location_list
    lopen
  else
    copen
  endif

  # TODO 元いたウィンドウに留まるのがよいか？Quickfixウィンドウに移動するほうがよいか？
  #wincmd p
enddef

# プロジェクトルートで、new, Quickfix
com! -nargs=+ GG   call <SID>GGrep(<q-args>, gpr.GetPrjRoot())

# プロジェクトルートで、add, Quickfix
com! -nargs=+ GGA  call <SID>GGrep(<q-args>, gpr.GetPrjRoot(), v:true, v:false)

# プロジェクトルートで、new, Locationlist
com! -nargs=+ LGG  call <SID>GGrep(<q-args>, gpr.GetPrjRoot(), v:false, v:true)

# カレントディレクトリで、new, Quickfix
com! -nargs=+ GGC  call <SID>GGrep(<q-args>, './',             v:false, v:false)

# カレントディレクトリで、add, Quickfix
com! -nargs=+ GGCA call <SID>GGrep(<q-args>, './',             v:false, v:false)

# このファイルで、new, Quickfix (GGTのTは、This file)
com! -nargs=+ GGT  call <SID>GGrep(<q-args>, '%',              v:false, v:false)

# このファイルで、add, Quickfix (GGTAのTは、This file)
com! -nargs=+ GGTA call <SID>GGrep(<q-args>, '%',              v:true,  v:false)


#---------------------------------------------------------------------------------------------
# Mapping (カーソル下の単語検索)

# プロジェクトルートで、new, Quickfix
nnoremap <silent> <C-G><C-G> :<C-U>call histadd(':', 'GG ' .. '\<<C-R><C-W>\>') <Bar> GG \<<C-R><C-W>\><CR>
vnoremap <silent> <C-G><C-G>     y:call histadd(':', 'GG ' .. '\<<C-R>"\>')     <Bar> GG <C-R>"<CR>

# プロジェクトルートで、add, Quickfix
nnoremap <silent> <C-G><C-A> :<C-U>call histadd(':', 'GGA ' .. '\<<C-R><C-W>\>') <Bar> GGA \<<C-R><C-W>\><CR>
vnoremap <silent> <C-G><C-A>     y:call histadd(':', 'GGA ' .. '\<<C-R>"\>')     <Bar> GGA <C-R>"<CR>

# プロジェクトルートで、new, Locationlist
nnoremap <silent> <C-G><C-L> :<C-U>call histadd(':', 'LGG ' .. '\<<C-R><C-W>\>') <Bar> LGG \<<C-R><C-W>\><CR>
vnoremap <silent> <C-G><C-L>     y:call histadd(':', 'LGG ' .. '\<<C-R>"\>')     <Bar> LGG <C-R>"<CR>

# カレントディレクトリで、new, Quickfix (C-Cはマッピングできないため、とりあえずC-Fにマッピングしている。)
nnoremap <silent> <C-G><C-F> :<C-U>call histadd(':', 'GGC ' .. '\<<C-R><C-W>\>') <Bar> GGC \<<C-R><C-W>\><CR>
vnoremap <silent> <C-G><C-F>     y:call histadd(':', 'GGC ' .. '\<<C-R>"\>')     <Bar> GGC <C-R>"<CR>

# カレントディレクトリで、add, Quickfix (Rは押しやすさだけで、意味はない。)
nnoremap <silent> <C-G><C-R> :<C-U>call histadd(':', 'GGCA ' .. '\<<C-R><C-W>\>') <Bar> GGCA \<<C-R><C-W>\><CR>
vnoremap <silent> <C-G><C-R>     y:call histadd(':', 'GGCA ' .. '\<<C-R>"\>')     <Bar> GGCA <C-R>"<CR>

# このファイルで、new, Quickfix (Tは、This file)
nnoremap <silent> <C-G><C-T> :<C-U>call histadd(':', 'GGT ' .. '\<<C-R><C-W>\>') <Bar> GGT \<<C-R><C-W>\><CR>
vnoremap <silent> <C-G><C-T>     y:call histadd(':', 'GGT ' .. '\<<C-R>"\>')     <Bar> GGT <C-R>"<CR>


#---------------------------------------------------------------------------------------------
# Mapping

# 文字列、検索パスとも入力する (Iは、InputのI. また、Tabになるので、押しやすい。)
nnoremap <C-G><C-I> :<C-u>grep '' <Left><Left>

# 現在の検索文字列でgrep (Sは、SearchのS)
nnoremap <C-G><C-S> :<C-u>grep '<C-R>/'<Space>
#nnoremap <silent> <C-g><C-g> :<C-u>grep '\<<C-R><C-W>\>'<CR>

# 選択範囲でgrep (Iは、とりあえず<C-G><C-I>を引き継いでいる。)
vnoremap <C-G><C-I> y:grep '<C-R>"'<Space>

# Fall Back
# nnoremap <Leader>g :<C-u>vim "\<<C-r><C-w>\>" *<CR>


#---------------------------------------------------------------------------------------------
# Mapping (Help)

# TODO C-G単推しで、ヘルプをポップアップ表示する
# nnoremap <C-G> call popup_create()


#----------------------------------------------------------------------------------------
# 設定
#   2  コマンド   vim, grep
#   2  結果       new, add
#   4  検索文字列 user_input, cword, register, search
#   5  範囲       cur_file, cur_dir, cur_dir&childs, prj, user_input
#   2  git grep   index, no-index
#   3  拡張子     all, cur(c,h), user_input
#   2  表示先     quickfix, location_list
#----------------------------------------------------------------------------------------


#---------------------------------------------------------------------------------------------
# Delete


# #----------------------------------------------------------------------------------
# # Quickfix cd Project-Root
#
# # Quickfixウィンドウを、指定のディレクトリをカレントディレクトリとして開き直す。
# def QfChdir(dir: string)
#   cclose
#
#   const save_autochdir = &autochdir
#   set noautochdir
#
#   const org_dir = getcwd()
#   exe 'noautocmd cd ' dir
#
#   copen
#   exe 'noautocmd cd' org_dir
#
#   &autochdir = save_autochdir
# enddef
#
# # Quickfixウィンドウを、プロジェクトルートをカレントディレクトリとして開き直す。
# com! QfChdirPrjRoot call QfChdir(gpr.GetPrjRoot())
#
# #----------------------------------------------------------------------------------


# #----------------------------------------------------------------------------------
# augroup MyVimrc_Grep
#   au!
#   exe 'au WinEnter * if (&buftype == "quickfix") | cd ' .. getcwd() .. ' | endif'
# augroup end
# #----------------------------------------------------------------------------------


# #----------------------------------------------------------------------------------
#
# var prj_root_file = '.git'
#
# # プロジェクトルートにcdしてから、grepを実行する。
# # TODO 今は、QFウィンドウが、grep実行時のディレクトリを覚えている？ → 要調査
# def GrepOnPrjRoot(str: string)
#   #? const save_autochdir = &autochdir
#   #? set autochdir
#
#   #? const pwd = getcwd()
#
#   # 7階層上のディレクトリまで確認
#   for i in range(7)
#     if glob(prj_root_file) != ''  # prj_root_fileファイルの存在確認
#       # 変更したオプションやカレントディレクトリを確実に戻すために、tryで囲む。
#       #? try
#         exe "silent grep! " .. "'" .. str .. "'" .. " **/*"
#         call feedkeys("\<CR>:\<Esc>\<C-o>", "tn")  # 見つかった最初へ移動させない。
#       #? finally
#       #? endtry
#       break
#     endif
#     cd ..
#   endfor
#
#   #? exe 'cd ' .. pwd
#   #? &autochdir = save_autochdir
# enddef
#
# com! GrepOnPrjRoot call GrepOnPrjRoot(expand("<cword>"))
#
# # nnoremap          <leader>g     :<C-u>call GrepOnPrjRoot("\\<<C-r><C-w>\\>")<CR>
# # nnoremap <silent> <C-g>         :<C-u>call GrepOnPrjRoot("\\<<C-r><C-w>\\>")<CR>
# # nnoremap          <leader>G     :<C-u>call GrepOnPrjRoot("<C-r><C-w>")<CR>
# # nnoremap          <leader><C-g> :<C-u>call GrepOnPrjRoot('')<Left><Left>
# # nnoremap <silent> <C-g>         :<C-u>call GrepOnPrjRoot("\\b<C-r><C-w>\\b")<CR>
# # nnoremap <silent> <leader>g     :<C-u>call GrepOnPrjRoot("\\b<C-r><C-w>\\b")<CR>
# # nnoremap          <leader>g     :<C-u>call GrepOnPrjRoot('')<Left><Left>
#
# #----------------------------------------------------------------------------------
