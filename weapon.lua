item = require "item"

weapon = {}

local Weapon = class("Weapon", item.Item)

local ProjectileGun = class("ProjectileGun", Weapon)

function ProjectileGun:initialize()
    self.firing_rate = 0.1 --shots/s
    self.shot_speed = 800
end


function ProjectileGun:fire()
  if not self.next_shot_time or game_time > self.next_shot_time then

    self.next_shot_time = shot_data.spawn("bullet", self.owner.x, self.owner.y, 
        math.cos(self.owner.rot)*self.owner.shot_speed, 
        math.sin(player.rot)*self.shot_speed, self.owner)

    self.next_shot_time = game_time + self.firing_rate
  end
end


local EnergyGun = class("EnergyGun", Weapon)


weapon.ProjectileGun = ProjectileGun
weapon.EnergyGun = EnergyGun

return weapon