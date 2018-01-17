local Wanderer = class("Wanderer", Ai)

function Wanderer:update(dt)
  Ai.update(self, dt) -- call superclass constructor
  if not self.entity.dx or game_time >= self.entity.wake_time then
    angle = 3.14159 * 2 * math.random()

    self.entity.dx = math.cos(angle) * self.entity.speed
    self.entity.dy = math.sin(angle) * self.entity.speed

    self.entity.wake_time = game_time + love.math.random() * 3 + love.math.random()
  end
end

return Wanderer
