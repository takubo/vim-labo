#!/bin/zsh




######## Utilities ########

# 行頭
# パイプ後
# セミコロン後
# && または || 後
# { または ( 後
function is-head {
	str=$1
	case `echo -n ${str%%[ 	]*}` in
		# 空文字列の比較をしているのは、カーソルが行頭にあるときのため。
		'' | *\| | *\; | *'&&' | *'||' | *\{ | *\( )
			#echo H
			true
			;;
		* )
			#echo K
			false
			;;
	esac
}

function ms {
	ls_len="`ls -1 $@ | sed '
	$ {
		# プロンプトの分
		i0
		i0
		i0
		i0
	}
	' |  wc -l`"

	if [ ${ls_len} -le ${LINES} ] ; then
		# if [ -p /dev/stdout ] ; then
			# ls -hv --color=auto -1 "$@" | cat -n
		# else
			ls -hv --color=always -1 "$@" | cat -n
		# fi
	else
		ls -hv  --color=auto "$@"
	fi
}



######## Key (zkbd) ######## TODO

#autoload -Uz zkbd

#function zkbd_file() {
#    [[ -f ~/.zkbd/${TERM}-${VENDOR}-${OSTYPE} ]] && printf '%s' ~/".zkbd/${TERM}-${VENDOR}-${OSTYPE}" && return 0
#	[[ -f ~/.zkbd/${TERM}-${DISPLAY}          ]] && printf '%s' ~/".zkbd/${TERM}-${DISPLAY}"          && return 0
#	return 1
#}
#
#    [[ ! -d ~/.zkbd ]] && mkdir ~/.zkbd
#keyfile=$(zkbd_file)
#    ret=$?
#    if [[ ${ret} -ne 0 ]]; then
#    zkbd
#keyfile=$(zkbd_file)
#    ret=$?
#    fi
#    if [[ ${ret} -eq 0 ]] ; then
#    source "${keyfile}"
#    else
#    printf 'Failed to setup keys using zkbd.\n'
#    fi
#    unfunction zkbd_file; unset keyfile ret




######## Key (no zkbd) ########

# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -A key

case `uname` in
	*CYGWIN* )
		key[Home]="[H"
		;;
	* )
		key[Home]=${terminfo[khome]}
		key[End]=${terminfo[kend]}
		key[Insert]=${terminfo[kich1]}
		key[Delete]=${terminfo[kdch1]}
		key[Up]=${terminfo[kcuu1]}
		key[Down]=${terminfo[kcud1]}
		key[Left]=${terminfo[kcub1]}
		key[Right]=${terminfo[kcuf1]}
		key[PageUp]=${terminfo[kpp]}
		key[PageDown]=${terminfo[knp]}
		;;
esac




######## Prompt ########

# for c in {000..255}; do echo -n "\e[38;5;${c}m $c" ; [ $(($c%16)) -eq 15 ] && echo;done;echo
# TODO BG

case `uname` in
	*CYGWIN* )
		#autoload -Uz colors && colors
		#PROMPT="%B%U%{${fg[red]}%}[%j] %w %D{%H:%M} %n%u %U%{${fg[cyan]}%}%~%u%{${fg[red]}%}
#%%%{${reset_color}%} "
		PROMPT=$'%U\e[38;5;009m[%j] %w %D{%H:%M} \e[38;5;229m%n%u %U\e[38;5;103m%~%u\e[38;5;009m
%%%f '
		PROMPT=$'%U%{\e[30;48;5;025m%}\e[38;5;009m[%j] %w %D{%H:%M} \e[38;5;075m%n%u %U\e[38;5;103m%~%u\e[38;5;009m
%%%f '
		PROMPT=$'%U\e[38;5;009m[%j] %w %D{%H:%M} \e[38;5;075m%n%u %U\e[38;5;247m%~%u\e[38;5;009m
%%%f '
		PROMPT=$'%U\e[38;5;009m[%j] %w %D{%H:%M} \e[38;5;009m%n%u %U\e[38;5;075m%~%u\e[38;5;009m
%%%f '
		;;
	* )
		PROMPT="%U%{${fg[red]}%}[%j] %w %D{%H:%M}%u %U%{${fg[red]}%}%{${fg[magenta]}%}%n%u %U%{${fg[green]}%}%m%u %{${fg[cyan]}%}%~%{${fg[red]}%}
