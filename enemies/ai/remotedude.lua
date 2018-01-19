local super = require 'enemies/ai/seeker'
local Remotedude = class("Remotedude", super)  -- subclass seeker

function Remotedude:initialize(entity)
  super.initialize(self, entity)
  self.israndom = 0.1
end

function Remotedude:update(dt)
  super.update(self, dt) -- call update from `Seeker` to do the movement portion
  if self.entity.animation then
    if self.entity.animation.position == 2 and not self.havesmoked then
      self.havesmoked = true
      local smokex = self.entity.x
      if self.entity.facing_east then
        smokex = smokex - 4
      else
        smokex = smokex + 4
      end
      SmokeParticles:new(smokex, self.entity.y-25, 2, 2, 0.014, 0.4)
    elseif self.entity.animation.position ~= 2 then
      self.havesmoked = false
    end

  end
end

return Remotedude
