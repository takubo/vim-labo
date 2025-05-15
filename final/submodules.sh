#!/bin/sh

#    1 doc-ja
#    2 submode
#    3 cfi
#    4 clever_f
#    5 Fugitive
#    6 CamelCaseMotion
#    7 MRU
#    8 BlockDiff
#    9 PrettyPrint
#   10 undotree
#   11 Rainbow Parentheses
#   12 ComfortableMotion
#   13 Surround
#   14 snippets
#   15 Easy Buffer
#   16 Tagbar

#	doc vim-jp/vimdoc-ja.git
#	ini takubo/vim-submode.git
#	ref takubo/current-func-info.vim.git
#	def rhysd/clever-f.vim.git
#	def tpope/vim-fugitive.git
#	def bkad/CamelCaseMotion.git
#	def takubo/mru.vim.git
#	def takubo/BlockDiff.git
#	dev thinca/vim-prettyprint.git
#	def takubo/undotree.git
#	ext takubo/comfortable-motion.vim.git
#	ext kien/rainbow_parentheses.vim.git
#	#def snippets
#	#def EasyBuffer
#	#def Surround
#	#def Tagbar

#	#std Tabubo/BlockMove
#	#std Tabubo/Battery
#	#std Tabubo/Numbers
#	#std Tabubo/CursorJumped
#	#std Tabubo/CAX Axes



#	dev     vim-jp/vimdoc-ja.git
#	dev     thinca/vim-prettyprint.git
#	std     takubo/vim-submode.git
#	std     takubo/current-func-info.vim.git
#	std     rhysd/clever-f.vim.git
#	std     tpope/vim-fugitive.git
#	std     bkad/CamelCaseMotion.git
#	std     takubo/mru.vim.git
#
#	ext     takubo/undotree.git
#	ext     kien/rainbow_parentheses.vim.git
#
#	try     takubo/comfortable-motion.vim.git
#        # try   X troydm/easybuffer.vim
#	# try     snippets
#	# try     Surround
#	# try     Tagbar
#
#	myp     takubo/BlockDiff.git
#	# myp     tabubo/Battery
#	# myp     tabubo/CursorJumped
#	# myp     tabubo/EdgeMove BlockMove
#	# myp     tabubo/Numbers
#	# myp     tabubo/Axes


cd `git rev-parse --show-toplevel` || exit 1

cd ./pack

cat <<- 'EOF' | sed '/^\s*#/d; /^$/d' | cat > submodules
	# def/start    tabubo/Battery
	# def/start    tabubo/CursorJumped
	# def/start    tabubo/EdgeMove BlockMove
	# def/start    tabubo/Numbers
	# def/start    tabubo/Axes

	reg/start    vim-jp/vimdoc-ja
	reg/start    takubo/vim-submode
	reg/start    takubo/current-func-info.vim
	reg/start    rhysd/clever-f.vim
	reg/start    tpope/vim-fugitive
	reg/start    bkad/CamelCaseMotion
	reg/start    takubo/mru.vim
	reg/start    takubo/BlockDiff

	ext/start    thinca/vim-prettyprint
	ext/start    takubo/undotree
	ext/start    kien/rainbow_parentheses.vim

	# try/opt    takubo/comfortable-motion.vim
  # try/opt  X troydm/easybuffer.vim
	# try/opt    snippets
	# try/opt    Surround
	# try/opt    Tagbar
EOF

GitSubmodeAdd() { # Git Submodule Add
  if [ $# -ne 2 ]; then
    echo 'Git Submode Add Error: ' "$@"
    return
  fi

  pack_dir="$1"
  repo_path="$2"
  repo_name="${repo_path##*/}"
  tgt_dir="${pack_dir}/start/${repo_name}"

  if [ ! -d "${tgt_dir}" ]; then
    git submodule add "https://github.com/${repo_path}.git" "${tgt_dir}"
  fi
}

cat submodules | awk '{ print $1"/start" }' | xargs mkdir -p

cat submodules | while read line; do
  GitSubmodeAdd $line
done

git submodule update --remote


#cat submodules | awk '{ system("GSA " $1 " " $2) }'
#cat submodules | xargs -n 2 GSA
#cat submodules | xargs -n 2 echo GSA | sh
#cat submodules | xargs -n 2 eval GSA
#cat submodules | awk '{ print "GSA " $1 " " $2 }'

#cat submodules | awk '{
#print "GSA " $1 " " $2
#  echo git submodule add https://github.com/"$1" pack/"$2"/
#}'

#IFS='\n'
#for line in `cat submodules`
#do
#  echo $line
#done

# git submodule add 

# doc
# ref
# ini
# def, std
# dev
# ext
# div, std

update_all() {
  git submodule update --remote foo/
}
