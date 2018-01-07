require "requires"

lovetoys.initialize({
    globals = true,
    debug = true
})

function love.load()
  TILESIZE = 64
  window = {w = love.graphics.getWidth(), h = love.graphics.getHeight()}

  mainmap = map:new(12, 16)
  mainmap:init_main()

  player.x = 300
  player.y = 300
  player.rot = 0

  player_input = controls.init()
  reticle.init()
end

function love.update(dt)
	player_input:update()
  reticle.update(dt)
  player.update(dt)
  camera.update(dt)
end

function love.draw()
  mainmap:draw()
  player.draw()
  reticle.draw()
end
