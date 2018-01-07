require "requires"
require "reticle"
require "input"

lovetoys.initialize({
    globals = true,
    debug = true
})

function love.load()
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
