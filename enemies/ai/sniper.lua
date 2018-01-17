local super = require 'enemies/ai/rifleman'
local Sniper = class("Sniper", super)  -- subclass rifleman

function Sniper:update(dt)
  super.update(self, dt)
end

return Sniper