%%%{${reset_color}%} "
		PROMPT="%U%{${fg[red]}%}[%j] %w %D{%H:%M} %n%u %U%{${fg[cyan]}%}%~%u%{${fg[red]}%}
%%%{${reset_color}%} "
		PROMPT="%U%F{009}[%j] %w %D{%H:%M} %n%u %U%F{075}%~%u%F{009}
%%%f "
		;;
esac




######## PATH ######## TODO

PATH=~/bin:/cygdrive/c/Users/U351376/bin:$PATH




######## Completion ######## TODO

## 初期化
autoload -Uz compinit && compinit -C

## 補完侯補をメニューから選択する。
### select=2: 補完候補を一覧から選択する。
#zstyle ':completion:*:default' menu select
###           ただし、補完候補が3つ以上なければすぐに補完する。
zstyle ':completion:*:default' menu select=3
#zstyle ':completion:*:default' menu true

# Shift-Tabで補完候補を逆順する("\e[Z"でも動作する)
bindkey "^[[Z" reverse-menu-complete

## 補完候補に色を付ける。
### "": 空文字列はデフォルト値を使うという意味。
zstyle ':completion:*:default' list-colors ""
## 補完方法毎にグループ化する。
### 補完方法の表示方法
###   %B...%b: 「...」を太字にする。
###   %d: 補完方法のラベル
zstyle ':completion:*' format '%B%d%b'
zstyle ':completion:*' group-name ''
## 補完候補をキャッシュする。
zstyle ':completion:*' use-cache yes
## 詳細な情報を使う。
zstyle ':completion:*' verbose yes
## # カーソルの位置に補なうことで単語を完成させようとする。
setopt complete_in_word
## 補完候補がないときなどにビープ音を鳴らさない。
setopt no_beep
## 辞書順ではなく数字順に並べる。
setopt numeric_glob_sort
## 補完リストを水平にソートする。
setopt LIST_ROWS_FIRST

## -x: export SUDO_PATHも一緒に行う。
## -T: SUDO_PATHとsudo_pathを連動する。
typeset -xT SUDO_PATH sudo_path
## 重複したパスを登録しない。
typeset -U sudo_path
## (N-/): 存在しないディレクトリは登録しない。
##    パス(...): ...という条件にマッチするパスのみ残す。
##            N: NULL_GLOBオプションを設定。
##               globがマッチしなかったり存在しないパスを無視する。
##            -: シンボリックリンク先のパスを評価。
##            /: ディレクトリのみ残す。
sudo_path=({,/usr/pkg,/usr/local,/usr}/sbin(N-/))
## sudo時にはsudo用のパスも使う。
zstyle ':completion:sudo:*' environ PATH="$SUDO_PATH:$PATH"




######## History ########

## ヒストリを保存するファイル
HISTFILE=~/.zsh_history

## 大きな数を指定してすべてのヒストリを保存するようにしている。
## メモリ上のヒストリ数。
HISTSIZE=4294967295
## 保存するヒストリ数
SAVEHIST=$HISTSIZE

## ヒストリファイルにコマンドラインだけではなく実行時刻と実行時間も保存する。
setopt extended_history
## 同じコマンドラインを連続で実行した場合はヒストリに登録しない。
setopt hist_ignore_dups

## すぐにヒストリファイルに追記する。
setopt inc_append_history
## zshプロセス間でヒストリを共有する。
setopt share_history

## C-sでのヒストリ検索が潰されてしまうため、出力停止・開始用にC-s/C-qを使わない。
setopt no_flow_control

## 入力中の文字から始まるコマンドの履歴が表示される。
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
#bindkey "^[[A" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end
#bindkey "^[[B" history-beginning-search-forward-end




######## Changing Directly ########

## # cd時に自動的にpushdする。"cd -[Tab]"で移動履歴を一覧できる。
setopt auto_pushd

## コマンド名がディレクトリ時にcdする
setopt auto_cd

## トップでの '^' で 'cd ../' 実行
function chdir-up-dir {
	if [ "${BUFFER}" = "" ] ; then
		BUFFER='cd ../'
		zle accept-line
	else
		zle self-insert
	fi
}
zle -N chdir-up-dir
bindkey "\^" chdir-up-dir

