local super = require 'enemies/ai/seeker'
local Rocketeer = class("Rocketeer", super)  -- subclass seeker

function Rocketeer:initialize(entity)
  super.initialize(self, entity)

  self.wake_time = game_time
  self.state = "moving"
  self.reload_time = 3.0
  self.nextshot_time = 0
end

function Rocketeer:update(dt)
  if not self.stun and not self.force_move then
    if game_time > self.wake_time then
      -- consider what to do
      if self.state == "moving" then
        -- maybe we should switch to firing?
        if love.math.random() < (self.reliability or 0.75)
          and (self.entity.x - player.x) * (self.entity.x - player.x) + (self.entity.y - player.y) * (self.entity.y - player.y) < 300000 + 150000 * love.math.random()
          and self.entity:canSee(player) then
          self.state = "firing"
          self.nextshot_time = game_time + 0.125 + love.math.random()
        end
      else
        -- maybe we should switch to moving?
        if love.math.random() < 0.25
          or (self.entity.x - player.x) * (self.entity.x - player.x) + (self.entity.y - player.y) * (self.entity.y - player.y) > 300000 + 150000 * love.math.random()
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
      self.entity:aimAt(player)
      if self.entity.aim then
        local sin = math.sin(self.entity.aim)
        local cos = math.cos(self.entity.aim)
        if sin < 0 then
          self.entity.facing_north = true
        else
          self.entity.facing_north = false
        end

        if cos < 0 then
          self.entity.facing_east = false
        else
          self.entity.facing_east = true
        end
        self.facing_override = true
      end
      self.entity:stopMoving()
      if self.nextshot_time < game_time then
        self.entity:shootAt(player)
        self.nextshot_time = game_time + self.reload_time
      end
    end
  end
end

return Rocketeer
