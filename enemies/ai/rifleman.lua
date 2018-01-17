local super = require 'enemies/ai/seeker'
local Rifleman = class("Rifleman", super)  -- subclass seeker

function Rifleman:initialize(entity)
  super.initialize(self, entity)

  self.reload_time = 2.0
  self.nextshot_time = game_time + self.reload_time
end


function Rifleman:update(dt)
  super.update(self, dt)

  -- if we can see the player we will stand still and shoot at them
  if self.entity:canSee(player) then
    self.entity:faceTowards(player)
    self.entity:stopMoving()
    if self.nextshot_time < game_time then
      self.entity:shootAt(player)
      self.nextshot_time = game_time + reload_time
    elseif self.lockon then
      self.entity:lockOn(player)
    end
  end

end

return Rifleman
