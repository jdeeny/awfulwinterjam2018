local super = require 'enemies/ai/seeker'
local Remotedude = class("Remotedude", super)  -- subclass seeker

function Remotedude:initialize(entity)
  super.initialize(self, entity)
  self.israndom = 0.1
  self.nextsmoke = game_time + math.random()
  self.smoketime = 0.1 + math.random() * 0.2
end

function Remotedude:update(dt)
  super.update(self, dt) -- call update from `Seeker` to do the movement portion
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

return Remotedude
