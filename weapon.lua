
require "math"
item = require "item"
cpml = require 'lib/cpml'
lovelightning = require "lib/lovelightning/lovelightning"
camera = require "camera"
weapon = {}
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
      math.cos(self.owner.rot)*self.owner.shot_speed, 
      math.sin(player.rot)*self.shot_speed, self.owner)
end

-------------------------------------------------------------------------------
local LightningGun = class("LightningGun", Weapon)

function LightningGun:initialize()
  Weapon.initialize(self)
  self.range = 300
  self.firing_arc = math.pi/6
  self.bolts = {} 
end

function LightningGun:_aquire_targets()
  local targets = {}
  
  -- get 2 unit vectors reprending your firing arc
  local aim_vec = cpml.vec2.new(math.cos(self.owner.rot),math.sin(self.owner.rot))
  local pos_vec = cpml.vec2.new(self.owner.x, self.owner.y)
  
  for _, z in ipairs(enemies) do 
      local they_vec = cpml.vec2.new(z.x,z.y)
      
  end

  if #targets == 0 then

    local unit_rot = cpml.vec2.new(co)
    -- make up a fake target range pixes ahead
    table.insert(targets,{x=self.owner.x+300,y=self.owner.y+300})

  end
  
  return targets
end

function LightningGun:_fire(targets)
  self.bolts = {}
  for _, t in ipairs(targets) do
    local newbolt = lovelightning:new(255,255,255)
    local as = {x = self.owner.x, y = self.owner.y}
    local at = {x = t.x, y = t.y}
    newbolt:create(camera.view_x(as), camera.view_y(as), 
      camera.view_x(at), camera.view_y(at))
    
    table.insert(self.bolts, newbolt)
  end
  -- body
end

function LightningGun:update(dt)
  for _, b in pairs(self.bolts) do
    b:update(dt)
  end
end


function LightningGun:draw()
  if self.bolts ~= nil then
    for _, b in pairs(self.bolts) do
        b:draw()
    end
  end
end


-------------------------------------------------------------------------------
weapon.ProjectileGun = ProjectileGun
weapon.LightningGun = LightningGun

return weapon