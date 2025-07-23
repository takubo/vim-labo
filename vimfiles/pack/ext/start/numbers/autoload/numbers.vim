vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8

#=============================================================================================
# Numbers
#=============================================================================================



#----------------------------------------------------------------------------------------
# Config Parameters
#----------------------------------------------------------------------------------------

const numbers_use_octal  = exists('g:numbers_use_octal' ) ? g:numbers_use_octal  : false
const numbers_extend_bin = exists('g:numbers_extend_bin') ? g:numbers_extend_bin : true
const numbers_extend_dec = exists('g:numbers_extend_dec') ? g:numbers_extend_dec : false
const numbers_extend_hex = exists('g:numbers_extend_hex') ? g:numbers_extend_hex : false



#----------------------------------------------------------------------------------------
# Constants
#----------------------------------------------------------------------------------------

# const b2h = {
#   '0000': '0',
#   '0001': '1',
#   '0010': '2',
#   '0011': '3',
#   '0100': '4',
#   '0101': '5',
#   '0110': '6',
#   '0111': '7',
#   '1000': '8',
#   '1001': '9',
#   '1010': 'a',
#   '1011': 'b',
#   '1100': 'c',
#   '1101': 'd',
#   '1110': 'e',
#   '1111': 'f',
# }

const h2b = {
  '0': '0000',
  '1': '0001',
  '2': '0010',
  '3': '0011',
  '4': '0100',
  '5': '0101',
  '6': '0110',
  '7': '0111',
  '8': '1000',
  '9': '1001',
  'a': '1010',
  'b': '1011',
  'c': '1100',
  'd': '1101',
  'e': '1110',
  'f': '1111',
}

const h2b_dsip = {
  '0': 'oooo',
  '1': 'oooI',
  '2': 'ooIo',
  '3': 'ooII',
  '4': 'oIoo',
  '5': 'oIoI',
  '6': 'oIIo',
  '7': 'oIII',
  '8': 'Iooo',
  '9': 'IooI',
  'a': 'IoIo',
  'b': 'IoII',
  'c': 'IIoo',
  'd': 'IIoI',
  'e': 'IIIo',
  'f': 'IIII',
}



#----------------------------------------------------------------------------------------
# Internal Functions
#----------------------------------------------------------------------------------------


def AnalizeNumberString(src_str: string): dict<any>
  var str = src_str
  var numstr = ''
  var base = 0

  if str =~? '[lLuU]\{,3\}$'  # long long型リテラルは、0x56LLのようにLが2つ付く
    str = str -> substitute('[ulUL]\+$', '', '')
  endif

  if true  # 桁区切りのアンダースコア
    str = str -> substitute('_', '', 'g')
  endif

  if     str =~? '^0x\x\+$'  # 16進数
    base   = 16
    numstr = str -> strpart(2)

  elseif str =~? '^\%([1-9]\d*\|0\+\)$'  # 0のみから構成される数は、Cの仕様上、厳密には8進であるが、便宜上10進として扱う。
    base   = 10
    numstr = str

  elseif numbers_use_octal && str =~? '^0\o\+$'  # 8進数
    base   = 8
    numstr = str

  elseif str =~? '^0b[01]\+$'  # 2進リテラル(C99)
    base   = 2
    numstr = str -> strpart(2)

  elseif numbers_extend_bin && str =~? '^\%(0b\)\?[_01]\+$'  # Cの接頭辞がない2進数 および 桁区切りにアンダースコアを使う2進数
    base   = 2
    numstr = str -> substitute('^0b\|_', '', 'g')

  elseif numbers_extend_hex && str =~? '^\x\+$'  # Cの接頭辞がない16進数
    base  =  16
    numstr = str

  elseif numbers_extend_dec && str =~? '^[1-9][0-9,]\+$'  # 桁区切りにカンマを使う10進数
    base   = 10
    numstr = str -> substitute('^0\+\|,', '', 'g')

  elseif !numbers_use_octal && str =~? '^[0-9]\+$'  # 0で始まる10進数 (8進数が無効のときのみ)
    base  =  10
    numstr = str -> substitute('^0\+', '', 'g')

  elseif numbers_extend_dec && !numbers_use_octal && str =~? '^[0-9][0-9,]\+$'  # 桁区切りにカンマを使う10進数
    base   = 10
    numstr = str -> substitute('^0\+\|,', '', 'g')

  endif

  return {'src': src_str, 'numstr': numstr, 'base': base}
