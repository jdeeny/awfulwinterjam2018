local play = { freezeframe_start_time = 0, freezeframe_end_time = 0}

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
        z:update(mdt)
      end

      for _,z in pairs(shots) do
        z:update(mdt)
      end

      camera.update(mdt)
      timer.update()

      delay.process()
      water.update(mdt)
      current_room:update(mdt)

      electricity:update(mdt)
    end
end

function play.draw()
  camera.apply_shake()

	current_room:draw()

  for _,z in pairs(sparks) do
    z:draw()
  end
  for _,z in pairs(doodads) do
     z:draw()
  end
  for _,z in pairs(enemies) do
    z:draw()
  end
  for _,z in pairs(shots) do
    z:draw()
  end

  player:draw()
  electricity:draw()

  hud:draw()

  fade:draw()
end

function play.game_speed()
  if play.freezeframe_end_time > gui_time then
    return 0
  else
    return 1
  end
end

function play.freezeframe(duration)
  -- needs to be based on gui_time since obviously game_time won't be moving
  play.freezeframe_start_time = gui_time
  play.freezeframe_end_time = gui_time + duration
end

return play