## トップでの '-' で 'cd -' 実行
function chdir-prev-dir {
	if [ "${BUFFER}" = "" ] ; then
		BUFFER="cd -"
		zle accept-line
	else
		zle self-insert
	fi
}
zle -N chdir-prev-dir
bindkey "\-" chdir-prev-dir

## '^]' で 'popd' 実行
function chdir-pop-dir {
	zle push-input
	BUFFER="popd"
	zle accept-line
}
zle -N chdir-pop-dir
bindkey "^\]" chdir-pop-dir

## トップでの '[' で 'popd' 実行
function chdir-popd {
	if [ "${BUFFER}" = "" ] ; then
		BUFFER="popd"
		zle accept-line
	else
		zle self-insert
	fi
}
zle -N chdir-popd
bindkey "[" chdir-popd

## トップでの 'Tab' で 'cd ' 入力
function input-cd {
	if [ "${BUFFER}" = "" ] ; then
		zle push-input
		LBUFFER="cd "
	else
		zle expand-or-complete
	fi
}
zle -N input-cd
bindkey "\t" input-cd




######## ZLE ########

autoload -Uz zed

# 改行を入力しやすくする
#bindkey "^j" self-insert    # ^jで改行(文字)を入力
#bindkey -s "^[^m" "\n"      # ^mでEnter

## jjで "$_" 入力
function input-dollar-underscore {
	LBUFFER=${LBUFFER}'$_'
}
zle -N input-dollar-underscore
bindkey "jj" input-dollar-underscore

## kkで "$" 入力
function input-dollar {
	LBUFFER=${LBUFFER}'$'
}
zle -N input-dollar
bindkey "kk" input-dollar

## ヘッドでの '.' で './' 入力
function input-curdir {
	if is-head ${LBUFFER} ; then
		LBUFFER=${LBUFFER}'./'
	else 
		zle self-insert
	fi
}
zle -N input-curdir
bindkey "." input-curdir

## ヘッドでの '~' で '~/' 入力
function input-homedir {
	if is-head ${LBUFFER} ; then
		LBUFFER=${LBUFFER}'~/'
	else 
		zle self-insert
	fi
}
zle -N input-homedir
bindkey "~" input-homedir

## トップでの ';' で 'ms' 実行
function exec-ls {
	if [ "${BUFFER}" = "" ] ; then
		LBUFFER="ms "
		zle accept-line
	else
		zle self-insert
	fi
}
zle -N exec-ls
bindkey ";" exec-ls




######## Process Control ########

# '^Z' で 'fg %' 実行
function run-fg-last {
	fg %
	zle reset-prompt
}
zle -N run-fg-last
bindkey "^z" run-fg-last

## 実行したプロセスの消費時間がn秒以上かかったら
## 自動的に消費時間の統計情報を表示する。
REPORTTIME=5




######## Aliases ######## TODO

alias ls='ls --color=auto -v'
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias llh='ls -lh'
alias lah='ls -lah'
alias lo='ls -1'    # one
alias l1='ls -1'
alias lh='ls -1sh'

alias lt='ls -1ht'
alias lT='ls -1hrt'
alias lr='ls -1hrt'
alias llt='ls -lht'
alias llT='ls -lhrt'
alias llr='ls -lhrt'

alias ml='ms -l'
alias ma='ms -a'
alias mla='ms -la'
alias m1='ms -1'

alias df='df -h'
alias md='mkdir'
#alias md='source $HOME/bin/md'

alias grep='grep --color=auto'

#alias awk='gawk'
#alias v='vim'
#alias c='gcc'
#alias d='gdb'
#alias m='make'
# to abbreviations alias -g A='| awk'
# to abbreviations alias -g B='| bc -l'
# to abbreviations alias -g C='| cut'
#ga alias -g C='| clip'
#ga alias -g D='| disp'
# to abbreviations alias -g F='| s2t | cut -f'	#field
# to abbreviations alias -g G='| grep'
#ga alias -g H='| head -n 20'
#ga alias -g J='| japan_numerical'
alias -g L='| less'
# to abbreviations alias -g N='| cat -n'
# to abbreviations alias -g Q='| sort'
# to abbreviations alias -g R='| tr'
# to abbreviations alias -g S='| sed'
#ga alias -g T='| tail'
#ga alias -g U='| iconv -f cp932 -t utf-8'
# to abbreviations alias -g V='| vim -R -'
#ga alias -g W='| wc -l'
# to abbreviations alias -g X='| xargs'
# to abbreviations alias -g Y='| wc'
# EIKMOPZ
alias GD='git diff'
alias GS='git status .'
alias gsh='git status | head -n 20'
alias kakasi='kakasi -iutf8 -outf8'

