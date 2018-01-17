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

function enemy:stopMoving()
  self.dx = 0
  self.dy = 0
end

function enemy:faceTowards(entity)
  local angle = math.atan2(entity.y - self.y, entity.x - self.x)
  --self.rot = cpml.vec2.to_polar(cpml.vec2.new(aim_x, aim_y))
end

function enemy:shootAt(entity)
  self.aim = math.atan2(entity.y - self.y, entity.x - self.x)
  --self.aim = cpml.vec2.to_polar(cpml.vec2.new(entity.x - self.x, entity.y - self.y))
  if self.equipped_items['weapon'] then
    self.equipped_items['weapon']:_fire(player)
  end
end

function enemy:take_damage(damage, silent, angle, force)
  if self.hp and self.hp > 0 then
    self.hp = math.max(0, self.hp - damage)

    if not silent then
      camera.bump(5 * force)
      self:be_stunned(0.1 * force)
      self:be_knocked_back(0.1 * force, 100 * force * math.cos(angle), 100 * force * math.sin(angle))
    end
    if self.hp <= 0 then
      self:die()
    end
  end
end

function enemy:die()
  if self.dead then return end
  self.dead = true
  self.personality = nil
  current_level:addBody(self.body or 'deadbody', self.x, self.y)
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
