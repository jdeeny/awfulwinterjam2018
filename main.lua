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
  reticle.init()

  shots = {}

  game_time = 0
end

function love.update(dt)
  game_time = game_time + dt

	player_input:update()
  reticle.update(dt)
  player.update(dt)
  for _,z in pairs(shots) do
    z:update(dt)
  end
  camera.update(dt)
end

function love.draw()
  mainmap:draw()

  for _,z in pairs(shots) do
    z:draw()
  end

  player.draw()

  reticle.draw()
end
