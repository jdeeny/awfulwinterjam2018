local animation = {}

function animation.init()

  local tesla_grid = anim8.newGrid(64, 96, image.tesla:getWidth(), image.tesla:getHeight(), 0, 0, 0)
  animation.tesla_run_se = anim8.newAnimation(tesla_grid('4-10',1, '1-3', 1), 0.1)
  animation.tesla_run_ne = anim8.newAnimation(tesla_grid('4-10',2, '1-3', 2), 0.1)
  animation.tesla_run_sw = anim8.newAnimation(tesla_grid('4-10',1, '1-3', 1), 0.1):flipH()
  animation.tesla_run_nw = anim8.newAnimation(tesla_grid('4-10',2, '1-3', 2), 0.1):flipH()
  animation.tesla_idle_se = anim8.newAnimation(tesla_grid(11,1), 0.1)
  animation.tesla_idle_sw = anim8.newAnimation(tesla_grid(11,1), 0.1):flipH()

  local gear_grid = anim8.newGrid(64, 96, image.gear:getWidth(), image.gear:getHeight(), 0, 0, 0)
  animation.gear_spin_cw = anim8.newAnimation(gear_grid('1-6',1), 0.12)
  animation.gear_spin_ccw = anim8.newAnimation(gear_grid('6-1',1), 0.12)
end

return animation
