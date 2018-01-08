require "requires"

lovetoys.initialize({
    globals = true,
    debug = true
})

function love.load()
  TILESIZE = 64
  window = {w = love.graphics.getWidth(), h = love.graphics.getHeight()}

  image.init()

  mainmap = map:new(12, 16)
  mainmap:init_main()

  player.x = 300
  player.y = 300
  player.rot = 0

  player_input = controls.init()
  player_input.deadband = 0.2
  love.mouse.setCursor(love.mouse.getSystemCursor('crosshair'))
  love.mouse.setVisible(false)

  enemies = {}
  enemy_data.spawn("schmuck", 200, 200)
  enemy_data.spawn("schmuck", 300, 100)
  shots = {}

  game_time = 0
  timer.init()
end

function love.update(dt)
  game_time = game_time + dt

	player_input:update()
  player.update(dt)
  for _,z in pairs(enemies) do
    z:update(dt)
  end
  for _,z in pairs(shots) do
    z:update(dt)
  end
  camera.update(dt)
  timer.update(dt)
end

function love.draw()
  mainmap:draw()

  for _,z in pairs(enemies) do
    z:draw()
  end
  for _,z in pairs(shots) do
    z:draw()
  end

  player:draw()

  timer.draw()
end
