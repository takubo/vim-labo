vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8


class Selector
  var Slector_Window_Height = 25
  var Slector_Use_Current_Window = false
  var Slector_Auto_Close = true
endclass



finish



# Height of the MRU window
# Default height is 8
if !exists('g:Slector_Window_Height')
    g:Slector_Window_Height = 25
endif

if !exists('g:Slector_Use_Current_Window')
    g:Slector_Use_Current_Window = 0
endif

if !exists('g:Slector_Auto_Close')
    g:Slector_Auto_Close = 1
endif


# MRU_Open_Window                       {{{1
# Display the Most Recently Used file list in a temporary window.
# If the optional argument is supplied, then it specifies the pattern of files
# to selectively display in the MRU window.
function MRU_Open_Window(...)

    " Load the latest MRU file list
    call s:MRU_LoadList()

    " Check for empty MRU list
    if empty(s:MRU_files)
        call s:MRU_Warn_Msg('MRU file list is empty')
        return
    endif

    " Save the current buffer number. This is used later to open a file when a
    " entry is selected from the MRU window. The window number is not saved,
    " as the window number will change when new windows are opened.
    let s:MRU_last_buffer = bufnr('%')

    let bname = '__MRU_Files__'

    " If the window is already open, jump to it
    let winnum = bufwinnr(bname)
    if winnum != -1
        if winnr() != winnum
            " If not already in the window, jump to it
            exe winnum . 'wincmd w'
        endif

        setlocal modifiable

        " Delete the contents of the buffer to the black-hole register
        silent! %delete _
    else
        if g:MRU_Use_Current_Window
            " Reuse the current window
            "
            " If the __MRU_Files__ buffer exists, then reuse it. Otherwise open
            " a new buffer
            let bufnum = bufnr(bname)
            if bufnum == -1
                let cmd = 'edit ' . bname
            else
                let cmd = 'buffer ' . bufnum
            endif

            exe cmd

            if bufnr('%') != bufnr(bname)
                " Failed to edit the MRU buffer
                return
            endif
        else
            " Open a new window at the bottom

            " If the __MRU_Files__ buffer exists, then reuse it. Otherwise open
            " a new buffer
            let bufnum = bufnr(bname)
            if bufnum == -1
                let wcmd = bname
            else
                let wcmd = '+buffer' . bufnum
            endif

            exe 'silent! botright ' . g:MRU_Window_Height . 'split ' . wcmd
        endif
    endif

    setlocal modifiable

    " Mark the buffer as scratch
    setlocal buftype=nofile
    setlocal bufhidden=delete
    setlocal noswapfile
    setlocal nowrap
    setlocal nobuflisted
    " Set the 'filetype' to 'mru'. This allows the user to apply custom
    " syntax highlighting or other changes to the MRU bufer.
    setlocal filetype=mru
    " Use fixed height for the MRU window
    setlocal winfixheight

    " Setup the cpoptions properly for the maps to work
    let old_cpoptions = &cpoptions
    set cpoptions&vim

    " Create mappings to select and edit a file from the MRU list
    nnoremap <buffer> <silent> <CR>
                \ :call <SID>MRU_Select_File_Cmd('edit,useopen')<CR>
    vnoremap <buffer> <silent> <CR>
                \ :call <SID>MRU_Select_File_Cmd('edit,useopen')<CR>
    nnoremap <buffer> <silent> o
                \ :call <SID>MRU_Select_File_Cmd('edit,newwin_horiz')<CR>
    vnoremap <buffer> <silent> o
                \ :call <SID>MRU_Select_File_Cmd('edit,newwin_horiz')<CR>
    nnoremap <buffer> <silent> <S-CR>
                \ :call <SID>MRU_Select_File_Cmd('edit,newwin_horiz')<CR>
    vnoremap <buffer> <silent> <S-CR>
                \ :call <SID>MRU_Select_File_Cmd('edit,newwin_horiz')<CR>
    nnoremap <buffer> <silent> O
                \ :call <SID>MRU_Select_File_Cmd('edit,newwin_vert')<CR>
    vnoremap <buffer> <silent> O
                \ :call <SID>MRU_Select_File_Cmd('edit,newwin_vert')<CR>
    nnoremap <buffer> <silent> t
                \ :call <SID>MRU_Select_File_Cmd('edit,newtab')<CR>
    vnoremap <buffer> <silent> t
                \ :call <SID>MRU_Select_File_Cmd('edit,newtab')<CR>
    nnoremap <buffer> <silent> v
                \ :call <SID>MRU_Select_File_Cmd('view,useopen')<CR>
    nnoremap <buffer> <silent> p
                \ :call <SID>MRU_Select_File_Cmd('view,preview')<CR>
    vnoremap <buffer> <silent> p
                \ :<C-u>if line("'<") == line("'>")<Bar>
                \     call <SID>MRU_Select_File_Cmd('open,preview')<Bar>
                \ else<Bar>
                \     echoerr "Only a single file can be previewed"<Bar>
                \ endif<CR>
    nnoremap <buffer> <silent> u :MRU<CR>
    nnoremap <buffer> <silent> <2-LeftMouse>
                \ :call <SID>MRU_Select_File_Cmd('edit,useopen')<CR>
    nnoremap <buffer> <silent> q :close<CR>

    " Restore the previous cpoptions settings
    let &cpoptions = old_cpoptions

    " Display the MRU list
    if a:0 == 0
        " No search pattern specified. Display the complete list
        let m = copy(s:MRU_files)
    else
        " Display only the entries matching the specified pattern
	" First try using it as a literal pattern
	let m = filter(copy(s:MRU_files), 'stridx(v:val, a:1) != -1')
	if len(m) == 0
	    " No match. Try using it as a regular expression
	    let m = filter(copy(s:MRU_files), 'v:val =~# a:1')
	endif
    endif

    " Get the tail part of the file name (without the directory) and display
    " it along with the full path in parenthesis.
    let  output = map(m, g:MRU_Filename_Format.formatter)
    silent! 0put =output

    " Delete the empty line at the end of the buffer
    silent! $delete _

    " Move the cursor to the beginning of the file
    normal! gg

    " Add syntax highlighting for the file names
    if has_key(g:MRU_Filename_Format, 'syntax')
        exe "syntax match MRUFileName '" . g:MRU_Filename_Format.syntax . "'"
        highlight default link MRUFileName Identifier
    endif

    setlocal nomodifiable
