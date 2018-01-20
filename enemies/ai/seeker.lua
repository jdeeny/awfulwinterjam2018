local Seeker = class("Seeker", Ai)

local PI = 3.14159
function Seeker:initialize(entity)
  Ai.initialize(self, entity)
  self.israndom = 0.05
end

function Seeker:update(dt)
  Ai.update(self, dt) -- call superclass constructor
  local need_goal = not self.goal_x or math.abs(self.entity.x - self.goal_x) + math.abs(self.entity.y - self.goal_y) < 16
  if not self.entity.dx or game_time >= self.entity.wake_time or need_goal then
  	if need_goal then
  		local gx, gy = current_level:pos_to_grid(self.entity.x), current_level:pos_to_grid(self.entity.y)
  		local dx, dy = pathfinder.hill_climb(gx, gy)
  		self.goal_x = TILESIZE * (gx + dx + 0.5)
  		self.goal_y = TILESIZE * (gy + dy + 0.5)
  	end
    local angle = math.atan2(self.goal_y - self.entity.y, self.goal_x - self.entity.x)
    if self.israndom and math.random() < self.israndom then
      angle = angle + math.random() * PI - PI / 2
    end
    self.angle = angle
    self.entity.wake_time = game_time + 0.05 + love.math.random() * 1
  end
  self.entity.dx = math.cos(self.angle) * self.entity.speed
  self.entity.dy = math.sin(self.angle) * self.entity.speed
end

return Seeker
