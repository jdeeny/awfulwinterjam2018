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
  if e.animation then
    e.animation = e.animation:clone()
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
  touch_damage = 10,
  personality = 'Wanderer',
}

enemy_data["fodder"] =
{
  kind = "fodder", name = "Test Fodder",
  sprite = "gear", death_sound = "snap",
  animation = animation.gear_spin_ccw,
  max_hp = 30,
  speed = 200,
  radius = 15,
  value = 0.5,
  touch_damage = 10,
  personality = 'Seeker',
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
  shot_speed = 500,
  weapon_type = weapon.ProjectileGun,
  projectile_type = 'enemybullet',
  personality = 'Rifleman'
}
return enemy_data
