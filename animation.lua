local animation = {}

function animation.init()

  local tesla_se_grid = anim8.newGrid(71, 72, image.tesla_se:getWidth(), image.tesla_se:getHeight(), 0, 0, 0)
  animation.tesla_run_se = anim8.newAnimation(tesla_se_grid('1-8',1), 0.1)
end

return animation
