
require "math"
item = require "items/item"
cpml = require 'lib/cpml'
lovelightning = require "effects/lovelightning"
camera = require "camera"


local weapon = {}

-------------------------------------------------------------------------------
local Weapon = class("Weapon", item.Item)

function Weapon:_acquire_targets()
  -- override me and return a list of targets inform {x,y}
  return {}
end

function Weapon:initialize()
   -- Weapon.initialize(self) -- super class init, uncomment when subclassing
  self.firing_rate = 0.1 -- s / shot
  self.max_ammo = 100
  self.ammo = 100
  self.ammo_cost = 10 -- per second cost of firing weapn
  self.charge_rate = 15 -- ammo gained per second
  self.is_firing = false
  self.min_ammo_to_fire = 10
end

function Weapon:_fire(targets)
  -- override me
end

function Weapon:reload(ammo)
  if ammo then
    self.ammo = min(self.max_ammo, self.ammo+ammo)
  end
end

function Weapon:update(dt)
  -- Weapon.update(self, dt)
    if not self.is_firing then
      self.ammo = math.min(self.max_ammo, self.ammo+self.charge_rate*dt)
    end
end

function Weapon:fire()
  if not self.next_shot_time or game_time > self.next_shot_time then
    if self.ammo > self.ammo_cost*self.firing_rate then
      self:_fire(self:_acquire_targets())
      self.is_firing = true
      self.next_shot_time = game_time + self.firing_rate
      self.ammo = self.ammo - self.ammo_cost*self.firing_rate
    else
      self:release()
    end
  end
end

function Weapon:release()
  -- Weapon.release(self)
  self.is_firing = false
  -- body
end
-------------------------------------------------------------------------------
local ProjectileGun = class("ProjectileGun", Weapon)

function ProjectileGun:initialize()
  Weapon.initialize(self)
  self.name = 'ProjectileGun'
  self.shot_speed = 1200
  self.sound = "gunshot"
  self.icon = "gun_icon"
  self.projectile = "bullet"
  self.cof_multiplier = 0
end

function ProjectileGun:_fire(targets)
  local angle = self.owner.aim + (love.math.random() - 0.5) * 0.4 * self.cof_multiplier
  shot_data.spawn(self.projectile, self.owner.x + 48 * math.cos(angle), self.owner.y + 48 * math.sin(angle),
      math.cos(angle)*(self.owner.shot_speed or self.shot_speed),
      math.sin(angle)*(self.owner.shot_speed or self.shot_speed), self.owner)
  audiomanager:playOnce(self.sound)
  if self.owner.is_player then
    camera.bump(6, self.owner.aim)
  end
  self.owner:be_knocked_back(0.1, -100 * math.cos(angle), -100 * math.sin(angle))
  self.cof_multiplier = math.min(1, self.cof_multiplier + 0.15)
  spark_data.spawn("muzzle", {r=255, g=170 + love.math.random(50), b=100}, self.owner.x + 112 * math.cos(angle), self.owner.y + 112 * math.sin(angle),
    0, 0, angle)
end

function ProjectileGun:release()
  Weapon.release(self)
  self.cof_multiplier = 0
end

function ProjectileGun:draw()
  local aim = self.owner.aim or 0
  if math.cos(aim) < 0 then --left
    love.graphics.draw(image['tesla_arm_gun'],
      self.owner.x - camera.x + 8 * math.cos(aim), self.owner.y - camera.y + 8 * math.sin(aim),
      aim, 1, -1, 64, 32)
  else --right
    love.graphics.draw(image['tesla_arm_gun'],
      self.owner.x - camera.x + 8 * math.cos(aim), self.owner.y - camera.y + 8 * math.sin(aim),
      aim, 1, 1, 64, 32)
  end
end

-------------------------------------------------------------------------------

local SniperGun = class("SniperGun", Weapon)

function SniperGun:initialize()
  Weapon.initialize(self)
  self.name = 'SniperGun'
  self.shot_speed = 1800
  self.sound = "gunshot"
  self.icon = "gun_icon"
  self.projectile = "sniper_bullet"
end

