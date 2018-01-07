local player = {
	sprite = love.graphics.newImage("assets/sprites/dude.png"),
	speed = 300,
	}

function player.draw()
  love.graphics.draw(player.sprite, player.x, player.y, player.rot-math.pi/2, 1, 1,
    player.sprite:getWidth()/2, player.sprite:getHeight()/2)
end

function player.update(dt)
  local x, y = player_input:get 'move'

  local DEADBAND = 0.2

  if x < -DEADBAND then
    player.x = player.x - player.speed*dt
  elseif x > DEADBAND then
    player.x = player.x + player.speed*dt
  end

  if y < -DEADBAND then
    player.y = player.y - player.speed*dt
  elseif y > DEADBAND then
    player.y = player.y + player.speed*dt
  end

  -- limit movement to the screen
  local player_radius = math.max(player.sprite:getHeight()/2,player.sprite:getWidth()/2)
  player.x = cpml.utils.clamp(player.x, player_radius, love.graphics.getWidth() - player_radius)
  player.y = cpml.utils.clamp(player.y, player_radius, love.graphics.getHeight() - player_radius)

  -- rotate to face the reticle
  player.rot = math.atan2(player.y-reticle.y, player.x-reticle.x)
end

return player
