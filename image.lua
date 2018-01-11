local image = {}

function image.init()
  image.dude = love.graphics.newImage("assets/sprites/dude.png")

  image.reticle = love.graphics.newImage("assets/sprites/opengameart/crosshairs/circle-02.png")
  image.wall = love.graphics.newImage("assets/sprites/wall.png")
  image.floor = love.graphics.newImage("assets/sprites/floor.png")

  image.bullet = love.graphics.newImage("assets/sprites/bullet.png")
end

return image
