enemy_data = {}

function enemy_data.spawn(kind, x, y, parameter)
  local new_id = idcounter.get_id("enemy")
  if not enemy_data[kind] then return end

  local e = enemy:new()
  e.id = new_id
  e.x = x
  e.y = y
  e.parameter = parameter -- used for spawning a dude facing a certain way, for instance

  e.birth_time = game_time
  e.wake_time = game_time
  e.attack_time = game_time

  for i, v in pairs(enemy_data[kind]) do
    e[i] = v
  end

  -- Clone animations if present, otherwise all enemies of that type will share timing data
  if e.animation then
    e.animation = e.animation:clone()
  end
  if e.animations then
    for _, a in ipairs(e.animations) do
      a = a:clone()
    end
  end

  local personality = personalities[e.personality] or personalities['Seeker']
  e.ai = personality:new(e)

  if e.weapon_type then
    local w = e.weapon_type:new()
    if e.projectile_type then
      w.projectile = e.projectile_type
    end
    e:equip('weapon', w)
  end

  e.hp = e.max_hp
  enemy_value = enemy_value + e.value

  enemies[new_id] = e

  current_level:addMob(new_id, enemies[new_id])

  return new_id
end

--[[
enemy_data["canbot"] =
{
  kind = "canbot", name = "CAN BOT!",
  sprite = "canbot",  death_sound = "crash",
  animations = {
    canbot_run_ne = animation.canbot_run_ne:clone(),
    canbot_run_se = animation.canbot_run_se:clone(),
    canbot_run_nw = animation.canbot_run_nw:clone(),
    canbot_run_sw = animation.canbot_run_sw:clone(),
    canbot_idle_ne = animation.canbot_idle_ne:clone(),
    canbot_idle_se = animation.canbot_idle_se:clone(),
    canbot_idle_nw = animation.canbot_idle_nw:clone(),
    canbot_idle_sw = animation.canbot_idle_sw:clone(),
    canbot_hurt_ne = animation.canbot_hurt_ne:clone(),
    canbot_hurt_se = animation.canbot_hurt_se:clone(),
    canbot_hurt_nw = animation.canbot_hurt_nw:clone(),
    canbot_hurt_sw = animation.canbot_hurt_sw:clone(),
  },

  max_hp = 60,
  speed = 100,
  radius = 30,
  value = 1,
  bleeds = 1,
  touch_damage = 10,
  personality = 'Seeker',
  drop_items = {{chance=0.05,item="max_ammo_increase"},
                {chance=0.05,item="max_health_increase"},
                {chance=0.05,item="damage_mult"},
                {chance=0.05,item="charge_rate_mult"},
                {chance=0.25,item="health_pack"},},
}
]]

enemy_data["lumpgoon"] =
{
  kind = "lumpgoon", name = "Lump Goon",
  sprite = "lumpgoon", death_sound = "grunt",
  animations = {
    lumpgoon_run_ne = animation.lumpgoon_run_ne:clone(),
    lumpgoon_run_se = animation.lumpgoon_run_se:clone(),
    lumpgoon_run_nw = animation.lumpgoon_run_nw:clone(),
    lumpgoon_run_sw = animation.lumpgoon_run_sw:clone(),
    lumpgoon_idle_ne = animation.lumpgoon_idle_ne:clone(),
    lumpgoon_idle_se = animation.lumpgoon_idle_se:clone(),
    lumpgoon_idle_nw = animation.lumpgoon_idle_nw:clone(),
    lumpgoon_idle_sw = animation.lumpgoon_idle_sw:clone(),},
  max_hp = 80,
  speed = 100,
  radius = 25,
  value = 1.5,
  bleeds = 2,
  touch_damage = 20,
  personality = 'Seeker',
  drop_items = {{chance=0.05,item="max_ammo_increase"},
                {chance=0.05,item="max_health_increase"},
                {chance=0.05,item="damage_mult"},
                {chance=0.05,item="charge_rate_mult"},
                {chance=0.25,item="health_pack"},},
}

