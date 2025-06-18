vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8

#=============================================================================================
# Numbers
#=============================================================================================


import autoload 'numbers.vim' as nr


#---------------------------------------------------------------------------------------------
# Commands


#--------------------------------------------
# Display

com! -bar -nargs=0 NumberDisplay      nr.NumberDisplay(expand("<cword>"))
com! -bar -nargs=0 NumberDisplayPopup nr.NumberDisplayPopup(expand("<cword>"), -1)


#--------------------------------------------
# Auto

com! -bar -nargs=0 NumberDisplayAutoToggle      nr.NumbersAutoToggle(nr.AUTO_MODE.CLINE)
com! -bar -nargs=0 NumberDisplayAutoTogglePopup nr.NumbersAutoToggle(nr.AUTO_MODE.POPUP)


#--------------------------------------------
# Base Change

com! -bar -nargs=? BD nr.BaseChange(10, <q-args>,  2)
com! -bar -nargs=? BH nr.BaseChange(16, <q-args>,  2)
com! -bar -nargs=? BX nr.BaseChange(16, <q-args>,  2)
com! -bar -nargs=? DB nr.BaseChange( 2, <q-args>, 10)
com! -bar -nargs=? DH nr.BaseChange(16, <q-args>, 10)
com! -bar -nargs=? DX nr.BaseChange(16, <q-args>, 10)
com! -bar -nargs=? HB nr.BaseChange( 2, <q-args>, 16)
com! -bar -nargs=? XB nr.BaseChange( 2, <q-args>, 16)
com! -bar -nargs=? HD nr.BaseChange(10, <q-args>, 16)
com! -bar -nargs=? XD nr.BaseChange(10, <q-args>, 16)


#---------------------------------------------------------------------------------------------
# Mapping

# inoremap <C-r><C-b><C-d> <C-r>=Bin2Dec('')<Left><Left>
# inoremap <C-r><C-b><C-h> <C-r>=Bin2Hex('')<Left><Left>
# inoremap <C-r><C-b><C-x> <C-r>=Bin2Hex('')<Left><Left>
# inoremap <C-r><C-d><C-b> <C-r>=Dec2Bin('')<Left><Left>
# inoremap <C-r><C-d><C-x> <C-r>=Dec2Hex('')<Left><Left>
# inoremap <C-r><C-d><C-h> <C-r>=Dec2Hex('')<Left><Left>
# inoremap <C-r><C-h><C-b> <C-r>=Hex2Bin('')<Left><Left>
# inoremap <C-r><C-h><C-d> <C-r>=Hex2Dec('')<Left><Left>
# inoremap <C-r><C-x><C-b> <C-r>=Hex2Bin('')<Left><Left>
# inoremap <C-r><C-x><C-d> <C-r>=Hex2Dec('')<Left><Left>


#---------------------------------------------------------------------------------------------
# TODO
# シェル版の奇数変換コマンドの全てのオプションに対応
#
#   1. 区切り文字 , _ '
#   2. BaseChange Input


# com! -bar -nargs=? BD exe 'normal! ' . (search('^\%#$', 'cn') ? 'i' : 'ciw') . s:cmd_driver('Bin', 'Dec', <f-args>) . "\<Esc>"
# com! -bar -nargs=? BH exe 'normal! ' . (search('^\%#$', 'cn') ? 'i' : 'ciw') . s:cmd_driver('Bin', 'Hex', <f-args>) . "\<Esc>"
# com! -bar -nargs=? BX exe 'normal! ' . (search('^\%#$', 'cn') ? 'i' : 'ciw') . s:cmd_driver('Bin', 'Hex', <f-args>) . "\<Esc>"
# com! -bar -nargs=? DB exe 'normal! ' . (search('^\%#$', 'cn') ? 'i' : 'ciw') . s:cmd_driver('Dec', 'Bin', <f-args>) . "\<Esc>"
# com! -bar -nargs=? DH exe 'normal! ' . (search('^\%#$', 'cn') ? 'i' : 'ciw') . s:cmd_driver('Dec', 'Hex', <f-args>) . "\<Esc>"
# com! -bar -nargs=? DX exe 'normal! ' . (search('^\%#$', 'cn') ? 'i' : 'ciw') . s:cmd_driver('Dec', 'Hex', <f-args>) . "\<Esc>"
# com! -bar -nargs=? HB exe 'normal! ' . (search('^\%#$', 'cn') ? 'i' : 'ciw') . s:cmd_driver('Hex', 'Bin', <f-args>) . "\<Esc>"
# com! -bar -nargs=? XB exe 'normal! ' . (search('^\%#$', 'cn') ? 'i' : 'ciw') . s:cmd_driver('Hex', 'Bin', <f-args>) . "\<Esc>"
# com! -bar -nargs=? HD exe 'normal! ' . (search('^\%#$', 'cn') ? 'i' : 'ciw') . s:cmd_driver('Hex', 'Dec', <f-args>) . "\<Esc>"
# com! -bar -nargs=? XD exe 'normal! ' . (search('^\%#$', 'cn') ? 'i' : 'ciw') . s:cmd_driver('Hex', 'Dec', <f-args>) . "\<Esc>"


#---------------------------------------------------------------------------------------------
# Test

# 0xaf45 0xf0 0b011100 0716 1234 65535 0xfdb97531 0xfdb97531ff 256 0b111111110000000011010000  0101111
# 0xaf45UL 0xf0ll 0b011100 0716 1234 65536 0xfdb97531 256a 0b111111110000000011010000  0101111
# 98,67878,2345 0b01011111000000001101_0000 0xffffffffffffffff 0xffffffffffffffffffffffffffffffff
# 0b11 993692464862809801080805478547854754953675 3 165535 18446744073709551606
