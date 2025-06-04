#!/bin/sh

git rev-parse --show-toplevel || exit

cd `git rev-parse --show-toplevel`

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
	reg/start    troydm/easybuffer.vim

	try/start    thinca/vim-prettyprint
	try/start    takubo/undotree
	try/start    kien/rainbow_parentheses.vim

	# try/opt    takubo/comfortable-motion.vim
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
