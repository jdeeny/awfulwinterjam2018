local Intertitle = require "movies/intertitle"
local Movie = require "movies/movie"

local sequence = require "movies/sequence"

local SequenceStep = sequence.SequenceStep
local IntertitleStep = sequence.IntertitleStep

local movie_play = {

}



-------------------------------------------------------------------------------
-- type, start, update, stop, draw, run_time
movie_play.movie_data = {
  sequence_steps = {
    IntertitleStep("We find Nikola Tesla\nnewly arrived in America,\nworking at the \nEdison Machine works.", 2),
    SequenceStep:new({
      type = "animation",
      start = function(self)
        player:start_force_move(0.5, player.speed, 0)
      end,
      run_time = 1,
    }),
    IntertitleStep("Mr. Batchelor,\nI've invented the \n24 standard machines.", 2),
    IntertitleStep("I'm here for my reward!", 2),
    SequenceStep:new({
      type = "animation",
      start = function(self)
        player:start_force_move(0.5, player.speed, 0)
      end,
      run_time = 2,
    }),
    IntertitleStep("Ha ha ha ha ha ...", 2),
    IntertitleStep("There was no reward you fool!", 2),
    IntertitleStep("Thomas Alva Edison \nwill never pay!", 2),
    SequenceStep:new({
      type = "animation",
      start = function(self)
        player:start_force_move(0.5, player.speed, 0)
      end,
      run_time = 2,
    }),
    IntertitleStep("Oh ... He WILL pay ..", 2),
    SequenceStep:new({
      type = "animation",
      run_time = 0.5,
    }),
    IntertitleStep("He Will PAY!", 2),
  },
  music = {track="figleaf", volume=1, offset=27},
}

movie_play.movie_data2 = {
  sequence_steps = {
    SequenceStep:new({
      type = "animation",
      start = function(self)
        player:start_force_move(0.5, player.speed, 0)
      end,
      run_time = 1,
    }),
    IntertitleStep("Inconceivable!", 2),
    SequenceStep:new({
      type = "animation",
      start = function(self)
        player:start_force_move(0.5, player.speed, 0)
      end,
      run_time = 2,
    }),
    IntertitleStep("I do not think you know what that means.", 2),
    SequenceStep:new({
      type = "animation",
      start = function(self)
        player:start_force_move(0.5, player.speed, 0)
      end,
      run_time = 2,
    }),
    IntertitleStep("...", 2),
    SequenceStep:new({
      type = "animation",
      run_time = 0.5,
    }),
    IntertitleStep("Fuck.", 2),
  },
  music = {track="figleaf", volume=1, offset=27},
}

movie_play.movie_data3 = {
  sequence_steps = {
    SequenceStep:new({
      type = "animation",
      start = function(self)
        player:start_force_move(0.5, player.speed, 0)
      end,
      run_time = 1,
    }),
    IntertitleStep("...", 2),
    SequenceStep:new({
      type = "animation",
      start = function(self)
        player:start_force_move(0.5, player.speed, 0)
      end,
      run_time = 2,
    }),
    IntertitleStep("---", 2),
    SequenceStep:new({
      type = "animation",
      start = function(self)
        player:start_force_move(0.5, player.speed, 0)
      end,
      run_time = 2,
    }),
    IntertitleStep("&&&", 2),
    SequenceStep:new({
      type = "animation",
      run_time = 0.5,
    }),
    IntertitleStep("$$$", 2),
  },
  music = {track="figleaf", volume=1, offset=27},
}

movie_play.credits = {
  sequence_steps = {
    IntertitleStep("Wardenclyffe Laboratory\n\nTechnicians\n\nwould like to thank you\n\nfor playing our game.", 5),
    IntertitleStep("John Deeny\n\njdeeny@gmail.com", 3),
    IntertitleStep("Samuel Wilson\n\nyokomeshi@gmail.com", 3),
    IntertitleStep("Graham Chambers\n\nmshadowy.Art@gmail.com", 3),
    IntertitleStep("Amy Zurko\n\namyzurko@gmail.com", 3),
    IntertitleStep("Andrew Chaniotis\n\nandreas.xaniotis@gmail.com", 3),
    IntertitleStep("Jason Nyland\n\njasonnyland@fastmail.com", 3),
	IntertitleStep("Michael Winterstein\n\nkangra@quirksand.net",3),
    IntertitleStep("Mason Pluimer\n\ntherealpickle@gmail.com", 3),
    IntertitleStep("Michael Winterstein\n\nkangra@quirksand.net", 3),
    --IntertitleStep("", 3),
    IntertitleStep("Music\n\nFig Leaf Times Two\n\nby Kevin MacLeod\n\nincompetech.com", 3),
  },
  music = {track="credits", volume=1, offset=0},
}

function movie_play.enter(movie_data, finish_callback)

  movie_play.finish_callback = finish_callback

  movie_play.movie = Movie:new(movie_data)
  movie_play.movie:start()

  state = STATE_MOVIE_PLAY
end

function movie_play.exit()
  movie_play.movie:stop()
  movie_play.finish_callback()
end

function movie_play.update(dt)
  movie_play.movie:update(dt)
  if movie_play.movie:is_finished() then
    movie_play.exit()
  end
end

function movie_play.draw()
  movie_play.movie:draw()
end

return movie_play
