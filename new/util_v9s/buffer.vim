vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8


# バッファ切替 (選択)
nnoremap  <C-K> :<C-U>ls <CR>:b<Space>
nnoremap g<C-K> :<C-U>ls!<CR>:b<Space>

# バッファ切替 (順番)
nnoremap g<A-n> <Cmd>bnext<CR>
nnoremap g<A-p> <Cmd>bprev<CR>


# バッファ切替 (無名バッファ)
# バッファ切替 (無名バッファ, 変更あり)
nnoremap         <A-p> <ScriptCmd>NextNonameBuf(-1, MODIFIED_ONLY)<CR>
nnoremap         <A-n> <ScriptCmd>NextNonameBuf(+1, MODIFIED_ONLY)<CR>
# バッファ切替 (無名バッファ, 変更なし)
nnoremap        g<A-p> <ScriptCmd>NextNonameBuf(-1, NO_MODIFIED_ONLY)<CR>
nnoremap        g<A-n> <ScriptCmd>NextNonameBuf(+1, NO_MODIFIED_ONLY)<CR>
# バッファ切替 (無名バッファ, 変更任意)
nnoremap <Leader><A-p> <ScriptCmd>NextNonameBuf(-1, REGARDLESS_OF_MODIFY)<CR>
nnoremap <Leader><A-n> <ScriptCmd>NextNonameBuf(+1, REGARDLESS_OF_MODIFY)<CR>

# com! -bar -bang -nargs=0 NonameBufPrev NextNonameBuf(-1, '<bar>' == '!' ? REGARDLESS_OF_MODIFY : NO_MODIFIED_ONLY)
# com! -bar -bang -nargs=0 NonameBufNext NextNonameBuf(+1, '<bar>' == '!' ? REGARDLESS_OF_MODIFY : NO_MODIFIED_ONLY)


# バッファ削除 (指定)
nnoremap <Leader>z :<C-U>bdel<Space>
nnoremap <Leader>Z :<C-U>bdel!<Space>

# バッファ削除 (選択)
nnoremap <Leader><C-K> :<C-U>ls <CR>:bdel<Space>


#---------------------------------------------------------------------------------------------
# EasyBuffer

if 0
  packadd EasyBuffer
  nnoremap <silent> <C-K> :<Cmd>EasyBufferBotRight<CR><Cmd>OptimalWindowHeight<CR>
endif


#---------------------------------------------------------------------------------------------
# ウィンドウレイアウトを崩さないでバッファを閉じる
com! -bar -bang CloseBuffer {
        const bufnr = bufnr('%')
        #bprevious
        bnext
        exe 'bdelete<bang>' bufnr
      }


#---------------------------------------------------------------------------------------------
# Move to No Name Buffer

const MODIFIED_ONLY = 2
const NO_MODIFIED_ONLY = 1
const REGARDLESS_OF_MODIFY = 0

def NextNonameBuf(dir: number = 0, modified: number = MODIFIED_ONLY)
  const cur_buf  = bufnr()
  const last_buf = bufnr('$')

  const cur_buf_plus_1  = min([cur_buf + 1, last_buf])
  const cur_buf_minus_1 = max([cur_buf - 1, 1       ])

  # cur_bufの次を起点とした、連番リスト。末尾で、先頭に戻って、循環。このリストに、cur_bufは含まない。
  var bufnrs = dir >= 0 ?
                (range(cur_buf_plus_1,  last_buf, +1) + range(1,        cur_buf_minus_1, +1)) :
                (range(cur_buf_minus_1, 1,        -1) + range(last_buf, cur_buf_plus_1,  -1))

  const Judge = (_, bufnr) => buflisted(bufnr) && bufname(bufnr) == '' &&
                          (
                            modified == REGARDLESS_OF_MODIFY                                  ||
                            modified == NO_MODIFIED_ONLY     && !getbufinfo(bufnr)[0].changed ||
                            modified == MODIFIED_ONLY        &&  getbufinfo(bufnr)[0].changed
                          )

  const tgt_bufnrs = bufnrs -> filter(Judge)

  if tgt_bufnrs != []
      exe 'buffer' tgt_bufnrs[0]
      return
  endif

  echo modified == MODIFIED_ONLY    ? '変更された無名バッファはありません。'       :
       modified == NO_MODIFIED_ONLY ? '変更されていない無名バッファはありません。' :
                                      '無名バッファはありません。'
enddef
