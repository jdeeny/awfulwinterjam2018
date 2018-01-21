local crosshairs = { offset = 0, use_mouse = false, draw_cursor = true }

function crosshairs.draw(center_x, center_y)
  local center_x, center_y
  if crosshairs.use_mouse then
    center_x, center_y = love.mouse.getPosition()
  elseif player.aim and crosshairs.draw_cursor then
    if player.equipped_items['weapon'].is_firing then
      local distance = math.min(3 * TILESIZE, window.w * 0.5 - 150, window.h * 0.5 - 150)
      center_x = camera.view_x(player) + distance * math.cos(player.aim)
      center_y = camera.view_y(player) + distance * math.sin(player.aim)
    else
      -- don't draw
      crosshairs.offset = 0
      return
    end
  end

  if not center_x or not center_y then return end

  if player.equipped_items['weapon'].name == 'ProjectileGun' then
    love.graphics.setColor(255,200,100,255)
    crosshairs.offset = 0.5 * (crosshairs.offset + player.equipped_items['weapon'].cof_multiplier)
    love.graphics.draw(image['sight_bullet_dot'], center_x, center_y, 0, 1, 1, 8, 8)
    love.graphics.draw(image['sight_bullet_line'], center_x + 16 + 32*crosshairs.offset, center_y, 0, 1, 1, 16, 8)
    love.graphics.draw(image['sight_bullet_line'], center_x , center_y + 16 + 32*crosshairs.offset, math.pi * 0.5, 1, 1, 16, 8)
    love.graphics.draw(image['sight_bullet_line'], center_x - 16 - 32*crosshairs.offset, center_y, math.pi, 1, 1, 16, 8)
    love.graphics.draw(image['sight_bullet_line'], center_x, center_y - 16 - 32*crosshairs.offset, math.pi * 1.5, 1, 1, 16, 8)
  elseif player.equipped_items['weapon'].name == 'RayGun' then
    love.graphics.setColor(180,120,255,255)
    if player.equipped_items['weapon'].is_firing then
      crosshairs.offset = 0.5 * (crosshairs.offset + (1.125 - 1.25 * player.equipped_items['weapon'].focus))
    else
      crosshairs.offset = 0.5 * crosshairs.offset
    end

    love.graphics.draw(image['sight_bullet_dot'], center_x, center_y, 0, 1, 1, 8, 8)
    local r
    for j = 1, 7 do
      r = 0.3 + 3 * crosshairs.offset + 0.89759790102 * j
      love.graphics.draw(image['sight_triangle'],
        center_x + math.cos(r) * (64 - 32*crosshairs.offset),
        center_y + math.sin(r) * (64 - 32*crosshairs.offset),
        r, 1, 1, 16, 16)
    end
  elseif player.equipped_items['weapon'].name == 'LightningGun' then
    love.graphics.setColor(130,230,255,255)

    if player.equipped_items['weapon'].is_firing then
      crosshairs.offset = 0.5 * (crosshairs.offset + 1)
    else
      crosshairs.offset = 0.5 * crosshairs.offset
    end

    local r
    local radius = 32 + (28 + 8 * love.math.random())*crosshairs.offset
    for j = 1, 3 do
      r = (player.aim + math.pi or 0) + 2.09439510239 * j
      love.graphics.draw(image['sight_v'],
        center_x + math.cos(r) * radius,
        center_y + math.sin(r) * radius,
        r, 1, 1, 16, 16)
    end
  end
  love.graphics.setColor(255,255,255,255)
end

return crosshairs
