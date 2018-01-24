local player = mob:new()

local mousemoved = false
local DEADBAND = 0.2

function player.init()
  player.is_player = true
  player.sprite = 'tesla'
  player.facing_north = false
  player.facing_east = true
  player.speed = 300
  player.radius = 20
  player.max_hp = 40
  player.hp = 40
  player.dying = false
  player.stun = nil
  player.iframe_end_time = 0
  player.shot_delay = 0.1
  player.shot_speed = 800
  player.weapon = 1
  player.weapon_max = 3
  player.weapons = { weapon.ProjectileGun:new(), weapon.LightningGun:new(),
    weapon.RayGun:new() }

  player.animations = {}
  player.animations['run_ne'] = animation.tesla_run_ne
  player.animations['run_se'] = animation.tesla_run_se
  player.animations['run_sw'] = animation.tesla_run_sw
  player.animations['run_nw'] = animation.tesla_run_nw
  player.animations['idle_ne'] = animation.tesla_idle_se
  player.animations['idle_se'] = animation.tesla_idle_se
  player.animations['idle_sw'] = animation.tesla_idle_sw
  player.animations['idle_nw'] = animation.tesla_idle_sw
  player.animations['electrocute_e'] = animation.tesla_electrocute_e
  player.animations['electrocute_w'] = animation.tesla_electrocute_w
  player.animation = player.animations['run_sw']
  player.animation_state = 'run'

  player.rot = 0
  player.aim = player.rot
  player.equipped_items = {}
  player:equip('weapon', player.weapons[player.weapon])

  player.electro_time = game_time
  player.next_splash = game_time
  player.splash_delay = 0.12

  player.input_disabled = false
end

function player.update(dt)
  player:update_position(dt)

  local aim_x, aim_y = player_input:get('aim')

  if math.abs(aim_x) < DEADBAND then
    aim_x = 0
  end
  if math.abs(aim_y) < DEADBAND then
    aim_y = 0
  end

  -- the input gets disabled for movies
  if not player.input_disabled then
    if not player.dying then
      -- rotate to direction we're aiming. if the mouse has moved, face the mouse
      -- position, otherwise update the rotation from keyboard and gamepad
      if aim_x ~= 0 or aim_y ~= 0 then
        crosshairs.use_mouse = false
        _, player.aim = cpml.vec2.to_polar(cpml.vec2.new(aim_x, aim_y)) -- joystick angle is new aim
      elseif mousemoved then
        crosshairs.use_mouse = true
        mousemoved = false

        mx, my = love.mouse.getPosition()
        pvec = cpml.vec2.new(player.x-camera.x, player.y-camera.y)
        mvec = cpml.vec2.new(mx, my)
        _, player.aim = cpml.vec2.to_polar(mvec-pvec) -- angle to mouse pos. is new aim
      end

      if player.aim then
        if player.aim >= math.pi then
          player.facing_north = true
        else
          player.facing_north = false
        end

        if player.aim > math.pi * 0.5 and player.aim < math.pi * 1.5 then
          player.facing_east = false
        else
          player.facing_east = true
        end
      end
    end

    -- fire weapon (or not)
    if player.equipped_items['weapon'] then
      -- update all weapons
      for _, w in ipairs(player.weapons) do
        w:update(dt)
      end

      if player_input:pressed('swap') then
        player.weapon_switch(1)
      elseif player_input:pressed('swap_rev') then
        player.weapon_switch(-1)
      elseif player_input:pressed('weap1') then
        player.weapon_switch_direct(1)
      elseif player_input:pressed('weap2') then
        player.weapon_switch_direct(2)
      elseif player_input:pressed('weap3') then
        player.weapon_switch_direct(3)
      end

      if (aim_x ~= 0 or aim_y ~= 0 or player_input:down('fire')) and not player.stun and not player.force_move and not player.dying then
        player.equipped_items['weapon']:fire()
      else
        player.equipped_items['weapon']:release()
      end
    end
  end

  if not player.dying then
    -- check if we're standing on a doodad
    for _,z in pairs(doodads) do
      if collision.aabb_aabb(player, z) then
        z:trigger()
      end
    end

    -- check to see if we can interact with items
    for _,itm in pairs(items) do
      if collision.aabb_aabb(player, itm) and itm.pick_up then
        itm:pick_up(player)
      end
    end

    -- ...or if we touched an enemy
    if player.iframe_end_time < game_time then
      for _,z in pairs(enemies) do
        if z.touch_damage > 0 and collision.aabb_aabb(player, z) then
          player:take_damage(z.touch_damage, false, math.atan2(player.y - z.y, player.x - z.x), 5, true)
          break
        end
      end
    end
  end

  player.animation = player.animations[player.animation_state .. '_' .. player.get_facing_string(player.facing_north, player.facing_east)]
  for _, anim in pairs(player.animations) do
    anim:update(dt)
  end
  if (player.electro_time or 0) > game_time then
    if player.facing_east then
      player.animation = player.animations['electrocute_e']
    else
      player.animation = player.animations['electrocute_w']
    end
  end
