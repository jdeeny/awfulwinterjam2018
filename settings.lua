local settings = {}

local default_settings = { 
  -- These should be modified with the correct variables/names as required
  game_speed = 1.0,
  start_dungeon = 1,
  volume = 100,
  max_unlocked_dungeon = 1,
  gfx_mode = 'windowed',
  window_width =  window.w,
  window_height = window.h
}

settings = default_settings

function settings.init() 
	AudioManager:setMasterVolume(settings.volume/10)
	
end


return settings