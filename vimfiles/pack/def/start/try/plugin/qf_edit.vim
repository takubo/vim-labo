vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8


#---------------------------------------------------------------------------------------------
# Qickfix Edit
#---------------------------------------------------------------------------------------------



#---------------------------------------------------------------------------------------------
# Variables

var History = {}



#---------------------------------------------------------------------------------------------
# Functions


#--------------------------------------------
# Delete

function DeleteEntry() range
  const winnr = winnr()
  const GetListFunc = b:QuickFix ? function('getqflist') : function('getloclist', [winnr])
  const SetListFunc = b:QuickFix ? function('setqflist') : function('setloclist', [winnr])

  call <SID>DeleteEntry_body(a:firstline, a:lastline, GetListFunc, SetListFunc)
endfunction

def DeleteEntry_body(firstline: number, lastline: number, GetListFunc: func, SetListFunc: func)
  const id = GetListFunc({'id': 0}).id
  var history = get(History, id, [])

  var qf = GetListFunc()

  history -> add(copy(qf))
  History[id] = history

  qf -> remove(firstline - 1, lastline - 1)

  const title = GetListFunc({'title': 0}).title

  # TODO noau がないと、FTloadが走る。
  #      function <SNR>82_del_entry[6]..FileType Autocommands for "*"..function <SNR>12_LoadFTPlugin[18]..script C:\Users\UserName\vimfiles\ftplugin\qf.vim の処理中にエラーが検出されました:
  #      行  121:
  # E127: 関数 <SNR>82_del_entry を再定義できません: 使用中です
  noautocmd SetListFunc(qf, 'r')
  SetListFunc([], 'r', {'title': title})

  execute ':' .. firstline
enddef


#--------------------------------------------
# Undo

def Undo()
  const winnr = winnr()
  const GetListFunc = b:QuickFix ? function('getqflist') : function('getloclist', [winnr])
  const SetListFunc = b:QuickFix ? function('setqflist') : function('setloclist', [winnr])

  Undo_body(GetListFunc, SetListFunc)
enddef

def Undo_body(GetListFunc: func, SetListFunc: func)
  const id = GetListFunc({'id': 0}).id
  var history = get(History, id, [])

  if !empty(history)
    const title = GetListFunc({'title': 0}).title
    const curpos = getpos('.')

    # TODO noau がないと、FTloadが走る。
    noautocmd remove(history, -1) -> SetListFunc('r')
    SetListFunc([], 'r', {'title': title})

    setpos('.', curpos)
  endif
enddef



#---------------------------------------------------------------------------------------------
# Mapping

nnoremap <silent> <Plug>(QuickfixEdit-Delelte)        <ScriptCmd>DeleteEntry()<CR>
nnoremap <silent> <Plug>(QuickfixEdit-Delelte)        <ScriptCmd>DeleteEntry()<CR>

vnoremap <silent> <Plug>(QuickfixEdit-Delelte-Visual) :call <SID>DeleteEntry()<CR>
vnoremap <silent> <Plug>(QuickfixEdit-Delelte-Visual) :call <SID>DeleteEntry()<CR>

nnoremap <silent> <Plug>(QuickfixEdit-Undo)           <ScriptCmd>Undo()<CR>
