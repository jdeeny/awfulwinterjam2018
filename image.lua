local image = {}

function image.init()
  image.dude = love.graphics.newImage("assets/sprites/dude.png")
  image.gear = love.graphics.newImage("assets/sprites/gear.png")

  image.reticle = love.graphics.newImage("assets/sprites/opengameart/crosshairs/circle-02.png")

  image.wall = love.graphics.newImage("assets/tiles/wallStoneTiling.png")
  image.floor = love.graphics.newImage("assets/tiles/woodFloorTile.png")
  image.corner_nw = love.graphics.newImage("assets/tiles/wallStoneCorner.png")
  image.wallcorner_transition = love.graphics.newImage("assets/tiles/wallStoneCTransition.png")
  image.exit_north = love.graphics.newImage("assets/tiles/exit_north.png")
  image.exit_east = love.graphics.newImage("assets/tiles/exit_east.png")
  image.teleporter = love.graphics.newImage("assets/tiles/teleporter.png")

  image.bullet = love.graphics.newImage("assets/sprites/bullet.png")

  image.spark = love.graphics.newImage("assets/sprites/spark.png")
  image.spark_big = love.graphics.newImage("assets/sprites/spark_big.png")

  image.tesla = love.graphics.newImage("assets/sprites/tesla_sprite_sheet.png")

  image.intro = love.graphics.newImage("assets/fullscreen/silentFilmBack_template.png")
end

return image
