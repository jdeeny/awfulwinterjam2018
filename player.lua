local player = mob:new()

local mousemoved = false

function player.update(dt)
  for _, anim in pairs(player.animations) do
    anim:update(dt)
  end

  local move_x, move_y = player_input:get('move')

  if player.force_move then
    -- cutscene movement
    player.x = player.x + player.force_move.dx * dt
    player.y = player.y + player.force_move.dy * dt
  else
    local move_x, move_y = player_input:get('move')

    local DEADBAND = 0.2

    player.dx = move_x > DEADBAND and player.speed or move_x < -DEADBAND and -player.speed or 0
    player.dy = move_y > DEADBAND and player.speed or move_y < -DEADBAND and -player.speed or 0

    if math.abs(player.dx) >= 0.01 or math.abs(player.dy) >= 0.01 then
      if player.dy >= 0.01 then
        player.facing_north = false
      elseif player.dy <= -0.01 then
        player.facing_north = true
      end

      if player.dx >= 0.01 then
        player.facing_east = true
      elseif player.dx <= -0.01 then
        player.facing_east = false
      end

      player.animation = player.animations['run_' .. player.get_facing_string(player.facing_north, player.facing_east)]
    else
      player.animation = player.animations['idle_' .. player.get_facing_string(player.facing_north, player.facing_east)]
    end

    if math.abs(player.dx) >= 0.01 and math.abs(player.dy) >= 0.01 then
      -- 1/sqrt(2)
      player.dx = player.dx * 0.7071
      player.dy = player.dy * 0.7071
    end

    player:update_position(dt)

    -- get aiming vector
    local aim_x, aim_y = player_input:get('aim')

    if math.abs(aim_x) < DEADBAND then
      aim_x = 0
    end

    -- rotate to direction we're aiming. if the mouse has moved, face the mouse
    -- position, otherwise update the rotation from keyboard and gamepad

    if aim_x ~= 0 or aim_y ~= 0 then
      love.mouse.setVisible(false)
      _, player.aim = cpml.vec2.to_polar(cpml.vec2.new(aim_x, aim_y)) -- joystick angle is new aim
    elseif mousemoved then
      love.mouse.setVisible(true)
      mousemoved = false

      mx, my = love.mouse.getPosition()
      pvec = cpml.vec2.new(player.x-camera.x, player.y-camera.y)
      mvec = cpml.vec2.new(mx, my)
      _, player.aim = cpml.vec2.to_polar(mvec-pvec) -- angle to mouse pos. is new aim
    end

    player.equipped_items['weapon']:update(dt)

    if player_input:down('fire') and player.equipped_items['weapon'] then
      player.equipped_items['weapon']:fire()
    end

    -- check if we're standing on a doodad
    for _,z in pairs(doodads) do
      if collision.aabb_aabb(player, z) then
        z:trigger()
      end
    end
  end
end


function love.mousemoved( x, y, dx, dy, istouch )
  mousemoved = true
end

function player.die()
  player.start_force_move(0, 0)
  fade.start_fade("fadeout", game_time, game_time + 3, function()
      fade.start_fade("fadein", gui_time, gui_time + 3)
      game_state = 'death'
    end)
end

function player:be_attacked(damage)
  if self.hp > 0 then
    self.hp = math.max(self.hp - damage, 0)
    if self.hp <= 0 then
      self.die()
    end
  end
end

function player.start_force_move(dx, dy)
  player.force_move = {}
  player.force_move.dx = dx
  player.force_move.dy = dy
end

function player.end_force_move()
  player.force_move = nil
end

function player:draw_hp()
	--love.graphics.setFont(timer.font)
	love.graphics.print(self.hp, 690, 50)
end

return player
