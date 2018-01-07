local reticle = {
  x = 0,
  y = 0,
  speed = 600,
  sprite = love.graphics.newImage("assets/sprites/opengameart/crosshairs/circle-02.png")
}

function reticle.init()
  love.mouse.setRelativeMode(true)
end

function reticle.draw()
  local SCALE = 0.1
  love.graphics.draw(reticle.sprite, reticle.x, reticle.y, 0, SCALE, SCALE,
    reticle.sprite:getWidth()/2, reticle.sprite:getHeight()/2)
end

function reticle.update(dt)
  local x, y = player_input:get 'aim'

  if player_input:getActiveDevice() == "joystick" then
    local DEADBAND = 0.2

    if x < -DEADBAND then
      reticle.x = reticle.x - reticle.speed*dt
    elseif x > DEADBAND then
      reticle.x = reticle.x + reticle.speed*dt
    end

    if y < -DEADBAND then
      reticle.y = reticle.y - reticle.speed*dt
    elseif y > DEADBAND then
      reticle.y = reticle.y + reticle.speed*dt
    end

    -- clamp reticle to edge of screen
    reticle.x = cpml.utils.clamp(reticle.x, 0, window.w)
    reticle.y = cpml.utils.clamp(reticle.y, 0, window.h)
  else
    reticle.x, reticle.y = love.mouse.getX(), love.mouse.getY()
  end
end

return reticle
