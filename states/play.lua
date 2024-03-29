local play = { freezeframe_start_time = 0, freezeframe_end_time = 0}

function play.enter()
  state = STATE_PLAY
  audiomanager:playRandomMusic()
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

player:draw()
  electricity:draw()



  play.draw_screen_flash()

  hud:draw()

  -- debug
  -- pathfinder.draw_debug()

  fade:draw()
  crosshairs.draw()
end

function play.game_speed()
  if play.freezeframe_end_time > gui_time then
    return 0
  else
    return gameplay_speed
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

return play
