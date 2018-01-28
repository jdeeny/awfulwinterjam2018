local super = require 'enemies/ai/bouncer'
local RemotedudeBouncer = class("RemotedudeBouncer", super)
function RemotedudeBouncer:initialize(entity)
  super.initialize(self, entity)
  self.nextsmoke = game_time + math.random()
  self.smoketime = 0.1 + math.random() * 0.2
end
function RemotedudeBouncer:update(dt)
  super.update(self, dt)
  -- add in the smoke from remotedude
  if (self.nextsmoke or 0) < game_time then
      local smokex = self.entity.x
      if self.entity.facing_east then
        smokex = smokex - 4
      else
        smokex = smokex + 4
      end
      local angle  = math.atan2(self.entity.y, self.entity.x)

      RemoteSmokeParticles:new(smokex, self.entity.y-25, 2, 2, 0.014 + math.random() * 0.01, 0.4 + math.random() * 0.1, angle + PI)
      self.nextsmoke = game_time + self.smoketime + math.random() * math.random() * 0.2
  end
end

return RemotedudeBouncer
