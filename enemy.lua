local enemy = class('enemy', mob)

function enemy:update(dt)
  if game_time >= self.wake_time then
    -- stagger around randomly, i guess
    local angle = love.math.random() * math.pi * 2

    self.dx = math.cos(angle) * self.speed
    self.dy = math.sin(angle) * self.speed

    -- face the direction we're going
    self.rot = angle

    self.wake_time = game_time + love.math.random() * 3
  end

  self:update_position(dt)
end

function enemy:die()
  enemies[self.id] = nil
end

return enemy
