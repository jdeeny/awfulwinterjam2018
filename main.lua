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

local playerCar = {}
local road = {}
local camera = {}




function love.load()
  playerCar.x = 100
  playerCar.y = 100
  playerCar.anim_image = love.graphics.newImage('assets/sprites/redcar.png')
  playerCar.anim_grid = anim8.newGrid(96, 64, playerCar.anim_image:getWidth(), playerCar.anim_image:getHeight())
  playerCar.animation = anim8.newAnimation(playerCar.anim_grid('1-2', 1), 0.4)
end



local function update_car(dt)

  local x, y = input:get 'move'

  if x < -0.2 then
    playerCar.x = playerCar.x - 1
  elseif x > 0.2 then
    playerCar.x = playerCar.x + 1
  end

  if y < -0.2 then
    playerCar.y = playerCar.y - 1
  elseif y > 0.2 then
    playerCar.y = playerCar.y + 1
  end

--[[
  if input:pressed 'accel' then
    playerCar.speed = playerCar.speed + 10 * dt
  elseif input:pressed 'brake' then
    playerCar.speed = playerCar.speed - 10 * dt
  else
    playerCar.speed = playerCar.speed - 1 * dt
  end
--]]
  playerCar.x = cpml.utils.clamp(playerCar.x, 0, love.graphics.getWidth())
  playerCar.y = cpml.utils.clamp(playerCar.y, 0, love.graphics.getHeight())

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
  playerCar.animation:draw(playerCar.anim_image, playerCar.x, playerCar.y)
end
