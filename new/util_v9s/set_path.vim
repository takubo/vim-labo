vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8

#=============================================================================================
# SetPath.vim
#=============================================================================================


#set path+=./**
#set path+=;

set wildignore+=**/.git/**
set wildignore+=**/.svn/**


var PrjRootFile = '.git'
PrjRootFile = '.gitignore'

const MaxParent = 20


# {
# BufReadのタイミングでは、カレントディレクトリが当該バッファに変わってないのだが、
# set autochdirすることで、なぜかカレントディレクトリが変わるので、この処理を行っている。
# saveなどすると、なぜか上手くいかない。。。
#let save_autochdir = &autochdir
#set autochdir
#let &autochdir = save_autochdir
# }


def GetPrjRoot(): string
  var prj_root: string

  prj_root = finddir(PrjRootFile, '.;')
  if prj_root != ''
    return prj_root -> fnamemodify(':h:p')
  endif

  prj_root = findfile(PrjRootFile, '.;')
  return prj_root -> fnamemodify(':h:p')
enddef

 # TODO スペースをエスケープ
 # TODO コンマをエスケープ
def GetPrjRootPath(): string
  const prj_root = GetPrjRoot() -> substitute('.\zs/$', '', '')  # root dirを除外するため'/'の前に1文字以上必要。

  return prj_root == '' ?  '' : (prj_root .. '/**' .. ',')
 #return prj_root == '' ?  '' : (',' .. prj_root .. '/**')
enddef

def GetIncludePath(): string
  return ''
enddef


com! -bang -bar -nargs=0 SetPath {
      if '<bang>' == '!'
        setl path&
      endif
      &l:path ..= (&l:path[-1] != ',' ? ',' : '') .. GetPrjRootPath() .. GetIncludePath()
      echo &l:path
    }

com! -bang -bar -nargs=0 ResetPath SetpathSilent<bang> | echo &l:path

com! -bang -bar -nargs=0 SetpathForce ResetPath<bang>


augroup SetPath
  au!
 #au BufRead,BufNew
 # TODO ChDir
  au BufReadPost,BufNewFile * silent SetPath!
augroup end
