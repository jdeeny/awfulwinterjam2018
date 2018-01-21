local super = require 'enemies/ai/seeker'
local Bouncer = class("Bouncer", Seeker)

function Bouncer:initialize(entity)
  super.initialize(self, entity)
  self.angle = self.entity.parameter or love.math.random() * 2 * math.pi
end

function Bouncer:update(dt)
  super.update(self, dt)
  self.entity.dx = math.cos(self.angle) * self.entity.speed
  self.entity.dy = math.sin(self.angle) * self.entity.speed
end

function Bouncer:react_to_collision(normal_x, normal_y)
  -- reflect off the wall
  -- all walls are rectangular so this is easy for now
  local dx, dy = math.cos(self.angle), math.sin(self.angle)
  if normal_x ~= 0 then dx = -dx end
  if normal_y ~= 0 then dy = -dy end
  self.angle = math.atan2(dy, dx)
end

return Bouncer
