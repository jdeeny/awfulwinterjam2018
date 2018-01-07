local player = mob:new()

player.sprite = "dude"
player.speed = 300
player.radius = 40
player.max_hp = 100
player.hp = 100
player.next_shot_time = 0
player.shot_delay = 0.1
player.shot_speed = 800

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

  if game_time >= player.next_shot_time and player_input:down('fire') then
    -- pew pew
    shot_data.spawn("bullet", player.x, player.y, math.cos(player.rot) * player.shot_speed, math.sin(player.rot) * player.shot_speed, "player")
    player.next_shot_time = game_time + player.shot_delay
  end

  player:update_position(dt)

  -- rotate to face the reticle
  player.rot = math.atan2(reticle.y + camera.y - player.y, reticle.x + camera.x - player.x)
end

function player.die()
  love.events.push("quit")
end

return player
