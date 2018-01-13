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

  new_game()

  player_input, menu_input = controls.init()
  player_input.deadband = 0.2
  love.mouse.setCursor(love.mouse.getSystemCursor('crosshair'))
  love.mouse.setVisible(false)
  love.mouse.setGrabbed(true)

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

function new_game()
  player.sprite = 'tesla'
  player.facing_north = false
  player.facing_east = false
  player.speed = 300
  player.radius = 20
  player.max_hp = 100
  player.hp = 100
  player.next_shot_time = 0
  player.shot_delay = 0.1
  player.shot_speed = 800

  player.animations = {}
  player.animations['run_ne'] = animation.tesla_run_ne
  player.animations['run_se'] = animation.tesla_run_se
  player.animations['run_sw'] = animation.tesla_run_sw
  player.animations['run_nw'] = animation.tesla_run_nw
  player.animations['idle_ne'] = animation.tesla_idle_se
  player.animations['idle_se'] = animation.tesla_idle_se
  player.animations['idle_sw'] = animation.tesla_idle_sw
  player.animations['idle_nw'] = animation.tesla_idle_sw
  player.animation = player.animations['run_se']

  player.rot = 0
  player.aim = player.rot
  player.equipped_items = {}
  -- player:equip('weapon', weapon.LightningGun:new())
  player:equip('weapon', weapon.ProjectileGun:new())

  enemies = nil
  enemy_count = nil
  shots = nil
  doodads = nil

  current_dungeon = dungeon:new()
  current_dungeon:init(5, 4)
  current_dungeon:setup_main()
  dungeon.move_to_room(current_dungeon.start_x, current_dungeon.start_y, "west")

  game_time = 0
  player.start_force_move(player.speed, 0)
  fade.start_fade("fadein", 0, 0.5,
            function()
              player.end_force_move()
            end)
end

--]]