endfunction


finish



" When only a single matching filename is found in the MRU list, the following
" option controls whether the file name is displayed in the MRU window or the
" file is directly opened. When this variable is set to 0 and a single
" matching file name is found, then the file is directly opened.
if !exists('MRU_Window_Open_Always')
    let MRU_Window_Open_Always = 0
endif

" When opening a file from the MRU list, the file is opened in the current
" tab. If the selected file has to be opened in a tab always, then set the
" following variable to 1. If the file is already opened in a tab, then the
" cursor will be moved to that tab.
if !exists('MRU_Open_File_Use_Tabs')
    let MRU_Open_File_Use_Tabs = 0
endif

" Format of the file names displayed in the MRU window.
" The default is to display the filename followed by the complete path to the
" file in parenthesis. This variable controls the expressions used to format
" and parse the path. This can be changed to display the filenames in a
" different format. The 'formatter' specifies how to split/format the filename
" and 'parser' specifies how to read the filename back; 'syntax' matches the
" part to be highlighted.
if !exists('MRU_Filename_Format')
    let MRU_Filename_Format = {
        \   'formatter': 'fnamemodify(v:val, ":t") . " (" . v:val . ")"',
        \   'parser': '(\zs.*\ze)',
        \   'syntax': '^.\{-}\ze('
        \}
endif

" Control to temporarily lock the MRU list. Used to prevent files from
" getting added to the MRU list when the ':vimgrep' command is executed.
let s:mru_list_locked = 0

" MRU_LoadList                          {{{1
" Loads the latest list of file names from the MRU file
function! s:MRU_LoadList()
    " If the MRU file is present, then load the list of filenames. Otherwise
    " start with an empty list.
    if filereadable(g:MRU_File)
        let s:MRU_files = readfile(g:MRU_File)
        if s:MRU_files[0] =~# '^\s*" Most recently edited files in Vim'
            " Generated by the previous version of the MRU plugin.
            " Discard the list.
            let s:MRU_files = []
        elseif s:MRU_files[0] =~# '^#'
            " Remove the comment line
            call remove(s:MRU_files, 0)
        else
            " Unsupported format
            let s:MRU_files = []
        endif
    else
        let s:MRU_files = []
    endif
endfunction

" MRU_SaveList                          {{{1
" Saves the MRU file names to the MRU file
function! s:MRU_SaveList()
    let l = []
    call add(l, '# Most recently edited files in Vim (version 3.0)')
    call extend(l, s:MRU_files)
    call writefile(l, g:MRU_File)
