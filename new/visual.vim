vim9script


nnoremap v <C-v>

augroup MyVimrc_Visual
  au!
  # <buffer>と<nowait>により、各omapより優先させる。
  au ModeChanged *:[vV\x16]* vmap <expr> <buffer> <nowait> i mode() == "\x16" ? '<Plug>(Visual-I)' : 'i'
  au ModeChanged *:[vV\x16]* vmap <expr> <buffer> <nowait> a mode() == "\x16" ? '<Plug>(Visual-A)' : 'a'
augroup end

vnoremap <Plug>(Visual-I) <Cmd>vunmap <buffer> i<Bar>call feedkeys(getpos('v')[1] != getpos('.')[1] ? 'I' : 'i')<CR>
vnoremap <Plug>(Visual-A) <Cmd>vunmap <buffer> a<Bar>call feedkeys(getpos('v')[1] != getpos('.')[1] ? 'A' : 'a')<CR>


### Test ###
vnoremap ia i(
