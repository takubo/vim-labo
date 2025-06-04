vim9script

#def Jindentexpr(): number
#  #var lnum = v:lnum
#  var lnum = line('.')
#
#  if 1 == lnum
#    return -1
#  endif
#
#  var prev_lnum = prevnonblank(lnum - 1)
#
#  for i in range(99)
#  #while 0 < prev_lnum
#    var line = getline(prev_lnum)
#    if line =~# '^\s*[⇒→]'
#      return indent(prev_lnum) + 3
#    endif
#    if line =~# '^\s*[\U2460-\U2473・□■◇◆〇●〇◎]'
#      return indent(prev_lnum) + 2
#    endif
#    prev_lnum = prevnonblank(prev_lnum - 1)
#  #endwhile
#  endfor
#
#  return -1
#enddef

def g:Jindentexpr(): number
  return Jindentexpr()
enddef

def Jindentexpr(): number
  #const lnum = v:lnum
  const lnum = line('.')

  if 1 == lnum
    return -1
  endif

  var prev_lnum = prevnonblank(lnum - 1)

  var line = getline(prev_lnum)
  if (line =~# '^\s*[⇒→]') && (prev_lnum == (lnum - 1))
    return indent(prev_lnum) + 3
  endif
  if line =~# '^\s*[\U2460-\U2473・□■◇◆〇●〇◎☆★※]'
    const prev_topchar =          line->substitute('^\s\+', '', '')[0]
    const cur_topchar  = getline(lnum)->substitute('^\s\+', '', '')[0]
    if prev_topchar != cur_topchar
      return indent(prev_lnum) + 2
    endif
    if prev_topchar == cur_topchar
      return indent(prev_lnum)
    endif
  endif

  return indent(prev_lnum)
enddef

defcompile

#set indentexpr=Jindentexpr()
#com! Jindent setl indentexpr=g:Jindentexpr()
com! Jindent setl indentexpr=<SID>Jindentexpr()
