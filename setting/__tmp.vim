" 改行後、コメント化しない。
set formatoptions-=or
setl formatoptions-=or

set mps+=【:】,「:」,『:』,《:》

" Unicodeで定義されている全ての括弧
set mps+=(:),<:>,[:],{:},（:）,＜:＞,［:］,｛:｝,｟:｠,｢:｣,〈:〉,《:》,「:」,『:』,【:】,〔:〕,〖:〗,〘:〙,〚:〛,⟦:⟧,⟨:⟩,⟪:⟫,⟬:⟭,⟮:⟯,⦃:⦄,⦅:⦆,⦇:⦈,⦉:⦊,⦋:⦌,⦍:⦎,⦏:⦐,⦑:⦒,⦗:⦘,⧼:⧽,❨:❩,❪:❫,❬:❭,❮:❯,❰:❱,❲:❳,❴:❵,⁽:⁾,₍:₎

" Unicodeの曖昧文字を半角2文字分とする
set ambiwidth=double

nnoremap cu ciw
nnoremap du daw


" #-----------------------------------------------
" 
" 
" # '^Z' で 'fg %' 実行
" function run-fg-last {
" 	if [ "${BUFFER}" = "" ] ; then
" 		fg %
" 		zle reset-prompt
" 	else
" 		POSTDISPLAY="
" 
" (stack):$BUFFER"
" #stack:[$LBUFFER]"
" #[stack]$LBUFFER"
" #\e[34mpend:[$LBUFFER]"
" 		#zle push-line
" 		#zle push-input
" 		zle push-line-or-edit
" 	fi
" }
" zle -N run-fg-last
" bindkey "^z" run-fg-last
" 
" 
" #-----------------------------------------------
