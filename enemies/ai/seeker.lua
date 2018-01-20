local Seeker = class("Seeker", Ai)

local PI = 3.14159
function Seeker:initialize(entity)
  Ai.initialize(self, entity)
  self.israndom = 0.05
  self.rotspeed = self.entity.rotspeed or 25
  self.curspeed = 0
  self.goalspeed = 0
  self.accel = self.entity.accel or 1
  self.cornering = self.entity.cornering or 1
  self.angle = 0
end

function Seeker:update(dt)
  Ai.update(self, dt) -- call superclass constructor
  local need_goal = not self.goal_x or math.abs(self.entity.x - self.goal_x) + math.abs(self.entity.y - self.goal_y) < 16
  --if not self.entity.dx then --or game_time >= self.entity.wake_time or need_goal then
  	if need_goal then
  		local gx, gy = current_level:pos_to_grid(self.entity.x), current_level:pos_to_grid(self.entity.y)
  		local dx, dy = pathfinder.hill_climb(gx, gy)
  		self.goal_x = TILESIZE * (gx + dx + 0.5) + (math.random() - 0.5) * TILESIZE / 2
  		self.goal_y = TILESIZE * (gy + dy + 0.5) + (math.random() - 0.5) * TILESIZE / 2
  	end
    local newangle = math.atan2(self.goal_y - self.entity.y, self.goal_x - self.entity.x) or 0
    --print("goal: "..self.goal_y..", " ..self.goal_x.."  player: "..player.x..", "..player.y)
    if self.israndom then
      local randomdelta = (math.random() - 0.5) * (PI / 2) * self.israndom * dt
      --print("RANDOM!: " .. randomdelta)
      newangle = newangle + randomdelta
    end
    --print("angle: ".. self.angle.." "..newangle)
    self.cornerslowdown = math.sqrt(math.abs((self.angle or 0) - (newangle or 0))) * self.cornering * dt
    --print("speed: ".. self.entity.speed .." "..self.cornerslowdown)
    if newangle > self.angle then
      self.angle = cpml.utils.clamp(self.angle + self.rotspeed * dt, self.angle, newangle)
    else
      self.angle = cpml.utils.clamp(self.angle - self.rotspeed * dt, newangle, self.angle)
    end

    --print("angle: ".. self.angle.." "..newangle)
    --self.entity.wake_time = game_time + 0.05 + love.math.random() * 0.1
  --end
print(self.cornering)
  if self.goalspeed > self.curspeed then
    self.curspeed = cpml.utils.clamp(self.curspeed + self.accel * dt, self.curspeed, self.goalspeed)
  else
    self.curspeed = cpml.utils.clamp(self.curspeed - self.accel * dt, self.goalspeed, self.curspeed)
  end

  self.entity.dx = math.cos(self.angle) * self.entity.speed * (1-(self.cornerslowdown or 0))
  self.entity.dy = math.sin(self.angle) * self.entity.speed * (1-(self.cornerslowdown or 0))
end

return Seeker
