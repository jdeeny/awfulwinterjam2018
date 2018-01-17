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

Ai.Wanderer = require('enemies/ai/wanderer')

return Ai
