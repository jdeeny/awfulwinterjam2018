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

    self:run_ai()
  end

  self:update_position(dt)
end

function enemy:die()
  enemy_count = enemy_count - 1
  if enemy_count == 0 then
    current_room:coda()
  end
  enemies[self.id] = nil
end


function enemy:run_ai()
    -- if we are adjacent to player, attack
    playerloc = cpml.vec2(player.x, player.y)
    meloc = cpml.vec2(self.x, self.y)
    if playerloc:dist(meloc) < 40 then
        -- attack
    end
    -- else try to pathfind to player

    -- if we can, move towards player
end


return enemy
