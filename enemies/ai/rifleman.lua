local super = require 'enemies/ai/seeker' 
local Rifleman = class("Rifleman", super)  -- subclass seeker

function Rifleman:update(dt)
  super.update(self, dt)
end

return Rifleman
