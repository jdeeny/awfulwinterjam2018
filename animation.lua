local animation = {}

function animation.init()

  local tesla_se_grid = anim8.newGrid(71, 72, image.tesla_se:getWidth(), image.tesla_se:getHeight(), 0, 0, 0)
  animation.tesla_run_se = anim8.newAnimation(tesla_se_grid('1-8',1), 0.1)

  local gear_grid = anim8.newGrid(64, 96, image.gear:getWidth(), image.gear:getHeight(), 0, 0, 0)
  animation.gear_spin_cw = anim8.newAnimation(gear_grid('1-6',1), 0.12)
  animation.gear_spin_ccw = anim8.newAnimation(gear_grid('6-1',1), 0.12)
end

return animation
