local enemy = class('enemy', mob)

function enemy.init()
    --enemy.next_attack = game_time
    --enemy.wake_time = game_time
end

function enemy:update(dt)
    if self.next_attack == nil then
      self.next_attack = game_time
    end

    playerloc = cpml.vec2(player.x, player.y)
    meloc = cpml.vec2(self.x, self.y)
    if playerloc:dist(meloc) <= 10 then
      if game_time >= self.next_attack or 0 then
        -- attack
        player:be_attacked(10, math.atan2(player.y - self.y, player.x - self.x))
        self.next_attack = game_time + .4 + love.math.random(.1)
      end
    end

  if game_time >= self.wake_time then
    -- stagger around randomly, i guess
--   angle = love.math.random() * math.pi * 2
-- if we can, move towards player
angle = playerloc:angle_to(meloc)

    self.dx = math.cos(angle) * self.speed
    self.dy = math.sin(angle) * self.speed

    -- face the direction we're going

    self.wake_time = game_time + love.math.random() * 1
  end

  self:run_ai()

  self:update_position(dt)
  self:update_animation(dt)
end

function enemy:die()
  enemy_count = enemy_count - 1
  sound_manager.play(self.death_sound)
  if enemy_count == 0 then
    -- end the room after a brief delay
    delay.start(1, function() current_room:coda() end)
  end
  enemies[self.id] = nil
end


function enemy:run_ai()
    -- if we are adjacent to player, attack
    -- else try to pathfind to player

end


return enemy
