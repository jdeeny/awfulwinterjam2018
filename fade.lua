local fade = {start_time = 0, end_time = 1}

function fade.draw(time)
  if fade.state then
    if fade.state == "fadein" then
      alpha = cpml.utils.clamp(255 - 255 * (time - fade.start_time) / (fade.end_time - fade.start_time), 0, 255)
    else
      alpha = cpml.utils.clamp(255 * (time - fade.start_time) / (fade.end_time - fade.start_time), 0, 255)
    end
    love.graphics.setColor(0,0,0, alpha)
    love.graphics.rectangle("fill", 0, 0, window.w, window.h)
    love.graphics.setColor(255,255,255,255)

    if time > fade.end_time then
      fade.state = nil
      if fade.end_function then
        fade.end_function()
      end
    end
  end
end

function fade.start_fade(state, start_time, end_time, end_function)
  fade.state = state
  fade.start_time = start_time
  fade.end_time = end_time
  if end_function then
    fade.end_function = end_function
  else
    fade.end_function = nil
  end
end

return fade
