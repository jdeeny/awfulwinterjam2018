local mob = class('mob')

function mob:draw()
  love.graphics.draw(image[self.sprite], camera.view_x(self), camera.view_y(self), self.rot, 1, 1,
    image[self.sprite]:getWidth()/2, image[self.sprite]:getHeight()/2)
end

function mob:update_position(dt)
  -- collide with the map
  hit, mx, my, m_time, nx, ny = collision.aabb_map_sweep(self, self.dx * dt, self.dy * dt)

  if hit then
    dot = self.dx * ny - self.dy * nx

    self.dx = dot * ny
    self.dy = dot * (-nx)

    if m_time < 1 then
      -- now try continuing our movement along the new vector
      hit, mx, my, m_time, nx, ny = collision.aabb_map_sweep({x = mx, y = my, radius = self.radius},
                                       self.dx * dt * (1 - m_time), self.dy * dt * (1 - m_time))
    end
  end

  self.x = mx
  self.y = my
end

function mob:take_damage(n)
  if self.hp then
    self.hp = self.hp - n
    if self.hp <= 0 then
      self:die()
    end
  end
end

return mob
