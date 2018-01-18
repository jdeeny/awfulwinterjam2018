local fade = {}

function fade.draw()
  if fade.state then
    love.graphics.setColor(0,0,0, fade.alpha)
    love.graphics.rectangle("fill", 0, 0, window.w, window.h)
    love.graphics.setColor(255,255,255,255)
  end
end

function fade.start_fade(state, time, gui_based)
  local tween, target

  fade.state = state

  if fade.state == "fadein" then
	  fade.alpha = 255
	  target = 0
  else
	  fade.alpha = 0
	  target = 255
  end

  if gui_based then
  	tween = gui_flux.to(fade, time, {alpha = target})
  else
    tween = game_flux.to(fade, time, {alpha = target})
  end
end

return fade