enddef

# com! TestAnalizeNumberString echo AnalizeNumberString(expand("<cword>"))
# TestAnalizeNumberString


def HexAddLeadingZero(hex_str: string): string
  const len = len(hex_str)

  return len == 1            ? '0' .. hex_str                             :
         len == 3            ? '0' .. hex_str                             :
         len > 4 && len <  8 ? matchstr(    '000' .. hex_str, '.\{8\}$')  :
         len > 8 && len < 16 ? matchstr('0000000' .. hex_str, '.\{16\}$') :
                               hex_str
enddef

# com! TestHexAddLeadingZero echo expand("<cword>") -> substitute('^0x\|[lLuU]\+$', '', 'g') -> HexAddLeadingZero()
# TestHexAddLeadingZero


# 2進数に、4桁ごとにアンダースコアを挿入する
def BinUnderscore(numstr: string): string
  return numstr -> substitute('[01]\zs\ze\%([01]\{4\}\)\+$', '&_', 'g')
enddef


# 10進数に、4桁ごとにカンマを挿入する
def DecimalComma(numstr: string): string
  return numstr -> substitute('\d\zs\ze\%(\d\{3\}\)\+$', '&,', 'g')
enddef


# 16進数に、4桁ごとにアンダースコアを挿入する
def HexUnderscore(numstr: string): string
  return numstr -> substitute('\x\zs\ze\%(\x\{4\}\)\+$', '&_', 'g')
enddef


# 桁区切りを挿入する。
def InsertSeparator(
    numstr:  string,       # 変換対象文字列
    sep:     string = '',  # 桁区切り文字(カンマやアンダースコアなど)
    sep_dig: number = 4    # 桁区切り文字を何文字ごとに挿入するか
  ): string
  return numstr -> substitute(('\x\zs\ze\%(\x\{' .. sep_dig .. '\}\)\+$'), ('&' .. sep), 'g')
enddef



#----------------------------------------------------------------------------------------
# I/F Functions
#----------------------------------------------------------------------------------------


def Bin2Dec(bin_str: string): string
  if has('python3')
    return pyxeval('format(' .. (bin_str[0 : 1] != '0b' ? '0b' : '') .. bin_str .. ', "d")')
  else
    return printf('%u', (bin_str[0 : 1] != '0b' ? '0b' : '') .. bin_str)
  endif
enddef


def Bin2Hex(bin_str: string): string
  # return bin_str -> map((_, v) => b2h[v])
  # return bin_str -> substitute('^0b', '', '') -> map((_, v) => b2h[v])
  if has('python3')
    return pyxeval('format(' .. (bin_str[0 : 1] != '0b' ? '0b' : '') .. bin_str .. ', "x")')
  else
    return printf('%x', (bin_str[0 : 1] != '0b' ? '0b' : '') .. bin_str)
  endif
enddef


def Bin2Hex_LeadingZero(bin_str: string): string
  return bin_str -> Bin2Hex() -> HexAddLeadingZero()
enddef


def Dec2Bin(dec_str: string): string
  if has('python3')
    return pyxeval('format(' .. dec_str .. ', "b")')
  else
    return printf('%b', dec_str)
  endif
enddef


def Dec2Bin_Disp(dec_str: string): string
  return dec_str -> Dec2Hex() -> Hex2Bin_Disp()
enddef


def Dec2Hex(dec_str: string): string
  if has('python3')
    return pyxeval('format(' .. dec_str .. ', "x")')
  else
    return printf('%x', dec_str)
  endif
enddef


