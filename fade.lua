local fade = {}

function fade.draw()
  if fade.state then
    love.graphics.setColor(0,0,0, fade.alpha)
    love.graphics.rectangle("fill", 0, 0, window.w, window.h)
    love.graphics.setColor(255,255,255,255)
  end
end

function fade.finish()
  fade.state = nil
end

function fade.start_fade(state, time, gui_based, end_function)
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
  	tween = gui_flux.to(fade, time, {alpha = target}):oncomplete(fade.finish)
  else
	tween = game_flux.to(fade, time, {alpha = target}):oncomplete(fade.finish)
  end
  
  if end_function then
	  tween:oncomplete(end_function)
  end
 
end

return fade
