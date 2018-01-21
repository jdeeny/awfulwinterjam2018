Intertitle = require "states/intertitle"

local movie_a = {
  music = {track="figleaf", volume=1, offset=27},
}

-------------------------------------------------------------------------------
local SequenceStep = class("SequenceStep")

function SequenceStep:initialize( seq_table )
  self.type = seq_table.type
  self.run_time = seq_table.run_time or 9999
  self._start = seq_table.start
  self._stop = seq_table.stop
  self._update = seq_table.update
  self._draw = seq_table.draw
end

function SequenceStep:start( ... )
  self.start_time = love.timer.getTime()
  self._started = true
  self._running = true
  
  if self._start then
    self:_start()
  end
end

function SequenceStep:update(dt)
  if self._running then
    if love.timer.getTime() > (self.start_time + self.run_time) then
      self._running = false
    else
      if self._update then
        self:_update(dt)
      end
      if self.type == 'animation' then
        movie_a._update_level(dt)
      end
    end
  end
end

function SequenceStep:stop( ... )
  if self._running then
    self._running = false
    if self._stop then
      self:_stop()
    end
  end
end

function SequenceStep:draw( ... )
  if self._draw and self._running then
    self:_draw()
  end

  if self.type == 'animation' then
    movie_a._draw_level()
  end
end

function SequenceStep:is_finished( ... )
  if not self._started then
    return false 
  end
  return not self._running
end

-------------------------------------------------------------------------------
IntertitleStep = class("IntertitleStep",SequenceStep)

function IntertitleStep:initialize(text, duration)
  self._text = text
  self._duration = duration
  local startfunc = function(self)
    self.intertitle = Intertitle:new(self._text,self._duration)
  end
  local updatefunc = function(self, dt)
    if self.intertitle:complete() then
        self:stop()
      end
  end
  local drawfunc = function(self)
    self.intertitle:draw()
  end
  SequenceStep.initialize(self, {start=startfunc, update=updatefunc,
    draw=drawfunc, type='intertitle'})
end

-------------------------------------------------------------------------------
-- type, start, update, stop, draw, run_time
movie_a.sequence_steps = {
  SequenceStep:new({
    type = "animation",
    start = function(self)
      player:start_force_move(0.5, player.speed, 0)
    end,
    run_time = 1,
  }),
  IntertitleStep("My name is Nikola Tesla.", 2),
  SequenceStep:new({
    type = "animation",
    start = function(self)
      player:start_force_move(0.5, player.speed, 0)
    end,
    run_time = 2,
  }),
  IntertitleStep("You kill my father.", 2),
  SequenceStep:new({
    type = "animation",
    start = function(self)
      player:start_force_move(0.5, player.speed, 0)
    end,
    run_time = 2,
  }),
  IntertitleStep("Prepare to die ...", 2),
  SequenceStep:new({
    type = "animation",
    run_time = 0.5,
  }),
  IntertitleStep("... by electricity", 2),
}







function movie_a.enter()
  movie_a.start_time = love.timer.getTime()
  -- movie_a.intertitle = Intertitle:new(unpack(movie_a.intertitles[1]))

  if movie_a.music then
	  audiomanager:playMusic(movie_a.music.track, movie_a.music.volume, 
      movie_a.music.offset)
  end

  movie_a.dungeon = dungeon:new(1, 1, {['start'] = {3}}, nil)
  movie_a.dungeon:setup_main()
  
  movie_a.dungeon:move_to_room(1,1,'west')

  player.input_disabled = true

  movie_a.seq_i = 1
  movie_a.seq = movie_a.sequence_steps[movie_a.seq_i]
  movie_a.seq:start()

  state = STATE_MOVIE_A
end

function movie_a.exit()
  gamestage.setup_next_stage(gamestage.current_stage)
  gamestage.advance_to_play()
  audiomanager:stopMusic()
  player.input_disabled = false
  play.enter()
end

function movie_a._update_level(dt)
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

function movie_a._draw_level()
  current_level:draw()

  player:draw()
  play.draw_screen_flash()

  fade:draw()
end

function movie_a.update(dt)

  player_input:update()
  if player_input:pressed('fire') or player_input:pressed('sel') then
    movie_a.exit()
    return
  end

  if movie_a.seq:is_finished() then
    

    movie_a.seq:stop()
    
    movie_a.seq_i = movie_a.seq_i + 1
    if movie_a.seq_i > #movie_a.sequence_steps then
      movie_a.exit()
      return
    end
    movie_a.seq = movie_a.sequence_steps[movie_a.seq_i]   

    movie_a.seq:start()
    
  else
    movie_a.seq:update(dt)
  end

  
end

function movie_a.draw()
  if movie_a.seq then
    movie_a.seq:draw()
  end
end


return movie_a