def Dec2Hex_LeadingZero(dec_str: string): string
  return dec_str -> Dec2Hex() -> HexAddLeadingZero()
enddef


def Hex2Bin(hex_str: string): string
  # return hex_str -> map((_, v) => h2b[tolower(v)])
  return hex_str -> substitute('^0x', '', '') -> map((_, v) => h2b[tolower(v)])
enddef


def Hex2Bin_Disp(hex_str: string): string
  # return hex_str -> map((_, v) => (h2b_dsip[tolower(v)] .. ' ')) -> substitute(' $', '', '')
  return hex_str -> substitute('^0x', '', '') -> map((_, v) => (h2b_dsip[tolower(v)] .. ' ')) -> substitute(' $', '', '')
enddef


def Hex2Dec(hex_str: string): string
  if has('python3')
    return pyxeval('format(' .. (hex_str[0 : 1] != '0x' ? '0x' : '') .. hex_str .. ', "d")')
  else
    return printf('%u', (hex_str[0 : 1] != '0x' ? '0x' : '') .. hex_str)
  endif
enddef


var now_disp = false

# Unified CRのために、結果を返す。
export def NumberDisplay(str: string): bool
  const ana = AnalizeNumberString(str)

  const dig = len(ana.numstr)

  const base = ana.base

  if base == 16
    const dec = ana.numstr -> Hex2Dec()
    const bin = ana.numstr -> Hex2Bin_Disp()
    const byt = (len(ana.numstr) / 2.0) -> ceil() -> float2nr()
    const bit = substitute(bin, '^[ o]\+\| ', '', 'g') -> len()

    echo ' [Dec]' dec '    [Bin]' bin '' (winwidth(0) > 100 ? '    ' : '\n') '[Byt]' byt '    [Bit]' bit '    [Dig]' dig

    now_disp = true

  elseif base == 10
    const hex = ana.numstr -> Dec2Hex()
    const bin = hex -> Hex2Bin_Disp()
    const byt = (len(hex) / 2.0) -> ceil() -> float2nr()
    const bit = substitute(bin, '^[ o]\+\| ', '', 'g') -> len()

    echo ' [Hex] 0x' .. hex '    [Bin]' bin  '' (winwidth(0) > 100 ? '    ' : '\n') '[byt]' byt '    [Bit]' bit '    [Dig]' dig

    now_disp = true

  elseif base == 2
    const hex = ana.numstr -> Bin2Hex()
    const dec = hex -> Hex2Dec()
    const byt = (len(ana.numstr) / 8.0) -> ceil() -> float2nr()
    const bit = substitute(ana.numstr, '^0\+', '', '') -> len()

    echo ' [Hex] 0x' .. hex '    [Dec] ' dec '    [byt]' byt '    [Bit]' bit '    [Dig]' dig

    now_disp = true

  elseif now_disp
    echo ''

    now_disp = false
  endif

  return now_disp  # for Unified CR
enddef

# com! TestNumberDisplay NumberDisplay(expand("<cword>"))
# TestNumberDisplay


export def OnNumber(str: string = expand("<cword>")): bool
  return AnalizeNumberString(str).base != 0
enddef

# com! TestOnNumberCur echo OnNumber()
# TestOnNumberCur



#----------------------------------------------------------------------------------------
# AutoCommand
#----------------------------------------------------------------------------------------

export enum AUTO_MODE
  NONE,
  CLINE,
  POPUP,
endenum

# g:NumbersAuto = false
var NumbersAuto = AUTO_MODE.NONE

export def NumbersAutoToggle(auto_mode: AUTO_MODE)
  if NumbersAuto == AUTO_MODE.NONE
    NumbersAuto = auto_mode
  else
    NumbersAuto = AUTO_MODE.NONE
  endif

  augroup Numbers_Auto
    au!

    if NumbersAuto == AUTO_MODE.CLINE
      au CursorMoved,VimResized * NumberDisplay(expand("<cword>"))
    elseif NumbersAuto == AUTO_MODE.POPUP
      au CursorMoved,VimResized * NumberDisplayPopup(expand("<cword>"))
    endif

    # if NumbersAuto != AUTO_MODE.POPUP
    #   popup_close(PopWinId)
    # endif
  augroup end