alias l='ls'
alias m='man'
#alias v='vg'
#alias vg='gvim'
alias af='awk -f'

alias gt='git'
alias mk='make'

alias s2t="sed -e 's/[ \t][ \t]*/\t/g'"
alias psg='ps ax | grep'

alias cc='gcc'

case `uname` in
    *CYGWIN* )	# Cygwin
	alias a='./a.exe'
	alias vim='gvim'
	;;
    * )		# Other Unix or Unix-like
	alias a='./a.out'
	;;
esac

alias awk='awk -M'
alias dog='source-highlight-esc.sh'



######## Abbreviations ########

setopt extended_glob

typeset -A abbreviations

abbreviations=(
    "A"    "| awk '"
    "AF"   "for (i = 1; i <= NF; i++) { "
    "AB"   "| awk 'BEGIN{ "
    "ABF"  "| awk 'BEGIN{ printf \"%"
    "C"    "| cat -n "
    "CA"   "| --color=always "
    "CN"   "| --color=none "
    "D"    "| disp"
    "DB"   "| d2b -s "
    "DX"   "| d2x -s "
    "F"    "| find -name '**"
    "FN"   "| find -name '**"
    "F1"   "| find -maxdepth 1 -name '**"
    "FO"   "-o -name '*"
    "FG"   "| find | xargs grep "
    "FLD"  "| s2t | cut -f'"	#field
    "FNS"  "| find -name '.svn' -prune -type f -o -name '"
    "FNG"  "| find -name '.git' -prune -type f -o -name '"
    "G"    "| grep "
    "GV"   "| grep -v "
    "H"    "| head -n 20 "
    "HH"   '| head -n $(($LINES-4)) '
    "HN"   "| head -n "
    "HL"   "--help"
    "I"    "| "
    "L"    "| clip"
    "LC"   "LANG=C "
    "LJ"   "LANG=ja_JP.UTF-8 "
    "N"    "> /dev/null "
    "NN"   "> /dev/null 2>&1"
    "NE"   "2> /dev/null"
    "NI"   "< /dev/null"
    "Q"    "| sort "     # Quick sort
    "S"    "| sed '"
    "SN"   "| sed -n '"
    "SS"   "| sed 's/"
    "T"    "| tail -n 20 "
    "TT"   '| tail -n $(($LINES-4)) '
    "TN"   "| tail -n "
    "TL"   "| tr 'A-Z' 'a-z' "	# To Lower
    "TU"   "| tr 'a-z' 'A-Z' "	# To Upper
    "U"    "| iconv -f cp932 -t utf-8 "
    "UU"   "| iconv -f utf-8 -t cp932 "
    "UE"   "| iconv -f euc-jp -t utf-8 "
    "UN"   "| sort | uniq"
    "V"    "| vim -R - "
    "W"    "| wc -l "
    "X"    "| xargs "
    "XI"   "| xargs -i "
    "XN"   "| xargs -n "
)

