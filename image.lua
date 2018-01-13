local image = {}

function image.init()
  image.dude = love.graphics.newImage("assets/sprites/dude.png")
  image.gear = love.graphics.newImage("assets/sprites/gear.png")

  image.reticle = love.graphics.newImage("assets/sprites/opengameart/crosshairs/circle-02.png")
  image.wall = love.graphics.newImage("assets/sprites/wall.png")
  image.floor = love.graphics.newImage("assets/sprites/floor.png")
  image.exit_north = love.graphics.newImage("assets/sprites/exit_north.png")
  image.exit_east = love.graphics.newImage("assets/sprites/exit_east.png")

  image.bullet = love.graphics.newImage("assets/sprites/bullet.png")
  image.tesla_se = love.graphics.newImage("assets/sprites/tesla-se.png")

  image.intro = love.graphics.newImage("assets/fullscreen/silentFilmBack_template.png")
end

return image
