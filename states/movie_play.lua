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
    IntertitleStep("We find Nikola Tesla\n\nnewly arrived in America,",2.5),
    IntertitleStep("working at the \n\nEdison Machine works.", 2.5),
    
    -- -- Telsa walks up tp charles batchelor who is alread standing in the room
    -- SequenceStep:new({
    --   type = "animation",
    --   start = function(self)
    --     player:start_force_move(0.5, player.speed, 0)
    --   end,
    --   run_time = 1,
    -- }),
    IntertitleStep("Nikola Tesla:\n\n\"Mr. Batchelor,\n\nI've invented the\n\n24 standard machines.\"", 3),
    IntertitleStep("\"I'm here for my reward.\"", 2),
    
    -- -- charles moves toward tesla
    -- SequenceStep:new({
    --   type = "animation",
    --   start = function(self)
    --     player:start_force_move(0.5, player.speed, 0)
    --   end,
    --   run_time = 2,
    -- }),

    IntertitleStep("Charles Batchelor:\n\n\"Ha ha ha ha ha.\n\nThere was no reward.\"", 2),
    IntertitleStep("\"You FOOL.\"", 2),
    IntertitleStep("\"Thomas Alva Edison\n\nwill never pay.\"", 2),
    -- SequenceStep:new({
    --   type = "animation",
    --   start = function(self)
    --     player:start_force_move(0.5, player.speed, 0)
    --   end,
    --   run_time = 2,
    -- }),
    IntertitleStep("Nikola Tesla:\n\n\"Oh ... He WILL pay.\"", 2),
    -- SequenceStep:new({
    --   type = "animation",
    --   run_time = 0.5,
    -- }),
    IntertitleStep("\"And so will YOU\"", 2),
  },
  music = {track="figleaf", volume=0.3, offset=27},
}

movie_play.movie_data2 = {
  sequence_steps = {
    -- Tesla walks into lab
    -- SequenceStep:new({
    --   type = "animation",
    --   start = function(self)
    --     player:start_force_move(0.5, player.speed, 0)
    --   end,
    --   run_time = 2,
    -- }),
    IntertitleStep("Nikola Tesla:\n\n\"Ahh. My Tesla\n\nExperimental Station.\"", 2),
    
    -- -- Tesla walks over to to bench
    -- SequenceStep:new({
    --   type = "animation",
    --   start = function(self)
    --     player:start_force_move(0.5, player.speed, 0)
    --   end,
    --   run_time = 2,
    -- }),
    IntertitleStep("\"I wonder ...\"", 2),
    IntertitleStep("\"What signals will\n\nI find today?\"", 2.5),
    
    -- -- tesls just stands there
    -- SequenceStep:new({
    --   type = "animation",
    --   start = function(self)
    --     player:start_force_move(0.5, player.speed, 0)
    --   end,
    --   run_time = 4,
    -- }),
    IntertitleStep("\"Eureka\"", 1),
    
    -- -- tesls just stands there
    -- SequenceStep:new({
    --   type = "animation",
    --   start = function(self)
    --     -- player:start_force_move(0.5, player.speed, 0)
    --   end,
    --   run_time = 0.5,
    -- }),
    IntertitleStep("\"Martian Signals\"", 2),
    
    -- marconi walks in
    -- SequenceStep:new({
    --   type = "animation",
    --   start = function(self)
    --     -- player:start_force_move(0.5, player.speed, 0)
    --   end,
    --   run_time = 2,
    -- }),
    IntertitleStep("Guglielmo Marconi:\n\n\"Ha ha ha.\"", 2),
    IntertitleStep("\"You Fool\"", 2),
    IntertitleStep("\"You just detected\n\nMY experiments \"", 3),
    
    -- -- Marconi runs away, tesla moves a bit toward the direction he left
    -- SequenceStep:new({
    --   type = "animation",
    --   start = function(self)
    --     player:start_force_move(-0.5, player.speed, 0)
    --   end,
    --   run_time = 2,
    -- }),
    IntertitleStep("Nikola Telsa:\n\n\"You will answer for what\n\nyou've done, Marconi.\"", 2),
  },
  music = {track="figleaf", volume=0.3, offset=27},
}

movie_play.movie_data3 = {
  sequence_steps = {
    -- -- open to scene with 2 random guys facing edison
    -- SequenceStep:new({
    --   type = "animation",
    --   start = function(self)
    --     ---player:start_force_move(0.5, player.speed, 0)
    --   end,
    --   run_time = 1,
    -- }),
    IntertitleStep("Nobel Price Committee:\n\n\"Congratulations\n\nMr. Tesla\"", 2),
    IntertitleStep("\"We'd like to award\n\nyou and Mr. Edison\n\n the Nobel Prize.\"", 2),

    -- -- 2 guys leave
    -- SequenceStep:new({
    --   type = "animation",
    --   start = function(self)
    --     --player:start_force_move(0.5, player.speed, 0)
    --   end,
    --   run_time = 1,
    -- }),

    -- -- Edison walks in
    -- SequenceStep:new({
    --   type = "animation",
    --   start = function(self)
    --     --player:start_force_move(0.5, player.speed, 0)
    --   end,
    --   run_time = 3,
    -- }),

    IntertitleStep("Thomas Edison: \n\n\"You'll have\n\n to kill me\"", 2),
    IntertitleStep("\"before i ever share\n\n a Nobel Prize with you\"", 2),

    -- -- tesla walks forward, zoom in if you can
    -- SequenceStep:new({
    --   type = "animation",
    --   start = function(self)
    --     player:start_force_move(0.5, player.speed, 0)
    --   end,
    --   run_time = 2,
    -- }),
    IntertitleStep("Nikola Telsa:\n\n\"So be it.\"", 2),

    -- edison runs away
    -- SequenceStep:new({
    --   type = "animation",
    --   run_time = 1,
    -- }),
  },
  music = {track="figleaf", volume=0.3, offset=27},
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
    IntertitleStep("Mason Pluimer\n\ntherealpickle@gmail.com", 3),
    IntertitleStep("Michael Winterstein\n\nkangra@quirksand.net", 3),
    --IntertitleStep("", 3),
    IntertitleStep("Music\n\nFig Leaf Times Two\n\nby Kevin MacLeod\n\nincompetech.com", 3),
  },
  music = {track="credits", volume=0.3, offset=0},
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
