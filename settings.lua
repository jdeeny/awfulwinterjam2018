local default_settings = {
  volume = 100,   -- max
  game_speed = 3,  -- normal
  start_stage = 1, -- first
  max_unlocked_dungeon = 1,  -- just the first ###not implemented
  draw_crosshairs_always = false,
  gfx_mode = 'windowed',
  window_width =  window.w,
  window_height = window.h,
  -- stage_upgrades : defaults to nil
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
	allowed_options[option_index['volume']]:setTo(settings.volume)
	allowed_options[option_index['speed']]:setTo(settings.game_speed)
	allowed_options[option_index['start']]:setTo(settings.start_stage)
	allowed_options[option_index['crosshairs']]:setTo(settings.draw_crosshairs_always)
	gamestage.upgrades = settings.stage_upgrades	
end

function save_settings()
	settings.volume = allowed_options[option_index['volume']]:getSetting()
	settings.game_speed = allowed_options[option_index['speed']]:getSetting()
	settings.start_stage = allowed_options[option_index['start']]:getSetting() 
	settings.draw_crosshairs_always = allowed_options[option_index['crosshairs']]:getSetting()
	-- disabled for playtesting
	settings.stage_upgrades = gamestage.upgrades
	bitser.dumpLoveFile('savedata', settings)
end

return settings
