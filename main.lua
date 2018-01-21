lovetoys = require("lib/lovetoys/lovetoys")
lovetoys.initialize({globals = true, debug = true})

PI = 3.14159
game_time = 0

require "requires"

STATE_SPLASH, STATE_MAINMENU, STATE_FILM, STATE_PLAY,
    STATE_PAUSE, STATE_DEATH, STATE_CONTINUE, STATE_WIN, STATE_OPTIONS,
    STATE_INTERTITLE, STATE_MOVIE_A = 0,1,2,3,4,5,6,7,8,9,10

gamestates = {[0]=splash, [1]=mainmenu, [2]=film, [3]=play,
    [4]=pause, [5]=death, [6]=continue, [7]=win, [8]=options,
    [9]=intertitle, [10]=movie_a}

function love.load()
  TILESIZE = 64
  print("LOAD")

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
  player.init()

  splash.enter()
  timer.init()
end

function love.update(dt)
  gui_time = love.timer.getTime()
  gui_flux.update(dt)
  gamestates[state].update(dt)
  if player_input:down('killall') then
    for _, z in pairs(enemies) do
      z:die()
    end
  end
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
