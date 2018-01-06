lovetoys = require("lib/lovetoys/lovetoys")
lovetoys.initialize({globals = true, debug = true})

require "requires"



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

local MenuState = require("states/MenuState")

function love.load()
    resources = Resources()

    -- Add your resources here:
    resources:addImage("circle", "assets/sprites/redcar.png")

    resources:load()

    stack = StackHelper()
    stack:push(MenuState())
end

function love.update(dt)
    input:update()
    stack:current():update(dt)
end

function love.draw()
    stack:current():draw()
end

--[[ Using baton but left this in for later reference]]
function love.keypressed(key, isrepeat)
    stack:current():keypressed(key, isrepeat)
end

function love.keyreleased(key, isrepeat)
    stack:current():keyreleased(key, isrepeat)
end

function love.mousepressed(x, y, button)
    stack:current():mousepressed(x, y, button)
end
--]]
