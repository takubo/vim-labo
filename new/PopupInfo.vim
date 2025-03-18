vim9script

# TODO
#   add API
#   pu win id list
#   EscEsc
#


hi Mode		guifg=#cf302d	guibg=#282828	gui=none	ctermfg=159
hi Mode		guifg=#eeeeee	guibg=#282828	gui=none	ctermfg=159
hi Mode		guifg=#878787	guibg=NONE	gui=NONE	ctermfg=102	ctermbg=NONE	cterm=NONE
hi Mode		guifg=#C7C7C7	guibg=NONE	gui=NONE	ctermfg=102	ctermbg=NONE	cterm=NONE
hi Mode      	guifg=#d0c589	guibg=#282828
hi Mode		guifg=#d7d0c7	guibg=NONE	gui=NONE	ctermfg=102	ctermbg=NONE	cterm=NONE


var PopUpWindowId = []


# Arg
      # line
      # col
      # highlight
      # zindex
      # time

#export def PopUpInfo(cont: string, time: number = 2500, line_off: number = 2, col_off: number = 2)
export def PopUpInfo(cont: string, time: number = 2500, line_off: number = 5, col_off: number = 5)
  PopUpInfoM([cont], time, line_off, col_off)
enddef

# 関数名末尾のCは、CenterのC.
export def PopUpInfoMC(cont: list<string>, time: number = 2500, line_off: number = 5, col_off: number = 5, pos: string = 'center') # center: bool = false)
  PopUpInfoM(cont, time, line_off, col_off, pos)
enddef

export def PopUpInfoC(cont: string, time: number = 2500, line_off: number = 5, col_off: number = 5, pos: string = 'center') # center: bool = false)
  PopUpInfoM([cont], time, line_off, col_off, pos)
enddef

# 関数名末尾のMは、Multi lineのM.
export def PopUpInfoM(cont: list<string>, time: number = 2500, line_off: number = 5, col_off: number = 5, pos: string = 'topleft') # center: bool = false)
  PopUpInfo_Close()
  PopUpInfo_Internal(cont, time, line_off, col_off, pos)
enddef

# 関数名末尾のAは、AddのA.
export def PopUpInfoA(cont: string, time: number = 2500, line_off: number = 5, col_off: number = 5, pos: string = 'topleft')
  PopUpInfo_Internal([cont], time, line_off, col_off, pos)
enddef

def PopUpInfo_Close()
  if !empty(PopUpWindowId)
    PopUpWindowId -> map((_, id) => popup_close(id))
    PopUpWindowId = []
  endif
enddef

def PopUpInfo_Internal(cont: list<string>, time: number = 2500, line_off: number = 5, col_off: number = 5, pos: string = 'topleft') # center: bool = false)
  add(PopUpWindowId, popup_create(cont, {
      #'line':               'cursor+3',
      #'line':               'cursor+2',
      'line':               'cursor' .. (line_off >= 0 ? '+' : '') .. printf('%d', line_off),
      # TODO 最下行付近のとき、カーソルに掛かる。
      #'col':                'cursor+2',
      'col':                'cursor' .. (col_off >= 0 ? '+' : '') .. printf('%d', col_off),
      #'line':               'cursor+2',
      #'col':                'cursor+2',
      'pos':                pos,
      #'posinvert':          ,
      #'textprop':           ,
      #'textpropwin':        ,
      #'textpropid':         ,
      #'fixed':              ,
      #'flip':               ,
      #'maxheight':          ,
      #'minheight':          ,
      #'maxwidth':           ,
      #'minwidth':           ,
      #'firstline':          ,
      #'hidden':             ,
      #'tabpage':            ,
      #'title':              ,
      'wrap':               false,
      #'drag':               ,
      #'dragall':            ,
      #'resize':             ,
      #'close':              ,
      'highlight':          'Mode', #'SLFilename', 'Pmenu', 'Mode', 'Special', 'String',

      #'padding':            [1, 2, 1, 3],

      #'padding':            [1, 3, 1, 3],

      'padding':            [0, 2, 0, 3],
      'border':             [],

      #'borderhighlight':    ,
      'borderchars':        ['─', '│', '─', '│', '┌', '┐', '┘', '└'],
      #'scrollbar':          ,
      #'scrollbarhighlight': ,
      #'thumbhighlight':     ,
      'zindex':             1000,
      #'mask':               ,
      'time':               time,
      'moved':              'any',
      #'mousemoved':         ,
      #'cursorline':         ,
      #'filter':             ,
      #'mapping':            ,
      #'filtermode':         ,
      #'callback':           ,
    }
  ))
enddef

com! -nargs=* PopUpInfo call PopUpInfo(<q-args>, 5000)

augroup EscEscPopupInfo
  au!
  au User EscEsc PopUpInfo_Close()
augroup end
