local super = require 'enemies/ai/seeker'
local Rifleman = class("Rifleman", super)  -- subclass seeker

function Rifleman:initialize(entity)
  super.initialize(self, entity)

  self.reload_time = 2.0
  self.nextshot_time = game_time + self.reload_time * 0.2 * math.random() + self.reload_time * 0.9
end


function Rifleman:update(dt)
  super.update(self, dt) -- call update from `Seeker` to do the movement portion

  -- if we can see the player (have LOS) we will stand still and shoot at them
  if self.entity:canSee(player) and not self.stun and not self.force_move then
    if not self.hasseen then
      self.hasseen = true
      self.nextshot_time = game_time + math.random() * 0.25
    end
    self.entity:faceTowards(player)
    self.entity:stopMoving()
    if self.nextshot_time < game_time then
      self.entity:shootAt(player)
      self.nextshot_time = game_time + self.reload_time
    elseif self.lockon then
      self.entity:lockOn(player)
    end
  else
    self.hasseen = false
  end

end

return Rifleman
