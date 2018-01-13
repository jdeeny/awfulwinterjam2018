local play = { freezeframe_start_time = 0, freezeframe_end_time = 0}

function play.update(dt)

	player_input:update()

    if player_input:pressed('pause') then
      game_state = 'pause'
    else
      mdt = dt * play.game_speed()
      game_time = game_time + mdt
      player.update(mdt)

      for _,z in pairs(sparks) do
        z:update(mdt)
      end
      for _,z in pairs(enemies) do
        z:update(mdt)
      end
      for _,z in pairs(shots) do
        z:update(mdt)
      end

      camera.update(mdt)
      timer.update()

      if play.coda_time and play.coda_time <= game_time then
        current_room:coda()
        play.coda_time = nil
      end
    end
end

function play.draw()
  if camera.shake_end_time then
    if camera.shake_end_time > gui_time then
      camera.apply_shake()
    else
      camera.clear_shake()
    end
  end

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

  fade.draw(game_time)

  timer.draw()
  player:draw_hp()
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
