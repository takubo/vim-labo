finish


cd \Users\$USER\vim_swap

function! s:rec() " abort
    let filelist = glob("_.s*")
    let splitted = split(filelist, "\n")
    for file in splitted
	"echo file
	new
	cd \Users\$USER\vim_swap
	try
	    exe "recover " . file
	catch
	finally
    endfor
endfunction

call s:rec()
