local animation = {}

function animation.init()

  local tesla_grid = anim8.newGrid(64, 96, image.tesla:getWidth(), image.tesla:getHeight(), 0, 0, 0)
  animation.tesla_run_se = anim8.newAnimation(tesla_grid('1-10',1), 0.12)
  animation.tesla_run_ne = anim8.newAnimation(tesla_grid('1-10',2), 0.12)
  animation.tesla_run_sw = anim8.newAnimation(tesla_grid('1-10',1), 0.12):flipH()
  animation.tesla_run_nw = anim8.newAnimation(tesla_grid('1-10',2), 0.12):flipH()
  animation.tesla_idle_se = anim8.newAnimation(tesla_grid(11,1), 0.8)
  animation.tesla_idle_sw = anim8.newAnimation(tesla_grid(11,1), 0.8):flipH()

  local gear_grid = anim8.newGrid(64, 72, image.gear:getWidth(), image.gear:getHeight(), 0, 0, 0)
  animation.gear_spin_cw = anim8.newAnimation(gear_grid('1-6',1), 0.12)
  animation.gear_spin_ccw = anim8.newAnimation(gear_grid('6-1',1), 0.12)

  local pow_grid = anim8.newGrid(128, 128, image.pow:getWidth(), image.pow:getHeight(), 0, 0, 0)
  animation.pow = anim8.newAnimation(pow_grid('1-4',1), 0.05)

  local shard_grid = anim8.newGrid(64, 16, image.shard:getWidth(), image.shard:getHeight(), 0, 0, 0)
  animation.shard = anim8.newAnimation(shard_grid('1-4',1), 0.1)

  local explosion_grid = anim8.newGrid(256, 256, image.explosion:getWidth(), image.explosion:getHeight(), 0, 0, 0)
  animation.explosion = anim8.newAnimation(explosion_grid('1-6',1), 0.06)

  local remotedude_grid = anim8.newGrid(64, 64, image.remotedude:getWidth(), image.remotedude:getHeight(), 0, 0, 0)
  animation.remotedude_red_run_se = anim8.newAnimation(remotedude_grid('1-1',1,'2-2',1), {0.5, 0.2})
  animation.remotedude_red_run_ne = anim8.newAnimation(remotedude_grid('3-3',1,'4-4',1), {0.5, 0.2})
  animation.remotedude_red_run_sw = anim8.newAnimation(remotedude_grid('1-1',1,'2-2',1), {0.5, 0.2}):flipH()
  animation.remotedude_red_run_nw = anim8.newAnimation(remotedude_grid('3-3',1,'4-4',1), {0.5, 0.2}):flipH()

  animation.remotedude_blue_run_se = anim8.newAnimation(remotedude_grid('1-1',2,'2-2',2), {0.5, 0.2})
  animation.remotedude_blue_run_ne = anim8.newAnimation(remotedude_grid('3-3',2,'4-4',2), {0.5, 0.2})
  animation.remotedude_blue_run_sw = anim8.newAnimation(remotedude_grid('1-1',2,'2-2',2), {0.5, 0.2}):flipH()
  animation.remotedude_blue_run_nw = anim8.newAnimation(remotedude_grid('3-3',2,'4-4',2), {0.5, 0.2}):flipH()

  animation.remotedude_green_run_se = anim8.newAnimation(remotedude_grid('1-1',3,'2-2',3), {0.5, 0.2})
  animation.remotedude_green_run_ne = anim8.newAnimation(remotedude_grid('3-3',3,'4-4',3), {0.5, 0.2})
  animation.remotedude_green_run_sw = anim8.newAnimation(remotedude_grid('1-1',3,'2-2',3), {0.5, 0.2}):flipH()
  animation.remotedude_green_run_nw = anim8.newAnimation(remotedude_grid('3-3',3,'4-4',3), {0.5, 0.2}):flipH()

  animation.remotedude_red_idle = anim8.newAnimation(remotedude_grid(1,1), 0.5)
  animation.remotedude_blue_idle = anim8.newAnimation(remotedude_grid(1,2), 0.5)
  animation.remotedude_green_idle = anim8.newAnimation(remotedude_grid(1,3), 0.5)

  local lump_grid = anim8.newGrid(64, 96, image.lumpgoon:getWidth(), image.lumpgoon:getHeight(), 0, 0, 0)
  animation.lumpgoon_run_se = anim8.newAnimation(lump_grid('1-7',1), 0.8)
  animation.lumpgoon_run_ne = anim8.newAnimation(lump_grid('1-7',2), 0.8)
  animation.lumpgoon_run_sw = anim8.newAnimation(lump_grid('1-7',1), 0.8):flipH()
  animation.lumpgoon_run_nw = anim8.newAnimation(lump_grid('1-7',2), 0.8):flipH()
  animation.lumpgoon_idle_se = anim8.newAnimation(lump_grid('8-9',1), 0.8)
  animation.lumpgoon_idle_ne = anim8.newAnimation(lump_grid('8-9',2), 0.8)
  animation.lumpgoon_idle_sw = anim8.newAnimation(lump_grid('8-9',1), 0.8):flipH()
  animation.lumpgoon_idle_nw = anim8.newAnimation(lump_grid('8-9',2), 0.8):flipH()

  local canbot_grid = anim8.newGrid(64, 96, image.canbot:getWidth(), image.canbot:getHeight(), 0, 0, 0)
  animation.canbot_run_se = anim8.newAnimation(canbot_grid('1-4',1), 0.8)
  animation.canbot_run_ne = anim8.newAnimation(canbot_grid('1-4',2), 0.8)
  animation.canbot_run_sw = anim8.newAnimation(canbot_grid('1-4',1), 0.8):flipH()
  animation.canbot_run_nw = anim8.newAnimation(canbot_grid('1-4',2), 0.8):flipH()
  animation.canbot_idle_se = anim8.newAnimation(canbot_grid('5-6',1), 0.8)
  animation.canbot_idle_ne = anim8.newAnimation(canbot_grid('5-6',2), 0.8)
  animation.canbot_idle_sw = anim8.newAnimation(canbot_grid('5-6',1), 0.8):flipH()
  animation.canbot_idle_nw = anim8.newAnimation(canbot_grid('5-6',2), 0.8):flipH()
  animation.canbot_hurt_se = anim8.newAnimation(canbot_grid('7-7',1), 0.8)
  animation.canbot_hurt_ne = anim8.newAnimation(canbot_grid('7-7',2), 0.8)
  animation.canbot_hurt_sw = anim8.newAnimation(canbot_grid('7-7',1), 0.8):flipH()
  animation.canbot_hurt_nw = anim8.newAnimation(canbot_grid('7-7',2), 0.8):flipH()


  local pinkerton_grid = anim8.newGrid(64, 96, image.pinkerton:getWidth(), image.pinkerton:getHeight(), 0, 0, 0)
  animation.pinkerton_run_sw = anim8.newAnimation(pinkerton_grid('1-10',2), 0.8)
  animation.pinkerton_run_nw = anim8.newAnimation(pinkerton_grid('1-10',1), 0.8)
  animation.pinkerton_run_se = anim8.newAnimation(pinkerton_grid('1-10',2), 0.8):flipH()
  animation.pinkerton_run_ne = anim8.newAnimation(pinkerton_grid('1-10',1), 0.8):flipH()
  animation.pinkerton_idle_sw = anim8.newAnimation(pinkerton_grid('1-1',3), 0.8)
  animation.pinkerton_idle_nw = anim8.newAnimation(pinkerton_grid('2-2',3), 0.8)
  animation.pinkerton_idle_se = anim8.newAnimation(pinkerton_grid('1-1',3), 0.8):flipH()
  animation.pinkerton_idle_ne = anim8.newAnimation(pinkerton_grid('2-2',3), 0.8):flipH()
  animation.pinkerton_hurt_se = anim8.newAnimation(pinkerton_grid('9-9',3), 0.8)
  animation.pinkerton_hurt_ne = anim8.newAnimation(pinkerton_grid('10-10',3), 0.8)
  animation.pinkerton_hurt_sw = anim8.newAnimation(pinkerton_grid('9-9',3), 0.8):flipH()
  animation.pinkerton_hurt_nw = anim8.newAnimation(pinkerton_grid('10-10',3), 0.8):flipH()


end

return animation
