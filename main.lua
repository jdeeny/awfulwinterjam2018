lovetoys = require("lib/lovetoys/lovetoys")
lovetoys.initialize({globals = true, debug = true})

require "requires"

function love.load()
  TILESIZE = 64
  window = {w = love.graphics.getWidth(), h = love.graphics.getHeight()}

  film.init()
  image.init()
  animation.init()
  sound_manager.init()

  enemies = nil
  enemy_count = nil
  shots = nil
  doodads = nil
  current_dungeon = dungeon:new()
  current_dungeon:init(5, 4)
  current_dungeon:setup_main()
  dungeon.move_to_room(current_dungeon.start_x, current_dungeon.start_y, "west")
  player.start_force_move(player.speed, 0)
  fade.start_fade("fadein", 0, 0.5,
            function()
              player.end_force_move()
            end)

  player.rot = 0
  player.aim = player.rot
  -- player:equip('weapon', weapon.LightningGun:new())
  player:equip('weapon', weapon.ProjectileGun:new())


  player_input, menu_input = controls.init()
  player_input.deadband = 0.2
  love.mouse.setCursor(love.mouse.getSystemCursor('crosshair'))
  love.mouse.setVisible(false)
  love.mouse.setGrabbed(true)

  game_time = 0
  game_state = 'main_menu'
  timer.init()
end

function love.update(dt)
  state.update(dt)
  sound_manager.update(dt)
end

function love.draw()
  state.draw()
end
--]]
