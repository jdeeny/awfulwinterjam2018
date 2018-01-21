local Intertitle = require "movies/intertitle"
local Movie = require "movies/movie"

local sequence = require "movies/sequence"

local SequenceStep = sequence.SequenceStep
local IntertitleStep = sequence.IntertitleStep

local movie_a = {

}



-------------------------------------------------------------------------------
-- type, start, update, stop, draw, run_time
movie_a.movie_data = {
  sequence_steps = {
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
  },
  music = {track="figleaf", volume=1, offset=27},
}


function movie_a.enter(movie_data, dungeon, finish_callback)

  movie_a.finish_callback = finish_callback

  -- movie_a.dungeon = dungeon:new()
  -- movie_a.dungeon:init(1, 1, {['start'] = {3}}, nil)
  -- movie_a.dungeon:setup_main()
  
  dungeon:move_to_room(1,1,'west')

  movie_a.movie = Movie:new(movie_data)
  movie_a.movie:start()
  

  state = STATE_MOVIE_A
end

function movie_a.exit()
  movie_a.movie:stop()
  -- current_dungeon = movie_a.cached_dungeon
  movie_a.finish_callback()
end

function movie_a.update(dt)
  movie_a.movie:update(dt)
  if movie_a.movie:is_finished() then
    movie_a.exit()
  end
end


function movie_a.draw()
  movie_a.movie:draw()
end


return movie_a