enemy_data["superlump"] =
{
  kind = "superlump", name = "Super Goon",
  sprite = "lumpgoon", death_sound = "grunt",
  animations = {
    superlump_run_ne = animation.lumpgoon_run_ne:clone(),
    superlump_run_se = animation.lumpgoon_run_se:clone(),
    superlump_run_nw = animation.lumpgoon_run_nw:clone(),
    superlump_run_sw = animation.lumpgoon_run_sw:clone(),
    superlump_idle_ne = animation.lumpgoon_idle_ne:clone(),
    superlump_idle_se = animation.lumpgoon_idle_se:clone(),
    superlump_idle_nw = animation.lumpgoon_idle_nw:clone(),
    superlump_idle_sw = animation.lumpgoon_idle_sw:clone(),},
  max_hp = 160,
  speed = 100,
  radius = 25,
  value = 1.5,
  -- bleeds = 2,
  touch_damage = 20,
  personality = 'Seeker',
  drop_items = {{chance=0.05,item="max_ammo_increase"},
                {chance=0.05,item="max_health_increase"},
                {chance=0.05,item="damage_mult"},
                {chance=0.05,item="charge_rate_mult"},
                {chance=0.25,item="health_pack"},},

  death_action = function(self)
    local angle = 1.0471975512 * love.math.random()
    for i = 1, 6 do
      local id = enemy_data.spawn("lumpgoon", self.x, self.y)
      local t = 0.5 + love.math.random()
      enemies[id]:be_stunned(t)
      enemies[id]:be_knocked_back(t, 200 * math.cos(angle + 1.0471975512 * i), 200 * math.sin(angle + 1.0471975512 * i))
    end
    explosions.blood(self.x, self.y)
  end,
}

enemy_data["rifledude"] =
{
  kind = "rifledude", name = "Rifle Dude",
  sprite = "pinkerton", death_sound = "grunt",
  animations = {
    rifledude_run_ne = animation.pinkerton_run_ne:clone(),
    rifledude_run_se = animation.pinkerton_run_se:clone(),
    rifledude_run_nw = animation.pinkerton_run_nw:clone(),
    rifledude_run_sw = animation.pinkerton_run_sw:clone(),
    rifledude_idle_ne = animation.pinkerton_idle_ne:clone(),
    rifledude_idle_se = animation.pinkerton_idle_se:clone(),
    rifledude_idle_nw = animation.pinkerton_idle_nw:clone(),
    rifledude_idle_sw = animation.pinkerton_idle_sw:clone(),
    rifledude_hurt_ne = animation.pinkerton_hurt_ne:clone(),
    rifledude_hurt_se = animation.pinkerton_hurt_se:clone(),
    rifledude_hurt_nw = animation.pinkerton_hurt_nw:clone(),
    rifledude_hurt_sw = animation.pinkerton_hurt_sw:clone(),
  },


  max_hp = 60,
  speed = 80,
  radius = 30,
  value = 2,
  touch_damage = 7,
  shot_speed = 400,
  next_splash = game_time,
  splash_delay = 0.12,
  bleeds = 2,
  weapon_type = weapon.ProjectileGun,
  projectile_type = 'enemybullet',
  personality = 'Rifleman',
  drop_items = {{chance=0.025,item="max_ammo_increase"},
                {chance=0.025,item="max_health_increase"},
                {chance=0.025,item="damage_mult"},
                {chance=0.025,item="charge_rate_mult"},
                {chance=0.125,item="health_pack"},},
}


enemy_data["bursterdude"] =
{
  kind = "bursterdude", name = "Burster Dude",
  sprite = "pinkerton", death_sound = "grunt",
  animations = {
    bursterdude_run_ne = animation.pinkerton_run_ne:clone(),
    bursterdude_run_se = animation.pinkerton_run_se:clone(),
    bursterdude_run_nw = animation.pinkerton_run_nw:clone(),
    bursterdude_run_sw = animation.pinkerton_run_sw:clone(),
    bursterdude_idle_ne = animation.pinkerton_idle_ne:clone(),
    bursterdude_idle_se = animation.pinkerton_idle_se:clone(),
    bursterdude_idle_nw = animation.pinkerton_idle_nw:clone(),
    bursterdude_idle_sw = animation.pinkerton_idle_sw:clone(),
    bursterdude_hurt_ne = animation.pinkerton_hurt_ne:clone(),
    bursterdude_hurt_se = animation.pinkerton_hurt_se:clone(),
    bursterdude_hurt_nw = animation.pinkerton_hurt_nw:clone(),
    bursterdude_hurt_sw = animation.pinkerton_hurt_sw:clone(),
  },


  max_hp = 80,
  speed = 90,
  radius = 30,
  value = 3,
  touch_damage = 10,
  shot_speed = 450,
  burst_size = 3,
  next_splash = game_time,
  splash_delay = 0.12,
  bleeds = 2,
  weapon_type = weapon.ProjectileGun,
  projectile_type = 'enemybullet',
  personality = 'Rifleman',
  drop_items = {{chance=0.05,item="max_ammo_increase"},
                {chance=0.05,item="max_health_increase"},
                {chance=0.05,item="damage_mult"},
                {chance=0.05,item="charge_rate_mult"},
                {chance=0.25,item="health_pack"},},
}



