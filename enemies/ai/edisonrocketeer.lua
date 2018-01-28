local super = require 'enemies/ai/rocketeer'
local EdisonRocketeer = class("EdisonRocketeer", super)  -- subclass seeker

function EdisonRocketeer:initialize(entity)
  super.initialize(self, entity)

  self.reload_time = 2.0
  self.next_spawn = game_time+3
  self.nextshot_time = 0
  --self.state = 'takeoff'
  self.fly_time = game_time + 5
end

function EdisonRocketeer:update(dt)
  super.update(self, dt)
--[[if game_time > self.wake_time then
    -- consider what to do
    if self.state == "takeoff" and self.fly_time < game_time then
      self.state = 'moving'
      end
  end]]

  if self.next_spawn < game_time then
    self.next_spawn = game_time + math.random() * 2 + 2.5
    local angle = 1.0471975512 * love.math.random()
    for i = 1, math.random(3) do
      local t = math.random(3)
      if t == 1 then local id = enemy_data.spawn("lumpgoon", self.entity.x, self.entity.y)
      elseif t == 2 then local id = enemy_data.spawn("canbot", self.entity.x, self.entity.y)
      else local id = enemy_data.spawn("rifledude", self.entity.x, self.entity.y)
      end

      local t = 100 + math.random()* 100
      if enemies[id] then
        enemies[id]:be_stunned(t)
        enemies[id]:be_knocked_back(t, 300 * math.cos(angle + 1.0471975512 * i), 300 * math.sin(angle + 1.0471975512 * i))
      end
    end
  end

end

return EdisonRocketeer
