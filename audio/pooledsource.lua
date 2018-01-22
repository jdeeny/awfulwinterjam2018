local PooledSource = class('PooledSource')

function PooledSource:initialize(path, volume)
  self.source = love.audio.newSource(path, "static")
  if volume then
    self.source:setVolume(volume)
  end
  self.pool = {}
  self.count = 0
end

function PooledSource:play()
  -- print(self.count)
  return self:find_available():play()
end

function PooledSource:find_available()
  for id, s in pairs(self.pool) do
    if s:isPlaying() then
    else
      return s
    end
  end

  local s = self.source:clone()
  self.count = self.count + 1
  self.pool[self.count] = s
  return s
end

return PooledSource