enemy_data["sniperdude"] =
{
  kind = "sniperdude", name = "Sniper Dude",
  sprite = "sniper", death_sound = "grunt",

  animations = {
    sniperdude_run_ne = animation.pinkerton_run_ne:clone(),
    sniperdude_run_se = animation.pinkerton_run_se:clone(),
    sniperdude_run_nw = animation.pinkerton_run_nw:clone(),
    sniperdude_run_sw = animation.pinkerton_run_sw:clone(),
    sniperdude_idle_ne = animation.pinkerton_idle_ne:clone(),
    sniperdude_idle_se = animation.pinkerton_idle_se:clone(),
    sniperdude_idle_nw = animation.pinkerton_idle_nw:clone(),
    sniperdude_idle_sw = animation.pinkerton_idle_sw:clone(),
    sniperdude_hurt_ne = animation.pinkerton_hurt_ne:clone(),
    sniperdude_hurt_se = animation.pinkerton_hurt_se:clone(),
    sniperdude_hurt_nw = animation.pinkerton_hurt_nw:clone(),
    sniperdude_hurt_sw = animation.pinkerton_hurt_sw:clone(),
  },

  max_hp = 30,
  speed = 80,
  radius = 30,
  value = 2,
  touch_damage = 0,
  shot_speed = 1800,
  burst_size = 3,
  next_splash = game_time,
  splash_delay = 0.12,
  bleeds = 1,
  weapon_type = weapon.SniperGun,
  projectile_type = 'sniper_bullet',
  personality = 'Sniper',
  drop_items = {{chance=0.05,item="max_ammo_increase"},
                {chance=0.05,item="max_health_increase"},
                {chance=0.05,item="damage_mult"},
                {chance=0.05,item="charge_rate_mult"},
                {chance=0.25,item="health_pack"},},
}

enemy_data["remotedude_red"] =
{
  kind = "remotedude_red", name = "RC Mower",
  sprite = "remotedude", death_sound = "crash",
  --animation = animation.remotedude_red_run_se,
  animations = { remotedude_red_run_ne = animation.remotedude_red_run_ne:clone(), remotedude_red_run_se = animation.remotedude_red_run_se:clone(), remotedude_red_run_nw = animation.remotedude_red_run_nw:clone(), remotedude_red_run_sw = animation.remotedude_red_run_sw:clone()},
  max_hp = 30,
  speed = 100,
  radius = 14,
  value = 0.25,
  touch_damage = 5,
  next_splash = game_time,
  splash_delay = 0.2,
  splash_force = 15,
  cornering = 0.1,
  rotspeed = 1,
  personality = 'Bouncer',
}

enemy_data["remotedude_blue"] =
{
  kind = "remotedude_blue", name = "RC Mower",
  sprite = "remotedude", death_sound = "crash",
  --animation = animation.remotedude_blue_run_se,
  animations = { remotedude_blue_run_ne = animation.remotedude_blue_run_ne:clone(), remotedude_blue_run_se = animation.remotedude_blue_run_se:clone(), remotedude_blue_run_nw = animation.remotedude_blue_run_nw:clone(), remotedude_blue_run_sw = animation.remotedude_blue_run_sw:clone(),},
  max_hp = 30,
  speed = 60,
  radius = 14,
  value = 0.5,
  touch_damage = 5,
  next_splash = game_time,
  splash_delay = 0.2,
  splash_force = 15,
  cornering = 0.1,
  rotspeed = 1,
  personality = 'Remotedude',
}

enemy_data["remotedude_green"] =
{
  kind = "remotedude_green", name = "RC Mower",
  sprite = "remotedude", death_sound = "crash",
  --animation = animation.remotedude_green_run_se,
  animations = { remotedude_green_run_ne = animation.remotedude_green_run_ne:clone(), remotedude_green_run_se = animation.remotedude_green_run_se:clone(), remotedude_green_run_nw = animation.remotedude_green_run_nw:clone(), remotedude_green_run_sw = animation.remotedude_green_run_sw:clone(),},
  max_hp = 30,
  speed = 80,
  radius = 14,
  value = 0.75,
  touch_damage = 5,
  next_splash = game_time,
  splash_delay = 0.2,
  splash_force = 15,
  cornering = 0.1,
  rotspeed = 1,
  personality = 'Remotedude',
}