function SniperGun:_fire(targets)
  local angle = self.owner.aim
  shot_data.spawn(self.projectile, self.owner.x + 48 * math.cos(angle), self.owner.y + 48 * math.sin(angle),
      math.cos(angle)*(self.owner.shot_speed or self.shot_speed),
      math.sin(angle)*(self.owner.shot_speed or self.shot_speed), self.owner)
  audiomanager:playOnce(self.sound)
  if self.owner.is_player then
    camera.bump(6, self.owner.aim)
  end
  self.owner:be_knocked_back(0.3, -300 * math.cos(angle), -300 * math.sin(angle))
  spark_data.spawn("muzzle", {r=255, g=140 + love.math.random(100), b=100}, self.owner.x + 112 * math.cos(angle), self.owner.y + 112 * math.sin(angle),
    0, 0, angle)
end

function SniperGun:release()
  Weapon.release(self)
end

function SniperGun:draw()
  local aim = self.owner.aim or 0

  if self.owner.scoping and self.owner.ai.shot_confidence then
    -- draw sight
    _, mx, my, mt = collision.aabb_room_sweep({x = self.owner.x, y = self.owner.y, radius = 0},
      2000 * math.cos(aim), 2000 * math.sin(aim))

    pmx, pmy, pmt = collision.aabb_sweep({x = self.owner.x, y = self.owner.y, radius = 0}, player,
      2000 * math.cos(aim), 2000 * math.sin(aim))
    if pmt and pmt < mt then
      mx, my, mt = pmx, pmy, pmt
    end

    love.graphics.setColor(255, 50, 0, math.min(255, 120 + self.owner.ai.shot_confidence * 100))
    love.graphics.setLineWidth(1 + self.owner.ai.shot_confidence * 2)
    love.graphics.line(self.owner.x - camera.x, self.owner.y - camera.y, mx - camera.x, my - camera.y)
    love.graphics.setLineWidth(1)
    love.graphics.setColor(255,255,255,255)
  end

  if math.cos(aim) < 0 then --left
    love.graphics.draw(image['tesla_arm_gun'],
      self.owner.x - camera.x + 8 * math.cos(aim), self.owner.y - camera.y + 8 * math.sin(aim),
      aim, 1, -1, 64, 32)
  else --right
    love.graphics.draw(image['tesla_arm_gun'],
      self.owner.x - camera.x + 8 * math.cos(aim), self.owner.y - camera.y + 8 * math.sin(aim),
      aim, 1, 1, 64, 32)
  end
end

-------------------------------------------------------------------------------

local RocketLauncher = class("RocketLauncher", Weapon)

function RocketLauncher:initialize()
  Weapon.initialize(self)
  self.name = 'RocketLauncher'
  self.shot_speed = 20
  self.sound = "gunshot"
  self.icon = "gun_icon"
  self.projectile = "rocket"
end

function RocketLauncher:_fire(targets)
  local angle = self.owner.aim
  shot_data.spawn(self.projectile, self.owner.x + 48 * math.cos(angle), self.owner.y + 48 * math.sin(angle),
      math.cos(angle)*(self.owner.shot_speed or self.shot_speed),
      math.sin(angle)*(self.owner.shot_speed or self.shot_speed), self.owner)
  audiomanager:playOnce(self.sound)
  if self.owner.is_player then
    camera.bump(12, self.owner.aim)
  end
  self.owner:be_knocked_back(0.2, -200 * math.cos(angle), -200 * math.sin(angle))
  spark_data.spawn("muzzle", {r=255, g=170 + love.math.random(50), b=100}, self.owner.x + 112 * math.cos(angle), self.owner.y + 112 * math.sin(angle),
    0, 0, angle)
  spark_data.spawn("muzzle", {r=255, g=170 + love.math.random(50), b=100}, self.owner.x + 112 * math.cos(angle + math.pi), self.owner.y + 112 * math.sin(angle + math.pi),
    0, 0, angle)
end

function RocketLauncher:release()
  Weapon.release(self)
end

