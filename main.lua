lovetoys = require("lib/lovetoys/lovetoys")
lovetoys.initialize({globals = true, debug = true})

PI = 3.14159
game_time = 0

require "requires"

STATE_SPLASH, STATE_MAINMENU, STATE_FILM, STATE_PLAY,
    STATE_PAUSE, STATE_DEATH, STATE_CONTINUE, STATE_WIN, STATE_OPTIONS,
    STATE_MOVIE_PLAY = 0,1,2,3,4,5,6,7,8,9


gamestates = {[0]=splash, [1]=mainmenu, [2]=film, [3]=play,
    [4]=pause, [5]=death, [6]=continue, [7]=win, [8]=options,
    [9]=movie_play}

function love.load()
  TILESIZE = 64
  print("LOAD")

  water_terrain = Terrain:new('water', 64, 64, 'water_open')        -- N E S W
  water_terrain:addTile('w', 'water_4side1',                  " * * * *")
  water_terrain:addTile('w', 'water_4side2',                  " * * * *")
  water_terrain:addTile('w', 'water_3side1',                  " *w* * *")
  water_terrain:addTile('w', 'water_3side2',                  " *w* * *")
  water_terrain:addTile('w', 'water_1side1',                  "ww wwwww")
  water_terrain:addTile('w', 'water_1side2',                  "ww wwwww")
  water_terrain:addTile('w', 'water_2side1',                  " www www")
  water_terrain:addTile('w', 'water_2side2',                  " www www")
  water_terrain:addTile('w', 'water_ecorner1',                " *www* *")
  water_terrain:addTile('w', 'water_ecorner2',                " *www* *")
  water_terrain:addTile('w', 'water_ecorner3',                " *www* *")
  water_terrain:addTile('w', 'water_ecorner4',                " *www* *")
  water_terrain:addTile('w', 'water_open',                    "wwwwwwww")
  water_terrain:addTile('w', 'water_1side2corners',           "w w w* *")
  water_terrain:addTile('w', 'water_2edge1',                  "w   w* *")
  water_terrain:addTile('w', 'water_2edge2',                  "w   w* *")
  water_terrain:addTile('w', 'water_4corners',                "w w w w ")
  water_terrain:addTile('w', 'water_edge1',                   "wwwww* *")
  water_terrain:addTile('w', 'water_edge2',                   "wwwww* *")
  water_terrain:addTile('w', 'water_edge3',                   "wwwww* *")
  water_terrain:addTile('w', 'water_edge4',                   "wwwww* *")
  water_terrain:addTile('w', 'water_icorner',                 "wwwwwww ")
  water_terrain:addTile('w', 'water_edgeandse1',             "www w* *")
  water_terrain:addTile('w', 'water_edgeandse2',             "www w* *")
  water_terrain:addTile('w', 'water_edgeandse3',             "www w* *")
  water_terrain:addTile('w', 'water_edgeandse4',             "www w* *")
  water_terrain:addTile('w', 'water_edgeandne1',             "w www* *")
  water_terrain:addTile('w', 'water_edgeandne2',             "w www* *")
  water_terrain:addTile('w', 'water_edgeandne3',             "w www* *")
  water_terrain:addTile('w', 'water_edgeandne4',             "w www* *")
  water_terrain:addTile('w', 'water_halfcorner1',            " www * *")
  water_terrain:addTile('w', 'water_ecorner1oppo',           "  w w  *")


  water_terrain:debugPrint()


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

  gamestage.current_stage = 1

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
  --local st = love.timer.getTime()
  gamestates[state].draw()

  -- debug
  --[[love.graphics.setFont(debug_font)
  love.graphics.setColor(50, 200, 100, 200)
  love.graphics.print("FPS: "..love.timer.getFPS(), 20, 20)
  local dc = love.graphics.getStats()
  love.graphics.print("draws: "..dc.drawcalls, 20, 40)
  love.graphics.print("switches: "..dc.canvasswitches.." / "..dc.shaderswitches, 20, 60)
  love.graphics.print(math.floor((love.timer.getTime() - st) * 1000000) / 1000 .. " ms", 20, 80)]]
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