enddef



#----------------------------------------------------------------------------------------
# PopUp
#----------------------------------------------------------------------------------------


#--------------------------------------------
# Highlight

def PopUpHighlight()
  #hi NumbersHl	guifg=#d0bfb8	guibg=black	gui=NONE
  #hi NumbersHl	guifg=#cf302d	guibg=black	gui=NONE
  #hi NumbersHl	guifg=#85b0df	guibg=black	gui=NONE
  #hi NumbersHl	guifg=#d7d0c7	guibg=black	gui=NONE
  hi NumbersHl	guifg=#cc9988	guibg=black	gui=NONE
enddef

PopUpHighlight()

augroup Numbers_Highlight
  au!
  au Colorscheme * PopUpHighlight()
augroup end


#--------------------------------------------
# PopUp

var PopWinId = 0

# PopUpで、数字情報を表示する。
export def NumberDisplayPopup(str: string = expand("<cword>"), time: number = 4000): bool
  #-------------------------------------------
  # Analize

  # if !search('\%#\w', 'bcn')
  #   return
  # endif

  const ana = AnalizeNumberString(str)

  const dig = len(ana.numstr)

  var hex = ''
  var dec = ''
  var bin = ''
  var byt: number
  var bit: number

  const base = ana.base

  if base == 16
    hex = ana.numstr
    dec = ana.numstr -> Hex2Dec() -> DecimalComma()
    # dec = dec .. ' ' .. (dec->DecimalComma())
    bin = ana.numstr -> Hex2Bin_Disp()
    byt = (len(ana.numstr) / 2.0) -> ceil() -> float2nr()
    bit = bin -> substitute('^[ o]\+\| ', '', 'g') -> len()

    now_disp = true

  elseif base == 10
    hex = Dec2Hex(ana.numstr)
    dec = ana.numstr -> DecimalComma()
    # dec = dec .. ' ' .. (dec->DecimalComma())
    bin = hex -> Hex2Bin_Disp()
    byt = (len(hex) / 2.0) -> ceil() -> float2nr()
    bit = bin -> substitute('^[ o]\+\| ', '', 'g') -> len()

    now_disp = true

  elseif base == 2
    hex = ana.numstr -> Bin2Hex()
    dec = hex -> Hex2Dec() -> DecimalComma()
    # dec = dec .. ' ' .. (dec->DecimalComma())
    bin = ana.numstr
    byt = (len(ana.numstr) / 8.0) -> ceil() -> float2nr()
    bit = ana.numstr -> substitute('^0\+', '', '') -> len()

    now_disp = true

  elseif now_disp
    now_disp = false
  endif

  # popup_close(PopWinId)

  if now_disp
    #-------------------------------------------
    # Make Contents

    var lines:    list<string>       = []
    var mask:     list<list<number>> = []
    var num_line: number             = 1

    if true || base !=  2 | MakePopupContents(' [Bin] '   .. bin, lines, mask, num_line) | num_line += 1 | endif
    if true || base != 10 | MakePopupContents(' [Dec] '   .. dec, lines, mask, num_line) | num_line += 1 | endif
    if true || base != 16 | MakePopupContents(' [Hex] 0x' .. hex, lines, mask, num_line) | num_line += 1 | endif
                            MakePopupContents(' [Byt] '   .. byt, lines, mask, num_line) | num_line += 1
                            MakePopupContents(' [Bit] '   .. bit, lines, mask, num_line) | num_line += 1
                            MakePopupContents(' [Len] '   .. dig, lines, mask, num_line) | num_line += 1

    #-------------------------------------------
    # Show PopUp Window

    PopWinId = popup_create(lines, {
             #line: 'cursor+2',
              line: 'cursor+3',
              col: 'cursor',
              flip: true,
              moved: 'any',
              minwidth: 0,
              time: time,
              tabpage: 0,
              wrap: false,
              zindex: 200,
              drag: 1,
              highlight: 'NumbersHl',
              close: 'click',
              padding: [0, 0, 0, 0],
             #mask: mask,
              border: [],
              borderchars: ['─', '│', '─', '│', '┌', '┐', '┘', '└'],
             #mask: [[1, 1, 1, 1], [-1, -1, 1, 1], [1, 1, -1, -1], [-1, -1, -1, -1]]
          })
  endif

  return now_disp  # for Unified CR
