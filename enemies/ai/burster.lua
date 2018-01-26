local super = require 'enemies/ai/seeker'
local Burster = class("Burster", super)  -- subclass seeker

function Burster:initialize(entity)
  super.initialize(self, entity)

  self.wake_time = game_time
  self.state = "moving"
  self.reload_time = 2.0
  self.nextshot_time = 0
  self.burst_count = 0
  self.burst_size = 5
  self.burst_time = 0.1
end

function Burster:update(dt)
  if not self.stun and not self.force_move then
    if game_time > self.wake_time then
      -- consider what to do
      if self.state == "moving" then
        -- maybe we should switch to firing?
        if self.nextshot_time < game_time and love.math.random() < (self.reliability or 0.75)
          and (self.entity.x - player.x) * (self.entity.x - player.x) + (self.entity.y - player.y) * (self.entity.y - player.y) < 202400 + 80000 * love.math.random()
          and self.entity:canSee(player) then
          self.state = "firing"
          self.burst_count = 0
          self.nextshot_time = game_time + math.random() * 0.25
        end
      else
        -- maybe we should switch to moving?
        if self.burst_count >= self.burst_size then
          self.state = "moving"
          self.nextshot_time = game_time + self.reload_time
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
      if self.nextshot_time < game_time and self.burst_count < self.burst_size then
        self.entity:shootAt(player)
        self.burst_count = self.burst_count + 1
        self.nextshot_time = game_time + self.burst_time
      end
    end
  end
end

return Burster
