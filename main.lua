lovetoys = require("lib/lovetoys/lovetoys")
lovetoys.initialize({globals = true, debug = true})

require "requires"

function love.load()
  TILESIZE = 64
  window = {w = love.graphics.getWidth(), h = love.graphics.getHeight()}

  intro.init()
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
  game_state = 'main_menu'
  timer.init()
end

function love.update(dt)
  state.update(dt)
end

function love.draw()
  state.draw()
end
--]]
