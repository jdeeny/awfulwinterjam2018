local default_settings = { 
  volume = 100,   -- max
  game_speed = 3,  -- medium
  start_dungeon = 1, -- first
  max_unlocked_dungeon = 1,  -- just the first
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

 -- bitser won't serialize functions, so these need to be global

function init_settings() 
	allowed_options[1]:setTo(settings.volume)
	allowed_options[2]:setTo(settings.game_speed)
	allowed_options[3]:setTo(settings.start_dungeon)
end

function save_settings() 
	settings.volume = allowed_options[1]:getSetting()
	settings.game_speed = allowed_options[2]:getSetting()
	settings.start_dungeon = allowed_options[3]:getSetting()   
	bitser.dumpLoveFile('savedata', settings)
end

return settings