function RocketLauncher:draw()
  local aim = self.owner.aim or 0
  if math.cos(aim) < 0 then --left
    love.graphics.draw(image['tesla_arm_gun'],
      self.owner.x - camera.x + 8 * math.cos(aim), self.owner.y - camera.y + 8 * math.sin(aim),
      aim, 1, -1, 64, 32)
  else --right
    love.graphics.draw(image['tesla_arm_gun'],
      self.owner.x - camera.x + 8 * math.cos(aim), self.owner.y - camera.y + 8 * math.sin(aim),
      aim, 1, 1, 64, 32)
  end
end

-------------------------------------------------------------------------------

local LightningGun = class("LightningGun", Weapon)

function LightningGun:initialize()
  Weapon.initialize(self)
  self.name = 'LightningGun'
  self.range = 400
  self.firing_arc = math.pi/4
  self.bolts = {}
  self.draw_time = 0.1
  self.spark_time = 0
  self.damage = 600
  self.firing_rate = 0.1
  self.chain_targets = 1
  -- self.sound = "tesla_coil_long"
  self.icon = "lightning_icon"
end

function LightningGun:_acquire_targets()
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

    if current_level:feature_at(player.x/TILESIZE, player.y/TILESIZE):sub(1,5) == 'water' then

      local newbolt = lovelightning:new(255,255,255)

      newbolt.power = .5
      newbolt.jitter_factor = 0.75
      newbolt.fork_chance = .9
      newbolt.max_fork_angle = math.pi

      local ptarg = { x = self.owner.x +math.random()*16 - 8, y = self.owner.y +math.random()*16 - 8 }
      newbolt:setSource({x=camera.view_x(self.owner), y=camera.view_y(self.owner)})
      newbolt:setPrimaryTarget({x=camera.view_x(ptarg), y=camera.view_y(ptarg)})
      newbolt:create(function (ftarg, level)
              table.insert(self.fork_targets,{target=ftarg,level=level})
            end)

      table.insert(self.bolts, newbolt)
    end


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
  Weapon.update(self, dt)

  if self.bolts and self.fired_at then
    if game_time < self.fired_at + self.draw_time then
      for _, b in pairs(self.bolts) do
        b:update(dt)
      end
    else
      if current_level:feature_at(player.x/TILESIZE, player.y/TILESIZE):sub(1,5) == 'water' then
        player:take_damage(self.damage * 0 * dt)
        camera.shake(5,1)
      end
      if self.targets and #self.targets > 0 then
        for _, t in pairs(self.targets) do
          if t.take_damage then
            t:take_damage(self.damage * dt, false, 0, 0, false)
            if game_time > self.spark_time then
              for i = 1, love.math.random(7) do
                angle = love.math.random() * math.pi * 2
                speed = 200 + 1800 * love.math.random()
                spark_data.spawn("spark_blue", {r=255, g=255, b=255}, t.x, t.y, speed * math.cos(angle), speed * math.sin(angle))
              end
              for i = 1, love.math.random(3) do
                angle = love.math.random() * math.pi * 2
                speed = 200 + 1000 * love.math.random()
                spark_data.spawn("spark_big_blue", {r=255, g=255, b=255}, t.x, t.y, speed * math.cos(angle), speed * math.sin(angle))
              end
              self.spark_time = game_time + 0.1
            end
          end
        end
      end
      self.bolts = {}
    end
  end
end

function LightningGun:release( )
  Weapon.release(self)
  if self.sound_hum then
    self.sound_hum:stop()
    self.sound_hum = nil
  end
  self.targets = nil
end



function LightningGun:draw()
  local aim = self.owner.aim or 0
  if math.cos(aim) < 0 then --left
    love.graphics.draw(image['tesla_arm_lightning'],
      self.owner.x - camera.x + 8 * math.cos(aim), self.owner.y - camera.y + 8 * math.sin(aim),
      aim, 1, -1, 64, 32)
  else --right
    love.graphics.draw(image['tesla_arm_lightning'],
      self.owner.x - camera.x + 8 * math.cos(aim), self.owner.y - camera.y + 8 * math.sin(aim),
      aim, 1, 1, 64, 32)
  end

  if self.bolts then
    local drawn = false
    for _, b in pairs(self.bolts) do
        b:draw()
        drawn = true
    end
    if drawn then
      play.flash_screen(love.math.random(20), 0, 60 + love.math.random(60), 96, 0.5)
    end
  end
