finish

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

def! C_X(count: number): string
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
enddef
nnoremap <C-A> :call C_A()<CR>
nnoremap <C-X> :call C_X()<CR>

nnoremap <expr> <C-A> search('\%#[\U2460-\U2473]', 'bcn') ? C_A() : "<C-A>"
nnoremap <expr> <C-X> search('\%#[\U2460-\U2473]', 'bcn') ? C_X() : "<C-X>"


function! C_X2(t)
  if a:t == ''
    let &operatorfunc = 'C_X2'
    "echo "#"
    let g:g =  "#"
    return 'g@l'
    "return  C_X() . 'g@l'
  endif
  "let g:g =  "%"
  "echo "%"
  let cx = C_X(v:count1)
  echo cx
  exe "normal! " . cx
  "exe "normal! G"
  "return cx
  "return "x" . 'g@l'
  "put =repeat(nr2char(10), 3)
  "return "G" . 'g@lG'
  return 'g@l'
  return cx . 'g@l'
  "return C_X() . 'g@l'
endfunction

function! C_X2(t)
  if a:t == ''
    let &operatorfunc = 'C_X2'
    return 'g@l'
  endif
  let cx = C_X(v:count1)
  exe "normal! " . cx
  return
endfunction
nnoremap <expr> <C-A> search('\%#[\U2460-\U2473]', 'bcn') ? C_A() : "<C-A>"
nnoremap <expr> <C-X> search('\%#[\U2460-\U2473]', 'bcn') ? C_X2('') : "<C-X>"
"nnoremap <expr> <C-X> ":normal! ". (search('\%#[\U2460-\U2473]', 'bcn') ? C_X2('') : "<C-X>")

function! DotRepeat_old(funcname)
  let &operatorfunc = a:funcname
  return 'g@l'
endfunction
function! C_X2(type)
  let cx = C_X(v:count1)
  exe "normal! " . cx
  return
endfunction


" let s:ll = 0
" fun! LL()
"   "normal! x
"   let s:ll = s:ll + 1
"   echo s:ll
"   return s:ll % 2 ? 'x' : "o\<esc>"
" endfunc
" nnoremap @ call LL()<CR>
" nnoremap <expr> @ LL()
" 
" 
" 
" 
" let g:rr = 0
" fun! RR2()
"   let g:rr += 1
"   echo g:rr
"   return g:rr % 2 ? 'x' : "o"
" endfunc
" fun! RR()
"   "normal! x
"   let s:rr = s:rr + 1
"   "echo s:rr
"   let k = "i=RR2()\<CR>\<Esc>"
"   return k
" endfunc
" nnoremap <expr> @ RR()
" 
" function! RR2()
"       if search('\%#②', 'bcn')	| call substitute('\%#②', 'bcn')return "①"
"   elseif search('\%#③', 'bcn')	| call substitute('\%#③', 'bcn')return "②"
"   elseif search('\%#④', 'bcn')	| call substitute('\%#④', 'bcn')return "③"
"   elseif search('\%#⑤', 'bcn')	| call substitute('\%#⑤', 'bcn')return "④"
"   elseif search('\%#⑥', 'bcn')	| call substitute('\%#⑥', 'bcn')return "⑤"
"   elseif search('\%#⑦', 'bcn')	| call substitute('\%#⑦', 'bcn')return "⑥"
"   elseif search('\%#⑧', 'bcn')	| call substitute('\%#⑧', 'bcn')return "⑦"
"   elseif search('\%#⑨', 'bcn')	| call substitute('\%#⑨', 'bcn')return "⑧"
"   elseif search('\%#⑩', 'bcn')	| call substitute('\%#⑩', 'bcn')return "⑨"
"   elseif search('\%#⑪', 'bcn')	| call substitute('\%#⑪', 'bcn')return "⑩"
"   elseif search('\%#⑫', 'bcn')	| call substitute('\%#⑫', 'bcn')return "⑪"
"   elseif search('\%#⑬', 'bcn')	| call substitute('\%#⑬', 'bcn')return "⑫"
"   elseif search('\%#⑭', 'bcn')	| call substitute('\%#⑭', 'bcn')return "⑬"
"   elseif search('\%#⑮', 'bcn')	| call substitute('\%#⑮', 'bcn')return "⑭"
"   elseif search('\%#⑯', 'bcn')	| call substitute('\%#⑯', 'bcn')return "⑮"
"   endif
"   return ''
" endfunc
" " ooooooooxoooooooxoxoxoxoxoxoxoxoxo
" 
" 
" 
" fun! LL()
"   "normal! x
"   let s:ll = s:ll + 1
"   echo s:ll
"   if s:ll % 2
"     normal! x
"   else
"     normal! o 
"   endif
"   return s:ll % 2 ? 'x' : "o\<esc>"
" endfunc
" nnoremap <expr> @ ":\<C-U>call LL()\<CR>"
" nnoremap <Plug>lll :<C-U>call LL()\<CR>
" nnoremap <expr> <Plug>lll ":\<C-U>call LL()\<CR>"
" nmap <expr> @ '<Plug>lll'
" 
" 
" "nnoremap <expr> @ ":\<C-U>call RR2()\<CR>"
