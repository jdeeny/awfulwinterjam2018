local super = require 'enemies/ai/seeker'
local Charger = class("Charger", super)  -- subclass seeker

function Charger:initialize(entity)
  super.initialize(self, entity)

  self.wake_time = game_time
  self.state = "moving"
  self.next_charge_time = game_time
end

function Charger:update(dt)
  if not self.stun and not self.force_move then
    if game_time > self.wake_time then
      -- maybe we should start charging?
      if self.state == "moving" then
        if game_time > self.next_charge_time and love.math.random() < (self.reliability or 0.75)
          and (self.entity.x - player.x) * (self.entity.x - player.x) + (self.entity.y - player.y) * (self.entity.y - player.y) < 102400 + 80000 * love.math.random()
          and self.entity:canSee(player) then
            -- DESTROY
          self.state = "preparing"
          self.charge_start_time = game_time + 0.125 + math.random() * 0.125
        end
      end
      self.wake_time = game_time + 0.25 + love.math.random() * 0.5
    end

    if self.state == "moving" then
      super.update(self, dt) -- call update from `Seeker` to do the movement portion
    elseif self.state == "preparing" then
      self.entity:faceTowards(player)
      self.entity:aimAt(player)
      self.entity:stopMoving()
      if game_time > self.charge_start_time then
        -- GO
        self.state = "charging"
      end
    elseif self.state == "charging" then
      local speed = self.entity.speed * (1 + 3 * (game_time - self.charge_start_time))
      self.entity.dx = math.cos(self.entity.aim) * speed
      self.entity.dy = math.sin(self.entity.aim) * speed
    end
  end
end

function Charger:react_to_collision(normal_x, normal_y)
  if self.state == "charging" then
    -- ouch
    self.state = "moving"
    for i = 1, 8 do
      angle = math.atan2(normal_y, normal_x) + (love.math.random() - 0.5) * math.pi
      speed = 200 + 1800 * love.math.random()
      spark_data.spawn("spark", {r=255, g=255, b=255}, self.entity.x - 32 * normal_x, self.entity.y - 32 * normal_y, speed * math.cos(angle), speed * math.sin(angle))
    end
    for i = 1, 6 do
      angle = math.atan2(normal_y, normal_x) + (love.math.random() - 0.5) * math.pi
      speed = 200 + 1000 * love.math.random()
      spark_data.spawn("spark_big", {r=255, g=255, b=255}, self.entity.x - 32 * normal_x, self.entity.y - 32 * normal_y, speed * math.cos(angle), speed * math.sin(angle))
    end
    self.entity:be_stunned(1)
    self.entity:be_knocked_back(1, 100 * math.cos(self.entity.aim + math.pi), 100 * math.sin(self.entity.aim + math.pi))
    self.next_charge_time = game_time + 1 + 3*love.math.random()
  end
end

return Charger
