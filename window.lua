window = {}
--window.callbacks = {}

local dw = 12   --desired width / height
local dh = 9


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

function window.reset()
  window.sizebyscale(window.bestscale())
end

function window.bestscale()
  local sw, sh, fs, vsync, fsaa = love.window.getMode( )
  local s = 1
  while s * dw * TILESIZE < sw and s * dh * TILESIZE < sh do
    s = s + 1
  end

  return s
end

function window.sizebyscale(s)
  local w = s * dw * TILESIZE
  local h = s * dh * TILESIZE
  love.window.setMode(w, h)
end

function love.resize(w, h)
  print(("Window resized to width: %d and height: %d."):format(w, h))
  window.update()
  print(("Window resized to width: %d and height: %d."):format(w, h))
end

window.update()
