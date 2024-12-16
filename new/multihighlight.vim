vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 expandtab
scriptencoding utf-8


#----------------------------------------------------------------------------------------
# Initialization

def Init()
  ColorInit()

  augroup MultiHighLightColor
    au!
    au ColorScheme * ColorInit()
  augroup end

  InitVars()
enddef


#----------------------------------------------------------------------------------------
# Color

const Colors = [
  [ 'red',      'white' ],  #  1
  [ 'yellow',   'black' ],  #  2
  [ 'magenta',  'white' ],  #  4
  [ 'cyan',     'black' ],  #  6
  [ '#88ee22',  'black' ],  # 11
  [ 'blue',     'white' ],  #  3
# [ 'green',    'black' ],  #  5
  [ '#ee8822',  'black' ],  #  7
  [ '#22ee88',  'black' ],  #  8
# [ '#8822ee',  'black' ],  #  9
  [ '#ee2288',  'black' ],  # 10
  [ '#2288ee',  'black' ],  # 12
  [ '#cdc673',  'black' ]   #  khaki
# [ '#ff8000',  'black' ],  #   
]

const HighlightNum = len(Colors)

def ColorInit()
  mapnew(Colors,
    '{ name: "MultiHighLight" .. v:key, ' ..
    '  guifg: Colors[v:key][1],   ' ..
    '  guibg: Colors[v:key][0],   ' ..
    '  fg:    Colors[v:key][1],   ' ..
    '  bg:    Colors[v:key][0],   ' ..
    '}                                  '
  )
  -> hlset()
enddef


#----------------------------------------------------------------------------------------
# Data Strucure

# 次に使うべきMultiHighLightNのNを保持する。
var HighlightCur: number
# TODO var HighlightIndex: number

# ハイライト対象文字列と、highlight設定の組を保持する。
var HighlightInfo: list<dict<string>>
#
# For Example:
#
#    HighlightInfo = [
#      { 'pattern': 'Foo', 'HighlightName': 'MultiHighLight0'},
#      { 'pattern': 'bar', 'HighlightName': 'MultiHighLight1'},
#      { 'pattern': 'BAZ', 'HighlightName': 'MultiHighLight2'},
#    ]
#

# Window IDをキーにして、Match IDのリストを保持する。
var MatchId: dict<list<number>>

var Suspending: bool


def InitVars()
  HighlightCur = 0
  # TODO HighlightIndex = 0

  HighlightInfo = []

  MatchId = {}

  Suspending = false
enddef


#----------------------------------------------------------------------------------------
# Entry Point

export def New(pattern: string)
  Reset()
  Add(pattern)
enddef

export def Reset()
  Suspend()

  InitVars()
enddef

export def Add(pattern: string)
  if Suspending
    Reset()
    # Resume()
    # InitVars()
  endif

  const hl_name = 'MultiHighLight' .. HighlightCur

  HighlightCur = (HighlightCur + 1) % HighlightNum

  HighlightInfo = add(HighlightInfo, {'pattern': pattern, 'HighlightName': hl_name})

  def ExeHighlight(key_unused: number, win_id: number)
    const match_id = matchadd(hl_name, pattern, 10, -1, {'window': win_id})
    # add(MatchId[win_id], match_id)
    MatchId[win_id] = get(MatchId, win_id, [])->extend([match_id])
  enddef

  GetAllWinIdList()->mapnew(ExeHighlight)

  SetAutoCmd()
enddef

export def Suspend()
  if Suspending
    return
  endif

  Suspending = true

  def MatchDelete(win_id: string, match_id: list<number>): number
    if win_id2tabwin(str2nr(win_id))[0] != 0
      match_id->mapnew('matchdelete(v:val, ' .. win_id .. ')')
    endif
    return 0
  enddef

  MatchId->mapnew(MatchDelete)

  # TODO 要素削除の要あり。
  MatchId = {}

  CancelAutoCmd()
enddef

