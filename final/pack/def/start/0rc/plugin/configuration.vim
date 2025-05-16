vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8

#=============================================================================================
# Configuration
#=============================================================================================



#---------------------------------------------------------------------------------------------
# Edit File


import autoload 'util_func.vim' as uf
import autoload 'window_ratio.vim' as wr


#const vimrc_path = $HOME .. (true || has('win32') ? '/vimfiles/vimrc' : '/.vimrc')
const vimrc_path = $HOME .. (has('win32') ? '/vimfiles' : '/.vim') .. '/vimrc'
const colors_dir = $HOME .. (has('win32') ? '/vimfiles' : '/.vim') .. '/pack/def/start/0rc/colors/'  # TODO
const color_path = colors_dir .. g:colors_name .. '.vim'


def FileOpen(path: string, other_tab: bool = false)
  const buf_name = '^' .. path
  const win_id_list = bufnr(buf_name) -> win_findbuf()

  # 現在のタブページ内で開かれていれば
  const cur_win_idx = win_id_list -> mapnew((_, v) => win_id2win(v)) -> indexof((_, v) => v > 0)

  if cur_win_idx != -1
    win_gotoid(win_id_list[cur_win_idx])
    return
  endif

  # 別のタブページで開かれていれば
  if other_tab
    const othr_win_idx = win_id_list -> mapnew((_, v) => win_id2tabwin(v)) -> flattennew() -> indexof((_, v) => v > 0)
    if othr_win_idx != -1
      win_gotoid(win_id_list[othr_win_idx])
      return
    endif
  endif

  if uf.IsEmptyBuf()
    exe 'edit'   path
  elseif wr.VertSplit()
    exe 'vsplit' path
  else
    exe 'split'  path
  endif
enddef


com! -bang -bar EditVIMRC FileOpen(vimrc_path, <bang>false)
com! -bang -bar VIMRC EditVIMRC

com! -bang -bar EditColor FileOpen(color_path, <bang>false)


nnoremap <silent> <Leader>v <Cmd>EditVIMRC<CR>
nnoremap <silent> <Leader>V <Cmd>EditColor<CR>
#nnoremap <silent> <Leader>v <ScriptCmd>FileOpen('$HOME/vimfiles/pack/new/start/new/plugin')<CR>



#---------------------------------------------------------------------------------------------
# Make Option File

com! OptionsExe {
        options

        try
          :g/^"/d
        catch /E486/
        endtry
        try
          :g/^ \?\t/d
        catch /E486/
        endtry

        :g/^[^\t]\+$/s/^/# /
        :g/\t/s/^/set /
        :g/\t/s/\t.*/=/

        execute('version') -> split('\n')[0 : 3] -> append(0)
        append(4, '')
        :1,4s/^/# /

        normal! gg
        noh

        #nnoremap <buffer> # I#<esc>A<BS><Esc>
        #nnoremap <buffer> ! I# TODO <esc>A<BS><Esc>
        #nnoremap <buffer> @ I# <esc>A<BS>  #@ <Esc>
        #g$.$s    %?%%n
      }

com! Options silent keeppatterns OptionsExe
