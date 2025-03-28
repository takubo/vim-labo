vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8


#----------------------------------------------------------------------------------------
# Utility Commands
#----------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------
# Help
com! FL help function-list<CR>

#----------------------------------------------------------------------------------------
# メーデー Tablineを非表示にする
com! Mayday set showtabline=0
com! MayDay Mayday
com! MAYDAY Mayday


#----------------------------------------------------------------------------------------
# Vertical-f

com! -nargs=1 VerticalFFwrd | call search('^\s*' .. <q-args>)
com! -nargs=1 VerticalFBack | call search('^\s*' .. <q-args>, 'b')


#----------------------------------------------------------------------------------------
# Switch Options

#com! AR let &l:autoread = !&l:autoread
com! AR setl autoread!

com! Wrap      PushPosAll | exe 'windo set wrap'   | PopPosAll
com! NoWrap    PushPosAll | exe 'windo set nowrap' | PopPosAll

com! WinWrap   PushPosAll | exe 'windo set wrap'   | PopPosAll
com! WinNoWrap PushPosAll | exe 'windo set nowrap' | PopPosAll

com! AllWrap   PushPosAll | exe 'windo set wrap'   | PopPosAll
com! AllNoWrap PushPosAll | exe 'windo set nowrap' | PopPosAll


#----------------------------------------------------------------------------------------
# Tempfile
com! -bar -nargs=? ETempfile exe 'edit'      tempname() . (<q-args> =~ '^[^.]' ? '.' . <q-args> : <q-args>)
com! -bar -nargs=? STempfile exe 'split'     tempname() . (<q-args> =~ '^[^.]' ? '.' . <q-args> : <q-args>)
com! -bar -nargs=? VTempfile exe 'vsplit'    tempname() . (<q-args> =~ '^[^.]' ? '.' . <q-args> : <q-args>)
com! -bar -nargs=? TTempfile exe 'tab split' tempname() . (<q-args> =~ '^[^.]' ? '.' . <q-args> : <q-args>)
com! -bar -nargs=? Tempfile  STempfile <args>


#----------------------------------------------------------------------------------------
# 単語文字数自動表示
augroup WordLen
  autocmd!
  # autocmd CursorHold * echo len(expand('<cword>'))
augroup END


#----------------------------------------------------------------------------------------
com! Utf8  setl fileencoding=UTF-8
com! EucJp setl fileencoding=EUC-JP
com! Cp932 setl fileencoding=CP932


#----------------------------------------------------------------------------------------
# HighlightInfo


#----------------------------------------------------------------------------------------
# 変更済み 無名バッファ

def NextModifiedNonamebuf(dir: number)
  const first_buf = 1
  const last_buf  = bufnr('$')
  const cur_buf   = bufnr()

  var sta1: number
  var end1: number
  var sta2: number
  var end2: number
  var dis:  number

  if dir > 0
    sta1 = cur_buf + 1
    end1 = last_buf

    sta2 = first_buf
    end2 = cur_buf - 1

    dis = +1
  else
    sta1 = cur_buf - 1
    end1 = first_buf

    sta2 = last_buf
    end2 = cur_buf + 1

    dis = -1
  endif

  if !NextModifiedNonamebuf_Sub(sta1, end1, dis)
    if !NextModifiedNonamebuf_Sub(sta2, end2, dis)
      echo '変更された無名バッファはありません。'
    endif
  endif
enddef

def NextModifiedNonamebuf_Sub(sta: number, end: number, dis: number): bool
  for i in range(sta, end, dis)
    if buflisted(i) && bufname(i) == '' && getbufinfo(i)[0].changed
      exe 'buffer' i
      return true
    endif
  endfor
  return false
enddef

com! -nargs=0 -bar NextNonameModifiedBuf call NextModifiedNonamebuf(+1)
com! -nargs=0 -bar PrevNonameModifiedBuf call NextModifiedNonamebuf(-1)


#----------------------------------------------------------------------------------------
# #if-#def の構造を可視化する。

const Indent = 4

def IfDefStruct()
  var ind = -Indent

  for i in range(1, line('$'))
    const str = getline(i)

    if i == line('.')
      echo repeat(' ', ind + Indent) .. '........................................'
    endif

    if     str =~# '^\s*#\s*if'
      ind += Indent
    elseif str =~# '^\s*#\s*elif'
    elseif str =~# '^\s*#\s*else'
    elseif str =~# '^\s*#\s*endif'
    else
      continue
    endif
    echo repeat(' ', ind) .. str

    if     str =~# '^\s*#\s*endif'
      # 見やすいように、endifの後には空行を出力。
      #echo "\n"
      ind -= Indent
    endif
  endfor
enddef

def IfDefStructInBuffer()
  const temp = execute('IfDefStruct')
  new
  silent put =temp
  :1,2delete _
enddef

com! IfDefStruct call IfDefStruct()
com! IfDefStructInBuffer call IfDefStructInBuffer()


#----------------------------------------------------------------------------------------
# ifdefを閉じる

com! FoldIfdef setl foldmarker=#if,#endif | setl foldmethod=marker | normal! zM
com! IfdefFold FoldIfdef


#----------------------------------------------------------------------------------------
# Add Include

iab <silent> inc  #include ""<Left><C-x><C-f><C-R>=Eatchar('\s')<CR>
iab <silent> ins  #include <><Left><C-x><C-f><C-R>=Eatchar('\s')<CR>


