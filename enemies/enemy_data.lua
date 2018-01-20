enemy_data = {}

function enemy_data.spawn(kind, x, y)
  local new_id = idcounter.get_id("enemy")

  local e = enemy:new()

  e.id = new_id
  e.x = x
  e.y = y

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

  local personality = personalities[e.personality] or personalities['Wanderer']
  e.ai = personality:new(e)

  if e.weapon_type then
    local w = e.weapon_type:new()
    if e.projectile_type then
      w.projectile = "enemybullet"
    end
    e:equip('weapon', w)
  end

  e.hp = e.max_hp
  enemy_value = enemy_value + e.value

  enemies[new_id] = e

  current_level:addMob(new_id, enemies[new_id])

  return new_id
end

enemy_data["schmuck"] =
{
  kind = "schmuck", name = "Test Loser",
  sprite = "dude",  death_sound = "unh",
  max_hp = 60,
  speed = 100,
  radius = 30,
  value = 1,
  bleeds = 1,
  touch_damage = 10,
  personality = 'Wanderer',
  drop_items = {{chance=0.05,item="max_ammo_increase"},
                {chance=0.05,item="max_health_increase"},
                {chance=0.05,item="damage_mult"},
                {chance=0.05,item="charge_rate_mult"},
                {chance=0.25,item="health_pack"},},
}

enemy_data["lumpgoon"] =
{
  kind = "lumpgoon", name = "Lump Goon",
  sprite = "lumpgoon", death_sound = "unh",
--  animation = animation.gear_spin_ccw,
  animations = { lumpgoon_run_ne = animation.lumpgoon_run_ne:clone(), lumpgoon_run_se = animation.lumpgoon_run_se:clone(), lumpgoon_run_nw = animation.lumpgoon_run_nw:clone(), lumpgoon_run_sw = animation.lumpgoon_run_sw:clone(),},
  max_hp = 250,
  speed = 40,
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

enemy_data["rifledude"] =
{
  kind = "rifledude", name = "Rifle Dude",
  sprite = "dude", death_sound = "unh",
  max_hp = 40,
  speed = 80,
  radius = 30,
  value = 2,
  touch_damage = 0,
  shot_speed = 400,
  burst_size = 3,
  next_splash = game_time,
  splash_delay = 0.12,
  bleeds = 1,
  weapon_type = weapon.ProjectileGun,
  projectile_type = 'enemybullet',
  personality = 'Rifleman',
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
  speed = 40,
  radius = 5,
  value = 0.25,
  touch_damage = 5,
  next_splash = game_time,
  splash_delay = 0.2,
  splash_force = 15,
  personality = 'Remotedude',
}

enemy_data["remotedude_blue"] =
{
  kind = "remotedude_blue", name = "RC Mower",
  sprite = "remotedude", death_sound = "crash",
  --animation = animation.remotedude_blue_run_se,
  animations = { remotedude_blue_run_ne = animation.remotedude_blue_run_ne:clone(), remotedude_blue_run_se = animation.remotedude_blue_run_se:clone(), remotedude_blue_run_nw = animation.remotedude_blue_run_nw:clone(), remotedude_blue_run_sw = animation.remotedude_blue_run_sw:clone(),},
  max_hp = 30,
  speed = 60,
  radius = 5,
  value = 0.5,
  touch_damage = 5,
  next_splash = game_time,
  splash_delay = 0.2,
  splash_force = 15,
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
  radius = 5,
  value = 0.75,
  touch_damage = 5,
  next_splash = game_time,
  splash_delay = 0.2,
  splash_force = 15,
  personality = 'Remotedude',
}



return enemy_data
