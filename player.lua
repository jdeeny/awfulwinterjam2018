local player = mob:new()

player.sprite = "dude"
player.speed = 300
player.radius = 20
player.max_hp = 100
player.hp = 100
player.next_shot_time = 0
player.shot_delay = 0.1
player.shot_speed = 800


local mousemoved = false

function player.update(dt)
  local move_x, move_y = player_input:get('move')

  local DEADBAND = 0.2

  player.dx = move_x > DEADBAND and player.speed or move_x < -DEADBAND and -player.speed or 0
  player.dy = move_y > DEADBAND and player.speed or move_y < -DEADBAND and -player.speed or 0

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
  -- check if we're standing on a doodad
  for _,z in pairs(doodads) do
    if collision.aabb_aabb(player, z) then
      z:trigger()
    end
  end

  -- get aiming vector
  local aim_x, aim_y = player_input:get('aim')

  if math.abs(aim_x) < DEADBAND then
    aim_x = 0
  end

  if math.abs(aim_y) < DEADBAND then
    aim_y = 0
  end

  -- rotate to direction we're aiming. if the mouse has moved, face the mouse
  -- position, otherwise update the rotation from keyboard and gamepad
  local r, theta
  if aim_x ~= 0 or aim_y ~= 0 then
    love.mouse.setVisible(false)
    r, theta = cpml.vec2.to_polar(cpml.vec2.new(aim_x, aim_y))
    player.rot = theta
  elseif mousemoved then
    love.mouse.setVisible(true)
    mousemoved = false

    mx, my = love.mouse.getPosition()
    pvec = cpml.vec2.new(player.x-camera.x, player.y-camera.y)
    mvec = cpml.vec2.new(mx, my)
    r, theta = cpml.vec2.to_polar(mvec-pvec)
    player.rot = theta
  end
end


function love.mousemoved( x, y, dx, dy, istouch )
  mousemoved = true
end

function player.die()
  love.events.push("quit")
end

function player:be_attacked(damage)
    self.hp = math.max(self.hp - damage, 0)
end

function player:draw_hp()
	--love.graphics.setFont(timer.font)
	love.graphics.print(self.hp, 690, 50)
end

return player