endfunction

" MRU_AddFile                           {{{1
" Adds a file to the MRU file list
"   acmd_bufnr - Buffer number of the file to add
function! s:MRU_AddFile(acmd_bufnr)
    if s:mru_list_locked
        " MRU list is currently locked
        return
    endif

    " Get the full path to the filename
    let fname = fnamemodify(bufname(a:acmd_bufnr + 0), ':p')
    if fname == ''
        return
    endif

    " Skip temporary buffers with buftype set. The buftype is set for buffers
    " used by plugins.
    if &buftype != ''
        return
    endif

    if g:MRU_Include_Files != ''
        " If MRU_Include_Files is set, include only files matching the
        " specified pattern
        if fname !~# g:MRU_Include_Files
            return
        endif
    endif

    if g:MRU_Exclude_Files != ''
        " Do not add files matching the pattern specified in the
        " MRU_Exclude_Files to the MRU list
        if fname =~# g:MRU_Exclude_Files
            return
        endif
    endif

    " If the filename is not already present in the MRU list and is not
    " readable then ignore it
    let idx = index(s:MRU_files, fname)
    if idx == -1
        if !filereadable(fname)
            " File is not readable and is not in the MRU list
            return
        endif
    endif

    " Load the latest MRU file list
    call s:MRU_LoadList()

    " Remove the new file name from the existing MRU list (if already present)
    call filter(s:MRU_files, 'v:val !=# fname')

    " Add the new file list to the beginning of the updated old file list
    call insert(s:MRU_files, fname, 0)

    " Trim the list
    if len(s:MRU_files) > g:MRU_Max_Entries
        call remove(s:MRU_files, g:MRU_Max_Entries, -1)
    endif

    " Save the updated MRU list
    call s:MRU_SaveList()

    " If the MRU window is open, update the displayed MRU list
    let bname = '__MRU_Files__'
    let winnum = bufwinnr(bname)
    if winnum != -1
        let cur_winnr = winnr()
        call s:MRU_Open_Window()
        if winnr() != cur_winnr
            exe cur_winnr . 'wincmd w'
        endif
    endif
endfunction

" MRU_escape_filename                   {{{1
" Escape special characters in a filename. Special characters in file names
" that should be escaped (for security reasons)
let s:esc_filename_chars = ' *?[{`$%#"|!<>();&' . "'\t\n"
function! s:MRU_escape_filename(fname)
    if exists("*fnameescape")
        return fnameescape(a:fname)
    else
        return escape(a:fname, s:esc_filename_chars)
    endif
endfunction

" MRU_Edit_File                         {{{1
" Edit the specified file
"   filename - Name of the file to edit
"   sanitized - Specifies whether the filename is already escaped for special
"   characters or not.
function! s:MRU_Edit_File(filename, sanitized)
    if !a:sanitized
	let esc_fname = s:MRU_escape_filename(a:filename)
    else
	let esc_fname = a:filename
    endif

    " If the user wants to always open the file in a tab, then open the file
    " in a tab. If it is already opened in a tab, then the cursor will be
    " moved to that tab.
    if g:MRU_Open_File_Use_Tabs
	call s:MRU_Open_File_In_Tab(a:filename, esc_fname)
	return
    endif

    " If the file is already open in one of the windows, jump to it
    let winnum = bufwinnr('^' . a:filename . '$')
    if winnum != -1
        if winnum != winnr()
            exe winnum . 'wincmd w'
        endif
    else
        if !&hidden && (&modified || &buftype != '' || &previewwindow)
            " Current buffer has unsaved changes or is a special buffer or is
            " the preview window.  The 'hidden' option is also not set.
            " So open the file in a new window.
            exe 'split ' . esc_fname
        else
            " The current file can be replaced with the selected file.
            exe 'edit ' . esc_fname
        endif
    endif
endfunction

" MRU_Open_File_In_Tab
" Open a file in a tab. If the file is already opened in a tab, jump to the
" tab. Otherwise, create a new tab and open the file.
"   fname     : Name of the file to open
"   esc_fname : File name with special characters escaped
function! s:MRU_Open_File_In_Tab(fname, esc_fname)
    " If the selected file is already open in the current tab or in
    " another tab, jump to it. Otherwise open it in a new tab
    if bufwinnr('^' . a:fname . '$') == -1
	let tabnum = -1
	let i = 1
	let bnum = bufnr('^' . a:fname . '$')
	while i <= tabpagenr('$')
	    if index(tabpagebuflist(i), bnum) != -1
		let tabnum = i
		break
	    endif
	    let i += 1
	endwhile

	if tabnum != -1
	    " Goto the tab containing the file
	    exe 'tabnext ' . i
	else
	    " Open a new tab as the last tab page
	    exe '$tabnew ' . a:esc_fname
	endif
    endif

    " Jump to the window containing the file
    let winnum = bufwinnr('^' . a:fname . '$')
    if winnum != winnr()
	exe winnum . 'wincmd w'
    endif
