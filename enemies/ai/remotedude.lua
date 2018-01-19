local super = require 'enemies/ai/seeker'
local Remotedude = class("Remotedude", super)  -- subclass seeker

function Remotedude:initialize(entity)
  super.initialize(self, entity)

  self.reload_time = 2.0
  self.nextshot_time = game_time + self.reload_time * 0.2 * math.random() + self.reload_time * 0.9
end


function Remotedude:update(dt)
  super.update(self, dt) -- call update from `Seeker` to do the movement portion
  print('update')

  print(self.animation)
  if self.entity.animation then
    print(self.entity.animation.position)
    if self.entity.animation.position == 1 then
      print("smoke")
      SmokeParticles:new(self.entity.x, self.entity.y, 5, 2, .07, .1)
    end
  end

  if math.random() < 0.2 then
    SmokeParticles:new(self.entity.x, self.entity.y, 5, 2, .07, .1)
  end

end

return Remotedude
