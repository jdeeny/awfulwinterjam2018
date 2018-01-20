window = {}
window.callbacks = {}

local dw = 12   --desired width / height
local dh = 9

window.s = 1.0

function window.update(w, h)
  window.realw, window.realh = love.graphics.getWidth(), love.graphics.getHeight()
  window.w, window.h = window.realw/window.s, window.realw/window.s
  if window.resetdone then cscreen.update(window.realw, window.realh, window.s) end
  window._runcallbacks()
end

function window._runcallbacks()
  for id, f in pairs(window.callbacks) do
    print("callback: ".. id)
    f()
  end
end

function window.addCallback(f, id)
  local i = id or "callback"..math.random()
  window.callbacks[i] = f
  return i
end

function window.removeCallback(id)
  window.callbacks[id] = nil
end

function window.reset()
  window.resetdone = true
  window.s = window.bestscale()
  print("Scale "..window.s)
  window.sizebyscale(window.s)
  print("WH: "..window.w.." "..window.h)
  cscreen.init(window.w, window.h, false)

end

function window.bestscale()
  local sw, sh, fs, vsync, fsaa = love.window.getMode( )
  local s = 1
  while s * dw * TILESIZE < sw and s * dh * TILESIZE < sh do
    s = s + 1
  end

  return s
  --return 2
end

function window.sizebyscale(s)
  local w = dw * TILESIZE
  local h = dh * TILESIZE
  window.w, window.h = w, h
  love.window.setMode(w*s, h*s, { resizable = true, minheight = 480, minwidth = 640, fullscreen = false } )
end

function love.resize(w, h)
  print(("Window resized to width: %d and height: %d."):format(w, h))
  window.update(w, h)
  print(("Window resized to width: %d and height: %d."):format(w, h))
end
