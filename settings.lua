local default_settings = {
  -- These should be modified with the correct variables/names as required
  game_speed = 1.0,
  start_dungeon = 1,
  volume = 50,
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

-- DBG
for k,v in pairs(settings) do
	print(k,v)
end
-- DBG

settings = default_settings

 -- bitser won't serialize functions, so these need to be global

function init_settings()
	AudioManager:setMasterVolume(settings.volume/200)
	for i, s in ipairs({0.3,0.75,1.0,1.25}) do    -- Game speed
		if s == settings.game_speed then
			allowed_options[2]:setIndex(i)
		end
	end
end

function save_settings()
	bitser.dumpLoveFile('savedata', settings)
end

return settings
