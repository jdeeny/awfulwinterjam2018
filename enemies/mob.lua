local mob = class('mob')

function mob:initialize()

	self.dx = 0
	self.dy = 0
  self.equipped_items = {}
end

function mob:draw()
  if self.equipped_items then
    for _ , x in pairs(self.equipped_items) do
      x:draw()
    end
  end

  if self.animation == nil then
    love.graphics.draw(image[self.sprite], camera.view_x(self), camera.view_y(self), self.rot, 1, 1,
      image[self.sprite]:getWidth()/2, image[self.sprite]:getHeight()/2)
  else
    self.animation:draw(image[self.sprite], camera.view_x(self), camera.view_y(self), self.rot, 1, 1,
      32, 48)
  end
end

function mob:update_position(dt)
  if self.force_move then
    -- ignore everything else and just go
    self.x = self.x + self.force_move.dx * dt
    self.y = self.y + self.force_move.dy * dt

    if self.force_move.duration:finished() then
      self.force_move = nil
    end
  else
    if self.stun then
      if self.stun.duration:finished() then
        self.stun = nil
      end
      self.dx = 0
      self.dy = 0
      self.animation_state = 'idle'
    elseif self.dying then
      self.dx = 0
      self.dy = 0
      self.animation_state = 'idle'
    else
      -- now we can actually -choose- where to go
      self:update_move_controls()

      if math.abs(self.dx) >= 0.01 or math.abs(self.dy) >= 0.01 then
        if self.dy >= 0.01 then
          self.facing_north = false
        elseif self.dy <= -0.01 then
          self.facing_north = true
        end

        if self.dx >= 0.01 then
          self.facing_east = true
        elseif self.dx <= -0.01 then
          self.facing_east = false
        end

        self.animation_state = 'run'
      else
        self.animation_state = 'idle'
      end
    end

    -- apply knockback
    if self.knockback then
      if self.knockback.duration:finished() then
        self.knockback = nil
      else
        t = 1 - self.knockback.duration:t()
        self.dx = self.dx + self.knockback.dx * t
        self.dy = self.dy + self.knockback.dy * t
      end
    end

    -- collide with the map
    hit, mx, my, m_time, nx, ny = collision.aabb_room_sweep(self, self.dx * dt, self.dy * dt)

    if hit then
      dot = self.dx * ny - self.dy * nx

      self.dx = dot * ny
      self.dy = dot * (-nx)

      if m_time < 1 then
        -- now try continuing our movement along the new vector
        hit, mx, my, m_time, nx, ny = collision.aabb_room_sweep({x = mx, y = my, radius = self.radius},
                                         self.dx * dt * (1 - m_time), self.dy * dt * (1 - m_time))
      end
    end

    self.x = mx
    self.y = my
  end
end

function mob:update_animation(dt)
  if self.animation ~= nil then
    self.animation:update(dt)
  end
end

function mob:canSee(target)
  return not collision.aabb_room_sweep({x = self.x, y = self.y, radius = 0}, target.x - self.x, target.y - self.y)
end

function mob:be_stunned(dur)
  self.stun = {duration = duration.start(dur)}
end

function mob:be_knocked_back(dur, dx, dy)
  self.knockback = {duration = duration.start(dur),
                  dx = dx or 0, dy = dy or 0}
end

function mob:start_force_move(dur, dx, dy)
  self.force_move = {duration = duration.start(dur),
                  dx = dx or 0, dy = dy or 0}
end

function mob:end_force_move()
  self.force_move = nil
end

function mob:equip(id, item)
  self.equipped_items[id] = item
  self.equipped_items[id]:equipped(self)
end

function mob.unequip(id)
  local tmp = self.equipped_items[id]
  self.equipped_items[id] = nil
  return tmp
end

function mob.get_facing_string(north, east)
  if north then
    if east then
      return 'ne'
    else
      return 'nw'
    end
  else
    if east then
      return 'se'
    else
      return 'sw'
    end
  end
end

return mob
