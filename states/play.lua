local play = { freezeframe_start_time = 0, freezeframe_end_time = 0, draw_cursor = false }

function play.enter()
  state = STATE_PLAY
end

function play.update(dt)

	player_input:update()

  if player_input:pressed('pause') then
    pause.enter()
  else
    mdt = dt * play.game_speed()
    game_time = game_time + mdt

    game_flux.update(mdt)

    player.update(mdt)

    for _,z in pairs(sparks) do
      z:update(mdt)
    end

    spawner.process()
    for _,z in pairs(enemies) do
  --    z:update(mdt)
    end

    for _,z in pairs(shots) do
      z:update(mdt)
    end

    for _,z in pairs(items) do
      z:update(mdt)
    end

    camera.update(mdt)
    timer.update()

    delay.process()
    current_level:update(mdt)

    pathfinder.update()

    electricity:update(mdt)
    current_level:update(mdt)
  end
end

function play.draw()
  camera.apply_shake()

--	current_level:draw()
  current_level:draw()

  for _,z in pairs(sparks) do
    z:draw()
  end
  for _,z in pairs(doodads) do
     z:draw()
  end
  for _,z in pairs(items) do
    z:draw()
  end
  for _,z in pairs(enemies) do
--    z:draw()
  end
  for _,z in pairs(shots) do
    z:draw()
  end

  electricity:draw()


  player:draw()
  play.draw_screen_flash()

  hud:draw()

  -- debug
  pathfinder.draw_debug()

  fade:draw()
  if play.draw_cursor then
    play.draw_crosshairs()
  end
end

function play.game_speed()
  if play.freezeframe_end_time > gui_time then
    return 0
  else
    return 1 --gameplay_speed
  end
end

function play.freezeframe(duration)
  -- needs to be based on gui_time since obviously game_time won't be moving
  play.freezeframe_start_time = gui_time
  play.freezeframe_end_time = gui_time + duration
end

function play.flash_screen(r, g, b, a, dur)
  play.screen_flash = {r = r, g = g, b = b, a = a, duration = duration.start(dur)}
end

function play.draw_screen_flash()
  if play.screen_flash then
    if play.screen_flash.duration:finished() then
      play.screen_flash = nil
    else
      love.graphics.setBlendMode("add")
      love.graphics.setColor(play.screen_flash.r, play.screen_flash.g, play.screen_flash.b,
        play.screen_flash.a * (1 - play.screen_flash.duration:t()))
      love.graphics.rectangle("fill", 0, 0, window.w, window.h)
      love.graphics.setColor(255,255,255,255)
      love.graphics.setBlendMode("alpha")
    end
  end
end

local mouse_x, mouse_y
play.crosshair_offset = 0
function play.draw_crosshairs()
  mouse_x, mouse_y = love.mouse.getPosition()

  if player.equipped_items['weapon'].name == 'ProjectileGun' then
    love.graphics.setColor(255,200,100,255)
    play.crosshair_offset = 0.5 * (play.crosshair_offset + player.equipped_items['weapon'].cof_multiplier)
    love.graphics.draw(image['sight_bullet_dot'], mouse_x, mouse_y, 0, 1, 1, 8, 8)
    love.graphics.draw(image['sight_bullet_line'], mouse_x + 16 + 32*play.crosshair_offset, mouse_y, 0, 1, 1, 16, 8)
    love.graphics.draw(image['sight_bullet_line'], mouse_x , mouse_y + 16 + 32*play.crosshair_offset, math.pi * 0.5, 1, 1, 16, 8)
    love.graphics.draw(image['sight_bullet_line'], mouse_x - 16 - 32*play.crosshair_offset, mouse_y, math.pi, 1, 1, 16, 8)
    love.graphics.draw(image['sight_bullet_line'], mouse_x, mouse_y - 16 - 32*play.crosshair_offset, math.pi * 1.5, 1, 1, 16, 8)
  elseif player.equipped_items['weapon'].name == 'RayGun' then
    love.graphics.setColor(180,120,255,255)
    if player.equipped_items['weapon'].fired_at then
      play.crosshair_offset = 0.5 * (play.crosshair_offset + (1.125 - 1.25 * player.equipped_items['weapon'].focus))
    else
      play.crosshair_offset = 0.5 * play.crosshair_offset
    end

    love.graphics.draw(image['sight_bullet_dot'], mouse_x, mouse_y, 0, 1, 1, 8, 8)
    local r
    for j = 1, 7 do
      r = 0.3 + 3 * play.crosshair_offset + 0.89759790102 * j
      love.graphics.draw(image['sight_triangle'],
        mouse_x + math.cos(r) * (64 - 32*play.crosshair_offset),
        mouse_y + math.sin(r) * (64 - 32*play.crosshair_offset),
        r, 1, 1, 16, 16)
    end
  elseif player.equipped_items['weapon'].name == 'LightningGun' then
    love.graphics.setColor(130,230,255,255)

    if player.equipped_items['weapon'].is_firing then
      play.crosshair_offset = 0.5 * (play.crosshair_offset + 1)
    else
      play.crosshair_offset = 0.5 * play.crosshair_offset
    end

    local r
    local radius = 32 + (28 + 8 * love.math.random())*play.crosshair_offset
    for j = 1, 3 do
      r = (player.aim + math.pi or 0) + 2.09439510239 * j
      love.graphics.draw(image['sight_v'],
        mouse_x + math.cos(r) * radius,
        mouse_y + math.sin(r) * radius,
        r, 1, 1, 16, 16)
    end
  end
  love.graphics.setColor(255,255,255,255)
end

return play
