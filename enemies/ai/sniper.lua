local super = require 'enemies/ai/rifleman'
local Sniper = class("Sniper", super)  -- subclass rifleman

function Sniper:initialize(entity)
  super.initialize(self, entity)

  self.reload_time = 4.0
  self.lockon = true
end


function Sniper:update(dt)
  super.update(self, dt)
end

return Sniper
