require 'math'

local baton = require 'lib/baton/baton' -- the baton input library https://github.com/tesselode/baton
local anim8 = require 'lib/anim8/anim8' -- anim8 animation library https://github.com/kikito/anim8
local cpml = require 'lib/cpml'-- Cirno's Perfect Math Library https://github.com/excessive/cpml (Docs: http://excessive.github.io/cpml/)
local HC = require 'lib/HC' -- General purpose collision detection library for the use with LÖVE. https://github.com/vrld/HC (Docs: http://hc.readthedocs.org)
--local class = require 'lib/middleclass/middleclass' -- OOP https://github.com/kikito/middleclass
local lovetoys = require('lib/lovetoys/lovetoys') -- Entity-Componet System https://github.com/Lovetoys/lovetoys
lovetoys.initialize({
    globals = true,
    debug = true
})


--require 'lib/autobatch/autobatch'                 -- autobatch automatic SpriteBatch https://github.com/rxi/autobatch
-- nice scaling for pixel graphics (might be fixed in git version?) https://github.com/SystemLogoff/lovePixel
-- interesting text library that allows control per letter https://github.com/mzrinsky/popo https://github.com/EntranceJew/popo
-- neural net that generates text that looks like source data https://github.com/karpathy/char-rnn
-- https://github.com/tastyminerals/coherent-text-generation-limited
-- sound synth lib https://github.com/vrld/Moan


local input = baton.new {
  controls = {
    moveleft = {'key:a', 'axis:leftx-'},
    moveright = {'key:d', 'axis:leftx+'},
    moveup = {'key:w', 'axis:lefty-'},
    movedown = {'key:s', 'axis:lefty+'},

    aimleft = {'key:left', 'axis:rightx-'},
    aimright = {'key:right', 'axis:rightx+'},
    aimup = {'key:up', 'axis:righty-'},
    aimdown = {'key:down', 'axis:righty+'},

    --fire = {'key:space', 'axis:triggerright', 'button:a'},
  },
  pairs = {
    move = {'moveleft', 'moveright', 'moveup', 'movedown'},
    aim = {'aimleft', 'aimright', 'aimup', 'aimdown'},
  },
  joystick = love.joystick.getJoysticks()[1],
}


local Fruit = class('Fruit') -- 'Fruit' is the class' name

local dude = {}

function love.load()
  engine = Engine()
  dude.x = 100
  dude.y = 100
  dude.anim_image = love.graphics.newImage('assets/sprites/dude.png')
  dude.anim_grid = anim8.newGrid(75, 52, dude.anim_image:getWidth(), dude.anim_image:getHeight())
  dude.animation = anim8.newAnimation(dude.anim_grid(1, 1), 0.4)
end


local function shoot()

end

local function update_car(dt)

  local x, y = input:get 'move'

  if x < -0.2 then
    dude.x = dude.x - 1
  elseif x > 0.2 then
    dude.x = dude.x + 1
  end

  if y < -0.2 then
    dude.y = dude.y - 1
  elseif y > 0.2 then
    dude.y = dude.y + 1
  end

--[[
  if input:pressed 'accel' then
    dude.speed = dude.speed + 10 * dt
  elseif input:pressed 'brake' then
    dude.speed = dude.speed - 10 * dt
  else
    dude.speed = dude.speed - 1 * dt
  end
--]]
  dude.x = cpml.utils.clamp(dude.x, 0, love.graphics.getWidth())
  dude.y = cpml.utils.clamp(dude.y, 0, love.graphics.getHeight())

end


function love.update(dt)
	input:update()
  engine:update(dt)
  --world:update(dt)

--  update_car(dt)
--  dude.animation:update(dt)
end


local function draw_road()
  love.graphics.setColor(50, 50, 50)
  love.graphics.polygon('fill', 0, 200, 50, 200, 100, 300)
end


function love.draw()
  engine:draw()
--  draw_road()
--  dude.animation:draw(dude.anim_image, dude.x, dude.y)
end