endfunction

" MRU_Window_Edit_File                  {{{1
"   fname     : Name of the file to edit. May specify single or multiple
"               files.
"   edit_type : Specifies how to edit the file. Can be one of 'edit' or 'view'.
"               'view' - Open the file as a read-only file
"               'edit' - Edit the file as a regular file
"   multi     : Specifies  whether a single file or multiple files need to be
"               opened.
"   open_type : Specifies where to open the file.
"               useopen - If the file is already present in a window, then
"                         jump to that window.  Otherwise, open the file in
"                         the previous window.
"               newwin_horiz - Open the file in a new horizontal window.
"               newwin_vert - Open the file in a new vertical window.
"               newtab  - Open the file in a new tab. If the file is already
"                         opened in a tab, then jump to that tab.
"               preview - Open the file in the preview window
function! s:MRU_Window_Edit_File(fname, multi, edit_type, open_type)
    let esc_fname = s:MRU_escape_filename(a:fname)

    if a:open_type ==# 'newwin_horiz'
        " Edit the file in a new horizontally split window above the previous
        " window
        wincmd p
        exe 'belowright new ' . esc_fname
    elseif a:open_type ==# 'newwin_vert'
        " Edit the file in a new vertically split window above the previous
        " window
        wincmd p
        exe 'belowright vnew ' . esc_fname
    elseif a:open_type ==# 'newtab' || g:MRU_Open_File_Use_Tabs
	call s:MRU_Open_File_In_Tab(a:fname, esc_fname)
    elseif a:open_type ==# 'preview'
        " Edit the file in the preview window
        exe 'topleft pedit ' . esc_fname
    else
        " If the selected file is already open in one of the windows,
        " jump to it
        let winnum = bufwinnr('^' . a:fname . '$')
        if winnum != -1
            exe winnum . 'wincmd w'
        else
            if g:MRU_Auto_Close == 1 && g:MRU_Use_Current_Window == 0
                " Jump to the window from which the MRU window was opened
                if exists('s:MRU_last_buffer')
                    let last_winnr = bufwinnr(s:MRU_last_buffer)
                    if last_winnr != -1 && last_winnr != winnr()
                        exe last_winnr . 'wincmd w'
                    endif
                endif
            else
                if g:MRU_Use_Current_Window == 0
                    " Goto the previous window
                    " If MRU_Use_Current_Window is set to one, then the
                    " current window is used to open the file
                    wincmd p
                endif
            endif

            let split_window = 0

            if (!&hidden && (&modified || &previewwindow)) || a:multi
                " Current buffer has unsaved changes or is the preview window
                " or the user is opening multiple files
                " So open the file in a new window
                let split_window = 1
            endif

            if &buftype != ''
                " Current buffer is a special buffer (maybe used by a plugin)
                if g:MRU_Use_Current_Window == 0 ||
                            \ bufnr('%') != bufnr('__MRU_Files__')
                    let split_window = 1
                endif
            endif

            " Edit the file
            if split_window
                " Current buffer has unsaved changes or is a special buffer or
                " is the preview window.  So open the file in a new window
                if a:edit_type ==# 'edit'
                    exe 'split ' . esc_fname
                else
                    exe 'sview ' . esc_fname
                endif
            else
                if a:edit_type ==# 'edit'
                    exe 'edit ' . esc_fname
                else
                    exe 'view ' . esc_fname
                endif
            endif
        endif
    endif
endfunction

