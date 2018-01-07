local player = {
  sprite = love.graphics.newImage("assets/sprites/dude.png"),
  speed = 300,
  radius = 40,
  }

function player.draw()
  love.graphics.draw(player.sprite, camera.view_x(player), camera.view_y(player), player.rot-math.pi/2, 1, 1,
    player.sprite:getWidth()/2, player.sprite:getHeight()/2)
end

function player.update(dt)
  local input_x, input_y = player_input:get 'move'

  local DEADBAND = 0.2

  player.dx = input_x > DEADBAND and player.speed or input_x < -DEADBAND and -player.speed or 0
  player.dy = input_y > DEADBAND and player.speed or input_y < -DEADBAND and -player.speed or 0

  if player.dx ~= 0 and player.dy ~= 0 then
    -- 1/sqrt(2)
    player.dx = player.dx * 0.7071
    player.dy = player.dy * 0.7071
  end

  -- collide with the map
  hit, mx, my, m_time, nx, ny = collision.aabb_map_sweep(player, player.dx * dt, player.dy * dt)

  if hit then
    dot = player.dx * ny - player.dy * nx

    player.dx = dot * ny
    player.dy = dot * (-nx)

    if m_time < 1 then
      -- now try continuing our movement along the new vector
      hit, mx, my, m_time, nx, ny = collision.aabb_map_sweep({x = mx, y = my, radius = player.radius},
                                       player.dx * dt * (1 - m_time), player.dy * dt * (1 - m_time))
    end
  end

  player.x = mx
  player.y = my

  -- rotate to face the reticle
  player.rot = math.atan2(player.y - reticle.y - camera.y, player.x - reticle.x - camera.x)
end

return player
