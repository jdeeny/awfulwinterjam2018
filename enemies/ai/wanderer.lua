local Wanderer = class("Wanderer", Ai)

function Wanderer:update(dt)
  Ai.update(self, dt) -- call superclass constructor
end

return Wanderer