end

function player.update_move_controls()
  local move_x, move_y = player_input:get('move')

  if not player.input_disabled then
    player.dx = move_x > DEADBAND and player.speed or move_x < -DEADBAND and -player.speed or 0
    player.dy = move_y > DEADBAND and player.speed or move_y < -DEADBAND and -player.speed or 0

    if math.abs(player.dx) >= 0.01 and math.abs(player.dy) >= 0.01 then
      -- 1/sqrt(2)
      player.dx = player.dx * 0.7071
      player.dy = player.dy * 0.7071
    end
  end
end

function love.mousemoved( x, y, dx, dy, istouch )
  mousemoved = true
end

function player.die()
  player.dying = true
  if player.equipped_items then
    for _ , x in pairs(player.equipped_items) do
      if x.release then
        x:release()
      end
    end
  end
  fade.start_fade("fadeout", 3, true)
  delay.start(3, function() death.enter() end)
end

function player:take_damage(damage, silent, angle, force, stunning)
  local angle = angle or 0
  local force = force or 0
  local stunning = stunning or false

  if self.hp and self.hp > 0 then
    self.hp = math.max(0, self.hp - damage)
    BloodParticles:new(self.x, self.y, 5, 5, angle, (.5+math.sqrt(force) + math.random() + math.random() * force)/7, (1.3+math.sqrt(damage)*0.5 + .5 * math.random() * math.random())/2, 2+damage / 4 + damage * math.random())

    if not silent then
      if self.hp > 0 then
        play.flash_screen(255, 100, 50, 64, 0.05 * force)
        play.freezeframe(0.03 * force)
        camera.shake(2 * force, 0.1 * force)
        if stunning then
          self:be_stunned(0.1 * force)
        end
        self:be_knocked_back(0.1 * force, 100 * force * math.cos(angle), 100 * force * math.sin(angle))
      else
        play.flash_screen(255, 100, 50, 128, 1)
        play.freezeframe(0.3)
        camera.shake(15, 1)
        self:be_stunned(1)
        self:be_knocked_back(1, 600 * math.cos(angle), 600 * math.sin(angle))
      end
    end

    if self.hp <= 0 then
      self.be_invincible(99999)
      self:die()
    else
      self.be_invincible(1)
    end
  end
end

function player:heal(hp)
  self.hp = math.min(self.hp+hp, self.max_hp)
end

function player.weapon_switch(rev)
  local inc = rev or 1
  player.weapon = player.weapon + inc
  if player.weapon > player.weapon_max then player.weapon = 1 end
  if player.weapon <= 0 then player.weapon = player.weapon_max end

  if #player.weapons > 1 then
    player.equipped_items['weapon']:release()
    player:unequip('weapon')
    player:equip('weapon', player.weapons[player.weapon])
    play.crosshair_offset = 0
  end

end

function player.weapon_switch_direct(weap)
  local w = weap or 1
  player.weapon = w
  if player.weapon > player.weapon_max then player.weapon = 1 end
  if player.weapon <= 0 then player.weapon = player.weapon_max end

  if #player.weapons > 1 then
    player.equipped_items['weapon']:release()
    player:unequip('weapon')
    player:equip('weapon', player.weapons[player.weapon])
    play.crosshair_offset = 0
  end

end


function player.be_invincible(duration)
  player.iframe_end_time = game_time + duration
end

return player
