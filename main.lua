lovetoys = require("lib/lovetoys/lovetoys")
lovetoys.initialize({globals = true, debug = true})

require "requires"

function love.load()
  TILESIZE = 64
  window = {w = love.graphics.getWidth(), h = love.graphics.getHeight()}

  image.init()
  animation.init()
  sound.init()

  enemies = nil
  enemy_count = nil
  shots = nil
  doodads = nil
  current_dungeon = dungeon:new()
  dungeon.move_to_room()

  player.x = 300
  player.y = 300
  player.rot = 0
  player:equip('weapon', weapon.ProjectileGun:new())

  player_input, menu_input = controls.init()
  player_input.deadband = 0.2
  love.mouse.setCursor(love.mouse.getSystemCursor('crosshair'))
  love.mouse.setVisible(false)
  love.mouse.setGrabbed(true)

  game_time = 0
  game_state = 'intro'
  timer.init()
end

function love.update(dt)
  if game_state == 'intro' then
    player_input:update()
    if player_input:pressed('pause') then
      game_state = 'play'
    else

    end
  elseif game_state == 'play' then
	  player_input:update()

    if player_input:pressed('pause') then
      game_state = 'pause'
    else
      game_time = game_time + dt

      player.update(dt)

      for _,z in pairs(enemies) do
        z:update(dt)
      end

      for _,z in pairs(shots) do
        z:update(dt)
      end

      camera.update(dt)
      timer.update()
    end

  elseif game_state == 'pause' then
      menu_input:update()
      menu.update(dt)
      timer.update()
  end
end

function love.draw()
  if game_state == 'intro' then
    intro.draw()
  else
    if game_state == 'pause' then
      love.graphics.setShader(menu.background_shader)
    end
    current_room:draw()

    for _,z in pairs(doodads) do
  	   z:draw()
     end
    for _,z in pairs(enemies) do
      z:draw()
    end
    for _,z in pairs(shots) do
      z:draw()
    end

    player:draw()
    timer.draw()
    player:draw_hp()

    if game_state == 'pause' then
      love.graphics.setShader()
      menu.draw()
    end
  end
end
--]]
