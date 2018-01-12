local intro = {}

function intro.draw()
  love.graphics.draw(image.intro, 0, 0, 0, window.w / image.intro:getWidth(), window.h / image.intro:getHeight())
end


return intro
