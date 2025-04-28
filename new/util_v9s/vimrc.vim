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
# Make Directories

def MkVimDir(path: string)
  const p = $HOME .. '/' .. path
  if !isdirectory(p)
    mkdir(p)
  endif
enddef

MkVimDir('vim_undo')
MkVimDir('vim_buckup')
MkVimDir('vim_swap')
MkVimDir('vim_view')


#---------------------------------------------------------------------------------------------
# Leader

legacy let mapleader = "\<Space>"

# Leader(Space)の空打ちで、カーソルが一つ進むのが鬱陶しいので。
nnoremap <Leader> <Nop>


#---------------------------------------------------------------------------------------------
# Options

# set nocompatible

#exe 'source' expand('<sfile>:p:h') .. '/options.vim'
exe $"source {expand('<sfile>:p:h')}/options.vim"


#---------------------------------------------------------------------------------------------
# Vimrc Default

filetype on

syntax enable

filetype plugin indent on


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
# Plugins


#---------------------------------------------------------------------------------------------
# CursorJumped

com! -bar -nargs=0 CursorJumped CFIPopupAuto


#---------------------------------------------------------------------------------------------
# Colorscheme

colorscheme rimpa
