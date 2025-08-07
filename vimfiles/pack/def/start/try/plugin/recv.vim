"finish


"cd \Users\$USER\vim_swap
cd ~/vim_swap

function! s:rec() " abort
    cd ~/vim_swap
    let filelist = glob("_.s*")
    let splitted = split(filelist, "\n")
    let RecvNum = len(splitted)
    for file in splitted
	"echo file
	tabnew
	"cd \Users\$USER\vim_swap
	cd ~/vim_swap
	try
	    exe "recover " . file
	catch
	finally
        endtry
    endfor
endfunction

"call s:rec()

com! Recover call <SID>rec()
