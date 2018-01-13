local player = mob:new()

local mousemoved = false
local DEADBAND = 0.2

function player.init()
  player.sprite = 'tesla'
  player.facing_north = false
  player.facing_east = false
  player.speed = 300
  player.radius = 20
  player.max_hp = 40
  player.hp = 40
  player.dying = false
  player.stun = nil
  player.iframe_end_time = 1
  player.next_shot_time = 0
  player.shot_delay = 0.1
  player.shot_speed = 800
  player.weapon = 1
  player.weapon_max = 2
  player.weapons = { weapon.ProjectileGun:new(), weapon.LightningGun:new() }

  player.animations = {}
  player.animations['run_ne'] = animation.tesla_run_ne
  player.animations['run_se'] = animation.tesla_run_se
  player.animations['run_sw'] = animation.tesla_run_sw
  player.animations['run_nw'] = animation.tesla_run_nw
  player.animations['idle_ne'] = animation.tesla_idle_se
  player.animations['idle_se'] = animation.tesla_idle_se
  player.animations['idle_sw'] = animation.tesla_idle_sw
  player.animations['idle_nw'] = animation.tesla_idle_sw
  player.animation = player.animations['run_se']

  player.rot = 0
  player.aim = player.rot
  player.equipped_items = {}
  player:equip('weapon', player.weapons[player.weapon])
end

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
    if player.stun then
      if player.stun.end_time > game_time then
        t = 1 - (game_time - player.stun.start_time) / (player.stun.end_time - player.stun.start_time)
        player.dx = player.stun.dx * t
        player.dy = player.stun.dy * t
      else
        player.stun = nil
      end
      player.animation = player.animations['idle_' .. player.get_facing_string(player.facing_north, player.facing_east)]
    elseif player.dying then
      player.animation = player.animations['idle_' .. player.get_facing_string(player.facing_north, player.facing_east)]
    else
      local move_x, move_y = player_input:get('move')

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
    end

    if math.abs(player.dx) >= 0.01 and math.abs(player.dy) >= 0.01 then
      -- 1/sqrt(2)
      player.dx = player.dx * 0.7071
      player.dy = player.dy * 0.7071
    end

    player:update_position(dt)

    if not player.dying then
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

      if player_input:pressed('swap') and player.equipped_items['weapon'] then
        player.weapon_switch()
      end

      -- check if we're standing on a doodad
      for _,z in pairs(doodads) do
        if collision.aabb_aabb(player, z) then
          z:trigger()
        end
      end
    end
  end
end

function love.mousemoved( x, y, dx, dy, istouch )
  mousemoved = true
end

function player.die()
  player.dying = true
  fade.start_fade("fadeout", game_time, game_time + 3, function()
      fade.start_fade("fadein", gui_time, gui_time + 3)
      game_state = 'death'
    end)
end

function player:be_attacked(damage, direction)
  if player.iframe_end_time and player.iframe_end_time < game_time then
    self.hp = math.max(self.hp - damage, 0)
    if self.hp <= 0 then
      play.freezeframe(0.5)
      camera.shake(15, 1)
      player.be_stunned(1, 1000 * math.cos(direction), 1000 * math.sin(direction))
      player.be_invincible(99999)
      self.die()
    else
      play.freezeframe(0.2)
      camera.shake(5, 0.5)
      player.be_stunned(0.5, 500 * math.cos(direction), 500 * math.sin(direction))
      player.be_invincible(1)
    end
  end
end

function player.be_stunned(duration, dx, dy)
  player.stun = {start_time = game_time, end_time = game_time + duration,
                  dx = dx or 0, dy = dy or 0}
end

function player.weapon_switch()
  --player:unequip('weapon')
  player.weapon = player.weapon + 1
  if player.weapon > player.weapon_max then player.weapon = 1 end
  player:equip('weapon', player.weapons[player.weapon])
end


function player.be_invincible(duration)
  player.iframe_end_time = game_time + duration
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
