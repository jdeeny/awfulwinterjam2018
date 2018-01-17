local Seeker = class("Seeker", Ai)

function Seeker:update(dt)
  Ai.update(self, dt) -- call superclass constructor
  local need_goal = not self.goal_x or math.abs(self.entity.x - self.goal_x) + math.abs(self.entity.y - self.goal_y) < 16
  if not self.entity.dx or game_time >= self.entity.wake_time or need_goal then
  	if need_goal then
  		local gx, gy = room.pos_to_grid(self.entity.x), room.pos_to_grid(self.entity.y)
  		local dx, dy = pathfinder.hill_climb(gx, gy)
  		self.goal_x = TILESIZE * (gx + dx + 0.5)
  		self.goal_y = TILESIZE * (gy + dy + 0.5)
  	end
    angle = math.atan2(self.goal_y - self.entity.y, self.goal_x - self.entity.x)

    self.entity.dx = math.cos(angle) * self.entity.speed
    self.entity.dy = math.sin(angle) * self.entity.speed

    self.entity.wake_time = game_time + love.math.random() * 1
  end
end

return Seeker
