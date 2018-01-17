
require "math"
item = require "item"
cpml = require 'lib/cpml'
lovelightning = require "effects/lovelightning"
camera = require "camera"


local weapon = {}

-------------------------------------------------------------------------------
local Weapon = class("Weapon", item.Item)

function Weapon:_aquire_targets()
  -- override me and return a list of targets inform {x,y}
  return {}
end

function Weapon:initialize()
   -- Weapon.initialize(self) -- super class init, uncomment when subclassing
  self.firing_rate = 0.1 --shots/s
end

function Weapon:_fire(targets)
  -- override me
end


function Weapon:update(dt)
  -- override me
end

function Weapon:fire()
  if not self.next_shot_time or game_time > self.next_shot_time then
    self:_fire(self:_aquire_targets())
    self.next_shot_time = game_time + self.firing_rate
  end
end

function Weapon:release()
  -- body
end
-------------------------------------------------------------------------------
local ProjectileGun = class("ProjectileGun", Weapon)

function ProjectileGun:initialize()
  Weapon.initialize(self)
  self.shot_speed = 800
  self.sound = "gunshot"
  self.icon = "gun_icon"
  self.projectile = "bullet"
end


function ProjectileGun:_fire(targets)
  angle = self.owner.aim + (love.math.random() - 0.5) * math.pi * 0.1
  self.next_shot_time = shot_data.spawn(self.projectile, self.owner.x, self.owner.y,
      math.cos(angle)*(self.owner.shot_speed or self.shot_speed),
      math.sin(angle)*(self.owner.shot_speed or self.shot_speed), self.owner)
  audiomanager:playOnce(self.sound)
  camera.bump(6, self.owner.aim)
  self.owner:be_knocked_back(0.1, -100 * math.cos(angle), -100 * math.sin(angle))
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
  self.icon = "lightning_icon"
end

function LightningGun:_aquire_targets()
  local targets = {}

  -- player vectors
  local aim_vec = cpml.vec2.new(math.cos(self.owner.aim),math.sin(self.owner.aim))
  local pos_vec = cpml.vec2.new(self.owner.x, self.owner.y)

  -- search for targets
  for _, z in pairs(enemies) do
    local ven = cpml.vec2.new(z.x, z.y)
    local v_to_en = ven-pos_vec -- vector to the enemy

    if (cpml.vec2.angle_between(aim_vec, v_to_en) < self.firing_arc/2 and
        cpml.vec2.len(v_to_en) < self.range) or cpml.vec2.len(v_to_en) < 50 then
      table.insert(targets,z)
    end

  end

  return targets
end

function LightningGun:_fire(targets)

  if not self.owner.x then return end

  self.fork_targets = {}

  local fired_at_targets = {}

  local nodes = electricity:nodesincircle(self.owner.x, self.owner.y, self.range)

  if not self.sound_hum then
    self.sound_hum = audiomanager.sources['tesla_hum1'].source:clone()
    self.sound_hum:setVolume(0.5)
    self.sound_hum:play()
  end
  -- audiomanager:playLooped('car1', 100, 'car2', 'car3')

  -- if no targets shoot straight ahead at nothing
  if not targets or #targets == 0 then

    local aim_vec = cpml.vec2.new(math.cos(self.owner.aim),math.sin(self.owner.aim))
    local pos_vec = cpml.vec2.new(self.owner.x, self.owner.y)

    local range = 50
    local vtarg = pos_vec+aim_vec*range

    local newbolt = lovelightning:new(255,255,255)

    newbolt.power = .5
    newbolt.jitter_factor = 0.75
    newbolt.fork_chance = .9
    newbolt.max_fork_angle = math.pi
    -- newbolt:setForkTargets(electricity:nodesincircle(
    --       self.owner.x, self.owner.y, range))

    newbolt:setSource({x=camera.view_x(self.owner), y=camera.view_y(self.owner)})
    newbolt:setPrimaryTarget({x=camera.view_x(vtarg), y=camera.view_y(vtarg)})
    newbolt:create(function (ftarg, level)
            table.insert(self.fork_targets,{target=ftarg,level=level})
          end)

    table.insert(self.bolts, newbolt)

  else
    local last_target = self.owner
    for i, t in ipairs(targets) do
      if i <= self.chain_targets then
        local newbolt = lovelightning:new(255,255,255)

        -- newbolt:setForkTargets(nodes)


        newbolt:setSource({x=camera.view_x(last_target), y=camera.view_y(last_target)})
        newbolt:setPrimaryTarget({x=camera.view_x(t), y=camera.view_y(t)})

        newbolt:create(function (ftarg, level)
            table.insert(self.fork_targets,{target=ftarg,level=level})
          end)
        table.insert(self.bolts, newbolt)
        table.insert(fired_at_targets,t)
        last_target = t
      end
    end
    audiomanager:playOnce('spark')
  end


  self.fired_at = game_time
  self.targets = fired_at_targets
