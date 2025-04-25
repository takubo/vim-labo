"set encoding=utf-8
vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8


#=============================================================================================
# Options
# Setting
# Utilities
# Plugins
#=============================================================================================


#---------------------------------------------------------------------------------------------
# Directories

if !isdirectory($HOME .. "/vim_buckup")
  mkdir($HOME .. "/vim_buckup")
endif

if !isdirectory($HOME .. "/vim_swap")
  mkdir($HOME .. "/vim_swap")
endif


#---------------------------------------------------------------------------------------------
# Leader

legacy let mapleader = "\<Space>"

# Leader(Space)の空打ちで、カーソルが一つ進むのが鬱陶しいので。
nnoremap <Leader> <Nop>


#---------------------------------------------------------------------------------------------
# Eatchar

def Eatchar(pattern: string): string
  const c = nr2char(getchar(0))
  return (c =~ pattern) ? '' : c
enddef
#例 iabbr <silent> if if ()<Left><C-R>=Eatchar('\s')<CR>

#def EatSpace(): string
def EatS(): string
  const c = nr2char(getchar(0))
  return (c =~ '\s') ? '' : c
enddef


#---------------------------------------------------------------------------------------------
# CursorJumped

com! -bar -nargs=0 CursorJumped CFIPopupAuto


colorscheme rimpa
