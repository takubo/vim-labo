vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8


#----------------------------------------------------------------------------------------
# Highlight

def Hl()
  hi BatteryLvlFtl	guifg=#ff0000	guibg=#ff0000	gui=NONE	cterm=NONE
  hi BatteryLvlLow	guifg=#ff8800	guibg=#ff8800	gui=NONE	cterm=NONE
  hi BatteryLvlMid	guifg=#ffff00	guibg=#ffff00	gui=NONE	cterm=NONE
  hi BatteryLvlNrm	guifg=#00ff00	guibg=#00ff00	gui=NONE	cterm=NONE
  hi BatteryLvlNon	guifg=#000000	guibg=#000000	gui=NONE	cterm=NONE
 #hi BatteryLvlNon	guifg=#664400	guibg=#664400	gui=NONE	cterm=NONE
  hi BatteryLvlBrd	guifg=#222222	guibg=#222222	gui=NONE	cterm=NONE
  hi BatteryLvlBrd	guifg=#666666	guibg=#666666	gui=NONE	cterm=NONE

  hi BatteryLvlNon	guifg=#666666	guibg=#666666	gui=NONE	cterm=NONE
  hi BatteryLvlBrd	guifg=#000000	guibg=#000000	gui=NONE	cterm=NONE
enddef

augroup sp_hl
  au!
  au Colorscheme * Hl()
augroup end

Hl()


#----------------------------------------------------------------------------------------

def BatteryDemo(): float
  return rand() / pow(2, 32) * 100 / 100 * 4
enddef

g:BatDemoRem = 100
def BatteryRemaining(): number
  var rem = g:BatDemoRem

  if rem <= 0
    rem = 100
  else
    rem -= float2nr(BatteryDemo())
    if rem < 0
      rem = 0
    endif
  endif

  g:BatDemoRem = rem
  return rem
 #return 89
enddef

const GraphCellNum = 20
const GraphCellPerCent = 100 / GraphCellNum

export def Demo(): list<string>
  const remain_percent = BatteryRemaining()
  const remaining = remain_percent / GraphCellPerCent
  const consumed  = GraphCellNum - remaining

  const bat_hl =
    remain_percent <= 12 ? '%#BatteryLvlFtl#' :
    remain_percent <= 30 ? '%#BatteryLvlLow#' :
    remain_percent <= 45 ? '%#BatteryLvlMid#' : '%#BatteryLvlNrm#'

  const remaining_str = bat_hl .. repeat('!', remaining)
  const consumed_str  = '%#BatteryLvlNon#' .. repeat('!', consumed)

  # echo remaining_str consumed_str

  # 電池の出っ張り部分
  const bat_str_pro = '%#BatteryLvlBrd#@@' .. remaining_str .. consumed_str .. '%#BatteryLvlBrd#@@'
  # 電池の出っ張りでない部分
  const bat_str = (bat_str_pro -> substitute('!\ze[^!]*$', '', '')
                             # -> substitute('!\ze[^!]*$', '', '')
                  ) .. '%#BatteryLvlBrd#@@'

  # echo bat_str_pro bat_str
  const brd_str = '%#BatteryLvlBrd#' .. repeat('@', GraphCellNum + 2 * 2)

  const bat_draw = [ $'%#TabLine#        [ %3({remain_percent}%)%% ]',
                     brd_str,
                     bat_str,
                     bat_str_pro,
                     bat_str_pro,
                     bat_str,
                     brd_str,
                   ]
  # echo bat_draw
  # .. "\n" .. '@@@@@@@@@@@@@@@@@@@@@@@@'
  # .. "\n" .. '@@                  @@@@'
  # .. "\n" .. '@@                    @@'
  # .. "\n" .. '@@                    @@'
  # .. "\n" .. '@@                  @@@@'
  # .. "\n" .. '@@@@@@@@@@@@@@@@@@@@@@@@'

  return bat_draw
enddef
