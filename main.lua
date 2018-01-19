lovetoys = require("lib/lovetoys/lovetoys")
lovetoys.initialize({globals = true, debug = true})

PI = 3.14159
game_time = 0

require "requires"

STATE_SPLASH, STATE_MAINMENU, STATE_FILM, STATE_PLAY,
    STATE_PAUSE, STATE_DEATH, STATE_CONTINUE, STATE_WIN, STATE_OPTIONS= 0,1,2,3,4,5,6,7, 8

gamestates = {[0]=splash, [1]=mainmenu, [2]=film, [3]=play,
    [4]=pause, [5]=death, [6]=continue, [7]=win, [8]=options}

function love.load()
  TILESIZE = 64

  gui_time = love.timer.getTime()

  image.init()
  animation.init()
  audiomanager = AudioManager:new()
  electricity = ElectricSim:new()

  player_input, menu_input = controls.init()
  player_input.deadband = 0.2
  love.mouse.setCursor(love.mouse.getSystemCursor('crosshair'))
  love.mouse.setVisible(false)
  love.mouse.setGrabbed(true)

  init_settings()

  splash.enter()
  timer.init()
end

function love.update(dt)
  gui_time = love.timer.getTime()
  gui_flux.update(dt)
  gamestates[state].update(dt)
end

debug_font = love.graphics.newFont(12)
function love.draw()
  local st = love.timer.getTime()
  gamestates[state].draw()

  -- debug
  love.graphics.setFont(debug_font)
  love.graphics.setColor(50, 200, 100, 200)
  love.graphics.print("FPS: "..love.timer.getFPS(), 20, 20)
  local dc = love.graphics.getStats()
  love.graphics.print("draws: "..dc.drawcalls, 20, 40)
  love.graphics.print("switches: "..dc.canvasswitches.." / "..dc.shaderswitches, 20, 60)
  love.graphics.print(math.floor((love.timer.getTime() - st) * 1000000) / 1000 .. " ms", 20, 80)
  love.graphics.setColor(255, 255, 255, 255)
end

function love.focus(f)
  if f then
    love.mouse.setVisible(false)
    love.mouse.setGrabbed(true)
  else
    love.mouse.setVisible(true)
    love.mouse.setGrabbed(false)
    if state == STATE_PLAY then
      pause.enter()
    end
  end
end

function new_game()
  game_time = 0

  player.init()

  enemies = nil
  enemy_value = nil
  shots = nil
  doodads = nil
  sparks = nil

  current_dungeon = dungeon:new()
  current_dungeon:init(5, 4)
  current_dungeon:setup_main()

  dungeon.move_to_room(current_dungeon.start_x, current_dungeon.start_y, "west")
  pathfinder.rebuild_time = 0

  player:start_force_move(9999, player.speed, 0)

  fade.start_fade("fadein", 0.5, true)
  delay.start(0.5, function() player:end_force_move() end)
end
