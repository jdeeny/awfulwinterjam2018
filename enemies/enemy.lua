local enemy = class('enemy', mob)

function enemy:update(dt)
  self.ai:update(dt)
  self:update_position(dt)

  self:update_animation(dt)
end

function enemy:update_move_controls()
--[[  if not self.dx or game_time >= self.wake_time then
    angle = math.atan2(player.y - self.y, player.x - self.x)

    self.dx = math.cos(angle) * self.speed
    self.dy = math.sin(angle) * self.speed

    self.wake_time = game_time + love.math.random() * 1
  end]]
end

function enemy:canSee(entity)
  return false
end

function enemy:stopMoving()
  self.dx = 0
  self.dy = 0
end

function enemy:faceTowards(entity)
  angle = math.atan2(entity.y - self.y, entity.x - self.x)
end

function enemy:shootPlayer()
end

function enemy:die()
  if self.dead then return end
  self.dead = true
  self.personality = nil
  enemy_value = enemy_value - self.value
  enemies[self.id] = nil
  current_level:remove(self.id)
  audiomanager:playOnce(self.death_sound)
  if enemy_value <= 0.01 and spawner.wave_count == 0 then
    -- end the room after a brief delay
    delay.start(1, function() current_room:coda() end)
  end
end

return enemy
