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
# Environment Variables
#---------------------------------------------------------------------------------------------

#$VIMFILES = expand('<sfile>:p:h')
$VIMFILES = fnamemodify($MYVIMRC, ':p:h')


#---------------------------------------------------------------------------------------------
# Make Directories
#---------------------------------------------------------------------------------------------

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
#---------------------------------------------------------------------------------------------

legacy let mapleader = "\<Space>"

# Leader(Space)の空打ちで、カーソルが一つ進むのが鬱陶しいので。
nnoremap <Leader> <Nop>


#---------------------------------------------------------------------------------------------
# Options
#---------------------------------------------------------------------------------------------

# set nocompatible

#exe 'source' expand('<sfile>:p:h') .. '/options.vim'
exe $"source {expand('<sfile>:p:h')}/options.vim"
#exe $"source {$VIMFILES}/options.vim"


#---------------------------------------------------------------------------------------------
# Vimrc Default
#---------------------------------------------------------------------------------------------

syntax enable

filetype plugin indent on


#---------------------------------------------------------------------------------------------
# Timeoutlen
#---------------------------------------------------------------------------------------------

set timeoutlen=1100

augroup MyVimrc_Timeoutlen
  au!
  au InsertEnter * set timeoutlen=700
  au InsertLeave * set timeoutlen=1100
augroup end


#---------------------------------------------------------------------------------------------
# Colorscheme
#---------------------------------------------------------------------------------------------

#-------------------------------------------------
# Gold

g:RimpaGold = true

com! Gold {
  g:RimpaGold = !g:RimpaGold
  colorscheme rimpa
}

def g:IsGold(): bool
  return g:RimpaGold
enddef

nnoremap , <Cmd>Gold<CR><Cmd>redrawtabline<CR><Cmd>redrawstatus!<CR>

#-------------------------------------------------
# Dark

g:RimpaDark = true

com! Dark {
  g:RimpaDark = !g:RimpaDark
  colorscheme rimpa
}

nnoremap @ <Cmd>Dark<CR>

#-------------------------------------------------
# Colorscheme

colorscheme rimpa


#---------------------------------------------------------------------------------------------
# Invalidate
#---------------------------------------------------------------------------------------------

nnoremap <silent> ZZ <Nop>
nnoremap <silent> ZQ <Nop>

# IME状態の切り替えをさせない。
inoremap <C-^> <Nop>


#---------------------------------------------------------------------------------------------
# Swap_Exists
#---------------------------------------------------------------------------------------------

var swap_select = true

augroup MyVimrc_SwapExists
  au!
  au SwapExists * if !swap_select | v:swapchoice = 'o' | endif
augroup END

com! SwapSelect {
      swap_select = true
      edit %
      swap_select = false
    }


#---------------------------------------------------------------------------------------------
# QuickFix
#---------------------------------------------------------------------------------------------

augroup MyVimrc_QickFix
  au!
  # grepする際に'|cwindow'を付けなくても、Quickfixに結果を表示する
  au QuickfixCmdPost make,grep,grepadd,vimgrep,cbuffer,cfile exe 'botright cwindow ' .. (&lines / 4)
  au QuickfixCmdPost lmake,lgrep,lgrepadd,lvimgrep,lcbuffer,lcfile exe 'lwindow ' .. (winheight(0) / 4)
augroup end


#---------------------------------------------------------------------------------------------
# Eatchar
#---------------------------------------------------------------------------------------------

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

#-------------------------------------------------
# Xxx

#-------------------------------------------------
# Yyy

#-------------------------------------------------
# Zzz


#---------------------------------------------------------------------------------------------
# CursorJumped
#---------------------------------------------------------------------------------------------

com! -bar -nargs=0 CursorJumped CFIPopupAuto
