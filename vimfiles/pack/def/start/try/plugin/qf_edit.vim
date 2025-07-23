vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8


#---------------------------------------------------------------------------------------------
# Qickfix Edit
#---------------------------------------------------------------------------------------------


#---------------------------------------------------------------------------------------------
# Mapping

nnoremap <silent> <Plug>(QuickfixEdit-Delelte)        <ScriptCmd>DelEntry()<CR>
nnoremap <silent> <Plug>(QuickfixEdit-Delelte)        <ScriptCmd>DelEntry()<CR>

vnoremap <silent> <Plug>(QuickfixEdit-Delelte-Visual) :call <SID>DelEntry()<CR>
vnoremap <silent> <Plug>(QuickfixEdit-Delelte-Visual) :call <SID>DelEntry()<CR>

nnoremap <silent> <Plug>(QuickfixEdit-Undo)           <ScriptCmd>UndoEntry()<CR>


#---------------------------------------------------------------------------------------------
# Variables

var History = {}


#---------------------------------------------------------------------------------------------
# Functions

function DelEntry() range
  const winnr = winnr()
  const GetList = b:QuickFix ? function('getqflist') : function('getloclist', [winnr])
  const SetList = b:QuickFix ? function('setqflist') : function('setloclist', [winnr])

  call <SID>DelEntry_body(a:firstline, a:lastline, GetList, SetList)
endfunction

def DelEntry_body(firstline: number, lastline: number, GetList: func, SetList: func)
  const id = GetList({'id': 0}).id
  var history = get(History, id, [])

  var qf = GetList()

  history -> add(copy(qf))
  History[id] = history

  qf -> remove(firstline - 1, lastline - 1)

  const title = GetList({'title': 0}).title

  # TODO noau がないと、FTloadが走る。
  #      function <SNR>82_del_entry[6]..FileType Autocommands for "*"..function <SNR>12_LoadFTPlugin[18]..script C:\Users\UserName\vimfiles\ftplugin\qf.vim の処理中にエラーが検出されました:
  #      行  121:
  # E127: 関数 <SNR>82_del_entry を再定義できません: 使用中です
  noautocmd SetList(qf, 'r')
  SetList([], 'r', {'title': title})

  execute ':' .. firstline
enddef

def UndoEntry()
  const winnr = winnr()
  const GetList = b:QuickFix ? function('getqflist') : function('getloclist', [winnr])
  const SetList = b:QuickFix ? function('setqflist') : function('setloclist', [winnr])

  UndoEntry_body(GetList, SetList)
enddef

def UndoEntry_body(GetList: func, SetList: func)
  const id = GetList({'id': 0}).id
  var history = get(History, id, [])

  if !empty(history)
    const title = GetList({'title': 0}).title
    const curpos = getpos('.')

    # TODO noau がないと、FTloadが走る。
    noautocmd remove(history, -1) -> SetList('r')
    SetList([], 'r', {'title': title})

    setpos('.', curpos)
  endif
enddef
