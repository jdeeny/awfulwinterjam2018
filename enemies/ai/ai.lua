local Ai = class("Ai")

function Ai:initialize(entity)
  self.entity = entity
  self.state = 'idle'
  return self
end

function Ai:update(dt)

end

function Ai:getState()
  return self.state
end

return Ai
