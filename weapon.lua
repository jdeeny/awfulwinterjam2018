
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
  self.sound = "snap"
end


function ProjectileGun:_fire(targets)
  angle = self.owner.aim + (love.math.random() - 0.5) * math.pi * 0.1
  self.next_shot_time = shot_data.spawn("bullet", self.owner.x, self.owner.y,
      math.cos(angle)*self.owner.shot_speed,
      math.sin(angle)*self.shot_speed, self.owner)
  audiomanager:playOnce(self.sound)
  camera.bump(6, self.owner.aim)
end

-------------------------------------------------------------------------------
local LightningGun = class("LightningGun", Weapon)

function LightningGun:initialize()
  Weapon.initialize(self)
  self.range = 400
  self.firing_arc = math.pi/6
  self.bolts = {}
  self.draw_time = 0.1
  self.damage = 100
  self.firing_rate = 0.1
  self.chain_targets = 1
  -- self.sound = "tesla_coil_long"
end

function LightningGun:_aquire_targets()
  local targets = {}

  -- player vectors
  local aim_vec = cpml.vec2.new(math.cos(self.owner.aim),math.sin(self.owner.aim))
  local pos_vec = cpml.vec2.new(self.owner.x, self.owner.y)

  -- search for targets
  for _, z in pairs(enemies) do
    local ven = cpml.vec2.new(z.x, z.y)-pos_vec -- vector to the enemy
    if cpml.vec2.angle_between(aim_vec, ven) < self.firing_arc/2 and
        cpml.vec2.len(ven) < self.range then
      table.insert(targets,z)
    end
  end

  return targets
end

function LightningGun:_fire(targets)
  if not self.owner.x then return end

  self.fork_targets = {}

  -- if no targets shoot straight ahead at nothing
  if not targets or #targets == 0 then

    local aim_vec = cpml.vec2.new(math.cos(self.owner.aim),math.sin(self.owner.aim))
    local pos_vec = cpml.vec2.new(self.owner.x, self.owner.y)

    local vtarg = pos_vec+aim_vec*50

    local newbolt = lovelightning:new(255,255,255)
    newbolt.power = .5
    newbolt.jitter_factor = 0.75
    newbolt.fork_chance = 0.9
    newbolt.max_fork_angle = math.pi/3
    newbolt.iterations = 4

    newbolt:setSource({x=camera.view_x(self.owner), y=camera.view_y(self.owner)})
    newbolt:setPrimaryTarget({x=camera.view_x(vtarg), y=camera.view_y(vtarg)})
    newbolt:create()

    table.insert(self.bolts, newbolt)
  
  else
    local last_target = self.owner
    for i, t in ipairs(targets) do
      if i <= self.chain_targets then
        local newbolt = lovelightning:new(255,255,255)
    
        newbolt:setForkTargets(targets)
        newbolt:setSource({x=camera.view_x(last_target), y=camera.view_y(last_target)})
        newbolt:setPrimaryTarget({x=camera.view_x(t), y=camera.view_y(t)})

        newbolt:create(function (ftarg, level)
            table.insert(self.fork_targets,{target=ftarg,level=level})  
          end)
        table.insert(self.bolts, newbolt)
        last_target = t
      end      
    end
  end


  self.fired_at = game_time
  self.targets = targets
end

function LightningGun:update(dt)
  if self.bolts and self.fired_at then
    if game_time < self.fired_at + self.draw_time then

      for _, b in pairs(self.bolts) do
        b:update(dt)
      end

    else
      if self.targets and #self.targets > 0 then
        for _, t in pairs(self.targets) do
          if t.take_damage then t:take_damage(self.damage) end
        end
      end
      self.bolts = {}
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
