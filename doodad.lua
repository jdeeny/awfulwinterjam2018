local doodad = class('doodad')

function doodad:draw()
  love.graphics.draw(image[self.sprite], camera.view_x(self), camera.view_y(self), 0, 1, 1,
    image[self.sprite]:getWidth()/2, image[self.sprite]:getHeight()/2)
end

return doodad
