Movie = class("Movie")


function Movie:initialize(movie_data)
  self.steps = movie_data.sequence_steps
  self.step_index = 1
  self.current_step = self.steps[self.step_index]

  self.music = movie_data.music

  self._finished = false
end

function Movie:start()
  player.input_disabled = true

  self.current_step:start()

  if self.music then
    audiomanager:playMusic(self.music.track, self.music.volume, 
      self.music.offset)
  end

end

function Movie:stop()
  player.input_disabled = false
  self._finished = true
  audiomanager:stopMusic()
end

function Movie:update(dt)
  player_input:update()
  if player_input:pressed('fire') or player_input:pressed('sel') then
    self:stop()
  end

  if not self._finished then 
    if self.current_step:is_finished() then
      self.current_step:stop()
      
      self.step_index = self.step_index + 1
      if self.step_index > #self.steps then
        self._finished = true
      else
        self.current_step = self.steps[self.step_index]   
        self.current_step:start()
      end
    else
      self.current_step:update(dt)
      if self.current_step.type == 'animation' then
        game_time = game_time + dt
        game_flux.update(dt)
        camera.update(dt)
        timer.update()
        delay.process()
        pathfinder.update()
        player.update(dt)
        electricity:update(dt)
        current_level:update(dt)
      end
    end
  end
end

function Movie:draw()
  self.current_step:draw()
  if self.current_step.type == 'animation' then
    current_level:draw()

    player:draw()
    play.draw_screen_flash()

    fade:draw()
  end
end

function Movie:is_finished( ... )
  return self._finished
end


return Movie