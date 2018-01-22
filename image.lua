local image = {}

function image.init()
  image.void = love.graphics.newImage("assets/tiles/void.png")
  image.dude = love.graphics.newImage("assets/sprites/dude.png")
  image.gear = love.graphics.newImage("assets/sprites/gear.png")
  image.lumpgoon = love.graphics.newImage("assets/sprites/goon_sprite_sheet.png")
  image.canbot = love.graphics.newImage("assets/sprites/canbot_sprite_sheet.png")
  image.pinkerton = love.graphics.newImage("assets/sprites/pinkerton_sprite_sheet.png")
  image.sniper = love.graphics.newImage("assets/sprites/sniper_sprite_sheet.png")


  image.sight_bullet_dot = love.graphics.newImage("assets/crosshairs/sight_bullet_dot.png")
  image.sight_bullet_line = love.graphics.newImage("assets/crosshairs/sight_bullet_line.png")
  image.sight_triangle = love.graphics.newImage("assets/crosshairs/sight_triangle.png")
  image.sight_v = love.graphics.newImage("assets/crosshairs/sight_v.png")

  image.wall = love.graphics.newImage("assets/tiles/void.png")
  image.wall_southface = love.graphics.newImage("assets/tiles/wallStoneTiling.png")
  image.wall_southdoor = love.graphics.newImage("assets/tiles/door.png")
  image.invinciblewall = image.wall
  image.invinciblewall_southface = image.wall_southface
  image.invinciblewall_southdoor = image.wall_southdoor
  image.door = love.graphics.newImage("assets/tiles/void.png")
  image.door_southface = love.graphics.newImage("assets/tiles/door.png")
  image.floor = love.graphics.newImage("assets/tiles/woodFloorTile.png")
  image.opendoor = image.floor
  image.fakedoor = image.floor
  image.rubble = love.graphics.newImage("assets/tiles/woodFloorTileRubble.png")
  image.corner_nw = love.graphics.newImage("assets/tiles/wallStoneCorner.png")
  image.wallcorner_transition = love.graphics.newImage("assets/tiles/wallStoneCTransition.png")
  image.exit_north = love.graphics.newImage("assets/tiles/exit_north.png")
  image.exit_east = love.graphics.newImage("assets/tiles/exit_east.png")
  image.teleporter = love.graphics.newImage("assets/tiles/teleporter.png")
  image.ballpost = love.graphics.newImage("assets/tiles/aballonapost.png")

  image.bullet = love.graphics.newImage("assets/sprites/bullet.png")
  image.bullet_blue = love.graphics.newImage("assets/sprites/bullet_blue.png")
  image.rocket_red = love.graphics.newImage("assets/sprites/rocket_red.png")
  image.rocket_green = love.graphics.newImage("assets/sprites/rocket_green.png")

  image.spark = love.graphics.newImage("assets/sprites/spark.png")
  image.spark_big = love.graphics.newImage("assets/sprites/spark_big.png")
  image.spark_blue = love.graphics.newImage("assets/sprites/spark_blue.png")
  image.spark_big_blue = love.graphics.newImage("assets/sprites/spark_big_blue.png")
  image.pow = love.graphics.newImage("assets/sprites/pow.png")
  image.shard = love.graphics.newImage("assets/sprites/shard.png")
  image.explosion = love.graphics.newImage("assets/sprites/explosion.png")
  image.muzzle1 = love.graphics.newImage("assets/sprites/muzzle1.png")
  image.muzzle2 = love.graphics.newImage("assets/sprites/muzzle2.png")
  image.muzzle3 = love.graphics.newImage("assets/sprites/muzzle3.png")
  image.muzzle4 = love.graphics.newImage("assets/sprites/muzzle4.png")
  image.muzzle5 = love.graphics.newImage("assets/sprites/muzzle5.png")

  image.tesla = love.graphics.newImage("assets/sprites/tesla_sprite_sheet.png")

  image.tesla_arm_wrench = love.graphics.newImage("assets/sprites/tesla_arm_wrench.png")
  image.tesla_arm_gun = love.graphics.newImage("assets/sprites/tesla_arm_gun.png")
  image.tesla_arm_ray = love.graphics.newImage("assets/sprites/tesla_arm_ray.png")
  image.tesla_arm_lightning = love.graphics.newImage("assets/sprites/tesla_arm_lightning.png")

  image.intro = love.graphics.newImage("assets/fullscreen/silentFilmBack_template.png")

  image.gun_icon = love.graphics.newImage("assets/icons/gun.png")
  image.lightning_icon = love.graphics.newImage("assets/icons/lightning.png")
  image.ray_icon = love.graphics.newImage("assets/icons/ray.png")

  image.timer_bg = love.graphics.newImage("assets/icons/timer_bg.png")
  image.bar = love.graphics.newImage("assets/icons/bar.png")
  image.bar_shading = love.graphics.newImage("assets/icons/bar_shading.png")

  image.arrow = love.graphics.newImage("assets/icons/arrow.png")
  image.point = love.graphics.newImage("assets/icons/point.png")
  image.point_yellow = love.graphics.newImage("assets/icons/point_yellow.png")

  image.watershape = love.graphics.newImage("assets/tiles/water/watermask.jpg")
  image.watershape:setWrap('repeat', 'repeat')
  image.water = love.graphics.newImage("assets/tiles/water/waterbase.png")
  image.water:setWrap('repeat', 'repeat')
  image.water_border = love.graphics.newImage("assets/tiles/water/waterborder.png")