export def Resume()
  if !Suspending
    return
  endif

  def ExeHighlight(key_unused: number, win_id: number)

    def MatchAdd(key_unused2: number, info: dict<string>)
      const hl_name = info.HighlightName
      const pattern = info.pattern

      const match_id = matchadd(hl_name, pattern, 10, -1, {'window': win_id})
      # add(MatchId[win_id], match_id)
      MatchId[win_id] = get(MatchId, win_id, [])->extend([match_id])
    enddef

    HighlightInfo->mapnew(MatchAdd)
  enddef

  GetAllWinIdList()->mapnew(ExeHighlight)

  SetAutoCmd()

  Suspending = false
enddef


#----------------------------------------------------------------------------------------
# Auto Command

def SetAutoCmd()
  augroup MultiHighLight
    au!
    au WinNew * AutoCmd_WinNew()
    # au WinClosed * remove(MatchId, win_getid())
  augroup end
enddef

def CancelAutoCmd()
  augroup MultiHighLight
    au!
  augroup end
enddef

def AutoCmd_WinNew()
  const win_id = win_getid()

  def ExeHighlight(key_unused: number, highlight_info: dict<string>)
    const hl_name = highlight_info.HighlightName
    const pattern = highlight_info.pattern

    const match_id = matchadd(hl_name, pattern, 10, -1, {'window': win_id})

    MatchId[win_id] = get(MatchId, win_id, [])->extend([match_id])
  enddef

  HighlightInfo->mapnew(ExeHighlight)
enddef

#----------------------------------------------------------------------------------------
# Utilities

def GetAllWinIdList(): list<number>
  #echo tabpagenr('$')->range()->map('v:val + 1') -> map('[v:val, tabpagewinnr(v:val, "$")]') #->map('win_getid(v:val[1], v:val[0])')
  #echo tabpagenr('$')->range()->map('v:val + 1') -> map('[v:val, tabpagewinnr(v:val, "$")]') -> map('range(1, v:val[1])') #->map('map(win_getid(v:val, ' .. v:key .. ')')


  #? const tabnr_list = tabpagenr('$')->range()->map('v:val + 1')
  #? #echo tabnr_list

  #? const tab_wins_list = tabnr_list->mapnew('[v:val, tabpagewinnr(v:val, "$")]')
  #? #echo tab_wins_list

  #? const tab_winnr_list = tab_wins_list->mapnew('range(1, v:val[1])')
  #? #echo tab_winnr_list

  #? const tabnr_mult_list = tab_wins_list->mapnew('repeat([v:val[0]], v:val[1])')
  #? #echo tabnr_mult_list

  #? const tab_winnr_flat_list = flattennew(tab_winnr_list)
  #? #echo tab_winnr_flat_list

  #? const tabnr_mult_flat_list = flattennew(tabnr_mult_list)
  #? #echo tabnr_mult_flat_list

  #? #const all_win_id = tab_winnr_flat_list->mapnew('win_getid(v:val, tabnr_mult_flat_list[v:key])')
  #? #echo all_win_id


  #echo tabpagenr('$')->range()->map('v:val + 1') -> map('[v:val, tabpagewinnr(v:val, "$")]') -> map('[range(1, v:val[1]), repeat([v:val[0]], v:val[1])]')


  def Sub(key: number, val: list<number>): list<number>
    return val->map('win_getid(v:val, ' .. (key + 1) .. ')')
  enddef
  const all_win_id = tabpagenr('$')->range()->map('v:val + 1') -> map('[v:val, tabpagewinnr(v:val, "$")]') -> map('range(1, v:val[1])') -> map(Sub) -> flattennew()

  return all_win_id
enddef

#echo GetAllWinIdList()

#highlight Test guifg=white guibg=red

#var highlights1 = ( GetAllWinIdList()->mapnew("[v:val, matchadd('Test', 'call', 10, -1, {'window': v:val})]") )
#var highlights2 = ( GetAllWinIdList()->mapnew("[v:val, matchadd('Test', 'For',  10, -1, {'window': v:val})]") )

#echo highlights1
#echo highlights2

#echo getmatches()

#call matchadd('Test', 'call', 10, -1, {'window': 1975})


#----------------------------------------------------------------------------------------
# Initialize

Init()


#----------------------------------------------------------------------------------------
# Command Definition

