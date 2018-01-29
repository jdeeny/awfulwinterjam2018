local super = require 'enemies/ai/rocketeer'
local EdisonRocketeer = class("EdisonRocketeer", super)  -- subclass seeker

function EdisonRocketeer:initialize(entity)
  super.initialize(self, entity)

  self.reload_time = 2.0
  self.next_spawn = game_time+6
  self.next_fireball = game_time + 3
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

  if self.next_fireball and self.next_fireball < game_time then
    self.next_fireball = game_time + math.random() * 2 + 2.0
    local destx, desty = current_level:pos_to_grid(player.x), current_level:pos_to_grid(player.y)
    local dv = cpml.vec2.new(player.x, player.y)
    local sv = cpml.vec2.new(self.entity.x, self.entity.y)
    local radius, theta = (dv - sv):to_polar()
    --print("xy: "..destx.. " "..desty.." "..radius.." "..theta)

    -- shoot fire as projectile
    shot_data.spawn('fireball', self.entity.x + 48 * math.cos(theta), self.entity.y + 48 * math.sin(theta),
        math.cos(theta)*(150),
        math.sin(theta)*(150), self.entity)

  end

end

return EdisonRocketeer