magic-abbrev-expand() {
	local MATCH
	LBUFFER=${LBUFFER%%(#m)[-_a-zA-Z0-9]#}
	LBUFFER+=${abbreviations[$MATCH]:-$MATCH}
	LBUFFER=${LBUFFER##| }      # 行頭で展開するときはパイプを消す
	if [ "${abbreviations[$MATCH]}" = "" ]; then
		zle self-insert
	fi
}
zle -N magic-abbrev-expand
bindkey " " magic-abbrev-expand




######## Math and Calculation ########

## 数学ライブラリをload
zmodload -i zsh/mathfunc

## PIをシェル変数として定義
PI=`awk 'BEGIN{ printf "%.12f", atan2(0,-1) }'`
typeset -r PI


function xawk {
	if [ "${BUFFER}" = "" ] ; then
		LBUFFER="awk 'BEGIN{ print "
		RBUFFER=" }'"
	else
		zle end-of-line
	fi
}
zle -N xawk
bindkey "^e" xawk

function xawk-f {
	if [ "${BUFFER}" = "" ] ; then
		LBUFFER="awk -f "
	else
		zle beginning-of-line
	fi
}
zle -N xawk-f
bindkey "^a" xawk-f

alias AWK="gawk -O -e '
	BEGIN{ OFMT = \"%.8g\"; pi = atan2(0, -1) }
	# deg2rad
	function d2r(deg) { return deg * pi / 180 }
	# rad2deg
	function r2d(rad) { return rad * 180 / pi }
' -e"
function aawk {
	if [ "${BUFFER}" = "" ] ; then
		LBUFFER="AWK 'BEGIN{ print "
		RBUFFER=" }'"
	else
		zle backward-char
	fi
}
zle -N aawk
bindkey "^b" aawk

function my-zcalc {
	if [ "${BUFFER}" = "" ] ; then
		zle push-input
		BUFFER='echo $((  ))'
		zle forward-word
		zle forward-word
		zle backward-char
	else
		zle self-insert
	fi
}
zle -N my-zcalc
bindkey "#" my-zcalc




######## Miscellaneous ########

# シェル関数やスクリプトの source 実行時に、 $0 を一時的にその関数／スクリプト名にセットする。
setopt FUNCTION_ARGZERO

# `.' で開始するファイル名にマッチさせるとき、先頭に明示的に `.' を指定する必要がなくなる
#setopt GLOB_DOTS

# ZMV をLoad
autoload -Uz zmv

# コマンドラインでもコメントを使う
setopt interactivecomments

# {}の中に no match があってもエラーとしない。
setopt nonomatch

export GREP_COLORS='ms=01;31:mc=01;31:sl=:cx=:fn=35:ln=32:bn=32:se=36'
export LESS='-i -M -R'




######## for GNU Screen ########
# 
# preexec () {
# 	if [ "$TERM" = "screen" ]; then
# 		[ ${STY} ] && echo -ne "\ek${1%% *}\e\\"
# 	fi
# }
# 
# precmd() {
# 	chpwd
# }
# 
# chpwd() {
# 	if [ "$TERM" = "screen" -a "$PWD" = "$HOME" ]; then
# 		echo -n "\ek[~]\e\\"
# 	elif [ "$TERM" = "screen" ]; then
# 		echo -n "\ek[`basename $PWD`]\e\\"
# 	fi
# }
# chpwd




######## 実験場 ######## TODO

function mk_tmp_file {
	unset tf

	# trap '[[ "$tmpfile" ]] && rm -f $tmpfile' 1 2 3 15

	tf=$(mktemp --suffix .$1 2>/dev/null||mktemp --suffix .$1 -t tmp)

	vgg $tf
}

# vi風キーバインドにする
#bindkey -v

[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# for vim terminal
LANG=ja_JP.UTF-8


##############################################################


autoload -Uz edit-command-line
zle -N edit-command-line
bindkey "^O" edit-command-line

# bindkey "^t" push-line


#-----------------------------------------------


# '^Z' で 'fg %' 実行
function run-fg-last {
	if [ "${BUFFER}" = "" ] ; then
		fg %
		zle reset-prompt
	else
		POSTDISPLAY="

(stack):$BUFFER"
#stack:[$LBUFFER]"
#[stack]$LBUFFER"
#\e[34mpend:[$LBUFFER]"
		#zle push-line
		#zle push-input
		zle push-line-or-edit
	fi
}
zle -N run-fg-last
bindkey "^z" run-fg-last


#-----------------------------------------------

show_buffer_stack() {
  POSTDISPLAY="

stack: $LBUFFER"
  zle push-line-or-edit
}
zle -N show_buffer_stack
setopt noflowcontrol
bindkey '^Q' show_buffer_stack

#-----------------------------------------------


#-----------------------------------------------


#-----------------------------------------------


#-----------------------------------------------


#-----------------------------------------------
#
# あまりキー(総合)
# Q T U O ^ | [ ] G
#
# あまりキー(先頭)
# U I D F B J K 
#

