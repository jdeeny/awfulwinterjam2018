local player = {
  sprite = "dude",
  speed = 300,
  radius = 40,
  next_shot_time = 0,
  shot_delay = 0.1,
  shot_speed = 800,
  }

function player.draw()
  love.graphics.draw(image[player.sprite], camera.view_x(player), camera.view_y(player), player.rot, 1, 1,
    image[player.sprite]:getWidth()/2, image[player.sprite]:getHeight()/2)
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
  player.rot = math.atan2(reticle.y + camera.y - player.y, reticle.x + camera.x - player.x)

  if game_time >= player.next_shot_time and player_input:down('fire') then
    -- pew pew
    shot_data.spawn("bullet", player.x, player.y, math.cos(player.rot) * player.shot_speed, math.sin(player.rot) * player.shot_speed, "player")
    player.next_shot_time = game_time + player.shot_delay
  end
end

return player
