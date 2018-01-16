window = {}
--window.callbacks = {}

function window.update()
  window.w = love.graphics.getWidth()
  window.h = love.graphics.getHeight()
end

--[[function window._runcallbacks()
  for _, f in pairs(window.callbacks) do
    print "callback"
    f()
  end
end

function window.addCallback(f, id)
  local i = id or ""..math.random()
  window.callbacks[i] = f
  return i
end

function window.removeCallback(id)
  window.callbacks[id] = nil
end]]

function love.resize(w, h)
  print(("Window resized to width: %d and height: %d."):format(w, h))
  window.update()
    print(("Window resized to width: %d and height: %d."):format(w, h))
end

window.update()
