local enemy = class('enemy', mob)

function enemy:update(dt)
  self:update_position(dt)
  self.facing = self:get_facing_string()
  self:update_animation(dt)
end

function enemy:update_move_controls(dt)
--[[  if not self.dx or game_time >= self.wake_time then
    angle = math.atan2(player.y - self.y, player.x - self.x)

    self.dx = math.cos(angle) * self.speed
    self.dy = math.sin(angle) * self.speed

    self.wake_time = game_time + love.math.random() * 1
  end]]
  self.ai:update(dt)

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

function enemy:take_damage(damage, silent, angle, force, stunning)
  local angle = angle or 0
  local force = force or 0
  local stunning = stunning or false
  if self.hp and self.hp > 0 then
    self.hp = math.max(0, self.hp - damage)
    if self.bleeds then
      if player.equipped_items['weapon'].name == 'ProjectileGun' then
        BloodParticles:new(self.x, self.y, 5, 5, angle, (.5+math.sqrt(force) + math.random() + math.random() * force)/7, ((1.3+math.sqrt(damage)*0.5 + .5 * math.random() * math.random())/2)/1.3, 2+damage / 6 + damage * math.random()*.75)
      elseif player.equipped_items['weapon'].name == 'LightningGun' then
        if math.random() > 0.6 then
          BloodParticles:new(self.x, self.y, 5, 5, angle, (.5+math.sqrt(force) + math.random() + math.random() * force)/7, ((1.3+math.sqrt(damage)*0.5 + .5 * math.random() * math.random())/2)/2.3, 2+damage / 6 + damage * math.random()*.35)
        end
      end
    end
    if not silent then
      camera.bump(5 * force)
      if stunning then
        self:be_stunned(0.1 * force)
      end
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
  if self.drop_items then
    for _, drop_item in pairs(self.drop_items) do
      if math.random() < drop_item.chance then
        item_data.spawn(drop_item.item, self.x+30*(math.random()-0.5),
          self.y+30*(math.random()-0.5))
        --break
      end
    end
  end
  spawner.test_completion()
end

return enemy
