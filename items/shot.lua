local shot = class('shot')

local hit, mx, mt, mt, nx, ny
function shot:update(dt)
  -- check for timeout
  if self.duration and self.duration:finished() then
    if self.timeout then self:timeout() end
    self:die()
    return
  end

  if self.custom_update then
    self:custom_update(dt)
  end

  -- collide: first with tiles, then mobs
  if self.collides_with_map then
    hit, mx, my, mt, nx, ny = collision.aabb_room_sweep(self, self.dx * dt, self.dy * dt)
  else
    hit = nil
    mx, my = self.x + self.dx * dt, self.y + self.dy * dt
    mt = 1
    nx, ny = 0, 0
  end

  if self.collides_with_enemies then
   for j,z in pairs(enemies) do
     hx, hy, ht = collision.aabb_sweep(self, z, self.dx * dt, self.dy * dt)
     if ht and ht < mt then
       hit = {"enemy", j}
       mt, mx, my = ht, hx, hy
     end
   end
  end

  if self.collides_with_player and player.iframe_end_time < game_time then
    hx, hy, ht = collision.aabb_sweep(self, player, self.dx * dt, self.dy * dt)
    if ht and ht < mt then
      hit = {"player", player}
      mt, mx, my = ht, hx, hy
    end
  end

  self.x = mx
  self.y = my

  -- now, if we hit something, react
  if hit then
    self:collide(hit, mx, my, mt, nx, ny)
  end
end

function shot:die()
  shots[self.id] = nil
end

function shot:draw()
  if self.duration then
    love.graphics.setColor(255, 255, 255, 255 * math.min(1, 5.5 - 5 * self.duration:t()))
  end
  love.graphics.draw(image[self.sprite], camera.view_x(self), camera.view_y(self), math.atan2(self.dy, self.dx), 1, 1,
    image[self.sprite]:getWidth()/2, image[self.sprite]:getHeight()/2)
  love.graphics.setColor(255,255,255,255)
end


return shot