image.water_surround1 = love.graphics.newImage("assets/tiles/water/4side1.png")
image.water_surround2 = love.graphics.newImage("assets/tiles/water/4side2.png")
image.water_e1 = love.graphics.newImage("assets/tiles/water/3side1.png")
image.water_e2 = love.graphics.newImage("assets/tiles/water/3side2.png")
image.water_nw1 = love.graphics.newImage("assets/tiles/water/ecorner1.png")
image.water_nw2 = love.graphics.newImage("assets/tiles/water/ecorner2.png")
image.water_nw3 = love.graphics.newImage("assets/tiles/water/ecorner3.png")
image.water_nw4 = love.graphics.newImage("assets/tiles/water/ecorner4.png")
image.water_allbute1 = love.graphics.newImage("assets/tiles/water/3side1.png")
image.water_allbute2 = love.graphics.newImage("assets/tiles/water/3side2.png")
image.water_singleisland1 = love.graphics.newImage("assets/tiles/water/4side1.png")
image.water_singleisland2 = love.graphics.newImage("assets/tiles/water/4side2.png")
image.water_ns1 = love.graphics.newImage("assets/tiles/water/2edge1.png")
image.water_ns2 = love.graphics.newImage("assets/tiles/water/2edge2.png")
image.water_cross = love.graphics.newImage("assets/tiles/water/4corners.png")
image.water_t_nes = love.graphics.newImage("assets/tiles/water/1side2corners.png")
image.water_open = love.graphics.newImage("assets/tiles/water/open.png")
image.water_edge1 = love.graphics.newImage("assets/tiles/water/edge1.png")
image.water_edge2 = love.graphics.newImage("assets/tiles/water/edge2.png")
image.water_edge3 = love.graphics.newImage("assets/tiles/water/edge3.png")
image.water_edge4 = love.graphics.newImage("assets/tiles/water/edge4.png")

image.title1 = love.graphics.newImage("assets/titles/title1.jpg")
image.title2 = love.graphics.newImage("assets/titles/title2.jpg")
image.title3 = love.graphics.newImage("assets/titles/title3.jpg")

  image.deadbody = love.graphics.newImage("assets/sprites/deadbody.png")
  image.chargemap = love.graphics.newImage("assets/sprites/chargemap.png")

  image.remotedude = love.graphics.newImage("assets/sprites/remoteBaddie_spriteSheet.png")

  image.heart = love.graphics.newImage("assets/icons/heart_32x32.png")
  image.patent_icon = love.graphics.newImage("assets/icons/patent.png")

  image.capacitor = love.graphics.newImage("assets/tiles/capacitor.png")



end

return image
