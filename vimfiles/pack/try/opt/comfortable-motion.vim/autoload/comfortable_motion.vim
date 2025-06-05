vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 et:
scriptencoding utf-8

#=============================================================================
# File: comfortable_motion.vim
# Author: Yuta Taniguchi
# Created: 2016-10-02
#=============================================================================


# Default parameter values
if !exists('g:comfortable_motion_interval')
  g:comfortable_motion_interval = 1000.0 / 60
endif
if !exists('g:comfortable_motion_friction')
  g:comfortable_motion_friction = 80.0
endif
if !exists('g:comfortable_motion_air_drag')
  g:comfortable_motion_air_drag = 2.0
endif
if !exists('g:comfortable_motion_scroll_down_key')
  g:comfortable_motion_scroll_down_key = "\<C-e>"
endif
if !exists('g:comfortable_motion_scroll_up_key')
  g:comfortable_motion_scroll_up_key = "\<C-y>"
endif

# The state
var comfortable_motion_state = {
  'impulse': 0.0,
  'velocity': 0.0,
  'delta': 0.0,
}

var timer_id = -1
var CursorColumnSave: bool


def Tick(_: number)

  var st = comfortable_motion_state  # This is just an alias for the global variable
  if abs(st.velocity) >= 1 || st.impulse != 0 # short-circuit if velocity is less than one
    const dt = g:comfortable_motion_interval / 1000.0  # Unit conversion: ms -> s

    # Compute resistance forces
    const vel_sign = st.velocity == 0
      \            ? 0
      \            : float2nr(st.velocity / abs(st.velocity)) # TODO
    const friction = -vel_sign * g:comfortable_motion_friction * 1  # The mass is 1
    const air_drag = -st.velocity * g:comfortable_motion_air_drag
    const additional_force = friction + air_drag

    # Update the state
    st.delta += st.velocity * dt
    st.velocity += st.impulse + (abs(additional_force * dt) > abs(st.velocity) ? -st.velocity : additional_force * dt)
    st.impulse = 0.0

    # Scroll
    const int_delta = float2nr(st.delta >= 0 ? floor(st.delta) : ceil(st.delta))
    st.delta -= int_delta + 0.0 # TODO

    &cursorcolumn = false  # TODO
    #&cursorline = false  # TODO

    if int_delta > 0
      if 0
        execute "silent noautocmd normal! " .. string(abs(int_delta)) .. g:comfortable_motion_scroll_down_key .. string(abs(int_delta)) .. 'gj'
        redraw
      elseif 1
        #range(int_delta) -> map((_, _) => { # TODO foreach
          #execute("silent noautocmd normal! \<c-e>gj")
        range(int_delta / 2) -> map((_, _) => { # TODO foreach
          execute("silent noautocmd normal! 2\<c-e>2gj")
          redraw
          return 0
        })
      else
        #range(int_delta) -> map((_, _) => { # TODO foreach
          #execute("silent noautocmd normal! \<c-e>gj")
        range(int_delta / 2) -> map((_, _) => { # TODO foreach
          execute("silent noautocmd normal! 2\<c-e>2gj")
          return 0
        })
        redraw
      endif
    elseif int_delta < 0
      if 0
        execute "silent noautocmd normal! " .. string(abs(int_delta)) .. g:comfortable_motion_scroll_up_key .. string(abs(int_delta)) .. 'gk'
        redraw
      elseif 1
       #range(int_delta, -1) -> map((_, _) => { # TODO foreach
         #execute("silent noautocmd normal! \<c-y>gk")
        range(float2nr(floor(int_delta / 2.0)), -1) -> map((_, _) => { # TODO foreach
          execute("silent noautocmd normal! 2\<c-y>2gk")
          redraw
          return 0
        })
      else
        range(float2nr(floor(int_delta / 2.0)), -1) -> map((_, _) => { # TODO foreach
          execute("silent noautocmd normal! 2\<c-y>2gk")
          return 0
        })
        redraw
      endif
    else
      # Do nothing
    endif
    redraw
  else
    Stop()
    ##?? # Stop scrolling and the thread
    ##?? st.velocity = 0.0
    ##?? st.delta = 0.0
    ##?? timer_stop(timer_id)
    ##?? # TODO unlet s:timer_id
    ##?? timer_id = -1
  endif