#----------------------------------------------------------------------------------------
# Add IncludeGuard

def InsertIncludeGurd()
  const filename_part = expand('%')->toupper()->substitute('\W', '_', 'g')

  const prefix_filename = (exists('g:IncludeGuardPrefix') ? g:IncludeGuardPrefix : '') .. filename_part

  const ig_head = "#ifndef\t" .. prefix_filename
  const ig_cmnt = "#define\t" .. prefix_filename
  const ig_tail = "#endif\t/* " .. prefix_filename .. " */"

  append(0, ig_head)
  append(1, ig_cmnt)
  append(line('$'), ig_tail)

  echo prefix_filename
enddef

com! -nargs=0 -bar InsertIncludeGurd call InsertIncludeGurd()


#----------------------------------------------------------------------------------------
# 関数の行数を表示する

def CountFunctionLines()
  # 現在カーソル行を保存
  const cur_line = line('.')
  # スクリーンの最上行へ移動
  normal! H
  # スクリーン最上行を保存
  const top_line = line('.')
  # カーソル行へ戻る
  execute 'normal ' . cur_line . 'G'
  # 関数先頭へ移動
  normal! [[
  const sta_line = line('.')
  # 関数末尾へ移動
  normal! ][
  const end_line = line('.')
  # 結果(関数の行数)表示
  echo end_line - sta_line + 1
  # 保存していた位置に戻る
  execute 'normal ' . top_line . 'G'
  normal! z<CR>
  execute 'normal ' . cur_line . 'G'
enddef

command! FuncLines CountFunctionLines()


#----------------------------------------------------------------------------------------
# Func Inner Search

def FuncInnerSearch(): string
  const lines = FuncRange()
  const search = '\%>' .. (lines[0] - 1) .. 'l\%<' .. (lines[1]  + 1) .. 'l'
  return search
enddef

# TODO Cの特定の書き方しか対応してない。
def FuncRange(): list<number>
  PushPos

  # 2jは、関数の先頭に居た時用
  # 2kは、関数定義行を含むため
  # TODO いずれも暫定
  keepjumps normal! 2j[[2k
  const first_line = line('.')
  keepjumps normal! ][
  const last_line = line('.')

  PopPos

  return [first_line, last_line]
enddef


#----------------------------------------------------------------------------------------
# Count Line

function CountLine() range
  echo a:lastline - a:firstline + 1
endfunction

com! -range L :<line1>,<line2> call CountLine()


#----------------------------------------------------------------------------------------
# Surround Line Brace

function SurroundLineBrace() range
  " echo a:firstline a:lastline
  " red
  " sleep 2
  exe a:lastline
  normal! o}
  exe a:firstline
  normal! O{
  normal! j>i{>a{
endfunction

com! -range Brace :<line1>,<line2>call SurroundLineBrace()


#----------------------------------------------------------------------------------------
# Edit

com! -nargs=0 -bar Tab2Space setlocal   expandtab | retab<CR>
com! -nargs=0 -bar Space2Tab setlocal noexpandtab | retab!<CR>

com! KakkoZenkaku {
        s/(/（/g
        s/)/）/g
      }


#----------------------------------------------------------------------------------------
# Macro

com! MacroStart normal! qq
com! MacroEnd   normal! q


#----------------------------------------------------------------------------------------
# Git

com! Branch echo FugitiveHead(7)


#----------------------------------------------------------------------------------------
# Insert Unicode Character
com! -nargs=1 Unicode exe 'normal! o<C-v>u' . tolower('<args>') . '<Esc>'


#----------------------------------------------------------------------------------------
# XML

com! -nargs=0 -bar XMLShape :%s/></>\r</g | filetype indent on | setf xml | normal gg=G


#----------------------------------------------------------------------------------------
# Markdown

# def MdBar()
#   const str = getline(line('.') - 1)
#   const width = strdisplaywidth(str, 0)
#   call setline('.', repeat('-', width))
# enddef

def MdBar()
  const len = getline('.')->strdisplaywidth()
  exe 'normal! o' .. repeat('-', len)
enddef

com! MdBar MdBar()

com! MdGrep grep -B1 -- '^---' %


#----------------------------------------------------------------------------------------
# Plant UML

# Windowsでの設定例です。他の場合は外部コマンド部分を読み替えてください。
augroup PlantUML
  au!
  au FileType plantuml com! OpenUml :!/cygdrive/c/Program\ Files/Google/Chrome/Application/chrome.exe %
augroup end


#----------------------------------------------------------------------------------------
# Calender and Clock

com! Date echo system("date")
#com! Cal echo system("cal")
#com! Cal echo system("cal") | echo system("date")
#com! Cal echo ' ' | echo system("date") | echo ' ' | echo ' ' | echo system("cal")
com! Koyomi echo ' ' | echo system("cal") | echo ' ' | echo ' ' | echo system("Date")

com! Time call popup_create( strftime('%Y/%m/%d (%a)    %X'), {
                 \ pos: 'center',
                 \ moved: 'any',
                 \ tabpage: 0,
                 \ wrap: v:false,
                 \ zindex: 200,
                 \ highlight: 'NormalPop',
                 \ border: [2, 2, 2, 2],
                 \ close: 'click',
                 \ padding: [2, 4, 2, 4],
               \ }
            \ )
                 # time: a:time,
                 # minwidth: 30,
                 # maxheight: &lines - 4 - 3,
                 # mask: mask
                 # filter: 'popup_filter_menu',
