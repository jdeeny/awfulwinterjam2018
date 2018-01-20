local image = {}

function image.init()
  image.dude = love.graphics.newImage("assets/sprites/dude.png")
  image.gear = love.graphics.newImage("assets/sprites/gear.png")
  image.lumpgoon = love.graphics.newImage("assets/sprites/goon_sprite_sheet.png")

  image.sight_bullet_dot = love.graphics.newImage("assets/crosshairs/sight_bullet_dot.png")
  image.sight_bullet_line = love.graphics.newImage("assets/crosshairs/sight_bullet_line.png")
  image.sight_triangle = love.graphics.newImage("assets/crosshairs/sight_triangle.png")
  image.sight_v = love.graphics.newImage("assets/crosshairs/sight_v.png")

  image.wall = love.graphics.newImage("assets/tiles/wallStoneTiling.png")
  image.floor = love.graphics.newImage("assets/tiles/woodFloorTile.png")
  image.rubble = love.graphics.newImage("assets/tiles/woodFloorTileRubble.png")
  image.corner_nw = love.graphics.newImage("assets/tiles/wallStoneCorner.png")
  image.wallcorner_transition = love.graphics.newImage("assets/tiles/wallStoneCTransition.png")
  image.exit_north = love.graphics.newImage("assets/tiles/exit_north.png")
  image.exit_east = love.graphics.newImage("assets/tiles/exit_east.png")
  image.teleporter = love.graphics.newImage("assets/tiles/teleporter.png")
  image.ballpost = love.graphics.newImage("assets/tiles/aballonapost.png")

  image.bullet = love.graphics.newImage("assets/sprites/bullet.png")
  image.bullet_blue = love.graphics.newImage("assets/sprites/bullet_blue.png")

  image.spark = love.graphics.newImage("assets/sprites/spark.png")
  image.spark_big = love.graphics.newImage("assets/sprites/spark_big.png")
  image.spark_blue = love.graphics.newImage("assets/sprites/spark_blue.png")
  image.spark_big_blue = love.graphics.newImage("assets/sprites/spark_big_blue.png")
  image.pow = love.graphics.newImage("assets/sprites/pow.png")

  image.tesla = love.graphics.newImage("assets/sprites/tesla_sprite_sheet.png")

  image.tesla_arm_wrench = love.graphics.newImage("assets/sprites/tesla_arm_wrench.png")
  image.tesla_arm_gun = love.graphics.newImage("assets/sprites/tesla_arm_gun.png")
  image.tesla_arm_ray = love.graphics.newImage("assets/sprites/tesla_arm_ray.png")
  image.tesla_arm_lightning = love.graphics.newImage("assets/sprites/tesla_arm_lightning.png")

  image.intro = love.graphics.newImage("assets/fullscreen/silentFilmBack_template.png")

  image.gun_icon = love.graphics.newImage("assets/icons/gun.png")
  image.lightning_icon = love.graphics.newImage("assets/icons/lightning.png")
  image.ray_icon = love.graphics.newImage("assets/icons/ray.png")

  image.arrow = love.graphics.newImage("assets/icons/arrow.png")
  image.point = love.graphics.newImage("assets/icons/point.png")
  image.point_yellow = love.graphics.newImage("assets/icons/point_yellow.png")

  image.watermask = love.graphics.newImage("assets/tiles/water/watermask.jpg")
  image.watermask:setWrap('repeat', 'repeat')
  image.water = love.graphics.newImage("assets/tiles/water/waterbase.png")
  image.water_border = love.graphics.newImage("assets/tiles/water/waterborder.png")
  image.deadbody = love.graphics.newImage("assets/sprites/deadbody.png")
  image.chargemap = love.graphics.newImage("assets/sprites/chargemap.png")

  image.remotedude = love.graphics.newImage("assets/sprites/remoteBaddie_spriteSheet.png")

  image.heart = love.graphics.newImage("assets/icons/heart_32x32.png")
  image.patent_icon = love.graphics.newImage("assets/icons/patent.png")


end

return image
