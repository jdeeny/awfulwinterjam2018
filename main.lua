require 'math'

local baton = require 'lib/baton/baton' -- the baton input library https://github.com/tesselode/baton
local anim8 = require 'lib/anim8/anim8' -- anim8 animation library https://github.com/kikito/anim8
local cpml = require 'lib/cpml'-- Cirno's Perfect Math Library https://github.com/excessive/cpml (Docs: http://excessive.github.io/cpml/)
--require 'lib/autobatch/autobatch'                 -- autobatch automatic SpriteBatch https://github.com/rxi/autobatch
-- OOP https://github.com/kikito/middleclass
-- nice scaling for pixel graphics (might be fixed in git version?) https://github.com/SystemLogoff/lovePixel
-- interesting text library that allows control per letter https://github.com/mzrinsky/popo https://github.com/EntranceJew/popo
-- neural net that generates text that looks like source data https://github.com/karpathy/char-rnn
-- https://github.com/tastyminerals/coherent-text-generation-limited
-- sound synth lib https://github.com/vrld/Moan

local input = baton.new {
  controls = {
    left = {'key:left', 'axis:leftx-', 'button:dpleft'},
    right = {'key:right', 'axis:leftx+', 'button:dpright'},
    up = {'key:up', 'axis:lefty-', 'button:dpup'},
    down = {'key:down', 'axis:lefty+', 'button:dpdown'},
    accel = {'key:x', 'button:a'},
    brake = {'key:c', 'button:b'}
  },
  pairs = {
    move = {'left', 'right', 'up', 'down'}
  },
  joystick = love.joystick.getJoysticks()[1],
}

local playerCar = {}
local road = {}
local camera = {}




function love.load()
  playerCar.x = 0 -- vehicles position across the track, normalized -1 to 1
  playerCar.position = 0	-- position on the track (actually camera's position)
  playerCar.speed = 0
  playerCar.max_speed = 200
  playerCar.anim_image = love.graphics.newImage('assets/sprites/redcar.png')
  playerCar.anim_grid = anim8.newGrid(96, 64, playerCar.anim_image:getWidth(), playerCar.anim_image:getHeight())
  playerCar.animation = anim8.newAnimation(playerCar.anim_grid('1-2', 1), 0.4)

  road.lanes = 3
  road.segment_length = 200
  road.rumble_segments = 3

  camera.fov = 110
  camera.height = 1000
  camera.draw_distance = 300

end



local function update_car(dt)
  local dx = dt * 2 * (playerCar.speed / playerCar.max_speed) -- at top speed, should be able to cross from left to right (-1 to 1) in 1 second

  local x, y = input:get 'move'

  if x < 0.0 then
    playerCar.x = playerCar.x - dx
  elseif x > 0.0 then
    playerCar.x = playerCar.x + dx
  end

  if input:pressed 'accel' then
    playerCar.speed = playerCar.speed + 10 * dt
  elseif input:pressed 'brake' then
    playerCar.speed = playerCar.speed - 10 * dt
  else
    playerCar.speed = playerCar.speed - 1 * dt
  end

  if ( playerCar.x < -1.0 or playerCar.x > 1.0 ) and playerCar.speed > playerCar.offroad_maxspeed then
    playerCar.speed = playerCar.speed + playerCar.offroad_decel * dt
    playerCar.x = cpml.utils.clamp(playerCar.x, -2.0, 2.0)
    playerCar.speed = cpml.utils.clamp(playerCar.speed, 0.0, playerCar.maxSpeed)
  end
end


function love.update(dt)
	input:update()
  update_car(dt)
  playerCar.animation:update(dt)
end


local function draw_road()
  love.graphics.setColor(50, 50, 50)
  love.graphics.polygon('fill', 0, 200, 50, 200, 100, 300)
end


function love.draw()
  draw_road()
  playerCar.animation:draw(playerCar.anim_image, 100, 200)
end
