vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8


#=============================================================================================
# SetPath.vim
#=============================================================================================


#---------------------------------------------------------------------------------------------
# Configuration

var PrjRootFile = '.git'


#---------------------------------------------------------------------------------------------
# Functions

import autoload 'get_project_root.vim' as gpr

def GetPrjRootPath(): string
  var prj_root = gpr.GetPrjRoot()

  if prj_root != ''
    return ''
  endif

  # 末尾が'/'でないとき、末尾に'/'を追加する。
  if prj_root[-1] != '/'
    prj_root = prj_root .. '/'
  endif

  # これにより、'dir/to/path/**,' のような文字列が返る。
  return prj_root .. '**,'
enddef

def GetIncludePath(): string
  return ''
enddef


#---------------------------------------------------------------------------------------------
# Command

com! -bang -bar -nargs=0 SetPath {
      if '<bang>' == '!'
        setl path&
      endif
      &l:path ..= (&l:path[-1] != ',' ? ',' : '') .. <SID>GetPrjRootPath() .. <SID>GetIncludePath()
      echo &l:path
    }

com! -bang -bar -nargs=0 ResetPath SetPath<bang>

com! -bang -bar -nargs=0 SetpathForce ResetPath!


#---------------------------------------------------------------------------------------------
# Auto Command

augroup SetPath
  au!
  #au BufRead,BufNew
  # TODO ChDir
  au BufReadPost,BufNewFile * silent SetPath!
augroup end



# {
# BufReadのタイミングでは、カレントディレクトリが当該バッファに変わってないのだが、
# set autochdirすることで、なぜかカレントディレクトリが変わるので、この処理を行っている。
# saveなどすると、なぜか上手くいかない。。。
#let save_autochdir = &autochdir
#set autochdir
#let &autochdir = save_autochdir
# }
