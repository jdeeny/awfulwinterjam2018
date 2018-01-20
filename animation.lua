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
  animation.lumpgoon_run_se = anim8.newAnimation(lump_grid('1-7',1), 0.4)
  animation.lumpgoon_run_ne = anim8.newAnimation(lump_grid('1-7',2), 0.4)
  animation.lumpgoon_run_sw = anim8.newAnimation(lump_grid('1-7',1), 0.4):flipH()
  animation.lumpgoon_run_nw = anim8.newAnimation(lump_grid('1-7',2), 0.4):flipH()
  animation.lumpgoon_idle_se = anim8.newAnimation(lump_grid('8-9',1), 0.6)
  animation.lumpgoon_idle_ne = anim8.newAnimation(lump_grid('8-9',2), 0.6)
  animation.lumpgoon_idle_sw = anim8.newAnimation(lump_grid('8-9',1), 0.6):flipH()
  animation.lumpgoon_idle_nw = anim8.newAnimation(lump_grid('8-9',2), 0.6):flipH()
end

return animation
