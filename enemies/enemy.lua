local enemy = class('enemy', mob)

function enemy:update(dt)
  self:update_position(dt)

  playerloc = cpml.vec2(player.x, player.y)
  meloc = cpml.vec2(self.x, self.y)
  if playerloc:dist(meloc) <= 10 then
    if game_time >= self.attack_time or 0 then
      -- attack
      player:be_attacked(10, math.atan2(player.y - self.y, player.x - self.x))
      self.attack_time = game_time + .4 + love.math.random(.1)
    end
  end

  self:update_animation(dt)
end

function enemy:update_move_controls()
  if not self.dx or game_time >= self.wake_time then
    angle = math.atan2(player.y - self.y, player.x - self.x)

    self.dx = math.cos(angle) * self.speed
    self.dy = math.sin(angle) * self.speed

    self.wake_time = game_time + love.math.random() * 1
  end
end

function enemy:die()
  enemy_value = enemy_value - self.value
  audiomanager:playOnce(self.death_sound)
  if enemy_value <= 0.01 and spawner.wave_count == 0 then
    -- end the room after a brief delay
    delay.start(1, function() current_room:coda() end)
  end
  enemies[self.id] = nil
end

return enemy
