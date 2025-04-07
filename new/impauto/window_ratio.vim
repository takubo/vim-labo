vim9script

export def WindowRatio(): float
  const h = winheight(0) + 0.0
  const w =  winwidth(0) + 0.0
  return (w / h - 178.0 / 78.0)
enddef

#       Vert Split すべきとき、正数が返る。
# Horizontal Split すべきとき、負数が返る。
export def SplitDirection(): number
  return ( winwidth(0) > (&columns * 7 / 10) && <SID>WindowRatio() >= 0 ) ? 9999 : -9999
enddef

#       Vert Split すべきとき、'v'が返る。
# Horizontal Split すべきとき、's'が返る。
export def SplitDirectionStr(): string
  return ( winwidth(0) > (&columns * 7 / 10) && <SID>WindowRatio() >= 0 ) ? 'v' : 's'
enddef

#       Vert Split すべきとき、true が返る。
# Horizontal Split すべきとき、falseが返る。
export def VertSplit(): bool
  return ( winwidth(0) > (&columns * 7 / 10) && WindowRatio() >= 0 )
enddef
