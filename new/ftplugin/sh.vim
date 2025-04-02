scriptencoding utf-8
" vim:set ts=8 sts=2 sw=2 tw=0:

function! s:mk_ab(a, b)
  exe 'inorea <buffer> ' . a:a . ' ' . a:b . "<C-R>=Eatchar('\\s')<CR>"
'
endfunc

call s:mk_ab("A", "<Bar> awk '")
call s:mk_ab("AF", "for (i = 1; i <= NF; i++) { ")
call s:mk_ab("AB", "<Bar> awk 'BEGIN{ ")
call s:mk_ab("ABF", "<Bar> awk 'BEGIN{ printf \"%")
call s:mk_ab("C", "<Bar> cat -n ")
call s:mk_ab("CA", "<Bar> --color=always ")
call s:mk_ab("CN", "<Bar> --color=none ")
call s:mk_ab("D", "<Bar> disp")
call s:mk_ab("DB", "<Bar> d2b -s ")
call s:mk_ab("DX", "<Bar> d2x -s ")
call s:mk_ab("F", "<Bar> find -iname '**")
call s:mk_ab("FN", "<Bar> find -iname '**")
call s:mk_ab("F1", "<Bar> find -maxdepth 1 -name '*")
call s:mk_ab("FO", "-o -name '*")
call s:mk_ab("FG", "<Bar> find <Bar> xargs grep ")
call s:mk_ab("FLD", "<Bar> s2t <Bar> cut -f'")
call s:mk_ab("FNS", "<Bar> find -name '.svn' -prune -type f -o -name '")
call s:mk_ab("FNG", "<Bar> find -name '.git' -prune -type f -o -name '")
call s:mk_ab("G", "<Bar> grep ")
call s:mk_ab("GV", "<Bar> grep -v ")
call s:mk_ab("H", "<Bar> head -n 20 ")
call s:mk_ab("HN", "<Bar> head -n ")
call s:mk_ab("HL", "--help")
call s:mk_ab("I", "<Bar> ")
call s:mk_ab("L", "<Bar> clip")
call s:mk_ab("LC", "LANG=C ")
call s:mk_ab("LJ", "LANG=ja_JP.UTF-8 ")
call s:mk_ab("N", "> /dev/null ")
call s:mk_ab("NN", "> /dev/null 2>&1")
call s:mk_ab("NE", "2> /dev/null")
call s:mk_ab("NI", "< /dev/null")
call s:mk_ab("Q", "<Bar> sort ")
call s:mk_ab("S", "<Bar> sed '")
call s:mk_ab("SN", "<Bar> sed -n '")
call s:mk_ab("SS", "<Bar> sed 's/")
call s:mk_ab("T", "<Bar> tail -n 20 ")
call s:mk_ab("TN", "<Bar> tail -n ")
call s:mk_ab("TL", "<Bar> tr 'A-Z' 'a-z' ")
call s:mk_ab("TU", "<Bar> tr 'a-z' 'A-Z' ")
call s:mk_ab("U", "<Bar> iconv -f cp932 -t utf-8 ")
call s:mk_ab("UU", "<Bar> iconv -f utf-8 -t cp932 ")
call s:mk_ab("UE", "<Bar> iconv -f euc-jp -t utf-8 ")
call s:mk_ab("UN", "<Bar> sort <Bar> uniq")
call s:mk_ab("V", "<Bar> vim -R - ")
call s:mk_ab("W", "<Bar> wc -l ")
call s:mk_ab("X", "<Bar> xargs ")
call s:mk_ab("XI", "<Bar> xargs -i ")
call s:mk_ab("XN", "<Bar> xargs -n ")
