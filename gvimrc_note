scriptencoding utf-8
" vim:set ts=8 sts=2 sw=2 tw=0: (この行に関しては:help modelineを参照)


set guioptions=

colorscheme Rimpa

set transparency=235

set mps+=（:）,「:」,『:』,【:】

call SetCpmplKey('ァアィイゥウェエォオカガキギクグケゲコゴサザシジスズセゼソゾタダチヂッツヅテデトドナニヌネノハバパヒビピフブプヘベペホボポマミムメモャヤュユョヨラリルレロヮワヰヱヲンヴヵヶヷヸヹヺー')
inoremap <buffer><expr> ｊ pumvisible() ? '<C-n>' : 'j'
inoremap <buffer><expr> ｋ pumvisible() ? '<C-p>' : 'k'
inoremap <buffer><expr> <C-j> pumvisible() ? '<C-n>' : '<C-j>'
inoremap <buffer><expr> <C-k> pumvisible() ? '<C-p>' : '<C-k>'

inoremap <expr> ｊｊ pumvisible() ? '<C-N><C-N>' : '<Esc>:w<CR>'
inoremap <expr>   ｊ pumvisible() ? '<C-N><C-N>' : '<Esc>:w<CR>'
inoremap <expr> っｊ pumvisible() ? '<C-N><C-N>' : '<Esc>:w<CR>'

"highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=#ffffff
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=#333377
au BufNewFile,BufRead * match ZenkakuSpace /　/


iab <silent> q1  ①<C-R>=Eatchar('\s')<CR>
iab <silent> q2  ②<C-R>=Eatchar('\s')<CR>
iab <silent> q3  ③<C-R>=Eatchar('\s')<CR>
iab <silent> q4  ④<C-R>=Eatchar('\s')<CR>
iab <silent> q5  ⑤<C-R>=Eatchar('\s')<CR>
iab <silent> q6  ⑥<C-R>=Eatchar('\s')<CR>
iab <silent> q7  ⑦<C-R>=Eatchar('\s')<CR>
iab <silent> q8  ⑧<C-R>=Eatchar('\s')<CR>
iab <silent> q9  ⑨<C-R>=Eatchar('\s')<CR>
iab <silent> q10 ⑩<C-R>=Eatchar('\s')<CR>
iab <silent> q11 ⑪<C-R>=Eatchar('\s')<CR>
iab <silent> q12 ⑫<C-R>=Eatchar('\s')<CR>


iab <silent> qd ・<C-R>=Eatchar('\s')<CR>


function! C_A()
      if search('\%#①', 'bcn')	| return "s②\<Esc>"
  elseif search('\%#②', 'bcn')	| return "s③\<Esc>"
  elseif search('\%#③', 'bcn')	| return "s④\<Esc>"
  elseif search('\%#④', 'bcn')	| return "s⑤\<Esc>"
  elseif search('\%#⑤', 'bcn')	| return "s⑥\<Esc>"
  elseif search('\%#⑥', 'bcn')	| return "s⑦\<Esc>"
  elseif search('\%#⑦', 'bcn')	| return "s⑧\<Esc>"
  elseif search('\%#⑧', 'bcn')	| return "s⑨\<Esc>"
  elseif search('\%#⑨', 'bcn')	| return "s⑩\<Esc>"
  elseif search('\%#⑩', 'bcn')	| return "s⑪\<Esc>"
  elseif search('\%#⑪', 'bcn')	| return "s⑫\<Esc>"
  elseif search('\%#⑫', 'bcn')	| return "s⑬\<Esc>"
  elseif search('\%#⑬', 'bcn')	| return "s⑭\<Esc>"
  elseif search('\%#⑭', 'bcn')	| return "s⑮\<Esc>"
  elseif search('\%#⑮', 'bcn')	| return "s⑯\<Esc>"
  endif
  return ''
endfunc
function! C_X()
      if search('\%#②', 'bcn')	| return "s①\<Esc>"
  elseif search('\%#③', 'bcn')	| return "s②\<Esc>"
  elseif search('\%#④', 'bcn')	| return "s③\<Esc>"
  elseif search('\%#⑤', 'bcn')	| return "s④\<Esc>"
  elseif search('\%#⑥', 'bcn')	| return "s⑤\<Esc>"
  elseif search('\%#⑦', 'bcn')	| return "s⑥\<Esc>"
  elseif search('\%#⑧', 'bcn')	| return "s⑦\<Esc>"
  elseif search('\%#⑨', 'bcn')	| return "s⑧\<Esc>"
  elseif search('\%#⑩', 'bcn')	| return "s⑨\<Esc>"
  elseif search('\%#⑪', 'bcn')	| return "s⑩\<Esc>"
  elseif search('\%#⑫', 'bcn')	| return "s⑪\<Esc>"
  elseif search('\%#⑬', 'bcn')	| return "s⑫\<Esc>"
  elseif search('\%#⑭', 'bcn')	| return "s⑬\<Esc>"
  elseif search('\%#⑮', 'bcn')	| return "s⑭\<Esc>"
  elseif search('\%#⑯', 'bcn')	| return "s⑮\<Esc>"
  endif
  return ''
endfunc
nnoremap <C-a> :call C_A()<CR>
nnoremap <C-x> :call C_X()<CR>

nnoremap <expr> <C-a> search('\%#[\U2460-\U2473]', 'bcn') ? C_A() : "<C-a>"
nnoremap <expr> <C-x> search('\%#[\U2460-\U2473]', 'bcn') ? C_X() : "<C-x>"

"inoremap (( （
"inoremap )) ）

"nmap 　 <Space>

set guicursor=n-v-c:block-Cursor/lCursor,ve:ver35-Cursor,o:hor50-Cursor,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor,a:blinkon0
set guicursor=n-v-c:ver10-Cursor/lCursor,ve:ver35-Cursor,o:hor50-Cursor,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor,a:blinkon0

call ResizeFont(0)

set visualbell t_vb=
