local Seeker = class("Seeker", Ai)

function Seeker:update(dt)
  Ai.update(self, dt) -- call superclass constructor
  if not self.entity.dx or game_time >= self.entity.wake_time then
    angle = math.atan2(player.y - self.entity.y, player.x - self.entity.x)

    self.entity.dx = math.cos(angle) * self.entity.speed
    self.entity.dy = math.sin(angle) * self.entity.speed

    self.entity.wake_time = game_time + love.math.random() * 1
  end
end

return Seeker