enddef

def MakePopupContents(line: string, lines: list<string>, mask: list<list<number>>, num_line: number)
    lines -> add(line)
    mask  -> add([strdisplaywidth(line) + 2, -1, num_line, num_line])
enddef


# 数字情報のPopUpをクローズする。
export def NumberDisplayPopupClose()
  popup_close(PopWinId)
enddef


augroup EscEscSearch
  au!
  au User EscEsc NumberDisplayPopupClose()
augroup end



#----------------------------------------------------------------------------------------
# Format Change (Base Change)
#----------------------------------------------------------------------------------------

export enum PREFIX
  NONE,
  AUTO,
  MUST,
endenum

# 基数変換した文字列をクリップボードへコピーする。
export def BaseChange(
    to:      number,                      # 変換後基数
    arg_str: string = expand("<cword>"),  # 変換対象文字列
    from:    number = 0,                  # 変換元基数
    sep:     string = '',                 # 桁区切り文字(カンマやアンダースコアなど) (空文字なら、桁区切りの挿入なし。)
    sep_dig: number = 4,                  # 桁区切り文字を何文字ごとに挿入するか
    zero_pad: bool = false,               # 先頭のゼロパディングを実施するか否か
    prefix:  PREFIX = PREFIX.AUTO,        # 接頭辞(0xや0b)を付加するか
  ): string

  const str = (arg_str == '' ? expand("<cword>") : arg_str)

  const ana = AnalizeNumberString(str)

  const base = from == 0 ? ana.base : from

  var hex: string
  var dec: string
  var bin: string

  if base == 16
    hex = ana.numstr
    dec = ana.numstr -> Hex2Dec()
    bin = ana.numstr -> Hex2Bin()

  elseif base == 10
    hex = ana.numstr -> Dec2Hex()
    dec = ana.numstr
    bin = hex        -> Hex2Bin()

  elseif base == 2
    hex = ana.numstr -> Bin2Hex()
    dec = hex        -> Hex2Dec()
    bin = ana.numstr

  else
    return ''
  endif


  var pfx_str = ''
  var pad_str = ''  # TODO
  var num_str = ''

  if to == 16
    pfx_str = '0x'
    num_str = hex

  elseif to == 10
    num_str = dec

  elseif to == 2
    pfx_str = '0b'
    num_str = bin

  endif

  if (prefix == PREFIX.MUST) || ((prefix == PREFIX.AUTO) && (match(str, '^0[box]') != -1))
  else
    pfx_str = ''
  endif

  if sep != ''
    num_str = num_str -> InsertSeparator(sep, sep_dig)
  endif

  const result = pfx_str .. pad_str .. num_str

  @* = result

  echo 'Format Change:  [' str ']  =>  [' result ']'
  return result
enddef

# com! TestB2H BaseChange(16)
# TestB2H



#---------------------------------------------------------------------------------------------
# Test

# 0xaf45 0xf0 0b011100 0716 1234 65535 0xfdb97531 0xfdb97531ff 256 0b111111110000000011010000  0101111
# 0xaf45UL 0xf0ll 0b011100 0716 1234 65536 0xfdb97531 256a 0b111111110000000011010000  0101111
# 98,67878,2345 0b01011111000000001101_0000 0xffffffffffffffff 0xffffffffffffffffffffffffffffffff
# 0b11 993692464862809801080805478547854754953675 3 165535 18446744073709551606
