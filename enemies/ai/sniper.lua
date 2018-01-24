local super = require 'enemies/ai/seeker'
local Sniper = class("Sniper", super)  -- subclass seeker

function Sniper:initialize(entity)
  super.initialize(self, entity)

  self.wake_time = game_time
  self.state = "moving"
  self.reload_time = 2.0
  self.nextshot_time = 0
  self.scope_angle = 0
  self.shot_confidence = 0
end

function Sniper:update(dt)
  if not self.stun and not self.force_move then
    if game_time > self.wake_time then
      -- consider what to do
      if self.state == "moving" then
        -- maybe we should switch to firing?
        if love.math.random() < (self.reliability or 0.75)
          and self.entity:canSee(player) then
          self.state = "firing"
          self.confidence = 0
          self.entity.scoping = false
          self.nextshot_time = game_time + math.random() * 0.25
        end
      else
        -- maybe we should switch to moving?
        if not self.entity.scoping and love.math.random() < 0.3
          or not self.entity:canSee(player) then
          self.state = "moving"
          self.entity.scoping = false
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
      if self.nextshot_time >= game_time then
        -- just look at the player, we can't start scoping in yet
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
      else
        if not self.entity.scoping then
          -- start scoping in on the player
          self.scope_angle = math.atan2(player.y - self.entity.y, player.x - self.entity.x)
          self.shot_confidence = 0
          self.entity.scoping = true
          self.scope_start_time = game_time
        elseif self.scope_fire_time then
          if game_time > self.scope_fire_time then
            if self.entity.equipped_items['weapon'] then
              self.entity.equipped_items['weapon']:_fire(player)
            end
            self.nextshot_time = game_time + self.reload_time
            self.entity.scoping = false
            self.scope_fire_time = nil
          end
        else
          if self.shot_confidence > 1 then
            -- locked on
            self.scope_fire_time = game_time + 0.2
          else
            -- shift our aim towards the player
            local a = math.atan2(player.y - self.entity.y, player.x - self.entity.x) - self.scope_angle

            if (a > math.pi) then
              a = a - math.pi * 2
            elseif (a < -math.pi) then
              a = a + math.pi * 2
            end

            self.scope_angle = self.scope_angle + a * (math.min(1, dt * 0.95))

            -- gain confidence if we're close to the target
            if game_time > self.scope_start_time + 0.2 and math.abs(a) < 0.25 then
              self.shot_confidence = self.shot_confidence + dt * (1 - 5 * math.abs(a))
            else
              self.shot_confidence = math.max(0, self.shot_confidence - dt)
            end
          end
        end

        self.entity.aim = self.scope_angle
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
      end
    end
  end
end

return Sniper
