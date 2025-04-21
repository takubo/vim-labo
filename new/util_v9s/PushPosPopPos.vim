vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8


# restore pos.vim


#=============================================================================================
# PushposPopPos
#=============================================================================================


var org_win_view: dict<number>

def PushPos()
  org_win_view = winsaveview()  # カレントウィンドウのビューを取得
enddef

def PopPos()
  winrestview(org_win_view)  # カレントウィンドウのビューを復元
enddef


### データ構造定義 ###############
#  dict {
#    'org_win_id' : number;
#    'org_buf_nr' : number;
#  } PosAll[];
##################################
var PosAll = []

var org_win_id: number
var org_buf_nr: number

def PushPosAll()
  PushPos
  org_buf_nr = bufnr()
  org_win_id = win_getid()
enddef

def PopPosAll()
  win_gotoid(org_win_id)
  exe 'buffer' org_buf_nr
  PopPos
enddef

com PPP {
    PushPosAll()
    tabdo wind echon
    PopPosAll()
  }
if 0
com! -bar -nargs=0 PushPos    call PushPos()
com! -bar -nargs=0 PopPos     call PopPos()

com! -bar -nargs=0 PushPosAll call PushPosAll()
com! -bar -nargs=0 PopPosAll  call PopPosAll()
endif
#=============================================================================================

#inoreab pppos const org_win_view = winsaveview()  # カレントウィンドウのビューを取得<CR>winrestview(org_win_view)           # カレントウィンドウのビューを復元
#inoreab <silent> pppos const org_win_view = winsaveview()  # カレントウィンドウのビューを取得<CR>winrestview(org_win_view)           # カレントウィンドウのビューを復元<C-R>=Eatchar('\s')<CR>
inoreab <silent> pppos const org_win_view = winsaveview()   # push win view<CR>winrestview(org_win_view)   # pop win view<C-R>=Eatchar('\s')<CR>

#inoreab ppwin const org_win_id = win_getid()<CR>PushPoswin  win_gotoid(org_win_id)
inoreab <silent> ppwin const org_win_id = win_getid()  # push window<CR>win_gotoid(org_win_id)   # pop window<C-R>=Eatchar('\s')<CR>

inoreab <silent> ppbuf const org_buf_nr = bufnr(  # push buffer)<CR>exe 'buffer' org_buf_n  # pop bufferr<C-R>=Eatchar('\s')<CR>

# defer winrestview('winsaveview()')
# defer win_gotoid('win_getid()')