enddef

def Stop()
  var st = comfortable_motion_state  # This is just an alias for the global variable

  # Stop scrolling and the thread
  st.velocity = 0.0
  st.delta = 0.0
  timer_stop(timer_id)
  # TODO unlet s:timer_id
  timer_id = -1

  &cursorcolumn = CursorColumnSave
  #&cursorline = true
enddef

export def Flick(impulse: float)
#export def Flick(impulse: number)
  if timer_id == -1
    CursorColumnSave = &cursorcolumn
    &cursorcolumn = false
    # There is no thread, start one
    const interval = float2nr(round(g:comfortable_motion_interval))
    timer_id = timer_start(interval, function("Tick"), {'repeat': -1})
  else
    const st = comfortable_motion_state  # This is just an alias for the global variable
    if (st.velocity * impulse) < 0  # TODO  逆符号なら
      Stop()
      return
    endif
  endif
  comfortable_motion_state.impulse += impulse
enddef

augroup ccc
  au!
  au WinLeave * Stop()
augroup end

#g:comfortable_motion_friction = 253.0
#g:comfortable_motion_air_drag = 45.0
g:comfortable_motion_impulse_multiplier = 38.0
g:comfortable_motion_impulse_multiplier = 12.0
#nnoremap <silent> <C-D> <ScriptCmd>Flick(g:comfortable_motion_impulse_multiplier * min([64, winheight(0)])     )<CR>
#nnoremap <silent> <C-U> <ScriptCmd>Flick(g:comfortable_motion_impulse_multiplier * min([64, winheight(0)]) * -1)<CR>
nnoremap <silent> gj <ScriptCmd>Flick(g:comfortable_motion_impulse_multiplier * min([64, winheight(0)])     )<CR>
nnoremap <silent> gk <ScriptCmd>Flick(g:comfortable_motion_impulse_multiplier * min([64, winheight(0)]) * -1)<CR>

vnoremap <silent> gj <ScriptCmd>Flick(g:comfortable_motion_impulse_multiplier * min([64, winheight(0)])     )<CR>
vnoremap <silent> gk <ScriptCmd>Flick(g:comfortable_motion_impulse_multiplier * min([64, winheight(0)]) * -1)<CR>

vnoremap <silent> <C-D> <ScriptCmd>Flick(g:comfortable_motion_impulse_multiplier * min([64, winheight(0)])     )<CR>
vnoremap <silent> <C-U> <ScriptCmd>Flick(g:comfortable_motion_impulse_multiplier * min([64, winheight(0)]) * -1)<CR>


nnoremap <silent> <Plug>(gj) <ScriptCmd>Flick(g:comfortable_motion_impulse_multiplier * min([64, winheight(0)])     )<CR>
nnoremap <silent> <Plug>(gk) <ScriptCmd>Flick(g:comfortable_motion_impulse_multiplier * min([64, winheight(0)]) * -1)<CR>
submode#enter_with('VertScrollDn', 'nv', '', 'gj', '<Plug>(gj)')
submode#enter_with('VertScrollUp', 'nv', '', 'gk', '<Plug>(gk)')
submode#map(       'VertScrollDn', 'nv', '',  'j', '<Plug>(gj)')
submode#map(       'VertScrollUp', 'nv', '',  'k', '<Plug>(gk)')

submode#map(       'VertScrollDn', 'nv', 'x', 'k', '<Plug>(gk)')
submode#map(       'VertScrollUp', 'nv', 'x', 'j', '<Plug>(gj)')
#submode#leave_with('VertScrollDn', 'nv', '',  'k')
#submode#leave_with('VertScrollUp', 'nv', '',  'j')
#
#com! Stop {
#  Stop()
#  echo "Stop"
#}
#augroup CCCC
#  au!
#  #au User SubmodeEnterVertScrollDn Stop #call Flick(-1)
#  #au User SubmodeLeaveVertScrollUp Stop #call Flick(+1)
#  au User SubmodeLeaveVertScrollDn Stop
#  au User SubmodeLeaveVertScrollUp Stop
#augroup end
