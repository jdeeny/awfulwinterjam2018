local Particles = class("Particles")

function Particles:initialize(x, y, w, h, lifetime)
  self.x, self.y = x, y
  self.w = w or 10
  self.h = h or 10
  self.lifetime = lifetime or 5
  self.id = "particles" .. math.random()
  self.kind = "particles"
  self.psystem = nil
end

function Particles:update(dt)
  if self.psystem then
    self.psystem:update(dt)
  end
  if self.lifetime and self.lifetime < game_time then
    --current_level:remove(self.id)
    --self.psystem = nil
  end
end

function Particles:draw()
  if self.psystem then
    love.graphics.draw(self.psystem, camera.view_x(self), camera.view_y(self))
  end
end

return Particles
