window = {}

function window.update()
  window.w = love.graphics.getWidth()
  window.h = love.graphics.getHeight()
end

function love.resize(w, h)
  window.update()
end

window.update()