end

-------------------------------------------------------------------------------

local RayGun = class("RayGun", Weapon)

function RayGun:_acquire_targets()
  -- override me and return a list of targets inform {x,y}
  return {}
end

function RayGun:initialize()

  Weapon.initialize(self)
  self.name = 'RayGun'
  self.icon = "ray_icon"
  self.range = 4000
  self.firing_arc = math.pi/4
  self.damage = 50
  self.beam_width = 10
  self.focus_time = 5.0
  self.min_focus = 0.1
  self.initial_focus = 0.9 -- 0 to 1
  self.sound = audiomanager.sources['buzz'].source
  self.sfx = nil
  self.spark_time = 0
end

function RayGun:_fire(targets)
  if not self.fired_at then
    self.diameter = self.firing_arc
    self.fired_at = game_time
    self.focus = self.initial_focus
    self.angle = self.owner.aim
  end
end

function RayGun:release()
  Weapon.release(self)
  if self.fired_at then
    self.fired_at = nil
  end
end

local a, firing_time, percent_of_focus
function RayGun:update(dt)
  Weapon.update(self, dt)
  if self.fired_at then

    --cap it at focus time
    firing_time = math.min(self.focus_time, game_time-self.fired_at)
    percent_of_focus = (self.focus_time-firing_time)/self.focus_time

    self.focus = percent_of_focus * (self.initial_focus - self.min_focus) + self.min_focus
    self.diameter = self.firing_arc * self.focus

    self.sfx = self.sound:clone()
    self.sfx:setVolume(0.3*(1-percent_of_focus))
    self.sfx:setPitch(math.max(1/2^3,2^2*percent_of_focus))
    self.sfx:play()

    a = self.owner.aim - self.angle

    if (a > math.pi) then
      a = a - math.pi * 2
    elseif (a < -math.pi) then
      a = a + math.pi * 2
    end

    self.angle = self.angle + a * (math.min(1, 3 * dt))

    -- now look for enemies to hurt
    local sparked = false
    for _,z in pairs(enemies) do
      a = self.angle - math.atan2(z.y - (self.owner.y + 48 * math.sin(self.angle)), z.x - self.owner.x + 48 * math.cos(self.angle))

      if (a > math.pi) then
        a = a - math.pi * 2
      elseif (a < -math.pi) then
        a = a + math.pi * 2
      end

      if math.abs(a) < self.diameter/2 + 0.1 then
        local dist = cpml.vec2.new(self.x, self.y):dist(cpml.vec2.new(z.x,z.y))
        local d = self.damage * dt * (1 - cpml.utils.clamp(self.focus + 0.2, 0, 1.0))*2
        --print("distmod: " .. distmod .. " focus: "..self.focus .. " dmg: "..d)
        z:take_damage(d, false, self.angle + a, 3 * dt, false)
        if game_time > self.spark_time and d > 0.01 then
          for i = 1, math.floor(7 - 6 * self.focus) do
            angle = self.angle + a + 0.5 * (love.math.random() - 0.5)
            speed = (200 + 1800 * love.math.random()) * (1.5 - self.focus) + math.random(d* 5)
            spark_data.spawn("spark_blue", {r=255, g=100, b=150}, z.x, z.y, speed * math.cos(angle), speed * math.sin(angle))
            angle = self.angle + a + 0.5 * (love.math.random() - 0.5)
            speed = (200 + 1800 * love.math.random()) * (1.5 - self.focus) + math.random(d* 3)
            spark_data.spawn("spark_blue", {r=255, g=100, b=150}, z.x, z.y, speed * math.cos(angle), speed * math.sin(angle))
            angle = self.angle + a + 0.5 * (love.math.random() - 0.5)
            speed = (200 + 1800 * love.math.random()) * (1.5 - self.focus) + math.random(d)
            spark_data.spawn("spark_big_blue", {r=255, g=100, b=150}, z.x, z.y, speed * math.cos(angle), speed * math.sin(angle))
          end
          for i = 1, math.floor(3 - 2 * self.focus) do
            angle = self.angle + a + 0.5 * (love.math.random() - 0.5)
            speed = (200 + 1800 * love.math.random()) * (1.5 - self.focus) + math.random(d*4)
            spark_data.spawn("spark_blue", {r=255, g=100, b=150}, z.x, z.y, speed * math.cos(angle), speed * math.sin(angle))
            angle = self.angle + a + 0.5 * (love.math.random() - 0.5)
            speed = (200 + 1800 * love.math.random()) * (1.5 - self.focus) + math.random(d*3)
            spark_data.spawn("spark_big_blue", {r=255, g=100, b=150}, z.x, z.y, speed * math.cos(angle), speed * math.sin(angle))
            angle = self.angle + a + 0.5 * (love.math.random() - 0.5)
            speed = (200 + 1800 * love.math.random()) * (1.5 - self.focus) + math.random(d*2)
            spark_data.spawn("spark_big_blue", {r=255, g=100, b=150}, z.x, z.y, speed * math.cos(angle), speed * math.sin(angle))
            angle = self.angle + a + 0.5 * (love.math.random() - 0.5)
            speed = (200 + 1800 * love.math.random()) * (1.5 - self.focus) + math.random(d)
            spark_data.spawn("spark_big_blue", {r=255, g=100, b=150}, z.x, z.y, speed * math.cos(angle), speed * math.sin(angle))
          end
          sparked = true
        end
      end
    end
    if sparked then self.spark_time = game_time + 0.1 end
  end
