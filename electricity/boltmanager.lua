local BoltManager = class("BoltManager")

function BoltManager:initialize()
  self.bolts = {}
  self.count = 0
end

function BoltManager:add(source, target, intensity, time)
  local bolt = {}
  bolt.lightning = LoveLightning:new(255, 255, 255, intensity)
  bolt.lightning:setSource(source)
  bolt.lightning:setPrimaryTarget(target)
  bolt.id = self.count
  bolt.timeout = game_time + time
  self.count = self.count + 1
  self.bolts[self.count] = bolt
  return bolt
end

function BoltManager:update(dt)
  if math.random() < (5.0 * dt) then
    print("added")
    self:add(cpml.vec2.new(math.random() * 500, math.random() * 500),
              cpml.vec2.new(math.random() * 500, math.random() * 500),
              math.random(),
              math.random() * 1 + 1)
  end

  for id, b in pairs(self.bolts) do
    if b.timeout < game_time then
      self.bolts[id] = nil
    else
      b.lightning:update(dt)
    end
  end
end

function BoltManager:draw()
  for _, b in pairs(self.bolts) do
    b.lightning:draw()
  end
end

return BoltManager
