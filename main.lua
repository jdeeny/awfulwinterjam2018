require "requires"
require "reticle"
require "input"

lovetoys.initialize({
    globals = true,
    debug = true
})




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
  dude.x = cpml.utils.clamp(dude.x, dude_radius, love.graphics.getWidth() - dude_radius)
  dude.y = cpml.utils.clamp(dude.y, dude_radius, love.graphics.getHeight() - dude_radius)

  -- rotate to face the reticle
  dude.rot = math.atan2(dude.y-reticle.y, dude.x-reticle.x)

end

function love.load()
  dude.x = 100
  dude.y = 100
  dude.speed = 300
  dude.rot = 0

  reticle.initialize()
end

function love.update(dt)
	player_input:update()
  reticle.update(dt)
  dude.update(dt)
end

function love.draw()
  dude.draw()
  reticle.draw()
end
