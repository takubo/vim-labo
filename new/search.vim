vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 expandtab
scriptencoding utf-8


import autoload "./PopUpInfo.vim" as pui
# import autoload "../impauto/Search.vim" as s
# import autoload "../impauto/Search_MultiHilight.vim" as smh


# Extar
# Asterisk
# Extarisk
# Exterisk


#----------------------------------------------------------------------------------------
# Search Cursor Word
#----------------------------------------------------------------------------------------

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

  #SearchCountPopup()
  SearchCountAuto
  CursorJumped

  return v:true
enddef


#----------------------------------------------------------------------------------------
# Search Count
#----------------------------------------------------------------------------------------

def SearchCountStr(): string
  const count = searchcount({"maxcount": 99999, "timeout": 250})
  return count.current .. (count.exact_match || (count.total == 0) ? "" : " +") .. " / " ..  count.total .. (count.incomplete ? "+" : "")
enddef

def SearchCountPopup(display_time: number = 2000)
  pui.PopUpInfo(SearchCountStr(), display_time)
enddef

com! -bar -nargs=0 SearchCount     call SearchCountPopup(-1)  # カーソル移動するまで、表示しっぱなし。
com! -bar -nargs=0 SearchCountAuto call SearchCountPopup()    # 一定時間で消える。


#----------------------------------------------------------------------------------------
# Mapping
#----------------------------------------------------------------------------------------

nnoremap  * <cmd>if <SID>SearchCWord(v:true,  v:false) <Bar> set hlsearch <Bar> endif<CR>
nnoremap  # <cmd>if <SID>SearchCWord(v:true,  v:true ) <Bar> set hlsearch <Bar> endif<CR>
nnoremap g* <cmd>if <SID>SearchCWord(v:false, v:false) <Bar> set hlsearch <Bar> endif<CR>
nnoremap g# <cmd>if <SID>SearchCWord(v:false, v:true ) <Bar> set hlsearch <Bar> endif<CR>

nnoremap  * <cmd>if <SID>SearchCWord(v:true,  v:false) <Bar> set hlsearch <Bar> endif<CR>
nnoremap  # <cmd>if <SID>SearchCWord(v:true,  v:true ) <Bar> set hlsearch <Bar> endif<CR>
nnoremap g* <cmd>if <SID>SearchCWord(v:false, v:false) <Bar> set hlsearch <Bar> endif<CR>
nnoremap g# <cmd>if <SID>SearchCWord(v:false, v:true ) <Bar> set hlsearch <Bar> endif<CR>

# normalにしないと、検索対象がないときに、SearchCountが発動しない。
nnoremap n <cmd>normal! n<CR><Cmd>SearchCountAuto<CR><Cmd>CursorJumped<CR>
nnoremap N <cmd>normal! N<CR><Cmd>SearchCountAuto<CR><Cmd>CursorJumped<CR>

#cnoremap <silent> <Plug>(CommandlineCR-Colon) <CR>
#cnoremap <silent> <Plug>(CommandlineCR-Debug) <CR>
#cnoremap <silent> <Plug>(CommandlineCR-Input) <CR>
#cnoremap <silent> <Plug>(CommandlineCR-InApp) <CR>
#cnoremap <silent> <Plug>(CommandlineCR-Equal) <CR>
cnoremap <silent> <Plug>(CommandlineCR) <CR>
cmap <expr> <CR> getcmdtype() == '/' ? '<Plug>(CommandlineCR-Slash)' : '<Plug>(CommandlineCR)'

# TODO cmdwinから検索開始したとき。

nnoremap <Leader>n <Cmd>SearchCount<CR>



# TODO C_<CRC>で検索対象がないとき、エラーになり、サーチカウントも表示されない。
# C_<CRC>で検索対象がないとき、エラーになり、サーチカウントも表示されない。の対策でfeedkeys()化。
cnoremap <silent> <Plug>(CommandlineCR-Slash) <Cmd>call feedkeys("\<lt>CR>:SearchCountAuto\<lt>CR>", 'ntx')<CR>
cnoremap <silent> <Plug>(CommandlineCR-Slash) <Cmd>call feedkeys("\<lt>CR>", 'nit')<CR><Cmd>SearchCountAuto<CR>
cnoremap <silent> <Plug>(CommandlineCR-Slash) <CR><Cmd>SearchCountAuto<CR>



cnoremap <silent> <Plug>(CommandlineCR-Slash) <CR>
augroup SearchCR
	au!
	au CmdlineLeave * {
		if expand("<afile>") == '/'
			# <esc>, <C-C>で抜けたとき、SearchCountAutoがエラーとなるので、tryで囲む。
			# エラー終了したままだと、onceでイベントは消えない。
			# エラーとなることで、PopUpは表示されないので、escやc-cのときpopupが表示されず、都合がよい。
			exe 'au SearchCR SafeState * ++once CursorJumped | try | SearchCountAuto | catch | endtry'

			# @/ = getcmdline()
			#exe 'au SearchCR ModeChanged c:n ++once CursorJumped | try | SearchCountAuto | catch | endtry'
		endif
	}
augroup end