enemy_data["canbot"] =
{
  kind = "canbot", name = "Canbot 0.8",
  sprite = "canbot",  death_sound = "crash",
  max_hp = 80,
  speed = 100,
  radius = 40,
  value = 1,
  bleeds = false,
  touch_damage = 20,

  animations = {
    canbot_run_ne = animation.canbot_run_ne:clone(),
    canbot_run_se = animation.canbot_run_se:clone(),
    canbot_run_nw = animation.canbot_run_nw:clone(),
    canbot_run_sw = animation.canbot_run_sw:clone(),
    canbot_idle_ne = animation.canbot_idle_ne:clone(),
    canbot_idle_se = animation.canbot_idle_se:clone(),
    canbot_idle_nw = animation.canbot_idle_nw:clone(),
    canbot_idle_sw = animation.canbot_idle_sw:clone(),
    canbot_hurt_ne = animation.canbot_hurt_ne:clone(),
    canbot_hurt_se = animation.canbot_hurt_se:clone(),
    canbot_hurt_nw = animation.canbot_hurt_nw:clone(),
    canbot_hurt_sw = animation.canbot_hurt_sw:clone(),
  },


  personality = 'Charger',
  drop_items = {{chance=0.05,item="max_ammo_increase"},
                {chance=0.05,item="max_health_increase"},
                {chance=0.05,item="damage_mult"},
                {chance=0.05,item="charge_rate_mult"},
                {chance=0.25,item="health_pack"},},
}

enemy_data["rocketguy"] =
{
  kind = "rocketguy", name = "Rocket Guy",
  sprite = "dude", death_sound = "grunt",
  max_hp = 80,
  speed = 80,
  radius = 30,
  value = 2,
  touch_damage = 0,
  shot_speed = 100,
  burst_size = 3,
  next_splash = game_time,
  splash_delay = 0.12,
  bleeds = 1,
  weapon_type = weapon.ProjectileGun,
  projectile_type = 'rocket',
  personality = 'Rocketeer',
  drop_items = {{chance=0.05,item="max_ammo_increase"},
                {chance=0.05,item="max_health_increase"},
                {chance=0.05,item="damage_mult"},
                {chance=0.05,item="charge_rate_mult"},
                {chance=0.25,item="health_pack"},},
}

enemy_data["homingrocketguy"] =
{
  kind = "homingrocketguy", name = "Homing Rocket Guy",
  sprite = "dude", death_sound = "grunt",
  max_hp = 80,
  speed = 80,
  radius = 30,
  value = 2,
  touch_damage = 0,
  shot_speed = 100,
  burst_size = 3,
  next_splash = game_time,
  splash_delay = 0.12,
  bleeds = 1,
  weapon_type = weapon.ProjectileGun,
  projectile_type = 'homing_rocket',
  personality = 'Rocketeer',
  drop_items = {{chance=0.05,item="max_ammo_increase"},
                {chance=0.05,item="max_health_increase"},
                {chance=0.05,item="damage_mult"},
                {chance=0.05,item="charge_rate_mult"},
                {chance=0.25,item="health_pack"},},
}


enemy_data["edison"] =
{
  kind = "edison", name = "Edison",
  sprite = "edison", death_sound = "unh",
  max_hp = 800,
  speed = 160,
  radius = 60,
  value = 100,
  touch_damage = 0,
  shot_speed = 160,
  burst_size = 3,
  next_splash = game_time,
  splash_delay = 0.12,
  bleeds = 5,
  weapon_type = weapon.ProjectileGun,
  projectile_type = 'homing_rocket',
  personality = 'EdisonRocketeer',
  animations = {
    edison_run_ne = animation.edison_run_ne:clone(),
    edison_run_se = animation.edison_run_se:clone(),
    edison_run_nw = animation.edison_run_nw:clone(),
    edison_run_sw = animation.edison_run_sw:clone(),
    edison_takeoff_ne = animation.edison_takeoff_ne:clone(),
    edison_takeoff_se = animation.edison_takeoff_se:clone(),
    edison_takeoff_nw = animation.edison_takeoff_nw:clone(),
    edison_takeoff_sw = animation.edison_takeoff_sw:clone(),},
  drop_items = {{chance=0.05,item="max_ammo_increase"},
                {chance=0.05,item="max_health_increase"},
                {chance=0.05,item="damage_mult"},
                {chance=0.05,item="charge_rate_mult"},
                {chance=0.25,item="health_pack"},},
}


return enemy_data
