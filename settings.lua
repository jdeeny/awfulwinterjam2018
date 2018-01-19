local default_settings = {
  volume = 100,   -- max
  game_speed = 1,  -- medium
  start_stage = 1, -- first
  max_unlocked_dungeon = 1,  -- just the first
  draw_crosshairs_always = false,
  gfx_mode = 'windowed',
  window_width =  window.w,
  window_height = window.h,
}

local settings = {}

if love.filesystem.exists('savedata') then
     settings = bitser.loadLoveFile('savedata')
	 
	 -- integrity check, primarily needed during dev
	 local saved_keys = {}
	 local default_keys = {}
	 
	 for k in pairs(settings) do 
		 table.insert(saved_keys,k)
	 end
	 
	 for k in pairs(default_settings) do 
		 table.insert(default_keys,k)
	 end
	 
	 table.sort(saved_keys)
	 table.sort(default_keys)
	 
	 for i,k in ipairs(default_keys) do
		 if saved_keys[i] ~= k then
			 -- saved settings are corrupt/out of date
			 print("Incompatible save data. Resetting to defaults.")
			 settings = default_settings
			 bitser.dumpLoveFile('savedata', settings)
			 break
		 end
	 end
	 
else
	settings = default_settings
	bitser.dumpLoveFile('savedata', settings)
end


-- bitser won't serialize functions, so these need to be global

function init_settings()
	allowed_options[1]:setTo(settings.volume)
	allowed_options[2]:setTo(settings.game_speed)
	allowed_options[3]:setTo(settings.start_stage)
	allowed_options[4]:setTo(settings.draw_crosshairs_always)
end

function save_settings()
	settings.volume = allowed_options[1]:getSetting()
	settings.game_speed = allowed_options[2]:getSetting()
	settings.start_stage = allowed_options[3]:getSetting() 
	settings.draw_crosshairs_always = allowed_options[4]:getSetting()
	bitser.dumpLoveFile('savedata', settings)
end

return settings
