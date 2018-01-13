
require "math"
item = require "item"
cpml = require 'lib/cpml'
lovelightning = require "lib/lovelightning/lovelightning"
camera = require "camera"

local weapon = {}

-------------------------------------------------------------------------------
local Weapon = class("Weapon", item.Item)

function Weapon:_aquire_targets()
  -- override me and return a list of targets inform {x,y}
  return {}
end

function Weapon:initialize()
  self.firing_rate = 0.1 --shots/s
end

function Weapon:_fire(targets)
  -- override me
end

function Weapon:fire()
  if not self.next_shot_time or game_time > self.next_shot_time then
    self:_fire(self:_aquire_targets())
    self.next_shot_time = game_time + self.firing_rate
  end
end

function Weapon:update(dt)
  -- override me
end

-------------------------------------------------------------------------------
local ProjectileGun = class("ProjectileGun", Weapon)

function ProjectileGun:initialize()
  Weapon.initialize(self)
  self.shot_speed = 800
end


function ProjectileGun:_fire(targets)
  self.next_shot_time = shot_data.spawn("bullet", self.owner.x, self.owner.y, 
      math.cos(self.owner.aim)*self.owner.shot_speed, 
      math.sin(player.aim)*self.shot_speed, self.owner)
end

-------------------------------------------------------------------------------
local LightningGun = class("LightningGun", Weapon)

function LightningGun:initialize()
  Weapon.initialize(self)
  self.range = 300
  self.firing_arc = math.pi/6
  self.bolts = {}
  self.draw_time = 0.1
end

function LightningGun:_aquire_targets()
  local targets = {}
  
  -- get 2 unit vectors reprending your firing arc
  local aim_vec = cpml.vec2.new(math.cos(self.owner.aim),math.sin(self.owner.aim))
  local pos_vec = cpml.vec2.new(self.owner.x, self.owner.y)
  
  -- search for targets

  -- if no targets shoot straight ahead at nothing 
  if #targets == 0 then

    local vtarg = pos_vec+aim_vec*self.range
    table.insert(targets,{x=vtarg.x, y=vtarg.y})

  end
  
  return targets
end

function LightningGun:_fire(targets)
  if not self.owner.x or not targets then return end

  self.bolts = {}
  
  for _, t in ipairs(targets) do
    local newbolt = lovelightning:new(255,255,255)
    
    newbolt:create(camera.view_x(self.owner), camera.view_y(self.owner), 
      camera.view_x(t), camera.view_y(t))
    
    table.insert(self.bolts, newbolt)
  end
  
  self.fired_at = game_time
end

function LightningGun:update(dt)
  if self.bolts and self.fired_at then
    if game_time < self.fired_at + self.draw_time then
      for _, b in pairs(self.bolts) do
        b:update(dt)
      end
    else
      self.bolts = nil
    end
  end
end

function LightningGun:draw()
  if self.bolts then
    for _, b in pairs(self.bolts) do
        b:draw()
    end
  end
end


-------------------------------------------------------------------------------
weapon.ProjectileGun = ProjectileGun
weapon.LightningGun = LightningGun

return weapon
