require "requires"

lovetoys.initialize({
    globals = true,
    debug = true
})


local player_input = baton.new {
  controls = {
    moveleft = {'key:a', 'axis:leftx-'},
    moveright = {'key:d', 'axis:leftx+'},
    moveup = {'key:w', 'axis:lefty-'},
    movedown = {'key:s', 'axis:lefty+'},

    aimleft = {'key:left', 'axis:rightx-'},
    aimright = {'key:right', 'axis:rightx+'},
    aimup = {'key:up', 'axis:righty-'},
    aimdown = {'key:down', 'axis:righty+'},

    fire = {'key:space', 'button:a', 'axis:triggerright+'},
  },
  pairs = {
    move = {'moveleft', 'moveright', 'moveup', 'movedown'},
    aim = {'aimleft', 'aimright', 'aimup', 'aimdown'},
  },
  joystick = love.joystick.getJoysticks()[1],
}

local dude = {
  sprite = love.graphics.newImage("assets/sprites/dude.png")
}

dude.draw = function()
  love.graphics.draw(dude.sprite, dude.x, dude.y, dude.rot-math.pi/2, 1, 1, 
    dude.sprite:getWidth()/2, dude.sprite:getHeight()/2)
end

dude.update = function(dt)
  local x, y = player_input:get 'move'

  local DEADBAND = 0.2

  if x < -DEADBAND then
    dude.x = dude.x - dude.speed*dt
  elseif x > DEADBAND then
    dude.x = dude.x + dude.speed*dt
  end

  if y < -DEADBAND then
    dude.y = dude.y - dude.speed*dt
  elseif y > DEADBAND then
    dude.y = dude.y + dude.speed*dt
  end

  -- limit movement to the screen
  local dude_radius = math.max(dude.sprite:getHeight()/2,dude.sprite:getWidth()/2)
  if dude.x > love.graphics.getWidth()-dude_radius then
    dude.x = love.graphics.getWidth()-dude_radius
  elseif dude.x < dude_radius then
    dude.x = dude_radius
  end

  if dude.y > love.graphics.getHeight()-dude_radius then
    dude.y = love.graphics.getHeight()-dude_radius
  elseif dude.y < dude_radius then
    dude.y = dude_radius
  end

  -- rotation only using the mouse postion, for now, I dont know how to
  -- do it with the keys...still learning.
  local mx, my = love.mouse.getPosition()
  dude.rot = math.atan2(dude.y-my, dude.x-mx)

end

function love.load()
  dude.x = 100
  dude.y = 100
  dude.speed = 300
  dude.rot = 0

  love.mouse.setVisible(true)

end

function love.update(dt)
	player_input:update()
  dude.update(dt)
end

function love.draw()
  dude.draw()
end
