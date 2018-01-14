local spark = class('spark')

function spark:update(dt)
  if self.duration:finished() then
    self:die()
  else
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

    self.dx = self.dx - self.dx * 16 * dt
    self.dy = self.dy - self.dy * 16 * dt
    -- hit, mx, my, mt, nx, ny = collision.aabb_room_sweep(self, self.dx * dt, self.dy * dt)
    -- self.x = mx
    -- self.y = my
    -- if nx ~= 0 then self.dx = -self.dx end
    -- if ny ~= 0 then self.dy = -self.dy end
  end
end

function spark:die()
  sparks[self.id] = nil
end

function spark:draw()
  love.graphics.setColor(self.color.r, self.color.g, self.color.b, 255 - 255 * self.duration:t())
  love.graphics.draw(image[self.sprite], camera.view_x(self), camera.view_y(self),
    self.r or 0, self.sx or 1, self.sy or 1, self.sprite_hwidth, self.sprite_hheight)
  love.graphics.setColor(255, 255, 255, 255)
end


return spark
