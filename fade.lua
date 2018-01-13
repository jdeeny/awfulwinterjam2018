local fade = {}

function fade.draw()
  if fade.state then
    if fade.state == "fadein" then
      alpha = 255 - 255 * fade.duration:t()
    else
      alpha = 255 * fade.duration:t()
    end
    love.graphics.setColor(0,0,0, alpha)
    love.graphics.rectangle("fill", 0, 0, window.w, window.h)
    love.graphics.setColor(255,255,255,255)

    if fade.duration:finished() then
      fade.state = nil
      fade.duration = nil
      if fade.end_function then
        fade.end_function()
      end
    end
  end
end

function fade.start_fade(state, time, gui_based, end_function)
  fade.state = state
  fade.duration = duration.start(time, gui_based)
  if end_function then
    fade.end_function = end_function
  else
    fade.end_function = nil
  end
end

return fade
