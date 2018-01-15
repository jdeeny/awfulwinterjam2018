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
  image.ballpost = love.graphics.newImage("assets/tiles/aballonapost.png")

  image.bullet = love.graphics.newImage("assets/sprites/bullet.png")

  image.spark = love.graphics.newImage("assets/sprites/spark.png")
  image.spark_big = love.graphics.newImage("assets/sprites/spark_big.png")

  image.tesla = love.graphics.newImage("assets/sprites/tesla_sprite_sheet.png")

  image.intro = love.graphics.newImage("assets/fullscreen/silentFilmBack_template.png")

  image.gun_icon = love.graphics.newImage("assets/icons/gun.png")
  image.lightning_icon = love.graphics.newImage("assets/icons/lightning.png")
  
  image.arrow = love.graphics.newImage("assets/icons/arrow.png") -- up arrow; rotate for other directions

  image.watermask = love.graphics.newImage("assets/tiles/water/watermask.jpg")
  image.watermask:setWrap('repeat', 'repeat')
  image.water = love.graphics.newImage("assets/tiles/water/waterbase.png")
  image.water_border = love.graphics.newImage("assets/tiles/water/waterborder.png")

  image.chargemap = love.graphics.newImage("assets/sprites/chargemap.png")
end

return image