end

function LightningGun:hit_fork_target( target, level )
  -- body
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
          if t.take_damage then
            t:take_damage(self.damage)
          end
        end
      end
      self.bolts = {}
    end
  end
end

function LightningGun:release( )
  if self.sound_hum then
    self.sound_hum:stop()
    self.sound_hum = nil
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

local RayGun = class("RayGun", Weapon)

function RayGun:_aquire_targets()
  -- override me and return a list of targets inform {x,y}
  return {}
end

function RayGun:initialize()

  Weapon.initialize(self)
  self.sound = "gunshot"
  self.icon = "ray_icon"
  self.range = 500
  self.firing_arc = math.pi/4
  self.damage = 100
  self.beam_width = 10
  self.focus_time = 5.0
  self.initial_focus = 0.1 -- 0 to 1
  self.sound = audiomanager.sources['buzz'].source
end

function RayGun:_fire(targets)
  if not self.fired_at then
    self.current_angle = self.firing_arc
    self.fired_at = game_time
    self.focus = self.initial_focus
  end
end

function RayGun:release()
  if self.fired_at then
    self.fired_at = nil
  end
end

function RayGun:update(dt)
  if self.fired_at then

    --cap it at focus time
    local firing_time = math.min(self.focus_time, game_time-self.fired_at)
    local percent_of_focus = (self.focus_time-firing_time)/self.focus_time

    self.current_angle = self.firing_arc*percent_of_focus
    self.focus = math.max(self.initial_focus, percent_of_focus)

    local sfx = self.sound:clone()
    sfx:setVolume(0.3*(1-percent_of_focus))
    sfx:setPitch(math.max(1/2^3,2^2*percent_of_focus))
    sfx:play()

  end
end


function RayGun:draw()

  if self.fired_at and self.current_angle then
    local dx = self.range*math.cos(self.current_angle)
    local dy = self.range*math.sin(self.current_angle)

    local canvas = love.graphics.newCanvas()
    love.graphics.setCanvas(canvas)

    love.graphics.setColor(200, 0, 255, 255*(1-self.focus))

    local y_offset = 300

    love.graphics.arc( 'fill', 0 , y_offset-self.beam_width/2, self.range,
      -self.current_angle/2, 0, 20 )

    love.graphics.rectangle( 'fill', 0, y_offset-self.beam_width/2,
      self.range, self.beam_width)

    love.graphics.arc( 'fill', 0, y_offset+self.beam_width/2, self.range,
      0, self.current_angle/2, 20 )


    love.graphics.setCanvas()
    local mode = love.graphics.getBlendMode()

    love.graphics.setBlendMode('alpha','premultiplied')
    love.graphics.draw(canvas,
      camera.view_x(self.owner), camera.view_y(self.owner),
      self.owner.aim, 1, 1, 0, y_offset)

    love.graphics.setColor(255,255,255)
    love.graphics.setBlendMode(mode)
  end

end

-------------------------------------------------------------------------------
weapon.ProjectileGun = ProjectileGun
weapon.LightningGun = LightningGun
weapon.RayGun = RayGun

return weapon
