vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8


finish


#----------------------------------------------------------------------------------------
# Dummy (for Demo)

# 他から自由に干渉できるよう、グローバルスコープとしておく。
g:BatDemoRem = 100.0

def BatteryReduce(dummy: number)
  var rem = g:BatDemoRem

  if rem <= 0
    rem = 100
  else
    # 0..N の範囲の乱数を生成して引く
    rem -= (rand() / pow(2, 32) * 8)
    if rem < 0
      rem = 0
    endif
  endif

  g:BatDemoRem = rem
enddef

# 旧タイマの削除 (再読み込みする際、古いタイマを削除しないと、どんどん貯まっていってしまう。)
if exists('g:BatteryDemoTimerId') | timer_stop(g:BatteryDemoTimerId) | endif

g:BatteryDemoTimerId = 0

def SetTimer(on: bool)
  if on
    if timer_info(g:BatteryDemoTimerId) == []
      g:BatteryDemoTimerId = timer_start(1000, BatteryReduce, {'repeat': -1})
    endif
  else
    timer_stop(g:BatteryDemoTimerId)
  endif
enddef

def BatteryRemaining(): number
  return g:BatDemoRem -> float2nr()
enddef

SetTimer(true)

# API
 1. 残パーセントを任意に設定できる
 2. 残時間を任意に設定できる
 3. 電源状態を任意に設定できる

    シミュレータモードへ移行できる
 4.   sysが有効なとき
 5.   sysが無効なとき
    シミュレータモードを終了できる
 6.   sysが有効なとき
 7.   sysが無効なとき

    残パーセントの自動減少を開始できる
 8.   sysが有効なとき
 9.   sysが無効なとき
    残時間の自動減少を開始できる
10.   sysが有効なとき
11.   sysが無効なとき

    残パーセントの自動減少を終了できる
12.   sysが有効なとき
13.   sysが無効なとき
    残時間の自動減少を終了できる
14.   sysが有効なとき
15.   sysが無効なとき

16. 残パーセントの自動減少のタイマ間隔を設定できる
17. 残時間の自動減少のタイマ間隔を設定できる

18. 残パーセントの自動減少の減り刻みを設定できる
19. 残時間の自動減少の減り刻みを設定できる