end


function RayGun:draw()
  local aim = (not self.is_firing and self.owner.aim) or self.angle or 0
  if math.cos(aim) < 0 then --left
    love.graphics.draw(image['tesla_arm_ray'],
      self.owner.x - camera.x + 8 * math.cos(aim), self.owner.y - camera.y + 8 * math.sin(aim),
      aim, 1, -1, 64, 32)
  else --right
    love.graphics.draw(image['tesla_arm_ray'],
      self.owner.x - camera.x + 8 * math.cos(aim), self.owner.y - camera.y + 8 * math.sin(aim),
      aim, 1, 1, 64, 32)
  end

  if self.fired_at and self.diameter then
    local dx = self.range*math.cos(self.diameter)
    local dy = self.range*math.sin(self.diameter)

    if not self.canvas then
      self.canvas = love.graphics.newCanvas()
    end
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear()

    love.graphics.setColor(90 + 120 * love.math.random(), 100*love.math.random(), 200 + 55 * love.math.random(),
      cpml.utils.clamp(255*(1-self.focus), 50, 255))

    local y_offset = 300
    local diameter_variance = 0.05 * love.math.random()

    love.graphics.arc( 'fill', 0 , y_offset-self.beam_width/2, self.range,
      -self.diameter/2 - 0.05 * love.math.random(), 0, 20 )

    love.graphics.rectangle( 'fill', 0, y_offset-self.beam_width/2,
      self.range, self.beam_width)

    love.graphics.arc( 'fill', 0, y_offset+self.beam_width/2, self.range,
      0, self.diameter/2 + 0.05 * love.math.random(), 20 )

    love.graphics.setCanvas()
    local mode = love.graphics.getBlendMode()

    ray_effect.chromasep.angle = math.random() * 2 * 3.1415
    ray_effect.chromasep.radius = math.random()* 12

    ray_effect(function()
      love.graphics.setBlendMode('alpha','premultiplied')
      love.graphics.draw(self.canvas,
        camera.view_x(self.owner) + 48 * math.cos(self.angle), camera.view_y(self.owner) + 48 * math.sin(self.angle),
        self.angle, 1, 1, 0, y_offset)
    end)

    love.graphics.setColor(255,255,255,255)
    love.graphics.setBlendMode(mode)

    camera.shake(3 - 2.5 * self.focus, 0.3)
    play.flash_screen(50 + 10 * love.math.random(), 0, 100 + 20 * love.math.random(), cpml.utils.clamp(128*(1-self.focus), 0, 128), 0.5)
  end

end

-------------------------------------------------------------------------------
weapon.ProjectileGun = ProjectileGun
weapon.SniperGun = SniperGun
weapon.LightningGun = LightningGun
weapon.RayGun = RayGun

return weapon
