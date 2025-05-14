vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8


#---------------------------------------------------------------------------------------------
# Substitute
#---------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------
# Basic

# Basic (バッファ全体)
nnoremap S               :<C-u>g$.$s    %%%<Left><Left>
vnoremap S                        :s    %%%<Left><Left>

# 検索内容を被置換
nnoremap <C-s>           :<C-u>g$.$s    %<C-R>/%%g<Left><Left>
vnoremap <C-s>                    :s    %<C-R>/%%g<Left><Left>

# # カーソル下の単語を被置換
# nnoremap gs              :<C-u>g$.$s    %<C-R><C-W>%%g<Left><Left>
# vnoremap gs                       :s    %<C-R>/%<C-R><C-W>%g

# 無名レジスタの内容を被置換
nnoremap gS              :<C-u>g$.$s    %<C-R>"%%g<Left><Left>
nnoremap gS                       :s    %<C-R>"%%g<Left><Left>

# # 現在行内の全てを置換
# nnoremap <Leader>s           :<C-u>s    %%%g<Left><Left><Left>

# 末尾にgフラグを付加する
cnoremap <expr> <C-g> match(getcmdline(), '\(g.\..s\\|s\)    /') == 0 ? '<End>g' :
                    \ match(getcmdline(), '\(g.\..s\\|s\)    %') == 0 ? '<End>g' : ''


#----------------------------------------------------------------------------------------
# Symbol Rename ( 検索内容を、カーソル下単語で、置換 )

# 関数内のシンボルだけを置換
# TODO Cの特定の書き方にしか対応してない。
def RenameFuncInnerSymbol() 
  const sword = @/                 # 被置換文字列
  const cword = expand('<cword>')  # 置換後単語

  PushPos

  # 関数先頭へ移動
  #   2jは、関数の先頭に居た時用
  #   2kは、関数定義行を含むため
  #   TODO いずれも暫定
  keepjumps normal! 2j[[2k
  const first_line = line('.')

  # 関数末尾へ移動
  keepjumps normal! ][
  const last_line = line('.')

  # コマンドを組み立てる
  const cmd_range = ':' .. first_line .. ',' .. last_line
  const cmd_body = 's/' .. sword .. '/' .. cword .. '/g'

  # 置換実行
  exe cmd_range .. cmd_body

  PopPos
enddef

# 関数内のシンボルだけを置換
com! -nargs=0 -bar RenameFuncInnerSymbol call <SID>RenameFuncInnerSymbol()

# 関数内のシンボルだけを置換
nnoremap <silent> <Leader>s :<C-u>RenameFuncInnerSymbol<CR>

# ファイル内全てのシンボルを置換
# 置換後に、置換後文字列を検索レジスタへ設定することで、置換後文字列がハイライトされるようにしている。
nnoremap <silent> <Leader>S :<C-u>PushPos<CR>:g$.$s    /<C-r>//<C-r><C-w>/g<CR>:PopPos<CR>:let @/='<C-r><C-w>'<CR>

# # cfdo (誤爆回避のため、<C-S>を2回押させる。)
# nnoremap <Leader><C-s><C-s> :<C-u>PushPosAll <Bar> cfdo %s/<C-r>//<C-r><C-w>/g <Bar> update <Bar> PopPosAll


#----------------------------------------------------------------------------------------

################################################
# キー利用表
#
#        	s	S	<C-S>
# なし   	-	1	1
# g      		1	
# <Leadr>	1	1	1
# z      			
#
################################################
