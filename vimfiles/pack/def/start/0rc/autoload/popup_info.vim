vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8


# TODO
#   add API
#   pu win id list


#----------------------------------------------------------------------------------------
# Highlight

def PopUpInfoHighlight()
  hi PopUpInfo	guifg=#d7d0c7	guibg=NONE	gui=NONE	ctermfg=102	ctermbg=NONE	cterm=NONE
enddef

augroup PopUpInfoHighlight
  au!
  au Colorscheme * PopUpInfoHighlight()
augroup end

PopUpInfoHighlight()


#----------------------------------------------------------------------------------------
# Command

com! -nargs=* PopUpInfo call PopUpInfo(<q-args>, 5000)
com! -nargs=* PopUpInfo call PopUpInfo(<q-args>, 2500)


#----------------------------------------------------------------------------------------
# EscEsc

augroup EscEscPopupInfo
  au!
  au User EscEsc PopUpInfo_Close()
augroup end


#----------------------------------------------------------------------------------------
# API

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

# TODO
export def PopUpInfo_NMV(cont: string, time: number = 2500, line_off: number = 5, col_off: number = 5)
  PopUpInfo_Close()
  PopUpInfo_Internal([cont], time, line_off, col_off, 'topleft', [0, 0, 0])
enddef


#----------------------------------------------------------------------------------------
# Inner Data

var PopUpWindowId = []


#----------------------------------------------------------------------------------------
# Inner Function

def PopUpInfo_Close()
  if !empty(PopUpWindowId)
    PopUpWindowId -> foreach((_, id) => popup_close(id))
    PopUpWindowId = []
  endif
enddef

#def PopUpInfo_Internal(cont: list<string>, time: number = 2500, line_off: number = 5, col_off: number = 5, pos: string = 'topleft') # center: bool = false)
def PopUpInfo_Internal(cont: list<string>, time: number = 2500, line_off: number = 5, col_off: number = 5, pos: string = 'topleft', moved: any = 'any') # center: bool = false)
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
      'highlight':          'PopUpInfo',

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
      'moved':              moved,
      #'mousemoved':         ,
      #'cursorline':         ,
      #'filter':             ,
      #'mapping':            ,
      #'filtermode':         ,
      #'callback':           ,
    }
  ))
enddef