" MRU_Select_File_Cmd                   {{{1
" Open a file selected from the MRU window
"
"   'opt' has two values separated by comma. The first value specifies how to
"   edit the file  and can be either 'edit' or 'view'. The second value
"   specifies where to open the file. It can take one of the following values:
"     'useopen' to open file in the previous window
"     'newwin_horiz' to open the file in a new horizontal split window
"     'newwin_vert' to open the file in a new vertical split window.
"     'newtab' to open the file in a new tab.
" If multiple file names are selected using visual mode, then open multiple
" files (either in split windows or tabs)
function! s:MRU_Select_File_Cmd(opt) range
    let [edit_type, open_type] = split(a:opt, ',')

    let fnames = getline(a:firstline, a:lastline)

    if g:MRU_Auto_Close == 1 && g:MRU_Use_Current_Window == 0
        " Automatically close the window if the file window is
        " not used to display the MRU list.
        silent! close
    endif

    let multi = 0

    for f in fnames
        if f == ''
            continue
        endif

        " The text in the MRU window contains the filename in parenthesis
        let file = matchstr(f, g:MRU_Filename_Format.parser)

        call s:MRU_Window_Edit_File(file, multi, edit_type, open_type)

        if a:firstline != a:lastline
            " Opening multiple files
            let multi = 1
        endif
    endfor
endfunction

" MRU_Warn_Msg                          {{{1
" Display a warning message
function! s:MRU_Warn_Msg(msg)
    echohl WarningMsg
    echo a:msg
    echohl None
endfunction

" MRU_Complete                          {{{1
" Command-line completion function used by :MRU command
function! s:MRU_Complete(ArgLead, CmdLine, CursorPos)
    if a:ArgLead == ''
        " Return the complete list of MRU files
        return s:MRU_files
    else
        " Return only the files matching the specified pattern
        return filter(copy(s:MRU_files), 'v:val =~? a:ArgLead')
    endif
endfunction

" MRU_Cmd                               {{{1
" Function to handle the MRU command
"   pat - File name pattern passed to the MRU command
function! s:MRU_Cmd(pat)
    if a:pat == ''
        " No arguments specified. Open the MRU window
        call s:MRU_Open_Window()
        return
    endif

    let pat= '\c' . substitute(a:pat, ' \+', '.*', 'g')

    " Load the latest MRU file
    call s:MRU_LoadList()

    " Empty MRU list
    if empty(s:MRU_files)
        call s:MRU_Warn_Msg('MRU file list is empty')
        return
    endif

    " First use the specified string as a literal string and search for
    " filenames containing the string. If only one filename is found,
    " then edit it (unless the user wants to open the MRU window always)
    let m = filter(copy(s:MRU_files), 'stridx(v:val, pat) != -1')
    if len(m) > 0
	if len(m) == 1 && !g:MRU_Window_Open_Always
	    call s:MRU_Edit_File(m[0], 0)
	    return
	endif

	" More than one file matches. Try find an accurate match
	let new_m = filter(m, 'v:val ==# pat')
	if len(new_m) == 1 && !g:MRU_Window_Open_Always
	    call s:MRU_Edit_File(new_m[0], 0)
	    return
	endif

	" Couldn't find an exact match, open the MRU window with all the
        " files matching the pattern.
	call s:MRU_Open_Window(pat)
	return
    endif

    " Use the specified string as a regular expression pattern and search
    " for filenames matching the pattern
    let m = filter(copy(s:MRU_files), 'v:val =~? pat')

    if len(m) == 0
        " If an existing file (not present in the MRU list) is specified,
        " then open the file.
        if filereadable(pat)
            call s:MRU_Edit_File(pat, 0)
            return
        endif

        " No filenames matching the specified pattern are found
        call s:MRU_Warn_Msg("MRU file list doesn't contain " .
                    \ "files matching " . pat)
        return
    endif

    if len(m) == 1 && !g:MRU_Window_Open_Always
        call s:MRU_Edit_File(m[0], 0)
        return
    endif

    call s:MRU_Open_Window(pat)
endfunction

" Load the MRU list on plugin startup
call s:MRU_LoadList()

" MRU autocommands {{{1
" Autocommands to detect the most recently used files
autocmd BufRead * call s:MRU_AddFile(expand('<abuf>'))
autocmd BufNewFile * call s:MRU_AddFile(expand('<abuf>'))
autocmd BufWritePost * call s:MRU_AddFile(expand('<abuf>'))

" The ':vimgrep' command adds all the files searched to the buffer list.
" This also modifies the MRU list, even though the user didn't edit the
" files. Use the following autocmds to prevent this.
autocmd QuickFixCmdPre *vimgrep* let s:mru_list_locked = 1
autocmd QuickFixCmdPost *vimgrep* let s:mru_list_locked = 0

" Command to open the MRU window
command! -nargs=* -complete=customlist,s:MRU_Complete MRU call s:MRU_Cmd(<q-args>)
command! -nargs=* -complete=customlist,s:MRU_Complete Mru call s:MRU_Cmd(<q-args>)

" }}}
