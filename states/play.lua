local play = {}

function play.update(dt)

	player_input:update()

    if player_input:pressed('pause') then
      game_state = 'pause'
    else
      game_time = game_time + dt
      player.update(dt)

      for _,z in pairs(sparks) do
        z:update(dt)
      end
      for _,z in pairs(enemies) do
        z:update(dt)
      end
      for _,z in pairs(shots) do
        z:update(dt)
      end

      camera.update(dt)
      timer.update()
    end
end

function play.draw()
	current_room:draw()

  for _,z in pairs(sparks) do
    z:draw(dt)
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

return play
