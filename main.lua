require "requires"
require "reticle"
require "input"

lovetoys.initialize({
    globals = true,
    debug = true
})

function love.load()
  TILESIZE = 128

  mainmap = map:new(50, 30)
  mainmap:init_main()

  player.x = 100
  player.y = 100
  player.rot = 0

  reticle.initialize()
end

function love.update(dt)
	player_input:update()
  reticle.update(dt)
  player.update(dt)
end

function love.draw()
  player.draw()
  reticle.draw()
end
