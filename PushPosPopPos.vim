vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8

#=============================================================================================
# PushposPopPos TODO restore pos.vim
#=============================================================================================



#---------------------------------------------------------------------------------------------
# Inner Window

var WinView: list<dict<number>>

def PushPos()
  WinView -> add( winsaveview() )     # カレントウィンドウのビューを取得
enddef

def PopPos()
  WinView -> remove(-1) -> winrestview()  # カレントウィンドウのビューを復元
enddef

#------------------
# Test
#
#def Test()
#  PushPos()
#  normal! G
#  redraw
#  sleep 1
#  PopPos()
#enddef
#
#Test()



#---------------------------------------------------------------------------------------------
# All

### データ構造定義 ###############
#  dict {
#    'org_win_id' : number;
#    'org_buf_nr' : number;
#  } PosAll[];
##################################
var PosAll = []

def PushPosAll()
  PushPos()
  PosAll -> add(
    {
      'org_win_id': win_getid(),
      'org_buf_nr': bufnr(),
    }
  )
enddef

def PopPosAll()
  const pos_all = PosAll -> remove(-1)
  win_gotoid(pos_all.org_win_id)
  exe 'buffer' pos_all.org_buf_nr
  PopPos()
enddef

#------------------
# Test
#
#def TestAll()
#    PushPosAll()
#    tabdo windo echo 100
#    PopPosAll()
#enddef
#
#TestAll()



#---------------------------------------------------------------------------------------------
# Commands

com! -bar -nargs=0 PushPos    call PushPos()
com! -bar -nargs=0 PopPos     call PopPos()

com! -bar -nargs=0 PushPosAll call PushPosAll()
com! -bar -nargs=0 PopPosAll  call PopPosAll()



#---------------------------------------------------------------------------------------------
# Abbreviations


inoreab <silent> pppos const org_win_view = winsaveview()   # save win view<CR>winrestview(org_win_view)   # restore win view<C-R>=Eatchar('\s')<CR>
inoreab <silent> ppwin const org_win_id = win_getid()  # save window<CR>win_gotoid(org_win_id)   # restore window<C-R>=Eatchar('\s')<CR>
inoreab <silent> pptab const org_win_id = win_getid()  # save window<CR>win_gotoid(org_win_id)   # restore window<C-R>=Eatchar('\s')<CR>
inoreab <silent> ppbuf const org_buf_nr = bufnr()  # save buffer<CR>exe 'buffer' org_buf_nr  # restore buffer<C-R>=Eatchar('\s')<CR>

inoreab <silent> ppdef defer winrestview(winsaveview())<CR>defer win_gotoid(win_getid())<CR>defer execute('buffer ' .. bufnr())<C-R>=Eatchar('\s')<CR>

#inoreab <silent> pppos defer winrestview(winsaveview())
#inoreab <silent> ppwin defer win_gotoid(win_getid())
#inoreab <silent> ppbuf defer execute('buffer ' .. bufnr())


#  defer winrestview(winsaveview())
#  defer win_gotoid(win_getid())
#  defer execute('buffer ' .. bufnr())


#def TestAbb()
#  defer winrestview(winsaveview())
#  defer win_gotoid(win_getid())
#  defer execute('buffer ' .. bufnr())
#
#  normal! G
#  redraw
#  sleep 1
#  tabdo windo echo 100
#enddef
#TestAbb()
