local super = require 'enemies/ai/seeker'
local Rifleman = class("Rifleman", super)  -- subclass seeker

function Rifleman:initialize(entity)
  super.initialize(self, entity)

  self.wake_time = game_time
  self.state = "moving"
  self.reload_time = 2.0
  self.nextshot_time = 0
end

function Rifleman:update(dt)
  if not self.stun and not self.force_move then
    if game_time > self.wake_time then
      -- consider what to do
      if self.state == "moving" then
        -- maybe we should switch to firing?
        if love.math.random() < (self.reliability or 0.75)
          and (self.entity.x - player.x) * (self.entity.x - player.x) + (self.entity.y - player.y) * (self.entity.y - player.y) < 102400 + 80000 * love.math.random()
          and self.entity:canSee(player) then
          self.state = "firing"
          self.nextshot_time = game_time + math.random() * 0.25
        end
      else
        -- maybe we should switch to moving?
        if love.math.random() < 0.25
          or (self.entity.x - player.x) * (self.entity.x - player.x) + (self.entity.y - player.y) * (self.entity.y - player.y) > 102400 + 80000 * love.math.random()
          or not self.entity:canSee(player) then
          self.state = "moving"
        end
      end
      self.wake_time = game_time + 0.5 + love.math.random()
    end

    if self.state == "moving" then
      super.update(self, dt) -- call update from `Seeker` to do the movement portion
      if self.entity.dy ~= 0 or self.entity.dx ~= 0 then
        self.entity.aim = math.atan2(self.entity.dy or 0, self.entity.dx or 0)
      end
    elseif self.state == "firing" then
      -- shoot at the player
      self.entity:faceTowards(player)
      self.entity:aimAt(player)
      self.entity:stopMoving()
      if self.nextshot_time < game_time then
        self.entity:shootAt(player)
        self.nextshot_time = game_time + self.reload_time
      end
    end
  end
end

return Rifleman