com! -nargs=1 -bang MHA call Add(<q-args>)
com! -nargs=0 -bang MHD call Suspend()
com! -nargs=0 -bang MHR call Resume()
com! -nargs=0 -bang MHZ call Reset()


finish


#----------------------------------------------------------------------------------------
# Highlight Color Test

Add('\<color_sample__1\>')

Add('\<color_sample__2\>')

Add('\<color_sample__3\>')

Add('\<color_sample__4\>')

Add('\<color_sample__5\>')

Add('\<color_sample__6\>')

Add('\<color_sample__7\>')

Add('\<color_sample__8\>')

Add('\<color_sample__9\>')

Add('\<color_sample_10\>')

Add('\<color_sample_11\>')

Add('\<color_sample_12\>')

Add('\<color_sample_13\>')

Add('\<color_sample_14\>')

Add('\<color_sample_15\>')

Add('\<color_sample_16\>')

Add('\<color_sample_17\>')


finish



 "#ff6622",
 "black",  

""#ff7766", 
""black",   

export def Add(pattern: string)
  const hl_name = 'MultiHighLight' .. HighlightCur

  ++HighlightCur

  HighlightInfo = add(HighlightInfo, {'pattern': pattern, 'HighlightName': hl_name})

  def ExeHighlight(key_unused: number, win_id: number)
    const match_id = matchadd(hl_name, pattern, 10, -1, {'window': win_id})
    # add(MatchId[win_id], match_id)
    MatchId[win_id] = get(MatchId, win_id, [])->extend([match_id])
  enddef

  GetAllWinIdList()->mapnew(ExeHighlight)

  SetAutoCmd()
enddef



#----------------------------------------------------------------------------------------
# Color

const BgColorSequence = [ "red",   "magenta", "yellow", "blue",  "cyan",  "green", "#ee8822", "#22ee88", "#8822ee", "#ee2288", "#2288ee" ]
const FgColorSequence = [ "white", "white",   "black",  "white", "black", "black", "black",   "black",   "black",   "black",   "black"   ]

const HighlightNum: number = len(BgColorSequence) - 1

def ColorInit()
  mapnew(BgColorSequence,
    '{ name: "MultiHighLight" .. v:key, ' ..
    '  guifg: FgColorSequence[v:key],   ' ..
    '  guibg: BgColorSequence[v:key],   ' ..
    '  fg:    FgColorSequence[v:key],   ' ..
    '  bg:    BgColorSequence[v:key],   ' ..
    '}                                  '
  )
  -> hlset()
enddef



#??  #def ExeAutoCmd_WinNew()
#??  def WinNew()
#??  enddef
#??  
#??  #def ExeAutoCmd_WinClosed()
#??  def WinClosed()
#??  enddef

#? # ハイライト文字列のLsit
#? var Patterns: list<string>

# リストの辞書

#----------------------------------------------------------------------------------------
# Doc



# API
#

1. Init()
2. # New()
3. Add()
4. Suspend()    冪等、いつでも
5. Resume()     冪等、いつでも
6. Reset()      冪等、いつでも

# 操作

*, g*           Add             New
#, g#           Add             New / Add
C_<CR>          Reset
<Esc><Esc>      Suspend
n, N            Resume


/, ?, g/, g?    Reset


# データ構造
#
#

class {
  pattern
  highlight
}

array[] = {
  .pattern
  .highlight
}[]

dictionary{win_id} = match_id[]




enum Status
  NoActive,
# First,
# FirstSuspending,
  Active,
  Suspending
endenum

  Init()
# New()
  Add()
  Suspend()
  Resume()
  Reset()




# Start -- { Init() } --> NoActive -- { New() } -->  First  -- { Add() } --> Active -- { Suspend() } --> Suspending

#                 Start
#                  ｜
#               { Init() }
#                  ↓
#     －－－－→ NoActive
#                  ｜
#                { New() }
#                  ｜
#                  ｜
#                  ｜
#                  ↓
#                 First       { Suspend() }                 FirstSuspending
#                  ｜
#               { Add() }
#                  ｜
#                  ｜
#                  ↓
#                Active
#                  ｜
#             { Suspend() }
#                  ↓
#               Suspending
#
