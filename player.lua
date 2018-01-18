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
  player.next_shot_time = 0
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
  player.animation = player.animations['run_sw']
  player.animation_state = 'run'

  player.rot = 0
  player.aim = player.rot
  player.equipped_items = {}
  player:equip('weapon', player.weapons[player.weapon])
end

function player.update(dt)
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

    -- fire weapon (or not)
    if player.equipped_items['weapon'] then
      player.equipped_items['weapon']:update(dt)

      if player_input:pressed('swap') then
        player.weapon_switch()
      end

      if (aim_x ~= 0 or aim_y ~= 0) or player_input:down('fire') then
        player.equipped_items['weapon']:fire()
      elseif (aim_x == 0 and aim_y == 0) and not player_input:down('fire') then
        player.equipped_items['weapon']:release()
      end

    end

    -- check if we're standing on a doodad
    for _,z in pairs(doodads) do
      if collision.aabb_aabb(player, z) then
        z:trigger()
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
end

function player.update_move_controls()
  local move_x, move_y = player_input:get('move')

  player.dx = move_x > DEADBAND and player.speed or move_x < -DEADBAND and -player.speed or 0
  player.dy = move_y > DEADBAND and player.speed or move_y < -DEADBAND and -player.speed or 0

  if math.abs(player.dx) >= 0.01 and math.abs(player.dy) >= 0.01 then
    -- 1/sqrt(2)
    player.dx = player.dx * 0.7071
    player.dy = player.dy * 0.7071
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

function player.weapon_switch()
  --player:unequip('weapon')
  if player.weapons[player.weapon].release then
    player.weapons[player.weapon]:release()
  end
  player.weapon = player.weapon + 1
  if player.weapon > player.weapon_max then player.weapon = 1 end
  player:equip('weapon', player.weapons[player.weapon])
end


function player.be_invincible(duration)
  player.iframe_end_time = game_time + duration
end

return player
