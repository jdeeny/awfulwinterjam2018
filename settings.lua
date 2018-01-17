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

local settings = {}

if love.filesystem.exists('savedata') then
	settings = bitser.loadLoveFile('savedata')
else
	settings = default_settings
	bitser.dumpLoveFile('savedata', settings)
end

settings = default_settings

 -- bitser won't serialize functions, so these need to be global

function init_settings() 
	AudioManager:setMasterVolume(settings.volume/10)
end

function save_settings()    
	bitser.dumpLoveFile('savedata', settings)
end

return settings