Intertitle = require "states/intertitle"

local movie_a = {
  music = {track="figleaf", volume=1, offset=27},
  intertitles = {
    {"This is the first thing said.", 3},
  },
}

local sequence_finished = true
local sequence_index = 0
local sequence_current_step = nil
local sequence = {
  {type='animation', action=function() 
      sequence_finished = false
      player:start_force_move(0.5, player.speed, 0)
      delay.start(2, function() 
        player:end_force_move()
        sequence_finished = true
      end)
    end},
  {type='intertitle', action={"Hello. My name is Inigo montoya.",3}},
  {type='animation', action=function() 
      sequence_finished = false
      player:start_force_move(0.5, player.speed, 0)
      delay.start(2, function() 
        player:end_force_move()
        sequence_finished = true
      end)
    end},
  {type='intertitle', action={"You killed my father.",3}},
  {type='animation', action=function() 
      sequence_finished = false
      player:start_force_move(0.5, player.speed, 0)
      delay.start(2, function() 
        player:end_force_move()
        sequence_finished = true
      end)
    end},
  {type='intertitle', action={"Prepare to die.",3}},
}

function movie_a.enter()
  movie_a.start_time = love.timer.getTime()
  -- movie_a.intertitle = Intertitle:new(unpack(movie_a.intertitles[1]))

  if movie_a.music then
	  audiomanager:playMusic(movie_a.music.track, movie_a.music.volume, 
      movie_a.music.offset)
  end

  movie_a.dungeon = dungeon:new()
  movie_a.dungeon:init(1, 1, {['start'] = {3}}, nil)
  movie_a.dungeon:setup_main()
  
  movie_a.dungeon:move_to_room(1,1,'west')

  player.input_disabled = true


  fade.start_fade("fadein", 0.5, true)
  player:start_force_move(player.speed, 0, 1)
  sequence_finished = false
  delay.start(0.5, function() 
      player:end_force_move()
      sequence_finished = true 
    end)

  state = STATE_MOVIE_A
end

function movie_a.exit()
  gamestage.setup_next_stage(gamestage.current_level)
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

  if not movie_a.intertitle then
    movie_a._update_level(dt)

    if sequence_finished then
      sequence_index = sequence_index + 1
      
      if sequence_index > #sequence then
        movie_a.exit()
        return
      end

      local seq = sequence[sequence_index]

      print("sequence_index",sequence_index)
      if seq['type'] == 'animation' then
        print("animation")
        seq['action']()
      elseif seq['type'] == 'intertitle' then
        print("intertitle")
        movie_a.intertitle = Intertitle:new(unpack(seq['action']))
        print("animation")
      end
    end

  elseif movie_a.intertitle:complete() then
    movie_a.intertitle = nil
  end
  
end

function movie_a.draw()
  if movie_a.intertitle then
    movie_a.intertitle:draw()
  else
    movie_a._draw_level()
  end
end


return movie_a
