local timer = {
  timestamp = "0:00"
}


function timer.init()
  startTime = love.timer.getTime()
  timeStamp = string.format("%d:%02d",0,0)
end

function timer.update(dt)
  local elapsedTime = love.timer.getTime() - startTime
  local s = math.floor(elapsedTime % 60)
  local m = math.floor(elapsedTime / 60)
  timeStamp = string.format("%d:%02d",m,s)
end

function timer.draw()
  love.graphics.print(timeStamp, 750, 15)
end

return timer